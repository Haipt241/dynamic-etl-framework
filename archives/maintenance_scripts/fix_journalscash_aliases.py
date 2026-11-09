"""
Fix table alias case mismatches in sp_dynamic_xeroblue_journalscash
"""
import re

print("="*80)
print("Fixing Table Alias Case Mismatches in sp_dynamic_xeroblue_journalscash")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find sp_dynamic_xeroblue_journalscash procedure
sp_start = content.find('CREATE PROCEDURE sp_dynamic_xeroblue_journalscash')
sp_end = content.find('CREATE PROCEDURE sp_dynamic_xeroblue_journals (IN p_clientID')

if sp_start == -1 or sp_end == -1:
    print("❌ Could not find sp_dynamic_xeroblue_journalscash procedure!")
    exit(1)

before_proc = content[:sp_start]
procedure = content[sp_start:sp_end]
after_proc = content[sp_end:]

print(f"\nFound procedure from position {sp_start} to {sp_end}")
print(f"Procedure length: {len(procedure)} characters")

# Search for specific issues in this procedure
issues_found = []

# Issue 1: Line ~16013 - lowercase j in AND clause
issue1 = len(re.findall(r"AND ABS\(j\.`JournalLine_NetAmount`\)", procedure))
if issue1 > 0:
    issues_found.append(f"AND ABS(j.`JournalLine_NetAmount`): {issue1}")

# Issue 2: Line ~16043 - lowercase j in CASE ELSE
issue2 = len(re.findall(r"ELSE j\.`Reference`", procedure))
if issue2 > 0:
    issues_found.append(f"ELSE j.`Reference`: {issue2}")

# Issue 3: Lines 16156-16161 - lowercase j alias with backticks
issue3 = len(re.findall(r"@finalTable, ' `j`", procedure))
if issue3 > 0:
    issues_found.append(f"@finalTable, ' `j`: {issue3}")

# Issue 4: Lines 16166-16173 - ON uppercase J but SET lowercase j
issue4 = len(re.findall(r"ON J\.`SourceId`.*?SET `j`\.`InvoiceTotal`", procedure, re.DOTALL))
if issue4 > 0:
    issues_found.append(f"ON J... SET `j`: {issue4}")

# Issue 5: Lines 16178-16181 - UPDATE J but SET `j`
issue5 = len(re.findall(r"UPDATE ', @finalTable, ' J.*?SET `j`\.`IsVisible`", procedure, re.DOTALL))
if issue5 > 0:
    issues_found.append(f"UPDATE J... SET `j`: {issue5}")

print(f"\nIssues found in sp_dynamic_xeroblue_journalscash:")
for issue in issues_found:
    print(f"  - {issue}")

# Apply fixes
proc_fixed = procedure

# Fix 1: AND ABS(j. -> AND ABS(J.
proc_fixed = re.sub(r'AND ABS\(j\.`', 'AND ABS(J.`', proc_fixed)
print("\n✓ Fixed: AND ABS(j.` → AND ABS(J.`")

# Fix 2: ELSE j.`Reference` -> ELSE J.`Reference`
proc_fixed = re.sub(r'ELSE j\.`Reference`', 'ELSE J.`Reference`', proc_fixed)
print("✓ Fixed: ELSE j.`Reference` → ELSE J.`Reference`")

# Fix 3: @finalTable, ' `j` -> @finalTable, ' `J`
proc_fixed = re.sub(r"(@finalTable, ') `j`", r"\1 `J`", proc_fixed)
print("✓ Fixed: @finalTable, ' `j` → @finalTable, ' `J`")

# Fix 4: SET `j`. -> SET `J`. (when preceded by ON J.)
# Need to be more careful here - fix backtick-quoted lowercase j
proc_fixed = re.sub(r'SET `j`\.', 'SET `J`.', proc_fixed)
print("✓ Fixed: SET `j`. → SET `J`.")

# Fix 5: WHERE `j`. -> WHERE `J`.
proc_fixed = re.sub(r'WHERE `j`\.', 'WHERE `J`.', proc_fixed)
print("✓ Fixed: WHERE `j`. → WHERE `J`.")

# Fix 6: AND `j`. -> AND `J`.
proc_fixed = re.sub(r'AND `j`\.', 'AND `J`.', proc_fixed)
print("✓ Fixed: AND `j`. → AND `J`.")

# Fix 7: ON `org`.`OrganisationID` = `j`.`OrganisationID` - this should use J
proc_fixed = re.sub(r"ON `org`\.`OrganisationID` = `j`\.`OrganisationID`",
                    "ON `org`.`OrganisationID` = `J`.`OrganisationID`", proc_fixed)
print("✓ Fixed: ON `org`.`OrganisationID` = `j`.`OrganisationID` → ...`J`...")

# Reconstruct file
content_fixed = before_proc + proc_fixed + after_proc

# Verify fixes in the procedure
remaining_issues = []

# Check for remaining lowercase j in backticks
remaining_j_backtick = len(re.findall(r'`j`\.', proc_fixed))
if remaining_j_backtick > 0:
    remaining_issues.append(f"`j`. : {remaining_j_backtick}")

# Check for remaining lowercase j without backticks (in specific contexts)
remaining_j_and = len(re.findall(r'\bAND j\.', proc_fixed))
if remaining_j_and > 0:
    remaining_issues.append(f"AND j. : {remaining_j_and}")

remaining_j_else = len(re.findall(r'\bELSE j\.', proc_fixed))
if remaining_j_else > 0:
    remaining_issues.append(f"ELSE j. : {remaining_j_else}")

print(f"\n" + "="*80)
print("Verification:")
print("="*80)

if remaining_issues:
    print("\n⚠ Remaining potential issues:")
    for issue in remaining_issues:
        print(f"  - {issue}")
else:
    print("\n✅ No remaining lowercase j alias issues in sp_dynamic_xeroblue_journalscash")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print(f"\n✓ File updated successfully!")
print("="*80)
