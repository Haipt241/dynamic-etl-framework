-- Setup integration_name column and populate data for SERVICE_TO_INTEGRATION mapping
-- This implements TODO: "Move to vibedb_cms.service table (add integration_name column)"

USE vibedb_cms;

-- Add integration_name column (nullable, unique when not null)
ALTER TABLE service
ADD COLUMN integration_name VARCHAR(100) NULL COMMENT 'Integration folder name for dynamic integrations';

-- Add unique constraint for non-null values
ALTER TABLE service
ADD CONSTRAINT uk_service_integration_name UNIQUE (integration_name);

-- Populate integration_name for the 19 services from hardcoded SERVICE_TO_INTEGRATION mapping
UPDATE service SET integration_name = 'xeroblue' WHERE id = 1;        -- Xero
UPDATE service SET integration_name = 'qbo' WHERE id = 4;             -- Quickbooks
UPDATE service SET integration_name = 'dq_myobar' WHERE id = 7;       -- MYOB Business
UPDATE service SET integration_name = 'hubspot' WHERE id = 9;         -- Hubspot - CRM
UPDATE service SET integration_name = 'cin7_dear' WHERE id = 14;      -- Dear Inventory
UPDATE service SET integration_name = 'simpro' WHERE id = 16;         -- SimPro
UPDATE service SET integration_name = 'unleashed' WHERE id = 17;      -- Unleashed
UPDATE service SET integration_name = 'payroll_au' WHERE id = 21;     -- Xero Payroll
UPDATE service SET integration_name = 'deputy' WHERE id = 23;         -- Deputy
UPDATE service SET integration_name = 'xeroproject' WHERE id = 25;    -- Xero Projects
UPDATE service SET integration_name = 'cin7' WHERE id = 27;           -- Cin7
UPDATE service SET integration_name = 'shopify' WHERE id = 38;        -- Shopify
UPDATE service SET integration_name = 'vinsight' WHERE id = 43;       -- Vinsight
UPDATE service SET integration_name = 'karbon_hq' WHERE id = 50;      -- Karbon
UPDATE service SET integration_name = 'keypay' WHERE id = 57;         -- KeyPay
UPDATE service SET integration_name = 'tidywork' WHERE id = 62;       -- TidyWork
UPDATE service SET integration_name = 'wfm' WHERE id = 69;            -- Workflow Max Bluerock
UPDATE service SET integration_name = 'myob_detailed' WHERE id = 71;  -- MYOB Business - DETAILED
UPDATE service SET integration_name = 'fyi' WHERE id = 72;            -- FYI Elite

-- Verify the mapping
SELECT
    id,
    Name,
    integration_name
FROM service
WHERE integration_name IS NOT NULL
ORDER BY id;

-- Check that we have exactly 19 integration mappings
SELECT COUNT(*) as integration_count FROM service WHERE integration_name IS NOT NULL;