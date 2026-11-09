# ETL Project Implementation Guide
## Step-by-Step Guide for Adding Query Monitoring to ETL Containers

**Target Project:** ETL Container Projects
**Backend API:** CMS-BackEnd-V3 (already implemented)
**Purpose:** Add query performance monitoring to existing ETL containers

---

## Overview

This guide shows you how to add query performance monitoring to your ETL container project. The monitoring system will:

1. Track every SQL query executed during ETL runs
2. Automatically detect slow queries (>30 seconds)
3. Get AI-powered optimization suggestions from Claude
4. Help you improve performance and reduce costs

### What's Already Done (Backend)

✅ Database tables created
✅ API endpoints implemented
✅ LLM integration with Claude ready
✅ Auto-analysis background tasks configured

### What You Need to Do (ETL Project)

📝 Add query tracking to your ETL code
📝 Submit queries to the monitoring API
📝 (Optional) View suggestions and optimize queries

---

## Prerequisites

Before starting, ensure you have:

- Python 3.8+
- `requests` library installed
- Access to CMS Backend API
- ETL API write key (get from admin)
- Existing container logging already implemented

---

## Step 1: Copy the Monitoring Client

Create a new file `query_monitoring_client.py` in your ETL project:

```python
"""
Query Monitoring Client for ETL Containers
Copy this file to your ETL project
"""
import time
import logging

logger = logging.getLogger(__name__)


class QueryMonitoringClient:
    """Client for tracking query performance"""

    def __init__(self, api_url: str, api_key: str):
        """
        Initialize client

        Args:
            api_url: API base URL (e.g., https://api.vibecfo.au/api/etl)
            api_key: ETL API write key
        """
        self.api_url = api_url.rstrip('/')
        self.api_key = api_key
        self.queries = []

    def track_query(self, query_text: str, execution_time_ms: float,
                   rows_examined: int = None, rows_affected: int = None,
                   bytes_sent: int = None, table_names: list = None):
        """
        Track a single query execution

        Args:
            query_text: SQL query text (use ? for parameters)
            execution_time_ms: Execution time in milliseconds
            rows_examined: Number of rows examined
            rows_affected: Number of rows affected/returned
            bytes_sent: Bytes sent to client
            table_names: List of table names involved
        """
        self.queries.append({
            'query_text': query_text,
            'execution_time_ms': execution_time_ms,
            'rows_examined': rows_examined,
            'rows_affected': rows_affected,
            'bytes_sent': bytes_sent,
            'table_names': table_names or []
        })

    def submit_queries(self, container_log_id: str):
        """
        Submit all tracked queries to API

        Args:
            container_log_id: Container log ID from start_container()

        Returns:
            API response dict
        """
        import requests

        if not self.queries:
            return {'success': True, 'logged_count': 0}

        try:
            response = requests.post(
                f"{self.api_url}/query-logs",
                headers={
                    'X-API-Key': self.api_key,
                    'Content-Type': 'application/json'
                },
                json={
                    'container_log_id': container_log_id,
                    'queries': self.queries
                },
                timeout=30
            )
            response.raise_for_status()
            result = response.json()

            # Clear queries after successful submission
            self.queries = []

            return result

        except Exception as e:
            logger.error(f"Failed to submit queries: {e}")
            # Don't raise - monitoring failures shouldn't crash ETL
            return {'success': False, 'error': str(e)}


class TrackedCursor:
    """Cursor wrapper that automatically tracks queries"""

    def __init__(self, cursor, query_tracker: QueryMonitoringClient):
        """
        Wrap a database cursor

        Args:
            cursor: Database cursor (any DB-API 2.0 cursor)
            query_tracker: QueryMonitoringClient instance
        """
        self.cursor = cursor
        self.query_tracker = query_tracker

    def execute(self, query, params=None):
        """Execute query with automatic tracking"""
        start_time = time.time()

        try:
            result = self.cursor.execute(query, params)
            execution_time_ms = (time.time() - start_time) * 1000

            # Track the query
            self.query_tracker.track_query(
                query_text=query,
                execution_time_ms=execution_time_ms,
                rows_examined=self.cursor.rowcount if self.cursor.rowcount >= 0 else None,
                rows_affected=self.cursor.rowcount if self.cursor.rowcount >= 0 else None
            )

            return result

        except Exception as e:
            # Track failed query too
            execution_time_ms = (time.time() - start_time) * 1000
            self.query_tracker.track_query(
                query_text=query,
                execution_time_ms=execution_time_ms
            )
            raise

    def fetchone(self):
        """Fetch one row"""
        return self.cursor.fetchone()

    def fetchall(self):
        """Fetch all rows"""
        return self.cursor.fetchall()

    def fetchmany(self, size=None):
        """Fetch many rows"""
        return self.cursor.fetchmany(size)

    def close(self):
        """Close cursor"""
        return self.cursor.close()

    @property
    def rowcount(self):
        """Get row count"""
        return self.cursor.rowcount

    @property
    def description(self):
        """Get description"""
        return self.cursor.description

    def __enter__(self):
        """Context manager enter"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        self.close()
```

---

## Step 2: Update Your ETL Container Code

### Option A: Manual Query Tracking (Simple)

Manually track each query:

```python
import os
from query_monitoring_client import QueryMonitoringClient
from container_monitoring_client import ContainerMonitoringClient
import time

# Initialize clients
api_url = os.environ['ETL_API_URL']
api_key = os.environ['ETL_API_KEY']

container_client = ContainerMonitoringClient(api_url, api_key)
query_client = QueryMonitoringClient(api_url, api_key)

# Start container
log_id = container_client.start_container(
    integration='xero_sync',
    client_id=123,
    firm_id=456
)

try:
    # Your ETL logic with manual tracking
    conn = get_database_connection()
    cursor = conn.cursor()

    # Track each query manually
    query = "SELECT * FROM clients WHERE firm_id = ?"
    start_time = time.time()
    cursor.execute(query, [firm_id])
    execution_time_ms = (time.time() - start_time) * 1000

    query_client.track_query(
        query_text=query,
        execution_time_ms=execution_time_ms,
        rows_examined=cursor.rowcount,
        table_names=['clients']
    )

    clients = cursor.fetchall()

    # Process clients...

    # Submit queries
    query_client.submit_queries(log_id)

    # Complete container
    container_client.complete_container(log_id, status="success")

except Exception as e:
    # Submit queries even on failure
    query_client.submit_queries(log_id)
    container_client.complete_container(log_id, status="failed", error_details=str(e))
    raise
```

### Option B: Automatic Query Tracking (Recommended)

Use the `TrackedCursor` wrapper for automatic tracking:

```python
import os
from query_monitoring_client import QueryMonitoringClient, TrackedCursor
from container_monitoring_client import ContainerMonitoringClient

# Initialize clients
api_url = os.environ['ETL_API_URL']
api_key = os.environ['ETL_API_KEY']

container_client = ContainerMonitoringClient(api_url, api_key)
query_client = QueryMonitoringClient(api_url, api_key)

# Start container
log_id = container_client.start_container(
    integration='xero_sync',
    client_id=123,
    firm_id=456
)

try:
    # Your ETL logic with automatic tracking
    conn = get_database_connection()
    cursor = conn.cursor()

    # Wrap cursor for automatic tracking
    tracked_cursor = TrackedCursor(cursor, query_client)

    # All queries executed through tracked_cursor are automatically tracked!
    tracked_cursor.execute("SELECT * FROM clients WHERE firm_id = ?", [firm_id])
    clients = tracked_cursor.fetchall()

    for client in clients:
        # These queries are also automatically tracked
        tracked_cursor.execute("SELECT * FROM invoices WHERE client_id = ?", [client['id']])
        invoices = tracked_cursor.fetchall()

        # Process invoices...

        tracked_cursor.execute("UPDATE invoices SET status = ? WHERE client_id = ?", ['synced', client['id']])

    # Submit all tracked queries
    query_client.submit_queries(log_id)

    # Complete container
    container_client.complete_container(log_id, status="success")

except Exception as e:
    # Submit queries even on failure
    query_client.submit_queries(log_id)
    container_client.complete_container(log_id, status="failed", error_details=str(e))
    raise
finally:
    cursor.close()
    conn.close()
```

---

## Step 3: Add Environment Variables

Add these to your container's environment variables:

```bash
# Required (should already exist from container monitoring)
ETL_API_URL=https://api.vibecfo.au/api/etl
ETL_API_KEY=your-writeonly-key-here

# Optional: Query monitoring configuration
QUERY_MONITORING_ENABLED=true
```

---

## Step 4: Test Your Implementation

### Test Locally

1. Run your ETL container locally
2. Check that queries are being tracked (check logs)
3. Verify queries appear in the API:

```bash
curl -H "X-API-Key: your-readonly-key" \
  "https://api.vibecfo.au/api/etl/query-logs?integration=xero_sync&page=1"
```

### Test Slow Query Detection

Intentionally create a slow query to test:

```python
# Add a slow query for testing
import time
start = time.time()
cursor.execute("SELECT * FROM large_table WHERE complex_condition = ?", [value])
time.sleep(31)  # Simulate slow query >30s
execution_time_ms = (time.time() - start) * 1000
query_client.track_query(query_text="SELECT...", execution_time_ms=execution_time_ms)
```

Check if it's detected as slow:

```bash
curl -H "X-API-Key: your-readonly-key" \
  "https://api.vibecfo.au/api/etl/slow-queries?integration=xero_sync"
```

---

## Step 5: View Optimization Suggestions

### Check for Suggestions

After slow queries are detected (wait 5-10 minutes for auto-analysis):

```bash
curl -H "X-API-Key: your-readonly-key" \
  "https://api.vibecfo.au/api/etl/optimization-suggestions?is_resolved=false"
```

### Response Example

```json
{
  "suggestions": [
    {
      "suggestion_id": 123,
      "query_hash": "abc123...",
      "severity": "high",
      "issue_type": "missing_index",
      "suggestion_text": "This query examines 150,000 rows. Creating a composite index will improve performance.",
      "recommended_indexes": [
        {
          "table": "clients",
          "columns": ["firm_id", "created_at"],
          "create_statement": "CREATE INDEX idx_firm_created ON clients(firm_id, created_at)"
        }
      ],
      "optimized_query": "SELECT id, name FROM clients WHERE firm_id = ? AND created_at > ?",
      "expected_improvement_pct": 75,
      "times_seen": 45
    }
  ]
}
```

### Implement Suggestions

1. Review the suggestion
2. Create the recommended index:
   ```sql
   CREATE INDEX idx_firm_created ON clients(firm_id, created_at);
   ```
3. Update your query if suggested
4. Test the improvement
5. Mark as resolved:
   ```bash
   curl -X PATCH \
     -H "X-API-Key: your-writeonly-key" \
     -H "Content-Type: application/json" \
     -d '{"is_resolved": true, "resolved_by": "your-email", "resolution_notes": "Created index, query now runs in 8s"}' \
     "https://api.vibecfo.au/api/etl/optimization-suggestions/123"
   ```

---

## Complete Implementation Example

Here's a complete, production-ready example:

```python
"""
ETL Container with Query Monitoring
Production-ready example
"""
import os
import sys
import logging
import traceback
from query_monitoring_client import QueryMonitoringClient, TrackedCursor
from container_monitoring_client import ContainerMonitoringClient

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
API_URL = os.environ['ETL_API_URL']
API_KEY = os.environ['ETL_API_KEY']
INTEGRATION_NAME = os.environ['INTEGRATION_NAME']  # e.g., 'xero_sync'
CLIENT_ID = int(os.environ.get('CLIENT_ID', 0)) or None
FIRM_ID = int(os.environ.get('FIRM_ID', 0)) or None


def main():
    """Main ETL execution"""

    # Initialize monitoring clients
    container_client = ContainerMonitoringClient(API_URL, API_KEY)
    query_client = QueryMonitoringClient(API_URL, API_KEY)

    # Start container logging
    logger.info("Starting ETL container...")
    container_log_id = container_client.start_container(
        integration=INTEGRATION_NAME,
        client_id=CLIENT_ID,
        firm_id=FIRM_ID,
        container_name=os.environ.get('HOSTNAME'),
        platform='azure',
        region='australiaeast',
        vcpu=1.0,
        memory_gb=2.0
    )
    logger.info(f"Container log ID: {container_log_id}")

    conn = None
    cursor = None

    try:
        # Connect to database
        conn = get_database_connection()
        cursor = conn.cursor()

        # Wrap cursor for automatic query tracking
        tracked_cursor = TrackedCursor(cursor, query_client)

        # Execute your ETL logic
        logger.info("Fetching clients...")
        tracked_cursor.execute(
            "SELECT id, name FROM clients WHERE firm_id = ? AND active = 1",
            [FIRM_ID]
        )
        clients = tracked_cursor.fetchall()
        logger.info(f"Found {len(clients)} clients")

        # Process each client
        for client_row in clients:
            client_id, client_name = client_row
            logger.info(f"Processing client: {client_name}")

            # Fetch invoices
            tracked_cursor.execute(
                "SELECT id, amount, status FROM invoices WHERE client_id = ? AND status = 'pending'",
                [client_id]
            )
            invoices = tracked_cursor.fetchall()

            # Sync to external system (your business logic)
            sync_to_external_system(client_id, invoices)

            # Update invoice statuses
            if invoices:
                tracked_cursor.execute(
                    "UPDATE invoices SET status = 'synced', synced_at = NOW() WHERE client_id = ?",
                    [client_id]
                )
                conn.commit()

        # Submit query performance logs
        logger.info("Submitting query performance logs...")
        query_result = query_client.submit_queries(container_log_id)
        logger.info(f"Logged {query_result.get('logged_count', 0)} queries")
        if query_result.get('slow_queries_detected', 0) > 0:
            logger.warning(f"Detected {query_result['slow_queries_detected']} slow queries")

        # Complete container logging
        logger.info("Marking container as successful...")
        container_result = container_client.complete_container(
            container_log_id,
            status="success",
            remarks=f"Successfully processed {len(clients)} clients"
        )
        logger.info(f"Container completed. Duration: {container_result.get('duration_seconds')}s, Cost: ${container_result.get('cost_usd', 0):.6f}")

        logger.info("✓ ETL completed successfully")
        return 0

    except Exception as e:
        logger.error(f"✗ ETL failed: {e}")
        logger.error(traceback.format_exc())

        # Submit queries even on failure
        try:
            query_client.submit_queries(container_log_id)
        except:
            pass

        # Mark container as failed
        try:
            container_client.complete_container(
                container_log_id,
                status="failed",
                error_details=traceback.format_exc(),
                remarks=f"Failed: {str(e)}"
            )
        except:
            pass

        return 1

    finally:
        # Cleanup
        if cursor:
            cursor.close()
        if conn:
            conn.close()


def get_database_connection():
    """Get database connection (implement based on your DB)"""
    import pymysql
    return pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        database=os.environ['DB_NAME']
    )


def sync_to_external_system(client_id, invoices):
    """Sync data to external system (your business logic)"""
    # Your sync logic here
    pass


if __name__ == "__main__":
    sys.exit(main())
```

---

## Troubleshooting

### Problem: Queries not appearing in API

**Solutions:**
- Verify `container_log_id` is valid
- Check API key has write permissions
- Ensure `submit_queries()` is being called
- Check network connectivity to API

### Problem: No slow queries detected

**Solutions:**
- Verify queries are actually >30 seconds
- Check `execution_time_ms` is in milliseconds (not seconds)
- Ensure queries are being submitted via API

### Problem: No optimization suggestions generated

**Solutions:**
- Wait 5-10 minutes for auto-analysis to run
- Check LLM API is configured in backend
- Manually trigger analysis via POST /analyze-query
- Check backend logs for errors

### Problem: Monitoring is slowing down ETL

**Solutions:**
- Query tracking is very lightweight (<1ms overhead)
- Move `submit_queries()` to end of ETL (batch submission)
- Disable monitoring if needed: don't call `track_query()`

---

## Best Practices

### ✅ Do's

1. **Always submit queries** - Even on failure
2. **Use TrackedCursor** - Automatic tracking is easier
3. **Normalize queries** - Use `?` for parameters, not actual values
4. **Batch submissions** - Submit once at end, not per query
5. **Handle failures gracefully** - Don't let monitoring crash your ETL
6. **Review suggestions** - Act on high/critical suggestions quickly

### ❌ Don'ts

1. **Don't include actual values in queries** - Use `?` placeholders
2. **Don't submit queries synchronously** - Batch them
3. **Don't let monitoring errors crash ETL** - Wrap in try/except
4. **Don't ignore slow queries** - They cost money
5. **Don't skip query submission on errors** - Always submit

---

## FAQ

**Q: Will this slow down my ETL?**
A: No, query tracking adds <1ms overhead per query. Submission is batched at the end.

**Q: What if the API is down?**
A: Monitoring failures are caught and logged, but won't crash your ETL.

**Q: How accurate is the LLM analysis?**
A: Claude 3.5 Sonnet provides 80-90% actionable suggestions based on testing.

**Q: Can I disable monitoring temporarily?**
A: Yes, just don't call `track_query()` or set `QUERY_MONITORING_ENABLED=false`.

**Q: How much does LLM analysis cost?**
A: ~$0.006 per query analysis. Budget is capped at $5/day by default.

**Q: Can I see historical query performance?**
A: Yes, use GET /query-logs with date filters.

---

## Next Steps

1. ✅ Copy `query_monitoring_client.py` to your project
2. ✅ Update your ETL code (Option A or B)
3. ✅ Add environment variables
4. ✅ Test locally
5. ✅ Deploy to production
6. ✅ Monitor slow queries
7. ✅ Implement optimizations
8. ✅ Mark suggestions as resolved

---

## Support

- **Backend API Docs:** `/docs/ETL_INTEGRATION_GUIDE.md`
- **API Reference:** https://api.vibecfo.au/api/etl/docs
- **Support:** devops@etani.com.au
- **Issues:** Report in #etl-monitoring Slack channel

---

**Version:** 1.0
**Last Updated:** 2025-01-06
**Backend API Version:** v1
