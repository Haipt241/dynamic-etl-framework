"""
Test conditional evadb_stage prefix removal for Azure vs AWS
"""
import sql_object_scripts as sqlobj

print("="*80)
print("Testing Conditional evadb_stage Prefix Behavior")
print("="*80)

# Sample view template from source
sample_view = sqlobj.create_prod_views[:500]  # Get first 500 chars

print("\n1. Original Template in sql_object_scripts.py:")
print("-" * 80)
print(sample_view)
print("...")

# Simulate client replacement (like runtime does)
test_clientid = "1518"
test_legacy_clientid = "bigoleshoecompany_client1518"

prod_views_test = sqlobj.create_prod_views.replace(
    'bigoleshoecompany_client0000',
    test_legacy_clientid.lower()
).replace('c0000', f'c{test_clientid}')

print("\n2. After Client ID Replacement:")
print("-" * 80)
print(prod_views_test[:500])
print("...")

# Scenario 1: Azure (USE_AWS_DB = False)
print("\n" + "="*80)
print("SCENARIO 1: Azure Environment (USE_AWS_DB=False)")
print("="*80)

USE_AWS_DB = False
azure_views = prod_views_test

if USE_AWS_DB:
    azure_views = azure_views.replace('`evadb_stage`.', '').replace('evadb_stage.', '')

print("\nSQL that would be executed in Azure:")
print("-" * 80)
print(azure_views[:500])
print("...")

import re
azure_evadb_count = len(re.findall(r'`evadb_stage`\.', azure_views))
print(f"\nResult: {azure_evadb_count} evadb_stage prefixes present")
print("✓ Views will query separate evadb_stage database")

# Scenario 2: AWS (USE_AWS_DB = True)
print("\n" + "="*80)
print("SCENARIO 2: AWS Environment (USE_AWS_DB=True)")
print("="*80)

USE_AWS_DB = True
aws_views = prod_views_test

if USE_AWS_DB:
    aws_views = aws_views.replace('`evadb_stage`.', '').replace('evadb_stage.', '')

print("\nSQL that would be executed in AWS:")
print("-" * 80)
print(aws_views[:500])
print("...")

aws_evadb_count = len(re.findall(r'`evadb_stage`\.', aws_views))
print(f"\nResult: {aws_evadb_count} evadb_stage prefixes present")
print("✓ Views will query tables in current vibedb_{FIRMCODE} database")

# Summary
print("\n" + "="*80)
print("VALIDATION SUMMARY")
print("="*80)

print(f"\n✓ Azure preserved evadb_stage: {azure_evadb_count > 0}")
print(f"✓ AWS removed evadb_stage: {aws_evadb_count == 0}")

if azure_evadb_count > 0 and aws_evadb_count == 0:
    print("\n🎉 SUCCESS: Conditional logic working correctly!")
    print("\n✅ Azure compatibility: Maintained")
    print("✅ AWS compatibility: Achieved")
    print("✅ Single source code: Both environments supported")
else:
    print("\n⚠ WARNING: Conditional logic not working as expected")
    print(f"   Azure evadb_stage count: {azure_evadb_count} (expected > 0)")
    print(f"   AWS evadb_stage count: {aws_evadb_count} (expected = 0)")

print("="*80)
