"""
Validate that both sp_dynamic_xeroblue_journals and sp_dynamic_xeroblue_journalscash
have all table alias case mismatches fixed
"""
import re

print("="*80)
print("Validating Both Journal Stored Procedures")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find both procedures
journals_start = content.find('CREATE PROCEDURE sp_dynamic_xeroblue_journals (IN p_clientID')
journals_end = content.find('$$\n\n--\n-- Create procedure', journals_start + 100)

journalscash_start = content.find('CREATE PROCEDURE sp_dynamic_xeroblue_journalscash')
journalscash_end = journals_start  # journalscash comes before journals

if journals_start == -1 or journalscash_start == -1:
    print("❌ Could not find procedures!")
    exit(1)

journals_proc = content[journals_start:journals_end]
journalscash_proc = content[journalscash_start:journalscash_end]

print(f"\nFound procedures:")
print(f"  sp_dynamic_xeroblue_journalscash: {len(journalscash_proc)} chars")
print(f"  sp_dynamic_xeroblue_journals: {len(journals_proc)} chars")

# Define checks for lowercase alias issues
checks = {
    'ON j. (not backtick)': r'\bON j\.',
    'AND j. (not backtick)': r'\bAND j\.',
    'SET j. (not backtick)': r'\bSET j\.',
    'WHERE j. (not backtick)': r'\bWHERE j\.',
    'ELSE j. (not backtick)': r'\bELSE j\.',
    'ON `j`.': r'ON `j`\.',
    'AND `j`.': r'AND `j`\.',
    'SET `j`.': r'SET `j`\.',
    'WHERE `j`.': r'WHERE `j`\.',
    "alias ' `j`": r"' `j`",
}

# Check sp_dynamic_xeroblue_journals
print("\n" + "="*80)
print("1. sp_dynamic_xeroblue_journals:")
print("="*80)

journals_issues = {}
journals_total = 0

for check_name, pattern in checks.items():
    matches = re.findall(pattern, journals_proc)
    count = len(matches)

    if count > 0:
        journals_issues[check_name] = count
        journals_total += count
        print(f"  ❌ {check_name}: {count} found")

if not journals_issues:
    print("  ✅ No lowercase 'j' alias issues found")

# Check sp_dynamic_xeroblue_journalscash
print("\n" + "="*80)
print("2. sp_dynamic_xeroblue_journalscash:")
print("="*80)

journalscash_issues = {}
journalscash_total = 0

for check_name, pattern in checks.items():
    matches = re.findall(pattern, journalscash_proc)
    count = len(matches)

    if count > 0:
        journalscash_issues[check_name] = count
        journalscash_total += count
        print(f"  ❌ {check_name}: {count} found")

if not journalscash_issues:
    print("  ✅ No lowercase 'j' alias issues found")

# Check for correct uppercase usage
print("\n" + "="*80)
print("3. Correct Uppercase Usage:")
print("="*80)

journals_uppercase_j = len(re.findall(r'\bON J\.', journals_proc))
journalscash_uppercase_j = len(re.findall(r'\bON J\.', journalscash_proc))

print(f"  sp_dynamic_xeroblue_journals:")
print(f"    ✓ ON J. references: {journals_uppercase_j}")

print(f"  sp_dynamic_xeroblue_journalscash:")
print(f"    ✓ ON J. references: {journalscash_uppercase_j}")

# Overall summary
print("\n" + "="*80)
print("VALIDATION SUMMARY:")
print("="*80)

all_clear = (journals_total == 0 and journalscash_total == 0)

if all_clear:
    print("\n✅ SUCCESS: Both procedures are fixed!")
    print(f"\n✓ sp_dynamic_xeroblue_journals: No issues ({journals_uppercase_j} correct ON J. refs)")
    print(f"✓ sp_dynamic_xeroblue_journalscash: No issues ({journalscash_uppercase_j} correct ON J. refs)")
    print("\n🎯 Both procedures ready for AWS deployment!")
else:
    print(f"\n⚠ WARNING: Issues remain")
    print(f"  sp_dynamic_xeroblue_journals: {journals_total} issues")
    print(f"  sp_dynamic_xeroblue_journalscash: {journalscash_total} issues")

print("="*80)
