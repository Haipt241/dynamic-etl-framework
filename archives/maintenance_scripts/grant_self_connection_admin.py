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

    print("=" * 100)
    print("Attempting to grant CONNECTION_ADMIN to etaniadmin (ourselves)")
    print("=" * 100)
    print()

    # Try to grant CONNECTION_ADMIN to ourselves
    try:
        print(f"Executing: GRANT CONNECTION_ADMIN ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%';")
        cursor.execute(f"GRANT CONNECTION_ADMIN ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%'")
        print("✓ Successfully granted CONNECTION_ADMIN privilege!")
        print()

        print("Flushing privileges...")
        cursor.execute("FLUSH PRIVILEGES")
        conn.commit()
        print("✓ Privileges flushed!")
        print()

        print("=" * 100)
        print("SUCCESS! etaniadmin now has CONNECTION_ADMIN privilege")
        print("=" * 100)
        print()
        print("You can now kill other users' processes!")

    except mysql.connector.Error as e:
        print(f"❌ Failed to grant CONNECTION_ADMIN: {e}")
        print()
        print("This might be an Azure MySQL Flexible Server restriction.")
        print()

        # Try alternative privileges
        print()
        print("Trying alternative approach with SYSTEM_USER privilege...")
        try:
            cursor.execute(f"GRANT SYSTEM_USER ON *.* TO '{config.MYSQL_SERVER_USERNAME}'@'%'")
            cursor.execute("FLUSH PRIVILEGES")
            conn.commit()
            print("✓ Successfully granted SYSTEM_USER privilege!")
        except Exception as e2:
            print(f"❌ Failed: {e2}")

    print()

    # Check current privileges again
    print()
    print("=" * 100)
    print("Current privileges after grant attempt:")
    print("=" * 100)
    print()

    cursor.execute(f"SHOW GRANTS FOR '{config.MYSQL_SERVER_USERNAME}'@'%'")
    grants = cursor.fetchall()

    for grant in grants:
        print(grant[0])

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
