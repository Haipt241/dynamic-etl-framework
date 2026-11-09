"""
Check if foreignexchange_master table exists in AWS
"""
import os
os.environ['USE_AWS_DB'] = 'True'
os.environ['DB_Destination'] = 'CMS'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'TEST_CLIENT9999'
os.environ['EtaniOrganisationID'] = '999999'
os.environ['XeroTenantID'] = 'test'

import sql_helper
from sqlalchemy import text

print("="*80)
print("Checking foreignexchange_master Table in AWS")
print("="*80)

print(f"\nAWS Mode: {sql_helper.USE_AWS_DB}")
print(f"CMS Database: {sql_helper.CMS_DB_NAME}")

try:
    # Get CMS engine
    cms_engine = sql_helper.get_cms_engine()

    # Check if table exists
    with cms_engine.connect() as connection:
        # Check in vibedb_cms
        query = """
            SELECT TABLE_NAME, TABLE_SCHEMA, TABLE_ROWS,
                   CREATE_TIME, UPDATE_TIME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'vibedb_cms'
            AND TABLE_NAME = 'foreignexchange_master'
        """
        result = connection.execute(text(query))
        row = result.fetchone()

        if row:
            print(f"\n✅ Table EXISTS in vibedb_cms")
            print(f"   Schema: {row[1]}")
            print(f"   Rows: {row[2]}")
            print(f"   Created: {row[3]}")
            print(f"   Updated: {row[4]}")

            # Check columns
            col_query = """
                SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_SCHEMA = 'vibedb_cms'
                AND TABLE_NAME = 'foreignexchange_master'
                ORDER BY ORDINAL_POSITION
            """
            col_result = connection.execute(text(col_query))
            columns = col_result.fetchall()

            print(f"\n   Columns ({len(columns)}):")
            for col in columns:
                print(f"     - {col[0]}: {col[1]} {'NULL' if col[2]=='YES' else 'NOT NULL'}")

            # Sample data
            sample_query = """
                SELECT * FROM vibedb_cms.foreignexchange_master
                LIMIT 5
            """
            sample_result = connection.execute(text(sample_query))
            samples = sample_result.fetchall()

            print(f"\n   Sample data (first 5 rows):")
            if samples:
                for sample in samples:
                    print(f"     {sample}")
            else:
                print("     (No data in table)")

        else:
            print(f"\n❌ Table DOES NOT EXIST in vibedb_cms")
            print(f"\n   You need to:")
            print(f"   1. Check if it exists in Azure vibedb database")
            print(f"   2. Migrate the table and data to AWS vibedb_cms")
            print(f"   3. Or create the table structure if it doesn't exist")

        # Also check if it exists in any other database
        other_query = """
            SELECT TABLE_SCHEMA, TABLE_ROWS
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = 'foreignexchange_master'
        """
        other_result = connection.execute(text(other_query))
        other_rows = other_result.fetchall()

        if other_rows:
            print(f"\n   Found in other databases:")
            for other_row in other_rows:
                print(f"     - {other_row[0]} ({other_row[1]} rows)")

except Exception as e:
    print(f"\n❌ ERROR: {e}")
    print(f"\n   Could not connect to AWS database or query failed")

print("\n" + "="*80)
