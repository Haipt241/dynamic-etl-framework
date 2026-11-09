import mysql.connector
import config

# Azure MySQL connection details with relaxed SSL
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'connection_timeout': 30,
    'ssl_disabled': False  # Use SSL but don't verify
}

print(f"Connecting to Azure MySQL: {connection_config['host']}")
print(f"Database: {connection_config['database']}")
print("This may take a moment...")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # Query to get count of all views first
    print("Getting count of views...")
    cursor.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = 'evadb'")
    total_views = cursor.fetchone()[0]
    print(f"Total views in evadb: {total_views}")
    print()

    # Query to get just view names containing xeroblue_transactionsblend
    print("Querying for xeroblue_transactionsblend views...")
    query = """
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME LIKE '%xeroblue_transactionsblend%'
    ORDER BY TABLE_NAME;
    """

    cursor.execute(query)
    transactionsblend_views = cursor.fetchall()

    print(f"Found {len(transactionsblend_views)} xeroblue_transactionsblend views:")
    print("=" * 100)
    for i, (view_name,) in enumerate(transactionsblend_views, 1):
        print(f"{i}. {view_name}")

    print()
    print("=" * 100)
    print()

    # Now get the definitions for these specific views to check for ROW_NUMBER()
    print("Checking which views use ROW_NUMBER()...")
    print()

    views_with_rownumber = []
    for (view_name,) in transactionsblend_views:
        query = f"""
        SELECT VIEW_DEFINITION
        FROM INFORMATION_SCHEMA.VIEWS
        WHERE TABLE_SCHEMA = 'evadb'
        AND TABLE_NAME = '{view_name}'
        """
        cursor.execute(query)
        result = cursor.fetchone()

        if result:
            view_def = result[0]
            if 'ROW_NUMBER()' in view_def:
                has_journal_number_index = '`JournalNumber` AS `Index`' in view_def or 'JournalNumber AS `Index`' in view_def
                views_with_rownumber.append({
                    'name': view_name,
                    'has_rownumber': True,
                    'has_journalnumber_index': has_journal_number_index
                })

    print(f"\n📋 VIEWS USING ROW_NUMBER(): {len(views_with_rownumber)}")
    print("=" * 100)

    needs_update = []
    already_updated = []

    for view_info in views_with_rownumber:
        if view_info['has_journalnumber_index']:
            already_updated.append(view_info['name'])
            print(f"✓ {view_info['name']} - Already uses JournalNumber AS Index")
        else:
            needs_update.append(view_info['name'])
            print(f"✗ {view_info['name']} - Needs update (uses ROW_NUMBER)")

    print()
    print("=" * 100)
    print("\n📊 SUMMARY:")
    print(f"   Views needing update: {len(needs_update)}")
    print(f"   Views already updated: {len(already_updated)}")

    if needs_update:
        print("\n🔧 VIEWS TO UPDATE:")
        for view_name in needs_update:
            print(f"   - {view_name}")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
