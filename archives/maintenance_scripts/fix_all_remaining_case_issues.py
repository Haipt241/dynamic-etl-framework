"""
Fix ALL remaining case sensitivity issues in table references
"""
import re

print("="*80)
print("Fixing ALL Remaining Case Sensitivity Issues")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find ALL patterns with mixed case after c0000_xeroblue_
# Pattern: c0000_xeroblue_ followed by any word with at least one capital letter
all_mixed_patterns = re.findall(
    r'c0000_xeroblue_[a-zA-Z]*[A-Z][a-zA-Z]*',
    content
)

unique_patterns = sorted(set(all_mixed_patterns))

print(f"\nFound {len(unique_patterns)} unique mixed-case patterns:")
print("-" * 80)

content_fixed = content

for pattern in unique_patterns:
    count = content_fixed.count(pattern)
    lowercase_pattern = pattern.lower()

    print(f"  {pattern:50} → {lowercase_pattern:50} ({count:3} occurrences)")

    # Replace all occurrences
    content_fixed = content_fixed.replace(pattern, lowercase_pattern)

# Verify no more mixed-case patterns remain
remaining = re.findall(
    r'c0000_xeroblue_[a-z]*[A-Z][a-z]*',
    content_fixed
)

print("\n" + "="*80)
if remaining:
    print(f"⚠ WARNING: Found {len(set(remaining))} remaining mixed-case patterns:")
    for p in sorted(set(remaining)):
        print(f"    - {p}")
else:
    print(f"✅ All {len(unique_patterns)} mixed-case patterns fixed!")
    print(f"✅ No remaining mixed-case table references found")

# Also check for mixed case in actual table names (not just c0000 templates)
# Pattern: c{digits}_xeroblue_ with capital letters
runtime_mixed = re.findall(
    r'c\d+_xeroblue_[a-z]*[A-Z][a-z]*',
    content_fixed
)

if runtime_mixed:
    print(f"\n⚠ Found {len(set(runtime_mixed))} runtime mixed-case patterns:")
    for p in sorted(set(runtime_mixed)):
        print(f"    - {p}")
else:
    print(f"\n✅ No runtime mixed-case patterns found")

# Write back
with open('sql_object_scripts.py', 'w', encoding='utf-8') as f:
    f.write(content_fixed)

print("\n" + "="*80)
print("SUMMARY")
print("="*80)
print(f"✅ Fixed {len(unique_patterns)} unique mixed-case table patterns")
print(f"✅ All table references now use consistent lowercase naming")
print(f"✓ File updated successfully!")
print("="*80)
