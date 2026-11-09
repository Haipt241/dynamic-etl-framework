"""
SQL Views Optimizer Script

This script analyzes views for a given client and recommends indexes
to improve query performance. It parses view definitions to identify
columns used in JOINs, WHERE, GROUP BY, and ORDER BY clauses.

Usage:
    python sql_views_optimizer.py --client_id 1834 --firmcode SWAU
"""

print("Starting SQL Views Optimizer...")

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
# These are required by sql_helper.py but not used by the optimizer
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


class ViewAnalyzer:
    """Analyzes SQL views to identify columns that need indexing."""

    def __init__(self, client_id: int, firmcode: str):
        self.client_id = client_id
        self.firmcode = firmcode
        self.view_prefix = f"{firmcode}_CLIENT{client_id}_"
        self.index_recommendations = defaultdict(lambda: {
            'join_columns': set(),
            'where_columns': set(),
            'group_by_columns': set(),
            'order_by_columns': set(),
            'view_names': set(),
            'database': None,  # Will be 'evadb' or 'evadb_stage'
            'explain_results': [],  # Store EXPLAIN results
            'query_cost': 0,  # Aggregate query cost
            'uses_filesort': False,  # Does any query use filesort?
            'uses_temp_table': False,  # Does any query use temp table?
        })
        # Cache for table statistics
        self.table_stats = {}  # {table_name: {row_count, size_mb, columns_stats}}
        self.column_selectivity = {}  # {(table, column): selectivity_ratio}

    def get_all_views(self) -> List[Tuple[str, str, str]]:
        """
        Retrieve all views for the client from both databases.

        Returns:
            List of tuples (view_name, view_definition, database_name)
        """
        views = []

        # Query views from both eva_main_engine (evadb) and eva_engine (evadb_stage)
        engines = [
            (eva_main_engine, EVA_DB_NAME, 'evadb'),
            (eva_engine, EVA_STAGE_DB_NAME, 'evadb_stage')
        ]

        for engine, db_name, db_type in engines:
            try:
                logger.info(f"Querying views from {db_name} (type: {db_type})...")
                print(f"Querying views from {db_name} with prefix: {self.view_prefix}%")

                query = text("""
                    SELECT TABLE_NAME, VIEW_DEFINITION
                    FROM INFORMATION_SCHEMA.VIEWS
                    WHERE TABLE_SCHEMA = :db_name
                    AND TABLE_NAME LIKE :view_prefix
                    ORDER BY TABLE_NAME
                """)

                with engine.connect() as conn:
                    result = conn.execute(query, {
                        'db_name': db_name,
                        'view_prefix': f"{self.view_prefix}%"
                    })

                    row_count = 0
                    for row in result:
                        view_name = row[0]
                        view_definition = row[1]
                        views.append((view_name, view_definition, db_type))
                        logger.info(f"Found view: {view_name} in {db_type}")
                        print(f"Found view: {view_name}")
                        row_count += 1

                    if row_count == 0:
                        print(f"No views found in {db_name}")
                        logger.info(f"No views found in {db_name}")

            except Exception as e:
                logger.error(f"Error querying views from {db_name}: {e}")
                print(f"ERROR querying {db_name}: {e}")
                import traceback
                traceback.print_exc()

        return views

    def extract_table_name_from_identifier(self, identifier_str: str) -> Tuple[str, str]:
        """
        Extract table name and column from a qualified identifier.

        Args:
            identifier_str: String like 'table.column' or 'column'

        Returns:
            Tuple of (table_name, column_name)
        """
        parts = identifier_str.split('.')
        if len(parts) == 2:
            return parts[0].strip('`'), parts[1].strip('`')
        return None, parts[0].strip('`')

    def parse_join_conditions(self, parsed_sql) -> Dict[str, Set[str]]:
        """
        Extract columns used in JOIN conditions.

        Returns:
            Dict mapping table names to sets of column names used in JOINs
        """
        join_columns = defaultdict(set)

        def extract_from_token(token):
            if token.ttype is Keyword and 'JOIN' in token.value.upper():
                return True
            return False

        # Find JOIN clauses
        join_found = False
        for token in parsed_sql.flatten():
            if token.ttype is Keyword and 'JOIN' in token.value.upper():
                join_found = True
            elif join_found and token.ttype is Keyword and token.value.upper() == 'ON':
                # Next tokens should be the join condition
                continue
            elif join_found and '=' in str(token):
                # Parse the join condition
                condition = str(token)
                # Extract both sides of the equality
                sides = condition.split('=')
                for side in sides:
                    table, column = self.extract_table_name_from_identifier(side.strip())
                    if table:
                        join_columns[table].add(column)

        return join_columns

    def parse_where_conditions(self, parsed_sql) -> Dict[str, Set[str]]:
        """
        Extract columns used in WHERE conditions.

        Returns:
            Dict mapping table names to sets of column names used in WHERE
        """
        where_columns = defaultdict(set)

        for token in parsed_sql.tokens:
            if isinstance(token, Where):
                # Extract identifiers from WHERE clause
                where_str = str(token)
                # Simple regex to find table.column patterns
                pattern = r'(\w+)\.(\w+)'
                matches = re.findall(pattern, where_str)
                for table, column in matches:
                    where_columns[table].add(column)

        return where_columns

    def parse_group_by(self, parsed_sql) -> Dict[str, Set[str]]:
        """
        Extract columns used in GROUP BY.

        Returns:
            Dict mapping table names to sets of column names
        """
        group_by_columns = defaultdict(set)

        # Find GROUP BY clause
        sql_str = str(parsed_sql)
        group_by_match = re.search(r'GROUP\s+BY\s+(.*?)(?:ORDER|HAVING|LIMIT|$)',
                                   sql_str, re.IGNORECASE | re.DOTALL)

        if group_by_match:
            group_by_clause = group_by_match.group(1)
            # Extract table.column patterns
            pattern = r'(\w+)\.(\w+)'
            matches = re.findall(pattern, group_by_clause)
            for table, column in matches:
                group_by_columns[table].add(column)

        return group_by_columns

    def parse_order_by(self, parsed_sql) -> Dict[str, Set[str]]:
        """
        Extract columns used in ORDER BY.

        Returns:
            Dict mapping table names to sets of column names
        """
        order_by_columns = defaultdict(set)

        # Find ORDER BY clause
        sql_str = str(parsed_sql)
        order_by_match = re.search(r'ORDER\s+BY\s+(.*?)(?:LIMIT|$)',
                                   sql_str, re.IGNORECASE | re.DOTALL)

        if order_by_match:
            order_by_clause = order_by_match.group(1)
            # Extract table.column patterns
            pattern = r'(\w+)\.(\w+)'
            matches = re.findall(pattern, order_by_clause)
            for table, column in matches:
                order_by_columns[table].add(column)

        return order_by_columns

    def identify_table_database(self, table_name: str) -> str:
        """
        Determine if a table belongs to evadb or evadb_stage.

        Args:
            table_name: Name of the table

        Returns:
            'evadb' or 'evadb_stage'
        """
        # Stage tables typically have 'stage' in their name
        if 'stage' in table_name.lower():
            return 'evadb_stage'
        else:
            return 'evadb'

    def get_table_statistics(self, table_name: str, database: str) -> Dict:
        """
        Get table statistics including size, row count, and column cardinality.

        Args:
            table_name: Name of the table
            database: Database name ('evadb' or 'evadb_stage')

        Returns:
            Dict with row_count, size_mb, and column stats
        """
        # Check cache first
        cache_key = f"{database}.{table_name}"
        if cache_key in self.table_stats:
            return self.table_stats[cache_key]

        # Determine which engine to use
        if database == 'evadb_stage':
            engine = eva_engine
            db_name = EVA_STAGE_DB_NAME
        else:
            engine = eva_main_engine
            db_name = EVA_DB_NAME

        stats = {
            'row_count': 0,
            'size_mb': 0.0,
            'columns': {}
        }

        try:
            # Get table size and row count
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

        # Cache the result
        self.table_stats[cache_key] = stats
        return stats

    def get_column_selectivity(self, table_name: str, column_name: str, database: str) -> float:
        """
        Calculate column selectivity (cardinality ratio).
        Selectivity = DISTINCT(column) / COUNT(*)
        Higher selectivity = better index candidate

        Args:
            table_name: Name of the table
            column_name: Name of the column
            database: Database name

        Returns:
            Selectivity ratio (0.0 to 1.0)
        """
        # Check cache
        cache_key = (database, table_name, column_name)
        if cache_key in self.column_selectivity:
            return self.column_selectivity[cache_key]

        # Determine which engine to use
        if database == 'evadb_stage':
            engine = eva_engine
            db_name = EVA_STAGE_DB_NAME
        else:
            engine = eva_main_engine
            db_name = EVA_DB_NAME

        selectivity = 0.0

        try:
            # Use INFORMATION_SCHEMA for quick stats
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
                    selectivity = cardinality / total_rows if total_rows > 0 else 0.0
                else:
                    # Fallback: run actual query (slower but accurate)
                    count_query = text(f"""
                        SELECT
                            COUNT(DISTINCT `{column_name}`) as distinct_count,
                            COUNT(*) as total_count
                        FROM `{db_name}`.`{table_name}`
                        LIMIT 1
                    """)
                    result = conn.execute(count_query).fetchone()
                    if result and result[1] > 0:
                        selectivity = result[0] / result[1]

            logger.debug(f"Column {table_name}.{column_name} selectivity: {selectivity:.4f}")

        except Exception as e:
            logger.warning(f"Error calculating selectivity for {table_name}.{column_name}: {e}")
            # Default to moderate selectivity if we can't calculate
            selectivity = 0.5

        # Cache the result
        self.column_selectivity[cache_key] = selectivity
        return selectivity

    def run_explain_analysis(self, view_name: str, database: str) -> Dict:
        """
        Run EXPLAIN on a view to get actual query plan insights.

        Args:
            view_name: Name of the view
            database: Database name

        Returns:
            Dict with explain results and key metrics
        """
        # Determine which engine to use
        if database == 'evadb_stage':
            engine = eva_engine
        else:
            engine = eva_main_engine

        explain_info = {
            'cost': 0,
            'uses_filesort': False,
            'uses_temp_table': False,
            'full_table_scans': [],
            'missing_indexes': [],
            'rows_examined': 0
        }

        try:
            # Run EXPLAIN on the view
            explain_query = text(f"EXPLAIN SELECT * FROM `{view_name}` LIMIT 1")

            with engine.connect() as conn:
                result = conn.execute(explain_query)

                for row in result:
                    # Parse EXPLAIN output
                    # row typically has: id, select_type, table, type, possible_keys, key, key_len, ref, rows, Extra
                    if len(row) >= 10:
                        table = row[2]
                        access_type = row[3]
                        possible_keys = row[4]
                        key_used = row[5]
                        rows_value = row[8]
                        extra = row[9] or ''

                        # Safely convert rows to int - handle non-numeric values
                        try:
                            if rows_value and str(rows_value).strip():
                                # Try to parse as integer
                                rows_int = int(str(rows_value).strip())
                                explain_info['rows_examined'] += rows_int
                            # else: rows is None, empty, or whitespace - skip it
                        except (ValueError, TypeError):
                            # rows contains non-numeric value like 'const', 'a.invoiceid', or table reference
                            # These are valid EXPLAIN output for certain query types
                            # Use a default estimate based on access type
                            if access_type == 'const':
                                explain_info['rows_examined'] += 1  # Constant access = 1 row
                            elif access_type == 'eq_ref':
                                explain_info['rows_examined'] += 1  # Unique key lookup = 1 row
                            elif access_type == 'ref':
                                explain_info['rows_examined'] += 10  # Index range = estimate 10 rows
                            elif access_type in ('ALL', 'index'):
                                explain_info['rows_examined'] += 1000  # Full scan = estimate 1000 rows
                            else:
                                explain_info['rows_examined'] += 100  # Default estimate

                        # Check for full table scan
                        if access_type in ('ALL', 'index'):
                            explain_info['full_table_scans'].append(table)

                        # Check for filesort
                        if 'filesort' in str(extra).lower():
                            explain_info['uses_filesort'] = True

                        # Check for temp table
                        if 'temporary' in str(extra).lower():
                            explain_info['uses_temp_table'] = True

                        # Check for missing indexes
                        if possible_keys and not key_used:
                            explain_info['missing_indexes'].append(table)

            # Estimate cost (simplified: rows examined is a proxy for cost)
            explain_info['cost'] = explain_info['rows_examined']

            logger.debug(f"EXPLAIN {view_name}: {explain_info['rows_examined']:,} rows, "
                        f"filesort={explain_info['uses_filesort']}, "
                        f"temp={explain_info['uses_temp_table']}")

        except Exception as e:
            logger.warning(f"Error running EXPLAIN on {view_name}: {e}")

        return explain_info

    def analyze_view(self, view_name: str, view_definition: str, database: str):
        """
        Analyze a single view and collect index recommendations.

        Args:
            view_name: Name of the view
            view_definition: SQL definition of the view
            database: Database where the view exists ('evadb' or 'evadb_stage')
        """
        logger.info(f"\nAnalyzing view: {view_name}")

        try:
            # Run EXPLAIN analysis first
            explain_result = self.run_explain_analysis(view_name, database)

            # Parse the SQL
            parsed = sqlparse.parse(view_definition)[0]

            # Extract columns from different clauses
            join_columns = self.parse_join_conditions(parsed)
            where_columns = self.parse_where_conditions(parsed)
            group_by_columns = self.parse_group_by(parsed)
            order_by_columns = self.parse_order_by(parsed)

            # Aggregate recommendations per table
            all_tables = set(
                list(join_columns.keys()) +
                list(where_columns.keys()) +
                list(group_by_columns.keys()) +
                list(order_by_columns.keys())
            )

            for table in all_tables:
                # Determine which database the table belongs to
                table_db = self.identify_table_database(table)

                self.index_recommendations[table]['database'] = table_db
                self.index_recommendations[table]['view_names'].add(view_name)
                self.index_recommendations[table]['explain_results'].append(explain_result)
                self.index_recommendations[table]['query_cost'] += explain_result['cost']

                # Track filesort and temp table usage
                if explain_result['uses_filesort']:
                    self.index_recommendations[table]['uses_filesort'] = True
                if explain_result['uses_temp_table']:
                    self.index_recommendations[table]['uses_temp_table'] = True

                if table in join_columns:
                    self.index_recommendations[table]['join_columns'].update(join_columns[table])
                if table in where_columns:
                    self.index_recommendations[table]['where_columns'].update(where_columns[table])
                if table in group_by_columns:
                    self.index_recommendations[table]['group_by_columns'].update(group_by_columns[table])
                if table in order_by_columns:
                    self.index_recommendations[table]['order_by_columns'].update(order_by_columns[table])

        except Exception as e:
            logger.error(f"Error analyzing view {view_name}: {e}")

    def check_existing_indexes(self, table_name: str, database: str) -> Set[str]:
        """
        Check which indexes already exist on a table.

        Args:
            table_name: Name of the table
            database: Database name ('evadb' or 'evadb_stage')

        Returns:
            Set of column combinations that are already indexed (e.g., 'col1,col2')
        """
        existing_indexes = set()

        # Determine which engine to use
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
                    index_name = row[0]
                    columns = row[1]
                    existing_indexes.add(columns)
                    logger.debug(f"Existing index on {table_name}: {index_name} ({columns})")

        except Exception as e:
            logger.error(f"Error checking indexes for {table_name}: {e}")

        return existing_indexes

    def estimate_performance_gain(self, table_name: str, columns: List[str],
                                   usage_type: str, view_names: Set[str],
                                   recommendations: Dict) -> str:
        """
        Estimate the performance gain from adding an index using advanced metrics.

        Args:
            table_name: Name of the table
            columns: List of columns in the index
            usage_type: Type of usage (JOIN, WHERE, GROUP BY, ORDER BY)
            view_names: Set of view names that will benefit
            recommendations: The recommendations dict for this table

        Returns:
            String describing the estimated performance gain
        """
        # Get table statistics
        database = recommendations['database']
        table_stats = self.get_table_statistics(table_name, database)
        row_count = table_stats['row_count']
        size_mb = table_stats['size_mb']

        # Calculate average selectivity for the columns
        selectivities = []
        for col in columns:
            sel = self.get_column_selectivity(table_name, col, database)
            selectivities.append(sel)

        avg_selectivity = sum(selectivities) / len(selectivities) if selectivities else 0.5

        # Get EXPLAIN insights
        query_cost = recommendations.get('query_cost', 0)
        uses_filesort = recommendations.get('uses_filesort', False)
        uses_temp_table = recommendations.get('uses_temp_table', False)

        # Calculate priority score (higher = more important)
        priority_score = 0

        # Factor 1: Table size (larger tables benefit more)
        if size_mb > 1000:  # > 1GB
            priority_score += 100
        elif size_mb > 100:  # > 100MB
            priority_score += 50
        elif size_mb > 10:  # > 10MB
            priority_score += 20
        else:
            priority_score += 5

        # Factor 2: Selectivity (higher selectivity = better index)
        if avg_selectivity > 0.8:  # Very selective
            priority_score += 80
            selectivity_label = "EXCELLENT"
        elif avg_selectivity > 0.5:  # Good selectivity
            priority_score += 50
            selectivity_label = "GOOD"
        elif avg_selectivity > 0.2:  # Moderate
            priority_score += 20
            selectivity_label = "MODERATE"
        else:  # Low selectivity
            priority_score += 5
            selectivity_label = "LOW"

        # Factor 3: Query cost (higher cost = more benefit from index)
        if query_cost > 100000:
            priority_score += 100
        elif query_cost > 10000:
            priority_score += 50
        elif query_cost > 1000:
            priority_score += 20

        # Factor 4: Usage type
        if usage_type == 'JOIN':
            priority_score += 80
            base_gain = "70-95%"
        elif usage_type == 'WHERE':
            priority_score += 60
            base_gain = "50-85%"
        elif usage_type == 'GROUP BY':
            priority_score += 40
            base_gain = "40-70%"
            if uses_filesort:
                priority_score += 30
                base_gain = "60-80% (eliminates filesort)"
        elif usage_type == 'ORDER BY':
            priority_score += 40
            base_gain = "40-70%"
            if uses_filesort:
                priority_score += 30
                base_gain = "60-80% (eliminates filesort)"
        else:
            priority_score += 20
            base_gain = "30-60%"

        # Factor 5: Composite index bonus
        if len(columns) > 1:
            priority_score += 20

        # Determine overall priority
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

        # Build detailed gain estimate
        view_count = len(view_names)
        details = []

        details.append(f"Priority: {priority} (score: {priority_score})")
        details.append(f"Performance: {base_gain} faster")
        details.append(f"Table: {row_count:,} rows, {size_mb:.1f} MB")
        details.append(f"Selectivity: {selectivity_label} ({avg_selectivity:.2%})")

        if query_cost > 0:
            details.append(f"Query cost: {query_cost:,} rows examined")

        if uses_filesort:
            details.append("Eliminates FILESORT")
        if uses_temp_table:
            details.append("Eliminates TEMP TABLE")

        details.append(f"Benefits {view_count} view(s)")

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
        sql_helper_code.append(f"    # INDEXES FOR CLIENT {self.client_id} - {self.firmcode}")
        sql_helper_code.append(f"    # Auto-generated by sql_views_optimizer.py")
        sql_helper_code.append("    # ==================================================\n")

        upsert_code.append("\n        # ==================================================")
        upsert_code.append(f"        # INDEXES FOR CLIENT {self.client_id} - {self.firmcode}")
        upsert_code.append(f"        # Auto-generated by sql_views_optimizer.py")
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
            view_names = recommendations['view_names']

            # Determine which function to use
            if database == 'evadb_stage':
                func_name = 'Add_StageId_Generic_Index'
            else:
                func_name = 'Add_ClientTable_Index'

            # Generate code for each type of column usage
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

                # Check if index already exists
                existing_indexes = self.check_existing_indexes(table_name, database)
                if columns_str in existing_indexes:
                    logger.info(f"Index already exists on {table_name}({columns_str})")
                    continue

                # Generate performance estimate with advanced metrics
                performance_gain = self.estimate_performance_gain(
                    table_name, columns_list, usage_type, view_names, recommendations
                )

                # Format view names
                view_list = ', '.join(sorted(list(view_names)))

                # Generate code lines
                comment = f"# {usage_type} index for {table_name}: {columns_str}"
                perf_comment = f"# Performance: {performance_gain}"
                views_comment = f"# Benefits views: {view_list}"
                code_line = f'{func_name}("{table_name}", "{columns_str}")'

                # Add to appropriate lists
                for code_list, indent in [(sql_helper_code, "    "), (upsert_code, "        ")]:
                    code_list.append(f"{indent}{comment}")
                    code_list.append(f"{indent}{perf_comment}")
                    code_list.append(f"{indent}{views_comment}")
                    code_list.append(f"{indent}{code_line}")
                    code_list.append("")

        return {
            'sql_helper': sql_helper_code,
            'upsert': upsert_code
        }

    def modify_sql_helper_file(self, code_lines: List[str]):
        """
        Modify sql_helper.py to add new index recommendations.

        Args:
            code_lines: List of code lines to add
        """
        file_path = '/home/jepilor/etl 1.0/etl_packages/sql_helper.py'

        try:
            with open(file_path, 'r') as f:
                content = f.read()

            # Find the CheckAndInitIndexesForXero function
            # Insert before the except block at the end
            insertion_marker = '    except TypeError as e:'

            if insertion_marker not in content:
                logger.error("Could not find insertion point in sql_helper.py")
                return False

            # Insert the new code
            new_content = content.replace(
                insertion_marker,
                '\n'.join(code_lines) + '\n\n' + insertion_marker
            )

            # Write back to file
            with open(file_path, 'w') as f:
                f.write(new_content)

            logger.info(f"Successfully modified {file_path}")
            return True

        except Exception as e:
            logger.error(f"Error modifying sql_helper.py: {e}")
            return False

    def modify_upsert_file(self, code_lines: List[str]):
        """
        Modify XEROBLUE - UPSERT.py to add new index recommendations.

        Args:
            code_lines: List of code lines to add
        """
        file_path = '/home/jepilor/etl 1.0/etl_packages/XEROBLUE - UPSERT.py'

        try:
            with open(file_path, 'r') as f:
                content = f.read()

            # Find the CheckAndInitIndexes function
            # Insert before the except block at the end
            insertion_marker = '    except TypeError as e:'

            if insertion_marker not in content:
                logger.error("Could not find insertion point in XEROBLUE - UPSERT.py")
                return False

            # Insert the new code
            new_content = content.replace(
                insertion_marker,
                '\n'.join(code_lines) + '\n\n' + insertion_marker
            )

            # Write back to file
            with open(file_path, 'w') as f:
                f.write(new_content)

            logger.info(f"Successfully modified {file_path}")
            return True

        except Exception as e:
            logger.error(f"Error modifying XEROBLUE - UPSERT.py: {e}")
            return False

    def print_analysis_summary(self):
        """Print a summary of the analysis findings."""
        print("\n" + "="*80)
        print("ANALYSIS SUMMARY")
        print("="*80)

        # Collect table statistics
        table_info = []
        for table_name, recommendations in self.index_recommendations.items():
            database = recommendations['database']
            stats = self.get_table_statistics(table_name, database)
            query_cost = recommendations.get('query_cost', 0)
            view_count = len(recommendations['view_names'])

            table_info.append({
                'table': table_name,
                'rows': stats['row_count'],
                'size_mb': stats['size_mb'],
                'query_cost': query_cost,
                'views': view_count
            })

        # Sort by size (largest first)
        table_info.sort(key=lambda x: x['size_mb'], reverse=True)

        print(f"\nTables Analyzed: {len(table_info)}")
        print(f"Total Views: {len(set(v for r in self.index_recommendations.values() for v in r['view_names']))}")
        print("\nTop Tables by Size:")
        print(f"{'Table':<50} {'Rows':>12} {'Size':>10} {'Views':>6} {'Cost':>12}")
        print("-" * 95)

        for i, info in enumerate(table_info[:10], 1):
            print(f"{info['table']:<50} {info['rows']:>12,} {info['size_mb']:>9.1f}M {info['views']:>6} {info['query_cost']:>12,}")

        # Count filesort and temp table usage
        filesort_tables = sum(1 for r in self.index_recommendations.values() if r.get('uses_filesort'))
        temp_table_tables = sum(1 for r in self.index_recommendations.values() if r.get('uses_temp_table'))

        print(f"\nPerformance Issues Detected:")
        print(f"  Tables using FILESORT: {filesort_tables}")
        print(f"  Tables using TEMP TABLE: {temp_table_tables}")

        # Calculate total data size
        total_size = sum(info['size_mb'] for info in table_info)
        total_rows = sum(info['rows'] for info in table_info)
        print(f"\nTotal Data Analyzed:")
        print(f"  Total Rows: {total_rows:,}")
        print(f"  Total Size: {total_size:.1f} MB ({total_size/1024:.2f} GB)")

        print("="*80)

    def run_analysis(self, auto_modify: bool = False):
        """
        Run the complete analysis workflow.

        Args:
            auto_modify: If True, automatically modify the source files
        """
        print(f"\n{'='*80}")
        print(f"SQL Views Optimizer")
        print(f"{'='*80}")
        print(f"Client ID: {self.client_id}")
        print(f"Firm Code: {self.firmcode}")
        print(f"View Prefix: {self.view_prefix}")
        print(f"Auto-modify: {auto_modify}")
        print(f"{'='*80}\n")

        logger.info(f"Starting analysis for {self.view_prefix}* views...")

        # Get all views
        print("Step 1: Retrieving views from database...")
        views = self.get_all_views()
        print(f"Step 1 complete: Found {len(views)} views\n")

        if not views:
            logger.warning(f"No views found with prefix {self.view_prefix}")
            return

        logger.info(f"Found {len(views)} views to analyze")

        # Analyze each view with progress tracking
        print("Step 2: Running advanced analysis (EXPLAIN + Selectivity + Table Stats)...")
        for i, (view_name, view_definition, database) in enumerate(views, 1):
            if i % 10 == 0 or i == len(views):
                print(f"  Progress: {i}/{len(views)} views analyzed ({100*i//len(views)}%)")
            self.analyze_view(view_name, view_definition, database)
        print(f"Step 2 complete: Analyzed {len(views)} views with advanced metrics\n")

        # Generate summary statistics
        print("Step 3: Generating summary statistics...")
        self.print_analysis_summary()
        print()

        # Generate code
        print("Step 4: Generating index recommendations...")
        logger.info("\n" + "="*80)
        logger.info("GENERATING INDEX RECOMMENDATIONS")
        logger.info("="*80 + "\n")

        code = self.generate_index_code()

        # Check if there are any recommendations
        if not code['sql_helper'] or len(code['sql_helper']) <= 4:  # Just the header
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

        # Save to files for easy reference
        with open('/home/jepilor/etl 1.0/etl_packages/index_recommendations_sql_helper.txt', 'w') as f:
            f.write('\n'.join(code['sql_helper']))

        with open('/home/jepilor/etl 1.0/etl_packages/index_recommendations_upsert.txt', 'w') as f:
            f.write('\n'.join(code['upsert']))

        logger.info("\nRecommendations saved to:")
        logger.info("  - index_recommendations_sql_helper.txt")
        logger.info("  - index_recommendations_upsert.txt")

        # Auto-modify files if requested
        if auto_modify:
            logger.info("\n" + "="*80)
            logger.info("AUTO-MODIFYING SOURCE FILES")
            logger.info("="*80 + "\n")

            success_sql_helper = self.modify_sql_helper_file(code['sql_helper'])
            success_upsert = self.modify_upsert_file(code['upsert'])

            if success_sql_helper and success_upsert:
                logger.info("\nSuccessfully modified both files!")
                logger.info("Please review the changes and test thoroughly.")
            else:
                logger.error("\nFailed to modify one or more files.")
                logger.info("Please manually add the code from the generated .txt files.")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Analyze SQL views and recommend indexes for performance optimization'
    )
    parser.add_argument(
        '--client_id',
        type=int,
        default=1834,
        help='Client ID (default: 1834)'
    )
    parser.add_argument(
        '--firmcode',
        type=str,
        default='SWAU',
        help='Firm code (default: SWAU)'
    )
    parser.add_argument(
        '--auto-modify',
        action='store_true',
        help='Automatically modify source files with recommendations'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show recommendations without modifying files (default behavior)'
    )

    args = parser.parse_args()

    # Create analyzer and run
    analyzer = ViewAnalyzer(args.client_id, args.firmcode)
    analyzer.run_analysis(auto_modify=args.auto_modify)


if __name__ == '__main__':
    main()
