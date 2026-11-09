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
        query_data = {
            'query_text': query_text,
            'execution_time_ms': execution_time_ms,
            'rows_examined': rows_examined,
            'rows_affected': rows_affected,
            'bytes_sent': bytes_sent,
            'table_names': table_names or []
        }
        self.queries.append(query_data)
        logger.debug(f"[Query Monitoring] Tracked query (total: {len(self.queries)}): {query_text[:100]}... ({execution_time_ms:.2f}ms)")

    def submit_queries(self, container_log_id: str):
        """
        Submit all tracked queries to API

        Args:
            container_log_id: Container log ID from start_container()

        Returns:
            API response dict
        """
        import requests

        # Log query count and basic info
        logger.info(f"[Query Monitoring] Submitting queries to endpoint")
        logger.info(f"[Query Monitoring] Number of queries tracked: {len(self.queries)}")
        logger.info(f"[Query Monitoring] Container Log ID: {container_log_id}")

        if not self.queries:
            logger.warning(f"[Query Monitoring] No queries to submit (self.queries is empty)")
            return {'success': True, 'logged_count': 0}

        endpoint_url = f"{self.api_url}/query-logs"
        logger.info(f"[Query Monitoring] Endpoint URL: {endpoint_url}")

        payload = {
            'container_log_id': container_log_id,
            'queries': self.queries
        }
        logger.info(f"[Query Monitoring] Payload summary: container_log_id={container_log_id}, queries_count={len(self.queries)}")

        try:
            response = requests.post(
                endpoint_url,
                headers={
                    'X-API-Key': self.api_key,
                    'Content-Type': 'application/json'
                },
                json=payload,
                timeout=30
            )
            logger.info(f"[Query Monitoring] Response Status Code: {response.status_code}")
            logger.info(f"[Query Monitoring] Response Content: {response.text}")

            response.raise_for_status()
            result = response.json()

            logger.info(f"[Query Monitoring] Successfully submitted {len(self.queries)} queries")
            logger.info(f"[Query Monitoring] Result: {result}")

            # Clear queries after successful submission
            self.queries = []

            return result

        except Exception as e:
            logger.error(f"[Query Monitoring] Failed to submit queries: {e}")
            logger.error(f"[Query Monitoring] Exception type: {type(e).__name__}")
            logger.error(f"[Query Monitoring] Endpoint was: {endpoint_url}")
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
