# Complete Integration Parameters Reference

## Service Table SQL Updates

Run these SQL statements to add integration metadata to the service table:

```sql
-- First, add columns to service table
ALTER TABLE vibedb_cms.service
ADD COLUMN integration_name VARCHAR(50) NULL COMMENT 'Python integration name',
ADD COLUMN config_file_name VARCHAR(100) NULL COMMENT 'Config file name',
ADD COLUMN is_dynamic_integration BOOLEAN DEFAULT FALSE COMMENT 'Uses dynamic framework',
ADD INDEX idx_dynamic_integration (is_dynamic_integration);

-- Then populate the data
UPDATE vibedb_cms.service SET integration_name='qbo', config_file_name='qbo_config.json', is_dynamic_integration=TRUE WHERE id=4;
UPDATE vibedb_cms.service SET integration_name='dq_myobar', config_file_name='dq_myobar_config.json', is_dynamic_integration=TRUE WHERE id=7;
UPDATE vibedb_cms.service SET integration_name='jobman', config_file_name='jobman_config.json', is_dynamic_integration=TRUE WHERE id=8;
UPDATE vibedb_cms.service SET integration_name='hubspot', config_file_name='hubspot_config.json', is_dynamic_integration=TRUE WHERE id=9;
UPDATE vibedb_cms.service SET integration_name='cin7_dear', config_file_name='cin7_dear_config.json', is_dynamic_integration=TRUE WHERE id=14;
UPDATE vibedb_cms.service SET integration_name='simpro', config_file_name='simpro_config.json', is_dynamic_integration=TRUE WHERE id=16;
UPDATE vibedb_cms.service SET integration_name='unleashed', config_file_name='unleashed_config.json', is_dynamic_integration=TRUE WHERE id=17;
UPDATE vibedb_cms.service SET integration_name='payroll_au', config_file_name='payroll_au_config.json', is_dynamic_integration=TRUE WHERE id=21;
-- Note: service_id 21 is used by both payroll_au and payroll_nz - they share the same service ID
UPDATE vibedb_cms.service SET integration_name='deputy', config_file_name='deputy_config.json', is_dynamic_integration=TRUE WHERE id=23;
UPDATE vibedb_cms.service SET integration_name='xeroproject', config_file_name='xeroproject_config.json', is_dynamic_integration=TRUE WHERE id=25;
UPDATE vibedb_cms.service SET integration_name='cin7', config_file_name='cin7_config.json', is_dynamic_integration=TRUE WHERE id=27;
UPDATE vibedb_cms.service SET integration_name='shopify', config_file_name='shopify_config.json', is_dynamic_integration=TRUE WHERE id=38;
UPDATE vibedb_cms.service SET integration_name='vinsight', config_file_name='vinsight_config.json', is_dynamic_integration=TRUE WHERE id=43;
UPDATE vibedb_cms.service SET integration_name='karbon_hq', config_file_name='karbon_hq_config.json', is_dynamic_integration=TRUE WHERE id=50;
UPDATE vibedb_cms.service SET integration_name='keypay', config_file_name='keypay_config.json', is_dynamic_integration=TRUE WHERE id=57;
UPDATE vibedb_cms.service SET integration_name='tidywork', config_file_name='tidywork_config.json', is_dynamic_integration=TRUE WHERE id=62;
UPDATE vibedb_cms.service SET integration_name='wfm', config_file_name='wfm_config.json', is_dynamic_integration=TRUE WHERE id=69;
UPDATE vibedb_cms.service SET integration_name='myob_detailed', config_file_name='myob_detailed_config.json', is_dynamic_integration=TRUE WHERE id=71;
UPDATE vibedb_cms.service SET integration_name='fyi', config_file_name='fyi_config.json', is_dynamic_integration=TRUE WHERE id=72;
```

---

## Required Parameters by Integration

**IMPORTANT:** The JSON keys in `client_service.Details` column MUST match these keys EXACTLY.

### QuickBooks Online (service_id=4)
```json
{
  "realm_id": "123456789"
}
```

### MYOB Business (service_id=7 - dq_myobar)
```json
{
  "myob_client_id": "xxx",
  "myob_access_token": "xxx",
  "myob_client_secret": "xxx",
  "myob_company_file": "xxx",
  "myob_start_date": "2024-01-01",
  "myob_end_date": "2024-12-31",
  "myob_reporting_basis": "Accrual",
  "myob_year_end_adjust": "false",
  "myob_as_of_date": "2024-12-31",
  "myob_api_key": "xxx",
  "myob_api_version": "v2",
  "myob_api_endpoint": "https://api.myob.com/accountright",
  "myob_cf_token": "xxx",
  "myob_refresh_token": "xxx",
  "myob_user_uid": "xxx",
  "myob_user_username": "xxx",
  "myob_organisation": "xxx"
}
```

### JobMan (service_id=8)
```json
{
  "jobman_client_id": "xxx",
  "jobman_client_secret": "xxx",
  "EtaniClientID": "FIRMCODE_CLIENT123",
  "EtaniOrganisationID": "456",
  "ApiToken": "xxx"
}
```

### HubSpot (service_id=9)
```json
{
  "hubspot_client_id": "xxx",
  "hubspot_client_secret": "xxx",
  "hubspot_token": "xxx",
  "hubspot_refresh_token": "xxx",
  "hubspot_portal_id": "xxx",
  "storage_account_name": "etanissis",
  "storage_access_key": "xxx",
  "file_share_name": "xeroblue-pydw-refreshtoken"
}
```

### Cin7 DEAR (service_id=14)
```json
{
  "dear_account_id": "xxx",
  "dear_application_key": "xxx"
}
```

### SimPro (service_id=16)
```json
{
  "simpro_token": "xxx",
  "simpro_client_id": "xxx",
  "simpro_company_id": "xxx",
  "simpro_domain": "xxx.simprosuite.com",
  "simpro_upg_api_key": "xxx",
  "simpro_upg_client_id": "xxx"
}
```

### Unleashed (service_id=17)
```json
{
  "unleashed_api_id": "xxx",
  "unleashed_api_private_key": "xxx",
  "unleashed_client_type": "Standard"
}
```

### Xero Payroll AU/NZ (service_id=21)
```json
{
  "xero_client_id": "xxx",
  "xero_client_secret": "xxx",
  "xero_access_token": "xxx",
  "xero_refresh_token": "xxx",
  "xero_tenant_id": "xxx",
  "storage_account_name": "etanissis",
  "storage_access_key": "xxx",
  "file_share_name": "xeroblue-pydw-refreshtoken"
}
```

### Deputy (service_id=23)
```json
{
  "deputy_access_token": "xxx",
  "deputy_domain": "company.na.deputy.com"
}
```

### Xero Projects (service_id=25)
```json
{
  "xero_client_id": "xxx",
  "xero_client_secret": "xxx",
  "xero_access_token": "xxx",
  "xero_refresh_token": "xxx",
  "xero_tenant_id": "xxx"
}
```

### Cin7 (service_id=27)
```json
{
  "api_username": "xxx",
  "api_key": "xxx"
}
```

### Shopify (service_id=38)
```json
{
  "shopify_access_token": "xxx",
  "store_url": "mystore.myshopify.com",
  "api_version": "2024-01"
}
```

### Vinsight (service_id=43)
```json
{
  "vinsight_api_key": "xxx"
}
```

### Karbon (service_id=50)
```json
{
  "karbon_access_key": "xxx",
  "karbon_tenant_access_key": "xxx"
}
```

### KeyPay (service_id=57)
```json
{
  "api_username": "xxx",
  "api_key": "xxx"
}
```

### TidyWork (service_id=62)
```json
{
  "tidywork_api_key": "REDACTED",
  "tidywork_domain": "companyname.tidywork.com.au"
}
```

### WorkflowMax (service_id=69)
```json
{
  "wfm_client_id": "xxx",
  "wfm_client_secret": "xxx",
  "wfm_access_token": "xxx",
  "wfm_refresh_token": "xxx",
  "wfm2_tenant_id": "xxx",
  "storage_account_name": "etanissis",
  "storage_access_key": "xxx",
  "file_share_name": "xeroblue-pydw-refreshtoken"
}
```

### MYOB Detailed (service_id=71)
```json
{
  "etani_link_organisation_id": "xxx",
  "myob_client_id": "xxx",
  "myob_access_token": "xxx",
  "myob_client_secret": "xxx",
  "myob_company_file": "xxx",
  "myob_api_key": "xxx",
  "myob_api_version": "v2",
  "myob_api_endpoint": "https://api.myob.com/accountright",
  "myob_cf_token": "xxx",
  "myob_refresh_token": "xxx",
  "myob_user_uid": "xxx",
  "myob_user_username": "xxx",
  "myob_organisation": "xxx"
}
```

### FYI (service_id=72)
```json
{
  "x-fyi-access-id": "xxx",
  "x-fyi-access-secret": "xxx"
}
```

---

## Quick Reference Table

| Service ID | Integration Name | Config File | Key Parameters |
|------------|------------------|-------------|----------------|
| 4 | qbo | qbo_config.json | realm_id |
| 7 | dq_myobar | dq_myobar_config.json | myob_client_id, myob_access_token, myob_company_file |
| 8 | jobman | jobman_config.json | jobman_client_id, jobman_client_secret, ApiToken |
| 9 | hubspot | hubspot_config.json | hubspot_token, hubspot_refresh_token, hubspot_portal_id |
| 14 | cin7_dear | cin7_dear_config.json | dear_account_id, dear_application_key |
| 16 | simpro | simpro_config.json | simpro_token, simpro_client_id, simpro_domain |
| 17 | unleashed | unleashed_config.json | unleashed_api_id, unleashed_api_private_key |
| 21 | payroll_au/nz | payroll_au_config.json | xero_client_id, xero_refresh_token, xero_tenant_id |
| 23 | deputy | deputy_config.json | deputy_access_token, deputy_domain |
| 25 | xeroproject | xeroproject_config.json | xero_client_id, xero_refresh_token, xero_tenant_id |
| 27 | cin7 | cin7_config.json | api_username, api_key |
| 38 | shopify | shopify_config.json | shopify_access_token, store_url |
| 43 | vinsight | vinsight_config.json | vinsight_api_key |
| 50 | karbon_hq | karbon_hq_config.json | karbon_access_key, karbon_tenant_access_key |
| 57 | keypay | keypay_config.json | api_username, api_key |
| 62 | tidywork | tidywork_config.json | tidywork_api_key, tidywork_domain |
| 69 | wfm | wfm_config.json | wfm_client_id, wfm_refresh_token |
| 71 | myob_detailed | myob_detailed_config.json | myob_client_id, myob_access_token, myob_company_file |
| 72 | fyi | fyi_config.json | x-fyi-access-id, x-fyi-access-secret |

---

## How to Update Details Column

### Check Current Data
```sql
SELECT id, Service, Details
FROM vibedb_cms.client_service
WHERE id = 7102;
```

### Update Details JSON (Example for TidyWork)
```sql
UPDATE vibedb_cms.client_service
SET Details = JSON_OBJECT(
    'tidywork_api_key', 'pfnwAhEWbb+oZfNz3AD4ZQNr3RXn+MJvPzHM+olMOsQ=',
    'tidywork_domain', 'douglasinnovation.tidywork.com.au'
)
WHERE id = 7102;
```

### Verify Details Match Config
```python
# Run this to check if your Details JSON matches config requirements
python test_org_parameter_fetch.py
```

**Good output:**
```
✅ TIDYWORK_API_KEY: EXACT MATCH (key: tidywork_api_key)
✅ TIDYWORK_DOMAIN: EXACT MATCH (key: tidywork_domain)
```

**Bad output (keys don't match):**
```
❌ TIDYWORK_API_KEY: No exact match for 'tidywork_api_key' in Details JSON
```

---

## Notes

1. **JSON keys are case-sensitive** - `tidywork_api_key` ≠ `TidyWork_API_Key`
2. **Use snake_case** - Most integrations use lowercase with underscores
3. **No pattern matching** - Keys must match exactly (no guessing)
4. **Standard params handled automatically** - `etani_client_id`, `etani_organisation_id`, `db_destination`, `trigger_type`, `reset_mode` are built by the system
5. **Only integration-specific params needed** - Don't include standard params in Details JSON

---

## Validation Query

Check all client_service records that need Details updates:

```sql
SELECT
    cs.id,
    cs.Service,
    s.integration_name,
    s.config_file_name,
    CASE
        WHEN cs.Details IS NULL THEN 'Missing'
        WHEN cs.Details = '{}' THEN 'Empty'
        ELSE 'Has Data'
    END as details_status
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.service s ON cs.Service = s.id
WHERE s.is_dynamic_integration = TRUE
    AND cs.Status IN (1, 9, 12)
ORDER BY s.id, cs.id;
```

This will show which orgs have missing or empty Details JSON that need to be populated.
