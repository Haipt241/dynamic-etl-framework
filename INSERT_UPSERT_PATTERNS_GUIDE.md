# INSERT và UPSERT Patterns Guide

**Branch:** `xero-aws-only`
**Files:** `xero_etl_entrypoint.py`, `XEROBLUE - INSERT.py`, `XEROBLUE - UPSERT.py`

---

## 1. INSERT VS UPSERT ROUTING LOGIC

### Core File: `xero_etl_entrypoint.py`

### Decision Logic
```python
def check_table_exists(client_id: int, firm_code: str) -> bool:
    """
    Kiểm tra table có tồn tại không để quyết định chạy INSERT hay UPSERT

    Returns:
        True = Run UPSERT (incremental update)
        False = Run INSERT (initial full load)
    """
    # Sanitize firm code
    sanitized_firm_code = sanitize_firmcode(firm_code)  # "sw-au" → "SWAU"
    database_name = f"vibedb_{sanitized_firm_code}"
    table_name = f"c{client_id}_xeroblue_transactions"

    print(f"🔍 Checking if table exists: {database_name}.{table_name}")

    # Connect to database
    connection = pymysql.connect(
        host=db_params['host'],
        port=int(db_params['port']),
        user=db_params['user'],
        password=db_params['password'],
        ssl=db_params.get('ssl'),
        connect_timeout=30
    )

    with connection.cursor() as cursor:
        # Check information_schema.tables
        query = """
            SELECT COUNT(*) as table_count
            FROM information_schema.tables
            WHERE table_schema = %s AND table_name = %s
        """
        cursor.execute(query, (database_name, table_name))
        result = cursor.fetchone()
        table_exists = result[0] > 0

        if table_exists:
            print(f"✓ Table {table_name} exists → Run UPSERT")
        else:
            print(f"✗ Table {table_name} không tồn tại → Run INSERT")

        return table_exists
```

### Execution Flow
```python
# Main execution logic
client_id = int(ClientIdNumber)
firm_code = os.environ.get('FIRMCODE')

if check_table_exists(client_id, firm_code):
    # Table tồn tại → chạy UPSERT (incremental)
    script_name = "XEROBLUE - UPSERT.py"
else:
    # Table chưa có → chạy INSERT (full load)
    script_name = "XEROBLUE - INSERT.py"

# Run script with 8-hour timeout
result = subprocess.run(
    ['python3', '-u', script_name],
    timeout=28800,  # 8 hours for large orgs
    env=os.environ.copy()
)
```

---

## 2. INSERT PATTERN (Initial Full Load)

### File: `XEROBLUE - INSERT.py`

### Logic Flow
1. **Fetch All Data** - Không dùng `If-Modified-Since` header
2. **Create Stage Tables** - Tạo temporary tables cho staging
3. **Data Transformation** - FX conversion, calculations
4. **Load to Production** - Call SQL stored procedures

### Key Implementation
```python
def xero_requests_insert(endpoint, params=None):
    """
    INSERT mode: Fetch tất cả data, không filter theo modified date
    """
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Xero-tenant-id': xero_tenant_id,
        'Accept': 'application/json'
    }

    # KHÔNG thêm If-Modified-Since header
    # Fetch tất cả data từ đầu

    response = requests.get(endpoint_url, headers=headers, params=params)
    return response.json()

# Example: Fetch all invoices
all_invoices = xero_requests_insert('https://api.xero.com/api.xro/2.0/Invoices')
```

### Stage Table Creation
```sql
-- Tạo stage table cho INSERT
CREATE TABLE IF NOT EXISTS c0000_0001_xeroblue_invoicesstage (
    `InvoiceId` VARCHAR(100),
    `Type` VARCHAR(100),
    `Contact` VARCHAR(255),
    `LineItem_Description` TEXT,
    `LineItem_LineAmount` DECIMAL(15, 4),
    `UpdatedDateUTC` DATETIME,
    `ClientID` VARCHAR(255),
    `OrganisationID` INT,
    -- staging columns for processing
    `ProcessingStatus` VARCHAR(50) DEFAULT 'PENDING'
);
```

### Data Processing Flow
```python
# INSERT processing steps
def process_insert_data():
    # 1. Fetch all endpoints
    endpoints = ['Invoices', 'Contacts', 'Accounts', 'Payments', ...]

    for endpoint in endpoints:
        # 2. Fetch all data (no modified filter)
        data = xero_requests_insert(endpoint)

        # 3. Load to stage table
        load_to_stage_table(endpoint, data)

        # 4. Transform data (FX conversion, calculations)
        transform_stage_data(endpoint)

        # 5. Move from stage to production
        execute_stored_procedure(f'sp_process_{endpoint.lower()}')
```

---

## 3. UPSERT PATTERN (Incremental Update)

### File: `XEROBLUE - UPSERT.py`

### Logic Flow
1. **Get Last Refresh Date** - Từ `lastrefreshdate` table
2. **Fetch Modified Data Only** - Dùng `If-Modified-Since` header
3. **Upsert Records** - Insert new, update existing
4. **Update Last Refresh Date** - Save new checkpoint

### Last Refresh Date Tracking
```sql
CREATE TABLE IF NOT EXISTS c0000_xeroblue_lastrefreshdate (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `TableName` VARCHAR(255),
    `RefreshRowCount` INT,
    `TotalRowCount` INT,
    `StartDate` DATETIME,
    `EndDate` DATETIME,
    `LastRefreshUTCDate` DATETIME,      -- Dùng cho If-Modified-Since
    `LoadType` VARCHAR(255),            -- 'INSERT' hoặc 'UPSERT'
    `RefreshStatus` VARCHAR(255),       -- 'SUCCESS', 'FAILED'
    `JobRunId` BIGINT,
    `ClientID` VARCHAR(255),
    `OrganisationID` INT,
    UNIQUE KEY `unique_table_client_org` (`TableName`, `ClientID`, `OrganisationID`)
);
```

### Get Last Refresh Date
```python
def get_last_refresh_date(table_name):
    """
    Lấy last refresh date cho differential sync
    """
    query = """
        SELECT LastRefreshUTCDate
        FROM c0000_xeroblue_lastrefreshdate
        WHERE TableName = %s
        AND ClientID = %s
        AND OrganisationID = %s
        AND RefreshStatus = 'SUCCESS'
        ORDER BY EndDate DESC
        LIMIT 1
    """

    cursor.execute(query, (table_name, ClientIdNumber, EtaniOrganisationID))
    result = cursor.fetchone()

    if result and result[0]:
        last_refresh = result[0].strftime('%Y-%m-%dT%H:%M:%S')
        print(f"📅 Last refresh date for {table_name}: {last_refresh}")
        return last_refresh
    else:
        # First time - get data from 1 year ago
        one_year_ago = (datetime.now() - timedelta(days=365)).strftime('%Y-%m-%dT%H:%M:%S')
        print(f"🆕 First time sync for {table_name}, using: {one_year_ago}")
        return one_year_ago
```

### If-Modified-Since Implementation
```python
def xero_requests_upsert(endpoint, if_modified_since=None):
    """
    UPSERT mode: Chỉ fetch data đã modified kể từ last refresh
    """
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Xero-tenant-id': xero_tenant_id,
        'Accept': 'application/json'
    }

    # Thêm If-Modified-Since header cho differential sync
    if if_modified_since:
        headers['If-Modified-Since'] = if_modified_since
        print(f"🔄 Fetching {endpoint} modified since: {if_modified_since}")

    response = requests.get(endpoint_url, headers=headers)

    if response.status_code == 304:
        print(f"✅ No changes for {endpoint} since {if_modified_since}")
        return None  # No data to process

    return response.json()

# Example usage
last_refresh = get_last_refresh_date('Invoices')
modified_invoices = xero_requests_upsert('Invoices', last_refresh)

if modified_invoices:
    # Process only the modified invoices
    upsert_invoices(modified_invoices)
```

### Upsert Logic
```python
def upsert_records(table_name, records):
    """
    Insert new records, update existing ones
    """
    for record in records:
        # Check if record exists
        check_query = f"""
            SELECT COUNT(*) FROM {table_name}
            WHERE InvoiceId = %s AND OrganisationID = %s
        """
        cursor.execute(check_query, (record['InvoiceID'], EtaniOrganisationID))
        exists = cursor.fetchone()[0] > 0

        if exists:
            # Update existing record
            update_query = f"""
                UPDATE {table_name}
                SET LineItem_LineAmount = %s,
                    UpdatedDateUTC = %s,
                    LastModified = NOW()
                WHERE InvoiceId = %s AND OrganisationID = %s
            """
            cursor.execute(update_query, (
                record['LineAmount'],
                record['UpdatedDateUTC'],
                record['InvoiceID'],
                EtaniOrganisationID
            ))
            print(f"📝 Updated existing record: {record['InvoiceID']}")
        else:
            # Insert new record
            insert_query = f"""
                INSERT INTO {table_name}
                (InvoiceId, LineItem_LineAmount, UpdatedDateUTC, ClientID, OrganisationID)
                VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(insert_query, (
                record['InvoiceID'],
                record['LineAmount'],
                record['UpdatedDateUTC'],
                ClientIdNumber,
                EtaniOrganisationID
            ))
            print(f"➕ Inserted new record: {record['InvoiceID']}")
```

### Update Last Refresh Date
```python
def update_last_refresh_date(table_name, refresh_count):
    """
    Save checkpoint sau khi UPSERT thành công
    """
    current_time = datetime.now(timezone.utc)

    insert_query = """
        INSERT INTO c0000_xeroblue_lastrefreshdate
        (TableName, RefreshRowCount, StartDate, EndDate, LastRefreshUTCDate,
         LoadType, RefreshStatus, JobRunId, ClientID, OrganisationID)
        VALUES (%s, %s, %s, %s, %s, 'UPSERT', 'SUCCESS', %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            RefreshRowCount = VALUES(RefreshRowCount),
            EndDate = VALUES(EndDate),
            LastRefreshUTCDate = VALUES(LastRefreshUTCDate),
            RefreshStatus = 'SUCCESS'
    """

    cursor.execute(insert_query, (
        table_name,
        refresh_count,
        current_time,
        current_time,
        current_time.strftime('%Y-%m-%d %H:%M:%S'),
        JOB_RUN_ID,
        ClientIdNumber,
        EtaniOrganisationID
    ))

    print(f"✅ Updated last refresh date for {table_name}: {current_time}")
```

---

## 4. MODIFIED TIMESTAMP HANDLING (XERO)

### Xero UpdatedDateUTC Field
- **Field Name:** `UpdatedDateUTC`
- **Format:** RFC3339 (e.g., `2025-01-02T10:30:45.123Z`)
- **Storage:** `DATETIME` in MySQL
- **Usage:** Làm filter cho If-Modified-Since header

### HTTP Headers for Differential Sync
```python
# UPSERT: Chỉ lấy data modified sau last refresh date
headers['If-Modified-Since'] = '2025-01-02T10:30:00'

# Xero API response:
# - 304 Not Modified: Không có data nào thay đổi
# - 200 OK: Trả về chỉ những records đã modified
```

### Entity Schema Pattern
```sql
-- Tất cả Xero entities có UpdatedDateUTC field
CREATE TABLE IF NOT EXISTS c0000_xeroblue_invoices (
    `InvoiceId` VARCHAR(100) NULL,
    `Type` VARCHAR(100) NULL,
    `Contact` VARCHAR(255) NULL,
    `LineItem_LineAmount` DECIMAL(15, 4) NULL,
    `UpdatedDateUTC` DATETIME NULL,     -- Key field cho differential sync
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    INDEX idx_updated_date (UpdatedDateUTC),
    INDEX idx_org_updated (OrganisationID, UpdatedDateUTC)
);
```

---

## 5. CHECKPOINT RECOVERY PATTERN

### ETLCheckpointManager Usage
```python
from etl_checkpoint import ETLCheckpointManager

# Initialize checkpoint manager
checkpoint_manager = ETLCheckpointManager(
    org_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber),
    etani_client_id=EtaniClientID,
    script_type='UPSERT'  # hoặc 'INSERT'
)

# Check for existing checkpoint (after rate limit)
checkpoint = checkpoint_manager.get_checkpoint()
if checkpoint:
    print(f"🔄 Resuming from checkpoint: {checkpoint}")
    last_endpoint = checkpoint.get('last_endpoint')
    last_refresh_date = checkpoint.get('last_refresh_date')
    # Resume từ endpoint cuối cùng
else:
    print("🆕 Starting fresh ETL run")

# Save checkpoint khi bị rate limited (429)
try:
    # ETL processing...
    pass
except RateLimitException as e:
    checkpoint_manager.save_checkpoint({
        'last_endpoint': current_endpoint,
        'last_refresh_date': current_refresh_date,
        'processed_count': processed_count
    })
    print("💾 Checkpoint saved, will resume in 24h")
    raise
```

---

## 6. PERFORMANCE OPTIMIZATION

### INSERT vs UPSERT Performance
- **INSERT:** Slower initial load, but comprehensive data
- **UPSERT:** Fast incremental updates (chỉ process modified records)

### Optimization Strategies
1. **Batch Processing:** Process records theo batches thay vì từng record
2. **Parallel Endpoints:** Fetch multiple endpoints đồng thời
3. **Index Optimization:** Đảm bảo có indexes trên UpdatedDateUTC và primary keys
4. **Memory Management:** Clear DataFrames sau mỗi endpoint để giảm memory usage

### Monitoring Performance
```python
# Track processing metrics
start_time = time.time()
processed_records = 0

for endpoint in endpoints:
    endpoint_start = time.time()

    # Process endpoint
    records = process_endpoint(endpoint)
    processed_records += len(records)

    endpoint_duration = time.time() - endpoint_start
    print(f"⚡ {endpoint}: {len(records)} records in {endpoint_duration:.2f}s")

total_duration = time.time() - start_time
print(f"📊 Total: {processed_records} records in {total_duration:.2f}s")
```

---

**Logic này cho phép smart routing giữa full load và incremental sync, đảm bảo data integrity và performance optimization.**