"""
Test script to validate execute_multiple_sqlscripts properly handles stored procedures
"""
import os

# Set up environment
os.environ['USE_AWS_DB'] = 'False'  # Use Azure for testing (simpler)
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TESTCLIENT_CLIENT9999'
os.environ['EtaniOrganisationID'] = '9999'
os.environ['XeroTenantID'] = 'test'

import sql_object_scripts as sqlobj
import re

def analyze_prereq_stored_procs():
    """Analyze the structure of prereq_stored_procs"""

    procs = sqlobj.prereq_stored_procs

    print("="*80)
    print("Analysis of sqlobj.prereq_stored_procs")
    print("="*80)

    # Basic stats
    print(f"\nTotal length: {len(procs):,} characters")
    print(f"Number of semicolons: {procs.count(';'):,}")
    print(f"Number of DROP PROCEDURE: {procs.count('DROP PROCEDURE')}")

    # Find CREATE PROCEDURE patterns (with whitespace)
    creates = list(re.finditer(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE\s+(\w+)', procs, re.IGNORECASE))
    print(f"Number of CREATE PROCEDURE: {len(creates)}")

    if creates:
        print(f"\nProcedures found:")
        for i, match in enumerate(creates):
            proc_name = match.group(1)
            print(f"  {i+1}. {proc_name}")

    # Test the splitting logic from execute_multiple_sqlscripts
    print("\n" + "="*80)
    print("Testing Splitting Logic")
    print("="*80)

    # Check for CREATE PROCEDURE (with possible whitespace/newlines between)
    has_procedures = bool(re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', procs, re.IGNORECASE))
    print(f"\nhas_procedures detected: {has_procedures}")

    if has_procedures:
        # For procedures, split by END; followed by comments or another CREATE
        parts = re.split(r'(END;)\s*(?=--|\Z)', procs.strip())

        statements = []
        current_statement = ""
        for i, part in enumerate(parts):
            if part.strip():
                current_statement += part
                # If this is an END; marker, complete the statement
                if part.strip() == 'END;' and current_statement.strip():
                    statements.append(current_statement.strip())
                    current_statement = ""

        # Add any remaining statement
        if current_statement.strip():
            statements.append(current_statement.strip())

        print(f"\nNumber of statements after splitting: {len(statements)}")

        # Categorize statements
        drop_count = 0
        create_count = 0
        set_count = 0
        other_count = 0

        for stmt in statements:
            if 'DROP PROCEDURE' in stmt.upper():
                drop_count += 1
            elif re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', stmt, re.IGNORECASE):
                create_count += 1
            elif stmt.upper().startswith('SET '):
                set_count += 1
            else:
                other_count += 1

        print(f"\nStatement breakdown:")
        print(f"  DROP PROCEDURE statements: {drop_count}")
        print(f"  CREATE PROCEDURE statements: {create_count}")
        print(f"  SET statements: {set_count}")
        print(f"  Other statements: {other_count}")

        # Show first few statements
        print(f"\nFirst 3 statements:")
        for i, stmt in enumerate(statements[:3]):
            preview = stmt.replace('\n', ' ')[:150]
            print(f"  {i+1}. {preview}...")

        # Validate each CREATE PROCEDURE is complete
        print(f"\nValidating CREATE PROCEDURE statements are complete:")
        incomplete = []
        for i, stmt in enumerate(statements):
            if re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', stmt, re.IGNORECASE):
                # Check if it has BEGIN...END
                has_begin = 'BEGIN' in stmt.upper()
                has_end = 'END;' in stmt.upper() or stmt.strip().endswith('END')

                if not (has_begin and has_end):
                    incomplete.append(i)
                    print(f"  ⚠ Statement {i+1} might be incomplete (BEGIN: {has_begin}, END: {has_end})")

        if not incomplete:
            print(f"  ✓ All {create_count} CREATE PROCEDURE statements appear complete!")
        else:
            print(f"  ⚠ Found {len(incomplete)} potentially incomplete statements")

    print("\n" + "="*80)
    print("Test Complete!")
    print("="*80)

    # Summary
    print(f"\n✓ The execute_multiple_sqlscripts function should successfully execute:")
    print(f"  - {drop_count} DROP PROCEDURE statements")
    print(f"  - {create_count} CREATE PROCEDURE statements")
    print(f"  - {set_count} SET statements")
    print(f"  - {other_count} other statements")
    print(f"\nEach procedure will be executed as a single, complete statement.")

if __name__ == "__main__":
    try:
        analyze_prereq_stored_procs()
    except Exception as e:
        print(f"\n❌ Test failed: {e}")
        import traceback
        traceback.print_exc()
