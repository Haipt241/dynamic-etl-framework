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

print(f"Connecting to Azure MySQL: {connection_config['host']}")
print(f"Database: {connection_config['database']}")
print()

try:
    # Connect to Azure MySQL
    conn = mysql.connector.connect(**connection_config)
    cursor = conn.cursor()

    print("✓ Connected successfully!")
    print()

    # Check for active processes
    print("Checking for active processes using xeroblue_transactionsblend views...")
    print("=" * 100)
    print()

    query = """
    SELECT
        ID,
        USER,
        HOST,
        DB,
        COMMAND,
        TIME,
        TIME/3600 AS hours,
        STATE,
        INFO
    FROM information_schema.processlist
    WHERE INFO IS NOT NULL
    AND USER != 'etaniadmin'
    ORDER BY TIME DESC
    """

    cursor.execute(query)
    processes = cursor.fetchall()

    print(f"Found {len(processes)} active processes (excluding etaniadmin)")
    print()

    # Filter for processes using transactionsblend views
    transactionsblend_processes = []

    for process in processes:
        process_id, user, host, db, command, time_sec, hours, state, info = process
        if info and 'xeroblue_transactionsblend' in info.lower():
            transactionsblend_processes.append({
                'id': process_id,
                'user': user,
                'host': host,
                'db': db,
                'command': command,
                'time': time_sec,
                'hours': hours,
                'state': state,
                'info': info
            })

    if transactionsblend_processes:
        print(f"⚠️  Found {len(transactionsblend_processes)} processes using xeroblue_transactionsblend views:")
        print("-" * 100)

        for i, proc in enumerate(transactionsblend_processes, 1):
            print(f"\n{i}. Process ID: {proc['id']}")
            print(f"   User: {proc['user']}")
            print(f"   Host: {proc['host']}")
            print(f"   Database: {proc['db']}")
            print(f"   Time: {proc['time']}s ({proc['hours']:.2f} hours)")
            print(f"   State: {proc['state']}")
            print(f"   Query: {proc['info'][:200]}...")

        print()
        print("=" * 100)
        print()

        # Ask if we should kill these processes
        print("These processes need to be killed before updating the views.")
        print()

        # Save process info to file
        with open('processes_to_kill.txt', 'w') as f:
            f.write("PROCESSES USING XEROBLUE_TRANSACTIONSBLEND VIEWS\n")
            f.write("=" * 100 + "\n\n")
            for proc in transactionsblend_processes:
                f.write(f"Process ID: {proc['id']}\n")
                f.write(f"User: {proc['user']}\n")
                f.write(f"Host: {proc['host']}\n")
                f.write(f"Time: {proc['time']}s\n")
                f.write(f"Query: {proc['info']}\n")
                f.write("-" * 100 + "\n\n")

        print(f"💾 Process details saved to: processes_to_kill.txt")
        print()

        # Generate kill commands
        print("SQL commands to kill these processes:")
        print("-" * 100)
        kill_commands = []
        for proc in transactionsblend_processes:
            kill_cmd = f"KILL {proc['id']};"
            kill_commands.append(kill_cmd)
            print(kill_cmd)

        print()

        # Save kill commands to file
        with open('kill_commands.sql', 'w') as f:
            f.write("-- SQL COMMANDS TO KILL PROCESSES USING XEROBLUE_TRANSACTIONSBLEND VIEWS\n")
            f.write("-- Generated: " + time.strftime("%Y-%m-%d %H:%M:%S") + "\n\n")
            for cmd in kill_commands:
                f.write(cmd + "\n")

        print(f"💾 Kill commands saved to: kill_commands.sql")

    else:
        print("✓ No active processes found using xeroblue_transactionsblend views")
        print("✓ Safe to proceed with view updates!")

    # Also show all active processes for reference
    print()
    print("=" * 100)
    print("ALL ACTIVE PROCESSES (for reference):")
    print("-" * 100)

    if processes:
        print(f"\nTotal: {len(processes)} processes\n")
        for i, process in enumerate(processes[:20], 1):  # Show first 20
            process_id, user, host, db, command, time_sec, hours, state, info = process
            print(f"{i}. ID: {process_id} | User: {user} | Time: {time_sec}s | DB: {db}")
            if info:
                print(f"   Query: {info[:100]}...")

        if len(processes) > 20:
            print(f"\n... and {len(processes) - 20} more processes")
    else:
        print("No active processes found")

    cursor.close()
    conn.close()

except mysql.connector.Error as err:
    print(f"❌ Database Error: {err}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    import traceback
    traceback.print_exc()
