"""
Check what databases exist on the Aurora instance
"""
import boto3
import json
from sqlalchemy import create_engine, text
import config

def get_secret():
    secret_name = "rds!cluster-44496612-3d03-451b-9749-88451f45fed7"
    region_name = "ap-northeast-3"

    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region_name)

    response = client.get_secret_value(SecretId=secret_name)
    secret_dict = json.loads(response['SecretString'])
    return secret_dict

print("Retrieving credentials from AWS Secrets Manager...")
creds = get_secret()
print(f"✓ Got credentials for user: {creds['username']}")

# Connect WITHOUT specifying a database
connection_string = (
    f"mysql+pymysql://{creds['username']}:{creds['password']}"
    f"@{config.AWS_RDS_HOST}"  # No database specified
)

print(f"\nConnecting to: {config.AWS_RDS_HOST}")
engine = create_engine(connection_string)

try:
    with engine.connect() as conn:
        print("✓ Connected successfully!")

        # Show all databases
        print("\n" + "="*60)
        print("DATABASES ON THIS AURORA INSTANCE:")
        print("="*60)
        result = conn.execute(text("SHOW DATABASES"))
        databases = [row[0] for row in result]

        for db in databases:
            print(f"  - {db}")

        print("\n" + "="*60)
        print(f"Total databases found: {len(databases)}")

        # Check if evadb_stage exists
        if 'evadb_stage' in databases:
            print("\n✓ Database 'evadb_stage' EXISTS")
        else:
            print("\n✗ Database 'evadb_stage' DOES NOT EXIST")
            print("\nAvailable databases:")
            for db in databases:
                if db not in ['information_schema', 'mysql', 'performance_schema', 'sys']:
                    print(f"  → {db}")

except Exception as e:
    print(f"✗ Error: {e}")
    import traceback
    traceback.print_exc()
finally:
    engine.dispose()
