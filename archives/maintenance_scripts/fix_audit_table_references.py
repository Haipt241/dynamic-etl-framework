"""
Fix audit table references to use correct database and table names
"""
import re

print("="*80)
print("Fixing Audit Table References")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find all problematic patterns
# Pattern: FROM vibedb.', v_legacyClientID, '_xeroblue_..._aud
# Or: FROM evadb.', v_legacyClientID, '_xeroblue_..._aud

# Count original occurrences
vibedb_aud_count = len(re.findall(r"FROM vibedb\.', v_legacyClientID, '_xeroblue_\w+_aud", content))
evadb_aud_count = len(re.findall(r"FROM evadb\.', v_legacyClientID, '_xeroblue_\w+_aud", content))

print(f"\nFound issues:")
print(f"  vibedb.', v_legacyClientID, '..._aud patterns: {vibedb_aud_count}")
print(f"  evadb.', v_legacyClientID, '..._aud patterns: {evadb_aud_count}")

# Fix: Replace with proper database.table reference
# The audit tables should be in the same database (DATABASE())
# and use the numeric client ID (v_clientID) not the full legacy client ID

# Pattern 1: vibedb.', v_legacyClientID, '_xeroblue_XXX_aud
# Replace with: c', v_clientID, '_xeroblue_XXX_aud (use current database context)
content_fixed = re.sub(
    r"FROM vibedb\.', v_legacyClientID, '(_xeroblue_\w+_aud)",
    r"FROM c', v_clientID, '\1",
    content
)

# Pattern 2: evadb.', v_legacyClientID, '_xeroblue_XXX_aud
# Replace with: c', v_clientID, '_xeroblue_XXX_aud (use current database context)
content_fixed = re.sub(
    r"FROM evadb\.', v_legacyClientID, '(_xeroblue_\w+_aud)",
    r"FROM c', v_clientID, '\1",
    content_fixed
)

# Verify the fix
new_vibedb_aud_count = len(re.findall(r"FROM vibedb\.', v_legacyClientID, '_xeroblue_\w+_aud", content_fixed))
new_evadb_aud_count = len(re.findall(r"FROM evadb\.', v_legacyClientID, '_xeroblue_\w+_aud", content_fixed))

print(f"\nAfter fix:")
print(f"  vibedb.', v_legacyClientID, '..._aud patterns: {new_vibedb_aud_count}")
print(f"  evadb.', v_legacyClientID, '..._aud patterns: {new_evadb_aud_count}")

if new_vibedb_aud_count == 0 and new_evadb_aud_count == 0:
    print(f"\n✅ All {vibedb_aud_count + evadb_aud_count} audit table references fixed!")
    print("\nAudit tables will now use:")
    print("  - Current database context (DATABASE())")
    print("  - Numeric client ID: c{v_clientID}_xeroblue_XXX_aud")
else:
    print(f"\n⚠ WARNING: Some references still have issues!")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✓ File updated successfully!")
print("="*80)
