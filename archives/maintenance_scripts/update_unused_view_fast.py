import mysql.connector
import config
import re

# Azure MySQL connection details
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'connection_timeout': 30,
    'ssl_disabled': False
}

print("=" * 100)
print("UPDATING UNUSED TRANSACTIONSBLEND_AUD VIEW (FAST VERSION)")
print("=" * 100)
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # STEP 1: Load views from file
    print("STEP 1: Loading views from saved list...")
    print("-" * 100)

    all_views = []
    with open('views_with_rownumber_FULL_LIST.txt', 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('XEROBLUE') and not line.startswith('====') and not line.startswith('Total'):
                all_views.append(line)

    # Filter for _aud views only
    all_aud_views = [v for v in all_views if '_aud' in v.lower()]

    print(f"Loaded {len(all_views)} total views")
    print(f"Filtered to {len(all_aud_views)} transactionsblend_aud views")
    print()

    # STEP 2: Get views currently in processlist
    print("STEP 2: Getting views currently in use from processlist...")
    print("-" * 100)

    query = """
    SELECT INFO
    FROM information_schema.processlist
    WHERE INFO IS NOT NULL
    AND USER != 'etaniadmin'
    AND LOWER(INFO) LIKE '%transactionsblend%'
    """

    cursor.execute(query)
    active_queries = cursor.fetchall()

    # Extract view names from queries
    views_in_use = set()
    for (query_text,) in active_queries:
        if query_text:
            # Extract view names using regex
            matches = re.findall(r'(\w+_client\d+_xeroblue_transactionsblend\w*)', query_text.lower())
            views_in_use.update(matches)

    print(f"Found {len(views_in_use)} views currently in use:")
    for view_name in sorted(views_in_use):
        print(f"  - {view_name}")
    print()

    # STEP 3: Find views NOT in use
    print("STEP 3: Finding transactionsblend_aud views NOT currently in use...")
    print("-" * 100)

    unused_views = [v for v in all_aud_views if v.lower() not in views_in_use]

    print(f"Found {len(unused_views)} transactionsblend_aud views NOT in use")
    print()

    if not unused_views:
        print("❌ No unused transactionsblend_aud views found! All are currently being queried.")
        exit(1)

    # Pick the first unused view
    test_view = unused_views[0]
    print(f"Selected view for test update: {test_view}")
    print()

    # STEP 4: Get current view definition
    print("STEP 4: Getting current view definition...")
    print("-" * 100)

    query = f"""
    SELECT VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME = '{test_view}'
    """

    cursor.execute(query)
    result = cursor.fetchone()

    if not result:
        print(f"❌ View '{test_view}' not found!")
        exit(1)

    old_view_def = result[0]
    print(f"Current view uses row_number(): {'✓ Yes' if 'row_number()' in old_view_def.lower() else '✗ No'}")
    print()

    # STEP 5: Create updated view definition
    print("STEP 5: Creating updated view definition...")
    print("-" * 100)

    # Replace row_number() with JournalNumber AS Index
    new_view_def = re.sub(
        r'row_number\(\)\s+over\s*\(\s*order\s+by\s+`tb`\.`JournalDate`\s*\)\s+as\s+`Index`',
        "`tb`.`JournalNumber` AS `Index`",
        old_view_def,
        flags=re.IGNORECASE
    )

    # Verify the change was made
    if '`JournalNumber` AS `Index`' in new_view_def or 'JournalNumber AS `Index`' in new_view_def:
        print("✓ View definition updated successfully (in memory)")
    else:
        print("❌ Failed to update view definition")
        exit(1)

    print()

    # STEP 6: Execute CREATE OR REPLACE VIEW
    print("STEP 6: Executing CREATE OR REPLACE VIEW...")
    print("-" * 100)
    print(f"Updating view: {test_view}")
    print()

    create_view_sql = f"CREATE OR REPLACE VIEW {test_view} AS {new_view_def}"

    try:
        cursor.execute(create_view_sql)
        conn.commit()
        print(f"✓ Successfully updated view: {test_view}")
    except Exception as e:
        print(f"❌ Failed to update view: {e}")
        conn.rollback()
        exit(1)

    print()

    # STEP 7: Verify the update
    print("STEP 7: Verifying the update...")
    print("-" * 100)

    query = f"""
    SELECT VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME = '{test_view}'
    """

    cursor.execute(query)
    result = cursor.fetchone()

    if result:
        updated_view_def = result[0]

        has_journal_number = '`JournalNumber` AS `Index`' in updated_view_def or 'JournalNumber AS `Index`' in updated_view_def
        has_row_number = 'row_number()' in updated_view_def.lower()

        print("Verification results:")
        if has_journal_number and not has_row_number:
            print("  ✓ View now uses JournalNumber AS Index")
            print("  ✓ View no longer uses row_number()")
            print()
            print("=" * 100)
            print("SUCCESS! Test view updated successfully!")
            print("=" * 100)
            print()
            print(f"Updated view: {test_view}")
            print(f"Remaining unused _aud views to update: {len(unused_views) - 1}")
            print(f"Total unused views (all types): {len([v for v in all_views if v.lower() not in views_in_use]) - 1}")
            print()

            # Save list of unused views
            with open('unused_transactionsblend_aud_views.txt', 'w') as f:
                f.write(f"UNUSED TRANSACTIONSBLEND_AUD VIEWS (Not in processlist)\n")
                f.write("=" * 100 + "\n\n")
                f.write(f"Total: {len(unused_views)} views\n")
                f.write(f"Test view updated: {test_view}\n")
                f.write(f"Remaining: {len(unused_views) - 1} views\n\n")
                f.write("List of remaining unused _aud views:\n")
                f.write("-" * 100 + "\n")
                for i, view in enumerate(unused_views[1:], 1):
                    f.write(f"{i}. {view}\n")

            print(f"💾 List of remaining unused _aud views saved to: unused_transactionsblend_aud_views.txt")
        else:
            print("  ❌ Update verification failed")
            if has_row_number:
                print("  ❌ View still uses row_number()")
            if not has_journal_number:
                print("  ❌ View doesn't use JournalNumber AS Index")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
    import traceback
    traceback.print_exc()
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
