"""
Find all mixed-case SourceId references in stored procedures that need to be lowercase
"""
import re

print("="*80)
print("Finding Mixed-Case SourceId References in Stored Procedures")
print("="*80)

# Read the file
with open('sql_object_scripts.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the stored procedures section (starts at prereq_stored_procs)
sp_start = content.find('prereq_stored_procs ="""')
sp_end = len(content)  # Go to end of file

if sp_start == -1:
    print("❌ Could not find prereq_stored_procs!")
    exit(1)

stored_procedures = content[sp_start:sp_end]

# Find all references to SourceId (with mixed case) in stored procedures
# We're looking for patterns like:
# - j.SourceId, jc.SourceId, tb.SourceId, J.SourceId
# - `SourceId` (backtick-quoted)

patterns_to_find = [
    (r'([a-z]+)\.\`?SourceId\`?', 'alias.SourceId'),
    (r'`SourceId`', 'backtick SourceId'),
    (r'PARTITION BY SourceId', 'PARTITION BY SourceId'),
    (r'ORDER BY SourceId', 'ORDER BY SourceId'),
]

print("\nSearching stored procedures for mixed-case SourceId references...")

total_found = 0
for pattern, description in patterns_to_find:
    matches = list(re.finditer(pattern, stored_procedures))
    if matches:
        print(f"\n{description}: {len(matches)} occurrences")
        total_found += len(matches)

        # Show first 3 examples
        for i, match in enumerate(matches[:3], 1):
            start = max(0, match.start() - 50)
            end = min(len(stored_procedures), match.end() + 50)
            context = stored_procedures[start:end].replace('\n', ' ').strip()
            print(f"  Example {i}: ...{context}...")

print("\n" + "="*80)
print(f"Total mixed-case SourceId references found: {total_found}")
print("\n✓ All these need to be changed to lowercase: sourceid")
print("="*80)
