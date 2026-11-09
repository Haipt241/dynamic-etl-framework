"""
Fix all mixed-case SourceId references to lowercase sourceid in stored procedures
for AWS case-sensitivity compatibility
"""
import re

print("="*80)
print("Fixing Mixed-Case SourceId References to Lowercase")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count current mixed-case references
count_alias_sourceid = len(re.findall(r'([a-z]+)\.\`?SourceId\`?', content))
count_backtick_sourceid = len(re.findall(r'`SourceId`', content))
count_partition_sourceid = len(re.findall(r'PARTITION BY SourceId', content))

print(f"\nCurrent state:")
print(f"  alias.SourceId: {count_alias_sourceid}")
print(f"  `SourceId`: {count_backtick_sourceid}")
print(f"  PARTITION BY SourceId: {count_partition_sourceid}")
print(f"  Total: {count_alias_sourceid + count_backtick_sourceid + count_partition_sourceid}")

content_fixed = content

# Fix 1: Change backtick-quoted `SourceId` to `sourceid`
content_fixed = re.sub(r'`SourceId`', '`sourceid`', content_fixed)
print("\n✓ Fixed backtick-quoted `SourceId`")

# Fix 2: Change alias.SourceId to alias.sourceid (e.g., j.SourceId → j.sourceid)
content_fixed = re.sub(r'([a-z]+)\.SourceId', r'\1.sourceid', content_fixed)
print("✓ Fixed alias.SourceId patterns")

# Fix 3: Change PARTITION BY SourceId to PARTITION BY sourceid
content_fixed = re.sub(r'PARTITION BY SourceId', 'PARTITION BY sourceid', content_fixed)
print("✓ Fixed PARTITION BY SourceId")

# Fix 4: Change ORDER BY SourceId to ORDER BY sourceid
content_fixed = re.sub(r'ORDER BY SourceId', 'ORDER BY sourceid', content_fixed)
print("✓ Fixed ORDER BY SourceId")

# Count after fixes
count_alias_after = len(re.findall(r'([a-z]+)\.\`?SourceId\`?', content_fixed))
count_backtick_after = len(re.findall(r'`SourceId`', content_fixed))
count_partition_after = len(re.findall(r'PARTITION BY SourceId', content_fixed))
count_lowercase = len(re.findall(r'sourceid', content_fixed, re.IGNORECASE))

print(f"\nAfter fixes:")
print(f"  alias.SourceId remaining: {count_alias_after}")
print(f"  `SourceId` remaining: {count_backtick_after}")
print(f"  PARTITION BY SourceId remaining: {count_partition_after}")
print(f"  Total sourceid references (lowercase): {count_lowercase}")

# Show sample changes
print("\n" + "="*80)
print("Sample Changes:")
print("="*80)

# Find a sample ON clause to show the change
before_sample = re.search(r'ON j\.`SourceId` = t\.`Id`', content)
after_sample = re.search(r'ON j\.`sourceid` = t\.`Id`', content_fixed)

if before_sample and after_sample:
    print(f"\nBefore: {before_sample.group()}")
    print(f"After:  {after_sample.group()}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
if count_alias_after == 0 and count_backtick_after == 0 and count_partition_after == 0:
    print("✅ SUCCESS: All SourceId references changed to lowercase sourceid!")
    print("\nFixed patterns:")
    print("  - j.SourceId → j.sourceid")
    print("  - jc.SourceId → jc.sourceid")
    print("  - `SourceId` → `sourceid`")
    print("  - PARTITION BY SourceId → PARTITION BY sourceid")
    print("  - ORDER BY SourceId → ORDER BY sourceid")
else:
    print(f"⚠ WARNING: {count_alias_after + count_backtick_after + count_partition_after} mixed-case references remain")

print(f"\n✓ File updated successfully!")
print("="*80)
