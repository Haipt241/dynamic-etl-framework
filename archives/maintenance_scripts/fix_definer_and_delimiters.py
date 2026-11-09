"""
Fix DEFINER clauses and delimiter issues in sql_object_scripts.py
"""
import re

print("="*80)
print("Fixing DEFINER Clauses and Delimiters in sql_object_scripts.py")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Count original DEFINER clauses
original_definer_count = content.count('DEFINER')
print(f"\nOriginal DEFINER count: {original_definer_count}")

# Remove DEFINER clauses
# Pattern: CREATE\nDEFINER = 'xxx'@'%'\nPROCEDURE -> CREATE PROCEDURE
content_fixed = re.sub(
    r'CREATE\s+DEFINER\s*=\s*[^\s]+\s+PROCEDURE',
    'CREATE PROCEDURE',
    content,
    flags=re.MULTILINE
)

# Count remaining DEFINER clauses
remaining_definer_count = content_fixed.count('DEFINER')
print(f"Remaining DEFINER count: {remaining_definer_count}")
print(f"Removed: {original_definer_count - remaining_definer_count}")

# Fix delimiter issue where $$ appears in middle of procedures
# Look for pattern: END\n$$\n  SET (which indicates $$ in wrong place)
# Should be: END;\n  SET
delimiter_fixes = 0

# Find cases where $$ appears after something other than END
# Pattern: not END, then $$, then more SQL statements
lines = content_fixed.split('\n')
fixed_lines = []
in_procedure = False

for i, line in enumerate(lines):
    # Check if we're entering a CREATE PROCEDURE
    if re.search(r'CREATE\s+PROCEDURE', line, re.IGNORECASE):
        in_procedure = True

    # Check if line ends with $$ but it's not after END
    if in_procedure and line.strip().endswith('$$'):
        # Look back to see if previous non-empty line ends with END
        prev_line_idx = i - 1
        while prev_line_idx >= 0 and not lines[prev_line_idx].strip():
            prev_line_idx -= 1

        if prev_line_idx >= 0:
            prev_line_stripped = lines[prev_line_idx].strip()
            if not prev_line_stripped.upper().startswith('END'):
                # This $$ is in the wrong place, should be ;
                line = line.replace('$$', ';')
                delimiter_fixes += 1
                print(f"  Fixed delimiter on line {i+1}: {line[:80]}")

    # Check if we're at the end of a procedure
    if in_procedure and line.strip().upper().startswith('END') and '$$' in lines[i:i+2]:
        in_procedure = False

    fixed_lines.append(line)

content_fixed = '\n'.join(fixed_lines)

print(f"\nDelimiter fixes applied: {delimiter_fixes}")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n✓ File updated successfully!")
print("\n" + "="*80)
print("Fixes Complete!")
print("="*80)
print(f"\nSummary:")
print(f"  - Removed {original_definer_count - remaining_definer_count} DEFINER clauses")
print(f"  - Fixed {delimiter_fixes} misplaced $$ delimiters")
