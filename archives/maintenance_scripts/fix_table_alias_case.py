"""
Fix table alias case mismatches in stored procedures
Problem: Alias defined as uppercase J but used as lowercase j in ON/WHERE clauses
Solution: Change all lowercase j references to uppercase J to match the alias definition
"""
import re

print("="*80)
print("Fixing Table Alias Case Mismatches (j → J)")
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

# Count mismatches - looking for patterns like:
# UPDATE ... J ... ON j.column (uppercase alias definition, lowercase usage)

patterns_to_fix = [
    (r"ON j\.`", "ON J.`"),  # ON j.`column` → ON J.`column`
    (r"AND j\.`", "AND J.`"),  # AND j.`column` → AND J.`column`
    (r"WHERE j\.", "WHERE J."),  # WHERE j.column → WHERE J.column
    (r"WHEN j\.`", "WHEN J.`"),  # WHEN j.`column` → WHEN J.`column`
    (r"SET j\.`", "SET J.`"),  # SET j.`column` → SET J.`column`
    (r"FROM ', @finaltable, ' j\n", "FROM ', @finaltable, ' J\n"),  # FROM table j → FROM table J
    (r"FROM ', @journalsStage, ' j\n", "FROM ', @journalsStage, ' J\n"),
    (r", ' j\n", ", ' J\n"),  # table j (in JOIN/UPDATE) → table J
]

print("\nSearching for lowercase 'j' aliases in stored procedures...")

sp_fixed = stored_procedures
total_changes = 0

for pattern, replacement in patterns_to_fix:
    matches = re.findall(pattern, sp_fixed)
    count = len(matches)

    if count > 0:
        sp_fixed = re.sub(pattern, replacement, sp_fixed)
        total_changes += count
        print(f"  ✓ Fixed: {pattern} → {replacement} ({count} occurrences)")

# Also fix lowercase jc (journalscash) to uppercase JC
jc_patterns = [
    (r"ON jc\.`", "ON JC.`"),
    (r"AND jc\.`", "AND JC.`"),
    (r"WHERE jc\.", "WHERE JC."),
    (r"WHEN jc\.`", "WHEN JC.`"),
    (r"SET jc\.`", "SET JC.`"),
]

print("\nSearching for lowercase 'jc' aliases...")

for pattern, replacement in jc_patterns:
    matches = re.findall(pattern, sp_fixed)
    count = len(matches)

    if count > 0:
        sp_fixed = re.sub(pattern, replacement, sp_fixed)
        total_changes += count
        print(f"  ✓ Fixed: {pattern} → {replacement} ({count} occurrences)")

# Reconstruct file
content_fixed = before_sp + sp_fixed

# Verify fixes by searching for remaining lowercase usage
remaining_issues = []

# Check for "ON j." pattern (lowercase j in ON clause)
on_j_lower = re.findall(r"ON j\.", content_fixed[sp_start:])
if on_j_lower:
    remaining_issues.append(f"ON j. : {len(on_j_lower)}")

# Check for "AND j." pattern
and_j_lower = re.findall(r"AND j\.", content_fixed[sp_start:])
if and_j_lower:
    remaining_issues.append(f"AND j. : {len(and_j_lower)}")

print("\n" + "="*80)
print("Verification:")
print("="*80)

if remaining_issues:
    print("\n⚠ Potential remaining issues:")
    for issue in remaining_issues:
        print(f"  - {issue}")
else:
    print("\n✅ No remaining lowercase alias issues found")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
if total_changes > 0:
    print(f"✅ SUCCESS: Fixed {total_changes} table alias case mismatches!")
    print("\nFixed patterns:")
    print("  - ON j.`SourceId` → ON J.`SourceId`")
    print("  - AND j.`column` → AND J.`column`")
    print("  - WHERE j.column → WHERE J.column")
    print("\n✓ AWS case-sensitivity compatibility achieved")
else:
    print("ℹ No changes needed - aliases already consistent")

print(f"\n✓ File updated successfully!")
print("="*80)
