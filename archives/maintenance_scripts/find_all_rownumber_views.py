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

    # Search for ALL xeroblue_transactionsblend views with row_number (case-insensitive)
    print("Searching for ALL xeroblue_transactionsblend views using row_number() (case-insensitive)...")
    print("This will take a moment...")
    print()

    query = """
    SELECT TABLE_NAME,
           CASE
               WHEN LOWER(VIEW_DEFINITION) LIKE '%row_number()%' OR LOWER(VIEW_DEFINITION) LIKE '%row_number ()%'
               THEN 'Uses row_number()'
               ELSE 'Unknown'
           END AS status
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME LIKE '%xeroblue_transactionsblend%'
    AND (LOWER(VIEW_DEFINITION) LIKE '%row_number()%' OR LOWER(VIEW_DEFINITION) LIKE '%row_number ()%')
    ORDER BY TABLE_NAME
    """

    cursor.execute(query)
    results = cursor.fetchall()

    print(f"Found {len(results)} xeroblue_transactionsblend views using row_number()")
    print("=" * 100)
    print()

    # Save all results to file
    with open('views_with_rownumber_FULL_LIST.txt', 'w') as f:
        f.write("XEROBLUE TRANSACTIONSBLEND VIEWS USING row_number()\n")
        f.write("=" * 100 + "\n\n")
        f.write(f"Total: {len(results)} views\n\n")
        for view_name, status in results:
            f.write(f"{view_name}\n")

    # Display first 100
    print("First 100 views:")
    print("-" * 100)
    for i, (view_name, status) in enumerate(results[:100], 1):
        print(f"{i}. {view_name}")

    if len(results) > 100:
        print(f"\n... and {len(results) - 100} more views")

    print()
    print(f"💾 Full list saved to: views_with_rownumber_FULL_LIST.txt")

    # Categorize by view type
    print()
    print("=" * 100)
    print("BREAKDOWN BY VIEW TYPE:")
    print("-" * 100)

    view_types = {
        'base': [],
        'cash': [],
        'aud': [],
        'usd': [],
        'eur': [],
        'gbp': [],
        'nzd': [],
        'cash_fx': []
    }

    for view_name, _ in results:
        view_lower = view_name.lower()
        if '_aud' in view_lower:
            view_types['aud'].append(view_name)
        elif '_usd' in view_lower:
            view_types['usd'].append(view_name)
        elif '_eur' in view_lower:
            view_types['eur'].append(view_name)
        elif '_gbp' in view_lower:
            view_types['gbp'].append(view_name)
        elif '_nzd' in view_lower:
            view_types['nzd'].append(view_name)
        elif 'transactionsblendcash' in view_lower and any(fx in view_lower for fx in ['_aud', '_usd', '_eur', '_gbp', '_nzd']):
            view_types['cash_fx'].append(view_name)
        elif 'transactionsblendcash' in view_lower:
            view_types['cash'].append(view_name)
        else:
            view_types['base'].append(view_name)

    for vtype, views in view_types.items():
        if views:
            print(f"{vtype.upper()}: {len(views)} views")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
