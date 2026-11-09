"""
Remove evadb_stage and evadb database prefixes for AWS compatibility
In AWS, tables are in the current database (vibedb_FIRMCODE), not in separate evadb databases
"""
import re

print("="*80)
print("Removing evadb_stage and evadb Database Prefixes")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count original references
evadb_stage_count = len(re.findall(r'evadb_stage\.', content))
evadb_count = len(re.findall(r'\bevadb\.', content))

print(f"\nOriginal counts:")
print(f"  evadb_stage. references: {evadb_stage_count}")
print(f"  evadb. references: {evadb_count}")
print(f"  Total: {evadb_stage_count + evadb_count}")

# Remove evadb_stage. prefix
# Pattern: evadb_stage.c0000_xeroblue_XXX -> c0000_xeroblue_XXX
content_fixed = re.sub(
    r'\bevadb_stage\.',
    '',
    content
)

# Remove evadb. prefix (but not in comments or strings where it's just explanatory)
# Pattern: evadb.c0000_xeroblue_XXX -> c0000_xeroblue_XXX
content_fixed = re.sub(
    r'\bevadb\.',
    '',
    content_fixed
)

# Count remaining references
remaining_evadb_stage = len(re.findall(r'evadb_stage\.', content_fixed))
remaining_evadb = len(re.findall(r'\bevadb\.', content_fixed))

print(f"\nAfter removal:")
print(f"  evadb_stage. references: {remaining_evadb_stage}")
print(f"  evadb. references: {remaining_evadb}")

if remaining_evadb_stage == 0 and remaining_evadb == 0:
    print(f"\n✅ All {evadb_stage_count + evadb_count} database prefixes removed!")
else:
    print(f"\n⚠ WARNING: {remaining_evadb_stage + remaining_evadb} references remain")

# Show sample of changes
print("\n" + "="*80)
print("Sample Changes:")
print("="*80)

# Find a few examples in the fixed content
samples = re.findall(
    r'FROM\s+([^\s]+)\s+',
    content_fixed
)[:10]

print("\nSample FROM clauses after fix:")
for i, sample in enumerate(samples[:5], 1):
    print(f"  {i}. FROM {sample}")

# Verify no evadb references in view definitions
view_section_match = re.search(
    r'create_prod_views\s*=\s*"""(.*?)"""',
    content_fixed,
    re.DOTALL
)

if view_section_match:
    view_content = view_section_match.group(1)
    view_evadb_count = view_content.count('evadb')

    if view_evadb_count == 0:
        print(f"\n✅ No 'evadb' references in view definitions")
    else:
        print(f"\n⚠ Found {view_evadb_count} 'evadb' references in views")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("SUMMARY")
print("="*80)
print(f"\n✅ Removed all evadb_stage. and evadb. prefixes")
print(f"✅ Tables will now reference current database")
print(f"\nBefore: FROM evadb_stage.c0000_xeroblue_journals")
print(f"After:  FROM c0000_xeroblue_journals")
print(f"\n✓ File updated successfully!")
print("="*80)
