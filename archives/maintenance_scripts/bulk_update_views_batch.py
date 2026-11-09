import mysql.connector
import config
import re
import time
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

BATCH_SIZE = 50

print("=" * 100)
print("BULK UPDATE VIEWS IN BATCHES")
print("=" * 100)
print(f"Batch size: {BATCH_SIZE} views")
print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # STEP 1: Load all views from file
    print("STEP 1: Loading views from saved list...")
    print("-" * 100)

    all_views = []
    with open('views_with_rownumber_FULL_LIST.txt', 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('XEROBLUE') and not line.startswith('====') and not line.startswith('Total'):
                all_views.append(line)

    print(f"Loaded {len(all_views)} views to update")
    print()

    # Track progress
    total_views = len(all_views)
    updated_count = 0
    skipped_count = 0
    failed_count = 0
    updated_views = []
    skipped_views = []
    failed_views = []

    # Process in batches
    batch_num = 1

    for batch_start in range(0, total_views, BATCH_SIZE):
        batch_end = min(batch_start + BATCH_SIZE, total_views)
        batch_views = all_views[batch_start:batch_end]

        print()
        print("=" * 100)
        print(f"BATCH {batch_num}: Processing views {batch_start + 1} to {batch_end} of {total_views}")
        print("=" * 100)
        print()

        # Check which views are currently in use
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

        # Process each view in the batch
        for idx, view_name in enumerate(batch_views, 1):
            print(f"[{batch_start + idx}/{total_views}] Processing: {view_name}...", end=" ")

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

        # Batch summary
        print()
        print(f"Batch {batch_num} completed!")
        print(f"  Updated: {updated_count}")
        print(f"  Skipped: {skipped_count}")
        print(f"  Failed: {failed_count}")
        print()

        batch_num += 1

        # Small delay between batches
        if batch_end < total_views:
            print("Waiting 2 seconds before next batch...")
            time.sleep(2)

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
    with open('bulk_update_results.txt', 'w') as f:
        f.write("BULK UPDATE RESULTS\n")
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

    print("💾 Detailed results saved to: bulk_update_results.txt")
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
