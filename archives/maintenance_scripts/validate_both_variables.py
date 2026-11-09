"""
Validate both prereq_drop_procedures and prereq_stored_procs
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
print("Validating Both DROP and CREATE Variables")
print("="*80)

# Check DROP procedures
print("\n1. Validating prereq_drop_procedures:")
print("-" * 40)

drops = sqlobj.prereq_drop_procedures
drop_count = drops.count('DROP PROCEDURE')
print(f"   DROP PROCEDURE count: {drop_count}")
print(f"   Has DEFINER: {'Yes' if 'DEFINER' in drops else 'No'}")
print(f"   Length: {len(drops):,} characters")

# Check CREATE procedures
print("\n2. Validating prereq_stored_procs:")
print("-" * 40)

creates = sqlobj.prereq_stored_procs

# Check for DEFINER
definer_count = creates.count('DEFINER')
print(f"   Has DEFINER: {'Yes' if definer_count > 0 else 'No'}")
if definer_count > 0:
    print(f"   DEFINER count: {definer_count}")

# Simulate splitting logic
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+PROCEDURE', creates, re.IGNORECASE))
    and creates.strip().endswith('$$')
)

print(f"   Ends with $$: {creates.strip().endswith('$$')}")
print(f"   Will use $$ delimiter: {has_procedures_with_delimiter}")

if has_procedures_with_delimiter:
    segments = creates.strip().split('$$')
    statements = []

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
            statements.append(segment)
        else:
            subsegments = segment.split(';')
            for subsegment in subsegments:
                subsegment = subsegment.strip()
                if subsegment:
                    statements.append(subsegment)
else:
    statements = creates.strip().split(';')

create_count = 0
incomplete = []

for i, stmt in enumerate(statements):
    if not stmt:
        continue
    if re.search(r'CREATE\s+PROCEDURE', stmt, re.IGNORECASE):
        create_count += 1
        # Check completeness
        has_begin = 'BEGIN' in stmt.upper()
        has_end = bool(re.search(r'\bEND\s*$', stmt.upper()))
        if not (has_begin and has_end):
            match = re.search(r'PROCEDURE\s+(\w+)', stmt, re.IGNORECASE)
            proc_name = match.group(1) if match else "UNKNOWN"
            incomplete.append(proc_name)

print(f"   CREATE PROCEDURE count: {create_count}")
print(f"   Complete procedures: {create_count - len(incomplete)}")
print(f"   Incomplete procedures: {len(incomplete)}")
print(f"   Length: {len(creates):,} characters")

# Overall validation
print("\n" + "="*80)
print("OVERALL VALIDATION")
print("="*80)

success = True
issues = []

if drop_count != 34:
    success = False
    issues.append(f"Expected 34 DROP procedures, found {drop_count}")

if create_count != 34:
    success = False
    issues.append(f"Expected 34 CREATE procedures, found {create_count}")

if definer_count > 0:
    success = False
    issues.append(f"Found {definer_count} DEFINER clauses (should be 0)")

if len(incomplete) > 0:
    success = False
    issues.append(f"Found {len(incomplete)} incomplete procedures")

if success:
    print("\n✅ VALIDATION PASSED!")
    print(f"  - {drop_count} DROP PROCEDURE statements ready")
    print(f"  - {create_count} CREATE PROCEDURE statements complete")
    print(f"  - No DEFINER clauses")
    print(f"  - No incomplete procedures")
    print(f"\n✓ Ready to execute in AWS!")
else:
    print("\n❌ VALIDATION FAILED!")
    for issue in issues:
        print(f"  - {issue}")
    if incomplete:
        print(f"\nIncomplete procedures: {', '.join(incomplete[:5])}")

print("="*80)
