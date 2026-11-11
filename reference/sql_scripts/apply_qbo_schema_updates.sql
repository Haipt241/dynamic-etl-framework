-- =====================================================
-- QuickBooks Online Schema Update Script
-- =====================================================
-- This script is used to apply schema updates to QBO tables
-- when the API fields change or new fields are discovered
-- 
-- Usage: 
-- 1. Replace {clientID} and {orgID} with actual values
-- 2. Uncomment the sections for the endpoints you want to update
-- 3. Run the script to drop and recreate tables with new schema
-- =====================================================

-- Set your client and organization IDs here
-- For BIGOLESHOECOMPANY demo:
-- SET @clientID = '2013';  -- For BIGOLESHOECOMPANY_CLIENT2013
-- SET @orgID = '7035';     -- For OrganisationID 7035

-- =====================================================
-- BIGOLESHOECOMPANY COMPLETE SCHEMA SETUP
-- =====================================================
-- This section creates all tables, procedures, and views for BIGOLESHOECOMPANY
-- Replace 2013 and 7035 with actual values if different

-- Execute all Production Tables
source SQL Scripts/QBO-PROD-TABLES.sql;

-- Execute all Stage Tables  
source SQL Scripts/QBO-STAGE-TABLES.sql;

-- Execute all Stored Procedures
source SQL Scripts/QBO-STORED-PROCEDURES.sql;

-- Execute all Views
source SQL Scripts/QBO-VIEWS.sql;

-- =====================================================
-- CUSTOMER ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Customer tables

/*
-- Drop existing Customer tables
DROP TABLE IF EXISTS c{clientID}_qbo_customer;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_customerstage;

-- Create Customer stage table with updated schema
CREATE TABLE IF NOT EXISTS c{clientID}_{orgID}_qbo_customerstage (
    -- Primary identifier fields
    Id VARCHAR(255),
    SyncToken VARCHAR(255),
    
    -- Name fields
    DisplayName VARCHAR(255),
    Title VARCHAR(255),
    GivenName VARCHAR(255),
    MiddleName VARCHAR(255),
    FamilyName VARCHAR(255),
    Suffix VARCHAR(255),
    CompanyName VARCHAR(255),
    PrintOnCheckName VARCHAR(255),
    FullyQualifiedName VARCHAR(500),
    
    -- Status and type fields
    Active BOOLEAN,
    Taxable BOOLEAN,
    Job BOOLEAN,
    BillWithParent BOOLEAN,
    IsProject BOOLEAN,
    IsStatementWithParent BOOLEAN,
    IsCDS BOOLEAN,
    
    -- Balance fields
    Balance DECIMAL(18,2),
    BalanceWithJobs DECIMAL(18,2),
    OpenBalanceDate DATE,
    TotalRevenue DECIMAL(18,2),
    TotalExpense DECIMAL(18,2),
    
    -- Currency fields
    CurrencyRef_value VARCHAR(255),
    CurrencyRef_name VARCHAR(255),
    
    -- Delivery and communication preferences
    PreferredDeliveryMethod VARCHAR(255),
    
    -- Contact information
    PrimaryPhone_FreeFormNumber VARCHAR(255),
    AlternatePhone_FreeFormNumber VARCHAR(255),
    Mobile_FreeFormNumber VARCHAR(255),
    Fax_FreeFormNumber VARCHAR(255),
    PrimaryEmailAddr_Address VARCHAR(255),
    WebAddr_URI VARCHAR(255),
    
    -- Billing address
    BillAddr_Id VARCHAR(255),
    BillAddr_Line1 VARCHAR(255),
    BillAddr_Line2 VARCHAR(255),
    BillAddr_Line3 VARCHAR(255),
    BillAddr_Line4 VARCHAR(255),
    BillAddr_Line5 VARCHAR(255),
    BillAddr_City VARCHAR(255),
    BillAddr_Country VARCHAR(255),
    BillAddr_CountrySubDivisionCode VARCHAR(255),
    BillAddr_PostalCode VARCHAR(255),
    BillAddr_Lat DECIMAL(10,6),
    BillAddr_Long DECIMAL(10,6),
    
    -- Shipping address
    ShipAddr_Id VARCHAR(255),
    ShipAddr_Line1 VARCHAR(255),
    ShipAddr_Line2 VARCHAR(255),
    ShipAddr_Line3 VARCHAR(255),
    ShipAddr_Line4 VARCHAR(255),
    ShipAddr_Line5 VARCHAR(255),
    ShipAddr_City VARCHAR(255),
    ShipAddr_Country VARCHAR(255),
    ShipAddr_CountrySubDivisionCode VARCHAR(255),
    ShipAddr_PostalCode VARCHAR(255),
    ShipAddr_Lat DECIMAL(10,6),
    ShipAddr_Long DECIMAL(10,6),
    
    -- Other address (optional)
    OtherAddr_Id VARCHAR(255),
    OtherAddr_Line1 VARCHAR(255),
    OtherAddr_Line2 VARCHAR(255),
    OtherAddr_Line3 VARCHAR(255),
    OtherAddr_Line4 VARCHAR(255),
    OtherAddr_Line5 VARCHAR(255),
    OtherAddr_City VARCHAR(255),
    OtherAddr_Country VARCHAR(255),
    OtherAddr_CountrySubDivisionCode VARCHAR(255),
    OtherAddr_PostalCode VARCHAR(255),
    OtherAddr_Lat DECIMAL(10,6),
    OtherAddr_Long DECIMAL(10,6),
    
    -- Reference fields
    ParentRef_value VARCHAR(255),
    ParentRef_name VARCHAR(255),
    Level INT,
    SalesTermRef_value VARCHAR(255),
    SalesTermRef_name VARCHAR(255),
    PaymentMethodRef_value VARCHAR(255),
    PaymentMethodRef_name VARCHAR(255),
    DefaultTaxCodeRef_value VARCHAR(255),
    DefaultTaxCodeRef_name VARCHAR(255),
    CustomerTypeRef_value VARCHAR(255),
    CustomerTypeRef_name VARCHAR(255),
    ARAccountRef_value VARCHAR(255),
    ARAccountRef_name VARCHAR(255),
    ShipMethodRef_value VARCHAR(255),
    ShipMethodRef_name VARCHAR(255),
    
    -- Tax fields
    ResaleNum VARCHAR(255),
    PrimaryTaxIdentifier VARCHAR(255),
    SecondaryTaxIdentifier VARCHAR(255),
    TaxExemptionReasonId INT,
    GSTRegistrationType VARCHAR(255),
    GSTRegsitrationNumber VARCHAR(255),
    
    -- Other fields
    Notes VARCHAR(4000),
    Source VARCHAR(255),
    V4IDPseudonym VARCHAR(255),
    
    -- Custom fields (stored as JSON)
    CustomField TEXT,
    
    -- Attachable references (stored as JSON)
    AttachableRef TEXT,
    
    -- System fields
    sparse BOOLEAN,
    domain VARCHAR(255),
    
    -- Metadata fields
    MetaData_CreateTime DATETIME,
    MetaData_LastUpdatedTime DATETIME,
    MetaData_LastChangedByRef VARCHAR(255),
    MetaData_SyncErrorGuid VARCHAR(255),
    
    -- Client tracking fields
    ClientID VARCHAR(255),
    OrganisationID INT
);

-- Create Customer production table with updated schema
CREATE TABLE IF NOT EXISTS c{clientID}_qbo_customer (
    -- [Same fields as stage table above]
    -- Primary identifier fields
    Id VARCHAR(255),
    SyncToken VARCHAR(255),
    
    -- Name fields
    DisplayName VARCHAR(255),
    Title VARCHAR(255),
    GivenName VARCHAR(255),
    MiddleName VARCHAR(255),
    FamilyName VARCHAR(255),
    Suffix VARCHAR(255),
    CompanyName VARCHAR(255),
    PrintOnCheckName VARCHAR(255),
    FullyQualifiedName VARCHAR(500),
    
    -- Status and type fields
    Active BOOLEAN,
    Taxable BOOLEAN,
    Job BOOLEAN,
    BillWithParent BOOLEAN,
    IsProject BOOLEAN,
    IsStatementWithParent BOOLEAN,
    IsCDS BOOLEAN,
    
    -- Balance fields
    Balance DECIMAL(18,2),
    BalanceWithJobs DECIMAL(18,2),
    OpenBalanceDate DATE,
    TotalRevenue DECIMAL(18,2),
    TotalExpense DECIMAL(18,2),
    
    -- Currency fields
    CurrencyRef_value VARCHAR(255),
    CurrencyRef_name VARCHAR(255),
    
    -- Delivery and communication preferences
    PreferredDeliveryMethod VARCHAR(255),
    
    -- Contact information
    PrimaryPhone_FreeFormNumber VARCHAR(255),
    AlternatePhone_FreeFormNumber VARCHAR(255),
    Mobile_FreeFormNumber VARCHAR(255),
    Fax_FreeFormNumber VARCHAR(255),
    PrimaryEmailAddr_Address VARCHAR(255),
    WebAddr_URI VARCHAR(255),
    
    -- Billing address
    BillAddr_Id VARCHAR(255),
    BillAddr_Line1 VARCHAR(255),
    BillAddr_Line2 VARCHAR(255),
    BillAddr_Line3 VARCHAR(255),
    BillAddr_Line4 VARCHAR(255),
    BillAddr_Line5 VARCHAR(255),
    BillAddr_City VARCHAR(255),
    BillAddr_Country VARCHAR(255),
    BillAddr_CountrySubDivisionCode VARCHAR(255),
    BillAddr_PostalCode VARCHAR(255),
    BillAddr_Lat DECIMAL(10,6),
    BillAddr_Long DECIMAL(10,6),
    
    -- Shipping address
    ShipAddr_Id VARCHAR(255),
    ShipAddr_Line1 VARCHAR(255),
    ShipAddr_Line2 VARCHAR(255),
    ShipAddr_Line3 VARCHAR(255),
    ShipAddr_Line4 VARCHAR(255),
    ShipAddr_Line5 VARCHAR(255),
    ShipAddr_City VARCHAR(255),
    ShipAddr_Country VARCHAR(255),
    ShipAddr_CountrySubDivisionCode VARCHAR(255),
    ShipAddr_PostalCode VARCHAR(255),
    ShipAddr_Lat DECIMAL(10,6),
    ShipAddr_Long DECIMAL(10,6),
    
    -- Other address (optional)
    OtherAddr_Id VARCHAR(255),
    OtherAddr_Line1 VARCHAR(255),
    OtherAddr_Line2 VARCHAR(255),
    OtherAddr_Line3 VARCHAR(255),
    OtherAddr_Line4 VARCHAR(255),
    OtherAddr_Line5 VARCHAR(255),
    OtherAddr_City VARCHAR(255),
    OtherAddr_Country VARCHAR(255),
    OtherAddr_CountrySubDivisionCode VARCHAR(255),
    OtherAddr_PostalCode VARCHAR(255),
    OtherAddr_Lat DECIMAL(10,6),
    OtherAddr_Long DECIMAL(10,6),
    
    -- Reference fields
    ParentRef_value VARCHAR(255),
    ParentRef_name VARCHAR(255),
    Level INT,
    SalesTermRef_value VARCHAR(255),
    SalesTermRef_name VARCHAR(255),
    PaymentMethodRef_value VARCHAR(255),
    PaymentMethodRef_name VARCHAR(255),
    DefaultTaxCodeRef_value VARCHAR(255),
    DefaultTaxCodeRef_name VARCHAR(255),
    CustomerTypeRef_value VARCHAR(255),
    CustomerTypeRef_name VARCHAR(255),
    ARAccountRef_value VARCHAR(255),
    ARAccountRef_name VARCHAR(255),
    ShipMethodRef_value VARCHAR(255),
    ShipMethodRef_name VARCHAR(255),
    
    -- Tax fields
    ResaleNum VARCHAR(255),
    PrimaryTaxIdentifier VARCHAR(255),
    SecondaryTaxIdentifier VARCHAR(255),
    TaxExemptionReasonId INT,
    GSTRegistrationType VARCHAR(255),
    GSTRegsitrationNumber VARCHAR(255),
    
    -- Other fields
    Notes VARCHAR(4000),
    Source VARCHAR(255),
    V4IDPseudonym VARCHAR(255),
    
    -- Custom fields (stored as JSON)
    CustomField TEXT,
    
    -- Attachable references (stored as JSON)
    AttachableRef TEXT,
    
    -- System fields
    sparse BOOLEAN,
    domain VARCHAR(255),
    
    -- Metadata fields
    MetaData_CreateTime DATETIME,
    MetaData_LastUpdatedTime DATETIME,
    MetaData_LastChangedByRef VARCHAR(255),
    MetaData_SyncErrorGuid VARCHAR(255),
    
    -- Client tracking fields
    ClientID VARCHAR(255),
    OrganisationID INT,
    
    -- Indexes
    PRIMARY KEY (Id, OrganisationID),
    INDEX idx_org (OrganisationID),
    INDEX idx_name (DisplayName, OrganisationID),
    INDEX idx_active (Active, OrganisationID),
    INDEX idx_company (CompanyName, OrganisationID),
    INDEX idx_email (PrimaryEmailAddr_Address, OrganisationID),
    INDEX idx_customer_type (CustomerTypeRef_value, OrganisationID),
    INDEX idx_parent (ParentRef_value, OrganisationID),
    INDEX idx_update (MetaData_LastUpdatedTime, OrganisationID)
);

-- Recreate Customer stored procedure
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_customer;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_customer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_customer');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_customerstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationId = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;
*/

-- =====================================================
-- VENDOR ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Vendor tables

/*
-- Drop existing Vendor tables
DROP TABLE IF EXISTS c{clientID}_qbo_vendor;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_vendorstage;

-- Add CREATE TABLE statements for Vendor with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- INVOICE ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Invoice tables

/*
-- Drop existing Invoice tables
DROP TABLE IF EXISTS c{clientID}_qbo_invoice;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_invoicestage;

-- Add CREATE TABLE statements for Invoice with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- BILL ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Bill tables

/*
-- Drop existing Bill tables
DROP TABLE IF EXISTS c{clientID}_qbo_bill;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_billstage;

-- Add CREATE TABLE statements for Bill with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- PAYMENT ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Payment tables

/*
-- Drop existing Payment tables
DROP TABLE IF EXISTS c{clientID}_qbo_payment;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_paymentstage;

-- Add CREATE TABLE statements for Payment with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- ITEM ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Item tables

/*
-- Drop existing Item tables
DROP TABLE IF EXISTS c{clientID}_qbo_item;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_itemstage;

-- Add CREATE TABLE statements for Item with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- ACCOUNT ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Account tables

/*
-- Drop existing Account tables
DROP TABLE IF EXISTS c{clientID}_qbo_account;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_accountstage;

-- Add CREATE TABLE statements for Account with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- JOURNALENTRY ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update JournalEntry tables

/*
-- Drop existing JournalEntry tables
DROP TABLE IF EXISTS c{clientID}_qbo_journalentry;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_journalentrystage;

-- Add CREATE TABLE statements for JournalEntry with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- DEPOSIT ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Deposit tables

/*
-- Drop existing Deposit tables
DROP TABLE IF EXISTS c{clientID}_qbo_deposit;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_depositstage;

-- Add CREATE TABLE statements for Deposit with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- PURCHASE ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Purchase tables

/*
-- Drop existing Purchase tables
DROP TABLE IF EXISTS c{clientID}_qbo_purchase;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_purchasestage;

-- Add CREATE TABLE statements for Purchase with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- SALESRECEIPT ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update SalesReceipt tables

/*
-- Drop existing SalesReceipt tables
DROP TABLE IF EXISTS c{clientID}_qbo_salesreceipt;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_salesreceiptstage;

-- Add CREATE TABLE statements for SalesReceipt with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- CREDITMEMO ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update CreditMemo tables

/*
-- Drop existing CreditMemo tables
DROP TABLE IF EXISTS c{clientID}_qbo_creditmemo;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_creditmemostage;

-- Add CREATE TABLE statements for CreditMemo with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- EMPLOYEE ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Employee tables

/*
-- Drop existing Employee tables
DROP TABLE IF EXISTS c{clientID}_qbo_employee;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_employeestage;

-- Add CREATE TABLE statements for Employee with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- CLASS ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Class tables

/*
-- Drop existing Class tables
DROP TABLE IF EXISTS c{clientID}_qbo_class;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_classstage;

-- Add CREATE TABLE statements for Class with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- DEPARTMENT ENDPOINT UPDATES
-- =====================================================
-- Uncomment this section to update Department tables

/*
-- Drop existing Department tables
DROP TABLE IF EXISTS c{clientID}_qbo_department;
DROP TABLE IF EXISTS c{clientID}_{orgID}_qbo_departmentstage;

-- Add CREATE TABLE statements for Department with updated schema here
-- Add stored procedure recreation here
*/

-- =====================================================
-- VIEW UPDATES
-- =====================================================
-- Add any view recreation statements here

/*
-- Example: Recreate customer view
CREATE OR REPLACE VIEW v_qbo_customer_{clientID} AS
SELECT * FROM c{clientID}_qbo_customer;
*/

-- =====================================================
-- USAGE INSTRUCTIONS
-- =====================================================
-- 1. Review the QuickBooks API documentation for the endpoint you're updating
-- 2. Identify new or changed fields
-- 3. Update the appropriate section above with the new schema
-- 4. Replace {clientID} and {orgID} with actual values
-- 5. Uncomment only the sections you need to update
-- 6. Run the script
-- 7. Update the corresponding Python ETL code to handle new fields
-- 8. Update the main table definition files:
--    - SQL Scripts/QBO-STAGE-TABLES.sql
--    - SQL Scripts/QBO-PROD-TABLES.sql
--    - SQL Scripts/QBO-STORED-PROCEDURES.sql

-- =====================================================
-- CHANGE LOG
-- =====================================================
-- Date: [Today's Date]
-- Customer Endpoint Updated:
-- - Added Title field
-- - Added IsStatementWithParent, IsCDS flags
-- - Added OpenBalanceDate, TotalRevenue, TotalExpense
-- - Added Lat/Long for all addresses
-- - Added OtherAddr object
-- - Added multiple new reference fields (_name variants)
-- - Added tax-related fields
-- - Added Source, V4IDPseudonym
-- - Added CustomField and AttachableRef as JSON
-- - Added additional metadata fields

-- [Add more changelog entries as endpoints are updated]