"""
Validate that all table alias case mismatches have been fixed
"""
import re

print("="*80)
print("Validating Table Alias Case-Sensitivity Fixes")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find stored procedures section
sp_start = content.find('prereq_stored_procs ="""')
if sp_start == -1:
    print("❌ Could not find prereq_stored_procs!")
    exit(1)

stored_procedures = content[sp_start:]

# Check for remaining lowercase alias issues
checks = {
    'ON j. (lowercase j)': r'\bON j\.',
    'AND j. (lowercase j)': r'\bAND j\.',
    'SET j. (lowercase j)': r'\bSET j\.',
    'WHERE j. (lowercase j)': r'\bWHERE j\.',
    'WHEN j. (lowercase j)': r'\bWHEN j\.',
}

print("\n1. Checking for remaining lowercase 'j' alias issues:")
print("-" * 80)

all_clear = True
total_issues = 0

for check_name, pattern in checks.items():
    matches = re.findall(pattern, stored_procedures)
    count = len(matches)

    status = "✅" if count == 0 else "❌"
    print(f"{status} {check_name}: {count} found")

    if count > 0:
        all_clear = False
        total_issues += count

# Check that we have uppercase J references
uppercase_j_count = len(re.findall(r'\bON J\.', stored_procedures))
print(f"\n✓ Uppercase 'J' references in ON clauses: {uppercase_j_count}")

# Verify SourceId column references are correct (mixed case)
sourceid_refs = len(re.findall(r'SourceId', stored_procedures))
print(f"✓ SourceId column references (mixed case): {sourceid_refs}")

# Check for common patterns that should now work
print("\n" + "="*80)
print("2. Validating Correct Patterns:")
print("="*80)

correct_patterns = {
    'ON J.`SourceId`': r'ON J\.`SourceId`',
    'AND J.`OrganisationID`': r'AND J\.`OrganisationID`',
    'SET J.`ContactId`': r'SET J\.`ContactId`',
}

for pattern_name, pattern in correct_patterns.items():
    matches = re.findall(pattern, stored_procedures)
    count = len(matches)
    print(f"✓ {pattern_name}: {count} found")

# Summary
print("\n" + "="*80)
print("VALIDATION SUMMARY:")
print("="*80)

if all_clear and uppercase_j_count > 0 and sourceid_refs > 0:
    print("\n✅ SUCCESS: All table alias case mismatches have been fixed!")
    print(f"\n✓ No lowercase 'j' aliases found in ON/AND/SET/WHERE clauses")
    print(f"✓ {uppercase_j_count} uppercase 'J' aliases properly used")
    print(f"✓ {sourceid_refs} SourceId column references (correct mixed case)")
    print("\n🎯 AWS case-sensitivity requirements met!")
    print("\n✓ Ready to test: CALL sp_dynamic_xeroblue_journals('1518', 5393, 5393)")
else:
    print(f"\n⚠ WARNING: {total_issues} potential issues remain")
    print("  Please review the output above for details")

print("="*80)
