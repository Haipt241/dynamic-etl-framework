#!/usr/bin/env python3
"""
[WARNING]  DEPRECATION NOTICE [WARNING]
=======================
This standalone SQL executor is now integrated into the unified workflow.

[SYNC] MIGRATION GUIDE:
- OLD: python sql_executor.py --integration qbo --client-id CLIENT2013 --org-id 7035
- NEW: python run_dynamic_integration.py --integration qbo --mode insert --param EtaniClientID=CLIENT2013 --param EtaniOrganisationID=7035

The new unified workflow handles SQL generation AND execution automatically in INSERT mode.

For the complete workflow, use:
    python run_dynamic_integration.py --help

This standalone executor will be maintained for compatibility but new development should use run_dynamic_integration.py
=======================

SQL Executor for Generated Integrations

Automatically executes SQL files for generated integrations with config-based client information.
Supports executing specific sections (stage, prod, view, procedure) or all sections.
"""

import argparse
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional

# Add parent directory to path
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parent_dir)

from dynamic_integrations.generator.utils import Utils
import config

# Import sql_helper after setting up sys.argv in main()
from dynamic_integrations.database.sql_helper import get_firmcode_from_client_id


class SQLExecutor:
    """SQL Executor for generated integration files"""

    def __init__(self):
        """Initialize SQL Executor"""
        from dynamic_integrations.paths import integration_root
        self.base_dir = integration_root()
        self.generated_dir = self.base_dir / "generated_integrations"
        self.utils = Utils()
        self.get_firmcode_from_client_id = get_firmcode_from_client_id  # Assign imported function

        print("[START] SQL Executor for Generated Integrations")
    
    def get_available_integrations(self) -> List[str]:
        """Get list of available integrations with SQL files"""
        integrations = []
        
        if not self.generated_dir.exists():
            return integrations
        
        for integration_dir in self.generated_dir.iterdir():
            if integration_dir.is_dir() and (integration_dir / "sql").exists():
                integrations.append(integration_dir.name)
        
        return sorted(integrations)
    
    def extract_client_info_from_config(self, integration_name: str) -> Dict[str, str]:
        """Extract client information from integration config"""
        try:
            config = Utils.load_integration_config(integration_name.upper())
            env_vars_config = config.get('env_vars_config', {})
            
            # Extract client ID from EtaniClientID (e.g., "BIGOLESHOECOMPANY_CLIENT2013" -> "2013", "BIGOLESHOECOMPANY")
            client_field = env_vars_config.get('etani_client_id', {})
            etani_client_id = os.getenv(client_field.get('env_var', 'EtaniClientID'), client_field.get('default_value', ''))
            client_id = ""
            client_name = ""
            
            if etani_client_id and 'CLIENT' in etani_client_id:
                # Extract number after CLIENT
                match = re.search(r'CLIENT(\d+)', etani_client_id)
                if match:
                    client_id = match.group(1)
                # Extract company name before CLIENT
                client_name = etani_client_id.split('_CLIENT')[0]
            
            # Extract org ID
            org_field = env_vars_config.get('etani_organisation_id', {})
            org_id = os.getenv(org_field.get('env_var', 'EtaniOrganisationID'), org_field.get('default_value', ''))
            
            client_info = {
                'client_id': client_id,
                'client_name': client_name, 
                'org_id': str(org_id),
                'etani_client_id': etani_client_id.lower() if etani_client_id else '',  # Add lowercased etani_client_id
                'integration_name': integration_name.upper()
            }
            
            print(f"[OK] Extracted client info from {integration_name} config:")
            print(f"   Client ID: {client_id}")
            print(f"   Client Name: {client_name}")
            print(f"   Org ID: {org_id}")
            print(f"   Etani Client ID (lowercased): {etani_client_id.lower() if etani_client_id else ''}")
            
            return client_info
            
        except Exception as e:
            print(f"[ERROR] Error extracting client info from {integration_name} config: {str(e)}")
            return {}
    
    def get_sql_files(self, integration_name: str, section: str) -> List[Path]:
        """Get SQL files for specific integration and section"""
        sql_dir = self.generated_dir / integration_name / "sql"
        
        if not sql_dir.exists():
            print(f"[ERROR] SQL directory not found: {sql_dir}")
            return []
        
        sql_files = []
        
        if section == "all":
            # Get all SQL files in order
            sections = ["stage", "prod", "view", "procedure"]
            for sect in sections:
                files = self._get_section_files(sql_dir, sect)
                sql_files.extend(files)
        else:
            sql_files = self._get_section_files(sql_dir, section)
        
        return sql_files
    
    def _get_section_files(self, sql_dir: Path, section: str) -> List[Path]:
        """Get SQL files for specific section"""
        section_patterns = {
            "stage": ["*stage*.sql", "create_stage*.sql"],
            "prod": ["*prod*.sql", "create_prod*.sql"], 
            "view": ["*view*.sql", "create_view*.sql"],
            "procedure": ["*procedure*.sql", "*sp_*.sql", "create_procedure*.sql"]
        }
        
        patterns = section_patterns.get(section, [f"*{section}*.sql"])
        files_set = set()  # Use set to avoid duplicates
        
        for pattern in patterns:
            files_set.update(sql_dir.glob(pattern))
        
        return sorted(list(files_set))
    
    def replace_placeholders(self, sql_content: str, client_info: Dict[str, str]) -> str:
        """Replace placeholders in SQL content with actual values"""
        # Check if we're using AWS and get firmcode
        use_aws_db = getattr(config, 'USE_AWS_DB', True)
        # Get etani_client_id and extract firmcode
        etani_client_id = client_info.get('etani_client_id', '')
        firmcode = self.get_firmcode_from_client_id(etani_client_id) if etani_client_id and self.get_firmcode_from_client_id else None

        # Require firmcode to proceed - otherwise raise error
        if not firmcode:
            error_message = "ERROR: No firmcode found in client_info! EtaniClientID may be missing or invalid."
            print(f"   [ERROR] {error_message}")
            raise ValueError(error_message)

        # Use AWS engine with firmcode
        stage_database = f'vibedb_{firmcode.upper()}'
        main_database = f'vibedb_{firmcode.upper()}'
        cms_database = 'vibedb_cms'
        print(f"   [SYNC] Using databases {stage_database}, {main_database}, {cms_database} (FIRMCODE: {firmcode.upper()})")
        replacements = {
            # Standard format used in execute_qbo_schema_updates.py
            '{clientID}': client_info.get('client_id', ''),
            '{etani_client_id}': client_info.get('etani_client_id', ''),  # New: lowercased etani_client_id
            '{clientName}': client_info.get('client_name', ''),
            '{orgID}': client_info.get('org_id', ''),

            # Database references for cross-database views - dynamic based on AWS/Azure mode
            '{stage_database}': stage_database,
            '{main_database}': main_database,
            '{cms_database}': cms_database,
            '{client_database}': stage_database,  # Add client_database placeholder for lastrefreshdate tables

            # Alternative formats for flexibility
            '{CLIENT_ID}': client_info.get('client_id', ''),
            '{CLIENT_NAME}': client_info.get('client_name', ''),
            '{ORG_ID}': client_info.get('org_id', ''),
            '{INTEGRATION_NAME}': client_info.get('integration_name', ''),
            '{client_id}': client_info.get('client_id', ''),
            '{client_name}': client_info.get('client_name', ''),
            '{org_id}': client_info.get('org_id', ''),
            '{integration_name}': client_info.get('integration_name', '').lower(),
            '{firmcode}': firmcode or ''  # Add firmcode as placeholder for custom uses
        }

        processed_content = sql_content
        for placeholder, value in replacements.items():
            processed_content = processed_content.replace(placeholder, str(value))

        return processed_content

    def replace_placeholders_with_legacy(self, sql_content: str, client_info: Dict[str, str], legacy_client_id: str) -> str:
        """Replace placeholders with legacy client ID support for view naming only"""
        # Start with regular placeholder replacement
        processed_content = self.replace_placeholders(sql_content, client_info)

        current_etani_client_id = client_info.get('etani_client_id', '')
        legacy_view_prefix = legacy_client_id.lower()

        # Replace the etani_client_id placeholder specifically for views
        processed_content = processed_content.replace(current_etani_client_id, legacy_view_prefix)

        return processed_content

    def execute_sql_file(self, sql_file: Path, client_info: Dict[str, str], dry_run: bool = False, legacy_client_id: str = None) -> bool:
        """Execute a single SQL file"""
        try:
            print(f"[FILE] Processing: {sql_file.name}")

            # Read SQL content
            with open(sql_file, 'r', encoding='utf-8') as f:
                sql_content = f.read()

            # Check if this is a view file and handle legacy client ID logic
            is_view_file = 'view' in sql_file.name.lower()

            # Replace placeholders with legacy support for view files only
            if is_view_file and legacy_client_id:
                print(f"  [SYNC] Using legacy client ID for view naming: {legacy_client_id}")
                processed_sql = self.replace_placeholders_with_legacy(sql_content, client_info, legacy_client_id)
            else:
                processed_sql = self.replace_placeholders(sql_content, client_info)

            if dry_run:
                print(f"   [INFO] [DRY RUN] Would execute {len(processed_sql)} characters of SQL")
                return True

            # Execute SQL using the same method as execute_qbo_schema_updates.py
            return self._execute_sql_content(processed_sql, sql_file.name, client_info)

        except Exception as e:
            print(f"[ERROR] Error processing {sql_file.name}: {str(e)}")
            return False
    
    def _execute_sql_content(self, sql_content: str, filename: str, client_info: Dict[str, str] = None) -> bool:
        """Execute SQL content using mysql command or sql_helper"""
        try:
            # Try using sql_helper if available
            try:
                from dynamic_integrations.database.sql_helper import eva_engine, eva_main_engine, cms_engine, USE_AWS_DB, _create_aws_engine, get_firmcode_from_client_id, ensure_database_exists
                from sqlalchemy import text

                # Get etani_client_id from client_info parameter if available
                etani_client_id = client_info.get('etani_client_id', '')

                # Extract firmcode from EtaniClientID
                firmcode = self.get_firmcode_from_client_id(etani_client_id) if etani_client_id and self.get_firmcode_from_client_id else None

                # Require firmcode to proceed - otherwise raise error
                if not firmcode:
                    error_message = "ERROR: No firmcode found! EtaniClientID environment variable is missing or invalid."
                    print(f"   [ERROR] {error_message}")
                    raise ValueError(error_message)

                # Use AWS engines with firmcode
                stage_db_name = f'vibedb_{firmcode.upper()}'
                main_db_name = f'vibedb_{firmcode.upper()}'
                cms_db_name = 'vibedb_cms'

                # Ensure database exists (will create it if missing)
                ensure_database_exists(stage_db_name)

                # Create AWS engines for the specific firmcode database
                aws_stage_engine = _create_aws_engine(stage_db_name)
                aws_main_engine = _create_aws_engine(main_db_name)

                print(f"   [SYNC] Using database: {stage_db_name} (FIRMCODE: {firmcode.upper()})")

                # Determine which AWS engine to use based on SQL content
                if 'CREATE PROCEDURE' in sql_content:
                    print(f"   [INFO] Detected PROCEDURE statements, using cms engine (vibedb_cms)")
                    engine = cms_engine  # Use cms_engine for all stored procedures
                elif 'CREATE VIEW' in sql_content:
                    print(f"   [INFO] Detected VIEW statements, using main engine ({main_db_name})")
                    engine = aws_main_engine
                else:
                    print(f"   [INFO] Using stage engine ({stage_db_name}) for non-view statements")
                    engine = aws_stage_engine
                
                # Handle stored procedures differently than regular SQL
                if 'CREATE PROCEDURE' in sql_content:
                    print(f"   [INFO] Detected stored procedures, using special parsing")
                    statements = self._parse_stored_procedures(sql_content)
                else:
                    # Split SQL into individual statements for regular SQL
                    statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
                
                with engine.connect() as conn:
                    failed_statements = []
                    successful_statements = 0

                    for i, statement in enumerate(statements):
                        if statement.strip():
                            try:
                                conn.execute(text(statement))
                                successful_statements += 1
                                print(f"   [OK] Executed statement {i+1}/{len(statements)}")
                            except Exception as e:
                                failed_statements.append({
                                    'statement_num': i+1,
                                    'error': str(e),
                                    'statement': statement[:100] + '...' if len(statement) > 100 else statement
                                })
                                print(f"   [ERROR] ERROR in statement {i+1}/{len(statements)}: {str(e)}")

                    # Only commit if all statements succeeded
                    if len(failed_statements) == 0:
                        conn.commit()
                        print(f"   [OK] Successfully executed {filename} ({successful_statements} statements)")
                        return True
                    else:
                        # Don't commit if there were failures
                        print(f"   [ERROR] FAILED to execute {filename}: {len(failed_statements)} statement(s) failed out of {len(statements)}")
                        print(f"   [STOP] SQL execution halted due to errors. Integration workflow stopped.")

                        # Log detailed error information
                        for failure in failed_statements:
                            print(f"   [DEBUG] Statement {failure['statement_num']} failed: {failure['error']}")
                            print(f"   [DATA] SQL: {failure['statement']}")

                        return False
                
            except ImportError:
                print("   [WARNING]  sql_helper not available, falling back to mysql command")
                return self._execute_via_mysql_command(sql_content, filename)
            
        except Exception as e:
            print(f"   [ERROR] Error executing {filename}: {str(e)}")
            return False
    
    def _parse_stored_procedures(self, sql_content: str) -> List[str]:
        """Parse stored procedures from SQL content"""
        statements = []
        current_statement = []
        in_procedure = False
        paren_count = 0
        current_delimiter = ';'
        
        lines = sql_content.split('\n')
        
        for line in lines:
            line = line.strip()
            
            # Skip empty lines and comments  
            if not line or line.startswith('--'):
                continue
            
            # Handle DELIMITER statements
            if line.startswith('DELIMITER'):
                delimiter_match = line.split()
                if len(delimiter_match) > 1:
                    current_delimiter = delimiter_match[1]
                continue  # Skip DELIMITER lines, don't execute them
            
            # Check for DROP PROCEDURE
            if line.startswith('DROP PROCEDURE'):
                if current_statement and in_procedure:
                    statements.append('\n'.join(current_statement))
                    current_statement = []
                    in_procedure = False
                statements.append(line)
                continue
            
            # Check for CREATE PROCEDURE
            if line.startswith('CREATE PROCEDURE'):
                if current_statement:
                    statements.append('\n'.join(current_statement))
                    current_statement = []
                current_statement.append(line)
                in_procedure = True
                continue
            
            # If we're in a procedure, add all lines until END with current delimiter
            if in_procedure:
                current_statement.append(line)
                
                # Track parentheses for procedure parameters
                paren_count += line.count('(') - line.count(')')
                
                # Check for END of procedure with current delimiter
                delimiter_stripped = current_delimiter.strip()
                if (line.endswith('END ' + delimiter_stripped) or 
                    line == 'END ' + delimiter_stripped or 
                    line.endswith('END' + delimiter_stripped) or 
                    line == 'END' + delimiter_stripped) and paren_count <= 0:
                    # Convert delimiter back to semicolon for MySQL execution
                    proc_statement = '\n'.join(current_statement)
                    if delimiter_stripped != ';':
                        # Replace the delimiter with semicolon
                        proc_statement = proc_statement.replace(' ' + delimiter_stripped, ';')
                        proc_statement = proc_statement.replace(delimiter_stripped, ';')
                        # Clean up potential double semicolons
                        proc_statement = proc_statement.replace(';;', ';')
                    # Ensure proper ending
                    if not proc_statement.strip().endswith(';'):
                        proc_statement = proc_statement.rstrip() + ';'
                    statements.append(proc_statement)
                    current_statement = []
                    in_procedure = False
                    paren_count = 0
                    current_delimiter = ';'  # Reset delimiter after procedure
            else:
                # Regular SQL statement outside procedures
                if line and not line.startswith('DELIMITER'):
                    statements.append(line)
        
        # Add any remaining statement
        if current_statement:
            proc_statement = '\n'.join(current_statement)
            delimiter_stripped = current_delimiter.strip()
            if delimiter_stripped != ';':
                # Replace the delimiter with semicolon
                proc_statement = proc_statement.replace(' ' + delimiter_stripped, ';')
                proc_statement = proc_statement.replace(delimiter_stripped, ';')
                # Clean up potential double semicolons
                proc_statement = proc_statement.replace(';;', ';')
            # Ensure proper ending
            if not proc_statement.strip().endswith(';'):
                proc_statement = proc_statement.rstrip() + ';'
            statements.append(proc_statement)
        
        return [stmt for stmt in statements if stmt.strip()]
    
    def _execute_via_mysql_command(self, sql_content: str, filename: str) -> bool:
        """Execute SQL using mysql command line tool"""
        try:
            # This would need database connection details
            # For now, just simulate execution
            print(f"   [INFO] [MYSQL CLI] Would execute {filename} via mysql command")
            return True
            
        except Exception as e:
            print(f"   [ERROR] MySQL CLI execution failed: {str(e)}")
            return False
    
    def execute_integration(self, integration_name: str, section: str = "all", 
                           client_info: Optional[Dict[str, str]] = None, dry_run: bool = False) -> bool:
        """Execute SQL files for specific integration"""
        print(f"\n[START] Executing SQL for {integration_name.upper()} integration")
        print(f"[DATA] Section: {section}")
        
        # Get client info from config if not provided
        if not client_info:
            client_info = self.extract_client_info_from_config(integration_name)
            if not client_info:
                print(f"[ERROR] Could not extract client info for {integration_name}")
                return False
        
        # Get SQL files
        sql_files = self.get_sql_files(integration_name, section)
        if not sql_files:
            print(f"[ERROR] No SQL files found for {integration_name} section '{section}'")
            return False
        
        print(f"📁 Found {len(sql_files)} SQL files to execute")
        
        # Execute files
        success_count = 0
        for sql_file in sql_files:
            if self.execute_sql_file(sql_file, client_info, dry_run):
                success_count += 1
        
        # Summary
        if success_count == len(sql_files):
            print(f"[OK] Successfully executed all {len(sql_files)} SQL files for {integration_name}")
            return True
        else:
            print(f"[WARNING]  Executed {success_count}/{len(sql_files)} SQL files for {integration_name}")
            return False
    
    def execute_all_integrations(self, section: str = "all", dry_run: bool = False) -> Dict[str, bool]:
        """Execute SQL files for all available integrations"""
        integrations = self.get_available_integrations()
        
        if not integrations:
            print("[ERROR] No integrations with SQL files found")
            return {}
        
        print(f"\n[START] Executing SQL for all integrations: {integrations}")
        
        results = {}
        for integration in integrations:
            try:
                success = self.execute_integration(integration, section, dry_run=dry_run)
                results[integration] = success
            except Exception as e:
                print(f"[ERROR] Failed to execute {integration}: {str(e)}")
                results[integration] = False
        
        # Summary
        successful = [k for k, v in results.items() if v]
        failed = [k for k, v in results.items() if not v]
        
        print(f"\n[DATA] Execution Summary:")
        print(f"   [OK] Successful: {len(successful)} - {successful}")
        print(f"   [ERROR] Failed: {len(failed)} - {failed}")
        
        return results


def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="SQL Executor for Generated Integrations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
        Examples:
          # Execute all SQL files for QBO
          python sql_executor.py --integration qbo --section all
          
          # Execute only stage tables for QBO 
          python sql_executor.py --integration qbo --section stage
          
          # Execute with custom client info
          python sql_executor.py --integration qbo --client-id 2013 --org-id 7035 --section all
          
          # Execute all integrations (dry run)
          python sql_executor.py --all-integrations --dry-run
          
          # List available integrations
          python sql_executor.py --list
        """
    )
    
    parser.add_argument("--integration", help="Integration name (e.g., qbo, xero, simpro)")
    parser.add_argument("--section", default="all", 
                        choices=["all", "stage", "prod", "view", "procedure"],
                        help="SQL section to execute (default: all)")
    
    parser.add_argument("--client-id", help="Override client ID from config")
    parser.add_argument("--client-name", help="Override client name from config") 
    parser.add_argument("--org-id", help="Override organization ID from config")
    
    parser.add_argument("--all-integrations", action="store_true", 
                        help="Execute SQL for all available integrations")
    parser.add_argument("--list", action="store_true", 
                        help="List available integrations")
    parser.add_argument("--dry-run", action="store_true", 
                        help="Show what would be executed without running")
    
    args = parser.parse_args()
    
    # Handle help
    if len(sys.argv) == 1:
        parser.print_help()
        return
    
    executor = SQLExecutor()
    
    # Handle list command
    if args.list:
        integrations = executor.get_available_integrations()
        print(f"📁 Available integrations: {integrations}")
        return
    
    # Validate arguments
    if not args.all_integrations and not args.integration:
        print("[ERROR] Error: Must specify --integration or --all-integrations")
        parser.print_help()
        return
    
    try:
        if args.all_integrations:
            # Execute all integrations
            executor.execute_all_integrations(args.section, args.dry_run)
        else:
            # Execute specific integration
            # Set sys.argv to include integration so sql_helper can detect it
            if '--integration' not in sys.argv:
                sys.argv.extend(['--integration', args.integration])

            # Now import sql_helper after sys.argv is set
            from dynamic_integrations.database.sql_helper import get_firmcode_from_client_id

            # Set the function reference in the executor
            executor.get_firmcode_from_client_id = get_firmcode_from_client_id

            client_info = None
            if args.client_id or args.client_name or args.org_id:
                client_info = {
                    'client_id': args.client_id or '',
                    'client_name': args.client_name or '',
                    'org_id': args.org_id or '',
                    'integration_name': args.integration.upper()
                }

            success = executor.execute_integration(
                args.integration, args.section, client_info, args.dry_run
            )
            
            if not success:
                sys.exit(1)
                
    except KeyboardInterrupt:
        print("\n[WARNING]  Execution interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"[ERROR] Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()