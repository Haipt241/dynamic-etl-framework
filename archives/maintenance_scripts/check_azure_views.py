import mysql.connector
import config
import pandas as pd

# Azure MySQL connection details
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'ssl_ca': config.MYSQL_SERVER_SSL_CERT,
    'ssl_verify_cert': True,
    'ssl_verify_identity': True
}

print(f"Connecting to Azure MySQL: {connection_config['host']}")
print(f"Database: {connection_config['database']}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    # Query to get all views containing ROW_NUMBER() in evadb
    query = """
    SELECT
        TABLE_NAME,
        VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND VIEW_DEFINITION LIKE '%ROW_NUMBER()%'
    ORDER BY TABLE_NAME;
    """

    print("Querying for all views with ROW_NUMBER()...")
    cursor.execute(query)
    results = cursor.fetchall()

    print(f"\nFound {len(results)} views using ROW_NUMBER()\n")
    print("=" * 100)

    # Filter for xeroblue_transactionsblend views
    transactionsblend_views = []
    other_views = []

    for table_name, view_def in results:
        if 'xeroblue_transactionsblend' in table_name.lower():
            transactionsblend_views.append({
                'view_name': table_name,
                'definition': view_def
            })
        else:
            other_views.append({
                'view_name': table_name,
                'definition': view_def
            })

    # Display xeroblue_transactionsblend views
    print("\n📋 XEROBLUE TRANSACTIONSBLEND VIEWS USING ROW_NUMBER():")
    print("=" * 100)
    if transactionsblend_views:
        for i, view in enumerate(transactionsblend_views, 1):
            print(f"\n{i}. View: {view['view_name']}")
            # Check if it contains ROW_NUMBER() OVER (ORDER BY
            if 'ROW_NUMBER() OVER (ORDER BY' in view['definition']:
                print("   ✗ Uses OLD pattern: ROW_NUMBER() OVER (ORDER BY ...)")
            if '`JournalNumber` AS `Index`' in view['definition'] or 'JournalNumber AS `Index`' in view['definition']:
                print("   ✓ Already uses: JournalNumber AS Index")
    else:
        print("No xeroblue_transactionsblend views found with ROW_NUMBER()")

    # Display other views with ROW_NUMBER()
    if other_views:
        print("\n\n📋 OTHER VIEWS USING ROW_NUMBER():")
        print("=" * 100)
        for i, view in enumerate(other_views, 1):
            print(f"{i}. {view['view_name']}")

    # Summary
    print("\n" + "=" * 100)
    print("\n📊 SUMMARY:")
    print(f"   Total views with ROW_NUMBER(): {len(results)}")
    print(f"   - xeroblue_transactionsblend views: {len(transactionsblend_views)}")
    print(f"   - Other views: {len(other_views)}")

    # Save to CSV for detailed analysis
    if results:
        df = pd.DataFrame(results, columns=['view_name', 'view_definition'])
        output_file = 'azure_views_with_rownumber.csv'
        df.to_csv(output_file, index=False)
        print(f"\n💾 Detailed results saved to: {output_file}")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Error connecting to Azure MySQL: {err}")
except Exception as e:
    print(f"❌ Error: {e}")
