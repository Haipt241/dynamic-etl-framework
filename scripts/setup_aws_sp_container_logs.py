"""
Script to create sp_add_container_logs stored procedure in AWS vibedb_cms database
"""

# Support direct operational CLI execution.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import os
import sys

# Set AWS credentials
os.environ['USE_AWS_DB'] = 'True'
os.environ['AWS_ACCESS_KEY_ID'] = 'REDACTED'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'REDACTED'

# Import after setting env vars
import config
from sqlalchemy import create_engine, text
import boto3
import json

def get_aws_credentials():
    """Get AWS RDS credentials from Secrets Manager"""
    secret_name = config.AWS_RDS_SECRET_NAME
    region_name = config.AWS_RDS_REGION

    try:
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        response = client.get_secret_value(SecretId=secret_name)
        secret = response['SecretString']

        try:
            secret_dict = json.loads(secret)
            return secret_dict.get('username', config.AWS_RDS_USERNAME), secret_dict.get('password')
        except json.JSONDecodeError:
            return config.AWS_RDS_USERNAME, secret
    except Exception as e:
        print(f"Error retrieving credentials: {e}")
        raise

def create_stored_procedure():
    """Create the sp_add_container_logs stored procedure"""

    # Get credentials
    username, password = get_aws_credentials()

    # Create engine for vibedb_cms
    connection_string = f"mysql+pymysql://REDACTED:REDACTED@{config.AWS_RDS_HOST}/vibedb_cms"
    engine = create_engine(connection_string, echo=True)

    # First, check if container_logs table exists
    check_table_sql = """
    SELECT COUNT(*) as count
    FROM information_schema.tables
    WHERE table_schema = 'vibedb_cms'
    AND table_name = 'container_logs'
    """

    # Create/update table with all required columns
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS container_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        integration VARCHAR(50),
        organisation_id INT,
        client_id INT,
        firm_id INT,
        start_date DATETIME NULL,
        end_date DATETIME NULL,
        status VARCHAR(50),
        log_id VARCHAR(255) UNIQUE,
        remarks TEXT,
        platform VARCHAR(20),
        region VARCHAR(50),
        container_name VARCHAR(100),
        duration_seconds INT,
        trigger_type VARCHAR(50),
        error_details TEXT,
        vcpu DECIMAL(3,1),
        memory_gb DECIMAL(4,1),
        ecs_task_id VARCHAR(100),
        cloudwatch_url VARCHAR(500),
        task_definition VARCHAR(100),
        vcpu_allocated DECIMAL(3,1),
        memory_gb_allocated DECIMAL(4,1),
        cpu_peak_pct DECIMAL(5,2),
        cpu_avg_pct DECIMAL(5,2),
        memory_peak_gb DECIMAL(5,3),
        memory_avg_gb DECIMAL(5,3),
        recommended_size VARCHAR(20),
        cost_usd DECIMAL(8,4),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_log_id (log_id),
        INDEX idx_organisation (organisation_id),
        INDEX idx_client (client_id),
        INDEX idx_status (status)
    )
    """

    # Drop existing procedure
    drop_proc_sql = "DROP PROCEDURE IF EXISTS sp_add_container_logs"

    # Create stored procedure
    create_proc_sql = """
    CREATE PROCEDURE sp_add_container_logs(
         IN p_integration VARCHAR(50),
      IN p_organisation_id INT,
      IN p_client_id INT,
      IN p_firm_id INT,
      IN p_start_date DATETIME,
      IN p_end_date DATETIME,
      IN p_status VARCHAR(50),
      IN p_log_id VARCHAR(255),
      IN p_remarks TEXT,
      IN p_platform VARCHAR(20),
      IN p_region VARCHAR(50),
      IN p_container_name VARCHAR(100),
      IN p_duration_seconds INT,
      IN p_trigger_type VARCHAR(50),
      IN p_error_details TEXT,
      IN p_vcpu DECIMAL(3,1),
      IN p_memory_gb DECIMAL(4,1),
      IN p_ecs_task_id VARCHAR(100),
      IN p_cloudwatch_url VARCHAR(500),
      IN p_task_definition VARCHAR(100),
      IN p_vcpu_allocated DECIMAL(3,1),
      IN p_memory_gb_allocated DECIMAL(4,1),
      IN p_cpu_peak_pct DECIMAL(5,2),
      IN p_cpu_avg_pct DECIMAL(5,2),
      IN p_memory_peak_gb DECIMAL(5,3),
      IN p_memory_avg_gb DECIMAL(5,3),
      IN p_recommended_size VARCHAR(20),
      IN p_cost_usd DECIMAL(8,4)
    )
    BEGIN
      -- Check if log_id already exists
      IF EXISTS (SELECT 1 FROM container_logs WHERE log_id = p_log_id) THEN
          -- Update existing record
          UPDATE container_logs
          SET
              end_date = p_end_date,
              status = p_status,
              remarks = p_remarks,
              duration_seconds = p_duration_seconds,
              error_details = p_error_details,
              vcpu = COALESCE(p_vcpu, vcpu),
              memory_gb = COALESCE(p_memory_gb, memory_gb),
              ecs_task_id = COALESCE(p_ecs_task_id, ecs_task_id),
              cloudwatch_url = COALESCE(p_cloudwatch_url, cloudwatch_url),
              task_definition = COALESCE(p_task_definition, task_definition),
              vcpu_allocated = COALESCE(p_vcpu_allocated, vcpu_allocated),
              memory_gb_allocated = COALESCE(p_memory_gb_allocated, memory_gb_allocated),
              cpu_peak_pct = COALESCE(p_cpu_peak_pct, cpu_peak_pct),
              cpu_avg_pct = COALESCE(p_cpu_avg_pct, cpu_avg_pct),
              memory_peak_gb = COALESCE(p_memory_peak_gb, memory_peak_gb),
              memory_avg_gb = COALESCE(p_memory_avg_gb, memory_avg_gb),
              recommended_size = COALESCE(p_recommended_size, recommended_size),
              cost_usd = COALESCE(p_cost_usd, cost_usd)
          WHERE log_id = p_log_id;
      ELSE
          -- Insert new record
          INSERT INTO container_logs (
              integration, organisation_id, client_id, firm_id,
              start_date, end_date, status, log_id, remarks,
              platform, region, container_name, duration_seconds,
              trigger_type, error_details, vcpu, memory_gb,
              ecs_task_id, cloudwatch_url,
              task_definition, vcpu_allocated, memory_gb_allocated,
              cpu_peak_pct, cpu_avg_pct, memory_peak_gb, memory_avg_gb,
              recommended_size, cost_usd
          ) VALUES (
              p_integration, p_organisation_id, p_client_id, p_firm_id,
              p_start_date, p_end_date, p_status, p_log_id, p_remarks,
              p_platform, p_region, p_container_name, p_duration_seconds,
              p_trigger_type, p_error_details, p_vcpu, p_memory_gb,
              p_ecs_task_id, p_cloudwatch_url,
              p_task_definition, p_vcpu_allocated, p_memory_gb_allocated,
              p_cpu_peak_pct, p_cpu_avg_pct, p_memory_peak_gb, p_memory_avg_gb,
              p_recommended_size, p_cost_usd
          );
      END IF;
    END
    """

    # Individual column additions (safer for existing tables)
    new_columns = [
        "ALTER TABLE container_logs ADD COLUMN platform VARCHAR(20)",
        "ALTER TABLE container_logs ADD COLUMN region VARCHAR(50)",
        "ALTER TABLE container_logs ADD COLUMN container_name VARCHAR(100)",
        "ALTER TABLE container_logs ADD COLUMN duration_seconds INT",
        "ALTER TABLE container_logs ADD COLUMN trigger_type VARCHAR(50)",
        "ALTER TABLE container_logs ADD COLUMN error_details TEXT",
        "ALTER TABLE container_logs ADD COLUMN vcpu DECIMAL(3,1)",
        "ALTER TABLE container_logs ADD COLUMN memory_gb DECIMAL(4,1)",
        "ALTER TABLE container_logs ADD COLUMN ecs_task_id VARCHAR(100)",
        "ALTER TABLE container_logs ADD COLUMN cloudwatch_url VARCHAR(500)",
        "ALTER TABLE container_logs ADD COLUMN task_definition VARCHAR(100)",
        "ALTER TABLE container_logs ADD COLUMN vcpu_allocated DECIMAL(3,1)",
        "ALTER TABLE container_logs ADD COLUMN memory_gb_allocated DECIMAL(4,1)",
        "ALTER TABLE container_logs ADD COLUMN cpu_peak_pct DECIMAL(5,2)",
        "ALTER TABLE container_logs ADD COLUMN cpu_avg_pct DECIMAL(5,2)",
        "ALTER TABLE container_logs ADD COLUMN memory_peak_gb DECIMAL(5,3)",
        "ALTER TABLE container_logs ADD COLUMN memory_avg_gb DECIMAL(5,3)",
        "ALTER TABLE container_logs ADD COLUMN recommended_size VARCHAR(20)",
        "ALTER TABLE container_logs ADD COLUMN cost_usd DECIMAL(8,4)"
    ]

    try:
        with engine.connect() as connection:
            # Check if table exists
            print("Checking if container_logs table exists...")
            result = connection.execute(text(check_table_sql)).scalar()

            if result == 0:
                print("Creating container_logs table...")
                connection.execute(text(create_table_sql))
                connection.commit()
                print("✓ Table created successfully")
            else:
                print("✓ Table already exists")

                # Add missing columns to existing table one by one
                print("Adding missing columns to existing table...")
                columns_added = 0
                for column_sql in new_columns:
                    try:
                        connection.execute(text(column_sql))
                        connection.commit()
                        columns_added += 1
                    except Exception as e:
                        if "Duplicate column name" in str(e):
                            continue  # Column already exists
                        else:
                            print(f"⚠️ Warning adding column: {e}")
                            break
                print(f"✓ Added {columns_added} new columns successfully")

            # Drop existing procedure
            print("\nDropping existing stored procedure if exists...")
            connection.execute(text(drop_proc_sql))
            connection.commit()
            print("✓ Dropped (if existed)")

            # Create new procedure
            print("\nCreating sp_add_container_logs stored procedure...")
            connection.execute(text(create_proc_sql))
            connection.commit()
            print("✓ Stored procedure created successfully!")

            # Test the procedure
            print("\nTesting stored procedure...")
            test_sql = """
            CALL sp_add_container_logs(
                'TEST', 999, 1518, 124,
                NOW(), NOW(),
                'Testing', 'test-log-id-123',
                'Test setup script',
                'AWS', 'ap-southeast-2', 'test-container', 60, 'MANUAL', NULL,
                1.0, 2.0, '', '', '',
                1.0, 2.0, NULL, NULL, NULL, NULL, NULL, 0.0
            )
            """
            connection.execute(text(test_sql))
            connection.commit()
            print("✓ Test call successful!")

            # Verify the test entry
            verify_sql = "SELECT * FROM container_logs WHERE log_id = 'test-log-id-123'"
            result = connection.execute(text(verify_sql))
            row = result.fetchone()
            if row:
                print(f"✓ Verified: Test entry created with log_id: {row[8]}")

            print("\n" + "="*60)
            print("SUCCESS! The stored procedure is ready to use.")
            print("="*60)

    except Exception as e:
        print(f"\n❌ Error: {e}")
        raise
    finally:
        engine.dispose()

if __name__ == "__main__":
    print("="*60)
    print("AWS RDS - sp_add_container_logs Setup Script")
    print("="*60)
    print(f"\nTarget Database: vibedb_cms")
    print(f"Host: {config.AWS_RDS_HOST}")
    print(f"Region: {config.AWS_RDS_REGION}\n")

    try:
        create_stored_procedure()
    except Exception as e:
        print(f"\n❌ Setup failed: {e}")
        sys.exit(1)
