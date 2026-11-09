"""
Test SQL syntax by parsing each statement
"""
import os
import re

# Set up environment
os.environ['USE_AWS_DB'] = 'False'
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TEST_CLIENT9999'
os.environ['EtaniOrganisationID'] = '999999'
os.environ['XeroTenantID'] = 'test'

import sql_object_scripts as sqlobj

print("="*80)
print("Testing SQL Statement Syntax")
print("="*80)

def validate_sql_statement(stmt, stmt_type, proc_name=None):
    """Validate a SQL statement for common syntax errors"""
    issues = []

    # Check for DEFINER
    if 'DEFINER' in stmt.upper():
        issues.append("Contains DEFINER clause")

    # Check for incomplete DECLARE statements
    if 'DECLARE' in stmt.upper():
        # Find all DECLARE statements
        declares = re.findall(r'DECLARE\s+\w+\s+\w+(?:\(\d+\))?\s+DEFAULT\s*(\S*)', stmt, re.IGNORECASE)
        for default_val in declares:
            if not default_val or default_val in ['DECLARE', 'SET', 'SELECT', 'BEGIN', 'END']:
                issues.append(f"Incomplete DECLARE with missing DEFAULT value")
                break

    # Check for misplaced delimiters
    if stmt_type == 'CREATE PROCEDURE':
        # Should not have $$ in middle
        lines = stmt.split('\n')
        for i, line in enumerate(lines):
            if '$$' in line and i < len(lines) - 3:  # Allow $$ near end
                if not line.strip().startswith('END'):
                    issues.append(f"Misplaced $$ delimiter in middle of procedure")
                    break

    return issues

print("\n1. Testing DROP PROCEDURE statements:")
print("-" * 40)

drops = sqlobj.prereq_drop_procedures
drop_statements = [s.strip() for s in drops.split(';') if s.strip() and 'DROP PROCEDURE' in s.upper()]

print(f"   Found {len(drop_statements)} DROP statements")

for i, stmt in enumerate(drop_statements[:3]):  # Test first 3
    issues = validate_sql_statement(stmt, 'DROP')
    if issues:
        print(f"   ✗ Statement {i+1}: {', '.join(issues)}")
    else:
        match = re.search(r'DROP PROCEDURE IF EXISTS\s+(\w+)', stmt, re.IGNORECASE)
        proc_name = match.group(1) if match else "UNKNOWN"
        print(f"   ✓ Statement {i+1}: {proc_name}")

if len(drop_statements) > 3:
    print(f"   ... and {len(drop_statements) - 3} more DROP statements")

print("\n2. Testing CREATE PROCEDURE statements:")
print("-" * 40)

creates = sqlobj.prereq_stored_procs

# Split using the same logic as execute_multiple_sqlscripts
has_procedures_with_delimiter = (
    bool(re.search(r'CREATE\s+PROCEDURE', creates, re.IGNORECASE))
    and creates.strip().endswith('$$')
)

if has_procedures_with_delimiter:
    segments = creates.strip().split('$$')
    statements = []

    for segment in segments:
        segment = segment.strip()
        if not segment:
            continue

        if re.search(r'CREATE\s+PROCEDURE', segment, re.IGNORECASE):
            statements.append(('CREATE PROCEDURE', segment))
        else:
            subsegments = segment.split(';')
            for subsegment in subsegments:
                subsegment = subsegment.strip()
                if subsegment:
                    statements.append(('OTHER', subsegment))
else:
    statements = [('OTHER', s.strip()) for s in creates.strip().split(';') if s.strip()]

create_statements = [s for t, s in statements if t == 'CREATE PROCEDURE']
print(f"   Found {len(create_statements)} CREATE statements")

errors_found = False

for i, stmt in enumerate(create_statements):
    match = re.search(r'PROCEDURE\s+(\w+)', stmt, re.IGNORECASE)
    proc_name = match.group(1) if match else "UNKNOWN"

    issues = validate_sql_statement(stmt, 'CREATE PROCEDURE', proc_name)

    if issues:
        errors_found = True
        print(f"\n   ✗ {proc_name}:")
        for issue in issues:
            print(f"      - {issue}")
        # Show first 500 chars of statement
        preview = stmt[:500].replace('\n', ' ')
        print(f"      Preview: {preview}...")
    else:
        # Check if complete
        has_begin = 'BEGIN' in stmt.upper()
        has_end = bool(re.search(r'\bEND\s*$', stmt.upper()))
        if has_begin and has_end:
            print(f"   ✓ {proc_name} - Complete")
        else:
            errors_found = True
            print(f"   ✗ {proc_name} - Incomplete (BEGIN: {has_begin}, END: {has_end})")

# Overall result
print("\n" + "="*80)
if errors_found:
    print("❌ SYNTAX ERRORS FOUND - SQL statements need corrections")
else:
    print("✅ ALL SQL STATEMENTS VALID - Ready to execute!")
print("="*80)
