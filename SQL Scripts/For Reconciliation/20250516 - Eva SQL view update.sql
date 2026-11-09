-- Add isvisible column to Journal and JournalCash tables
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


-- Updated SQL views
CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_accrualtransactions_aud AS
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

CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_cashtransactions_aud AS
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