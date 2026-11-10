--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Drop procedure `CreateEVAStageFullTextIndexIfNotExists`
--
DROP PROCEDURE IF EXISTS CreateEVAStageFullTextIndexIfNotExists;

--
-- Drop procedure `CreateEVAStageIndexIfNotExists`
--
DROP PROCEDURE IF EXISTS CreateEVAStageIndexIfNotExists;

--
-- Drop procedure `SP_AddIndexesForClients`
--
DROP PROCEDURE IF EXISTS SP_AddIndexesForClients;

--
-- Drop procedure `sp_add_container_logs`
--
DROP PROCEDURE IF EXISTS sp_add_container_logs;

--
-- Drop procedure `SP_CleanUpXeroBlueStageData`
--
DROP PROCEDURE IF EXISTS SP_CleanUpXeroBlueStageData;

--
-- Drop procedure `sp_dynamic_xeroblue_accounts`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_accounts;

--
-- Drop procedure `sp_dynamic_xeroblue_banktransactions`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_banktransactions;

--
-- Drop procedure `sp_dynamic_xeroblue_banktransfers`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_banktransfers;

--
-- Drop procedure `sp_dynamic_xeroblue_batchpayments`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_batchpayments;

--
-- Drop procedure `sp_dynamic_xeroblue_budgets`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_budgets;

--
-- Drop procedure `sp_dynamic_xeroblue_contacts`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_contacts;

--
-- Drop procedure `sp_dynamic_xeroblue_creditnotes`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_creditnotes;

--
-- Drop procedure `sp_dynamic_xeroblue_default`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_default;

--
-- Drop procedure `sp_dynamic_xeroblue_invoices`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_invoices;

--
-- Drop procedure `sp_dynamic_xeroblue_invoicesdraft`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_invoicesdraft;

--
-- Drop procedure `sp_dynamic_xeroblue_items`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_items;

--
-- Drop procedure `sp_dynamic_xeroblue_lastrefreshdate`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_lastrefreshdate;

--
-- Drop procedure `sp_dynamic_xeroblue_manualjournals`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_manualjournals;

--
-- Drop procedure `sp_dynamic_xeroblue_overpayments`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_overpayments;

--
-- Drop procedure `sp_dynamic_xeroblue_payments`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_payments;

--
-- Drop procedure `sp_dynamic_xeroblue_prepayments`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_prepayments;

--
-- Drop procedure `sp_dynamic_xeroblue_reprocess_sp`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_reprocess_sp;

--
-- Drop procedure `sp_dynamic_xeroblue_taxrates`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_taxrates;

--
-- Drop procedure `sp_dynamic_xeroblue_trackingcategoryconnections`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_trackingcategoryconnections;

--
-- Drop procedure `sp_dynamic_xeroblue_transactions`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_transactions;

--
-- Drop procedure `sp_dynamic_xeroblue_transactions_fixing`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_transactions_fixing;

--
-- Drop procedure `sp_dynamic_xeroblue_transactions_stageonly`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_transactions_stageonly;

--
-- Drop procedure `sp_dynamic_xpm_transactions`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xpm_transactions;

--
-- Drop procedure `sp_python_package_log`
--
DROP PROCEDURE IF EXISTS sp_python_package_log;

--
-- Drop procedure `sp_dynamic_xeroblue_journals`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_journals;

--
-- Drop procedure `sp_dynamic_xeroblue_journalscash`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_journalscash;

--
-- Drop procedure `sp_dynamic_xeroblue_reconciliation`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_reconciliation;

--
-- Drop procedure `sp_dynamic_xeroblue_transactionsblend_by_client`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_transactionsblend_by_client;

--
-- Drop procedure `sp_dynamic_xeroblue_transactionsblend`
--
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_transactionsblend;

DELIMITER $$

--
-- Create procedure `sp_dynamic_xeroblue_transactionsblend`
--
CREATE PROCEDURE sp_dynamic_xeroblue_transactionsblend (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int;
  DECLARE v_clientID int;
  DECLARE v_batch_start timestamp;
  DECLARE v_total_rows int;
  DECLARE v_rowcount int;
  DECLARE v_ffset int;
  DECLARE v_batchsize int;

  -- Initialize variables
  SET v_OrganisationID = COALESCE(p_legacyOrgID, p_orgID, 0);
  SET v_clientID = p_clientID;
  SET v_batch_start = NOW();
  SET v_total_rows = 0;
  SET v_rowcount = 1;
  SET v_ffset = 0;
  SET v_batchsize = 1000;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  -- Dynamic table names
  SET @transactionsblendStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_transactionsblendstage');
  SET @finalTable = CONCAT('c', v_clientID, '_xeroblue_transactionsblend');

  --     -- 1. Ensure staging table exists
  --     SET @sql = CONCAT('CREATE TABLE IF NOT EXISTS ', @transactionsblendStage, ' LIKE ', @finalTable);
  --     PREPARE stmt FROM @sql;
  --     EXECUTE stmt;
  --     DEALLOCATE PREPARE stmt;
  -- 
  --     -- 2. Check and add missing columns to the final table
  --     SET @sql = '';
  --     WITH missing_columns AS (
  --         SELECT 'Index' AS column_name, 'INT NULL AFTER `Id`' AS column_definition UNION ALL
  --         SELECT 'ACC_ACCPAY', 'VARCHAR(50) NULL AFTER `CashOrAccruals`' UNION ALL
  --         SELECT 'Accounts_Class', 'VARCHAR(255) NULL AFTER `CashOrAccruals`' UNION ALL
  --         SELECT 'PnL_BS', 'VARCHAR(10) NULL' UNION ALL
  --         SELECT 'AgedMovement', 'VARCHAR(50) NULL' UNION ALL
  --         SELECT 'CashReceived', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CashSpent', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'DebitGross', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'DebitNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CreditGross', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CreditNetAmount', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'DebitGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'DebitNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CreditGrossFX', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CreditNetAmountFX', 'DECIMAL(30,6) NULL' UNION ALL
  --         SELECT 'CashSummary', 'VARCHAR(100) NULL' UNION ALL
  --         SELECT 'DetailedBreakdownAccountNames', 'VARCHAR(255) NULL' UNION ALL
  --         SELECT 'SystemAccount', 'VARCHAR(255) NULL'
  --     )
  --     SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition))
  --     INTO @columns_to_add
  --     FROM missing_columns mc
  --     LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
  --         ON ic.TABLE_SCHEMA = DATABASE()
  --         AND ic.TABLE_NAME = @finalTable
  --         AND ic.COLUMN_NAME = mc.column_name
  --     WHERE ic.COLUMN_NAME IS NULL;
  -- 
  --     IF @columns_to_add IS NOT NULL THEN
  --         SET @sql = CONCAT('ALTER TABLE ', @finalTable, ' ', @columns_to_add);
  --         PREPARE stmt FROM @sql;
  --         EXECUTE stmt;
  --         DEALLOCATE PREPARE stmt;
  --     END IF;
  -- 
  --     -- 3. Truncate the staging table
  --     SET @sql = CONCAT('TRUNCATE TABLE ', @transactionsblendStage);
  --     PREPARE stmt FROM @sql;
  --     EXECUTE stmt;
  --     DEALLOCATE PREPARE stmt;
  -- 
  --     -- 4. Insert into staging table (batched) - RN Removed
  --     WHILE v_rowcount > 0 DO
  --         SET @sql = CONCAT('
  --             INSERT INTO ', @transactionsblendStage, ' (
  --                 `Id`, `JournalId`, `JournalDate`, `JournalNumber`, `CreatedDateUTC`, `SourceId`, `SourceType`, `JournalLine_JournalLineId`,
  --                 `JournalLine_Description`, `JournalLine_AccountId`, `JournalLine_AccountCode`, `JournalLine_AccountType`,
  --                 `JournalLine_AccountName`, `JournalLine_NetAmount`, `JournalLine_GrossAmount`, `JournalLine_TaxAmount`,
  --                 `JournalLine_TaxType`, `JournalLine_TaxName`, `LineItem_TrackingCategory1_CategoryId`,
  --                 `LineItem_TrackingCategory1_CategoryName`, `LineItem_TrackingCategory1_OptionId`, `LineItem_TrackingCategory1_OptionName`,
  --                 `LineItem_TrackingCategory1_Option_Stat`, `LineItem_TrackingCategory2_CategoryId`, `LineItem_TrackingCategory2_CategoryName`,
  --                 `LineItem_TrackingCategory2_OptionId`, `LineItem_TrackingCategory2_OptionName`, `LineItem_TrackingCategory2_Option_Stat`,
  --                 `ClientID`, `OrganisationID`, `JournalLine_NetAmount_AUD`, `JournalLine_NetAmount_USD`, `JournalLine_NetAmount_NZD`,
  --                 `JournalLine_NetAmount_EUR`, `JournalLine_NetAmount_GBP`, `JournalLine_GrossAmount_AUD`, `JournalLine_GrossAmount_USD`,
  --                 `JournalLine_GrossAmount_NZD`, `JournalLine_GrossAmount_EUR`, `JournalLine_GrossAmount_GBP`, `JournalLine_TaxAmount_AUD`,
  --                 `JournalLine_TaxAmount_USD`, `JournalLine_TaxAmount_NZD`, `JournalLine_TaxAmount_EUR`, `JournalLine_TaxAmount_GBP`,
  --                 `Split`, `Changes`, `User`, `Details`, `SourceNumber`, `CashOrAccruals`, `ContactID`, `ContactName`, `ContactSource`,
  --                 `PaymentSourceID`, `PaymentType`, `ShowOnCashBasisReports`, `FullyPaidOnDate`, `DayDifference`, `PlannedPaymentDate`,
  --                 `ItemCode`, `Quantity`, `DiscountRate`, `UnitAmount`, `UnitAmount_AUD`, `UnitAmount_USD`, `UnitAmount_NZD`, `UnitAmount_EUR`,
  --                 `UnitAmount_GBP`, `AmountDue`, `AmountDue_AUD`, `AmountDue_USD`, `AmountDue_NZD`, `AmountDue_EUR`, `AmountDue_GBP`, `URL`,
  --                 `DueDate`, `Reference`
  --             )
  --             SELECT * FROM (
  --               SELECT * FROM (
  --                 SELECT
  --                     j.`Id`, j.`JournalId`, j.`JournalDate`, j.`JournalNumber`, j.`CreatedDateUTC`, j.`SourceId`, j.`SourceType`,
  --                     j.`JournalLine_JournalLineId`, j.`JournalLine_Description`, j.`JournalLine_AccountId`, j.`JournalLine_AccountCode`,
  --                     j.`JournalLine_AccountType`, j.`JournalLine_AccountName`, j.`JournalLine_NetAmount`, j.`JournalLine_GrossAmount`,
  --                     j.`JournalLine_TaxAmount`, j.`JournalLine_TaxType`, j.`JournalLine_TaxName`, j.`LineItem_TrackingCategory1_CategoryId`,
  --                     j.`LineItem_TrackingCategory1_CategoryName`, j.`LineItem_TrackingCategory1_OptionId`, j.`LineItem_TrackingCategory1_OptionName`,
  --                     j.`LineItem_TrackingCategory1_Option_Stat`, j.`LineItem_TrackingCategory2_CategoryId`, j.`LineItem_TrackingCategory2_CategoryName`,
  --                     j.`LineItem_TrackingCategory2_OptionId`, j.`LineItem_TrackingCategory2_OptionName`, j.`LineItem_TrackingCategory2_Option_Stat`,
  --                     j.`ClientID`, j.`OrganisationID`, j.`JournalLine_NetAmount_AUD`, j.`JournalLine_NetAmount_USD`, j.`JournalLine_NetAmount_NZD`,
  --                     j.`JournalLine_NetAmount_EUR`, j.`JournalLine_NetAmount_GBP`, j.`JournalLine_GrossAmount_AUD`, j.`JournalLine_GrossAmount_USD`,
  --                     j.`JournalLine_GrossAmount_NZD`, j.`JournalLine_GrossAmount_EUR`, j.`JournalLine_GrossAmount_GBP`, j.`JournalLine_TaxAmount_AUD`,
  --                     j.`JournalLine_TaxAmount_USD`, j.`JournalLine_TaxAmount_NZD`, j.`JournalLine_TaxAmount_EUR`, j.`JournalLine_TaxAmount_GBP`,
  --                     j.`Split`, j.`Changes`, j.`User`, j.`Details`, COALESCE(j.`InvoiceNumber`, j.`CreditNoteNumber`) AS `SourceNumber`,
  --                     ''Accruals'' AS `CashOrAccruals`, t.`ContactID`, t.`ContactName`, t.`Source` AS `ContactSource`,
  --                     CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
  --                     CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentType` ELSE NULL END AS `PaymentType`,
  --                     t.`ShowOnCashBasisReports`, t.`FullyPaidOnDate`, t.`DayDifference`, t.`PlannedPaymentDate`, t.`ItemCode`, t.`Quantity`,
  --                     t.`DiscountRate`, t.`UnitAmount`, t.`UnitAmount_AUD`, t.`UnitAmount_USD`, t.`UnitAmount_NZD`, t.`UnitAmount_EUR`,
  --                     t.`UnitAmount_GBP`, t.`AmountDue`, t.`AmountDue_AUD`, t.`AmountDue_USD`, t.`AmountDue_NZD`, t.`AmountDue_EUR`,
  --                     t.`AmountDue_GBP`, t.`URL`, t.`DueDate`, CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END AS `Reference`
  --                 FROM `c', v_clientID, '_xeroblue_journals` j
  --                 LEFT JOIN `c', v_clientID, '_xeroblue_transactions` t
  --                     ON j.`SourceId` = t.`Id`
  --                     AND j.`OrganisationID` = t.`OrganisationID`
  --                     AND j.`JournalLine_AccountCode` = t.`AccountCode`
  --                     AND ABS(j.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
  --                 WHERE j.`OrganisationID` = ', v_OrganisationID, '
  --                 LIMIT ', v_batchsize, ' OFFSET ', v_ffset, '
  --                 ) as accruals
  -- 
  --                 UNION ALL
  --     
  --               SELECT * FROM (
  --                 SELECT
  --                     jc.`Id`, jc.`JournalId`, jc.`JournalDate`, jc.`JournalNumber`, jc.`CreatedDateUTC`, jc.`SourceId`, jc.`SourceType`,
  --                     jc.`JournalLine_JournalLineId`, jc.`JournalLine_Description`, jc.`JournalLine_AccountId`, jc.`JournalLine_AccountCode`,
  --                     jc.`JournalLine_AccountType`, jc.`JournalLine_AccountName`, jc.`JournalLine_NetAmount`, jc.`JournalLine_GrossAmount`,
  --                     jc.`JournalLine_TaxAmount`, jc.`JournalLine_TaxType`, jc.`JournalLine_TaxName`, jc.`LineItem_TrackingCategory1_CategoryId`,
  --                     jc.`LineItem_TrackingCategory1_CategoryName`, jc.`LineItem_TrackingCategory1_OptionId`, jc.`LineItem_TrackingCategory1_OptionName`,
  --                     jc.`LineItem_TrackingCategory1_Option_Stat`, jc.`LineItem_TrackingCategory2_CategoryId`, jc.`LineItem_TrackingCategory2_CategoryName`,
  --                     jc.`LineItem_TrackingCategory2_OptionId`, jc.`LineItem_TrackingCategory2_OptionName`, jc.`LineItem_TrackingCategory2_Option_Stat`,
  --                     jc.`ClientID`, jc.`OrganisationID`, jc.`JournalLine_NetAmount_AUD`, jc.`JournalLine_NetAmount_USD`, jc.`JournalLine_NetAmount_NZD`,
  --                     jc.`JournalLine_NetAmount_EUR`, jc.`JournalLine_NetAmount_GBP`, jc.`JournalLine_GrossAmount_AUD`, jc.`JournalLine_GrossAmount_USD`,
  --                     jc.`JournalLine_GrossAmount_NZD`, jc.`JournalLine_GrossAmount_EUR`, jc.`JournalLine_GrossAmount_GBP`, jc.`JournalLine_TaxAmount_AUD`,
  --                     jc.`JournalLine_TaxAmount_USD`, jc.`JournalLine_TaxAmount_NZD`, jc.`JournalLine_TaxAmount_EUR`, jc.`JournalLine_TaxAmount_GBP`,
  --                     jc.`Split`, jc.`Changes`, jc.`User`, jc.`Details`, COALESCE(jc.`InvoiceNumber`, jc.`CreditNoteNumber`) AS `SourceNumber`,
  --                     ''Cash'' AS `CashOrAccruals`, t.`ContactID`, t.`ContactName`, t.`Source` AS `ContactSource`,
  --                     CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
  --                     CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentType` ELSE NULL END AS `PaymentType`,
  --                     t.`ShowOnCashBasisReports`, t.`FullyPaidOnDate`, t.`DayDifference`, t.`PlannedPaymentDate`, t.`ItemCode`, t.`Quantity`,
  --                     t.`DiscountRate`, t.`UnitAmount`, t.`UnitAmount_AUD`, t.`UnitAmount_USD`, t.`UnitAmount_NZD`, t.`UnitAmount_EUR`,
  --                     t.`UnitAmount_GBP`, t.`AmountDue`, t.`AmountDue_AUD`, t.`AmountDue_USD`, t.`AmountDue_NZD`, t.`AmountDue_EUR`,
  --                     t.`AmountDue_GBP`, t.`URL`, t.`DueDate`, CASE WHEN jc.`Reference` IS NULL THEN t.`Reference` ELSE jc.`Reference` END AS `Reference`
  --                 FROM `c', v_clientID, '_xeroblue_journalscash` jc
  --                 LEFT JOIN `c', v_clientID, '_xeroblue_transactions` t
  --                     ON jc.`SourceId` = t.`Id`
  --                     AND jc.`OrganisationID` = t.`OrganisationID`
  --                     AND jc.`JournalLine_AccountCode` = t.`AccountCode`
  --                     AND ABS(jc.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
  --                 WHERE jc.`OrganisationID` = ', v_OrganisationID, '
  --                 LIMIT ', v_batchsize, ' OFFSET ', v_ffset, '
  --                 ) as cash 
  --             ) AS merged_data
  --             WHERE 1=1;  -- Simplified WHERE clause, no longer needs RN
  --         ');
  --         PREPARE stmt FROM @sql;
  --         EXECUTE stmt;
  --         SELECT ROW_COUNT() INTO v_rowcount;
  --         DEALLOCATE PREPARE stmt;
  -- 
  --         SET v_total_rows = v_total_rows + v_rowcount;
  --         SET v_ffset = v_ffset + v_batchsize;
  --     END WHILE;
  -- 
  -- --     -- 5. Delete existing records from the final table
  -- --     SET @sql = CONCAT('
  -- --         DELETE f FROM ', @finalTable, ' f
  -- --         INNER JOIN ', @transactionsblendStage, ' s ON f.`JournalLine_JournalLineId` = s.`JournalLine_JournalLineId`
  -- --         WHERE f.`OrganisationID` = ', v_OrganisationID
  -- --     );
  -- --     PREPARE stmt FROM @sql;
  -- --     EXECUTE stmt;
  -- --     DEALLOCATE PREPARE stmt;
  -- 
  --     -- 6. Insert into final table (batched) - RN Removed
  --     SET v_ffset = 0;
  --     SET v_rowcount = 1;
  --     WHILE v_rowcount > 0 DO
  --         SET @sql = CONCAT('
  --             INSERT INTO ', @finalTable, ' (
  --                 `Id`, `JournalId`, `JournalDate`, `JournalNumber`, `CreatedDateUTC`, `Reference`, `SourceId`, `SourceType`,
  --                 `JournalLine_JournalLineId`, `JournalLine_Description`, `JournalLine_AccountId`, `JournalLine_AccountCode`,
  --                 `JournalLine_AccountType`, `JournalLine_AccountName`, `JournalLine_NetAmount`, `JournalLine_GrossAmount`,
  --                 `JournalLine_TaxAmount`, `JournalLine_NetAmount_AUD`, `JournalLine_GrossAmount_AUD`, `JournalLine_TaxAmount_AUD`,
  --                 `JournalLine_TaxType`, `JournalLine_TaxName`, `LineItem_TrackingCategory1_CategoryId`,
  --                 `LineItem_TrackingCategory1_CategoryName`, `LineItem_TrackingCategory1_OptionId`, `LineItem_TrackingCategory1_OptionName`,
  --                 `LineItem_TrackingCategory1_Option_Stat`, `LineItem_TrackingCategory2_CategoryId`, `LineItem_TrackingCategory2_CategoryName`,
  --                 `LineItem_TrackingCategory2_OptionId`, `LineItem_TrackingCategory2_OptionName`, `LineItem_TrackingCategory2_Option_Stat`,
  --                 `ClientID`, `OrganisationID`, `Split`, `ContactID`, `ContactName`, `ContactSource`, `PaymentSourceID`, `PaymentType`,
  --                 `Changes`, `User`, `Details`, `ShowOnCashBasisReports`, `FullyPaidOnDate`, `DayDifference`, `SourceNumber`,
  --                 `CashOrAccruals`, `PlannedPaymentDate`, `ItemCode`, `Quantity`, `DiscountRate`, `UnitAmount`, `UnitAmount_AUD`,
  --                 `AmountDue`, `AmountDue_AUD`, `URL`, `DueDate`, `Index`, `ACC_ACCPAY`, `Accounts_Class`, `PnL_BS`, `AgedMovement`,
  --                 `CashReceived`, `CashSpent`, `DebitGross`, `DebitNetAmount`, `CreditGross`, `CreditNetAmount`, `DebitGrossFX`,
  --                 `DebitNetAmountFX`, `CreditGrossFX`, `CreditNetAmountFX`, `CashSummary`, `DetailedBreakdownAccountNames`, `SystemAccount`
  --             )
  --             SELECT
  --                 tb.`Id`, tb.`JournalId`, tb.`JournalDate`, tb.`JournalNumber`, tb.`CreatedDateUTC`, tb.`Reference`, tb.`SourceId`,
  --                 IFNULL(tb.`SourceType`, ''NULL VALUE'') AS `SourceType`, tb.`JournalLine_JournalLineId`, tb.`JournalLine_Description`,
  --                 tb.`JournalLine_AccountId`, tb.`JournalLine_AccountCode`, tb.`JournalLine_AccountType`, tb.`JournalLine_AccountName`,
  --                 tb.`JournalLine_NetAmount`, tb.`JournalLine_GrossAmount`, tb.`JournalLine_TaxAmount`, tb.`JournalLine_NetAmount_AUD`,
  --                 tb.`JournalLine_GrossAmount_AUD`, tb.`JournalLine_TaxAmount_AUD`, tb.`JournalLine_TaxType`, tb.`JournalLine_TaxName`,
  --                 tb.`LineItem_TrackingCategory1_CategoryId`, tb.`LineItem_TrackingCategory1_CategoryName`, tb.`LineItem_TrackingCategory1_OptionId`,
  --                 tb.`LineItem_TrackingCategory1_OptionName`, tb.`LineItem_TrackingCategory1_Option_Stat`, tb.`LineItem_TrackingCategory2_CategoryId`,
  --                 tb.`LineItem_TrackingCategory2_CategoryName`, tb.`LineItem_TrackingCategory2_OptionId`, tb.`LineItem_TrackingCategory2_OptionName`,
  --                 tb.`LineItem_TrackingCategory2_Option_Stat`, tb.`ClientID`, tb.`OrganisationID`, tb.`Split`, tb.`ContactID`, tb.`ContactName`,
  --                 tb.`ContactSource`, tb.`PaymentSourceID`, tb.`PaymentType`, tb.`Changes`, tb.`User`, tb.`Details`, tb.`ShowOnCashBasisReports`,
  --                 tb.`FullyPaidOnDate`, tb.`DayDifference`, tb.`SourceNumber`, tb.`CashOrAccruals`, tb.`PlannedPaymentDate`, tb.`ItemCode`,
  --                 tb.`Quantity`, tb.`DiscountRate`, tb.`UnitAmount`, tb.`UnitAmount_AUD`, tb.`AmountDue`, tb.`AmountDue_AUD`, tb.`URL`,
  --                 tb.`DueDate`,
  -- 
  --                 -- Calculated Columns
  --                 ROW_NUMBER() OVER (ORDER BY tb.`JournalDate`) AS `Index`,
  --                 CASE
  --                     WHEN LOCATE(''ACCREC'', tb.`SourceType`) > 0 THEN ''ACCREC''
  --                     WHEN LOCATE(''ACCPAY'', tb.`SourceType`) > 0 THEN ''ACCPAY''
  --                     WHEN LEFT(tb.`SourceType`, 2) = ''AR'' THEN ''ACCREC''
  --                     WHEN LEFT(tb.`SourceType`, 2) = ''AP'' THEN ''ACCPAY''
  --                     ELSE ''OTHER UNRELATED TO AR/AP''
  --                 END AS `ACC_ACCPAY`,
  --                 acc.`Class` AS `Accounts_Class`,
  --                 CASE
  --                     WHEN acc.`Class` IN (''Revenue'', ''Expense'') THEN ''PnL''
  --                     WHEN acc.`Class` IN (''Asset'', ''Liability'', ''Equity'') THEN ''BS''
  --                     ELSE NULL
  --                 END AS `PnL_BS`,
  --                 CASE
  --                     WHEN tb.`SourceType` = ''ACCREC'' AND tb.`CashOrAccruals` = ''Accruals'' THEN ''Accruals''
  --                     WHEN tb.`SourceType` = ''ACCPAY'' AND tb.`CashOrAccruals` = ''Accruals'' THEN ''Accruals''
  --                     WHEN tb.`SourceType` IN (''ACCREC'', ''ACCPAY'') AND tb.`CashOrAccruals` = ''Cash'' THEN ''Cash''
  --                     WHEN tb.`SourceType` = ''ACCRECCREDIT'' AND tb.`CashOrAccruals` = ''Accruals'' AND tb.`Changes` = ''Applied'' THEN ''Accruals''
  --                     WHEN tb.`SourceType` = ''ACCPAYCREDIT'' AND tb.`CashOrAccruals` = ''Accruals'' AND tb.`Changes` = ''Applied'' THEN ''Payments''
  --                     WHEN tb.`SourceType` = ''ACCRECCREDIT'' AND tb.`CashOrAccruals` = ''Accruals'' AND tb.`Changes` = ''Approved'' THEN ''Accruals''
  --                     WHEN tb.`SourceType` = ''APOVERPAYMENT'' AND tb.`CashOrAccruals` = ''Accruals'' AND tb.`Changes` = ''Cash Refunded'' THEN ''CashOPPP''
  --                     ELSE NULL
  --                 END AS `AgedMovement`,
  --                 CASE WHEN acc.`Type` = ''BANK'' AND tb.`JournalLine_GrossAmount_AUD` >= 0 THEN tb.`JournalLine_GrossAmount_AUD` ELSE NULL END AS `CashReceived`,
  --                 CASE WHEN acc.`Type` = ''BANK'' AND tb.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - tb.`JournalLine_GrossAmount_AUD`) ELSE NULL END AS `CashSpent`,
  --                 CASE WHEN tb.`JournalLine_GrossAmount` >= 0 THEN tb.`JournalLine_GrossAmount` ELSE NULL END AS `DebitGross`,
  --                 CASE WHEN tb.`JournalLine_NetAmount`   >= 0 THEN tb.`JournalLine_NetAmount`   ELSE NULL END AS `DebitNetAmount`,
  --                 CASE WHEN tb.`JournalLine_GrossAmount` < 0 THEN (0 - tb.`JournalLine_GrossAmount`) ELSE NULL END AS `CreditGross`,
  --                 CASE WHEN tb.`JournalLine_NetAmount`   < 0 THEN (0 - tb.`JournalLine_NetAmount`)   ELSE NULL END AS `CreditNetAmount`,
  --                 CASE WHEN tb.`JournalLine_GrossAmount_AUD` >= 0 THEN tb.`JournalLine_GrossAmount_AUD` ELSE NULL END AS `DebitGrossFX`,
  --                 CASE WHEN tb.`JournalLine_NetAmount_AUD`   >= 0 THEN tb.`JournalLine_NetAmount_AUD`   ELSE NULL END AS `DebitNetAmountFX`,
  --                 CASE WHEN tb.`JournalLine_GrossAmount_AUD` < 0 THEN (0 - tb.`JournalLine_GrossAmount_AUD`) ELSE NULL END AS `CreditGrossFX`,
  --                 CASE WHEN tb.`JournalLine_NetAmount_AUD`   < 0 THEN (0 - tb.`JournalLine_NetAmount_AUD`)   ELSE NULL END AS `CreditNetAmountFX`,
  --                 CASE
  --                     WHEN tb.`JournalLine_AccountName` = ''GST'' THEN ''PLUS GST Movements''
  --                     WHEN acc.`Type` = ''BANK'' THEN ''Cash Surplus (Deficit)''
  --                     WHEN acc.`Class` IN (''Asset'', ''Revenue'') THEN ''Income''
  --                     WHEN acc.`Class` IN (''Liability'', ''Expense'', ''Equity'') THEN ''Less Expenses''
  --                     ELSE acc.`Name`
  --                 END AS `CashSummary`,
  --                 CASE
  --                     WHEN tb.`JournalLine_AccountName` = ''GST'' AND tb.`JournalLine_NetAmount_AUD` < 0 THEN ''GST Collected''
  --                     WHEN tb.`JournalLine_AccountName` = ''GST'' AND tb.`JournalLine_NetAmount_AUD` >= 0 THEN ''GST Paid''
  --                     ELSE tb.`JournalLine_AccountName`
  --                 END AS `DetailedBreakdownAccountNames`,
  --                 acc.`SystemAccount` AS `SystemAccount`
  --             FROM
  --                 (SELECT * FROM ', @transactionsblendStage, ' LIMIT ', v_batchsize, ' OFFSET ', v_ffset, ') tb
  --             LEFT JOIN `c', v_clientID, '_xeroblue_accounts` acc
  --                 ON tb.`JournalLine_AccountId` = acc.`AccountId`
  --                 AND tb.`OrganisationID` = acc.`OrganisationID`;
  --         ');
  -- 
  --         PREPARE stmt FROM @sql;
  --         EXECUTE stmt;
  --         SELECT ROW_COUNT() INTO v_rowcount;
  --         DEALLOCATE PREPARE stmt;
  -- 
  --         SET v_total_rows = v_total_rows + v_rowcount;
  --         SET v_ffset = v_ffset + v_batchsize;
  --     END WHILE;
  -- 
  -- 
  --     -- 7. Drop the staging table
  --     SET @sql = CONCAT('DROP TABLE IF EXISTS ', @transactionsblendStage);
  --     PREPARE stmt FROM @sql;
  --     EXECUTE stmt;
  --     DEALLOCATE PREPARE stmt;
  -- Log completion
  SELECT
    CONCAT('Process completed. Total rows: ', v_total_rows, ', Time: ', TIMESTAMPDIFF(SECOND, v_batch_start, NOW()), 's') AS message;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_transactionsblend_by_client`
--
CREATE PROCEDURE sp_dynamic_xeroblue_transactionsblend_by_client (IN `p_clientID` int)
BEGIN
  DECLARE v_OrganisationID int;
  DECLARE v_legacyOrganisationID int;
  DECLARE v_clientID int;
  DECLARE v_batch_start timestamp;
  DECLARE v_total_rows int;
  DECLARE v_rowcount int;
  DECLARE v_ffset int;
  DECLARE v_batchsize int;
  DECLARE done int DEFAULT FALSE;
  DECLARE orgs_cursor CURSOR FOR
  SELECT
    Id AS organisationID,
    IFNULL(JSON_UNQUOTE(JSON_EXTRACT(Details, '$.Legacy.id')), id) AS LegacyOrganisationID
  FROM etaniv2.client_service
  WHERE client = p_clientID
  AND Service = 1;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN orgs_cursor;

    read_loop:
  LOOP
    FETCH orgs_cursor INTO v_OrganisationID, v_legacyOrganisationID;

    IF done THEN
      LEAVE read_loop;
    END IF;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    CALL sp_dynamic_xeroblue_transactionsblend(p_clientID, v_OrganisationID, v_legacyOrganisationID);

  END LOOP;

  CLOSE orgs_cursor;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_reconciliation`
--
CREATE PROCEDURE sp_dynamic_xeroblue_reconciliation (IN p_id int,
IN p_endpoint varchar(255),
IN p_clientid int,
IN p_organisationid int,
IN p_legacyorganisationid int)
BEGIN
  DECLARE v_organisationid int DEFAULT p_organisationid;
  DECLARE v_clientid int DEFAULT p_clientid;
  DECLARE v_id int DEFAULT 0;
  DECLARE v_recordcount int;
  DECLARE v_uniquerecordcount int;
  DECLARE v_filterkeycount int;
  DECLARE v_minfilterkey int;
  DECLARE v_maxfilterkey int;
  DECLARE v_comment text DEFAULT '';
  DECLARE v_missingids text DEFAULT '';
  DECLARE v_duplicateids text DEFAULT '';
  DECLARE v_status varchar(255) DEFAULT '';
  DECLARE v_table varchar(255) DEFAULT p_endpoint;

  SET v_organisationid = CASE WHEN p_legacyorganisationid <> 0 THEN p_legacyorganisationid ELSE p_organisationid END;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET SESSION group_concat_max_len = 4294967295;
  SET @stagetable = CONCAT('c', v_clientid, '_', p_organisationid, '_xeroblue_', v_table, 'stage');
  SET @finaltable = CONCAT('c', v_clientid, '_xeroblue_', v_table);
  SET @transtable = CONCAT('c', v_clientid, '_xeroblue_transactions');
  SET @banktransfertable = CONCAT('c', v_clientid, '_xeroblue_banktransfers');
  SET @trackingcattable = CONCAT('c', v_clientid, '_xeroblue_trackingcategories');

  SET @sql = '';

  -- Add isvisible column if missing - Start
  WITH missing_columns
  AS
  (SELECT
      'isvisible' AS column_name,
      'boolean NULL DEFAULT TRUE AFTER `DueDate`' AS column_definition)
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set1
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @finaltable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns
  AS
  (SELECT
      'isvisible' AS column_name,
      'boolean NULL DEFAULT TRUE AFTER `DueDate`' AS column_definition)
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set2
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @stagetable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  IF @columns_to_add_set1 IS NOT NULL THEN
    SET @sql = CONCAT('ALTER TABLE ', @finaltable, ' ', @columns_to_add_set1);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;

  IF @columns_to_add_set2 IS NOT NULL THEN
    SET @sql = CONCAT('ALTER TABLE ', @stagetable, ' ', @columns_to_add_set2);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;

  SET @sql = CONCAT('SELECT 
            COUNT(*) AS recordcount 
            ,COUNT(DISTINCT ID) AS uniquerecordcount
            ,COUNT(DISTINCT JournalNumber) AS filterkeycount
            ,MIN(JournalNumber) AS minfilterkey
            ,MAX(JournalNumber) AS maxfilterkey
        INTO 
            @recordcount,
            @uniquerecordcount,
            @filterkeycount, 
            @minfilterkey, 
            @maxfilterkey
        FROM ', @finaltable, ' 
        WHERE OrganisationID = ', v_organisationid, '
        GROUP BY clientid, OrganisationID;');
  PREPARE checkstmt FROM @sql;
  EXECUTE checkstmt;
  DEALLOCATE PREPARE checkstmt;
  -- Add isvisible column if missing - End

  -- Get next ID if not provided
  IF p_id = 0 THEN
    SET @sql = CONCAT('SELECT IFNULL(MAX(id)+1, 1) INTO @id FROM xeroblue_reconciliation LIMIT 1;');
    PREPARE idstmt FROM @sql;
    EXECUTE idstmt;
    DEALLOCATE PREPARE idstmt;
    SET v_id = @id;
    SET @sql = CONCAT('INSERT INTO xeroblue_reconciliation (
                id,
                clientid,
                organisationid,
                tablename,
                uniquekey,
                filterkey,
                date,
                recordcount, 
                uniquerecordcount, 
                filterkeycount, 
                minfilterkey, 
                maxfilterkey
            )
            SELECT
                ', v_id, '
                ,clientid
                ,OrganisationID
                ,''', @finaltable, ''' AS tablename
                ,''ID'' AS uniquekey
                ,''JournalNumber'' AS filterkey
                ,NOW() AS date,
                @recordcount, 
                @uniquerecordcount, 
                @filterkeycount, 
                @minfilterkey, 
                @maxfilterkey
            FROM ', @finaltable, '
            WHERE OrganisationID = ', v_organisationid, '
            GROUP BY clientid, OrganisationID;');
    PREPARE insertstmt FROM @sql;
    EXECUTE insertstmt;
    DEALLOCATE PREPARE insertstmt;
  ELSE
    SET v_id = p_id;
  END IF;

  -- Check for duplicate journal numbers
  IF @recordcount > @uniquerecordcount THEN
    SET v_comment = CONCAT(v_comment, '"possibleDuplicate": ');
    SET @sql = CONCAT('WITH duplicates AS (
                SELECT
                    ID
                    ,JournalNumber
                    ,SourceID
                    ,ROW_NUMBER() OVER(PARTITION BY JournalNumber,id ORDER BY JournalNumber,id) AS RN
                    ,OrganisationID
                FROM ', @finaltable, '
                WHERE OrganisationID = ', v_organisationid, '
            )
            SELECT GROUP_CONCAT(CONCAT(''"'',ID,''"'') SEPARATOR '', '')
            INTO @duplicateids
            FROM duplicates WHERE RN > 1;');
    PREPARE dupstmt FROM @sql;
    EXECUTE dupstmt;
    DEALLOCATE PREPARE dupstmt;

    SET v_comment = CONCAT(v_comment, '[', @duplicateids, ']');
  END IF;

  -- Check for missing journal numbers
  IF @maxfilterkey > @filterkeycount
    OR @minfilterkey > 1 THEN

    IF v_comment != '' THEN
      SET v_comment = CONCAT(v_comment, ', ');
    END IF;
    SET v_comment = CONCAT(v_comment, '"missingJournalNumbers": ');
    SET @sql = CONCAT('WITH RECURSIVE gaps AS (
                SELECT 
                    JournalNumber AS MaxID,
                    IFNULL(LAG(JournalNumber) OVER (ORDER BY JournalNumber),0) AS MinID
                FROM ', @finaltable, '
                WHERE OrganisationID = ', v_organisationid, '
            ),
            gap_ranges AS (
                SELECT 
                    MinID + 1 AS start_id,
                    MaxID - 1 AS end_id
                FROM gaps
                WHERE MaxID - MinID > 1
            )
            SELECT 
                GROUP_CONCAT(
                CASE 
                WHEN start_id = end_id THEN CONCAT(''"'',start_id,''"'')
                ELSE CONCAT(''"'',start_id,''-'',end_id,''"'') 
                END SEPARATOR '', '') AS missing_journalnumbers
            INTO @missingids
            FROM gap_ranges;');
    PREPARE missingstmt FROM @sql;
    EXECUTE missingstmt;
    DEALLOCATE PREPARE missingstmt;

    SET v_comment = CONCAT(v_comment, '[', @missingids, ']');
  END IF;

  SET v_comment = CONCAT('[{', v_comment, '}]');

  IF v_id != 0 THEN
    SET v_status = CASE WHEN @recordcount = @uniquerecordcount AND
          @maxfilterkey = @filterkeycount AND
          @minfilterkey = 1 THEN 'DONE' ELSE 'FAILED' END;
  ELSE
    SET v_status = 'PENDING';
  END IF;

  -- Fix missing details - Start
  -- Check and update journals with missing contact details
  SET @sql = CONCAT('UPDATE ', @finaltable, ' J
            LEFT JOIN ', @transtable, ' T
                    ON j.`SourceId` = t.`Id`
                    AND j.`OrganisationID` = t.`OrganisationID`        
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
                J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END
            WHERE j.ContactID IS NULL AND j.SourceID IS NOT NULL AND j.OrganisationID = ', v_organisationid, ';');
  PREPARE updatestmt1 FROM @sql;
  EXECUTE updatestmt1;
  DEALLOCATE PREPARE updatestmt1;

  -- Check and update journals with NULL SourceID
  SET @sql = CONCAT('UPDATE ', @finaltable, '       
            SET  `SourceID` = ''unknown''
            WHERE ContactID IS null AND SourceID IS null AND OrganisationID = ', v_organisationid, ';');
  PREPARE updatestmt2 FROM @sql;
  EXECUTE updatestmt2;
  DEALLOCATE PREPARE updatestmt2;

  -- Check and update journals with missing option names
  SET @sql = CONCAT('UPDATE ', @finaltable, ' j
            JOIN ', @trackingcattable, ' tc
            ON j.LineItem_TrackingCategory1_CategoryId  = tc.TrackingCategoryId
            AND j.LineItem_TrackingCategory1_OptionId  = tc.TrackingOptionId
            AND J.OrganisationID = tc.OrganisationID
            SET
            j.LineItem_TrackingCategory1_OptionName = tc.OptionName
            WHERE j.LineItem_TrackingCategory1_OptionName <> tc.OptionName 
            AND j.OrganisationID = ', v_organisationid, ';');
  PREPARE updatestmt3 FROM @sql;
  EXECUTE updatestmt3;
  DEALLOCATE PREPARE updatestmt3;

  SET @sql = CONCAT('UPDATE ', @finaltable, ' j
            JOIN ', @trackingcattable, ' tc
            ON j.LineItem_TrackingCategory2_CategoryId  = tc.TrackingCategoryId
            AND j.LineItem_TrackingCategory2_OptionId  = tc.TrackingOptionId
            AND J.OrganisationID = tc.OrganisationID
            SET
            j.LineItem_TrackingCategory2_OptionName = tc.OptionName
            WHERE j.LineItem_TrackingCategory2_OptionName <> tc.OptionName 
            AND j.OrganisationID = ', v_organisationid, ';');
  PREPARE updatestmt4 FROM @sql;
  EXECUTE updatestmt4;
  DEALLOCATE PREPARE updatestmt4;

  -- Update PaymentSourceID and PaymentType for Credit Notes with allocations
  SET @sql = CONCAT('UPDATE ', @finaltable, ' J
        JOIN ', @transtable, ' T
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
            AND j.`JournalLine_GrossAmount` = 
                    CASE WHEN ContactSource = ''CREDITNOTES'' 
                        THEN t.`AllocationAmount` * -1
                    ELSE t.`AllocationAmount`
                    END
        SET  
            J.`PaymentSourceID` = t.`PaymentSourceID`,
            J.`PaymentType` = t.`PaymentType`
        WHERE j.SystemAccount = ''DEBTORS''
        AND j.OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt10 FROM @sql;
  EXECUTE updatestmt10;
  DEALLOCATE PREPARE updatestmt10;

  -- Update AgedMovement for journals
  SET @sql = CONCAT('UPDATE ', @finaltable, ' J
        SET  
            j.`AgedMovement` =
            CASE
                WHEN J.`SourceType` = ''ACCREC'' THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCPAY'' THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCRECCREDIT'' AND J.PaymentSourceID IS NULL THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCRECCREDIT'' AND J.PaymentSourceID IS NOT NULL THEN ''Payments''
                WHEN J.`SourceType` = ''ACCRECPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''ACCPAYCREDIT'' THEN ''Payments''
                WHEN J.`SourceType` = ''ARPREPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''AROVERPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''APOVERPAYMENT''  THEN ''CashOPPP''
                ELSE NULL
            END
        WHERE OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt11 FROM @sql;
  EXECUTE updatestmt11;
  DEALLOCATE PREPARE updatestmt11;
  -- Fix missing details - End


  -- Hide journals with following criterias - Start
  -- Check and hide journals with duplicate line items for same SourceID
  SET @sql = CONCAT('WITH JournalTotals AS (
            SELECT 
                SourceId,
                JournalNumber,
                JournalDate,
                CreatedDateUTC,
                SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2))) AS Total_NetAmount,
                SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2))) AS Total_GrossAmount,
                LAG(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_NetAmount,
                LAG(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_GrossAmount,
                LAG(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagCreatedDateUTC,
                LEAD(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_NetAmount,
                LEAD(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_GrossAmount,
                LEAD(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadCreatedDateUTC
            FROM ', @finaltable, '
            WHERE JournalLine_JournalLineId IS NOT NULL
                AND SourceId IS NOT NULL
                AND SourceID != ''unknown''
                AND OrganisationId = ', v_organisationid, '
            GROUP BY 
                SourceId,
                JournalNumber,
                JournalDate,
                CreatedDateUTC
            )
            UPDATE ', @finaltable, ' j
            JOIN JournalTotals jt
            ON j.SourceId = jt.SourceId
                AND j.JournalNumber = jt.JournalNumber
            SET j.isvisible = 
                CASE 
                    WHEN LagCreatedDateUTC IS NULL 
                        AND LeadCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    WHEN LeadCreatedDateUTC IS NOT NULL
                        AND LagCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LagTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LagTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    WHEN LeadCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    ELSE 1
                END
            WHERE OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt6 FROM @sql;
  EXECUTE updatestmt6;
  DEALLOCATE PREPARE updatestmt6;

  -- Check and show journals for invoice allocation
  SET @sql = CONCAT('WITH invallocation AS (
            SELECT j.SourceId
                ,j.journalnumber 
                ,j.JournalDate
                ,j.createddateutc
                ,j.Sourcetype
                ,j.JournalLine_AccountName
                ,j.JournalLine_GrossAmount
                ,j.isvisible
                ,j.ContactSource
                ,j.InvoiceNumber
                ,t.PaymentSourceID
                ,t.PaymentType
                ,t.AllocationDate
                ,t.AllocationAmount
                ,ROW_NUMBER() OVER(
                        PARTITION BY j.JournalLine_AccountName, j.JournalLine_GrossAmount 
                        ORDER BY j.journalnumber DESC
                    ) AS rn
            FROM ', @finaltable, ' j
            JOIN ', @transtable, ' t
                ON t.ID = j.SourceID 
                AND t.OrganisationID = j.OrganisationID
                AND t.AllocationAmount = j.JournalLine_GrossAmount
            WHERE j.ContactSource IN (''CREDITNOTES'', ''OVERPAYMENTS'', ''PREPAYMENTS'')
                AND j.OrganisationId = ', v_organisationid, '
            )
            UPDATE ', @finaltable, ' j
            JOIN invallocation i
                ON i.journalnumber = j.journalnumber
            SET j.isvisible = 
                    CASE
                        WHEN rn = 1 THEN 1
                        ELSE 0
                    END
            WHERE j.OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt7 FROM @sql;
  EXECUTE updatestmt7;
  DEALLOCATE PREPARE updatestmt7;

  -- Check and show journals with 2 or less records for SourceID
  SET @sql = CONCAT('WITH journaloutdated AS (
            SELECT SourceId
                ,COUNT(DISTINCT journalnumber) AS rc
            FROM ', @finaltable, '
            WHERE OrganisationId = ', v_organisationid, '
            GROUP BY SourceId
            )
            UPDATE ', @finaltable, ' j
            JOIN journaloutdated i
                ON i.SourceId = j.SourceId
                AND i.rc <= 2
            SET j.isvisible = 1
            WHERE j.OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt8 FROM @sql;
  EXECUTE updatestmt8;
  DEALLOCATE PREPARE updatestmt8;

  -- Check and hide outliers from journals
  SET @sql = CONCAT('WITH outliers AS (
            SELECT SourceId
                ,journalnumber
                ,LAG(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelag
                ,LEAD(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelead
                ,isvisible
            FROM ', @finaltable, '
            WHERE OrganisationId = ', v_organisationid, '
            GROUP BY SourceId, journalnumber, isvisible
            )
            UPDATE ', @finaltable, ' j
            JOIN outliers i
                ON i.SourceId = j.SourceId
                AND i.journalnumber = j.journalnumber
            SET j.isvisible = 0
            WHERE isvisiblelag = 0 AND isvisiblelead = 0
            AND j.OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt9 FROM @sql;
  EXECUTE updatestmt9;
  DEALLOCATE PREPARE updatestmt9;

  -- Check and hide journals with VOIDED/DELETED/TRANSFERRED status of SourceID
  SET @sql = CONCAT('UPDATE ', @finaltable, ' J
            LEFT JOIN (
                    SELECT DISTINCT ID, Source, Status, OrganisationID FROM ', @transtable, '
                    WHERE Status IN (''VOIDED'', ''DELETED'')
                ) DELETED 
                ON DELETED.ID = J.SourceID AND DELETED.OrganisationID = J.OrganisationID
            LEFT JOIN (
                    SELECT BankTransferID, OrganisationID FROM ', @banktransfertable, '
                ) BT 
                ON BT.BankTransferID = J.SourceID AND BT.OrganisationID = J.OrganisationID
            SET isvisible = 0
            WHERE (
                DELETED.ID IS NOT NULL 
                OR (
                        J.SourceType = ''TRANSFER''
                    AND BT.BankTransferID IS NULL
                    )
                )
            AND J.OrganisationId = ', v_organisationid, ';');
  PREPARE updatestmt5 FROM @sql;
  EXECUTE updatestmt5;
  DEALLOCATE PREPARE updatestmt5;
  -- Hide journals with following criterias - End

  -- Update the reconciliation record
  SET @sql = CONCAT('UPDATE xeroblue_reconciliation
        SET 
            recordcount = @recordcount
            ,uniquerecordcount = @uniquerecordcount
            ,filterkeycount = @filterkeycount
            ,minfilterkey = @minfilterkey
            ,maxfilterkey = @maxfilterkey
            ,comment = ''', v_comment, '''
            ,status = ''', v_status, '''
        WHERE id = ', v_id, ';');
  PREPARE updstmt FROM @sql;
  EXECUTE updstmt;
  DEALLOCATE PREPARE updstmt;

  -- Fetch the reconciliation record
  SET @sql = CONCAT('SELECT 
            id, 
            clientid, 
            organisationid, 
            tablename,
            uniquekey,
            filterkey,
            recordcount, 
            uniquerecordcount, 
            filterkeycount, 
            minfilterkey, 
            maxfilterkey, 
            date, 
            status, 
            comment
        FROM xeroblue_reconciliation
        WHERE id = ', v_id, ';');
  PREPARE selectstmt FROM @sql;
  EXECUTE selectstmt;
  DEALLOCATE PREPARE selectstmt;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_journalscash`
--
CREATE PROCEDURE sp_dynamic_xeroblue_journalscash (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET SESSION group_concat_max_len = 4294967295;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  -- Replace hardcoded table references with dynamic ones
  SET @journalscashStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_journalscashstage');
  SET @finalTable = CONCAT('c', v_clientID, '_xeroblue_journalscash');
  SET @transTable = CONCAT('c', v_clientID, '_xeroblue_transactions');
  SET @acctsTable = CONCAT('c', v_clientID, '_xeroblue_accounts');


  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @sql = '';
  WITH missing_columns
  AS
  (SELECT
      'Index' AS column_name,
      'INT NULL AFTER `Id`' AS column_definition
    UNION ALL
    SELECT
      'ACC_ACCPAY',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'Accounts_Class',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PnL_BS',
      'VARCHAR(10) NULL'
    UNION ALL
    SELECT
      'AgedMovement',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'CashReceived',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSpent',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSummary',
      'VARCHAR(100) NULL'
    UNION ALL
    SELECT
      'DetailedBreakdownAccountNames',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'SystemAccount',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set1
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @finalTable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns2
  AS
  (SELECT
      'ContactID' AS column_Name,
      'VARCHAR(255) NULL' AS column_definition
    UNION ALL
    SELECT
      'ContactName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ContactSource',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentSourceID',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentType',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ShowOnCashBasisReports',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'FullyPaidOnDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DayDifference',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PlannedPaymentDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ItemCode',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'Quantity',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'DiscountRate',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'UnitAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'URL',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DueDate',
      'DATE NULL'
    UNION ALL
    SELECT
      'OrganisationName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceTotal',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set2
  FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @finalTable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns
  AS
  (SELECT
      'Index' AS column_name,
      'INT NULL AFTER `Id`' AS column_definition
    UNION ALL
    SELECT
      'ACC_ACCPAY',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'Accounts_Class',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PnL_BS',
      'VARCHAR(10) NULL'
    UNION ALL
    SELECT
      'AgedMovement',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'CashReceived',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSpent',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSummary',
      'VARCHAR(100) NULL'
    UNION ALL
    SELECT
      'DetailedBreakdownAccountNames',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'SystemAccount',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set3
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @journalscashStage
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns2
  AS
  (SELECT
      'ContactID' AS column_Name,
      'VARCHAR(255) NULL' AS column_definition
    UNION ALL
    SELECT
      'ContactName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ContactSource',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentSourceID',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentType',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ShowOnCashBasisReports',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'FullyPaidOnDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DayDifference',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PlannedPaymentDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ItemCode',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'Quantity',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'DiscountRate',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'UnitAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'URL',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DueDate',
      'DATE NULL'
    UNION ALL
    SELECT
      'OrganisationName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceTotal',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set4
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
  SET @create_fxtable = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
                `BaseCurrency` VARCHAR(10),
                `Date` DATE,
                `AUD` DECIMAL(10, 4),
                `USD` DECIMAL(10, 4),
                `NZD` DECIMAL(10, 4),
                `EUR` DECIMAL(10, 4),
                `GBP` DECIMAL(10, 4)
                ,INDEX(BaseCurrency, DATE)
            );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt0 FROM @insert_fxtable;
  EXECUTE stmt0;
  DEALLOCATE PREPARE stmt0;

  SET @updatejournalscashStage = CONCAT('UPDATE ', @journalscashStage, ' AS jrnl
        LEFT JOIN c', v_clientID, '_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
            AND fx.`Date` = 
                CASE 
                    WHEN jrnl.`JournalDate` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
                    WHEN jrnl.`JournalDate` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
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
  CONCAT('UPDATE ', @journalscashStage, ' J
            LEFT JOIN ', @transTable, ' T
                    ON j.`SourceId` = t.`Id`
                    AND j.`OrganisationID` = t.`OrganisationID`
                    AND j.`JournalLine_AccountCode` = t.`AccountCode`
                    AND ABS(j.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
            LEFT JOIN ', @acctsTable, ' acc
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
            J.`InvoiceTotal` = CASE WHEN t.Source = ''INVOICES'' THEN t.`Total` ELSE NULL END');

  PREPARE updtrn_stmt FROM @update_from_trans_sql;
  EXECUTE updtrn_stmt;
  DEALLOCATE PREPARE updtrn_stmt;


  -- init batching vars
  SET @ffset = 0;
  SET @rowcount = 1;
  SET @batchsize = 500;


  WHILE @rowcount > 0 DO
    SET @delete_trg = CONCAT('DELETE TRG FROM ', @finalTable, ' TRG
        INNER JOIN (
            SELECT JournalId FROM ', @journalscashStage, ' 
            WHERE OrganisationId = ', v_OrganisationID, '
            GROUP BY JournalId
            ORDER BY JournalId  -- Ensures deterministic deletion
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ' 
        ) STG ON TRG.JournalId = STG.JournalId;');
    PREPARE del_stmt FROM @delete_trg;
    EXECUTE del_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE del_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @insert_xeroblue_journalscash = CONCAT('INSERT INTO ', @finalTable, '
        SELECT DISTINCT * FROM ', @journalscashStage, ';');

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
        FROM c', v_clientID, '_xeroblue_journalscash
        WHERE OrganisationId = ', v_OrganisationID, '
    ) subquery
    WHERE row_num > 1
    )
    DELETE FROM c', v_clientID, '_xeroblue_journalscash 
    WHERE JournalLine_JournalLineId IN (SELECT JournalLine_JournalLineId FROM duplicates)
    AND OrganisationId = ', v_OrganisationID, '
    LIMIT 1;
    ');
    PREPARE dup_stmt FROM @dup_sql;
    EXECUTE dup_stmt;
    SELECT
      ROW_COUNT() INTO @dup_rowcount;
    DEALLOCATE PREPARE dup_stmt;
  END WHILE;

  SET @update_xeroblue_journals1 = CONCAT('UPDATE ', @finalTable, ' `j`
        JOIN c', v_clientID, '_xeroblue_organisationsclients AS `org`  
        ON `org`.`OrganisationID` = `j`.`OrganisationID`
        SET `j`.`OrganisationName` = `org`.`Name`
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`OrganisationName` IS NULL;');
  PREPARE update_stmt1 FROM @update_xeroblue_journals1;
  EXECUTE update_stmt1;
  DEALLOCATE PREPARE update_stmt1;

  SET @update_xeroblue_journals2 = CONCAT('UPDATE ', @finalTable, ' `j`
        JOIN ', @transTable, ' `t`  
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
        SET `j`.`InvoiceTotal` = `t`.`Total`
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`InvoiceTotal` IS NULL
        AND `j`.`ContactSource` = ''INVOICES'';');
  PREPARE update_stmt2 FROM @update_xeroblue_journals2;
  EXECUTE update_stmt2;
  DEALLOCATE PREPARE update_stmt2;

  SET @update_xeroblue_journals3 = CONCAT('UPDATE ', @finalTable, ' j
        SET `j`.`IsVisible` = 1
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`IsVisible` IS NULL;');
  PREPARE update_stmt3 FROM @update_xeroblue_journals3;
  EXECUTE update_stmt3;
  DEALLOCATE PREPARE update_stmt3;

  CALL `sp_dynamic_xeroblue_reconciliation`(0, 'JournalsCash', v_clientID, p_orgID, v_OrganisationID);

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_journals`
--
CREATE PROCEDURE sp_dynamic_xeroblue_journals (IN p_clientID varchar(100), IN p_orgID int, IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET SESSION group_concat_max_len = 4294967295;

  -- Replace hardcoded table references with dynamic ones
  SET @journalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_journalsstage');
  SET @finalTable = CONCAT('c', v_clientID, '_xeroblue_journals');
  SET @transTable = CONCAT('c', v_clientID, '_xeroblue_transactions');
  SET @acctsTable = CONCAT('c', v_clientID, '_xeroblue_accounts');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @sql = '';
  WITH missing_columns
  AS
  (SELECT
      'Index' AS column_name,
      'INT NULL AFTER `Id`' AS column_definition
    UNION ALL
    SELECT
      'ACC_ACCPAY',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'Accounts_Class',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PnL_BS',
      'VARCHAR(10) NULL'
    UNION ALL
    SELECT
      'AgedMovement',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'CashReceived',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSpent',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSummary',
      'VARCHAR(100) NULL'
    UNION ALL
    SELECT
      'DetailedBreakdownAccountNames',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'SystemAccount',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set1
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @finalTable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns2
  AS
  (SELECT
      'ContactID' AS column_Name,
      'VARCHAR(255) NULL' AS column_definition
    UNION ALL
    SELECT
      'ContactName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ContactSource',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentSourceID',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentType',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ShowOnCashBasisReports',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'FullyPaidOnDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DayDifference',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PlannedPaymentDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ItemCode',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'Quantity',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'DiscountRate',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'CreditNoteNumber',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'UnitAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'URL',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceNumber',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DueDate',
      'DATE NULL'
    UNION ALL
    SELECT
      'OrganisationName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceTotal',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set2
  FROM missing_columns2 mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @finalTable
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns
  AS
  (SELECT
      'Index' AS column_name,
      'INT NULL AFTER `Id`' AS column_definition
    UNION ALL
    SELECT
      'ACC_ACCPAY',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'Accounts_Class',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PnL_BS',
      'VARCHAR(10) NULL'
    UNION ALL
    SELECT
      'AgedMovement',
      'VARCHAR(50) NULL'
    UNION ALL
    SELECT
      'CashReceived',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSpent',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGross',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'DebitNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditGrossFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CreditNetAmountFX',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'CashSummary',
      'VARCHAR(100) NULL'
    UNION ALL
    SELECT
      'DetailedBreakdownAccountNames',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'SystemAccount',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set3
  FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
      ON ic.TABLE_SCHEMA = DATABASE()
      AND ic.TABLE_NAME = @journalsStage
      AND ic.COLUMN_NAME = mc.column_name
  WHERE ic.COLUMN_NAME IS NULL;

  WITH missing_columns2
  AS
  (SELECT
      'ContactID' AS column_Name,
      'VARCHAR(255) NULL' AS column_definition
    UNION ALL
    SELECT
      'ContactName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ContactSource',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentSourceID',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PaymentType',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ShowOnCashBasisReports',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'FullyPaidOnDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DayDifference',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'PlannedPaymentDate',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'ItemCode',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'Quantity',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'DiscountRate',
      'FLOAT NULL'
    UNION ALL
    SELECT
      'CreditNoteNumber',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'UnitAmount',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'UnitAmount_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_AUD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_USD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_NZD',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_EUR',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'AmountDue_GBP',
      'DECIMAL(30,6) NULL'
    UNION ALL
    SELECT
      'URL',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceNumber',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'DueDate',
      'DATE NULL'
    UNION ALL
    SELECT
      'OrganisationName',
      'VARCHAR(255) NULL'
    UNION ALL
    SELECT
      'InvoiceTotal',
      'VARCHAR(255) NULL')
  SELECT
    GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition, CHAR(10))) INTO @columns_to_add_set4
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
  SET @create_fxtable = CONCAT('CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
                `BaseCurrency` VARCHAR(10),
                `Date` DATE,
                `AUD` DECIMAL(10, 4),
                `USD` DECIMAL(10, 4),
                `NZD` DECIMAL(10, 4),
                `EUR` DECIMAL(10, 4),
                `GBP` DECIMAL(10, 4)
                ,INDEX(BaseCurrency, DATE)
            );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt0 FROM @insert_fxtable;
  EXECUTE stmt0;
  DEALLOCATE PREPARE stmt0;

  SET @updatejournalsStage3 = CONCAT('UPDATE ', @journalsStage, ' AS jrnl
        LEFT JOIN c', v_clientID, '_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
            AND fx.`Date` = 
                CASE 
                    WHEN jrnl.`JournalDate` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
                    WHEN jrnl.`JournalDate` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
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
  CONCAT('UPDATE ', @journalsStage, ' J
        LEFT JOIN ', @transTable, ' T
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
            AND j.`JournalLine_AccountCode` = t.`AccountCode`
            AND ABS(j.`JournalLine_NetAmount`) = ABS(t.`LineAmount`)
        LEFT JOIN ', @acctsTable, ' acc
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
            J.`InvoiceTotal` = CASE WHEN t.Source = ''INVOICES'' THEN t.`Total` ELSE NULL END');

  PREPARE updtrn_stmt FROM @update_from_trans_sql;
  EXECUTE updtrn_stmt;
  DEALLOCATE PREPARE updtrn_stmt;

  -- init batching vars
  SET @ffset = 0;
  SET @rowcount = 1;
  SET @batchsize = 500;



  WHILE @rowcount > 0 DO
    SET @delete_trg = CONCAT('DELETE TRG FROM ', @finalTable, ' TRG
        INNER JOIN (
        SELECT JournalId FROM ', @journalsStage, ' 
        WHERE OrganisationId = ', v_OrganisationID, '
        GROUP BY JournalId
        ORDER BY JournalId  -- Ensures deterministic deletion
        LIMIT ', @batchsize, ' OFFSET ', @ffset, ' 
        ) STG ON TRG.JournalId = STG.JournalId;');
    PREPARE del_stmt FROM @delete_trg;
    EXECUTE del_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE del_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;


  SET @insert_xeroblue_journals = CONCAT('INSERT INTO ', @finalTable, '
        SELECT * FROM ', @journalsStage, ';');

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
        FROM c', v_clientID, '_xeroblue_journals
        WHERE OrganisationId = ', v_OrganisationID, '
    ) subquery
    WHERE row_num > 1
    )
    DELETE FROM c', v_clientID, '_xeroblue_journals 
    WHERE JournalLine_JournalLineId IN (SELECT JournalLine_JournalLineId FROM duplicates)
    AND OrganisationId = ', v_OrganisationID, '
    LIMIT 1;
    ');
    PREPARE dup_stmt FROM @dup_sql;
    EXECUTE dup_stmt;
    SELECT
      ROW_COUNT() INTO @dup_rowcount;
    DEALLOCATE PREPARE dup_stmt;
  END WHILE;

  SET @update_xeroblue_journals1 = CONCAT('UPDATE ', @finalTable, ' `j`
        JOIN c', v_clientID, '_xeroblue_organisationsclients AS `org`  
        ON `org`.`OrganisationID` = `j`.`OrganisationID`
        SET `j`.`OrganisationName` = `org`.`Name`
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`OrganisationName` IS NULL;');
  PREPARE update_stmt1 FROM @update_xeroblue_journals1;
  EXECUTE update_stmt1;
  DEALLOCATE PREPARE update_stmt1;

  SET @update_xeroblue_journals2 = CONCAT('UPDATE ', @finalTable, ' `j`
        JOIN ', @transTable, ' `t`  
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
        SET `j`.`InvoiceTotal` = `t`.`Total`
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`InvoiceTotal` IS NULL
        AND `j`.`ContactSource` = ''INVOICES'';');
  PREPARE update_stmt2 FROM @update_xeroblue_journals2;
  EXECUTE update_stmt2;
  DEALLOCATE PREPARE update_stmt2;

  SET @update_xeroblue_journals3 = CONCAT('UPDATE ', @finalTable, ' j
        SET `j`.`IsVisible` = 1
        WHERE `j`.`OrganisationID` = ', v_OrganisationID, '
        AND `j`.`IsVisible` IS NULL;');
  PREPARE update_stmt3 FROM @update_xeroblue_journals3;
  EXECUTE update_stmt3;
  DEALLOCATE PREPARE update_stmt3;

  CALL `sp_dynamic_xeroblue_reconciliation`(0, 'Journals', v_clientID, p_orgID, v_OrganisationID);
END
$$

--
-- Create procedure `sp_python_package_log`
--
CREATE
DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_python_package_log (IN `job_id` bigint,
IN `jobrun_id` bigint,
IN `datasource` varchar(255),
IN `taskname` varchar(255),
IN `status_message` varchar(255))
BEGIN
  INSERT INTO python_package_log (`JobId`, `JobRunId`, `DataSource`, `TaskName`, `StatusMessage`, `LogTimestamp`)
    VALUES (job_id, jobrun_id, datasource, taskname, status_message, UTC_TIMESTAMP());
END
$$

--
-- Create procedure `sp_dynamic_xpm_transactions`
--
CREATE PROCEDURE sp_dynamic_xpm_transactions (IN `client_id` int,
IN `org_id` int,
IN `legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT org_id;
  DECLARE v_client_id int DEFAULT client_id;
  DECLARE v_legacyClientId int DEFAULT client_id;

  DECLARE v_firmcode varchar(255);

  SET v_OrganisationID = CASE WHEN legacyOrgID <> 0 THEN legacyOrgID ELSE org_id END;

  SELECT
    CAST(REPLACE(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')), v_client_id), '-', '') AS char(10)),
    REPLACE(F.Code, '-', '') INTO v_legacyClientId, v_firmcode
  FROM etaniv2.accounting_firm F
    JOIN etaniv2.`client` C
      ON F.Id = C.AccountingFirm
  WHERE C.Id = v_client_id LIMIT 1;


  -- Drop temporary table if it exists
  SET @tranx_table = CONCAT('transactions', CONNECTION_ID());
  -- SET @_tranx_table = CONCAT('_transactions', CONNECTION_ID());

  SET @drop_temp_tbl = CONCAT('
        DROP TABLE IF EXISTS ', @tranx_table, ';');
  PREPARE drop_stmt FROM @drop_temp_tbl;
  EXECUTE drop_stmt;
  DEALLOCATE PREPARE drop_stmt;


  -- Create temporary table
  SET @create_temp_table = CONCAT('
    CREATE TEMPORARY TABLE IF NOT EXISTS ', @tranx_table, ' (
        `Timesheet ID` INT,
        `Staff ID` INT,
        `Staff` VARCHAR(255),
        `Client Group ID` VARCHAR(255),
        `Group(s)` VARCHAR(255),
        `XPM Client ID` INT,
        `Client` VARCHAR(255),
        `XPM Invoice Client ID` INT,
        `Invoiced Client` VARCHAR(255),
        `Billable` VARCHAR(10),
        `Billable Amount (Totalled)` DECIMAL(18,2),
        `Billable Rate` DECIMAL(18,2),
        `Billed?` VARCHAR(10),
        `Date` DATE,
        `Invoice Number` VARCHAR(255),
        `Invoiced Amount (Totalled)` DECIMAL(18,2),
        `Invoiced Date` DATE,
        `Ledger Type` VARCHAR(50),
        `Quantity` DECIMAL(18,2),
        `Standard Charge Rate` DECIMAL(18,2),
        `Task ID` VARCHAR(255),
        `Task Name` VARCHAR(255),
        `Category` VARCHAR(255),
        `Completed Date` DATE,
        `Due Date` VARCHAR(255),
        `Invoiced` DECIMAL(18,2),
        `Job No.` VARCHAR(255),
        `Name` VARCHAR(255),
        `Start Date` DATE,
        `State` VARCHAR(255),
        `Standard Amount (Totalled)` DECIMAL(18,2),
        `Time` DECIMAL(18,2),
        `Invoiced Time` DECIMAL(18,2),
        `Invoice Due Date` DATE,
        `Invoice Billable Rate` DECIMAL(18,2),
        `Invoice Type` VARCHAR(255),
        `Note` TEXT,
        `Invoice Task ID` INT,
        `Task Completed` VARCHAR(10),
        `Task Bilable` VARCHAR(10),
        `Merged Staff Name Task Name` VARCHAR(255),
        `Billable Without Leave` VARCHAR(255),
        `Client ID` VARCHAR(255),
        `Organisation ID` INT,
        `Hours` DECIMAL(18,2)
    );
    ');

  PREPARE stmt FROM @create_temp_table;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @insert_tranx_wiptask = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT DISTINCT
        Ts.ID AS `Timesheet ID`,
        Ts.`Staff ID` AS `Staff ID`,
        Ts.`Staff Name` AS `Staff`,
        Ts.`Client Group ID` AS `Client Group ID`,
        Ts.`Client Group Name` AS `Group(s)`,
        Ts.`Job Client ID` AS `XPM Client ID`, 
        Ts.`Job Client Name` AS `Client`, 
        COALESCE(ITCB.`XPM Client ID`, Ts.`Job Client ID`) AS `XPM Invoice Client ID`,
        COALESCE(ITCB.`XPM Client Name`, Ts.`Job Client Name`) AS `Invoiced Client`,
        COALESCE(W.Ledger_Billable, IF(Ts.`Billable` = 1, ''Yes'', ''No'')) AS `Billable`,
        IF(W.Ledger_Billable = ''YES'' OR Ts.`Billable` = 1, 
        IFNULL(
                (CAST(Ts.`Minutes` AS DECIMAL(18,2)) / 60) * 
                CASE 
                    WHEN W.Ledger_Billable_Rate IS NOT NULL AND TRIM(W.Ledger_Billable_Rate) != '''' 
                        THEN CAST(REPLACE(W.Ledger_Billable_Rate, '','', '''') AS DECIMAL(18,2))
                    WHEN staff.StaffHistoricalRate IS NOT NULL AND TRIM(staff.StaffHistoricalRate) != '''' 
                        THEN CAST(REPLACE(staff.StaffHistoricalRate, '','', '''') AS DECIMAL(18,2))
                    WHEN staff.StaffRate IS NOT NULL AND TRIM(staff.StaffRate) != '''' 
                        THEN CAST(REPLACE(staff.StaffRate, '','', '''') AS DECIMAL(18,2))
                    ELSE 0
                END, 
                0
            ),
        0) AS `Billable Amount (Totalled)`,
        CASE 
            WHEN W.Ledger_Billable_Rate IS NULL OR TRIM(W.Ledger_Billable_Rate) = '''' THEN NULL
            ELSE CAST(REPLACE(W.Ledger_Billable_Rate, '','', '''') AS DECIMAL(18,2))
        END AS `Billable Rate`,
        IF(Ts.`Invoice Task ID` IS NOT NULL AND ITCB.`TASK ARRAY ID` IS NOT NULL, ''Yes'',
            IF(W.`Ledger_Invoiced_Amount_Totalled` IS NOT NULL, ''Yes'', ''No'')) AS `Billed?`,
        CAST(Ts.`Date` AS DATE) AS `Date`,
        IF(Ts.`Invoice Task ID` IS NOT NULL AND ITCB.`TASK ARRAY ID` IS NOT NULL, ITCB.ID,
            IF(W.`Ledger_Invoiced_Amount_Totalled` IS NOT NULL, CAST(W.`Ledger_Invoice_Number` AS CHAR(255)), NULL)) AS `Invoice Number`,
        IF(W.Ledger_Invoiced_Amount_Totalled IS NOT NULL, 
            CAST(REPLACE(W.Ledger_Invoiced_Amount_Totalled, '','', '''') AS DECIMAL(18,2)) / TsCount.TsCount,
            IF(Ts.`Job Completed Date` IS NOT NULL, 0, NULL)) AS `Invoiced Amount (Totalled)`,
        IF(Ts.`Invoice Task ID` IS NOT NULL AND ITCB.`TASK ARRAY ID` IS NOT NULL, CAST(ITCB.`Date` AS DATE),
            IF(W.`Ledger_Invoiced_Date` IS NOT NULL, CAST(W.`Ledger_Invoiced_Date` AS DATE), NULL)) AS `Invoiced Date`,
        ''time'' AS `Ledger Type`,
        NULL AS `Quantity`,
        IFNULL(W.Ledger_Standard_Rate, 0) AS `Standard Charge Rate`,
        Ts.`Task ID` AS `Task ID`,
        Ts.`Task Name` AS `Task Name`,
        CAST(W.Ledger_Job_Category AS CHAR(255)) AS `Category`,
        CAST(Ts.`Job Completed Date` AS DATE) AS `Completed Date`,
        CAST(Ts.`Job Due Date` AS DATE) AS `Due Date`,
        IFNULL(CAST(REPLACE(IJT.TotalTaskArrayAmount, '','', '''') AS DECIMAL(18,2)), NULL) AS `Invoiced`,
        Ts.`Job ID` AS `Job No.`,
        CAST(Ts.`Job Name` AS CHAR(255)) AS `Name`,
        CAST(Ts.`Job Start Date` AS DATE) AS `Start Date`,
        Ts.`Job State` AS `State`,
        IF(W.Ledger_Standard_Rate IS NOT NULL, 
        (CAST(Ts.`Minutes` AS DECIMAL(18,2)) / 60) * 
        CAST(NULLIF(REPLACE(W.Ledger_Standard_Rate, '','', ''''), '''') AS DECIMAL(18,2)),
        IF(W.Ledger_Billable_Rate IS NOT NULL,
        (CAST(Ts.`Minutes` AS DECIMAL(18,2)) / 60) * 
        CAST(NULLIF(REPLACE(W.Ledger_Billable_Rate, '','', ''''), '''') AS DECIMAL(18,2)),
        0
        )
        ) AS `Standard Amount (Totalled)`,
        Ts.`Minutes` AS `Time`,
        IFNULL(ITCB.`TASK ARRAY Minutes`, Ts.`Minutes`) AS `Invoiced Time`,
        CAST(ITCB.`Due Date` AS DATE) AS `Invoice Due Date`,
        CAST(NULLIF(REPLACE(ITCB.`TASK ARRAY Billable Rate`, '','', ''''), '''') AS DECIMAL(18,2)) AS `Invoice Billable Rate`,
        ITCB.`Type` AS `Invoice Type`,
        Ts.`Note` AS `Note`,
        Ts.`Invoice Task ID` AS `Invoice Task ID`,
        Ts.`Task Completed` AS `Task Completed`,
        Ts.`Task Bilable` AS `Task Bilable`,
        CONCAT(Ts.`Staff Name`, ''-'', Ts.`Task Name`) AS `Merged Staff Name Task Name`,
        CASE 
            WHEN Ts.`Task Name` LIKE ''%Leave%'' OR Ts.`Task Name` LIKE ''%Public Holiday%'' OR Ts.`Task Name` LIKE ''%Internal%'' OR Ts.`Job Name` LIKE ''%Capacity Reducing%'' THEN ''NA''
            WHEN Ts.Billable = 1 THEN ''Billable''
            WHEN Ts.Billable = 0 THEN ''Internal''
            ELSE ''UNKNOWN''
        END AS `Billable Without Leave`,
        Ts.`Client ID` AS `Client ID`,
        Ts.`Organisation ID` AS `Organisation ID`,
        CAST(Ts.`Minutes` AS DECIMAL(18,2)) / 60 AS `Hours`
    FROM `c', v_client_id, '_xpm_timesheetsWIPtask` Ts
    LEFT JOIN `c', v_client_id, '_xpm_WIPcleared` W
        ON W.OrganisationID = Ts.`Organisation ID`
        AND W.Ledger_Staff = Ts.`Staff Name`
        AND W.Ledger_Date = Ts.`Date`
        AND W.Job_Job_No = Ts.`Job ID`
        AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(IFNULL(W.Ledger_Note, ''''), CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'',''''),''N/A'','''') =
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Ts.Note, CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'', ''''),''N/A'','''')
        AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(W.`Ledger_Description`, CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'','''') =
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Ts.`Task Name`, CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'', '''')
        AND Ts.Minutes = CASE
            WHEN LOCATE('':'', W.Ledger_Time) >= 1 
            THEN CAST(SUBSTRING(W.Ledger_Time, 1, LOCATE('':'',W.Ledger_Time) - 1) AS DECIMAL(18,2)) * 60
                + CAST(SUBSTRING(W.Ledger_Time, LOCATE('':'', W.Ledger_Time) + 1, LENGTH(W.Ledger_Time)) AS DECIMAL(18,2))
            WHEN LOCATE(''.'', W.Ledger_Time) >= 1 THEN CAST(W.Ledger_Time AS DECIMAL(18,2)) * 60
            END
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invoicetaskcostbreakdown` ITCB 
        ON Ts.`Organisation ID` = ITCB.`Organisation ID` AND Ts.`Invoice Task ID` = ITCB.`TASK ARRAY ID`
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invTaskJobID_mins_amt` IJT
        ON Ts.`Job ID` = IJT.JobID AND Ts.`Organisation ID` = IJT.OrganisationID
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_timesheetstaffrates` staff
        ON staff.OrganisationID = Ts.`Organisation ID`
        AND staff.TimesheetID = Ts.`ID`
    LEFT JOIN (
        SELECT `Job ID`, `Task ID`, `Staff ID`, `Staff Name`, `Date`,
                `Minutes`, `Note`, `Organisation ID`, COUNT(*) AS TsCount
        FROM `c', v_client_id, '_xpm_timesheetsWIPtask`
        GROUP BY `Job ID`, `Task ID`, `Staff ID`, `Staff Name`, `Date`, `Minutes`, `Note`, `Organisation ID`
    ) TsCount ON TsCount.`Organisation ID` = Ts.`Organisation ID`
        AND TsCount.`Job ID` = Ts.`Job ID`
        AND TsCount.`Task ID` = Ts.`Task ID`
        AND TsCount.`Staff ID` = Ts.`Staff ID`
        AND TsCount.`Date` = Ts.`Date`
        AND TsCount.`Minutes` = Ts.`Minutes`
        AND TsCount.`Note` = Ts.`Note`
    WHERE Ts.`Staff ID` NOT IN (111111, 222222)
        AND Ts.`Organisation ID` = ''', v_OrganisationID, ''';
    ');


  PREPARE stmt1 FROM @insert_tranx_wiptask;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;


  SET @insert_tranx_itcb = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT 
        NULL AS `Timesheet ID`,
        NULL AS `Staff ID`,
        NULL AS `Staff`,
        NULL AS `Client Group ID`,
        NULL AS `Group(s)`,
        ITCB.`XPM Client ID` AS `XPM Client ID`, 
        ITCB.`XPM Client Name` AS `Client`, 
        ITCB.`XPM Client ID` AS `XPM Invoice Client ID`, 
        ITCB.`XPM Client Name` AS `Invoiced Client`, 
        ITCB.`COST ARRAY Billable` AS `Billable`,   
        ITCB.`Cost ARRAY Amount` AS `Billable Amount (Totalled)`,
        NULL AS `Billable Rate`,
        NULL AS `Billed?`,
        ITCB.`Date` AS `Date`,
        CAST(ITCB.`ID` AS CHAR(255)) AS `Invoice Number`,
        CASE 
            WHEN WIPCleared.LedgerInvoicedAmountTotalled IS NOT NULL THEN WIPCleared.LedgerInvoicedAmountTotalled
            WHEN LOCATE(''No Job Cost'', ITCB.`Source`) > 0 THEN ITCB.`COST ARRAY Amount`
            ELSE ITCB.`COST ARRAY Amount`
        END AS `Invoiced Amount (Totalled)`,
        CASE 
            WHEN WIPCleared.LedgerInvoicedDate IS NOT NULL THEN WIPCleared.LedgerInvoicedDate 
            WHEN LOCATE(''No Job Cost'', ITCB.`Source`) > 0 THEN ITCB.`Date`
            ELSE ITCB.`Date`
        END AS `Invoiced Date`,
        ''Miscellaneous'' AS `Ledger Type`,
        ITCB.`COST ARRAY Quantity` AS `Quantity`,
        NULL AS `Standard Charge Rate`,
        NULL AS `Task ID`,
        NULL AS `Task Name`,
        NULL AS `Category`,
        NULL AS `Completed Date`,
        NULL AS `Due Date`,
        CAST(ITCB.`Amount` AS DECIMAL(18,2)) AS `Invoiced`,
        ITCB.`JobID` AS `Job No.`,
        CAST(ITCB.`Job Name` AS CHAR(255)) AS `Name`,
        NULL AS `Start Date`,
        NULL AS `State`,
        NULL AS `Standard Amount (Totalled)`,
        NULL AS `Time`,
        NULL AS `Invoiced Time`,
        ITCB.`Due Date` AS `Invoice Due Date`,
        NULL AS `Invoice Billable Rate`,
        ITCB.`Type` AS `Invoice Type`,
        ITCB.`COST ARRAY Note` AS `Note`, 
        NULL AS `Invoice Task ID`,
        NULL AS `Task Completed`,
        NULL AS `Task Bilable`,
        NULL AS `Merged Staff Name Task Name`,
        NULL AS `Billable Without Leave`,
        ITCB.`Client ID` AS `Client ID`, 
        ITCB.`Organisation ID` AS `Organisation ID`, 
        NULL AS `Hours`
    FROM evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invoicetaskcostbreakdown` ITCB
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_ledgerinvoicedamounttotalled` WIPCleared 
        ON ITCB.ID = WIPCleared.InvoiceID 
        AND ITCB.JobID = WIPCleared.JobID 
        AND ITCB.`Organisation ID` = WIPCleared.`OrganisationID`
    WHERE 
        ITCB.JobId IS NULL
        AND ITCB.`Organisation ID` = ', v_OrganisationID, ';
    ');

  PREPARE stmt2 FROM @insert_tranx_itcb;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


  SET @insert_tranx_disbursements = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT 
        NULL AS `Timesheet ID`,
        NULL AS `Staff ID`,
        NULL AS `Staff`,
        NULL AS `Client Group ID`,
        NULL AS `Group(s)`,
        JI.`Jobs Job Client ID` AS `XPM Client ID`,
        JI.`Jobs Job Client Name` AS `Client`,
        JI.`Jobs Job Client ID` AS `XPM Invoice Client ID`,
        JI.`Jobs Job Client Name` AS `Invoiced Client`,
        W.Ledger_Billable AS `Billable`,
        CAST(NULLIF(REPLACE(COALESCE(W.Ledger_Billable_Amount_Totalled, ''0''), '','', ''''), '''') AS DECIMAL(18,2)) AS `Billable Amount (Totalled)`,
        CAST(NULLIF(REPLACE(COALESCE(W.Ledger_Billable_Rate, ''0''), '','', ''''), '''') AS DECIMAL(18,2)) AS `Billable Rate`,
        W.Ledger_Billable AS `Billed?`,
        W.Ledger_Date AS `Date`,
        CAST(W.Ledger_Invoice_Number AS CHAR(255)) AS `Invoice Number`,
        CAST(NULLIF(REPLACE(COALESCE(W.Ledger_Invoiced_Amount_Totalled, ''0''), '','', ''''), '''') AS DECIMAL(18,2)) AS `Invoiced Amount (Totalled)`,        
        W.Ledger_Invoiced_Date AS `Invoiced Date`,
        ''disbursement'' AS `Ledger Type`,
        ''1.00'' AS `Quantity`,
        CAST(REPLACE(COALESCE(W.Ledger_Billable_Amount_Totalled, ''0''), '','', '''') AS DECIMAL(18,2)) AS `Standard Charge Rate`,
        NULL AS `Task ID`,
        NULL AS `Task Name`,
        CAST(W.Ledger_Job_Category AS CHAR(255)) AS `Category`,
        NULL AS `Completed Date`,
        NULL AS `Due Date`,
        CASE
        WHEN IJT.TotalTaskArrayAmount IS NULL OR TRIM(IJT.TotalTaskArrayAmount) = '''' THEN NULL
        ELSE CAST(REPLACE(IJT.TotalTaskArrayAmount, '','', '''') AS DECIMAL(18,2))
        END AS `Invoiced`,
        W.Job_Job_No AS `Job No.`,
        CAST(JI.`Jobs Job Name` AS CHAR(255)) AS `Name`,
        NULL AS `Start Date`,
        JI.`Jobs Job State` AS `State`,
        CAST(REPLACE(COALESCE(W.Ledger_Billable_Amount_Totalled, ''0''), '','', '''') AS DECIMAL(18,2))  AS `Standard Amount (Totalled)`,
        NULL AS `Time`,
        NULL AS `Invoiced Time`,
        NULL AS `Invoice Due Date`,
        NULL AS `Invoice Billable Rate`,
        NULL AS `Invoice Type`,
        CONCAT(COALESCE(W.`Ledger_Note`, ''''), ''-'', W.`Ledger_Description`) AS `Note`, 
        NULL AS `Invoice Task ID`,
        NULL AS `Task Completed`,
        NULL AS `Task Bilable`,
        NULL AS `Merged Staff Name Task Name`,
        NULL AS `Billable Without Leave`,
        W.ClientID AS `Client ID`, 
        W.`OrganisationID` AS `Organisation ID`,
        NULL AS `Hours`
    FROM `c', v_client_id, '_xpm_WIPcleared` W
    JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_jobsInterim` JI 
        ON W.Job_Job_No = JI.`jobs job id` 
        AND W.OrganisationID = JI.`Organisation ID`
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invTaskJobID_mins_amt` IJT
        ON W.Job_Job_No = IJT.JobID AND W.OrganisationID = IJT.OrganisationID
    WHERE W.Ledger_Ledger_Type = ''disbursement'' AND W.OrganisationID = ', v_OrganisationID, ';
    ');

  PREPARE stmt3 FROM @insert_tranx_disbursements;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;

  SET @insert_tranx_addl_disbursements = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT
        NULL AS `Timesheet ID`,
        NULL AS `Staff ID`,
        NULL AS `Staff`,
        NULL AS `Client Group ID`,
        NULL AS `Group(s)`,
        J.`Jobs Job Client ID` AS `XPM Client ID`,
        J.`Jobs Job Client Name` AS `Client`,
        J.`Jobs Job Client ID` AS `XPM Invoice Client ID`,
        J.`Jobs Job Client Name` AS `Invoiced Client`,
        W.Ledger_Billable AS `Billable`,
        NULL AS `Billable Amount (Totalled)`,
        NULL AS `Billable Rate`,
        W.Ledger_Billable AS `Billed?`,
        W.Ledger_Date AS `Date`,
        CAST(W.Ledger_Invoice_Number AS CHAR(255)) AS `Invoice Number`,
        CAST(IFNULL(REPLACE(W.Ledger_Invoiced_Amount_Totalled, '','', ''''), 0) AS DECIMAL(18,2)) AS `Invoiced Amount (Totalled)`,
        W.Ledger_Invoiced_Date AS `Invoiced Date`,
        ''additional disbursement'' AS `Ledger Type`,
        NULL AS `Quantity`,
        NULL AS `Standard Charge Rate`,
        NULL AS `Task ID`,
        NULL AS `Task Name`,
        CAST(W.Ledger_Job_Category AS CHAR(255)) AS `Category`,
        J.`Jobs Job Completed Date` AS `Completed Date`,
        J.`Jobs Job Due Date` AS `Due Date`,
        CASE
        WHEN IJT.TotalTaskArrayAmount IS NULL OR TRIM(IJT.TotalTaskArrayAmount) = '''' THEN NULL
        ELSE CAST(REPLACE(IJT.TotalTaskArrayAmount, '','', '''') AS DECIMAL(18,2))
        END AS `Invoiced`,
        W.Job_Job_No AS `Job No.`,
        CAST(W.Job_Name AS CHAR(255)) AS `Name`,
        NULL AS `Start Date`,
        J.`Jobs Job State` AS `State`,
        NULL AS `Standard Amount (Totalled)`,
        NULL AS `Time`,
        NULL AS `Invoiced Time`,
        J.`Jobs Job Due Date` AS `Invoice Due Date`,
        NULL AS `Invoice Billable Rate`,
        NULL AS `Invoice Type`,
        W.Ledger_Note AS `Note`,
        NULL AS `Invoice Task ID`,
        NULL AS `Task Completed`,
        NULL AS `Task Bilable`,
        NULL AS `Merged Staff Name Task Name`,
        NULL AS `Billable Without Leave`,
        W.`ClientID` AS `Client ID`,
        W.`OrganisationID` AS `Organisation ID`,
        NULL AS `Hours`
    FROM `c', v_client_id, '_xpm_WIPcleared` W
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_jobsInterim` J
        ON J.`Jobs Job ID` = W.Job_Job_No AND J.`Organisation ID` = W.OrganisationID
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invTaskJobID_mins_amt` IJT
        ON W.Job_Job_No = IJT.JobID AND W.OrganisationID = IJT.OrganisationID
    WHERE W.Ledger_Ledger_Type = ''additional disbursement''
        AND W.OrganisationID = ', v_OrganisationID, ';
    ');

  PREPARE stmt4 FROM @insert_tranx_addl_disbursements;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;

  SET @insert_tranx_addl_time = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT
        NULL AS `Timesheet ID`,
        NULL AS `Staff ID`,
        NULL AS `Staff`,
        NULL AS `Client Group ID`,
        NULL AS `Group(s)`,
        ITCB.`XPM Client ID` AS `XPM Client ID`,
        ITCB.`XPM Client Name` AS `Client`,
        ITCB.`XPM Client ID` AS `XPM Invoice Client ID`,
        ITCB.`XPM Client Name` AS `Invoiced Client`,
        ITCB.`TASK ARRAY Billable` AS `Billable`,
        CAST(NULLIF(REPLACE(COALESCE(W.Ledger_Billable_Amount_Totalled, ''0''), '','', ''''), '''') AS DECIMAL(18,2)) AS `Billable Amount (Totalled)`,
        CAST(NULLIF(REPLACE(COALESCE(W.`Ledger_Billable_Rate`, ''0''), '','', ''''), '''') AS DECIMAL(18,2)) AS `Billable Rate`,
        ITCB.`TASK ARRAY BILLABLE` AS `Billed?`,
        CAST(ITCB.`Date` AS DATE) AS `Date`,
        CAST(ITCB.`ID` AS CHAR(255)) AS `Invoice Number`,
        CAST(ITCB.`TASK ARRAY Amount` AS DECIMAL(18,2)) AS `Invoiced Amount (Totalled)`,
        CAST(ITCB.`Date` AS DATE) AS `Invoiced Date`,
        ''additional time'' AS `Ledger Type`,
        CAST(NULL AS DECIMAL(18,2)) AS `Quantity`,
        CAST(NULL AS DECIMAL(18,2)) AS `Standard Charge Rate`,
        NULL AS `Task ID`,
        NULL AS `Task Name`,
        CAST(W.Ledger_Job_Category AS CHAR(255)) AS `Category`,
        CAST(J.`Jobs Job Completed Date` AS DATE) AS `Completed Date`,
        CAST(J.`Jobs Job Due Date` AS DATE) AS `Due Date`,
        CAST(ITCB.`Amount` AS DECIMAL(18,2)) AS `Invoiced`,
        ITCB.`JobID` AS `Job No.`,
        CAST(ITCB.`Job Name` AS CHAR(255)) AS `Name`,
        NULL AS `Start Date`,
        J.`Jobs Job State` AS `State`,
        CAST(NULL AS DECIMAL(18,2)) AS `Standard Amount (Totalled)`,
        NULL AS `Time`,
        NULL AS `Invoiced Time`,
        CAST(ITCB.`Due Date` AS DATE) AS `Invoice Due Date`,
        CAST(NULL AS DECIMAL(18,2)) AS `Invoice Billable Rate`,
        ITCB.`Type` AS `Invoice Type`,
        ITCB.`COST ARRAY Note` AS `Note`,
        NULL AS `Invoice Task ID`,
        NULL AS `Task Completed`,
        NULL AS `Task Bilable`,
        NULL AS `Merged Staff Name Task Name`,
        NULL AS `Billable Without Leave`,
        ITCB.`Client ID` AS `Client ID`,
        ITCB.`Organisation ID` AS `Organisation ID`,
        NULL AS `Hours`
    FROM `c', v_client_id, '_xpm_WIPcleared` W
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invoicetaskcostbreakdown` ITCB
        ON W.Job_Job_No = ITCB.JobID
        AND W.Ledger_Invoice_Number = ITCB.ID
        AND W.OrganisationID = ITCB.`Organisation ID`
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_jobsInterim` J
        ON J.`Jobs Job ID` = ITCB.JobID
        AND J.`Organisation ID` = ITCB.`Organisation ID`
    LEFT JOIN `c', v_client_id, '_xpm_timesheetsWIPtask` TS
        ON TS.`Invoice Task ID` = ITCB.`TASK ARRAY ID`
        AND TS.`Organisation ID` = ITCB.`Organisation ID`
    WHERE W.Ledger_Ledger_Type = ''additional time''
        AND ITCB.Status <> ''Cancelled''
        AND ITCB.`Task Array ID` IS NOT NULL
        AND TS.`Invoice Task ID` IS NULL
        AND W.OrganisationID = ', v_OrganisationID, ';
    ');

  PREPARE stmt5 FROM @insert_tranx_addl_time;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;

  SET @insert_tranx_interim = CONCAT('
    INSERT INTO ', @tranx_table, '
    SELECT
        NULL AS `Timesheet ID`,
        NULL AS `Staff ID`,
        NULL AS `Staff`,
        NULL AS `Client Group ID`,
        NULL AS `Group(s)`,
        ITCB.`XPM Client ID` AS `XPM Client ID`,
        ITCB.`XPM Client Name` AS `Client`,
        ITCB.`XPM Client ID` AS `XPM Invoice Client ID`,
        ITCB.`XPM Client Name` AS `Invoiced Client`,
        W.`Ledger_Billable` AS `Billable`,
        CAST(IFNULL(REPLACE(IFNULL(W.`Ledger_Invoiced_Amount_Totalled`, W.`Ledger_Billable_Amount_Totalled`), '','', ''''), 0) AS DECIMAL(18,2)) AS `Billable Amount (Totalled)`,
        ABS(CAST(IFNULL(REPLACE(IFNULL(W.`Ledger_Invoiced_Amount_Totalled`, W.`Ledger_Billable_Amount_Totalled`), '','', ''''), 0) AS DECIMAL(18,2))) AS `Billable Rate`,
        W.`Ledger_Billable` AS `Billed?`,
        W.`Ledger_Date` AS `Date`,
        CAST(W.`Ledger_Invoice_Number` AS CHAR(255)) AS `Invoice Number`,
        CAST(IFNULL(REPLACE(W.`Ledger_Invoiced_Amount_Totalled`, '','', ''''), 0) AS DECIMAL(18,2)) AS `Invoiced Amount (Totalled)`,
        W.`Ledger_invoiced_date` AS `Invoiced Date`,
        ''interim'' AS `Ledger Type`,
        NULL AS `Quantity`,
        NULL AS `Standard Charge Rate`,
        NULL AS `Task ID`,
        NULL AS `Task Name`,
        CAST(W.`Ledger_Job_Category` AS CHAR(255)) AS `Category`,
        J.`Jobs Job Completed Date` AS `Completed Date`,
        J.`Jobs Job Due Date` AS `Due Date`,
        CAST(NULLIF(REPLACE(IJT.`TotalTaskArrayAmount`, '','', ''''), '''') AS DECIMAL(18,2)) AS `Invoiced`,
        W.`Job_Job_No` AS `Job No.`,
        CAST(W.`Job_Name` AS CHAR(255)) AS `Name`,
        NULL AS `Start Date`,
        ITCB.`Status` AS `State`,
        CAST(IFNULL(REPLACE(W.`Ledger_Invoiced_Amount_Totalled`, '','', ''''), 0) AS DECIMAL(18,2)) AS `Standard Amount (Totalled)`,
        NULL AS `Time`,
        NULL AS `Invoiced Time`,
        J.`Jobs Job Due Date` AS `Invoice Due Date`,
        NULL AS `Invoice Billable Rate`,
        ITCB.`Type` AS `Invoice Type`,
        IFNULL(W.`Ledger_Note`, '''') AS `Note`,
        NULL AS `Invoice Task ID`,
        NULL AS `Task Completed`,
        NULL AS `Task Bilable`,
        NULL AS `Merged Staff Name Task Name`,
        NULL AS `Billable Without Leave`,
        W.`ClientID` AS `Client ID`,
        W.`OrganisationID` AS `Organisation ID`,
        NULL AS `Hours`
    FROM `c', v_client_id, '_xpm_WIPcleared` W
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_jobsInterim` J
        ON J.`Jobs Job ID` = W.`Job_Job_No` 
        AND J.`Organisation ID` = W.`OrganisationID`
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invTaskJobID_mins_amt` IJT
        ON W.`Job_Job_No` = IJT.`JobID` 
        AND W.`OrganisationID` = IJT.`OrganisationID`
    LEFT JOIN evadb.`', v_firmcode, '_CLIENT', v_legacyClientId, '_XPM_invoicetaskcostbreakdown` ITCB
    ON ITCB.`JobID` = W.`Job_Job_No`
    AND ITCB.`Date` = W.`Ledger_Date`
    AND IFNULL(ITCB.`COST ARRAY Billable`, ITCB.`Task Array Billable`) = W.`Ledger_Billable`
    AND ITCB.`Organisation ID` = W.`OrganisationID`
    AND IFNULL(ITCB.`COST ARRAY Amount`, ITCB.`Task Array Amount`) = 
        CASE
            WHEN W.`Ledger_Invoiced_Amount_Totalled` IS NOT NULL AND W.`Ledger_Invoiced_Amount_Totalled` != '''' 
                THEN ABS(CAST(REPLACE(W.`Ledger_Invoiced_Amount_Totalled`, '','', '''') AS DECIMAL(18,2)))
            WHEN W.`Ledger_Billable_Amount_Totalled` IS NOT NULL AND W.`Ledger_Billable_Amount_Totalled` != ''''
                THEN ABS(CAST(REPLACE(W.`Ledger_Billable_Amount_Totalled`, '','', '''') AS DECIMAL(18,2)))
            ELSE 0
        END
    AND ITCB.`Status` <> ''Cancelled''
        AND (
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(W.`LEdger_Note` AS CHAR(4000)), CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'','''') =
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(ITCB.`Cost Array Description` AS CHAR(4000)), CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'', '''')
            OR
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(W.`LEdger_Description` AS CHAR(4000)), CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'','''') =
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(ITCB.`Cost Array Description` AS CHAR(4000)), CHAR(13), ''''), CHAR(9), ''''), CHAR(10), ''''), '' '', ''''), ''"'', '''')
            OR LOCATE(ITCB.`Id`, W.`Ledger_Description`) > 0
        )
    WHERE W.`Ledger_Ledger_Type` = ''interim''
        AND W.`OrganisationID` = ', v_OrganisationID, ';
    ');

  PREPARE stmt6 FROM @insert_tranx_interim;
  EXECUTE stmt6;
  DEALLOCATE PREPARE stmt6;

  -- truncatge stage table
  SET @delete_tranx = CONCAT('
    TRUNCATE TABLE `c', v_client_id, '_', org_id, '_xpm_transactionsstage`;
    ');

  PREPARE stmt7 FROM @delete_tranx;
  EXECUTE stmt7;
  DEALLOCATE PREPARE stmt7;

  -- Insert data from temporary table into the stage table
  SET @insert_tranx_stage = CONCAT('
    INSERT INTO `c', v_client_id, '_', org_id, '_xpm_transactionsstage` (
        `Timesheet ID`, `Staff ID`, `Staff`, `Client Group ID`, `Group(s)`, `XPM Client ID`,
        `Client`, `XPM Invoice Client ID`, `Invoiced Client`, `Billable`, `Billable Amount (Totalled)`,
        `Billable Rate`, `Billed?`, `Date`, `Invoice Number`, `Invoiced Amount (Totalled)`, `Invoiced Date`,
        `Ledger Type`, `Quantity`, `Standard Charge Rate`, `Task ID`, `Task Name`, `Category`,
        `Completed Date`, `Due Date`, `Invoiced`, `Job No.`, `Name`, `Start Date`, `State`,
        `Standard Amount (Totalled)`, `Time`, `Invoiced Time`, `Invoice Due Date`, `Invoice Billable Rate`,
        `Invoice Type`, `Note`, `Invoice Task ID`, `Task Completed`, `Task Bilable`,
        `Merged Staff Name Task Name`, `Billable Without Leave`, `Client ID`, `Organisation ID`, `Hours`
    )
    SELECT * FROM ', @tranx_table, ';
    ');

  PREPARE stmt8 FROM @insert_tranx_stage;
  EXECUTE stmt8;
  DEALLOCATE PREPARE stmt8;

  -- update value for additional columns in stage table
  SET @update_tranx_stage = CONCAT('
    UPDATE `c', v_client_id, '_', org_id, '_xpm_transactionsstage` t
    LEFT JOIN `c', v_client_id, '_xpm_tasksdetail` j 
        ON t.`Job No.` = j.`P_Response.Jobs.Job_ID`
        AND t.`Organisation ID` = j.`OrganisationID`
    LEFT JOIN `c', v_client_id, '_xpm_clients` Cl 
        ON j.`P_Response.Jobs.Job_Client_ID` = Cl.Id 
        AND j.`OrganisationID` = Cl.`OrganisationID`
    LEFT JOIN `c', v_client_id, '_xpm_CAPACITYDEV` c 
        ON t.`Staff ID` = c.`StaffID` 
        AND t.`Organisation ID` = c.`OrganisationID`
    SET
        t.`job_manager_name` = j.`P_Response.Jobs.Job_Manager_Name`,
        t.`job_partner_name` = j.`P_Response.Jobs.Job_Partner_Name`,
        t.`clients_account_manager_name` = Cl.`AccountManager.Name`,
        t.`clients_job_manager_name` = Cl.`JobManager.Name`,
        t.`team` = NULLIF(c.`Team`, '''')
    WHERE t.`job_manager_name` IS NULL
        OR t.`job_partner_name` IS NULL
        OR t.`clients_account_manager_name` IS NULL
        OR t.`clients_job_manager_name` IS NULL
        OR t.`team` IS NULL
    ');

  PREPARE stmt9 FROM @update_tranx_stage;
  EXECUTE stmt9;
  DEALLOCATE PREPARE stmt9;

  -- Delete existing records from the target table
  SET @delete_tranx = CONCAT('
    DELETE FROM `c', v_client_id, '_xpm_transactions`
    WHERE `Organisation ID` = ', v_OrganisationID, ';
    ');

  PREPARE stmt10 FROM @delete_tranx;
  EXECUTE stmt10;
  DEALLOCATE PREPARE stmt10;

  -- insert data to final table
  SET @insert_tranx_final = CONCAT('
    INSERT INTO `c', v_client_id, '_xpm_transactions`
    SELECT * FROM `c', v_client_id, '_', org_id, '_xpm_transactionsstage`;
    ');

  PREPARE stmt11 FROM @insert_tranx_final;
  EXECUTE stmt11;
  DEALLOCATE PREPARE stmt11;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_transactions_stageonly`
--
CREATE PROCEDURE sp_dynamic_xeroblue_transactions_stageonly (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int,
IN `p_legacyClientId` varchar(255))
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_legacyClientID varchar(255) DEFAULT p_legacyClientId;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  -- Replace hardcoded table references with dynamic ones
  SET @transactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_transactionsstage');
  SET @creditnotesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_creditnotesstage');
  SET @invoicesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_invoicesstage');
  SET @overpaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_overpaymentsstage');
  SET @prepaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_prepaymentsstage');
  SET @manualJournalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_manualjournalsstage');
  SET @banktransactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransactionsstage');
  SET @paymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_paymentsstage');

  SET @transactionsProd = CONCAT('c', v_clientID, '_xeroblue_transactions');
  SET @creditnotesProd = CONCAT('c', v_clientID, '_xeroblue_creditnotes');
  SET @invoicesProd = CONCAT('c', v_clientID, '_xeroblue_invoices');
  SET @overpaymentsProd = CONCAT('c', v_clientID, '_xeroblue_overpayments');
  SET @prepaymentsProd = CONCAT('c', v_clientID, '_xeroblue_prepayments');
  SET @manualJournalsProd = CONCAT('c', v_clientID, '_xeroblue_manualjournals');
  SET @banktransactionsProd = CONCAT('c', v_clientID, '_xeroblue_banktransactions');
  SET @paymentsProd = CONCAT('c', v_clientID, '_xeroblue_payments');

  SET @paymentsIndexCols = 'OrganisationID,InvoiceId,PaymentType';
  SET @invoicesIndexOrgId = 'OrganisationID';
  SET @creditnotesIndexCols = 'CreditNoteId,OrganisationID';
  SET @prepaymentsIndexCols = 'OrganisationID,PrepaymentId';
  SET @overpaymentsIndexCols = 'OrganisationID,OverpaymentId';
  SET @manualJournalsIndexCols = 'OrganisationID';
  SET @banktransactionsIndexCols = 'OrganisationID';

  SELECT
    index_name INTO @paymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_payments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @paymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @invoicesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_invoices%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @invoicesIndexOrgId
  LIMIT 1;

  SELECT
    index_name INTO @creditnotesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_creditnotes%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @creditnotesIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @prepaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_prepayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @prepaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @overpaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_overpayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @overpaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @manualJournalsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_manualjournals%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @manualJournalsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @banktransactionsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_banktransactions%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @banktransactionsIndexCols
  LIMIT 1;


  SET @trunc_table = CONCAT('
        TRUNCATE TABLE ', @transactionsStage, ';
    ');
  PREPARE stmt FROM @trunc_table;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @batchsize = 1000;
  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
                CONCAT(IFNULL(C.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
                C.`HasAttachments` AS `HasAttachments`,
                C.`CreditNoteNumber` AS `CreditNoteNumber`,
                C.`RemainingCredit` AS `RemainingCredit`,
                C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                C.`Reference` AS `Reference`,
                ''CREDITNOTES'' AS `Source`,
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
                CASE WHEN CA.InvoiceId IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
            FROM ', @creditnotesProd, ' C  FORCE INDEX(', @creditnotesIndexName, ') 
            INNER JOIN ', @creditnotesStage, ' CS ON C.`CreditNoteID` = CS.`CreditNoteID`
            LEFT JOIN (
                SELECT DISTINCT
                    `CreditNoteId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `ClientID`,
                    `OrganisationID`
                FROM evadb.', v_legacyClientID, '_xeroblue_creditnoteallocations_aud
                WHERE `OrganisationID` = ', v_OrganisationID, '
            ) CA
                ON C.`CreditNoteID` = CA.`CreditNoteID` 
                AND C.`OrganisationID` = CA.`OrganisationID`
            WHERE c.OrganisationID = ', v_OrganisationID, '
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt1 FROM @insert_intostage;
    EXECUTE stmt1;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt1;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage2 = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
                I.`Id` AS `LineID`,
                I.`InvoiceId` AS `ID`,
                I.`Date` AS `Date`,
                I.`Type` AS `Type`,
                I.`ContactId` AS `ContactID`,
                I.`ContactName` AS `ContactName`,
                I.`LineItem_LineItemId` AS `LineItemID`,
                I.`LineItem_Description` AS `Description`,
                I.`LineItem_Quantity` AS `Quantity`,
                I.`LineItem_UnitAmount` AS `UnitAmount`,
                I.`LineItem_ItemCode` AS `ItemCode`,
                I.`LineItem_AccountCode` AS `AccountCode`,
                I.`LineItem_TaxType` AS `TaxType`,
                I.`LineItem_TaxAmount` AS `TaxAmount`,
                I.`LineItem_LineAmount` AS `LineAmount`,
                I.`LineAmountTypes` AS `LineAmountTypes`,
                I.`Status` AS `Status`,
                I.`SubTotal` AS `SubTotal`,
                I.`TotalTax` AS `TotalTax`,
                I.`Total` AS `Total`,
                I.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                I.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                I.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                I.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                I.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                I.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                I.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                I.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                I.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                I.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                I.`LineItem_DiscountRate` AS `DiscountRate`,
                I.`CurrencyCode` AS `CurrencyCode`,
                CAST(I.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                I.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(I.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(I.`OrganisationID` AS CHAR)) AS `AccountUID`,
                I.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                I.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                I.`Reference` AS `Reference`,
                ''INVOICES'' AS `Source`,
                I.`ClientID` AS `ClientID`,
                I.`OrganisationID` AS `OrganisationID`,
                I.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                I.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                I.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                I.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                I.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                I.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                I.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                I.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                I.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                I.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                I.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                I.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                I.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                I.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                I.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                I.`SubTotal_AUD` AS `SubTotal_AUD`,
                I.`SubTotal_USD` AS `SubTotal_USD`,
                I.`SubTotal_NZD` AS `SubTotal_NZD`,
                I.`SubTotal_EUR` AS `SubTotal_EUR`,
                I.`SubTotal_GBP` AS `SubTotal_GBP`,
                I.`TotalTax_AUD` AS `TotalTax_AUD`,
                I.`TotalTax_USD` AS `TotalTax_USD`,
                I.`TotalTax_NZD` AS `TotalTax_NZD`,
                I.`TotalTax_EUR` AS `TotalTax_EUR`,
                I.`TotalTax_GBP` AS `TotalTax_GBP`,
                I.`Total_AUD` AS `Total_AUD`,
                I.`Total_USD` AS `Total_USD`,
                I.`Total_NZD` AS `Total_NZD`,
                I.`Total_EUR` AS `Total_EUR`,
                I.`Total_GBP` AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                I.`DueDate` AS `DueDate`,
                LEFT(I.`InvoiceNumber`,100) AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User`,
                NULL AS `Details`,
                DATEDIFF(I.`FullyPaidOnDate`, I.`Date`) AS `DayDifference`,
                I.`PlannedPaymentDate` AS `PlannedPaymentDate`,
                I.`AmountDue` AS `AmountDue`,
                I.`AmountDue_AUD` AS `AmountDue_AUD`,
                I.`AmountDue_USD` AS `AmountDue_USD`,
                I.`AmountDue_NZD` AS `AmountDue_NZD`,
                I.`AmountDue_EUR` AS `AmountDue_EUR`,
                I.`AmountDue_GBP` AS `AmountDue_GBP`,
                I.`URL` AS `URL`
            FROM ', @invoicesProd, ' I FORCE INDEX(', @invoicesIndexName, ')
            INNER JOIN ', @invoicesStage, ' INVS ON I.`InvoiceId` = INVS.`InvoiceId`
            WHERE I.`OrganisationID` = ', v_OrganisationID, '
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt2 FROM @insert_intostage2;
    EXECUTE stmt2;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt2;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage3 = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
                CAST(NULLIF(OP.`CurrencyRate`,'''') AS FLOAT) AS `CurrencyRate`,
                OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(OP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                OP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                OP.`RemainingCredit` AS `RemainingCredit`,
                OP.`Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                ''OVERPAYMENTS'' AS `Source`,
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
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
            FROM ', @overpaymentsProd, ' OP FORCE INDEX (', @overpaymentsIndexName, ')
            INNER JOIN ', @overpaymentsStage, ' OPS ON OP.`OverPaymentId` = OPS.`OverPaymentId`
            LEFT JOIN (
                SELECT DISTINCT
                    `OverPaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.', v_legacyClientID, '_xeroblue_overpaymentallocation_aud
                WHERE `Organisation ID` = ', v_OrganisationID, '
            ) OPA 
                ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
                AND OP.`OrganisationID` = OPA.`Organisation ID`
            WHERE OP.`OrganisationID` = ', v_OrganisationID, '
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt3 FROM @insert_intostage3;
    EXECUTE stmt3;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt3;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage4 = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
                NULLIF(PP.`CurrencyRate`,'''') AS `CurrencyRate`,
                PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(PP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                PP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                PP.`RemainingCredit` AS `RemainingCredit`,
                PP.`Date` AS `FullyPaidOnDate`,
                PP.`Reference` AS `Reference`,
                ''PREPAYMENTS'' AS `Source`,
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
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
            FROM ', @prepaymentsProd, ' PP FORCE INDEX (', @prepaymentsIndexName, ')
            INNER JOIN ', @prepaymentsStage, ' PS ON PP.`PrePaymentId` = PS.`PrePaymentId`
            LEFT JOIN (
                SELECT DISTINCT
                    `PrePaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.', v_legacyClientID, '_xeroblue_prepaymentallocation_aud
                WHERE `Organisation ID` = ', v_OrganisationID, '
            ) PPA 
                ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
                AND PP.`OrganisationID` = PPA.`Organisation ID`
            WHERE PP.`OrganisationID` = ', v_OrganisationID, '    
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt4 FROM @insert_intostage4;
    EXECUTE stmt4;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt4;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage5 = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
                MJ.`Id` AS `LineID`,
                MJ.`ManualJournalId` AS `ID`,
                MJ.`Date` AS `Date`,
                NULL AS `Type`,
                NULL AS `ContactID`,
                NULL AS `ContactName`,
                NULL AS `LineItemID`,
                MJ.`JournalLine_Description` AS `Description`,
                NULL AS `Quantity`,
                NULL AS `UnitAmount`,
                NULL AS `ItemCode`,
                MJ.`JournalLine_AccountCode` AS `AccountCode`,
                MJ.`JournalLine_TaxType` AS `TaxType`,
                MJ.`JournalLine_TaxAmount` AS `TaxAmount`,
                MJ.`JournalLine_LineAmount` AS `LineAmount`,
                MJ.`LineAmountTypes` AS `LineAmountTypes`,
                MJ.`Status` AS `Status`,
                NULL AS `SubTotal`,
                NULL AS `TotalTax`,
                NULL AS `Total`,
                MJ.`JournalLine_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                MJ.`JournalLine_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                MJ.`JournalLine_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                MJ.`JournalLine_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                MJ.`JournalLine_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                MJ.`JournalLine_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                MJ.`JournalLine_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                MJ.`JournalLine_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                MJ.`JournalLine_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                MJ.`JournalLine_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                NULL AS `CurrencyCode`,
                NULL AS `CurrencyRate`,
                MJ.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(MJ.`JournalLine_AccountCode`, ''BLANK''), ''-'', CAST(MJ.`OrganisationID` AS CHAR)) AS `AccountUID`,
                MJ.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                MJ.`Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                ''MANUALJOURNALS'' AS `Source`,
                MJ.`ClientID` AS `ClientID`,
                MJ.`OrganisationID` AS `OrganisationID`,
                NULL AS `UnitAmount_AUD`,
                NULL AS `UnitAmount_USD`,
                NULL AS `UnitAmount_NZD`,
                NULL AS `UnitAmount_EUR`,
                NULL AS `UnitAmount_GBP`,
                MJ.`JournalLine_TaxAmount_AUD` AS `TaxAmount_AUD`,
                MJ.`JournalLine_TaxAmount_USD` AS `TaxAmount_USD`,
                MJ.`JournalLine_TaxAmount_NZD` AS `TaxAmount_NZD`,
                MJ.`JournalLine_TaxAmount_EUR` AS `TaxAmount_EUR`,
                MJ.`JournalLine_TaxAmount_GBP` AS `TaxAmount_GBP`,
                MJ.`JournalLine_LineAmount_AUD` AS `LineAmount_AUD`,
                MJ.`JournalLine_LineAmount_USD` AS `LineAmount_USD`,
                MJ.`JournalLine_LineAmount_NZD` AS `LineAmount_NZD`,
                MJ.`JournalLine_LineAmount_EUR` AS `LineAmount_EUR`,
                MJ.`JournalLine_LineAmount_GBP` AS `LineAmount_GBP`,
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
                MJ.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User  `,
                NULL AS `Details`,
                DATEDIFF(MJ.`Date`, MJ.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ', @manualJournalsProd, ' MJ FORCE INDEX (', @manualJournalsIndexName, ')
            INNER JOIN ', @manualJournalsStage, ' MJS ON MJ.`ManualJournalId` = MJS.`ManualJournalId`
            WHERE MJ.`OrganisationID` = ', v_OrganisationID, '
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt5 FROM @insert_intostage5;
    EXECUTE stmt5;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt5;
    SET @ffset = @ffset + @batchsize;

  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage6 = CONCAT('
        INSERT IGNORE INTO ', @transactionsStage, '
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
            BT.`Id` AS `LineID`,
            BT.`BankTransactionId` AS `ID`,
            BT.`Date` AS `Date`,
            BT.`Type` AS `Type`,
            BT.`Contact_ContactId` AS `ContactID`,
            BT.`Contact_ContactName` AS `ContactName`,
            BT.`LineItem_LineItemId` AS `LineItemID`,
            BT.`LineItem_Description` AS `Description`,
            BT.`LineItem_Quantity` AS `Quantity`,
            BT.`LineItem_UnitAmount` AS `UnitAmount`,
            BT.`LineItem_ItemCode` AS `ItemCode`,
            BT.`LineItem_AccountCode` AS `AccountCode`,
            BT.`LineItem_TaxType` AS `TaxType`,
            BT.`LineItem_TaxAmount` AS `TaxAmount`,
            BT.`LineItem_LineAmount` AS `LineAmount`,
            BT.`LineAmountTypes` AS `LineAmountTypes`,
            BT.`Status` AS `Status`,
            BT.`SubTotal` AS `SubTotal`,
            BT.`TotalTax` AS `TotalTax`,
            BT.`Total` AS `Total`,
            BT.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
            BT.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
            BT.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
            BT.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
            BT.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
            BT.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
            BT.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
            BT.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
            BT.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
            BT.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
            NULL AS `DiscountRate`,
            BT.`CurrencyCode` AS `CurrencyCode`,
            CAST(BT.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
            BT.`UpdatedDateUTC` AS `UpdatedDateUTC`,
            CONCAT(IFNULL(BT.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(BT.`OrganisationID` AS CHAR)) AS `AccountUID`,
            BT.`HasAttachments` AS `HasAttachments`,
            NULL AS `CreditNoteNumber`,
            NULL AS `RemainingCredit`,
            BT.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            BT.`Reference` AS `Reference`,
            ''BANKTRANSACTIONS'' AS `Source`,
            BT.`ClientID` AS `ClientID`,
            BT.`OrganisationID` AS `OrganisationID`,
            BT.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
            BT.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
            BT.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
            BT.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
            BT.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
            BT.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
            BT.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
            BT.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
            BT.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
            BT.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
            BT.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
            BT.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
            BT.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
            BT.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
            BT.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
            BT.`SubTotal_AUD` AS `SubTotal_AUD`,
            BT.`SubTotal_USD` AS `SubTotal_USD`,
            BT.`SubTotal_NZD` AS `SubTotal_NZD`,
            BT.`SubTotal_EUR` AS `SubTotal_EUR`,
            BT.`SubTotal_GBP` AS `SubTotal_GBP`,
            BT.`TotalTax_AUD` AS `TotalTax_AUD`,
            BT.`TotalTax_USD` AS `TotalTax_USD`,
            BT.`TotalTax_NZD` AS `TotalTax_NZD`,
            BT.`TotalTax_EUR` AS `TotalTax_EUR`,
            BT.`TotalTax_GBP` AS `TotalTax_GBP`,
            BT.`Total_AUD` AS `Total_AUD`,
            BT.`Total_USD` AS `Total_USD`,
            BT.`Total_NZD` AS `Total_NZD`,
            BT.`Total_EUR` AS `Total_EUR`,
            BT.`Total_GBP` AS `Total_GBP`,
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
            DATEDIFF(BT.`Date`, BT.`FullyPaidOnDate`) AS `DayDifference`,
            NULL AS `PlannedPaymentDate`,
            NULL AS `AmountDue`,
            NULL AS `AmountDue_AUD`,
            NULL AS `AmountDue_USD`,
            NULL AS `AmountDue_NZD`,
            NULL AS `AmountDue_EUR`,
            NULL AS `AmountDue_GBP`,
            NULL AS `URL`
        FROM ', @banktransactionsProd, ' BT FORCE INDEX (', @banktransactionsIndexName, ')
        INNER JOIN ', @banktransactionsStage, ' BTS ON BT.`BankTransactionId` = BTS.`BankTransactionId`
        WHERE BT.`OrganisationID` = ', v_OrganisationID, '
        LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');
    PREPARE stmt6 FROM @insert_intostage6;
    EXECUTE stmt6;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt6;
    SET @ffset = @ffset + @batchsize;

  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage7 = CONCAT('
            INSERT IGNORE INTO ', @transactionsStage, '
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
            SELECT  DISTINCT
                P.`PaymentId` AS `LineID`,
                P.`PaymentId` AS `ID`,
                P.`Date` AS `Date`,
                P.`PaymentType` AS `Type`,
                X.ContactId as `ContactID`,
                X.ContactName AS `ContactName`,
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
                CASE WHEN P.`CurrencyRate` LIKE ''%E%'' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION(''E'' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
                P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(P.`AccountCode`, ''BLANK''), ''-'', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
                NULL AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                P.`Date` AS `FullyPaidOnDate`,
                P.`Reference` AS `Reference`,
                ''PAYMENTS'' AS `Source`,
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
                X.Type AS `PaymentSourceType`,
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
            FROM ', @paymentsProd, ' P FORCE INDEX (', @paymentsIndexName, ')
            INNER JOIN ', @paymentsStage, ' PS ON P.`PaymentId` = PS.`PaymentId`
            JOIN (
                SELECT OrganisationId, ''INVOICES'' AS Type, InvoiceId AS PaymentSourceID, ContactId, ContactName 
                FROM c', v_clientID, '_xeroblue_invoices  FORCE INDEX(', @invoicesIndexName, ') 
                WHERE OrganisationId =  ', v_OrganisationID, ' 
                UNION ALL
                SELECT OrganisationId, ''CREDITNOTES'' AS Type, CreditNoteID AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c', v_clientID, '_xeroblue_creditnotes FORCE INDEX(', @creditnotesIndexName, ')
                WHERE OrganisationId =  ', v_OrganisationID, ' 
                UNION ALL
                SELECT OrganisationId, ''PREPAYMENTS'' AS Type, PrepaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c', v_clientID, '_xeroblue_prepayments FORCE INDEX(', @prepaymentsIndexName, ')
                WHERE OrganisationId =  ', v_OrganisationID, ' 
                UNION ALL
                SELECT OrganisationId, ''OVERPAYMENTS'' AS Type, OverpaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c', v_clientID, '_xeroblue_overpayments FORCE INDEX(', @overpaymentsIndexName, ')
                WHERE OrganisationId =  ', v_OrganisationID, ' 
            ) AS X ON X.OrganisationId = P.OrganisationID AND P.InvoiceId = X.PaymentSourceID
            WHERE P.`OrganisationID` = ', v_OrganisationID, '
            LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
            ');

    PREPARE stmt7 FROM @insert_intostage7;
    EXECUTE stmt7;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt7;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @rowcount = 1;
  SET @batch_size = 1000;
  SET @delete_table = CONCAT('
	    DELETE trg
        FROM c', v_clientID, '_xeroblue_transactions trg
        JOIN ', @transactionsStage, ' src ON trg.`id` = src.`id`
	    WHERE trg.`OrganisationID` = ', v_OrganisationID, ';
	');

  WHILE @rowcount > 0 DO
    PREPARE stmt8 FROM @delete_table;
    EXECUTE stmt8;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt8;
  END WHILE;

  SET @done = 0;
  SET @ffset = 0;

  WHILE @done = 0 DO
    SET @insert_tofinal = CONCAT('
	        INSERT IGNORE INTO `c', v_clientID, '_xeroblue_transactions`
	        SELECT * FROM `', @transactionsStage, '`
			LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
		    ');
    PREPARE stmt9 FROM @insert_tofinal;
    EXECUTE stmt9;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt9;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_transactions_fixing`
--
CREATE PROCEDURE sp_dynamic_xeroblue_transactions_fixing (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int,
IN `p_legacyClientId` varchar(255))
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_legacyClientID varchar(255) DEFAULT p_legacyClientId;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  -- Replace hardcoded table references with dynamic ones
  SET @transactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_transactionsstage');

  SET @paymentsIndexCols = 'OrganisationID,InvoiceId,PaymentType';
  SET @invoicesIndexOrgId = 'OrganisationID';
  SET @creditnotesIndexCols = 'CreditNoteId,OrganisationID';
  SET @prepaymentsIndexCols = 'OrganisationID,PrepaymentId';
  SET @overpaymentsIndexCols = 'OrganisationID,OverpaymentId';
  SET @manualJournalsIndexCols = 'OrganisationID';
  SET @banktransactionsIndexCols = 'OrganisationID';

  SELECT
    index_name INTO @paymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_payments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @paymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @invoicesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_invoices%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @invoicesIndexOrgId
  LIMIT 1;

  SELECT
    index_name INTO @creditnotesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_creditnotes%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @creditnotesIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @prepaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_prepayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @prepaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @overpaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_overpayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @overpaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @manualJournalsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_manualjournals%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @manualJournalsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @banktransactionsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_banktransactions%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @banktransactionsIndexCols
  LIMIT 1;


  SET @trunc_table = CONCAT('
        TRUNCATE TABLE ', @transactionsStage, ';
    ');
  PREPARE stmt FROM @trunc_table;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @batchsize = 1000;
  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage = CONCAT('
	    INSERT IGNORE INTO ', @transactionsStage, '
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
	        CONCAT(IFNULL(C.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
	        C.`HasAttachments` AS `HasAttachments`,
	        C.`CreditNoteNumber` AS `CreditNoteNumber`,
	        C.`RemainingCredit` AS `RemainingCredit`,
	        C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
	        C.`Reference` AS `Reference`,
	        ''CREDITNOTES'' AS `Source`,
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
	        CASE WHEN CA.InvoiceId IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
	    FROM c', v_clientID, '_xeroblue_creditnotes C  FORCE INDEX(', @creditnotesIndexName, ') 
	    LEFT JOIN (
	        SELECT DISTINCT
	            `CreditNoteId`,
	            `InvoiceId`,
	            `Dt`,
	            `Amount`,
	            `ClientID`,
	            `OrganisationID`
	        FROM evadb.', v_legacyClientID, '_xeroblue_creditnoteallocations_aud
	        WHERE `OrganisationID` = ', v_OrganisationID, '
	    ) CA
	        ON C.`CreditNoteID` = CA.`CreditNoteID` 
	        AND C.`OrganisationID` = CA.`OrganisationID`
	    WHERE c.OrganisationID = ', v_OrganisationID, '
		 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt1 FROM @insert_intostage;
    EXECUTE stmt1;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt1;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage2 = CONCAT('
    INSERT IGNORE INTO ', @transactionsStage, '
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
        CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `FullyPaidOnDate` AS `FullyPaidOnDate`,
        `Reference` AS `Reference`,
        ''INVOICES'' AS `Source`,
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
        LEFT(`InvoiceNumber`,100) AS `InvoiceNumber`,
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
    FROM c', v_clientID, '_xeroblue_invoices  FORCE INDEX(', @invoicesIndexName, ') 
    WHERE `OrganisationID` = ', v_OrganisationID, '
	 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
    ');
    PREPARE stmt2 FROM @insert_intostage2;
    EXECUTE stmt2;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt2;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  /*WHILE @done = 0 DO*/
  SET @insert_intostage3 = CONCAT('
	    INSERT IGNORE INTO ', @transactionsStage, '
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
	        CAST(NULLIF(OP.`CurrencyRate`,'''') AS FLOAT) AS `CurrencyRate`,
	        OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
	        CONCAT(IFNULL(OP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
	        OP.`HasAttachments` AS `HasAttachments`,
	        NULL AS `CreditNoteNumber`,
	        OP.`RemainingCredit` AS `RemainingCredit`,
	        OP.`Date` AS `FullyPaidOnDate`,
	        NULL AS `Reference`,
	        ''OVERPAYMENTS'' AS `Source`,
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
	        CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
	    FROM c', v_clientID, '_xeroblue_overpayments OP  FORCE INDEX (', @overpaymentsIndexName, ')
	    LEFT JOIN (
	        SELECT DISTINCT
	            `OverPaymentId`,
	            `InvoiceId`,
	            `Dt`,
	            `Amount`,
	            `Client ID`,
	            `Organisation ID`
	        FROM evadb.', v_legacyClientID, '_xeroblue_overpaymentallocation_aud
	        WHERE `Organisation ID` = ', v_OrganisationID, '
	    ) OPA 
	        ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
	        AND OP.`OrganisationID` = OPA.`Organisation ID`
	    WHERE OP.`OrganisationID` = ', v_OrganisationID, '
		 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');

  SELECT
    @insert_intostage3;
/*PREPARE stmt3 FROM @insert_intostage3;
EXECUTE stmt3;
SELECT ROW_COUNT() INTO @rowcount;  
IF @rowcount = 0 THEN SET @done = 1; END IF;
*//*DEALLOCATE PREPARE stmt3;*/
/*		SET @ffset = @ffset + @batchsize;	   
	END WHILE;*/

/*SET @ffset = 0;
SET @done = 0; 

WHILE @done = 0 DO
 SET @insert_intostage4 = CONCAT('
 INSERT IGNORE INTO ',@transactionsStage,'
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
     NULLIF(PP.`CurrencyRate`,'''') AS `CurrencyRate`,
     PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
     CONCAT(IFNULL(PP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
     PP.`HasAttachments` AS `HasAttachments`,
     NULL AS `CreditNoteNumber`,
     PP.`RemainingCredit` AS `RemainingCredit`,
     PP.`Date` AS `FullyPaidOnDate`,
     PP.`Reference` AS `Reference`,
     ''PREPAYMENTS'' AS `Source`,
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
     CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
 FROM c',v_clientID,'_xeroblue_prepayments PP  FORCE INDEX (',@prepaymentsIndexName,')
 LEFT JOIN (
     SELECT DISTINCT
         `PrePaymentId`,
         `InvoiceId`,
         `Dt`,
         `Amount`,
         `Client ID`,
         `Organisation ID`
     FROM evadb.',v_legacyClientID,'_xeroblue_prepaymentallocation_aud
     WHERE `Organisation ID` = ',v_OrganisationID,'
 ) PPA 
     ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
     AND PP.`OrganisationID` = PPA.`Organisation ID`
 WHERE PP.`OrganisationID` = ',v_OrganisationID,'    
 LIMIT ',@batchsize,' OFFSET ',@ffset,';
    ');
  PREPARE stmt4 FROM @insert_intostage4;
  EXECUTE stmt4;
 SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;
  DEALLOCATE PREPARE stmt4;
	SET @ffset = @ffset + @batchsize;	   
END WHILE;
 
SET @ffset = 0;
SET @done = 0; 

WHILE @done = 0 DO
 SET @insert_intostage5 = CONCAT('
 INSERT IGNORE INTO ',@transactionsStage,'
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
     CONCAT(IFNULL(`JournalLine_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
     `HasAttachments` AS `HasAttachments`,
     NULL AS `CreditNoteNumber`,
     NULL AS `RemainingCredit`,
     `Date` AS `FullyPaidOnDate`,
     NULL AS `Reference`,
     ''MANUALJOURNALS'' AS `Source`,
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
 FROM c',v_clientID,'_xeroblue_manualjournals FORCE INDEX (',@manualJournalsIndexName,')
 WHERE `OrganisationID` = ',v_OrganisationID,'
 LIMIT ',@batchsize,' OFFSET ',@ffset,';
    ');
  PREPARE stmt5 FROM @insert_intostage5;
  EXECUTE stmt5;
  SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;
 DEALLOCATE PREPARE stmt5;
	SET @ffset = @ffset + @batchsize;
   
END WHILE;
 
SET @ffset = 0;
SET @done = 0; 

WHILE @done = 0 DO
 SET @insert_intostage6 = CONCAT('
 INSERT IGNORE INTO ',@transactionsStage,'
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
     CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
     `HasAttachments` AS `HasAttachments`,
     NULL AS `CreditNoteNumber`,
     NULL AS `RemainingCredit`,
     `FullyPaidOnDate` AS `FullyPaidOnDate`,
     `Reference` AS `Reference`,
     ''BANKTRANSACTIONS'' AS `Source`,
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
 FROM c',v_clientID,'_xeroblue_banktransactions FORCE INDEX (',@banktransactionsIndexName,')
 WHERE `OrganisationID` = ',v_OrganisationID,'
 LIMIT ',@batchsize,' OFFSET ',@ffset,';
    ');
  PREPARE stmt6 FROM @insert_intostage6;
  EXECUTE stmt6;
  SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;
 DEALLOCATE PREPARE stmt6;
	SET @ffset = @ffset + @batchsize;
   
END WHILE;
 
SET @ffset = 0;
SET @done = 0; 

WHILE @done = 0 DO
 SET @insert_intostage7 = CONCAT('
    INSERT IGNORE INTO ',@transactionsStage,'
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
    SELECT  DISTINCT
        P.`PaymentId` AS `LineID`,
        P.`PaymentId` AS `ID`,
        P.`Date` AS `Date`,
        P.`PaymentType` AS `Type`,
        X.ContactId as `ContactID`,
        X.ContactName AS `ContactName`,
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
        CASE WHEN P.`CurrencyRate` LIKE ''%E%'' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION(''E'' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
        P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(P.`AccountCode`, ''BLANK''), ''-'', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
        NULL AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        P.`Date` AS `FullyPaidOnDate`,
        P.`Reference` AS `Reference`,
        ''PAYMENTS'' AS `Source`,
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
        X.Type AS `PaymentSourceType`,
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
	    FROM c',v_clientID,'_xeroblue_payments P FORCE INDEX (',@paymentsIndexName,')
	    JOIN (
	   	 SELECT OrganisationId, ''INVOICES'' AS Type, InvoiceId AS PaymentSourceID, ContactId, ContactName FROM c',v_clientID,'_xeroblue_invoices  FORCE INDEX(',@invoicesIndexName,') 
	   	 WHERE OrganisationId =  ',v_OrganisationID,' 
		    UNION ALL
		    SELECT OrganisationId, ''CREDITNOTES'' AS Type, CreditNoteID AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c',v_clientID,'_xeroblue_creditnotes FORCE INDEX(',@creditnotesIndexName,')
		    WHERE OrganisationId =  ',v_OrganisationID,' 
		    UNION ALL
		    SELECT OrganisationId, ''PREPAYMENTS'' AS Type, PrepaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c',v_clientID,'_xeroblue_prepayments FORCE INDEX(',@prepaymentsIndexName,')
		    WHERE OrganisationId =  ',v_OrganisationID,' 
		    UNION ALL
		    SELECT OrganisationId, ''OVERPAYMENTS'' AS Type, OverpaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c',v_clientID,'_xeroblue_overpayments FORCE INDEX(',@overpaymentsIndexName,')
		    WHERE OrganisationId =  ',v_OrganisationID,' 
		) AS X ON X.OrganisationId = P.OrganisationID AND P.InvoiceId = X.PaymentSourceID
	    WHERE P.`OrganisationID` = ',v_OrganisationID,'
 LIMIT ',@batchsize,' OFFSET ',@ffset,';
    ');
     
  PREPARE stmt7 FROM @insert_intostage7;
  EXECUTE stmt7;
 SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;
  DEALLOCATE PREPARE stmt7;
	SET @ffset = @ffset + @batchsize;	   
END WHILE;
 

SET @rowcount = 1;
SET @batch_size = 1000;
SET @delete_table = CONCAT('
    DELETE FROM c', v_clientID, '_xeroblue_transactions
    WHERE `OrganisationID` = ', v_OrganisationID, '
    LIMIT ', @batch_size, ';
');

WHILE @rowcount > 0 DO
 PREPARE stmt8 FROM @delete_table;
 EXECUTE stmt8;
 SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;  
 DEALLOCATE PREPARE stmt8;
END WHILE;

SET @done = 0;
SET @ffset = 0;

WHILE @done = 0 DO
    SET @insert_tofinal = CONCAT('
        INSERT IGNORE INTO `c',v_clientID,'_xeroblue_transactions`
        SELECT * FROM `',@transactionsStage,'`
		  LIMIT ',@batchsize,' OFFSET ',@ffset,';
	    ');
  PREPARE stmt9 FROM @insert_tofinal;
	EXECUTE stmt9;  
 SELECT ROW_COUNT() INTO @rowcount;  
 IF @rowcount = 0 THEN SET @done = 1; END IF;
	DEALLOCATE PREPARE stmt9;
 	SET @ffset = @ffset + @batchsize;	   
END WHILE;
 */

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_transactions`
--
CREATE PROCEDURE sp_dynamic_xeroblue_transactions (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int,
IN `p_legacyClientId` varchar(255))
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_legacyClientID varchar(255) DEFAULT p_legacyClientId;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  -- Replace hardcoded table references with dynamic ones
  SET @transactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_transactionsstage');

  SET @paymentsIndexCols = 'OrganisationID,InvoiceId,PaymentType';
  SET @invoicesIndexOrgId = 'OrganisationID';
  SET @creditnotesIndexCols = 'CreditNoteId,OrganisationID';
  SET @prepaymentsIndexCols = 'OrganisationID,PrepaymentId';
  SET @overpaymentsIndexCols = 'OrganisationID,OverpaymentId';
  SET @manualJournalsIndexCols = 'OrganisationID';
  SET @banktransactionsIndexCols = 'OrganisationID';

  SELECT
    index_name INTO @paymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_payments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @paymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @invoicesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_invoices%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @invoicesIndexOrgId
  LIMIT 1;

  SELECT
    index_name INTO @creditnotesIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_creditnotes%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @creditnotesIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @prepaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_prepayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @prepaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @overpaymentsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_overpayments%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @overpaymentsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @manualJournalsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_manualjournals%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @manualJournalsIndexCols
  LIMIT 1;

  SELECT
    index_name INTO @banktransactionsIndexName
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
  AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_banktransactions%')
  GROUP BY index_name
  HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @banktransactionsIndexCols
  LIMIT 1;


  SET @trunc_table = CONCAT('
        TRUNCATE TABLE ', @transactionsStage, ';
    ');
  PREPARE stmt FROM @trunc_table;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @batchsize = 1000;
  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage = CONCAT('
	    INSERT IGNORE INTO ', @transactionsStage, '
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
	        CONCAT(IFNULL(C.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
	        C.`HasAttachments` AS `HasAttachments`,
	        C.`CreditNoteNumber` AS `CreditNoteNumber`,
	        C.`RemainingCredit` AS `RemainingCredit`,
	        C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
	        C.`Reference` AS `Reference`,
	        ''CREDITNOTES'' AS `Source`,
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
	        CASE WHEN CA.InvoiceId IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
	    FROM c', v_clientID, '_xeroblue_creditnotes C  FORCE INDEX(', @creditnotesIndexName, ') 
	    LEFT JOIN (
	        SELECT DISTINCT
	            `CreditNoteId`,
	            `InvoiceId`,
	            `Dt`,
	            `Amount`,
	            `ClientID`,
	            `OrganisationID`
	        FROM vibedb.', v_legacyClientID, '_xeroblue_creditnoteallocations_aud
	        WHERE `OrganisationID` = ', v_OrganisationID, '
	    ) CA
	        ON C.`CreditNoteID` = CA.`CreditNoteID` 
	        AND C.`OrganisationID` = CA.`OrganisationID`
	    WHERE c.OrganisationID = ', v_OrganisationID, '
		 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt1 FROM @insert_intostage;
    EXECUTE stmt1;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt1;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage2 = CONCAT('
    INSERT IGNORE INTO ', @transactionsStage, '
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
        CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `FullyPaidOnDate` AS `FullyPaidOnDate`,
        `Reference` AS `Reference`,
        ''INVOICES'' AS `Source`,
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
        LEFT(`InvoiceNumber`,100) AS `InvoiceNumber`,
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
    FROM c', v_clientID, '_xeroblue_invoices  FORCE INDEX(', @invoicesIndexName, ') 
    WHERE `OrganisationID` = ', v_OrganisationID, '
	 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
    ');
    PREPARE stmt2 FROM @insert_intostage2;
    EXECUTE stmt2;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt2;

    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage3 = CONCAT('
	    INSERT IGNORE INTO ', @transactionsStage, '
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
	        CAST(NULLIF(OP.`CurrencyRate`,'''') AS FLOAT) AS `CurrencyRate`,
	        OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
	        CONCAT(IFNULL(OP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
	        OP.`HasAttachments` AS `HasAttachments`,
	        NULL AS `CreditNoteNumber`,
	        OP.`RemainingCredit` AS `RemainingCredit`,
	        OP.`Date` AS `FullyPaidOnDate`,
	        NULL AS `Reference`,
	        ''OVERPAYMENTS'' AS `Source`,
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
	        CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
	    FROM c', v_clientID, '_xeroblue_overpayments OP  FORCE INDEX (', @overpaymentsIndexName, ')
	    LEFT JOIN (
	        SELECT DISTINCT
	            `OverPaymentId`,
	            `InvoiceId`,
	            `Dt`,
	            `Amount`,
	            `Client ID`,
	            `Organisation ID`
	        FROM vibedb.', v_legacyClientID, '_xeroblue_overpaymentallocation_aud
	        WHERE `Organisation ID` = ', v_OrganisationID, '
	    ) OPA 
	        ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
	        AND OP.`OrganisationID` = OPA.`Organisation ID`
	    WHERE OP.`OrganisationID` = ', v_OrganisationID, '
		 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt3 FROM @insert_intostage3;
    EXECUTE stmt3;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt3;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage4 = CONCAT('
    INSERT IGNORE INTO ', @transactionsStage, '
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
        NULLIF(PP.`CurrencyRate`,'''') AS `CurrencyRate`,
        PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(PP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
        PP.`HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        PP.`RemainingCredit` AS `RemainingCredit`,
        PP.`Date` AS `FullyPaidOnDate`,
        PP.`Reference` AS `Reference`,
        ''PREPAYMENTS'' AS `Source`,
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
        CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
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
    FROM c', v_clientID, '_xeroblue_prepayments PP  FORCE INDEX (', @prepaymentsIndexName, ')
    LEFT JOIN (
        SELECT DISTINCT
            `PrePaymentId`,
            `InvoiceId`,
            `Dt`,
            `Amount`,
            `Client ID`,
            `Organisation ID`
        FROM vibedb.', v_legacyClientID, '_xeroblue_prepaymentallocation_aud
        WHERE `Organisation ID` = ', v_OrganisationID, '
    ) PPA 
        ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
        AND PP.`OrganisationID` = PPA.`Organisation ID`
    WHERE PP.`OrganisationID` = ', v_OrganisationID, '    
    LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt4 FROM @insert_intostage4;
    EXECUTE stmt4;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt4;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage5 = CONCAT('
    INSERT IGNORE INTO ', @transactionsStage, '
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
        CONCAT(IFNULL(`JournalLine_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `Date` AS `FullyPaidOnDate`,
        NULL AS `Reference`,
        ''MANUALJOURNALS'' AS `Source`,
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
    FROM c', v_clientID, '_xeroblue_manualjournals FORCE INDEX (', @manualJournalsIndexName, ')
    WHERE `OrganisationID` = ', v_OrganisationID, '
	 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt5 FROM @insert_intostage5;
    EXECUTE stmt5;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt5;
    SET @ffset = @ffset + @batchsize;

  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage6 = CONCAT('
    INSERT IGNORE INTO ', @transactionsStage, '
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
        CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `FullyPaidOnDate` AS `FullyPaidOnDate`,
        `Reference` AS `Reference`,
        ''BANKTRANSACTIONS'' AS `Source`,
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
    FROM c', v_clientID, '_xeroblue_banktransactions FORCE INDEX (', @banktransactionsIndexName, ')
    WHERE `OrganisationID` = ', v_OrganisationID, '
	 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');
    PREPARE stmt6 FROM @insert_intostage6;
    EXECUTE stmt6;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt6;
    SET @ffset = @ffset + @batchsize;

  END WHILE;

  SET @ffset = 0;
  SET @done = 0;

  WHILE @done = 0 DO
    SET @insert_intostage7 = CONCAT('
	    INSERT IGNORE INTO ', @transactionsStage, '
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
	    SELECT  DISTINCT
	        P.`PaymentId` AS `LineID`,
	        P.`PaymentId` AS `ID`,
	        P.`Date` AS `Date`,
	        P.`PaymentType` AS `Type`,
	        X.ContactId as `ContactID`,
	        X.ContactName AS `ContactName`,
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
	        CASE WHEN P.`CurrencyRate` LIKE ''%E%'' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION(''E'' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
	        P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
	        CONCAT(IFNULL(P.`AccountCode`, ''BLANK''), ''-'', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
	        NULL AS `HasAttachments`,
	        NULL AS `CreditNoteNumber`,
	        NULL AS `RemainingCredit`,
	        P.`Date` AS `FullyPaidOnDate`,
	        P.`Reference` AS `Reference`,
	        ''PAYMENTS'' AS `Source`,
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
	        X.Type AS `PaymentSourceType`,
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
		    FROM c', v_clientID, '_xeroblue_payments P FORCE INDEX (', @paymentsIndexName, ')
		    JOIN (
		   	 SELECT OrganisationId, ''INVOICES'' AS Type, InvoiceId AS PaymentSourceID, ContactId, ContactName FROM c', v_clientID, '_xeroblue_invoices  FORCE INDEX(', @invoicesIndexName, ') 
		   	 WHERE OrganisationId =  ', v_OrganisationID, ' 
			    UNION ALL
			    SELECT OrganisationId, ''CREDITNOTES'' AS Type, CreditNoteID AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c', v_clientID, '_xeroblue_creditnotes FORCE INDEX(', @creditnotesIndexName, ')
			    WHERE OrganisationId =  ', v_OrganisationID, ' 
			    UNION ALL
			    SELECT OrganisationId, ''PREPAYMENTS'' AS Type, PrepaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c', v_clientID, '_xeroblue_prepayments FORCE INDEX(', @prepaymentsIndexName, ')
			    WHERE OrganisationId =  ', v_OrganisationID, ' 
			    UNION ALL
			    SELECT OrganisationId, ''OVERPAYMENTS'' AS Type, OverpaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name FROM c', v_clientID, '_xeroblue_overpayments FORCE INDEX(', @overpaymentsIndexName, ')
			    WHERE OrganisationId =  ', v_OrganisationID, ' 
			) AS X ON X.OrganisationId = P.OrganisationID AND P.InvoiceId = X.PaymentSourceID
		    WHERE P.`OrganisationID` = ', v_OrganisationID, '
	 LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
	    ');

    PREPARE stmt7 FROM @insert_intostage7;
    EXECUTE stmt7;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt7;
    SET @ffset = @ffset + @batchsize;
  END WHILE;


  SET @rowcount = 1;
  SET @batch_size = 1000;
  SET @delete_table = CONCAT('
	    DELETE FROM c', v_clientID, '_xeroblue_transactions
	    WHERE `OrganisationID` = ', v_OrganisationID, '
	    LIMIT ', @batch_size, ';
	');

  WHILE @rowcount > 0 DO
    PREPARE stmt8 FROM @delete_table;
    EXECUTE stmt8;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt8;
  END WHILE;

  SET @done = 0;
  SET @ffset = 0;

  WHILE @done = 0 DO
    SET @insert_tofinal = CONCAT('
	        INSERT IGNORE INTO `c', v_clientID, '_xeroblue_transactions`
	        SELECT * FROM `', @transactionsStage, '`
			  LIMIT ', @batchsize, ' OFFSET ', @ffset, ';
		    ');
    PREPARE stmt9 FROM @insert_tofinal;
    EXECUTE stmt9;
    SELECT
      ROW_COUNT() INTO @rowcount;
    IF @rowcount = 0 THEN
      SET @done = 1;
    END IF;
    DEALLOCATE PREPARE stmt9;
    SET @ffset = @ffset + @batchsize;
  END WHILE;


END
$$

--
-- Create procedure `sp_dynamic_xeroblue_trackingcategoryconnections`
--
CREATE PROCEDURE sp_dynamic_xeroblue_trackingcategoryconnections (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  SET @defaultTable = CONCAT('c', v_clientID, '_xeroblue_trackingcategoryconnections');

  SET @delete_sql = CONCAT('
                DELETE FROM c', v_clientID, '_xeroblue_trackingcategoryconnections
                WHERE OrganisationID = ', v_OrganisationID, ';
            ');
  PREPARE del_stmt FROM @delete_sql;
  EXECUTE del_stmt;
  DEALLOCATE PREPARE del_stmt;

  SET @insert_sql = CONCAT('
                INSERT INTO c', v_clientID, '_xeroblue_trackingcategoryconnections
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_invoices
                    WHERE Status in (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ', v_OrganisationID, '
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_invoices
                    WHERE Status in (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ', v_OrganisationID, '
                ) inv WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_journals
                    WHERE OrganisationID = ', v_OrganisationID, '
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_journals
                    WHERE OrganisationID = ', v_OrganisationID, '
                ) jrnl WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_creditnotes
                    WHERE Status IN (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ', v_OrganisationID, '
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_creditnotes
                    WHERE Status IN (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ', v_OrganisationID, '
                ) crdt WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, ''-01''), ''%Y-%m-%d''), ''%b-%Y'')) AS ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(`Tracking.1.TrackingCategoryID`,`Tracking.1.Option`) AS `CategoryID+Option`
                        ,a.ClientID
                        ,a.OrganisationID
                    FROM c', v_clientID, '_xeroblue_budgets a
                    INNER JOIN c', v_clientID, '_xeroblue_accounts b 
                        ON a.`BudgetLines.AccountID` = b.`AccountID` 
                        AND a.`BudgetLines.AccountCode` = b.`Code`
                        AND a.`OrganisationID` = b.`OrganisationID`
                    WHERE a.OrganisationID = ', v_OrganisationID, '
                    UNION ALL
                    SELECT
                        CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, ''-01''), ''%Y-%m-%d''), ''%b-%Y'')) AS ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(`Tracking.2.TrackingCategoryID`,`Tracking.2.Option`) AS `CategoryID+Option`
                        ,a.ClientID
                        ,a.OrganisationID
                    FROM c', v_clientID, '_xeroblue_budgets a
                    INNER JOIN c', v_clientID, '_xeroblue_accounts b 
                        ON a.`BudgetLines.AccountID` = b.`AccountID` 
                        AND a.`BudgetLines.AccountCode` = b.`Code`
                        AND a.`OrganisationID` = b.`OrganisationID`
                    WHERE a.OrganisationID = ', v_OrganisationID, '
                ) bdgt WHERE `CategoryID+Option` IS NOT NULL;
            ');

  PREPARE ins_stmt FROM @insert_sql;
  EXECUTE ins_stmt;
  DEALLOCATE PREPARE ins_stmt;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_taxrates`
--
CREATE PROCEDURE sp_dynamic_xeroblue_taxrates (IN p_clientID varchar(100),
IN p_orgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  SET @taxratesStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_taxratesstage');

  SET @delete_taxrates = CONCAT('
		DELETE FROM c', v_clientID, '_xeroblue_taxrates 
		 WHERE `OrganisationId` = ', v_OrganisationID, ';
		');

  --	SELECT @delete_taxrates;	
  PREPARE stmt FROM @delete_taxrates;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @insert_taxrates = CONCAT('
		INSERT INTO c', v_clientID, '_xeroblue_taxrates 
		 SELECT * from ', @taxratesStage, ';
	');
  --	SELECT @insert_taxrates;
  PREPARE stmt2 FROM @insert_taxrates;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


END
$$

--
-- Create procedure `sp_dynamic_xeroblue_reprocess_sp`
--
CREATE PROCEDURE sp_dynamic_xeroblue_reprocess_sp (IN p_endpoint varchar(255))
BEGIN
  DECLARE done int DEFAULT FALSE;
  DECLARE v_client_id int;
  DECLARE v_org_id int;
  DECLARE v_legacy_id int;

  DECLARE cur CURSOR FOR
  SELECT
    s.client AS client_id,
    s.id AS org_id,
    IFNULL(JSON_UNQUOTE(JSON_EXTRACT(s.Details, '$.Legacy.id')), s.id) AS legacy_id
  FROM etaniv2.client_service s
    JOIN evadb_stage.firms_with_containers fwc
      ON fwc.firm_id = s.AccountingFirm
    JOIN etaniv2.client c
      ON s.Client = c.id
  WHERE s.status = 1
  AND s.service = 1
  AND c.Status <> 2;


  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

    read_loop:
  LOOP
    FETCH cur INTO v_client_id, v_org_id, v_legacy_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SET @tablestage = CONCAT('c', v_client_id, '_', v_org_id, '_xeroblue_', p_endpoint, 'stage');
    -- Call stored procedure for each row
    IF EXISTS (SELECT
          1
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
        AND table_name = @tablestage) THEN
      SET @sp_sql = CONCAT('
          CALL sp_dynamic_xeroblue_', p_endpoint, '(', v_client_id, ',', v_org_id, ',', v_legacy_id, ');
          ');
      PREPARE stmt FROM @sp_sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
    END IF;

  END LOOP;

  CLOSE cur;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_prepayments`
--
CREATE PROCEDURE sp_dynamic_xeroblue_prepayments (IN p_clientID varchar(100),
IN p_orgID int,
IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  -- Replace hardcoded table references with dynamic ones
  SET @prepaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_prepaymentsstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt10 FROM @insert_fxtable;
  EXECUTE stmt10;
  DEALLOCATE PREPARE stmt10;


  -- prepaymentsAllocations temp table creation and population for speedier insertion
  CREATE TEMPORARY TABLE IF NOT EXISTS prepaymentsAllocations (
    AllocationID int AUTO_INCREMENT PRIMARY KEY,
    PrepaymentId varchar(100) NOT NULL,
    AllocationNumber int NOT NULL,
    AllocationDate date NOT NULL,
    AppliedAmount decimal(18, 2) NOT NULL,
    CurrencyCode varchar(10) NOT NULL,
    AUD decimal(18, 6) DEFAULT NULL,
    USD decimal(18, 6) DEFAULT NULL,
    NZD decimal(18, 6) DEFAULT NULL,
    EUR decimal(18, 6) DEFAULT NULL,
    GBP decimal(18, 6) DEFAULT NULL
  );

  SET @insertAllocationsQuery = CONCAT('INSERT INTO prepaymentsAllocations (PrepaymentId, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode)
          SELECT PrepaymentId, 1, Allocation1_Date, Allocation1_AppliedAmount, CurrencyCode
          FROM ', @prepaymentsStage, '
          WHERE Allocation1_Date IS NOT NULL
          UNION ALL
          SELECT PrepaymentId, 2, Allocation2_Date, Allocation2_AppliedAmount, CurrencyCode
          FROM ', @prepaymentsStage, '
          WHERE Allocation2_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 3, prepymt.Allocation3_Date, prepymt.Allocation3_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation3_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 4, prepymt.Allocation4_Date, prepymt.Allocation4_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation4_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 5, prepymt.Allocation5_Date, prepymt.Allocation5_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation5_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 6, prepymt.Allocation6_Date, prepymt.Allocation6_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation6_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 7, prepymt.Allocation7_Date, prepymt.Allocation7_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation7_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 8, prepymt.Allocation8_Date, prepymt.Allocation8_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation8_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 9, prepymt.Allocation9_Date, prepymt.Allocation9_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation9_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 10, prepymt.Allocation10_Date, prepymt.Allocation10_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation10_Date IS NOT NULL;');

  PREPARE stmt FROM @insertAllocationsQuery;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  -- Update prepaymentsAllocations currencies
  SET @update_allocations = CONCAT('
	    UPDATE prepaymentsAllocations AS alloc
	    JOIN ', @fx_table, ' AS fx
	        ON fx.BaseCurrency = alloc.CurrencyCode
	        AND fx.Date = CASE
	            WHEN alloc.AllocationDate <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	            WHEN alloc.AllocationDate >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	            ELSE alloc.AllocationDate
	        END
	    SET alloc.AUD = alloc.AppliedAmount * fx.AUD,
	        alloc.USD = alloc.AppliedAmount * fx.USD,
	        alloc.NZD = alloc.AppliedAmount * fx.NZD,
	        alloc.EUR = alloc.AppliedAmount * fx.EUR,
	        alloc.GBP = alloc.AppliedAmount * fx.GBP;
	    ');
  PREPARE stmt1 FROM @update_allocations;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;

  SET @updateprepaymentsStage = CONCAT('UPDATE ', @prepaymentsStage, ' AS prepymt
	     LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN prepymt.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
									WHEN prepymt.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
									ELSE prepymt.`Date` 
								END
	    SET `RemainingCredit_AUD` = prepymt.`RemainingCredit` * fx.`AUD`,
            `RemainingCredit_USD` = prepymt.`RemainingCredit` * fx.`USD`,
            `RemainingCredit_NZD` = prepymt.`RemainingCredit` * fx.`NZD`,
            `RemainingCredit_EUR` = prepymt.`RemainingCredit` * fx.`EUR`,
            `RemainingCredit_GBP` = prepymt.`RemainingCredit` * fx.`GBP`,
            `SubTotal_AUD` = prepymt.`SubTotal` * fx.`AUD`,
            `SubTotal_USD` = prepymt.`SubTotal` * fx.`USD`,
            `SubTotal_NZD` = prepymt.`SubTotal` * fx.`NZD`,
            `SubTotal_EUR` = prepymt.`SubTotal` * fx.`EUR`,
            `SubTotal_GBP` = prepymt.`SubTotal` * fx.`GBP`,
            `TotalTax_AUD` = prepymt.`TotalTax` * fx.`AUD`,
            `TotalTax_USD` = prepymt.`TotalTax` * fx.`USD`,
            `TotalTax_NZD` = prepymt.`TotalTax` * fx.`NZD`,
            `TotalTax_EUR` = prepymt.`TotalTax` * fx.`EUR`,
            `TotalTax_GBP` = prepymt.`TotalTax` * fx.`GBP`,
            `Total_AUD` = prepymt.`Total` * fx.`AUD`,
            `Total_USD` = prepymt.`Total` * fx.`USD`,
            `Total_NZD` = prepymt.`Total` * fx.`NZD`,
            `Total_EUR` = prepymt.`Total` * fx.`EUR`,
            `Total_GBP` = prepymt.`Total` * fx.`GBP`,
            `LineItem_UnitAmount_AUD` = prepymt.`LineItem_UnitAmount` * fx.`AUD`,
            `LineItem_UnitAmount_USD` = prepymt.`LineItem_UnitAmount` * fx.`USD`,
            `LineItem_UnitAmount_NZD` = prepymt.`LineItem_UnitAmount` * fx.`NZD`,
            `LineItem_UnitAmount_EUR` = prepymt.`LineItem_UnitAmount` * fx.`EUR`,
            `LineItem_UnitAmount_GBP` = prepymt.`LineItem_UnitAmount` * fx.`GBP`,
            `LineItem_TaxAmount_AUD` = prepymt.`LineItem_TaxAmount` * fx.`AUD`,
            `LineItem_TaxAmount_USD` = prepymt.`LineItem_TaxAmount` * fx.`USD`,
            `LineItem_TaxAmount_NZD` = prepymt.`LineItem_TaxAmount` * fx.`NZD`,
            `LineItem_TaxAmount_EUR` = prepymt.`LineItem_TaxAmount` * fx.`EUR`,
            `LineItem_TaxAmount_GBP` = prepymt.`LineItem_TaxAmount` * fx.`GBP`,
            `LineItem_LineAmount_AUD` = prepymt.`LineItem_LineAmount` * fx.`AUD`,
            `LineItem_LineAmount_USD` = prepymt.`LineItem_LineAmount` * fx.`USD`,
            `LineItem_LineAmount_NZD` = prepymt.`LineItem_LineAmount` * fx.`NZD`,
            `LineItem_LineAmount_EUR` = prepymt.`LineItem_LineAmount` * fx.`EUR`,
            `LineItem_LineAmount_GBP` = prepymt.`LineItem_LineAmount` * fx.`GBP`;');

  PREPARE stmt2 FROM @updateprepaymentsStage;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_prepayments TRG
    		INNER JOIN ', @prepaymentsStage, ' STG 
        	ON TRG.`PrepaymentId` = STG.`PrepaymentId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt5 FROM @delete_trg;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;


  SET @insert_xeroblue_prepayments = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_prepayments (
        `PrepaymentId`,
        `Date`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    )
    SELECT 
        prepymt.`PrepaymentId`,
        NULLIF(`Date`, ''''),
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        `CurrencyCode`,
        `CurrencyRate`,
        NULLIF(`UpdatedDateUTC`, ''''),
        alloc.`Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, ''''),
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        alloc.`Allocation1_AppliedAmount_AUD`,
        alloc.`Allocation1_AppliedAmount_USD`,
        alloc.`Allocation1_AppliedAmount_NZD`,
        alloc.`Allocation1_AppliedAmount_EUR`,
        alloc.`Allocation1_AppliedAmount_GBP`,
        alloc.`Allocation2_AppliedAmount_AUD`,
        alloc.`Allocation2_AppliedAmount_USD`,
        alloc.`Allocation2_AppliedAmount_NZD`,
        alloc.`Allocation2_AppliedAmount_EUR`,
        alloc.`Allocation2_AppliedAmount_GBP`,
        alloc.`Allocation3_AppliedAmount_AUD`,
        alloc.`Allocation3_AppliedAmount_USD`,
        alloc.`Allocation3_AppliedAmount_NZD`,
        alloc.`Allocation3_AppliedAmount_EUR`,
        alloc.`Allocation3_AppliedAmount_GBP`,
        alloc.`Allocation4_AppliedAmount_AUD`,
        alloc.`Allocation4_AppliedAmount_USD`,
        alloc.`Allocation4_AppliedAmount_NZD`,
        alloc.`Allocation4_AppliedAmount_EUR`,
        alloc.`Allocation4_AppliedAmount_GBP`,
        alloc.`Allocation5_AppliedAmount_AUD`,
        alloc.`Allocation5_AppliedAmount_USD`,
        alloc.`Allocation5_AppliedAmount_NZD`,
        alloc.`Allocation5_AppliedAmount_EUR`,
        alloc.`Allocation5_AppliedAmount_GBP`,
        alloc.`Allocation6_AppliedAmount_AUD`,
        alloc.`Allocation6_AppliedAmount_USD`,
        alloc.`Allocation6_AppliedAmount_NZD`,
        alloc.`Allocation6_AppliedAmount_EUR`,
        alloc.`Allocation6_AppliedAmount_GBP`,
        alloc.`Allocation7_AppliedAmount_AUD`,
        alloc.`Allocation7_AppliedAmount_USD`,
        alloc.`Allocation7_AppliedAmount_NZD`,
        alloc.`Allocation7_AppliedAmount_EUR`,
        alloc.`Allocation7_AppliedAmount_GBP`,
        alloc.`Allocation8_AppliedAmount_AUD`,
        alloc.`Allocation8_AppliedAmount_USD`,
        alloc.`Allocation8_AppliedAmount_NZD`,
        alloc.`Allocation8_AppliedAmount_EUR`,
        alloc.`Allocation8_AppliedAmount_GBP`,
        alloc.`Allocation9_AppliedAmount_AUD`,
        alloc.`Allocation9_AppliedAmount_USD`,
        alloc.`Allocation9_AppliedAmount_NZD`,
        alloc.`Allocation9_AppliedAmount_EUR`,
        alloc.`Allocation9_AppliedAmount_GBP`,
        alloc.`Allocation10_AppliedAmount_AUD`,
        alloc.`Allocation10_AppliedAmount_USD`,
        alloc.`Allocation10_AppliedAmount_NZD`,
        alloc.`Allocation10_AppliedAmount_EUR`,
        alloc.`Allocation10_AppliedAmount_GBP`
    FROM ', @prepaymentsStage, ' prepymt
    LEFT JOIN (
    SELECT 
            PrepaymentId,
            MAX(CASE WHEN AllocationNumber = 1 THEN AppliedAmount END) AS Allocation1_AppliedAmount,
                 MAX(CASE WHEN AllocationNumber = 1 THEN AUD END) AS `Allocation1_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN USD END) AS  `Allocation1_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN NZD END) AS  `Allocation1_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN EUR END) AS  `Allocation1_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 1 THEN GBP END) AS  `Allocation1_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 2 THEN AppliedAmount END) AS Allocation2_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 2 THEN AUD END) AS `Allocation2_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN USD END) AS  `Allocation2_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN NZD END) AS  `Allocation2_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN EUR END) AS  `Allocation2_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 2 THEN GBP END) AS  `Allocation2_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 3 THEN AppliedAmount END) AS Allocation3_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 3 THEN AUD END) AS `Allocation3_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN USD END) AS  `Allocation3_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN NZD END) AS  `Allocation3_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN EUR END) AS  `Allocation3_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 3 THEN GBP END) AS  `Allocation3_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 4 THEN AppliedAmount END) AS Allocation4_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 4 THEN AUD END) AS `Allocation4_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN USD END) AS  `Allocation4_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN NZD END) AS  `Allocation4_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN EUR END) AS  `Allocation4_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 4 THEN GBP END) AS  `Allocation4_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 5 THEN AppliedAmount END) AS Allocation5_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 5 THEN AUD END) AS `Allocation5_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN USD END) AS  `Allocation5_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN NZD END) AS  `Allocation5_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN EUR END) AS  `Allocation5_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 5 THEN GBP END) AS  `Allocation5_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 6 THEN AppliedAmount END) AS Allocation6_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 6 THEN AUD END) AS `Allocation6_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN USD END) AS  `Allocation6_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN NZD END) AS  `Allocation6_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN EUR END) AS  `Allocation6_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 6 THEN GBP END) AS  `Allocation6_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 7 THEN AppliedAmount END) AS Allocation7_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 7 THEN AUD END) AS `Allocation7_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN USD END) AS  `Allocation7_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN NZD END) AS  `Allocation7_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN EUR END) AS  `Allocation7_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 7 THEN GBP END) AS  `Allocation7_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 8 THEN AppliedAmount END) AS Allocation8_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 8 THEN AUD END) AS `Allocation8_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN USD END) AS  `Allocation8_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN NZD END) AS  `Allocation8_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN EUR END) AS  `Allocation8_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 8 THEN GBP END) AS  `Allocation8_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 9 THEN AppliedAmount END) AS Allocation9_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 9 THEN AUD END) AS `Allocation9_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN USD END) AS  `Allocation9_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN NZD END) AS  `Allocation9_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN EUR END) AS  `Allocation9_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 9 THEN GBP END) AS  `Allocation9_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 10 THEN AppliedAmount END) AS Allocation10_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 10 THEN AUD END) AS `Allocation10_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN USD END) AS  `Allocation10_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN NZD END) AS  `Allocation10_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN EUR END) AS  `Allocation10_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 10 THEN GBP END) AS  `Allocation10_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 11 THEN AppliedAmount END) AS Allocation11_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 11 THEN AUD END) AS `Allocation11_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN USD END) AS  `Allocation11_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN NZD END) AS  `Allocation11_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN EUR END) AS  `Allocation11_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 11 THEN GBP END) AS  `Allocation11_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 12 THEN AppliedAmount END) AS Allocation12_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 12 THEN AUD END) AS `Allocation12_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN USD END) AS  `Allocation12_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN NZD END) AS  `Allocation12_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN EUR END) AS  `Allocation12_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 12 THEN GBP END) AS  `Allocation12_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 13 THEN AppliedAmount END) AS Allocation13_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 13 THEN AUD END) AS `Allocation13_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN USD END) AS  `Allocation13_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN NZD END) AS  `Allocation13_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN EUR END) AS  `Allocation13_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 13 THEN GBP END) AS  `Allocation13_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 14 THEN AppliedAmount END) AS Allocation14_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 14 THEN AUD END) AS `Allocation14_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN USD END) AS  `Allocation14_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN NZD END) AS  `Allocation14_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN EUR END) AS  `Allocation14_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 14 THEN GBP END) AS  `Allocation14_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 15 THEN AppliedAmount END) AS Allocation15_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 15 THEN AUD END) AS `Allocation15_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN USD END) AS  `Allocation15_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN NZD END) AS  `Allocation15_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN EUR END) AS  `Allocation15_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 15 THEN GBP END) AS  `Allocation15_AppliedAmount_GBP`
         FROM prepaymentsAllocations
         GROUP BY PrepaymentId) alloc ON prepymt.PrepaymentId = alloc.PrepaymentId;
		');

  PREPARE stmt6 FROM @insert_xeroblue_prepayments;
  EXECUTE stmt6;
  DEALLOCATE PREPARE stmt6;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_payments`
--
CREATE PROCEDURE sp_dynamic_xeroblue_payments (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  -- Replace hardcoded table references with dynamic ones
  SET @paymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_paymentsstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt1 FROM @insert_fxtable;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;



  SET @updatepaymentsStage3 = CONCAT('UPDATE ', @paymentsStage, ' AS pymt
        JOIN `c', v_clientID, '_xeroblue_organisationsclients` AS `org` ON `org`.`OrganisationID` = `pymt`.`OrganisationID`
        JOIN (SELECT `InvoiceId`, `CurrencyCode` FROM `c', v_clientID, '_xeroblue_invoices` WHERE `OrganisationID` = ', v_OrganisationID, ') AS `inv` ON `pymt`.`InvoiceId` = `inv`.`InvoiceId`
        JOIN (SELECT `CreditNoteId`, `CurrencyCode` FROM `c', v_clientID, '_xeroblue_creditnotes` WHERE `OrganisationID` = ', v_OrganisationID, ') AS `cn` ON `pymt`.`InvoiceId` = `cn`.`CreditNoteId`
        JOIN (SELECT `OverPaymentId`, `CurrencyCode` FROM `c', v_clientID, '_xeroblue_overpayments` WHERE `OrganisationID` = ', v_OrganisationID, ') AS `op` ON `pymt`.`InvoiceId` = `op`.`OverPaymentId`
        JOIN (SELECT `PrePaymentId`, `CurrencyCode` FROM `c', v_clientID, '_xeroblue_prepayments` WHERE `OrganisationID` = ', v_OrganisationID, ') AS `pp` ON `pymt`.`InvoiceId` = `pp`.`PrePaymentId`
	     LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = CASE 
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''ACCRECPAYMENT'', ''ACCPAYPAYMENT'') THEN `inv`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''APCREDITPAYMENT'', ''ARCREDITPAYMENT'') THEN `cn`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''APOVERPAYMENTPAYMENT'', ''AROVERPAYMENTPAYMENT'') THEN `op`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''ARPREPAYMENTPAYMENT'', ''APPREPAYMENTPAYMENT'') THEN `pp`.`CurrencyCode`
                    ELSE `org`.`BaseCurrency` 
                END
	            AND fx.`Date` = CASE 
	            	WHEN pymt.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
						WHEN pymt.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
						ELSE pymt.`Date` 
					END
	    SET
	    `Amount_AUD` = CASE 
            WHEN `org`.`BaseCurrency` = ''AUD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`AUD` 
        END,
        `Amount_USD` = CASE 
            WHEN `org`.`BaseCurrency` = ''USD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`USD` 
        END,
        `Amount_NZD` = CASE 
            WHEN `org`.`BaseCurrency` = ''NZD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`NZD` 
        END,
        `Amount_EUR` = CASE 
            WHEN `org`.`BaseCurrency` = ''EUR'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
                    ELSE `pymt`.`Amount` * `fx`.`EUR` 
        END,
        `Amount_GBP` = CASE 
            WHEN `org`.`BaseCurrency` = ''GBP'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`GBP` 
        END;');

  PREPARE stmt2 FROM @updatepaymentsStage3;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;

  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_payments TRG
    		INNER JOIN ', @paymentsStage, ' STG 
        	ON TRG.`PaymentId` = STG.`PaymentId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt3 FROM @delete_trg;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;


  SET @insert_xeroblue_payments = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_payments (
         `PaymentId`,
            `Date`,
            `Amount`,
            `CurrencyRate`,
            `Reference`,
            `PaymentType`,
            `Status`,
            `UpdatedDateUTC`,
            `IsReconciled`,
            `BatchPaymentId`,
            `InvoiceId`,
            `InvoiceNumber`,
            `CreditNoteId`,
            `CreditNoteNumber`,
            `AccountId`,
            `AccountCode`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
        )
        SELECT
            `PaymentId`,
                NULLIF(`Date`, ''''),
                `Amount`,
                `CurrencyRate`,
                `Reference`,
                `PaymentType`,
                `Status`,
                NULLIF(`UpdatedDateUTC`, ''''),
                `IsReconciled`,
                `BatchPaymentId`,
                `InvoiceId`,
                `InvoiceNumber`,
                `CreditNoteId`,
                `CreditNoteNumber`,
                `AccountId`,
                `AccountCode`,
                `ClientID`,
                `OrganisationID`,
                `Amount_AUD`,
                `Amount_USD`,
                `Amount_NZD`,
                `Amount_EUR`,
                `Amount_GBP`
        FROM ', @paymentsStage, ' pymt;    
		');

  PREPARE stmt4 FROM @insert_xeroblue_payments;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_overpayments`
--
CREATE PROCEDURE sp_dynamic_xeroblue_overpayments (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  -- Replace hardcoded table references with dynamic ones
  SET @overpaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_overpaymentsstage');
  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt10 FROM @insert_fxtable;
  EXECUTE stmt10;
  DEALLOCATE PREPARE stmt10;

  -- Allocations temp table creation and population for speedier insertion
  CREATE TEMPORARY TABLE IF NOT EXISTS Allocations (
    AllocationID int AUTO_INCREMENT PRIMARY KEY,
    OverpaymentId varchar(100) NOT NULL,
    AllocationNumber int NOT NULL,
    AllocationDate date NOT NULL,
    AppliedAmount decimal(18, 2) NOT NULL,
    CurrencyCode varchar(10) NOT NULL,
    AUD decimal(18, 6) DEFAULT NULL,
    USD decimal(18, 6) DEFAULT NULL,
    NZD decimal(18, 6) DEFAULT NULL,
    EUR decimal(18, 6) DEFAULT NULL,
    GBP decimal(18, 6) DEFAULT NULL
  );

  SET @insertAllocationsQuery = CONCAT('INSERT INTO Allocations (OverpaymentId, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode)
          SELECT OverpaymentId, 1, Allocation1_Date, Allocation1_AppliedAmount, CurrencyCode
          FROM ', @overpaymentsStage, '
          WHERE Allocation1_Date IS NOT NULL
          UNION ALL
          SELECT OverpaymentId, 2, Allocation2_Date, Allocation2_AppliedAmount, CurrencyCode
          FROM ', @overpaymentsStage, '
          WHERE Allocation2_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 3, ovrpymt.Allocation3_Date, ovrpymt.Allocation3_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation3_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 4, ovrpymt.Allocation4_Date, ovrpymt.Allocation4_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation4_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 5, ovrpymt.Allocation5_Date, ovrpymt.Allocation5_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation5_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 6, ovrpymt.Allocation6_Date, ovrpymt.Allocation6_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation6_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 7, ovrpymt.Allocation7_Date, ovrpymt.Allocation7_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation7_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 8, ovrpymt.Allocation8_Date, ovrpymt.Allocation8_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation8_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 9, ovrpymt.Allocation9_Date, ovrpymt.Allocation9_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation9_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 10, ovrpymt.Allocation10_Date, ovrpymt.Allocation10_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation10_Date IS NOT NULL
		    ;');

  PREPARE stmt11 FROM @insertAllocationsQuery;
  EXECUTE stmt11;
  DEALLOCATE PREPARE stmt11;

  -- Update allocations currencies
  SET @update_allocations = CONCAT('
	    UPDATE Allocations AS alloc
	    JOIN ', @fx_table, ' AS fx
	        ON fx.BaseCurrency = alloc.CurrencyCode
	        AND fx.Date = CASE
	            WHEN alloc.AllocationDate <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	            WHEN alloc.AllocationDate >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	            ELSE alloc.AllocationDate
	        END
	    SET alloc.AUD = alloc.AppliedAmount * fx.AUD,
	        alloc.USD = alloc.AppliedAmount * fx.USD,
	        alloc.NZD = alloc.AppliedAmount * fx.NZD,
	        alloc.EUR = alloc.AppliedAmount * fx.EUR,
	        alloc.GBP = alloc.AppliedAmount * fx.GBP;
	    ');
  PREPARE stmt FROM @update_allocations;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;



  SET @updateoverpaymentsStage3 = CONCAT('UPDATE ', @overpaymentsStage, ' AS ovrpymt
	        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = ovrpymt.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN ovrpymt.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN ovrpymt.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE ovrpymt.`Date` 
	                                                                END
	    SET `RemainingCredit_AUD` = ovrpymt.`RemainingCredit` * fx.`AUD`,
        `RemainingCredit_USD` = ovrpymt.`RemainingCredit` * fx.`USD`,
        `RemainingCredit_NZD` = ovrpymt.`RemainingCredit` * fx.`NZD`,
        `RemainingCredit_EUR` = ovrpymt.`RemainingCredit` * fx.`EUR`,
        `RemainingCredit_GBP` = ovrpymt.`RemainingCredit` * fx.`GBP`,
        `SubTotal_AUD` = ovrpymt.`SubTotal` * fx.`AUD`,
        `SubTotal_USD` = ovrpymt.`SubTotal` * fx.`USD`,
        `SubTotal_NZD` = ovrpymt.`SubTotal` * fx.`NZD`,
        `SubTotal_EUR` = ovrpymt.`SubTotal` * fx.`EUR`,
        `SubTotal_GBP` = ovrpymt.`SubTotal` * fx.`GBP`,
        `TotalTax_AUD` = ovrpymt.`TotalTax` * fx.`AUD`,
        `TotalTax_USD` = ovrpymt.`TotalTax` * fx.`USD`,
        `TotalTax_NZD` = ovrpymt.`TotalTax` * fx.`NZD`,
        `TotalTax_EUR` = ovrpymt.`TotalTax` * fx.`EUR`,
        `TotalTax_GBP` = ovrpymt.`TotalTax` * fx.`GBP`,
        `Total_AUD` = ovrpymt.`Total` * fx.`AUD`,
        `Total_USD` = ovrpymt.`Total` * fx.`USD`,
        `Total_NZD` = ovrpymt.`Total` * fx.`NZD`,
        `Total_EUR` = ovrpymt.`Total` * fx.`EUR`,
        `Total_GBP` = ovrpymt.`Total` * fx.`GBP`,
        `LineItem_UnitAmount_AUD` = ovrpymt.`LineItem_UnitAmount` * fx.`AUD`,
        `LineItem_UnitAmount_USD` = ovrpymt.`LineItem_UnitAmount` * fx.`USD`,
        `LineItem_UnitAmount_NZD` = ovrpymt.`LineItem_UnitAmount` * fx.`NZD`,
        `LineItem_UnitAmount_EUR` = ovrpymt.`LineItem_UnitAmount` * fx.`EUR`,
        `LineItem_UnitAmount_GBP` = ovrpymt.`LineItem_UnitAmount` * fx.`GBP`,
        `LineItem_TaxAmount_AUD` = ovrpymt.`LineItem_TaxAmount` * fx.`AUD`,
        `LineItem_TaxAmount_USD` = ovrpymt.`LineItem_TaxAmount` * fx.`USD`,
        `LineItem_TaxAmount_NZD` = ovrpymt.`LineItem_TaxAmount` * fx.`NZD`,
        `LineItem_TaxAmount_EUR` = ovrpymt.`LineItem_TaxAmount` * fx.`EUR`,
        `LineItem_TaxAmount_GBP` = ovrpymt.`LineItem_TaxAmount` * fx.`GBP`,
        `LineItem_LineAmount_AUD` = ovrpymt.`LineItem_LineAmount` * fx.`AUD`,
        `LineItem_LineAmount_USD` = ovrpymt.`LineItem_LineAmount` * fx.`USD`,
        `LineItem_LineAmount_NZD` = ovrpymt.`LineItem_LineAmount` * fx.`NZD`,
        `LineItem_LineAmount_EUR` = ovrpymt.`LineItem_LineAmount` * fx.`EUR`,
        `LineItem_LineAmount_GBP` = ovrpymt.`LineItem_LineAmount` * fx.`GBP`;');

  PREPARE stmt4 FROM @updateoverpaymentsStage3;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;

  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_overpayments TRG
    		INNER JOIN ', @overpaymentsStage, ' STG 
        	ON TRG.`OverpaymentId` = STG.`OverpaymentId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt5 FROM @delete_trg;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;


  SET @insert_xeroblue_overpayments = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_overpayments (
        `OverpaymentId`,
        `Date`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    )
    SELECT 
        ovrpymt.`OverpaymentId`,
        NULLIF(`Date`, '''') AS `Date`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        ovrpymt.`CurrencyCode`,
        ovrpymt.`CurrencyRate`,
        NULLIF(`UpdatedDateUTC`, '''') AS `UpdatedDateUTC`,
        alloc.`Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, '''') AS `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, '''') AS `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, '''') AS `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, '''') AS `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, '''') AS `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, '''') AS `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, '''') AS `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, '''') AS `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, '''') AS `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, '''') AS `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        alloc.`Allocation1_AppliedAmount_AUD`,
        alloc.`Allocation1_AppliedAmount_USD`,
        alloc.`Allocation1_AppliedAmount_NZD`,
        alloc.`Allocation1_AppliedAmount_EUR`,
        alloc.`Allocation1_AppliedAmount_GBP`,
        alloc.`Allocation2_AppliedAmount_AUD`,
        alloc.`Allocation2_AppliedAmount_USD`,
        alloc.`Allocation2_AppliedAmount_NZD`,
        alloc.`Allocation2_AppliedAmount_EUR`,
        alloc.`Allocation2_AppliedAmount_GBP`,
        alloc.`Allocation3_AppliedAmount_AUD`,
        alloc.`Allocation3_AppliedAmount_USD`,
        alloc.`Allocation3_AppliedAmount_NZD`,
        alloc.`Allocation3_AppliedAmount_EUR`,
        alloc.`Allocation3_AppliedAmount_GBP`,
        alloc.`Allocation4_AppliedAmount_AUD`,
        alloc.`Allocation4_AppliedAmount_USD`,
        alloc.`Allocation4_AppliedAmount_NZD`,
        alloc.`Allocation4_AppliedAmount_EUR`,
        alloc.`Allocation4_AppliedAmount_GBP`,
        alloc.`Allocation5_AppliedAmount_AUD`,
        alloc.`Allocation5_AppliedAmount_USD`,
        alloc.`Allocation5_AppliedAmount_NZD`,
        alloc.`Allocation5_AppliedAmount_EUR`,
        alloc.`Allocation5_AppliedAmount_GBP`,
        alloc.`Allocation6_AppliedAmount_AUD`,
        alloc.`Allocation6_AppliedAmount_USD`,
        alloc.`Allocation6_AppliedAmount_NZD`,
        alloc.`Allocation6_AppliedAmount_EUR`,
        alloc.`Allocation6_AppliedAmount_GBP`,
        alloc.`Allocation7_AppliedAmount_AUD`,
        alloc.`Allocation7_AppliedAmount_USD`,
        alloc.`Allocation7_AppliedAmount_NZD`,
        alloc.`Allocation7_AppliedAmount_EUR`,
        alloc.`Allocation7_AppliedAmount_GBP`,
        alloc.`Allocation8_AppliedAmount_AUD`,
        alloc.`Allocation8_AppliedAmount_USD`,
        alloc.`Allocation8_AppliedAmount_NZD`,
        alloc.`Allocation8_AppliedAmount_EUR`,
        alloc.`Allocation8_AppliedAmount_GBP`,
        alloc.`Allocation9_AppliedAmount_AUD`,
        alloc.`Allocation9_AppliedAmount_USD`,
        alloc.`Allocation9_AppliedAmount_NZD`,
        alloc.`Allocation9_AppliedAmount_EUR`,
        alloc.`Allocation9_AppliedAmount_GBP`,
        alloc.`Allocation10_AppliedAmount_AUD`,
        alloc.`Allocation10_AppliedAmount_USD`,
        alloc.`Allocation10_AppliedAmount_NZD`,
        alloc.`Allocation10_AppliedAmount_EUR`,
        alloc.`Allocation10_AppliedAmount_GBP`
    FROM ', @overpaymentsStage, ' ovrpymt
    LEFT JOIN (
    SELECT 
            OverpaymentId,
            MAX(CASE WHEN AllocationNumber = 1 THEN AppliedAmount END) AS Allocation1_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 1 THEN AUD END) AS `Allocation1_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 1 THEN USD END) AS  `Allocation1_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 1 THEN NZD END) AS  `Allocation1_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 1 THEN EUR END) AS  `Allocation1_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 1 THEN GBP END) AS  `Allocation1_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 2 THEN AppliedAmount END) AS Allocation2_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 2 THEN AUD END) AS `Allocation2_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 2 THEN USD END) AS  `Allocation2_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 2 THEN NZD END) AS  `Allocation2_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 2 THEN EUR END) AS  `Allocation2_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 2 THEN GBP END) AS  `Allocation2_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 3 THEN AppliedAmount END) AS Allocation3_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 3 THEN AUD END) AS `Allocation3_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 3 THEN USD END) AS  `Allocation3_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 3 THEN NZD END) AS  `Allocation3_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 3 THEN EUR END) AS  `Allocation3_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 3 THEN GBP END) AS  `Allocation3_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 4 THEN AppliedAmount END) AS Allocation4_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 4 THEN AUD END) AS `Allocation4_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 4 THEN USD END) AS  `Allocation4_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 4 THEN NZD END) AS  `Allocation4_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 4 THEN EUR END) AS  `Allocation4_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 4 THEN GBP END) AS  `Allocation4_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 5 THEN AppliedAmount END) AS Allocation5_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 5 THEN AUD END) AS `Allocation5_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 5 THEN USD END) AS  `Allocation5_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 5 THEN NZD END) AS  `Allocation5_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 5 THEN EUR END) AS  `Allocation5_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 5 THEN GBP END) AS  `Allocation5_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 6 THEN AppliedAmount END) AS Allocation6_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 6 THEN AUD END) AS `Allocation6_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 6 THEN USD END) AS  `Allocation6_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 6 THEN NZD END) AS  `Allocation6_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 6 THEN EUR END) AS  `Allocation6_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 6 THEN GBP END) AS  `Allocation6_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 7 THEN AppliedAmount END) AS Allocation7_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 7 THEN AUD END) AS `Allocation7_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 7 THEN USD END) AS  `Allocation7_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 7 THEN NZD END) AS  `Allocation7_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 7 THEN EUR END) AS  `Allocation7_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 7 THEN GBP END) AS  `Allocation7_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 8 THEN AppliedAmount END) AS Allocation8_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 8 THEN AUD END) AS `Allocation8_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 8 THEN USD END) AS  `Allocation8_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 8 THEN NZD END) AS  `Allocation8_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 8 THEN EUR END) AS  `Allocation8_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 8 THEN GBP END) AS  `Allocation8_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 9 THEN AppliedAmount END) AS Allocation9_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 9 THEN AUD END) AS `Allocation9_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 9 THEN USD END) AS  `Allocation9_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 9 THEN NZD END) AS  `Allocation9_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 9 THEN EUR END) AS  `Allocation9_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 9 THEN GBP END) AS  `Allocation9_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 10 THEN AppliedAmount END) AS Allocation10_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 10 THEN AUD END) AS `Allocation10_AppliedAmount_AUD`,
            MAX(CASE WHEN AllocationNumber = 10 THEN USD END) AS  `Allocation10_AppliedAmount_USD`,
            MAX(CASE WHEN AllocationNumber = 10 THEN NZD END) AS  `Allocation10_AppliedAmount_NZD`,
            MAX(CASE WHEN AllocationNumber = 10 THEN EUR END) AS  `Allocation10_AppliedAmount_EUR`,
            MAX(CASE WHEN AllocationNumber = 10 THEN GBP END) AS  `Allocation10_AppliedAmount_GBP`       
         FROM Allocations
         GROUP BY OverpaymentId) alloc ON ovrpymt.OverpaymentId = alloc.OverpaymentId;
		');

  PREPARE stmt6 FROM @insert_xeroblue_overpayments;
  EXECUTE stmt6;
  DEALLOCATE PREPARE stmt6;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_manualjournals`
--
CREATE PROCEDURE sp_dynamic_xeroblue_manualjournals (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  -- Replace hardcoded table references with dynamic ones
  SET @manualjournalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_manualjournalsstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt0 FROM @insert_fxtable;
  EXECUTE stmt0;
  DEALLOCATE PREPARE stmt0;

  SET @updatemanualjournalsStage3 = CONCAT('UPDATE ', @manualjournalsStage, ' AS mnljrnl
         LEFT JOIN c1518_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `mnljrnl`.`OrganisationID`
	      LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN mnljrnl.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN mnljrnl.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE mnljrnl.`Date` 
	                                                                END
	    SET  `JournalLine_LineAmount_AUD` = `mnljrnl`.`JournalLine_LineAmount` * `AUD`
		,`JournalLine_LineAmount_USD` = `mnljrnl`.`JournalLine_LineAmount` * `USD`
		,`JournalLine_LineAmount_NZD` = `mnljrnl`.`JournalLine_LineAmount` * `NZD`
		,`JournalLine_LineAmount_EUR` = `mnljrnl`.`JournalLine_LineAmount` * `EUR`
		,`JournalLine_LineAmount_GBP` = `mnljrnl`.`JournalLine_LineAmount` * `GBP`
		,`JournalLine_TaxAmount_AUD` = `mnljrnl`.`JournalLine_TaxAmount` * `AUD`
		,`JournalLine_TaxAmount_USD` = `mnljrnl`.`JournalLine_TaxAmount` * `USD`
		,`JournalLine_TaxAmount_NZD` = `mnljrnl`.`JournalLine_TaxAmount` * `NZD`
		,`JournalLine_TaxAmount_EUR` = `mnljrnl`.`JournalLine_TaxAmount` * `EUR`
		,`JournalLine_TaxAmount_GBP` = `mnljrnl`.`JournalLine_TaxAmount` * `GBP`;
		');

  PREPARE stmt1 FROM @updatemanualjournalsStage3;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;

  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_manualjournals TRG
    		INNER JOIN ', @manualjournalsStage, ' STG 
        	ON TRG.`ManualJournalId` = STG.`ManualJournalId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt2 FROM @delete_trg;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


  SET @insert_xeroblue_manualjournals = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_manualjournals (
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        `Date`,
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        `UpdatedDateUTC`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    )
     SELECT
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        NULLIF(`Date`, ''''),
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        NULLIF(`UpdatedDateUTC`, ''''),
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    FROM ', @manualjournalsStage, ';
		');

  PREPARE stmt3 FROM @insert_xeroblue_manualjournals;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_lastrefreshdate`
--
CREATE PROCEDURE sp_dynamic_xeroblue_lastrefreshdate (IN p_CID int,
IN p_TableName varchar(255),
IN p_RefreshRowCount int,
IN p_TotalRowCount int,
IN p_StartDate datetime,
IN p_EndDate datetime,
IN p_LastRefreshUTCDate datetime,
IN p_LoadType varchar(255),
IN p_RefreshStatus varchar(255),
IN p_JobRunId bigint,
IN p_DatabaseDestination varchar(255),
IN p_ClientID varchar(255),
IN p_OrganisationID int,
IN p_TriggerType varchar(255),
IN p_RefreshDetails varchar(255))
BEGIN
  DECLARE v_NewID int;

  --             SELECT COALESCE(MAX(ID), 0) + 1 INTO v_NewID FROM `c1834_xeroblue_lastrefreshdate`;

  SET @lastRefreshDateTable = CONCAT('c', p_CID, '_xeroblue_lastrefreshdate');

  SET @newid_sql = CONCAT('SELECT COALESCE(MAX(ID), 0) + 1 INTO @v_NewID FROM `', @lastRefreshDateTable, '`;');
  PREPARE new_stmt FROM @newid_sql;
  EXECUTE new_stmt;
  DEALLOCATE PREPARE new_stmt;
  SET v_NewID = @v_NewID;

  SET @insert_sql = CONCAT('INSERT INTO `', COALESCE(@lastRefreshDateTable, ''), '` (',
  '`Id`, `TableName`, `RefreshRowCount`, `TotalRowCount`, `StartDate`, `EndDate`, ',
  '`LastRefreshUTCDate`, `LoadType`, `RefreshStatus`, `JobRunId`, `DatabaseDestination`, ',
  '`ClientID`, `OrganisationID`, `TriggerType`, `RefreshDetails` ) VALUES (',
  COALESCE(v_NewID, 0), ', ',
  '''', COALESCE(p_TableName, ''), ''', ',
  COALESCE(p_RefreshRowCount, 0), ', ',
  COALESCE(p_TotalRowCount, 0), ', ',
  IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_StartDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
  IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_EndDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
  IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_LastRefreshUTCDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
  '''', COALESCE(p_LoadType, ''), ''', ',
  '''', COALESCE(p_RefreshStatus, ''), ''', ',
  COALESCE(p_JobRunId, 'NULL'), ', ',
  '''', COALESCE(p_DatabaseDestination, ''), ''', ',
  '''', COALESCE(p_ClientID, ''), ''', ',
  COALESCE(p_OrganisationID, 'NULL'), ', ',
  '''', COALESCE(p_TriggerType, ''), ''', ',
  '''', COALESCE(p_RefreshDetails, ''), '''',
  ') ON DUPLICATE KEY UPDATE ',
  '`RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`), ',
  '`TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`), ',
  '`StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`), ',
  '`EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`), ',
  '`LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`), ',
  '`LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`), ',
  '`RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`), ',
  '`JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`), ',
  '`DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`), ',
  '`TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`), ',
  '`RefreshDetails` = VALUES(`RefreshDetails`)');


  PREPARE ins_stmt FROM @insert_sql;
  EXECUTE ins_stmt;
  DEALLOCATE PREPARE ins_stmt;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_items`
--
CREATE PROCEDURE sp_dynamic_xeroblue_items (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_table_name varchar(255) DEFAULT CONCAT('c', v_clientID, '_xeroblue_items');
  DECLARE column_list text DEFAULT '';
  DECLARE column_list2 text DEFAULT '';
  DECLARE done int DEFAULT 0;
  DECLARE col_name varchar(255);
  DECLARE col_type varchar(255);

  -- Declare cursor to retrieve column names and types dynamically
  DECLARE cur CURSOR FOR
  SELECT
    COLUMN_NAME,
    DATA_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = v_table_name
  AND TABLE_SCHEMA = DATABASE();

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  SET @defaultStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_itemsstage');



  SET @update_items = CONCAT('        
        UPDATE `', @defaultStage, '`
        SET
            `CodeUID` = CONCAT(`Code`, CAST(`OrganisationID` AS CHAR)),
            `InventoryCodeUID` = CONCAT(`InventoryAssetAccountCode`, CAST(`OrganisationID` AS CHAR));
        ');
  PREPARE stmt FROM @update_items;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @delete_default = CONCAT('
		DELETE FROM ', v_table_name, ' 
		 WHERE `OrganisationId` = ', v_OrganisationID, ';
		');

  PREPARE stmt2 FROM @delete_default;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


  -- Process columns dynamically
  OPEN cur;
    read_loop:
  LOOP
    FETCH cur INTO col_name, col_type;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET column_list = CONCAT(column_list, '`', col_name, '`, ');
    -- Handle date/datetime columns: convert '' to NULL
    IF col_type IN ('date', 'datetime', 'timestamp') THEN
      SET column_list2 = CONCAT(column_list2,
      'NULLIF(`', col_name, '`, NULL) AS `', col_name, '`, ');
    ELSE
      SET column_list2 = CONCAT(column_list2, '`', col_name, '`, ');
    END IF;
  END LOOP;
  CLOSE cur;

  -- Remove trailing comma from column_list
  SET column_list = LEFT(column_list, CHAR_LENGTH(column_list) - 2);
  SET column_list2 = LEFT(column_list2, CHAR_LENGTH(column_list2) - 2);

  -- Dynamic INSERT with transformed date values
  SET @insert_sql = CONCAT('INSERT INTO ', v_table_name, '(', column_list, ') 
        SELECT ', column_list2, ' FROM ', @defaultStage, '
        ;');

  PREPARE stmt FROM @insert_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


END
$$

--
-- Create procedure `sp_dynamic_xeroblue_invoicesdraft`
--
CREATE PROCEDURE sp_dynamic_xeroblue_invoicesdraft (IN p_clientID int, IN p_orgID int, IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @invoicesDraftStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_invoicesdraftstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE fx_stmt FROM @create_fxtable;
  EXECUTE fx_stmt;
  DEALLOCATE PREPARE fx_stmt;


  SET @insert_fxtable = CONCAT('
        INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
        SELECT 
            `BaseCurrency`,
            `Date`,
            AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
            AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
            AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
            AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
            AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
        FROM foreignexchange_master
        WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
        GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE ins_fx_stmt FROM @insert_fxtable;
  EXECUTE ins_fx_stmt;
  DEALLOCATE PREPARE ins_fx_stmt;

  SET @update_sql = CONCAT('
        UPDATE ', @invoicesDraftStage, '
        SET
            `DiscountRate` = IFNULL(`LineItem_DiscountRate`, 0), 
            `DiscountRate%` = IFNULL(`LineItem_DiscountRate` * 0.01, 0),
            `LineAmountCalculation` = CAST(
                CASE 
                    WHEN `LineAmountTypes` = ''INCLUSIVE'' AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                    WHEN `LineAmountTypes` = ''INCLUSIVE'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                    WHEN (`LineAmountTypes` = ''EXCLUSIVE'' OR `LineAmountTypes` = ''NOTAX'') AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount`)
                    WHEN (`LineAmountTypes` = ''EXCLUSIVE'' OR `LineAmountTypes` = ''NOTAX'') AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
                    ELSE 0 
                END AS DECIMAL(15, 4)
            ),     
            `LineAmountCalculationIncTax` = CAST(
                CASE 
                    WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount`)
                    WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
                    WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    ELSE 0 
                END AS DECIMAL(15, 4)
            ),    	
            `LineAmountTradeCreditorCalculation` = CAST(
                CASE 
                    WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount`)
                    WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    ELSE 0 
                END AS DECIMAL(15, 4)
            ),   
            `LineAmountTradeDebtorCalculation` = CAST(
                CASE 
                    WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
                    WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                    ELSE 0 
                END AS DECIMAL(15, 4)
            ),
            `DayDifference` = CASE WHEN `FullyPaidOnDate` = '''' OR `FullyPaidOnDate` IS NULL
                                    OR `Date` = '''' OR `Date` IS NULL THEN NULL 
                            ELSE DATEDIFF(
                                  NULLIF(NULLIF(`FullyPaidOnDate`, ''''), ''0000-00-00''), 
                                  NULLIF(`Date`, '''')
                              )
            END ,
            `Account_UID` = CONCAT(`LineItem_AccountCode`, ''-'', `OrganisationID`)
        ;');

  PREPARE upd_stmt FROM @update_sql;
  EXECUTE upd_stmt;
  DEALLOCATE PREPARE upd_stmt;

  SET @update_sql = CONCAT('
        UPDATE `', @invoicesDraftStage, '` AS `inv`
        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = inv.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN inv.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN inv.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE inv.`Date` 
	                                                                END
        SET  
            `LineItem_UnitAmount_AUD` = `inv`.`LineItem_UnitAmount` * `AUD`,
            `LineItem_UnitAmount_USD` = `inv`.`LineItem_UnitAmount` * `USD`,
            `LineItem_UnitAmount_NZD` = `inv`.`LineItem_UnitAmount` * `NZD`,
            `LineItem_UnitAmount_EUR` = `inv`.`LineItem_UnitAmount` * `EUR`,
            `LineItem_UnitAmount_GBP` = `inv`.`LineItem_UnitAmount` * `GBP`,
            `LineItem_TaxAmount_AUD` = `inv`.`LineItem_TaxAmount` * `AUD`,
            `LineItem_TaxAmount_USD` = `inv`.`LineItem_TaxAmount` * `USD`,
            `LineItem_TaxAmount_NZD` = `inv`.`LineItem_TaxAmount` * `NZD`,
            `LineItem_TaxAmount_EUR` = `inv`.`LineItem_TaxAmount` * `EUR`,
            `LineItem_TaxAmount_GBP` = `inv`.`LineItem_TaxAmount` * `GBP`,
            `LineItem_LineAmount_AUD` = `inv`.`LineItem_LineAmount` * `AUD`,
            `LineItem_LineAmount_USD` = `inv`.`LineItem_LineAmount` * `USD`,
            `LineItem_LineAmount_NZD` = `inv`.`LineItem_LineAmount` * `NZD`,
            `LineItem_LineAmount_EUR` = `inv`.`LineItem_LineAmount` * `EUR`,
            `LineItem_LineAmount_GBP` = `inv`.`LineItem_LineAmount` * `GBP`,
            `LineItem_DiscountAmount_AUD` = `inv`.`LineItem_DiscountAmount` * `AUD`,
            `LineItem_DiscountAmount_USD` = `inv`.`LineItem_DiscountAmount` * `USD`,
            `LineItem_DiscountAmount_NZD` = `inv`.`LineItem_DiscountAmount` * `NZD`,
            `LineItem_DiscountAmount_EUR` = `inv`.`LineItem_DiscountAmount` * `EUR`,
            `LineItem_DiscountAmount_GBP` = `inv`.`LineItem_DiscountAmount` * `GBP`,
            `SubTotal_AUD` = `inv`.`SubTotal` * `AUD`,
            `SubTotal_USD` = `inv`.`SubTotal` * `USD`,
            `SubTotal_NZD` = `inv`.`SubTotal` * `NZD`,
            `SubTotal_EUR` = `inv`.`SubTotal` * `EUR`,
            `SubTotal_GBP` = `inv`.`SubTotal` * `GBP`,
            `TotalTax_AUD` = `inv`.`TotalTax` * `AUD`,
            `TotalTax_USD` = `inv`.`TotalTax` * `USD`,
            `TotalTax_NZD` = `inv`.`TotalTax` * `NZD`,
            `TotalTax_EUR` = `inv`.`TotalTax` * `EUR`,
            `TotalTax_GBP` = `inv`.`TotalTax` * `GBP`,
            `Total_AUD` = `inv`.`Total` * `AUD`,
            `Total_USD` = `inv`.`Total` * `USD`,
            `Total_NZD` = `inv`.`Total` * `NZD`,
            `Total_EUR` = `inv`.`Total` * `EUR`,
            `Total_GBP` = `inv`.`Total` * `GBP`,
            `TotalDiscount_AUD` = `inv`.`TotalDiscount` * `AUD`,
            `TotalDiscount_USD` = `inv`.`TotalDiscount` * `USD`,
            `TotalDiscount_NZD` = `inv`.`TotalDiscount` * `NZD`,
            `TotalDiscount_EUR` = `inv`.`TotalDiscount` * `EUR`,
            `TotalDiscount_GBP` = `inv`.`TotalDiscount` * `GBP`,
            `AmountDue_AUD` = `inv`.`AmountDue` * `AUD`,
            `AmountDue_USD` = `inv`.`AmountDue` * `USD`,
            `AmountDue_NZD` = `inv`.`AmountDue` * `NZD`,
            `AmountDue_EUR` = `inv`.`AmountDue` * `EUR`,
            `AmountDue_GBP` = `inv`.`AmountDue` * `GBP`,
            `AmountPaid_AUD` = `inv`.`AmountPaid` * `AUD`,
            `AmountPaid_USD` = `inv`.`AmountPaid` * `USD`,
            `AmountPaid_NZD` = `inv`.`AmountPaid` * `NZD`,
            `AmountPaid_EUR` = `inv`.`AmountPaid` * `EUR`,
            `AmountPaid_GBP` = `inv`.`AmountPaid` * `GBP`,
            `CISDeduction_AUD` = `inv`.`CISDeduction` * `AUD`,
            `CISDeduction_USD` = `inv`.`CISDeduction` * `USD`,
            `CISDeduction_NZD` = `inv`.`CISDeduction` * `NZD`,
            `CISDeduction_EUR` = `inv`.`CISDeduction` * `EUR`,
            `CISDeduction_GBP` = `inv`.`CISDeduction` * `GBP`,
            `AmountCredited_AUD` = `inv`.`AmountCredited` * `AUD`,
            `AmountCredited_USD` = `inv`.`AmountCredited` * `USD`,
            `AmountCredited_NZD` = `inv`.`AmountCredited` * `NZD`,
            `AmountCredited_EUR` = `inv`.`AmountCredited` * `EUR`,
            `AmountCredited_GBP` = `inv`.`AmountCredited` * `GBP`,
            `LineAmountCalculation_AUD` = `inv`.`LineAmountCalculation` * `AUD`,
            `LineAmountCalculation_USD` = `inv`.`LineAmountCalculation` * `USD`,
            `LineAmountCalculation_NZD` = `inv`.`LineAmountCalculation` * `NZD`,
            `LineAmountCalculation_EUR` = `inv`.`LineAmountCalculation` * `EUR`,
            `LineAmountCalculation_GBP` = `inv`.`LineAmountCalculation` * `GBP`,
            `LineAmountCalculationIncTax_AUD` = `inv`.`LineAmountCalculationIncTax` * `AUD`,
            `LineAmountCalculationIncTax_USD` = `inv`.`LineAmountCalculationIncTax` * `USD`,
            `LineAmountCalculationIncTax_NZD` = `inv`.`LineAmountCalculationIncTax` * `NZD`,
            `LineAmountCalculationIncTax_EUR` = `inv`.`LineAmountCalculationIncTax` * `EUR`,
            `LineAmountCalculationIncTax_GBP` = `inv`.`LineAmountCalculationIncTax` * `GBP`,
            `LineAmountTradeCreditorCalculation_AUD` = `inv`.`LineAmountTradeCreditorCalculation` * `AUD`,
            `LineAmountTradeCreditorCalculation_USD` = `inv`.`LineAmountTradeCreditorCalculation` * `USD`,
            `LineAmountTradeCreditorCalculation_NZD` = `inv`.`LineAmountTradeCreditorCalculation` * `NZD`,
            `LineAmountTradeCreditorCalculation_EUR` = `inv`.`LineAmountTradeCreditorCalculation` * `EUR`,
            `LineAmountTradeCreditorCalculation_GBP` = `inv`.`LineAmountTradeCreditorCalculation` * `GBP`,
            `LineAmountTradeDebtorCalculation_AUD` = `inv`.`LineAmountTradeDebtorCalculation` * `AUD`,
            `LineAmountTradeDebtorCalculation_USD` = `inv`.`LineAmountTradeDebtorCalculation` * `USD`,
            `LineAmountTradeDebtorCalculation_NZD` = `inv`.`LineAmountTradeDebtorCalculation` * `NZD`,
            `LineAmountTradeDebtorCalculation_EUR` = `inv`.`LineAmountTradeDebtorCalculation` * `EUR`,
            `LineAmountTradeDebtorCalculation_GBP` = `inv`.`LineAmountTradeDebtorCalculation` * `GBP`
            ;');

  PREPARE upd_fx_stmt FROM @update_sql;
  EXECUTE upd_fx_stmt;
  DEALLOCATE PREPARE upd_fx_stmt;


  -- init batching vars
  SET @ffset = 0;
  SET @rowcount = 1;
  SET @batchsize = 500;



  WHILE @rowcount > 0 DO
    SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_invoicesdraft TRG
          INNER JOIN (
          SELECT InvoiceId FROM `', @invoicesDraftStage, '`
          GROUP BY InvoiceId
          ORDER BY InvoiceId
          LIMIT ', @batchsize, ' OFFSET ', @ffset, '
          )STG  ON TRG.`InvoiceId` = STG.`InvoiceId`
          WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');
    PREPARE del_stmt FROM @delete_trg;
    EXECUTE del_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE del_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @rowcount = 1;

  WHILE @rowcount > 0 DO
    SET @insert_sql = CONCAT('
        INSERT INTO c', v_clientID, '_xeroblue_invoicesdraft (
            `Id`,
            `InvoiceId`,
            `Type`,
            `ContactId`,
            `ContactName`,
            `LineItem_LineItemId`,
            `LineItem_Description`,
            `LineItem_Quantity`,
            `LineItem_UnitAmount`,
            `LineItem_ItemCode`,
            `LineItem_AccountCode`,
            `LineItem_TaxType`,
            `LineItem_TaxAmount`,
            `LineItem_LineAmount`,
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
            `LineItem_DiscountRate`,
            `LineItem_DiscountAmount`,
            `LineItemAggregate`,
            `Date`,
            `DueDate`,
            `LineAmountTypes`,
            `InvoiceNumber`,
            `Reference`,
            `BrandingThemeId`,
            `URL`,
            `CurrencyCode`,
            `CurrencyRate`,
            `Status`,
            `SentToContact`,
            `ExpectedPaymentDate`,
            `PlannedPaymentDate`,
            `SubTotal`,
            `TotalTax`,
            `Total`,
            `TotalDiscount`,
            `HasAttachments`,
            `PaymentIds`,
            `PrePaymentIds`,
            `OverPaymentIds`,
            `CreditNoteIds`,
            `AmountDue`,
            `AmountPaid`,
            `CISDeduction`,
            `FullyPaidOnDate`,
            `AmountCredited`,
            `UpdatedDateUTC`,
            `CreditNotes`,
            `Prepayments`,
            `Payments`,
            `Overpayments`,
            `RepeatingInvoiceID`,
            `ClientID`,
            `OrganisationID`,
            `LineItem_UnitAmount_AUD`,
            `LineItem_UnitAmount_USD`,
            `LineItem_UnitAmount_NZD`,
            `LineItem_UnitAmount_EUR`,
            `LineItem_UnitAmount_GBP`,
            `LineItem_TaxAmount_AUD`,
            `LineItem_TaxAmount_USD`,
            `LineItem_TaxAmount_NZD`,
            `LineItem_TaxAmount_EUR`,
            `LineItem_TaxAmount_GBP`,
            `LineItem_LineAmount_AUD`,
            `LineItem_LineAmount_USD`,
            `LineItem_LineAmount_NZD`,
            `LineItem_LineAmount_EUR`,
            `LineItem_LineAmount_GBP`,
            `LineItem_DiscountAmount_AUD`,
            `LineItem_DiscountAmount_USD`,
            `LineItem_DiscountAmount_NZD`,
            `LineItem_DiscountAmount_EUR`,
            `LineItem_DiscountAmount_GBP`,
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
            `TotalDiscount_AUD`,
            `TotalDiscount_USD`,
            `TotalDiscount_NZD`,
            `TotalDiscount_EUR`,
            `TotalDiscount_GBP`,
            `AmountDue_AUD`,
            `AmountDue_USD`,
            `AmountDue_NZD`,
            `AmountDue_EUR`,
            `AmountDue_GBP`,
            `AmountPaid_AUD`,
            `AmountPaid_USD`,
            `AmountPaid_NZD`,
            `AmountPaid_EUR`,
            `AmountPaid_GBP`,
            `CISDeduction_AUD`,
            `CISDeduction_USD`,
            `CISDeduction_NZD`,
            `CISDeduction_EUR`,
            `CISDeduction_GBP`,
            `AmountCredited_AUD`,
            `AmountCredited_USD`,
            `AmountCredited_NZD`,
            `AmountCredited_EUR`,
            `AmountCredited_GBP`,
            `DiscountRate`,
            `DiscountRate%`,
            `LineAmountCalculation`,
            `LineAmountCalculationIncTax`,
            `LineAmountTradeCreditorCalculation`,
            `LineAmountTradeDebtorCalculation`,
            `DayDifference`,
            `LineAmountCalculation_AUD`,
            `LineAmountCalculation_USD`,
            `LineAmountCalculation_NZD`,
            `LineAmountCalculation_EUR`,
            `LineAmountCalculation_GBP`,
            `LineAmountCalculationIncTax_AUD`,
            `LineAmountCalculationIncTax_USD`,
            `LineAmountCalculationIncTax_NZD`,
            `LineAmountCalculationIncTax_EUR`,
            `LineAmountCalculationIncTax_GBP`,
            `LineAmountTradeCreditorCalculation_AUD`,
            `LineAmountTradeCreditorCalculation_USD`,
            `LineAmountTradeCreditorCalculation_NZD`,
            `LineAmountTradeCreditorCalculation_EUR`,
            `LineAmountTradeCreditorCalculation_GBP`,
            `LineAmountTradeDebtorCalculation_AUD`,
            `LineAmountTradeDebtorCalculation_USD`,
            `LineAmountTradeDebtorCalculation_NZD`,
            `LineAmountTradeDebtorCalculation_EUR`,
            `LineAmountTradeDebtorCalculation_GBP`,
            `Account_UID`
        )
        SELECT
            NULLIF(`Id`, ''''),
            NULLIF(`InvoiceId`, ''''),
            NULLIF(`Type`, ''''),
            NULLIF(`ContactId`, ''''),
            NULLIF(`ContactName`, ''''),
            NULLIF(`LineItem_LineItemId`, ''''),
            NULLIF(`LineItem_Description`, ''''),
            `LineItem_Quantity`,
            `LineItem_UnitAmount`,
            NULLIF(`LineItem_ItemCode`, ''''),
            NULLIF(`LineItem_AccountCode`, ''''),
            NULLIF(`LineItem_TaxType`, ''''),
            `LineItem_TaxAmount`,
            `LineItem_LineAmount`,
            NULLIF(`LineItem_TrackingCategory1_CategoryId`, ''''),
            NULLIF(`LineItem_TrackingCategory1_CategoryName`, ''''),
            NULLIF(`LineItem_TrackingCategory1_OptionId`, ''''),
            NULLIF(`LineItem_TrackingCategory1_OptionName`, ''''),
            NULLIF(`LineItem_TrackingCategory1_Option_Stat`, ''''),
            NULLIF(`LineItem_TrackingCategory2_CategoryId`, ''''),
            NULLIF(`LineItem_TrackingCategory2_CategoryName`, ''''),
            NULLIF(`LineItem_TrackingCategory2_OptionId`, ''''),
            NULLIF(`LineItem_TrackingCategory2_OptionName`, ''''),
            NULLIF(`LineItem_TrackingCategory2_Option_Stat`, ''''),
            `LineItem_DiscountRate`,
            `LineItem_DiscountAmount`,
            NULLIF(`LineItemAggregate`, ''''),
            CASE 
                WHEN `Date` IS NULL OR `Date` = '''' THEN NULL 
                ELSE DATE(STR_TO_DATE(`Date`, ''%Y-%m-%d %H:%i:%s'')) 
            END,
            CASE 
                WHEN `DueDate` IS NULL OR `DueDate` = '''' THEN NULL 
                ELSE DATE(STR_TO_DATE(`DueDate`, ''%Y-%m-%d %H:%i:%s'')) 
            END,
            NULLIF(`LineAmountTypes`, ''''),
            NULLIF(`InvoiceNumber`, ''''),
            NULLIF(`Reference`, ''''),
            NULLIF(`BrandingThemeId`, ''''),
            NULLIF(`URL`, ''''),
            NULLIF(`CurrencyCode`, ''''),
            `CurrencyRate`,
            NULLIF(`Status`, ''''),
            `SentToContact`,
            CASE 
                WHEN `ExpectedPaymentDate` IS NULL OR `ExpectedPaymentDate` = '''' THEN NULL 
                ELSE DATE(STR_TO_DATE(`ExpectedPaymentDate`, ''%Y-%m-%d %H:%i:%s'')) 
            END,
            CASE 
                WHEN `PlannedPaymentDate` IS NULL OR `PlannedPaymentDate` = '''' THEN NULL 
                ELSE DATE(STR_TO_DATE(`PlannedPaymentDate`, ''%Y-%m-%d %H:%i:%s'')) 
            END,
            `SubTotal`,
            `TotalTax`,
            `Total`,
            `TotalDiscount`,
            `HasAttachments`,
            NULLIF(`PaymentIds`, ''''),
            NULLIF(`PrePaymentIds`, ''''),
            NULLIF(`OverPaymentIds`, ''''),
            NULLIF(`CreditNoteIds`, ''''),
            `AmountDue`,
            `AmountPaid`,
            `CISDeduction`,
            NULLIF(`FullyPaidOnDate`, ''''),
            `AmountCredited`,
            NULLIF(`UpdatedDateUTC`, ''''),
            NULLIF(`CreditNotes`, ''''),
            NULLIF(`Prepayments`, ''''),
            NULLIF(`Payments`, ''''),
            NULLIF(`Overpayments`, ''''),
            NULLIF(`RepeatingInvoiceID`, ''''),
            NULLIF(`ClientID`, ''''),
            NULLIF(`OrganisationID`, ''''),
            `LineItem_UnitAmount_AUD`,
            `LineItem_UnitAmount_USD`,
            `LineItem_UnitAmount_NZD`,
            `LineItem_UnitAmount_EUR`,
            `LineItem_UnitAmount_GBP`,
            `LineItem_TaxAmount_AUD`,
            `LineItem_TaxAmount_USD`,
            `LineItem_TaxAmount_NZD`,
            `LineItem_TaxAmount_EUR`,
            `LineItem_TaxAmount_GBP`,
            `LineItem_LineAmount_AUD`,
            `LineItem_LineAmount_USD`,
            `LineItem_LineAmount_NZD`,
            `LineItem_LineAmount_EUR`,
            `LineItem_LineAmount_GBP`,
            `LineItem_DiscountAmount_AUD`,
            `LineItem_DiscountAmount_USD`,
            `LineItem_DiscountAmount_NZD`,
            `LineItem_DiscountAmount_EUR`,
            `LineItem_DiscountAmount_GBP`,
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
            `TotalDiscount_AUD`,
            `TotalDiscount_USD`,
            `TotalDiscount_NZD`,
            `TotalDiscount_EUR`,
            `TotalDiscount_GBP`,
            `AmountDue_AUD`,
            `AmountDue_USD`,
            `AmountDue_NZD`,
            `AmountDue_EUR`,
            `AmountDue_GBP`,
            `AmountPaid_AUD`,
            `AmountPaid_USD`,
            `AmountPaid_NZD`,
            `AmountPaid_EUR`,
            `AmountPaid_GBP`,
            `CISDeduction_AUD`,
            `CISDeduction_USD`,
            `CISDeduction_NZD`,
            `CISDeduction_EUR`,
            `CISDeduction_GBP`,
            `AmountCredited_AUD`,
            `AmountCredited_USD`,
            `AmountCredited_NZD`,
            `AmountCredited_EUR`,
            `AmountCredited_GBP`,
            `DiscountRate`,
            `DiscountRate%`,
            `LineAmountCalculation`,
            `LineAmountCalculationIncTax`,
            `LineAmountTradeCreditorCalculation`,
            `LineAmountTradeDebtorCalculation`,
            `DayDifference`, 
            `LineAmountCalculation_AUD`,
            `LineAmountCalculation_USD`,
            `LineAmountCalculation_NZD`,
            `LineAmountCalculation_EUR`,
            `LineAmountCalculation_GBP`,
            `LineAmountCalculationIncTax_AUD`,
            `LineAmountCalculationIncTax_USD`,
            `LineAmountCalculationIncTax_NZD`,
            `LineAmountCalculationIncTax_EUR`,
            `LineAmountCalculationIncTax_GBP`,
            `LineAmountTradeCreditorCalculation_AUD`,
            `LineAmountTradeCreditorCalculation_USD`,
            `LineAmountTradeCreditorCalculation_NZD`,
            `LineAmountTradeCreditorCalculation_EUR`,
            `LineAmountTradeCreditorCalculation_GBP`,
            `LineAmountTradeDebtorCalculation_AUD`,
            `LineAmountTradeDebtorCalculation_USD`,
            `LineAmountTradeDebtorCalculation_NZD`,
            `LineAmountTradeDebtorCalculation_EUR`,
            `LineAmountTradeDebtorCalculation_GBP`,
            `Account_UID`
        FROM ', @invoicesDraftStage, '
        ORDER BY InvoiceID
        LIMIT ', @batchsize, ' OFFSET ', @ffset, ';');
    PREPARE ins_stmt FROM @insert_sql;
    EXECUTE ins_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE ins_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_invoices`
--
CREATE PROCEDURE sp_dynamic_xeroblue_invoices (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @invoicesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_invoicesstage');



  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt0 FROM @insert_fxtable;
  EXECUTE stmt0;
  DEALLOCATE PREPARE stmt0;


  SET @updateinvoicesStage = CONCAT('UPDATE ', @invoicesStage, '
        SET
		`DiscountRate` = IFNULL(`LineItem_DiscountRate`, 0), 
		`DiscountRate%` = IFNULL(`LineItem_DiscountRate` * 0.01, 0),
		`LineAmountCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = ''INCLUSIVE'' AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = ''INCLUSIVE'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = ''EXCLUSIVE'' OR `LineAmountTypes` = ''NOTAX'') AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = ''EXCLUSIVE'' OR `LineAmountTypes` = ''NOTAX'') AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),     
		`LineAmountCalculationIncTax` = CAST(
			CASE 
				WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCPAY'' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),    	
		`LineAmountTradeCreditorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCPAY'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),   
		`LineAmountTradeDebtorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCREC'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),
		`DayDifference` =
            CASE
                WHEN NULLIF(`FullyPaidOnDate`,'''') IS NOT NULL THEN DATEDIFF(CAST(`FullyPaidOnDate` AS DATE), CAST(`Date` AS DATE))
                ELSE NULL END,
		`Account_UID` = CONCAT(`LineItem_AccountCode`, ''-'', `OrganisationID`);');

  PREPARE stmt1 FROM @updateinvoicesStage;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;




  SET @updateinvoicesStage3 = CONCAT('UPDATE ', @invoicesStage, ' AS inv
	        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = inv.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN inv.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN inv.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE inv.`Date` 
	                                                                END
	    SET  `LineItem_UnitAmount_AUD` = `inv`.`LineItem_UnitAmount` * `AUD`,
		`LineItem_UnitAmount_USD` = `inv`.`LineItem_UnitAmount` * `USD`,
		`LineItem_UnitAmount_NZD` = `inv`.`LineItem_UnitAmount` * `NZD`,
		`LineItem_UnitAmount_EUR` = `inv`.`LineItem_UnitAmount` * `EUR`,
		`LineItem_UnitAmount_GBP` = `inv`.`LineItem_UnitAmount` * `GBP`,
		`LineItem_TaxAmount_AUD` = `inv`.`LineItem_TaxAmount` * `AUD`,
		`LineItem_TaxAmount_USD` = `inv`.`LineItem_TaxAmount` * `USD`,
		`LineItem_TaxAmount_NZD` = `inv`.`LineItem_TaxAmount` * `NZD`,
		`LineItem_TaxAmount_EUR` = `inv`.`LineItem_TaxAmount` * `EUR`,
		`LineItem_TaxAmount_GBP` = `inv`.`LineItem_TaxAmount` * `GBP`,
		`LineItem_LineAmount_AUD` = `inv`.`LineItem_LineAmount` * `AUD`,
		`LineItem_LineAmount_USD` = `inv`.`LineItem_LineAmount` * `USD`,
		`LineItem_LineAmount_NZD` = `inv`.`LineItem_LineAmount` * `NZD`,
		`LineItem_LineAmount_EUR` = `inv`.`LineItem_LineAmount` * `EUR`,
		`LineItem_LineAmount_GBP` = `inv`.`LineItem_LineAmount` * `GBP`,
		`LineItem_DiscountAmount_AUD` = `inv`.`LineItem_DiscountAmount` * `AUD`,
		`LineItem_DiscountAmount_USD` = `inv`.`LineItem_DiscountAmount` * `USD`,
		`LineItem_DiscountAmount_NZD` = `inv`.`LineItem_DiscountAmount` * `NZD`,
		`LineItem_DiscountAmount_EUR` = `inv`.`LineItem_DiscountAmount` * `EUR`,
		`LineItem_DiscountAmount_GBP` = `inv`.`LineItem_DiscountAmount` * `GBP`,
		`SubTotal_AUD` = `inv`.`SubTotal` * `AUD`,
		`SubTotal_USD` = `inv`.`SubTotal` * `USD`,
		`SubTotal_NZD` = `inv`.`SubTotal` * `NZD`,
		`SubTotal_EUR` = `inv`.`SubTotal` * `EUR`,
		`SubTotal_GBP` = `inv`.`SubTotal` * `GBP`,
		`TotalTax_AUD` = `inv`.`TotalTax` * `AUD`,
		`TotalTax_USD` = `inv`.`TotalTax` * `USD`,
		`TotalTax_NZD` = `inv`.`TotalTax` * `NZD`,
		`TotalTax_EUR` = `inv`.`TotalTax` * `EUR`,
		`TotalTax_GBP` = `inv`.`TotalTax` * `GBP`,
		`Total_AUD` = `inv`.`Total` * `AUD`,
		`Total_USD` = `inv`.`Total` * `USD`,
		`Total_NZD` = `inv`.`Total` * `NZD`,
		`Total_EUR` = `inv`.`Total` * `EUR`,
		`Total_GBP` = `inv`.`Total` * `GBP`,
		`TotalDiscount_AUD` = `inv`.`TotalDiscount` * `AUD`,
		`TotalDiscount_USD` = `inv`.`TotalDiscount` * `USD`,
		`TotalDiscount_NZD` = `inv`.`TotalDiscount` * `NZD`,
		`TotalDiscount_EUR` = `inv`.`TotalDiscount` * `EUR`,
		`TotalDiscount_GBP` = `inv`.`TotalDiscount` * `GBP`,
		`AmountDue_AUD` = `inv`.`AmountDue` * `AUD`,
		`AmountDue_USD` = `inv`.`AmountDue` * `USD`,
		`AmountDue_NZD` = `inv`.`AmountDue` * `NZD`,
		`AmountDue_EUR` = `inv`.`AmountDue` * `EUR`,
		`AmountDue_GBP` = `inv`.`AmountDue` * `GBP`,
		`AmountPaid_AUD` = `inv`.`AmountPaid` * `AUD`,
		`AmountPaid_USD` = `inv`.`AmountPaid` * `USD`,
		`AmountPaid_NZD` = `inv`.`AmountPaid` * `NZD`,
		`AmountPaid_EUR` = `inv`.`AmountPaid` * `EUR`,
		`AmountPaid_GBP` = `inv`.`AmountPaid` * `GBP`,
		`CISDeduction_AUD` = `inv`.`CISDeduction` * `AUD`,
		`CISDeduction_USD` = `inv`.`CISDeduction` * `USD`,
		`CISDeduction_NZD` = `inv`.`CISDeduction` * `NZD`,
		`CISDeduction_EUR` = `inv`.`CISDeduction` * `EUR`,
		`CISDeduction_GBP` = `inv`.`CISDeduction` * `GBP`,
		`AmountCredited_AUD` = `inv`.`AmountCredited` * `AUD`,
		`AmountCredited_USD` = `inv`.`AmountCredited` * `USD`,
		`AmountCredited_NZD` = `inv`.`AmountCredited` * `NZD`,
		`AmountCredited_EUR` = `inv`.`AmountCredited` * `EUR`,
		`AmountCredited_GBP` = `inv`.`AmountCredited` * `GBP`,
		`LineAmountCalculation_AUD` = `inv`.`LineAmountCalculation` * `AUD`,
		`LineAmountCalculation_USD` = `inv`.`LineAmountCalculation` * `USD`,
		`LineAmountCalculation_NZD` = `inv`.`LineAmountCalculation` * `NZD`,
		`LineAmountCalculation_EUR` = `inv`.`LineAmountCalculation` * `EUR`,
		`LineAmountCalculation_GBP` = `inv`.`LineAmountCalculation` * `GBP`,
		`LineAmountCalculationIncTax_AUD` = `inv`.`LineAmountCalculationIncTax` * `AUD`,
		`LineAmountCalculationIncTax_USD` = `inv`.`LineAmountCalculationIncTax` * `USD`,
		`LineAmountCalculationIncTax_NZD` = `inv`.`LineAmountCalculationIncTax` * `NZD`,
		`LineAmountCalculationIncTax_EUR` = `inv`.`LineAmountCalculationIncTax` * `EUR`,
		`LineAmountCalculationIncTax_GBP` = `inv`.`LineAmountCalculationIncTax` * `GBP`,
		`LineAmountTradeCreditorCalculation_AUD` = `inv`.`LineAmountTradeCreditorCalculation` * `AUD`,
		`LineAmountTradeCreditorCalculation_USD` = `inv`.`LineAmountTradeCreditorCalculation` * `USD`,
		`LineAmountTradeCreditorCalculation_NZD` = `inv`.`LineAmountTradeCreditorCalculation` * `NZD`,
		`LineAmountTradeCreditorCalculation_EUR` = `inv`.`LineAmountTradeCreditorCalculation` * `EUR`,
		`LineAmountTradeCreditorCalculation_GBP` = `inv`.`LineAmountTradeCreditorCalculation` * `GBP`,
		`LineAmountTradeDebtorCalculation_AUD` = `inv`.`LineAmountTradeDebtorCalculation` * `AUD`,
		`LineAmountTradeDebtorCalculation_USD` = `inv`.`LineAmountTradeDebtorCalculation` * `USD`,
		`LineAmountTradeDebtorCalculation_NZD` = `inv`.`LineAmountTradeDebtorCalculation` * `NZD`,
		`LineAmountTradeDebtorCalculation_EUR` = `inv`.`LineAmountTradeDebtorCalculation` * `EUR`,
		`LineAmountTradeDebtorCalculation_GBP` = `inv`.`LineAmountTradeDebtorCalculation` * `GBP`;');

  PREPARE stmt2 FROM @updateinvoicesStage3;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;

  -- init batching vars
  SET @ffset = 0;
  SET @rowcount = 1;
  SET @batchsize = 500;

  WHILE @rowcount > 0 DO
    SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_invoices TRG
          INNER JOIN (
          SELECT InvoiceId FROM `', @invoicesStage, '`
          GROUP BY InvoiceId
          ORDER BY InvoiceId
          LIMIT ', @batchsize, ' OFFSET ', @ffset, '
          )STG  ON TRG.`InvoiceId` = STG.`InvoiceId`
          WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');
    PREPARE del_stmt FROM @delete_trg;
    EXECUTE del_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE del_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

  SET @ffset = 0;
  SET @rowcount = 1;

  WHILE @rowcount > 0 DO
    SET @insert_sql = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_invoices (
        `Id`,
        `InvoiceId`,
        `Type`,
        `ContactId`,
        `ContactName`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineItem_DiscountAmount`,
        `LineItemAggregate`,
        `Date`,
        `DueDate`,
        `LineAmountTypes`,
        `InvoiceNumber`,
        `Reference`,
        `BrandingThemeId`,
        `URL`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Status`,
        `SentToContact`,
        `ExpectedPaymentDate`,
        `PlannedPaymentDate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        `PaymentIds`,
        `PrePaymentIds`,
        `OverPaymentIds`,
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        `FullyPaidOnDate`,
        `AmountCredited`,
        `UpdatedDateUTC`,
        `CreditNotes`,
        `Prepayments`,
        `Payments`,
        `Overpayments`,
        `RepeatingInvoiceID`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
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
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`,
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    )
    SELECT
        NULLIF(`Id`, ''''),
        NULLIF(`InvoiceId`, ''''),
        NULLIF(`Type`, ''''),
        NULLIF(`ContactId`, ''''),
        NULLIF(`ContactName`, ''''),
        NULLIF(`LineItem_LineItemId`, ''''),
        NULLIF(`LineItem_Description`, ''''),
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        NULLIF(`LineItem_ItemCode`, ''''),
        NULLIF(`LineItem_AccountCode`, ''''),
        NULLIF(`LineItem_TaxType`, ''''),
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        NULLIF(`LineItem_TrackingCategory1_CategoryId`, ''''),
        NULLIF(`LineItem_TrackingCategory1_CategoryName`, ''''),
        NULLIF(`LineItem_TrackingCategory1_OptionId`, ''''),
        NULLIF(`LineItem_TrackingCategory1_OptionName`, ''''),
        NULLIF(`LineItem_TrackingCategory1_Option_Stat`, ''''),
        NULLIF(`LineItem_TrackingCategory2_CategoryId`, ''''),
        NULLIF(`LineItem_TrackingCategory2_CategoryName`, ''''),
        NULLIF(`LineItem_TrackingCategory2_OptionId`, ''''),
        NULLIF(`LineItem_TrackingCategory2_OptionName`, ''''),
        NULLIF(`LineItem_TrackingCategory2_Option_Stat`, ''''),
        `LineItem_DiscountRate`,
        `LineItem_DiscountAmount`,
        NULLIF(`LineItemAggregate`, ''''),
        NULLIF(`Date`, ''''),
        NULLIF(NULLIF(`DueDate`, ''''), ''1753-01-31 00:00:00+00:00''),
        NULLIF(`LineAmountTypes`, ''''),
        NULLIF(`InvoiceNumber`, ''''),
        NULLIF(`Reference`, ''''),
        NULLIF(`BrandingThemeId`, ''''),
        NULLIF(`URL`, ''''),
        NULLIF(`CurrencyCode`, ''''),
        `CurrencyRate`,
        NULLIF(`Status`, ''''),
        `SentToContact`,
        NULLIF(`ExpectedPaymentDate`, ''''),
        NULLIF(`PlannedPaymentDate`, ''''),
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        NULLIF(`PaymentIds`, ''''),
        NULLIF(`PrePaymentIds`, ''''),
        NULLIF(`OverPaymentIds`, ''''),
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        NULLIF(`FullyPaidOnDate`, ''''),
        `AmountCredited`,
        NULLIF(`UpdatedDateUTC`, ''''),
        NULLIF(`CreditNotes`, ''''),
        NULLIF(`Prepayments`, ''''),
        NULLIF(`Payments`, ''''),
        NULLIF(`Overpayments`, ''''),
        NULLIF(`RepeatingInvoiceID`, ''''),
        NULLIF(`ClientID`, ''''),
        NULLIF(`OrganisationID`, ''''),
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
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
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`, 
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    FROM ', @invoicesStage, '
    ORDER BY InvoiceId
    LIMIT ', @batchsize, ' OFFSET ', @ffset, ';');

    PREPARE ins_stmt FROM @insert_sql;
    EXECUTE ins_stmt;
    SELECT
      ROW_COUNT() INTO @rowcount;
    DEALLOCATE PREPARE ins_stmt;
    SET @ffset = @ffset + @batchsize;
  END WHILE;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_default`
--
CREATE PROCEDURE sp_dynamic_xeroblue_default (IN `p_table_name` varchar(100),
IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  -- Declare local variables first
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_table_name varchar(100) DEFAULT CONCAT('c', v_clientID, '_xeroblue_', p_table_name);
  DECLARE column_list text DEFAULT '';
  DECLARE column_list2 text DEFAULT '';
  DECLARE done int DEFAULT 0;
  DECLARE col_name varchar(255);
  DECLARE col_type varchar(255);

  -- Declare cursor to retrieve column names and types dynamically
  DECLARE cur CURSOR FOR
  SELECT
    COLUMN_NAME,
    DATA_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = v_table_name
  AND TABLE_SCHEMA = DATABASE();

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET v_table_name = LOWER(v_table_name);

  -- Now set session variables
  SET @defaultStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_', p_table_name, 'stage');
  -- SET @defaultTable = CONCAT('c', v_clientID, '_xeroblue_', v_table_name);
  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Dynamic DELETE to clean previous data
  SET @delete_default = CONCAT('DELETE FROM ', v_table_name, ' 
         WHERE `OrganisationId` is NULL or `OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt FROM @delete_default;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  -- Process columns dynamically
  OPEN cur;
    read_loop:
  LOOP
    FETCH cur INTO col_name, col_type;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF col_name <> 'my_row_id' THEN
      SET column_list = CONCAT(column_list, '`', col_name, '`, ');
    END IF;
    -- Handle date/datetime columns: convert '' to NULL
    IF col_type IN ('date', 'datetime', 'timestamp') THEN
      SET column_list2 = CONCAT(column_list2,
      'NULLIF(`', col_name, '`, NULL) AS `', col_name, '`, ');
    ELSE
      IF col_name <> 'my_row_id' THEN
        SET column_list2 = CONCAT(column_list2, '`', col_name, '`, ');
      END IF;
    END IF;
  END LOOP;
  CLOSE cur;

  -- Remove trailing comma from column_list
  SET column_list = LEFT(column_list, CHAR_LENGTH(column_list) - 2);
  SET column_list2 = LEFT(column_list2, CHAR_LENGTH(column_list2) - 2);

  -- Dynamic INSERT with transformed date values
  SET @insert_sql = CONCAT('INSERT INTO ', v_table_name, '(', column_list, ') 
        SELECT ', column_list2, ' FROM ', @defaultStage, '
        ;');

  PREPARE stmt FROM @insert_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_creditnotes`
--
CREATE PROCEDURE sp_dynamic_xeroblue_creditnotes (IN p_clientID varchar(100),
IN p_orgID int,
IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @creditNotesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_creditnotesstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt10 FROM @insert_fxtable;
  EXECUTE stmt10;
  DEALLOCATE PREPARE stmt10;

  -- CreditNotesAllocations temp table creation and population for speedier insertion
  CREATE TEMPORARY TABLE IF NOT EXISTS CreditNotesAllocations (
    AllocationID int AUTO_INCREMENT PRIMARY KEY,
    CreditNoteID varchar(100) NOT NULL,
    AllocationNumber int NOT NULL,
    AllocationDate date NOT NULL,
    AppliedAmount decimal(18, 2) NOT NULL,
    CurrencyCode varchar(10) NOT NULL,
    AUD decimal(18, 6) DEFAULT NULL,
    USD decimal(18, 6) DEFAULT NULL,
    NZD decimal(18, 6) DEFAULT NULL,
    EUR decimal(18, 6) DEFAULT NULL,
    GBP decimal(18, 6) DEFAULT NULL
  );

  SET @insertAllocationsQuery = CONCAT('INSERT INTO CreditNotesAllocations (CreditNoteID, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode)
          SELECT CreditNoteID, 1, Allocation1_Date, Allocation1_AppliedAmount, CurrencyCode
          FROM ', @creditNotesStage, '
          WHERE Allocation1_Date IS NOT NULL
          UNION ALL
          SELECT CreditNoteID, 2, Allocation2_Date, Allocation2_AppliedAmount, CurrencyCode
          FROM ', @creditNotesStage, '
          WHERE Allocation2_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 3, crdt.Allocation3_Date, crdt.Allocation3_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation3_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 4, crdt.Allocation4_Date, crdt.Allocation4_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation4_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 5, crdt.Allocation5_Date, crdt.Allocation5_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation5_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 6, crdt.Allocation6_Date, crdt.Allocation6_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation6_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 7, crdt.Allocation7_Date, crdt.Allocation7_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation7_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 8, crdt.Allocation8_Date, crdt.Allocation8_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation8_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 9, crdt.Allocation9_Date, crdt.Allocation9_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation9_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 10, crdt.Allocation10_Date, crdt.Allocation10_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation10_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 11, crdt.Allocation11_Date, crdt.Allocation11_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation11_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 12, crdt.Allocation12_Date, crdt.Allocation12_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation12_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 13, crdt.Allocation13_Date, crdt.Allocation13_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation13_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 14, crdt.Allocation14_Date, crdt.Allocation14_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation14_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    crdt.CreditNoteID, 15, crdt.Allocation15_Date, crdt.Allocation15_AppliedAmount, crdt.CurrencyCode
		    FROM ', @creditNotesStage, ' AS crdt
		    WHERE crdt.Allocation15_Date IS NOT NULL;');

  PREPARE stmt FROM @insertAllocationsQuery;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  -- Update CreditNotesAllocations currencies
  SET @update_allocations = CONCAT('
	    UPDATE CreditNotesAllocations AS alloc
	    JOIN ', @fx_table, ' AS fx
	        ON fx.BaseCurrency = alloc.CurrencyCode
	        AND fx.Date = CASE
	            WHEN alloc.AllocationDate <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	            WHEN alloc.AllocationDate >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	            ELSE alloc.AllocationDate
	        END
	    SET alloc.AUD = alloc.AppliedAmount * fx.AUD,
	        alloc.USD = alloc.AppliedAmount * fx.USD,
	        alloc.NZD = alloc.AppliedAmount * fx.NZD,
	        alloc.EUR = alloc.AppliedAmount * fx.EUR,
	        alloc.GBP = alloc.AppliedAmount * fx.GBP;
	    ');
  PREPARE stmt1 FROM @update_allocations;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;

  SET @updateCreditNotesStage = CONCAT('UPDATE ', @creditNotesStage, '
        SET
                `LineAmountCreditNoteCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAYCREDIT'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCRECCREDIT'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCPAYCREDIT'' THEN 0 - (`LineItem_LineAmount`)
                WHEN (`LineAmountTypes` = ''Exclusive'' OR `LineAmountTypes` = ''NoTax'') AND `Type` = ''ACCRECCREDIT'' THEN (`LineItem_LineAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeCreditorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCPAYCREDIT'' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCPAYCREDIT'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCPAYCREDIT'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeDebtorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = ''Inclusive'' AND `Type` = ''ACCRECCREDIT'' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = ''Exclusive'' AND `Type` = ''ACCRECCREDIT'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = ''NoTax'' AND `Type` = ''ACCRECCREDIT'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        );');

  PREPARE stmt2 FROM @updateCreditNotesStage;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;




  SET @updateCreditNotesStage3 = CONCAT('UPDATE ', @creditNotesStage, ' AS crdt
	        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = crdt.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN crdt.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN crdt.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE crdt.`Date` 
	                                                                END
	    SET  `LineItem_UnitAmount_AUD` = crdt.`LineItem_UnitAmount` * fx.`AUD`
	                ,`LineItem_UnitAmount_USD` = crdt.`LineItem_UnitAmount` * fx.`USD`
	                ,`LineItem_UnitAmount_NZD` = crdt.`LineItem_UnitAmount` * fx.`NZD`
	                ,`LineItem_UnitAmount_EUR` = crdt.`LineItem_UnitAmount` * fx.`EUR`
	                ,`LineItem_UnitAmount_GBP` = crdt.`LineItem_UnitAmount` * fx.`GBP`
	                ,`LineItem_TaxAmount_AUD` = crdt.`LineItem_TaxAmount` * fx.`AUD`
	                ,`LineItem_TaxAmount_USD` = crdt.`LineItem_TaxAmount` * fx.`USD`
	                ,`LineItem_TaxAmount_NZD` = crdt.`LineItem_TaxAmount` * fx.`NZD`
	                ,`LineItem_TaxAmount_EUR` = crdt.`LineItem_TaxAmount` * fx.`EUR`
	                ,`LineItem_TaxAmount_GBP` = crdt.`LineItem_TaxAmount` * fx.`GBP`
	                ,`LineItem_LineAmount_AUD` = crdt.`LineItem_LineAmount` * fx.`AUD`
	                ,`LineItem_LineAmount_USD` = crdt.`LineItem_LineAmount` * fx.`USD`
	                ,`LineItem_LineAmount_NZD` = crdt.`LineItem_LineAmount` * fx.`NZD`
	                ,`LineItem_LineAmount_EUR` = crdt.`LineItem_LineAmount` * fx.`EUR`
	                ,`LineItem_LineAmount_GBP` = crdt.`LineItem_LineAmount` * fx.`GBP`
	                ,`SubTotal_AUD` = crdt.`SubTotal` * fx.`AUD`
	                ,`SubTotal_USD` = crdt.`SubTotal` * fx.`USD`
	                ,`SubTotal_NZD` = crdt.`SubTotal` * fx.`NZD`
	                ,`SubTotal_EUR` = crdt.`SubTotal` * fx.`EUR`
	                ,`SubTotal_GBP` = crdt.`SubTotal` * fx.`GBP`
	                ,`TotalTax_AUD` = crdt.`TotalTax` * fx.`AUD`
	                ,`TotalTax_USD` = crdt.`TotalTax` * fx.`USD`
	                ,`TotalTax_NZD` = crdt.`TotalTax` * fx.`NZD`
	                ,`TotalTax_EUR` = crdt.`TotalTax` * fx.`EUR`
	                ,`TotalTax_GBP` = crdt.`TotalTax` * fx.`GBP`
	                ,`Total_AUD` = crdt.`Total` * fx.`AUD`
	                ,`Total_USD` = crdt.`Total` * fx.`USD`
	                ,`Total_NZD` = crdt.`Total` * fx.`NZD`
	                ,`Total_EUR` = crdt.`Total` * fx.`EUR`
	                ,`Total_GBP` = crdt.`Total` * fx.`GBP`
	                ,`RemainingCredit_AUD` = crdt.`RemainingCredit` * fx.`AUD`
	                ,`RemainingCredit_USD` = crdt.`RemainingCredit` * fx.`USD`
	                ,`RemainingCredit_NZD` = crdt.`RemainingCredit` * fx.`NZD`
	                ,`RemainingCredit_EUR` = crdt.`RemainingCredit` * fx.`EUR`
	                ,`RemainingCredit_GBP` = crdt.`RemainingCredit` * fx.`GBP`
	        ,`LineAmountCreditNoteCalculation_AUD` = crdt.`LineAmountCreditNoteCalculation` * fx.`AUD`
	        ,`LineAmountCreditNoteCalculation_USD` = crdt.`LineAmountCreditNoteCalculation` * fx.`USD`
	        ,`LineAmountCreditNoteCalculation_NZD` = crdt.`LineAmountCreditNoteCalculation` * fx.`NZD`
	        ,`LineAmountCreditNoteCalculation_EUR` = crdt.`LineAmountCreditNoteCalculation` * fx.`EUR`
	        ,`LineAmountCreditNoteCalculation_GBP` = crdt.`LineAmountCreditNoteCalculation` * fx.`GBP`
	        ,`LineAmountTradeCreditorCalculation_AUD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`AUD`
	        ,`LineAmountTradeCreditorCalculation_USD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`USD`
	        ,`LineAmountTradeCreditorCalculation_NZD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`NZD`
	        ,`LineAmountTradeCreditorCalculation_EUR` = crdt.`LineAmountTradeCreditorCalculation` * fx.`EUR`
	        ,`LineAmountTradeCreditorCalculation_GBP` = crdt.`LineAmountTradeCreditorCalculation` * fx.`GBP`
	        ,`LineAmountTradeDebtorCalculation_AUD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`AUD`
	        ,`LineAmountTradeDebtorCalculation_USD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`USD`
	        ,`LineAmountTradeDebtorCalculation_NZD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`NZD`
	        ,`LineAmountTradeDebtorCalculation_EUR` = crdt.`LineAmountTradeDebtorCalculation` * fx.`EUR`
	        ,`LineAmountTradeDebtorCalculation_GBP` = crdt.`LineAmountTradeDebtorCalculation` * fx.`GBP`;');

  PREPARE stmt4 FROM @updateCreditNotesStage3;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;

  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_creditnotes TRG
    		INNER JOIN ', @creditNotesStage, ' STG 
        	ON TRG.`CreditNoteId` = STG.`CreditNoteId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt5 FROM @delete_trg;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;


  SET @insert_xeroblue_creditnotes = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_creditnotes (
        `Id`,
        `CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Date`,
        `Status`,
        `LineAmountTypes`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `UpdatedDateUTC`,
        `CurrencyCode`,
        `FullyPaidOnDate`,
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `Allocation11_AppliedAmount`,
        `Allocation11_Date`,
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        `Allocation12_AppliedAmount`,
        `Allocation12_Date`,
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        `Allocation13_AppliedAmount`,
        `Allocation13_Date`,
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        `Allocation14_AppliedAmount`,
        `Allocation14_Date`,
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        `Allocation15_AppliedAmount`,
        `Allocation15_Date`,
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
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
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`,
        `Allocation11_AppliedAmount_AUD`,
        `Allocation11_AppliedAmount_USD`,
        `Allocation11_AppliedAmount_NZD`,
        `Allocation11_AppliedAmount_EUR`,
        `Allocation11_AppliedAmount_GBP`,
        `Allocation12_AppliedAmount_AUD`,
        `Allocation12_AppliedAmount_USD`,
        `Allocation12_AppliedAmount_NZD`,
        `Allocation12_AppliedAmount_EUR`,
        `Allocation12_AppliedAmount_GBP`,
        `Allocation13_AppliedAmount_AUD`,
        `Allocation13_AppliedAmount_USD`,
        `Allocation13_AppliedAmount_NZD`,
        `Allocation13_AppliedAmount_EUR`,
        `Allocation13_AppliedAmount_GBP`,
        `Allocation14_AppliedAmount_AUD`,
        `Allocation14_AppliedAmount_USD`,
        `Allocation14_AppliedAmount_NZD`,
        `Allocation14_AppliedAmount_EUR`,
        `Allocation14_AppliedAmount_GBP`,
        `Allocation15_AppliedAmount_AUD`,
        `Allocation15_AppliedAmount_USD`,
        `Allocation15_AppliedAmount_NZD`,
        `Allocation15_AppliedAmount_EUR`,
        `Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    )
     SELECT
        `Id`,
        crdt.`CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        CASE 
            WHEN NULLIF(`Date`, '''') IS NULL THEN NULL
            WHEN `Date` LIKE ''%+%'' THEN STR_TO_DATE(SUBSTRING_INDEX(`Date`, ''+'', 1), ''%Y-%m-%d %H:%i:%s'')
            ELSE CAST(`Date` AS DATE)
        END,
        `Status`,
        `LineAmountTypes`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
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
        `LineItem_DiscountRate`,
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        NULLIF(`UpdatedDateUTC`, ''''),
        crdt.`CurrencyCode`,
        NULLIF(`FullyPaidOnDate`, ''''),
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
        alloc.`Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, ''''),
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        alloc.`Allocation11_AppliedAmount`,
        NULLIF(`Allocation11_Date`, ''''),
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        alloc.`Allocation12_AppliedAmount`,
        NULLIF(`Allocation12_Date`, ''''),
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        alloc.`Allocation13_AppliedAmount`,
        NULLIF(`Allocation13_Date`, ''''),
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        alloc.`Allocation14_AppliedAmount`,
        NULLIF(`Allocation14_Date`, ''''),
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        alloc.`Allocation15_AppliedAmount`,
        NULLIF(`Allocation15_Date`, ''''),
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
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
        alloc.`Allocation1_AppliedAmount_AUD`,
        alloc.`Allocation1_AppliedAmount_USD`,
        alloc.`Allocation1_AppliedAmount_NZD`,
        alloc.`Allocation1_AppliedAmount_EUR`,
        alloc.`Allocation1_AppliedAmount_GBP`,
        alloc.`Allocation2_AppliedAmount_AUD`,
        alloc.`Allocation2_AppliedAmount_USD`,
        alloc.`Allocation2_AppliedAmount_NZD`,
        alloc.`Allocation2_AppliedAmount_EUR`,
        alloc.`Allocation2_AppliedAmount_GBP`,
        alloc.`Allocation3_AppliedAmount_AUD`,
        alloc.`Allocation3_AppliedAmount_USD`,
        alloc.`Allocation3_AppliedAmount_NZD`,
        alloc.`Allocation3_AppliedAmount_EUR`,
        alloc.`Allocation3_AppliedAmount_GBP`,
        alloc.`Allocation4_AppliedAmount_AUD`,
        alloc.`Allocation4_AppliedAmount_USD`,
        alloc.`Allocation4_AppliedAmount_NZD`,
        alloc.`Allocation4_AppliedAmount_EUR`,
        alloc.`Allocation4_AppliedAmount_GBP`,
        alloc.`Allocation5_AppliedAmount_AUD`,
        alloc.`Allocation5_AppliedAmount_USD`,
        alloc.`Allocation5_AppliedAmount_NZD`,
        alloc.`Allocation5_AppliedAmount_EUR`,
        alloc.`Allocation5_AppliedAmount_GBP`,
        alloc.`Allocation6_AppliedAmount_AUD`,
        alloc.`Allocation6_AppliedAmount_USD`,
        alloc.`Allocation6_AppliedAmount_NZD`,
        alloc.`Allocation6_AppliedAmount_EUR`,
        alloc.`Allocation6_AppliedAmount_GBP`,
        alloc.`Allocation7_AppliedAmount_AUD`,
        alloc.`Allocation7_AppliedAmount_USD`,
        alloc.`Allocation7_AppliedAmount_NZD`,
        alloc.`Allocation7_AppliedAmount_EUR`,
        alloc.`Allocation7_AppliedAmount_GBP`,
        alloc.`Allocation8_AppliedAmount_AUD`,
        alloc.`Allocation8_AppliedAmount_USD`,
        alloc.`Allocation8_AppliedAmount_NZD`,
        alloc.`Allocation8_AppliedAmount_EUR`,
        alloc.`Allocation8_AppliedAmount_GBP`,
        alloc.`Allocation9_AppliedAmount_AUD`,
        alloc.`Allocation9_AppliedAmount_USD`,
        alloc.`Allocation9_AppliedAmount_NZD`,
        alloc.`Allocation9_AppliedAmount_EUR`,
        alloc.`Allocation9_AppliedAmount_GBP`,
        alloc.`Allocation10_AppliedAmount_AUD`,
        alloc.`Allocation10_AppliedAmount_USD`,
        alloc.`Allocation10_AppliedAmount_NZD`,
        alloc.`Allocation10_AppliedAmount_EUR`,
        alloc.`Allocation10_AppliedAmount_GBP`,
        alloc.`Allocation11_AppliedAmount_AUD`,
        alloc.`Allocation11_AppliedAmount_USD`,
        alloc.`Allocation11_AppliedAmount_NZD`,
        alloc.`Allocation11_AppliedAmount_EUR`,
        alloc.`Allocation11_AppliedAmount_GBP`,
        alloc.`Allocation12_AppliedAmount_AUD`,
        alloc.`Allocation12_AppliedAmount_USD`,
        alloc.`Allocation12_AppliedAmount_NZD`,
        alloc.`Allocation12_AppliedAmount_EUR`,
        alloc.`Allocation12_AppliedAmount_GBP`,
        alloc.`Allocation13_AppliedAmount_AUD`,
        alloc.`Allocation13_AppliedAmount_USD`,
        alloc.`Allocation13_AppliedAmount_NZD`,
        alloc.`Allocation13_AppliedAmount_EUR`,
        alloc.`Allocation13_AppliedAmount_GBP`,
        alloc.`Allocation14_AppliedAmount_AUD`,
        alloc.`Allocation14_AppliedAmount_USD`,
        alloc.`Allocation14_AppliedAmount_NZD`,
        alloc.`Allocation14_AppliedAmount_EUR`,
        alloc.`Allocation14_AppliedAmount_GBP`,
        alloc.`Allocation15_AppliedAmount_AUD`,
        alloc.`Allocation15_AppliedAmount_USD`,
        alloc.`Allocation15_AppliedAmount_NZD`,
        alloc.`Allocation15_AppliedAmount_EUR`,
        alloc.`Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    FROM ', @creditNotesStage, ' crdt
    LEFT JOIN (
    SELECT 
            CreditNoteID,
            MAX(CASE WHEN AllocationNumber = 1 THEN AppliedAmount END) AS Allocation1_AppliedAmount,
                 MAX(CASE WHEN AllocationNumber = 1 THEN AUD END) AS `Allocation1_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN USD END) AS  `Allocation1_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN NZD END) AS  `Allocation1_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN EUR END) AS  `Allocation1_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 1 THEN GBP END) AS  `Allocation1_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 2 THEN AppliedAmount END) AS Allocation2_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 2 THEN AUD END) AS `Allocation2_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN USD END) AS  `Allocation2_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN NZD END) AS  `Allocation2_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN EUR END) AS  `Allocation2_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 2 THEN GBP END) AS  `Allocation2_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 3 THEN AppliedAmount END) AS Allocation3_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 3 THEN AUD END) AS `Allocation3_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN USD END) AS  `Allocation3_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN NZD END) AS  `Allocation3_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN EUR END) AS  `Allocation3_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 3 THEN GBP END) AS  `Allocation3_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 4 THEN AppliedAmount END) AS Allocation4_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 4 THEN AUD END) AS `Allocation4_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN USD END) AS  `Allocation4_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN NZD END) AS  `Allocation4_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN EUR END) AS  `Allocation4_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 4 THEN GBP END) AS  `Allocation4_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 5 THEN AppliedAmount END) AS Allocation5_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 5 THEN AUD END) AS `Allocation5_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN USD END) AS  `Allocation5_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN NZD END) AS  `Allocation5_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN EUR END) AS  `Allocation5_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 5 THEN GBP END) AS  `Allocation5_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 6 THEN AppliedAmount END) AS Allocation6_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 6 THEN AUD END) AS `Allocation6_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN USD END) AS  `Allocation6_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN NZD END) AS  `Allocation6_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN EUR END) AS  `Allocation6_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 6 THEN GBP END) AS  `Allocation6_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 7 THEN AppliedAmount END) AS Allocation7_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 7 THEN AUD END) AS `Allocation7_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN USD END) AS  `Allocation7_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN NZD END) AS  `Allocation7_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN EUR END) AS  `Allocation7_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 7 THEN GBP END) AS  `Allocation7_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 8 THEN AppliedAmount END) AS Allocation8_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 8 THEN AUD END) AS `Allocation8_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN USD END) AS  `Allocation8_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN NZD END) AS  `Allocation8_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN EUR END) AS  `Allocation8_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 8 THEN GBP END) AS  `Allocation8_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 9 THEN AppliedAmount END) AS Allocation9_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 9 THEN AUD END) AS `Allocation9_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN USD END) AS  `Allocation9_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN NZD END) AS  `Allocation9_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN EUR END) AS  `Allocation9_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 9 THEN GBP END) AS  `Allocation9_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 10 THEN AppliedAmount END) AS Allocation10_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 10 THEN AUD END) AS `Allocation10_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN USD END) AS  `Allocation10_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN NZD END) AS  `Allocation10_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN EUR END) AS  `Allocation10_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 10 THEN GBP END) AS  `Allocation10_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 11 THEN AppliedAmount END) AS Allocation11_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 11 THEN AUD END) AS `Allocation11_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN USD END) AS  `Allocation11_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN NZD END) AS  `Allocation11_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN EUR END) AS  `Allocation11_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 11 THEN GBP END) AS  `Allocation11_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 12 THEN AppliedAmount END) AS Allocation12_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 12 THEN AUD END) AS `Allocation12_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN USD END) AS  `Allocation12_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN NZD END) AS  `Allocation12_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN EUR END) AS  `Allocation12_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 12 THEN GBP END) AS  `Allocation12_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 13 THEN AppliedAmount END) AS Allocation13_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 13 THEN AUD END) AS `Allocation13_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN USD END) AS  `Allocation13_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN NZD END) AS  `Allocation13_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN EUR END) AS  `Allocation13_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 13 THEN GBP END) AS  `Allocation13_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 14 THEN AppliedAmount END) AS Allocation14_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 14 THEN AUD END) AS `Allocation14_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN USD END) AS  `Allocation14_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN NZD END) AS  `Allocation14_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN EUR END) AS  `Allocation14_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 14 THEN GBP END) AS  `Allocation14_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 15 THEN AppliedAmount END) AS Allocation15_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 15 THEN AUD END) AS `Allocation15_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN USD END) AS  `Allocation15_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN NZD END) AS  `Allocation15_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN EUR END) AS  `Allocation15_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 15 THEN GBP END) AS  `Allocation15_AppliedAmount_GBP`
         FROM CreditNotesAllocations
         GROUP BY CreditNoteID) alloc ON crdt.CreditNoteId = alloc.CreditNoteId;
		');

  PREPARE stmt6 FROM @insert_xeroblue_creditnotes;
  EXECUTE stmt6;
  DEALLOCATE PREPARE stmt6;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_contacts`
--
CREATE PROCEDURE sp_dynamic_xeroblue_contacts (IN p_clientID varchar(100),
IN p_orgID int,
IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @contactsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_contactsstage');

  SET @update_stage = CONCAT('
        UPDATE `', @contactsStage, '`
        SET
            `FullAddress` = CONCAT(`Street_AddressLine1`, '' '', `Street_City`, '' '', `Street_Region`, '' '', `Street_Country`, '' '', `Street_PostalCode`),
            `RegionAddress` = CONCAT(`Street_City`, '' '', `Street_Region`, '' '', `Street_Country`)
        WHERE `OrganisationId` = ', v_OrganisationID, ';
    ');
  PREPARE stmt FROM @update_stage;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @delete_table = CONCAT('
        DELETE `trgt`
        FROM `c', v_clientID, '_xeroblue_contacts` `trgt`
        INNER JOIN `', @contactsStage, '` `stg`
            ON `trgt`.`OrganisationId` = `stg`.`OrganisationId` 
            AND `trgt`.`ContactId` = `stg`.`ContactId`
        WHERE `trgt`.`OrganisationId` = ', v_OrganisationID, ';
    ');
  PREPARE stmt2 FROM @delete_table;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;

  SET @insert_tofinal = CONCAT('
        INSERT INTO `c', v_clientID, '_xeroblue_contacts`
        SELECT * 
        FROM `', @contactsStage, '`
        WHERE `OrganisationId` = ', v_OrganisationID, ';
    ');
  PREPARE stmt3 FROM @insert_tofinal;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;

END
$$

--
-- Create procedure `sp_dynamic_xeroblue_budgets`
--
CREATE PROCEDURE sp_dynamic_xeroblue_budgets (IN p_clientID int, IN p_orgID int, IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;
  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
  -- Replace hardcoded table references with dynamic ones
  SET @budgetsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_budgetsstage');

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE fx_stmt FROM @create_fxtable;
  EXECUTE fx_stmt;
  DEALLOCATE PREPARE fx_stmt;


  SET @insert_fxtable = CONCAT('
        INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
        SELECT 
            `BaseCurrency`,
            `Date`,
            AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
            AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
            AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
            AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
            AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
        FROM foreignexchange_master
        WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
        GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE ins_fx_stmt FROM @insert_fxtable;
  EXECUTE ins_fx_stmt;
  DEALLOCATE PREPARE ins_fx_stmt;

  SET @update_sql = CONCAT('
        UPDATE `', @budgetsStage, '` bdgt
        INNER JOIN c', v_clientID, '_xeroblue_accounts acct 
            ON bdgt.`BudgetLines.AccountID` = acct.`AccountID`
            AND bdgt.`BudgetLines.AccountCode` = acct.`Code`
            AND bdgt.`OrganisationID` = acct.`OrganisationID`
        SET bdgt.`BudgetLines.BudgetBalances.Amount` = CASE 
                WHEN acct.`Class` = ''Revenue'' THEN bdgt.`BudgetLines.BudgetBalances.Amount`
                WHEN acct.`Class` = ''Expense'' THEN (0 - bdgt.`BudgetLines.BudgetBalances.Amount`)
            END
        WHERE acct.`Class` IN (''Revenue'', ''Expense'');
        ');
  PREPARE upd_stmt FROM @update_sql;
  EXECUTE upd_stmt;
  DEALLOCATE PREPARE upd_stmt;


  SET @update_sql = CONCAT('
        UPDATE `', @budgetsStage, '` AS `bdgt`
        LEFT JOIN `c', v_clientID, '_xeroblue_organisationsclients` AS `org` 
            ON `org`.`OrganisationID` = `bdgt`.`OrganisationID`
        LEFT JOIN ', @fx_table, ' AS `fx` ON fx.`BaseCurrency` = `org`.`BaseCurrency`
                AND `fx`.`Date` = CASE 
                    WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) <= ''', v_minDate, ''' THEN ''', v_minDate, ''' 
                    WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
                    ELSE LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) 
                END
        SET 
            `bdgt`.`BudgetLines.BudgetBalances.Amount_AUD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`AUD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_USD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`USD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_NZD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`NZD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_EUR` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`EUR`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_GBP` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`GBP`
        ;');
  PREPARE upd_stmt FROM @update_sql;
  EXECUTE upd_stmt;
  DEALLOCATE PREPARE upd_stmt;

  SET @delete_sql = CONCAT('
        DELETE FROM c', v_clientID, '_xeroblue_budgets 
        WHERE `OrganisationId` = ', v_OrganisationID, ';
        ');
  PREPARE del_stmt FROM @delete_sql;
  EXECUTE del_stmt;
  DEALLOCATE PREPARE del_stmt;

  SET @insert_sql = CONCAT('
        INSERT INTO `c', v_clientID, '_xeroblue_budgets` 
        SELECT DISTINCT * FROM `', @budgetsStage, '`;
        ');
  PREPARE ins_stmt FROM @insert_sql;
  EXECUTE ins_stmt;
  DEALLOCATE PREPARE ins_stmt;
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_batchpayments`
--
CREATE PROCEDURE sp_dynamic_xeroblue_batchpayments (IN p_clientID int, IN p_orgID int, IN p_legacyOrgID int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @batchPaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_batchpaymentsstage');

  SET @delete_sql = CONCAT('
        DELETE `TRG`
        FROM `c', v_clientID, '_xeroblue_batchpayments` `TRG`
        INNER JOIN `', @batchPaymentsStage, '` `STG` 
            ON `TRG`.`BatchPaymentId` = `STG`.`BatchPaymentId`
            AND `TRG`.`OrganisationId` = `STG`.`OrganisationId`
        WHERE `TRG`.`OrganisationId` = ', v_OrganisationID, '
        ;');
  PREPARE del_stmt FROM @delete_sql;
  EXECUTE del_stmt;
  DEALLOCATE PREPARE del_stmt;

  SET @insert_sql = CONCAT('
        INSERT INTO `c', v_clientID, '_xeroblue_batchpayments` 
        SELECT 
            `Id`,
            `BatchPaymentId`,
            `AccountId`,
            `Particulars`,
            `Code`,
            `Reference`,
            `Details`,
            `Narrative`,
            NULLIF(`Date`,''''),
            `Payment_PaymentId`,
            `Payment_InvoiceId`,
            `Payment_BankAccountNumber`,
            `Payment_Particulars`,
            `Payment_Code`,
            `Payment_Reference`,
            `Payment_Details`,
            `Payment_Amount`,
            `PaymentAggregate`,
            `Type`,
            `Status`,
            `TotalAmount`,
            `IsReconciled`,
            NULLIF(`UpdatedDateUTC`,''''),
            `ClientID`,
            `OrganisationID`
        FROM `', @batchPaymentsStage, '`
        ;');
END
$$

--
-- Create procedure `sp_dynamic_xeroblue_banktransfers`
--
CREATE PROCEDURE sp_dynamic_xeroblue_banktransfers (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @bankTransfersStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransfersstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt0 FROM @insert_fxtable;
  EXECUTE stmt0;
  DEALLOCATE PREPARE stmt0;


  SET @updatebankTransfersStage = CONCAT('UPDATE ', @bankTransfersStage, '
        AS `bnktrnsfr`
    LEFT JOIN `c1518_xeroblue_accounts` AS `acct` 
        ON `bnktrnsfr`.`FromBankAccount_AccountId` = `acct`.`AccountId` 
        AND `bnktrnsfr`.`OrganisationID` = `acct`.`OrganisationID`
    LEFT JOIN ', @fx_table, ' AS `fx` ON `fx`.`BaseCurrency` = `acct`.`CurrencyCode` 
        AND `fx`.`Date` = CASE 
            WHEN `bnktrnsfr`.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, ''' 
            WHEN `bnktrnsfr`.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
            ELSE `bnktrnsfr`.`Date` 
        END
    SET  
        `Amount_AUD` = `bnktrnsfr`.`Amount` * `fx`.`AUD`,
        `Amount_USD` = `bnktrnsfr`.`Amount` * `fx`.`USD`,
        `Amount_NZD` = `bnktrnsfr`.`Amount` * `fx`.`NZD`,
        `Amount_EUR` = `bnktrnsfr`.`Amount` * `fx`.`EUR`,
        `Amount_GBP` = `bnktrnsfr`.`Amount` * `fx`.`GBP`;');

  PREPARE stmt1 FROM @updatebankTransfersStage;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;


  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_banktransfers TRG
    		INNER JOIN ', @bankTransfersStage, ' STG 
        	ON TRG.`BankTransferId` = STG.`BankTransferId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt2 FROM @delete_trg;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;


  SET @insert_xeroblue_banktransfers = CONCAT('INSERT INTO `c', v_clientID, '_xeroblue_banktransfers` 
        SELECT 
            `BankTransferId`,
            `FromBankAccount_Code`,
            `FromBankAccount_AccountId`,
            `FromBankAccount_Name`,
            `ToBankAccount_Code`,
            `ToBankAccount_AccountId`,
            `ToBankAccount_Name`,
            `Amount`,
            NULLIF(`Date`,''''),
            `CurrencyRate`,
            `FromBankTransactionID`,
            `ToBankTransactionID`,
            `HasAttachments`,
            `CreatedDateUTC`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
        FROM `c1518_5393_xeroblue_banktransfersstage`
		');

  PREPARE stmt3 FROM @insert_xeroblue_banktransfers;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_banktransactions`
--
CREATE PROCEDURE sp_dynamic_xeroblue_banktransactions (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;

  DECLARE v_maxDate datetime;
  DECLARE v_minDate datetime;

  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  -- Replace hardcoded table references with dynamic ones
  SET @banktransactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransactionsstage');

  SELECT
    MAX(DATE) INTO v_maxDate
  FROM foreignexchange_master;
  SELECT
    MIN(DATE) INTO v_minDate
  FROM foreignexchange_master;

  SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());

  -- FXTable creation and population
  SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ', @fx_table, ' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );');
  PREPARE stmt FROM @create_fxtable;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


  SET @insert_fxtable = CONCAT('
    INSERT INTO ', @fx_table, ' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
  PREPARE stmt1 FROM @insert_fxtable;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;


  SET @updatebanktransactionsStage = CONCAT('UPDATE ', @banktransactionsStage, '
        SET
                `ConditionalType` = CASE 
                    WHEN `Type` = ''SPEND'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-OVERPAYMENT'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE-OVERPAYMENT'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-PREPAYMENT'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE-PREPAYMENT'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-TRANSFER'' THEN ''NOTINCLUDED''
                    WHEN `Type` = ''RECEIVE-TRANSFER'' THEN ''NOTINCLUDED''
                    ELSE ''UNKNOWN'' 
                END,
                `Account_UID` = CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', `OrganisationID`);');

  PREPARE stmt2 FROM @updatebanktransactionsStage;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;

  SET @updatebanktransactionsStage = CONCAT('UPDATE ', @banktransactionsStage, '
                SET
                `BankTansactionCashflowCalculation` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount`)  
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`)  
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                ),  
                `LineAmountCalculatedIncTax` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                ),  		
                `PaymentAmount` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                );');

  PREPARE stmt3 FROM @updatebanktransactionsStage;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;




  SET @updatebanktransactionsStage3 = CONCAT('UPDATE ', @banktransactionsStage, ' AS bnktrnsxn
	        LEFT JOIN ', @fx_table, ' AS fx ON fx.`BaseCurrency` = bnktrnsxn.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN bnktrnsxn.`Date` <= ''', v_minDate, ''' THEN ''', v_minDate, '''
	                                                                        WHEN bnktrnsxn.`Date` >= ''', v_maxDate, ''' THEN ''', v_maxDate, '''
	                                                                        ELSE bnktrnsxn.`Date` 
	                                                                END
	    	SET  
                `LineItem_UnitAmount_AUD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`AUD`,
                `LineItem_UnitAmount_USD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`USD`,
                `LineItem_UnitAmount_NZD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`NZD`,
                `LineItem_UnitAmount_EUR` = bnktrnsxn.`LineItem_UnitAmount` * fx.`EUR`,
                `LineItem_UnitAmount_GBP` = bnktrnsxn.`LineItem_UnitAmount` * fx.`GBP`,
                `LineItem_TaxAmount_AUD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`AUD`,
                `LineItem_TaxAmount_USD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`USD`,
                `LineItem_TaxAmount_NZD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`NZD`,
                `LineItem_TaxAmount_EUR` = bnktrnsxn.`LineItem_TaxAmount` * fx.`EUR`,
                `LineItem_TaxAmount_GBP` = bnktrnsxn.`LineItem_TaxAmount` * fx.`GBP`,
                `LineItem_LineAmount_AUD` = bnktrnsxn.`LineItem_LineAmount` * fx.`AUD`,
                `LineItem_LineAmount_USD` = bnktrnsxn.`LineItem_LineAmount` * fx.`USD`,
                `LineItem_LineAmount_NZD` = bnktrnsxn.`LineItem_LineAmount` * fx.`NZD`,
                `LineItem_LineAmount_EUR` = bnktrnsxn.`LineItem_LineAmount` * fx.`EUR`,
                `LineItem_LineAmount_GBP` = bnktrnsxn.`LineItem_LineAmount` * fx.`GBP`,
                `SubTotal_AUD` = bnktrnsxn.`SubTotal` * fx.`AUD`,
                `SubTotal_USD` = bnktrnsxn.`SubTotal` * fx.`USD`,
                `SubTotal_NZD` = bnktrnsxn.`SubTotal` * fx.`NZD`,
                `SubTotal_EUR` = bnktrnsxn.`SubTotal` * fx.`EUR`,
                `SubTotal_GBP` = bnktrnsxn.`SubTotal` * fx.`GBP`,
                `TotalTax_AUD` = bnktrnsxn.`TotalTax` * fx.`AUD`,
                `TotalTax_USD` = bnktrnsxn.`TotalTax` * fx.`USD`,
                `TotalTax_NZD` = bnktrnsxn.`TotalTax` * fx.`NZD`,
                `TotalTax_EUR` = bnktrnsxn.`TotalTax` * fx.`EUR`,
                `TotalTax_GBP` = bnktrnsxn.`TotalTax` * fx.`GBP`,
                `Total_AUD` = bnktrnsxn.`Total` * fx.`AUD`,
                `Total_USD` = bnktrnsxn.`Total` * fx.`USD`,
                `Total_NZD` = bnktrnsxn.`Total` * fx.`NZD`,
                `Total_EUR` = bnktrnsxn.`Total` * fx.`EUR`,
                `Total_GBP` = bnktrnsxn.`Total` * fx.`GBP`,
                `BankTansactionCashflowCalculation_AUD` = `BankTansactionCashflowCalculation` * fx.`AUD`,
                `BankTansactionCashflowCalculation_USD` = `BankTansactionCashflowCalculation` * fx.`USD`,
                `BankTansactionCashflowCalculation_NZD` = `BankTansactionCashflowCalculation` * fx.`NZD`,
                `BankTansactionCashflowCalculation_EUR` = `BankTansactionCashflowCalculation` * fx.`EUR`,
                `BankTansactionCashflowCalculation_GBP` = `BankTansactionCashflowCalculation` * fx.`GBP`,
                `LineAmountCalculatedIncTax_AUD` = `LineAmountCalculatedIncTax` * fx.`AUD`,
                `LineAmountCalculatedIncTax_USD` = `LineAmountCalculatedIncTax` * fx.`USD`,
                `LineAmountCalculatedIncTax_NZD` = `LineAmountCalculatedIncTax` * fx.`NZD`,
                `LineAmountCalculatedIncTax_EUR` = `LineAmountCalculatedIncTax` * fx.`EUR`,
                `LineAmountCalculatedIncTax_GBP` = `LineAmountCalculatedIncTax` * fx.`GBP`,
                `PaymentAmount_AUD` = `PaymentAmount` * fx.`AUD`,
                `PaymentAmount_USD` = `PaymentAmount` * fx.`USD`,
                `PaymentAmount_NZD` = `PaymentAmount` * fx.`NZD`,
                `PaymentAmount_EUR` = `PaymentAmount` * fx.`EUR`,
                `PaymentAmount_GBP` = `PaymentAmount` * fx.`GBP`;');

  PREPARE stmt4 FROM @updatebanktransactionsStage3;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;

  SET @delete_trg = CONCAT('DELETE TRG FROM c', v_clientID, '_xeroblue_banktransactions TRG
    		INNER JOIN ', @banktransactionsStage, ' STG 
        	ON TRG.`BankTransactionId` = STG.`BankTransactionId`
    	WHERE TRG.`OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt5 FROM @delete_trg;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;


  SET @insert_xeroblue_banktransactions = CONCAT('INSERT INTO c', v_clientID, '_xeroblue_banktransactions (
        `Id`,
                `BankTransactionId`,
                `Type`,
                `Contact_ContactName`,
                `Contact_ContactId`,
                `BankAccount_AccountId`,
                `BankAccount_AccountName`,
                `BankAccount_Code`,
                `LineItem_LineItemId`,
                `LineItem_Description`,
                `LineItem_Quantity`,
                `LineItem_UnitAmount`,
                `LineItem_AccountCode`,
                `LineItem_TaxType`,
                `LineItem_TaxAmount`,
                `LineItem_LineAmount`,
                `LineItem_ItemCode`,
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
                `LineItemAggregate`,
                `IsReconciled`,
                `Date`,
                `Reference`,
                `CurrencyRate`,
                `URL`,
                `Status`,
                `LineAmountTypes`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `PrepaymentId`,
                `OverpaymentId`,
                `UpdatedDateUTC`,
                `FullyPaidOnDate`,
                `CurrencyCode`,
                `HasAttachments`,
                `ClientID`,
                `OrganisationID`,
                `LineItem_UnitAmount_AUD`,
                `LineItem_UnitAmount_USD`,
                `LineItem_UnitAmount_NZD`,
                `LineItem_UnitAmount_EUR`,
                `LineItem_UnitAmount_GBP`,
                `LineItem_TaxAmount_AUD`,
                `LineItem_TaxAmount_USD`,
                `LineItem_TaxAmount_NZD`,
                `LineItem_TaxAmount_EUR`,
                `LineItem_TaxAmount_GBP`,
                `LineItem_LineAmount_AUD`,
                `LineItem_LineAmount_USD`,
                `LineItem_LineAmount_NZD`,
                `LineItem_LineAmount_EUR`,
                `LineItem_LineAmount_GBP`,
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
                `ConditionalType`,
                `Account_UID`,
                `BankTansactionCashflowCalculation`,
                `BankTansactionCashflowCalculation_AUD`,
                `BankTansactionCashflowCalculation_USD`,
                `BankTansactionCashflowCalculation_NZD`,
                `BankTansactionCashflowCalculation_EUR`,
                `BankTansactionCashflowCalculation_GBP`,
                `LineAmountCalculatedIncTax`,
                `LineAmountCalculatedIncTax_AUD`,
                `LineAmountCalculatedIncTax_USD`,
                `LineAmountCalculatedIncTax_NZD`,
                `LineAmountCalculatedIncTax_EUR`,
                `LineAmountCalculatedIncTax_GBP`,
                `PaymentAmount`,
                `PaymentAmount_AUD`,
                `PaymentAmount_USD`,
                `PaymentAmount_NZD`,
                `PaymentAmount_EUR`,
                `PaymentAmount_GBP` 
            )
            SELECT
                `Id`,
                `BankTransactionId`,
                `Type`,
                `Contact_ContactName`,
                `Contact_ContactId`,
                `BankAccount_AccountId`,
                `BankAccount_AccountName`,
                `BankAccount_Code`,
                `LineItem_LineItemId`,
                SUBSTRING(`LineItem_Description`,1,100),
                `LineItem_Quantity`,
                `LineItem_UnitAmount`,
                `LineItem_AccountCode`,
                `LineItem_TaxType`,
                `LineItem_TaxAmount`,
                `LineItem_LineAmount`,
                `LineItem_ItemCode`,
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
                `LineItemAggregate`,
                `IsReconciled`,
                NULLIF(`Date`, ''''),
                LEFT(`Reference`,100),
                `CurrencyRate`,
                `URL`,
                `Status`,
                `LineAmountTypes`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `PrepaymentId`,
                `OverpaymentId`,
                NULLIF(`UpdatedDateUTC`, ''''),
                NULLIF(`FullyPaidOnDate`, ''''),
                `CurrencyCode`,
                `HasAttachments`,
                `ClientID`,
                `OrganisationID`,
                `LineItem_UnitAmount_AUD`,
                `LineItem_UnitAmount_USD`,
                `LineItem_UnitAmount_NZD`,
                `LineItem_UnitAmount_EUR`,
                `LineItem_UnitAmount_GBP`,
                `LineItem_TaxAmount_AUD`,
                `LineItem_TaxAmount_USD`,
                `LineItem_TaxAmount_NZD`,
                `LineItem_TaxAmount_EUR`,
                `LineItem_TaxAmount_GBP`,
                `LineItem_LineAmount_AUD`,
                `LineItem_LineAmount_USD`,
                `LineItem_LineAmount_NZD`,
                `LineItem_LineAmount_EUR`,
                `LineItem_LineAmount_GBP`,
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
                `ConditionalType`,
                `Account_UID`,
                `BankTansactionCashflowCalculation`,
                `BankTansactionCashflowCalculation_AUD`,
                `BankTansactionCashflowCalculation_USD`,
                `BankTansactionCashflowCalculation_NZD`,
                `BankTansactionCashflowCalculation_EUR`,
                `BankTansactionCashflowCalculation_GBP`,
                `LineAmountCalculatedIncTax`,
                `LineAmountCalculatedIncTax_AUD`,
                `LineAmountCalculatedIncTax_USD`,
                `LineAmountCalculatedIncTax_NZD`,
                `LineAmountCalculatedIncTax_EUR`,
                `LineAmountCalculatedIncTax_GBP`,
                `PaymentAmount`,
                `PaymentAmount_AUD`,
                `PaymentAmount_USD`,
                `PaymentAmount_NZD`,
                `PaymentAmount_EUR`,
                `PaymentAmount_GBP` 
        FROM ', @banktransactionsStage, ' bnktrnsxn;
		');

  PREPARE stmt6 FROM @insert_xeroblue_banktransactions;
  EXECUTE stmt6;
  DEALLOCATE PREPARE stmt6;



END
$$

--
-- Create procedure `sp_dynamic_xeroblue_accounts`
--
CREATE PROCEDURE sp_dynamic_xeroblue_accounts (IN `p_clientID` varchar(100),
IN `p_orgID` int,
IN `p_legacyOrgID` int)
BEGIN
  DECLARE v_OrganisationID int DEFAULT p_orgID;
  DECLARE v_clientID int DEFAULT p_clientID;
  DECLARE v_table_name varchar(255) DEFAULT CONCAT('c', v_clientID, '_xeroblue_accounts');
  DECLARE column_list text DEFAULT '';
  DECLARE column_list2 text DEFAULT '';
  DECLARE done int DEFAULT 0;
  DECLARE col_name varchar(255);
  DECLARE col_type varchar(255);



  -- Declare cursor to retrieve column names and types dynamically
  DECLARE cur CURSOR FOR
  SELECT
    COLUMN_NAME,
    DATA_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = v_table_name
  AND TABLE_SCHEMA = DATABASE();

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;



  -- Process columns dynamically

  OPEN cur;
    read_loop:
  LOOP
    FETCH cur INTO col_name, col_type;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET column_list = CONCAT(column_list, '`', col_name, '`, ');
    -- Handle date/datetime columns: convert '' to NULL
    IF col_type IN ('date', 'datetime', 'timestamp') THEN
      SET column_list2 = CONCAT(column_list2,
      'NULLIF(`', col_name, '`, NULL) AS `', col_name, '`, ');
    ELSE
      SET column_list2 = CONCAT(column_list2, '`', col_name, '`, ');
    END IF;
  END LOOP;
  CLOSE cur;

  -- Remove trailing comma from column_list
  SET column_list = LEFT(column_list, CHAR_LENGTH(column_list) - 2);
  SET column_list2 = LEFT(column_list2, CHAR_LENGTH(column_list2) - 2);




  SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

  SET @accountsStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_accountsstage');
  IF NOT EXISTS (SELECT
        1
      FROM INFORMATION_SCHEMA.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = @accountsStage) THEN
    SET @accountsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_accountsstage');
  END IF;

  SET @update_accounts_sql = CONCAT('
    UPDATE ', @accountsStage, '
    SET
        `AccountType` = CASE 
            WHEN `Type` = ''BANK'' THEN ''Bank''
            WHEN `Type` = ''CURRENT'' THEN ''Current Assets''
            WHEN `Type` = ''CURRLIAB'' THEN ''Current Liabilities''
            WHEN `Type` = ''DEPRECIATN'' THEN ''Depreciation''
            WHEN `Type` = ''DIRECTCOSTS'' THEN ''Direct Costs''
            WHEN `Type` = ''EQUITY'' THEN ''Equity''
            WHEN `Type` = ''EXPENSE'' THEN ''Expenses''
            WHEN `Type` = ''LIABILITY'' THEN ''Non-Current Liabilities''
            WHEN `Type` = ''NONCURRENT'' THEN ''Non-Current Assets''
            WHEN `Type` = ''OTHERINCOME'' THEN ''Other Income''
            WHEN `Type` = ''REVENUE'' THEN ''Revenue''
            WHEN `Type` = ''SALES'' THEN ''Sales''
            WHEN `Type` = ''TERMLIAB'' THEN ''Non-Current Liabilities''    
            WHEN `Type` = ''FIXED'' THEN ''Fixed Assets''
            WHEN `Type` = ''INVENTORY'' THEN ''Inventory Assets''
            WHEN `Type` = ''OVERHEADS'' THEN ''Expenses''
            WHEN `Type` = ''PREPAYMENT'' THEN ''Prepayment''
            WHEN `Type` = ''PAYGLIABILITY'' THEN ''PAYG Liability''
            WHEN `Type` = ''SUPERANNUATIONEXPENSE'' THEN ''Expenses''
            WHEN `Type` = ''SUPERANNUATIONLIABILITY'' THEN ''Superannuation Liability''
            WHEN `Type` = ''WAGESEXPENSE'' THEN ''Expenses''
            ELSE ''Unknown'' END,
        `BalanceSheetReportingType` = CASE 
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Retained Earnings''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Retained Earnings''
            WHEN `ReportingCode` LIKE ''%LIA.CUR%'' THEN ''Current Liabilities''
            WHEN `ReportingCode` LIKE ''%ASS.NCA.FIX%'' THEN ''Fixed Assets''
            WHEN `ReportingCode` LIKE ''%ASS.NCA%'' THEN ''Non-Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS.CUR.CAS.BAN%'' THEN ''Bank''
            WHEN `ReportingCode` LIKE ''%ASS.CUR%'' THEN ''Current Assets''
            WHEN `ReportingCode` LIKE ''%LIA.NCL%'' THEN ''Non-Current Liabilities''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%LIA%'' AND (Type = ''LIABILITY'' OR Type = ''TERMLIAB'') THEN ''Non-Current Liabilities''
            WHEN `ReportingCode` LIKE ''%LIA%'' AND Type = ''CURRLIAB'' THEN ''Current Liabilities''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''CURRENT'' THEN ''Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''BANK'' THEN ''Bank''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''NONCURRENT'' THEN ''Non-Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''FIXED'' THEN ''Fixed Assets''
            ELSE ''UNKNOWN'' END,
        `P&LReportingTypeInterim` = CASE 
            WHEN `ReportingCode` LIKE ''%ASS%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%LIA%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%REV.OTH%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%REV.TRA%'' THEN ''Trading Income''
            WHEN `ReportingCode` LIKE ''%REV.INV%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%EXP.INC%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%EXP.COS%'' THEN ''Cost of Sales''
            WHEN `ReportingCode` LIKE ''%EXP.DIV%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.FOR%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.DEP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.REN%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.EMP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.INT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.FBT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.ENT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.BAD%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.NON%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%REV.GRA%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%EXP.VEH%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.AMO%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Other Income''
            ELSE `ReportingCode` END;
        ');

  PREPARE stmt FROM @update_accounts_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  SET @update_accounts_sql2 = CONCAT('
        UPDATE ', @accountsStage, '
        SET
        `AccountTypeOrder` = CASE 
            WHEN `AccountType` = ''Revenue'' THEN ''1''
            WHEN `AccountType` = ''Sales'' THEN ''2''
            WHEN `AccountType` = ''Direct Costs'' THEN ''3''
            WHEN `AccountType` = ''Other Income'' THEN ''4''
            WHEN `AccountType` = ''Depreciation'' THEN ''5''
            WHEN `AccountType` = ''Expenses'' THEN ''6''
            WHEN `AccountType` = ''Bank'' THEN ''7''
            WHEN `AccountType` = ''Current Assets'' THEN ''8''
            WHEN `AccountType` = ''Non-Current Assets'' THEN ''9''
            WHEN `AccountType` = ''Current Liabilities'' THEN ''10''
            WHEN `AccountType` = ''Non-Current Liabilities'' THEN ''11''
            WHEN `AccountType` = ''Equity'' THEN ''12''
            ELSE ''13'' END,
        `P&LGroup` = CASE 
            WHEN `AccountType` = ''Direct Costs'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Revenue'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Sales'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Other Income'' THEN ''Other Income''
            WHEN `AccountType` = ''Expenses'' THEN ''Expense''
            WHEN `AccountType` = ''Depreciation'' THEN ''Expense''
            ELSE ''Unknown'' END,
        `BalanceSheetType` = CASE 
            WHEN `AccountType` = ''Direct Costs'' THEN ''Equity''
            WHEN `AccountType` = ''Revenue'' THEN ''Equity''
            WHEN `AccountType` = ''Sales'' THEN ''Equity''
            WHEN `AccountType` = ''Other Income'' THEN ''Equity''
            WHEN `AccountType` = ''Expenses'' THEN ''Equity''
            WHEN `AccountType` = ''Depreciation'' THEN ''Equity''
            ELSE `AccountType` END,
        `StatementofCashflow` = CASE 
            WHEN `AccountType` = ''Revenue'' THEN ''Receipts from customers''
            WHEN `AccountType` = ''Sales'' THEN ''Receipts from customers''
            WHEN `AccountType` = ''Direct Costs'' THEN ''Payments to suppliers and employees''
            WHEN `AccountType` = ''Other Income'' THEN ''Cash receipts from other operating activities''
            WHEN `AccountType` = ''Fixed Assets'' THEN ''Payment for property, plant and equipment''
            WHEN `AccountType` = ''Expenses'' THEN ''Payments to suppliers and employees''
            WHEN `AccountType` = ''Prepayments'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Current Assets'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Non-Current Assets'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Current Liabilities'' THEN ''Other cash items from financing activities''
            ELSE ''Working on It'' END,
        `BalanceSheetReportingGroup` = CASE 
            WHEN `ReportingCode` LIKE ''%ASS%'' THEN ''Assets''
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%LIA%'' THEN ''Liabilities''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Equity''
            ELSE ''UNKNOWN'' END,
        `P&LReportingType` = CASE
            WHEN LOCATE(''.'', `P&LReportingTypeInterim`) > 0 THEN 
                SUBSTRING_INDEX(`P&LReportingTypeInterim`, ''.'', 1)
            ELSE 
                `P&LReportingTypeInterim`
            END;
        ');

  PREPARE stmt2 FROM @update_accounts_sql2;
  EXECUTE stmt2;
  DEALLOCATE PREPARE stmt2;

  SET @update_accounts_sql3 = CONCAT('
    UPDATE ', @accountsStage, '
    SET
        `BalanceSheetGroup` = CASE 
            WHEN `BalanceSheetType` = ''Equity'' THEN ''Equity''
            WHEN `BalanceSheetType` = ''Retained Earnings'' THEN ''Equity''
            WHEN `BalanceSheetType` = ''Current Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Fixed Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Prepayment'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Bank'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Non-Current Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Inventory Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Current Liabilities'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''Term Liability'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''PAYG Liability'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''Non-Current Liabilities'' THEN ''Liabilities''
            ELSE ''UNKNOWN'' END,
        `CashflowActivities` = CASE 
            WHEN `StatementofCashflow` = ''Receipts from customers'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Payments to suppliers and employees'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Cash receipts from other operating activities'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Payment for property, plant and equipment'' THEN ''Investing Activities''
            WHEN `StatementofCashflow` = ''Other cash items from investing activities'' THEN ''Investing Activities''
            WHEN `StatementofCashflow` = ''Other cash items from financing activities'' THEN ''Financing Activities''
            ELSE ''Working on It'' END,
        `P&LReportingGroup` = CASE 
            WHEN `P&LReportingType` = ''Trading Income'' THEN ''Direct''
            WHEN `P&LReportingType` = ''Cost of Sales'' THEN ''Direct''
            WHEN `P&LReportingType` = ''Other Income'' THEN ''Other Income''
            WHEN `P&LReportingType` = ''Operating Expenses'' THEN ''Expenses''
            WHEN `P&LReportingType` = ''Non-Operating Expenses'' THEN ''Expenses''
            ELSE ''Balance Sheet Item'' END;
        ');


  PREPARE stmt3 FROM @update_accounts_sql3;
  EXECUTE stmt3;
  DEALLOCATE PREPARE stmt3;

  SET @update_accounts_sql4 = CONCAT('
        UPDATE ', @accountsStage, '
        SET
            `Class` = CONCAT(UPPER(LEFT(`Class`, 1)), LOWER(SUBSTRING(`Class`, 2))),
            `ClassOrder` = CASE 
                WHEN `Class` = ''REVENUE'' THEN ''1''
                WHEN `Class` = ''EXPENSE'' THEN ''2''
                WHEN `Class` = ''ASSET'' THEN ''3''
                WHEN `Class` = ''LIABILITY'' THEN ''4''
                WHEN `Class` = ''EQUITY'' THEN ''5''
                ELSE ''6'' END,
            `P&LGroupOrder` = CASE 
                WHEN `P&LGroup` = ''Direct Grouping'' THEN ''1''
                WHEN `P&LGroup` = ''Other Income'' THEN ''2''
                WHEN `P&LGroup` = ''Expense'' THEN ''3''
                ELSE ''4'' END,
            `BalanceSheetAccountName` = CASE 
                WHEN `P&LGroup` <> ''Unknown'' THEN ''Retained Earnings''
                ELSE Name END,
            `BalanceSheetReportingTypeOrder` = CASE 
                WHEN `BalanceSheetReportingType` = ''Bank'' THEN ''1''
                WHEN `BalanceSheetReportingType` = ''Current Assets'' THEN ''2''
                WHEN `BalanceSheetReportingType` = ''Non-Current Assets'' THEN ''3''
                WHEN `BalanceSheetReportingType` = ''Fixed Assets'' THEN ''4''
                WHEN `BalanceSheetReportingType` = ''Current Liabilities'' THEN ''5''
                WHEN `BalanceSheetReportingType` = ''Non-Current Liabilities'' THEN ''6''
                WHEN `BalanceSheetReportingType` = ''PAYG Liability'' THEN ''7''
                WHEN `BalanceSheetReportingType` = ''Superannuation Liability'' THEN ''8''
                WHEN `BalanceSheetReportingType` = ''Retained Earnings'' THEN ''9''
                WHEN `BalanceSheetReportingType` = ''Equity'' THEN ''10''
                WHEN `BalanceSheetReportingType` = ''Revenue'' THEN ''11''
                WHEN `BalanceSheetReportingType` = ''Sales'' THEN ''12''
                WHEN `BalanceSheetReportingType` = ''Direct Costs'' THEN ''13''
                WHEN `BalanceSheetReportingType` = ''Expenses'' THEN ''14''
                WHEN `BalanceSheetReportingType` = ''Depreciation'' THEN ''15''
                WHEN `BalanceSheetReportingType` = ''Other Income'' THEN ''16''
                WHEN `BalanceSheetReportingType` = ''Overheads'' THEN ''17''
                WHEN `BalanceSheetReportingType` = ''Prepayment'' THEN ''18''
                WHEN `BalanceSheetReportingType` = ''Superannuation Expense'' THEN ''19''
                WHEN `BalanceSheetReportingType` = ''Wages Expense'' THEN ''20''
                ELSE ''Unknown'' END,
            `BalanceSheetReportingGroupOrder` = CASE 
                WHEN `BalanceSheetReportingGroup` = ''Assets'' THEN ''1''
                WHEN `BalanceSheetReportingGroup` = ''Liabilities'' THEN ''2''
                WHEN `BalanceSheetReportingGroup` = ''Equity'' THEN ''3''
                ELSE ''Unknown'' END,
            `P&LReportingGroupOrder` = CASE 
                WHEN `P&LReportingGroup` = ''Direct'' THEN ''1''
                WHEN `P&LReportingGroup` = ''Other Income'' THEN ''2''
                WHEN `P&LReportingGroup` = ''Expenses'' THEN ''3''
                ELSE ''4'' END,
            `P&LReportingTypeOrder` = CASE 
                WHEN `P&LReportingType` = ''Trading Income'' THEN ''1''
                WHEN `P&LReportingType` = ''Cost of Sales'' THEN ''2''
                WHEN `P&LReportingType` = ''Other Income'' THEN ''3''
                WHEN `P&LReportingType` = ''Operating Expenses'' THEN ''4''
                WHEN `P&LReportingType` = ''Non-Operating Expenses'' THEN ''5''
                ELSE ''6'' END,
            `BalanceSheetGroupOrder` = CASE 
                WHEN `BalanceSheetGroup` = ''Assets'' THEN ''1''
                WHEN `BalanceSheetGroup` = ''Liabilities'' THEN ''2''
                WHEN `BalanceSheetGroup` = ''Equity'' THEN ''3''
                ELSE ''4'' END,
            `CashflowActivitiesOrder` = CASE 
                WHEN `CashflowActivities` = ''Operating Activities'' THEN ''1''
                WHEN `CashflowActivities` = ''Investing Activities'' THEN ''2''
                WHEN `CashflowActivities` = ''Financing Activities'' THEN ''3''
                ELSE ''4'' END,
            `StatementofCashflowOrder` = CASE 
                WHEN `StatementofCashflow` = ''Receipts from customers'' THEN ''1''
                WHEN `StatementofCashflow` = ''Payments to suppliers and employees'' THEN ''2''
                WHEN `StatementofCashflow` = ''Cash receipts from other operating activities'' THEN ''3''
                WHEN `StatementofCashflow` = ''Payment for property, plant and equipment'' THEN ''4''
                WHEN `StatementofCashflow` = ''Other cash items from investing activities'' THEN ''5''
                WHEN `StatementofCashflow` = ''Other cash items from financing activities'' THEN ''6''
                ELSE ''7'' END,
            `CashIn/CashOut` = CASE 
                WHEN `Class` = ''Asset'' THEN ''Cash In''
                WHEN `Class` = ''Liability'' THEN ''Cash Out''
                WHEN `Class` = ''Revenue'' THEN ''Cash In''
                WHEN `Class` = ''Expense'' THEN ''Cash Out''
                ELSE ''UNKNOWN'' END,
            `Account_UID` = CONCAT(IFNULL(`Code`, ''BLANK''), ''-'', `OrganisationID`),
            `AccountName_UID` = CONCAT(IFNULL(`Name`, ''BLANK''), `OrganisationID`);
        ');
  PREPARE stmt4 FROM @update_accounts_sql4;
  EXECUTE stmt4;
  DEALLOCATE PREPARE stmt4;

  SET @delete_trans = CONCAT('DELETE FROM c', v_clientID, '_xeroblue_accounts 
    	    WHERE `OrganisationId` = ', v_OrganisationID, ';');

  PREPARE stmt5 FROM @delete_trans;
  EXECUTE stmt5;
  DEALLOCATE PREPARE stmt5;



  -- Dynamic INSERT with transformed date values
  SET @insert_sql = CONCAT('INSERT INTO ', v_table_name, '(', column_list, ') 
        SELECT ', column_list2, ' FROM ', @accountsStage, '
        ;');


  PREPARE stmt FROM @insert_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

--
-- Create procedure `SP_CleanUpXeroBlueStageData`
--
CREATE PROCEDURE SP_CleanUpXeroBlueStageData (IN `p_client_id` int,
IN `p_org_id` int)
BEGIN
  DECLARE v_clientId int DEFAULT p_client_id;
  DECLARE v_organisationId int DEFAULT p_org_id;
  DECLARE done1,
          done2 int DEFAULT FALSE;
  DECLARE tablename1 varchar(255);
  DECLARE tablename2 varchar(255);

  DECLARE cur_clients CURSOR FOR
  SELECT
    TABLE_NAME
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME LIKE CONCAT('%c', v_clientId, '_xeroblue_%');

  DECLARE cur_orgs CURSOR FOR
  SELECT
    TABLE_NAME
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME LIKE CONCAT('%c', v_clientId, '_', v_organisationId, '_xeroblue_%');

  BEGIN
    -- Handlers for NOT FOUND
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = TRUE;



    OPEN cur_clients;

      clients_loop:
    LOOP
      FETCH cur_clients INTO tablename1;
      IF done1 THEN
        LEAVE clients_loop;
      END IF;

      SELECT
        CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Legacy.id')), v_organisationId) AS char(10)) INTO @legacy_orgId
      FROM etaniv2.client_service cs
      WHERE Id = v_organisationId;

      SET @delete_by_orgid = CONCAT('
		  DELETE FROM `', tablename1, '`
		  WHERE OrganisationId = ', @legacy_orgId, ';');
      -- SELECT @delete_by_orgid;
      PREPARE del_stmt FROM @delete_by_orgid;
      EXECUTE del_stmt;
      DEALLOCATE PREPARE del_stmt;

    END LOOP;

    CLOSE cur_clients;
  END;

  BEGIN
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = TRUE;
    OPEN cur_orgs;

      orgs_loop:
    LOOP
      FETCH cur_orgs INTO tablename2;
      IF done2 THEN
        LEAVE orgs_loop;
      END IF;

      SET @truncate_org_table = CONCAT('
		  TRUNCATE TABLE `', tablename2, '`;
	   	');
      PREPARE trunc_stmt FROM @truncate_org_table;
      EXECUTE trunc_stmt;
      DEALLOCATE PREPARE trunc_stmt;

    END LOOP;

    CLOSE cur_orgs;
  END;

END
$$

--
-- Create procedure `sp_add_container_logs`
--
CREATE PROCEDURE sp_add_container_logs (IN `p_integration` varchar(50),
IN `p_organisation_id` int,
IN `p_client_id` int,
IN `p_firm_id` int,
IN `p_start_date` timestamp,
IN `p_end_date` timestamp,
IN `p_status` varchar(50),
IN `p_log_id` varchar(64),
IN `p_remarks` longtext)
BEGIN
  INSERT INTO vibedb_cms.container_logs (integration, organisation_id, client_id, firm_id,
  start_date, end_date, `status`, log_id, remarks)
    VALUES (p_integration, p_organisation_id, p_client_id, p_firm_id, p_start_date, p_end_date, p_status, p_log_id, p_remarks)
  ON DUPLICATE KEY UPDATE
  end_date = VALUES(end_date),
  `status` = VALUES(`status`),
  remarks = CONCAT(IFNULL(remarks, ''), '\n', IFNULL(VALUES(remarks), ''));
END
$$

--
-- Create procedure `SP_AddIndexesForClients`
--
CREATE PROCEDURE SP_AddIndexesForClients ()
BEGIN
  DECLARE done int DEFAULT 0;
  DECLARE v_clientID char(10);
  DECLARE index_exists int DEFAULT 0;  -- Declare local variable
  DECLARE cur CURSOR FOR
  SELECT DISTINCT
    CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')), C.Id) AS char(10)) AS ClientId
  FROM etaniv2.client C
    JOIN etaniv2.accounting_firm F
      ON C.accountingFirm = F.Id
    JOIN etaniv2.client_service S
      ON C.id = S.`Client`
  WHERE F.Code IN ('ENSPIRA', 'MKSGROUP', 'AUSTASIAGROUP', 'ADVISE', 'POWERTYNAN', 'AHP', 'CAVEOPARTNERS')
  AND C.status = 1
  AND S.Service = 1
  AND S.Status <> 2;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;

    read_loop:
  WHILE done = 0 DO
    FETCH cur INTO v_clientID;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

    -- Table names
    SET @table_transactions = CONCAT('c', v_clientID, '_xeroblue_transactionsblend');
    SET @table_accounts = CONCAT('c', v_clientID, '_xeroblue_accounts');

    -- Check if idx_journaldate exists
    SET @index_check_sql = CONCAT('SELECT COUNT(*) INTO @index_exists 
             FROM INFORMATION_SCHEMA.STATISTICS 
             WHERE TABLE_SCHEMA = DATABASE() 
             AND TABLE_NAME = "', @table_transactions, '" 
             AND INDEX_NAME = "c', v_clientID, '_transactionsblend_journaldate_idx";');

    PREPARE stmt_check FROM @index_check_sql;
    EXECUTE stmt_check;
    DEALLOCATE PREPARE stmt_check;

    -- Manually fetch into local variable
    SELECT
      @index_exists INTO index_exists;

    -- Add index only if it does NOT exist
    IF index_exists = 0 THEN
      SET @alter_sql = CONCAT('ALTER TABLE ', @table_transactions, '
                    ADD INDEX c', v_clientID, '_transactionsblend_journaldate_idx (JournalDate);');
      PREPARE stmt_idx FROM @alter_sql;
      EXECUTE stmt_idx;
      DEALLOCATE PREPARE stmt_idx;
    END IF;

    -- Repeat for idx_AccountId_OrgID
    SET @index_check_sql = CONCAT('SELECT COUNT(*) INTO @index_exists 
             FROM INFORMATION_SCHEMA.STATISTICS 
             WHERE TABLE_SCHEMA = DATABASE() 
             AND TABLE_NAME = "', @table_transactions, '" 
             AND INDEX_NAME = "c', v_clientID, '_transactionsblend_AccountId_OrgID_idx";');

    PREPARE stmt_check FROM @index_check_sql;
    EXECUTE stmt_check;
    DEALLOCATE PREPARE stmt_check;

    SELECT
      @index_exists INTO index_exists;

    IF index_exists = 0 THEN
      SET @alter_sql = CONCAT('ALTER TABLE ', @table_transactions, '
                    ADD INDEX c', v_clientID, '_transactionsblend_AccountId_OrgID_idx (JournalLine_AccountId, OrganisationID);');
      PREPARE stmt_idx FROM @alter_sql;
      EXECUTE stmt_idx;
      DEALLOCATE PREPARE stmt_idx;
    END IF;

    -- Check and add index for xeroblue_accounts
    SET @index_check_sql = CONCAT('SELECT COUNT(*) INTO @index_exists 
             FROM INFORMATION_SCHEMA.STATISTICS 
             WHERE TABLE_SCHEMA = DATABASE() 
             AND TABLE_NAME = "', @table_accounts, '" 
             AND INDEX_NAME = "c', v_clientID, '_accounts_AccountId_OrgID_idx";');

    PREPARE stmt_check FROM @index_check_sql;
    EXECUTE stmt_check;
    DEALLOCATE PREPARE stmt_check;

    SELECT
      @index_exists INTO index_exists;

    IF index_exists = 0 THEN
      SET @alter_sql = CONCAT('ALTER TABLE ', @table_accounts, '
                    ADD INDEX c', v_clientID, '_accounts_AccountId_OrgID_idx (AccountId, OrganisationID);');
      PREPARE stmt_idx FROM @alter_sql;
      EXECUTE stmt_idx;
      DEALLOCATE PREPARE stmt_idx;
    END IF;

  END WHILE;

  CLOSE cur;
END
$$

--
-- Create procedure `CreateEVAStageIndexIfNotExists`
--
CREATE PROCEDURE CreateEVAStageIndexIfNotExists (IN `p_table_name` varchar(255),
IN `p_index_name` varchar(255),
IN `p_column_names` varchar(255))
BEGIN
  -- Declare a variable to hold the dynamic SQL query
  DECLARE base_index_name varchar(64) DEFAULT p_index_name;
  DECLARE new_index_name varchar(64) DEFAULT p_index_name;
  DECLARE counter int DEFAULT 1;
  SET @sql_query = NULL;
  SET @index_count = 0;
  SET @name_count = 0;
  SET p_table_name = LOWER(p_table_name);

  -- Check if the index already exists
  SELECT
    COUNT(*) INTO @index_count
  FROM (SELECT
      index_name
    FROM information_schema.statistics
    WHERE table_schema = DATABASE()
    AND table_name = p_table_name
    GROUP BY index_name
    HAVING REPLACE(REPLACE(GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ','), ' ', ''), '`', '')
    = REPLACE(REPLACE(REPLACE(REPLACE(p_column_names, ' ', ''), '`', ''), '(50)', ''), '(255)', '')) AS existing_indexes;


  -- If the index doesn't exist, create it
  IF @index_count = 0 THEN
    SET base_index_name = REPLACE(p_index_name, '_idx', '');

    WHILE EXISTS (SELECT
          1
        FROM information_schema.statistics
        WHERE table_name = p_table_name
        AND index_name = new_index_name) DO
      SET counter = counter + 1;
      SET new_index_name = CONCAT(base_index_name, counter, '_idx');
    END WHILE;

    -- Construct the dynamic SQL query to create the index
    SET @sql_query = CONCAT('CREATE INDEX `', new_index_name, '`',
    ' ON `', p_table_name, '`',
    ' (', REPLACE(p_column_names, 'Index', '`Index`'), ')');

    -- Prepare and execute the dynamic SQL query
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

  END IF;
END
$$

--
-- Create procedure `CreateEVAStageFullTextIndexIfNotExists`
--
CREATE PROCEDURE CreateEVAStageFullTextIndexIfNotExists (IN `p_table_name` varchar(255),
IN `p_index_name` varchar(255),
IN `p_column_names` varchar(255))
BEGIN
  -- Declare a variable to hold the dynamic SQL query
  SET @sql_query = NULL;
  SET @index_count = 0;
  SET p_table_name = LOWER(p_table_name);
  -- Check if the index already exists
  SELECT
    COUNT(1) INTO @index_count
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = p_table_name
  AND INDEX_NAME = p_index_name;

  -- If the index doesn't exist, create it
  IF @index_count = 0 THEN
    -- Construct the dynamic SQL query to create the index
    SET @sql_query = CONCAT('CREATE FULLTEXT INDEX ', p_index_name,
    ' ON ', p_table_name,
    ' (', p_column_names, ')');

    -- Prepare and execute the dynamic SQL query
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END
$$

DELIMITER ;