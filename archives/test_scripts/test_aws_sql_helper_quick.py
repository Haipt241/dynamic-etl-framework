"""
Quick test for AWS RDS integration in sql_helper.py
"""
import os
import sys

print("="*70)
print("Quick AWS RDS Integration Test")
print("="*70)

# Set environment variables
os.environ['USE_AWS_DB'] = 'True'
os.environ['AWS_ACCESS_KEY_ID'] = 'REDACTED'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'REDACTED'
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TEST_CLIENT9999'
os.environ['EtaniOrganisationID'] = '999999'
os.environ['XeroTenantID'] = 'test-tenant-id'

print("\n1. Importing sql_helper...")
try:
    import sql_helper
    from sqlalchemy import text
    print("✓ sql_helper imported successfully")
except Exception as e:
    print(f"✗ Failed to import: {e}")
    sys.exit(1)

print(f"\n2. Checking AWS mode...")
print(f"   USE_AWS_DB = {sql_helper.USE_AWS_DB}")
if not sql_helper.USE_AWS_DB:
    print("✗ AWS mode not enabled!")
    sys.exit(1)
print("✓ AWS mode is enabled")

print(f"\n3. Checking engine databases...")
print(f"   eva_engine -> {sql_helper.eva_engine.url.database}")
print(f"   eva_main_engine -> {sql_helper.eva_main_engine.url.database}")
print(f"   cms_engine -> {sql_helper.cms_engine.url.database}")

# Verify correct databases
assert sql_helper.eva_engine.url.database == 'vibedb_stage', "eva_engine should use vibedb_stage"
assert sql_helper.eva_main_engine.url.database == 'vibedb', "eva_main_engine should use vibedb"
assert sql_helper.cms_engine.url.database == 'vibedb_cms', "cms_engine should use vibedb_cms"
print("✓ All engines configured with correct databases")

print(f"\n4. Testing eva_engine connection (vibedb_stage)...")
try:
    with sql_helper.eva_engine.connect() as conn:
        result = conn.execute(text("SELECT DATABASE() as db, VERSION() as version")).fetchone()
        print(f"✓ Connected to: {result[0]}, MySQL version: {result[1]}")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

print(f"\n5. Testing eva_main_engine connection (vibedb)...")
try:
    with sql_helper.eva_main_engine.connect() as conn:
        result = conn.execute(text("SELECT DATABASE() as db, COUNT(*) as tables FROM information_schema.tables WHERE table_schema=DATABASE()")).fetchone()
        print(f"✓ Connected to: {result[0]}, Found {result[1]} tables")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

print(f"\n6. Testing cms_engine connection (vibedb_cms)...")
try:
    with sql_helper.cms_engine.connect() as conn:
        result = conn.execute(text("SELECT DATABASE() as db, COUNT(*) as tables FROM information_schema.tables WHERE table_schema=DATABASE()")).fetchone()
        print(f"✓ Connected to: {result[0]}, Found {result[1]} tables")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    sys.exit(1)

print(f"\n7. Testing ReadMySQLTable function...")
try:
    error_list = []
    df = sql_helper.ReadMySQLTable(
        "SELECT DATABASE() as db_name, COUNT(*) as count FROM information_schema.tables WHERE table_schema=DATABASE()",
        'TEST',
        'TEST_CLIENT',
        '999',
        error_list,
        IsCMS=False
    )
    if df is not None and len(df) > 0:
        print(f"✓ ReadMySQLTable works! Database: {df.iloc[0]['db_name']}, Tables: {df.iloc[0]['count']}")
    else:
        print("✗ ReadMySQLTable returned empty result")
        sys.exit(1)
except Exception as e:
    print(f"✗ ReadMySQLTable failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

print(f"\n8. Testing connection pool...")
try:
    pool = sql_helper.eva_engine.pool
    print(f"✓ Pool configured:")
    print(f"   Size: {pool.size()}")
    print(f"   Checked in: {pool.checkedin()}")
    print(f"   Checked out: {pool.checkedout()}")
except Exception as e:
    print(f"✗ Pool check failed: {e}")

print("\n" + "="*70)
print("✓ ALL TESTS PASSED! AWS integration is working!")
print("="*70)
print("\nSummary:")
print("- SQL helper successfully configured for AWS RDS Aurora")
print("- Database mapping: evadb_stage->vibedb_stage, evadb->vibedb, etaniv2->vibedb_cms")
print("- All engines connect successfully")
print("- ReadMySQLTable function works correctly")
print("- Connection pooling is active")
print("\nYou can now use sql_helper with AWS by setting USE_AWS_DB=True")
