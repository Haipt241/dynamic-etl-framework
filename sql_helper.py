import sys
from datetime import datetime, timezone

from dotenv import load_dotenv

import config
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError, ProgrammingError, OperationalError
from sqlalchemy.pool import QueuePool
import pymysql
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type
import pandas as pd
import logging
import os
import json
import boto3
from botocore.exceptions import ClientError
from datetime import datetime
import traceback

from utils import get_acronym, format_timestamp
logger = logging.getLogger(__name__)
logging.info("Logging to stdout")
env_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '.env')
load_dotenv(env_path)

# Import query monitoring client
try:
    from query_monitoring_client import QueryMonitoringClient
    from container_monitoring_client import ContainerMonitoringClient
    QUERY_MONITORING_AVAILABLE = True
except ImportError:
    QUERY_MONITORING_AVAILABLE = False
    logger.warning("Query monitoring client not available")

# SQL Error Logging Setup
SQL_ERROR_LOG_DIR = os.path.join(os.path.dirname(__file__), 'logs', 'sql_errors')
os.makedirs(SQL_ERROR_LOG_DIR, exist_ok=True)

# Global cost tracker instance (set by dynamic integration)
cost_tracker = None

def track_cost_operation(operation_type: str, rows_affected: int = 0):
    """
    Track database operations for cost calculation

    Args:
        operation_type (str): 'INSERT', 'UPDATE', 'SELECT', 'STORED_PROC'
        rows_affected (int): Number of rows affected by operation
    """
    global cost_tracker
    if cost_tracker:
        try:
            cost_tracker.track_operation(operation_type, rows_affected)
        except Exception as e:
            # Silently fail cost tracking - don't break the main operation
            print(f"[WARNING] Cost tracking error: {e}")
    # If cost_tracker is None, silently continue without tracking

def cleanup_all_connections():
    """
    Dispose all SQLAlchemy engine connection pools.

    CRITICAL: Must be called in finally blocks of top-level orchestrators
    (run_full_sync, run_dynamic_integration.py) to prevent connection leaks
    that cause Aurora ACUs to stay high after script completion.

    This closes all pooled connections and releases database resources immediately.
    Without this, connections stay in "Sleep" state and consume ACUs indefinitely.

    Usage:
        try:
            # Main ETL logic
            pass
        finally:
            cleanup_all_connections()
    """
    global eva_engine, eva_main_engine, cms_engine

    try:
        logger.info("🔒 Cleaning up all database connections...")

        # Log final connection pool stats before disposal
        for engine_name, engine in [
            ('eva_engine', eva_engine),
            ('eva_main_engine', eva_main_engine),
            ('cms_engine', cms_engine)
        ]:
            if engine:
                try:
                    pool = engine.pool
                    checked_in = pool.checkedin()
                    total = pool.size()
                    logger.info(f"  {engine_name}: {checked_in} checked in, {total} total in pool")
                except Exception as e:
                    logger.debug(f"  Could not get stats for {engine_name}: {e}")

        # Dispose all engine pools
        if eva_engine:
            eva_engine.dispose()
            logger.info("  ✓ eva_engine disposed")

        if eva_main_engine:
            eva_main_engine.dispose()
            logger.info("  ✓ eva_main_engine disposed")

        if cms_engine:
            cms_engine.dispose()
            logger.info("  ✓ cms_engine disposed")

        logger.info("[OK] All database connections cleaned up successfully")

    except Exception as e:
        logger.error(f"[ERROR] Error during connection cleanup: {e}")
        # Don't raise - this is cleanup, we want script to exit gracefully

def log_connection_ids(container_info=None):
    """
    Log MySQL connection IDs for tracking which containers own which connections.

    This helps correlate PROCESSLIST with running containers for debugging ACU issues.

    Args:
        container_info: Dict with container_id, client_id, org_id for logging

    Returns:
        dict: Connection IDs for each engine
    """
    global eva_engine, eva_main_engine, cms_engine

    try:
        connection_ids = {}

        # Get connection ID from each engine
        for engine_name, engine in [
            ('eva_engine', eva_engine),
            ('eva_main_engine', eva_main_engine),
            ('cms_engine', cms_engine)
        ]:
            if engine:
                try:
                    with engine.connect() as conn:
                        result = conn.execute(text("SELECT CONNECTION_ID()"))
                        conn_id = result.scalar()
                        connection_ids[engine_name] = conn_id
                except Exception as e:
                    logger.warning(f"Failed to get connection ID for {engine_name}: {e}")

        # Log with container context
        if container_info:
            logger.info(
                f"[DATA] Container {container_info.get('container_id', 'unknown')} | "
                f"Client {container_info.get('client_id', 'unknown')} | "
                f"Org {container_info.get('org_id', 'unknown')} | "
                f"MySQL Connection IDs: {connection_ids}"
            )
        else:
            logger.info(f"[DATA] MySQL Connection IDs: {connection_ids}")

        return connection_ids

    except Exception as e:
        logger.warning(f"Failed to log connection IDs: {e}")
        return {}

# ============================================================================
# AWS-ONLY DATABASE MODE - Azure MySQL is DEPRECATED
# ============================================================================
USE_AWS_DB = os.getenv('USE_AWS_DB', 'False').lower() in ('true', '1', 'yes')

# CRITICAL VALIDATION: Enforce AWS-only mode
if not USE_AWS_DB:
    raise RuntimeError(
        "[ERROR] CRITICAL ERROR: Azure MySQL is deprecated and cannot be used.\n"
        "   All databases have been migrated to AWS RDS Aurora.\n"
        "   \n"
        "   REQUIRED: Set environment variable USE_AWS_DB=True\n"
        "   \n"
        "   Examples:\n"
        "   - PowerShell: $env:USE_AWS_DB='True'\n"
        "   - Bash: export USE_AWS_DB=True\n"
        "   - Python: os.environ['USE_AWS_DB'] = 'True'\n"
        "   - Docker: -e USE_AWS_DB=True\n"
        "   \n"
        "   If you believe this is an error, contact DevOps immediately."
    )

logger.info(f"[OK] Database mode: AWS RDS Aurora (Azure MySQL deprecated)")

# Set AWS credentials from config if not already in environment
if USE_AWS_DB:
    if not os.getenv('AWS_ACCESS_KEY_ID') and hasattr(config, 'AWS_ACCESS_KEY_ID'):
        os.environ['AWS_ACCESS_KEY_ID'] = config.AWS_ACCESS_KEY_ID
    if not os.getenv('AWS_SECRET_ACCESS_KEY') and hasattr(config, 'AWS_SECRET_ACCESS_KEY'):
        os.environ['AWS_SECRET_ACCESS_KEY'] = config.AWS_SECRET_ACCESS_KEY

# Function to extract FIRMCODE from EtaniClientID
def get_firmcode_from_client_id(client_id):
    """
    Extract the FIRMCODE from EtaniClientID.
    FIRMCODE is everything before the first underscore, with dashes removed.

    Examples:
        EtaniClientID = "BIGOLESHOECOMPANY_CLIENT1518"
        Returns: "BIGOLESHOECOMPANY"

        EtaniClientID = "SW-AU_CLIENT1234"
        Returns: "SWAU"

    Args:
        client_id (str): The EtaniClientID

    Returns:
        str: The extracted FIRMCODE with dashes removed
    """
    if not client_id:
        return None

    # Find the first underscore and extract everything before it
    underscore_index = client_id.find('_')
    if underscore_index == -1:
        # No underscore found, return the whole string (with dashes removed)
        return client_id.replace('-', '')

    # Extract firmcode before underscore and remove dashes
    firmcode = client_id[:underscore_index]
    return firmcode.replace('-', '')

def refresh_aws_engines_if_needed():
    """
    Refresh AWS engines if EtaniClientID (and thus FIRMCODE) has changed.
    This prevents engine reuse across different clients.
    """
    global eva_engine, eva_main_engine, cms_engine, EVA_DB_NAME, EVA_STAGE_DB_NAME, EtaniClientID

    if not USE_AWS_DB:
        return

    # PRIORITY 1: Check environment variable first (set by run_dynamic_integration.py)
    env_etani_client_id = os.getenv('EtaniClientID')

    if env_etani_client_id:
        # Use environment variable - this takes highest priority
        current_etani_client_id = env_etani_client_id
        EtaniClientID = env_etani_client_id
        print(f"[CONFIG] Using EtaniClientID from environment: {env_etani_client_id}")
    else:
        # PRIORITY 2: Try to reload from integration config
        current_etani_client_id = None
        current_integration_name = None

        # Try to get integration name from command line args
        for i, arg in enumerate(sys.argv):
            if arg == '--integration' and i < len(sys.argv) - 1:
                current_integration_name = sys.argv[i + 1]
                break
            elif arg.startswith('--integration='):
                current_integration_name = arg.split('=', 1)[1]
                break

        # If we have integration name, reload config
        if current_integration_name:
            try:
                # Import the Utils class to load config
                sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dynamic_integrations', 'generator'))
                from dynamic_integrations.generator.utils import Utils

                # Load fresh integration config
                integration_config = Utils.load_integration_config(current_integration_name.lower())
                env_vars_config = integration_config.get('env_vars_config', {})

                # Get client info from config
                config_etani_client_id = env_vars_config.get('etani_client_id', {}).get('default_value', '')
                current_etani_client_id = config_etani_client_id

                # Update global variable with fresh value
                EtaniClientID = current_etani_client_id

            except Exception as e:
                print(f"[WARNING] Warning: Could not reload config for engine refresh: {e}")
                # Fall back to current global value
                current_etani_client_id = EtaniClientID
        else:
            # Fall back to current global value
            current_etani_client_id = EtaniClientID

    # Get current FIRMCODE from config
    current_firmcode = get_firmcode_from_client_id(current_etani_client_id) if current_etani_client_id else None

    print(f"[DEBUG] refresh_aws_engines_if_needed():")
    print(f"  current_etani_client_id: {current_etani_client_id}")
    print(f"  current_firmcode: {current_firmcode}")

    # Get current FIRMCODE that engines are using
    current_engine_db = eva_engine.url.database if hasattr(eva_engine, 'url') else None
    expected_engine_db = f'vibedb_{current_firmcode}' if current_firmcode else None

    print(f"  current_engine_db: {current_engine_db}")
    print(f"  expected_engine_db: {expected_engine_db}")

    # Check if engine database matches expected database
    if current_engine_db != expected_engine_db:
        print(f"[SYNC] Engine refresh needed: current='{current_engine_db}' vs expected='{expected_engine_db}'")

        # Dispose old engines
        try:
            eva_engine.dispose()
            eva_main_engine.dispose()
            cms_engine.dispose()
            print(f"[CLEAN] Disposed old engines")
        except Exception as e:
            print(f"[WARNING] Error disposing old engines: {e}")

        if current_firmcode:
            # Update global database names
            EVA_DB_NAME = f'vibedb_{current_firmcode}'
            EVA_STAGE_DB_NAME = f'vibedb_{current_firmcode}'

            # Create new engines
            try:
                aws_eva_engine = _create_aws_engine(EVA_STAGE_DB_NAME)
                aws_eva_main_engine = _create_aws_engine(EVA_DB_NAME)
                aws_cms_engine = _create_aws_engine('vibedb_cms')

                # Override global engines
                eva_engine = aws_eva_engine
                eva_main_engine = aws_eva_main_engine
                cms_engine = aws_cms_engine

                print(f"[OK] AWS engines refreshed for FIRMCODE: {current_firmcode}")
                print(f"   Database mapping: eva_engine->{EVA_STAGE_DB_NAME}, eva_main_engine->{EVA_DB_NAME}")
                print(f"   Verify: eva_engine.url.database = {eva_engine.url.database}")

            except Exception as e:
                print(f"[ERROR] Error creating AWS engines for FIRMCODE {current_firmcode}: {e}")
                raise
        else:
            print(f"[WARNING] No valid FIRMCODE found from EtaniClientID: {EtaniClientID}")
    else:
        print(f"[OK] Engines already match expected database: {expected_engine_db}")


DB_Destination = os.getenv('DB_Destination')
# print(f"DB_Destination: {DB_Destination}")
JOB_ID = os.getenv('JOB_ID')
JOB_RUN_ID = os.getenv('JOB_RUN_ID')
TRIGGER_TYPE = os.getenv('TRIGGER_TYPE')
# Org Integration Details - Get from command line args and integration config

# Initialize variables
EtaniClientID = None
EtaniOrganisationID = None
integration_name = None
cli_etani_client_id = None
cli_etani_organisation_id = None

# Method 1: Check for --integration arg (run_dynamic_integration.py approach)
for i, arg in enumerate(sys.argv):
    if arg == '--integration' and i < len(sys.argv) - 1:
        integration_name = sys.argv[i + 1]
    elif arg.startswith('--integration='):
        integration_name = arg.split('=', 1)[1]
    elif arg == '--param' and i < len(sys.argv) - 1:
        param = sys.argv[i + 1]
        if '=' in param:
            key, value = param.split('=', 1)
            if key.strip() == 'EtaniClientID':
                cli_etani_client_id = value.strip()
            elif key.strip() == 'EtaniOrganisationID':
                cli_etani_organisation_id = value.strip()

# Method 2: Check integration_name from script name (like wfm_integration.py)
if not integration_name:
    script_name = os.path.basename(sys.argv[0])
    if script_name.endswith('_integration.py'):
        integration_name = script_name.replace('_integration.py', '')

logger.info(f"Detected integration from command line: {integration_name}")

# If we have integration name, get client info from config
if integration_name:
    # Import the Utils class to load config
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dynamic_integrations', 'generator'))
    from dynamic_integrations.generator.utils import Utils

    # Load integration config
    integration_config = Utils.load_integration_config(integration_name.lower())
    env_vars_config = integration_config.get('env_vars_config', {})

    # Get client info from config
    config_etani_client_id = env_vars_config.get('etani_client_id', {}).get('default_value', '')
    config_etani_organisation_id = env_vars_config.get('etani_organisation_id', {}).get('default_value', '')

    logger.info(
        f"Config values - EtaniClientID: {config_etani_client_id}, EtaniOrganisationID: {config_etani_organisation_id}")

    # Priority: CLI args > Environment variables > Config defaults
    EtaniClientID = cli_etani_client_id or os.getenv('EtaniClientID') or config_etani_client_id
    EtaniOrganisationID = cli_etani_organisation_id or os.getenv('EtaniOrganisationID') or config_etani_organisation_id
else:
    # No integration name detected - fall back to environment variables only
    EtaniClientID = os.getenv('EtaniClientID')
    EtaniOrganisationID = os.getenv('EtaniOrganisationID')

XeroTenantID = os.getenv('XeroTenantID')
Reset_Mode = os.getenv("Reset_Mode")

# Database name variables for cross-database queries
# These are used when you need to reference tables from other databases in your queries
if USE_AWS_DB:
    # Extract FIRMCODE from EtaniClientID for dynamic database naming
    FIRMCODE = get_firmcode_from_client_id(EtaniClientID) if EtaniClientID else None

    if FIRMCODE:
        # Use vibedb_{FIRMCODE} format for both main and stage databases
        EVA_DB_NAME = f'vibedb_{FIRMCODE}'
        EVA_STAGE_DB_NAME = f'vibedb_{FIRMCODE}'
        logger.info(f"Using dynamic database name: {EVA_DB_NAME} (FIRMCODE: {FIRMCODE})")
    else:
        # Fallback to default if FIRMCODE cannot be determined
        EVA_DB_NAME = 'vibedb'
        EVA_STAGE_DB_NAME = 'vibedb_stage'
        logger.warning("EtaniClientID not available, using default database names")

    CMS_DB_NAME = 'vibedb_cms'  # AWS CMS database (client, client_service tables)
else:
    # FATAL: Azure database names should never be used
    raise RuntimeError(
        "[ERROR] CRITICAL ERROR: Azure database names deprecated.\n"
        "   Cannot use etaniv2, evadb, or evadb_stage - all migrated to AWS.\n"
        "   REQUIRED: Set environment variable USE_AWS_DB=True"
    )

logger.info(f"Database names: CMS={CMS_DB_NAME}, EVA={EVA_DB_NAME}, STAGE={EVA_STAGE_DB_NAME}")

# ============================================================================
# Query Monitoring Setup
# ============================================================================
query_client = None
container_client = None
CONTAINER_LOG_ID = os.getenv('CONTAINER_LOG_ID', '')  # Container log ID from parent app or created dynamically


def start_container_log(integration: str, organisation_id: int, client_id: int = None,
                        firm_id: int = None, job_id: int = None, job_run_id: int = None,
                        trigger_type: str = None):
    """
    Create a container log entry at the start of ETL execution.

    Args:
        integration: Integration name (e.g., 'xero_sync')
        organisation_id: Organisation ID
        client_id: Optional client ID
        firm_id: Optional firm ID
        job_id: Optional job ID
        job_run_id: Optional job run ID
        trigger_type: Optional trigger type (e.g., 'MANUAL', 'SCHEDULED')

    Returns:
        str: container_log_id to use for query logging, or None if failed
    """
    global CONTAINER_LOG_ID

    if not container_client:
        logger.warning("[Container Monitoring] container_client is None - monitoring not enabled")
        return None

    # If we already have a container log ID from env, use it
    if CONTAINER_LOG_ID:
        logger.info(f"[Container Monitoring] Using existing CONTAINER_LOG_ID from env: {CONTAINER_LOG_ID}")
        return CONTAINER_LOG_ID

    try:
        logger.info(f"[Container Monitoring] Creating container log for {integration}")
        container_log_id = container_client.start_container(
            integration=integration,
            organisation_id=organisation_id,
            client_id=client_id,
            firm_id=firm_id,
            job_id=job_id,
            job_run_id=job_run_id,
            trigger_type=trigger_type
        )

        if container_log_id:
            CONTAINER_LOG_ID = container_log_id
            logger.info(f"[Container Monitoring] Container log created: {container_log_id}")
        else:
            logger.warning("[Container Monitoring] Failed to create container log (returned None)")

        return container_log_id
    except Exception as e:
        logger.error(f"[Container Monitoring] Exception creating container log: {e}")
        return None


def complete_container_log(status: str = "success", error_details: str = None):
    """
    Mark the container log as complete.

    Args:
        status: Status ('success', 'failed', etc.)
        error_details: Optional error details if failed

    Returns:
        dict: API response
    """
    if not container_client:
        logger.warning("[Container Monitoring] container_client is None - monitoring not enabled")
        return {'success': False, 'error': 'Container monitoring not enabled'}

    if not CONTAINER_LOG_ID:
        logger.warning("[Container Monitoring] No CONTAINER_LOG_ID to complete")
        return {'success': False, 'error': 'No container_log_id available'}

    try:
        logger.info(f"[Container Monitoring] Completing container log: {CONTAINER_LOG_ID} ({status})")
        result = container_client.complete_container(CONTAINER_LOG_ID, status, error_details)
        return result
    except Exception as e:
        logger.error(f"[Container Monitoring] Exception completing container log: {e}")
        return {'success': False, 'error': str(e)}


def submit_query_logs(container_log_id=None):
    """
    Submit all tracked queries to the API.

    Args:
        container_log_id: Optional container log ID. If not provided, uses CONTAINER_LOG_ID env var.

    Returns:
        dict: API response with logged_count and slow_queries_detected
    """
    logger.info(f"[Query Monitoring] submit_query_logs called with container_log_id={container_log_id}")
    logger.info(f"[Query Monitoring] query_client is: {query_client}")

    if not query_client:
        logger.warning("[Query Monitoring] query_client is None - monitoring not enabled")
        return {'success': False, 'error': 'Query monitoring not enabled'}

    log_id = container_log_id or CONTAINER_LOG_ID
    logger.info(f"[Query Monitoring] Resolved container_log_id: {log_id}")
    logger.info(
        f"[Query Monitoring] Number of queries in client: {len(query_client.queries) if hasattr(query_client, 'queries') else 'N/A'}")

    if not log_id:
        logger.warning("[Query Monitoring] No container_log_id provided for query submission")
        return {'success': False, 'error': 'No container_log_id provided'}

    try:
        logger.info(f"[Query Monitoring] Calling query_client.submit_queries with log_id={log_id}")
        result = query_client.submit_queries(log_id)
        logger.info(f"[Query Monitoring] Submitted queries: {result.get('logged_count', 0)} queries logged")
        if result.get('slow_queries_detected', 0) > 0:
            logger.warning(f"[Query Monitoring] Detected {result['slow_queries_detected']} slow queries")
        return result
    except Exception as e:
        logger.error(f"[Query Monitoring] Failed to submit query logs: {e}")
        logger.error(f"[Query Monitoring] Exception type: {type(e).__name__}")
        return {'success': False, 'error': str(e)}


if QUERY_MONITORING_AVAILABLE:
    # Use config values directly
    try:
        import config
        query_monitoring_enabled = getattr(config, 'QUERY_MONITORING_ENABLED', False)
        etl_api_url = getattr(config, 'ETL_API_URL', '')
        etl_api_key = getattr(config, 'ETL_API_KEY', '')
    except ImportError:
        # Fallback if config not available
        query_monitoring_enabled = False
        etl_api_url = ''
        etl_api_key = ''

    logger.info(f"[Query Monitoring Init] QUERY_MONITORING_ENABLED={query_monitoring_enabled}")
    logger.info(f"[Query Monitoring Init] ETL_API_URL={'SET' if etl_api_url else 'NOT SET'}")
    logger.info(f"[Query Monitoring Init] ETL_API_KEY={'SET' if etl_api_key else 'NOT SET'}")

    if query_monitoring_enabled and etl_api_url and etl_api_key:
        try:
            logger.info(f"[Query Monitoring Init] Initializing QueryMonitoringClient with URL: {etl_api_url}")
            query_client = QueryMonitoringClient(etl_api_url, etl_api_key)
            container_client = ContainerMonitoringClient(etl_api_url, etl_api_key)
            logger.info("[Query Monitoring Init] Query monitoring enabled in sql_helper")
            logger.info(f"[Query Monitoring Init] query_client created: {query_client}")
            logger.info(f"[Query Monitoring Init] container_client created: {container_client}")
            if CONTAINER_LOG_ID:
                logger.info(f"[Query Monitoring Init] Container log ID from env: {CONTAINER_LOG_ID}")
            else:
                logger.info(f"[Query Monitoring Init] No CONTAINER_LOG_ID set in env - will create on-demand")
        except Exception as e:
            logger.warning(f"[Query Monitoring Init] Failed to initialize query monitoring: {e}")
    else:
        logger.info("[Query Monitoring Init] Query monitoring disabled (env vars not set or enabled=false)")
else:
    logger.info("[Query Monitoring Init] Query monitoring not available (query_monitoring_client.py not imported)")


# ============================================================================
# SQL Error Logging Function
# ============================================================================

def log_sql_error(sql_query, error, database_name=None, params=None, context=None):
    """
    Log SQL errors to a dedicated error log file.

    Args:
        sql_query (str): The SQL query that failed
        error (Exception): The exception that was raised
        database_name (str, optional): Name of the database where error occurred
        params (dict, optional): Parameters used in the query
        context (str, optional): Additional context (e.g., function name, endpoint)
    """
    try:
        # Create log filename with date
        log_date = datetime.now().strftime('%Y-%m-%d')
        log_filename = f"sql_errors_{log_date}.log"
        log_filepath = os.path.join(SQL_ERROR_LOG_DIR, log_filename)

        # Prepare log entry
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        separator = "=" * 80

        # Get client info if available
        client_info = ""
        if EtaniClientID:
            client_info = f"Client ID: {EtaniClientID}"
            if EtaniOrganisationID:
                client_info += f" | Org ID: {EtaniOrganisationID}"

        # Get database mode
        db_mode = "AWS RDS Aurora" if USE_AWS_DB else "Azure MySQL"
        if database_name:
            db_info = f"{db_mode} - Database: {database_name}"
        else:
            db_info = db_mode

        # Format error details
        error_type = type(error).__name__
        error_message = str(error)

        # Get stack trace
        stack_trace = ''.join(traceback.format_tb(error.__traceback__))

        # Format SQL query (truncate if too long)
        formatted_query = sql_query
        if len(formatted_query) > 5000:
            formatted_query = formatted_query[:5000] + "\n... (truncated) ..."

        # Build log entry
        log_entry = f"""
{separator}
TIMESTAMP: {timestamp}
{separator}
DATABASE: {db_info}
{client_info}
CONTEXT: {context or 'N/A'}
JOB_ID: {JOB_ID or 'N/A'} | JOB_RUN_ID: {JOB_RUN_ID or 'N/A'}

ERROR TYPE: {error_type}
ERROR MESSAGE: {error_message}

SQL QUERY:
{formatted_query}

PARAMETERS: {params or 'None'}

STACK TRACE:
{stack_trace}
{separator}

"""

        # Write to log file
        with open(log_filepath, 'a', encoding='utf-8') as f:
            f.write(log_entry)

        # Also log to console
        logger.error(f"SQL Error logged to: {log_filepath}")

    except Exception as log_error:
        # If logging fails, at least print to console
        logger.error(f"Failed to write SQL error log: {log_error}")
        logger.error(f"Original SQL error: {error}")


# Default values - will be overridden by dynamic config loading above
DB_Destination = 'EVA'
JOB_ID = 1
JOB_RUN_ID = 7239
TRIGGER_TYPE = 'MANUAL'

# Handle None EtaniClientID - no table prefix if None
if EtaniClientID and 'CLIENT' in EtaniClientID:
    client_number = EtaniClientID[EtaniClientID.find('CLIENT') + len('CLIENT'):]
    TablePrefixEVA = f'c{client_number}_{EtaniOrganisationID or "0"}_xeroblue_'
    TableClientEVA = f"c{client_number}_xeroblue_"
    ClientIdNumber = client_number
else:
    # No table prefix when EtaniClientID is None
    TablePrefixEVA = ''
    TableClientEVA = ''
    ClientIdNumber = None

# ============================================================================
# LEGACY Azure DB Connection Setup (DEPRECATED - DO NOT USE)
# ============================================================================
# Azure MySQL is DEPRECATED. All data migrated to AWS RDS Aurora.
# These engines will be immediately replaced by AWS engines if USE_AWS_DB=True

# Initialize engines as None - will be set by AWS code below
eva_engine = None
eva_main_engine = None

if not USE_AWS_DB:
    # FATAL: Azure MySQL is no longer supported
    raise RuntimeError(
        "[ERROR] CRITICAL ERROR: Azure MySQL is deprecated and cannot be used.\n"
        "   All databases have been migrated to AWS RDS Aurora.\n"
        "   REQUIRED: Set environment variable USE_AWS_DB=True\n"
        "   If you see this error, contact DevOps immediately."
    )

# etanidb/cms connection parameters
# IMPORTANT: CMS database location depends on USE_AWS_DB setting
# Note: For AWS, engine will be created lazily after _get_awsrds_secret() is defined
cms_engine = None
cms_connection_params = None

if not USE_AWS_DB:
    # FATAL: Azure MySQL CMS database is no longer supported
    raise RuntimeError(
        "[ERROR] CRITICAL ERROR: Cannot create CMS engine - Azure MySQL deprecated.\n"
        "   CMS database has been migrated from etaniv2 (Azure) to vibedb_cms (AWS).\n"
        "   REQUIRED: Set environment variable USE_AWS_DB=True"
    )
else:
    # AWS RDS Aurora - CMS engine will be created lazily (see get_cms_engine() below)
    logger.info("🔧 CMS Engine: Will use AWS RDS Aurora (vibedb_cms) - created lazily")

# ============================================================================
# AWS RDS Aurora Connection Setup
# ============================================================================

# Cache for AWS credentials
_aws_credentials_cache = None


def refresh_aws_credentials():
    """
    Force refresh of AWS RDS credentials from Secrets Manager.
    Clears the cache and retrieves new credentials.
    """
    global _aws_credentials_cache

    logger.info("[SYNC] Forcing AWS credentials refresh...")
    _aws_credentials_cache = None  # Clear cache to force refresh

    try:
        credentials = _get_awsrds_secret()  # This will fetch new credentials
        logger.info("[OK] AWS credentials refreshed successfully")
        return credentials
    except Exception as e:
        logger.error(f"[ERROR] Failed to refresh AWS credentials: {e}")
        raise


def refresh_aws_engines():
    """
    Refresh AWS engines after credential rotation.
    Disposes old engines and creates new ones with refreshed credentials.
    """
    global eva_engine, eva_main_engine, cms_engine

    if not USE_AWS_DB:
        logger.warning("Not using AWS DB - skipping engine refresh")
        return

    logger.info("[SYNC] Refreshing AWS engines due to credential rotation...")

    try:
        # Dispose old engines first
        try:
            if eva_engine:
                eva_engine.dispose()
            if eva_main_engine:
                eva_main_engine.dispose()
            if cms_engine:
                cms_engine.dispose()
            logger.info("[CLEAN] Disposed old AWS engines")
        except Exception as e:
            logger.warning(f"[WARNING] Error disposing old engines: {e}")

        # Refresh credentials first
        refresh_aws_credentials()

        # Recreate engines with new credentials
        aws_eva_engine = _create_aws_engine(EVA_STAGE_DB_NAME)
        aws_eva_main_engine = _create_aws_engine(EVA_DB_NAME)
        aws_cms_engine = _create_aws_engine(CMS_DB_NAME)

        # Replace global engines
        eva_engine = aws_eva_engine
        eva_main_engine = aws_eva_main_engine
        cms_engine = aws_cms_engine

        logger.info("[OK] AWS engines refreshed successfully")

    except Exception as e:
        logger.error(f"[ERROR] Failed to refresh AWS engines: {e}")
        raise


def is_aws_credentials_error(exception):
    """
    Check if an exception is due to AWS credentials being expired/invalid.

    Args:
        exception: The exception to check

    Returns:
        bool: True if it's a credentials error (1045 Access denied) in AWS mode
    """
    if not USE_AWS_DB:
        return False

    error_str = str(exception).lower()

    # Check for MySQL error 1045 (Access denied) - this happens during password rotation
    if '1045' in error_str and 'access denied' in error_str:
        return True

    # Check for authentication failed errors
    if 'authentication failed' in error_str:
        return True

    # Check for connection authentication errors (must have password context)
    if 'access denied' in error_str and 'using password:' in error_str:
        return True

    return False


def handle_aws_credentials_error_and_retry(func, *args, **kwargs):
    """
    Execute a function with automatic AWS credentials refresh on access denied errors.

    Args:
        func: Function to execute
        *args, **kwargs: Arguments to pass to the function

    Returns:
        Function result

    Raises:
        Exception: Re-raises the exception if it's not a credentials issue or retry fails
    """
    try:
        # First attempt
        return func(*args, **kwargs)
    except Exception as e:
        if is_aws_credentials_error(e):
            logger.warning(f"🔑 Detected AWS credentials error: {e}")
            logger.info("[SYNC] Attempting to refresh credentials and retry...")

            try:
                # Refresh engines and retry
                refresh_aws_engines()

                # Retry the function
                logger.info("[SYNC] Retrying operation with refreshed credentials...")
                return func(*args, **kwargs)

            except Exception as retry_error:
                if is_aws_credentials_error(retry_error):
                    logger.error("[ERROR] Credentials refresh failed - still getting access denied")
                    logger.error("💡 Check if AWS Secrets Manager has the correct password")
                else:
                    logger.error(f"[ERROR] Retry failed with different error: {retry_error}")
                raise retry_error
        else:
            # Not a credentials error, re-raise original exception
            raise e


def aws_credentials_auto_refresh(func):
    """
    Decorator to automatically handle AWS credential refresh on 1045 Access denied errors.

    Usage:
        @aws_credentials_auto_refresh
        def my_database_function(...):
            # Database operations here

    This decorator will automatically detect AWS credential errors and refresh
    credentials + engines before retrying the operation once.
    """
    from functools import wraps

    @wraps(func)
    def wrapper(*args, **kwargs):
        return handle_aws_credentials_error_and_retry(func, *args, **kwargs)

    return wrapper


def _get_awsrds_secret():
    """
    Retrieve RDS credentials from AWS Secrets Manager.
    Caches credentials to avoid repeated API calls.
    """
    global _aws_credentials_cache

    if _aws_credentials_cache is not None:
        return _aws_credentials_cache

    secret_name = config.AWS_RDS_SECRET_NAME
    region_name = config.AWS_RDS_REGION

    try:
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

        secret = get_secret_value_response['SecretString']

        try:
            secret_dict = json.loads(secret)
            username = secret_dict.get('username', config.AWS_RDS_USERNAME)
            password = secret_dict.get('password')
        except (json.JSONDecodeError, KeyError):
            username = config.AWS_RDS_USERNAME
            password = secret

        _aws_credentials_cache = {
            'username': username,
            'password': password
        }

        logger.info(f"Retrieved AWS RDS credentials for user: {username}")
        return _aws_credentials_cache

    except ClientError as e:
        logger.error(f"Failed to retrieve AWS secret: {e}")
        raise e


def _create_aws_engine(database_name):
    """
    Create a SQLAlchemy engine for AWS RDS Aurora with connection pooling.

    Args:
        database_name: Name of the database on AWS (vibedb, vibedb_stage, etc.)
    """
    credentials = _get_awsrds_secret()

    connection_string = (
        f"mysql+pymysql://{credentials['username']}:{credentials['password']}"
        f"@{config.AWS_RDS_HOST}/{database_name}"
    )

    engine = create_engine(
        connection_string,
        connect_args={
            "autocommit": True,  # Enable autocommit like Azure engines
        },
        poolclass=QueuePool,
        pool_size=5,           # REDUCED: Minimize idle connections for ACU scale-down
        max_overflow=10,       # REDUCED: Max 15 total connections per engine
        pool_timeout=30,       # Fail fast if pool exhausted
        pool_recycle=300,      # CRITICAL: Recycle every 5min to prevent Sleep buildup consuming ACUs
        pool_pre_ping=True,    # Verify connections before use
        echo=False,
    )

    logger.info(f"AWS RDS connection pool created for database: {database_name}")
    return engine


def get_cms_engine():
    """
    Get or create the CMS engine (lazily creates AWS CMS engine if needed).

    Returns:
        SQLAlchemy engine for CMS database
    """
    global cms_engine

    if cms_engine is not None:
        return cms_engine

    if USE_AWS_DB:
        # Create AWS CMS engine lazily
        logger.info("🔧 Creating AWS CMS engine for vibedb_cms...")
        cms_engine = _create_aws_engine('vibedb_cms')
        return cms_engine
    else:
        # This shouldn't happen - Azure engine should be created at module load
        logger.error("[ERROR] CMS engine is None but USE_AWS_DB is False - this shouldn't happen!")
        raise RuntimeError("CMS engine not initialized properly")



def ensure_database_exists(database_name, error_list=None):
    """
    Check if a database exists and create it if it doesn't.

    Args:
        database_name: Name of the database to check/create (e.g., 'vibedb_TIGERS')
        error_list: Optional list to append error messages to

    Returns:
        bool: True if database exists or was created successfully, False otherwise
    """
    try:
        if USE_AWS_DB:
            # For AWS, connect to the CMS database and create the firm database if needed
            credentials = _get_awsrds_secret()
            connection_string = (
                f"mysql+pymysql://{credentials['username']}:{credentials['password']}"
                f"@{config.AWS_RDS_HOST}/"  # No database specified in connection
            )

            temp_engine = create_engine(
                connection_string,
                connect_args={"autocommit": True},
                isolation_level="AUTOCOMMIT"
            )

            with temp_engine.connect() as connection:
                # Check if database exists
                check_query = text(
                    "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = :db_name"
                )
                result = connection.execute(check_query, {"db_name": database_name})
                exists = result.fetchone() is not None

                if not exists:
                    # Create database with utf8mb4_0900_ai_ci collation (matching vibedb_cms and other firm databases)
                    create_query = text(
                        f"CREATE DATABASE `{database_name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci")
                    connection.execute(create_query)
                    logger.info(f"Created database: {database_name}")
                    if error_list is not None:
                        error_list.append(f"INFO: Created database {database_name}")
                else:
                    logger.info(f"Database already exists: {database_name}")

            temp_engine.dispose()
            return True

        else:
            # Azure mode is deprecated - this should never execute
            raise RuntimeError(
                f"[ERROR] CRITICAL: Azure mode detected in ensure_database_exists().\n"
                f"   Azure MySQL is deprecated. USE_AWS_DB must be True."
            )

    except Exception as e:
        error_msg = f"Failed to check/create database {database_name}: {e}"
        logger.error(error_msg)
        if error_list is not None:
            error_list.append(error_msg)
        return False


# Create AWS engines if USE_AWS_DB is enabled
if USE_AWS_DB:
    try:
        # Map Azure database names to AWS database names
        # Use dynamic database names based on FIRMCODE from EtaniClientID
        # Format: vibedb_{FIRMCODE} for both stage and main databases
        # evadb_stage (Azure) -> vibedb_{FIRMCODE} (AWS)
        # evadb (Azure) -> vibedb_{FIRMCODE} (AWS)
        # etaniv2/CMS (Azure) -> vibedb_cms (AWS)

        print(f"[DATABASE] Creating AWS engines at module load time:")
        print(f"  EtaniClientID: {EtaniClientID}")
        print(f"  FIRMCODE: {get_firmcode_from_client_id(EtaniClientID) if EtaniClientID else None}")
        print(f"  EVA_STAGE_DB_NAME: {EVA_STAGE_DB_NAME}")
        print(f"  EVA_DB_NAME: {EVA_DB_NAME}")
        print(f"  CMS_DB_NAME: {CMS_DB_NAME}")

        aws_eva_engine = _create_aws_engine(EVA_STAGE_DB_NAME)
        aws_eva_main_engine = _create_aws_engine(EVA_DB_NAME)
        aws_cms_engine = _create_aws_engine(CMS_DB_NAME)  # CMS uses vibedb_cms

        # Override the Azure engines with AWS engines
        eva_engine = aws_eva_engine
        eva_main_engine = aws_eva_main_engine
        cms_engine = aws_cms_engine

        logger.info("Using AWS RDS Aurora engines")
        logger.info(f"Database mapping: evadb_stage->{EVA_STAGE_DB_NAME}, evadb->{EVA_DB_NAME}, etaniv2->{CMS_DB_NAME}")

    except Exception as e:
        logger.error(f"[ERROR] FATAL: Failed to initialize AWS RDS Aurora engines: {e}")
        logger.error("Azure MySQL is deprecated - cannot fall back")
        raise RuntimeError(
            f"[ERROR] CRITICAL ERROR: AWS RDS Aurora engine initialization failed.\n"
            f"   Error: {str(e)}\n"
            f"   Azure MySQL is deprecated and cannot be used as fallback.\n"
            f"   Check AWS credentials and network connectivity."
        ) from e


def log_retry_attempt(retry_state):
    fn_name = retry_state.fn.__name__
    retry_msg = f"Retrying {fn_name} (Attempt {retry_state.attempt_number}) due to {retry_state.outcome.exception()}"
    # logger.info(retry_msg)  # Suppress retry log output

    params = {
        "p_integration": fn_name,
        "p_organisation_id": None,
        "p_client_id": None,
        "p_firm_id": None,
        "p_start_date": None,
        "p_end_date": None,
        "p_status": f"RETRYING {fn_name}",
        "p_log_id": None,
        "p_remarks": retry_msg
    }
    update_container_logs(params)


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def update_container_logs(params):
    try:
        engine = get_cms_engine()
        sqlSP = text("""
        CALL sp_add_container_logs(:p_integration, :p_organisation_id, :p_client_id,
                                    :p_firm_id, :p_start_date, :p_end_date,
                                    :p_status, :p_log_id, :p_remarks)
        """)

        # Execute stored procedure on CMS engine (centralized logging)
        with engine.connect() as cursor:
            cursor.execute(sqlSP, params)
            cursor.commit()
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def LoadToEvaStageTableUpsert(df, endpoint, primary_key, stage_table, error_list):
    """
    Load data to EVA Stage Table using UPSERT logic with primary key

    Args:
        df: DataFrame with data to upsert
        endpoint: Endpoint name for logging
        primary_key: Primary key field name for UPSERT
        stage_table: Target stage table name
        error_list: Error list for logging
    """
    TaskName = "LoadToEvaStageTableUpsert"
    try:
        with eva_engine.connect() as connection:
            # Check if primary key column exists in data
            if primary_key not in df.columns:
                # Fallback to INSERT IGNORE
                columns = ', '.join(f"`{col}`" for col in df.columns)
                placeholders = ', '.join([":param_" + str(i) for i in range(len(df.columns))])
                query = f"INSERT IGNORE INTO {stage_table} ({columns}) VALUES ({placeholders})"
            else:
                # Build UPSERT SQL statement
                columns = list(df.columns)
                columns_str = ', '.join([f"`{col}`" for col in columns])
                placeholders = ', '.join([f":param_{i}" for i in range(len(columns))])

                # Build ON DUPLICATE KEY UPDATE clause (exclude primary key from updates)
                update_columns = [col for col in columns if col != primary_key]
                update_clause = ', '.join([f"`{col}` = VALUES(`{col}`)" for col in update_columns])

                query = f"""
                INSERT INTO {stage_table} ({columns_str})
                VALUES ({placeholders})
                ON DUPLICATE KEY UPDATE {update_clause}
                """

            # Convert DataFrame to list of dictionaries for batch execution
            data = []
            for _, row in df.iterrows():
                row_dict = {}
                for i, value in enumerate(row):
                    # Convert NaN to None for SQL compatibility
                    if pd.isna(value):
                        row_dict[f"param_{i}"] = None
                    elif value == "":
                        row_dict[f"param_{i}"] = None
                    else:
                        row_dict[f"param_{i}"] = value
                data.append(row_dict)

            # Execute UPSERT in batches
            batch_size = 1000
            for i in range(0, len(data), batch_size):
                batch = data[i:i + batch_size]
                connection.execute(text(query), batch)
                print(f'UPSERT Rows: {i + len(batch)}/{len(data)}')

            # Commit the transaction
            connection.commit()

            # Track cost operations for UPSERT (UPDATE operations)
            track_cost_operation('UPDATE', len(data))

            # Log success
            LoggingDetails(TaskName, f"{endpoint} - Successfully upserted data to EVA Stage TABLE: {stage_table}",
                           JOB_ID, JOB_RUN_ID, error_list, "DYNAMIC_INTEGRATION")

    except SQLAlchemyError as e:
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to upsert data to EVA stage table: {str(e)}", JOB_ID, JOB_RUN_ID,
                       error_list, "DYNAMIC_INTEGRATION")
        error_list.append(f"Failed to UPSERT Data to EVA stage table: {str(e)}")
        print(f"Error: {str(e)}")
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def LoadToEvaStageTable(df, endpoint, write_mode, stage_table, error_list):
    TaskName = "LoadToEvaStageTable"
    stage_table = stage_table.lower()
    endpoint = endpoint.lower()

    import time

    try:
        with eva_engine.connect() as connection:
            # If write mode is 'overwrite,' truncate the table first
            if write_mode == 'overwrite':
                truncate_query = f"TRUNCATE TABLE {stage_table}"

                # Track truncate operation
                truncate_start = time.time()
                connection.execute(text(truncate_query))
                truncate_time_ms = (time.time() - truncate_start) * 1000

                print(f"{endpoint} - Table {stage_table} truncated.")

                # Track truncate query
                if query_client:
                    try:
                        query_client.track_query(
                            query_text=truncate_query,
                            execution_time_ms=truncate_time_ms,
                            table_names=[stage_table]
                        )
                    except Exception as e:
                        print(f"[{TaskName}] Failed to track truncate query: {e}")

            # Preparing columns and insert query
            columns = ', '.join(f"`{col}`" for col in df.columns)
            placeholders = ', '.join([":param_" + str(i) for i in range(len(df.columns))])
            query = f"INSERT IGNORE INTO {stage_table} ({columns}) VALUES ({placeholders})"

            # Convert empty strings to None (NULL in SQL)
            data = [
                {f"param_{i}": (None if value == "" else value) for i, value in enumerate(row)}
                for row in df.itertuples(index=False, name=None)
            ]

            # Insert data in batches
            batch_size = 1000
            insert_start = time.time()
            total_rows_inserted = 0

            for i in range(0, len(data), batch_size):
                batch = data[i:i + batch_size]
                connection.execute(text(query), batch)
                total_rows_inserted += len(batch)
                print(f'Inserted Rows: {i + len(batch)}/{len(data)}')

            insert_time_ms = (time.time() - insert_start) * 1000

            # Track insert operations
            if query_client:
                try:
                    query_client.track_query(
                        query_text=f"INSERT INTO {stage_table} (batch insert)",
                        execution_time_ms=insert_time_ms,
                        rows_affected=total_rows_inserted,
                        table_names=[stage_table]
                    )
                    print(f"[{TaskName}] Insert tracked: {insert_time_ms:.2f}ms, {total_rows_inserted} rows")
                except Exception as e:
                    print(f"[{TaskName}] Failed to track insert query: {e}")

            # Track cost operations for INSERT
            track_cost_operation('INSERT', total_rows_inserted)

            # Log success
            LoggingDetails(TaskName, f"{endpoint} - Successfully loaded data to EVA Stage TABLE: {stage_table}", JOB_ID,
                           JOB_RUN_ID, error_list, "XEROBLUE")
    except SQLAlchemyError as e:
        # Log SQL error to file
        log_sql_error(
            sql_query=query if 'query' in locals() else "TRUNCATE/INSERT query",
            error=e,
            database_name=EVA_STAGE_DB_NAME,
            params={'table': stage_table, 'rows': len(df) if df is not None else 0, 'write_mode': write_mode},
            context=f"{TaskName} - {endpoint}"
        )
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to load data to EVA stage table: {str(e)}", JOB_ID, JOB_RUN_ID,
                       error_list, "XEROBLUE")
        error_list.append(f"Failed to Load Data to EVA stage table: {str(e)}")
        print(f"Error: {str(e)}")
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def ExecuteEvaSP(procedure_name, endpoint, error_list, query=False, integration_name="XEROBLUE"):
    TaskName = "ExecuteEvaSP"
    endpoint = endpoint.lower()

    # Determine which engine to use based on procedure name and AWS mode
    # For AWS connections, sp_dynamic_xeroblue* procedures are in vibedb_cms for maintainability
    use_cms_engine = USE_AWS_DB and 'sp_dynamic_xeroblue' in procedure_name.lower()
    selected_engine = cms_engine if use_cms_engine else eva_engine
    engine_name = 'cms_engine (vibedb_cms)' if use_cms_engine else 'eva_engine'

    # Log which database we're using
    db_name = selected_engine.url.database if hasattr(selected_engine.url, 'database') else 'unknown'
    print(f"[{TaskName}] AWS_MODE={USE_AWS_DB}, Database={db_name}, Engine={engine_name}, Procedure={procedure_name}")

    LoggingDetails(TaskName, f"{endpoint} - Executing Eva Stored Procedure: {procedure_name}", JOB_ID, JOB_RUN_ID,
                   error_list, integration_name)
    try:

        if query:
            sqlSP = procedure_name
        else:
            sqlSP = f'CALL {procedure_name}'

        print(f"[{TaskName}] Executing SQL: {sqlSP[:200]}")  # Print first 200 chars

        # Track query execution time
        import time
        start_time = time.time()

        # Use selected engine based on procedure type and AWS mode
        with selected_engine.connect() as cursor:
            result = cursor.execute(text(sqlSP))
            cursor.commit()

            # Calculate execution time
            execution_time_ms = (time.time() - start_time) * 1000

            # Log row count if available
            rows_affected = result.rowcount if hasattr(result, 'rowcount') else None
            if rows_affected is not None:
                print(f"[{TaskName}] Rows affected: {rows_affected}")

            # Track query if monitoring is enabled (using global query_client)
            if query_client:
                try:
                    query_client.track_query(
                        query_text=sqlSP,
                        execution_time_ms=execution_time_ms,
                        rows_affected=rows_affected,
                        table_names=[endpoint]
                    )
                    print(f"[{TaskName}] Query tracked: {execution_time_ms:.2f}ms")
                except Exception as e:
                    print(f"[{TaskName}] Failed to track query: {e}")

            # Track cost operations for STORED_PROC calls
            track_cost_operation('STORED_PROC', rows_affected if rows_affected else 0)

        print(f"[{TaskName}] Successfully executed: {procedure_name}")
        LoggingDetails(TaskName, f"{endpoint} - Successfully executed Eva Stored Procedure: {procedure_name}", JOB_ID,
                       JOB_RUN_ID, error_list, "XEROBLUE")

    except (SQLAlchemyError, ProgrammingError, OperationalError) as ex:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=ex,
            database_name=EVA_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        # Log detailed error information
        error_msg = f"{endpoint} - Failed to execute Eva stored procedure {procedure_name}: {str(ex)}"
        print(f"[{TaskName}] ERROR: {error_msg}")
        LoggingDetails(TaskName, f"{endpoint} - Failed to execute Eva stored procedure {procedure_name}: {str(ex)}",
                       JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(error_msg)
    except Exception as e:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=e,
            database_name=EVA_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        # Log detailed error information
        error_msg = f"{endpoint} - Failed to execute Eva stored procedure {procedure_name}: {str(e)}"
        print(f"[{TaskName}] EXCEPTION: {error_msg}")

        LoggingDetails(TaskName, f"{endpoint} - Failed to execute Eva stored procedure {procedure_name}: {str(e)}",
                       JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(error_msg)
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def ExecuteCMSSP(procedure_name, endpoint, error_list, query=False, ):
    TaskName = "ExecuteCMSSP"
    endpoint = endpoint.lower()

    # Get CMS engine (lazy initialization for AWS)
    engine = get_cms_engine()

    # Log which database we're using
    db_name = engine.url.database if hasattr(engine.url, 'database') else 'unknown'
    print(f"[{TaskName}] Database={db_name}, Procedure={procedure_name}")

    try:
        if query:
            sqlSP = procedure_name
        else:
            sqlSP = f'CALL {procedure_name}'

        print(f"[{TaskName}] Executing SQL: {sqlSP[:200]}")  # Print first 200 chars

        # Track query execution time
        import time
        start_time = time.time()

        with engine.connect() as cursor:
            result = cursor.execute(text(sqlSP))
            cursor.commit()

            # Calculate execution time
            execution_time_ms = (time.time() - start_time) * 1000

            # Log row count if available
            rows_affected = result.rowcount if hasattr(result, 'rowcount') else None
            if rows_affected is not None:
                print(f"[{TaskName}] Rows affected: {rows_affected}")

            # Track query if monitoring is enabled (using global query_client)
            if query_client:
                try:
                    query_client.track_query(
                        query_text=sqlSP,
                        execution_time_ms=execution_time_ms,
                        rows_affected=rows_affected,
                        table_names=[endpoint]
                    )
                    print(f"[{TaskName}] Query tracked: {execution_time_ms:.2f}ms")
                except Exception as e:
                    print(f"[{TaskName}] Failed to track query: {e}")

            # Track cost operations for STORED_PROC calls
            track_cost_operation('STORED_PROC', rows_affected if rows_affected else 0)

        print(f"[{TaskName}] Successfully executed: {procedure_name}")
        LoggingDetails(TaskName, f"{endpoint} - Successfully executed CMS Stored Procedure: {procedure_name}", JOB_ID,
                       JOB_RUN_ID, error_list, "XEROBLUE")

    except (SQLAlchemyError, ProgrammingError, OperationalError) as ex:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=ex,
            database_name=CMS_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to execute CMS stored procedure {procedure_name}: {str(ex)}",
                       JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(f"{endpoint} - Failed to execute CMS stored procedure {procedure_name}: {str(ex)}")
        print(f"Error: {str(ex)}")
    except Exception as e:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=e,
            database_name=CMS_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        LoggingDetails(TaskName, f"{endpoint} - Failed to execute CMS stored procedure {procedure_name}: {str(e)}",
                       JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(f"{endpoint} - Failed to execute CMS stored procedure {procedure_name}: {str(e)}")
        # raise e
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def ExecuteDirectCMSSP(procedure_name, endpoint, error_list, query=False, ):
    """
    Execute cross-database procedures with multi-statement support.
    """
    TaskName = "ExecuteDirectCMSSP"
    endpoint = endpoint.lower()

    # Get CMS engine (lazy initialization for AWS)
    engine = get_cms_engine()

    try:
        if query:
            sqlSP = procedure_name
        else:
            sqlSP = f'CALL {procedure_name}'

        print(f"[{TaskName}] Executing: {sqlSP[:100]}...")

        # Track query execution time
        import time
        start_time = time.time()

        with engine.connect() as cursor:
            result = cursor.execute(text(sqlSP))
            cursor.commit()

            # Calculate execution time
            execution_time_ms = (time.time() - start_time) * 1000

            # Log row count if available
            rows_affected = result.rowcount if hasattr(result, 'rowcount') else None
            if rows_affected is not None:
                print(f"[{TaskName}] Rows affected: {rows_affected}")

            # Track query if monitoring is enabled
            if query_client:
                try:
                    query_client.track_query(
                        query_text=sqlSP,
                        execution_time_ms=execution_time_ms,
                        rows_affected=rows_affected,
                        table_names=[endpoint]
                    )
                    print(f"[{TaskName}] Query tracked: {execution_time_ms:.2f}ms")
                except Exception as e:
                    print(f"[{TaskName}] Failed to track query: {e}")

            # Track cost operations for STORED_PROC calls
            track_cost_operation('STORED_PROC', rows_affected if rows_affected else 0)

        print(f"[{TaskName}] Successfully executed: {procedure_name}")
        LoggingDetails(TaskName,
                       f"{endpoint} - Successfully executed CMS cross-database Stored Procedure: {procedure_name}",
                       JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")

    except (SQLAlchemyError, ProgrammingError, OperationalError) as ex:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=ex,
            database_name=CMS_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        error_msg = f"{endpoint} - Failed to execute CMS cross-database stored procedure {procedure_name}: {str(ex)}"
        LoggingDetails(TaskName, error_msg, JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(error_msg)
        print(f"[{TaskName}] Error: {str(ex)}")
        raise ex
    except Exception as e:
        # Log SQL error to file
        log_sql_error(
            sql_query=sqlSP if 'sqlSP' in locals() else procedure_name,
            error=e,
            database_name=CMS_DB_NAME,
            params=None,
            context=f"{TaskName} - {endpoint}"
        )
        error_msg = f"{endpoint} - Failed to execute CMS cross-database stored procedure {procedure_name}: {str(e)}"
        LoggingDetails(TaskName, error_msg, JOB_ID, JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(error_msg)
        print(f"[{TaskName}] Error: {str(e)}")
        raise e
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def ReadMySQLTable(query, endpoint, etani_client_Id, etani_organisation_id, error_list, IsCMS=False,
                   integration_name="XEROBLUE"):
    TaskName = 'ReadMySQLTable'
    engine = get_cms_engine() if IsCMS else eva_engine
    endpoint = endpoint.lower()

    import time

    try:
        # Track query execution time
        start_time = time.time()

        # Fetch data into a DataFrame
        with engine.connect() as connection:
            df = pd.read_sql(text(query), connection)

        execution_time_ms = (time.time() - start_time) * 1000
        row_count = len(df) if df is not None else 0

        # Track query if monitoring is enabled
        if query_client:
            try:
                query_client.track_query(
                    query_text=query,
                    execution_time_ms=execution_time_ms,
                    rows_affected=row_count,
                    table_names=[endpoint]
                )
                print(f"[{TaskName}] Query tracked: {execution_time_ms:.2f}ms, {row_count} rows")
            except Exception as e:
                print(f"[{TaskName}] Failed to track query: {e}")

        # Track cost operations for SELECT queries
        track_cost_operation('SELECT', row_count)

        if endpoint == 'ETANI':
            LoggingDetails(TaskName,
                           f"{endpoint} - Get CMS details for ClientID: {etani_client_Id}, OrgID: {etani_organisation_id}",
                           JOB_ID, JOB_RUN_ID, error_list, integration_name)
        else:
            LoggingDetails(TaskName, f"{endpoint} - Query MySQL table: {query}", JOB_ID, JOB_RUN_ID, error_list,
                           integration_name)
        return df

    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        # Log SQL error to file
        db_name = CMS_DB_NAME if IsCMS else EVA_DB_NAME
        log_sql_error(
            sql_query=query,
            error=e,
            database_name=db_name,
            params={'client_id': etani_client_Id, 'org_id': etani_organisation_id},
            context=f"{TaskName} - {endpoint}"
        )
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to query MySQL table: {str(e)}", JOB_ID, JOB_RUN_ID, error_list,
                       "XEROBLUE")
        error_list.append(f"{endpoint} - Failed to query MySQL table: {str(e)}")
        print(f"Error: {str(e)}")
        return None

    finally:
        # Connection automatically returned to pool by context manager
        pass


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),  # Retry up to 3 times
    wait=wait_exponential(multiplier=1, min=120, max=500),  # Exponential backoff
    before_sleep=log_retry_attempt  # Logs retries before sleeping
)
def get_firm_id(error_list, ClientIdNumber):
    firm_id = 0  # Default value in case no result is found

    # Get CMS engine (lazy initialization for AWS)
    engine = get_cms_engine()

    # Query without database prefix - cms_engine is already connected to the correct database
    # (etaniv2 in Azure, vibedb_cms in AWS)
    sqlqry = text("""
                  SELECT accountingfirm
                  FROM client
                  WHERE id = :client_id
                  """)

    params = {"client_id": ClientIdNumber}

    try:
        # Use cms_engine since client table is in CMS database
        with engine.connect() as cursor:
            result = cursor.execute(sqlqry, params).scalar_one_or_none()
            if result is not None:
                firm_id = result  # Assign the fetched firm_id
    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        print(f"Error fetching firm_id: {e}")
        error_list.append(f"Error fetching firm_id: {e}")

    return firm_id


def LoggingDetails(TaskName, StatusMessage, job_id, job_run_id, error_list, integration_name="XEROBLUE"):
    StatusMessage = StatusMessage.replace("'", "").replace(";", "")
    Truncated_Message = StatusMessage[:250]

    # Always print to console first
    print(f"[LOG] {TaskName}: {StatusMessage}")

    # Skip database logging in AWS mode - stored procedure doesn't exist in AWS
    if USE_AWS_DB:
        return

    # DEPRECATED: Azure database logging - this code should never execute
    # If you see this, USE_AWS_DB should be True
    raise RuntimeError(
        "[ERROR] CRITICAL: Attempted to use Azure database logging.\n"
        "   sp_python_package_log stored procedure is deprecated.\n"
        "   USE_AWS_DB must be True."
    )
    sqlSP = f"CALL sp_python_package_log({job_id}, {job_run_id}, '{integration_name}', '{TaskName}', '{Truncated_Message}');"
    try:
        with eva_engine.connect() as cursor:
            cursor.execute(text(sqlSP))
            cursor.commit()
    except (SQLAlchemyError, ProgrammingError, OperationalError) as ex:
        # Don't recursively call LoggingDetails to avoid infinite loop
        # Just print and add to error list
        error_msg = f"{TaskName} - Failed to execute logging stored procedure: {str(ex)}"
        if error_msg not in error_list:  # Prevent duplicate errors
            error_list.append(error_msg)
        print(f"[ERROR] Logging failed: {str(ex)}")
    finally:
        # Connection automatically returned to pool by context manager
        pass


@aws_credentials_auto_refresh
def ExecuteEVASQL(query: str, task_name: str, endpoint: str, params=[], error_list=[]):  # Has endpoint
    TaskName = task_name
    endpoint = endpoint.lower()

    import time

    try:
        # Open a connection and execute the query
        connection = eva_engine.connect()
        sql_query = text(query).bindparams(**params)

        # Track query execution time
        start_time = time.time()

        if params:
            # Compile the query with literal binds so that parameters are inlined:
            compiled_query = sql_query.compile(
                dialect=connection.dialect,
                compile_kwargs={"literal_binds": True}
            )
            final_query = str(compiled_query)
            print(f"{task_name} : executing query: {final_query[:200]}")  # Print first 200 chars

            # Execute the fully formatted SQL string
            result = connection.execute(text(final_query))
        else:
            print(f"{task_name} : executing query: {query[:200]}")  # Print first 200 chars
            result = connection.execute(sql_query)

        connection.commit()  # Commit the transaction (if needed)

        # Calculate execution time
        execution_time_ms = (time.time() - start_time) * 1000

        # Get rows affected
        rows_affected = result.rowcount if hasattr(result, 'rowcount') else None

        # Track query if monitoring is enabled
        if query_client:
            try:
                query_client.track_query(
                    query_text=final_query if params else query,
                    execution_time_ms=execution_time_ms,
                    rows_affected=rows_affected,
                    table_names=[endpoint]
                )
                print(f"[{TaskName}] Query tracked: {execution_time_ms:.2f}ms")
            except Exception as e:
                print(f"[{TaskName}] Failed to track query: {e}")

        # Log success
        LoggingDetails(TaskName, f"{endpoint} - Successfully executed Eva Stored Procedure: {task_name}", JOB_ID,
                       JOB_RUN_ID, error_list, "XEROBLUE")

    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        # Log SQL error to file
        log_sql_error(
            sql_query=query,
            error=e,
            database_name=EVA_DB_NAME,
            params=params if params else None,
            context=f"{TaskName} - {endpoint}"
        )
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to execute Eva stored procedure {task_name}: {str(e)}", JOB_ID,
                       JOB_RUN_ID, error_list, "XEROBLUE")
        error_list.append(f"Failed to execute EVA stored procedure: {str(e)}")
        print(f"Error: {str(e)}")
    finally:
        # Connection automatically returned to pool by context manager
        pass


def safe_execute_eva_sql(query, operation_name, endpoint, params=None):
    """Executes an EVA SQL command, handling duplicate key errors."""
    try:
        # For AWS connections, index creation procedures are in vibedb_cms
        # So use ExecuteCMSSP instead of ExecuteEVASQL
        if USE_AWS_DB and 'CreateEVAStageIndexIfNotExists' in query:
            # Extract parameters from params dict and format as direct procedure call
            if params:
                table_name = params.get('table_name', '')
                index_name = params.get('index_name', '')
                column_names = params.get('column_names', '')
                ExecuteCMSSP(f"CreateEVAStageIndexIfNotExists('{table_name}', '{index_name}', '{column_names}')",
                             endpoint, [])
            else:
                ExecuteCMSSP(query.replace('CALL ', ''), endpoint, [])
        else:
            ExecuteEVASQL(query, operation_name, endpoint, params)  # Pass endpoint
        return True
    except OperationalError as e:  # Catch the *specific* error
        if e.args[0] == 1061:  # 1061 is the MySQL error code for "Duplicate key name"
            print(f"Index already exists - skipping: {operation_name}")
            return True  # Return True, indicating success (index already exists)
        else:
            print(f"Error in {operation_name}: {e}")
            return False  # For other errors, re-raise/handle
    except Exception as e:  # Keep other errors
        print(f"Error in {operation_name}: {e}")
        return False


def Add_ClientTable_Index(endpoint: str, columns: str):
    """Creates an index on a client table, with deduplication."""
    table_name = f"{TableClientEVA}{endpoint}"
    if not endpoint or not columns:
        print("Missing parameters for Add_ClientTable_Index")
        return

    acronyms = [get_acronym(col) for col in columns.split(",")]
    # Create unique index name, handling potential long names:
    base_index_name = f"{table_name}_{''.join(acronyms)}"
    index_name = base_index_name[:60]  # Truncate to max length (MySQL limit)
    index_name += "_idx"  # Consistent suffix

    columns = columns.replace(" ", "") if " DESC" not in columns else columns
    params = {
        "table_name": table_name,
        "index_name": index_name,
        "column_names": columns
    }
    safe_execute_eva_sql(
        "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
        f"Add_{table_name}_ClientTable_Index",  # Use full table name in operation name
        endpoint,  # Pass the endpoint parameter
        params=params  # Pass parameters correctly
    )


def Add_StageId_Generic_Index(endpoint: str, columns: str):
    """Creates an index on a stage table, with deduplication."""
    if not endpoint or not columns:
        print("Missing parameters for Add_StageId_Generic_Index")
        return

    table_name = f"{TablePrefixEVA}{endpoint.lower()}stage"

    # Simplified naming
    col_names = columns.replace(',', '').replace('OrganisationId', 'OrgID').replace(' ', '').replace('_', '')
    index_name = f"{table_name}_{col_names}"  # combine
    index_name = index_name[:60]  # Truncate *before* adding suffix
    index_name += "_idx"
    columns = columns.replace(" ", "")
    params = {
        "table_name": table_name,
        "index_name": index_name,
        "column_names": columns
    }
    safe_execute_eva_sql(
        "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
        f"Add_{table_name}_Generic_Index",  # Use full table name
        endpoint,  # Pass the endpoint parameter
        params=params
    )


def CheckAndInitIndexesForXero():
    """
    Create indexes on PRODUCTION tables, with deduplication.
    Stage table indexes are handled in ExtractAPIResponse.
    """
    try:

        # Stage Tables
        Add_StageId_Generic_Index("overpayments", "OrganisationId,OverPaymentId")
        Add_StageId_Generic_Index("overpayments", "CurrencyCode,Date")
        Add_StageId_Generic_Index("prepayments", "CurrencyCode,Date")
        Add_StageId_Generic_Index("Invoices", "InvoiceId")
        Add_StageId_Generic_Index("ManualJournals", "ManualJournalId")
        Add_StageId_Generic_Index("Payments", "PaymentId")
        Add_StageId_Generic_Index("BankTransactions", "BankTransactionId")
        Add_StageId_Generic_Index("BatchPayments", "BatchPaymentId")
        Add_StageId_Generic_Index(f"Payments", "OrganisationId,PaymentId,InvoiceId,PaymentType,Amount")

        # Journals (Production Table)
        Add_ClientTable_Index("Journals", "OrganisationId, SourceId")
        Add_ClientTable_Index("Journals", "JournalLine_JournalLineId")  # Crucial for joins
        Add_ClientTable_Index("Journals",
                              "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount")  # For joining with Transactions
        Add_ClientTable_Index("Journals", "JournalDate")
        Add_ClientTable_Index("Journals", "JournalLine_AccountId,OrganisationID")
        Add_ClientTable_Index("Journals",
                              "OrganisationID,JournalLine_AccountId,JournalDate,ContactName,JournalLine_NetAmount")
        Add_ClientTable_Index("Journals", "JournalId")  # helpful for look ups
        Add_ClientTable_Index("Journals", "JournalDate,JournalId")
        Add_ClientTable_Index("Journals", "SourceType,Changes")
        Add_ClientTable_Index("Journals", "ContactSource,Changes")
        Add_ClientTable_Index("Journals", "OrganisationID,JournalDate,JournalLine_NetAmount")
        Add_ClientTable_Index("Journals", "JournalLine_NetAmount")
        Add_ClientTable_Index("Journals", "JournalLine_AccountType")
        Add_ClientTable_Index("Journals", "LineItem_TrackingCategory1_CategoryName")
        Add_ClientTable_Index("Journals", "LineItem_TrackingCategory1_OptionName")
        Add_ClientTable_Index("Journals", "OrganisationName")
        Add_ClientTable_Index("Journals", "PaymentType")
        Add_ClientTable_Index("Journals", "OrganisationID, JournalNumber DESC")

        # --- STAGE TABLE INDEX CREATION
        Add_StageId_Generic_Index("Journals", "OrganisationId,SourceId")
        Add_StageId_Generic_Index("Journals", "OrganisationId,JournalDate")
        Add_StageId_Generic_Index("Journals", "JournalLine_JournalLineId")
        Add_StageId_Generic_Index("Journals", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount")
        Add_StageId_Generic_Index("Journals", "JournalDate")  # good to have date
        Add_StageId_Generic_Index("Journals", "IsVisible,JournalDate")
        Add_StageId_Generic_Index("Journals", "JournalDate,JournalLine_AccountType")
        Add_StageId_Generic_Index("Journals", "JournalId")  # good to have JournalID

        # JournalsCash (Production Table)
        Add_ClientTable_Index("JournalsCash", "OrganisationId,SourceId")
        Add_ClientTable_Index("JournalsCash", "JournalLine_JournalLineId")  # Crucial for joins
        Add_ClientTable_Index("JournalsCash",
                              "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount")  # For joining with Transactions
        Add_ClientTable_Index("JournalsCash", "OrganisationID,JournalLine_AccountId,ContactName,JournalLine_NetAmount")
        Add_ClientTable_Index("JournalsCash", "JournalDate")
        Add_ClientTable_Index("JournalsCash", "JournalId")  # helpful for look ups
        Add_ClientTable_Index("JournalsCash", "JournalDate,JournalId")
        Add_ClientTable_Index("JournalsCash", "SourceType,Changes")
        Add_ClientTable_Index("JournalsCash", "ContactSource,Changes")
        Add_ClientTable_Index("JournalsCash", "OrganisationID, JournalDate,JournalLine_NetAmount")
        Add_ClientTable_Index("JournalsCash", "JournalLine_NetAmount")
        Add_ClientTable_Index("JournalsCash", "JournalLine_AccountType")
        Add_ClientTable_Index("JournalsCash", "LineItem_TrackingCategory1_OptionName")
        Add_ClientTable_Index("JournalsCash", "LineItem_TrackingCategory1_OptionName")
        Add_ClientTable_Index("JournalsCash", "OrganisationName")
        Add_ClientTable_Index("JournalsCash", "PaymentType")
        Add_ClientTable_Index("JournalsCash", "OrganisationID, JournalNumber DESC")

        # --- STAGE TABLE INDEX CREATION
        Add_StageId_Generic_Index("JournalsCash", "OrganisationId, SourceId")
        Add_StageId_Generic_Index("JournalsCash", "JournalLine_JournalLineId")
        Add_StageId_Generic_Index("JournalsCash", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount")
        Add_StageId_Generic_Index("JournalsCash", "JournalDate")  # good to have date
        Add_StageId_Generic_Index("JournalsCash", "JournalId")  # good to have JournalID

        # Transactions (Production Table)
        Add_ClientTable_Index("Transactions", "OrganisationId,Id")
        Add_ClientTable_Index("Transactions", "OrganisationID,AccountCode,LineAmount")  # Composite for join

        # --- Other tables (Keep existing calls) ---
        Add_ClientTable_Index("creditnotes", "OrganisationId,CreditNoteId")
        Add_ClientTable_Index("invoices", "OrganisationId,InvoiceId")
        Add_ClientTable_Index("Invoices", "OrganisationId")
        Add_ClientTable_Index("Invoices", "InvoiceId")
        Add_ClientTable_Index("Invoices", "InvoiceId,UpdatedDateUTC")
        Add_ClientTable_Index("Invoices", "OrganisationID,InvoiceId")
        Add_ClientTable_Index("BankTransactions", "OrganisationId")
        Add_ClientTable_Index("BankTransactions", "BankTransactionId")
        Add_ClientTable_Index("BankTransactions", "OrganisationId,BankTransactionId")
        Add_ClientTable_Index("BankTransactions", "LineItem_LineItemId")
        Add_ClientTable_Index("BankTransactions", "BankTransactionId,LineItem_LineItemId")
        Add_ClientTable_Index("BankTransactions", "Id, OrganisationID")
        Add_ClientTable_Index("banktransfers", "OrganisationId,BankTransferId")
        Add_ClientTable_Index("BatchPayments", "OrganisationId,BatchPaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,PaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,UpdatedDateUTC")
        Add_ClientTable_Index("Payments", "OrganisationID,InvoiceId,PaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,InvoiceId,PaymentType")
        Add_ClientTable_Index("accounts", "OrganisationID,Code")
        Add_ClientTable_Index("accounts", "SystemAccount")
        Add_ClientTable_Index("accounts", "AccountId,OrganisationID")
        Add_ClientTable_Index("accounts", "AccountId,OrganisationID,AccountType")
        Add_ClientTable_Index("accounts", "AccountId,OrganisationID,AccountType,Name")
        Add_ClientTable_Index("accounts", "AccountId")  # Add this
        Add_ClientTable_Index("accounts", "OrganisationID,AccountType")
        Add_ClientTable_Index("OverPayments", "OrganisationID,OverpaymentId")
        Add_ClientTable_Index("PrePayments", "OrganisationID,PrepaymentId")
        Add_ClientTable_Index("Contacts", "OrganisationID,ContactId")
        Add_ClientTable_Index("ManualJournals", "OrganisationId,ManualJournalId")
        Add_ClientTable_Index("organisationsclients", "OrganisationID,BaseCurrency")
        Add_ClientTable_Index("budgets", "`BudgetLines.AccountCode`,OrganisationID")


    except TypeError as e:
        if "missing 1 required positional argument" in str(e):
            print(f"Error in index creation: {e}")
        else:
            raise
    except Exception as e:
        print(f"Unexpected error in CheckAndInitIndexes: {e}")


@aws_credentials_auto_refresh
def check_procedure_exists(procedure_name):
    """
    Check if a stored procedure exists in the database
    """
    try:
        query = text(f"""
            SELECT COUNT(*) AS procedure_count
            FROM information_schema.routines
            WHERE routine_type = 'PROCEDURE'
            AND routine_name = :procedure_name
        """)

        with eva_engine.connect() as connection:
            result = connection.execute(query, {"procedure_name": procedure_name})
            row = result.fetchone()
            # Return True if procedure exists (count > 0)
            return row is not None and row[0] > 0
    except Exception as e:
        print(f"Error checking procedure existence: {e}")
        return False


@aws_credentials_auto_refresh
def get_max_etl_update_time(client_number: str, org_id: str, integration_name: str, endpoint_name: str,
                            timestamp_format: str = None, etani_link_org_id: str = None) -> str:
    """
    Get maximum EtlUpdateTime from production table for incremental loading.
    Returns formatted timestamp string or formatted default if not found.

    Args:
        client_number: Client number extracted from EtaniClientID
        org_id: Organization ID (EtaniOrganisationID)
        integration_name: Integration name (e.g. myob, xero)
        endpoint_name: Endpoint name (e.g. Invoices, Payments)
        timestamp_format: Format for timestamp output
        etani_link_org_id: EtaniLinkOrganisationID (optional, for myob_detailed)
    """

    # Default datetime for first time sync
    default_datetime = datetime(1970, 1, 1, 0, 0, 0)

    try:
        prod_table = f"c{client_number}_{integration_name.lower()}_{endpoint_name.lower()}"

        with eva_engine.connect() as conn:
            table_check_sql = f"SHOW TABLES LIKE :table_name"
            if not conn.execute(text(table_check_sql), {"table_name": prod_table}).fetchone():
                return format_timestamp(default_datetime, timestamp_format)

            desc_result = conn.execute(text(f"DESCRIBE `{prod_table}`"))
            columns = [row[0] for row in desc_result.fetchall()]
            if "etlupdatetime" not in columns:
                return format_timestamp(default_datetime, timestamp_format)

            # Use EtaniLinkOrganisationID instead of OrganisationID if available
            # This is used for myob_detailed when usingEtaniLinkOrganisationID = true
            organisation_id_to_use = etani_link_org_id if etani_link_org_id else org_id

            result = conn.execute(text(
                f"SELECT MAX(`etlupdatetime`) FROM `{prod_table}` WHERE `OrganisationID` = :org_id"
            ), {"org_id": organisation_id_to_use})

            max_etl_time = result.scalar()

            if not max_etl_time:
                return format_timestamp(default_datetime, timestamp_format)

            if isinstance(max_etl_time, str):
                etl_datetime = datetime.fromisoformat(max_etl_time.replace("Z", "+00:00"))
            else:
                etl_datetime = max_etl_time

            return format_timestamp(etl_datetime, timestamp_format)

    except Exception as e:
        logger.error(f"Error getting max EtlUpdateTime: {e}")
        return format_timestamp(default_datetime, timestamp_format)

def GetCMSDetails(etani_client_id, etani_organisation_id, xero_tenant_id=None):
    """
    Get CMS details for token fallback.
    Retrieves refresh_token from client_service.Details JSON when S3 token is not found.

    Args:
        etani_client_id: EtaniClientID (e.g., 'TIGERS_CLIENT6918')
        etani_organisation_id: EtaniOrganisationID (the client_service.Id)
        xero_tenant_id: XeroTenantID (optional, for verification)

    Returns:
        pandas DataFrame with RefreshToken, tenantId, Status columns
        Empty DataFrame if not found or error
    """
    import pandas as pd

    try:
        # Use global cms_engine to query CMS database
        with cms_engine.connect() as conn:
            query = text("""
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(Details, '$.refresh_token')) AS RefreshToken,
                    JSON_UNQUOTE(JSON_EXTRACT(Details, '$.tenantId')) AS tenantId,
                    Status
                FROM client_service
                WHERE Id = :org_id
            """)
            
            result = conn.execute(query, {'org_id': etani_organisation_id})
            rows = result.fetchall()
            
            if rows:
                df = pd.DataFrame(rows, columns=['RefreshToken', 'tenantId', 'Status'])
                logger.info(f"GetCMSDetails: Found details for org {etani_organisation_id}, Status={df.loc[0, 'Status']}")
                return df
            else:
                logger.warning(f"GetCMSDetails: No details found for org {etani_organisation_id}")
                return pd.DataFrame()
    
    except Exception as e:
        logger.error(f"GetCMSDetails error for org {etani_organisation_id}: {e}")
        return pd.DataFrame()
