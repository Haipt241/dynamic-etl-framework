# SQL Error Logging

## Overview

Automatic SQL error logging has been implemented to capture and log all failed SQL statements to dedicated log files. This feature helps with debugging, monitoring, and troubleshooting SQL-related issues in both AWS and Azure environments.

## Features

- **Automatic Error Capture**: All SQL errors are automatically logged when they occur
- **Detailed Error Information**: Each log entry includes:
  - Timestamp
  - Database mode (AWS RDS Aurora / Azure MySQL)
  - Database name
  - Client ID and Organization ID
  - Job ID and Job Run ID
  - Error type and message
  - Full SQL query
  - Query parameters
  - Stack trace
  - Context (function name, endpoint)
- **Daily Log Files**: Logs are organized by date (e.g., `sql_errors_2025-10-22.log`)
- **Query Truncation**: Long queries are truncated at 5000 characters to prevent huge log files
- **Integrated with Existing Error Handlers**: Works seamlessly with existing retry logic and error handling

## Log File Location

```
/home/jepilor/etl 1.0/etl_packages/logs/sql_errors/
```

Log files follow the naming convention: `sql_errors_YYYY-MM-DD.log`

## Integrated Functions

The following functions now automatically log SQL errors:

1. **LoadToEvaStageTable** - Logs errors when loading data to stage tables
2. **ExecuteEvaSP** - Logs errors when executing EVA stored procedures
3. **ExecuteCMSSP** - Logs errors when executing CMS stored procedures
4. **ReadMySQLTable** - Logs errors when reading from MySQL tables
5. **ExecuteEVASQL** - Logs errors when executing EVA SQL queries

## Log Entry Format

```
================================================================================
TIMESTAMP: 2025-10-22 14:30:45.123
================================================================================
DATABASE: AWS RDS Aurora - Database: vibedb_BIGOLESHOECOMPANY
Client ID: BIGOLESHOECOMPANY_CLIENT1518 | Org ID: 5393
CONTEXT: LoadToEvaStageTable - accounts
JOB_ID: 0 | JOB_RUN_ID: 0

ERROR TYPE: ProgrammingError
ERROR MESSAGE: (pymysql.err.ProgrammingError) (1146, "Table 'vibedb_BIGOLESHOECOMPANY.c1518_xeroblue_accounts' doesn't exist")

SQL QUERY:
INSERT INTO c1518_xeroblue_accounts (`AccountID`, `Code`, `Name`, ...)
VALUES (:param_0, :param_1, :param_2, ...)

PARAMETERS: {'table': 'c1518_xeroblue_accounts', 'rows': 150, 'write_mode': 'append'}

STACK TRACE:
  File "/app/sql_helper.py", line 446, in LoadToEvaStageTable
    connection.execute(text(query), batch)
  ...
================================================================================
```

## Manual Usage

You can also manually log SQL errors in your code:

```python
from sql_helper import log_sql_error

try:
    # Your SQL operation
    cursor.execute(query, params)
except Exception as e:
    log_sql_error(
        sql_query=query,
        error=e,
        database_name="vibedb_BIGOLESHOECOMPANY",
        params={"param1": "value1"},
        context="MyFunction - MyEndpoint"
    )
```

## Function Parameters

```python
log_sql_error(
    sql_query: str,           # The SQL query that failed
    error: Exception,         # The exception that was raised
    database_name: str = None,  # Name of the database (optional)
    params: dict = None,        # Parameters used in the query (optional)
    context: str = None         # Additional context like function name, endpoint (optional)
)
```

## Benefits

1. **Debugging**: Quickly identify SQL errors and their root causes
2. **Monitoring**: Track patterns in SQL failures over time
3. **Audit Trail**: Maintain a record of all SQL errors for compliance
4. **Performance Analysis**: Identify problematic queries that need optimization
5. **Environment Comparison**: Compare SQL errors between AWS and Azure environments

## Log Management

### Viewing Recent Errors
```bash
# View today's errors
tail -f logs/sql_errors/sql_errors_$(date +%Y-%m-%d).log

# Search for specific errors
grep "ERROR TYPE" logs/sql_errors/*.log

# Count errors by type
grep "ERROR TYPE" logs/sql_errors/*.log | sort | uniq -c
```

### Cleanup Old Logs
```bash
# Delete logs older than 30 days
find logs/sql_errors/ -name "sql_errors_*.log" -mtime +30 -delete
```

## Error Types Logged

- **SQLAlchemyError**: General SQLAlchemy errors
- **ProgrammingError**: SQL syntax errors, missing tables/columns
- **OperationalError**: Database connection issues, permission errors
- **IntegrityError**: Constraint violations, duplicate keys
- **Exception**: Any other unexpected errors

## Integration with Existing Systems

The SQL error logging integrates seamlessly with:
- Existing retry logic (tenacity)
- Console logging
- LoggingDetails function
- Error list tracking
- Container logs stored in database

## Troubleshooting

### Log Files Not Created
- Check permissions on `/logs/sql_errors/` directory
- Ensure the directory exists (created automatically on first run)

### Logs Too Large
- Queries are automatically truncated at 5000 characters
- Implement log rotation if needed
- Consider archiving old logs

### Missing Error Details
- Ensure all required parameters are passed to functions
- Check that environment variables (JOB_ID, EtaniClientID, etc.) are set

## Future Enhancements

Potential improvements:
- Log rotation with size limits
- Email alerts for critical errors
- Dashboard integration
- Automated error analysis and reporting
- Error pattern detection
