"""
Remove ALL evadb_stage and evadb database prefixes including backtick-quoted versions
"""
import re

print("="*80)
print("Removing ALL evadb References (Including Backtick-Quoted)")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count all variations
count_backtick_stage = len(re.findall(r'`evadb_stage`\.', content))
count_normal_stage = len(re.findall(r'\bevadb_stage\.', content))
count_backtick_evadb = len(re.findall(r'`evadb`\.', content))
count_normal_evadb = len(re.findall(r'\bevadb\.', content))

total_before = count_backtick_stage + count_normal_stage + count_backtick_evadb + count_normal_evadb

print(f"\nFound references:")
print(f"  `evadb_stage`. (backtick-quoted): {count_backtick_stage}")
print(f"  evadb_stage. (normal): {count_normal_stage}")
print(f"  `evadb`. (backtick-quoted): {count_backtick_evadb}")
print(f"  evadb. (normal): {count_normal_evadb}")
print(f"  Total: {total_before}")

content_fixed = content

# Remove backtick-quoted evadb_stage
content_fixed = re.sub(r'`evadb_stage`\.', '', content_fixed)
print(f"\n✓ Removed `evadb_stage`. references")

# Remove normal evadb_stage
content_fixed = re.sub(r'\bevadb_stage\.', '', content_fixed)
print(f"✓ Removed evadb_stage. references")

# Remove backtick-quoted evadb
content_fixed = re.sub(r'`evadb`\.', '', content_fixed)
print(f"✓ Removed `evadb`. references")

# Remove normal evadb
content_fixed = re.sub(r'\bevadb\.', '', content_fixed)
print(f"✓ Removed evadb. references")

# Count remaining
count_backtick_stage_after = len(re.findall(r'`evadb_stage`\.', content_fixed))
count_normal_stage_after = len(re.findall(r'\bevadb_stage\.', content_fixed))
count_backtick_evadb_after = len(re.findall(r'`evadb`\.', content_fixed))
count_normal_evadb_after = len(re.findall(r'\bevadb\.', content_fixed))

total_after = count_backtick_stage_after + count_normal_stage_after + count_backtick_evadb_after + count_normal_evadb_after

print(f"\nAfter removal:")
print(f"  `evadb_stage`. (backtick-quoted): {count_backtick_stage_after}")
print(f"  evadb_stage. (normal): {count_normal_stage_after}")
print(f"  `evadb`. (backtick-quoted): {count_backtick_evadb_after}")
print(f"  evadb. (normal): {count_normal_evadb_after}")
print(f"  Total: {total_after}")

# Show examples
print("\n" + "="*80)
print("Sample Changes:")
print("="*80)

# Find a few FROM clauses to show
from_clauses = re.findall(r'FROM\s+`?([^`\s]+)`?\s+', content_fixed)[:5]
print("\nSample FROM clauses after fix:")
for i, clause in enumerate(from_clauses, 1):
    print(f"  {i}. FROM {clause}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
if total_after == 0:
    print(f"✅ SUCCESS: Removed all {total_before} evadb references!")
    print(f"\nBefore: FROM `evadb_stage`.`c0000_xeroblue_journals` `tb`")
    print(f"After:  FROM `c0000_xeroblue_journals` `tb`")
else:
    print(f"⚠ WARNING: {total_after} references still remain!")

print(f"\n✓ File updated successfully!")
print("="*80)
