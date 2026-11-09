import mysql.connector
import config
import pandas as pd

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

    # Query ALL xeroblue_transactionsblend views with ROW_NUMBER() at once
    print("Querying for all xeroblue_transactionsblend views using ROW_NUMBER()...")
    print("This may take a minute...")
    print()

    query = """
    SELECT
        TABLE_NAME,
        VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME LIKE '%xeroblue_transactionsblend%'
    AND VIEW_DEFINITION LIKE '%ROW_NUMBER()%'
    ORDER BY TABLE_NAME;
    """

    cursor.execute(query)
    results = cursor.fetchall()

    print(f"Found {len(results)} xeroblue_transactionsblend views using ROW_NUMBER()")
    print("=" * 100)
    print()

    # Analyze each view
    needs_update = []
    already_correct = []

    for table_name, view_def in results:
        # Check if already uses JournalNumber AS Index
        if '`JournalNumber` AS `Index`' in view_def or 'JournalNumber AS `Index`' in view_def:
            already_correct.append(table_name)
        else:
            needs_update.append(table_name)

    # Display summary
    print("📊 SUMMARY:")
    print("=" * 100)
    print(f"Total views with ROW_NUMBER(): {len(results)}")
    print(f"  - Already using JournalNumber AS Index: {len(already_correct)}")
    print(f"  - NEED UPDATE (still using old ROW_NUMBER pattern): {len(needs_update)}")
    print()

    if needs_update:
        print("🔧 VIEWS THAT NEED TO BE UPDATED:")
        print("=" * 100)
        for i, view_name in enumerate(needs_update[:50], 1):  # Show first 50
            print(f"{i}. {view_name}")

        if len(needs_update) > 50:
            print(f"... and {len(needs_update) - 50} more views")

        # Save full list to file
        with open('views_needing_update.txt', 'w') as f:
            f.write("XEROBLUE TRANSACTIONSBLEND VIEWS NEEDING UPDATE\n")
            f.write("=" * 100 + "\n\n")
            for view_name in needs_update:
                f.write(f"{view_name}\n")

        print()
        print(f"💾 Full list saved to: views_needing_update.txt")

    if already_correct:
        print()
        print(f"✓ {len(already_correct)} views already use JournalNumber AS Index (no update needed)")

    # Save detailed results to CSV
    df = pd.DataFrame(results, columns=['view_name', 'view_definition'])
    df['status'] = df['view_name'].apply(lambda x: 'Correct' if x in already_correct else 'Needs Update')
    df.to_csv('azure_transactionsblend_views_analysis.csv', index=False)
    print(f"\n💾 Detailed analysis saved to: azure_transactionsblend_views_analysis.csv")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
