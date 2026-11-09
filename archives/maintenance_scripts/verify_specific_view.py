import mysql.connector
import config

# Azure MySQL connection details
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'connection_timeout': 30,
    'ssl_disabled': False
}

print(f"Connecting to Azure MySQL: {connection_config['host']}")
print(f"Database: {connection_config['database']}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # Check the specific view the user mentioned
    view_name = 'SWAU_CLIENT1668_XEROBLUE_transactionsblend_AUD'

    print(f"Checking view: {view_name}")
    print("=" * 100)
    print()

    query = f"""
    SELECT TABLE_NAME, VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME = '{view_name}'
    """

    cursor.execute(query)
    result = cursor.fetchone()

    if result:
        table_name, view_def = result
        print(f"✓ View found: {table_name}")
        print()

        # Check for ROW_NUMBER patterns (with or without space)
        has_row_number = 'ROW_NUMBER()' in view_def or 'ROW_NUMBER ()' in view_def
        has_journal_number = '`JournalNumber` AS `Index`' in view_def or 'JournalNumber AS `Index`' in view_def

        print("Analysis:")
        print("-" * 100)
        if has_row_number:
            print("❌ Uses ROW_NUMBER() pattern")
        else:
            print("✓ Does NOT use ROW_NUMBER()")

        if has_journal_number:
            print("✓ Uses JournalNumber AS Index")
        else:
            print("❌ Does NOT use JournalNumber AS Index")

        print()
        print("View Definition (first 2000 characters):")
        print("-" * 100)
        print(view_def[:2000])

        if len(view_def) > 2000:
            print("\n... (view definition truncated)")

    else:
        print(f"❌ View '{view_name}' not found!")
        print()
        print("Trying case-insensitive search...")

        query = f"""
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.VIEWS
        WHERE TABLE_SCHEMA = 'evadb'
        AND LOWER(TABLE_NAME) = LOWER('{view_name}')
        """

        cursor.execute(query)
        results = cursor.fetchall()

        if results:
            print(f"Found {len(results)} view(s) with similar name:")
            for (name,) in results:
                print(f"  - {name}")
        else:
            print("No views found with similar name")

    # Now let's also check with a broader ROW_NUMBER search
    print()
    print()
    print("=" * 100)
    print("Checking for ALL patterns of ROW_NUMBER in xeroblue_transactionsblend_aud views...")
    print()

    query = """
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME LIKE '%xeroblue_transactionsblend_aud%'
    AND (VIEW_DEFINITION LIKE '%ROW_NUMBER()%'
         OR VIEW_DEFINITION LIKE '%ROW_NUMBER ()%'
         OR VIEW_DEFINITION LIKE '%row_number()%'
         OR VIEW_DEFINITION LIKE '%row_number ()%')
    LIMIT 20
    """

    cursor.execute(query)
    results = cursor.fetchall()

    if results:
        print(f"Found {len(results)} _aud views using ROW_NUMBER:")
        for i, (name,) in enumerate(results, 1):
            print(f"{i}. {name}")
    else:
        print("No _aud views found using ROW_NUMBER()")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
