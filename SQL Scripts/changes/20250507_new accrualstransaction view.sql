/*
Add columns in Journals/JournalsCash stage and prod tables:
    OrganisationName
    InvoiceTotal

Update SP for journals/JournalsCash stage and prod tables to add columns and update values:
    OrganisationsClient(OrganisationName) -> OrganisationName
    Invoices/Transactions(Total) -> InvoiceTotal
*/

-- Adding new columns to stage and prod tables for Journals and JournalsCash
ALTER TABLE `evadb_stage`.`c1518_xeroblue_journals`
ADD COLUMN `OrganisationName` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_xeroblue_journals`
ADD COLUMN `InvoiceTotal` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_xeroblue_journalscash`
ADD COLUMN `OrganisationName` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_xeroblue_journalscash`
ADD COLUMN `InvoiceTotal` VARCHAR(255) NULL DEFAULT NULL;


ALTER TABLE `evadb_stage`.`c1518_5393_xeroblue_journalsstage`
ADD COLUMN `OrganisationName` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_5393_xeroblue_journalsstage`
ADD COLUMN `InvoiceTotal` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_5393_xeroblue_journalscashstage`
ADD COLUMN `OrganisationName` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `evadb_stage`.`c1518_5393_xeroblue_journalscashstage`
ADD COLUMN `InvoiceTotal` VARCHAR(255) NULL DEFAULT NULL;


-- Update value of new columns for Journals and JournalsCash
UPDATE `evadb_stage`.`c1518_xeroblue_journals` `j`
JOIN `evadb_stage`.`c1518_xeroblue_organisationsclients` AS `org`  
ON `org`.`OrganisationID` = `j`.`OrganisationID`
SET `j`.`OrganisationName` = `org`.`Name`
WHERE `j`.`OrganisationName` IS NULL;

UPDATE `evadb_stage`.`c1518_xeroblue_journals` `j`
JOIN `evadb_stage`.`c1518_xeroblue_Transactions` AS `t`  
    ON j.`SourceId` = t.`Id`
    AND j.`OrganisationID` = t.`OrganisationID`
SET `j`.`InvoiceTotal` = `t`.`Total`
WHERE `j`.`InvoiceTotal` IS NULL
AND `j`.`ContactSource` = 'INVOICES';

UPDATE `evadb_stage`.`c1518_xeroblue_journalsCash` `j`
JOIN `evadb_stage`.`c1518_xeroblue_organisationsclients` AS `org`  
ON `org`.`OrganisationID` = `j`.`OrganisationID`
SET `j`.`OrganisationName` = `org`.`Name`
WHERE `j`.`OrganisationName` IS NULL;

UPDATE `evadb_stage`.`c1518_xeroblue_journalsCash` `j`
JOIN `evadb_stage`.`c1518_xeroblue_Transactions` AS `t`  
    ON j.`SourceId` = t.`Id`
    AND j.`OrganisationID` = t.`OrganisationID`
SET `j`.`InvoiceTotal` = `t`.`Total`
WHERE `j`.`InvoiceTotal` IS NULL
AND `j`.`ContactSource` = 'INVOICES';


-- Updated SQL views
CREATE OR REPLACE VIEW evadb.bigoleshoecompany_client1518_xeroblue_accrualtransactions_aud AS
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
    `tb`.`JournalLine_GrossAmount_AUD` AS `GrossAmountFX`,
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
    'Hardcoded System Account' AS `SystemAccount`,
    COALESCE(`tb`.`InvoiceNumber`, `tb`.`CreditNoteNumber`) AS `SourceNumber`,
    `tb`.`ACC_ACCPAY` AS `ACCorACCPAY`,
    `tb`.`AgedMovement` AS `AgedMovement`,
    `tb`.`DebitGross` AS `DebitGross`,
    `tb`.`DebitNetAmount` AS `DebitNetAmount`,
    `tb`.`CreditGross` AS `CreditGross`,
    `tb`.`CreditNetAmount` AS `CreditNetAmount`,
    `tb`.`CashSummary` AS `CashSummary`,
    'X' AS `Source`,
    'X' AS `Sync`,
    `tb`.`PlannedPaymentDate` AS `PlannedPaymentDate`,
    `tb`.`ItemCode` AS `ItemCode`,
    `tb`.`Quantity` AS `Quantity`,
    `tb`.`DiscountRate` AS `DiscountRate`,
    `tb`.`UnitAmount` AS `UnitAmount`,
    `tb`.`URL` AS `URL`,
    `tb`.`DueDate` AS `DueDate`,
    `tb`.`InvoiceTotal` AS `InvoiceTotal`
FROM `evadb_stage`.`c1518_xeroblue_journals` `tb`;

CREATE OR REPLACE VIEW evadb.bigoleshoecompany_client1518_xeroblue_cashtransactions_aud AS
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
    `tb`.`JournalLine_GrossAmount_AUD` AS `GrossAmountFX`,
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
    'Hardcoded System Account' AS `SystemAccount`,
    COALESCE(`tb`.`InvoiceNumber`, `tb`.`CreditNoteNumber`) AS `SourceNumber`,
    `tb`.`ACC_ACCPAY` AS `ACCorACCPAY`,
    `tb`.`AgedMovement` AS `AgedMovement`,
    `tb`.`DebitGross` AS `DebitGross`,
    `tb`.`DebitNetAmount` AS `DebitNetAmount`,
    `tb`.`CreditGross` AS `CreditGross`,
    `tb`.`CreditNetAmount` AS `CreditNetAmount`,
    `tb`.`CashSummary` AS `CashSummary`,
    'X' AS `Source`,
    'X' AS `Sync`,
    `tb`.`PlannedPaymentDate` AS `PlannedPaymentDate`,
    `tb`.`ItemCode` AS `ItemCode`,
    `tb`.`Quantity` AS `Quantity`,
    `tb`.`DiscountRate` AS `DiscountRate`,
    `tb`.`UnitAmount` AS `UnitAmount`,
    `tb`.`URL` AS `URL`,
    `tb`.`DueDate` AS `DueDate`,
    `tb`.`InvoiceTotal` AS `InvoiceTotal`
FROM `evadb_stage`.`c1518_xeroblue_journalscash` `tb`;





-- Updated stored procedure for Journals and JournalsCash
CREATE DEFINER=`etaniadmin`@`%` PROCEDURE `sp_dynamic_xeroblue_journals`(IN p_clientID VARCHAR(100), IN p_orgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION group_concat_max_len = 4294967295;

    -- Replace hardcoded table references with dynamic ones
    SET @journalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_journalsstage');
    SET @finalTable = CONCAT('c',v_clientID,'_xeroblue_journals');
    SET @transTable = CONCAT('c',v_clientID,'_xeroblue_transactions');
    SET @acctsTable = CONCAT('c',v_clientID,'_xeroblue_accounts');

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    SET @sql = '';
    WITH missing_columns AS (
        SELECT 'Index' AS column_name, 'INT NULL AFTER `Id`' AS column_definition UNION ALL
        SELECT 'ACC_ACCPAY', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'Accounts_Class', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PnL_BS', 'VARCHAR(10) NULL' UNION ALL
        SELECT 'AgedMovement', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'CashReceived', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSpent', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSummary', 'VARCHAR(100) NULL' UNION ALL
        SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'SystemAccount', 'VARCHAR(255) NULL' 
    )   
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set1
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @finalTable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns2 AS(
        SELECT 'ContactID'  as column_Name, 'VARCHAR(255) NULL' as column_definition UNION ALL
        SELECT 'ContactName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ContactSource', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentSourceID', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentType', 'VARCHAR(255) NULL'  UNION ALL
        SELECT 'ShowOnCashBasisReports', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'FullyPaidOnDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DayDifference', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PlannedPaymentDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ItemCode', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'Quantity', 'FLOAT NULL' UNION ALL
        SELECT 'DiscountRate', 'FLOAT NULL' UNION ALL
        SELECT 'CreditNoteNumber', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'UnitAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'URL', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'InvoiceNumber', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DueDate', 'DATE NULL' UNION ALL
        SELECT 'OrganisationName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'InvoiceTotal', 'VARCHAR(255) NULL'
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10)))
    INTO @columns_to_add_set2
    FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @finalTable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns AS (
        SELECT 'Index' AS column_name, 'INT NULL AFTER `Id`' AS column_definition UNION ALL
        SELECT 'ACC_ACCPAY', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'Accounts_Class', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PnL_BS', 'VARCHAR(10) NULL' UNION ALL
        SELECT 'AgedMovement', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'CashReceived', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSpent', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSummary', 'VARCHAR(100) NULL' UNION ALL
        SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'SystemAccount', 'VARCHAR(255) NULL' 
    )   
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set3
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @journalsStage
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns2 AS (
        SELECT 'ContactID'  as column_Name, 'VARCHAR(255) NULL' as column_definition UNION ALL
        SELECT 'ContactName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ContactSource', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentSourceID', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentType', 'VARCHAR(255) NULL'  UNION ALL
        SELECT 'ShowOnCashBasisReports', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'FullyPaidOnDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DayDifference', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PlannedPaymentDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ItemCode', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'Quantity', 'FLOAT NULL' UNION ALL
        SELECT 'DiscountRate', 'FLOAT NULL' UNION ALL
        SELECT 'CreditNoteNumber', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'UnitAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'URL', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'InvoiceNumber', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DueDate', 'DATE NULL' UNION ALL
        SELECT 'OrganisationName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'InvoiceTotal', 'VARCHAR(255) NULL'
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10)))
    INTO @columns_to_add_set4
    FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @journalsStage
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    IF @columns_to_add_set1 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @finalTable, ' ', @columns_to_add_set1);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    IF @columns_to_add_set2 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @finalTable, ' ', @columns_to_add_set2);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    IF @columns_to_add_set3 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @journalsStage, ' ', @columns_to_add_set3);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    IF @columns_to_add_set4 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @journalsStage, ' ', @columns_to_add_set4);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    
    SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());
    
    -- FXTable creation and population
    SET @create_fxtable = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS ',@fx_table,' (
                `BaseCurrency` VARCHAR(10),
                `Date` DATE,
                `AUD` DECIMAL(10, 4),
                `USD` DECIMAL(10, 4),
                `NZD` DECIMAL(10, 4),
                `EUR` DECIMAL(10, 4),
                `GBP` DECIMAL(10, 4)
                ,INDEX(BaseCurrency, DATE)
            );'
        );
    PREPARE stmt FROM @create_fxtable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    
	SET @insert_fxtable = CONCAT('
    INSERT INTO ',@fx_table,' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM FOREIGNEXCHANGE_MASTER
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
    PREPARE stmt0 FROM @insert_fxtable;
    EXECUTE stmt0;
    DEALLOCATE PREPARE stmt0;
        
    SET @updatejournalsStage3 = CONCAT(
        'UPDATE ', @journalsStage, ' AS jrnl
        LEFT JOIN c',v_clientID,'_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
        LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
            AND fx.`Date` = 
                CASE 
                    WHEN jrnl.`JournalDate` <= ''',v_minDate,''' THEN ''',v_minDate, '''
                    WHEN jrnl.`JournalDate` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
                    ELSE jrnl.`JournalDate` 
                END
        SET  
            `JournalLine_NetAmount_AUD` = `jrnl`.`JournalLine_NetAmount` * `AUD`
            ,`JournalLine_NetAmount_USD` = `jrnl`.`JournalLine_NetAmount` * `USD`
            ,`JournalLine_NetAmount_NZD` = `jrnl`.`JournalLine_NetAmount` * `NZD`
            ,`JournalLine_NetAmount_EUR` = `jrnl`.`JournalLine_NetAmount` * `EUR`
            ,`JournalLine_NetAmount_GBP` = `jrnl`.`JournalLine_NetAmount` * `GBP`
            ,`JournalLine_GrossAmount_AUD` = `jrnl`.`JournalLine_GrossAmount` * `AUD`
            ,`JournalLine_GrossAmount_USD` = `jrnl`.`JournalLine_GrossAmount` * `USD`
            ,`JournalLine_GrossAmount_NZD` = `jrnl`.`JournalLine_GrossAmount` * `NZD`
            ,`JournalLine_GrossAmount_EUR` = `jrnl`.`JournalLine_GrossAmount` * `EUR`
            ,`JournalLine_GrossAmount_GBP` = `jrnl`.`JournalLine_GrossAmount` * `GBP`
            ,`JournalLine_TaxAmount_AUD` = `jrnl`.`JournalLine_TaxAmount` * `AUD`
            ,`JournalLine_TaxAmount_USD` = `jrnl`.`JournalLine_TaxAmount` * `USD`
            ,`JournalLine_TaxAmount_NZD` = `jrnl`.`JournalLine_TaxAmount` * `NZD`
            ,`JournalLine_TaxAmount_EUR` = `jrnl`.`JournalLine_TaxAmount` * `EUR`
            ,`JournalLine_TaxAmount_GBP` = `jrnl`.`JournalLine_TaxAmount` * `GBP`
            ,`Split` =CASE 
                WHEN `SourceType` = ''ACCPAY'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCPAYCREDIT''THEN ''INVOICES''
                WHEN `SourceType` = ''ACCPAYPAYMENT'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCREC'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCRECCREDIT'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCRECPAYMENT'' THEN ''INVOICES''
                WHEN `SourceType` = ''APCREDITPAYMENT'' THEN ''INVOICES'' 
                WHEN `SourceType` = ''ARCREDITPAYMENT'' THEN ''INVOICES''
                ELSE ''JOURNALS'' END
            ,`OrganisationName` = `org`.`Name`;
		');
        
		PREPARE stmt1 FROM @updatejournalsStage3;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

    SET @update_from_trans_sql = 
    CONCAT('UPDATE ',@journalsStage,' J
        LEFT JOIN ',@transTable,' T
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
            AND j.`JournalLine_AccountCode` = t.`AccountCode`
            AND ABS(j.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
        LEFT JOIN ',@acctsTable,' acc
            ON J.`JournalLine_AccountId` = acc.`AccountId`
            AND J.`OrganisationId` = acc.`OrganisationId`                          
        SET  J.`ContactId` = t.`ContactID`, 
            J.`ContactName` = t.`ContactName`, 
            J.`ContactSource` = t.`Source`,
            J.`PaymentSourceID` = CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentSourceID` ELSE NULL END,
            J.`PaymentType` =  CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentType` ELSE NULL END,
            J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
            J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
            J.`DayDifference` = t.`DayDifference`, 
            J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
            J.`ItemCode` = t.`ItemCode`, 
            J.`Quantity` = t.`Quantity`,
            J.`DiscountRate` = t.`DiscountRate`, 
            J.`CreditNoteNumber` = t.`CreditNoteNumber`,
            J.`UnitAmount` = t.`UnitAmount`, 
            J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
            J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
            J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
            J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
            J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
            J.`AmountDue` = t.`AmountDue`, 
            J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
            J.`AmountDue_USD` = t.`AmountDue_USD`, 
            J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
            J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
            J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
            J.`URL` = t.`URL`, 
            J.`InvoiceNumber` = t.`InvoiceNumber`,
            J.`DueDate` = t.`DueDate`, 
            J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END,
            -- Calculated Columns
            J.`ACC_ACCPAY` =
                CASE
                    WHEN LOCATE(''ACCREC'', J.`SourceType`) > 0 THEN ''ACCREC''
                    WHEN LOCATE(''ACCPAY'', J.`SourceType`) > 0 THEN ''ACCPAY''
                    WHEN LEFT(J.`SourceType`, 2) = ''AR'' THEN ''ACCREC''
                    WHEN LEFT(J.`SourceType`, 2) = ''AP'' THEN ''ACCPAY''
                    ELSE ''OTHER UNRELATED TO AR/AP''
                END,
            J.`Accounts_Class` = acc.`Class`,
            J.`PnL_BS` =
                CASE
                    WHEN acc.`Class` IN (''Revenue'', ''Expense'') THEN ''PnL''
                    WHEN acc.`Class` IN (''Asset'', ''Liability'', ''Equity'') THEN ''BS''
                    ELSE NULL
                END,
            J. `AgedMovement` =
                CASE
                    WHEN J.`SourceType` = ''ACCREC'' THEN ''Accruals''
                    WHEN J.`SourceType` = ''ACCPAY''THEN ''Accruals''
                    WHEN J.`SourceType` = ''ACCRECCREDIT'' THEN ''Accruals''
                    WHEN J.`SourceType` = ''ACCPAYCREDIT'' THEN ''Payments''
                    WHEN J.`SourceType` = ''APOVERPAYMENT''  THEN ''CashOPPP''
                    ELSE NULL
                END,
            J.`CashReceived`=
                CASE WHEN acc.`Type` = ''BANK'' AND J.`JournalLine_GrossAmount_AUD` >= 0 THEN J.`JournalLine_GrossAmount_AUD` ELSE NULL END,
            J.`CashSpent` =
                CASE WHEN acc.`Type` = ''BANK'' AND J.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - J.`JournalLine_GrossAmount_AUD`) ELSE NULL END,
            J.`DebitGross` =
                CASE WHEN J.`JournalLine_GrossAmount` >= 0 THEN J.`JournalLine_GrossAmount` ELSE NULL END,
            J.`DebitNetAmount` = CASE WHEN J.`JournalLine_NetAmount`   >= 0 THEN J.`JournalLine_NetAmount`   ELSE NULL END,
            J.`CreditGross` = CASE WHEN J.`JournalLine_GrossAmount` < 0 THEN (0 - J.`JournalLine_GrossAmount`) ELSE NULL END,
            J.`CreditNetAmount` = CASE WHEN J.`JournalLine_NetAmount`   < 0 THEN (0 - J.`JournalLine_NetAmount`)   ELSE NULL END,
            J.`DebitGrossFX` =  CASE WHEN J.`JournalLine_GrossAmount_AUD` >= 0 THEN J.`JournalLine_GrossAmount_AUD` ELSE NULL END,
            J.`DebitNetAmountFX` = CASE WHEN J.`JournalLine_NetAmount_AUD`   >= 0 THEN J.`JournalLine_NetAmount_AUD`   ELSE NULL END,
            J.`CreditGrossFX` =  CASE WHEN J.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - J.`JournalLine_GrossAmount_AUD`) ELSE NULL END,
            J.`CreditNetAmountFX` =  CASE WHEN J.`JournalLine_NetAmount_AUD`   < 0 THEN (0 - J.`JournalLine_NetAmount_AUD`)   ELSE NULL END,
            J.`CashSummary` = 
                CASE
                    WHEN J.`JournalLine_AccountName` = ''GST'' THEN ''PLUS GST Movements''
                    WHEN acc.`Type` = ''BANK'' THEN ''Cash Surplus (Deficit)''
                    WHEN acc.`Class` IN (''Asset'', ''Revenue'') THEN ''Income''
                    WHEN acc.`Class` IN (''Liability'', ''Expense'', ''Equity'') THEN ''Less Expenses''
                    ELSE acc.`Name`
                END,
            J.`DetailedBreakdownAccountNames` =
                CASE
                    WHEN J.`JournalLine_AccountName` = ''GST'' AND J.`JournalLine_NetAmount_AUD` < 0 THEN ''GST Collected''
                    WHEN J.`JournalLine_AccountName` = ''GST'' AND J.`JournalLine_NetAmount_AUD` >= 0 THEN ''GST Paid''
                    ELSE J.`JournalLine_AccountName`
                END,
            J.`SystemAccount` = acc.`SystemAccount`,
            J.`InvoiceTotal` = CASE WHEN t.Source = ''INVOICES'' THEN t.`Total` ELSE NULL END'
    );

    PREPARE updtrn_stmt FROM @update_from_trans_sql;
    EXECUTE updtrn_stmt;
    DEALLOCATE PREPARE updtrn_stmt;

        -- init batching vars
        SET @ffset = 0;
        SET @rowcount = 1;
        SET @batchsize = 500;

    

    WHILE @rowcount > 0 DO
    SET @delete_trg = CONCAT(
        'DELETE TRG FROM ',@finalTable,' TRG
        INNER JOIN (
        SELECT JournalId FROM ', @journalsStage, ' 
        WHERE OrganisationId = ', v_OrganisationID, '
        GROUP BY JournalId
        ORDER BY JournalId  -- Ensures deterministic deletion
        LIMIT ', @batchsize, ' OFFSET ',@ffset, ' 
        ) STG ON TRG.JournalId = STG.JournalId;'
    );  
    PREPARE del_stmt FROM @delete_trg;
    EXECUTE del_stmt;
    SELECT ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE del_stmt;            
    SET @ffset = @ffset + @batchsize;
    END WHILE;

    
    SET @insert_xeroblue_journals = CONCAT(
        'INSERT INTO ',@finalTable,'
        SELECT * FROM ', @journalsStage,';'
        );

    PREPARE ins_stmt FROM @insert_xeroblue_journals;
    EXECUTE ins_stmt;    
    DEALLOCATE PREPARE ins_stmt;

    SET @dup_rowcount = 1;

    WHILE @dup_rowcount > 0 DO
    SET @dup_sql = CONCAT(' 
    WITH duplicates AS (
    SELECT JournalLine_JournalLineId
    FROM (
        SELECT JournalLine_JournalLineId, 
            ROW_NUMBER() OVER (PARTITION BY JournalId, JournalLine_JournalLineId ORDER BY JournalLine_JournalLineId) AS row_num
        FROM c',v_clientID,'_xeroblue_journals
        WHERE OrganisationId = ', v_OrganisationID, '
    ) subquery
    WHERE row_num > 1
    )
    DELETE FROM c',v_clientID,'_xeroblue_journals 
    WHERE JournalLine_JournalLineId IN (SELECT JournalLine_JournalLineId FROM duplicates)
    AND OrganisationId = ', v_OrganisationID, '
    LIMIT 1;
    ');
    PREPARE dup_stmt FROM @dup_sql;
    EXECUTE dup_stmt;
    SELECT ROW_COUNT() INTO @dup_rowcount;
    DEALLOCATE PREPARE dup_stmt; 
    END WHILE;

    SET @update_xeroblue_journals1 = CONCAT(
        'UPDATE ',@finalTable,' `j`
        JOIN c',v_clientID,'_xeroblue_organisationsclients AS `org`  
        ON `org`.`OrganisationID` = `j`.`OrganisationID`
        SET `j`.`OrganisationName` = `org`.`Name`
        WHERE `j`.`OrganisationName` IS NULL;'
    );
    PREPARE update_stmt1 FROM @update_xeroblue_journals;
    EXECUTE update_stmt1;
    DEALLOCATE PREPARE update_stmt1; 

    SET @update_xeroblue_journals2 = CONCAT(
        'UPDATE ',@finalTable,' `j`
        JOIN ',@transTable,' AS `t`  
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
        SET `j`.`InvoiceTotal` = `t`.`Total`
        WHERE `j`.`InvoiceTotal` IS NULL
        AND `j`.`ContactSource` = ''INVOICES'';'
    );
    PREPARE update_stmt2 FROM @update_xeroblue_journals;
    EXECUTE update_stmt2;
    DEALLOCATE PREPARE update_stmt2; 
END


CREATE DEFINER=`etaniadmin`@`%` PROCEDURE `sp_dynamic_xeroblue_journalscash`(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION group_concat_max_len = 4294967295;
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
    -- Replace hardcoded table references with dynamic ones
    SET @journalscashStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_journalscashstage');
    SET @finalTable = CONCAT('c',v_clientID,'_xeroblue_journalscash');
    SET @transTable = CONCAT('c',v_clientID,'_xeroblue_transactions');
    SET @acctsTable = CONCAT('c',v_clientID,'_xeroblue_accounts');


    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    SET @sql = '';
    WITH missing_columns AS (
        SELECT 'Index' AS column_name, 'INT NULL AFTER `Id`' AS column_definition UNION ALL
        SELECT 'ACC_ACCPAY', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'Accounts_Class', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PnL_BS', 'VARCHAR(10) NULL' UNION ALL
        SELECT 'AgedMovement', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'CashReceived', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSpent', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSummary', 'VARCHAR(100) NULL' UNION ALL
        SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'SystemAccount', 'VARCHAR(255) NULL' 
    )   
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set1
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @finalTable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns2 AS(
        SELECT 'ContactID'  as column_Name, 'VARCHAR(255) NULL' as column_definition UNION ALL
        SELECT 'ContactName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ContactSource', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentSourceID', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentType', 'VARCHAR(255) NULL'  UNION ALL
        SELECT 'ShowOnCashBasisReports', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'FullyPaidOnDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DayDifference', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PlannedPaymentDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ItemCode', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'Quantity', 'FLOAT NULL' UNION ALL
        SELECT 'DiscountRate', 'FLOAT NULL' UNION ALL
        SELECT 'UnitAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'URL', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DueDate', 'DATE NULL' UNION ALL
        SELECT 'OrganisationName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'InvoiceTotal', 'VARCHAR(255) NULL'
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10)))
    INTO @columns_to_add_set2
    FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @finalTable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns AS (
        SELECT 'Index' AS column_name, 'INT NULL AFTER `Id`' AS column_definition UNION ALL
        SELECT 'ACC_ACCPAY', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'Accounts_Class', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PnL_BS', 'VARCHAR(10) NULL' UNION ALL
        SELECT 'AgedMovement', 'VARCHAR(50) NULL' UNION ALL
        SELECT 'CashReceived', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSpent', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGross', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'DebitNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CreditNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'CashSummary', 'VARCHAR(100) NULL' UNION ALL
        SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'SystemAccount', 'VARCHAR(255) NULL' 
    )   
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set3
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @journalscashStage
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns2 AS(
        SELECT 'ContactID'  as column_Name, 'VARCHAR(255) NULL' as column_definition UNION ALL
        SELECT 'ContactName', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ContactSource', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentSourceID', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PaymentType', 'VARCHAR(255) NULL'  UNION ALL
        SELECT 'ShowOnCashBasisReports', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'FullyPaidOnDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DayDifference', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'PlannedPaymentDate', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'ItemCode', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'Quantity', 'FLOAT NULL' UNION ALL
        SELECT 'DiscountRate', 'FLOAT NULL' UNION ALL
        SELECT 'UnitAmount', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'UnitAmount_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_AUD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_USD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_NZD', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_EUR', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'AmountDue_GBP', 'DECIMAL(30,6) NULL' UNION ALL
        SELECT 'URL', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'DueDate', 'DATE NULL' UNION ALL
        SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
        SELECT 'SystemAccount', 'VARCHAR(255) NULL' 
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10)))
    INTO @columns_to_add_set4
    FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @journalscashStage
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    IF @columns_to_add_set1 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @finalTable, ' ', @columns_to_add_set1);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    IF @columns_to_add_set2 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @finalTable, ' ', @columns_to_add_set2);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    IF @columns_to_add_set3 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @journalscashStage, ' ', @columns_to_add_set3);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    IF @columns_to_add_set4 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @journalscashStage, ' ', @columns_to_add_set4);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());
    
    -- FXTable creation and population
    SET @create_fxtable = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS ',@fx_table,' (
                `BaseCurrency` VARCHAR(10),
                `Date` DATE,
                `AUD` DECIMAL(10, 4),
                `USD` DECIMAL(10, 4),
                `NZD` DECIMAL(10, 4),
                `EUR` DECIMAL(10, 4),
                `GBP` DECIMAL(10, 4)
                ,INDEX(BaseCurrency, DATE)
            );'
        );
    PREPARE stmt FROM @create_fxtable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    
    SET @insert_fxtable = CONCAT('
    INSERT INTO ',@fx_table,' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM FOREIGNEXCHANGE_MASTER
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
    PREPARE stmt0 FROM @insert_fxtable;
    EXECUTE stmt0;
    DEALLOCATE PREPARE stmt0;
        
    SET @updatejournalscashStage = CONCAT(
        'UPDATE ', @journalscashStage, ' AS jrnl
        LEFT JOIN c',v_clientID,'_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
        LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
            AND fx.`Date` = 
                CASE 
                    WHEN jrnl.`JournalDate` <= ''',v_minDate,''' THEN ''',v_minDate, '''
                    WHEN jrnl.`JournalDate` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
                    ELSE jrnl.`JournalDate` 
                END
            SET  
            `JournalLine_NetAmount_AUD` = `jrnl`.`JournalLine_NetAmount` * `AUD`
            ,`JournalLine_NetAmount_USD` = `jrnl`.`JournalLine_NetAmount` * `USD`
            ,`JournalLine_NetAmount_NZD` = `jrnl`.`JournalLine_NetAmount` * `NZD`
            ,`JournalLine_NetAmount_EUR` = `jrnl`.`JournalLine_NetAmount` * `EUR`
            ,`JournalLine_NetAmount_GBP` = `jrnl`.`JournalLine_NetAmount` * `GBP`
            ,`JournalLine_GrossAmount_AUD` = `jrnl`.`JournalLine_GrossAmount` * `AUD`
            ,`JournalLine_GrossAmount_USD` = `jrnl`.`JournalLine_GrossAmount` * `USD`
            ,`JournalLine_GrossAmount_NZD` = `jrnl`.`JournalLine_GrossAmount` * `NZD`
            ,`JournalLine_GrossAmount_EUR` = `jrnl`.`JournalLine_GrossAmount` * `EUR`
            ,`JournalLine_GrossAmount_GBP` = `jrnl`.`JournalLine_GrossAmount` * `GBP`
            ,`JournalLine_TaxAmount_AUD` = `jrnl`.`JournalLine_TaxAmount` * `AUD`
            ,`JournalLine_TaxAmount_USD` = `jrnl`.`JournalLine_TaxAmount` * `USD`
            ,`JournalLine_TaxAmount_NZD` = `jrnl`.`JournalLine_TaxAmount` * `NZD`
            ,`JournalLine_TaxAmount_EUR` = `jrnl`.`JournalLine_TaxAmount` * `EUR`
            ,`JournalLine_TaxAmount_GBP` = `jrnl`.`JournalLine_TaxAmount` * `GBP`
            ,`Split` =CASE 
                WHEN `SourceType` = ''ACCPAY'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCPAYCREDIT''THEN ''INVOICES''
                WHEN `SourceType` = ''ACCPAYPAYMENT'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCREC'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCRECCREDIT'' THEN ''INVOICES''
                WHEN `SourceType` = ''ACCRECPAYMENT'' THEN ''INVOICES''
                WHEN `SourceType` = ''APCREDITPAYMENT'' THEN ''INVOICES'' 
                WHEN `SourceType` = ''ARCREDITPAYMENT'' THEN ''INVOICES''
                ELSE ''JOURNALS'' END
            ,`OrganisationName` = `org`.`Name`;
		');
        
		PREPARE stmt1 FROM @updatejournalscashStage;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

  SET @update_from_trans_sql = 
    CONCAT('UPDATE ',@journalscashStage,' J
            LEFT JOIN ',@transTable,' T
                    ON j.`SourceId` = t.`Id`
                    AND j.`OrganisationID` = t.`OrganisationID`
                    AND j.`JournalLine_AccountCode` = t.`AccountCode`
                    AND ABS(j.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
            LEFT JOIN ',@acctsTable,' acc
            ON J.`JournalLine_AccountId` = acc.`AccountId`
            AND J.`OrganisationId` = acc.`OrganisationId`                          
        SET  J.`ContactId` = t.`ContactID`, 
            J.`ContactName` = t.`ContactName`, 
            J.`ContactSource` = t.`Source`,
            J.`PaymentSourceID` = CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentSourceID` ELSE NULL END,
            J.`PaymentType` =  CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentType` ELSE NULL END,
            J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
            J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
            J.`DayDifference` = t.`DayDifference`, 
            J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
            J.`ItemCode` = t.`ItemCode`, 
            J.`Quantity` = t.`Quantity`,
            J.`DiscountRate` = t.`DiscountRate`, 
            J.`UnitAmount` = t.`UnitAmount`, 
            J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
            J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
            J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
            J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
            J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
            J.`AmountDue` = t.`AmountDue`, 
            J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
            J.`AmountDue_USD` = t.`AmountDue_USD`, 
            J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
            J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
            J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
            J.`URL` = t.`URL`, 
            J.`DueDate` = t.`DueDate`, 
            J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END,
            -- Calculated Columns
            J.`ACC_ACCPAY` =
                CASE
                    WHEN LOCATE(''ACCREC'', J.`SourceType`) > 0 THEN ''ACCREC''
                    WHEN LOCATE(''ACCPAY'', J.`SourceType`) > 0 THEN ''ACCPAY''
                    WHEN LEFT(J.`SourceType`, 2) = ''AR'' THEN ''ACCREC''
                    WHEN LEFT(J.`SourceType`, 2) = ''AP'' THEN ''ACCPAY''
                    ELSE ''OTHER UNRELATED TO AR/AP''
                END,
            J.`Accounts_Class` = acc.`Class`,
            J.`PnL_BS` =
                CASE
                    WHEN acc.`Class` IN (''Revenue'', ''Expense'') THEN ''PnL''
                    WHEN acc.`Class` IN (''Asset'', ''Liability'', ''Equity'') THEN ''BS''
                    ELSE NULL
                END,
            J. `AgedMovement` =
                CASE
                    WHEN J.`SourceType` IN (''ACCREC'', ''ACCPAY'')  THEN ''Cash''
                    ELSE NULL
                END,
            J.`CashReceived`=
                CASE WHEN acc.`Type` = ''BANK'' AND J.`JournalLine_GrossAmount_AUD` >= 0 THEN J.`JournalLine_GrossAmount_AUD` ELSE NULL END,
            J.`CashSpent` =
                CASE WHEN acc.`Type` = ''BANK'' AND J.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - J.`JournalLine_GrossAmount_AUD`) ELSE NULL END,
            J.`DebitGross` =
                CASE WHEN J.`JournalLine_GrossAmount` >= 0 THEN J.`JournalLine_GrossAmount` ELSE NULL END,
            J.`DebitNetAmount` = CASE WHEN J.`JournalLine_NetAmount`   >= 0 THEN J.`JournalLine_NetAmount`   ELSE NULL END,
            J.`CreditGross` = CASE WHEN J.`JournalLine_GrossAmount` < 0 THEN (0 - J.`JournalLine_GrossAmount`) ELSE NULL END,
            J.`CreditNetAmount` = CASE WHEN J.`JournalLine_NetAmount`   < 0 THEN (0 - J.`JournalLine_NetAmount`)   ELSE NULL END,
            J.`DebitGrossFX` =  CASE WHEN J.`JournalLine_GrossAmount_AUD` >= 0 THEN J.`JournalLine_GrossAmount_AUD` ELSE NULL END,
            J.`DebitNetAmountFX` = CASE WHEN J.`JournalLine_NetAmount_AUD`   >= 0 THEN J.`JournalLine_NetAmount_AUD`   ELSE NULL END,
            J.`CreditGrossFX` =  CASE WHEN J.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - J.`JournalLine_GrossAmount_AUD`) ELSE NULL END,
            J.`CreditNetAmountFX` =  CASE WHEN J.`JournalLine_NetAmount_AUD`   < 0 THEN (0 - J.`JournalLine_NetAmount_AUD`)   ELSE NULL END,
            J.`CashSummary` = 
                CASE
                    WHEN J.`JournalLine_AccountName` = ''GST'' THEN ''PLUS GST Movements''
                    WHEN acc.`Type` = ''BANK'' THEN ''Cash Surplus (Deficit)''
                    WHEN acc.`Class` IN (''Asset'', ''Revenue'') THEN ''Income''
                    WHEN acc.`Class` IN (''Liability'', ''Expense'', ''Equity'') THEN ''Less Expenses''
                    ELSE acc.`Name`
                END,
            J.`DetailedBreakdownAccountNames` =
                CASE
                    WHEN J.`JournalLine_AccountName` = ''GST'' AND J.`JournalLine_NetAmount_AUD` < 0 THEN ''GST Collected''
                    WHEN J.`JournalLine_AccountName` = ''GST'' AND J.`JournalLine_NetAmount_AUD` >= 0 THEN ''GST Paid''
                    ELSE J.`JournalLine_AccountName`
                END,
            J.`SystemAccount` = acc.`SystemAccount`,
            J.`InvoiceTotal` = CASE WHEN t.Source = ''INVOICES'' THEN t.`Total` ELSE NULL END'
    );

    PREPARE updtrn_stmt FROM @update_from_trans_sql;
    EXECUTE updtrn_stmt;
    DEALLOCATE PREPARE updtrn_stmt;
		

        -- init batching vars
        SET @ffset = 0;
        SET @rowcount = 1;
        SET @batchsize = 500;


    WHILE @rowcount > 0 DO
        SET @delete_trg = CONCAT(
        'DELETE TRG FROM ',@finalTable,' TRG
        INNER JOIN (
            SELECT JournalId FROM ', @journalscashStage, ' 
            WHERE OrganisationId = ', v_OrganisationID, '
            GROUP BY JournalId
            ORDER BY JournalId  -- Ensures deterministic deletion
            LIMIT ', @batchsize, ' OFFSET ',@ffset, ' 
        ) STG ON TRG.JournalId = STG.JournalId;'
        );
        PREPARE del_stmt FROM @delete_trg;
        EXECUTE del_stmt;
        SELECT ROW_COUNT() INTO @rowcount;
        DEALLOCATE PREPARE del_stmt;            
        SET @ffset = @ffset + @batchsize;
    END WHILE;
        
    SET @insert_xeroblue_journalscash = CONCAT(
        'INSERT INTO ',@finalTable,'
        SELECT DISTINCT * FROM ', @journalscashStage,';'
        );

    PREPARE ins_stmt FROM @insert_xeroblue_journalscash;
    EXECUTE ins_stmt;    
    DEALLOCATE PREPARE ins_stmt;

    SET @dup_rowcount = 1;

WHILE @dup_rowcount > 0 DO
SET @dup_sql = CONCAT(' 
    WITH duplicates AS (
    SELECT JournalLine_JournalLineId
    FROM (
        SELECT JournalLine_JournalLineId, 
                ROW_NUMBER() OVER (PARTITION BY JournalId, JournalLine_JournalLineId ORDER BY JournalLine_JournalLineId) AS row_num
        FROM c',v_clientID,'_xeroblue_journalscash
        WHERE OrganisationId = ', v_OrganisationID, '
    ) subquery
    WHERE row_num > 1
    )
    DELETE FROM c',v_clientID,'_xeroblue_journalscash 
    WHERE JournalLine_JournalLineId IN (SELECT JournalLine_JournalLineId FROM duplicates)
    AND OrganisationId = ', v_OrganisationID, '
    LIMIT 1;
    ');
    PREPARE dup_stmt FROM @dup_sql;
    EXECUTE dup_stmt;
    SELECT ROW_COUNT() INTO @dup_rowcount;
    DEALLOCATE PREPARE dup_stmt; 
END WHILE;

    SET @update_xeroblue_journals = CONCAT(
        'UPDATE ',@finalTable,' `j`
        JOIN c',v_clientID,'_xeroblue_organisationsclients AS `org`  
        ON `org`.`OrganisationID` = `j`.`OrganisationID`
        SET `j`.`OrganisationName` = `org`.`Name`
        WHERE `j`.`OrganisationName` IS NULL;

        UPDATE ',@finalTable,' `j`
        JOIN ',@transTable,' AS `t`  
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
        SET `j`.`InvoiceTotal` = `t`.`Total`
        WHERE `j`.`InvoiceTotal` IS NULL
        AND `j`.`ContactSource` = ''INVOICES'';'
    PREPARE update_stmt FROM @update_xeroblue_journals;
    EXECUTE update_stmt;
    DEALLOCATE PREPARE update_stmt; 

END