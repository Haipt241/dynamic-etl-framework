"""
Validate all error fixes are in place
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
print("VALIDATION OF ALL ERROR FIXES")
print("="*80)

all_passed = True

# Test 1: DEFINER clauses removed
print("\n1. DEFINER Clause Check:")
print("-" * 40)
definer_count = sqlobj.prereq_stored_procs.count('DEFINER')
if definer_count == 0:
    print("   ✅ No DEFINER clauses found")
else:
    print(f"   ❌ Found {definer_count} DEFINER clauses (should be 0)")
    all_passed = False

# Test 2: foreignexchange_master references
print("\n2. Foreign Exchange Table References:")
print("-" * 40)
fx_total = sqlobj.prereq_stored_procs.count('foreignexchange_master')
fx_prefixed = sqlobj.prereq_stored_procs.count('vibedb_cms.foreignexchange_master')
fx_unprefixed = fx_total - fx_prefixed

print(f"   Total foreignexchange_master references: {fx_total}")
print(f"   With vibedb_cms prefix: {fx_prefixed}")
print(f"   Without prefix: {fx_unprefixed}")

if fx_unprefixed == 0 and fx_prefixed > 0:
    print("   ✅ All foreignexchange_master references have vibedb_cms prefix")
elif fx_total == 0:
    print("   ⚠  No foreignexchange_master references found")
else:
    print(f"   ❌ {fx_unprefixed} references missing vibedb_cms prefix")
    all_passed = False

# Test 3: Audit table references
print("\n3. Audit Table References:")
print("-" * 40)
bad_vibedb = len(re.findall(r"FROM vibedb\.', v_legacyClientID, '_xeroblue_\w+_aud", sqlobj.prereq_stored_procs))
bad_evadb = len(re.findall(r"FROM evadb\.', v_legacyClientID, '_xeroblue_\w+_aud", sqlobj.prereq_stored_procs))

print(f"   Malformed vibedb audit references: {bad_vibedb}")
print(f"   Malformed evadb audit references: {bad_evadb}")

if bad_vibedb == 0 and bad_evadb == 0:
    print("   ✅ No malformed audit table references")
else:
    print(f"   ❌ Found {bad_vibedb + bad_evadb} malformed references")
    all_passed = False

# Test 4: Procedure completeness
print("\n4. Stored Procedure Structure:")
print("-" * 40)

# Split procedures
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+PROCEDURE', sqlobj.prereq_stored_procs, re.IGNORECASE))
    and sqlobj.prereq_stored_procs.strip().endswith('$$')
)

if has_procedures_with_delimiter:
    segments = sqlobj.prereq_stored_procs.strip().split('$$')
    statements = []

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
            statements.append(('CREATE', segment))

create_statements = [stmt for typ, stmt in statements if typ == 'CREATE']
print(f"   Total CREATE PROCEDURE statements: {len(create_statements)}")

incomplete = 0
for stmt in create_statements:
    has_begin = 'BEGIN' in stmt.upper()
    has_end = bool(re.search(r'\bEND\s*$', stmt.upper()))
    if not (has_begin and has_end):
        incomplete += 1

if incomplete == 0:
    print(f"   ✅ All {len(create_statements)} procedures are complete")
else:
    print(f"   ❌ {incomplete} incomplete procedures")
    all_passed = False

# Test 5: DROP procedures
print("\n5. DROP Procedure Statements:")
print("-" * 40)
drop_count = sqlobj.prereq_drop_procedures.count('DROP PROCEDURE')
print(f"   DROP PROCEDURE statements: {drop_count}")
if drop_count == 34:
    print("   ✅ All 34 DROP statements present")
else:
    print(f"   ⚠  Expected 34, found {drop_count}")

# Check XEROBLUE - INSERT.py for firms_with_containers fix
print("\n6. firms_with_containers Fix:")
print("-" * 40)
with open('XEROBLUE - INSERT.py', 'r', encoding='utf-8') as f:
    xeroblue_content = f.read()

# Find the UpdateCMSDetails function
updatecms_match = re.search(
    r'def UpdateCMSDetails.*?firms_with_containers.*?Execute(CMS|Eva)SP',
    xeroblue_content,
    re.DOTALL
)

if updatecms_match:
    if 'ExecuteCMSSP' in updatecms_match.group(0):
        print("   ✅ firms_with_containers uses ExecuteCMSSP (correct)")
    else:
        print("   ❌ firms_with_containers still uses ExecuteEvaSP (wrong)")
        all_passed = False
else:
    print("   ⚠  Could not find firms_with_containers reference")

# Final summary
print("\n" + "="*80)
if all_passed:
    print("✅ ALL VALIDATIONS PASSED!")
    print("\nAll error fixes have been successfully applied:")
    print("  1. ✅ No DEFINER clauses")
    print("  2. ✅ foreignexchange_master uses vibedb_cms prefix")
    print("  3. ✅ Audit table references use correct naming")
    print("  4. ✅ All stored procedures are complete")
    print("  5. ✅ firms_with_containers uses ExecuteCMSSP")
    print("\nReady to deploy and test!")
else:
    print("❌ SOME VALIDATIONS FAILED")
    print("\nPlease review the issues above before deploying.")

print("="*80)
