"""
ETL Cost Tracker Module

Tracks database operations and calculates MySQL Aurora Serverless v2 I/O costs for ETL runs.
Thread-safe for use with concurrent.futures.ThreadPoolExecutor.

Author: Claude Code
Date: 2026-01-01
"""

import time
from datetime import datetime
import threading


class ETLCostTracker:
    """
    Tracks database operations and calculates MySQL I/O costs for ETL runs.

    Thread-safe for concurrent database operations via ThreadPoolExecutor.
    Uses row-based I/O estimation: (rows_inserted + rows_updated) × 2 + rows_read
    Assumes average row size ≈ 8KB (1 I/O operation per row).

    Usage:
        tracker = ETLCostTracker(org_id, client_id, etani_client_id, 'INSERT', start_time)
        tracker.track_operation('INSERT', rows_affected=1000)
        tracker.track_operation('SELECT', rows_affected=500)
        cost_data = tracker.finalize(end_time, container_cost_usd, resource_metrics)
    """

    # Aurora Serverless v2 pricing (ap-southeast-2 region)
    AURORA_COST_PER_MILLION_READS = 0.24    # $0.24 per 1M read I/O operations
    AURORA_COST_PER_MILLION_WRITES = 0.24   # $0.24 per 1M write I/O operations

    def __init__(self, org_id, client_id, etani_client_id, run_type, start_time):
        """
        Initialize cost tracker.

        Args:
            org_id: Organization ID (EtaniOrganisationID)
            client_id: Client ID number (ClientIdNumber)
            etani_client_id: Full client ID string (e.g., 'TIGERS_CLIENT6918')
            run_type: Type of run ('INSERT', 'UPSERT', 'RECONCILIATION')
            start_time: Unix timestamp of run start (time.time())
        """
        self.org_id = org_id
        self.client_id = client_id
        self.etani_client_id = etani_client_id
        self.run_type = run_type
        self.start_time = start_time

        # Thread-safe counters using Lock for concurrent operations
        self._lock = threading.Lock()
        self.queries_executed = 0
        self.stored_procs_called = 0
        self.rows_inserted = 0
        self.rows_updated = 0
        self.rows_read = 0

    def track_operation(self, operation_type, rows_affected=0):
        """
        Track a database operation.

        Thread-safe method for tracking operations from concurrent threads.

        Args:
            operation_type: Type of operation
                - 'INSERT': Bulk insert operation (LoadToEvaStageTable)
                - 'UPDATE': Update operation
                - 'SELECT': Read operation (ReadMySQLTable)
                - 'STORED_PROC': Stored procedure call (ExecuteEvaSP, ExecuteCMSSP)
            rows_affected: Number of rows affected/returned (default: 0)
        """
        with self._lock:
            self.queries_executed += 1

            if operation_type == 'INSERT':
                self.rows_inserted += rows_affected
            elif operation_type == 'UPDATE':
                self.rows_updated += rows_affected
            elif operation_type == 'SELECT':
                self.rows_read += rows_affected
            elif operation_type == 'STORED_PROC':
                self.stored_procs_called += 1
                # Note: Stored procs may do inserts/updates/reads internally,
                # but we count them separately to avoid double-counting

    def calculate_mysql_cost(self):
        """
        Calculate estimated MySQL I/O cost based on rows affected.

        Formula:
            write_ios = (rows_inserted + rows_updated) × 2  # 2× for data + index
            read_ios = rows_read × 1
            total_ios = write_ios + read_ios
            cost = (total_ios / 1,000,000) × $0.24

        Returns:
            dict: {
                'estimated_write_ios': int,
                'estimated_read_ios': int,
                'estimated_total_ios': int,
                'mysql_io_cost_usd': float
            }
        """
        # Write I/Os: 2× multiplier for data + index updates
        # Each INSERT/UPDATE writes to data file + updates indexes
        write_ios = (self.rows_inserted + self.rows_updated) * 2

        # Read I/Os: 1× for SELECT queries
        read_ios = self.rows_read

        # Total I/O operations
        total_ios = write_ios + read_ios

        # Cost calculation (Aurora charges same for reads/writes)
        io_cost = (total_ios / 1_000_000) * self.AURORA_COST_PER_MILLION_WRITES

        return {
            'estimated_write_ios': write_ios,
            'estimated_read_ios': read_ios,
            'estimated_total_ios': total_ios,
            'mysql_io_cost_usd': round(io_cost, 6)  # Round to 6 decimal places (micro-cents)
        }

    def finalize(self, end_time, container_cost_usd, resource_metrics):
        """
        Finalize tracking and return complete cost summary.

        Called at end of ETL run to calculate final costs and prepare data for database insert.

        Args:
            end_time: Unix timestamp of run end (time.time())
            container_cost_usd: Container cost from calculate_fargate_cost() (float)
            resource_metrics: Dict from stop_tracking() with keys:
                - 'vcpu': vCPU allocation
                - 'peak_memory_gb': Peak memory usage
                - 'container_size': Recommended size (SMALL/NORMAL/MEDIUM/LARGE)

        Returns:
            dict: Complete cost data suitable for inserting into etl_run_costs table
        """
        mysql_costs = self.calculate_mysql_cost()

        return {
            'org_id': self.org_id,
            'client_id': self.client_id,
            'etani_client_id': self.etani_client_id,
            'integration_type': 'xero',
            'run_type': self.run_type,
            'run_start': datetime.fromtimestamp(self.start_time),
            'run_end': datetime.fromtimestamp(end_time),
            'runtime_seconds': int(end_time - self.start_time),

            # Database operation metrics
            'queries_executed': self.queries_executed,
            'stored_procs_called': self.stored_procs_called,
            'rows_inserted': self.rows_inserted,
            'rows_updated': self.rows_updated,
            'rows_read': self.rows_read,

            # I/O estimates
            'estimated_write_ios': mysql_costs['estimated_write_ios'],
            'estimated_read_ios': mysql_costs['estimated_read_ios'],
            'estimated_total_ios': mysql_costs['estimated_total_ios'],

            # Cost breakdown
            'container_cost_usd': container_cost_usd,
            'mysql_io_cost_usd': mysql_costs['mysql_io_cost_usd'],
            'total_cost_usd': round(container_cost_usd + mysql_costs['mysql_io_cost_usd'], 6),

            # Container details
            'container_vcpu': resource_metrics.get('vcpu'),
            'container_memory_gb': resource_metrics.get('peak_memory_gb'),
            'container_size': resource_metrics.get('container_size'),
            'task_arn': None  # Populated by save_etl_run_costs() function
        }

    def get_summary(self):
        """
        Get current tracking summary (for debugging/logging).

        Returns:
            dict: Current state of all counters
        """
        with self._lock:
            return {
                'queries_executed': self.queries_executed,
                'stored_procs_called': self.stored_procs_called,
                'rows_inserted': self.rows_inserted,
                'rows_updated': self.rows_updated,
                'rows_read': self.rows_read,
                'estimated_ios': (self.rows_inserted + self.rows_updated) * 2 + self.rows_read
            }


def calculate_fargate_cost(vcpu, memory_gb, duration_seconds):
    """
    Calculate AWS Fargate cost based on vCPU, memory, and duration.

    Fargate Pricing (ap-southeast-2):
    - vCPU: $0.04656 per vCPU per hour
    - Memory: $0.00511 per GB per hour

    Args:
        vcpu: Number of vCPUs allocated (0.25, 0.5, 1, 2, 4, etc.)
        memory_gb: Memory allocated in GB (0.5, 1, 2, 4, 8, etc.)
        duration_seconds: Duration of run in seconds

    Returns:
        float: Total Fargate cost in USD
    """
    # Fargate pricing per hour (ap-southeast-2 region)
    VCPU_COST_PER_HOUR = 0.04656
    MEMORY_COST_PER_GB_PER_HOUR = 0.00511

    # Convert seconds to hours
    duration_hours = duration_seconds / 3600

    # Calculate costs
    vcpu_cost = vcpu * VCPU_COST_PER_HOUR * duration_hours
    memory_cost = memory_gb * MEMORY_COST_PER_GB_PER_HOUR * duration_hours

    total_cost = vcpu_cost + memory_cost

    return round(total_cost, 6)  # Round to 6 decimal places (micro-cents)


def get_default_resource_metrics():
    """
    Get default resource metrics when actual metrics are unavailable.

    Returns:
        dict: Default resource metrics with keys:
            - 'vcpu': vCPU allocation (default: 1.0)
            - 'peak_memory_gb': Peak memory usage (default: 2.0)
            - 'container_size': Recommended size (default: 'NORMAL')
    """
    return {
        'vcpu': 1.0,
        'peak_memory_gb': 2.0,
        'container_size': 'NORMAL'
    }
