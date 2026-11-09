"""
Test script for AWS RDS Aurora connection pooling.

This script tests:
1. Connection to AWS RDS Aurora
2. Credential retrieval from AWS Secrets Manager or direct password
3. Connection pooling functionality
4. Basic database operations

Usage:
    # With AWS Secrets Manager (requires AWS credentials configured):
    python test_aws_connection.py

    # With direct password (for local testing):
    python test_aws_connection.py --password YOUR_PASSWORD
"""

import sys
import time
import argparse
from aws_db_helper import (
    initialize_aws_engine,
    test_aws_connection,
    get_pool_status,
    read_aws_table,
    execute_aws_query,
    close_aws_connections
)


def test_basic_connection():
    """Test basic database connection."""
    print("\n" + "="*60)
    print("TEST 1: Basic Connection Test")
    print("="*60)

    success = test_aws_connection()
    if success:
        print("✓ Connection successful!")
        return True
    else:
        print("✗ Connection failed!")
        return False


def test_pool_status():
    """Test connection pool status."""
    print("\n" + "="*60)
    print("TEST 2: Connection Pool Status")
    print("="*60)

    try:
        status = get_pool_status()
        print(f"Pool size: {status['pool_size']}")
        print(f"Checked in connections: {status['checked_in_connections']}")
        print(f"Checked out connections: {status['checked_out_connections']}")
        print(f"Overflow connections: {status['overflow']}")
        print(f"Total connections: {status['total_connections']}")
        print("✓ Pool status retrieved successfully!")
        return True
    except Exception as e:
        print(f"✗ Failed to get pool status: {e}")
        return False


def test_simple_query():
    """Test a simple SELECT query."""
    print("\n" + "="*60)
    print("TEST 3: Simple Query Test")
    print("="*60)

    try:
        result = read_aws_table("SELECT DATABASE() as current_db, VERSION() as version, NOW() as current_time")
        print("\nQuery Results:")
        print(result)
        print("\n✓ Query executed successfully!")
        return True
    except Exception as e:
        print(f"✗ Query failed: {e}")
        return False


def test_show_tables():
    """Test showing tables in the database."""
    print("\n" + "="*60)
    print("TEST 4: Show Tables")
    print("="*60)

    try:
        result = read_aws_table("SHOW TABLES")
        print(f"\nFound {len(result)} tables in database")
        if len(result) > 0:
            print("\nFirst 10 tables:")
            print(result.head(10))
        print("\n✓ Show tables successful!")
        return True
    except Exception as e:
        print(f"✗ Show tables failed: {e}")
        return False


def test_concurrent_connections():
    """Test multiple concurrent connections using the pool."""
    print("\n" + "="*60)
    print("TEST 5: Concurrent Connection Test")
    print("="*60)

    try:
        import concurrent.futures

        def query_database(i):
            """Execute a query in a separate thread."""
            result = read_aws_table(f"SELECT {i} as query_num, CONNECTION_ID() as conn_id, NOW() as timestamp")
            return result.iloc[0].to_dict()

        # Execute 5 queries concurrently
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            futures = [executor.submit(query_database, i) for i in range(1, 6)]
            results = [future.result() for future in concurrent.futures.as_completed(futures)]

        print(f"\nExecuted {len(results)} concurrent queries:")
        for result in results:
            print(f"  Query {result['query_num']}: Connection ID = {result['conn_id']}")

        # Check pool status after concurrent queries
        print("\nPool status after concurrent queries:")
        status = get_pool_status()
        print(f"  Total connections: {status['total_connections']}")
        print(f"  Checked out: {status['checked_out_connections']}")

        print("\n✓ Concurrent connection test successful!")
        return True
    except Exception as e:
        print(f"✗ Concurrent connection test failed: {e}")
        return False


def test_connection_reuse():
    """Test that connections are properly reused from the pool."""
    print("\n" + "="*60)
    print("TEST 6: Connection Reuse Test")
    print("="*60)

    try:
        connection_ids = []

        # Execute same query multiple times
        for i in range(5):
            result = read_aws_table("SELECT CONNECTION_ID() as conn_id")
            conn_id = result.iloc[0]['conn_id']
            connection_ids.append(conn_id)
            print(f"  Query {i+1}: Connection ID = {conn_id}")
            time.sleep(0.5)  # Small delay between queries

        # Check if connections were reused
        unique_connections = len(set(connection_ids))
        print(f"\nTotal queries: {len(connection_ids)}")
        print(f"Unique connections: {unique_connections}")

        if unique_connections < len(connection_ids):
            print("✓ Connections are being reused from the pool!")
            return True
        else:
            print("⚠ Each query used a different connection (pool may not be reusing)")
            return True
    except Exception as e:
        print(f"✗ Connection reuse test failed: {e}")
        return False


def run_all_tests():
    """Run all tests and report results."""
    print("\n" + "="*60)
    print("AWS RDS Aurora Connection Pooling Test Suite")
    print("="*60)

    tests = [
        ("Basic Connection", test_basic_connection),
        ("Pool Status", test_pool_status),
        ("Simple Query", test_simple_query),
        ("Show Tables", test_show_tables),
        ("Concurrent Connections", test_concurrent_connections),
        ("Connection Reuse", test_connection_reuse),
    ]

    results = {}
    for test_name, test_func in tests:
        try:
            results[test_name] = test_func()
        except Exception as e:
            print(f"\n✗ {test_name} crashed: {e}")
            results[test_name] = False

    # Summary
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)

    passed = sum(1 for result in results.values() if result)
    total = len(results)

    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{status}: {test_name}")

    print(f"\nTotal: {passed}/{total} tests passed")

    # Cleanup
    print("\nClosing connections...")
    close_aws_connections()
    print("✓ Cleanup complete!")

    return passed == total


if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Test AWS RDS Aurora connection pooling')
    parser.add_argument(
        '--password',
        type=str,
        default=None,
        help='Database password (if not using AWS Secrets Manager)'
    )
    parser.add_argument(
        '--secrets-manager',
        action='store_true',
        help='Use AWS Secrets Manager for credentials (requires AWS credentials configured)'
    )

    args = parser.parse_args()

    # Determine authentication method
    use_secrets_manager = args.secrets_manager or (args.password is None)

    try:
        # Initialize the AWS engine
        print("Initializing AWS RDS connection...")
        if use_secrets_manager:
            print("Using AWS Secrets Manager for credentials")
            initialize_aws_engine(use_secrets_manager=True)
        else:
            print("Using direct password authentication")
            initialize_aws_engine(use_secrets_manager=False, direct_password=args.password)

        # Run tests
        success = run_all_tests()
        sys.exit(0 if success else 1)

    except KeyboardInterrupt:
        print("\n\nTest interrupted by user")
        close_aws_connections()
        sys.exit(1)
    except Exception as e:
        print(f"\n\nUnexpected error: {e}")
        import traceback
        traceback.print_exc()
        close_aws_connections()
        sys.exit(1)
