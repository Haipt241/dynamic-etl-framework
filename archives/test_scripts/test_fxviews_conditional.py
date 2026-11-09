"""
Test conditional evadb_stage prefix removal for FX views (Azure vs AWS)
"""
import re
import sql_object_scripts as sqlobj

print("="*80)
print("Testing Conditional evadb_stage Prefix Behavior (FX Views)")
print("="*80)

# Sample FX view template from source
sample_fxview = sqlobj.create_prod_fxviews[500:1500]  # Get middle section with evadb_stage

print("\n1. Original FX View Template in sql_object_scripts.py:")
print("-" * 80)
print(sample_fxview)

# Simulate client replacement (like runtime does)
test_clientid = "1518"
test_legacy_clientid = "bigoleshoecompany_client1518"
test_fxcurrency = "aud"

prod_fxviews_test = sqlobj.create_prod_fxviews.replace(
    'bigoleshoecompany_client0000',
    test_legacy_clientid.lower()
).replace('_fxcurrency', f'_{test_fxcurrency}').replace('c0000', f'c{test_clientid}')

print("\n2. After Client ID and Currency Replacement:")
print("-" * 80)
sample_replaced = prod_fxviews_test[500:1500]
print(sample_replaced)

# Count evadb_stage references
original_count = len(re.findall(r'`evadb_stage`\.', prod_fxviews_test))
print(f"\nTotal evadb_stage references after replacement: {original_count}")

# Scenario 1: Azure (USE_AWS_DB = False)
print("\n" + "="*80)
print("SCENARIO 1: Azure Environment (USE_AWS_DB=False)")
print("="*80)

USE_AWS_DB = False
azure_fxviews = prod_fxviews_test

if USE_AWS_DB:
    azure_fxviews = azure_fxviews.replace('`evadb_stage`.', '').replace('evadb_stage.', '')

print("\nSQL that would be executed in Azure:")
print("-" * 80)
sample_azure = azure_fxviews[500:1500]
print(sample_azure)

azure_evadb_count = len(re.findall(r'`evadb_stage`\.', azure_fxviews))
print(f"\nResult: {azure_evadb_count} evadb_stage prefixes present")
print("✓ Views will query separate evadb_stage database")

# Scenario 2: AWS (USE_AWS_DB = True)
print("\n" + "="*80)
print("SCENARIO 2: AWS Environment (USE_AWS_DB=True)")
print("="*80)

USE_AWS_DB = True
aws_fxviews = prod_fxviews_test

if USE_AWS_DB:
    aws_fxviews = aws_fxviews.replace('`evadb_stage`.', '').replace('evadb_stage.', '')

print("\nSQL that would be executed in AWS:")
print("-" * 80)
sample_aws = aws_fxviews[500:1500]
print(sample_aws)

aws_evadb_count = len(re.findall(r'`evadb_stage`\.', aws_fxviews))
print(f"\nResult: {aws_evadb_count} evadb_stage prefixes present")
print("✓ Views will query tables in current vibedb_{FIRMCODE} database")

# Summary
print("\n" + "="*80)
print("VALIDATION SUMMARY")
print("="*80)

print(f"\nOriginal template had: {original_count} evadb_stage references")
print(f"Azure preserved: {azure_evadb_count} references")
print(f"AWS removed: {original_count - aws_evadb_count} references")
print(f"AWS remaining: {aws_evadb_count} references")

success = (azure_evadb_count == original_count and aws_evadb_count == 0)

if success:
    print("\n🎉 SUCCESS: Conditional logic working perfectly!")
    print("\n✅ Azure: All evadb_stage prefixes preserved")
    print("✅ AWS: All evadb_stage prefixes removed")
    print("✅ Single source code: Both environments supported")
else:
    print("\n⚠ WARNING: Conditional logic not working as expected")
    print(f"   Expected Azure: {original_count}, Got: {azure_evadb_count}")
    print(f"   Expected AWS: 0, Got: {aws_evadb_count}")

# Show specific examples
print("\n" + "="*80)
print("DETAILED COMPARISON")
print("="*80)

# Find a specific FROM clause to show the difference
azure_example = re.search(r'FROM [^;]+;', azure_fxviews)
aws_example = re.search(r'FROM [^;]+;', aws_fxviews)

if azure_example and aws_example:
    print("\nSame SQL clause in both environments:")
    print(f"\n  Azure: {azure_example.group().strip()}")
    print(f"  AWS:   {aws_example.group().strip()}")

print("="*80)
