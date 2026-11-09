"""
REVERT: Change all lowercase sourceid back to mixed-case SourceId
The actual table schema has SourceId (mixed case), not lowercase!
"""
import re

print("="*80)
print("REVERTING: Changing sourceid back to SourceId")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count current lowercase references
count_sourceid = len(re.findall(r'sourceid', content, re.IGNORECASE))

print(f"\nCurrent state:")
print(f"  Total sourceid references (lowercase): {count_sourceid}")

content_fixed = content

# Revert 1: Change `sourceid` back to `SourceId`
content_fixed = re.sub(r'`sourceid`', '`SourceId`', content_fixed)
print("\n✓ Reverted backtick-quoted `sourceid` to `SourceId`")

# Revert 2: Change alias.sourceid back to alias.SourceId (e.g., j.sourceid → j.SourceId)
content_fixed = re.sub(r'([a-z]+)\.sourceid', r'\1.SourceId', content_fixed)
print("✓ Reverted alias.sourceid to alias.SourceId")

# Revert 3: Change PARTITION BY sourceid back to PARTITION BY SourceId
content_fixed = re.sub(r'PARTITION BY sourceid', 'PARTITION BY SourceId', content_fixed)
print("✓ Reverted PARTITION BY sourceid to SourceId")

# Revert 4: Change ORDER BY sourceid back to ORDER BY SourceId
content_fixed = re.sub(r'ORDER BY sourceid', 'ORDER BY SourceId', content_fixed)
print("✓ Reverted ORDER BY sourceid to SourceId")

# Count after revert
count_sourceid_after = len(re.findall(r'SourceId', content_fixed))

print(f"\nAfter revert:")
print(f"  Total SourceId references (mixed case): {count_sourceid_after}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("✅ REVERTED: All references back to mixed-case SourceId!")
print("\nThis matches the actual table schema:")
print("  SourceId varchar(255) DEFAULT NULL")
print("="*80)
