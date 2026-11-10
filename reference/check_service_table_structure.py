#!/usr/bin/env python3
"""
Check vibedb_cms.service table structure to understand current schema
and plan for integration_name column addition
"""
import os
import sys
import json
import boto3
from sqlalchemy import create_engine, text

# Only set USE_AWS_DB to use AWS database
os.environ['USE_AWS_DB'] = 'True'
# Set AWS credentials directly for this script
os.environ['AWS_ACCESS_KEY_ID'] = 'REDACTED'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'REDACTED'

# Import config after setting environment variables
import config

def get_aws_rds_credentials():
    """Get AWS RDS credentials from Secrets Manager - simplified for CMS access only"""
    try:
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=config.AWS_RDS_REGION
        )

        response = client.get_secret_value(SecretId=config.AWS_RDS_SECRET_NAME)
        secret = response['SecretString']

        try:
            secret_dict = json.loads(secret)
            return secret_dict.get('username', config.AWS_RDS_USERNAME), secret_dict.get('password')
        except json.JSONDecodeError:
            return config.AWS_RDS_USERNAME, secret
    except Exception as e:
        print(f"Error retrieving AWS RDS credentials: {e}")
        raise

def create_direct_cms_engine():
    """Create direct engine for vibedb_cms database"""
    username, password = get_aws_rds_credentials()
    connection_string = f"mysql+pymysql://REDACTED:REDACTED@{config.AWS_RDS_HOST}/vibedb_cms"
    return create_engine(connection_string, echo=False)

def check_service_table_structure():
    """Check current structure of vibedb_cms.service table"""
    try:
        print("=" * 80)
        print("VIBEDB_CMS.SERVICE TABLE ANALYSIS")
        print("=" * 80)

        engine = create_direct_cms_engine()

        # 1. Describe table structure
        print("\n📋 TABLE STRUCTURE:")
        print("-" * 50)
        with engine.connect() as conn:
            result = conn.execute(text("DESCRIBE vibedb_cms.service"))
            for row in result:
                field, type_, null, key, default, extra = row
                print(f"{field:<20} {type_:<25} {null:<5} {key:<5} {default or 'NULL':<15} {extra}")

        # 2. Show sample data
        print(f"\n📊 SAMPLE SERVICE DATA:")
        print("-" * 50)
        query = text("""
            SELECT
                id,
                Name,
                SUBSTRING(Description, 1, 40) as description_short,
                Status
            FROM vibedb_cms.service
            ORDER BY id
            LIMIT 15
        """)

        with engine.connect() as conn:
            result = conn.execute(query)
            rows = result.fetchall()

            if rows:
                print(f"{'ID':<4} {'Name':<25} {'Description':<42} {'Status'}")
                print("-" * 75)
                for row in rows:
                    print(f"{row[0]:<4} {row[1]:<25} {row[2] or '':<42} {row[3]}")
            else:
                print("⚠️  No data found")

        # 3. Check for specific service IDs from org_parameter_fetcher
        print(f"\n🔍 SERVICES REFERENCED IN ORG_PARAMETER_FETCHER:")
        print("-" * 50)

        # Key service IDs from SERVICE_TO_INTEGRATION mapping
        key_services = [1, 4, 7, 9, 14, 16, 17, 21, 23, 25, 27, 38, 43, 50, 57, 62, 69, 71, 72]

        service_ids_str = ",".join(map(str, key_services))
        query = text(f"""
            SELECT
                id,
                Name,
                SUBSTRING(Description, 1, 30) as description_short,
                Status
            FROM vibedb_cms.service
            WHERE id IN ({service_ids_str})
            ORDER BY id
        """)

        with engine.connect() as conn:
            result = conn.execute(query)
            rows = result.fetchall()

            if rows:
                print(f"{'ID':<4} {'Name':<25} {'Description':<32} {'Status'}")
                print("-" * 65)

                # Hardcoded mapping for comparison
                SERVICE_TO_INTEGRATION = {
                    1: 'xeroblue', 4: 'qbo', 7: 'dq_myobar', 9: 'hubspot',
                    14: 'cin7_dear', 16: 'simpro', 17: 'unleashed', 21: 'payroll_au',
                    23: 'deputy', 25: 'xeroproject', 27: 'cin7', 38: 'shopify',
                    43: 'vinsight', 50: 'karbon_hq', 57: 'keypay', 62: 'tidywork',
                    69: 'wfm', 71: 'myob_detailed', 72: 'fyi'
                }

                for row in rows:
                    service_id, name, desc, status = row
                    integration_name = SERVICE_TO_INTEGRATION.get(service_id, 'NOT_MAPPED')
                    print(f"{service_id:<4} {name:<25} {desc or '':<32} {status}")

                # Show mapping
                print(f"\n🔗 CURRENT HARDCODED MAPPING:")
                print("-" * 50)
                for row in rows:
                    service_id = row[0]
                    service_name = row[1]
                    integration_name = SERVICE_TO_INTEGRATION.get(service_id, 'NOT_MAPPED')
                    print(f"  ID {service_id:2d}: {service_name:<25} → {integration_name}")
            else:
                print("⚠️  No key services found")

        # 4. Check if integration_name column already exists
        print(f"\n🔍 CHECK IF INTEGRATION_NAME COLUMN EXISTS:")
        print("-" * 50)

        with engine.connect() as conn:
            result = conn.execute(text("""
                SELECT COLUMN_NAME
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = 'vibedb_cms'
                AND TABLE_NAME = 'service'
                AND COLUMN_NAME IN ('integration_name', 'config_file_name', 'is_dynamic_integration')
            """))

            existing_columns = [row[0] for row in result]

            if existing_columns:
                print(f"✅ Found existing columns: {existing_columns}")
            else:
                print("❌ No integration-related columns found")
                print("   → TODO implementation needed!")

        print("\n" + "=" * 80)
        print("ANALYSIS COMPLETE")
        print("=" * 80)

        return True

    except Exception as e:
        print(f"❌ Error checking service table: {e}")
        return False

if __name__ == "__main__":
    success = check_service_table_structure()
    if not success:
        sys.exit(1)