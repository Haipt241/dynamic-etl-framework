from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from azure.storage.fileshare import ShareFileClient, ShareClient
import pandas as pd
import json
import requests
import base64
import config

server_eva = config.MYSQL_SERVER_NAME
database_eva = config.MYSQL_SERVER_EVA_DATABASE
database_cms = config.MYSQL_SERVER_CMS_DATABASE
username_eva = config.MYSQL_SERVER_USERNAME
password_eva = config.MYSQL_SERVER_PASSWORD
ssl_cert = config.MYSQL_SERVER_SSL_CERT

StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName = config.FILE_SHARE_NAME
OldFileShareName = 'xerobluedwrefreshtoken'

cms_connection_params = {
    "host": server_eva,
    "user": username_eva,
    "password": password_eva,
    "database": database_cms,
    "ssl": {"ca": ssl_cert},
    "autocommit": True,
}

cms_engine = create_engine(
    f"mysql+pymysql://{cms_connection_params['user']}:{cms_connection_params['password']}@{cms_connection_params['host']}/{cms_connection_params['database']}",
    connect_args={
        "ssl": cms_connection_params["ssl"],
        "autocommit": cms_connection_params["autocommit"],
    },
    pool_size=10,          # Adjust pool size as needed
    max_overflow=5,        # Extra connections beyond the pool size
    pool_timeout=30,       # Wait time for a connection
    pool_recycle=3600,     # Recycle connections every 1 hour
)

evastage_connection_params = {
    "host": server_eva,
    "user": username_eva,
    "password": password_eva,
    "database": database_eva,
    "ssl": {"ca": ssl_cert},
    "autocommit": True,
}

evastage_engine = create_engine(
    f"mysql+pymysql://{evastage_connection_params['user']}:{evastage_connection_params['password']}@{evastage_connection_params['host']}/{evastage_connection_params['database']}",
    connect_args={
        "ssl": evastage_connection_params["ssl"],
        "autocommit": evastage_connection_params["autocommit"],
    },
    pool_size=10,          # Adjust pool size as needed
    max_overflow=5,        # Extra connections beyond the pool size
    pool_timeout=30,       # Wait time for a connection
    pool_recycle=3600,     # Recycle connections every 1 hour
)

eva_connection_params = {
    "host": server_eva,
    "user": username_eva,
    "password": password_eva,
    "database": 'evadb',
    "ssl": {"ca": ssl_cert},
    "autocommit": True,
}

eva_engine = create_engine(
    f"mysql+pymysql://{eva_connection_params['user']}:{eva_connection_params['password']}@{eva_connection_params['host']}/{eva_connection_params['database']}",
    connect_args={
        "ssl": eva_connection_params["ssl"],
        "autocommit": eva_connection_params["autocommit"],
    },
    pool_size=10,          # Adjust pool size as needed
    max_overflow=5,        # Extra connections beyond the pool size
    pool_timeout=30,       # Wait time for a connection
    pool_recycle=3600,     # Recycle connections every 1 hour
)


def ReadMySQLTable(query, userengine):
    engine = userengine
    
    try:
        # Fetch data into a DataFrame
        with engine.connect() as connection:
            df = pd.read_sql(query, connection)

    except SQLAlchemyError as e:
        print(f"Error: {str(e)}")
        return None

    finally:
        engine.dispose()
        return df

def ExtractOrgDetailsFromCMS(code):
    sqlScript = f"""
        SELECT 
        CONCAT(
            replace(upper(f.code),'-',''),
            '_CLIENT',
            IFNULL(JSON_EXTRACT(c.Details, '$.Legacy.id'),CAST(cs.`Client` AS CHAR(10)))
        ) AS ClientID,
        CAST(cs.`Client` AS CHAR(10)) AS CMSClientID,
        IFNULL(JSON_EXTRACT(cs.Details, '$.Legacy.id'),CAST(cs.id AS CHAR(10))) AS OrganisationID,
        CAST(cs.id AS CHAR(10)) AS CMSOrganisationID,
        JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Organisation')) AS tenant_name,	
        JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.tenantId')) AS tenant_id
    FROM client_service cs
    JOIN client c ON cs.`Client` = c.id
    JOIN accounting_firm f ON cs.AccountingFirm = f.id
    WHERE f.`Status` <> 2
    AND cs.`Status` <> 2
    AND c.`Status` <> 2
    AND service = 1
    AND replace(lower(f.code),'-','') = '{code}'
    """
    df = ReadMySQLTable(sqlScript,cms_engine)
    
    return df

def GetDWTokenFileList(code,):
    share_client = ShareClient(account_url=f"https://{StorageAccountName}.file.core.windows.net/",share_name=FileShareName,credential=StorageAccessKey)
    try:
        files = []
        file_list = share_client.list_directories_and_files()
        for file in file_list:
            filename = file.name
            #print(f"File: {filename}")
            files.append(filename)
        filtered_files = [filename for filename in files if str(code).upper() in filename]
            
        df = pd.DataFrame(filtered_files, columns=['FileName'])
        df['ClientID'] = df['FileName'].apply(lambda x: x.split('_')[0] + '_' + x.split('_')[1] if len(x.split('_')) > 1 else None)
        df['OrganisationID'] = df['FileName'].apply(lambda x: x.split('_')[2].split('.')[0] if len(x.split('_')) > 2 else None)
        df = df.drop(columns=['FileName'])
        
        return df
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

def ExecuteMySQLScript(query, userengine):
    engine = userengine
    
    try:
        if 'CREATE PROCEDURE' in query:
            statements = query.strip().split('$$')
        else:
            statements = query.strip().split(';')
            
        for statement in statements:
            with engine.connect() as connection:
                connection.execute(text(statement))
                print(f"SQL script executed successfully: {statement[:100]}")

    except SQLAlchemyError as e:
        print(f"Error: {str(e)}")

    finally:
        engine.dispose()

def CreateProdTablesInEvaDBStg(clientid):
    
    MYSQL_PROD_TABLE = f"""
        set sql_generate_invisible_primary_key = off;

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_contactgroupmembers (
            `ContactID` VARCHAR(100) NULL,
            `Name` VARCHAR(255) NULL,
            `ContactGroupID` VARCHAR(100) NULL,
            `ContactGroups_Name` VARCHAR(255) NULL,
            `ContactGroups_Status` VARCHAR(100) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_balancesheetpivot (
            `ID` INT NULL,
            `Title` VARCHAR(255) NULL,
            `AccountName` VARCHAR(255) NULL,
            `Amount` VARCHAR(100) NULL,
            `Month` VARCHAR(100) NULL,
            `AccountId` VARCHAR(100) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_bankstatement (
            `BankAccountId` VARCHAR(100) NULL,
            `Date` DATE NULL,
            `Description` VARCHAR(4000) NULL,
            `Reference` VARCHAR(4000) NULL,
            `Reconciled` VARCHAR(100) NULL,
            `Source` VARCHAR(100) NULL,
            `Amount` FLOAT NULL,
            `Balance` FLOAT NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_banksummary (
            `ID` INT NULL,
            `BankAccount` VARCHAR(100) NULL,
            `AccountID` VARCHAR(100) NULL,
            `OpeningBalance` DECIMAL(30, 6) NULL,
            `CashReceived` DECIMAL(30, 6) NULL,
            `CashSpent` DECIMAL(30, 6) NULL,
            `FXGain` DECIMAL(30, 6) NULL,
            `ClosingBalance` DECIMAL(30, 6) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_expenseclaims (
            `ExpenseClaimId` VARCHAR(100) NULL,
            `UserId` VARCHAR(100) NULL,
            `Status` VARCHAR(100) NULL,
            `UpdatedDateUTC` DATETIME NULL,
            `Total` DECIMAL(30, 6) NULL,
            `AmountDue` DECIMAL(30, 6) NULL,
            `AmountPaid` DECIMAL(30, 6) NULL,
            `PaymentDueDate` DATE NULL,
            `ReportingDate` DATE NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_expenseclaimpayments (
            `Id` VARCHAR(100) NULL,
            `ExpenseClaimId` VARCHAR(100) NULL,
            `Date` DATE NULL,
            `Amount` DECIMAL(30, 6) NULL,
            `Reference` VARCHAR(255) NULL,
            `AccountId` TEXT NULL,
            `AccountCode` VARCHAR(100) NULL,
            `AccountName` VARCHAR(255) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_expenseclaimreceipts (
            `Id` VARCHAR(100) NULL,
            `ExpenseClaimId` VARCHAR(100) NULL,
            `ReceiptId` TEXT NULL,
            `Date` DATE NULL,
            `Contact_ContactId` VARCHAR(100) NULL,
            `Contact_Name` VARCHAR(255) NULL,
            `LineItem_Description` VARCHAR(4000) NULL,
            `LineItem_UnitAmount` DECIMAL(30, 6) NULL,
            `LineItem_AccountCode` VARCHAR(100) NULL,
            `LineItem_Quantity` FLOAT NULL,
            `LineItem_TaxAmount` DECIMAL(30, 6) NULL,
            `LineItem_TaxType` VARCHAR(100) NULL,
            `LineItem_LineAmount` DECIMAL(30, 6) NULL,
            `LineItem_TrackingCategory1_CategoryId` VARCHAR(100) NULL,
            `LineItem_TrackingCategory1_CategoryName` VARCHAR(255) NULL,
            `LineItem_TrackingCategory1_OptionId` VARCHAR(100) NULL,
            `LineItem_TrackingCategory1_OptionName` VARCHAR(255) NULL,
            `LineItem_TrackingCategory1_Option_Stat` VARCHAR(100) NULL,
            `LineItem_TrackingCategory2_CategoryId` VARCHAR(100) NULL,
            `LineItem_TrackingCategory2_CategoryName` VARCHAR(255) NULL,
            `LineItem_TrackingCategory2_OptionId` VARCHAR(100) NULL,
            `LineItem_TrackingCategory2_OptionName` VARCHAR(255) NULL,
            `LineItem_TrackingCategory2_Option_Stat` VARCHAR(100) NULL,
            `LineItem_DiscountRate` FLOAT NULL,
            `User_UserId` VARCHAR(100) NULL,
            `Reference` VARCHAR(255) NULL,
            `LineAmountTypes` TEXT NULL,
            `SubTotal` DECIMAL(30, 6) NULL,
            `TotalTax` DECIMAL(30, 6) NULL,
            `Total` DECIMAL(30, 6) NULL,
            `Status` VARCHAR(100) NULL,
            `ReceiptNumber` VARCHAR(100) NULL,
            `UpdatedDateUTC` DATETIME NULL,
            `HasAttachments` BOOLEAN NULL,
            `URL` VARCHAR(255) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_executivesummary (
            `Title` VARCHAR(255) NULL,
            `Metric` VARCHAR(255) NULL,
            `ThisMonth` VARCHAR(100) NULL,
            `PreviousMonth` VARCHAR(100) NULL,
            `Variance` VARCHAR(100) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_profitandlosspivot (
            `ID` INT NULL,
            `Title` VARCHAR(255) NULL,
            `AccountName` VARCHAR(255) NULL,
            `Amount` VARCHAR(100) NULL,
            `Month` VARCHAR(100) NULL,
            `AccountId` VARCHAR(100) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_xeroblue_budgetsummaryInterim (
            `ID` INT NULL,
            `Title` VARCHAR(255) NULL,
            `AccountId` VARCHAR(100) NULL,
            `BankAccount` VARCHAR(255) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL,
            `FinancialYear` FLOAT NULL,
            `AccountName_UID` VARCHAR(255) NULL,
            `Amount` VARCHAR(100) NULL,
            `Month` VARCHAR(100) NULL,
            `Amount_AUD` VARCHAR(100) NULL,
            `Amount_USD` VARCHAR(100) NULL,
            `Amount_NZD` VARCHAR(100) NULL,
            `Amount_EUR` VARCHAR(100) NULL,
            `Amount_GBP` VARCHAR(100) NULL,
            `TotalAmount` VARCHAR(100) NULL,
            `TotalAmount_AUD` VARCHAR(100) NULL,
            `TotalAmount_USD` VARCHAR(100) NULL,
            `TotalAmount_NZD` VARCHAR(100) NULL,
            `TotalAmount_EUR` VARCHAR(100) NULL,
            `TotalAmount_GBP` VARCHAR(100) NULL
        );

        set sql_generate_invisible_primary_key = on;
        """

    ExecuteMySQLScript(MYSQL_PROD_TABLE,evastage_engine)

def CreateProdSPInEvaDBStg(clientid):
    
    MYSQL_PROD_SP = f"""
        DROP PROCEDURE IF EXISTS sp_{clientid}_xeroblue_lastrefreshdate $$
        CREATE PROCEDURE sp_{clientid}_xeroblue_lastrefreshdate (
            IN p_TableName VARCHAR(255),
            IN p_RefreshRowCount INT,
            IN p_TotalRowCount INT,
            IN p_StartDate DATETIME,
            IN p_EndDate DATETIME,
            IN p_LastRefreshUTCDate DATETIME,
            IN p_LoadType VARCHAR(255),
            IN p_RefreshStatus VARCHAR(255),
            IN p_JobRunId BIGINT,
            IN p_DatabaseDestination VARCHAR(255),
            IN p_ClientID VARCHAR(255),
            IN p_OrganisationID INT,
            IN p_TriggerType VARCHAR(255),
            IN p_RefreshDetails VARCHAR(255)
        )
        BEGIN
            DECLARE v_NewID INT;

            SELECT COALESCE(MAX(ID), 0) + 1 INTO v_NewID FROM `{clientid}_xeroblue_lastrefreshdate`;

            INSERT INTO `{clientid}_xeroblue_lastrefreshdate` (
                `Id`,
                `TableName`, 
                `RefreshRowCount`, 
                `TotalRowCount`, 
                `StartDate`, 
                `EndDate`, 
                `LastRefreshUTCDate`, 
                `LoadType`, 
                `RefreshStatus`, 
                `JobRunId`,
                `DatabaseDestination`,
                `ClientID`, 
                `OrganisationID`,
                `TriggerType`,
                `RefreshDetails`
            ) VALUES (
                v_NewID,
                p_TableName, 
                p_RefreshRowCount, 
                p_TotalRowCount, 
                p_StartDate, 
                p_EndDate, 
                p_LastRefreshUTCDate, 
                p_LoadType, 
                p_RefreshStatus, 
                p_JobRunId, 
                p_DatabaseDestination, 
                p_ClientID, 
                p_OrganisationID,
                p_TriggerType,
                p_RefreshDetails
            )
            ON DUPLICATE KEY UPDATE
                `RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`),
                `TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`),
                `StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`),
                `EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`),
                `LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`),
                `LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`),
                `RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`),
                `JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`),
                `DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`),
                `TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`),
                `RefreshDetails` = VALUES(`RefreshDetails`);
        END
        """

    ExecuteMySQLScript(MYSQL_PROD_SP,evastage_engine)

def CreateStageTablesInEvaDBStg(clientid, organisationid):
    
    MYSQL_STAGE_TABLE = f"""
        set sql_generate_invisible_primary_key = off;
        
        CREATE TABLE IF NOT EXISTS {clientid}_{organisationid}_xeroblue_banksummarystage (
            `ID` INT NULL,
            `BankAccount` VARCHAR(100) NULL,
            `AccountID` VARCHAR(100) NULL,
            `OpeningBalance` DECIMAL(30, 6) NULL,
            `CashReceived` DECIMAL(30, 6) NULL,
            `CashSpent` DECIMAL(30, 6) NULL,
            `FXGain` DECIMAL(30, 6) NULL,
            `ClosingBalance` DECIMAL(30, 6) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT NULL
        );

        CREATE TABLE IF NOT EXISTS {clientid}_{organisationid}_xeroblue_trialbalancestage (
            `ID` INT(10) NULL,
            `Date` DATE NULL,
            `Title` VARCHAR(255) NULL,
            `Account` VARCHAR(255) NULL,
            `Debit` VARCHAR(100) NULL,
            `Credit` VARCHAR(100) NULL,
            `YTDDebit` VARCHAR(100) NULL,
            `YTDCredit` VARCHAR(100) NULL,
            `AccountId` VARCHAR(100) NULL,
            `ClientID` VARCHAR(255) NULL,
            `OrganisationID` INT(10) NULL
        );
        """

    ExecuteMySQLScript(MYSQL_STAGE_TABLE,evastage_engine)

def CreateStageSPInEvaDBStg(clientid, organisationid, legacyclientid, legacyorganisationid):
    
    MYSQL_STAGE_SP = f"""
        DROP PROCEDURE IF EXISTS sp_{clientid}_{organisationid}_xeroblue_transactions $$
        CREATE PROCEDURE sp_{clientid}_{organisationid}_xeroblue_transactions()
        BEGIN
            DECLARE v_OrganisationID INT DEFAULT {legacyorganisationid};

            TRUNCATE TABLE {clientid}_{organisationid}_xeroblue_transactionsstage;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                C.`Id` AS `LineID`,
                C.`CreditNoteId` AS `ID`,
                C.`Date` AS `Date`,
                C.`Type` AS `Type`,
                C.`Contact_ContactId` AS `ContactID`,
                C.`Contact_Name` AS `ContactName`,
                NULL AS `LineItemID`,
                C.`LineItem_Description` AS `Description`,
                C.`LineItem_Quantity` AS `Quantity`,
                C.`LineItem_UnitAmount` AS `UnitAmount`,
                C.`LineItem_ItemCode` AS `ItemCode`,
                C.`LineItem_AccountCode` AS `AccountCode`,
                C.`LineItem_TaxType` AS `TaxType`,
                C.`LineItem_TaxAmount` AS `TaxAmount`,
                C.`LineItem_LineAmount` AS `LineAmount`,
                C.`LineAmountTypes` AS `LineAmountTypes`,
                C.`Status` AS `Status`,
                C.`SubTotal` AS `SubTotal`,
                C.`TotalTax` AS `TotalTax`,
                C.`Total` AS `Total`,
                C.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                C.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                C.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                C.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                C.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                C.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                C.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                C.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                C.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                C.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                C.`LineItem_DiscountRate` AS `DiscountRate`,
                C.`CurrencyCode` AS `CurrencyCode`,
                CAST(C.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                C.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(C.`LineItem_AccountCode`, 'BLANK'), '-', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
                C.`HasAttachments` AS `HasAttachments`,
                C.`CreditNoteNumber` AS `CreditNoteNumber`,
                C.`RemainingCredit` AS `RemainingCredit`,
                C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                C.`Reference` AS `Reference`,
                'CREDITNOTES' AS `Source`,
                C.`ClientID` AS `ClientID`,
                C.`OrganisationID` AS `OrganisationID`,
                C.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                C.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                C.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                C.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                C.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                C.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                C.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                C.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                C.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                C.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                C.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                C.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                C.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                C.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                C.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                C.`SubTotal_AUD` AS `SubTotal_AUD`,
                C.`SubTotal_USD` AS `SubTotal_USD`,
                C.`SubTotal_NZD` AS `SubTotal_NZD`,
                C.`SubTotal_EUR` AS `SubTotal_EUR`,
                C.`SubTotal_GBP` AS `SubTotal_GBP`,
                C.`TotalTax_AUD` AS `TotalTax_AUD`,
                C.`TotalTax_USD` AS `TotalTax_USD`,
                C.`TotalTax_NZD` AS `TotalTax_NZD`,
                C.`TotalTax_EUR` AS `TotalTax_EUR`,
                C.`TotalTax_GBP` AS `TotalTax_GBP`,
                C.`Total_AUD` AS `Total_AUD`,
                C.`Total_USD` AS `Total_USD`,
                C.`Total_NZD` AS `Total_NZD`,
                C.`Total_EUR` AS `Total_EUR`,
                C.`Total_GBP` AS `Total_GBP`,
                C.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                C.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                C.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                C.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                C.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                CA.InvoiceId AS `PaymentSourceID`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Dt ELSE NULL END AS `AllocationDate`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Amount ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User`,
                NULL AS `Details`,
                DATEDIFF(C.`FullyPaidOnDate`, C.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                C.`RemainingCredit` AS `AmountDue`,
                C.`RemainingCredit_AUD` AS `AmountDue_AUD`,
                C.`RemainingCredit_USD` AS `AmountDue_USD`,
                C.`RemainingCredit_NZD` AS `AmountDue_NZD`,
                C.`RemainingCredit_EUR` AS `AmountDue_EUR`,
                C.`RemainingCredit_GBP` AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_creditnotes C
            LEFT JOIN (
                SELECT DISTINCT
                    `CreditNoteId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `ClientID`,
                    `OrganisationID`
                FROM evadb.{legacyclientid}_xeroblue_creditnoteallocations_aud
                WHERE `OrganisationID` = v_OrganisationID
            ) CA
                ON C.`CreditNoteID` = CA.`CreditNoteID` 
                AND C.`OrganisationID` = CA.`OrganisationID`
            WHERE c.OrganisationID = v_OrganisationID;
            
            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                `Id` AS `LineID`,
                `InvoiceId` AS `ID`,
                `Date` AS `Date`,
                `Type` AS `Type`,
                `ContactId` AS `ContactID`,
                `ContactName` AS `ContactName`,
                `LineItem_LineItemId` AS `LineItemID`,
                `LineItem_Description` AS `Description`,
                `LineItem_Quantity` AS `Quantity`,
                `LineItem_UnitAmount` AS `UnitAmount`,
                `LineItem_ItemCode` AS `ItemCode`,
                `LineItem_AccountCode` AS `AccountCode`,
                `LineItem_TaxType` AS `TaxType`,
                `LineItem_TaxAmount` AS `TaxAmount`,
                `LineItem_LineAmount` AS `LineAmount`,
                `LineAmountTypes` AS `LineAmountTypes`,
                `Status` AS `Status`,
                `SubTotal` AS `SubTotal`,
                `TotalTax` AS `TotalTax`,
                `Total` AS `Total`,
                `LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                `LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                `LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                `LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                `LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                `LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                `LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                `LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                `LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                `LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                `LineItem_DiscountRate` AS `DiscountRate`,
                `CurrencyCode` AS `CurrencyCode`,
                CAST(`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                `UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
                `HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                `FullyPaidOnDate` AS `FullyPaidOnDate`,
                `Reference` AS `Reference`,
                'INVOICES' AS `Source`,
                `ClientID` AS `ClientID`,
                `OrganisationID` AS `OrganisationID`,
                `LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                `LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                `LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                `LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                `LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                `LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                `LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                `LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                `LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                `LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                `LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                `LineItem_LineAmount_USD` AS `LineAmount_USD`,
                `LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                `LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                `LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                `SubTotal_AUD` AS `SubTotal_AUD`,
                `SubTotal_USD` AS `SubTotal_USD`,
                `SubTotal_NZD` AS `SubTotal_NZD`,
                `SubTotal_EUR` AS `SubTotal_EUR`,
                `SubTotal_GBP` AS `SubTotal_GBP`,
                `TotalTax_AUD` AS `TotalTax_AUD`,
                `TotalTax_USD` AS `TotalTax_USD`,
                `TotalTax_NZD` AS `TotalTax_NZD`,
                `TotalTax_EUR` AS `TotalTax_EUR`,
                `TotalTax_GBP` AS `TotalTax_GBP`,
                `Total_AUD` AS `Total_AUD`,
                `Total_USD` AS `Total_USD`,
                `Total_NZD` AS `Total_NZD`,
                `Total_EUR` AS `Total_EUR`,
                `Total_GBP` AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                `DueDate` AS `DueDate`,
                `InvoiceNumber` AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User`,
                NULL AS `Details`,
                DATEDIFF(`FullyPaidOnDate`, `Date`) AS `DayDifference`,
                `PlannedPaymentDate` AS `PlannedPaymentDate`,
                `AmountDue` AS `AmountDue`,
                `AmountDue_AUD` AS `AmountDue_AUD`,
                `AmountDue_USD` AS `AmountDue_USD`,
                `AmountDue_NZD` AS `AmountDue_NZD`,
                `AmountDue_EUR` AS `AmountDue_EUR`,
                `AmountDue_GBP` AS `AmountDue_GBP`,
                `URL` AS `URL`
            FROM {clientid}_xeroblue_invoices
            WHERE `OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                OP.`OverpaymentId` AS `LineID`,
                OP.`OverpaymentId` AS `ID`,
                OP.`Date` AS `Date`,
                OP.`Type` AS `Type`,
                OP.`Contact_ContactId` AS `ContactID`,
                OP.`Contact_Name` AS `ContactName`,
                OP.`LineItem_LineItemId` AS `LineItemID`,
                OP.`LineItem_Description` AS `Description`,
                OP.`LineItem_Quantity` AS `Quantity`,
                OP.`LineItem_UnitAmount` AS `UnitAmount`,
                OP.`LineItem_ItemCode` AS `ItemCode`,
                OP.`LineItem_AccountCode` AS `AccountCode`,
                OP.`LineItem_TaxType` AS `TaxType`,
                OP.`LineItem_TaxAmount` AS `TaxAmount`,
                OP.`LineItem_LineAmount` AS `LineAmount`,
                OP.`LineAmountTypes` AS `LineAmountTypes`,
                OP.`Status` AS `Status`,
                OP.`SubTotal` AS `SubTotal`,
                OP.`TotalTax` AS `TotalTax`,
                OP.`Total` AS `Total`,
                OP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                OP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                OP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                OP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                OP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                OP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                OP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                OP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                OP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                OP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                OP.`LineItem_DiscountRate` AS `DiscountRate`,
                OP.`CurrencyCode` AS `CurrencyCode`,
                CAST(NULLIF(OP.`CurrencyRate`,'') AS FLOAT) AS `CurrencyRate`,
                OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(OP.`LineItem_AccountCode`, 'BLANK'), '-', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                OP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                OP.`RemainingCredit` AS `RemainingCredit`,
                OP.`Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                'OVERPAYMENTS' AS `Source`,
                OP.`ClientID` AS `ClientID`,
                OP.`OrganisationID` AS `OrganisationID`,
                OP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                OP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                OP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                OP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                OP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                OP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                OP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                OP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                OP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                OP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                OP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                OP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                OP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                OP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                OP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                OP.`SubTotal_AUD` AS `SubTotal_AUD`,
                OP.`SubTotal_USD` AS `SubTotal_USD`,
                OP.`SubTotal_NZD` AS `SubTotal_NZD`,
                OP.`SubTotal_EUR` AS `SubTotal_EUR`,
                OP.`SubTotal_GBP` AS `SubTotal_GBP`,
                OP.`TotalTax_AUD` AS `TotalTax_AUD`,
                OP.`TotalTax_USD` AS `TotalTax_USD`,
                OP.`TotalTax_NZD` AS `TotalTax_NZD`,
                OP.`TotalTax_EUR` AS `TotalTax_EUR`,
                OP.`TotalTax_GBP` AS `TotalTax_GBP`,
                OP.`Total_AUD` AS `Total_AUD`,
                OP.`Total_USD` AS `Total_USD`,
                OP.`Total_NZD` AS `Total_NZD`,
                OP.`Total_EUR` AS `Total_EUR`,
                OP.`Total_GBP` AS `Total_GBP`,
                OP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                OP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                OP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                OP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                OP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                OPA.`InvoiceId` AS `PaymentSourceID`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Dt` ELSE NULL END AS `AllocationDate`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Amount` ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(OP.`Date`, OP.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_overpayments OP
            LEFT JOIN (
                SELECT DISTINCT
                    `OverPaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.{legacyclientid}_xeroblue_overpaymentallocation_aud
                WHERE `Organisation ID` = v_OrganisationID
            ) OPA 
                ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
                AND OP.`OrganisationID` = OPA.`Organisation ID`
            WHERE OP.`OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                PP.`PrepaymentId` AS `LineID`,
                PP.`PrepaymentId` AS `ID`,
                PP.`Date` AS `Date`,
                PP.`Type` AS `Type`,
                PP.`Contact_ContactId` AS `ContactID`,
                PP.`Contact_Name` AS `ContactName`,
                PP.`LineItem_LineItemId` AS `LineItemID`,
                PP.`LineItem_Description` AS `Description`,
                PP.`LineItem_Quantity` AS `Quantity`,
                PP.`LineItem_UnitAmount` AS `UnitAmount`,
                PP.`LineItem_ItemCode` AS `ItemCode`,
                PP.`LineItem_AccountCode` AS `AccountCode`,
                PP.`LineItem_TaxType` AS `TaxType`,
                PP.`LineItem_TaxAmount` AS `TaxAmount`,
                PP.`LineItem_LineAmount` AS `LineAmount`,
                PP.`LineAmountTypes` AS `LineAmountTypes`,
                PP.`Status` AS `Status`,
                PP.`SubTotal` AS `SubTotal`,
                PP.`TotalTax` AS `TotalTax`,
                PP.`Total` AS `Total`,
                PP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                PP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                PP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                PP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                PP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                PP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                PP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                PP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                PP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                PP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                PP.`LineItem_DiscountRate` AS `DiscountRate`,
                PP.`CurrencyCode` AS `CurrencyCode`,
                NULLIF(PP.`CurrencyRate`,'') AS `CurrencyRate`,
                PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(PP.`LineItem_AccountCode`, 'BLANK'), '-', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                PP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                PP.`RemainingCredit` AS `RemainingCredit`,
                PP.`Date` AS `FullyPaidOnDate`,
                PP.`Reference` AS `Reference`,
                'PREPAYMENTS' AS `Source`,
                PP.`ClientID` AS `ClientID`,
                PP.`OrganisationID` AS `OrganisationID`,
                PP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                PP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                PP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                PP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                PP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                PP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                PP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                PP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                PP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                PP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                PP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                PP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                PP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                PP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                PP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                PP.`SubTotal_AUD` AS `SubTotal_AUD`,
                PP.`SubTotal_USD` AS `SubTotal_USD`,
                PP.`SubTotal_NZD` AS `SubTotal_NZD`,
                PP.`SubTotal_EUR` AS `SubTotal_EUR`,
                PP.`SubTotal_GBP` AS `SubTotal_GBP`,
                PP.`TotalTax_AUD` AS `TotalTax_AUD`,
                PP.`TotalTax_USD` AS `TotalTax_USD`,
                PP.`TotalTax_NZD` AS `TotalTax_NZD`,
                PP.`TotalTax_EUR` AS `TotalTax_EUR`,
                PP.`TotalTax_GBP` AS `TotalTax_GBP`, 
                PP.`Total_AUD` AS `Total_AUD`,
                PP.`Total_USD` AS `Total_USD`,
                PP.`Total_NZD` AS `Total_NZD`,
                PP.`Total_EUR` AS `Total_EUR`,
                PP.`Total_GBP` AS `Total_GBP`,
                PP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                PP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                PP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                PP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                PP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                PPA.`InvoiceId` AS `PaymentSourceID`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Dt` ELSE NULL END AS `AllocationDate`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Amount` ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(PP.`Date`, PP.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_prepayments PP
            LEFT JOIN (
                SELECT DISTINCT
                    `PrePaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.{legacyclientid}_xeroblue_prepaymentallocation_aud
                WHERE `Organisation ID` = v_OrganisationID
            ) PPA 
                ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
                AND PP.`OrganisationID` = PPA.`Organisation ID`
            WHERE PP.`OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                `Id` AS `LineID`,
                `ManualJournalId` AS `ID`,
                `Date` AS `Date`,
                NULL AS `Type`,
                NULL AS `ContactID`,
                NULL AS `ContactName`,
                NULL AS `LineItemID`,
                `JournalLine_Description` AS `Description`,
                NULL AS `Quantity`,
                NULL AS `UnitAmount`,
                NULL AS `ItemCode`,
                `JournalLine_AccountCode` AS `AccountCode`,
                `JournalLine_TaxType` AS `TaxType`,
                `JournalLine_TaxAmount` AS `TaxAmount`,
                `JournalLine_LineAmount` AS `LineAmount`,
                `LineAmountTypes` AS `LineAmountTypes`,
                `Status` AS `Status`,
                NULL AS `SubTotal`,
                NULL AS `TotalTax`,
                NULL AS `Total`,
                `JournalLine_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                `JournalLine_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                `JournalLine_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                `JournalLine_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                `JournalLine_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                `JournalLine_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                `JournalLine_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                `JournalLine_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                `JournalLine_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                `JournalLine_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                NULL AS `CurrencyCode`,
                NULL AS `CurrencyRate`,
                `UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(`JournalLine_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
                `HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                `Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                'MANUALJOURNALS' AS `Source`,
                `ClientID` AS `ClientID`,
                `OrganisationID` AS `OrganisationID`,
                NULL AS `UnitAmount_AUD`,
                NULL AS `UnitAmount_USD`,
                NULL AS `UnitAmount_NZD`,
                NULL AS `UnitAmount_EUR`,
                NULL AS `UnitAmount_GBP`,
                `JournalLine_TaxAmount_AUD` AS `TaxAmount_AUD`,
                `JournalLine_TaxAmount_USD` AS `TaxAmount_USD`,
                `JournalLine_TaxAmount_NZD` AS `TaxAmount_NZD`,
                `JournalLine_TaxAmount_EUR` AS `TaxAmount_EUR`,
                `JournalLine_TaxAmount_GBP` AS `TaxAmount_GBP`,
                `JournalLine_LineAmount_AUD` AS `LineAmount_AUD`,
                `JournalLine_LineAmount_USD` AS `LineAmount_USD`,
                `JournalLine_LineAmount_NZD` AS `LineAmount_NZD`,
                `JournalLine_LineAmount_EUR` AS `LineAmount_EUR`,
                `JournalLine_LineAmount_GBP` AS `LineAmount_GBP`,
                NULL AS `SubTotal_AUD`,
                NULL AS `SubTotal_USD`,
                NULL AS `SubTotal_NZD`,
                NULL AS `SubTotal_EUR`,
                NULL AS `SubTotal_GBP`,
                NULL AS `TotalTax_AUD`,
                NULL AS `TotalTax_USD`,
                NULL AS `TotalTax_NZD`,
                NULL AS `TotalTax_EUR`,
                NULL AS `TotalTax_GBP`,
                NULL AS `Total_AUD`,
                NULL AS `Total_USD`,
                NULL AS `Total_NZD`,
                NULL AS `Total_EUR`,
                NULL AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User  `,
                NULL AS `Details`,
                DATEDIFF(`Date`, `Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_manualjournals
            WHERE `OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                `Id` AS `LineID`,
                `BankTransactionId` AS `ID`,
                `Date` AS `Date`,
                `Type` AS `Type`,
                `Contact_ContactId` AS `ContactID`,
                `Contact_ContactName` AS `ContactName`,
                `LineItem_LineItemId` AS `LineItemID`,
                `LineItem_Description` AS `Description`,
                `LineItem_Quantity` AS `Quantity`,
                `LineItem_UnitAmount` AS `UnitAmount`,
                `LineItem_ItemCode` AS `ItemCode`,
                `LineItem_AccountCode` AS `AccountCode`,
                `LineItem_TaxType` AS `TaxType`,
                `LineItem_TaxAmount` AS `TaxAmount`,
                `LineItem_LineAmount` AS `LineAmount`,
                `LineAmountTypes` AS `LineAmountTypes`,
                `Status` AS `Status`,
                `SubTotal` AS `SubTotal`,
                `TotalTax` AS `TotalTax`,
                `Total` AS `Total`,
                `LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                `LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                `LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                `LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                `LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                `LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                `LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                `LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                `LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                `LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                `CurrencyCode` AS `CurrencyCode`,
                CAST(`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                `UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
                `HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                `FullyPaidOnDate` AS `FullyPaidOnDate`,
                `Reference` AS `Reference`,
                'BANKTRANSACTIONS' AS `Source`,
                `ClientID` AS `ClientID`,
                `OrganisationID` AS `OrganisationID`,
                `LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                `LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                `LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                `LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                `LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                `LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                `LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                `LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                `LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                `LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                `LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                `LineItem_LineAmount_USD` AS `LineAmount_USD`,
                `LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                `LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                `LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                `SubTotal_AUD` AS `SubTotal_AUD`,
                `SubTotal_USD` AS `SubTotal_USD`,
                `SubTotal_NZD` AS `SubTotal_NZD`,
                `SubTotal_EUR` AS `SubTotal_EUR`,
                `SubTotal_GBP` AS `SubTotal_GBP`,
                `TotalTax_AUD` AS `TotalTax_AUD`,
                `TotalTax_USD` AS `TotalTax_USD`,
                `TotalTax_NZD` AS `TotalTax_NZD`,
                `TotalTax_EUR` AS `TotalTax_EUR`,
                `TotalTax_GBP` AS `TotalTax_GBP`,
                `Total_AUD` AS `Total_AUD`,
                `Total_USD` AS `Total_USD`,
                `Total_NZD` AS `Total_NZD`,
                `Total_EUR` AS `Total_EUR`,
                `Total_GBP` AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `Remaining Credit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(`Date`, `FullyPaidOnDate`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_banktransactions
            WHERE `OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_{organisationid}_xeroblue_transactionsstage
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                P.`PaymentId` AS `LineID`,
                P.`PaymentId` AS `ID`,
                P.`Date` AS `Date`,
                P.`PaymentType` AS `Type`,
                CASE 
                    WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.`ContactId`
                    WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.`Contact_ContactId`
                    WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.`Contact_ContactId`
                    WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.`Contact_ContactId`
                    END AS `ContactID`,
                CASE 
                    WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.`ContactName`
                    WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.`Contact_Name`
                    WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.`Contact_Name`
                    WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.`Contact_Name`
                    END AS `ContactName`,
                P.`PaymentId` AS `LineItemID`,
                NULL AS `Description`,
                NULL AS `Quantity`,
                NULL AS `UnitAmount`,
                NULL AS `ItemCode`,
                P.`AccountCode` AS `AccountCode`,
                NULL AS `TaxType`,
                NULL AS `TaxAmount`,
                P.`Amount` AS `LineAmount`,
                NULL AS `LineAmountTypes`,
                P.`Status` AS `Status`,
                NULL AS `SubTotal`,
                NULL AS `TotalTax`,
                NULL AS `Total`,
                NULL AS `TrackingCategory1CategoryID`,
                NULL AS `TrackingCategory1CategoryName`,
                NULL AS `TrackingCategory1OptionID`,
                NULL AS `TrackingCategory1OptionName`,
                NULL AS `TrackingCategory1OptionStat`,
                NULL AS `TrackingCategory2CategoryID`,
                NULL AS `TrackingCategory2CategoryName`,
                NULL AS `TrackingCategory2OptionID`,
                NULL AS `TrackingCategory2OptionName`,
                NULL AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                NULL AS `CurrencyCode`,
                CASE WHEN P.`CurrencyRate` LIKE '%E%' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION('E' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
                P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(P.`AccountCode`, 'BLANK'), '-', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
                NULL AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                P.`Date` AS `FullyPaidOnDate`,
                P.`Reference` AS `Reference`,
                'PAYMENTS' AS `Source`,
                P.`ClientID` AS `ClientID`,
                P.`OrganisationID` AS `OrganisationID`,
                NULL AS `UnitAmount_AUD`,
                NULL AS `UnitAmount_USD`,
                NULL AS `UnitAmount_NZD`,
                NULL AS `UnitAmount_EUR`,
                NULL AS `UnitAmount_GBP`,
                NULL AS `TaxAmount_AUD`,
                NULL AS `TaxAmount_USD`,
                NULL AS `TaxAmount_NZD`,
                NULL AS `TaxAmount_EUR`,
                NULL AS `TaxAmount_GBP`,
                P.`Amount_AUD` AS `LineAmount_AUD`,
                P.`Amount_USD` AS `LineAmount_USD`,
                P.`Amount_NZD` AS `LineAmount_NZD`,
                P.`Amount_EUR` AS `LineAmount_EUR`,
                P.`Amount_GBP` AS `LineAmount_GBP`,
                NULL AS `SubTotal_AUD`,
                NULL AS `SubTotal_USD`,
                NULL AS `SubTotal_NZD`,
                NULL AS `SubTotal_EUR`,
                NULL AS `SubTotal_GBP`,
                NULL AS `TotalTax_AUD`,
                NULL AS `TotalTax_USD`,
                NULL AS `TotalTax_NZD`,
                NULL AS `TotalTax_EUR`,
                NULL AS `TotalTax_GBP`,
                NULL AS `Total_AUD`,
                NULL AS `Total_USD`,
                NULL AS `Total_NZD`,
                NULL AS `Total_EUR`,
                NULL AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                P.`InvoiceId` AS `PaymentSourceID`,
                CASE 
                    WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN 'INVOICES'
                    WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN 'CREDITNOTES'
                    WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN 'PREPAYMENTS'
                    WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN 'OVERPAYMENTS'
                    END AS `PaymentSourceType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(P.`Date`, P.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM {clientid}_xeroblue_payments P
            LEFT JOIN {clientid}_xeroblue_invoices I 
                ON P.`InvoiceId` = I.`InvoiceId` AND P.`OrganisationID` = I.`OrganisationID`
            LEFT JOIN {clientid}_xeroblue_creditnotes C
                ON P.`InvoiceId` = C.`CreditNoteID` AND P.`OrganisationID` = C.`OrganisationID`
            LEFT JOIN {clientid}_xeroblue_prepayments PP
                ON P.`InvoiceId` = PP.`PrepaymentId` AND P.`OrganisationID` = PP.`OrganisationID`
            LEFT JOIN {clientid}_xeroblue_overpayments OP
                ON P.`InvoiceId` = OP.`OverpaymentId` AND P.`OrganisationID` = OP.`OrganisationID`
            WHERE P.`OrganisationID` = v_OrganisationID;

            DELETE FROM {clientid}_xeroblue_transactions WHERE `OrganisationID` = v_OrganisationID;

            INSERT INTO {clientid}_xeroblue_transactions
            SELECT * FROM {clientid}_{organisationid}_xeroblue_transactionsstage;
        END $$


        DROP PROCEDURE IF EXISTS sp_{clientid}_{organisationid}_xeroblue_transactionsblend $$
        CREATE PROCEDURE sp_{clientid}_{organisationid}_xeroblue_transactionsblend()
        BEGIN
            DECLARE v_OrganisationID INT DEFAULT {legacyorganisationid};

            TRUNCATE TABLE {clientid}_{organisationid}_xeroblue_transactionsblendstage;

            INSERT INTO `{clientid}_{organisationid}_xeroblue_transactionsblendstage`
            (
                `Id`,
                `JournalId`,
                `JournalDate`,
                `JournalNumber`,
                `CreatedDateUTC`,
                `SourceId`,
                `SourceType`,
                `JournalLine_JournalLineId`,
                `JournalLine_Description`,
                `JournalLine_AccountId`,
                `JournalLine_AccountCode`,
                `JournalLine_AccountType`,
                `JournalLine_AccountName`,
                `JournalLine_NetAmount`,
                `JournalLine_GrossAmount`,
                `JournalLine_TaxAmount`,
                `JournalLine_TaxType`,
                `JournalLine_TaxName`,
                `LineItem_TrackingCategory1_CategoryId`,
                `LineItem_TrackingCategory1_CategoryName`,
                `LineItem_TrackingCategory1_OptionId`,
                `LineItem_TrackingCategory1_OptionName`,
                `LineItem_TrackingCategory1_Option_Stat`,
                `LineItem_TrackingCategory2_CategoryId`,
                `LineItem_TrackingCategory2_CategoryName`,
                `LineItem_TrackingCategory2_OptionId`,
                `LineItem_TrackingCategory2_OptionName`,
                `LineItem_TrackingCategory2_Option_Stat`,
                `ClientID`,
                `OrganisationID`,
                `JournalLine_NetAmount_AUD`,
                `JournalLine_NetAmount_USD`,
                `JournalLine_NetAmount_NZD`,
                `JournalLine_NetAmount_EUR`,
                `JournalLine_NetAmount_GBP`,
                `JournalLine_GrossAmount_AUD`,
                `JournalLine_GrossAmount_USD`,
                `JournalLine_GrossAmount_NZD`,
                `JournalLine_GrossAmount_EUR`,
                `JournalLine_GrossAmount_GBP`,
                `JournalLine_TaxAmount_AUD`,
                `JournalLine_TaxAmount_USD`,
                `JournalLine_TaxAmount_NZD`,
                `JournalLine_TaxAmount_EUR`,
                `JournalLine_TaxAmount_GBP`,
                `Split`,
                `Changes`,
                `User`,
                `Details`,
                `SourceNumber`,
                `CashOrAccruals`,
                `ContactID`,
                `ContactName`,
                `ContactSource`,
                `PaymentSourceID`,
                `PaymentType`,
                `ShowOnCashBasisReports`,
                `FullyPaidOnDate`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `ItemCode`,
                `Quantity`,
                `DiscountRate`,
                `UnitAmount`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`,
                `DueDate`,
                `Reference`
            )
            SELECT DISTINCT
                tb.`Id`,
                tb.`JournalId`,
                tb.`JournalDate`,
                tb.`JournalNumber`,
                tb.`CreatedDateUTC`,
                tb.`SourceId`,
                tb.`SourceType`,
                tb.`JournalLine_JournalLineId`,
                tb.`JournalLine_Description`,
                tb.`JournalLine_AccountId`,
                tb.`JournalLine_AccountCode`,
                tb.`JournalLine_AccountType`,
                tb.`JournalLine_AccountName`,
                tb.`JournalLine_NetAmount`,
                tb.`JournalLine_GrossAmount`,
                tb.`JournalLine_TaxAmount`,
                tb.`JournalLine_TaxType`,
                tb.`JournalLine_TaxName`,
                tb.`LineItem_TrackingCategory1_CategoryId`,
                tb.`LineItem_TrackingCategory1_CategoryName`,
                tb.`LineItem_TrackingCategory1_OptionId`,
                tb.`LineItem_TrackingCategory1_OptionName`,
                tb.`LineItem_TrackingCategory1_Option_Stat`,
                tb.`LineItem_TrackingCategory2_CategoryId`,
                tb.`LineItem_TrackingCategory2_CategoryName`,
                tb.`LineItem_TrackingCategory2_OptionId`,
                tb.`LineItem_TrackingCategory2_OptionName`,
                tb.`LineItem_TrackingCategory2_Option_Stat`,
                tb.`ClientID`,
                tb.`OrganisationID`,
                tb.`JournalLine_NetAmount_AUD`,
                tb.`JournalLine_NetAmount_USD`,
                tb.`JournalLine_NetAmount_NZD`,
                tb.`JournalLine_NetAmount_EUR`,
                tb.`JournalLine_NetAmount_GBP`,
                tb.`JournalLine_GrossAmount_AUD`,
                tb.`JournalLine_GrossAmount_USD`,
                tb.`JournalLine_GrossAmount_NZD`,
                tb.`JournalLine_GrossAmount_EUR`,
                tb.`JournalLine_GrossAmount_GBP`,
                tb.`JournalLine_TaxAmount_AUD`,
                tb.`JournalLine_TaxAmount_USD`,
                tb.`JournalLine_TaxAmount_NZD`,
                tb.`JournalLine_TaxAmount_EUR`,
                tb.`JournalLine_TaxAmount_GBP`,
                tb.`Split`,
                tb.`Changes`,
                tb.`User`,
                tb.`Details`,
                COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
                'Accruals' AS `CashOrAccruals`,
                t2.`ContactID` AS `ContactID`,
                t2.`ContactName` AS `ContactName`,
                t2.`Source` AS `ContactSource`,
                CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
                CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END `PaymentType`,
                t2.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
                t2.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                t2.`DayDifference` AS `DayDifference`,
                t.`PlannedPaymentDate` AS `PlannedPaymentDate`,
                t.`ItemCode` AS `ItemCode`,
                t.`Quantity` AS `Quantity`,
                t.`DiscountRate` AS `DiscountRate`,
                t.`UnitAmount` AS `UnitAmount`,
                t.`UnitAmount_AUD` AS `UnitAmount_AUD`,
                t.`UnitAmount_USD` AS `UnitAmount_USD`,
                t.`UnitAmount_NZD` AS `UnitAmount_NZD`,
                t.`UnitAmount_EUR` AS `UnitAmount_EUR`,
                t.`UnitAmount_GBP` AS `UnitAmount_GBP`,
                t.`AmountDue` AS `AmountDue`,
                t.`AmountDue_AUD` AS `AmountDue_AUD`,
                t.`AmountDue_USD` AS `AmountDue_USD`,
                t.`AmountDue_NZD` AS `AmountDue_NZD`,
                t.`AmountDue_EUR` AS `AmountDue_EUR`,
                t.`AmountDue_GBP` AS `AmountDue_GBP`,
                t.`URL` AS `URL`,
                t.`DueDate` AS `DueDate`,
                CASE WHEN tb.`Reference` IS NULL THEN t.`Reference` ELSE tb.`Reference` END AS `Reference`
            FROM `{clientid}_xeroblue_journals` tb
            LEFT JOIN {clientid}_xeroblue_transactions AS t 
            ON tb.`SourceId` = t.Id 
            AND tb.`OrganisationID` = t.`OrganisationID`
            AND tb.`JournalLine_AccountCode` = t.`AccountCode`
            AND tb.`JournalLine_NetAmount` = t.`LineAmount`
            LEFT JOIN (
                SELECT DISTINCT
                    `Id`,
                    `ContactID`,
                    `ContactName`,
                    `Source`,
                    `ShowOnCashBasisReports`,
                    `FullyPaidOnDate`,
                    `DayDifference`,
                    `OrganisationID`
                FROM {clientid}_xeroblue_transactions
                WHERE `OrganisationID` = v_OrganisationID
            ) AS t2
            ON tb.`SourceId` = t2.Id 
            AND tb.`OrganisationID` = t2.`OrganisationID`
            WHERE tb.`OrganisationID` = v_OrganisationID
            
            UNION ALL
            SELECT DISTINCT
                tb.`Id`,
                tb.`JournalId`,
                tb.`JournalDate`,
                tb.`JournalNumber`,
                tb.`CreatedDateUTC`,
                tb.`SourceId`,
                tb.`SourceType`,
                tb.`JournalLine_JournalLineId`,
                tb.`JournalLine_Description`,
                tb.`JournalLine_AccountId`,
                tb.`JournalLine_AccountCode`,
                tb.`JournalLine_AccountType`,
                tb.`JournalLine_AccountName`,
                tb.`JournalLine_NetAmount`,
                tb.`JournalLine_GrossAmount`,
                tb.`JournalLine_TaxAmount`,
                tb.`JournalLine_TaxType`,
                tb.`JournalLine_TaxName`,
                tb.`LineItem_TrackingCategory1_CategoryId`,
                tb.`LineItem_TrackingCategory1_CategoryName`,
                tb.`LineItem_TrackingCategory1_OptionId`,
                tb.`LineItem_TrackingCategory1_OptionName`,
                tb.`LineItem_TrackingCategory1_Option_Stat`,
                tb.`LineItem_TrackingCategory2_CategoryId`,
                tb.`LineItem_TrackingCategory2_CategoryName`,
                tb.`LineItem_TrackingCategory2_OptionId`,
                tb.`LineItem_TrackingCategory2_OptionName`,
                tb.`LineItem_TrackingCategory2_Option_Stat`,
                tb.`ClientID`,
                tb.`OrganisationID`,
                tb.`JournalLine_NetAmount_AUD`,
                tb.`JournalLine_NetAmount_USD`,
                tb.`JournalLine_NetAmount_NZD`,
                tb.`JournalLine_NetAmount_EUR`,
                tb.`JournalLine_NetAmount_GBP`,
                tb.`JournalLine_GrossAmount_AUD`,
                tb.`JournalLine_GrossAmount_USD`,
                tb.`JournalLine_GrossAmount_NZD`,
                tb.`JournalLine_GrossAmount_EUR`,
                tb.`JournalLine_GrossAmount_GBP`,
                tb.`JournalLine_TaxAmount_AUD`,
                tb.`JournalLine_TaxAmount_USD`,
                tb.`JournalLine_TaxAmount_NZD`,
                tb.`JournalLine_TaxAmount_EUR`,
                tb.`JournalLine_TaxAmount_GBP`,
                tb.`Split`,
                tb.`Changes`,
                tb.`User`,
                tb.`Details`,
                COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
                'Cash' AS `CashOrAccruals`,
                t2.`ContactID` AS `ContactID`,
                t2.`ContactName` AS `ContactName`,
                t2.`Source` AS `ContactSource`,
                CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
                CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END `PaymentType`,
                t2.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
                t2.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                t2.`DayDifference` AS `DayDifference`,
                t.`PlannedPaymentDate` AS `PlannedPaymentDate`,
                t.`ItemCode` AS `ItemCode`,
                t.`Quantity` AS `Quantity`,
                t.`DiscountRate` AS `DiscountRate`,
                t.`UnitAmount` AS `UnitAmount`,
                t.`UnitAmount_AUD` AS `UnitAmount_AUD`,
                t.`UnitAmount_USD` AS `UnitAmount_USD`,
                t.`UnitAmount_NZD` AS `UnitAmount_NZD`,
                t.`UnitAmount_EUR` AS `UnitAmount_EUR`,
                t.`UnitAmount_GBP` AS `UnitAmount_GBP`,
                t.`AmountDue` AS `AmountDue`,
                t.`AmountDue_AUD` AS `AmountDue_AUD`,
                t.`AmountDue_USD` AS `AmountDue_USD`,
                t.`AmountDue_NZD` AS `AmountDue_NZD`,
                t.`AmountDue_EUR` AS `AmountDue_EUR`,
                t.`AmountDue_GBP` AS `AmountDue_GBP`,
                t.`URL` AS `URL`,
                t.`DueDate` AS `DueDate`,
                CASE WHEN tb.`Reference` IS NULL THEN t.`Reference` ELSE tb.`Reference` END AS `Reference`
            FROM `{clientid}_xeroblue_journalscash` tb
            LEFT JOIN {clientid}_xeroblue_transactions AS t 
            ON tb.`SourceId` = t.Id
            AND tb.`OrganisationID` = t.`OrganisationID`
            AND tb.`JournalLine_AccountCode` = t.`AccountCode`
            AND tb.`JournalLine_NetAmount` = t.`LineAmount`
            LEFT JOIN (
                SELECT DISTINCT
                    `Id`,
                    `ContactID`,
                    `ContactName`,
                    `Source`,
                    `ShowOnCashBasisReports`,
                    `FullyPaidOnDate`,
                    `DayDifference`,
                    `OrganisationID`
                FROM {clientid}_xeroblue_transactions
                WHERE `OrganisationID` = v_OrganisationID
            ) AS t2
            ON tb.`SourceId` = t2.Id 
            AND tb.`OrganisationID` = t2.`OrganisationID`
            WHERE tb.`OrganisationID` = v_OrganisationID;

            DELETE FROM `{clientid}_xeroblue_transactionsblend` WHERE `OrganisationId` = v_OrganisationID;

            INSERT INTO {clientid}_xeroblue_transactionsblend
            (
                `Id`,
                `JournalId`,
                `JournalDate`,
                `JournalNumber`,
                `CreatedDateUTC`,
                `SourceId`,
                `SourceType`,
                `JournalLine_JournalLineId`,
                `JournalLine_Description`,
                `JournalLine_AccountId`,
                `JournalLine_AccountCode`,
                `JournalLine_AccountType`,
                `JournalLine_AccountName`,
                `JournalLine_NetAmount`,
                `JournalLine_GrossAmount`,
                `JournalLine_TaxAmount`,
                `JournalLine_TaxType`,
                `JournalLine_TaxName`,
                `LineItem_TrackingCategory1_CategoryId`,
                `LineItem_TrackingCategory1_CategoryName`,
                `LineItem_TrackingCategory1_OptionId`,
                `LineItem_TrackingCategory1_OptionName`,
                `LineItem_TrackingCategory1_Option_Stat`,
                `LineItem_TrackingCategory2_CategoryId`,
                `LineItem_TrackingCategory2_CategoryName`,
                `LineItem_TrackingCategory2_OptionId`,
                `LineItem_TrackingCategory2_OptionName`,
                `LineItem_TrackingCategory2_Option_Stat`,
                `ClientID`,
                `OrganisationID`,
                `JournalLine_NetAmount_AUD`,
                `JournalLine_NetAmount_USD`,
                `JournalLine_NetAmount_NZD`,
                `JournalLine_NetAmount_EUR`,
                `JournalLine_NetAmount_GBP`,
                `JournalLine_GrossAmount_AUD`,
                `JournalLine_GrossAmount_USD`,
                `JournalLine_GrossAmount_NZD`,
                `JournalLine_GrossAmount_EUR`,
                `JournalLine_GrossAmount_GBP`,
                `JournalLine_TaxAmount_AUD`,
                `JournalLine_TaxAmount_USD`,
                `JournalLine_TaxAmount_NZD`,
                `JournalLine_TaxAmount_EUR`,
                `JournalLine_TaxAmount_GBP`,
                `Split`,
                `Changes`,
                `User`,
                `Details`,
                `SourceNumber`,
                `CashOrAccruals`,
                `ContactID`,
                `ContactName`,
                `ContactSource`,
                `PaymentSourceID`,
                `PaymentType`,
                `ShowOnCashBasisReports`,
                `FullyPaidOnDate`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `ItemCode`,
                `Quantity`,
                `DiscountRate`,
                `UnitAmount`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`,
                `DueDate`,
                `Reference` 
            )
            SELECT
                `Id`,
                `JournalId`,
                `JournalDate`,
                `JournalNumber`,
                `CreatedDateUTC`,
                `SourceId`,
                `SourceType`,
                `JournalLine_JournalLineId`,
                `JournalLine_Description`,
                `JournalLine_AccountId`,
                `JournalLine_AccountCode`,
                `JournalLine_AccountType`,
                `JournalLine_AccountName`,
                `JournalLine_NetAmount`,
                `JournalLine_GrossAmount`,
                `JournalLine_TaxAmount`,
                `JournalLine_TaxType`,
                `JournalLine_TaxName`,
                `LineItem_TrackingCategory1_CategoryId`,
                `LineItem_TrackingCategory1_CategoryName`,
                `LineItem_TrackingCategory1_OptionId`,
                `LineItem_TrackingCategory1_OptionName`,
                `LineItem_TrackingCategory1_Option_Stat`,
                `LineItem_TrackingCategory2_CategoryId`,
                `LineItem_TrackingCategory2_CategoryName`,
                `LineItem_TrackingCategory2_OptionId`,
                `LineItem_TrackingCategory2_OptionName`,
                `LineItem_TrackingCategory2_Option_Stat`,
                `ClientID`,
                `OrganisationID`,
                `JournalLine_NetAmount_AUD`,
                `JournalLine_NetAmount_USD`,
                `JournalLine_NetAmount_NZD`,
                `JournalLine_NetAmount_EUR`,
                `JournalLine_NetAmount_GBP`,
                `JournalLine_GrossAmount_AUD`,
                `JournalLine_GrossAmount_USD`,
                `JournalLine_GrossAmount_NZD`,
                `JournalLine_GrossAmount_EUR`,
                `JournalLine_GrossAmount_GBP`,
                `JournalLine_TaxAmount_AUD`,
                `JournalLine_TaxAmount_USD`,
                `JournalLine_TaxAmount_NZD`,
                `JournalLine_TaxAmount_EUR`,
                `JournalLine_TaxAmount_GBP`,
                `Split`,
                `Changes`,
                `User`,
                `Details`,
                `SourceNumber`,
                `CashOrAccruals`,
                `ContactID`,
                `ContactName`,
                `ContactSource`,
                `PaymentSourceID`,
                `PaymentType`,
                `ShowOnCashBasisReports`,
                `FullyPaidOnDate`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `ItemCode`,
                `Quantity`,
                `DiscountRate`,
                `UnitAmount`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`,
                `DueDate`,
                `Reference` 
            FROM (
            SELECT
                *
                ,ROW_NUMBER() OVER(PARTITION BY CashOrAccruals,JournalNumber,id ORDER BY CashOrAccruals,JournalNumber,id) AS RN
            FROM {clientid}_{organisationid}_xeroblue_transactionsblendstage
            ) a WHERE RN = 1;
        END $$
        """
    
    ExecuteMySQLScript(MYSQL_STAGE_SP,evastage_engine)

def CreateViewsInEvaDB(clientid, cmsclientid):
#     MYSQL_VIEWS = f"""
#     """
#     MYSQL_VIEWS = MYSQL_FXVIEWS.replace('fxcurrency',fx).replace('bigoleshoecompany_client0000',clientid).replace('c0000',cmsclientid)
#     ExecuteMySQLScript(MYSQL_VIEWS,eva_engine)

    fxs = {'AUD','USD','NZD','GBP','EUR'}
    for fx in fxs:
        MYSQL_FXVIEWS = f"""
        CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblend_fxcurrency AS
        SELECT 
            tb.`Id` AS `ID`,
            tb.`JournalId` AS `Journal ID`,
            tb.`JournalNumber` AS `Index`,
            tb.`JournalDate` AS `Journal Date`,
            tb.`JournalNumber` AS `Journal Number`,
            tb.`CreatedDateUTC` AS `Created Date UTC`,
            tb.`Reference` AS `Reference`,
            tb.`SourceId` AS `Source ID`,
            tb.`SourceType` AS `Source Type`,
            tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
            tb.`JournalLine_Description` AS `Description`,
            Acc.`AccountID` AS `Account ID`,
            Acc.`Code` AS `Account Code`,
            Acc.`AccountType` AS `Account Type`,
            Acc.`Name` AS `Account Name`,
            tb.`JournalLine_NetAmount` AS `Net Amount`,
            tb.`JournalLine_GrossAmount` AS `Gross Amount`,
            tb.`JournalLine_TaxAmount` AS `Tax Amount`,
            tb.`JournalLine_NetAmount_fxcurrency` AS `Net Amount FX`,
            tb.`JournalLine_GrossAmount_fxcurrency` AS `Gross Amount FX`,
            tb.`JournalLine_TaxAmount_fxcurrency` AS `Tax Amount FX`,
            tb.`JournalLine_TaxType` AS `Tax Type`,
            tb.`JournalLine_TaxName` AS `Tax Name`,
            tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
            tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
            tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
            tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
            tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
            tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
            tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
            tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
            tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
            tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
            tb.`ClientID` AS `Client ID`,
            tb.`OrganisationID` AS `Organisation ID`,
            tb.`Split` AS `Split`,
            tb.`ContactID` AS `Contact ID`,
            tb.`ContactName` AS `Contact Name`,
            tb.`ContactSource` AS `ContactSource`,
            tb.`PaymentSourceID` AS `PaymentSourceID`,
            tb.`PaymentType` AS `PaymentType`,
            tb.`Changes` AS `Changes`,
            tb.`User` AS `User`,
            tb.`Details` AS `Details`,
            tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
            tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            tb.`DayDifference` AS `DayDifference`,
            COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
            'Accruals' AS `Cash/Accruals`,
            tb.`ACC_ACCPAY` AS `ACC/ACCPAY`,
            tb.`Accounts_Class` AS `Accounts.Class`,
            tb.`PnL_BS` AS `PnL-BS`,
            tb.`AgedMovement` AS `Aged Movement`,
            tb.`CashReceived` AS `Cash Received`,
            tb.`CashSpent` AS `Cash Spent`,
            tb.`DebitGross` AS `Debit Gross`,
            tb.`DebitNetAmount` AS `Debit Net Amount`,
            tb.`CreditGross` AS `Credit Gross`,
            tb.`CreditNetAmount` AS `Credit Net Amount`,
            tb.`DebitGrossFX` AS `Debit Gross FX`,
            tb.`DebitNetAmountFX` AS `Debit Net Amount FX`,
            tb.`CreditGrossFX` AS `Credit Gross FX`,
            tb.`CreditNetAmountFX` AS `Credit Net Amount FX`,
            tb.`CashSummary` AS `Cash Summary`,
            tb.`DetailedBreakdownAccountNames` AS `Detailed Breakdown Account Names`,
            CASE 
                WHEN tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
                WHEN tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
                WHEN tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
                WHEN tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
                WHEN tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
                WHEN tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Approved' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Approved' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Edited' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Edited' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Credited' THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Credited' THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Applied' THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Applied' THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Prepayment Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Prepayment Note Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Overpayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Overpayment Allocation'
                ELSE NULL 
            END AS `Source`,
            CASE
                WHEN tb.`ContactSource` = 'PAYMENTS' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'INVOICES' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Approved' THEN
                    TRIM(REPLACE (CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Edited' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                ELSE NULL
            END AS `Sync`,
            tb.`PlannedPaymentDate` AS `Planned Payment Date`,
            tb.`ItemCode` AS `Item Code`,
            tb.`Quantity` AS `Quantity`,
            tb.`DiscountRate` AS `Discount Rate`,
            tb.`UnitAmount` AS `Unit Amount`,
            tb.`UnitAmount_fxcurrency` AS `Unit Amount FX`,
            tb.`AmountDue` AS `Amount Due`,
            tb.`AmountDue_fxcurrency` AS `Amount Due FX`,
            tb.`URL` AS `URL`,
            tb.`DueDate` AS `Due Date`,
            Acc.`SystemAccount` AS `System Account`,
            NULL AS `Invoice Total`,
            Acc.`Class` AS `Account Class`
        FROM evadb_stage.c0000_xeroblue_journals Tb
        LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
        ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;

        CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblendcash_fxcurrency AS
        SELECT 
            tb.`Id` AS `ID`,
            tb.`JournalId` AS `Journal ID`,
            tb.`JournalNumber` AS `Index`,
            tb.`JournalDate` AS `Journal Date`,
            tb.`JournalNumber` AS `Journal Number`,
            tb.`CreatedDateUTC` AS `Created Date UTC`,
            tb.`Reference` AS `Reference`,
            tb.`SourceId` AS `Source ID`,
            tb.`SourceType` AS `Source Type`,
            tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
            tb.`JournalLine_Description` AS `Description`,
            Acc.`AccountID` AS `Account ID`,
            Acc.`Code` AS `Account Code`,
            Acc.`AccountType` AS `Account Type`,
            Acc.`Name` AS `Account Name`,
            tb.`JournalLine_NetAmount` AS `Net Amount`,
            tb.`JournalLine_GrossAmount` AS `Gross Amount`,
            tb.`JournalLine_TaxAmount` AS `Tax Amount`,
            tb.`JournalLine_NetAmount_fxcurrency` AS `Net Amount FX`,
            tb.`JournalLine_GrossAmount_fxcurrency` AS `Gross Amount FX`,
            tb.`JournalLine_TaxAmount_fxcurrency` AS `Tax Amount FX`,
            tb.`JournalLine_TaxType` AS `Tax Type`,
            tb.`JournalLine_TaxName` AS `Tax Name`,
            tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
            tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
            tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
            tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
            tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
            tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
            tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
            tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
            tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
            tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
            tb.`ClientID` AS `Client ID`,
            tb.`OrganisationID` AS `Organisation ID`,
            tb.`Split` AS `Split`,
            tb.`ContactID` AS `Contact ID`,
            tb.`ContactName` AS `Contact Name`,
            tb.`ContactSource` AS `ContactSource`,
            tb.`PaymentSourceID` AS `PaymentSourceID`,
            tb.`PaymentType` AS `PaymentType`,
            tb.`Changes` AS `Changes`,
            tb.`User` AS `User`,
            tb.`Details` AS `Details`,
            tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
            tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            tb.`DayDifference` AS `DayDifference`,
            COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
            'Cash' AS `Cash/Accruals`,
            tb.`ACC_ACCPAY` AS `ACC/ACCPAY`,
            tb.`Accounts_Class` AS `Accounts.Class`,
            tb.`PnL_BS` AS `PnL-BS`,
            tb.`AgedMovement` AS `Aged Movement`,
            tb.`CashReceived` AS `Cash Received`,
            tb.`CashSpent` AS `Cash Spent`,
            tb.`DebitGross` AS `Debit Gross`,
            tb.`DebitNetAmount` AS `Debit Net Amount`,
            tb.`CreditGross` AS `Credit Gross`,
            tb.`CreditNetAmount` AS `Credit Net Amount`,
            tb.`DebitGrossFX` AS `Debit Gross FX`,
            tb.`DebitNetAmountFX` AS `Debit Net Amount FX`,
            tb.`CreditGrossFX` AS `Credit Gross FX`,
            tb.`CreditNetAmountFX` AS `Credit Net Amount FX`,
            tb.`CashSummary` AS `Cash Summary`,
            tb.`DetailedBreakdownAccountNames` AS `Detailed Breakdown Account Names`,
            CASE 
                WHEN tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
                WHEN tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
                WHEN tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
                WHEN tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
                WHEN tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
                WHEN tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Approved' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Approved' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Edited' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Edited' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Credited' THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Credited' THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Applied' THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Applied' THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Prepayment Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Prepayment Note Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Overpayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Overpayment Allocation'
                ELSE NULL 
            END AS `Source`,
            CASE
                WHEN tb.`ContactSource` = 'PAYMENTS' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'INVOICES' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Approved' THEN
                    TRIM(REPLACE (CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Edited' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                ELSE NULL
            END AS `Sync`,
            tb.`PlannedPaymentDate` AS `Planned Payment Date`,
            tb.`ItemCode` AS `Item Code`,
            tb.`Quantity` AS `Quantity`,
            tb.`DiscountRate` AS `Discount Rate`,
            tb.`UnitAmount` AS `Unit Amount`,
            tb.`UnitAmount_fxcurrency` AS `Unit Amount FX`,
            tb.`AmountDue` AS `Amount Due`,
            tb.`AmountDue_fxcurrency` AS `Amount Due FX`,
            tb.`URL` AS `URL`,
            tb.`DueDate` AS `Due Date`,
            Acc.`SystemAccount` AS `System Account`,
            NULL AS `Invoice Total`,
            Acc.`Class` AS `Account Class`
        FROM evadb_stage.c0000_xeroblue_journalscash Tb
        LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
        ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;

        CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_accrualtransactions_fxcurrency AS
        SELECT
            `tb`.`JournalDate` AS `Date`,
            `tb`.`Reference` AS `Reference`,
            `tb`.`SourceType` AS `SourceType`,
            `tb`.`JournalLine_Description` AS `Description`,
            `tb`.`JournalLine_AccountId` AS `AccountID`,
            `tb`.`JournalLine_AccountCode` AS `AccountCode`,
            `tb`.`JournalLine_AccountType` AS `AccountType`,
            `tb`.`JournalLine_AccountName` AS `AccountName`,
            `tb`.`JournalLine_NetAmount` AS `Amount`,
            `tb`.`JournalLine_TaxAmount` AS `TaxAmount`,
            `tb`.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategoryCategoryName`,
            `tb`.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategoryOptionName`,
            `tb`.`ContactID` AS `ContactID`,
            `tb`.`ContactName` AS `ContactName`,
            `tb`.`SourceType` AS `InvoiceOrBill`,
            `tb`.`Accounts_Class` AS `AccountClass`,
            `tb`.`OrganisationID` AS `OrganisationID`,
            `tb`.`Id` AS `ID`,
            `tb`.`JournalId` AS `JournalID`,
            `tb`.`JournalDate` AS `JournalDate`,
            `tb`.`JournalNumber` AS `JournalNumber`,
            `tb`.`CreatedDateUTC` AS `CreatedDateUTC`,
            `tb`.`SourceId` AS `SourceID`,
            `tb`.`JournalLine_JournalLineId` AS `JournalLineID`,
            `tb`.`JournalLine_GrossAmount_fxcurrency` AS `GrossAmountFX`,
            `tb`.`JournalLine_TaxType` AS `TaxType`,
            `tb`.`JournalLine_TaxName` AS `TaxName`,
            `tb`.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategoryCategoryID`,
            `tb`.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategoryOptionID`,
            `tb`.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategoryOptionStat`,
            `tb`.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
            `tb`.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
            `tb`.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
            `tb`.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
            `tb`.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
            `tb`.`ClientID` AS `ClientID`,
            `tb`.`Split` AS `Split`,
            `tb`.`ContactSource` AS `ContactSource`,
            `tb`.`PaymentSourceID` AS `PaymentSourceID`,
            `tb`.`PaymentType` AS `PaymentType`,
            `tb`.`Changes` AS `Changes`,
            `tb`.`User` AS `User`,
            `tb`.`Details` AS `Details`,
            `tb`.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
            `tb`.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            `tb`.`DayDifference` AS `DayDifference`,
            'ACCRUALS' AS `JournalType`,
            `tb`.`OrganisationName` AS `OrganisationName`,
            `SystemAccount` AS `SystemAccount`,
            COALESCE(`tb`.`InvoiceNumber`, `tb`.`CreditNoteNumber`) AS `SourceNumber`,
            `tb`.`ACC_ACCPAY` AS `ACCorACCPAY`,
            `tb`.`AgedMovement` AS `AgedMovement`,
            `tb`.`DebitGross` AS `DebitGross`,
            `tb`.`DebitNetAmount` AS `DebitNetAmount`,
            `tb`.`CreditGross` AS `CreditGross`,
            `tb`.`CreditNetAmount` AS `CreditNetAmount`,
            `tb`.`CashSummary` AS `CashSummary`,
            CASE 
                WHEN tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
                WHEN tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
                WHEN tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
                WHEN tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
                WHEN tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
                WHEN tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`PaymentSourceID` is not null THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Prepayment Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Payable Overpayment Allocation'
                ELSE NULL 
            END AS `Source`,
            CASE
                WHEN tb.`ContactSource` = 'PAYMENTS' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'INVOICES' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE (CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                ELSE NULL
            END AS `Sync`,
            `tb`.`PlannedPaymentDate` AS `PlannedPaymentDate`,
            `tb`.`ItemCode` AS `ItemCode`,
            `tb`.`Quantity` AS `Quantity`,
            `tb`.`DiscountRate` AS `DiscountRate`,
            `tb`.`UnitAmount` AS `UnitAmount`,
            `tb`.`URL` AS `URL`,
            `tb`.`DueDate` AS `DueDate`,
            `tb`.`InvoiceTotal` AS `InvoiceTotal`
        FROM `evadb_stage`.`c0000_xeroblue_journals` `tb`
        WHERE `tb`.`isvisible` = 1;

        CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_cashtransactions_fxcurrency AS
        SELECT
            `tb`.`JournalDate` AS `Date`,
            `tb`.`Reference` AS `Reference`,
            `tb`.`SourceType` AS `SourceType`,
            `tb`.`JournalLine_Description` AS `Description`,
            `tb`.`JournalLine_AccountId` AS `AccountID`,
            `tb`.`JournalLine_AccountCode` AS `AccountCode`,
            `tb`.`JournalLine_AccountType` AS `AccountType`,
            `tb`.`JournalLine_AccountName` AS `AccountName`,
            `tb`.`JournalLine_NetAmount` AS `Amount`,
            `tb`.`JournalLine_TaxAmount` AS `TaxAmount`,
            `tb`.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategoryCategoryName`,
            `tb`.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategoryOptionName`,
            `tb`.`ContactID` AS `ContactID`,
            `tb`.`ContactName` AS `ContactName`,
            `tb`.`SourceType` AS `InvoiceOrBill`,
            `tb`.`Accounts_Class` AS `AccountClass`,
            `tb`.`OrganisationID` AS `OrganisationID`,
            `tb`.`Id` AS `ID`,
            `tb`.`JournalId` AS `JournalID`,
            `tb`.`JournalDate` AS `JournalDate`,
            `tb`.`JournalNumber` AS `JournalNumber`,
            `tb`.`CreatedDateUTC` AS `CreatedDateUTC`,
            `tb`.`SourceId` AS `SourceID`,
            `tb`.`JournalLine_JournalLineId` AS `JournalLineID`,
            `tb`.`JournalLine_GrossAmount_fxcurrency` AS `GrossAmountFX`,
            `tb`.`JournalLine_TaxType` AS `TaxType`,
            `tb`.`JournalLine_TaxName` AS `TaxName`,
            `tb`.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategoryCategoryID`,
            `tb`.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategoryOptionID`,
            `tb`.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategoryOptionStat`,
            `tb`.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
            `tb`.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
            `tb`.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
            `tb`.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
            `tb`.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
            `tb`.`ClientID` AS `ClientID`,
            `tb`.`Split` AS `Split`,
            `tb`.`ContactSource` AS `ContactSource`,
            `tb`.`PaymentSourceID` AS `PaymentSourceID`,
            `tb`.`PaymentType` AS `PaymentType`,
            `tb`.`Changes` AS `Changes`,
            `tb`.`User` AS `User`,
            `tb`.`Details` AS `Details`,
            `tb`.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
            `tb`.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            `tb`.`DayDifference` AS `DayDifference`,
            'ACCRUALS' AS `JournalType`,
            `tb`.`OrganisationName` AS `OrganisationName`,
            `SystemAccount` AS `SystemAccount`,
            COALESCE(`tb`.`InvoiceNumber`, `tb`.`CreditNoteNumber`) AS `SourceNumber`,
            `tb`.`ACC_ACCPAY` AS `ACCorACCPAY`,
            `tb`.`AgedMovement` AS `AgedMovement`,
            `tb`.`DebitGross` AS `DebitGross`,
            `tb`.`DebitNetAmount` AS `DebitNetAmount`,
            `tb`.`CreditGross` AS `CreditGross`,
            `tb`.`CreditNetAmount` AS `CreditNetAmount`,
            `tb`.`CashSummary` AS `CashSummary`,
            CASE 
                WHEN tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
                WHEN tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
                WHEN tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
                WHEN tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
                WHEN tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
                WHEN tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' THEN 'Receivable Credit Note'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' THEN 'Payable Credit Note'
                WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`PaymentSourceID` is not null THEN 'Payable Credit Note Allocation'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' THEN 'Receivable Prepayment'
                WHEN tb.`SourceType` = 'APPREPAYMENT' THEN 'Payable Prepayment'
                WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Prepayment Allocation'
                WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Payable Prepayment Allocation'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' THEN 'Receivable Overpayment'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' THEN 'Payable Overpayment'
                WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Receivable Overpayment Allocation'
                WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`PaymentSourceID` is not null THEN 'Payable Overpayment Allocation'
                ELSE NULL 
            END AS `Source`,
            CASE
                WHEN tb.`ContactSource` = 'PAYMENTS' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'INVOICES' THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE (CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`PaymentSourceID` is null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
                WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`PaymentSourceID` is not null THEN
                    TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
                ELSE NULL
            END AS `Sync`,
            `tb`.`PlannedPaymentDate` AS `PlannedPaymentDate`,
            `tb`.`ItemCode` AS `ItemCode`,
            `tb`.`Quantity` AS `Quantity`,
            `tb`.`DiscountRate` AS `DiscountRate`,
            `tb`.`UnitAmount` AS `UnitAmount`,
            `tb`.`URL` AS `URL`,
            `tb`.`DueDate` AS `DueDate`,
            `tb`.`InvoiceTotal` AS `InvoiceTotal`
        FROM `evadb_stage`.`c0000_xeroblue_journalscash` `tb`
        WHERE `tb`.`isvisible` = 1;
        """
        MYSQL_FXVIEWS = MYSQL_FXVIEWS.replace('fxcurrency',fx).replace('bigoleshoecompany_client0000',clientid).replace('c0000',cmsclientid)
        ExecuteMySQLScript(MYSQL_FXVIEWS,eva_engine)

def CreateIndexInEvaDBStg(clientid, cmsclientid):
    MYSQL_INDEX = f"""
    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_xeroblue_journals' 
            AND COLUMN_NAME = 'IsVisible'
        ),
        'ALTER TABLE evadb_stage.c0000_xeroblue_journals ADD COLUMN `IsVisible` BOOLEAN DEFAULT TRUE AFTER `DueDate`',
        'SELECT "Column IsVisible already exists in c0000_xeroblue_journals"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_xeroblue_journalscash' 
            AND COLUMN_NAME = 'IsVisible'
        ),
        'ALTER TABLE evadb_stage.c0000_xeroblue_journalscash ADD COLUMN `IsVisible` BOOLEAN DEFAULT TRUE AFTER `DueDate`',
        'SELECT "Column IsVisible already exists in c0000_xeroblue_journalscash"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    -- Add isvisible index to Journal and JournalCash tables
    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_xeroblue_journals' 
            AND INDEX_NAME = 'c0000_xeroblue_Journals_isvisible_idx'
        ),
        'ALTER TABLE evadb_stage.c0000_xeroblue_journals ADD INDEX c0000_xeroblue_Journals_isvisible_idx (`isvisible`)',
        'SELECT "Index c0000_xeroblue_Journals_isvisible_idx already exists"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_xeroblue_journalscash' 
            AND INDEX_NAME = 'c0000_xeroblue_journalscash_isvisible_idx'
        ),
        'ALTER TABLE evadb_stage.c0000_xeroblue_journalscash ADD INDEX c0000_xeroblue_journalscash_isvisible_idx (`isvisible`)',
        'SELECT "Index c0000_xeroblue_journalscash_isvisible_idx already exists"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    """
    MYSQL_INDEX = MYSQL_INDEX.replace('bigoleshoecompany_client0000',clientid).replace('c0000',cmsclientid)
    ExecuteMySQLScript(MYSQL_INDEX,evastage_engine)

def AddColumnToStageTablesInEvaDBStg(clientid, organisationid):
    MYSQL_SCRIPT = f"""
    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_1111_xeroblue_journalsstage' 
            AND COLUMN_NAME = 'IsVisible'
        ),
        'ALTER TABLE evadb_stage.c0000_1111_xeroblue_journalsstage ADD COLUMN `IsVisible` BOOLEAN DEFAULT TRUE AFTER `DueDate`',
        'SELECT "Column IsVisible already exists in c0000_1111_xeroblue_journalsstage"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = (SELECT IF(
        NOT EXISTS(
            SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = 'evadb_stage' 
            AND TABLE_NAME = 'c0000_1111_xeroblue_journalscashstage' 
            AND COLUMN_NAME = 'IsVisible'
        ),
        'ALTER TABLE evadb_stage.c0000_1111_xeroblue_journalscashstage ADD COLUMN `IsVisible` BOOLEAN DEFAULT TRUE AFTER `DueDate`',
        'SELECT "Column IsVisible already exists in c0000_1111_xeroblue_journalscashstage"'
    ));
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    """
    MYSQL_SCRIPT = MYSQL_SCRIPT.replace('c0000',clientid).replace('1111',organisationid)
    ExecuteMySQLScript(MYSQL_SCRIPT,evastage_engine)


# INPUT FIRM CODE
FirmCodes = {
    'AHP'
}
FirmCodes = sorted(FirmCodes)
for FirmCode in FirmCodes:
    df_orgdtls = ExtractOrgDetailsFromCMS(FirmCode.replace('-',''))

    #compare DW Token list and Extracted Tokens
    df_listfromtoken = GetDWTokenFileList(FirmCode)
    if len(df_listfromtoken) > 0:
        df_orgdtls = pd.merge(df_orgdtls, df_listfromtoken, on=['ClientID','OrganisationID'])

    df_clientidset = df_orgdtls.drop(columns=['OrganisationID', 'CMSOrganisationID', 'tenant_name', 'tenant_id'])
    df_clientidset = df_clientidset.drop_duplicates(subset=['ClientID','CMSClientID'])
    df_clientidset = df_clientidset.sort_values(by=['ClientID','CMSClientID'])
    for index, row in df_clientidset.iterrows():
        CMSClientID = row['CMSClientID']
        CMSClientID = f'c{CMSClientID}'
        ClientID = row['ClientID']
        print(ClientID, CMSClientID)
        # CreateProdTablesInEvaDBStg(CMSClientID)
        CreateIndexInEvaDBStg(ClientID, CMSClientID)
        CreateViewsInEvaDB(ClientID, CMSClientID)
        # CreateProdSPInEvaDBStg(CMSClientID)
        
    for index, row in df_orgdtls.iterrows():
        CMSClientID = row['CMSClientID']
        CMSClientID = f'c{CMSClientID}'
        ClientID = row['ClientID']
        CMSOrganisationID = row['CMSOrganisationID']
        OrganisationID = row['OrganisationID']
        print(CMSClientID, CMSOrganisationID)
        # CreateStageTablesInEvaDBStg(CMSClientID, CMSOrganisationID)
        AddColumnToStageTablesInEvaDBStg(CMSClientID, CMSOrganisationID)
        # CreateStageSPInEvaDBStg(CMSClientID, CMSOrganisationID, ClientID, OrganisationID)

    print(df_orgdtls)


"""
1.get dw org details
2.extract correct ClientIDs and OrganisationIDs
3.create each objects in order (1)prod tables (2)stored procedures (3)views (4)stage tables
"""