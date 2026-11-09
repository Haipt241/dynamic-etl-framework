# Service Table Enhancement Recommendation

## Current Limitation

The mapping from `service_id` → `integration_name` is hardcoded in Python:

```python
# org_parameter_fetcher.py
SERVICE_TO_INTEGRATION = {
    62: 'tidywork',
    72: 'fyi',
    4: 'qbo',
    ...
}
```

**Problems:**
- ❌ Adding new integrations requires code changes
- ❌ Mapping knowledge lives in code, not database
- ❌ CMS has no visibility into which integrations are available
- ❌ Cannot disable integrations without code deploy

---

## Proposed Solution

Add integration metadata to `vibedb_cms.service` table:

```sql
ALTER TABLE vibedb_cms.service
ADD COLUMN integration_name VARCHAR(50) NULL COMMENT 'Python integration name (e.g., tidywork, fyi)',
ADD COLUMN config_file_name VARCHAR(100) NULL COMMENT 'Config file name (e.g., tidywork_config.json)',
ADD COLUMN is_dynamic_integration BOOLEAN DEFAULT FALSE COMMENT 'True if uses dynamic integration framework',
ADD INDEX idx_dynamic_integration (is_dynamic_integration);
```

---

## Populate Existing Services

```sql
-- Dynamic Integrations
UPDATE vibedb_cms.service SET
    integration_name = 'tidywork',
    config_file_name = 'tidywork_config.json',
    is_dynamic_integration = TRUE
WHERE id = 62;

UPDATE vibedb_cms.service SET
    integration_name = 'fyi',
    config_file_name = 'fyi_config.json',
    is_dynamic_integration = TRUE
WHERE id = 72;

UPDATE vibedb_cms.service SET
    integration_name = 'qbo',
    config_file_name = 'qbo_config.json',
    is_dynamic_integration = TRUE
WHERE id = 4;

UPDATE vibedb_cms.service SET
    integration_name = 'karbon_hq',
    config_file_name = 'karbon_hq_config.json',
    is_dynamic_integration = TRUE
WHERE id = 50;

-- Legacy Integrations (not using dynamic framework)
UPDATE vibedb_cms.service SET
    integration_name = 'xeroblue_legacy',
    config_file_name = NULL,
    is_dynamic_integration = FALSE
WHERE id = 1 AND name = 'Xero Blue (Legacy)';

-- Add more as needed...
```

---

## Updated Lambda Query

**Before (Lambda only gets service_id):**
```sql
SELECT cs.id, cs.Service
FROM vibedb_cms.client_service cs
WHERE cs.Status IN (1, 9, 12);
```
Container must map `service_id` → `integration_name` using hardcoded dict.

**After (Lambda gets service_id AND integration_name):**
```sql
SELECT cs.id, cs.Service, s.integration_name, s.config_file_name
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.service s ON cs.Service = s.id
WHERE cs.Status IN (1, 9, 12)
    AND s.is_dynamic_integration = TRUE;
```
Container receives `integration_name` directly, no mapping needed!

---

## Updated Container Query

**Before:**
```python
# Hardcoded mapping
integration_name = SERVICE_TO_INTEGRATION.get(service_id)
if not integration_name:
    raise Exception(f"Unknown service_id={service_id}")
```

**After:**
```python
# Direct from database
integration_name = cms_data['integration_name']
config_file_name = cms_data['config_file_name']
# No hardcoded mapping needed!
```

---

## Benefits

### 1. Database is Source of Truth ✅
- All integration metadata in one place
- CMS can query available integrations
- No code changes to add new integrations

### 2. Easy to Add New Integrations ✅
```sql
INSERT INTO vibedb_cms.service (id, name, integration_name, config_file_name, is_dynamic_integration)
VALUES (99, 'New Integration', 'new_integration', 'new_integration_config.json', TRUE);
```
No Python code changes required!

### 3. Can Disable Integrations ✅
```sql
UPDATE vibedb_cms.service
SET is_dynamic_integration = FALSE
WHERE id = 62;
```
Lambda will skip it immediately (no code deploy).

### 4. Better Observability ✅
```sql
-- See all dynamic integrations
SELECT id, name, integration_name, config_file_name
FROM vibedb_cms.service
WHERE is_dynamic_integration = TRUE;

-- See active orgs for each integration
SELECT s.name, s.integration_name, COUNT(*) as active_orgs
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.service s ON cs.Service = s.id
WHERE cs.Status IN (1, 9, 12)
    AND s.is_dynamic_integration = TRUE
GROUP BY s.id, s.name, s.integration_name;
```

### 5. Frontend Can Use It ✅
CMS frontend can query service table to:
- Show available integrations in dropdown
- Display integration status (active/disabled)
- Link to config files for debugging

---

## Migration Path

### Phase 1: Add Columns (Non-Breaking)
```sql
ALTER TABLE vibedb_cms.service
ADD COLUMN integration_name VARCHAR(50) NULL,
ADD COLUMN config_file_name VARCHAR(100) NULL,
ADD COLUMN is_dynamic_integration BOOLEAN DEFAULT FALSE;
```
- Old code continues working (columns are NULL)
- No downtime required

### Phase 2: Populate Data
```sql
UPDATE vibedb_cms.service SET ... WHERE id = 62;
UPDATE vibedb_cms.service SET ... WHERE id = 72;
-- ... populate all services
```
- Data available for new code to use
- Old code still uses hardcoded mapping (fallback)

### Phase 3: Update Python Code
```python
# org_parameter_fetcher.py - Try database first, fallback to hardcoded
integration_name = cms_data.get('integration_name')
if not integration_name:
    # Fallback to hardcoded mapping
    integration_name = SERVICE_TO_INTEGRATION.get(service_id)
```
- Deploy new container code
- Uses database if available
- Falls back to hardcoded if NULL

### Phase 4: Remove Hardcoded Mapping (Future)
```python
# org_parameter_fetcher.py - Database only
integration_name = cms_data.get('integration_name')
if not integration_name:
    raise Exception(f"service_id={service_id} has no integration_name in database")
```
- After all services populated
- Enforce database as single source of truth

---

## Updated CMS Query

**Container query with database enhancement:**
```sql
SELECT
    cs.id as org_id,
    cs.Client as client_id,
    cs.Service as service_id,
    cs.Status as status,
    cs.AccountingFirm as firm_id,
    cs.apiConnectionInfo,
    c.name as client_name,
    af.firmCode as firm_code,
    s.integration_name,        -- NEW
    s.config_file_name          -- NEW
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.client c ON cs.Client = c.id
INNER JOIN vibedb_cms.accountingfirm af ON cs.AccountingFirm = af.id
INNER JOIN vibedb_cms.service s ON cs.Service = s.id  -- NEW
WHERE cs.id = :org_id
    AND cs.Status IN (1, 9, 12);
```

**Python becomes:**
```python
cms_data = {
    'org_id': row[0],
    'client_id': row[1],
    'service_id': row[2],
    'status': row[3],
    'firm_id': row[4],
    'api_connection_info': json.loads(row[5]) if row[5] else {},
    'client_name': row[6],
    'firm_code': row[7],
    'integration_name': row[8],      # Direct from DB!
    'config_file_name': row[9]       # Direct from DB!
}

# Use it
integration_name = cms_data['integration_name']  # No mapping needed!
```

---

## Lambda Query Enhancement

**Before:**
```python
query = """
    SELECT cs.id, cs.Service
    FROM client_service cs
    WHERE cs.Status IN (1, 9, 12)
"""
```

**After:**
```python
query = """
    SELECT cs.id, cs.Service, s.integration_name
    FROM client_service cs
    INNER JOIN service s ON cs.Service = s.id
    WHERE cs.Status IN (1, 9, 12)
        AND s.is_dynamic_integration = TRUE
        AND af.database = 'AWS'
"""
```

Lambda can log which integration is being spawned:
```
Spawning task for org_id=7102, integration=tidywork (service_id=62)
```

---

## Example: Adding New Integration

### Old Way (Code Changes Required)
1. Edit `org_parameter_fetcher.py` - add to `SERVICE_TO_INTEGRATION`
2. Commit, push, build container, deploy to ECR
3. Wait for Lambda to pick up new image
4. Total time: 15-30 minutes + deployment

### New Way (Database Only)
```sql
-- 1. Add service metadata
UPDATE vibedb_cms.service SET
    integration_name = 'new_integration',
    config_file_name = 'new_integration_config.json',
    is_dynamic_integration = TRUE
WHERE id = 99;

-- 2. Add client_service record
INSERT INTO vibedb_cms.client_service
    (Client, Service, Status, AccountingFirm, apiConnectionInfo)
VALUES
    (2022, 99, 1, 15, '{"api_key": "xxx", "domain": "yyy"}');
```
**Total time: 30 seconds** (just SQL updates!)

Container will automatically:
- See `integration_name='new_integration'`
- Load `new_integration_config.json`
- Extract parameters from `apiConnectionInfo`
- Run the integration

---

## Recommendation

**YES, add these columns to the service table.**

**Benefits far outweigh the minimal migration effort:**
- ✅ No code changes for new integrations
- ✅ Database is single source of truth
- ✅ Better observability and debugging
- ✅ CMS can manage integrations dynamically
- ✅ Cleaner architecture (data-driven, not code-driven)

**Migration is non-breaking:**
- Phase 1-2 can happen today (just SQL)
- Phase 3 (code update) at your convenience
- Phase 4 (cleanup) when fully migrated

The container will work during the entire migration (fallback to hardcoded mapping until database populated).
