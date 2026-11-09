"""
Fix remaining table alias case issues in sp_dynamic_xeroblue_journals
"""
import re

print("="*80)
print("Fixing Remaining Issues in sp_dynamic_xeroblue_journals")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find sp_dynamic_xeroblue_journals procedure
journals_start = content.find('CREATE PROCEDURE sp_dynamic_xeroblue_journals (IN p_clientID')
journals_end = content.find('$$\n\n--\n-- Create procedure', journals_start + 100)

if journals_start == -1 or journals_end == -1:
    print("❌ Could not find sp_dynamic_xeroblue_journals procedure!")
    exit(1)

before_proc = content[:journals_start]
procedure = content[journals_start:journals_end]
after_proc = content[journals_end:]

print(f"\nFound procedure from position {journals_start} to {journals_end}")

# Count current issues
issues = {
    'ELSE j.': len(re.findall(r'\bELSE j\.', procedure)),
    'AND `j`.': len(re.findall(r'AND `j`\.', procedure)),
    'SET `j`.': len(re.findall(r'SET `j`\.', procedure)),
    'WHERE `j`.': len(re.findall(r'WHERE `j`\.', procedure)),
    "alias ' `j`": len(re.findall(r"' `j`", procedure)),
}

print("\nCurrent issues:")
for issue, count in issues.items():
    if count > 0:
        print(f"  - {issue}: {count}")

# Apply fixes
proc_fixed = procedure

# Fix 1: ELSE j. -> ELSE J.
proc_fixed = re.sub(r'\bELSE j\.', 'ELSE J.', proc_fixed)
print("\n✓ Fixed: ELSE j. → ELSE J.")

# Fix 2: AND `j`. -> AND `J`.
proc_fixed = re.sub(r'AND `j`\.', 'AND `J`.', proc_fixed)
print("✓ Fixed: AND `j`. → AND `J`.")

# Fix 3: SET `j`. -> SET `J`.
proc_fixed = re.sub(r'SET `j`\.', 'SET `J`.', proc_fixed)
print("✓ Fixed: SET `j`. → SET `J`.")

# Fix 4: WHERE `j`. -> WHERE `J`.
proc_fixed = re.sub(r'WHERE `j`\.', 'WHERE `J`.', proc_fixed)
print("✓ Fixed: WHERE `j`. → WHERE `J`.")

# Fix 5: ' `j` -> ' `J`
proc_fixed = re.sub(r"' `j`", "' `J`", proc_fixed)
print("✓ Fixed: ' `j` → ' `J`")

# Reconstruct file
content_fixed = before_proc + proc_fixed + after_proc

# Verify fixes
remaining = {
    'ELSE j.': len(re.findall(r'\bELSE j\.', proc_fixed)),
    'AND `j`.': len(re.findall(r'AND `j`\.', proc_fixed)),
    'SET `j`.': len(re.findall(r'SET `j`\.', proc_fixed)),
    'WHERE `j`.': len(re.findall(r'WHERE `j`\.', proc_fixed)),
    "alias ' `j`": len(re.findall(r"' `j`", proc_fixed)),
}

print("\n" + "="*80)
print("Verification:")
print("="*80)

total_remaining = sum(remaining.values())

if total_remaining == 0:
    print("\n✅ All issues fixed in sp_dynamic_xeroblue_journals!")
else:
    print(f"\n⚠ {total_remaining} issues remain:")
    for issue, count in remaining.items():
        if count > 0:
            print(f"  - {issue}: {count}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print(f"\n✓ File updated successfully!")
print("="*80)
