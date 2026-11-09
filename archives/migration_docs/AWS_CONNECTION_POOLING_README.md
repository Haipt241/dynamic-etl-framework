# AWS RDS Aurora Connection Pooling Guide

This guide explains how to use the AWS RDS connection pooling implementation for connecting your Azure web apps to AWS Aurora database.

## Overview

The implementation provides:
- **Connection Pooling**: Efficient reuse of database connections
- **Automatic Retry**: Built-in retry logic for transient failures
- **Flexible Authentication**: Supports both AWS Secrets Manager and direct credentials
- **Production-Ready**: Optimized pool settings for serverless Aurora

## Files Created

1. `aws_db_helper.py` - Main module with connection pooling functions
2. `test_aws_connection.py` - Comprehensive test suite
3. Configuration added to `config.py` in both `etl_packages` and `etl_cron_job`

## Configuration

### In `config.py`:

```python
# AWS RDS Aurora Credentials
AWS_RDS_HOST = 'vibecfo-evadb.cxokc4emghb7.ap-northeast-3.rds.amazonaws.com'
AWS_RDS_USERNAME = 'vibeadmin'
AWS_RDS_SECRET_NAME = 'rds!cluster-44496612-3d03-451b-9749-88451f45fed7'
AWS_RDS_REGION = 'ap-northeast-3'
AWS_RDS_DATABASE = 'vibedb_BIGOLESHOECOMPANY'
```
#aws rds database format is vibedb_{FIRMCODE}
#azure evadb and evadb_stage should be now be using AWS RDS vibedb_{FIRMCODE}

## Usage in Azure Web Apps

### Option 1: Using AWS Secrets Manager (Recommended for Production)

This is the most secure approach. Your Azure web app retrieves the database password from AWS Secrets Manager.

**Step 1: Configure AWS credentials in Azure App Service**

Your Azure web app needs permission to access AWS Secrets Manager. Add these to your Azure App Service **Configuration → Application Settings**:

- `AWS_ACCESS_KEY_ID`: Your AWS IAM access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS IAM secret key
- `AWS_DEFAULT_REGION`: `ap-northeast-3`

**Required IAM Policy**: The IAM user/role needs `secretsmanager:GetSecretValue` permission. Here's the minimal policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager:ap-northeast-3:*:secret:rds!cluster-44496612-3d03-451b-9749-88451f45fed7*"
    }
  ]
}
```

**Step 2: Use in your code**

```python
from aws_db_helper import initialize_aws_engine, read_aws_table, execute_aws_query

# Initialize the connection pool (do this once at app startup)
# This will automatically retrieve the password from AWS Secrets Manager
initialize_aws_engine(use_secrets_manager=True)

# Read data
df = read_aws_table("SELECT * FROM your_table LIMIT 10")

# Execute query
execute_aws_query(
    "INSERT INTO your_table (col1, col2) VALUES (:val1, :val2)",
    params={'val1': 'value1', 'val2': 'value2'}
)
```

**How it works:**
1. When you call `initialize_aws_engine(use_secrets_manager=True)`, it connects to AWS Secrets Manager
2. It retrieves the secret `rds!cluster-44496612-3d03-451b-9749-88451f45fed7` from region `ap-northeast-3`
3. The secret contains the database password (stored as JSON: `{"username": "vibeadmin", "password": "..."}`)
4. The connection pool is created with these credentials
5. Credentials are cached - Secrets Manager is only called once

### Option 2: Using Direct Password

For simpler setup, you can use the password directly. Store it as an Azure App Service environment variable.

**Step 1: Add password to Azure App Service Configuration**
- Add: `AWS_RDS_PASSWORD`: `your-database-password`

**Step 2: Use in your code**

```python
import os
from aws_db_helper import initialize_aws_engine, read_aws_table

# Get password from environment variable
aws_password = os.getenv('AWS_RDS_PASSWORD')

# Initialize the connection pool
initialize_aws_engine(use_secrets_manager=False, direct_password=aws_password)

# Use the connection
df = read_aws_table("SELECT * FROM your_table")
```

## Connection Pool Settings

The pool is configured with these optimal settings for Aurora Serverless:

```python
pool_size=10              # Keep 10 connections in the pool
max_overflow=20           # Allow up to 20 additional connections
pool_timeout=30           # Wait 30 seconds for a connection
pool_recycle=3600         # Recycle connections after 1 hour
pool_pre_ping=True        # Verify connection health before use
```

## Available Functions

### Initialization

```python
initialize_aws_engine(use_secrets_manager=True, direct_password=None)
```
Initialize the global connection pool. Call this once at application startup.

### Query Execution

```python
execute_aws_query(query, params=None, database=None)
```
Execute any SQL query (INSERT, UPDATE, DELETE, etc.)

**Example:**
```python
execute_aws_query(
    "UPDATE users SET status = :status WHERE id = :user_id",
    params={'status': 'active', 'user_id': 123}
)
```

### Reading Data

```python
read_aws_table(query, params=None, database=None)
```
Execute SELECT query and return pandas DataFrame.

**Example:**
```python
df = read_aws_table(
    "SELECT * FROM orders WHERE date >= :start_date",
    params={'start_date': '2025-01-01'}
)
print(f"Found {len(df)} orders")
```

### Loading Data

```python
load_to_aws_table(df, table_name, write_mode='append', database=None)
```
Load a pandas DataFrame to a table.

**Example:**
```python
import pandas as pd

df = pd.DataFrame({
    'name': ['Alice', 'Bob'],
    'age': [25, 30]
})

load_to_aws_table(df, 'users', write_mode='append')
```

### Stored Procedures

```python
execute_aws_stored_procedure(procedure_name, params=None, database=None)
```
Execute a stored procedure.

**Example:**
```python
execute_aws_stored_procedure(
    "sp_process_orders(:order_date)",
    params={'order_date': '2025-01-15'}
)
```

### Connection Management

```python
# Get pool statistics
status = get_pool_status()
print(f"Active connections: {status['checked_out_connections']}")

# Test connection
if test_aws_connection():
    print("Connection successful!")

# Close all connections (call during shutdown)
close_aws_connections()
```

## Testing Locally

If you have the database password, you can test the connection:

```bash
# Test with direct password
python test_aws_connection.py --password "YOUR_PASSWORD"

# Test with AWS Secrets Manager (requires AWS credentials configured)
python test_aws_connection.py --secrets-manager
```

## Integration Example for Azure Web App

Here's a complete example for a Flask app running in Azure:

```python
# app.py
import os
from flask import Flask, jsonify
from aws_db_helper import initialize_aws_engine, read_aws_table, close_aws_connections
import atexit

app = Flask(__name__)

# Initialize connection pool at startup
def init_db():
    # Option 1: Using Secrets Manager
    # initialize_aws_engine(use_secrets_manager=True)

    # Option 2: Using direct password from environment
    password = os.getenv('AWS_RDS_PASSWORD')
    initialize_aws_engine(use_secrets_manager=False, direct_password=password)

init_db()

# Clean up connections on shutdown
atexit.register(close_aws_connections)

@app.route('/api/data')
def get_data():
    try:
        df = read_aws_table("SELECT * FROM your_table LIMIT 100")
        return jsonify(df.to_dict(orient='records'))
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run()
```

## Benefits of Connection Pooling

1. **Performance**: Reusing connections is much faster than creating new ones
2. **Resource Efficiency**: Limits the number of database connections
3. **Stability**: Prevents overwhelming the database with too many connections
4. **Automatic Recovery**: Pool pre-ping detects and replaces stale connections
5. **Cost Savings**: Fewer connection overhead reduces Aurora compute costs

## Comparison: With vs Without Pooling

### Without Pooling (Old Way)
```python
# Every query creates a new connection
connection = pymysql.connect(host=..., user=..., password=...)
cursor = connection.cursor()
cursor.execute("SELECT ...")
connection.close()  # Expensive operation
```

### With Pooling (New Way)
```python
# Reuses connections from the pool
df = read_aws_table("SELECT ...")  # Much faster!
```

## Monitoring Pool Health

Add this endpoint to your Azure web app to monitor the connection pool:

```python
@app.route('/health/db-pool')
def pool_health():
    status = get_pool_status()
    return jsonify({
        'healthy': True,
        'pool_size': status['pool_size'],
        'active_connections': status['checked_out_connections'],
        'available_connections': status['checked_in_connections']
    })
```

## Troubleshooting

### Issue: "Unable to locate credentials"
**Solution**: Either configure AWS credentials in Azure App Service or use direct password method.

### Issue: Connection timeout
**Solution**:
- Verify the Aurora endpoint is publicly accessible
- Check security group allows traffic from Azure
- Verify credentials are correct

### Issue: Too many connections
**Solution**: Adjust `pool_size` and `max_overflow` in `aws_db_helper.py`

### Issue: Stale connections
**Solution**: The pool already has `pool_pre_ping=True` which handles this automatically

## Security Best Practices

1. **Never commit passwords**: Use environment variables
2. **Use Secrets Manager in production**: More secure than direct passwords
3. **Rotate credentials regularly**: Update in Secrets Manager
4. **Use SSL**: Aurora enforces SSL by default
5. **Principle of least privilege**: Grant only necessary database permissions

## Migration from Azure MySQL

If you're migrating from the existing Azure MySQL connection:

**Old code (Azure):**
```python
from sql_helper import eva_engine, ReadMySQLTable

df = ReadMySQLTable("SELECT * FROM table", "endpoint", client_id, org_id, error_list)
```

**New code (AWS):**
```python
from aws_db_helper import initialize_aws_engine, read_aws_table

# One-time initialization
initialize_aws_engine(use_secrets_manager=False, direct_password=password)

# Use similar to Azure
df = read_aws_table("SELECT * FROM table")
```

## Next Steps

1. Test the connection using `test_aws_connection.py` with your password
2. Choose authentication method (Secrets Manager vs direct password)
3. Configure credentials in your Azure App Service
4. Update your application code to use `aws_db_helper`
5. Monitor connection pool health in production

## Support

For issues or questions, refer to:
- SQLAlchemy documentation: https://docs.sqlalchemy.org/
- AWS RDS Aurora documentation: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/
- boto3 documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/
