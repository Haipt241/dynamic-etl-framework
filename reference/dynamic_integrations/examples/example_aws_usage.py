"""
Example: Using AWS RDS Connection Pooling in Your ETL Code

This demonstrates how to integrate AWS RDS connection pooling
into your existing ETL packages.
"""

from aws_db_helper import (
    initialize_aws_engine,
    read_aws_table,
    execute_aws_query,
    load_to_aws_table,
    get_pool_status,
    close_aws_connections
)
import pandas as pd
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# ============================================================================
# INITIALIZATION (Call this once at application startup)
# ============================================================================

def initialize_aws_connection():
    """
    Initialize the AWS RDS connection pool.
    Call this once when your application starts.
    """
    try:
        # For production: Use AWS Secrets Manager
        # This requires AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
        # configured in Azure App Service environment variables
        initialize_aws_engine(use_secrets_manager=True)

        logger.info("AWS RDS connection pool initialized successfully")

        # Optional: Check pool status
        status = get_pool_status()
        logger.info(f"Pool initialized with {status['pool_size']} connections")

    except Exception as e:
        logger.error(f"Failed to initialize AWS connection: {e}")
        raise


# ============================================================================
# EXAMPLE 1: Reading Data (Similar to your existing ReadMySQLTable)
# ============================================================================

def example_read_data():
    """Example: Read data from AWS RDS Aurora."""
    try:
        # Simple query
        df = read_aws_table("SELECT * FROM your_table LIMIT 10")
        logger.info(f"Retrieved {len(df)} rows from AWS RDS")
        print(df.head())

        # Query with parameters (prevents SQL injection)
        query = """
            SELECT * FROM your_table
            WHERE date >= :start_date
            AND status = :status
        """
        df = read_aws_table(
            query,
            params={
                'start_date': '2025-01-01',
                'status': 'active'
            }
        )
        logger.info(f"Retrieved {len(df)} rows with filters")

        return df

    except Exception as e:
        logger.error(f"Error reading data: {e}")
        raise


# ============================================================================
# EXAMPLE 2: Executing Queries (Similar to your existing ExecuteEvaSP)
# ============================================================================

def example_execute_query():
    """Example: Execute INSERT, UPDATE, DELETE queries."""
    try:
        # INSERT example
        execute_aws_query(
            "INSERT INTO your_table (name, value, created_at) VALUES (:name, :value, NOW())",
            params={'name': 'test_item', 'value': 123}
        )
        logger.info("Insert successful")

        # UPDATE example
        execute_aws_query(
            "UPDATE your_table SET status = :status WHERE id = :id",
            params={'status': 'completed', 'id': 1}
        )
        logger.info("Update successful")

        # DELETE example
        execute_aws_query(
            "DELETE FROM your_table WHERE id = :id",
            params={'id': 999}
        )
        logger.info("Delete successful")

    except Exception as e:
        logger.error(f"Error executing query: {e}")
        raise


# ============================================================================
# EXAMPLE 3: Loading DataFrames (Similar to your existing LoadToEvaStageTable)
# ============================================================================

def example_load_dataframe():
    """Example: Load a pandas DataFrame to AWS RDS."""
    try:
        # Create sample DataFrame (in practice, this comes from your API extraction)
        df = pd.DataFrame({
            'organisation_id': ['ORG001', 'ORG002', 'ORG003'],
            'name': ['Company A', 'Company B', 'Company C'],
            'revenue': [100000, 200000, 150000],
            'created_at': pd.Timestamp.now()
        })

        # Load to AWS RDS (similar to LoadToEvaStageTable)
        load_to_aws_table(
            df=df,
            table_name='your_stage_table',
            write_mode='append'  # or 'replace' to truncate first
        )

        logger.info(f"Successfully loaded {len(df)} rows to AWS RDS")

    except Exception as e:
        logger.error(f"Error loading DataFrame: {e}")
        raise


# ============================================================================
# EXAMPLE 4: Migrating from Azure MySQL to AWS RDS
# ============================================================================

def example_migration_pattern():
    """
    Example: How to migrate from your existing Azure MySQL code to AWS RDS.

    OLD CODE (Azure):
    from sql_helper import ReadMySQLTable, ExecuteEvaSP, LoadToEvaStageTable

    df = ReadMySQLTable(query, endpoint, client_id, org_id, error_list)
    ExecuteEvaSP(procedure_name, endpoint, error_list)
    LoadToEvaStageTable(df, endpoint, write_mode, stage_table, error_list)

    NEW CODE (AWS):
    """
    try:
        # Reading data (replaces ReadMySQLTable)
        df = read_aws_table("SELECT * FROM your_table")

        # Executing stored procedure (replaces ExecuteEvaSP)
        # Note: For AWS, you can call procedures directly
        execute_aws_query("CALL your_stored_procedure(:param1, :param2)",
                         params={'param1': 'value1', 'param2': 'value2'})

        # Loading data (replaces LoadToEvaStageTable)
        load_to_aws_table(df, 'your_stage_table', write_mode='append')

        logger.info("Migration pattern executed successfully")

    except Exception as e:
        logger.error(f"Error in migration pattern: {e}")
        raise


# ============================================================================
# EXAMPLE 5: Batch Processing with Connection Pooling
# ============================================================================

def example_batch_processing():
    """
    Example: Process multiple organizations efficiently using connection pool.
    The pool automatically manages connections across multiple operations.
    """
    try:
        # Get list of organizations
        orgs_df = read_aws_table("SELECT organisation_id, name FROM organisations WHERE active = 1")

        logger.info(f"Processing {len(orgs_df)} organizations")

        # Process each organization
        for index, org in orgs_df.iterrows():
            org_id = org['organisation_id']

            # Read data for this org (connection taken from pool)
            data = read_aws_table(
                "SELECT * FROM transactions WHERE organisation_id = :org_id",
                params={'org_id': org_id}
            )

            # Process the data (your business logic here)
            processed_data = data.copy()
            processed_data['processed'] = True
            processed_data['processed_at'] = pd.Timestamp.now()

            # Load back to database (connection returned to pool after use)
            load_to_aws_table(processed_data, 'processed_transactions', write_mode='append')

            logger.info(f"Processed {len(data)} records for org {org_id}")

        # Check pool health
        status = get_pool_status()
        logger.info(f"Pool status: {status['checked_out_connections']} connections in use")

    except Exception as e:
        logger.error(f"Error in batch processing: {e}")
        raise


# ============================================================================
# EXAMPLE 6: Error Handling and Retry Logic
# ============================================================================

def example_with_error_handling():
    """
    Example: The helper already includes retry logic, but you can add
    additional error handling for your specific use cases.
    """
    error_list = []

    try:
        # The functions automatically retry on transient errors
        # (network issues, connection timeouts, etc.)
        df = read_aws_table("SELECT * FROM your_table")

        logger.info(f"Successfully retrieved {len(df)} rows")

    except Exception as e:
        error_msg = f"Failed to read from AWS RDS after retries: {str(e)}"
        logger.error(error_msg)
        error_list.append(error_msg)

        # You can add your custom error handling here
        # e.g., send notification, log to tracking system, etc.

    return error_list


# ============================================================================
# EXAMPLE 7: Application Startup and Shutdown
# ============================================================================

def example_application_lifecycle():
    """
    Example: How to properly initialize and clean up connections
    in your Azure web app.
    """
    import atexit

    # At application startup
    try:
        logger.info("Starting application...")
        initialize_aws_connection()
        logger.info("AWS RDS connection pool ready")

        # Register cleanup function to run on shutdown
        atexit.register(close_aws_connections)

        # Your application code here
        example_read_data()
        example_execute_query()

        logger.info("Application running successfully")

    except Exception as e:
        logger.error(f"Application startup failed: {e}")
        raise


# ============================================================================
# MAIN - Run Examples
# ============================================================================

if __name__ == "__main__":
    """
    To run these examples:
    1. Ensure AWS credentials are configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    2. Run: python example_aws_usage.py
    """
    try:
        print("\n" + "="*70)
        print("AWS RDS Connection Pooling - Usage Examples")
        print("="*70)

        # Initialize connection pool
        print("\n1. Initializing connection pool...")
        initialize_aws_connection()

        # Run examples (comment out as needed)
        print("\n2. Example: Reading data...")
        # example_read_data()

        print("\n3. Example: Executing queries...")
        # example_execute_query()

        print("\n4. Example: Loading DataFrame...")
        # example_load_dataframe()

        print("\n5. Example: Batch processing...")
        # example_batch_processing()

        print("\n" + "="*70)
        print("Examples completed successfully!")
        print("="*70)

        # Show final pool status
        status = get_pool_status()
        print(f"\nFinal pool status:")
        print(f"  Total connections: {status['total_connections']}")
        print(f"  Available: {status['checked_in_connections']}")
        print(f"  In use: {status['checked_out_connections']}")

    except Exception as e:
        logger.error(f"Error running examples: {e}")
        import traceback
        traceback.print_exc()

    finally:
        # Clean up
        print("\nClosing connections...")
        close_aws_connections()
        print("Done!")
