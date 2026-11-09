# Integration Required Parameters

This document lists all parameters for each integration as defined in their `env_vars_config` configuration.

Generated on: 2026-01-15

**Note:** All integrations require `etani_client_id` and `etani_organisation_id` as base parameters. These are listed in the "Common Required Parameters" section and excluded from individual integration lists below.

**Note:** System parameters like `db_destination`, `trigger_type`, and `reset_mode` are excluded as they are not needed for API extraction.

---

## 1. CIN7 (cin7_config.json)

**Parameters:**
- `api_username`
- `api_key`

---

## 2. DEAR (cin7_dear_config.json)

**Parameters:**
- `dear_account_id`
- `dear_application_key`

---

## 3. Deputy (deputy_config.json)

**Parameters:**
- `deputy_access_token`
- `deputy_domain`

---

## 4. FYI_ELITE (fyi_config.json)

**Parameters:**
- `x-fyi-access-id`
- `x-fyi-access-secret`

---

## 5. Hubspot (hubspot_config.json)

**Parameters:**
- `hubspot_client_id`
- `hubspot_client_secret`
- `hubspot_token`
- `hubspot_refresh_token`
- `hubspot_portal_id`
- `storage_account_name`
- `storage_access_key`
- `file_share_name`

---

## 6. Jobman (jobman_config.json)

**Parameters:**
- `jobman_client_id`
- `jobman_client_secret`
- `ApiToken`

---

## 7. Karbon HQ (karbon_hq_config.json)

**Parameters:**
- `karbon_access_key`
- `karbon_tenant_access_key`

---

## 8. Keypay (keypay_config.json)

**Parameters:**
- `api_username`
- `api_key`

---

## 9. MYOB_DETAILED (myob_detailed_config.json)

**Parameters:**
- `etani_link_organisation_id`
- `myob_client_id`
- `myob_access_token`
- `myob_client_secret`
- `myob_company_file`
- `myob_api_key`
- `myob_api_version`
- `myob_api_endpoint`
- `myob_cf_token`
- `myob_refresh_token`
- `myob_user_uid`
- `myob_user_username`
- `myob_organisation`

---

## 10. Payroll AU (payroll_au_config.json)

**Parameters:**
- `xero_client_id`
- `xero_client_secret`
- `xero_access_token`
- `xero_refresh_token`
- `xero_tenant_id`
- `storage_account_name`
- `storage_access_key`
- `file_share_name`

---

## 11. Payroll NZ (payroll_nz_config.json)

**Parameters:**
- `xero_client_id`
- `xero_client_secret`
- `xero_access_token`
- `xero_refresh_token`
- `xero_tenant_id`
- `storage_account_name`
- `storage_access_key`
- `file_share_name`

---

## 12. QBO (qbo_config.json)

**Parameters:**
- `realm_id`

---

## 13. Shopify (shopify_config.json)

**Parameters:**
- `shopify_access_token`
- `store_url`
- `api_version`

---

## 14. Simpro (simpro_config.json)

**Parameters:**
- `simpro_token`
- `simpro_client_id`
- `simpro_company_id`
- `simpro_domain`
- `simpro_upg_api_key`
- `simpro_upg_client_id`

---

## 15. Tidywork (tidywork_config.json)

**Parameters:**
- `tidywork_api_key`
- `tidywork_domain`

---

## 16. Unleashed (unleashed_config.json)

**Parameters:**
- `unleashed_api_id`
- `unleashed_api_private_key`
- `unleashed_client_type`

---

## 17. VinSight (vinsight_config.json)

**Parameters:**
- `vinsight_api_key`

---

## 18. WFM (wfm_config.json)

**Parameters:**
- `wfm_client_id`
- `wfm_client_secret`
- `wfm_access_token`
- `wfm_refresh_token`
- `wfm2_tenant_id`
- `storage_account_name`
- `storage_access_key`
- `file_share_name`

---

## 19. XeroProject (xeroproject_config.json)

**Parameters:**
- `xero_client_id`
- `xero_client_secret`
- `xero_access_token`
- `xero_refresh_token`
- `xero_tenant_id`

---

## 20. DQ_MYOBAR (dq_myobar_config.json)

**Parameters:**
- `myob_client_id`
- `myob_access_token`
- `myob_client_secret`
- `myob_company_file`
- `myob_start_date`
- `myob_end_date`
- `myob_reporting_basis`
- `myob_year_end_adjust`
- `myob_as_of_date`
- `myob_api_key`
- `myob_api_version`
- `myob_api_endpoint`
- `myob_cf_token`
- `myob_refresh_token`
- `myob_user_uid`
- `myob_user_username`
- `myob_organisation`

---

## 21. Accredo (accredo_config.json)

**Parameters:**
- `accredo_client_id`
- `accredo_username`
- `accredo_password`
- `accredo_domain`
- `accredo_company_name`
- `accredo_oauth_domain`

---

## Common Required Parameters

All integrations require these base parameters:
- `etani_client_id` - Client identifier (maps to env var `EtaniClientID`)
- `etani_organisation_id` - Organization ID number (maps to env var `EtaniOrganisationID`)

---

## System Parameters (Excluded from API Extraction)

These parameters are used for system operations but not needed for API extraction:
- `db_destination` - Target database (`EVA`, `EVADW`, `DW`)
- `trigger_type` - Trigger type (`MANUAL` or `SCHEDULED`)
- `reset_mode` - Set to `true` to bypass status 16 protection

---

## Parameter Categories

### Core Integration Parameters
These are integration-specific credentials and identifiers required to authenticate and connect to the external service.

### Token Storage Parameters (OAuth2 Integrations)
Used by integrations that require token management:
- `storage_account_name` - Azure storage account for token management
- `storage_access_key` - Azure storage access key
- `file_share_name` - Azure file share name (default: `tokens`)

### OAuth2 Token Parameters
Some integrations support OAuth2 and can use these tokens:
- `*_access_token` - OAuth2 access token
- `*_refresh_token` - OAuth2 refresh token

---

## Parameter Mapping to Environment Variables

Each parameter in `env_vars_config` maps to an environment variable. For example:

**CIN7:**
- `api_username` → `API_USERNAME`
- `api_key` → `API_KEY`

**DEAR:**
- `dear_account_id` → `DEAR_ACCOUNT_ID`
- `dear_application_key` → `DEAR_APPLICATION_KEY`

**FYI_ELITE:**
- `x-fyi-access-id` → `FYI_ELITE_ACCESS_ID`
- `x-fyi-access-secret` → `FYI_ELITE_ACCESS_SECRET`

**Shopify:**
- `shopify_access_token` → `SHOPIFY_ACCESS_TOKEN`
- `store_url` → `SHOPIFY_STORE_URL`
- `api_version` → `SHOPIFY_API_VERSION`

See each integration's config file in `dynamic_integrations/generator/config/` for the complete mapping of parameter names to environment variables.

---

## Usage Examples

### DATABASE-DRIVEN Mode (Recommended)
Parameters are fetched from vibedb_cms database:
```bash
python run_dynamic_integration.py --org-id 7102 --mode upsert
```

### With Explicit Parameters
When using explicit parameters, you typically use the environment variable names:
```bash
# QBO Integration
python run_dynamic_integration.py --integration qbo --mode upsert \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789

# FYI Integration
python run_dynamic_integration.py --integration fyi --mode upsert \
  --param EtaniClientID=CLIENT123 \
  --param EtaniOrganisationID=7035 \
  --param FYI_ELITE_ACCESS_ID=xxx \
  --param FYI_ELITE_ACCESS_SECRET=yyy

# Shopify Integration
python run_dynamic_integration.py --integration shopify --mode upsert \
  --param EtaniClientID=SHOPIFY_CLIENT2024 \
  --param EtaniOrganisationID=9001 \
  --param SHOPIFY_ACCESS_TOKEN=shpat_xxx \
  --param SHOPIFY_STORE_URL=mystore.myshopify.com \
  --param SHOPIFY_API_VERSION=2024-01
```

---

## Notes

1. All parameter keys are defined in the `env_vars_config` section of each integration's config file located in `dynamic_integrations/generator/config/`.

2. Each parameter key in `env_vars_config` has an associated `env_var` field that specifies the environment variable name.

3. Default values in config files are for testing purposes only and should be replaced with actual credentials in production.

4. OAuth2 integrations may automatically manage token parameters (access_token, refresh_token) which are stored in Azure File Share under the `token/` directory.

5. For database-driven mode, all parameters should be stored in the `vibedb_cms.integration_parameters` table using the parameter key names (not the environment variable names).

6. System parameters (`db_destination`, `trigger_type`, `reset_mode`) are managed by the ETL system and not required for API extraction.

7. Token storage parameters (`storage_account_name`, `storage_access_key`, `file_share_name`) are only required for OAuth2 integrations that need persistent token storage.

---

For more details on running integrations, see the main [CLAUDE.md](../CLAUDE.md) file.
