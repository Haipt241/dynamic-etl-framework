import mysql.connector
import config
import re
from datetime import datetime

# Azure MySQL connection details
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'connection_timeout': 30,
    'ssl_disabled': False
}

# Specific views to update
VIEWS_TO_UPDATE = [
    'SWAU_CLIENT1668_XEROBLUE_transactionsblend_AUD',
    'SWAU_CLIENT1913_XEROBLUE_transactionsblend_AUD',
    'SWAU_CLIENT1877_XEROBLUE_transactionsblend_AUD'
]

print("=" * 100)
print("UPDATE SWAU TRANSACTIONSBLEND VIEWS")
print("=" * 100)
print(f"Views to update: {len(VIEWS_TO_UPDATE)}")
print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # Track progress
    total_views = len(VIEWS_TO_UPDATE)
    updated_count = 0
    skipped_count = 0
    failed_count = 0
    updated_views = []
    skipped_views = []
    failed_views = []

    # Check for active processes
    print(f"Checking for active processes...")
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
            matches = re.findall(r'(\w+_client\d+_xeroblue_transactionsblend\w*)', query_text.lower())
            views_in_use.update(matches)

    print(f"Found {len(views_in_use)} views currently in use")
    print()

    # Process each view
    for idx, view_name in enumerate(VIEWS_TO_UPDATE, 1):
        print(f"[{idx}/{total_views}] Processing: {view_name}...", end=" ")

        # Skip if in use
        if view_name.lower() in views_in_use:
            print("SKIPPED (in use)")
            skipped_count += 1
            skipped_views.append(view_name)
            continue

        try:
            # Get current view definition
            query = f"""
            SELECT VIEW_DEFINITION
            FROM INFORMATION_SCHEMA.VIEWS
            WHERE TABLE_SCHEMA = 'evadb'
            AND TABLE_NAME = '{view_name}'
            """

            cursor.execute(query)
            result = cursor.fetchone()

            if not result:
                print("FAILED (not found)")
                failed_count += 1
                failed_views.append((view_name, "View not found"))
                continue

            old_view_def = result[0]

            # Replace row_number() with JournalNumber AS Index
            new_view_def = re.sub(
                r'row_number\(\)\s+over\s*\(\s*order\s+by\s+`tb`\.`JournalDate`\s*\)\s+as\s+`Index`',
                "`tb`.`JournalNumber` AS `Index`",
                old_view_def,
                flags=re.IGNORECASE
            )

            # Verify the change
            if '`JournalNumber` AS `Index`' not in new_view_def and 'JournalNumber AS `Index`' not in new_view_def:
                print("FAILED (pattern not found)")
                failed_count += 1
                failed_views.append((view_name, "Pattern not found in definition"))
                continue

            # Execute CREATE OR REPLACE VIEW
            create_view_sql = f"CREATE OR REPLACE VIEW {view_name} AS {new_view_def}"
            cursor.execute(create_view_sql)
            conn.commit()

            print("SUCCESS")
            updated_count += 1
            updated_views.append(view_name)

        except Exception as e:
            print(f"FAILED ({str(e)[:50]})")
            failed_count += 1
            failed_views.append((view_name, str(e)))
            conn.rollback()

    # Final Summary
    print()
    print("=" * 100)
    print("FINAL SUMMARY")
    print("=" * 100)
    print(f"Total views processed: {total_views}")
    print(f"Successfully updated: {updated_count}")
    print(f"Skipped (in use): {skipped_count}")
    print(f"Failed: {failed_count}")
    print()
    print(f"Completion rate: {(updated_count / total_views * 100):.1f}%")
    print(f"Finished at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()

    # Save detailed results
    with open('swau_update_results.txt', 'w') as f:
        f.write("SWAU TRANSACTIONSBLEND VIEWS UPDATE RESULTS\n")
        f.write("=" * 100 + "\n\n")
        f.write(f"Finished at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write(f"Total views: {total_views}\n")
        f.write(f"Successfully updated: {updated_count}\n")
        f.write(f"Skipped (in use): {skipped_count}\n")
        f.write(f"Failed: {failed_count}\n\n")

        if updated_views:
            f.write("\n" + "=" * 100 + "\n")
            f.write(f"SUCCESSFULLY UPDATED VIEWS ({len(updated_views)}):\n")
            f.write("-" * 100 + "\n")
            for view in updated_views:
                f.write(f"{view}\n")

        if skipped_views:
            f.write("\n" + "=" * 100 + "\n")
            f.write(f"SKIPPED VIEWS (IN USE) ({len(skipped_views)}):\n")
            f.write("-" * 100 + "\n")
            for view in skipped_views:
                f.write(f"{view}\n")

        if failed_views:
            f.write("\n" + "=" * 100 + "\n")
            f.write(f"FAILED VIEWS ({len(failed_views)}):\n")
            f.write("-" * 100 + "\n")
            for view, error in failed_views:
                f.write(f"{view}: {error}\n")

    print("💾 Detailed results saved to: swau_update_results.txt")
    print()

    if skipped_count > 0:
        print(f"⚠️  {skipped_count} views were skipped because they were in use.")
        print("   You can re-run this script later to update them when they're free.")

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
