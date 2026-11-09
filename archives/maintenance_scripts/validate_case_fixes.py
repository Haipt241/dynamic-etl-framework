"""
Validate all case sensitivity fixes are applied correctly
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
print("VALIDATION: Case Sensitivity Fixes")
print("="*80)

all_passed = True

# Test 1: View names should be lowercase
print("\n1. View Names Case Check:")
print("-" * 40)

uppercase_views = sqlobj.create_prod_views.count('BIGOLESHOECOMPANY_CLIENT')
lowercase_views = sqlobj.create_prod_views.count('bigoleshoecompany_client')

print(f"   Uppercase view templates: {uppercase_views}")
print(f"   Lowercase view templates: {lowercase_views}")

if uppercase_views == 0 and lowercase_views > 0:
    print(f"   ✅ All view names are lowercase")
else:
    print(f"   ❌ Found {uppercase_views} uppercase view name templates")
    all_passed = False

# Test 2: Table names should be lowercase
print("\n2. Table Names Case Check:")
print("-" * 40)

# Check for common mixed-case patterns
mixed_case_patterns = [
    'c0000_xeroblue_BankTransactions',
    'c0000_xeroblue_Journals',
    'c0000_xeroblue_Invoices',
    'c0000_xeroblue_CreditNotes',
    'c0000_xeroblue_Payments',
    'c0000_xeroblue_Contacts'
]

issues_found = []
for pattern in mixed_case_patterns:
    count = sqlobj.create_prod_views.count(pattern)
    if count > 0:
        issues_found.append((pattern, count))

if not issues_found:
    print(f"   ✅ No mixed-case table names found")
else:
    print(f"   ❌ Found mixed-case table names:")
    for pattern, count in issues_found:
        print(f"      - {pattern} ({count} occurrences)")
    all_passed = False

# Test 3: Table aliases should be lowercase
print("\n3. Table Alias Case Check:")
print("-" * 40)

# Check for capital alias Tb (should be tb)
capital_tb = len(re.findall(r'FROM [a-z_0-9.]+ Tb\b', sqlobj.create_prod_views))

if capital_tb == 0:
    print(f"   ✅ No uppercase table aliases (Tb) found")
else:
    print(f"   ❌ Found {capital_tb} uppercase table aliases (Tb)")
    all_passed = False

# Test 4: Check XEROBLUE - INSERT.py
print("\n4. XEROBLUE - INSERT.py Case Check:")
print("-" * 40)

with open('XEROBLUE - INSERT.py', 'r', encoding='utf-8') as f:
    xeroblue_content = f.read()

uppercase_in_xeroblue = xeroblue_content.count('BIGOLESHOECOMPANY_CLIENT0000')
lowercase_in_xeroblue = xeroblue_content.count('bigoleshoecompany_client0000')
has_lower_call = 'legacy_clientid.lower()' in xeroblue_content

print(f"   Uppercase templates: {uppercase_in_xeroblue}")
print(f"   Lowercase templates: {lowercase_in_xeroblue}")
print(f"   Uses .lower() method: {has_lower_call}")

if uppercase_in_xeroblue == 0 and lowercase_in_xeroblue > 0 and has_lower_call:
    print(f"   ✅ XEROBLUE - INSERT.py uses lowercase view names")
else:
    print(f"   ❌ XEROBLUE - INSERT.py still has uppercase references")
    all_passed = False

# Test 5: Sample view SQL to verify correctness
print("\n5. Sample View SQL Verification:")
print("-" * 40)

# Get a sample view
sample = sqlobj.create_prod_views[:1000]
print(f"   First 1000 chars of view SQL:")
print(f"   {'...' + sample[:200]}")

# Check if it looks correct
if 'bigoleshoecompany_client0000' in sample.lower() and 'CREATE OR REPLACE VIEW' in sample:
    print(f"   ✅ View SQL structure looks correct")
else:
    print(f"   ⚠ Unable to verify view SQL structure")

# Final summary
print("\n" + "="*80)
if all_passed:
    print("✅ ALL VALIDATIONS PASSED!")
    print("\nAll case sensitivity fixes applied correctly:")
    print("  1. ✅ View names are lowercase")
    print("  2. ✅ Table names are lowercase")
    print("  3. ✅ Table aliases are lowercase")
    print("  4. ✅ XEROBLUE - INSERT.py uses lowercase templates")
    print("\nThe views will now:")
    print("  - Create with lowercase names (e.g., bigoleshoecompany_client1518_...)")
    print("  - Reference lowercase table names (e.g., c1518_xeroblue_journals)")
    print("  - Use lowercase aliases (e.g., tb, not Tb)")
else:
    print("❌ SOME VALIDATIONS FAILED")
    print("\nPlease review the issues above.")

print("="*80)
