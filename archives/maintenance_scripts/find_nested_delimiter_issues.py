"""
Find procedures with $$ delimiters in the middle (nested BEGIN/END blocks)
"""
import re
import os
import sys

# Force fresh import
if 'sql_object_scripts' in sys.modules:
    del sys.modules['sql_object_scripts']

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
print("Finding Nested Delimiter Issues")
print("="*80)

# Split by $$ to find all segments
segments = sqlobj.prereq_stored_procs.strip().split('$$')

print(f"\nTotal segments after splitting by $$: {len(segments)}")

issues_found = []

for i, segment in enumerate(segments):
    segment = segment.strip()
    if not segment:
        continue

    # Check if this is a CREATE PROCEDURE segment
    if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
        # Extract procedure name
        match = re.search(r'PROCEDURE\s+(\w+)', segment, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"

        # Check if it ends with END (complete procedure)
        ends_with_end = bool(re.search(r'\bEND\s*$', segment.upper()))

        if not ends_with_end:
            # This procedure segment doesn't end with END
            # It was likely split by a $$ in the middle
            issues_found.append({
                'segment_num': i,
                'proc_name': proc_name,
                'last_100_chars': segment[-100:].replace('\n', ' ')
            })

if issues_found:
    print(f"\n❌ FOUND {len(issues_found)} PROCEDURES WITH NESTED $$ ISSUES:")
    print("-" * 80)
    for issue in issues_found:
        print(f"\nSegment {issue['segment_num']}: {issue['proc_name']}")
        print(f"  Last 100 chars: ...{issue['last_100_chars']}")
        print(f"  ❌ This procedure was split by $$ in the middle!")
else:
    print(f"\n✅ NO NESTED DELIMITER ISSUES FOUND")
    print(f"   All procedures end with END before $$")

# Also check for procedures that span multiple segments
print(f"\n" + "="*80)
print("SEGMENT ANALYSIS:")
print("="*80)

create_count = 0
other_count = 0

for i, segment in enumerate(segments):
    segment = segment.strip()
    if not segment:
        continue

    if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
        create_count += 1
        match = re.search(r'PROCEDURE\s+(\w+)', segment, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"
        ends_with_end = bool(re.search(r'\bEND\s*$', segment.upper()))
        status = "✓" if ends_with_end else "✗"
        print(f"Segment {i:2}: {status} CREATE PROCEDURE {proc_name}")
    else:
        other_count += 1

print(f"\nSummary:")
print(f"  CREATE PROCEDURE segments: {create_count}")
print(f"  Other segments: {other_count}")
print(f"  Expected CREATE PROCEDURE count: 34")

if create_count != 34:
    print(f"\n❌ WARNING: Expected 34 procedures but found {create_count}!")
    print(f"   {34 - create_count} procedures may be split across multiple segments")
else:
    print(f"\n✅ Correct number of procedure segments!")

print("="*80)
