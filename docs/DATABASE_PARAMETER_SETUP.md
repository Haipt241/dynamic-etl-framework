# Database Parameter Setup - Exact Key Matching

## Overview

The parameter fetcher uses **exact key matching** between:
1. `client_service.apiConnectionInfo` JSON (database)
2. `{integration}_config.json` env_vars_config (code)

**Rule:** JSON keys MUST match config keys exactly - no pattern matching, no guessing.

---

## How It Works

### Step 1: Query CMS Database
```sql
SELECT cs.Service, cs.apiConnectionInfo
FROM vibedb_cms.client_service cs
WHERE cs.id = 7102;
```

**Result:**
```
service_id: 62
apiConnectionInfo: {"tidywork_api_key": "xxx", "tidywork_domain": "yyy"}
```

### Step 2: Map service_id → integration_name
```python
SERVICE_TO_INTEGRATION = {
    62: 'tidywork',
    72: 'fyi',
    4: 'qbo',
    ...
}
```
Result: `service_id=62` → `integration='tidywork'`

### Step 3: Load Config File
```
Load: dynamic_integrations/generator/config/tidywork_config.json
```

```json
{
  "env_vars_config": {
    "tidywork_api_key": {
      "env_var": "TIDYWORK_API_KEY"
    },
    "tidywork_domain": {
      "env_var": "TIDYWORK_DOMAIN"
    }
  }
}
```

### Step 4: Exact Match Extraction
```python
# For each key in env_vars_config:
for config_key in ['tidywork_api_key', 'tidywork_domain']:
    # Check if EXACT key exists in apiConnectionInfo
    if config_key in apiConnectionInfo:
        # Extract value
        value = apiConnectionInfo[config_key]
        # Map to environment variable
        params[env_var] = value
```

**Result:**
```python
{
  'EtaniClientID': 'DOUGLASINNOVATION_CLIENT2022',
  'EtaniOrganisationID': '7102',
  'TIDYWORK_API_KEY': 'REDACTED',
  'TIDYWORK_DOMAIN': 'douglasinnovation.tidywork.com.au'
}
```

---

## JSON Structure by Integration

### TidyWork (service_id=62)

**Config keys:**
```json
{
  "tidywork_api_key": {...},
  "tidywork_domain": {...}
}
```

**Required apiConnectionInfo:**
```json
{
  "tidywork_api_key": "REDACTED",
  "tidywork_domain": "douglasinnovation.tidywork.com.au"
}
```

### FYI (service_id=72)

**Config keys:**
```json
{
  "access_id": {...},
  "access_secret": {...}
}
```

**Required apiConnectionInfo:**
```json
{
  "access_id": "xxxxxxxxxxxxx",
  "access_secret": "xxxxxxxxxxxxx"
}
```

### QuickBooks Online (service_id=4)

**Config keys:**
```json
{
  "realm_id": {...},
  "refresh_token": {...}
}
```

**Required apiConnectionInfo:**
```json
{
  "realm_id": "123456789",
  "refresh_token": "REDACTED"
}
```

### Xero (service_id=1)

**Config keys:**
```json
{
  "xero_tenant_id": {...},
  "refresh_token": {...}
}
```

**Required apiConnectionInfo:**
```json
{
  "xero_tenant_id": "865512af-e7d8-4d42-8568-73084279eb43",
  "refresh_token": "xxxxxxxxxxxxx"
}
```

### Karbon (service_id=50)

**Config keys:**
```json
{
  "access_key": {...},
  "bearer": {...}
}
```

**Required apiConnectionInfo:**
```json
{
  "access_key": "xxxxxxxxxxxxx",
  "bearer": "xxxxxxxxxxxxx"
}
```

---

## Migrating Existing Data

If your `apiConnectionInfo` JSON keys don't match config keys:

### Check Current Keys
```sql
SELECT id, Service, apiConnectionInfo
FROM vibedb_cms.client_service
WHERE id = 7102;
```

**Example current data (WRONG):**
```json
{
  "apiKey": "REDACTED",      ← Should be: tidywork_api_key
  "domain": "douglas..."    ← Should be: tidywork_domain
}
```

### Find Required Keys
1. Check service_id: `62`
2. Map to integration: `tidywork`
3. Open config: `dynamic_integrations/generator/config/tidywork_config.json`
4. Look at `env_vars_config` keys (exclude standard ones like `etani_client_id`)

**Required keys for TidyWork:**
- `tidywork_api_key`
- `tidywork_domain`

### Update Database
```sql
UPDATE vibedb_cms.client_service
SET apiConnectionInfo = JSON_OBJECT(
    'tidywork_api_key', 'pfnwAhEWbb+oZfNz3AD4ZQNr3RXn+MJvPzHM+olMOsQ=',
    'tidywork_domain', 'douglasinnovation.tidywork.com.au'
)
WHERE id = 7102;
```

---

## Validation Script

Run this to check if your JSON keys match:

```python
# test_org_parameter_fetch.py
import os
os.environ['USE_AWS_DB'] = 'True'

from dynamic_integrations.org_parameter_fetcher import fetch_parameters_from_database

result = fetch_parameters_from_database('7102')

if result['success']:
    print("✅ All parameters found")
else:
    print(f"❌ {result['error']}")
```

**Expected output:**
```
✅ service_id=62 → integration=tidywork
✅ Loaded config: tidywork_config.json
🔍 Extracting parameters:
   Config keys: ['tidywork_api_key', 'tidywork_domain']
   JSON keys: ['tidywork_api_key', 'tidywork_domain']
   ✅ TIDYWORK_API_KEY: EXACT MATCH (key: tidywork_api_key)
   ✅ TIDYWORK_DOMAIN: EXACT MATCH (key: tidywork_domain)
✅ Fetched 2 integration parameters
```

**Error output (mismatched keys):**
```
❌ TIDYWORK_API_KEY: No exact match for 'tidywork_api_key' in JSON
❌ TIDYWORK_DOMAIN: No exact match for 'tidywork_domain' in JSON
```

---

## Database Schema Enhancement

### Current Approach
- `service_id` is stored in `client_service.Service`
- We have hardcoded `SERVICE_TO_INTEGRATION` mapping in Python
- Adding new integrations requires code changes

### Recommended Enhancement

Add `integration_name` and `config_file_name` to service table:

```sql
ALTER TABLE vibedb_cms.service
ADD COLUMN integration_name VARCHAR(50) NULL,
ADD COLUMN config_file_name VARCHAR(100) NULL,
ADD COLUMN is_dynamic_integration BOOLEAN DEFAULT FALSE;

-- Populate existing services
UPDATE vibedb_cms.service SET integration_name = 'tidywork', config_file_name = 'tidywork_config.json', is_dynamic_integration = TRUE WHERE id = 62;
UPDATE vibedb_cms.service SET integration_name = 'fyi', config_file_name = 'fyi_config.json', is_dynamic_integration = TRUE WHERE id = 72;
UPDATE vibedb_cms.service SET integration_name = 'qbo', config_file_name = 'qbo_config.json', is_dynamic_integration = TRUE WHERE id = 4;
UPDATE vibedb_cms.service SET integration_name = 'xeroblue', config_file_name = 'xeroblue_config.json', is_dynamic_integration = TRUE WHERE id = 1;
UPDATE vibedb_cms.service SET integration_name = 'karbon_hq', config_file_name = 'karbon_hq_config.json', is_dynamic_integration = TRUE WHERE id = 50;
-- ... add more
```

**Benefits:**
1. ✅ No hardcoded mapping in Python
2. ✅ CMS can manage integration metadata
3. ✅ Easy to add new integrations (just INSERT into service table)
4. ✅ Can disable integrations without code deploy
5. ✅ Clear mapping from service → integration → config file

**Query becomes:**
```sql
SELECT cs.Service, s.integration_name, s.config_file_name, cs.apiConnectionInfo
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.service s ON cs.Service = s.id
WHERE cs.id = 7102;
```

**Python code simplifies to:**
```python
integration_name = cms_data['integration_name']  # No mapping needed!
config_file = cms_data['config_file_name']       # No guessing needed!
```

---

## Complete Lambda to Container Flow

```
┌─────────────────────────────────────┐
│ Lambda: Query active integrations   │
│ WHERE Status IN (1, 9, 12)          │
│   AND af.database = 'AWS'           │
│   AND s.is_dynamic_integration=TRUE │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Spawn ECS task for each org_id      │
│ Command: --org-id 7102 --mode upsert│
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Container: Fetch parameters         │
│ Query CMS for org_id=7102           │
│ Get: service_id, apiConnectionInfo  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Map: service_id → integration_name  │
│ (From hardcoded dict OR service tbl)│
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Load: {integration}_config.json     │
│ Read: env_vars_config keys          │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Extract: EXACT match only           │
│ For each config key:                │
│   if key in apiConnectionInfo:      │
│     extract value                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Run: TIDYWORKIntegration            │
│ With all parameters set             │
└─────────────────────────────────────┘
```

---

## Recommendation

**SHORT TERM:** Use current approach with hardcoded `SERVICE_TO_INTEGRATION` mapping
- Simple, works immediately
- Update `apiConnectionInfo` JSON to match config keys exactly
- Test with `test_org_parameter_fetch.py`

**LONG TERM:** Add columns to service table
```sql
ALTER TABLE vibedb_cms.service
ADD COLUMN integration_name VARCHAR(50),
ADD COLUMN config_file_name VARCHAR(100),
ADD COLUMN is_dynamic_integration BOOLEAN DEFAULT FALSE;
```

**Benefits:**
- No code changes to add new integrations
- CMS becomes source of truth for integration metadata
- Cleaner architecture (database-driven, not code-driven)

---

## Testing

```powershell
# Test parameter fetching
$env:USE_AWS_DB="True"; python test_org_parameter_fetch.py

# Run full integration with --org-id
$env:USE_AWS_DB="True"; python run_dynamic_integration.py --org-id 7102 --mode upsert
```

---

## Troubleshooting

### Error: "No exact match for 'tidywork_api_key' in JSON"

**Cause:** JSON keys don't match config keys

**Fix:**
1. Check config file: `tidywork_config.json` → `env_vars_config` keys
2. Check database: `SELECT apiConnectionInfo FROM client_service WHERE id=7102`
3. Update database JSON to match config keys exactly

### Error: "Unknown service_id=X"

**Cause:** service_id not in `SERVICE_TO_INTEGRATION` mapping

**Fix:** Add to mapping in `org_parameter_fetcher.py`:
```python
SERVICE_TO_INTEGRATION = {
    ...
    X: 'new_integration_name',
}
```

Or add to service table (if enhanced schema):
```sql
UPDATE vibedb_cms.service
SET integration_name = 'new_integration_name',
    config_file_name = 'new_integration_config.json',
    is_dynamic_integration = TRUE
WHERE id = X;
```
