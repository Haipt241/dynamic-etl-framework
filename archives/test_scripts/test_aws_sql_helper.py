"""
Comprehensive test suite for AWS RDS integration in sql_helper.py

This tests all major database operations when USE_AWS_DB=True
"""
import os
import sys
import pandas as pd
import logging

# Set environment variables BEFORE importing sql_helper
os.environ['USE_AWS_DB'] = 'True'
os.environ['AWS_ACCESS_KEY_ID'] = 'REDACTED'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'REDACTED'

# Mock environment variables for ETL operations
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TEST_CLIENT9999'
os.environ['EtaniOrganisationID'] = '999999'
os.environ['XeroTenantID'] = 'test-tenant-id'

# Now import sql_helper (it will use AWS)
import sql_helper
from sql_helper import (
    eva_engine,
    eva_main_engine,
    cms_engine,
    ReadMySQLTable,
    ExecuteEvaSP,
    LoadToEvaStageTable,
    ExecuteCMSSP,
    USE_AWS_DB
)

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def print_header(text):
    """Print a formatted header"""
    print("\n" + "="*70)
    print(f"  {text}")
    print("="*70)


def print_success(text):
    """Print success message"""
    print(f"✓ {text}")


def print_error(text):
    """Print error message"""
    print(f"✗ {text}")


def print_info(text):
    """Print info message"""
    print(f"ℹ {text}")


# ============================================================================
# TEST 1: Verify AWS Mode is Enabled
# ============================================================================

def test_aws_mode():
    """Test that AWS mode is properly enabled"""
    print_header("TEST 1: Verify AWS Mode")

    if USE_AWS_DB:
        print_success("AWS mode is ENABLED")
        print_info(f"eva_engine: {eva_engine.url.database}")
        print_info(f"eva_main_engine: {eva_main_engine.url.database}")
        print_info(f"cms_engine: {cms_engine.url.database}")
        return True
    else:
        print_error("AWS mode is DISABLED - test cannot proceed")
        return False


# ============================================================================
# TEST 2: Test Engine Connections
# ============================================================================

def test_engine_connections():
    """Test that all engines can connect to AWS RDS"""
    print_header("TEST 2: Test Engine Connections")

    results = {}

    # Test eva_engine (vibedb_stage)
    try:
        with eva_engine.connect() as conn:
            result = conn.execute(sql_helper.text("SELECT DATABASE() as db")).fetchone()
            print_success(f"eva_engine connected to: {result[0]}")
            results['eva_engine'] = result[0] == 'vibedb_stage'
    except Exception as e:
        print_error(f"eva_engine connection failed: {e}")
        results['eva_engine'] = False

    # Test eva_main_engine (vibedb)
    try:
        with eva_main_engine.connect() as conn:
            result = conn.execute(sql_helper.text("SELECT DATABASE() as db")).fetchone()
            print_success(f"eva_main_engine connected to: {result[0]}")
            results['eva_main_engine'] = result[0] == 'vibedb'
    except Exception as e:
        print_error(f"eva_main_engine connection failed: {e}")
        results['eva_main_engine'] = False

    # Test cms_engine (vibedb)
    try:
        with cms_engine.connect() as conn:
            result = conn.execute(sql_helper.text("SELECT DATABASE() as db")).fetchone()
            print_success(f"cms_engine connected to: {result[0]}")
            results['cms_engine'] = result[0] == 'vibedb'
    except Exception as e:
        print_error(f"cms_engine connection failed: {e}")
        results['cms_engine'] = False

    all_passed = all(results.values())
    if all_passed:
        print_success("All engine connections successful!")
    else:
        print_error("Some engine connections failed")

    return all_passed


# ============================================================================
# TEST 3: Test ReadMySQLTable Function
# ============================================================================

def test_read_mysql_table():
    """Test the ReadMySQLTable function with AWS"""
    print_header("TEST 3: Test ReadMySQLTable Function")

    error_list = []

    try:
        # Test reading from vibedb_stage (eva_engine)
        print_info("Testing read from vibedb_stage...")
        query = "SELECT DATABASE() as current_db, COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = DATABASE()"
        df = ReadMySQLTable(query, 'TEST', 'TEST_CLIENT', '999', error_list, IsCMS=False)

        if df is not None and len(df) > 0:
            print_success(f"Read from {df.iloc[0]['current_db']}: {df.iloc[0]['table_count']} tables")
            print_info(f"Result:\n{df}")
        else:
            print_error("Failed to read data")
            return False

        # Test reading from vibedb (cms_engine)
        print_info("\nTesting read from vibedb (CMS)...")
        query2 = "SELECT DATABASE() as current_db, VERSION() as version"
        df2 = ReadMySQLTable(query2, 'TEST', 'TEST_CLIENT', '999', error_list, IsCMS=True)

        if df2 is not None and len(df2) > 0:
            print_success(f"Read from {df2.iloc[0]['current_db']}, MySQL version: {df2.iloc[0]['version']}")
        else:
            print_error("Failed to read from CMS")
            return False

        if error_list:
            print_error(f"Errors occurred: {error_list}")
            return False

        print_success("ReadMySQLTable function works correctly with AWS!")
        return True

    except Exception as e:
        print_error(f"ReadMySQLTable test failed: {e}")
        import traceback
        traceback.print_exc()
        return False


# ============================================================================
# TEST 4: Test Database Queries
# ============================================================================

def test_database_queries():
    """Test various database queries"""
    print_header("TEST 4: Test Database Queries")

    error_list = []
    all_passed = True

    try:
        # Test 1: List tables in vibedb_stage
        print_info("Listing tables in vibedb_stage...")
        df = ReadMySQLTable("SHOW TABLES", 'TEST', 'TEST_CLIENT', '999', error_list, IsCMS=False)
        if df is not None:
            table_count = len(df)
            print_success(f"Found {table_count} tables in vibedb_stage")
            if table_count > 0:
                print_info(f"First 5 tables: {df.head().values.tolist()}")
        else:
            print_error("Failed to list tables")
            all_passed = False

        # Test 2: List tables in vibedb
        print_info("\nListing tables in vibedb...")
        df2 = ReadMySQLTable("SHOW TABLES", 'TEST', 'TEST_CLIENT', '999', error_list, IsCMS=True)
        if df2 is not None:
            table_count2 = len(df2)
            print_success(f"Found {table_count2} tables in vibedb")
        else:
            print_error("Failed to list tables in vibedb")
            all_passed = False

        # Test 3: Check if specific tables exist
        print_info("\nChecking for common tables...")
        check_query = """
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
            AND table_name LIKE '_eva_%'
            LIMIT 5
        """
        df3 = ReadMySQLTable(check_query, 'TEST', 'TEST_CLIENT', '999', error_list, IsCMS=True)
        if df3 is not None and len(df3) > 0:
            print_success(f"Found {len(df3)} _eva_ tables:")
            for table in df3['table_name'].values:
                print_info(f"  - {table}")
        else:
            print_info("No _eva_ tables found (this might be expected)")

        if error_list:
            print_error(f"Errors occurred: {error_list}")
            all_passed = False

        if all_passed:
            print_success("Database query tests passed!")

        return all_passed

    except Exception as e:
        print_error(f"Database query test failed: {e}")
        import traceback
        traceback.print_exc()
        return False


# ============================================================================
# TEST 5: Test Pool Status
# ============================================================================

def test_pool_status():
    """Test connection pool status"""
    print_header("TEST 5: Test Connection Pool Status")

    try:
        print_info("eva_engine pool status:")
        pool = eva_engine.pool
        print_info(f"  Pool size: {pool.size()}")
        print_info(f"  Checked in: {pool.checkedin()}")
        print_info(f"  Checked out: {pool.checkedout()}")
        print_info(f"  Overflow: {pool.overflow()}")

        print_info("\neva_main_engine pool status:")
        pool2 = eva_main_engine.pool
        print_info(f"  Pool size: {pool2.size()}")
        print_info(f"  Checked in: {pool2.checkedin()}")
        print_info(f"  Checked out: {pool2.checkedout()}")
        print_info(f"  Overflow: {pool2.overflow()}")

        print_success("Pool status retrieved successfully!")
        return True

    except Exception as e:
        print_error(f"Pool status test failed: {e}")
        return False


# ============================================================================
# TEST 6: Test Concurrent Queries
# ============================================================================

def test_concurrent_queries():
    """Test connection pooling with concurrent queries"""
    print_header("TEST 6: Test Concurrent Queries (Connection Pooling)")

    error_list = []

    try:
        import concurrent.futures

        def run_query(query_num):
            query = f"SELECT {query_num} as query_num, CONNECTION_ID() as conn_id, DATABASE() as db"
            df = ReadMySQLTable(query, 'TEST', f'CLIENT{query_num}', '999', [], IsCMS=False)
            return df.iloc[0].to_dict() if df is not None else None

        print_info("Running 5 concurrent queries...")
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            futures = [executor.submit(run_query, i) for i in range(1, 6)]
            results = [future.result() for future in concurrent.futures.as_completed(futures)]

        if all(results):
            print_success(f"All {len(results)} concurrent queries succeeded!")
            connection_ids = [r['conn_id'] for r in results if r]
            unique_conns = len(set(connection_ids))
            print_info(f"Used {unique_conns} unique connections")
            for r in results:
                print_info(f"  Query {r['query_num']}: Connection {r['conn_id']}, DB: {r['db']}")
            return True
        else:
            print_error("Some concurrent queries failed")
            return False

    except Exception as e:
        print_error(f"Concurrent query test failed: {e}")
        import traceback
        traceback.print_exc()
        return False


# ============================================================================
# RUN ALL TESTS
# ============================================================================

def run_all_tests():
    """Run all test suites"""
    print("\n" + "#"*70)
    print("#  AWS RDS Integration Test Suite for sql_helper.py")
    print("#"*70)

    print_info(f"AWS Mode: {USE_AWS_DB}")
    print_info(f"Target Host: {sql_helper.config.AWS_RDS_HOST}")
    print_info(f"Expected Databases: vibedb_stage, vibedb")

    tests = [
        ("AWS Mode Verification", test_aws_mode),
        ("Engine Connections", test_engine_connections),
        ("ReadMySQLTable Function", test_read_mysql_table),
        ("Database Queries", test_database_queries),
        ("Connection Pool Status", test_pool_status),
        ("Concurrent Queries", test_concurrent_queries),
    ]

    results = {}
    for test_name, test_func in tests:
        try:
            results[test_name] = test_func()
        except Exception as e:
            print_error(f"{test_name} crashed: {e}")
            results[test_name] = False

    # Summary
    print_header("TEST SUMMARY")
    passed = sum(1 for r in results.values() if r)
    total = len(results)

    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{status}: {test_name}")

    print(f"\nTotal: {passed}/{total} tests passed")

    if passed == total:
        print_success("\n🎉 ALL TESTS PASSED! AWS integration is working correctly!")
        return True
    else:
        print_error(f"\n⚠ {total - passed} test(s) failed. Please review the errors above.")
        return False


if __name__ == "__main__":
    try:
        success = run_all_tests()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\nTests interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n\nUnexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
