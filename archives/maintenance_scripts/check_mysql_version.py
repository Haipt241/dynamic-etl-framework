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
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # Get MySQL version
    cursor.execute("SELECT VERSION()")
    version = cursor.fetchone()[0]

    print("=" * 100)
    print("MYSQL VERSION:")
    print("=" * 100)
    print(f"\n{version}\n")

    # Get more detailed server info
    cursor.execute("SHOW VARIABLES LIKE '%version%'")
    variables = cursor.fetchall()

    print()
    print("=" * 100)
    print("DETAILED VERSION INFORMATION:")
    print("=" * 100)
    print()

    for var_name, var_value in variables:
        print(f"{var_name}: {var_value}")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
