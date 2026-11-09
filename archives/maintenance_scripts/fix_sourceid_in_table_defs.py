"""
Fix SourceId column definitions in table CREATE statements to be lowercase
"""
import re

print("="*80)
print("Fixing SourceId Column Definitions in Table CREATE Statements")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find table definitions (before prereq_stored_procs)
prereq_start = content.find('prereq_drop_procedures ="""')
if prereq_start == -1:
    print("❌ Could not find prereq_drop_procedures!")
    exit(1)

table_defs_section = content[:prereq_start]
rest_of_file = content[prereq_start:]

# Count SourceId in column definitions (looking for patterns like `SourceId` VARCHAR...)
sourceid_col_pattern = r'`SourceId`\s+(VARCHAR|TEXT|INT)'
sourceid_index_pattern = r'(INDEX\s+\w+\s*\([^)]*?)SourceId([^)]*\))'

count_col_defs = len(re.findall(sourceid_col_pattern, table_defs_section))
count_index_defs = len(re.findall(sourceid_index_pattern, table_defs_section))

print(f"\nCurrent state in table definitions:")
print(f"  Column definitions with `SourceId`: {count_col_defs}")
print(f"  Index definitions with SourceId: {count_index_defs}")

# Fix column definitions
table_defs_fixed = re.sub(r'`SourceId`(\s+)', r'`sourceid`\1', table_defs_section)

# Fix index definitions
table_defs_fixed = re.sub(
    r'(INDEX\s+\w+[^\(]*\([^)]*?)SourceId([^)]*\))',
    r'\1sourceid\2',
    table_defs_fixed
)

# Count after fixes
count_col_after = len(re.findall(sourceid_col_pattern, table_defs_fixed))
count_index_after = len(re.findall(sourceid_index_pattern, table_defs_fixed))

print(f"\nAfter fixes:")
print(f"  Column definitions with `SourceId`: {count_col_after}")
print(f"  Index definitions with SourceId: {count_index_after}")

# Reconstruct file
content_fixed = table_defs_fixed + rest_of_file

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
if count_col_after == 0 and count_index_after == 0:
    print("✅ SUCCESS: All SourceId column and index definitions changed to lowercase!")
    print("\nFixed patterns:")
    print("  - `SourceId` VARCHAR(255) → `sourceid` VARCHAR(255)")
    print("  - INDEX ...SourceId... → INDEX ...sourceid...")
else:
    print(f"⚠ WARNING: Some mixed-case SourceId references remain")
    print(f"  Column defs: {count_col_after}, Index defs: {count_index_after}")

print(f"\n✓ File updated successfully!")
print("="*80)
