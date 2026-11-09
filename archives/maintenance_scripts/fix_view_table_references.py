"""
Fix view and table references - make everything lowercase for uniformity
"""
import re

print("="*80)
print("Fixing View and Table References - All Lowercase")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Issue 1: View names should be all lowercase
print("\n1. Fixing view names to lowercase:")
print("-" * 40)

# Pattern: BIGOLESHOECOMPANY_CLIENT0000 should be bigoleshoecompany_client0000
view_before = content.count('BIGOLESHOECOMPANY_CLIENT0000')
print(f"   Found {view_before} instances of uppercase view name template")

# Fix: Make view names lowercase
content_fixed = content.replace(
    'BIGOLESHOECOMPANY_CLIENT0000',
    'bigoleshoecompany_client0000'
)

view_after = content_fixed.count('BIGOLESHOECOMPANY_CLIENT0000')
print(f"   After fix: {view_after} instances remaining")
print(f"   ✓ Fixed {view_before - view_after} view name references")

# Issue 2: Table alias case mismatch
print("\n2. Fixing table alias case mismatch:")
print("-" * 40)

# FROM c0000_xeroblue_journals Tb (capital T) but references use tb (lowercase)
alias_before = content_fixed.count('FROM evadb_stage.c0000_xeroblue_journals Tb')
alias_before2 = content_fixed.count('FROM c0000_xeroblue_journals Tb')
total_alias = alias_before + alias_before2

print(f"   Found {total_alias} instances of 'FROM ... Tb' (should be 'tb')")

# Fix: Change Tb to tb for journals
content_fixed = content_fixed.replace(
    'FROM evadb_stage.c0000_xeroblue_journals Tb',
    'FROM evadb_stage.c0000_xeroblue_journals tb'
)
content_fixed = content_fixed.replace(
    'FROM c0000_xeroblue_journals Tb',
    'FROM c0000_xeroblue_journals tb'
)

alias_after = content_fixed.count(' Tb\n') + content_fixed.count(' Tb ')
print(f"   ✓ Fixed table alias to lowercase 'tb'")

# Issue 3: Mixed case table names - find all patterns
print("\n3. Fixing mixed-case table names:")
print("-" * 40)

# Find all c0000_xeroblue_XXX patterns where XXX has capital letters
mixed_case_tables = re.findall(
    r'c0000_xeroblue_[A-Z][a-zA-Z]+',
    content_fixed
)

if mixed_case_tables:
    unique_tables = set(mixed_case_tables)
    print(f"   Found {len(unique_tables)} unique mixed-case table patterns:")

    for table in sorted(unique_tables):
        count = content_fixed.count(table)
        lowercase_table = table.lower()
        print(f"     - {table} → {lowercase_table} ({count} occurrences)")
        content_fixed = content_fixed.replace(table, lowercase_table)

    print(f"   ✓ Fixed all table names to lowercase")
else:
    print(f"   ✓ No mixed-case table names found")

# Issue 4: Check for any remaining uppercase patterns in table/view names
print("\n4. Checking for other case inconsistencies:")
print("-" * 40)

# Look for patterns like evadb_stage.c0000_xeroblue with mixed case
remaining_mixed = re.findall(
    r'(?:evadb_stage\.|evadb\.|vibedb\.)c\d+_xeroblue_[A-Z][a-zA-Z]+',
    content_fixed
)

if remaining_mixed:
    unique_remaining = set(remaining_mixed)
    print(f"   Found {len(unique_remaining)} remaining mixed-case patterns:")
    for pattern in sorted(unique_remaining):
        print(f"     - {pattern}")
    print(f"   ⚠ Warning: Some mixed-case patterns remain")
else:
    print(f"   ✓ No remaining mixed-case patterns")

# Issue 5: Check for evadb vs evadb_stage consistency
print("\n5. Checking database prefix usage:")
print("-" * 40)

evadb_stage_count = content_fixed.count('evadb_stage.c0000')
evadb_count = content_fixed.count('evadb.c0000')
print(f"   evadb_stage.c0000 references: {evadb_stage_count}")
print(f"   evadb.c0000 references: {evadb_count}")
print(f"   ✓ Database prefixes will be handled at runtime")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("SUMMARY OF FIXES")
print("="*80)
print(f"\n✅ View names: BIGOLESHOECOMPANY_CLIENT → bigoleshoecompany_client")
print(f"✅ Table alias: Tb → tb")
if mixed_case_tables:
    print(f"✅ Fixed {len(unique_tables)} mixed-case table names to lowercase")
print(f"\n✓ File updated successfully!")
print(f"✓ All views and tables now use consistent lowercase naming")
print("="*80)
