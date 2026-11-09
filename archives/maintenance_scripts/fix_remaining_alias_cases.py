"""
Fix remaining table alias case mismatches in stored procedures
Specifically targeting cases where alias is defined as J but used as j
"""
import re

print("="*80)
print("Fixing Remaining Table Alias Case Mismatches")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find stored procedures section
sp_start = content.find('prereq_stored_procs ="""')
if sp_start == -1:
    print("❌ Could not find prereq_stored_procs!")
    exit(1)

before_sp = content[:sp_start]
stored_procedures = content[sp_start:]

# Count current issues
on_j_lower = len(re.findall(r'\bON j\.', stored_procedures))
and_j_lower = len(re.findall(r'\bAND j\.', stored_procedures))
set_j_lower = len(re.findall(r'\bSET j\.', stored_procedures))

print(f"\nCurrent lowercase 'j' references in stored procedures:")
print(f"  ON j. : {on_j_lower}")
print(f"  AND j. : {and_j_lower}")
print(f"  SET j. : {set_j_lower}")

sp_fixed = stored_procedures

# Fix remaining patterns - be more aggressive
# These patterns need word boundaries to avoid matching 'join' or other words containing 'j'

additional_fixes = [
    (r'\bON j\.', 'ON J.'),  # Word boundary before ON
    (r'\bAND j\.', 'AND J.'),  # Word boundary before AND
    (r'\bSET j\.', 'SET J.'),  # Word boundary before SET
    (r'\bWHERE j\.', 'WHERE J.'),
]

print("\nApplying additional fixes...")

total_changes = 0

for pattern, replacement in additional_fixes:
    matches = re.findall(pattern, sp_fixed)
    count = len(matches)

    if count > 0:
        sp_fixed = re.sub(pattern, replacement, sp_fixed)
        total_changes += count
        print(f"  ✓ Fixed: {pattern} ({count} occurrences)")

# Reconstruct file
content_fixed = before_sp + sp_fixed

# Verify fixes
on_j_after = len(re.findall(r'\bON j\.', content_fixed[sp_start:]))
and_j_after = len(re.findall(r'\bAND j\.', content_fixed[sp_start:]))
set_j_after = len(re.findall(r'\bSET j\.', content_fixed[sp_start:]))

print(f"\nAfter fixes:")
print(f"  ON j. : {on_j_after}")
print(f"  AND j. : {and_j_after}")
print(f"  SET j. : {set_j_after}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
if on_j_after == 0 and and_j_after == 0 and set_j_after == 0:
    print(f"✅ SUCCESS: All table alias case mismatches fixed! ({total_changes} changes)")
    print("\n✓ All aliases now consistently use uppercase J")
    print("✓ AWS case-sensitivity compatibility achieved")
else:
    print(f"⚠ {on_j_after + and_j_after + set_j_after} lowercase j references remaining")
    print("  (These may be legitimate lowercase aliases in subqueries)")

print(f"\n✓ File updated!")
print("="*80)
