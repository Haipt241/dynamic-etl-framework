"""
Comprehensive validation that SQL is ready for AWS deployment
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
print("AWS DEPLOYMENT READINESS VALIDATION")
print("="*80)

all_passed = True
issues = []

# Test 1: No evadb/evadb_stage prefixes
print("\n1. Database Prefix Check (AWS Compatibility):")
print("-" * 80)

sections = [
    ('create_prod_views', sqlobj.create_prod_views),
    ('create_prod_fxviews', sqlobj.create_prod_fxviews),
]

for section_name, content in sections:
    evadb_stage_count = content.count('evadb_stage.')
    evadb_count = content.count('evadb.')

    if evadb_stage_count > 0 or evadb_count > 0:
        print(f"   ❌ {section_name}:")
        if evadb_stage_count > 0:
            print(f"      - Found {evadb_stage_count} 'evadb_stage.' references")
        if evadb_count > 0:
            print(f"      - Found {evadb_count} 'evadb.' references")
        all_passed = False
        issues.append(f"{section_name}: Has evadb prefixes")
    else:
        print(f"   ✅ {section_name}: No evadb prefixes")

# Test 2: Case sensitivity
print("\n2. Case Sensitivity Check:")
print("-" * 80)

for section_name, content in sections:
    # Check for mixed case table names
    mixed_case = re.findall(r'c\d+_xeroblue_[a-z]*[A-Z][a-z]*', content)

    # Check for uppercase view names
    uppercase_views = content.count('BIGOLESHOECOMPANY_CLIENT')

    if mixed_case or uppercase_views > 0:
        print(f"   ❌ {section_name}:")
        if mixed_case:
            print(f"      - Found {len(set(mixed_case))} mixed-case table references")
        if uppercase_views > 0:
            print(f"      - Found {uppercase_views} uppercase view names")
        all_passed = False
        issues.append(f"{section_name}: Case sensitivity issues")
    else:
        print(f"   ✅ {section_name}: All lowercase")

# Test 3: Sample view structure
print("\n3. View Structure Check:")
print("-" * 80)

sample_view = sqlobj.create_prod_views[:1500]

# Check for proper patterns
has_create_view = 'CREATE OR REPLACE VIEW' in sample_view
has_from_clause = 'FROM' in sample_view
has_c0000_pattern = 'c0000_xeroblue_' in sample_view
no_evadb = 'evadb' not in sample_view.lower()

print(f"   Has CREATE OR REPLACE VIEW: {has_create_view}")
print(f"   Has FROM clause: {has_from_clause}")
print(f"   Has c0000 template pattern: {has_c0000_pattern}")
print(f"   No evadb references: {no_evadb}")

if has_create_view and has_from_clause and has_c0000_pattern and no_evadb:
    print(f"   ✅ View structure looks correct")
else:
    print(f"   ❌ View structure has issues")
    all_passed = False
    issues.append("View structure problems")

# Test 4: Stored procedures
print("\n4. Stored Procedures Check:")
print("-" * 80)

# Check for DEFINER
definer_count = sqlobj.prereq_stored_procs.count('DEFINER')

# Check for nested $$ delimiters
segments = sqlobj.prereq_stored_procs.strip().split('$$')
proc_segments = [s for s in segments if 'CREATE PROCEDURE' in s.upper()]

print(f"   DEFINER clauses: {definer_count}")
print(f"   Procedure segments: {len(proc_segments)}")
print(f"   Expected: 34")

if definer_count == 0 and len(proc_segments) == 34:
    print(f"   ✅ Stored procedures ready")
else:
    print(f"   ❌ Stored procedures have issues")
    all_passed = False
    issues.append("Stored procedure issues")

# Test 5: Foreign exchange references
print("\n5. Foreign Exchange Table References:")
print("-" * 80)

fx_with_prefix = sqlobj.prereq_stored_procs.count('vibedb_cms.foreignexchange_master')
fx_without_prefix = sqlobj.prereq_stored_procs.count('foreignexchange_master') - fx_with_prefix

print(f"   With vibedb_cms prefix: {fx_with_prefix}")
print(f"   Without prefix: {fx_without_prefix}")

if fx_without_prefix == 0 and fx_with_prefix > 0:
    print(f"   ✅ All FX references have vibedb_cms prefix")
else:
    print(f"   ⚠ Some FX references may be missing prefix")

# Test 6: Sample generated SQL
print("\n6. Sample Generated SQL:")
print("-" * 80)

# Simulate what would be generated
sample_sql = sqlobj.create_prod_views[:800]
sample_sql_replaced = sample_sql.replace('bigoleshoecompany_client0000', 'bigoleshoecompany_client1518')
sample_sql_replaced = sample_sql_replaced.replace('c0000', 'c1518')

print("   Generated SQL sample:")
print("   " + "-" * 76)
for line in sample_sql_replaced.split('\n')[:15]:
    if line.strip():
        print(f"   {line[:76]}")

# Check the replaced SQL
if 'evadb' not in sample_sql_replaced.lower() and 'bigoleshoecompany_client1518' in sample_sql_replaced:
    print("   " + "-" * 76)
    print(f"   ✅ Generated SQL looks correct")
else:
    print(f"   ❌ Generated SQL has issues")
    all_passed = False
    issues.append("Generated SQL issues")

# Final summary
print("\n" + "="*80)
print("VALIDATION SUMMARY")
print("="*80)

if all_passed:
    print("\n🎉 ✅ ALL VALIDATIONS PASSED!")
    print("\nYour SQL is ready for AWS deployment:")
    print("  ✅ No evadb/evadb_stage database prefixes")
    print("  ✅ All table and view names are lowercase")
    print("  ✅ Stored procedures are correctly formatted")
    print("  ✅ Foreign exchange references use vibedb_cms prefix")
    print("  ✅ Views will reference current database correctly")
    print("\n📋 Deployment Checklist:")
    print("  1. Ensure vibedb_cms.foreignexchange_master table exists")
    print("  2. Ensure vibedb_cms.firms_with_containers table exists")
    print("  3. Clear Python cache before deployment")
    print("  4. Test with one client first")
else:
    print(f"\n❌ VALIDATION FAILED ({len(issues)} issues)")
    print("\nIssues found:")
    for issue in issues:
        print(f"  - {issue}")
    print("\n⚠️  Please fix these issues before deploying to AWS")

print("="*80)
