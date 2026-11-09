"""
Test CMS Query - Direct query to verify Status value
"""
import os
import sys

# Set required environment variables BEFORE importing sql_helper
os.environ['EtaniClientID'] = 'DOUGLASINNOVATIONS_CLIENT2022'
os.environ['EtaniOrganisationID'] = '7102'
os.environ['DB_Destination'] = 'DW'
os.environ['USE_AWS_DB'] = 'True'

from sql_helper import ReadMySQLTable

error_list = []

# Test 1: Direct query - no joins, just get the status
print("=" * 80)
print("TEST 1: Direct query to client_service table (id=7102)")
print("=" * 80)

query1 = """
SELECT
    id,
    Client,
    Service,
    Status,
    Details
FROM vibedb_cms.client_service
WHERE id = 7102
"""

print(f"Query:\n{query1}")
df1 = ReadMySQLTable(query1, 'ETANI', 'DOUGLASINNOVATIONS_CLIENT2022', '7102', error_list, IsCMS=True)
print(f"\nResult:")
print(df1)
print(f"\nStatus value: {df1['Status'].iloc[0] if not df1.empty else 'NO RESULTS'}")

# Test 2: Query with client join only
print("\n" + "=" * 80)
print("TEST 2: Query with client table join")
print("=" * 80)

query2 = """
SELECT
    cs1.id,
    cs1.Client,
    cs1.Service,
    cs1.Status,
    c.name AS ClientName
FROM vibedb_cms.client_service cs1
INNER JOIN vibedb_cms.client c ON cs1.Client = c.id
WHERE cs1.id = 7102
"""

print(f"Query:\n{query2}")
df2 = ReadMySQLTable(query2, 'ETANI', 'DOUGLASINNOVATIONS_CLIENT2022', '7102', error_list, IsCMS=True)
print(f"\nResult:")
print(df2)
print(f"\nStatus value: {df2['Status'].iloc[0] if not df2.empty else 'NO RESULTS'}")

# Test 3: Full query with all joins (current query)
print("\n" + "=" * 80)
print("TEST 3: Full query with PBI service join and GROUP BY")
print("=" * 80)

query3 = """
SELECT
    cs1.Status,
    cs1.id as ClientServiceID,
    cs1.Client as ClientID,
    cs3.Status as PBIStatus,
    cs3.id as PBIServiceID,
    COUNT(cs2.id) AS OtherRefreshes
FROM vibedb_cms.client_service cs1
INNER JOIN vibedb_cms.client c
    ON cs1.Client = c.id
INNER JOIN vibedb_cms.client_service cs3
    ON cs1.Client = cs3.Client
    AND cs3.Service = 3
    AND cs3.Status NOT IN (0, 2, 13)
LEFT JOIN vibedb_cms.client_service cs2
    ON cs1.Client = cs2.Client
    AND cs1.Service = cs2.Service
    AND cs1.id <> cs2.id
    AND cs2.Status = 12
WHERE cs1.Service = 62
    AND cs1.id = 7102
GROUP BY cs1.Status, cs1.id, cs1.Client, cs3.Status, cs3.id
"""

print(f"Query:\n{query3}")
df3 = ReadMySQLTable(query3, 'ETANI', 'DOUGLASINNOVATIONS_CLIENT2022', '7102', error_list, IsCMS=True)
print(f"\nResult:")
print(df3)
print(f"\nStatus value: {df3['Status'].iloc[0] if not df3.empty else 'NO RESULTS'}")
print(f"Number of rows returned: {len(df3)}")

# Test 4: Check all TidyWork services for this client
print("\n" + "=" * 80)
print("TEST 4: All TidyWork (Service=62) records")
print("=" * 80)

query4 = """
SELECT
    cs.id,
    cs.Client,
    cs.Service,
    cs.Status,
    c.name AS ClientName
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.client c ON cs.Client = c.id
WHERE cs.Service = 62
ORDER BY cs.id DESC
LIMIT 10
"""

print(f"Query:\n{query4}")
df4 = ReadMySQLTable(query4, 'ETANI', 'DOUGLASINNOVATIONS_CLIENT2022', '7102', error_list, IsCMS=True)
print(f"\nResult:")
print(df4)

print("\n" + "=" * 80)
print("SUMMARY")
print("=" * 80)
if not df1.empty:
    print(f"Direct query Status: {df1['Status'].iloc[0]}")
if not df2.empty:
    print(f"With client join Status: {df2['Status'].iloc[0]}")
if not df3.empty:
    print(f"Full query Status: {df3['Status'].iloc[0]}")

if error_list:
    print(f"\nErrors encountered: {error_list}")
