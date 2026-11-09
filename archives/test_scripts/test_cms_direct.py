"""
Direct test of CMS query to debug Status mismatch
"""
import os
os.environ['USE_AWS_DB'] = 'True'
os.environ['EtaniClientID'] = 'DOUGLASINNOVATIONS_CLIENT2022'
os.environ['EtaniOrganisationID'] = '7102'

from sql_helper import get_cms_engine
from sqlalchemy import text
import pandas as pd

print("=" * 80)
print("DIRECT CMS QUERY TEST")
print("=" * 80)

# Get the CMS engine
engine = get_cms_engine()
print(f"✅ Got CMS engine: {engine.url.database}")

with engine.connect() as conn:
    # Test 1: Simple direct query
    print("\n" + "=" * 80)
    print("TEST 1: Direct SELECT - No JOINs, No JSON functions")
    print("=" * 80)

    query1 = text("""
        SELECT
            id,
            Client,
            Service,
            Status,
            AccountingFirm
        FROM client_service
        WHERE id = 7102
    """)

    print(f"Query: {query1}")
    result1 = conn.execute(query1)
    rows1 = result1.fetchall()

    if rows1:
        for row in rows1:
            print(f"✅ FOUND RECORD:")
            print(f"   id: {row[0]}")
            print(f"   Client: {row[1]}")
            print(f"   Service: {row[2]}")
            print(f"   Status: {row[3]} ⭐⭐⭐")
            print(f"   AccountingFirm: {row[4]}")
    else:
        print("❌ No record found")

    # Test 2: WITH explicit database name
    print("\n" + "=" * 80)
    print("TEST 2: Explicit database.table reference")
    print("=" * 80)

    query2 = text("""
        SELECT
            id,
            Client,
            Service,
            Status,
            AccountingFirm
        FROM vibedb_cms.client_service
        WHERE id = 7102
    """)

    print(f"Query: {query2}")
    result2 = conn.execute(query2)
    rows2 = result2.fetchall()

    if rows2:
        for row in rows2:
            print(f"✅ FOUND RECORD:")
            print(f"   id: {row[0]}")
            print(f"   Client: {row[1]}")
            print(f"   Service: {row[2]}")
            print(f"   Status: {row[3]} ⭐⭐⭐")
            print(f"   AccountingFirm: {row[4]}")
    else:
        print("❌ No record found")

    # Test 3: Check what database we're in
    print("\n" + "=" * 80)
    print("TEST 3: Verify connected database")
    print("=" * 80)

    query3 = text("SELECT DATABASE()")
    result3 = conn.execute(query3)
    current_db = result3.fetchone()[0]
    print(f"✅ Currently connected to database: {current_db}")

    # Test 4: Show all databases
    print("\n" + "=" * 80)
    print("TEST 4: List available databases")
    print("=" * 80)

    query4 = text("SHOW DATABASES LIKE 'vibedb%'")
    result4 = conn.execute(query4)
    dbs = result4.fetchall()
    print(f"Available databases:")
    for db in dbs:
        print(f"   - {db[0]}")

    # Test 5: Check if there are multiple records with id=7102 (shouldn't be possible)
    print("\n" + "=" * 80)
    print("TEST 5: Count records with id=7102")
    print("=" * 80)

    query5 = text("""
        SELECT COUNT(*) as count
        FROM vibedb_cms.client_service
        WHERE id = 7102
    """)

    result5 = conn.execute(query5)
    count = result5.fetchone()[0]
    print(f"Records with id=7102: {count}")

    # Test 6: The ACTUAL query with JOIN
    print("\n" + "=" * 80)
    print("TEST 6: Query WITH JOIN (like cms_manager does)")
    print("=" * 80)

    query6 = text("""
        SELECT
            cs1.Status,
            cs1.id as ClientServiceID,
            cs1.Client as ClientID,
            c.accountingFirm as FirmID
        FROM vibedb_cms.client_service cs1
        INNER JOIN vibedb_cms.client c
            ON cs1.Client = c.id
        WHERE cs1.Service = 62
            AND cs1.id = 7102
    """)

    print(f"Query: {query6}")
    result6 = conn.execute(query6)
    rows6 = result6.fetchall()

    if rows6:
        for row in rows6:
            print(f"✅ FOUND RECORD:")
            print(f"   Status: {row[0]} ⭐⭐⭐")
            print(f"   ClientServiceID: {row[1]}")
            print(f"   ClientID: {row[2]}")
            print(f"   FirmID: {row[3]}")
    else:
        print("❌ No record found")

print("\n" + "=" * 80)
print("SUMMARY")
print("=" * 80)
print("If all tests show Status=12, but Python code shows Status=1,")
print("then there's a caching or connection pool issue.")
