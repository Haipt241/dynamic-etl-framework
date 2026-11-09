import sql_helper
from sqlalchemy import text

print('=== Checking if stored procedures exist in vibedb_stage ===')

# Check for stored procedures
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text("""
        SELECT ROUTINE_NAME, ROUTINE_TYPE
        FROM information_schema.ROUTINES
        WHERE ROUTINE_SCHEMA = 'vibedb_stage'
        AND ROUTINE_NAME LIKE '%sp_dynamic_xeroblue%'
        LIMIT 5
    """)).fetchall()

    if result:
        print(f'✓ Found {len(result)} stored procedures')
        for row in result:
            print(f'  - {row[0]} ({row[1]})')
    else:
        print('✗ NO stored procedures found matching sp_dynamic_xeroblue%')

print('\n=== Checking for production tables (c1518_xeroblue_*) ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text("""
        SELECT TABLE_NAME
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = 'vibedb_stage'
        AND TABLE_NAME LIKE 'c1518_xeroblue_%'
        AND TABLE_NAME NOT LIKE '%stage'
        LIMIT 10
    """)).fetchall()

    if result:
        print(f'✓ Found {len(result)} production tables')
        for row in result:
            print(f'  - {row[0]}')
    else:
        print('✗ NO production tables found (only stage tables exist)')

print('\n=== Checking for stage tables (c1518_%_xeroblue_%stage) ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text("""
        SELECT TABLE_NAME, TABLE_ROWS
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = 'vibedb_stage'
        AND TABLE_NAME LIKE 'c1518_%_xeroblue_%stage'
        LIMIT 10
    """)).fetchall()

    if result:
        print(f'✓ Found {len(result)} stage tables')
        for row in result:
            print(f'  - {row[0]} ({row[1]} rows)')
    else:
        print('✗ NO stage tables found')

print('\n=== Testing if sp_dynamic_xeroblue_invoices exists ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text("""
        SELECT ROUTINE_NAME, ROUTINE_DEFINITION
        FROM information_schema.ROUTINES
        WHERE ROUTINE_SCHEMA = 'vibedb_stage'
        AND ROUTINE_NAME = 'sp_dynamic_xeroblue_invoices'
    """)).fetchone()

    if result:
        print(f'✓ sp_dynamic_xeroblue_invoices EXISTS')
        # Show first 500 chars of definition
        defn = result[1][:500] if result[1] else 'N/A'
        print(f'Definition preview: {defn}...')
    else:
        print('✗ sp_dynamic_xeroblue_invoices DOES NOT EXIST')
