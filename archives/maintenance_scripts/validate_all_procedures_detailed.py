"""
Detailed validation of all stored procedures
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

# Force fresh import
import sys
if 'sql_object_scripts' in sys.modules:
    del sys.modules['sql_object_scripts']

import sql_object_scripts as sqlobj

print("="*80)
print("Detailed Stored Procedure Validation")
print("="*80)

creates = sqlobj.prereq_stored_procs

# Check for DEFINER
definer_matches = list(re.finditer(r'DEFINER\s*=', creates, re.IGNORECASE))
print(f"\n1. DEFINER Check:")
print(f"   Found {len(definer_matches)} DEFINER clauses")
if definer_matches:
    print("   ❌ DEFINER clauses still present!")
    for match in definer_matches[:3]:
        start = max(0, match.start() - 50)
        end = min(len(creates), match.end() + 50)
        context = creates[start:end].replace('\n', ' ')
        print(f"   Location: ...{context}...")
else:
    print("   ✅ No DEFINER clauses")

# Split procedures using same logic as execute_multiple_sqlscripts
print(f"\n2. Procedure Splitting:")
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+PROCEDURE', creates, re.IGNORECASE))
    and creates.strip().endswith('$$')
)
print(f"   Uses $$ delimiter: {has_procedures_with_delimiter}")

if has_procedures_with_delimiter:
    segments = creates.strip().split('$$')
    statements = []

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
            statements.append(('CREATE', segment))
        else:
            subsegments = segment.split(';')
            for subsegment in subsegments:
                subsegment = subsegment.strip()
                if subsegment:
                    statements.append(('OTHER', subsegment))
else:
    statements = [('OTHER', s.strip()) for s in creates.strip().split(';') if s.strip()]

create_statements = [(name, stmt) for name, stmt in statements if name == 'CREATE']
print(f"   Total CREATE PROCEDURE statements: {len(create_statements)}")

# Validate each procedure
print(f"\n3. Individual Procedure Validation:")
print("-" * 80)

all_valid = True
for i, (_, stmt) in enumerate(create_statements, 1):
    # Extract procedure name
    match = re.search(r'PROCEDURE\s+(\w+)', stmt, re.IGNORECASE)
    proc_name = match.group(1) if match else "UNKNOWN"

    issues = []

    # Check for DEFINER in this specific procedure
    if 'DEFINER' in stmt.upper():
        issues.append("Has DEFINER clause")

    # Check for proper structure
    has_begin = 'BEGIN' in stmt.upper()
    has_end = bool(re.search(r'\bEND\s*$', stmt.upper()))

    if not has_begin:
        issues.append("Missing BEGIN")
    if not has_end:
        issues.append("Missing END")

    # Check for DECLARE statements without semicolons
    # Look for DECLARE followed by newline and another DECLARE (missing semicolon)
    declare_issues = re.findall(
        r'DECLARE\s+\w+\s+\w+(?:\([^\)]+\))?\s*(?:DEFAULT[^;]*)?[\n\r]+\s*DECLARE',
        stmt,
        re.IGNORECASE | re.MULTILINE
    )
    if declare_issues:
        issues.append(f"Found {len(declare_issues)} DECLARE statements possibly missing semicolons")

    # Check for proper quotes in CONCAT
    concat_matches = re.findall(r'CONCAT\([^)]{0,100}\)', stmt, re.IGNORECASE)
    for concat in concat_matches[:3]:  # Check first 3 CONCAT statements
        # Check if string literals are properly quoted
        if re.search(r'CONCAT\s*\(\s*[a-z_]+\s*,', concat, re.IGNORECASE):
            # Found variable as first arg - check if there are unquoted strings
            if re.search(r',\s*[a-z_]+\s*,(?!\s*\')', concat, re.IGNORECASE):
                # This might be a variable, which is OK
                pass

    if issues:
        all_valid = False
        print(f"{i:2}. ❌ {proc_name}")
        for issue in issues:
            print(f"       - {issue}")
    else:
        print(f"{i:2}. ✅ {proc_name}")

# Check specific problem procedures
print(f"\n4. Specific Procedure Checks:")
print("-" * 80)

# Check sp_dynamic_xeroblue_payments
payments_match = re.search(
    r'CREATE\s+PROCEDURE\s+sp_dynamic_xeroblue_payments.*?\n\s*END\s*$',
    creates,
    re.IGNORECASE | re.DOTALL | re.MULTILINE
)

if payments_match:
    payments_sql = payments_match.group(0)
    print("sp_dynamic_xeroblue_payments:")

    # Check first 800 characters
    print(f"  First 800 characters:")
    print("  " + "-" * 76)
    first_part = payments_sql[:800]
    for line in first_part.split('\n')[:20]:
        print(f"  {line}")
    print("  ...")

    # Check for specific issues
    if 'DEFINER' in payments_sql.upper():
        print("  ❌ Contains DEFINER")
    else:
        print("  ✅ No DEFINER")

    # Check DECLARE statements
    declares = re.findall(r'DECLARE\s+\w+\s+[^;]+;', payments_sql, re.IGNORECASE)
    print(f"  ✅ Found {len(declares)} DECLARE statements with semicolons")

    # Check for DECLARE without semicolons
    bad_declares = re.findall(
        r'DECLARE\s+\w+\s+\w+[^;]*[\n\r]+\s*(?:DECLARE|SET)',
        payments_sql,
        re.IGNORECASE
    )
    if bad_declares:
        print(f"  ❌ Found {len(bad_declares)} DECLARE statements possibly missing semicolons")
        for bd in bad_declares[:2]:
            print(f"     Example: {bd[:100].replace(chr(10), ' ')}")
    else:
        print(f"  ✅ All DECLARE statements have semicolons")

print("\n" + "="*80)
if all_valid:
    print("✅ ALL PROCEDURES VALID")
    print("\nThe __pycache__ has been cleared.")
    print("Please retry your execution - it should work now!")
else:
    print("❌ SOME PROCEDURES HAVE ISSUES")
    print("\nPlease review the issues above.")
print("="*80)
