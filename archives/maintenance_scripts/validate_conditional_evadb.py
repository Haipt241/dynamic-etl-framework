"""
Validate conditional evadb_stage prefix handling for Azure and AWS
"""
import re

print("="*80)
print("Validating Conditional evadb_stage Handling")
print("="*80)

# Read sql_object_scripts.py
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    sql_scripts = f.read()

# Read XEROBLUE - INSERT.py
with open('XEROBLUE - INSERT.py', 'r', encoding='utf-8') as f:
    insert_script = f.read()

print("\n1. Checking sql_object_scripts.py for evadb_stage prefixes...")
print("   (These should exist for Azure compatibility)")

# Count evadb_stage references in sql_object_scripts.py
evadb_stage_backtick = len(re.findall(r'`evadb_stage`\.', sql_scripts))
evadb_stage_normal = len(re.findall(r'\bevadb_stage\.', sql_scripts))

print(f"   `evadb_stage`. (backtick-quoted): {evadb_stage_backtick}")
print(f"   evadb_stage. (normal): {evadb_stage_normal}")

if evadb_stage_backtick > 0 or evadb_stage_normal > 0:
    print("   ✓ evadb_stage prefixes present (Azure compatibility preserved)")
else:
    print("   ✗ No evadb_stage prefixes found (Azure would break!)")

print("\n2. Checking XEROBLUE - INSERT.py for conditional removal logic...")

# Check prod_views conditional removal
prod_views_pattern = r"prod_views\s*=.*?\.replace\([^)]+\)\s*\n\s*if\s+USE_AWS_DB:\s*\n\s*prod_views\s*=\s*prod_views\.replace\(['\"]`evadb_stage`\.['\"],\s*['\"]['\"]"
prod_views_has_conditional = bool(re.search(prod_views_pattern, insert_script, re.MULTILINE))

print(f"   prod_views conditional removal: {'✓ Found' if prod_views_has_conditional else '✗ Missing'}")

# Check prod_fxviews conditional removal
prod_fxviews_pattern = r"prod_fxviews\s*=.*?\.replace\([^)]+\)\s*\n\s*.*?if\s+USE_AWS_DB:\s*\n\s*prod_fxviews\s*=\s*prod_fxviews\.replace\(['\"]`evadb_stage`\.['\"],\s*['\"]['\"]"
prod_fxviews_has_conditional = bool(re.search(prod_fxviews_pattern, insert_script, re.MULTILINE))

print(f"   prod_fxviews conditional removal: {'✓ Found' if prod_fxviews_has_conditional else '✗ Missing'}")

print("\n3. Validating logic flow...")

# Find the conditional removal blocks
if_blocks = re.findall(
    r'if\s+USE_AWS_DB:\s*\n\s*prod_(?:fx)?views\s*=\s*prod_(?:fx)?views\.replace\([^\)]+\)',
    insert_script
)

print(f"   Found {len(if_blocks)} conditional removal block(s)")

if len(if_blocks) == 2:
    print("   ✓ Both prod_views and prod_fxviews have conditional removal")
elif len(if_blocks) == 1:
    print("   ⚠ Only one conditional removal found (should be 2)")
else:
    print("   ✗ Conditional removal missing or incorrect")

print("\n" + "="*80)
print("Expected Behavior:")
print("="*80)
print("\n📁 Azure (USE_AWS_DB=False):")
print("   - sql_object_scripts.py contains: FROM `evadb_stage`.`c0000_xeroblue_journals`")
print("   - Runtime keeps: FROM `evadb_stage`.`c0000_xeroblue_journals`")
print("   - Views use separate evadb_stage database")

print("\n☁️  AWS (USE_AWS_DB=True):")
print("   - sql_object_scripts.py contains: FROM `evadb_stage`.`c0000_xeroblue_journals`")
print("   - Runtime removes prefix: FROM `c0000_xeroblue_journals`")
print("   - Views use tables in current vibedb_{FIRMCODE} database")

print("\n" + "="*80)

# Overall validation
all_checks_pass = (
    (evadb_stage_backtick > 0 or evadb_stage_normal > 0) and
    prod_views_has_conditional and
    prod_fxviews_has_conditional and
    len(if_blocks) == 2
)

if all_checks_pass:
    print("✅ SUCCESS: Conditional evadb_stage handling is correctly implemented!")
    print("\n✓ sql_object_scripts.py has evadb_stage prefixes")
    print("✓ XEROBLUE - INSERT.py conditionally removes them for AWS")
    print("✓ Both prod_views and prod_fxviews are handled")
    print("\n🎯 Both Azure and AWS compatibility achieved!")
else:
    print("⚠ WARNING: Some checks did not pass")
    print("\nPlease review the output above to identify issues.")

print("="*80)
