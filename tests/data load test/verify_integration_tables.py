#!/usr/bin/env python3
"""
Dynamic Integration Tables Verification Script

Verifies that all production tables for any integration have data by comparing:
1. Expected counts from c{clientID}_{integration}_lastrefreshdate table
2. Actual counts from production tables

Usage:
    # Verify specific integration
    python verify_integration_tables.py --integration dq_myobar --client-id BIGOLESHOECOMPANY_CLIENT1906 --org-id 1755241680

    # Verify QBO integration
    python verify_integration_tables.py --integration qbo --client-id BIGOLESHOECOMPANY_CLIENT2013 --org-id 7035

    # Verify FYI integration
    python verify_integration_tables.py --integration fyi --client-id SOMECOMPANY_CLIENT1234 --org-id 5678
"""

import os
import sys
import argparse
import json
import re
from datetime import datetime
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass


def parse_args():
    """Parse command-line arguments early to set environment variables"""
    parser = argparse.ArgumentParser(
        description="Verify dynamic integration production tables against expected counts"
    )
    parser.add_argument(
        '--client-id',
        required=True,
        help='Full client ID (e.g., BIGOLESHOECOMPANY_CLIENT1906)'
    )
    parser.add_argument(
        '--org-id',
        required=True,
        help='Organization ID'
    )
    parser.add_argument(
        '--integration',
        required=True,
        help='Integration name (e.g., dq_myobar, qbo, fyi, karbon_hq)'
    )
    return parser.parse_args()


# Parse args first to get client_id and org_id
args = parse_args()

# Set environment for AWS RDS (MUST be done before importing sql_helper)
os.environ['USE_AWS_DB'] = 'True'
os.environ['DB_Destination'] = 'DW'
os.environ['EtaniClientID'] = args.client_id
os.environ['EtaniOrganisationID'] = args.org_id

# Add integration and param args to sys.argv so sql_helper can detect them
# sql_helper.py looks for --integration and --param in sys.argv
if '--integration' not in sys.argv:
    sys.argv.extend(['--integration', args.integration])
if '--param' not in ' '.join(sys.argv):
    sys.argv.extend([
        '--param', f'EtaniClientID={args.client_id}',
        '--param', f'EtaniOrganisationID={args.org_id}'
    ])

# Add project root directory to path for imports
# Script is in tests/data load test/, need to go up 2 levels to project root
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(os.path.dirname(script_dir))
sys.path.insert(0, project_root)

from sqlalchemy import text
from sql_helper import eva_main_engine


@dataclass
class TableVerificationResult:
    """Result of verifying a single table"""
    endpoint: str
    table_name: str
    expected_count: Optional[int]
    actual_count: int
    status: str  # OK, MISMATCH, EMPTY, MISSING, ERROR, NOT_TRACKED
    difference: Optional[int]
    match_percentage: Optional[float]
    last_refresh: Optional[str]
    error_message: Optional[str] = None


def extract_client_number(client_id: str) -> Optional[str]:
    """
    Extract client number from EtaniClientID.

    Args:
        client_id: Full client ID (e.g., 'BIGOLESHOECOMPANY_CLIENT1906')

    Returns:
        Client number (e.g., '1906') or None if not found
    """
    match = re.search(r'CLIENT(\d+)', client_id, re.IGNORECASE)
    if match:
        return match.group(1)
    return None


def get_expected_counts(engine, client_number: str, integration: str) -> Dict[str, dict]:
    """
    Query c{client_number}_{integration}_lastrefreshdate for expected counts.

    Args:
        engine: SQLAlchemy engine
        client_number: Client number (e.g., '1906')
        integration: Integration name (e.g., 'dq_myobar', 'qbo', 'fyi')

    Returns:
        Dict mapping endpoint name to expected data:
        {'Contact': {'count': 150, 'timestamp': '2026-01-12 11:47:16', 'status': 'Success'}}
    """
    table_name = f"c{client_number}_{integration}_lastrefreshdate"

    try:
        query = text(f"""
            SELECT
                TableName,
                TotalRowCount,
                LastRefreshUTCDate,
                RefreshStatus
            FROM `{table_name}`
            WHERE TableName IS NOT NULL
            ORDER BY TableName
        """)

        with engine.connect() as conn:
            result = conn.execute(query)
            rows = result.fetchall()

            expected_counts = {}
            for row in rows:
                endpoint = row[0]
                expected_counts[endpoint] = {
                    'count': row[1] or 0,
                    'timestamp': row[2].strftime('%Y-%m-%d %H:%M:%S') if row[2] else None,
                    'status': row[3]
                }

            print(f"[OK] Found {len(expected_counts)} endpoints in {table_name}")
            return expected_counts

    except Exception as e:
        print(f"[ERROR] Error querying {table_name}: {e}")
        print("[WARNING] Proceeding without expected counts (will only check table existence)")
        return {}


def get_actual_count(engine, table_name: str, org_id: str) -> Tuple[int, Optional[str]]:
    """
    Query production table for actual row count.

    Args:
        engine: SQLAlchemy engine
        table_name: Full production table name
        org_id: Organization ID for filtering

    Returns:
        Tuple of (row_count, error_message)
    """
    try:
        # First check if table exists
        check_query = text("""
            SELECT COUNT(*)
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = :table_name
        """)

        with engine.connect() as conn:
            exists = conn.execute(check_query, {'table_name': table_name}).scalar() > 0

            if not exists:
                return -1, "Table does not exist"

            # Get row count with OrganisationID filter
            count_query = text(f"""
                SELECT COUNT(*)
                FROM `{table_name}`
                WHERE OrganisationID = :org_id
            """)

            row_count = conn.execute(count_query, {'org_id': org_id}).scalar()
            return row_count, None

    except Exception as e:
        return -1, str(e)


def verify_table(
    engine,
    client_id: str,
    org_id: str,
    integration: str,
    endpoint: str,
    expected_data: Optional[dict]
) -> TableVerificationResult:
    """
    Verify a single production table.

    Args:
        engine: SQLAlchemy engine
        client_id: Full client ID (e.g., 'BIGOLESHOECOMPANY_CLIENT1906')
        org_id: Organization ID
        integration: Integration name (e.g., 'dq_myobar', 'qbo')
        endpoint: Endpoint/TableName from lastrefreshdate (e.g., 'c1906_dq_myobar_account')
        expected_data: Expected count data from lastrefreshdate table

    Returns:
        TableVerificationResult
    """
    # Map from lastrefreshdate TableName to actual production table name
    # lastrefreshdate: c1906_dq_myobar_account
    # production table: bigoleshoecompany_client1906_dq_myobar_account

    # Extract client number from client_id
    client_number = extract_client_number(client_id)

    # Extract firmcode (everything before _CLIENT)
    firmcode = client_id.split('_CLIENT')[0].lower() if '_CLIENT' in client_id else client_id.lower()

    # Replace c{number}_ with {firmcode}_client{number}_
    if endpoint.startswith(f'c{client_number}_'):
        # Replace prefix
        table_name = endpoint.replace(f'c{client_number}_', f'{firmcode}_client{client_number}_', 1)
    else:
        # Fallback: use endpoint as-is
        table_name = endpoint

    # Get actual count
    actual_count, error = get_actual_count(engine, table_name, org_id)

    # Handle errors
    if error:
        if "does not exist" in error:
            return TableVerificationResult(
                endpoint=endpoint,
                table_name=table_name,
                expected_count=expected_data['count'] if expected_data else None,
                actual_count=0,
                status="MISSING",
                difference=None,
                match_percentage=None,
                last_refresh=expected_data['timestamp'] if expected_data else None,
                error_message=error
            )
        else:
            return TableVerificationResult(
                endpoint=endpoint,
                table_name=table_name,
                expected_count=expected_data['count'] if expected_data else None,
                actual_count=0,
                status="ERROR",
                difference=None,
                match_percentage=None,
                last_refresh=expected_data['timestamp'] if expected_data else None,
                error_message=error
            )

    # If no expected data available, just report existence
    if not expected_data:
        status = "OK" if actual_count > 0 else "EMPTY"
        return TableVerificationResult(
            endpoint=endpoint,
            table_name=table_name,
            expected_count=None,
            actual_count=actual_count,
            status=status,
            difference=None,
            match_percentage=None,
            last_refresh=None,
            error_message=None
        )

    # Compare expected vs actual
    expected_count = expected_data['count']
    difference = actual_count - expected_count

    # Calculate match percentage
    if expected_count > 0:
        match_percentage = (actual_count / expected_count) * 100
    else:
        match_percentage = 100.0 if actual_count == 0 else 0.0

    # Determine status
    if actual_count == expected_count:
        status = "OK"
    elif actual_count == 0:
        status = "EMPTY"
    else:
        status = "MISMATCH"

    return TableVerificationResult(
        endpoint=endpoint,
        table_name=table_name,
        expected_count=expected_count,
        actual_count=actual_count,
        status=status,
        difference=difference,
        match_percentage=match_percentage,
        last_refresh=expected_data['timestamp'],
        error_message=None
    )


def print_report(results: List[TableVerificationResult], client_id: str, org_id: str, integration: str, client_number: str):
    """
    Print console report with summary and details.
    """
    # Calculate summary statistics
    total = len(results)
    matching = sum(1 for r in results if r.status == "OK")
    mismatched = sum(1 for r in results if r.status == "MISMATCH")
    missing = sum(1 for r in results if r.status == "MISSING")
    empty = sum(1 for r in results if r.status == "EMPTY")
    errors = sum(1 for r in results if r.status == "ERROR")
    not_tracked = sum(1 for r in results if r.expected_count is None and r.status == "OK")

    # Print header
    print("\n" + "=" * 70)
    print(f"        {integration.upper()} Production Tables Verification")
    print("=" * 70)
    print(f"\nClient: {client_id}")
    print(f"Org ID: {org_id}")
    print(f"Integration: {integration.upper()}")
    print(f"Refresh Date Table: c{client_number}_{integration}_lastrefreshdate")

    # Print summary
    print("\n" + "-" * 70)
    print("SUMMARY:")
    print(f"  [OK] Matching Tables: {matching}/{total} ({matching/total*100:.1f}%)")
    if mismatched > 0:
        print(f"  [WARNING] Mismatched Tables: {mismatched}")
    if empty > 0:
        print(f"  [WARNING] Empty Tables: {empty}")
    if missing > 0:
        print(f"  [ERROR] Missing Tables: {missing}")
    if errors > 0:
        print(f"  [ERROR] Query Errors: {errors}")
    if not_tracked > 0:
        print(f"  [INFO] Not Tracked (no expected count): {not_tracked}")

    # Print issues
    issues = [r for r in results if r.status in ["MISMATCH", "MISSING", "EMPTY", "ERROR"]]
    if issues:
        print("\n" + "-" * 70)
        print("ISSUES DETECTED:\n")
        for result in issues:
            if result.status == "MISMATCH":
                print(f"[WARNING] {result.endpoint}")
                print(f"    Expected (API): {result.expected_count} rows")
                print(f"    Actual (DB):    {result.actual_count} rows")
                print(f"    Difference:     {result.difference:+d} rows ({abs(result.difference)/result.expected_count*100:.1f}% {'loss' if result.difference < 0 else 'gain'})")
                print(f"    Match %:        {result.match_percentage:.1f}%")
                if result.last_refresh:
                    print(f"    Last Sync:      {result.last_refresh}")
                print()
            elif result.status == "EMPTY":
                print(f"[WARNING] {result.endpoint}")
                print(f"    Status: Table exists but has 0 rows")
                if result.expected_count:
                    print(f"    Expected: {result.expected_count} rows")
                print()
            elif result.status == "MISSING":
                print(f"[ERROR] {result.endpoint}")
                print(f"    Status: Table does not exist in database")
                print(f"    Expected table: {result.table_name}")
                print()
            elif result.status == "ERROR":
                print(f"[ERROR] {result.endpoint}")
                print(f"    Error: {result.error_message}")
                print()

    # Print top successful endpoints
    successful = [r for r in results if r.status == "OK" and r.expected_count is not None]
    if successful:
        successful_sorted = sorted(successful, key=lambda x: x.actual_count, reverse=True)
        print("\n" + "-" * 70)
        print("SUCCESSFUL ENDPOINTS (Top 10 by row count):\n")
        for i, result in enumerate(successful_sorted[:10], 1):
            print(f"{i:2d}. [OK] {result.endpoint:30s}: {result.actual_count:5d} / {result.expected_count:5d} rows ({result.match_percentage:.1f}%)")

    print("\n" + "=" * 70)


def save_json_report(results: List[TableVerificationResult], client_id: str, org_id: str, integration: str) -> str:
    """
    Save verification results to JSON file.

    Returns:
        Path to saved file
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"verification_report_{integration.upper()}_{timestamp}.json"

    # Calculate summary
    total = len(results)
    matching = sum(1 for r in results if r.status == "OK")
    mismatched = sum(1 for r in results if r.status == "MISMATCH")
    missing = sum(1 for r in results if r.status == "MISSING")
    empty = sum(1 for r in results if r.status == "EMPTY")
    errors = sum(1 for r in results if r.status == "ERROR")

    report = {
        "timestamp": datetime.now().isoformat(),
        "client_id": client_id,
        "org_id": org_id,
        "integration": integration,
        "summary": {
            "total_endpoints": total,
            "matching_tables": matching,
            "mismatched_tables": mismatched,
            "missing_tables": missing,
            "empty_tables": empty,
            "error_count": errors
        },
        "details": [
            {
                "endpoint": r.endpoint,
                "table_name": r.table_name,
                "expected_count": r.expected_count,
                "actual_count": r.actual_count,
                "difference": r.difference,
                "status": r.status,
                "match_percentage": r.match_percentage,
                "last_refresh": r.last_refresh,
                "error_message": r.error_message
            }
            for r in results
        ]
    }

    with open(filename, 'w') as f:
        json.dump(report, f, indent=2)

    return filename


def main():
    """Main verification logic"""
    # Use args that were parsed at module level
    global args

    # Extract client number from client ID
    client_number = extract_client_number(args.client_id)
    if not client_number:
        print(f"[ERROR] Could not extract client number from '{args.client_id}'")
        print("   Expected format: FIRMCODE_CLIENT{number}")
        sys.exit(1)

    print(f"\n>> Starting verification...")
    print(f"   Client: {args.client_id} (#{client_number})")
    print(f"   Org ID: {args.org_id}")
    print(f"   Integration: {args.integration}")

    # Get expected counts from lastrefreshdate table
    print(f"\n>> Querying lastrefreshdate table...")
    expected_counts = get_expected_counts(eva_main_engine, client_number, args.integration)

    if not expected_counts:
        print("[WARNING] No expected counts found - will only verify table existence")

    # Verify each endpoint
    print(f"\n>> Verifying production tables...")
    results = []

    for endpoint in expected_counts.keys():
        result = verify_table(
            eva_main_engine,
            args.client_id,
            args.org_id,
            args.integration,
            endpoint,
            expected_counts.get(endpoint)
        )
        results.append(result)

        # Print progress
        status_icon = {
            "OK": "[OK]",
            "MISMATCH": "[WARN]",
            "EMPTY": "[WARN]",
            "MISSING": "[ERR]",
            "ERROR": "[ERR]"
        }.get(result.status, "[?]")

        print(f"   {status_icon} {endpoint:30s} - {result.status}")

    # Print console report
    print_report(results, args.client_id, args.org_id, args.integration, client_number)

    # Save JSON report
    json_file = save_json_report(results, args.client_id, args.org_id, args.integration)
    print(f"\n[INFO] Report saved to: {json_file}")


if __name__ == "__main__":
    main()
