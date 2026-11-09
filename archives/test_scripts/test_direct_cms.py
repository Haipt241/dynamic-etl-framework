"""
Direct CMS Database Query Test
Bypasses sql_helper to directly query the database
"""
import pymysql
import os
from dotenv import load_dotenv
import config

load_dotenv()

# Azure MySQL credentials
server = config.MYSQL_SERVER_NAME
username = config.MYSQL_SERVER_USERNAME
password = config.MYSQL_SERVER_PASSWORD
database = 'etaniv2'  # Azure CMS database (AWS uses 'vibedb_cms')
ssl_cert = config.MYSQL_SERVER_SSL_CERT

print("=" * 80)
print("DIRECT DATABASE CONNECTION TEST")
print("=" * 80)
print(f"Server: {server}")
print(f"Database: {database}")
print(f"SSL Cert exists: {os.path.exists(ssl_cert)}")
print("")

try:
    # Connect directly to MySQL
    connection = pymysql.connect(
        host=server,
        user=username,
        password=password,
        database=database,
        ssl={'ca': ssl_cert} if os.path.exists(ssl_cert) else None,
        cursorclass=pymysql.cursors.DictCursor
    )

    print("✅ Connected successfully!\n")

    with connection.cursor() as cursor:
        # Test 1: Direct query for client_service.id = 7102
        print("=" * 80)
        print("TEST 1: Direct SELECT from client_service WHERE id=7102")
        print("=" * 80)

        query1 = """
        SELECT
            id,
            Client,
            Service,
            Status,
            Details
        FROM client_service
        WHERE id = 7102
        """

        cursor.execute(query1)
        result1 = cursor.fetchone()

        if result1:
            print("✅ Record found!")
            print(f"   ID: {result1['id']}")
            print(f"   Client: {result1['Client']}")
            print(f"   Service: {result1['Service']}")
            print(f"   Status: {result1['Status']}")
            print(f"   Details: {result1['Details']}")
        else:
            print("❌ No record found with id=7102")

        # Test 2: Query with joins (like cms_manager does)
        print("\n" + "=" * 80)
        print("TEST 2: Query with joins and GROUP BY (like cms_manager.py)")
        print("=" * 80)

        query2 = """
        SELECT
            cs1.Status,
            cs1.id as ClientServiceID,
            cs1.Client as ClientID,
            cs3.Status as PBIStatus
        FROM client_service cs1
        INNER JOIN client c
            ON cs1.Client = c.id
        INNER JOIN client_service cs3
            ON cs1.Client = cs3.Client
            AND cs3.Service = 3
            AND cs3.Status NOT IN (0, 2, 13)
        WHERE cs1.Service = 62
            AND cs1.id = 7102
        GROUP BY cs1.Status, cs3.Details
        """

        cursor.execute(query2)
        result2 = cursor.fetchone()

        if result2:
            print("✅ Record found!")
            print(f"   Status (cs1.Status): {result2['Status']}")
            print(f"   ClientServiceID: {result2['ClientServiceID']}")
            print(f"   ClientID: {result2['ClientID']}")
            print(f"   PBI Status: {result2['PBIStatus']}")
        else:
            print("❌ No record found")

        # Test 3: Check if there's a PBI service (Service=3) for this client
        print("\n" + "=" * 80)
        print("TEST 3: Check PBI Service (Service=3) for Client")
        print("=" * 80)

        if result1:
            client_id = result1['Client']
            query3 = """
            SELECT
                id,
                Client,
                Service,
                Status
            FROM client_service
            WHERE Client = %s
                AND Service = 3
                AND Status NOT IN (0, 2, 13)
            """

            cursor.execute(query3, (client_id,))
            pbi_result = cursor.fetchone()

            if pbi_result:
                print("✅ PBI Service found!")
                print(f"   ID: {pbi_result['id']}")
                print(f"   Status: {pbi_result['Status']}")
            else:
                print("❌ No active PBI service found!")
                print("   This might be why the query fails - INNER JOIN on PBI service fails")

        # Test 4: All TidyWork services
        print("\n" + "=" * 80)
        print("TEST 4: All TidyWork (Service=62) records")
        print("=" * 80)

        query4 = """
        SELECT
            cs.id,
            cs.Client,
            cs.Status,
            c.name AS ClientName
        FROM client_service cs
        INNER JOIN client c ON cs.Client = c.id
        WHERE cs.Service = 62
        ORDER BY cs.id DESC
        LIMIT 5
        """

        cursor.execute(query4)
        all_results = cursor.fetchall()

        if all_results:
            print(f"Found {len(all_results)} TidyWork service records:")
            for row in all_results:
                print(f"   ID: {row['id']:4d} | Client: {row['Client']:4d} | Status: {row['Status']:2d} | Name: {row['ClientName']}")
        else:
            print("No TidyWork service records found")

    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    if result1:
        print(f"✅ Direct query found client_service.id=7102 with Status={result1['Status']}")
    if result2:
        print(f"   Full query (with joins) returned Status={result2['Status']}")
        if result1 and result1['Status'] != result2['Status']:
            print(f"   ⚠️  STATUS MISMATCH! Direct={result1['Status']}, With Joins={result2['Status']}")

    connection.close()

except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
