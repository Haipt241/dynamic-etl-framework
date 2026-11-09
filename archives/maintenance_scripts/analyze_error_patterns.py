"""
Analyze SQL error patterns from logs
"""
import re
from collections import defaultdict

# Read the log file
with open('logs/sql_errors/sql_errors_2025-10-22.log', 'r', encoding='utf-8') as f:
    content = f.read()

# Find all error blocks
error_blocks = content.split('='*80)

# Pattern analysis
error_patterns = defaultdict(list)

for block in error_blocks:
    # Extract error message
    error_match = re.search(r'ERROR MESSAGE: .*?"([^"]+)"', block)
    if error_match:
        error_msg = error_match.group(1)

        # Extract context
        context_match = re.search(r'CONTEXT: (\S+)', block)
        context = context_match.group(1) if context_match else "Unknown"

        # Categorize errors
        if "doesn't exist" in error_msg or "doesn't exist" in error_msg:
            # Extract table name
            table_match = re.search(r"Table '([^']+)'", error_msg)
            if table_match:
                table = table_match.group(1)
                error_patterns['missing_table'].append({
                    'table': table,
                    'context': context,
                    'message': error_msg
                })
        elif "syntax error" in error_msg.lower():
            error_patterns['syntax_error'].append({
                'context': context,
                'message': error_msg
            })
        else:
            error_patterns['other'].append({
                'context': context,
                'message': error_msg
            })

# Print summary
print("="*80)
print("SQL ERROR PATTERN ANALYSIS")
print("="*80)

print("\n1. MISSING TABLE ERRORS:")
print("-" * 80)
missing_tables = defaultdict(list)
for error in error_patterns.get('missing_table', []):
    missing_tables[error['table']].append(error['context'])

for table, contexts in sorted(missing_tables.items()):
    print(f"\nTable: {table}")
    print(f"  Referenced in: {', '.join(set(contexts))}")

    # Identify the issue
    if 'foreignexchange_master' in table:
        print(f"  ❌ ISSUE: foreignexchange_master should be in vibedb_cms, not {table.split('.')[0]}")
        print(f"  ✓ FIX: Need to update stored procedures to use vibedb_cms.foreignexchange_master")
    elif 'firms_with_containers' in table:
        print(f"  ✅ ALREADY FIXED: Changed ExecuteEvaSP to ExecuteCMSSP")
    elif '_aud' in table:
        print(f"  ❌ ISSUE: Audit table doesn't exist or has wrong database name")
        print(f"  ✓ FIX: Check if audit tables should exist or be created")
    else:
        print(f"  ❌ ISSUE: Table missing from database")

print("\n" + "="*80)
print("SUMMARY OF FIXES NEEDED:")
print("="*80)

# Count unique issues
fx_count = sum(1 for t in missing_tables.keys() if 'foreignexchange_master' in t)
audit_count = sum(1 for t in missing_tables.keys() if '_aud' in t)
firms_count = sum(1 for t in missing_tables.keys() if 'firms_with_containers' in t)

print(f"\n1. ✅ firms_with_containers errors: {firms_count} - ALREADY FIXED")
print(f"2. ❌ foreignexchange_master errors: {fx_count} - NEEDS FIX")
print(f"3. ❌ Audit table (_aud) errors: {audit_count} - NEEDS INVESTIGATION")

if fx_count > 0:
    print("\nFOREIGN EXCHANGE FIX:")
    print("-" * 80)
    print("Issue: Stored procedures reference foreignexchange_master without database prefix")
    print("Solution: Update procedures to use vibedb_cms.foreignexchange_master")
    print("\nProcedures that need fixing:")
    fx_contexts = set()
    for table, contexts in missing_tables.items():
        if 'foreignexchange_master' in table:
            fx_contexts.update(contexts)
    for ctx in sorted(fx_contexts):
        print(f"  - {ctx}")

print("\n" + "="*80)
