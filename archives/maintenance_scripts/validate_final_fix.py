"""
Validate that procedures will execute correctly with $$ delimiter splitting
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
print("Validating Stored Procedures with $$ Delimiter")
print("="*80)

query = sqlobj.prereq_stored_procs

print(f"\nTotal SQL length: {len(query):,} characters")

# Simulate the logic from execute_multiple_sqlscripts
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', query, re.IGNORECASE))
    and query.strip().endswith('$$')
)

has_create = bool(re.search(r'CREATE\s+PROCEDURE', query, re.IGNORECASE))
ends_with_delimiter = query.strip().endswith('$$')
print(f"Has CREATE PROCEDURE: {has_create}")
print(f"Ends with $$: {ends_with_delimiter}")
print(f"Will use $$ delimiter: {has_procedures_with_delimiter}")

if has_procedures_with_delimiter:
    # Split by $$ first
    segments = query.strip().split('$$')
    statements = []
    split_by = "$$ (with ; for non-procedures)"

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        # Check if this segment contains CREATE PROCEDURE
        if re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', segment, re.IGNORECASE):
            # This is a complete procedure, keep it as one statement
            statements.append(segment)
        else:
            # This segment contains other statements (DROP, SET, etc.), split by semicolon
            subsegments = segment.split(';')
            for subsegment in subsegments:
                subsegment = subsegment.strip()
                if subsegment:
                    statements.append(subsegment)
else:
    statements = query.strip().split(';')
    split_by = ";"

print(f"\nSplitting by: {split_by}")
print(f"Number of statements after split: {len(statements)}")

# Analyze statements
drop_count = 0
create_count = 0
set_count = 0
comment_count = 0
empty_count = 0
complete_procedures = 0
incomplete_procedures = []

for i, stmt in enumerate(statements):
    stmt_clean = stmt.strip()

    if not stmt_clean:
        empty_count += 1
        continue

    stmt_upper = stmt_clean.upper()

    if 'DROP PROCEDURE' in stmt_upper:
        drop_count += 1
    elif re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', stmt_clean, re.IGNORECASE):
        create_count += 1

        # Extract procedure name
        match = re.search(r'PROCEDURE\s+(\w+)', stmt_clean, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"

        # Check if complete (has BEGIN and END)
        has_begin = 'BEGIN' in stmt_upper
        has_end = bool(re.search(r'\bEND\s*$', stmt_upper))

        if has_begin and has_end:
            complete_procedures += 1
        else:
            incomplete_procedures.append((i+1, proc_name, has_begin, has_end))
    elif stmt_upper.startswith('SET '):
        set_count += 1
    elif stmt_upper.startswith('--'):
        comment_count += 1

print(f"\nStatement breakdown:")
print(f"  DROP PROCEDURE: {drop_count}")
print(f"  CREATE PROCEDURE: {create_count}")
print(f"    - Complete: {complete_procedures}")
print(f"    - Incomplete: {len(incomplete_procedures)}")
print(f"  SET statements: {set_count}")
print(f"  Comment blocks: {comment_count}")
print(f"  Empty: {empty_count}")

# Show first few CREATE PROCEDUREs
print(f"\nFirst 5 CREATE PROCEDURE statements:")
create_found = 0
for i, stmt in enumerate(statements):
    stmt_clean = stmt.strip()
    if re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', stmt_clean, re.IGNORECASE):
        match = re.search(r'PROCEDURE\s+(\w+)', stmt_clean, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"

        # Check completeness
        has_begin = 'BEGIN' in stmt_clean.upper()
        has_end = bool(re.search(r'\bEND\s*$', stmt_clean.upper()))
        status = "✓ COMPLETE" if (has_begin and has_end) else "✗ INCOMPLETE"

        # Check for internal semicolons
        semicolon_count = stmt_clean.count(';')

        print(f"  {create_found+1}. {proc_name}")
        print(f"      Status: {status}")
        print(f"      Length: {len(stmt_clean):,} chars")
        print(f"      Internal semicolons: {semicolon_count}")

        create_found += 1
        if create_found >= 5:
            break

# Validation
print("\n" + "="*80)
print("VALIDATION RESULT")
print("="*80)

expected_drops = 34
expected_creates = 34

success = True
issues = []

if not has_procedures_with_delimiter:
    success = False
    issues.append("Did not detect stored procedures with $$ delimiter!")

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
    issues.append(f"Found {set_count} SET statements (should be 1)")

if success:
    print("\n✅ VALIDATION PASSED!")
    print(f"  - Detected stored procedures with $$ delimiter")
    print(f"  - All {drop_count} DROP PROCEDURE statements present")
    print(f"  - All {create_count} CREATE PROCEDURE statements complete")
    print(f"  - Procedures contain internal semicolons (handled correctly)")
    print(f"  - Ready to execute with execute_multiple_sqlscripts()")
else:
    print("\n❌ VALIDATION FAILED!")
    for issue in issues:
        print(f"  - {issue}")

    if incomplete_procedures:
        print(f"\nIncomplete procedures (first 5):")
        for idx, name, has_begin, has_end in incomplete_procedures[:5]:
            print(f"  Statement {idx}: {name} (BEGIN: {has_begin}, END: {has_end})")

print("="*80)
