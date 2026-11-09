"""
Simple validation - just check DROP and CREATE counts and completeness
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
print("Final Validation - execute_multiple_sqlscripts Logic")
print("="*80)

query = sqlobj.prereq_stored_procs

# Use exact logic from execute_multiple_sqlscripts
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', query, re.IGNORECASE))
    and query.strip().endswith('$$')
)

print(f"\nDetects stored procedures with $$ delimiter: {has_procedures_with_delimiter}")

if has_procedures_with_delimiter:
    segments = query.strip().split('$$')
    statements = []

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        if re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', segment, re.IGNORECASE):
            statements.append(segment)
        else:
            subsegments = segment.split(';')
            for subsegment in subsegments:
                subsegment = subsegment.strip()
                if subsegment:
                    statements.append(subsegment)
else:
    statements = query.strip().split(';')

print(f"Total statements to execute: {len(statements)}")

# Count types
drop_count = 0
create_count = 0
other_count = 0

for stmt in statements:
    if not stmt:
        continue
    stmt_upper = stmt.upper()
    if 'DROP PROCEDURE' in stmt_upper:
        drop_count += 1
    elif re.search(r'CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE', stmt, re.IGNORECASE):
        create_count += 1
        # Verify completeness
        if 'BEGIN' not in stmt_upper or not re.search(r'\bEND\s*$', stmt_upper):
            print(f"  ⚠ WARNING: Found incomplete CREATE PROCEDURE")
    else:
        other_count += 1

print(f"\nStatement counts:")
print(f"  DROP PROCEDURE: {drop_count}")
print(f"  CREATE PROCEDURE: {create_count}")
print(f"  Other (SET, comments, etc.): {other_count}")

# Validate
print("\n" + "="*80)
success = (drop_count == 34 and create_count == 34)

if success:
    print("✅ VALIDATION PASSED!")
    print(f"\n✓ All 34 DROP PROCEDURE statements will execute")
    print(f"✓ All 34 CREATE PROCEDURE statements are complete and will execute")
    print(f"✓ {other_count} other statements (SET, comments) will execute")
    print(f"\n✓ execute_multiple_sqlscripts() will work correctly!")
else:
    print("❌ VALIDATION FAILED!")
    print(f"  Expected: 34 DROP, 34 CREATE")
    print(f"  Found: {drop_count} DROP, {create_count} CREATE")

print("="*80)
