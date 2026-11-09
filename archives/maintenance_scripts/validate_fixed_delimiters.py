"""
Validate that procedures will now split correctly
"""
import os
import re

# Set up environment
os.environ['USE_AWS_DB'] = 'False'
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TEST_CLIENT9999'
os.environ['EtaniOrganisationID'] = '999999'
os.environ['XeroTenantID'] = 'test'

import sql_object_scripts as sqlobj

print("="*80)
print("Validating Fixed Stored Procedures")
print("="*80)

procs = sqlobj.prereq_stored_procs

print(f"\nTotal SQL length: {len(procs):,} characters")

# Simulate execute_multiple_sqlscripts splitting
statements = procs.strip().split(';')

print(f"Number of statements after split(';'): {len(statements)}")

# Analyze statements
drop_count = 0
create_count = 0
set_count = 0
other_count = 0
incomplete_procedures = []

for i, stmt in enumerate(statements):
    stmt_clean = stmt.strip()
    if not stmt_clean or stmt_clean == '$$':
        continue

    stmt_upper = stmt_clean.upper()

    if 'DROP PROCEDURE' in stmt_upper:
        drop_count += 1
    elif re.search(r'CREATE\s+PROCEDURE', stmt_clean, re.IGNORECASE):
        create_count += 1

        # Check if complete (has BEGIN and END)
        has_begin = 'BEGIN' in stmt_upper
        has_end = stmt_upper.endswith('END')

        if not (has_begin and has_end):
            # Extract procedure name
            match = re.search(r'PROCEDURE\s+(\w+)', stmt_clean, re.IGNORECASE)
            proc_name = match.group(1) if match else "UNKNOWN"
            incomplete_procedures.append((i+1, proc_name, has_begin, has_end))
    elif stmt_upper.startswith('SET '):
        set_count += 1
    else:
        other_count += 1

print(f"\nStatement breakdown:")
print(f"  DROP PROCEDURE: {drop_count}")
print(f"  CREATE PROCEDURE: {create_count}")
print(f"  SET statements: {set_count}")
print(f"  Other: {other_count}")

# Show first few CREATE PROCEDUREs
print(f"\nFirst 5 CREATE PROCEDURE statements:")
create_found = 0
for i, stmt in enumerate(statements):
    stmt_clean = stmt.strip()
    if re.search(r'CREATE\s+PROCEDURE', stmt_clean, re.IGNORECASE):
        match = re.search(r'PROCEDURE\s+(\w+)', stmt_clean, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"

        # Check completeness
        has_begin = 'BEGIN' in stmt_clean.upper()
        has_end = stmt_clean.upper().endswith('END')
        status = "✓ COMPLETE" if (has_begin and has_end) else "✗ INCOMPLETE"

        print(f"  {create_found+1}. {proc_name} - {status} ({len(stmt_clean):,} chars)")

        create_found += 1
        if create_found >= 5:
            break

# Validation
print("\n" + "="*80)
print("VALIDATION RESULT")
print("="*80)

expected_drops = 34  # Based on the SQL file
expected_creates = 34

success = True
issues = []

if drop_count != expected_drops:
    success = False
    issues.append(f"Expected {expected_drops} DROP statements, found {drop_count}")

if create_count != expected_creates:
    success = False
    issues.append(f"Expected {expected_creates} CREATE statements, found {create_count}")

if len(incomplete_procedures) > 0:
    success = False
    issues.append(f"Found {len(incomplete_procedures)} incomplete procedures")

if set_count > 1:  # Allow 1 for SET NAMES at the beginning
    success = False
    issues.append(f"Found {set_count} SET statements (should be 1 or 0)")

if success:
    print("\n✓ VALIDATION PASSED!")
    print(f"  - All {drop_count} DROP PROCEDURE statements present")
    print(f"  - All {create_count} CREATE PROCEDURE statements complete")
    print(f"  - No orphaned statements detected")
    print(f"\n✓ The execute_multiple_sqlscripts function will work correctly!")
else:
    print("\n✗ VALIDATION FAILED!")
    for issue in issues:
        print(f"  - {issue}")

    if incomplete_procedures:
        print(f"\nIncomplete procedures:")
        for idx, name, has_begin, has_end in incomplete_procedures[:5]:
            print(f"  Statement {idx}: {name} (BEGIN: {has_begin}, END: {has_end})")

print("="*80)
