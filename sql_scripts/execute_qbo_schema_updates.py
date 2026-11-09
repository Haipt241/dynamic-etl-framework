#!/usr/bin/env python3
"""
QuickBooks Online Schema Update Execution Script
================================================

This script provides a centralized way to execute all QBO schema updates:
1. Create production tables
2. Create stage tables 
3. Create stored procedures
4. Create views

Usage:
    python execute_qbo_schema_updates.py --client-id CLIENT123 --client-name CLIENTNAME [--org-id 12345] [--section all|prod|stage|sp|views]

Examples:
    # Update everything for BIGOLESHOECOMPANY
    python execute_qbo_schema_updates.py --client-id 2013 --client-name BIGOLESHOECOMPANY --org-id 7035
    
    # Update only production tables
    python execute_qbo_schema_updates.py --client-id 2013 --client-name BIGOLESHOECOMPANY --section prod
    
    # Update for specific organization
    python execute_qbo_schema_updates.py --client-id 2013 --client-name BIGOLESHOECOMPANY --org-id 7035 --section stage
    
    # Create all views
    python execute_qbo_schema_updates.py --client-id 2013 --client-name BIGOLESHOECOMPANY --section views
"""

import argparse
import sys
import os
from pathlib import Path
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
import logging
from datetime import datetime
import re

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,  # Changed to DEBUG for more detailed logging
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f'qbo_schema_update_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class QBOSchemaUpdater:
    def __init__(self, client_id, org_id=None, client_name=None):
        self.client_id = client_id
        self.org_id = org_id
        self.client_name = client_name or f"CLIENT{client_id}"  # Default to CLIENTxxxx if no name provided
        self.stage_engine = None      # Engine for evadb_stage (for tables)
        self.eva_engine = None        # Engine for evadb (for views)
        self.script_dir = Path(__file__).parent / "SQL Scripts"
        logger.debug(f"Script directory: {self.script_dir}")
        logger.debug(f"Script directory exists: {self.script_dir.exists()}")
        
    def connect_to_database(self):
        """Establish database connections using config.py settings"""
        try:
            # Import database configuration
            sys.path.append(str(Path(__file__).parent))
            import config
            
            logger.debug(f"Attempting to connect to databases with settings:")
            logger.debug(f"Host: {config.MYSQL_SERVER_NAME}")
            logger.debug(f"User: {config.MYSQL_SERVER_USERNAME}")
            
            # Engine for evadb_stage (for production and stage tables)
            logger.debug("Creating evadb_stage engine...")
            self.stage_engine = create_engine(
                f"mysql+pymysql://REDACTED:REDACTED@{config.MYSQL_SERVER_NAME}/evadb_stage",
                connect_args={
                    "ssl": {"ca": config.MYSQL_SERVER_SSL_CERT},
                    "autocommit": True,
                }
            )
            logger.info("Successfully created evadb_stage engine")
            
            # Engine for evadb (for views)
            logger.debug("Creating evadb engine...")
            self.eva_engine = create_engine(
                f"mysql+pymysql://REDACTED:REDACTED@{config.MYSQL_SERVER_NAME}/evadb",
                connect_args={
                    "ssl": {"ca": config.MYSQL_SERVER_SSL_CERT},
                    "autocommit": True,
                }
            )
            logger.info("Successfully connected to evadb database")
            
            return True
            
        except SQLAlchemyError as e:
            logger.error(f"Error connecting to database: {e}")
            return False
        except ImportError as e:
            logger.error(f"Could not import config.py: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error during database connection: {e}")
            return False

    def check_table_exists(self, table_name, engine=None):
        """Check if a table exists in the database"""
        try:
            eng = engine or self.stage_engine
            
            with eng.connect() as connection:
                # Check current database first
                result = connection.execute(text("SELECT DATABASE()"))
                current_db = result.fetchone()[0]
                logger.debug(f"Checking table {table_name} in database: {current_db}")
                
                result = connection.execute(text(f"SHOW TABLES LIKE '{table_name}'"))
                table_exists = result.fetchone() is not None
                logger.debug(f"Table {table_name} exists: {table_exists}")
                return table_exists
                
        except SQLAlchemyError as e:
            logger.error(f"Error checking if table {table_name} exists: {e}")
            return False
            
    def convert_varchar_to_text(self, sql_content):
        """Convert VARCHAR to TEXT for non-key columns to avoid row size issues"""
        # First, find all key specifications and their columns
        # This includes PRIMARY KEY, KEY, UNIQUE KEY, and INDEX
        key_pattern = r'(PRIMARY KEY|KEY|UNIQUE KEY|INDEX)\s+(?:\w+\s+)?\(([^)]+)\)'
        key_matches = re.finditer(key_pattern, sql_content, re.IGNORECASE)
        
        # Store columns that are used in keys
        key_columns = set()
        for match in key_matches:
            # Extract column names from key specification, removing backticks
            columns_str = match.group(2)
            # Handle composite keys by splitting on comma
            for col in columns_str.split(','):
                # Extract just the column name, handling expressions like LENGTH(column, 255)
                col_match = re.search(r'`?(\w+)`?', col.strip())
                if col_match:
                    key_columns.add(col_match.group(1))
        
        # Also preserve specific columns that should always be VARCHAR
        # These are commonly used in JOINs or WHERE clauses
        preserved_columns = {
            'Id', 'ClientID', 'OrganisationID', 'AccountType', 'AccountSubType',
            'Classification', 'Name', 'DisplayName', 'ParentRef_value',
            'CurrencyRef_value', 'CustomerRef_value', 'VendorRef_value',
            'ItemRef_value', 'ClassRef_value', 'DepartmentRef_value',
            'AccountRef_value', 'TaxCodeRef_value', 'PaymentMethodRef_value',
            'Status', 'Type', 'DetailType', 'LineId', 'Line_LinkedTxn_TxnLineId', 'LinkedTxn_TxnLineId'
        }
        key_columns.update(preserved_columns)
            
        # Find all column definitions with VARCHAR
        # This pattern matches column names (with or without backticks) followed by VARCHAR
        column_pattern = r'`?(\w+)`?\s+VARCHAR\(\d+\)'
        
        def replace_varchar(match):
            column_name = match.group(1)
            if column_name not in key_columns:
                return f'`{column_name}` TEXT'
            else:
                return match.group(0)
        
        # Replace all VARCHAR definitions with TEXT for non-key columns
        sql_content = re.sub(column_pattern, replace_varchar, sql_content)
        
        return sql_content
            
    def execute_sql_file(self, file_path, replacements=None, engine=None):
        """Execute SQL file with optional text replacements"""
        try:
            if not file_path.exists():
                logger.error(f"SQL file not found: {file_path}")
                return False
                
            logger.debug(f"Reading SQL file: {file_path}")
            with open(file_path, 'r', encoding='utf-8') as file:
                sql_content = file.read()
                
            # Apply replacements
            if replacements:
                logger.debug(f"Applying replacements: {replacements}")
                for placeholder, value in replacements.items():
                    sql_content = sql_content.replace(placeholder, str(value))
                    
            # Convert VARCHAR to TEXT for large tables
            if 'CREATE TABLE' in sql_content:
                sql_content = self.convert_varchar_to_text(sql_content)
            
            # Use the provided engine or default to stage_engine
            eng = engine or self.stage_engine
            
            with eng.connect() as connection:
                # Handle stored procedures differently than regular SQL
                if 'CREATE PROCEDURE' in sql_content:
                    logger.debug("Detected stored procedures, using special parsing")
                    
                    # First, remove DELIMITER statements as they're MySQL client-specific
                    lines = []
                    for line in sql_content.split('\n'):
                        if not line.strip().startswith('DELIMITER'):
                            lines.append(line)
                    
                    cleaned_content = '\n'.join(lines)
                    
                    # Split on procedure boundaries
                    procedures = []
                    current_proc = []
                    in_procedure = False
                    
                    for line in cleaned_content.split('\n'):
                        line = line.strip()
                        if not line or line.startswith('--'):
                            continue
                            
                        if line.startswith('DROP PROCEDURE'):
                            if current_proc and in_procedure:
                                procedures.append('\n'.join(current_proc))
                                current_proc = []
                                in_procedure = False
                            # DROP PROCEDURE is a standalone statement
                            procedures.append(line)
                        elif line.startswith('CREATE PROCEDURE'):
                            if current_proc:
                                procedures.append('\n'.join(current_proc))
                                current_proc = []
                            current_proc.append(line)
                            in_procedure = True
                        elif (line == 'END//' or line == 'END;') and in_procedure:
                            # Normalize END statement to use semicolon
                            current_proc.append('END;')
                            procedures.append('\n'.join(current_proc))
                            current_proc = []
                            in_procedure = False
                        elif in_procedure:
                            # Replace // with ; for procedure body
                            if line.endswith('//'):
                                line = line[:-2] + ';'
                            current_proc.append(line)
                    
                    if current_proc:
                        procedures.append('\n'.join(current_proc))
                    
                    logger.debug(f"Found {len(procedures)} stored procedures to execute")
                    
                    for i, procedure in enumerate(procedures, 1):
                        if procedure.strip():
                            try:
                                logger.debug(f"Executing procedure {i}/{len(procedures)}")
                                connection.execute(text(procedure))
                                logger.debug(f"Successfully executed procedure {i}")
                            except SQLAlchemyError as e:
                                logger.error(f"Error executing procedure {i}: {e}")
                                logger.error(f"Full failed procedure: {procedure}")
                                return False
                else:
                    # Split into individual statements for regular SQL
                    statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
                    logger.debug(f"Found {len(statements)} SQL statements to execute")
                    
                    for i, statement in enumerate(statements, 1):
                        if statement.strip():
                            # Remove leading comments from statements
                            lines = statement.strip().split('\n')
                            # Filter out comment lines but keep the actual SQL
                            sql_lines = []
                            for line in lines:
                                if not line.strip().startswith('--'):
                                    sql_lines.append(line)
                            
                            clean_statement = '\n'.join(sql_lines).strip()
                            
                            # Skip if the entire statement is empty after removing comments
                            if not clean_statement:
                                logger.debug(f"Skipping empty statement {i}")
                                continue
                                
                            try:
                                logger.debug(f"Executing statement {i}/{len(statements)}")
                                connection.execute(text(clean_statement))
                                logger.debug(f"Successfully executed statement {i}")
                            except SQLAlchemyError as e:
                                logger.error(f"Error executing statement {i}: {e}")
                                logger.error(f"Full failed statement: {clean_statement}")
                                return False
                        
            logger.info(f"Successfully executed SQL file: {file_path.name}")
            return True
            
        except Exception as e:
            logger.error(f"Error executing SQL file {file_path}: {e}")
            return False
            
    def _execute_stored_procedures(self, cursor, sql_content):
        """Execute stored procedures that use DELIMITER statements"""
        # Remove DELIMITER commands and split by the delimiter
        sql_content = sql_content.replace('DELIMITER //', '')
        sql_content = sql_content.replace('DELIMITER ;', '')
        
        # Split by // to get individual procedures
        procedures = [proc.strip() for proc in sql_content.split('//') if proc.strip()]
        
        logger.debug(f"Found {len(procedures)} stored procedures to create")
        
        for i, procedure in enumerate(procedures, 1):
            if procedure.strip():
                try:
                    # Execute each procedure as a single statement
                    logger.debug(f"Creating stored procedure {i}/{len(procedures)}")
                    cursor.execute(procedure)
                    logger.debug(f"Successfully created stored procedure {i}")
                except Error as e:
                    logger.error(f"Error creating stored procedure {i}: {e}")
                    logger.debug(f"Failed procedure: {procedure[:200]}...")
                    raise e
            
    def create_production_tables(self):
        """Create QBO production tables"""
        logger.info("Creating production tables...")
        
        file_path = self.script_dir / "QBO-PROD-TABLES.sql"
        logger.debug(f"Production tables file path: {file_path}")
        replacements = {
            "{clientID}": self.client_id  # Use numeric client_id for table names
        }
        
        return self.execute_sql_file(file_path, replacements)
        
    def create_stage_tables(self):
        """Create QBO stage tables"""
        if not self.org_id:
            logger.error("Organization ID required for stage table creation")
            return False
            
        logger.info("Creating stage tables...")
        
        file_path = self.script_dir / "QBO-STAGE-TABLES.sql"
        logger.debug(f"Stage tables file path: {file_path}")
        replacements = {
            "{clientID}": self.client_id,
            "{clientName}": self.client_name,
            "{orgID}": self.org_id
        }
        
        return self.execute_sql_file(file_path, replacements)
        
    def create_stored_procedures(self):
        """Create QBO stored procedures"""
        logger.info("Creating stored procedures...")
        
        file_path = self.script_dir / "QBO-STORED-PROCEDURES.sql"
        logger.debug(f"Stored procedures file path: {file_path}")
        
        return self.execute_sql_file(file_path)
        
    def create_views(self):
        """Create QBO views in evadb database"""
        logger.info("Creating views in evadb database...")
        
        # Skip table existence check for now - we know the table exists
        logger.info("Proceeding with view creation...")
        
        file_path = self.script_dir / "QBO-VIEWS.sql"
        logger.debug(f"Views file path: {file_path}")
        
        # Read the file content first
        with open(file_path, 'r', encoding='utf-8') as file:
            sql_content = file.read()
        
        # Replace placeholders correctly:
        # View names should be: {client_name}_CLIENT{client_id}_qbo_*
        # Table references should be: evadb_stage.c{client_id}_qbo_*
        view_prefix = f'{self.client_name}_CLIENT{self.client_id}'
        
        # IMPORTANT: Replace table references FIRST before view names
        # This prevents the view name replacement from affecting table references
        
        # Replace table references (pattern: FROM c{clientID}_)
        sql_content = sql_content.replace('FROM c{clientID}_', f'FROM evadb_stage.c{self.client_id}_')
        
        # Also handle JOIN clauses
        sql_content = sql_content.replace('JOIN c{clientID}_', f'JOIN evadb_stage.c{self.client_id}_')
        sql_content = sql_content.replace('LEFT JOIN c{clientID}_', f'LEFT JOIN evadb_stage.c{self.client_id}_')
        sql_content = sql_content.replace('RIGHT JOIN c{clientID}_', f'RIGHT JOIN evadb_stage.c{self.client_id}_')
        sql_content = sql_content.replace('INNER JOIN c{clientID}_', f'INNER JOIN evadb_stage.c{self.client_id}_')
        
        # Now replace view names (pattern: {clientID}_qbo_)
        sql_content = sql_content.replace('{clientID}_qbo_', f'{view_prefix}_qbo_')
        
        # Replace DROP VIEW statements
        sql_content = sql_content.replace('DROP VIEW IF EXISTS {clientID}_', f'DROP VIEW IF EXISTS {view_prefix}_')
        
        logger.debug(f"Generated view name pattern: {view_prefix}_qbo_*")
        logger.debug(f"Table reference pattern: evadb_stage.c{self.client_id}_qbo_*")
        
        # Write to a temporary file
        import tempfile
        with tempfile.NamedTemporaryFile(mode='w', suffix='.sql', delete=False) as temp_file:
            temp_file.write(sql_content)
            temp_file_path = temp_file.name
        
        try:
            return self.execute_sql_file(Path(temp_file_path), engine=self.eva_engine)
        finally:
            # Clean up temp file
            import os
            os.unlink(temp_file_path)
        
    def update_all(self):
        """Execute all updates"""
        logger.info(f"Starting complete schema update for client: {self.client_id}")
        
        success_count = 0
        total_operations = 4
        
        # Production tables
        if self.create_production_tables():
            success_count += 1
            logger.info("Production tables created successfully")
        else:
            logger.error("Failed to create production tables")
            return False
            
        # Stage tables (only if org_id provided)
        if self.org_id:
            if self.create_stage_tables():
                success_count += 1
                logger.info("Stage tables created successfully")
            else:
                logger.error("Failed to create stage tables")
                return False
        else:
            logger.info("Skipping stage tables - no organization ID provided")
            total_operations -= 1
            
        # Stored procedures
        if self.create_stored_procedures():
            success_count += 1
            logger.info("Stored procedures created successfully")
        else:
            logger.error("Failed to create stored procedures")
            return False
            
        # Views
        if self.create_views():
            success_count += 1
            logger.info("Views created successfully")
        else:
            logger.error("Failed to create views")
            return False
            
        logger.info(f"Schema update completed: {success_count}/{total_operations} operations successful")
        return success_count == total_operations
        
    def close_connection(self):
        """Close database engines"""
        if self.stage_engine:
            self.stage_engine.dispose()
            logger.info("evadb_stage database engine disposed")
        if self.eva_engine:
            self.eva_engine.dispose()
            logger.info("evadb database engine disposed")

def main():
    parser = argparse.ArgumentParser(description='QBO Schema Update Tool')
    parser.add_argument('--client-id', required=True, help='Client ID (e.g., 2013)')
    parser.add_argument('--client-name', required=True, help='Client name (e.g., BIGOLESHOECOMPANY)')
    parser.add_argument('--org-id', type=int, help='Organization ID (e.g., 7035)')
    parser.add_argument('--section', default='all', choices=['all', 'prod', 'stage', 'sp', 'views'], 
                        help='Section to update')
    
    args = parser.parse_args()
    
    client_id = args.client_id
    client_name = args.client_name
    org_id = args.org_id
    section = args.section
    
    logger.info(f"Running QBO Schema Updates for {client_name}")
    logger.info(f"Client ID: {client_id}, Client Name: {client_name}, Org ID: {org_id}, Section: {section}")
    
    # Initialize updater
    updater = QBOSchemaUpdater(client_id, org_id, client_name)
    
    # Connect to database
    if not updater.connect_to_database():
        logger.error("Failed to connect to database")
        sys.exit(1)
        
    try:
        # Execute requested operations
        if section == 'all':
            logger.info("Creating ALL schema objects (tables, stored procedures, views)...")
            success = updater.update_all()
        elif section == 'prod':
            logger.info("Creating production tables...")
            success = updater.create_production_tables()
        elif section == 'stage':
            logger.info("Creating stage tables...")
            success = updater.create_stage_tables()
        elif section == 'sp':
            logger.info("Creating stored procedures...")
            success = updater.create_stored_procedures()
        elif section == 'views':
            logger.info("Creating views...")
            success = updater.create_views()
            
        if not success:
            logger.error("Schema update failed")
            sys.exit(1)
            
    finally:
        updater.close_connection()
        
    logger.info("Schema update completed successfully")

if __name__ == "__main__":
    main()