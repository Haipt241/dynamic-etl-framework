"""
SQL Stored Procedure Optimizer Script

This script analyzes stored procedures for a given client and recommends indexes
to improve query performance. It parses procedure definitions to identify
queries and their table/column usage patterns.

Usage:
    python sql_sp_optimizer.py --client_id 1834
"""

print("Starting SQL Stored Procedure Optimizer...")

import re
import argparse
import logging
import os
from collections import defaultdict
from typing import Dict, List, Set, Tuple
import sqlparse
from sqlparse.sql import IdentifierList, Identifier, Where, Function
from sqlparse.tokens import Keyword, DML

# Set dummy environment variables to allow sql_helper import
if not os.getenv('EtaniClientID'):
    os.environ['EtaniClientID'] = 'DUMMY_CLIENT1'
if not os.getenv('EtaniOrganisationID'):
    os.environ['EtaniOrganisationID'] = '1'
if not os.getenv('DB_Destination'):
    os.environ['DB_Destination'] = 'EVA'
if not os.getenv('JOB_ID'):
    os.environ['JOB_ID'] = '1'
if not os.getenv('JOB_RUN_ID'):
    os.environ['JOB_RUN_ID'] = '1'
if not os.getenv('TRIGGER_TYPE'):
    os.environ['TRIGGER_TYPE'] = 'MANUAL'
if not os.getenv('XeroTenantID'):
    os.environ['XeroTenantID'] = 'dummy-tenant-id'

# Import database connections from sql_helper
print("Importing sql_helper...")
from sql_helper import (
    eva_engine,
    cms_engine,
    eva_main_engine,
    EVA_DB_NAME,
    EVA_STAGE_DB_NAME,
    CMS_DB_NAME,
    USE_AWS_DB
)
from sqlalchemy import text
print("Import complete.")

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class StoredProcedureAnalyzer:
    """Analyzes stored procedures to identify tables and columns that need indexing."""

    def __init__(self, client_id: int):
        self.client_id = client_id
        self.sp_prefix = f"sp_c{client_id}_"
        self.index_recommendations = defaultdict(lambda: {
            'join_columns': set(),
            'where_columns': set(),
            'group_by_columns': set(),
            'order_by_columns': set(),
            'insert_columns': set(),
            'update_columns': set(),
            'sp_names': set(),
            'database': None,
            'explain_results': [],
            'query_cost': 0,
            'uses_filesort': False,
            'uses_temp_table': False,
        })
        # Cache for table statistics
        self.table_stats = {}
        self.column_selectivity = {}

    def get_all_stored_procedures(self) -> List[Tuple[str, str]]:
        """
        Retrieve all stored procedures for the client from evadb_stage.

        Returns:
            List of tuples (sp_name, sp_definition)
        """
        procedures = []

        try:
            logger.info(f"Querying stored procedures from {EVA_STAGE_DB_NAME}...")
            print(f"Querying stored procedures with prefix: {self.sp_prefix}%")

            query = text("""
                SELECT ROUTINE_NAME, ROUTINE_DEFINITION
                FROM INFORMATION_SCHEMA.ROUTINES
                WHERE ROUTINE_SCHEMA = :db_name
                AND ROUTINE_TYPE = 'PROCEDURE'
                AND ROUTINE_NAME LIKE :sp_prefix
                ORDER BY ROUTINE_NAME
            """)

            with eva_engine.connect() as conn:
                result = conn.execute(query, {
                    'db_name': EVA_STAGE_DB_NAME,
                    'sp_prefix': f"{self.sp_prefix}%"
                })

                row_count = 0
                for row in result:
                    sp_name = row[0]
                    sp_definition = row[1]
                    procedures.append((sp_name, sp_definition))
                    logger.info(f"Found stored procedure: {sp_name}")
                    print(f"Found SP: {sp_name}")
                    row_count += 1

                if row_count == 0:
                    print(f"No stored procedures found in {EVA_STAGE_DB_NAME}")
                    logger.info(f"No stored procedures found in {EVA_STAGE_DB_NAME}")

        except Exception as e:
            logger.error(f"Error querying stored procedures from {EVA_STAGE_DB_NAME}: {e}")
            print(f"ERROR querying {EVA_STAGE_DB_NAME}: {e}")
            import traceback
            traceback.print_exc()

        return procedures

    def extract_queries_from_procedure(self, sp_definition: str) -> List[str]:
        """
        Extract individual SQL queries from stored procedure definition.

        Args:
            sp_definition: The procedure body SQL

        Returns:
            List of SQL query strings
        """
        queries = []

        # Remove comments first
        code = re.sub(r'--.*$', '', sp_definition, flags=re.MULTILINE)
        code = re.sub(r'/\*.*?\*/', '', code, flags=re.DOTALL)

        # Find DML statements (SELECT, INSERT, UPDATE, DELETE)
        # Use semicolons as primary delimiters, but also handle END, DECLARE, IF, etc.

        # Split by semicolons first to get individual statements
        statements = re.split(r';', code)

        for statement in statements:
            statement = statement.strip()
            if not statement:
                continue

            # Check if this is a DML statement we want to analyze
            if re.match(r'^\s*(SELECT|INSERT|UPDATE|DELETE)\s+', statement, re.IGNORECASE):
                # Clean up and add to queries list
                query = statement.strip()
                if len(query) > 15:  # Ignore very short queries
                    queries.append(query)

        logger.debug(f"Extracted {len(queries)} queries from procedure")
        return queries

    def identify_table_database(self, table_name: str) -> str:
        """
        Determine if a table belongs to evadb or evadb_stage.

        Args:
            table_name: Name of the table

        Returns:
            'evadb' or 'evadb_stage'
        """
        # Stage tables typically have 'stage' in their name or are temp tables
        if 'stage' in table_name.lower() or table_name.startswith('tmp_') or table_name.startswith('#'):
            return 'evadb_stage'
        else:
            return 'evadb'

    def get_table_statistics(self, table_name: str, database: str) -> Dict:
        """
        Get table statistics including size, row count.

        Args:
            table_name: Name of the table
            database: Database name ('evadb' or 'evadb_stage')

        Returns:
            Dict with row_count, size_mb
        """
        cache_key = f"{database}.{table_name}"
        if cache_key in self.table_stats:
            return self.table_stats[cache_key]

        if database == 'evadb_stage':
            engine = eva_engine
            db_name = EVA_STAGE_DB_NAME
        else:
            engine = eva_main_engine
            db_name = EVA_DB_NAME

        stats = {
            'row_count': 0,
            'size_mb': 0.0,
        }

        try:
            query = text("""
                SELECT
                    TABLE_ROWS as row_count,
                    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) as size_mb
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = :db_name
                AND TABLE_NAME = :table_name
            """)

            with engine.connect() as conn:
                result = conn.execute(query, {
                    'db_name': db_name,
                    'table_name': table_name
                }).fetchone()

                if result:
                    stats['row_count'] = result[0] or 0
                    stats['size_mb'] = float(result[1] or 0)

            logger.debug(f"Table {table_name}: {stats['row_count']:,} rows, {stats['size_mb']:.2f} MB")

        except Exception as e:
            logger.error(f"Error getting table stats for {table_name}: {e}")

        self.table_stats[cache_key] = stats
        return stats

    def get_column_selectivity(self, table_name: str, column_name: str, database: str) -> float:
        """
        Calculate column selectivity (cardinality ratio).

        Args:
            table_name: Name of the table
            column_name: Name of the column
            database: Database name

        Returns:
            Selectivity ratio (0.0 to 1.0)
        """
        cache_key = (database, table_name, column_name)
        if cache_key in self.column_selectivity:
            return self.column_selectivity[cache_key]

        if database == 'evadb_stage':
            engine = eva_engine
            db_name = EVA_STAGE_DB_NAME
        else:
            engine = eva_main_engine
            db_name = EVA_DB_NAME

        selectivity = 0.5  # Default

        try:
            query = text("""
                SELECT
                    CARDINALITY,
                    (SELECT TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES
                     WHERE TABLE_SCHEMA = :db_name AND TABLE_NAME = :table_name) as total_rows
                FROM INFORMATION_SCHEMA.STATISTICS
                WHERE TABLE_SCHEMA = :db_name
                AND TABLE_NAME = :table_name
                AND COLUMN_NAME = :column_name
                AND SEQ_IN_INDEX = 1
                LIMIT 1
            """)

            with engine.connect() as conn:
                result = conn.execute(query, {
                    'db_name': db_name,
                    'table_name': table_name,
                    'column_name': column_name
                }).fetchone()

                if result and result[1] and result[1] > 0:
                    cardinality = result[0] or 0
                    total_rows = result[1]
                    selectivity = cardinality / total_rows if total_rows > 0 else 0.5

        except Exception as e:
            logger.warning(f"Error calculating selectivity for {table_name}.{column_name}: {e}")

        self.column_selectivity[cache_key] = selectivity
        return selectivity

    def parse_query_for_tables_and_columns(self, query: str) -> Dict:
        """
        Parse a SQL query to extract tables and columns used.

        Args:
            query: SQL query string

        Returns:
            Dict with tables and their column usage
        """
        result = defaultdict(lambda: {
            'join_columns': set(),
            'where_columns': set(),
            'group_by_columns': set(),
            'order_by_columns': set(),
            'insert_columns': set(),
            'update_columns': set(),
        })

        try:
            # Parse with sqlparse
            parsed = sqlparse.parse(query)[0]

            # Extract table names from FROM and JOIN clauses
            from_pattern = r'FROM\s+([`\w\.]+)'
            join_pattern = r'JOIN\s+([`\w\.]+)'

            from_matches = re.findall(from_pattern, query, re.IGNORECASE)
            join_matches = re.findall(join_pattern, query, re.IGNORECASE)

            tables = set(from_matches + join_matches)
            tables = {t.strip('`').split('.')[-1] for t in tables}  # Get table name without database prefix

            # Extract columns from WHERE clause
            where_match = re.search(r'WHERE\s+(.*?)(?:GROUP|ORDER|LIMIT|;|$)', query, re.IGNORECASE | re.DOTALL)
            if where_match:
                where_clause = where_match.group(1)
                # Find table.column patterns
                column_pattern = r'(\w+)\.(\w+)'
                matches = re.findall(column_pattern, where_clause)
                for table, column in matches:
                    if table in tables:
                        result[table]['where_columns'].add(column)

            # Extract columns from JOIN conditions
            join_pattern = r'JOIN\s+\w+.*?ON\s+(.*?)(?:JOIN|WHERE|GROUP|ORDER|$)'
            join_matches = re.finditer(join_pattern, query, re.IGNORECASE | re.DOTALL)
            for match in join_matches:
                join_condition = match.group(1)
                column_pattern = r'(\w+)\.(\w+)'
                matches = re.findall(column_pattern, join_condition)
                for table, column in matches:
                    if table in tables:
                        result[table]['join_columns'].add(column)

            # Extract GROUP BY columns
            group_by_match = re.search(r'GROUP\s+BY\s+(.*?)(?:ORDER|HAVING|LIMIT|;|$)', query, re.IGNORECASE | re.DOTALL)
            if group_by_match:
                group_by_clause = group_by_match.group(1)
                column_pattern = r'(\w+)\.(\w+)'
                matches = re.findall(column_pattern, group_by_clause)
                for table, column in matches:
                    if table in tables:
                        result[table]['group_by_columns'].add(column)

            # Extract ORDER BY columns
            order_by_match = re.search(r'ORDER\s+BY\s+(.*?)(?:LIMIT|;|$)', query, re.IGNORECASE | re.DOTALL)
            if order_by_match:
                order_by_clause = order_by_match.group(1)
                column_pattern = r'(\w+)\.(\w+)'
                matches = re.findall(column_pattern, order_by_clause)
                for table, column in matches:
                    if table in tables:
                        result[table]['order_by_columns'].add(column)

        except Exception as e:
            logger.warning(f"Error parsing query: {e}")

        return result

    def analyze_stored_procedure(self, sp_name: str, sp_definition: str):
        """
        Analyze a stored procedure and collect index recommendations.

        Args:
            sp_name: Name of the stored procedure
            sp_definition: SQL definition of the procedure
        """
        logger.info(f"\nAnalyzing stored procedure: {sp_name}")

        try:
            # Extract queries from procedure
            queries = self.extract_queries_from_procedure(sp_definition)
            logger.info(f"Found {len(queries)} queries in {sp_name}")

            # Analyze each query
            for query in queries:
                table_columns = self.parse_query_for_tables_and_columns(query)

                for table, columns_dict in table_columns.items():
                    # Determine database
                    table_db = self.identify_table_database(table)

                    self.index_recommendations[table]['database'] = table_db
                    self.index_recommendations[table]['sp_names'].add(sp_name)

                    # Aggregate column usage
                    for usage_type, columns in columns_dict.items():
                        self.index_recommendations[table][usage_type].update(columns)

        except Exception as e:
            logger.error(f"Error analyzing stored procedure {sp_name}: {e}")

    def check_existing_indexes(self, table_name: str, database: str) -> Set[str]:
        """
        Check which indexes already exist on a table.

        Args:
            table_name: Name of the table
            database: Database name

        Returns:
            Set of column combinations that are already indexed
        """
        existing_indexes = set()

        if database == 'evadb_stage':
            engine = eva_engine
            db_name = EVA_STAGE_DB_NAME
        else:
            engine = eva_main_engine
            db_name = EVA_DB_NAME

        try:
            query = text("""
                SELECT INDEX_NAME, GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) as columns
                FROM INFORMATION_SCHEMA.STATISTICS
                WHERE TABLE_SCHEMA = :db_name
                AND TABLE_NAME = :table_name
                GROUP BY INDEX_NAME
            """)

            with engine.connect() as conn:
                result = conn.execute(query, {
                    'db_name': db_name,
                    'table_name': table_name
                })

                for row in result:
                    columns = row[1]
                    existing_indexes.add(columns)

        except Exception as e:
            logger.error(f"Error checking indexes for {table_name}: {e}")

        return existing_indexes

    def estimate_performance_gain(self, table_name: str, columns: List[str],
                                   usage_type: str, sp_names: Set[str],
                                   recommendations: Dict) -> str:
        """
        Estimate the performance gain from adding an index.

        Args:
            table_name: Name of the table
            columns: List of columns in the index
            usage_type: Type of usage
            sp_names: Set of SP names that will benefit
            recommendations: The recommendations dict for this table

        Returns:
            String describing the estimated performance gain
        """
        database = recommendations['database']
        table_stats = self.get_table_statistics(table_name, database)
        row_count = table_stats['row_count']
        size_mb = table_stats['size_mb']

        # Calculate selectivity
        selectivities = []
        for col in columns:
            sel = self.get_column_selectivity(table_name, col, database)
            selectivities.append(sel)
        avg_selectivity = sum(selectivities) / len(selectivities) if selectivities else 0.5

        # Calculate priority score
        priority_score = 0

        # Table size factor
        if size_mb > 1000:
            priority_score += 100
        elif size_mb > 100:
            priority_score += 50
        elif size_mb > 10:
            priority_score += 20
        else:
            priority_score += 5

        # Selectivity factor
        if avg_selectivity > 0.8:
            priority_score += 80
            selectivity_label = "EXCELLENT"
        elif avg_selectivity > 0.5:
            priority_score += 50
            selectivity_label = "GOOD"
        elif avg_selectivity > 0.2:
            priority_score += 20
            selectivity_label = "MODERATE"
        else:
            priority_score += 5
            selectivity_label = "LOW"

        # Usage type factor
        if usage_type == 'JOIN':
            priority_score += 80
            base_gain = "70-95%"
        elif usage_type == 'WHERE':
            priority_score += 60
            base_gain = "50-85%"
        elif usage_type == 'GROUP BY':
            priority_score += 40
            base_gain = "40-70%"
        elif usage_type == 'ORDER BY':
            priority_score += 40
            base_gain = "40-70%"
        elif usage_type in ('INSERT', 'UPDATE'):
            priority_score += 30
            base_gain = "30-60%"
        else:
            priority_score += 20
            base_gain = "30-60%"

        # Composite index bonus
        if len(columns) > 1:
            priority_score += 20

        # Priority label
        if priority_score >= 200:
            priority = "CRITICAL"
        elif priority_score >= 150:
            priority = "VERY HIGH"
        elif priority_score >= 100:
            priority = "HIGH"
        elif priority_score >= 50:
            priority = "MEDIUM"
        else:
            priority = "LOW"

        sp_count = len(sp_names)
        details = []

        details.append(f"Priority: {priority} (score: {priority_score})")
        details.append(f"Performance: {base_gain} faster")
        details.append(f"Table: {row_count:,} rows, {size_mb:.1f} MB")
        details.append(f"Selectivity: {selectivity_label} ({avg_selectivity:.2%})")
        details.append(f"Benefits {sp_count} stored procedure(s)")

        return " | ".join(details)

    def generate_index_code(self) -> Dict[str, List[str]]:
        """
        Generate Python code for adding indexes.

        Returns:
            Dict with keys 'sql_helper' and 'upsert' containing lists of code lines
        """
        sql_helper_code = []
        upsert_code = []

        sql_helper_code.append("\n    # ==================================================")
        sql_helper_code.append(f"    # INDEXES FOR CLIENT {self.client_id} STORED PROCEDURES")
        sql_helper_code.append(f"    # Auto-generated by sql_sp_optimizer.py")
        sql_helper_code.append("    # ==================================================\n")

        upsert_code.append("\n        # ==================================================")
        upsert_code.append(f"        # INDEXES FOR CLIENT {self.client_id} STORED PROCEDURES")
        upsert_code.append(f"        # Auto-generated by sql_sp_optimizer.py")
        upsert_code.append("        # ==================================================\n")

        for table_name, recommendations in self.index_recommendations.items():
            if not any([
                recommendations['join_columns'],
                recommendations['where_columns'],
                recommendations['group_by_columns'],
                recommendations['order_by_columns']
            ]):
                continue

            database = recommendations['database']
            sp_names = recommendations['sp_names']

            # Determine function
            if database == 'evadb_stage':
                func_name = 'Add_StageId_Generic_Index'
            else:
                func_name = 'Add_ClientTable_Index'

            # Generate code for each type
            for usage_type, columns_set in [
                ('JOIN', recommendations['join_columns']),
                ('WHERE', recommendations['where_columns']),
                ('GROUP BY', recommendations['group_by_columns']),
                ('ORDER BY', recommendations['order_by_columns'])
            ]:
                if not columns_set:
                    continue

                columns_list = sorted(list(columns_set))
                columns_str = ','.join(columns_list)

                # Check if exists
                existing_indexes = self.check_existing_indexes(table_name, database)
                if columns_str in existing_indexes:
                    logger.info(f"Index already exists on {table_name}({columns_str})")
                    continue

                # Generate estimate
                performance_gain = self.estimate_performance_gain(
                    table_name, columns_list, usage_type, sp_names, recommendations
                )

                # Format SP names
                sp_list = ', '.join(sorted(list(sp_names)))

                comment = f"# {usage_type} index for {table_name}: {columns_str}"
                perf_comment = f"# Performance: {performance_gain}"
                sp_comment = f"# Benefits stored procedures: {sp_list}"
                code_line = f'{func_name}("{table_name}", "{columns_str}")'

                for code_list, indent in [(sql_helper_code, "    "), (upsert_code, "        ")]:
                    code_list.append(f"{indent}{comment}")
                    code_list.append(f"{indent}{perf_comment}")
                    code_list.append(f"{indent}{sp_comment}")
                    code_list.append(f"{indent}{code_line}")
                    code_list.append("")

        return {
            'sql_helper': sql_helper_code,
            'upsert': upsert_code
        }

    def print_analysis_summary(self):
        """Print summary of analysis findings."""
        print("\n" + "="*80)
        print("STORED PROCEDURE ANALYSIS SUMMARY")
        print("="*80)

        table_info = []
        for table_name, recommendations in self.index_recommendations.items():
            database = recommendations['database']
            stats = self.get_table_statistics(table_name, database)
            sp_count = len(recommendations['sp_names'])

            table_info.append({
                'table': table_name,
                'rows': stats['row_count'],
                'size_mb': stats['size_mb'],
                'sps': sp_count
            })

        table_info.sort(key=lambda x: x['size_mb'], reverse=True)

        print(f"\nTables Analyzed: {len(table_info)}")
        print(f"Total SPs: {len(set(sp for r in self.index_recommendations.values() for sp in r['sp_names']))}")
        print("\nTop Tables by Size:")
        print(f"{'Table':<50} {'Rows':>12} {'Size':>10} {'SPs':>6}")
        print("-" * 85)

        for i, info in enumerate(table_info[:10], 1):
            print(f"{info['table']:<50} {info['rows']:>12,} {info['size_mb']:>9.1f}M {info['sps']:>6}")

        total_size = sum(info['size_mb'] for info in table_info)
        total_rows = sum(info['rows'] for info in table_info)
        print(f"\nTotal Data Analyzed:")
        print(f"  Total Rows: {total_rows:,}")
        print(f"  Total Size: {total_size:.1f} MB ({total_size/1024:.2f} GB)")

        print("="*80)

    def run_analysis(self, auto_modify: bool = False):
        """Run the complete analysis workflow."""
        print(f"\n{'='*80}")
        print(f"SQL Stored Procedure Optimizer")
        print(f"{'='*80}")
        print(f"Client ID: {self.client_id}")
        print(f"SP Prefix: {self.sp_prefix}")
        print(f"Auto-modify: {auto_modify}")
        print(f"{'='*80}\n")

        logger.info(f"Starting analysis for {self.sp_prefix}* stored procedures...")

        # Get all stored procedures
        print("Step 1: Retrieving stored procedures from database...")
        procedures = self.get_all_stored_procedures()
        print(f"Step 1 complete: Found {len(procedures)} stored procedures\n")

        if not procedures:
            logger.warning(f"No stored procedures found with prefix {self.sp_prefix}")
            return

        logger.info(f"Found {len(procedures)} stored procedures to analyze")

        # Analyze each procedure
        print("Step 2: Analyzing stored procedure queries...")
        for i, (sp_name, sp_definition) in enumerate(procedures, 1):
            if i % 5 == 0 or i == len(procedures):
                print(f"  Progress: {i}/{len(procedures)} SPs analyzed ({100*i//len(procedures)}%)")
            self.analyze_stored_procedure(sp_name, sp_definition)
        print(f"Step 2 complete: Analyzed {len(procedures)} stored procedures\n")

        # Generate summary
        print("Step 3: Generating summary statistics...")
        self.print_analysis_summary()
        print()

        # Generate code
        print("Step 4: Generating index recommendations...")
        logger.info("\n" + "="*80)
        logger.info("GENERATING INDEX RECOMMENDATIONS")
        logger.info("="*80 + "\n")

        code = self.generate_index_code()

        if not code['sql_helper'] or len(code['sql_helper']) <= 4:
            logger.info("No new indexes needed - all required indexes already exist!")
            return

        # Print results
        print("\n" + "="*80)
        print("CODE TO ADD TO sql_helper.py (CheckAndInitIndexesForXero method)")
        print("="*80)
        for line in code['sql_helper']:
            print(line)

        print("\n" + "="*80)
        print("CODE TO ADD TO XEROBLUE - UPSERT.py (CheckAndInitIndexes method)")
        print("="*80)
        for line in code['upsert']:
            print(line)

        # Save to files
        with open('/home/jepilor/etl 1.0/etl_packages/sp_index_recommendations_sql_helper.txt', 'w') as f:
            f.write('\n'.join(code['sql_helper']))

        with open('/home/jepilor/etl 1.0/etl_packages/sp_index_recommendations_upsert.txt', 'w') as f:
            f.write('\n'.join(code['upsert']))

        logger.info("\nRecommendations saved to:")
        logger.info("  - sp_index_recommendations_sql_helper.txt")
        logger.info("  - sp_index_recommendations_upsert.txt")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Analyze stored procedures and recommend indexes for performance optimization'
    )
    parser.add_argument(
        '--client_id',
        type=int,
        default=1834,
        help='Client ID (default: 1834)'
    )
    parser.add_argument(
        '--auto-modify',
        action='store_true',
        help='Automatically modify source files with recommendations'
    )

    args = parser.parse_args()

    # Create analyzer and run
    analyzer = StoredProcedureAnalyzer(args.client_id)
    analyzer.run_analysis(auto_modify=args.auto_modify)


if __name__ == '__main__':
    main()
