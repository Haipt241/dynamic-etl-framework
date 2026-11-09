"""
Revert delimiters back to $$ format since execute_multiple_sqlscripts now handles it
"""
import re

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

print("="*80)
print("Reverting Stored Procedure Delimiters to $$")
print("="*80)

# Count original END; occurrences in prereq section
start_idx = content.find('prereq_stored_procs ="""')
if start_idx != -1:
    section = content[start_idx:]
    original_count = section.count('END;')
    print(f"\nOriginal END; count in prereq section: {original_count}")

# Replace END; with END\n$$
content_fixed = re.sub(r'END;', 'END\n$$', content)

# Count new $$ occurrences
if start_idx != -1:
    section_fixed = content_fixed[start_idx:]
    new_count = section_fixed.count('$$')
    print(f"New $$ count in prereq section: {new_count}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✓ File updated successfully!")
print("\n" + "="*80)
print("Delimiter Revert Complete!")
print("="*80)
