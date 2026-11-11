#!/usr/bin/env python3
"""
Execute CloseOut Stored Procedures in vibedb_cms Database

This script executes all generated CloseOut stored procedures in the vibedb_cms database.
"""

# Support direct operational CLI execution.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import os
import glob
from pathlib import Path
from sqlalchemy import text

# Import CMS database connection
from dynamic_integrations.database.sql_helper import cms_engine

def execute_closeout_procedure(sql_file_path):
    """
    Execute a single CloseOut procedure SQL file in vibedb_cms.

    Args:
        sql_file_path: Path to the SQL file

    Returns:
        tuple: (success: bool, error_message: str or None)
    """
    integration_name = Path(sql_file_path).parent.parent.name.upper()

    try:
        # Read SQL file
        with open(sql_file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        # Execute SQL in vibedb_cms
        with cms_engine.connect() as conn:
            # Split by DELIMITER to handle stored procedure syntax
            # MySQL stored procedures need special handling
            statements = []
            current_statement = []
            delimiter = ';'

            for line in sql_content.split('\n'):
                line_stripped = line.strip()

                # Handle DELIMITER changes
                if line_stripped.startswith('DELIMITER'):
                    if current_statement:
                        statements.append('\n'.join(current_statement))
                        current_statement = []
                    # Extract new delimiter
                    delimiter = line_stripped.split()[1] if len(line_stripped.split()) > 1 else ';'
                    continue

                current_statement.append(line)

                # Check if statement is complete
                if line_stripped.endswith(delimiter):
                    stmt = '\n'.join(current_statement)
                    # Remove the delimiter from the end
                    if delimiter != ';':
                        stmt = stmt.rstrip(delimiter)
                    statements.append(stmt)
                    current_statement = []

            # Add any remaining statement
            if current_statement:
                statements.append('\n'.join(current_statement))

            # Execute each statement
            for stmt in statements:
                stmt = stmt.strip()
                if stmt and not stmt.startswith('--') and stmt != 'DELIMITER ;':
                    try:
                        conn.execute(text(stmt))
                        conn.commit()
                    except Exception as e:
                        # Skip harmless errors like "procedure doesn't exist" on DROP
                        if 'does not exist' not in str(e).lower():
                            raise

        return True, None

    except Exception as e:
        error_msg = str(e)
        return False, error_msg


def main():
    """Execute all CloseOut procedures in vibedb_cms."""
    print("=" * 80)
    print("EXECUTING CLOSEOUT STORED PROCEDURES IN vibedb_cms")
    print("=" * 80)
    print()

    # Find all closeout procedure SQL files
    sql_files = glob.glob(
        'dynamic_integrations/generated_integrations/*/sql/closeout_procedure.sql'
    )

    if not sql_files:
        print("[ERROR] No CloseOut procedure SQL files found!")
        return

    print(f"[INFO] Found {len(sql_files)} CloseOut procedure(s) to execute")
    print()

    # Execute each procedure
    success_count = 0
    failure_count = 0

    for sql_file in sorted(sql_files):
        integration_name = Path(sql_file).parent.parent.name.upper()
        proc_name = f"Dynamic-ETL-{integration_name}-Integration-CloseOut"

        print(f"[EXEC] {proc_name}...", end=' ')

        success, error = execute_closeout_procedure(sql_file)

        if success:
            print("[OK]")
            success_count += 1
        else:
            print(f"[ERROR]")
            print(f"       Error: {error}")
            failure_count += 1

    print()
    print("=" * 80)
    print("EXECUTION SUMMARY")
    print("=" * 80)
    print(f"Total procedures: {len(sql_files)}")
    print(f"Successful: {success_count}")
    print(f"Failed: {failure_count}")
    print()

    if failure_count == 0:
        print("[OK] All CloseOut procedures executed successfully in vibedb_cms!")
    else:
        print(f"[WARNING] {failure_count} procedure(s) failed to execute")


if __name__ == '__main__':
    main()
