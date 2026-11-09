DROP TABLE IF EXISTS c2013_7035_qbo_companyinfostage

-- Disable invisible primary key generation
SET sql_generate_invisible_primary_key = off;
-- CompanyInfo Stage Table
CREATE TABLE IF NOT EXISTS c2013_7035_qbo_companyinfostage (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `SupportedLanguages` VARCHAR(50) NULL,
    `CompanyName` VARCHAR(255) NULL,
    `Country` VARCHAR(50) NULL,
    `sparse` BOOLEAN NULL,
    `Id` VARCHAR(50) NULL,
    `FiscalYearStartMonth` VARCHAR(50) NULL,
    `LegalName` VARCHAR(255) NULL,
    `CompanyStartDate` DATE NULL,
    `EmployerId` VARCHAR(50) NULL,
    `nameValue` TEXT NULL,

    -- Legal Address Fields
    `legal_addr_city` VARCHAR(100) NULL,
    `legal_addr_country` VARCHAR(50) NULL,
    `legal_addr_line1` VARCHAR(255) NULL,
    `legal_addr_postal_code` VARCHAR(20) NULL,
    `legal_addr_country_sub_division_code` VARCHAR(50) NULL,
    `legal_addr_id` VARCHAR(50) NULL,

    -- Company Address Fields
    `company_addr_city` VARCHAR(100) NULL,
    `company_addr_country` VARCHAR(50) NULL,
    `company_addr_line1` VARCHAR(255) NULL,
    `company_addr_postal_code` VARCHAR(20) NULL,
    `company_addr_country_sub_division_code` VARCHAR(50) NULL,
    `company_addr_id` VARCHAR(50) NULL,

    -- Customer Communication Address Fields
    `customer_comm_addr_city` VARCHAR(100) NULL,
    `customer_comm_addr_country` VARCHAR(50) NULL,
    `customer_comm_addr_line1` VARCHAR(255) NULL,
    `customer_comm_addr_postal_code` VARCHAR(20) NULL,
    `customer_comm_addr_country_sub_division_code` VARCHAR(50) NULL,
    `customer_comm_addr_id` VARCHAR(50) NULL,

    -- Contact Information
    `primary_phone_free_form_number` VARCHAR(50) NULL,
    `email_address` VARCHAR(255) NULL,

    -- Metadata
    `metadata_create_time` DATETIME NULL,
    `metadata_last_updated_time` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Indexes for CompanyInfo Stage Table
CREATE INDEX IF NOT EXISTS idx_companyinfo_stage_client_org 
ON c2013_7035_qbo_companyinfostage(ClientID, OrganisationID);

CREATE INDEX IF NOT EXISTS idx_companyinfo_stage_id 
ON c2013_7035_qbo_companyinfostage(Id);

-- Disable invisible primary key generation
SET sql_generate_invisible_primary_key = off;

DROP TABLE IF EXISTS c2013_qbo_companyinfo
-- CompanyInfo Production Table
CREATE TABLE IF NOT EXISTS c2013_qbo_companyinfo (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `SupportedLanguages` VARCHAR(50) NULL,
    `CompanyName` VARCHAR(255) NULL,
    `Country` VARCHAR(50) NULL,
    `sparse` BOOLEAN NULL,
    `Id` VARCHAR(50) NULL,
    `FiscalYearStartMonth` VARCHAR(50) NULL,
    `LegalName` VARCHAR(255) NULL,
    `CompanyStartDate` DATE NULL,
    `EmployerId` VARCHAR(50) NULL,
    `nameValue` TEXT NULL,

    -- Legal Address Fields
    `legal_addr_city` VARCHAR(100) NULL,
    `legal_addr_country` VARCHAR(50) NULL,
    `legal_addr_line1` VARCHAR(255) NULL,
    `legal_addr_postal_code` VARCHAR(20) NULL,
    `legal_addr_country_sub_division_code` VARCHAR(50) NULL,
    `legal_addr_id` VARCHAR(50) NULL,

    -- Company Address Fields
    `company_addr_city` VARCHAR(100) NULL,
    `company_addr_country` VARCHAR(50) NULL,
    `company_addr_line1` VARCHAR(255) NULL,
    `company_addr_postal_code` VARCHAR(20) NULL,
    `company_addr_country_sub_division_code` VARCHAR(50) NULL,
    `company_addr_id` VARCHAR(50) NULL,

    -- Customer Communication Address Fields
    `customer_comm_addr_city` VARCHAR(100) NULL,
    `customer_comm_addr_country` VARCHAR(50) NULL,
    `customer_comm_addr_line1` VARCHAR(255) NULL,
    `customer_comm_addr_postal_code` VARCHAR(20) NULL,
    `customer_comm_addr_country_sub_division_code` VARCHAR(50) NULL,
    `customer_comm_addr_id` VARCHAR(50) NULL,

    -- Contact Information
    `primary_phone_free_form_number` VARCHAR(50) NULL,
    `email_address` VARCHAR(255) NULL,

    -- Metadata
    `metadata_create_time` DATETIME NULL,
    `metadata_last_updated_time` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Indexes for CompanyInfo Production Table
CREATE INDEX IF NOT EXISTS idx_companyinfo_client_org 
ON c2013_qbo_companyinfo(ClientID, OrganisationID);

-- CompanyInfo View
CREATE OR REPLACE VIEW vw_qbo_companyinfo AS
SELECT 
    c.*,
    COALESCE(c.CompanyName, c.LegalName) as DisplayName,
    CONCAT(
        COALESCE(c.company_addr_line1, ''),
        CASE 
            WHEN c.company_addr_city IS NOT NULL THEN CONCAT(', ', c.company_addr_city)
            ELSE ''
        END,
        CASE 
            WHEN c.company_addr_country_sub_division_code IS NOT NULL THEN CONCAT(', ', c.company_addr_country_sub_division_code)
            ELSE ''
        END,
        CASE 
            WHEN c.company_addr_postal_code IS NOT NULL THEN CONCAT(' ', c.company_addr_postal_code)
            ELSE ''
        END,
        CASE 
            WHEN c.company_addr_country IS NOT NULL THEN CONCAT(', ', c.company_addr_country)
            ELSE ''
        END
    ) as FormattedAddress
FROM c2013_qbo_companyinfo c;

-- JournalEntry Stage Table
CREATE TABLE IF NOT EXISTS c2013_7035_qbo_journalentrystage (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `TxnDate` DATE NULL,
    `sparse` BOOLEAN NULL,
    `Id` VARCHAR(50) NULL,
    `Adjustment` BOOLEAN NULL,
    `DocNumber` VARCHAR(50) NULL,
    `PrivateNote` TEXT NULL,
    `CurrencyRef` VARCHAR(50) NULL,
    `ExchangeRate` DECIMAL(19,4) NULL,
    `HomeTotalAmt` DECIMAL(19,4) NULL,
    `TotalAmt` DECIMAL(19,4) NULL,

    -- Line Item Fields
    `Line_Id` VARCHAR(50) NULL,
    `Line_Description` TEXT NULL,
    `Line_Amount` DECIMAL(19,4) NULL,
    `Line_DetailType` VARCHAR(50) NULL,
    
    -- JournalEntryLineDetail Fields
    `Line_PostingType` VARCHAR(50) NULL,
    
    -- Account Reference Fields
    `Line_AccountRef_name` VARCHAR(255) NULL,
    `Line_AccountRef_value` VARCHAR(50) NULL,
    
    -- Entity Reference Fields
    `Line_Entity_Type` VARCHAR(50) NULL,
    `Line_Entity_EntityRef_name` VARCHAR(255) NULL,
    `Line_Entity_EntityRef_value` VARCHAR(50) NULL,
    
    -- Project Reference Fields
    `Line_ProjectRef_value` VARCHAR(50) NULL,

    -- Metadata
    `metadata_create_time` DATETIME NULL,
    `metadata_last_updated_time` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Indexes for JournalEntry Stage Table
CREATE INDEX IF NOT EXISTS idx_journalentry_stage_client_org 
ON c2013_7035_qbo_journalentrystage(ClientID, OrganisationID);

CREATE INDEX IF NOT EXISTS idx_journalentry_stage_id 
ON c2013_7035_qbo_journalentrystage(Id);

-- JournalEntry Production Table
CREATE TABLE IF NOT EXISTS c2013_qbo_journalentry (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `TxnDate` DATE NULL,
    `sparse` BOOLEAN NULL,
    `Id` VARCHAR(50) NULL,
    `Adjustment` BOOLEAN NULL,
    `DocNumber` VARCHAR(50) NULL,
    `PrivateNote` TEXT NULL,
    `CurrencyRef` VARCHAR(50) NULL,
    `ExchangeRate` DECIMAL(19,4) NULL,
    `HomeTotalAmt` DECIMAL(19,4) NULL,
    `TotalAmt` DECIMAL(19,4) NULL,

    -- Line Item Fields
    `Line_Id` VARCHAR(50) NULL,
    `Line_Description` TEXT NULL,
    `Line_Amount` DECIMAL(19,4) NULL,
    `Line_DetailType` VARCHAR(50) NULL,
    
    -- JournalEntryLineDetail Fields
    `Line_PostingType` VARCHAR(50) NULL,
    
    -- Account Reference Fields
    `Line_AccountRef_name` VARCHAR(255) NULL,
    `Line_AccountRef_value` VARCHAR(50) NULL,
    
    -- Entity Reference Fields
    `Line_Entity_Type` VARCHAR(50) NULL,
    `Line_Entity_EntityRef_name` VARCHAR(255) NULL,
    `Line_Entity_EntityRef_value` VARCHAR(50) NULL,
    
    -- Project Reference Fields
    `Line_ProjectRef_value` VARCHAR(50) NULL,

    -- Metadata
    `metadata_create_time` DATETIME NULL,
    `metadata_last_updated_time` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Id, Line_Id, ClientID, OrganisationID)
);

-- Create Indexes for JournalEntry Production Table
CREATE INDEX IF NOT EXISTS idx_journalentry_client_org 
ON c2013_qbo_journalentry(ClientID, OrganisationID);

-- JournalEntry View
CREATE OR REPLACE VIEW vw_qbo_journalentry AS
SELECT 
    j.*,
    -- Computed Fields
    CASE 
        WHEN j.Adjustment = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsAdjustment,
    DATE_FORMAT(j.TxnDate, '%Y-%m-%d') AS FormattedTxnDate,
    DATE_FORMAT(j.metadata_create_time, '%Y-%m-%d %H:%i:%s') AS FormattedCreateTime,
    DATE_FORMAT(j.metadata_last_updated_time, '%Y-%m-%d %H:%i:%s') AS FormattedLastUpdatedTime,
    -- Line Item Computed Fields
    CONCAT(j.Line_AccountRef_name, ' (', j.Line_AccountRef_value, ')') AS AccountDisplay,
    CONCAT(j.Line_Entity_EntityRef_name, ' (', j.Line_Entity_EntityRef_value, ')') AS EntityDisplay
FROM c2013_qbo_journalentry j;

-- Attachable Stage Table
CREATE TABLE IF NOT EXISTS c2013_7035_qbo_attachablestage (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `Id` VARCHAR(50) NULL,
    `FileName` VARCHAR(255) NULL,
    `ContentType` VARCHAR(100) NULL,
    `Size` INT NULL,
    `Note` TEXT NULL,
    `PlaceName` VARCHAR(255) NULL,
    `sparse` BOOLEAN NULL,

    -- LatLong Fields
    `LatLong_Value` VARCHAR(50) NULL,
    `LatLong_Lat` DECIMAL(10,6) NULL,
    `LatLong_Long` DECIMAL(10,6) NULL,

    -- AttachableRef Fields
    `AttachableRef_EntityRef_Type` VARCHAR(50) NULL,
    `AttachableRef_EntityRef_Value` VARCHAR(50) NULL,
    `AttachableRef_EntityRef_Name` VARCHAR(255) NULL,
    `AttachableRef_IncludeOnSend` BOOLEAN NULL,

    -- Metadata
    `metadata_CreateTime` DATETIME NULL,
    `metadata_LastUpdatedTime` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Indexes for Attachable Stage Table
CREATE INDEX IF NOT EXISTS idx_attachable_stage_client_org 
ON c2013_7035_qbo_attachablestage(ClientID, OrganisationID);

CREATE INDEX IF NOT EXISTS idx_attachable_stage_id 
ON c2013_7035_qbo_attachablestage(Id);

-- Attachable Production Table
CREATE TABLE IF NOT EXISTS c2013_qbo_attachable (
    -- Basic Information
    `SyncToken` VARCHAR(50) NULL,
    `domain` VARCHAR(50) NULL,
    `Id` VARCHAR(50) NULL,
    `FileName` VARCHAR(255) NULL,
    `ContentType` VARCHAR(100) NULL,
    `Size` INT NULL,
    `Note` TEXT NULL,
    `PlaceName` VARCHAR(255) NULL,
    `sparse` BOOLEAN NULL,

    -- LatLong Fields
    `LatLong_Value` VARCHAR(50) NULL,
    `LatLong_Lat` DECIMAL(10,6) NULL,
    `LatLong_Long` DECIMAL(10,6) NULL,

    -- AttachableRef Fields
    `AttachableRef_EntityRef_Type` VARCHAR(50) NULL,
    `AttachableRef_EntityRef_Value` VARCHAR(50) NULL,
    `AttachableRef_EntityRef_Name` VARCHAR(255) NULL,
    `AttachableRef_IncludeOnSend` BOOLEAN NULL,

    -- Metadata
    `metadata_CreateTime` DATETIME NULL,
    `metadata_LastUpdatedTime` DATETIME NULL,

    -- System Fields
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL,
    `CreatedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `ModifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (Id, ClientID, OrganisationID)
);

-- Create Indexes for Attachable Production Table
CREATE INDEX IF NOT EXISTS idx_attachable_client_org 
ON c2013_qbo_attachable(ClientID, OrganisationID);

-- Attachable View
CREATE OR REPLACE VIEW vw_qbo_attachable AS
SELECT 
    a.*,
    -- Computed Fields
    CASE 
        WHEN a.sparse = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsSparse,
    CASE 
        WHEN a.AttachableRef_IncludeOnSend = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsIncludedOnSend,
    DATE_FORMAT(a.metadata_CreateTime, '%Y-%m-%d %H:%i:%s') AS FormattedCreateTime,
    DATE_FORMAT(a.metadata_LastUpdatedTime, '%Y-%m-%d %H:%i:%s') AS FormattedLastUpdatedTime,
    -- Entity Reference Display
    CONCAT(a.AttachableRef_EntityRef_Type, ' (', a.AttachableRef_EntityRef_Value, ')') AS EntityDisplay,
    -- File Information
    CASE 
        WHEN a.Size IS NOT NULL THEN CONCAT(ROUND(a.Size/1024, 2), ' KB')
        ELSE NULL
    END AS FormattedSize,
    -- Location Information
    CASE 
        WHEN a.LatLong_Lat IS NOT NULL AND a.LatLong_Long IS NOT NULL 
        THEN CONCAT(a.LatLong_Lat, ', ', a.LatLong_Long)
        ELSE NULL
    END AS FormattedLocation
FROM c2013_qbo_attachable a;

-- Attachable Stage View
CREATE OR REPLACE VIEW vw_qbo_attachable_stage AS
SELECT 
    a.*,
    -- Computed Fields
    CASE 
        WHEN a.sparse = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsSparse,
    CASE 
        WHEN a.AttachableRef_IncludeOnSend = 1 THEN 'Yes'
        ELSE 'No'
    END AS IsIncludedOnSend,
    DATE_FORMAT(a.metadata_CreateTime, '%Y-%m-%d %H:%i:%s') AS FormattedCreateTime,
    DATE_FORMAT(a.metadata_LastUpdatedTime, '%Y-%m-%d %H:%i:%s') AS FormattedLastUpdatedTime,
    -- Entity Reference Display
    CONCAT(a.AttachableRef_EntityRef_Type, ' (', a.AttachableRef_EntityRef_Value, ')') AS EntityDisplay,
    -- File Information
    CASE 
        WHEN a.Size IS NOT NULL THEN CONCAT(ROUND(a.Size/1024, 2), ' KB')
        ELSE NULL
    END AS FormattedSize,
    -- Location Information
    CASE 
        WHEN a.LatLong_Lat IS NOT NULL AND a.LatLong_Long IS NOT NULL 
        THEN CONCAT(a.LatLong_Lat, ', ', a.LatLong_Long)
        ELSE NULL
    END AS FormattedLocation
FROM c2013_7035_qbo_attachablestage a;