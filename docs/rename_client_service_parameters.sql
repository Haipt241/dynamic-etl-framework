-- =====================================================================
-- Script to rename and add parameters in vibedb_cms.client_service.Details column
-- to match env_vars_config parameter names (snake_case)
-- =====================================================================
-- Generated on: 2026-01-15
--
-- This script performs two operations:
-- 1. RENAME: Renames existing JSON keys from PascalCase/camelCase
--    (as stored in database) to snake_case (as defined in env_vars_config)
-- 2. ADD: Adds missing parameters that exist in env_vars_config but not in database
--
-- All integrations are identified by service_id for reliability
-- =====================================================================

USE vibedb_cms;

-- =====================================================================
-- SELECT QUERIES - Review Current Data Before Updates
-- =====================================================================
-- These queries show the current state of client_service records for all
-- 21 integrations that will be updated by this script.
-- =====================================================================

-- =====================================================================
-- Summary: Count of records per integration
-- =====================================================================
-- Using exact service IDs from INTEGRATION_PARAMETERS_COMPLETE.md
SELECT
    s.id as service_id,
    s.Name as service_name,
    COUNT(*) as total_records,
    SUM(CASE WHEN cs.Details IS NOT NULL THEN 1 ELSE 0 END) as records_with_details,
    SUM(CASE WHEN cs.Details IS NULL THEN 1 ELSE 0 END) as records_without_details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id IN (
    4,   -- QBO
    7,   -- DQ_MYOBAR
    8,   -- Jobman
    9,   -- Hubspot
    14,  -- Cin7 DEAR
    16,  -- Simpro
    17,  -- Unleashed
    21,  -- Payroll AU/NZ (both use same service ID)
    23,  -- Deputy
    25,  -- XeroProject
    27,  -- Cin7
    38,  -- Shopify
    43,  -- Vinsight
    50,  -- Karbon HQ
    57,  -- Keypay
    62,  -- Tidywork
    69,  -- WFM
    71,  -- MYOB_DETAILED
    72   -- FYI
)
GROUP BY s.id, s.Name
ORDER BY s.id;

-- =====================================================================
-- All Records for Target Integrations
-- =====================================================================
-- Shows complete records for all 19 target integrations (21 total including variants)
SELECT
    s.id as service_id,
    s.Name as service_name,
    cs.*
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id IN (
    4,   -- QBO
    7,   -- DQ_MYOBAR
    8,   -- Jobman
    9,   -- Hubspot
    14,  -- Cin7 DEAR
    16,  -- Simpro
    17,  -- Unleashed
    21,  -- Payroll AU/NZ
    23,  -- Deputy
    25,  -- XeroProject
    27,  -- Cin7
    38,  -- Shopify
    43,  -- Vinsight
    50,  -- Karbon HQ
    57,  -- Keypay
    62,  -- Tidywork
    69,  -- WFM
    71,  -- MYOB_DETAILED
    72   -- FYI
)
ORDER BY s.id, cs.Client;

-- =====================================================================
-- Individual Integration Queries (by service ID)
-- =====================================================================

-- Service ID 4: QBO
SELECT 4 as service_id, 'QBO' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 4 AND cs.Details IS NOT NULL;

-- Service ID 7: DQ_MYOBAR
SELECT 7 as service_id, 'DQ_MYOBAR' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 7 AND cs.Details IS NOT NULL;

-- Service ID 8: Jobman
SELECT 8 as service_id, 'Jobman' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 8 AND cs.Details IS NOT NULL;

-- Service ID 9: Hubspot
SELECT 9 as service_id, 'Hubspot' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 9 AND cs.Details IS NOT NULL;

-- Service ID 14: Cin7 DEAR
SELECT 14 as service_id, 'DEAR' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 14 AND cs.Details IS NOT NULL;

-- Service ID 16: Simpro
SELECT 16 as service_id, 'Simpro' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 16 AND cs.Details IS NOT NULL;

-- Service ID 17: Unleashed
SELECT 17 as service_id, 'Unleashed' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 17 AND cs.Details IS NOT NULL;

-- Service ID 21: Payroll AU/NZ (both use same service ID)
SELECT 21 as service_id, 'Payroll AU/NZ' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 21 AND cs.Details IS NOT NULL;

-- Service ID 23: Deputy
SELECT 23 as service_id, 'Deputy' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 23 AND cs.Details IS NOT NULL;

-- Service ID 25: XeroProject
SELECT 25 as service_id, 'XeroProject' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 25 AND cs.Details IS NOT NULL;

-- Service ID 27: Cin7
SELECT 27 as service_id, 'CIN7' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 27 AND cs.Details IS NOT NULL;

-- Service ID 38: Shopify
SELECT 38 as service_id, 'Shopify' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 38 AND cs.Details IS NOT NULL;

-- Service ID 43: Vinsight
SELECT 43 as service_id, 'VinSight' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 43 AND cs.Details IS NOT NULL;

-- Service ID 50: Karbon HQ
SELECT 50 as service_id, 'Karbon HQ' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 50 AND cs.Details IS NOT NULL;

-- Service ID 57: Keypay
SELECT 57 as service_id, 'Keypay' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 57 AND cs.Details IS NOT NULL;

-- Service ID 62: Tidywork
SELECT 62 as service_id, 'Tidywork' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 62 AND cs.Details IS NOT NULL;

-- Service ID 69: WFM
SELECT 69 as service_id, 'WFM' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 69 AND cs.Details IS NOT NULL;

-- Service ID 71: MYOB_DETAILED
SELECT 71 as service_id, 'MYOB_DETAILED' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 71 AND cs.Details IS NOT NULL;

-- Service ID 72: FYI
SELECT 72 as service_id, 'FYI' as integration, s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE s.id = 72 AND cs.Details IS NOT NULL;

-- =====================================================================
-- END OF SELECT QUERIES
-- =====================================================================

-- =====================================================================
-- UPDATE STATEMENTS BEGIN HERE
-- =====================================================================
-- IMPORTANT: Review the SELECT query results above before running these updates!
-- Make sure to backup your database first!
-- =====================================================================

-- =====================================================================
-- 1. CIN7 Integration (service_id = 27)
-- =====================================================================
-- Rename: APIKey -> api_key, APIUsername -> api_username
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey', '$.APIUsername'),
    '$.api_key', JSON_EXTRACT(cs.Details, '$.APIKey'),
    '$.api_username', JSON_EXTRACT(cs.Details, '$.APIUsername')
)
WHERE s.id = 27
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 2. DEAR Integration (service_id = 14)
-- =====================================================================
-- Rename: Key -> dear_application_key, AccountID -> dear_account_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.Key', '$.AccountID'),
    '$.dear_application_key', JSON_EXTRACT(cs.Details, '$.Key'),
    '$.dear_account_id', JSON_EXTRACT(cs.Details, '$.AccountID')
)
WHERE s.id = 14
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.Key') IS NOT NULL;

-- =====================================================================
-- 3. Deputy Integration (service_id = 23)
-- =====================================================================
-- Rename: APIKey -> deputy_access_token, SubDomain -> deputy_domain
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey', '$.SubDomain'),
    '$.deputy_access_token', JSON_EXTRACT(cs.Details, '$.APIKey'),
    '$.deputy_domain', JSON_EXTRACT(cs.Details, '$.SubDomain')
)
WHERE s.id = 23
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 4. FYI / FYI_ELITE Integration (service_id = 72)
-- =====================================================================
-- Rename: AccessID -> x-fyi-access-id, AccessSecret -> x-fyi-access-secret
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.AccessID', '$.AccessSecret'),
    '$."x-fyi-access-id"', JSON_EXTRACT(cs.Details, '$.AccessID'),
    '$."x-fyi-access-secret"', JSON_EXTRACT(cs.Details, '$.AccessSecret')
)
WHERE s.id = 72
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.AccessID') IS NOT NULL;

-- =====================================================================
-- 5. Hubspot Integration (service_id = 9)
-- =====================================================================
-- Rename: APIKey -> hubspot_token
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey'),
    '$.hubspot_token', JSON_EXTRACT(cs.Details, '$.APIKey')
)
WHERE s.id = 9
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 6. Jobman Integration (service_id = 8)
-- =====================================================================
-- Note: Jobman parameters may need to be added based on config requirements
-- Currently no rename operations identified from documentation
-- Placeholder for future parameter additions

-- =====================================================================
-- 7. Karbon HQ Integration (service_id = 50)
-- =====================================================================
-- Rename: AccessKey -> karbon_access_key, TenantAccessKey -> karbon_tenant_access_key
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.AccessKey', '$.TenantAccessKey'),
    '$.karbon_access_key', JSON_EXTRACT(cs.Details, '$.AccessKey'),
    '$.karbon_tenant_access_key', JSON_EXTRACT(cs.Details, '$.TenantAccessKey')
)
WHERE s.id = 50
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.AccessKey') IS NOT NULL;

-- =====================================================================
-- 8. Keypay Integration (service_id = 57)
-- =====================================================================
-- Rename: APIKey -> api_key
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey'),
    '$.api_key', JSON_EXTRACT(cs.Details, '$.APIKey')
)
WHERE s.id = 57
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 9. MYOB_DETAILED / MYOB Integration (service_id = 71)
-- =====================================================================
-- Rename multiple fields:
-- Id -> myob_company_file
-- Name -> myob_organisation
-- access_token -> myob_access_token
-- refresh_token -> myob_refresh_token
-- user_uid -> myob_user_uid
-- user_username -> myob_user_username
-- cfToken -> myob_cf_token
-- LinkOrganisationId -> etani_link_organisation_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.Id', '$.Name', '$.access_token', '$.refresh_token',
                '$.user_uid', '$.user_username', '$.cfToken', '$.LinkOrganisationId'),
    '$.myob_company_file', JSON_EXTRACT(cs.Details, '$.Id'),
    '$.myob_organisation', JSON_EXTRACT(cs.Details, '$.Name'),
    '$.myob_access_token', JSON_EXTRACT(cs.Details, '$.access_token'),
    '$.myob_refresh_token', JSON_EXTRACT(cs.Details, '$.refresh_token'),
    '$.myob_user_uid', JSON_EXTRACT(cs.Details, '$.user_uid'),
    '$.myob_user_username', JSON_EXTRACT(cs.Details, '$.user_username'),
    '$.myob_cf_token', JSON_EXTRACT(cs.Details, '$.cfToken'),
    '$.etani_link_organisation_id', JSON_EXTRACT(cs.Details, '$.LinkOrganisationId')
)
WHERE s.id = 71
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.Id') IS NOT NULL;

-- =====================================================================
-- 10. Payroll AU Integration (service_id = 21)
-- =====================================================================
-- Rename: access_token -> xero_access_token, refresh_token -> xero_refresh_token, tenantId -> xero_tenant_id
-- Note: This UPDATE will affect both Payroll AU and Payroll NZ since they share service_id = 21
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.access_token', '$.refresh_token', '$.tenantId'),
    '$.xero_access_token', JSON_EXTRACT(cs.Details, '$.access_token'),
    '$.xero_refresh_token', JSON_EXTRACT(cs.Details, '$.refresh_token'),
    '$.xero_tenant_id', JSON_EXTRACT(cs.Details, '$.tenantId')
)
WHERE s.id = 21
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.access_token') IS NOT NULL;

-- =====================================================================
-- 11. Payroll NZ Integration (service_id = 21)
-- =====================================================================
-- Note: Payroll NZ shares service_id = 21 with Payroll AU
-- The UPDATE statement above (section 10) handles both integrations

-- =====================================================================
-- 12. QBO Integration (service_id = 4)
-- =====================================================================
-- Rename: realmId -> realm_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.realmId'),
    '$.realm_id', JSON_EXTRACT(cs.Details, '$.realmId')
)
WHERE s.id = 4
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.realmId') IS NOT NULL;

-- =====================================================================
-- 13. Shopify Integration (service_id = 38)
-- =====================================================================
-- Rename: StoreURL -> store_url, AccessToken -> shopify_access_token
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.StoreURL', '$.AccessToken'),
    '$.store_url', JSON_EXTRACT(cs.Details, '$.StoreURL'),
    '$.shopify_access_token', JSON_EXTRACT(cs.Details, '$.AccessToken')
)
WHERE s.id = 38
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.StoreURL') IS NOT NULL;

-- =====================================================================
-- 14. Simpro Integration (service_id = 16)
-- =====================================================================
-- Rename: APIKey -> simpro_token, ClientID -> simpro_client_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey', '$.ClientID'),
    '$.simpro_token', JSON_EXTRACT(cs.Details, '$.APIKey'),
    '$.simpro_client_id', JSON_EXTRACT(cs.Details, '$.ClientID')
)
WHERE s.id = 16
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 15. Tidywork Integration (service_id = 62)
-- =====================================================================
-- Rename: APIBaseURL -> tidywork_domain, APIAccessToken -> tidywork_api_key
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIBaseURL', '$.APIAccessToken'),
    '$.tidywork_domain', JSON_EXTRACT(cs.Details, '$.APIBaseURL'),
    '$.tidywork_api_key', JSON_EXTRACT(cs.Details, '$.APIAccessToken')
)
WHERE s.id = 62
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIBaseURL') IS NOT NULL;

-- =====================================================================
-- 16. Unleashed Integration (service_id = 17)
-- =====================================================================
-- Rename: APIID -> unleashed_api_id, APIKey -> unleashed_api_private_key
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIID', '$.APIKey'),
    '$.unleashed_api_id', JSON_EXTRACT(cs.Details, '$.APIID'),
    '$.unleashed_api_private_key', JSON_EXTRACT(cs.Details, '$.APIKey')
)
WHERE s.id = 17
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIID') IS NOT NULL;

-- =====================================================================
-- 17. VinSight Integration (service_id = 43)
-- =====================================================================
-- Rename: APIKey -> vinsight_api_key
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.APIKey'),
    '$.vinsight_api_key', JSON_EXTRACT(cs.Details, '$.APIKey')
)
WHERE s.id = 43
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL;

-- =====================================================================
-- 18. WFM Integration (service_id = 69)
-- =====================================================================
-- Rename: access_token -> wfm_access_token, refresh_token -> wfm_refresh_token, TenantID -> wfm2_tenant_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.access_token', '$.refresh_token', '$.TenantID'),
    '$.wfm_access_token', JSON_EXTRACT(cs.Details, '$.access_token'),
    '$.wfm_refresh_token', JSON_EXTRACT(cs.Details, '$.refresh_token'),
    '$.wfm2_tenant_id', JSON_EXTRACT(cs.Details, '$.TenantID')
)
WHERE s.id = 69
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.access_token') IS NOT NULL;

-- =====================================================================
-- 19. XeroProject Integration (service_id = 25)
-- =====================================================================
-- Rename: access_token -> xero_access_token, refresh_token -> xero_refresh_token, tenantId -> xero_tenant_id
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.access_token', '$.refresh_token', '$.tenantId'),
    '$.xero_access_token', JSON_EXTRACT(cs.Details, '$.access_token'),
    '$.xero_refresh_token', JSON_EXTRACT(cs.Details, '$.refresh_token'),
    '$.xero_tenant_id', JSON_EXTRACT(cs.Details, '$.tenantId')
)
WHERE s.id = 25
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.access_token') IS NOT NULL;

-- =====================================================================
-- 20. DQ_MYOBAR Integration (service_id = 7)
-- =====================================================================
-- Rename multiple fields (same as MYOB but different service ID):
-- Id -> myob_company_file
-- Name -> myob_organisation
-- access_token -> myob_access_token
-- refresh_token -> myob_refresh_token
-- user_uid -> myob_user_uid
-- user_username -> myob_user_username
-- cfToken -> myob_cf_token
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.Id', '$.Name', '$.access_token', '$.refresh_token',
                '$.user_uid', '$.user_username', '$.cfToken'),
    '$.myob_company_file', JSON_EXTRACT(cs.Details, '$.Id'),
    '$.myob_organisation', JSON_EXTRACT(cs.Details, '$.Name'),
    '$.myob_access_token', JSON_EXTRACT(cs.Details, '$.access_token'),
    '$.myob_refresh_token', JSON_EXTRACT(cs.Details, '$.refresh_token'),
    '$.myob_user_uid', JSON_EXTRACT(cs.Details, '$.user_uid'),
    '$.myob_user_username', JSON_EXTRACT(cs.Details, '$.user_username'),
    '$.myob_cf_token', JSON_EXTRACT(cs.Details, '$.cfToken')
)
WHERE s.id = 7
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.Id') IS NOT NULL;

-- =====================================================================
-- 21. Accredo Integration (service_id = TBD - Not in INTEGRATION_PARAMETERS_COMPLETE.md)
-- =====================================================================
-- Rename: apiBaseURL -> accredo_domain, apiClientID -> accredo_client_id,
--         apiPassword -> accredo_password, apiUsername -> accredo_username,
--         apiCompanyName -> accredo_company_name
-- Note: Service ID not found in INTEGRATION_PARAMETERS_COMPLETE.md - using name-based filtering
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.apiBaseURL', '$.apiClientID', '$.apiPassword',
                '$.apiUsername', '$.apiCompanyName'),
    '$.accredo_domain', JSON_EXTRACT(cs.Details, '$.apiBaseURL'),
    '$.accredo_client_id', JSON_EXTRACT(cs.Details, '$.apiClientID'),
    '$.accredo_password', JSON_EXTRACT(cs.Details, '$.apiPassword'),
    '$.accredo_username', JSON_EXTRACT(cs.Details, '$.apiUsername'),
    '$.accredo_company_name', JSON_EXTRACT(cs.Details, '$.apiCompanyName')
)
WHERE LOWER(s.Name) = 'accredo'
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.apiBaseURL') IS NOT NULL;

-- =====================================================================
-- ADD MISSING PARAMETERS
-- =====================================================================
-- These UPDATE statements add parameters that exist in env_vars_config
-- but are missing from the database Details column
--
-- Missing Parameters Summary:
-- - Hubspot: hubspot_client_id, hubspot_client_secret, hubspot_refresh_token,
--            hubspot_portal_id, storage_account_name, storage_access_key, file_share_name
-- - Jobman: All parameters (no sample data in database)
-- - Keypay: api_username
-- - MYOB_DETAILED: myob_client_id, myob_client_secret, myob_api_key,
--                  myob_api_version, myob_api_endpoint
-- - Payroll AU/NZ: xero_client_id, xero_client_secret, storage_account_name,
--                  storage_access_key, file_share_name
-- - Shopify: api_version
-- - Simpro: simpro_company_id, simpro_domain, simpro_upg_api_key, simpro_upg_client_id
-- - Unleashed: unleashed_client_type
-- - WFM: wfm_client_id, wfm_client_secret, storage_account_name,
--        storage_access_key, file_share_name
-- - XeroProject: xero_client_id, xero_client_secret
-- - DQ_MYOBAR: myob_client_id, myob_client_secret, myob_start_date, myob_end_date,
--              myob_reporting_basis, myob_year_end_adjust, myob_as_of_date,
--              myob_api_key, myob_api_version, myob_api_endpoint
-- - Accredo: accredo_oauth_domain
--
-- Note: Parameters are added with NULL values (except defaults like api_version,
--       myob_api_version, etc.) and must be populated manually or via application
-- =====================================================================

-- =====================================================================
-- Hubspot Integration (service_id = 9) - Add missing OAuth2 and storage parameters
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.hubspot_client_id', NULL,
    '$.hubspot_client_secret', NULL,
    '$.hubspot_refresh_token', NULL,
    '$.hubspot_portal_id', NULL,
    '$.storage_account_name', NULL,
    '$.storage_access_key', NULL,
    '$.file_share_name', 'tokens'
)
WHERE s.id = 9
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.hubspot_client_id') IS NULL;

-- =====================================================================
-- Jobman Integration (service_id = 8) - Add all required parameters
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    COALESCE(cs.Details, '{}'),
    '$.jobman_client_id', NULL,
    '$.jobman_client_secret', NULL,
    '$.ApiToken', NULL
)
WHERE s.id = 8
AND (cs.Details IS NULL OR JSON_EXTRACT(cs.Details, '$.jobman_client_id') IS NULL);

-- =====================================================================
-- Keypay Integration (service_id = 57) - Add missing api_username
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.api_username', NULL
)
WHERE s.id = 57
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.api_username') IS NULL;

-- =====================================================================
-- MYOB_DETAILED Integration (service_id = 71) - Add missing API configuration
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.myob_client_id', NULL,
    '$.myob_client_secret', NULL,
    '$.myob_api_key', NULL,
    '$.myob_api_version', 'v2',
    '$.myob_api_endpoint', 'https://arl2.api.myob.com'
)
WHERE s.id = 71
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.myob_client_id') IS NULL;

-- =====================================================================
-- Payroll AU Integration (service_id = 21) - Add OAuth2 client and storage parameters
-- =====================================================================
-- Note: This affects both Payroll AU and Payroll NZ since they share service_id = 21
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.xero_client_id', NULL,
    '$.xero_client_secret', NULL,
    '$.storage_account_name', NULL,
    '$.storage_access_key', NULL,
    '$.file_share_name', 'tokens'
)
WHERE s.id = 21
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.xero_client_id') IS NULL;

-- =====================================================================
-- Shopify Integration (service_id = 38) - Add api_version
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.api_version', '2024-01'
)
WHERE s.id = 38
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.api_version') IS NULL;

-- =====================================================================
-- Simpro Integration (service_id = 16) - Add missing domain and UPG parameters
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.simpro_company_id', NULL,
    '$.simpro_domain', NULL,
    '$.simpro_upg_api_key', NULL,
    '$.simpro_upg_client_id', NULL
)
WHERE s.id = 16
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.simpro_company_id') IS NULL;

-- =====================================================================
-- Unleashed Integration (service_id = 17) - Add client_type
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.unleashed_client_type', NULL
)
WHERE s.id = 17
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.unleashed_client_type') IS NULL;

-- =====================================================================
-- WFM Integration (service_id = 69) - Add OAuth2 client and storage parameters
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.wfm_client_id', NULL,
    '$.wfm_client_secret', NULL,
    '$.storage_account_name', NULL,
    '$.storage_access_key', NULL,
    '$.file_share_name', 'tokens'
)
WHERE s.id = 69
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.wfm_client_id') IS NULL;

-- =====================================================================
-- XeroProject Integration (service_id = 25) - Add OAuth2 client credentials
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.xero_client_id', NULL,
    '$.xero_client_secret', NULL
)
WHERE s.id = 25
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.xero_client_id') IS NULL;

-- =====================================================================
-- DQ_MYOBAR Integration (service_id = 7) - Add all missing MYOB parameters
-- =====================================================================
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.myob_client_id', NULL,
    '$.myob_client_secret', NULL,
    '$.myob_start_date', NULL,
    '$.myob_end_date', NULL,
    '$.myob_reporting_basis', 'Cash',
    '$.myob_year_end_adjust', 'false',
    '$.myob_as_of_date', NULL,
    '$.myob_api_key', NULL,
    '$.myob_api_version', 'v2',
    '$.myob_api_endpoint', 'https://arl2.api.myob.com'
)
WHERE s.id = 7
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.myob_client_id') IS NULL;

-- =====================================================================
-- Accredo Integration - Add missing oauth_domain
-- =====================================================================
-- Note: Using name-based filtering since service ID not found in INTEGRATION_PARAMETERS_COMPLETE.md
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    cs.Details,
    '$.accredo_oauth_domain', NULL
)
WHERE LOWER(s.Name) = 'accredo'
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.accredo_oauth_domain') IS NULL;

-- =====================================================================
-- Verification Queries
-- =====================================================================
-- Run these queries to verify the changes were applied correctly

-- Check CIN7
SELECT s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE LOWER(s.Name) = 'cin7' AND cs.Details IS NOT NULL
LIMIT 5;

-- Check DEAR
SELECT s.Name, cs.Client, cs.Details
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE LOWER(s.Name) = 'dear' AND cs.Details IS NOT NULL
LIMIT 5;

-- Check all integrations - count of records with old vs new parameter names
SELECT
    s.Name as integration,
    COUNT(*) as total_records,
    SUM(CASE WHEN JSON_EXTRACT(cs.Details, '$.APIKey') IS NOT NULL THEN 1 ELSE 0 END) as has_old_APIKey,
    SUM(CASE WHEN JSON_EXTRACT(cs.Details, '$.api_key') IS NOT NULL THEN 1 ELSE 0 END) as has_new_api_key,
    SUM(CASE WHEN JSON_EXTRACT(cs.Details, '$.APIUsername') IS NOT NULL THEN 1 ELSE 0 END) as has_old_APIUsername,
    SUM(CASE WHEN JSON_EXTRACT(cs.Details, '$.api_username') IS NOT NULL THEN 1 ELSE 0 END) as has_new_api_username
FROM client_service cs
JOIN service s ON cs.Service = s.id
WHERE cs.Details IS NOT NULL
GROUP BY s.Name;

-- =====================================================================
-- ROLLBACK Script (if needed)
-- =====================================================================
-- IMPORTANT: This script is destructive and will overwrite the renamed fields.
-- Only run this if you need to revert the changes.
-- Make sure to backup your database before running this script!
/*

-- Rollback CIN7
UPDATE client_service cs
JOIN service s ON cs.Service = s.id
SET cs.Details = JSON_SET(
    JSON_REMOVE(cs.Details, '$.api_key', '$.api_username'),
    '$.APIKey', JSON_EXTRACT(cs.Details, '$.api_key'),
    '$.APIUsername', JSON_EXTRACT(cs.Details, '$.api_username')
)
WHERE LOWER(s.Name) = 'cin7'
AND cs.Details IS NOT NULL
AND JSON_EXTRACT(cs.Details, '$.api_key') IS NOT NULL;

-- Add similar rollback statements for other integrations as needed...

*/

-- =====================================================================
-- End of Script
-- =====================================================================
