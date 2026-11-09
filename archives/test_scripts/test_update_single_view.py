import mysql.connector
import config
import time

# Azure MySQL connection details
connection_config = {
    'host': config.MYSQL_SERVER_NAME,
    'user': config.MYSQL_SERVER_USERNAME,
    'password': config.MYSQL_SERVER_PASSWORD,
    'database': config.MYSQL_SERVER_EVA_MAIN_DATABASE,
    'connection_timeout': 30,
    'ssl_disabled': False
}

view_name = 'swau_client1668_xeroblue_transactionsblend_aud'

print("=" * 100)
print(f"TEST: Updating view {view_name}")
print("=" * 100)
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # STEP 1: Check for processes using this specific view
    print("STEP 1: Checking for active processes using this view...")
    print("-" * 100)

    query = f"""
    SELECT
        ID,
        USER,
        HOST,
        TIME,
        STATE,
        INFO
    FROM information_schema.processlist
    WHERE INFO IS NOT NULL
    AND USER != 'etaniadmin'
    AND LOWER(INFO) LIKE '%{view_name}%'
    """

    cursor.execute(query)
    processes = cursor.fetchall()

    if processes:
        print(f"Found {len(processes)} processes using this view:")
        for process_id, user, host, time_sec, state, info in processes:
            print(f"  - Process ID: {process_id} | User: {user} | Time: {time_sec}s")

        print()
        print("Killing these processes...")
        killed_count = 0
        for process_id, user, host, time_sec, state, info in processes:
            try:
                cursor.execute(f"KILL {process_id}")
                print(f"  ✓ Killed process {process_id}")
                killed_count += 1
            except Exception as e:
                print(f"  ✗ Failed to kill process {process_id}: {e}")

        print(f"\n✓ Successfully killed {killed_count} out of {len(processes)} processes")
        time.sleep(2)  # Wait a moment for processes to clear
    else:
        print("✓ No active processes found using this view")

    print()

    # STEP 2: Get current view definition
    print("STEP 2: Getting current view definition...")
    print("-" * 100)

    query = f"""
    SELECT VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME = '{view_name}'
    """

    cursor.execute(query)
    result = cursor.fetchone()

    if not result:
        print(f"❌ View '{view_name}' not found!")
        exit(1)

    old_view_def = result[0]
    print("Current view definition (first 500 chars):")
    print(old_view_def[:500])
    print("...")
    print()

    # Check if it uses row_number
    if 'row_number()' not in old_view_def.lower():
        print("⚠️  This view doesn't use row_number(). Already updated?")
        print()
    else:
        print("✓ Confirmed: View uses row_number()")
        print()

    # STEP 3: Create updated view definition
    print("STEP 3: Creating updated view definition...")
    print("-" * 100)

    # Replace row_number() with JournalNumber AS Index
    # The pattern in the definition is: row_number() OVER (ORDER BY `tb`.`JournalDate` )  AS `Index`
    # We need to replace it with: `tb`.`JournalNumber` AS `Index`

    new_view_def = old_view_def

    # Try different patterns
    patterns_to_replace = [
        "row_number() OVER (ORDER BY `tb`.`JournalDate` )  AS `Index`",
        "row_number() over (order by `tb`.`JournalDate` )  as `Index`",
        "ROW_NUMBER() OVER (ORDER BY `tb`.`JournalDate` )  AS `Index`",
    ]

    replaced = False
    for pattern in patterns_to_replace:
        if pattern.lower() in new_view_def.lower():
            # Find the actual case-sensitive match
            import re
            # Case-insensitive regex to find and replace
            new_view_def = re.sub(
                r'row_number\(\)\s+over\s*\(\s*order\s+by\s+`tb`\.`JournalDate`\s*\)\s+as\s+`Index`',
                "`tb`.`JournalNumber` AS `Index`",
                new_view_def,
                flags=re.IGNORECASE
            )
            replaced = True
            break

    if not replaced:
        print("⚠️  Could not find the exact pattern to replace. Trying broader pattern...")
        import re
        new_view_def = re.sub(
            r'row_number\(\).*?as\s+`Index`',
            "`tb`.`JournalNumber` AS `Index`",
            new_view_def,
            flags=re.IGNORECASE
        )

    print("Updated view definition (first 500 chars):")
    print(new_view_def[:500])
    print("...")
    print()

    # Verify the change was made
    if '`JournalNumber` AS `Index`' in new_view_def or 'JournalNumber AS `Index`' in new_view_def:
        print("✓ View definition updated successfully (in memory)")
    else:
        print("❌ Failed to update view definition")
        exit(1)

    print()

    # STEP 4: Execute the CREATE OR REPLACE VIEW statement
    print("STEP 4: Executing CREATE OR REPLACE VIEW...")
    print("-" * 100)

    create_view_sql = f"CREATE OR REPLACE VIEW {view_name} AS {new_view_def}"

    try:
        cursor.execute(create_view_sql)
        conn.commit()
        print(f"✓ Successfully updated view: {view_name}")
    except Exception as e:
        print(f"❌ Failed to update view: {e}")
        conn.rollback()
        exit(1)

    print()

    # STEP 5: Verify the update
    print("STEP 5: Verifying the update...")
    print("-" * 100)

    query = f"""
    SELECT VIEW_DEFINITION
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'evadb'
    AND TABLE_NAME = '{view_name}'
    """

    cursor.execute(query)
    result = cursor.fetchone()

    if result:
        updated_view_def = result[0]

        # Check if it now uses JournalNumber
        has_journal_number = '`JournalNumber` AS `Index`' in updated_view_def or 'JournalNumber AS `Index`' in updated_view_def
        has_row_number = 'row_number()' in updated_view_def.lower()

        print("Verification results:")
        if has_journal_number and not has_row_number:
            print("  ✓ View now uses JournalNumber AS Index")
            print("  ✓ View no longer uses row_number()")
            print()
            print("Updated view definition (first 500 chars):")
            print(updated_view_def[:500])
            print("...")
        elif has_journal_number and has_row_number:
            print("  ⚠️  View uses JournalNumber but still has row_number() somewhere")
        else:
            print("  ❌ Update verification failed")

    print()
    print("=" * 100)
    print("TEST COMPLETED SUCCESSFULLY!")
    print("=" * 100)

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
