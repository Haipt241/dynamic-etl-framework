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
print(f"User: {config.MYSQL_SERVER_USERNAME}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # STEP 1: Check current privileges for etaniadmin
    print("=" * 100)
    print("STEP 1: Checking current privileges for etaniadmin user")
    print("=" * 100)
    print()

    query = f"SHOW GRANTS FOR '{config.MYSQL_SERVER_USERNAME}'@'%'"

    try:
        cursor.execute(query)
        grants = cursor.fetchall()

        print(f"Current privileges for {config.MYSQL_SERVER_USERNAME}:")
        print("-" * 100)
        for grant in grants:
            print(grant[0])

        print()

        # Check if SUPER or PROCESS privilege exists
        grants_text = ' '.join([str(grant[0]) for grant in grants])
        has_super = 'SUPER' in grants_text.upper()
        has_process = 'PROCESS' in grants_text.upper()
        has_all = 'ALL PRIVILEGES' in grants_text.upper()

        print("Privilege Analysis:")
        print("-" * 100)
        print(f"Has SUPER privilege: {'✓ Yes' if has_super else '✗ No'}")
        print(f"Has PROCESS privilege: {'✓ Yes' if has_process else '✗ No'}")
        print(f"Has ALL PRIVILEGES: {'✓ Yes' if has_all else '✗ No'}")

        print()

        if has_super or has_all:
            print("✓ User should be able to kill other users' processes")
        else:
            print("❌ User does NOT have permission to kill other users' processes")

    except Exception as e:
        print(f"Error checking grants: {e}")

    print()
    print()

    # STEP 2: Provide SQL commands to grant necessary privileges
    print("=" * 100)
    print("STEP 2: SQL Commands to Grant KILL Permissions")
    print("=" * 100)
    print()

    print("To grant the etaniadmin user permission to kill other users' processes,")
    print("you need to run these commands as a user with GRANT privileges (like root/admin):")
    print()
    print("-" * 100)
    print(f"-- Grant PROCESS privilege (to see all processes)")
    print(f"GRANT PROCESS ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';")
    print()
    print(f"-- Grant SUPER privilege (to kill other users' processes)")
    print(f"GRANT SUPER ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';")
    print()
    print("-- Flush privileges")
    print("FLUSH PRIVILEGES;")
    print("-" * 100)
    print()

    print("ALTERNATIVE (for MySQL 8.0+):")
    print("-" * 100)
    print(f"-- Grant CONNECTION_ADMIN privilege")
    print(f"GRANT CONNECTION_ADMIN ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';")
    print()
    print("-- Flush privileges")
    print("FLUSH PRIVILEGES;")
    print("-" * 100)
    print()

    # STEP 3: Try to grant the privileges (this will likely fail if we don't have grant privilege)
    print()
    print("=" * 100)
    print("STEP 3: Attempting to grant privileges (this may fail)")
    print("=" * 100)
    print()

    try:
        print("Attempting to grant PROCESS privilege...")
        cursor.execute(f"GRANT PROCESS ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%'")
        print("✓ PROCESS privilege granted")
    except Exception as e:
        print(f"✗ Failed to grant PROCESS privilege: {e}")

    print()

    try:
        print("Attempting to grant SUPER privilege...")
        cursor.execute(f"GRANT SUPER ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%'")
        print("✓ SUPER privilege granted")
    except Exception as e:
        print(f"✗ Failed to grant SUPER privilege: {e}")

    print()

    try:
        print("Attempting to flush privileges...")
        cursor.execute("FLUSH PRIVILEGES")
        conn.commit()
        print("✓ Privileges flushed")
    except Exception as e:
        print(f"✗ Failed to flush privileges: {e}")

    print()
    print()

    # STEP 4: Save SQL commands to file
    print("=" * 100)
    print("STEP 4: Saving SQL commands to file")
    print("=" * 100)
    print()

    with open('grant_kill_permissions.sql', 'w') as f:
        f.write("-- SQL Commands to Grant KILL Permissions to etaniadmin\n")
        f.write("-- Run these commands as a user with GRANT privileges (like root/admin)\n")
        f.write("-- " + "=" * 70 + "\n\n")
        f.write(f"-- Grant PROCESS privilege (to see all processes)\n")
        f.write(f"GRANT PROCESS ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';\n\n")
        f.write(f"-- Grant SUPER privilege (to kill other users' processes)\n")
        f.write(f"GRANT SUPER ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';\n\n")
        f.write("-- Flush privileges\n")
        f.write("FLUSH PRIVILEGES;\n\n")
        f.write("-- " + "=" * 70 + "\n\n")
        f.write("-- ALTERNATIVE (for MySQL 8.0+):\n")
        f.write(f"GRANT CONNECTION_ADMIN ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';\n")
        f.write("FLUSH PRIVILEGES;\n")

    print("✓ SQL commands saved to: grant_kill_permissions.sql")
    print()

    print()
    print("=" * 100)
    print("NEXT STEPS:")
    print("=" * 100)
    print()
    print("1. Run the SQL commands in grant_kill_permissions.sql as an admin user")
    print("2. You can do this via:")
    print("   - Azure Portal > MySQL > Query Editor")
    print("   - MySQL Workbench connected as admin")
    print("   - MySQL CLI as admin user")
    print()
    print("3. After granting privileges, re-run the test script to verify it works")
    print()

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
