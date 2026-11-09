"""
Restore evadb_stage prefixes in sql_object_scripts.py
They will be removed conditionally at runtime in XEROBLUE - INSERT.py based on USE_AWS_DB flag
"""
import re

print("="*80)
print("Restoring evadb_stage Prefixes for Azure Compatibility")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find view definitions section
view_section_start = content.find('create_prod_views ="""')
view_section_end = content.find('"""', view_section_start + 25)

if view_section_start == -1 or view_section_end == -1:
    print("❌ Could not find view section!")
    exit(1)

view_section = content[view_section_start:view_section_end]
before_view = content[:view_section_start]
after_view = content[view_section_end:]

# Count current references
current_evadb = view_section.count('evadb_stage.')

print(f"\nCurrent state:")
from_pattern_count = len(re.findall(r'FROM\s+`?c0000_xeroblue_', view_section))
print(f"  FROM c0000_xeroblue_ patterns: {from_pattern_count}")
print(f"  evadb_stage. prefixes: {current_evadb}")

# Add evadb_stage. prefix back to table references in views
# Pattern: FROM `c0000_xeroblue_XXX` -> FROM `evadb_stage`.`c0000_xeroblue_XXX`
view_section_fixed = re.sub(
    r'FROM\s+`(c0000_xeroblue_\w+)`',
    r'FROM `evadb_stage`.`\1`',
    view_section
)

# Pattern: JOIN `c0000_xeroblue_XXX` -> JOIN `evadb_stage`.`c0000_xeroblue_XXX`
view_section_fixed = re.sub(
    r'JOIN\s+`(c0000_xeroblue_\w+)`',
    r'JOIN `evadb_stage`.`\1`',
    view_section_fixed
)

# Pattern: LEFT JOIN `c0000_xeroblue_XXX` -> LEFT JOIN `evadb_stage`.`c0000_xeroblue_XXX`
view_section_fixed = re.sub(
    r'LEFT\s+JOIN\s+`(c0000_xeroblue_\w+)`',
    r'LEFT JOIN `evadb_stage`.`\1`',
    view_section_fixed
)

# Count after restoration
new_evadb = view_section_fixed.count('evadb_stage.')

print(f"\nAfter restoration:")
print(f"  evadb_stage. prefixes: {new_evadb}")
print(f"  Added: {new_evadb - current_evadb}")

# Reconstruct file
content_fixed = before_view + view_section_fixed + after_view

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("✓ evadb_stage prefixes restored for Azure compatibility")
print("\nNow the runtime code in XEROBLUE - INSERT.py will:")
print("  - Azure (USE_AWS_DB=False): Keep evadb_stage. prefixes")
print("  - AWS (USE_AWS_DB=True): Remove evadb_stage. prefixes")
print("="*80)
