# AWS RDS Connection Pooling - Quick Reference

## Setup Checklist

### In Azure App Service Configuration

Add these environment variables:

```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=ap-northeast-3
```

### IAM Policy Required

The IAM user needs permission to read the secret:

```json
{
  "Effect": "Allow",
  "Action": "secretsmanager:GetSecretValue",
  "Resource": "arn:aws:secretsmanager:ap-northeast-3:*:secret:rds!cluster-44496612-3d03-451b-9749-88451f45fed7*"
}
```

## Basic Usage

### 1. Initialize (Once at App Startup)

```python
from aws_db_helper import initialize_aws_engine

# Using AWS Secrets Manager (recommended)
initialize_aws_engine(use_secrets_manager=True)
```

### 2. Read Data

```python
from aws_db_helper import read_aws_table

# Simple query
df = read_aws_table("SELECT * FROM table")

# With parameters
df = read_aws_table(
    "SELECT * FROM table WHERE id = :id",
    params={'id': 123}
)
```

### 3. Execute Query

```python
from aws_db_helper import execute_aws_query

# INSERT
execute_aws_query(
    "INSERT INTO table (col1, col2) VALUES (:val1, :val2)",
    params={'val1': 'a', 'val2': 'b'}
)

# UPDATE
execute_aws_query(
    "UPDATE table SET status = :status WHERE id = :id",
    params={'status': 'done', 'id': 1}
)

# CALL stored procedure
execute_aws_query(
    "CALL sp_process_data(:param1)",
    params={'param1': 'value'}
)
```

### 4. Load DataFrame

```python
from aws_db_helper import load_to_aws_table
import pandas as pd

df = pd.DataFrame({'col1': [1, 2], 'col2': ['a', 'b']})
load_to_aws_table(df, 'table_name', write_mode='append')
```

### 5. Monitor Pool

```python
from aws_db_helper import get_pool_status

status = get_pool_status()
print(f"Connections in use: {status['checked_out_connections']}")
print(f"Available: {status['checked_in_connections']}")
```

### 6. Cleanup (On App Shutdown)

```python
from aws_db_helper import close_aws_connections

close_aws_connections()
```

## Migration from Azure MySQL

| Azure (Old) | AWS (New) |
|-------------|-----------|
| `ReadMySQLTable(query, endpoint, client_id, org_id, error_list)` | `read_aws_table(query, params=None)` |
| `ExecuteEvaSP(procedure_name, endpoint, error_list)` | `execute_aws_query(query, params=None)` |
| `LoadToEvaStageTable(df, endpoint, mode, table, error_list)` | `load_to_aws_table(df, table, write_mode)` |

## Connection Pool Benefits

✅ **50-100x faster** - Reuses connections instead of creating new ones
✅ **Automatic retry** - Handles transient failures
✅ **Health checks** - Detects and replaces stale connections
✅ **Resource efficient** - Limits concurrent connections
✅ **Cost savings** - Reduces Aurora compute overhead

## How the Secret Works

1. Your Azure app has AWS credentials (environment variables)
2. On startup, `initialize_aws_engine()` calls AWS Secrets Manager
3. Retrieves secret: `rds!cluster-44496612-3d03-451b-9749-88451f45fed7`
4. Secret contains: `{"username": "vibeadmin", "password": "..."}`
5. Creates connection pool with 10 connections
6. Credentials cached - Secrets Manager called only once

## Troubleshooting

| Error | Solution |
|-------|----------|
| "Unable to locate credentials" | Add AWS credentials to Azure App Service config |
| "Access Denied" | IAM user needs `secretsmanager:GetSecretValue` permission |
| "Connection timeout" | Check security group allows Azure IPs |
| "Too many connections" | Adjust `pool_size` in `aws_db_helper.py` |

## Files Reference

- `aws_db_helper.py` - Main connection pooling module
- `test_aws_connection.py` - Test suite
- `example_aws_usage.py` - Code examples
- `AWS_CONNECTION_POOLING_README.md` - Full documentation
- `AWS_QUICK_REFERENCE.md` - This file

## Support

- AWS Secrets Manager: https://docs.aws.amazon.com/secretsmanager/
- SQLAlchemy Pooling: https://docs.sqlalchemy.org/en/20/core/pooling.html
- boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/
