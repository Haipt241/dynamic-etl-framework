"""
Comprehensive validation of ALL case sensitivity issues
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
print("COMPREHENSIVE CASE SENSITIVITY VALIDATION")
print("="*80)

all_passed = True
issues = []

# Check all SQL content sections
sections_to_check = [
    ('create_prod_views', sqlobj.create_prod_views),
    ('create_prod_fxviews', sqlobj.create_prod_fxviews),
    ('prereq_stored_procs', sqlobj.prereq_stored_procs),
]

print("\n1. Checking for Mixed-Case Table References:")
print("-" * 80)

for section_name, content in sections_to_check:
    # Find any c0000_xeroblue_XXX or c####_xeroblue_XXX with capital letters
    mixed_case = re.findall(
        r'c\d+_xeroblue_[a-z]*[A-Z][a-z]*',
        content
    )

    if mixed_case:
        unique = set(mixed_case)
        print(f"\n   ❌ {section_name}: Found {len(unique)} mixed-case patterns")
        for pattern in sorted(unique)[:5]:  # Show first 5
            print(f"      - {pattern}")
        all_passed = False
        issues.append(f"{section_name}: {len(unique)} mixed-case table references")
    else:
        print(f"   ✅ {section_name}: No mixed-case table references")

# Check view names
print("\n2. Checking View Names:")
print("-" * 80)

uppercase_views = sqlobj.create_prod_views.count('BIGOLESHOECOMPANY_CLIENT')
if uppercase_views > 0:
    print(f"   ❌ Found {uppercase_views} uppercase view name templates")
    all_passed = False
    issues.append(f"Uppercase view names: {uppercase_views}")
else:
    print(f"   ✅ All view names are lowercase")

# Check table aliases
print("\n3. Checking Table Aliases:")
print("-" * 80)

# Check for uppercase aliases like Tb, Acc, etc. (but allow all-caps like SQL keywords)
uppercase_aliases = re.findall(
    r'FROM\s+[a-z_0-9.]+\s+([A-Z][a-z]+)\b',
    sqlobj.create_prod_views
)

if uppercase_aliases:
    unique = set(uppercase_aliases)
    print(f"   ❌ Found {len(unique)} unique uppercase aliases:")
    for alias in sorted(unique):
        print(f"      - {alias}")
    all_passed = False
    issues.append(f"Uppercase aliases: {len(unique)}")
else:
    print(f"   ✅ All table aliases are lowercase or uppercase (SQL keywords)")

# Check CREATE TABLE statements
print("\n4. Checking CREATE TABLE Statements:")
print("-" * 80)

create_tables = re.findall(
    r'CREATE\s+TABLE[^(]*\s+(c\d+_xeroblue_[a-zA-Z_]+)',
    sqlobj.create_prod_views + str(sqlobj.__dict__.get('create_tables', ''))
)

mixed_create = [t for t in create_tables if re.search(r'[A-Z]', t.split('_', 2)[2])]

if mixed_create:
    print(f"   ❌ Found {len(mixed_create)} CREATE TABLE with mixed case:")
    for table in set(mixed_create)[:5]:
        print(f"      - {table}")
    all_passed = False
    issues.append(f"Mixed-case CREATE TABLE: {len(mixed_create)}")
else:
    print(f"   ✅ All CREATE TABLE statements use lowercase")

# Check XEROBLUE - INSERT.py
print("\n5. Checking XEROBLUE - INSERT.py:")
print("-" * 80)

with open('XEROBLUE - INSERT.py', 'r', encoding='utf-8') as f:
    xeroblue_content = f.read()

# Check for uppercase templates
uppercase_templates = xeroblue_content.count('BIGOLESHOECOMPANY_CLIENT0000')

# Check for uppercase currency codes
uppercase_currencies = bool(re.search(r"fxcurrencies\s*=\s*\{[^}]*[A-Z]{3}", xeroblue_content))

# Check for .lower() usage
has_lower = 'legacy_clientid.lower()' in xeroblue_content

print(f"   Uppercase templates: {uppercase_templates}")
print(f"   Uppercase currencies: {uppercase_currencies}")
print(f"   Uses .lower(): {has_lower}")

if uppercase_templates > 0 or uppercase_currencies or not has_lower:
    print(f"   ❌ XEROBLUE - INSERT.py has case issues")
    all_passed = False
    issues.append("XEROBLUE - INSERT.py case issues")
else:
    print(f"   ✅ XEROBLUE - INSERT.py uses all lowercase")

# Final summary
print("\n" + "="*80)
if all_passed:
    print("✅ ALL VALIDATIONS PASSED!")
    print("\n✓ No mixed-case table references")
    print("✓ All view names are lowercase")
    print("✓ All table aliases are consistent")
    print("✓ All CREATE TABLE statements are lowercase")
    print("✓ XEROBLUE - INSERT.py is correct")
    print("\n🎉 Ready for AWS deployment!")
else:
    print("❌ VALIDATION FAILED")
    print(f"\nIssues found ({len(issues)}):")
    for issue in issues:
        print(f"  - {issue}")
    print("\n⚠️  Please run fix_all_remaining_case_issues.py again")

print("="*80)
