# How to Grant KILL Permissions on Azure MySQL Flexible Server

## Option 1: Azure Portal (Recommended)

1. Go to **Azure Portal** (portal.azure.com)
2. Navigate to your **MySQL Flexible Server** resource
3. In the left menu, find **"Settings"** section
4. Look for one of these options:
   - **"Query editor"** (if available)
   - **"Networking"** → Enable public access or configure firewall rules
5. If Query editor is available:
   - Click on it
   - Login as the **admin user** (not etaniadmin)
   - Paste and run this SQL:

```sql
-- Grant CONNECTION_ADMIN privilege for MySQL 8.0
GRANT CONNECTION_ADMIN ON *.* TO 'etaniadmin'@'%';
FLUSH PRIVILEGES;
```

## Option 2: MySQL Workbench

1. Open **MySQL Workbench**
2. Create a new connection with these details:
   - **Hostname**: etaniv2-mysql-prod.mysql.database.azure.com
   - **Port**: 3306
   - **Username**: **admin username** (not etaniadmin)
   - **Password**: admin password
   - **SSL**: Use SSL with CA certificate
3. Connect and run the SQL:

```sql
GRANT CONNECTION_ADMIN ON *.* TO 'etaniadmin'@'%';
FLUSH PRIVILEGES;
```

## Option 3: Azure Cloud Shell / Azure CLI

1. Open **Azure Cloud Shell** in Azure Portal (top right icon)
2. Run this command to connect:

```bash
mysql -h etaniv2-mysql-prod.mysql.database.azure.com -u <admin-username> -p
```

3. Enter admin password when prompted
4. Run the SQL:

```sql
GRANT CONNECTION_ADMIN ON *.* TO 'etaniadmin'@'%';
FLUSH PRIVILEGES;
```

## Option 4: MySQL Command Line from Local Machine

If you have mysql client installed:

```bash
mysql -h etaniv2-mysql-prod.mysql.database.azure.com \
      -u <admin-username> \
      -p \
      --ssl-mode=REQUIRED
```

Then run:
```sql
GRANT CONNECTION_ADMIN ON *.* TO 'etaniadmin'@'%';
FLUSH PRIVILEGES;
```

## Important Notes for Azure MySQL Flexible Server

1. **Admin User**: You need to login as the **server admin user** that was created when the MySQL server was provisioned
   - This is usually NOT 'etaniadmin'
   - Check Azure Portal → MySQL server → "Properties" or "Overview" to find the admin username

2. **Firewall Rules**: Make sure your IP is allowed in:
   - Azure Portal → MySQL server → "Networking"
   - Add your current IP address

3. **SSL/TLS**: Azure MySQL requires SSL connection
   - Download the SSL certificate if needed from Azure Portal

## After Granting Permissions

Once you've successfully run the GRANT command:
1. Verify by running our test script again
2. It should now be able to kill processes
3. Then we can proceed with updating all 2,387 views

## Troubleshooting

If you get "Access Denied" errors:
- Make sure you're using the **server admin account** (not etaniadmin)
- Check that your IP is whitelisted in the firewall rules
- Verify you're connecting with SSL enabled
