"""
Direct AWS RDS CMS Query Test
Tests the vibedb_cms database on AWS RDS Aurora
"""
import pymysql
import boto3
from botocore.exceptions import ClientError
import json
import config

print("=" * 80)
print("AWS RDS CMS DATABASE TEST")
print("=" * 80)

# Get AWS RDS credentials from Secrets Manager
def get_rds_credentials():
    """Get RDS credentials from AWS Secrets Manager"""
    secret_name = config.AWS_RDS_SECRET_NAME
    region_name = config.AWS_RDS_REGION

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = get_secret_value_response['SecretString']
        credentials = json.loads(secret)
        return credentials
    except ClientError as e:
        print(f"Error retrieving secret: {e}")
        return None

print("Getting RDS credentials from Secrets Manager...")
credentials = get_rds_credentials()

if not credentials:
    print("❌ Failed to get credentials")
    exit(1)

print(f"✅ Got credentials for user: {credentials.get('username')}")
print(f"Host: {config.AWS_RDS_HOST}")
print(f"Region: {config.AWS_RDS_REGION}")
print("")

try:
    # Connect to AWS RDS Aurora
    connection = pymysql.connect(
        host=config.AWS_RDS_HOST,
        user=credentials['username'],
        password=credentials['password'],
        database='vibedb_cms',  # AWS CMS database
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=10
    )

    print("✅ Connected to AWS RDS Aurora!\n")

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
            print(f"   Status: {result1['Status']} ⭐⭐⭐")
            details_str = str(result1['Details'])[:200] if result1['Details'] else 'None'
            print(f"   Details: {details_str}...")
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
            cs3.Status as PBIStatus,
            cs3.id as PBIServiceID
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
            print(f"   Status (cs1.Status): {result2['Status']} ⭐⭐⭐")
            print(f"   ClientServiceID: {result2['ClientServiceID']}")
            print(f"   ClientID: {result2['ClientID']}")
            print(f"   PBI Service ID: {result2['PBIServiceID']}")
            print(f"   PBI Status: {result2['PBIStatus']}")
        else:
            print("❌ No record found - INNER JOIN may be failing!")
            print("   Checking if PBI service exists...")

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
            ORDER BY Status
            """

            cursor.execute(query3, (client_id,))
            pbi_results = cursor.fetchall()

            if pbi_results:
                print(f"✅ Found {len(pbi_results)} PBI service records:")
                for pbi in pbi_results:
                    status_ok = "✅" if pbi['Status'] not in [0, 2, 13] else "❌"
                    print(f"   {status_ok} ID: {pbi['id']} | Status: {pbi['Status']}")
            else:
                print("❌ No PBI service found for this client!")
                print("   This is why the INNER JOIN fails - no matching PBI record")

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
                status_marker = "🟢" if row['Status'] == 12 else "🔴" if row['Status'] == 1 else "⚪"
                print(f"   {status_marker} ID: {row['id']:4d} | Client: {row['Client']:4d} | Status: {row['Status']:2d} | Name: {row['ClientName']}")
        else:
            print("No TidyWork service records found")

    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    if result1:
        print(f"✅ Direct query found client_service.id=7102 with Status={result1['Status']}")
    if result2:
        print(f"✅ Full query (with joins) returned Status={result2['Status']}")
        if result1 and result1['Status'] != result2['Status']:
            print(f"   ⚠️  STATUS MISMATCH! Direct={result1['Status']}, With Joins={result2['Status']}")
    elif result1 and not result2:
        print(f"❌ Direct query works but full query fails - issue with INNER JOIN on PBI service")

    connection.close()

except pymysql.err.OperationalError as e:
    if e.args[0] == 1049:
        print(f"❌ Database 'vibedb_cms' does not exist on AWS RDS")
        print(f"   Available databases might be: vibedb_DOUGLASINNOVATIONS, vibedb_BIGOLESHOECOMPANY, etc.")
        print(f"   The CMS database might be in a different database on AWS")
    else:
        print(f"❌ Connection Error: {e}")
        import traceback
        traceback.print_exc()
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
