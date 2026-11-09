"""
AWS RDS Aurora Database Helper with Connection Pooling

This module provides connection pooling and helper functions for AWS RDS Aurora MySQL.
It retrieves credentials securely from AWS Secrets Manager and uses SQLAlchemy for
connection pooling.
"""

import json
import logging
import boto3
from botocore.exceptions import ClientError
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError, ProgrammingError, OperationalError
from sqlalchemy.pool import QueuePool
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type
import config

# Set up logging
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# Cache for AWS credentials to avoid repeated calls to Secrets Manager
_aws_credentials_cache = None


def _get_awsrds_secret(use_secrets_manager=True, direct_password=None):
    """
    Retrieve RDS credentials from AWS Secrets Manager or use direct credentials.
    Caches the result to avoid repeated API calls.

    Args:
        use_secrets_manager (bool): If True, retrieve from AWS Secrets Manager.
                                    If False, use direct credentials.
        direct_password (str, optional): Direct password for database connection.
                                         Used when use_secrets_manager is False.

    Returns:
        dict: Dictionary containing 'username' and 'password'
    """
    global _aws_credentials_cache

    # Return cached credentials if available
    if _aws_credentials_cache is not None:
        return _aws_credentials_cache

    # Option 1: Use direct credentials (for testing or when Secrets Manager is unavailable)
    if not use_secrets_manager:
        if direct_password is None:
            raise ValueError("direct_password must be provided when use_secrets_manager is False")

        _aws_credentials_cache = {
            'username': config.AWS_RDS_USERNAME,
            'password': direct_password
        }
        logger.info("Using direct credentials (not Secrets Manager)")
        return _aws_credentials_cache

    # Option 2: Use AWS Secrets Manager (recommended for production)
    secret_name = config.AWS_RDS_SECRET_NAME
    region_name = config.AWS_RDS_REGION

    try:
        # Create a Secrets Manager client
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

        # Get the secret string
        secret = get_secret_value_response['SecretString']

        # Parse the secret - AWS RDS secrets are typically stored as JSON
        # with keys like: {"username": "vibeadmin", "password": "REDACTED"}
        try:
            secret_dict = json.loads(secret)
            username = secret_dict.get('username', config.AWS_RDS_USERNAME)
            password = secret_dict.get('password')

            if not password:
                raise ValueError("Password not found in secret")

        except (json.JSONDecodeError, KeyError) as e:
            # If it's not JSON, treat the whole string as the password
            logger.warning(f"Secret is not valid JSON, treating as plain password string: {e}")
            username = config.AWS_RDS_USERNAME
            password = secret

        # Cache the credentials
        _aws_credentials_cache = {
            'username': username,
            'password': password
        }

        logger.info(f"Retrieved credentials from AWS Secrets Manager for user: {username}")
        return _aws_credentials_cache

    except ClientError as e:
        error_code = e.response.get('Error', {}).get('Code', 'Unknown')
        error_message = e.response.get('Error', {}).get('Message', str(e))
        logger.error(f"Failed to retrieve secret from AWS Secrets Manager. Error: {error_code} - {error_message}")
        raise e


def _create_aws_engine(database=None, use_secrets_manager=True, direct_password=None):
    """
    Create a SQLAlchemy engine with connection pooling for AWS RDS Aurora.

    Args:
        database (str, optional): Database name. Defaults to config.AWS_RDS_DATABASE
        use_secrets_manager (bool): If True, use AWS Secrets Manager for credentials
        direct_password (str, optional): Direct password (used when use_secrets_manager=False)

    Returns:
        Engine: SQLAlchemy engine with connection pooling
    """
    # Get credentials
    credentials = _get_awsrds_secret(use_secrets_manager, direct_password)

    # Use provided database or default from config
    db_name = database or config.AWS_RDS_DATABASE

    # Build connection string
    connection_string = (
        f"mysql+pymysql://{credentials['username']}:{credentials['password']}"
        f"@{config.AWS_RDS_HOST}/{db_name}"
    )

    # Create engine with connection pooling
    engine = create_engine(
        connection_string,
        poolclass=QueuePool,
        pool_size=10,              # Number of connections to keep in the pool
        max_overflow=20,           # Maximum overflow connections beyond pool_size
        pool_timeout=30,           # Seconds to wait before giving up on getting a connection
        pool_recycle=3600,         # Recycle connections after 1 hour (prevents stale connections)
        pool_pre_ping=True,        # Verify connections before using them
        echo=False,                # Set to True for SQL query logging (debug mode)
    )

    logger.info(f"AWS RDS connection pool created for database: {db_name}")
    return engine


# Global engine will be initialized on first use or explicitly
aws_eva_engine = None


def initialize_aws_engine(use_secrets_manager=True, direct_password=None):
    """
    Initialize the global AWS engine.

    Args:
        use_secrets_manager (bool): If True, use AWS Secrets Manager
        direct_password (str, optional): Direct password (for testing)
    """
    global aws_eva_engine
    if aws_eva_engine is None:
        aws_eva_engine = _create_aws_engine(
            config.AWS_RDS_DATABASE,
            use_secrets_manager,
            direct_password
        )
    return aws_eva_engine


def log_retry_attempt(retry_state):
    """Log retry attempts for database operations."""
    fn_name = retry_state.fn.__name__
    retry_msg = f"Retrying {fn_name} (Attempt {retry_state.attempt_number}) due to {retry_state.outcome.exception()}"
    # logger.info(retry_msg)  # Suppress retry log output


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    before_sleep=log_retry_attempt
)
def execute_aws_query(query, params=None, database=None):
    """
    Execute a SQL query on AWS RDS Aurora with automatic retry.

    Args:
        query (str): SQL query to execute
        params (dict, optional): Query parameters
        database (str, optional): Database name (uses default if not provided)

    Returns:
        Result object from the query execution
    """
    global aws_eva_engine
    if aws_eva_engine is None:
        raise RuntimeError("AWS engine not initialized. Call initialize_aws_engine() first.")

    engine = aws_eva_engine if database is None else _create_aws_engine(database)

    try:
        with engine.connect() as connection:
            if params:
                result = connection.execute(text(query), params)
            else:
                result = connection.execute(text(query))
            connection.commit()
            return result
    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        logger.error(f"Failed to execute query: {e}")
        raise


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    before_sleep=log_retry_attempt
)
def execute_aws_stored_procedure(procedure_name, params=None, database=None):
    """
    Execute a stored procedure on AWS RDS Aurora.

    Args:
        procedure_name (str): Name of the stored procedure
        params (dict, optional): Procedure parameters
        database (str, optional): Database name

    Returns:
        Result object from the procedure execution
    """
    engine = aws_eva_engine if database is None else _create_aws_engine(database)

    try:
        sql = f"CALL {procedure_name}"
        with engine.connect() as connection:
            if params:
                result = connection.execute(text(sql), params)
            else:
                result = connection.execute(text(sql))
            connection.commit()
            logger.info(f"Successfully executed stored procedure: {procedure_name}")
            return result
    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        logger.error(f"Failed to execute stored procedure {procedure_name}: {e}")
        raise


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    before_sleep=log_retry_attempt
)
def read_aws_table(query, params=None, database=None):
    """
    Read data from AWS RDS Aurora and return as pandas DataFrame.

    Args:
        query (str): SELECT query
        params (dict, optional): Query parameters
        database (str, optional): Database name

    Returns:
        pandas.DataFrame: Query results as DataFrame
    """
    import pandas as pd

    engine = aws_eva_engine if database is None else _create_aws_engine(database)

    try:
        with engine.connect() as connection:
            if params:
                df = pd.read_sql(text(query), connection, params=params)
            else:
                df = pd.read_sql(text(query), connection)
            logger.info(f"Successfully read {len(df)} rows from AWS RDS")
            return df
    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        logger.error(f"Failed to read from AWS RDS: {e}")
        raise


@retry(
    retry=retry_if_exception_type((SQLAlchemyError, ProgrammingError, OperationalError)),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10),
    before_sleep=log_retry_attempt
)
def load_to_aws_table(df, table_name, write_mode='append', database=None):
    """
    Load a pandas DataFrame to AWS RDS Aurora table.

    Args:
        df (pandas.DataFrame): DataFrame to load
        table_name (str): Target table name
        write_mode (str): 'append' or 'replace' (default: 'append')
        database (str, optional): Database name

    Returns:
        int: Number of rows inserted
    """
    engine = aws_eva_engine if database is None else _create_aws_engine(database)

    try:
        # Use pandas to_sql with SQLAlchemy engine
        rows_inserted = df.to_sql(
            name=table_name,
            con=engine,
            if_exists=write_mode,
            index=False,
            method='multi',
            chunksize=1000
        )
        logger.info(f"Successfully loaded {len(df)} rows to table {table_name}")
        return rows_inserted
    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        logger.error(f"Failed to load data to AWS RDS table {table_name}: {e}")
        raise


def test_aws_connection():
    """
    Test the AWS RDS connection and pool.

    Returns:
        bool: True if connection is successful, False otherwise
    """
    try:
        with aws_eva_engine.connect() as connection:
            result = connection.execute(text("SELECT 1 as test"))
            row = result.fetchone()
            if row[0] == 1:
                logger.info("AWS RDS connection test successful!")
                logger.info(f"Connection pool size: {aws_eva_engine.pool.size()}")
                return True
    except Exception as e:
        logger.error(f"AWS RDS connection test failed: {e}")
        return False

    return False


def get_pool_status():
    """
    Get the current status of the connection pool.

    Returns:
        dict: Pool statistics
    """
    pool = aws_eva_engine.pool
    return {
        'pool_size': pool.size(),
        'checked_in_connections': pool.checkedin(),
        'checked_out_connections': pool.checkedout(),
        'overflow': pool.overflow(),
        'total_connections': pool.size() + pool.overflow()
    }


def close_aws_connections():
    """
    Properly dispose of all AWS RDS connections.
    Call this when shutting down the application.
    """
    try:
        aws_eva_engine.dispose()
        logger.info("AWS RDS connection pool disposed successfully")
    except Exception as e:
        logger.error(f"Error disposing AWS RDS connection pool: {e}")


if __name__ == "__main__":
    # Test the connection when module is run directly
    print("Testing AWS RDS connection...")
    if test_aws_connection():
        print("Connection test passed!")
        print(f"Pool status: {get_pool_status()}")
    else:
        print("Connection test failed!")
