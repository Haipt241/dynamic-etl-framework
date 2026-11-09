"""
Fix foreignexchange_master references to use vibedb_cms database prefix
"""
import re

print("="*80)
print("Fixing foreignexchange_master References")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count original references
original_count = content.count('foreignexchange_master')
prefixed_count = content.count('vibedb_cms.foreignexchange_master')
unprefixed_count = original_count - prefixed_count

print(f"\nOriginal state:")
print(f"  Total foreignexchange_master references: {original_count}")
print(f"  Already prefixed with vibedb_cms: {prefixed_count}")
print(f"  Need to be prefixed: {unprefixed_count}")

if unprefixed_count == 0:
    print("\n✅ All references already have the vibedb_cms prefix!")
    print("="*80)
    exit(0)

# Replace unprefixed references with prefixed ones
# Be careful to not double-prefix
# Pattern: match foreignexchange_master that is NOT preceded by vibedb_cms.
content_fixed = re.sub(
    r'(?<!vibedb_cms\.)foreignexchange_master',
    'vibedb_cms.foreignexchange_master',
    content
)

# Verify the fix
new_count = content_fixed.count('foreignexchange_master')
new_prefixed_count = content_fixed.count('vibedb_cms.foreignexchange_master')
new_unprefixed_count = new_count - new_prefixed_count

print(f"\nAfter fix:")
print(f"  Total foreignexchange_master references: {new_count}")
print(f"  Prefixed with vibedb_cms: {new_prefixed_count}")
print(f"  Still unprefixed: {new_unprefixed_count}")

if new_unprefixed_count > 0:
    print(f"\n⚠ WARNING: {new_unprefixed_count} references still unprefixed!")
else:
    print(f"\n✅ All {new_prefixed_count} references now have vibedb_cms prefix!")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✓ File updated successfully!")
print("="*80)
