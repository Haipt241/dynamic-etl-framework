#!/usr/bin/env python3
"""
Unified SQL Generator - Single file for all SQL generation needs

Consolidates sql_object_generator.py, sql_generator.py, llm_validator.py, prompt_builder.py
into one streamlined generator using template-first approach with LLM verification.

Based on QBO SQL patterns extracted from existing templates.
"""

import json
import re
import time
from pathlib import Path
from typing import Dict, List, Any, Optional

# MySQL Reserved Keywords - separated by context
SQL_COMMANDS = {
    'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'ALTER',
    'FROM', 'WHERE', 'INTO', 'BY', 'ORDER', 'GROUP'
}

# Column keywords that need escaping when used as column names
COLUMN_KEYWORDS = {
    'PRIMARY', 'SECONDARY', 'INDEX', 'KEY', 'TABLE', 'COLUMN',
    'CONSTRAINT', 'FOREIGN', 'REFERENCES'
}

# SQL Reserved Keywords - Comprehensive list for MySQL
RESERVED_KEYWORDS = {
    # SQL Commands
    'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'DROP', 'ALTER',
    'FROM', 'WHERE', 'INTO', 'BY', 'ORDER', 'GROUP', 'HAVING', 'UNION',
    'JOIN', 'LEFT', 'RIGHT', 'INNER', 'OUTER', 'ON', 'AS', 'DISTINCT',
    'LIMIT', 'OFFSET', 'LIKE', 'IN', 'EXISTS', 'BETWEEN', 'IS', 'NULL',
    'AND', 'OR', 'NOT', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END', 'VALUES',
    
    # Column/Table Keywords  
    'PRIMARY', 'SECONDARY', 'INDEX', 'KEY', 'TABLE', 'COLUMN', 
    'CONSTRAINT', 'FOREIGN', 'REFERENCES', 'UNIQUE', 'AUTO_INCREMENT',
    'DEFAULT', 'CHECK', 'CASCADE', 'RESTRICT', 'SET', 'SHOW', 'USE',
    
    # MySQL Specific
    'DESCRIBE', 'EXPLAIN', 'FLUSH', 'GRANT', 'REVOKE', 'LOCK', 'UNLOCK',
    'TRUNCATE', 'REPLACE', 'LOAD', 'DATA', 'INFILE', 'OUTFILE', 'VIRTUAL','LINES',
    'LEAD', 'SYSTEM'
}


class UnifiedSQLGenerator:
    """
    Single unified SQL generator using template-first approach with LLM verification.
    
    Based on QBO patterns:
    - STAGE: c{clientID}_{orgID}_{integration}_{entity}stage  
    - PROD:  c{clientID}_{integration}_{entity}
    - VIEW:  {etani_client_id}_{integration}_{entity}
    - PROCEDURES: Stored procedures for data processing
    """
    
    def __init__(self, integration_name: str, use_llm_verification: bool = True, chunk_size: int = 10):
        self.integration_name = integration_name.lower()
        self.use_llm_verification = use_llm_verification
        self.chunk_size = chunk_size
        
        print(f"🔥 UnifiedSQLGenerator for {integration_name}")
        print(f"🤖 LLM verification: {'enabled' if use_llm_verification else 'disabled'}")
        print(f"📦 Chunk size: {chunk_size}")
    
    def render_imported_template(self, template: str, schema: Dict, generated_sql: str) -> str:
        """Render an optional user SQL template using the same entity conversion."""
        from jinja2 import StrictUndefined, TemplateError
        from jinja2.sandbox import SandboxedEnvironment
        if not isinstance(template, str) or not template.strip():
            raise ValueError("SQL template cannot be empty")
        try:
            result = SandboxedEnvironment(undefined=StrictUndefined).from_string(template).render(
                integration_name=self.integration_name,
                entities=self._convert_schemas_to_entities([schema], "stage"),
                generated_sql=generated_sql,
            )
        except TemplateError as error:
            raise ValueError(f"Invalid SQL template: {error}") from error
        if not result.strip():
            raise ValueError("SQL template produced empty output")
        return result

    def generate_sql_type(self, schema_dir: Path, output_dir: Path, sql_type: str, 
                          failed_chunks: Optional[List[int]] = None) -> str:
        """
        Generate SQL file with chunking and retry support
        
        Args:
            schema_dir: Directory containing schema files
            output_dir: Directory to output SQL files  
            sql_type: Type of SQL (stage, prod, view, procedure)
            failed_chunks: List of failed chunk indices to retry (None = process all)
            
        Returns:
            Path to generated SQL file
        """
        print(f"🚀 Generating {sql_type.upper()} SQL using unified approach...")
        
        # Load schemas from file
        schemas = self._load_schemas_from_directory(schema_dir)
        if not schemas:
            raise ValueError(f"No schema files found in {schema_dir}")
        
        # Convert to entities  
        entities = self._convert_schemas_to_entities(schemas, sql_type)
        if not entities:
            raise ValueError(f"No entities found in schemas")
        
        print(f"📊 Found {len(entities)} entities to process")
        
        # Remove duplicates before processing
        entities = self._deduplicate_entities(entities)
        print(f"📊 After deduplication: {len(entities)} unique entities")
        
        # Initialize enterprise retry monitor
        try:
            from reliability_controlling import ChunkMonitor
            monitor = ChunkMonitor(
                operation_name=f"sql_generation_{sql_type}",
                integration_name=self.integration_name
            )
        except ImportError:
            print("⚠️ Enterprise retry system not found, using fallback monitoring")
            monitor = None
        
        # Generate with chunking if LLM verification enabled
        if self.use_llm_verification:
            verified_sql = self._generate_with_chunking(entities, sql_type, monitor, failed_chunks)
        else:
            # Template-only mode
            print("📝 Using template-only (no chunking needed)")
            verified_sql = self._generate_template_sql(entities, sql_type)
            
            # Add common tables/procedures at the end in template-only mode
            if sql_type == 'procedure':
                verified_sql += '\n\n' + '\n'.join(self._generate_common_procedures())
            elif sql_type == 'prod':
                verified_sql += '\n\n' + '\n'.join(self._generate_common_prod_tables())
        
        # Write to file
        output_file = output_dir / f"create_{sql_type}_table.sql"
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(verified_sql)
        
        print(f"✅ Generated {sql_type} SQL: {output_file}")
        return str(output_file)
    
    def _load_schemas_from_directory(self, schema_dir: Path) -> List[Dict]:
        """Load schemas from directory (same format as generator expects)"""
        schemas = []
        
        for schema_file in schema_dir.glob("*.json"):
            # Skip endpoints.json to avoid duplicates with main schema file
            if schema_file.name == "endpoints.json":
                continue
                
            try:
                with open(schema_file, 'r', encoding='utf-8') as f:
                    schema_data = json.load(f)
                
                # Handle different schema formats
                if isinstance(schema_data, list):
                    schemas.extend(schema_data)
                elif isinstance(schema_data, dict):
                    schemas.append(schema_data)
                    
            except Exception as e:
                print(f"⚠️ Warning: Could not load {schema_file}: {e}")
        
        return schemas
    
    def _convert_schemas_to_entities(self, schemas: List[Dict], sql_type: str) -> List[Dict]:
        """Convert schema format to entity format (same as handlers)"""
        entities = []
        
        for schema in schemas:
            schema_endpoints = schema.get("endpoints", [])
            for endpoint in schema_endpoints:
                entity = {
                    "name": endpoint.get("name", "unknown"),
                    "description": endpoint.get("description", ""),
                    "entity_type": endpoint.get("entity_type", "unknown"),
                    "fields": endpoint.get("fields", [])
                }
                entities.append(entity)
        
        return entities
    
    def _generate_with_chunking(self, entities: List[Dict], sql_type: str, 
                               monitor, failed_chunks: Optional[List[int]] = None) -> str:
        """Generate SQL with chunking and retry support"""
        
        # Split entities into chunks
        chunks = [entities[i:i + self.chunk_size] for i in range(0, len(entities), self.chunk_size)]
        
        # Initialize monitoring if available
        if monitor:
            monitor.start_operation()
            monitor.set_total_chunks(len(chunks))
        
        # Determine which chunks to process
        if failed_chunks:
            chunks_to_process = [(i, chunks[i]) for i in failed_chunks if i < len(chunks)]
            print(f"🔄 Retrying {len(chunks_to_process)} failed chunks")
        else:
            chunks_to_process = list(enumerate(chunks))
            print(f"🚀 Processing {len(chunks)} chunks")
        
        results = []
        header_added = False
        
        for chunk_idx, chunk in chunks_to_process:
            print(f"  📦 Processing chunk {chunk_idx + 1}/{len(chunks)} ({len(chunk)} entities)")
            
            # Generate template for chunk
            chunk_template = self._generate_template_sql(chunk, sql_type)
            
            # Try LLM verification (max 2 retries)
            chunk_result = self._process_chunk_with_retry(
                chunk_template, chunk, sql_type, chunk_idx, monitor
            )
            
            # Add to results
            if not header_added and not failed_chunks:
                results.append(chunk_result)
                header_added = True
            else:
                # Skip headers for subsequent chunks
                lines = chunk_result.split('\n')
                sql_lines = [line for line in lines if not (
                    line.startswith('--') and 'Auto Generated' in line
                )]
                results.append('\n'.join(sql_lines).strip())
        
        # Show final status and finalize monitoring
        if monitor:
            monitor.end_operation()
            
            # Generate enterprise report
            stats = monitor.get_statistics()
            print(f"\n📊 Chunk processing complete:")
            print(f"  ✅ Successful: {stats['successful_chunks']}")
            print(f"  ❌ Failed: {stats['failed_chunks']}")
            
            if stats['failed_chunks'] > 0:
                # Generate retry command using enterprise system
                failed_chunk_numbers = monitor.get_failed_chunk_numbers()
                if failed_chunk_numbers:
                    retry_cmd = monitor.generate_retry_command()
                    print(f"💡 Enterprise retry command: {retry_cmd}")
        else:
            print(f"\n📊 Chunk processing complete (no monitoring available)")
        
        # Add common tables/procedures at the end 
        if sql_type == 'procedure':
            results.append('\n'.join(self._generate_common_procedures()))
        elif sql_type == 'prod':
            results.append('\n'.join(self._generate_common_prod_tables()))
        
        return '\n\n'.join(results)
    
    def _generate_common_prod_tables(self) -> List[str]:
        """Generate common production tables (LastRefreshDate, etc.) that all integrations need"""
        sql_parts = []
        
        # Add LastRefreshDate table
        sql_parts.extend(self._generate_lastrefreshdate_table())

        return sql_parts
    
    def _generate_common_procedures(self) -> List[str]:
        """Generate common stored procedures (LastRefreshDate SP, etc.) that all integrations need"""
        sql_parts = []
        
        # Add LastRefreshDate procedure  
        sql_parts.extend(self._generate_lastrefreshdate_procedure())
        
        return sql_parts
    
    def _generate_lastrefreshdate_table(self) -> List[str]:
        """Generate LastRefreshDate table for logging refresh operations"""
        table_name = f"c{{clientID}}_{self.integration_name}_lastrefreshdate"
        
        return [
            f"-- {self.integration_name.upper()} LastRefreshDate Logging Table",
            f"DROP TABLE IF EXISTS {table_name};",
            f"CREATE TABLE {table_name} (",
            "    `Id` INT AUTO_INCREMENT PRIMARY KEY,",
            "    `TableName` VARCHAR(255) NOT NULL,",
            "    `RefreshRowCount` INT DEFAULT 0,",
            "    `TotalRowCount` INT DEFAULT 0,",
            "    `StartDate` DATETIME DEFAULT NULL,",
            "    `EndDate` DATETIME DEFAULT NULL,",
            "    `LastRefreshUTCDate` DATETIME DEFAULT NULL,",
            "    `LoadType` VARCHAR(100) DEFAULT NULL,",
            "    `RefreshStatus` VARCHAR(100) DEFAULT NULL,",
            "    `JobRunId` BIGINT DEFAULT NULL,",
            "    `DatabaseDestination` VARCHAR(100) DEFAULT NULL,",
            "    `ClientID` VARCHAR(255) DEFAULT NULL,",
            "    `OrganisationID` INT DEFAULT NULL,",
            "    `TriggerType` VARCHAR(100) DEFAULT NULL,",
            "    `RefreshDetails` TEXT DEFAULT NULL,",
            "    `CreatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP,",
            "    INDEX `idx_table_org` (`TableName`, `OrganisationID`),",
            "    INDEX `idx_status_date` (`RefreshStatus`, `StartDate`),",
            "    UNIQUE KEY `unique_table_client_org` (`TableName`, `ClientID`, `OrganisationID`)",
            ");",
            ""
        ]
    
    def _generate_lastrefreshdate_procedure(self) -> List[str]:
        """Generate LastRefreshDate stored procedure for logging refresh operations"""
        procedure_name = f"sp_dynamic_{self.integration_name}_lastrefreshdate"
        
        return [
            f"-- {self.integration_name.upper()} LastRefreshDate Logging Procedure",
            f"DROP PROCEDURE IF EXISTS {procedure_name};",
            "DELIMITER $$",
            f"CREATE PROCEDURE {procedure_name}(",
            "    IN p_CID INT,",
            "    IN p_TableName VARCHAR(255),",
            "    IN p_RefreshRowCount INT,",
            "    IN p_TotalRowCount INT,",
            "    IN p_StartDate DATETIME,",
            "    IN p_EndDate DATETIME,",
            "    IN p_LastRefreshUTCDate DATETIME,",
            "    IN p_LoadType VARCHAR(255),",
            "    IN p_RefreshStatus VARCHAR(255),",
            "    IN p_JobRunId BIGINT,",
            "    IN p_DatabaseDestination VARCHAR(255),",
            "    IN p_ClientID VARCHAR(255),",
            "    IN p_OrganisationID INT,",
            "    IN p_TriggerType VARCHAR(255),",
            "    IN p_RefreshDetails VARCHAR(255)",
            ")",
            "BEGIN",
            "    DECLARE v_NewID INT;",
            "",
            f"    SET @lastRefreshDateTable = CONCAT('`{{client_database}}`.`c', p_CID, '_{self.integration_name}_lastrefreshdate`');",
            "",
            "    SET @newid_sql = CONCAT('SELECT COALESCE(MAX(ID), 0) + 1 INTO @v_NewID FROM ', @lastRefreshDateTable, ';');",
            "    PREPARE new_stmt FROM @newid_sql;",
            "    EXECUTE new_stmt;",
            "    DEALLOCATE PREPARE new_stmt;",
            "    SET v_NewID = @v_NewID;",
            "",
            "    SET @insert_sql = CONCAT(",
            "        'INSERT INTO ', @lastRefreshDateTable, ' (',",
            "        '`Id`, `TableName`, `RefreshRowCount`, `TotalRowCount`, `StartDate`, `EndDate`, ',",
            "        '`LastRefreshUTCDate`, `LoadType`, `RefreshStatus`, `JobRunId`, `DatabaseDestination`, ',",
            "        '`ClientID`, `OrganisationID`, `TriggerType`, `RefreshDetails`) VALUES (',",
            "        COALESCE(v_NewID, 0), ', ',",
            "        '''', COALESCE(p_TableName, ''), ''', ',",
            "        COALESCE(p_RefreshRowCount, 0), ', ',",
            "        COALESCE(p_TotalRowCount, 0), ', ',",
            "        IFNULL(CONCAT(\"'\", DATE_FORMAT(STR_TO_DATE(LEFT(p_StartDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), \"'\"), 'NULL'), ', ',",
            "        IFNULL(CONCAT(\"'\", DATE_FORMAT(STR_TO_DATE(LEFT(p_EndDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), \"'\"), 'NULL'), ', ',",
            "        IFNULL(CONCAT(\"'\", DATE_FORMAT(STR_TO_DATE(LEFT(p_LastRefreshUTCDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), \"'\"), 'NULL'), ', ',",
            "        '''', COALESCE(p_LoadType, ''), ''', ',",
            "        '''', COALESCE(p_RefreshStatus, ''), ''', ',",
            "        COALESCE(p_JobRunId, 'NULL'), ', ',",
            "        '''', COALESCE(p_DatabaseDestination, ''), ''', ',",
            "        '''', COALESCE(p_ClientID, ''), ''', ',",
            "        COALESCE(p_OrganisationID, 'NULL'), ', ',",
            "        '''', COALESCE(p_TriggerType, ''), ''', ',",
            "        '''', COALESCE(p_RefreshDetails, ''), '''',",
            "        ') ON DUPLICATE KEY UPDATE ',",
            "        '`RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`), ',",
            "        '`TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`), ',",
            "        '`StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`), ',",
            "        '`EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`), ',",
            "        '`LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`), ',",
            "        '`LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`), ',",
            "        '`RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`), ',",
            "        '`JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`), ',",
            "        '`DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`), ',",
            "        '`TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`), ',",
            "        '`RefreshDetails` = VALUES(`RefreshDetails`)'",
            "    );",
            "",
            "    PREPARE ins_stmt FROM @insert_sql;",
            "    EXECUTE ins_stmt;",
            "    DEALLOCATE PREPARE ins_stmt;",
            "END $$",
            "DELIMITER ;",
            ""
        ]
    
    def _process_chunk_with_retry(self, template_sql: str, entities: List[Dict], 
                                  sql_type: str, chunk_idx: int, monitor) -> str:
        """Process chunk with retry logic (max 2 retries)"""
        
        max_retries = 2
        
        for attempt in range(max_retries + 1):
            try:
                if attempt > 0:
                    print(f"    🔄 Retry {attempt}/{max_retries} for chunk {chunk_idx + 1}")
                
                # Call actual LLM verification - replace with real LLM API
                verified_sql = self._call_llm_verification(template_sql, entities, sql_type)
                
                # Success
                if monitor:
                    monitor.log_chunk_result(chunk_idx, True)
                return verified_sql
                
            except Exception as e:
                print(f"    ⚠️ Attempt {attempt + 1} failed: {e}")
                
                if attempt == max_retries:
                    # Final failure - use template
                    print(f"    📝 Using template fallback for chunk {chunk_idx + 1}")
                    if monitor:
                        monitor.log_chunk_result(chunk_idx, False, template_fallback=True)
                    return template_sql
                
        return template_sql
    
    def _call_llm_verification(self, template_sql: str, entities: List[Dict], sql_type: str) -> str:
        """Call actual LLM verification - replace this with real LLM API call"""
        
        # Build refinement prompt
        prompt = self._build_refinement_prompt(template_sql, entities, sql_type)
        
        # TODO: Replace with actual LLM API call
        # For now, just apply smart context-aware fixes
        return self._apply_smart_fixes(template_sql)
    
    def _build_refinement_prompt(self, template_sql: str, entities: List[Dict], sql_type: str) -> str:
        """Build LLM refinement prompt"""
        
        entity_context = []
        for entity in entities:
            entity_name = entity.get('name', 'unknown')
            fields = entity.get('fields', [])
            field_info = [f"  - {field.get('db_column', field.get('name', 'unknown'))}: {field.get('data_type', 'VARCHAR')}" 
                         for field in fields[:5]]  # Limit to avoid token overflow
            
            entity_context.append(f"Entity: {entity_name}")
            if field_info:
                entity_context.extend(field_info)
        
        context_text = "\n".join(entity_context)
        
        return f"""Fix and optimize this {sql_type.upper()} SQL:

TEMPLATE SQL:
{template_sql}

ENTITY CONTEXT:
{context_text}

Requirements:
1. Escape MySQL reserved keywords with backticks
2. Use appropriate data types 
3. Fix syntax issues
4. Add proper indexes for tables (not views)

Return only valid SQL code."""
    
    def _apply_smart_fixes(self, sql_content: str) -> str:
        """Apply context-aware fixes to SQL - smart escaping that distinguishes SQL commands from column names"""
        
        fixed_sql = sql_content
        
        # Pass 1: Escape column names in CREATE TABLE statements only
        fixed_sql = self._escape_create_table_columns(fixed_sql)
        
        # Pass 2: Escape column names in column definitions with data types
        fixed_sql = self._escape_column_definitions(fixed_sql)
        
        # Pass 3: Fix common SQL syntax issues (but keep SQL commands clean)
        fixed_sql = re.sub(r'CREATE TABLE\s+(\w+)', r'CREATE TABLE \1', fixed_sql)
        fixed_sql = re.sub(r'PRIMARY KEY\s*\(\s*([^)]+)\s*\)', r'PRIMARY KEY (\1)', fixed_sql)
        
        return fixed_sql
    
    def _escape_create_table_columns(self, sql_content: str) -> str:
        """Escape reserved keywords used as column names in CREATE TABLE statements"""
        
        # Pattern to find CREATE TABLE statements and their column definitions
        def escape_table_columns(match):
            table_def = match.group(0)
            
            # Escape column keywords in this table definition only
            for keyword in COLUMN_KEYWORDS:
                # Match keyword followed by data type (column definition context)
                pattern = rf'\b({keyword})\b\s+(VARCHAR|INT|DATETIME|BOOLEAN|TEXT|DECIMAL|JSON|JSONB)'
                replacement = rf'`\1` \2'
                table_def = re.sub(pattern, replacement, table_def, flags=re.IGNORECASE)
            
            return table_def
        
        # Apply escaping only within CREATE TABLE statements
        create_table_pattern = r'CREATE TABLE[^;]+;'
        return re.sub(create_table_pattern, escape_table_columns, sql_content, flags=re.IGNORECASE | re.MULTILINE | re.DOTALL)
    
    def _escape_column_definitions(self, sql_content: str) -> str:
        """Escape reserved keywords in column definitions outside CREATE TABLE (like ALTER TABLE)"""
        
        fixed_sql = sql_content
        
        # Only escape column keywords followed by data types (not SQL commands)
        for keyword in COLUMN_KEYWORDS:
            # Match keyword + data type pattern (indicates column definition)
            pattern = rf'\b({keyword})\b\s+(VARCHAR|INT|DATETIME|BOOLEAN|TEXT|DECIMAL|JSON|JSONB)'
            replacement = rf'`\1` \2'
            fixed_sql = re.sub(pattern, replacement, fixed_sql, flags=re.IGNORECASE)
        
        return fixed_sql
    
    def _generate_template_sql(self, entities: List[Dict], sql_type: str) -> str:
        """Generate template SQL using QBO patterns"""
        
        if sql_type == 'stage':
            return self._generate_stage_template(entities)
        elif sql_type == 'prod':
            return self._generate_prod_template(entities)
        elif sql_type == 'view':
            return self._generate_view_template(entities)
        elif sql_type == 'procedure':
            return self._generate_procedure_template(entities)
        else:
            raise ValueError(f"Unsupported SQL type: {sql_type}")
    
    def _generate_stage_template(self, entities: List[Dict]) -> str:
        """Generate stage tables using AWS compatible pattern"""

        header = [
            f"-- {self.integration_name.upper()} Stage Tables - Auto Generated",
            f"-- Pattern: c{{clientID}}_{{orgID}}_{self.integration_name}_{{entity}}stage",
            f"-- Replace {{clientID}} and {{orgID}} with actual values",
            f"-- AWS: Database prefixes are no longer needed with AWS",
            "",
        ]

        sql_parts = header.copy()

        for entity in entities:
            entity_name = entity.get('name', 'unknown').lower()
            fields = entity.get('fields', [])

            # Table creation - AWS compatible (no database prefix)
            table_name = f"c{{clientID}}_{{orgID}}_{self.integration_name}_{entity_name}stage"

            sql_parts.extend([
                f"-- {entity.get('name', 'Unknown')} Stage Table",
                f"DROP TABLE IF EXISTS {table_name};",
                f"CREATE TABLE {table_name} ("
            ])

            # Generate fields with duplicate detection (includes PRIMARY KEY)
            primary_key_fields = []
            field_definitions = self._add_fields_with_duplicate_check(
                fields, primary_key_fields, table_type='stage'
            )

            sql_parts.append(",\n".join(field_definitions))
            sql_parts.extend([");", ""])

        return "\n".join(sql_parts)
    
    def _generate_prod_template(self, entities: List[Dict]) -> str:
        """Generate production tables using AWS compatible pattern"""

        header = [
            f"-- {self.integration_name.upper()} Production Tables - Auto Generated",
            f"-- Pattern: c{{clientID}}_{self.integration_name}_{{entity}}",
            f"-- Replace {{clientID}} with actual value",
            f"-- AWS: Database prefixes are no longer needed with AWS",
            "",
        ]

        sql_parts = header.copy()

        for entity in entities:
            entity_name = entity.get('name', 'unknown').lower()
            fields = entity.get('fields', [])

            # Table creation - AWS compatible (no database prefix)
            table_name = f"c{{clientID}}_{self.integration_name}_{entity_name}"

            sql_parts.extend([
                f"-- {entity.get('name', 'Unknown')} Production Table",
                f"DROP TABLE IF EXISTS {table_name};",
                f"CREATE TABLE {table_name} ("
            ])

            # Generate fields with duplicate detection (includes PRIMARY KEY)
            primary_key_fields = []
            field_definitions = self._add_fields_with_duplicate_check(
                fields, primary_key_fields, table_type='prod'
            )

            sql_parts.append(",\n".join(field_definitions))
            sql_parts.extend([");", ""])

        return "\n".join(sql_parts)
    
    def _generate_view_template(self, entities: List[Dict]) -> str:
        """Generate views using AWS compatible pattern"""

        header = [
            f"-- {self.integration_name.upper()} Views - Auto Generated",
            f"-- Pattern: {{etani_client_id}}_{self.integration_name}_{{entity}}",
            f"-- Replace {{etani_client_id}} with actual value",
            f"-- AWS: Database prefixes are no longer needed with AWS",
            "",
        ]

        sql_parts = header.copy()

        for entity in entities:
            entity_name = entity.get('name', 'unknown').lower()
            fields = entity.get('fields', [])

            view_name = f"{{etani_client_id}}_{self.integration_name}_{entity_name}"
            table_name = f"c{{clientID}}_{self.integration_name}_{entity_name}"

            sql_parts.extend([
                f"-- {entity.get('name', 'Unknown')} View",
                f"DROP VIEW IF EXISTS {view_name};",
                f"CREATE VIEW {view_name} AS",
                "SELECT"
            ])

            # Generate field list using db_column names with duplicate prevention
            select_fields = []
            seen_fields = set()

            for field in fields:
                db_column_raw = field.get('db_column', 'unknown')
                db_column = self._escape_reserved_keyword(db_column_raw.lower())
                api_name = field.get('api_name')

                # Skip duplicates
                normalized_db_column = db_column.upper().replace('`', '')
                if normalized_db_column in seen_fields:
                    continue
                seen_fields.add(normalized_db_column)

                # Always ensure view field names are lowercase
                original_column = db_column.replace('`', '')

                # Determine the desired lowercase field name
                if api_name and len(api_name) <= 64:
                    # Use lowercase version of api_name when available
                    lowercase_field = api_name.lower()
                else:
                    # Use lowercase version of original column name
                    lowercase_field = original_column.lower()

                # Only use AS if the original column name differs from desired lowercase name
                if original_column.lower() != lowercase_field:
                    select_fields.append(f"    {db_column} AS `{lowercase_field}`")
                else:
                    select_fields.append(f"    {db_column}")

            # Add audit columns with duplicate check and lowercase field names
            audit_fields = [
                ("ClientID", "clientid"),
                ("etlinserttime", "etlinserttime"),
                ("etlupdatetime", "etlupdatetime")
            ]
            for original_field, lowercase_field in audit_fields:
                if original_field.upper() not in seen_fields:
                    if original_field.lower() != lowercase_field:
                        select_fields.append(f"    {original_field} AS `{lowercase_field}`")
                    else:
                        select_fields.append(f"    {original_field}")
                    seen_fields.add(original_field.upper())

            sql_parts.append(",\n".join(select_fields))
            # AWS: No database prefix needed
            sql_parts.extend([f"FROM {table_name};", ""])

        return "\n".join(sql_parts)
    
    def _generate_procedure_template(self, entities: List[Dict]) -> str:
        """Generate stored procedures using AWS compatible pattern"""

        header = [
            f"-- {self.integration_name.upper()} Stored Procedures - Auto Generated",
            f"-- Individual procedures for each entity following QBO pattern",
            f"-- AWS: Database prefixes are no longer needed with AWS",
            f"-- AWS: Procedures do not use DEFINER clause",
            "",
        ]

        sql_parts = header.copy()

        # Generate individual procedure for each entity
        for entity in entities:
            entity_name = entity.get('name', 'unknown').lower()
            procedure_name = f"sp_dynamic_{self.integration_name}_{entity_name}"

            sql_parts.extend([
                f"-- {entity.get('name', 'Unknown')}",
                f"DROP PROCEDURE IF EXISTS {procedure_name};",
                "DELIMITER $$",
                # Remove DEFINER clause for AWS compatibility
                f"CREATE PROCEDURE {procedure_name}(IN p_clientID VARCHAR(100), IN p_orgID INT)",
                "BEGIN",
                "    DECLARE v_OrganisationID INT DEFAULT p_orgID;",
                "    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;",
                f"    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{{client_database}}`.`c', v_clientID, '_{self.integration_name}_{entity_name}`');",
                f"    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{{client_database}}`.`c', v_clientID, '_', p_orgID, '_{self.integration_name}_{entity_name}stage`');",
                "",
                "    SET @delete_default = CONCAT('",
                "        DELETE FROM ', v_table_name, ' ",
                "        WHERE OrganisationID = ', v_OrganisationID, ';",
                "    ');",
                "",
                "    PREPARE stmt1 FROM @delete_default;",
                "    EXECUTE stmt1;",
                "    DEALLOCATE PREPARE stmt1;",
                "",
                # Generate explicit SELECT with datetime handling
                *self._generate_insert_select_with_datetime_handling(entity),
                "",
                "    PREPARE stmt2 FROM @insert_sql;",
                "    EXECUTE stmt2;",
                "    DEALLOCATE PREPARE stmt2;",
                "END $$",
                "DELIMITER ;",
                ""
            ])

        return "\n".join(sql_parts)
    
    def _generate_insert_select_with_datetime_handling(self, entity: Dict) -> List[str]:
        """
        Generate INSERT SELECT statement with datetime field cleaning for procedures
        
        Args:
            entity: Entity definition containing fields
            
        Returns:
            List of SQL lines for the INSERT SELECT statement
        """
        fields = entity.get('fields', [])
        
        # Start building the SELECT clause
        sql_lines = [
            "    SET @insert_sql = CONCAT('",
            "        INSERT INTO ', v_table_name, '",
            "        SELECT"
        ]
        
        # Generate field list with datetime handling
        select_fields = []
        seen_fields = set()
        
        for field in fields:
            db_column = field.get('db_column', field.get('api_name', 'unknown'))
            # Remove backticks for processing
            clean_db_column = db_column.replace('`', '')
            
            # Skip duplicates
            if clean_db_column.upper() in seen_fields:
                continue
            seen_fields.add(clean_db_column.upper())
            
            # Check if this is a datetime field based on name patterns
            escaped_field = self._escape_reserved_keyword(clean_db_column.lower())
            
            if self._is_datetime_field(clean_db_column, field):
                # Apply datetime cleaning with CAST to avoid MySQL datetime conversion errors
                case_statement = f"""            CASE 
                WHEN CAST({escaped_field} AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE {escaped_field} 
            END as {escaped_field}"""
                select_fields.append(case_statement)
            else:
                # Regular field - no special handling needed
                select_fields.append(f"            {escaped_field}")
        
        # Add audit columns if not already present
        audit_fields = ["ClientID", "OrganisationID", "etlinserttime", "etlupdatetime"]
        for audit_field in audit_fields:
            if audit_field.upper() not in seen_fields:
                escaped_audit_field = self._escape_reserved_keyword(audit_field)
                select_fields.append(f"            {escaped_audit_field}")
                seen_fields.add(audit_field.upper())
        
        # Join fields with commas
        if select_fields:
            # Add comma after each field except the last one
            for i, field in enumerate(select_fields[:-1]):
                sql_lines.append(field + ",")
            sql_lines.append(select_fields[-1])  # Last field without comma
        
        # Complete the statement
        sql_lines.extend([
            "        FROM ', v_stage_table, ';",
            "    ');"
        ])
        
        return sql_lines
    
    def _is_datetime_field(self, column_name: str, field_definition: Dict) -> bool:
        """
        Determine if a field is a datetime field based on name patterns and type information
        
        Args:
            column_name: The database column name
            field_definition: Field definition from schema
            
        Returns:
            True if field should be treated as datetime
        """
        column_lower = column_name.lower()
        
        # Check explicit data type if available
        data_type = field_definition.get('data_type', '').lower()
        if any(dt in data_type for dt in ['datetime', 'timestamp', 'date']):
            return True
        
        # Check common datetime field name patterns
        datetime_patterns = [
            'time', 'date', 'created', 'modified', 'updated', 'deleted',
            'start', 'end', 'due', 'last', 'saved', 'invoiced'
        ]
        
        return any(pattern in column_lower for pattern in datetime_patterns)
    
    def _deduplicate_entities(self, entities: List[Dict]) -> List[Dict]:
        """Remove duplicate entities based on name"""
        seen_names = set()
        unique_entities = []
        
        for entity in entities:
            entity_name = entity.get('name', 'unknown').lower()
            if entity_name not in seen_names:
                seen_names.add(entity_name)
                unique_entities.append(entity)
            else:
                print(f"    ⚠️ Skipping duplicate entity: {entity_name}")
        
        return unique_entities
    
    def _add_fields_with_duplicate_check(self, fields: List[Dict], primary_key_fields: List[str], 
                                        table_type: str = 'stage') -> List[str]:
        """
        Add fields with comprehensive duplicate detection and removal
        
        Args:
            fields: List of field definitions from schema
            primary_key_fields: List to collect primary key field names (modified in-place)
            table_type: 'stage' or 'prod' to determine audit columns
            
        Returns:
            List of field definition strings
        """
        field_definitions = []
        existing_columns = set()
        duplicate_warnings = []
        
        # Process entity fields with duplicate tracking
        for i, field in enumerate(fields):
            db_column = field.get('db_column', f'unknown_{i}')
            field_name = self._escape_reserved_keyword(db_column.lower())
            field_type = self._get_mysql_type(field.get('data_type', 'string'), field)
            
            # Normalize column name for comparison (case insensitive, no backticks)
            normalized_name = field_name.upper().replace('`', '')
            
            # Check for duplicates
            if normalized_name in existing_columns:
                duplicate_warnings.append(f"Duplicate field detected and skipped: {field_name}")
                continue
            
            # Handle nullable
            nullable = field.get('nullable', True)
            null_constraint = "" if nullable else " NOT NULL"
            
            # Add field definition
            field_definitions.append(f"    {field_name} {field_type}{null_constraint}")
            existing_columns.add(normalized_name)
            
            # Collect primary key fields
            if field.get('is_primary_key', False):
                primary_key_fields.append(field_name)
        
        # Add audit columns - same for both stage and prod tables  
        audit_columns = [
            ("ClientID", "VARCHAR(255) NOT NULL"),
            ("OrganisationID", "VARCHAR(255) NOT NULL"), 
            ("etlinserttime", "DATETIME DEFAULT CURRENT_TIMESTAMP"),
            ("etlupdatetime", "DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
        ]
        
        # Add audit columns with duplicate check
        for col_name, col_def in audit_columns:
            normalized_name = col_name.upper()
            if normalized_name not in existing_columns:
                field_definitions.append(f"    {col_name} {col_def}")
                existing_columns.add(normalized_name)
            else:
                duplicate_warnings.append(f"Audit column already exists in schema: {col_name}")
        
        # Only report duplicate warnings if they are actual errors (not expected audit column skips)
        error_warnings = [w for w in duplicate_warnings if "Audit column already exists" not in w]
        if error_warnings:
            print(f"    ⚠️ Duplicate field warnings:")
            for warning in error_warnings:
                print(f"      - {warning}")
        
        # Add primary key logic: Use all fields marked as is_primary_key
        # But do not create PRIMARY KEY if only OrganisationID is marked as primary key
        if primary_key_fields:
            # Check if primary key contains only OrganisationID
            if len(primary_key_fields) == 1 and primary_key_fields[0] == "OrganisationID":
                print(f"    ⚠️ Skipping PRIMARY KEY creation - cannot use only OrganisationID as primary key")
            else:
                # Create composite primary key from all primary key fields
                pk_fields_str = ", ".join(primary_key_fields)
                pk_clause = f"    PRIMARY KEY ({pk_fields_str})"
                field_definitions.append(pk_clause)
        
        
        return field_definitions
    
    def _escape_reserved_keyword(self, field_name: str) -> str:
        """Escape MySQL reserved keywords with backticks"""
        if field_name.upper() in RESERVED_KEYWORDS:
            return f"`{field_name}`"
        return field_name
    
    def _get_mysql_type(self, field_type: str, field: dict = None) -> str:
        """Convert schema field type to MySQL type, respecting schema data_type and is_flatten flag"""
        
        # Define type mapping first
        type_mapping = {
            'string': 'VARCHAR(100)',
            'text': 'TEXT', 
            'integer': 'INT',
            'int': 'INT',
            'bigint': 'BIGINT',
            'float': 'FLOAT',
            'double': 'DOUBLE',
            'decimal': 'DECIMAL(10,2)',
            'boolean': 'BOOLEAN',
            'bool': 'BOOLEAN',
            'date': 'DATE',
            'datetime': 'DATETIME',
            'timestamp': 'TIMESTAMP',
            'json': 'JSON',
            'jsonb': 'JSON',
            # Handle common MySQL variants
            'varchar': field_type.upper() if field_type.upper().startswith('VARCHAR') else 'VARCHAR(255)',
            'varchar(100)': 'VARCHAR(100)',
            'varchar(255)': 'VARCHAR(255)',
            'varchar(500)': 'VARCHAR(500)',
            'varchar(1000)': 'VARCHAR(1000)',
        }
        
        if field:
            # Check if this field should be flattened (default: false)
            is_flatten = field.get('is_flatten', False)
            
            # PRIORITY 1: Use exact data_type from schema if present and not flattening
            if not is_flatten and 'data_type' in field and field['data_type']:
                schema_data_type = field['data_type']
                
                # Direct mapping if it's already a MySQL type
                if schema_data_type.upper() in ['JSON', 'JSONB', 'TEXT', 'INT', 'BIGINT', 'FLOAT', 'DOUBLE', 'BOOLEAN', 'DATE', 'DATETIME', 'TIMESTAMP']:
                    return 'JSON' if schema_data_type.upper() == 'JSONB' else schema_data_type.upper()
                
                # Handle VARCHAR with size
                if schema_data_type.upper().startswith('VARCHAR'):
                    return schema_data_type.upper()
                
                # Handle DECIMAL with precision
                if schema_data_type.upper().startswith('DECIMAL'):
                    return schema_data_type.upper()
                
                # Try exact mapping from type_mapping
                if schema_data_type.lower() in type_mapping:
                    return type_mapping[schema_data_type.lower()]
            
            # PRIORITY 2: Apply flattening logic only if is_flatten is true
            if is_flatten:
                db_column = field.get('db_column', '').lower()
                api_name = field.get('api_name', '').lower()
                
                # Apply smart sizing to avoid MySQL row size limit (65,535 bytes)
                # ID fields - flexible for int/uuid/string
                if (db_column == 'id' or db_column.endswith('id') or 
                    api_name == 'id' or api_name.endswith('_id')):
                    return 'VARCHAR(100)'  # Reduced from 255 - enough for UUIDs (36 chars)
                
                # Name/Title fields - typically shorter
                if any(keyword in db_column for keyword in ['name', 'title', 'type', 'status', 'source']):
                    return 'VARCHAR(100)'
                
                # Email fields
                if 'email' in db_column:
                    return 'VARCHAR(150)'
                
                # Description/Message fields should be TEXT
                if any(keyword in db_column for keyword in ['description', 'message', 'note', 'comment']):
                    return 'TEXT'
                
                # Address fields
                if any(keyword in db_column for keyword in ['address', 'city', 'region', 'country']):
                    return 'VARCHAR(100)'
                
                # Code/Number fields
                if any(keyword in db_column for keyword in ['code', 'number', 'postcode']):
                    return 'VARCHAR(50)'
        
        # PRIORITY 3: Fallback to field_type mapping
        return type_mapping.get(field_type.lower(), 'VARCHAR(100)')


def generate_all_sql_types(integration_name: str, schema_dir: Path, output_dir: Path, 
                          use_llm_verification: bool = True) -> Dict[str, str]:
    """
    Convenience function to generate all SQL types
    
    Args:
        integration_name: Name of integration
        schema_dir: Directory containing schema files
        output_dir: Directory to output SQL files
        use_llm_verification: Whether to use LLM verification
        
    Returns:
        Dict mapping SQL type to generated file path
    """
    
    generator = UnifiedSQLGenerator(integration_name, use_llm_verification)
    results = {}
    
    for sql_type in ['stage', 'prod', 'view', 'procedure']:
        try:
            file_path = generator.generate_sql_type(schema_dir, output_dir, sql_type)
            results[sql_type] = file_path
        except Exception as e:
            print(f"❌ Failed to generate {sql_type}: {e}")
            results[sql_type] = None
    
    return results