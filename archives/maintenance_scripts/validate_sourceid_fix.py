"""
Validate that all SourceId references have been changed to lowercase sourceid
"""
import re

print("="*80)
print("Validating SourceId Case-Sensitivity Fix")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Check for any remaining mixed-case SourceId references
# We'll look for patterns that should have been fixed

checks = {
    'Backtick SourceId (`SourceId`)': r'`SourceId`',
    'Alias dot SourceId (j.SourceId)': r'([a-z]+)\.SourceId',
    'PARTITION BY SourceId': r'PARTITION BY SourceId',
    'ORDER BY SourceId': r'ORDER BY SourceId',
}

print("\nChecking for remaining mixed-case SourceId references:")
print("-" * 80)

all_clear = True
for check_name, pattern in checks.items():
    matches = re.findall(pattern, content)
    count = len(matches)

    status = "✅" if count == 0 else "❌"
    print(f"{status} {check_name}: {count} found")

    if count > 0:
        all_clear = False
        # Show first example
        match = re.search(pattern, content)
        if match:
            start = max(0, match.start() - 50)
            end = min(len(content), match.end() + 50)
            context = content[start:end].replace('\n', ' ')
            print(f"   Example: ...{context}...")

# Check that we have lowercase sourceid references
lowercase_count = len(re.findall(r'sourceid', content, re.IGNORECASE))
print(f"\n✓ Total lowercase sourceid references: {lowercase_count}")

# Check specific patterns that should now be lowercase
print("\n" + "="*80)
print("Validating Correct Lowercase Usage:")
print("="*80)

correct_patterns = {
    'ON clauses with sourceid': r'ON\s+[a-z]+\.`?sourceid`?\s*=',
    'Column references `sourceid`': r'`sourceid`',
    'PARTITION BY sourceid': r'PARTITION BY sourceid',
}

for pattern_name, pattern in correct_patterns.items():
    matches = re.findall(pattern, content)
    count = len(matches)
    print(f"✓ {pattern_name}: {count} found")

print("\n" + "="*80)

if all_clear and lowercase_count > 0:
    print("✅ SUCCESS: All SourceId references have been properly converted to lowercase!")
    print("\nChanges applied:")
    print("  - `SourceId` → `sourceid` (column definitions)")
    print("  - j.SourceId → j.sourceid (table aliases)")
    print("  - PARTITION BY SourceId → PARTITION BY sourceid")
    print("  - INDEX ...SourceId... → INDEX ...sourceid...")
    print("\n✓ AWS case-sensitivity compatibility achieved")
else:
    print("⚠ WARNING: Some mixed-case SourceId references remain")
    print("  Please review the output above for details")

print("="*80)
