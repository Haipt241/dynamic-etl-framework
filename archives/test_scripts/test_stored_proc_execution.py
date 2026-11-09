import sql_helper
from sqlalchemy import text

print('=== Testing sp_dynamic_xeroblue_invoices execution ===')

client_id = '1518'
org_id = 5393
legacy_org_id = 5393

print(f'\nParameters:')
print(f'  client_id: {client_id}')
print(f'  org_id: {org_id}')
print(f'  legacy_org_id: {legacy_org_id}')

# First, check if stage table has data
print(f'\n=== Checking stage table: c{client_id}_{org_id}_xeroblue_invoicesstage ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text(f"""
        SELECT COUNT(*) as count
        FROM c{client_id}_{org_id}_xeroblue_invoicesstage
    """)).fetchone()
    print(f'Stage table rows: {result[0]}')

# Check if production table exists and has data
print(f'\n=== Checking production table: c{client_id}_xeroblue_invoices ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text(f"""
        SELECT COUNT(*) as count
        FROM c{client_id}_xeroblue_invoices
        WHERE OrganisationID = {org_id}
    """)).fetchone()
    print(f'Production table rows (for org {org_id}): {result[0]}')

# Now call the stored procedure with detailed error handling
print(f'\n=== Calling sp_dynamic_xeroblue_invoices ===')
try:
    with sql_helper.eva_engine.connect() as conn:
        # Enable SQL warnings
        conn.execute(text("SET SESSION sql_notes = 1"))
        conn.execute(text("SET SESSION sql_warnings = 1"))

        # Call the stored procedure
        result = conn.execute(text(f"""
            CALL sp_dynamic_xeroblue_invoices('{client_id}', {org_id}, {legacy_org_id})
        """))

        conn.commit()

        print(f'✓ Stored procedure executed')
        print(f'  Rows affected: {result.rowcount}')

        # Check if there were any warnings
        warnings = conn.execute(text("SHOW WARNINGS")).fetchall()
        if warnings:
            print(f'\n⚠ MySQL Warnings:')
            for w in warnings:
                print(f'  [{w[0]}] {w[1]}: {w[2]}')
        else:
            print('  No warnings')

except Exception as e:
    print(f'✗ Error: {e}')

# Check production table again after execution
print(f'\n=== Checking production table AFTER stored procedure ===')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text(f"""
        SELECT COUNT(*) as count
        FROM c{client_id}_xeroblue_invoices
        WHERE OrganisationID = {org_id}
    """)).fetchone()
    print(f'Production table rows (for org {org_id}): {result[0]}')
