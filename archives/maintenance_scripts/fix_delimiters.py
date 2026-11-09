"""
Fix stored procedure delimiters from $$ to ;
"""
import re

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

print("="*80)
print("Fixing Stored Procedure Delimiters")
print("="*80)

# Count original $$ occurrences
original_count = content.count('$$')
print(f"\nOriginal $$ count: {original_count}")

# Replace END\n$$ with END;
# Pattern: END at end of line, followed by $$
content_fixed = re.sub(r'END\n\$\$', 'END;', content)

# Count remaining $$ (should be 0)
remaining_count = content_fixed.count('$$')
print(f"Remaining $$ count after fix: {remaining_count}")

# Calculate how many were replaced
replaced = original_count - remaining_count
print(f"Replacements made: {replaced}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✓ File updated successfully!")
print("\nVerifying changes...")

# Read back and verify
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    verify_content = f.read()

# Count END; near the prereq_stored_procs section
start_idx = verify_content.find('prereq_stored_procs ="""')
if start_idx != -1:
    # Get just the prereq_stored_procs section (next ~10000 lines)
    section = verify_content[start_idx:start_idx+600000]
    end_semicolon_count = section.count('END;')
    print(f"Number of 'END;' in prereq_stored_procs section: {end_semicolon_count}")

print("\n" + "="*80)
print("Delimiter Fix Complete!")
print("="*80)
