"""
Restore evadb_stage prefixes globally in sql_object_scripts.py for Azure compatibility
Runtime code will remove them for AWS
"""
import re

print("="*80)
print("Restoring evadb_stage Prefixes (Azure Compatibility)")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count current state
current_from = len(re.findall(r'FROM\s+`c0000_xeroblue_', content))
current_join = len(re.findall(r'JOIN\s+`c0000_xeroblue_', content))
current_evadb = len(re.findall(r'`evadb_stage`\.', content))

print(f"\nCurrent state:")
print(f"  FROM `c0000_xeroblue_: {current_from}")
print(f"  JOIN `c0000_xeroblue_: {current_join}")
print(f"  `evadb_stage`. prefixes: {current_evadb}")

content_fixed = content

# Add evadb_stage. prefix to FROM clauses
# Pattern: FROM `c0000_xeroblue_XXX` -> FROM `evadb_stage`.`c0000_xeroblue_XXX`
content_fixed = re.sub(
    r'FROM\s+`(c0000_xeroblue_\w+)`',
    r'FROM `evadb_stage`.`\1`',
    content_fixed
)

# Add for JOIN clauses
content_fixed = re.sub(
    r'(\s)JOIN\s+`(c0000_xeroblue_\w+)`',
    r'\1JOIN `evadb_stage`.`\2`',
    content_fixed
)

# Count after restoration
new_from = len(re.findall(r'FROM\s+`evadb_stage`\.`c0000_xeroblue_', content_fixed))
new_join = len(re.findall(r'JOIN\s+`evadb_stage`\.`c0000_xeroblue_', content_fixed))
new_evadb = len(re.findall(r'`evadb_stage`\.', content_fixed))

print(f"\nAfter restoration:")
print(f"  FROM `evadb_stage`.`c0000_xeroblue_: {new_from}")
print(f"  JOIN `evadb_stage`.`c0000_xeroblue_: {new_join}")
print(f"  `evadb_stage`. prefixes total: {new_evadb}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("✅ evadb_stage prefixes restored!")
print("\nBehavior:")
print("  📁 Azure: Views will use evadb_stage.c0000_xeroblue_* (as before)")
print("  ☁️  AWS: Runtime will remove evadb_stage. prefix")
print("\nNext: Update XEROBLUE - INSERT.py to handle this conditionally")
print("="*80)
