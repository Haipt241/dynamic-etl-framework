CREATE OR REPLACE VIEW bigoleshoecompany_client1518_xeroblue_transactionsblend_aud AS
SELECT 
    tb.`Id` AS `ID`,
    tb.`JournalId` AS `Journal ID`,
    ROW_NUMBER() OVER (ORDER BY tb.`JournalDate` ASC) AS `Index`,
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
    tb.`JournalLine_NetAmount_AUD` AS `Net Amount FX`,
    tb.`JournalLine_GrossAmount_AUD` AS `Gross Amount FX`,
    tb.`JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
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
    tb.`UnitAmount_AUD` AS `Unit Amount FX`,
    tb.`AmountDue` AS `Amount Due`,
    tb.`AmountDue_AUD` AS `Amount Due FX`,
    tb.`URL` AS `URL`,
    tb.`DueDate` AS `Due Date`,
    Acc.`SystemAccount` AS `System Account`,
    NULL AS `Invoice Total`,
    Acc.`Class` AS `Account Class`
FROM evadb_stage.c1518_xeroblue_journals Tb
LEFT JOIN evadb_stage.c1518_xeroblue_accounts Acc 
ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;


CREATE OR REPLACE VIEW bigoleshoecompany_client1518_xeroblue_transactionsblendcash_aud AS
SELECT 
    tb.`Id` AS `ID`,
    tb.`JournalId` AS `Journal ID`,
    ROW_NUMBER() OVER (ORDER BY tb.`JournalDate` ASC) AS `Index`,
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
    tb.`JournalLine_NetAmount_AUD` AS `Net Amount FX`,
    tb.`JournalLine_GrossAmount_AUD` AS `Gross Amount FX`,
    tb.`JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
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
    COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`
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
    tb.`UnitAmount_AUD` AS `Unit Amount FX`,
    tb.`AmountDue` AS `Amount Due`,
    tb.`AmountDue_AUD` AS `Amount Due FX`,
    tb.`URL` AS `URL`,
    tb.`DueDate` AS `Due Date`,
    Acc.`SystemAccount` AS `System Account`,
    NULL AS `Invoice Total`,
    Acc.`Class` AS `Account Class`
FROM evadb_stage.c1518_xeroblue_journalscash Tb
LEFT JOIN evadb_stage.c1518_xeroblue_accounts Acc 
ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;


CREATE OR REPLACE VIEW bigoleshoecompany_client1518_xeroblue_accrualtransactions_aud AS
SELECT
    `t`.`Journal Date` AS `Date`,
    `t`.`Reference` AS `Reference`,
    `t`.`Source Type` AS `SourceType`,
    `t`.`Description` AS `Description`,
    `t`.`Account ID` AS `AccountID`,
    `t`.`Account Code` AS `AccountCode`,
    `t`.`Account Type` AS `AccountType`,
    `t`.`Account Name` AS `AccountName`,
    `t`.`Net Amount` AS `Amount`,
    `t`.`Tax Amount` AS `TaxAmount`,
    `t`.`Tracking Category 1 Category Name` AS `TrackingCategoryCategoryName`,
    `t`.`Tracking Category 1 Option Name` AS `TrackingCategoryOptionName`,
    `t`.`Contact ID` AS `ContactID`,
    `t`.`Contact Name` AS `ContactName`,
    `t`.`Source Type` AS `InvoiceOrBill`,
    `t`.`Account Class` AS `AccountClass`,
    (CONVERT(`t`.`Organisation ID` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `OrganisationID`,
    `t`.`ID` AS `ID`,
    `t`.`Journal ID` AS `JournalID`,
    (CONVERT(`t`.`Journal Date` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `JournalDate`,
    (CONVERT(`t`.`Journal Number` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `JournalNumber`,
    (CONVERT(`t`.`Created Date UTC` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `CreatedDateUTC`,
    `t`.`Source ID` AS `SourceID`,
    `t`.`Journal Line ID` AS `JournalLineID`,
    (CONVERT(`t`.`Gross Amount FX` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `GrossAmountFX`,
    `t`.`Tax Type` AS `TaxType`,
    `t`.`Tax Name` AS `TaxName`,
    `t`.`Tracking Category 1 Category ID` AS `TrackingCategoryCategoryID`,
    `t`.`Tracking Category 1 Option ID` AS `TrackingCategoryOptionID`,
    `t`.`Tracking Category 1 Option Stat` AS `TrackingCategoryOptionStat`,
    `t`.`Tracking Category 2 Category ID` AS `TrackingCategory2CategoryID`,
    `t`.`Tracking Category 2 Category Name` AS `TrackingCategory2CategoryName`,
    `t`.`Tracking Category 2 Option ID` AS `TrackingCategory2OptionID`,
    `t`.`Tracking Category 2 Option Name` AS `TrackingCategory2OptionName`,
    `t`.`Tracking Category 2 Option Stat` AS `TrackingCategory2OptionStat`,
    `t`.`Client ID` AS `ClientID`,
    `t`.`Split` AS `Split`,
    `t`.`ContactSource` AS `ContactSource`,
    `t`.`PaymentSourceID` AS `PaymentSourceID`,
    `t`.`PaymentType` AS `PaymentType`,
    `t`.`Changes` AS `Changes`,
    `t`.`User` AS `User`,
    `t`.`Details` AS `Details`,
    (CONVERT(`t`.`ShowOnCashBasisReports` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `ShowOnCashBasisReports`,
    (CONVERT(`t`.`FullyPaidOnDate` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `FullyPaidOnDate`,
    (CONVERT(`t`.`DayDifference` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `DayDifference`,
    'ACCRUALS' AS `JournalType`,
    `o`.`Name` AS `OrganisationName`,
    (CONVERT(`t`.`Index` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `Index`,
    `t`.`System Account` AS `SystemAccount`,
    `t`.`SourceNumber` AS `SourceNumber`,
    `t`.`ACC/ACCPAY` AS `ACCorACCPAY`,
    `t`.`Aged Movement` AS `AgedMovement`,
    `t`.`Debit Gross` AS `DebitGross`,
    `t`.`Debit Net Amount` AS `DebitNetAmount`,
    `t`.`Credit Gross` AS `CreditGross`,
    `t`.`Credit Net Amount` AS `CreditNetAmount`,
    `t`.`Cash Summary` AS `CashSummary`,
    `t`.`Source` AS `Source`,
    `t`.`Sync` AS `Sync`,
    `t`.`Planned Payment Date` AS `PlannedPaymentDate`,
    `t`.`Item Code` AS `ItemCode`,
    `t`.`Quantity` AS `Quantity`,
    `t`.`Discount Rate` AS `DiscountRate`,
    `t`.`Unit Amount` AS `UnitAmount`,
    `t`.`URL` AS `URL`,
    `t`.`Due Date` AS `DueDate`,
    `t`.`Invoice Total` AS `InvoiceTotal`
FROM `bigoleshoecompany_client1518_xeroblue_transactionsblend_aud` `t`
JOIN `bigoleshoecompany_client1518_xeroblue_organisations` `o` 
    ON `t`.`Organisation ID` = `o`.`Organisation ID`


CREATE OR REPLACE VIEW bigoleshoecompany_client1518_xeroblue_cashtransactions_aud AS
SELECT
    `t`.`Journal Date` AS `Date`,
    `t`.`Reference` AS `Reference`,
    `t`.`Source Type` AS `SourceType`,
    `t`.`Description` AS `Description`,
    `t`.`Account ID` AS `AccountID`,
    `t`.`Account Code` AS `AccountCode`,
    `t`.`Account Type` AS `AccountType`,
    `t`.`Account Name` AS `AccountName`,
    `t`.`Net Amount` AS `Amount`,
    `t`.`Tax Amount` AS `TaxAmount`,
    `t`.`Tracking Category 1 Category Name` AS `TrackingCategoryCategoryName`,
    `t`.`Tracking Category 1 Option Name` AS `TrackingCategoryOptionName`,
    `t`.`Contact ID` AS `ContactID`,
    `t`.`Contact Name` AS `ContactName`,
    `t`.`Source Type` AS `InvoiceOrBill`,
    `t`.`Account Class` AS `AccountClass`,
    (CONVERT(`t`.`Organisation ID` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `OrganisationID`,
    `t`.`ID` AS `ID`,
    `t`.`Journal ID` AS `JournalID`,
    (CONVERT(`t`.`Journal Date` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `JournalDate`,
    (CONVERT(`t`.`Journal Number` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `JournalNumber`,
    (CONVERT(`t`.`Created Date UTC` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `CreatedDateUTC`,
    `t`.`Source ID` AS `SourceID`,
    `t`.`Journal Line ID` AS `JournalLineID`,
    (CONVERT(`t`.`Gross Amount FX` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `GrossAmountFX`,
    `t`.`Tax Type` AS `TaxType`,
    `t`.`Tax Name` AS `TaxName`,
    `t`.`Tracking Category 1 Category ID` AS `TrackingCategoryCategoryID`,
    `t`.`Tracking Category 1 Option ID` AS `TrackingCategoryOptionID`,
    `t`.`Tracking Category 1 Option Stat` AS `TrackingCategoryOptionStat`,
    `t`.`Tracking Category 2 Category ID` AS `TrackingCategory2CategoryID`,
    `t`.`Tracking Category 2 Category Name` AS `TrackingCategory2CategoryName`,
    `t`.`Tracking Category 2 Option ID` AS `TrackingCategory2OptionID`,
    `t`.`Tracking Category 2 Option Name` AS `TrackingCategory2OptionName`,
    `t`.`Tracking Category 2 Option Stat` AS `TrackingCategory2OptionStat`,
    `t`.`Client ID` AS `ClientID`,
    `t`.`Split` AS `Split`,
    `t`.`ContactSource` AS `ContactSource`,
    `t`.`PaymentSourceID` AS `PaymentSourceID`,
    `t`.`PaymentType` AS `PaymentType`,
    `t`.`Changes` AS `Changes`,
    `t`.`User` AS `User`,
    `t`.`Details` AS `Details`,
    (CONVERT(`t`.`ShowOnCashBasisReports` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `ShowOnCashBasisReports`,
    (CONVERT(`t`.`FullyPaidOnDate` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `FullyPaidOnDate`,
    (CONVERT(`t`.`DayDifference` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `DayDifference`,
    'ACCRUALS' AS `JournalType`,
    `o`.`Name` AS `OrganisationName`,
    (CONVERT(`t`.`Index` USING utf8mb4) COLLATE utf8mb4_general_ci) AS `Index`,
    `t`.`System Account` AS `SystemAccount`,
    `t`.`SourceNumber` AS `SourceNumber`,
    `t`.`ACC/ACCPAY` AS `ACCorACCPAY`,
    `t`.`Aged Movement` AS `AgedMovement`,
    `t`.`Debit Gross` AS `DebitGross`,
    `t`.`Debit Net Amount` AS `DebitNetAmount`,
    `t`.`Credit Gross` AS `CreditGross`,
    `t`.`Credit Net Amount` AS `CreditNetAmount`,
    `t`.`Cash Summary` AS `CashSummary`,
    `t`.`Source` AS `Source`,
    `t`.`Sync` AS `Sync`,
    `t`.`Planned Payment Date` AS `PlannedPaymentDate`,
    `t`.`Item Code` AS `ItemCode`,
    `t`.`Quantity` AS `Quantity`,
    `t`.`Discount Rate` AS `DiscountRate`,
    `t`.`Unit Amount` AS `UnitAmount`,
    `t`.`URL` AS `URL`,
    `t`.`Due Date` AS `DueDate`,
    `t`.`Invoice Total` AS `InvoiceTotal`
FROM `bigoleshoecompany_client1518_xeroblue_transactionsblendcash_aud` `t`
JOIN `bigoleshoecompany_client1518_xeroblue_organisations` `o` 
    ON `t`.`Organisation ID` = `o`.`Organisation ID`