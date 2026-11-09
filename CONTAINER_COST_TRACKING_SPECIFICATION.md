# Container Cost Tracking System - Complete Specification
**Source Branch:** `xero-aws-only`
**Documentation Date:** January 9, 2026
**Purpose:** Training data for implementing comprehensive container cost tracking in dynamic integrations

## Table of Contents
1. [System Overview](#system-overview)
2. [Architecture Components](#architecture-components)
3. [Cost Calculation Logic](#cost-calculation-logic)
4. [Database Schema](#database-schema)
5. [Implementation Details](#implementation-details)
6. [Integration Patterns](#integration-patterns)
7. [API Integration](#api-integration)
8. [Error Handling](#error-handling)
9. [Code Examples](#code-examples)

---

## System Overview

### Purpose
The container cost tracking system provides comprehensive cost analysis for ETL operations by tracking:
- AWS Fargate container costs (vCPU + Memory)
- MySQL Aurora Serverless v2 I/O costs
- Resource utilization metrics
- Execution lifecycle events

### Key Features
- **Real-time Cost Tracking**: Calculates costs during ETL execution
- **Multi-Component Costing**: Separates container vs database costs
- **Resource Monitoring**: Tracks actual vs allocated resources
- **Thread-Safe Operations**: Supports concurrent ETL operations
- **Comprehensive Logging**: Records detailed execution metadata

---

## Architecture Components

### 1. Core Modules

#### 1.1 ETLCostTracker Class
**File:** `/Users/haipham/DuAn/upwork/etani/etl-packages/etl_cost_tracker.py`

```python
class ETLCostTracker:
    """Thread-safe cost tracking for ETL operations"""

    def __init__(self, org_id, client_id, etani_client_id, run_type, start_time):
        self.org_id = org_id
        self.client_id = client_id
        self.etani_client_id = etani_client_id
        self.run_type = run_type  # 'INSERT', 'UPSERT', 'RECONCILIATION'
        self.start_time = start_time

        # Thread-safe counters
        self._lock = threading.Lock()
        self.rows_inserted = 0
        self.rows_updated = 0
        self.rows_read = 0
        self.queries_executed = 0
        self.stored_procs_called = 0
```

#### 1.2 Container Monitoring Client
**File:** `/Users/haipham/DuAn/upwork/etani/etl-packages/container_monitoring_client.py`

```python
class ContainerMonitoringClient:
    """Client for tracking container execution lifecycle"""

    def __init__(self, api_url: str, api_key: str):
        """Initialize client with API URL and key"""
        self.api_url = api_url.rstrip('/')
        self.api_key = api_key

    def start_container(self, integration, organisation_id, client_id, firm_id, job_id, job_run_id, trigger_type):
        """Start container logging via API call"""
        # Returns container_log_id for subsequent operations

    def complete_container(self, container_log_id, status, error_details):
        """Mark container as complete via API call"""
```

#### 1.3 Query Monitoring Client
**File:** `/Users/haipham/DuAn/upwork/etani/etl-packages/query_monitoring_client.py`

```python
class QueryMonitoringClient:
    """Tracks individual query performance"""

    def track_query(self, query_text, execution_time_ms, rows_examined, rows_affected, bytes_sent, table_names):
        """Track individual query metrics"""

    def submit_queries(self, container_log_id):
        """Submit all tracked queries to backend"""
```

---

## Cost Calculation Logic

### 1. AWS Fargate Cost Calculation

#### 1.1 Pricing Constants (ap-southeast-2)
```python
FARGATE_VCPU_HOURLY = 0.04048      # $0.04048 per vCPU per hour
FARGATE_MEMORY_HOURLY = 0.004445   # $0.004445 per GB per hour
```

#### 1.2 Cost Calculation Formula
```python
def calculate_fargate_cost(vcpu, memory_gb, duration_seconds):
    """
    Calculate AWS Fargate container cost

    Args:
        vcpu (float): Allocated vCPUs
        memory_gb (float): Allocated memory in GB
        duration_seconds (int): Runtime duration in seconds

    Returns:
        float: Total container cost in USD
    """
    hours = duration_seconds / 3600.0
    vcpu_cost = vcpu * FARGATE_VCPU_HOURLY * hours
    memory_cost = memory_gb * FARGATE_MEMORY_HOURLY * hours
    total_cost = vcpu_cost + memory_cost
    return round(total_cost, 4)
```

#### 1.3 Cost Calculation Examples
```python
# Example 1: Small container
vcpu = 0.25
memory_gb = 0.5
duration = 300  # 5 minutes

cost = calculate_fargate_cost(0.25, 0.5, 300)
# Result: ~$0.0011 USD

# Example 2: Medium container
vcpu = 1.0
memory_gb = 2.0
duration = 1800  # 30 minutes

cost = calculate_fargate_cost(1.0, 2.0, 1800)
# Result: ~$0.0242 USD

# Example 3: Large container
vcpu = 2.0
memory_gb = 4.0
duration = 3600  # 1 hour

cost = calculate_fargate_cost(2.0, 4.0, 3600)
# Result: ~$0.0979 USD
```

### 2. MySQL Aurora Serverless v2 I/O Cost

#### 2.1 Pricing Constants
```python
AURORA_IO_PRICE_PER_MILLION = 0.24  # $0.24 per 1M I/O operations (ap-southeast-2)
```

#### 2.2 I/O Estimation Logic
```python
def calculate_mysql_cost(self):
    """
    Calculate MySQL Aurora Serverless v2 I/O costs

    Logic:
    - Write operations: INSERT/UPDATE operations × 2 (data + index writes)
    - Read operations: SELECT operations × 1
    - Cost: Total I/O operations / 1,000,000 × $0.24

    Returns:
        dict: Detailed cost breakdown
    """
    with self._lock:
        # Estimate write I/Os (data + index writes)
        estimated_write_ios = (self.rows_inserted + self.rows_updated) * 2

        # Estimate read I/Os
        estimated_read_ios = self.rows_read * 1

        # Total I/O operations
        estimated_total_ios = estimated_write_ios + estimated_read_ios

        # Calculate cost
        mysql_io_cost_usd = (estimated_total_ios / 1_000_000) * AURORA_IO_PRICE_PER_MILLION

        return {
            'estimated_write_ios': estimated_write_ios,
            'estimated_read_ios': estimated_read_ios,
            'estimated_total_ios': estimated_total_ios,
            'mysql_io_cost_usd': round(mysql_io_cost_usd, 6)
        }
```

#### 2.3 MySQL Cost Examples
```python
# Example 1: INSERT operation
rows_inserted = 10000
rows_updated = 0
rows_read = 5000

write_ios = 10000 * 2 = 20000
read_ios = 5000 * 1 = 5000
total_ios = 25000
cost = (25000 / 1_000_000) * 0.24 = $0.006

# Example 2: UPSERT operation
rows_inserted = 5000
rows_updated = 8000
rows_read = 15000

write_ios = (5000 + 8000) * 2 = 26000
read_ios = 15000 * 1 = 15000
total_ios = 41000
cost = (41000 / 1_000_000) * 0.24 = $0.009840

# Example 3: RECONCILIATION operation
rows_inserted = 0
rows_updated = 0
rows_read = 50000

write_ios = 0 * 2 = 0
read_ios = 50000 * 1 = 50000
total_ios = 50000
cost = (50000 / 1_000_000) * 0.24 = $0.012
```

### 3. Total Cost Calculation
```python
def finalize(self, end_time, container_cost_usd, resource_metrics):
    """
    Calculate final total cost and prepare data for storage

    Args:
        end_time (datetime): ETL completion time
        container_cost_usd (float): Pre-calculated container cost
        resource_metrics (dict): Resource utilization data

    Returns:
        dict: Complete cost data for storage
    """
    # Calculate runtime
    runtime_seconds = int((end_time - self.start_time).total_seconds())

    # Get MySQL costs
    mysql_costs = self.calculate_mysql_cost()

    # Calculate total cost
    total_cost_usd = container_cost_usd + mysql_costs['mysql_io_cost_usd']

    # Prepare complete cost data
    return {
        # Identification
        'org_id': self.org_id,
        'client_id': self.client_id,
        'etani_client_id': self.etani_client_id,
        'integration_type': 'XEROBLUE',  # or dynamic
        'run_type': self.run_type,

        # Timing
        'run_start': self.start_time,
        'run_end': end_time,
        'runtime_seconds': runtime_seconds,

        # Operations
        'queries_executed': self.queries_executed,
        'stored_procs_called': self.stored_procs_called,
        'rows_inserted': self.rows_inserted,
        'rows_updated': self.rows_updated,
        'rows_read': self.rows_read,

        # I/O Estimates
        'estimated_write_ios': mysql_costs['estimated_write_ios'],
        'estimated_read_ios': mysql_costs['estimated_read_ios'],
        'estimated_total_ios': mysql_costs['estimated_total_ios'],

        # Costs
        'container_cost_usd': container_cost_usd,
        'mysql_io_cost_usd': mysql_costs['mysql_io_cost_usd'],
        'total_cost_usd': total_cost_usd,

        # Resource Metrics
        'container_vcpu': resource_metrics.get('vcpu', 0.0),
        'container_memory_gb': resource_metrics.get('memory_gb', 0.0),
        'container_size': resource_metrics.get('container_size', 'UNKNOWN'),
        'task_arn': resource_metrics.get('task_arn', '')
    }
```

---

## Database Schema

### 1. Container Logs Table

#### 1.1 Basic Container Logs (sp_add_container_logs)
**Table:** `vibedb_cms.container_logs`

```sql
CREATE TABLE container_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    integration VARCHAR(50),
    organisation_id INT,
    client_id INT,
    firm_id INT,
    start_date DATETIME,
    end_date DATETIME,
    status VARCHAR(50),
    log_id VARCHAR(64) UNIQUE,
    remarks LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 1.2 Enhanced Container Logs (update_container_logs)
**Extended Parameters:**

```sql
CALL sp_add_container_logs(
    p_integration VARCHAR(50),
    p_organisation_id INT,
    p_client_id INT,
    p_firm_id INT,
    p_start_date DATETIME,
    p_end_date DATETIME,
    p_status VARCHAR(50),
    p_log_id VARCHAR(255),
    p_remarks TEXT,
    p_platform VARCHAR(20),           -- 'AWS'
    p_region VARCHAR(50),             -- 'ap-southeast-2'
    p_container_name VARCHAR(100),    -- 'xero-etl-task-medium'
    p_duration_seconds INT,           -- Runtime in seconds
    p_trigger_type VARCHAR(50),       -- 'MANUAL', 'SCHEDULED'
    p_error_details TEXT,             -- Error summary
    p_vcpu DECIMAL(3,1),             -- Allocated vCPUs
    p_memory_gb DECIMAL(4,1),        -- Allocated memory GB
    p_ecs_task_id VARCHAR(100),      -- ECS task identifier
    p_cloudwatch_url VARCHAR(500),   -- CloudWatch logs URL
    p_task_definition VARCHAR(100),   -- Task definition name
    p_vcpu_allocated DECIMAL(3,1),   -- Same as p_vcpu
    p_memory_gb_allocated DECIMAL(4,1), -- Same as p_memory_gb
    p_cpu_peak_pct DECIMAL(5,2),     -- Peak CPU utilization %
    p_cpu_avg_pct DECIMAL(5,2),      -- Average CPU utilization %
    p_memory_peak_gb DECIMAL(5,3),   -- Peak memory usage GB
    p_memory_avg_gb DECIMAL(5,3),    -- Average memory usage GB
    p_recommended_size VARCHAR(20),   -- 'SMALL', 'NORMAL', 'MEDIUM', 'LARGE'
    p_cost_usd DECIMAL(8,4)          -- Total cost USD
);
```

---

## Implementation Details

### 1. Container Resource Metadata

#### 1.1 ECS Metadata Extraction
```python
def get_ecs_container_resources():
    """
    Extract container resource allocation from ECS metadata endpoint

    Returns:
        dict: {'vcpu': float, 'memory_gb': float}
    """
    try:
        # Get metadata URI from environment
        metadata_uri = os.getenv('ECS_CONTAINER_METADATA_URI_V4')
        if not metadata_uri:
            return {'vcpu': 0.0, 'memory_gb': 0.0}

        # Fetch container metadata
        response = requests.get(f"{metadata_uri}/stats", timeout=5)
        container_metadata = response.json()

        # Try to get limits from container level first
        limits = container_metadata.get('limits', {})

        # Fallback to task-level metadata if container limits not available
        if not limits:
            task_response = requests.get(f"{metadata_uri}/task/stats", timeout=5)
            task_metadata = task_response.json()
            limits = task_metadata.get('limits', {})

        # Extract vCPU and memory
        vcpu = limits.get('CPU', 0) / 1024.0  # ECS CPU units to vCPUs
        memory_bytes = limits.get('Memory', 0)
        memory_gb = memory_bytes / (1024 * 1024 * 1024)  # Bytes to GB

        # Fallback: Infer from task family name if metadata incomplete
        if vcpu == 0.0 or memory_gb == 0.0:
            task_definition = get_ecs_task_definition()
            vcpu, memory_gb = infer_resources_from_task_name(task_definition)

        return {
            'vcpu': vcpu,
            'memory_gb': memory_gb
        }

    except Exception as e:
        print(f"⚠️ Warning: Could not fetch ECS resources: {str(e)}")
        # Return default values
        return {'vcpu': 1.0, 'memory_gb': 2.0}

def infer_resources_from_task_name(task_definition):
    """
    Infer container size from task definition name

    Args:
        task_definition (str): Task definition name like 'xero-etl-task-medium'

    Returns:
        tuple: (vcpu, memory_gb)
    """
    if not task_definition:
        return 1.0, 2.0

    task_lower = task_definition.lower()

    if 'small' in task_lower:
        return 0.25, 0.5
    elif 'medium' in task_lower:
        return 1.0, 2.0
    elif 'large' in task_lower:
        return 2.0, 4.0
    elif 'xlarge' in task_lower:
        return 4.0, 8.0
    else:
        return 1.0, 2.0  # Default
```

#### 1.2 Task Metadata Extraction
```python
def get_ecs_task_definition():
    """Extract task definition name from ECS metadata"""
    try:
        metadata_uri = os.getenv('ECS_CONTAINER_METADATA_URI_V4')
        response = requests.get(f"{metadata_uri}/task", timeout=5)
        task_metadata = response.json()

        task_arn = task_metadata.get('TaskARN', '')
        # Example: arn:aws:ecs:region:account:task-definition/xero-etl-task-medium:123
        if task_arn:
            parts = task_arn.split('/')
            if len(parts) >= 2:
                return parts[-1].split(':')[0]  # Extract 'xero-etl-task-medium'

        return 'unknown'

    except Exception as e:
        print(f"⚠️ Warning: Could not fetch task definition: {str(e)}")
        return 'unknown'

def get_ecs_task_id():
    """Extract ECS task ID for CloudWatch linking"""
    try:
        metadata_uri = os.getenv('ECS_CONTAINER_METADATA_URI_V4')
        response = requests.get(f"{metadata_uri}/task", timeout=5)
        task_metadata = response.json()

        task_arn = task_metadata.get('TaskARN', '')
        # Extract task ID from ARN
        if task_arn:
            return task_arn.split('/')[-1]

        return ''

    except Exception as e:
        print(f"⚠️ Warning: Could not fetch task ID: {str(e)}")
        return ''
```

#### 1.3 Caching Functions
```python
# Global caches
_cached_ecs_resources = None
_cached_ecs_task_id = None
_cached_task_definition = None

def get_cached_ecs_resources():
    """Cache ECS resources for container lifetime"""
    global _cached_ecs_resources
    if _cached_ecs_resources is None:
        _cached_ecs_resources = get_ecs_container_resources()
    return _cached_ecs_resources

def get_cached_ecs_task_id():
    """Cache ECS task ID for container lifetime"""
    global _cached_ecs_task_id
    if _cached_ecs_task_id is None:
        _cached_ecs_task_id = get_ecs_task_id()
    return _cached_ecs_task_id

def get_cached_task_definition():
    """Cache task definition for container lifetime"""
    global _cached_task_definition
    if _cached_task_definition is None:
        _cached_task_definition = get_ecs_task_definition()
    return _cached_task_definition
```

### 2. Cost Tracker Operations

#### 2.1 Thread-Safe Operation Tracking
```python
def track_operation(self, operation_type, rows_affected=0):
    """
    Thread-safe tracking of database operations

    Args:
        operation_type (str): 'INSERT', 'UPDATE', 'SELECT', 'STORED_PROC'
        rows_affected (int): Number of rows affected by operation
    """
    with self._lock:
        if operation_type == 'INSERT':
            self.rows_inserted += rows_affected
        elif operation_type == 'UPDATE':
            self.rows_updated += rows_affected
        elif operation_type == 'SELECT':
            self.rows_read += rows_affected
        elif operation_type == 'STORED_PROC':
            self.stored_procs_called += 1

        self.queries_executed += 1
```

#### 2.2 Integration Points in sql_helper.py
```python
# Global cost tracker instance (set by ETL script)
cost_tracker = None

def LoadToEvaStageTable(df, database_name, table_name, client_id, organisation_id, error_list,
                        integration_name='', if_exists='append'):
    """Load DataFrame to stage table with cost tracking"""
    try:
        # ... existing load logic ...

        # Track cost after successful load
        total_rows_inserted = len(df)
        if cost_tracker:
            cost_tracker.track_operation('INSERT', total_rows_inserted)

    except Exception as e:
        # ... error handling ...

def ExecuteEvaSP(sp_name, parameters, endpoint, error_list, client_id, organisation_id, integration_name=''):
    """Execute stored procedure with cost tracking"""
    try:
        # ... existing execution logic ...

        # Track cost
        rows_affected = cursor.rowcount
        if cost_tracker:
            cost_tracker.track_operation('STORED_PROC', rows_affected or 0)

    except Exception as e:
        # ... error handling ...

def ReadMySQLTable(query, endpoint, client_id, organisation_id, error_list,
                   IsCMS=False, integration_name='', return_connection=False):
    """Execute SELECT query with cost tracking"""
    try:
        # ... existing query execution ...

        # Track cost
        row_count = len(df)
        if cost_tracker:
            cost_tracker.track_operation('SELECT', row_count)

        return df

    except Exception as e:
        # ... error handling ...
```

---

## Integration Patterns

### 1. XEROBLUE - INSERT.py Pattern

#### 1.1 Initialization
```python
import sql_helper
from etl_cost_tracker import ETLCostTracker
# Timing
start_time = datetime.now()

# Initialize cost tracker
cost_tracker = ETLCostTracker(
    org_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber),
    etani_client_id=EtaniClientID,
    run_type='INSERT',
    start_time=start_time
)

# Make globally accessible for sql_helper functions
sql_helper.cost_tracker = cost_tracker

# Start container logging using helper function
container_log_id = start_container_log(
    integration='XEROBLUE',
    organisation_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber),
    firm_id=int(FirmID),
    job_id=int(os.getenv('JOB_ID', '0')),
    job_run_id=int(os.getenv('JOB_RUN_ID', '0')),
    trigger_type=os.getenv('TRIGGER_TYPE', 'MANUAL')
)
```

#### 1.2 ETL Execution
```python
# Process each endpoint
for endpoint in endpoints:
    try:
        # Extract data from API
        data = extract_api_data(endpoint)

        # Load to stage table (automatically tracked by LoadToEvaStageTable)
        LoadToEvaStageTable(data, database_name, stage_table, client_id, organisation_id, error_list, 'XEROBLUE')

        # Execute stored procedure (automatically tracked by ExecuteEvaSP)
        ExecuteEvaSP(sp_name, parameters, endpoint, error_list, client_id, organisation_id, 'XEROBLUE')

        # Read production count (automatically tracked by ReadMySQLTable)
        count_df = ReadMySQLTable(count_query, endpoint, client_id, organisation_id, error_list, integration_name='XEROBLUE')

    except Exception as e:
        # Handle endpoint errors
        pass
```

#### 1.3 Finalization
```python
# Stop timing
end_time = datetime.now()

# Get default resource metrics
final_resource_metrics = {
    'vcpu': 2.0,
    'memory_gb': 4.0,
    'peak_cpu_percent': 0.0,
    'avg_cpu_percent': 0.0,
    'peak_memory_gb': 0.0,
    'memory_gb': 0.0,
    'container_size': 'UNKNOWN'
}

# Get container resource allocation
resources = get_cached_ecs_resources()
vcpu = resources['vcpu']
memory_gb = resources['memory_gb']

# Calculate container cost
duration = int((end_time - start_time).total_seconds())
container_cost_usd = calculate_fargate_cost(vcpu, memory_gb, duration)

# Finalize cost tracking
cost_data = cost_tracker.finalize(
    end_time=end_time,
    container_cost_usd=container_cost_usd,
    resource_metrics=final_resource_metrics
)

# Update container logs with final details
container_params = {
    'log_id': container_log_id,
    'integration': 'XEROBLUE',
    'organisation_id': int(EtaniOrganisationID),
    'client_id': int(ClientIdNumber),
    'firm_id': int(FirmID),
    'start_date': start_time,
    'end_date': end_time,
    'status': 'Completed',
    'remarks': f'INSERT completed successfully',
    'platform': 'AWS',
    'region': 'ap-southeast-2',
    'container_name': get_cached_task_definition(),
    'duration_seconds': duration,
    'trigger_type': os.getenv('TRIGGER_TYPE', 'MANUAL'),
    'error_details': '',
    'vcpu': vcpu,
    'memory_gb': memory_gb,
    'ecs_task_id': get_cached_ecs_task_id(),
    'cloudwatch_url': generate_cloudwatch_url(),
    'task_definition': get_cached_task_definition(),
    'vcpu_allocated': vcpu,
    'memory_gb_allocated': memory_gb,
    'cpu_peak_pct': final_resource_metrics.get('peak_cpu_percent', 0.0),
    'cpu_avg_pct': final_resource_metrics.get('avg_cpu_percent', 0.0),
    'memory_peak_gb': final_resource_metrics.get('peak_memory_gb', 0.0),
    'memory_avg_gb': final_resource_metrics.get('memory_gb', 0.0),
    'recommended_size': final_resource_metrics.get('container_size', 'UNKNOWN'),
    'cost_usd': cost_data['total_cost_usd']
}

update_container_logs(container_params)

# Submit query logs
submit_query_logs(container_log_id)

# Complete container logging
complete_container_log('success', '')

# Print cost summary
print(f"💰 Total Run Cost: ${cost_data['total_cost_usd']:.6f}")
print(f"   - Container: ${cost_data['container_cost_usd']:.6f}")
print(f"   - MySQL I/O: ${cost_data['mysql_io_cost_usd']:.6f}")
print(f"📊 Operations: {cost_data['queries_executed']} queries, {cost_data['stored_procs_called']} stored procedures")
print(f"📈 Data: {cost_data['rows_inserted']} inserted, {cost_data['rows_read']} read")
```

### 2. XEROBLUE - UPSERT.py Pattern

Same pattern as INSERT.py with these differences:
```python
# Initialize with different run_type
cost_tracker = ETLCostTracker(
    org_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber),
    etani_client_id=EtaniClientID,
    run_type='UPSERT',  # Different run type
    start_time=start_time
)
```

### 3. XEROBLUE - RECONCILIATION.py Pattern

#### 3.1 Key Differences
```python
# RECONCILIATION uses hardcoded default metrics

# Initialize cost tracker
cost_tracker = ETLCostTracker(
    org_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber),
    etani_client_id=EtaniClientID,
    run_type='RECONCILIATION',
    start_time=start_time
)

# ... ETL processing ...

# Finalization with hardcoded metrics
end_time = datetime.now()
duration = int((end_time - start_time).total_seconds())

# Hardcoded resource metrics for RECONCILIATION
default_resource_metrics = {
    'vcpu': 0.25,
    'memory_gb': 0.5,
    'peak_cpu_percent': 0.0,
    'avg_cpu_percent': 0.0,
    'peak_memory_gb': 0.0,
    'memory_gb': 0.5,
    'container_size': 'SMALL'
}

# Calculate cost with hardcoded resources
container_cost_usd = calculate_fargate_cost(0.25, 0.5, duration)

# Finalize with default metrics
cost_data = cost_tracker.finalize(
    end_time=end_time,
    container_cost_usd=container_cost_usd,
    resource_metrics=default_resource_metrics
)
```

---

## API Integration

### 1. Container Monitoring

#### 1.2 Container Size Determination Logic
```python
def determine_container_size(vcpu, memory_gb, peak_cpu_percent, peak_memory_gb):
    """
    Recommend optimal container size based on utilization

    Args:
        vcpu (float): Allocated vCPUs
        memory_gb (float): Allocated memory GB
        peak_cpu_percent (float): Peak CPU utilization %
        peak_memory_gb (float): Peak memory usage GB

    Returns:
        str: Recommended container size
    """
    # Calculate utilization ratios
    cpu_utilization = peak_cpu_percent / 100.0
    memory_utilization = peak_memory_gb / memory_gb if memory_gb > 0 else 0.0

    # Determine if over/under-utilized
    is_cpu_overutilized = cpu_utilization > 0.80
    is_memory_overutilized = memory_utilization > 0.80
    is_cpu_underutilized = cpu_utilization < 0.30
    is_memory_underutilized = memory_utilization < 0.30

    # Recommendation logic
    if is_cpu_overutilized or is_memory_overutilized:
        if vcpu >= 2.0:
            return 'LARGE'
        elif vcpu >= 1.0:
            return 'MEDIUM'
        else:
            return 'NORMAL'
    elif is_cpu_underutilized and is_memory_underutilized:
        if vcpu <= 0.5:
            return 'SMALL'
        elif vcpu <= 1.0:
            return 'SMALL'
        else:
            return 'NORMAL'
    else:
        # Current size is appropriate
        if vcpu <= 0.5:
            return 'SMALL'
        elif vcpu <= 1.0:
            return 'NORMAL'
        elif vcpu <= 2.0:
            return 'MEDIUM'
        else:
            return 'LARGE'
```

#### 1.3 Integration in ETL Scripts
```python
# Check if resource tracking is enabled
RESOURCE_TRACKING_ENABLED = True
try:
    from resource_tracker import start_tracking, stop_tracking
except ImportError:
    RESOURCE_TRACKING_ENABLED = False
    print("⚠️ Resource tracker not available - using default metrics")

# Start tracking if available
if RESOURCE_TRACKING_ENABLED:
    start_tracking(sample_interval=10.0)

# ... ETL processing ...

# Stop tracking and get metrics
final_resource_metrics = {}
if RESOURCE_TRACKING_ENABLED:
    try:
        final_resource_metrics = stop_tracking()
    except Exception as e:
        print(f"⚠️ Resource tracking failed: {str(e)}")
        final_resource_metrics = get_default_resource_metrics()
else:
    final_resource_metrics = get_default_resource_metrics()

def get_default_resource_metrics():
    """Fallback resource metrics when tracker not available"""
    resources = get_cached_ecs_resources()
    return {
        'vcpu': resources['vcpu'],
        'memory_gb': resources['memory_gb'],
        'peak_cpu_percent': 0.0,
        'avg_cpu_percent': 0.0,
        'peak_memory_gb': 0.0,
        'memory_gb': resources['memory_gb'],
        'container_size': 'UNKNOWN'
    }
```

---

## API Integration

### 1. Helper Functions

#### 1.1 Container Logging Helpers
**File:** `/Users/haipham/DuAn/upwork/etani/etl-packages/sql_helper.py`

```python
def start_container_log(integration: str, organisation_id: int, client_id: int = None,
                       firm_id: int = None, job_id: int = None, job_run_id: int = None,
                       trigger_type: str = None):
    """
    Create a container log entry at the start of ETL execution.
    Returns container_log_id for subsequent operations
    """

def complete_container_log(status: str = "success", error_details: str = None):
    """
    Mark the container log as complete.
    """

def submit_query_logs(container_log_id=None):
    """
    Submit all tracked queries to the API.
    Returns dict with logged_count and slow_queries_detected
    """
```

### 2. Implementation Notes

The container cost tracking system uses helper functions from `sql_helper.py` that internally handle:
- Container lifecycle management via API calls
- Query performance logging
- Cost data storage in container_logs table
- Error handling and graceful degradation

The ContainerMonitoringClient and QueryMonitoringClient classes exist for direct API access but are abstracted away by the helper functions.

---

## Error Handling

### 1. Graceful Degradation Principles

#### 1.1 Cost Tracking Failures
```python
def safe_cost_tracking_operation(operation_func, *args, **kwargs):
    """
    Wrapper for cost tracking operations with graceful degradation

    Principle: Cost tracking failures should NEVER crash the ETL job
    """
    try:
        return operation_func(*args, **kwargs)
    except Exception as e:
        print(f"⚠️ Warning: Cost tracking operation failed: {str(e)}")
        # Log the error but don't re-raise
        return None
```

#### 1.2 Database Storage Failures
```python
def update_container_logs_safely(cost_data):
    """
    Update container logs with error handling
    """
    try:
        # ... database operations ...
        print(f"💾 Container logs updated successfully")
    except Exception as e:
        # Don't raise exception - graceful degradation
        print(f"⚠️ Warning: Failed to update container logs: {str(e)}")
        print(f"💰 Cost Summary: Total=${cost_data.get('total_cost_usd', 0):.6f}")

def update_container_logs(params):
    """
    Update container logs with error handling
    """
    try:
        # ... update operations ...
        print(f"📝 Container logs updated")
    except Exception as e:
        print(f"⚠️ Warning: Failed to update container logs: {str(e)}")
        # Don't raise - let ETL continue
```

#### 1.3 Resource Tracking Failures
```python
# Check availability at import time
RESOURCE_TRACKING_ENABLED = True
try:
    from resource_tracker import start_tracking, stop_tracking
except ImportError:
    RESOURCE_TRACKING_ENABLED = False

    # Define no-op fallback functions
    def start_tracking(sample_interval=10.0):
        pass

    def stop_tracking():
        return {}

# Use with error handling
if RESOURCE_TRACKING_ENABLED:
    try:
        final_resource_metrics = stop_tracking()
    except Exception as e:
        print(f"⚠️ Resource tracking error: {str(e)}")
        final_resource_metrics = get_default_metrics()
else:
    final_resource_metrics = get_default_metrics()
```

#### 1.4 API Communication Failures
```python
def start_container_log(integration, organisation_id, client_id, firm_id, job_id, job_run_id, trigger_type):
    """Start container logging with fallback"""
    try:
        client = ContainerMonitoringClient(ETL_API_URL, ETL_API_KEY)
        container_log_id = client.start_container(integration, organisation_id, client_id, firm_id, job_id, job_run_id, trigger_type)

        if container_log_id:
            print(f"📝 Container logging started: {container_log_id}")
            return container_log_id
        else:
            print(f"⚠️ Container logging API returned no ID")
            return generate_fallback_log_id()

    except Exception as e:
        print(f"⚠️ Container logging failed: {str(e)}")
        return generate_fallback_log_id()

def generate_fallback_log_id():
    """Generate fallback log ID when API fails"""
    import uuid
    fallback_id = str(uuid.uuid4())
    print(f"🔄 Using fallback log ID: {fallback_id}")
    return fallback_id
```

### 2. Error Logging Patterns

#### 2.1 Cost Calculation Errors
```python
def calculate_fargate_cost(vcpu, memory_gb, duration_seconds):
    """Calculate Fargate cost with validation"""
    try:
        # Validate inputs
        if not all(isinstance(x, (int, float)) and x >= 0 for x in [vcpu, memory_gb, duration_seconds]):
            print(f"⚠️ Invalid cost calculation inputs: vcpu={vcpu}, memory_gb={memory_gb}, duration={duration_seconds}")
            return 0.0

        # Perform calculation
        hours = duration_seconds / 3600.0
        vcpu_cost = vcpu * FARGATE_VCPU_HOURLY * hours
        memory_cost = memory_gb * FARGATE_MEMORY_HOURLY * hours
        total_cost = vcpu_cost + memory_cost

        # Validate result
        if total_cost < 0 or total_cost > 100.0:  # Sanity check: < $100
            print(f"⚠️ Suspicious cost calculation result: ${total_cost:.6f}")

        return round(total_cost, 4)

    except Exception as e:
        print(f"❌ Cost calculation failed: {str(e)}")
        return 0.0
```

#### 2.2 Database Connection Errors
```python
def get_cms_connection():
    """Get CMS database connection with retry logic"""
    max_retries = 3
    for attempt in range(max_retries):
        try:
            connection = pymysql.connect(
                host=CMS_DB_HOST,
                user=CMS_DB_USER,
                password=CMS_DB_PASSWORD,
                database='vibedb_cms',
                charset='utf8mb4'
            )
            return connection
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"⚠️ Database connection attempt {attempt + 1} failed, retrying...")
                time.sleep(2 ** attempt)  # Exponential backoff
            else:
                print(f"❌ All database connection attempts failed: {str(e)}")
                raise
```

---

## Code Examples

### 1. Complete Integration Example

```python
# complete_integration_example.py
"""
Complete example of container cost tracking integration
Following the xero-aws-only pattern
"""

import os
import time
from datetime import datetime
import pymysql
import requests

# Import cost tracking modules
from etl_cost_tracker import ETLCostTracker
from container_monitoring_client import ContainerMonitoringClient
from query_monitoring_client import QueryMonitoringClient

# Try to import resource tracker
RESOURCE_TRACKING_ENABLED = True
try:
    from resource_tracker import start_tracking, stop_tracking
except ImportError:
    RESOURCE_TRACKING_ENABLED = False
    def start_tracking(sample_interval=10.0): pass
    def stop_tracking(): return {}

def main():
    """Complete integration example"""

    # Configuration
    EtaniOrganisationID = "1755241477"
    ClientIdNumber = "1906"
    EtaniClientID = "BIGOLESHOECOMPANY_CLIENT1906"
    FirmID = "123"

    # Timing
    start_time = datetime.now()
    print(f"🚀 Starting MYOB integration at {start_time}")

    # Start resource tracking
    if RESOURCE_TRACKING_ENABLED:
        start_tracking(sample_interval=10.0)
        print("📊 Resource tracking started")
    else:
        print("⚠️ Resource tracking not available")

    # Initialize cost tracker
    cost_tracker = ETLCostTracker(
        org_id=int(EtaniOrganisationID),
        client_id=int(ClientIdNumber),
        etani_client_id=EtaniClientID,
        run_type='INSERT',
        start_time=start_time
    )

    # Make globally accessible
    import sql_helper
    sql_helper.cost_tracker = cost_tracker
    print("💰 Cost tracker initialized")

    # Start container logging
    container_log_id = start_container_log(
        integration='MYOB_DETAILED',
        organisation_id=int(EtaniOrganisationID),
        client_id=int(ClientIdNumber),
        firm_id=int(FirmID),
        job_id=int(os.getenv('JOB_ID', '0')),
        job_run_id=int(os.getenv('JOB_RUN_ID', '0')),
        trigger_type=os.getenv('TRIGGER_TYPE', 'MANUAL')
    )

    try:
        # Simulate ETL processing
        print("🔄 Processing endpoints...")

        # Process endpoint 1
        simulate_endpoint_processing('Contact', cost_tracker)

        # Process endpoint 2
        simulate_endpoint_processing('Invoice', cost_tracker)

        # Process endpoint 3
        simulate_endpoint_processing('Account', cost_tracker)

        status = 'Completed'
        error_details = None

    except Exception as e:
        print(f"❌ Integration failed: {str(e)}")
        status = 'Failed'
        error_details = str(e)

    # Stop timing
    end_time = datetime.now()
    duration = int((end_time - start_time).total_seconds())
    print(f"⏱️ Integration completed in {duration} seconds")

    # Get resource metrics
    final_resource_metrics = {}
    if RESOURCE_TRACKING_ENABLED:
        try:
            final_resource_metrics = stop_tracking()
            print(f"📈 Resource metrics collected")
        except Exception as e:
            print(f"⚠️ Resource tracking failed: {str(e)}")
            final_resource_metrics = get_default_resource_metrics()
    else:
        final_resource_metrics = get_default_resource_metrics()

    # Get container resources
    resources = get_cached_ecs_resources()
    vcpu = resources['vcpu']
    memory_gb = resources['memory_gb']

    # Calculate container cost
    container_cost_usd = calculate_fargate_cost(vcpu, memory_gb, duration)
    print(f"💳 Container cost: ${container_cost_usd:.6f}")

    # Finalize cost tracking
    cost_data = cost_tracker.finalize(
        end_time=end_time,
        container_cost_usd=container_cost_usd,
        resource_metrics=final_resource_metrics
    )

    # Update container logs
    update_container_logs_complete(container_log_id, start_time, end_time, status, error_details, final_resource_metrics, cost_data)

    # Submit query logs
    submit_query_logs(container_log_id)

    # Complete container via API
    complete_container(container_log_id, status, error_details)

    # Print final summary
    print_cost_summary(cost_data)

def simulate_endpoint_processing(endpoint_name, cost_tracker):
    """Simulate processing of an endpoint with cost tracking"""
    print(f"📊 Processing {endpoint_name}...")

    # Simulate API data extraction
    time.sleep(0.5)

    # Simulate database operations with cost tracking
    rows_inserted = 1000
    cost_tracker.track_operation('INSERT', rows_inserted)

    rows_read = 500
    cost_tracker.track_operation('SELECT', rows_read)

    cost_tracker.track_operation('STORED_PROC', 0)

    print(f"✅ {endpoint_name} completed: {rows_inserted} inserted, {rows_read} read")

def get_default_resource_metrics():
    """Default resource metrics when tracker unavailable"""
    resources = get_cached_ecs_resources()
    return {
        'vcpu': resources['vcpu'],
        'memory_gb': resources['memory_gb'],
        'peak_cpu_percent': 75.0,  # Estimated
        'avg_cpu_percent': 50.0,   # Estimated
        'peak_memory_gb': resources['memory_gb'] * 0.8,  # 80% utilization
        'memory_gb': resources['memory_gb'] * 0.6,       # 60% average
        'container_size': 'NORMAL'
    }

def print_cost_summary(cost_data):
    """Print detailed cost summary"""
    print("\n" + "="*60)
    print("💰 COST SUMMARY")
    print("="*60)
    print(f"Total Cost:     ${cost_data['total_cost_usd']:.6f}")
    print(f"  - Container:  ${cost_data['container_cost_usd']:.6f}")
    print(f"  - MySQL I/O:  ${cost_data['mysql_io_cost_usd']:.6f}")
    print()
    print(f"Operations:     {cost_data['queries_executed']} queries")
    print(f"                {cost_data['stored_procs_called']} stored procedures")
    print()
    print(f"Data:           {cost_data['rows_inserted']:,} rows inserted")
    print(f"                {cost_data['rows_updated']:,} rows updated")
    print(f"                {cost_data['rows_read']:,} rows read")
    print()
    print(f"I/O Estimate:   {cost_data['estimated_total_ios']:,} total operations")
    print(f"                {cost_data['estimated_write_ios']:,} write I/Os")
    print(f"                {cost_data['estimated_read_ios']:,} read I/Os")
    print()
    print(f"Runtime:        {cost_data['runtime_seconds']} seconds")
    print(f"Container:      {cost_data['container_vcpu']} vCPU, {cost_data['container_memory_gb']} GB")
    print(f"Size:           {cost_data['container_size']}")
    print("="*60)

if __name__ == "__main__":
    main()
```

### 2. Cost Calculation Examples

```python
# cost_calculation_examples.py
"""
Examples of cost calculations for different scenarios
"""

def example_small_integration():
    """Small integration example"""
    print("📊 Small Integration Example")
    print("-" * 40)

    # Container: 0.25 vCPU, 0.5 GB, 5 minutes
    container_cost = calculate_fargate_cost(0.25, 0.5, 300)

    # Operations: Light data processing
    rows_inserted = 1000
    rows_read = 500

    # MySQL cost calculation
    write_ios = rows_inserted * 2  # 2000 write I/Os
    read_ios = rows_read * 1       # 500 read I/Os
    total_ios = write_ios + read_ios  # 2500 total I/Os
    mysql_cost = (total_ios / 1_000_000) * 0.24  # $0.0006

    total_cost = container_cost + mysql_cost

    print(f"Container: {0.25} vCPU, {0.5} GB, 5 min = ${container_cost:.6f}")
    print(f"MySQL I/O: {total_ios:,} operations = ${mysql_cost:.6f}")
    print(f"Total: ${total_cost:.6f}")
    print()

def example_medium_integration():
    """Medium integration example"""
    print("📊 Medium Integration Example")
    print("-" * 40)

    # Container: 1.0 vCPU, 2.0 GB, 30 minutes
    container_cost = calculate_fargate_cost(1.0, 2.0, 1800)

    # Operations: Moderate data processing
    rows_inserted = 50000
    rows_updated = 10000
    rows_read = 25000

    # MySQL cost calculation
    write_ios = (rows_inserted + rows_updated) * 2  # 120,000 write I/Os
    read_ios = rows_read * 1                        # 25,000 read I/Os
    total_ios = write_ios + read_ios                # 145,000 total I/Os
    mysql_cost = (total_ios / 1_000_000) * 0.24    # $0.0348

    total_cost = container_cost + mysql_cost

    print(f"Container: {1.0} vCPU, {2.0} GB, 30 min = ${container_cost:.6f}")
    print(f"MySQL I/O: {total_ios:,} operations = ${mysql_cost:.6f}")
    print(f"Total: ${total_cost:.6f}")
    print()

def example_large_integration():
    """Large integration example"""
    print("📊 Large Integration Example")
    print("-" * 40)

    # Container: 2.0 vCPU, 4.0 GB, 2 hours
    container_cost = calculate_fargate_cost(2.0, 4.0, 7200)

    # Operations: Heavy data processing
    rows_inserted = 500000
    rows_updated = 200000
    rows_read = 300000

    # MySQL cost calculation
    write_ios = (rows_inserted + rows_updated) * 2  # 1,400,000 write I/Os
    read_ios = rows_read * 1                        # 300,000 read I/Os
    total_ios = write_ios + read_ios                # 1,700,000 total I/Os
    mysql_cost = (total_ios / 1_000_000) * 0.24    # $0.4080

    total_cost = container_cost + mysql_cost

    print(f"Container: {2.0} vCPU, {4.0} GB, 2 hours = ${container_cost:.6f}")
    print(f"MySQL I/O: {total_ios:,} operations = ${mysql_cost:.6f}")
    print(f"Total: ${total_cost:.6f}")
    print()

def example_reconciliation_only():
    """Reconciliation-only example"""
    print("📊 Reconciliation-Only Example")
    print("-" * 40)

    # Container: 0.25 vCPU, 0.5 GB, 10 minutes
    container_cost = calculate_fargate_cost(0.25, 0.5, 600)

    # Operations: Only reads for reconciliation
    rows_inserted = 0
    rows_updated = 0
    rows_read = 100000

    # MySQL cost calculation
    write_ios = 0                                   # No writes
    read_ios = rows_read * 1                        # 100,000 read I/Os
    total_ios = write_ios + read_ios                # 100,000 total I/Os
    mysql_cost = (total_ios / 1_000_000) * 0.24    # $0.0240

    total_cost = container_cost + mysql_cost

    print(f"Container: {0.25} vCPU, {0.5} GB, 10 min = ${container_cost:.6f}")
    print(f"MySQL I/O: {total_ios:,} operations (read-only) = ${mysql_cost:.6f}")
    print(f"Total: ${total_cost:.6f}")
    print()

if __name__ == "__main__":
    example_small_integration()
    example_medium_integration()
    example_large_integration()
    example_reconciliation_only()
```

---

## Summary

This comprehensive specification documents the complete container cost tracking system from the `xero-aws-only` branch. The system provides:

### Key Components:
1. **ETLCostTracker**: Thread-safe cost tracking throughout ETL operations
2. **Container Resource Detection**: Automatic ECS metadata extraction
3. **Dual Cost Calculation**: Fargate container costs + MySQL I/O costs
4. **Container Logging**: Cost tracking via `sp_add_container_logs` stored procedure
5. **Query Monitoring**: SQL query performance tracking via `submit_query_logs`
6. **Graceful Error Handling**: Non-disruptive failure modes

### Cost Model:
- **Container**: vCPU × $0.04048/hr + Memory × $0.004445/hr (ap-southeast-2)
- **MySQL I/O**: (Write I/Os + Read I/Os) / 1M × $0.24
- **Write I/Os**: (Inserts + Updates) × 2 (data + index)
- **Read I/Os**: Selects × 1

### Integration Pattern:
1. Initialize cost tracker and start container logging
2. Make tracker globally available via `sql_helper.cost_tracker`
3. Automatic operation tracking in database functions
4. Calculate final costs and update container logs
5. Update container logs with complete metadata
6. Submit query logs and complete API logging

This specification can serve as a complete implementation guide for adding comprehensive cost tracking to any ETL system following the same architectural patterns.