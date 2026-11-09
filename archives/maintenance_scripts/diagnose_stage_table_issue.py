import sql_helper
from sqlalchemy import text

print('=== Diagnosing Stage Table Population Issue ===\n')

client_id = '1518'
org_id = 5393
stage_table = f'c{client_id}_{org_id}_xeroblue_invoicesstage'

# Check if foreignexchange_master table exists (used by stored procedure)
print('1. Checking if foreignexchange_master table exists:')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text("""
        SELECT COUNT(*) as count
        FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = 'vibedb_stage'
        AND LOWER(TABLE_NAME) = 'foreignexchange_master'
    """)).fetchone()

    if result[0] > 0:
        print(f'   ✓ foreignexchange_master table EXISTS')

        # Check if it has data
        result2 = conn.execute(text("SELECT COUNT(*) FROM foreignexchange_master")).fetchone()
        print(f'   ✓ Has {result2[0]} rows')
    else:
        print(f'   ✗ foreignexchange_master table DOES NOT EXIST')
        print('   This will cause stored procedure to fail!')

# Check current stage table status
print(f'\n2. Checking stage table: {stage_table}')
with sql_helper.eva_engine.connect() as conn:
    result = conn.execute(text(f"""
        SELECT COUNT(*) as count
        FROM {stage_table}
    """)).fetchone()
    print(f'   Current rows: {result[0]}')

# Check if LoadToEvaStageTable is actually committing
print(f'\n3. Testing if LoadToEvaStageTable commits data:')
print('   Simulating data load...')

import pandas as pd

# Create test dataframe
test_df = pd.DataFrame({
    'InvoiceId': ['TEST123'],
    'Type': ['ACCREC'],
    'ContactName': ['Test Contact'],
    'OrganisationID': [org_id],
    'Date': ['2025-01-01']
})

# Try to load test data
error_list = []
try:
    sql_helper.LoadToEvaStageTable(
        test_df,
        'TEST',
        'append',  # Don't truncate
        stage_table,
        error_list
    )
    print('   ✓ Test data loaded')

    # Check if data is there
    with sql_helper.eva_engine.connect() as conn:
        result = conn.execute(text(f"""
            SELECT COUNT(*) as count
            FROM {stage_table}
            WHERE InvoiceId = 'TEST123'
        """)).fetchone()

        if result[0] > 0:
            print(f'   ✓ Test data found in table ({result[0]} rows)')

            # Clean up test data
            conn.execute(text(f"DELETE FROM {stage_table} WHERE InvoiceId = 'TEST123'"))
            conn.commit()
            print('   ✓ Test data cleaned up')
        else:
            print('   ✗ Test data NOT found after load (commit issue?)')

except Exception as e:
    print(f'   ✗ Error: {e}')

if error_list:
    print(f'\n   Errors: {error_list}')
