CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblend AS
SELECT 
    Tb.`Id` AS `ID`,
    Tb.`JournalId` AS `Journal ID`,
    Tb.`JournalNumber` AS `Index`,
    Tb.`JournalDate` AS `Journal Date`,
    Tb.`JournalNumber` AS `Journal Number`,
    Tb.`CreatedDateUTC` AS `Created Date UTC`,
    Tb.`Reference` AS `Reference`,
    Tb.`SourceId` AS `Source ID`,
    IFNULL(Tb.`SourceType`, 'NULL VALUE') AS `Source Type`,
    Tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    Tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    Tb.`JournalLine_NetAmount` AS `Net Amount`,
    Tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    Tb.`JournalLine_TaxAmount` AS `Tax Amount`,
    Tb.`JournalLine_TaxType` AS `Tax Type`,
    Tb.`JournalLine_TaxName` AS `Tax Name`,
    Tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    Tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    Tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    Tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    Tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    Tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    Tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    Tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    Tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    Tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    Tb.`ClientID` AS `Client ID`,
    Tb.`OrganisationID` AS `Organisation ID`,
    Tb.`Split` AS `Split`,
    Tb.`ContactID` AS `Contact ID`,
    Tb.`ContactName` AS `Contact Name`,
    Tb.`ContactSource` AS `ContactSource`,
    Tb.`PaymentSourceID` AS `PaymentSourceID`,
    Tb.`PaymentType` AS `PaymentType`,
    Tb.`Changes` AS `Changes`,
    Tb.`User` AS `User`,
    Tb.`Details` AS `Details`,
    Tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    Tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
    Tb.`DayDifference` AS `DayDifference`,
    COALESCE(Tb.`InvoiceNumber`,Tb.`CreditNoteNumber`) AS `SourceNumber`
FROM evadb_stage.c0000_xeroblue_journals Tb
LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
ON Tb.`JournalLine_AccountId` = Acc.`AccountId` AND Tb.`OrganisationID` = Acc.`OrganisationID`;

CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblendcash AS
SELECT 
    Tb.`Id` AS `ID`,
    Tb.`JournalId` AS `Journal ID`,
    Tb.`JournalNumber` AS `Index`,
    Tb.`JournalDate` AS `Journal Date`,
    Tb.`JournalNumber` AS `Journal Number`,
    Tb.`CreatedDateUTC` AS `Created Date UTC`,
    Tb.`Reference` AS `Reference`,
    Tb.`SourceId` AS `Source ID`,
    IFNULL(Tb.`SourceType`, 'NULL VALUE') AS `Source Type`,
    Tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    Tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    Tb.`JournalLine_NetAmount` AS `Net Amount`,
    Tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    Tb.`JournalLine_TaxAmount` AS `Tax Amount`,
    Tb.`JournalLine_TaxType` AS `Tax Type`,
    Tb.`JournalLine_TaxName` AS `Tax Name`,
    Tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    Tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    Tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    Tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    Tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    Tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    Tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    Tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    Tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    Tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    Tb.`ClientID` AS `Client ID`,
    Tb.`OrganisationID` AS `Organisation ID`,
    Tb.`Split` AS `Split`,
    Tb.`ContactID` AS `Contact ID`,
    Tb.`ContactName` AS `Contact Name`,
    Tb.`ContactSource` AS `ContactSource`,
    Tb.`PaymentSourceID` AS `PaymentSourceID`,
    Tb.`PaymentType` AS `PaymentType`,
    Tb.`Changes` AS `Changes`,
    Tb.`User` AS `User`,
    Tb.`Details` AS `Details`,
    Tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    Tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
    Tb.`DayDifference` AS `DayDifference`,
    COALESCE(Tb.`InvoiceNumber`,Tb.`CreditNoteNumber`) AS `SourceNumber`
FROM evadb_stage.c0000_xeroblue_journalscash Tb
LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
ON Tb.`JournalLine_AccountId` = Acc.`AccountId` AND Tb.`OrganisationID` = Acc.`OrganisationID`;


CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblend_fxcurrency AS
SELECT 
    Tb.`Id` AS `ID`,
    Tb.`JournalId` AS `Journal ID`,
    Tb.`JournalNumber` AS `Index`,
    Tb.`JournalDate` AS `Journal Date`,
    Tb.`JournalNumber` AS `Journal Number`,
    Tb.`CreatedDateUTC` AS `Created Date UTC`,
    Tb.`Reference` AS `Reference`,
    Tb.`SourceId` AS `Source ID`,
    Tb.`SourceType` AS `Source Type`,
    Tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    Tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    Tb.`JournalLine_NetAmount` AS `Net Amount`,
    Tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    Tb.`JournalLine_TaxAmount` AS `Tax Amount`,
    Tb.`JournalLine_NetAmount_fxcurrency` AS `Net Amount FX`,
    Tb.`JournalLine_GrossAmount_fxcurrency` AS `Gross Amount FX`,
    Tb.`JournalLine_TaxAmount_fxcurrency` AS `Tax Amount FX`,
    Tb.`JournalLine_TaxType` AS `Tax Type`,
    Tb.`JournalLine_TaxName` AS `Tax Name`,
    Tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    Tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    Tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    Tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    Tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    Tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    Tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    Tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    Tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    Tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    Tb.`ClientID` AS `Client ID`,
    Tb.`OrganisationID` AS `Organisation ID`,
    Tb.`Split` AS `Split`,
    Tb.`ContactID` AS `Contact ID`,
    Tb.`ContactName` AS `Contact Name`,
    Tb.`ContactSource` AS `ContactSource`,
    Tb.`PaymentSourceID` AS `PaymentSourceID`,
    Tb.`PaymentType` AS `PaymentType`,
    Tb.`Changes` AS `Changes`,
    Tb.`User` AS `User`,
    Tb.`Details` AS `Details`,
    Tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    Tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
    Tb.`DayDifference` AS `DayDifference`,
    COALESCE(Tb.`InvoiceNumber`,Tb.`CreditNoteNumber`) AS `SourceNumber`,
    'Accruals' AS `Cash/Accruals`,
    Tb.`ACC_ACCPAY` AS `ACC/ACCPAY`,
    Tb.`Accounts_Class` AS `Accounts.Class`,
    Tb.`PnL_BS` AS `PnL-BS`,
    Tb.`AgedMovement` AS `Aged Movement`,
    Tb.`CashReceived` AS `Cash Received`,
    Tb.`CashSpent` AS `Cash Spent`,
    Tb.`DebitGross` AS `Debit Gross`,
    Tb.`DebitNetAmount` AS `Debit Net Amount`,
    Tb.`CreditGross` AS `Credit Gross`,
    Tb.`CreditNetAmount` AS `Credit Net Amount`,
    Tb.`DebitGrossFX` AS `Debit Gross FX`,
    Tb.`DebitNetAmountFX` AS `Debit Net Amount FX`,
    Tb.`CreditGrossFX` AS `Credit Gross FX`,
    Tb.`CreditNetAmountFX` AS `Credit Net Amount FX`,
    Tb.`CashSummary` AS `Cash Summary`,
    Tb.`DetailedBreakdownAccountNames` AS `Detailed Breakdown Account Names`,
    CASE 
        WHEN Tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
        WHEN Tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
        WHEN Tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
        WHEN Tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
        WHEN Tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
        WHEN Tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Credit Note'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Approved' THEN 'Payable Credit Note'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Credit Note'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Edited' THEN 'Payable Credit Note'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Credited' THEN 'Payable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Applied' THEN 'Payable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Prepayment'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Payable Prepayment'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Prepayment'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Payable Prepayment'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Payable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Prepayment Note Allocation'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Payable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Overpayment'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Payable Overpayment'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Overpayment'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Payable Overpayment'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Payable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Payable Overpayment Allocation'
        ELSE NULL 
    END AS `Source`,
    CASE
        WHEN Tb.`ContactSource` = 'PAYMENTS' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'INVOICES' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` = 'Approved' THEN
            TRIM(REPLACE (CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` = 'Edited' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'OVERPAYMENTS' AND Tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'OVERPAYMENTS' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'PREPAYMENTS' AND Tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'PREPAYMENTS' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        ELSE NULL
    END AS `Sync`,
    Tb.`PlannedPaymentDate` AS `Planned Payment Date`,
    Tb.`ItemCode` AS `Item Code`,
    Tb.`Quantity` AS `Quantity`,
    Tb.`DiscountRate` AS `Discount Rate`,
    Tb.`UnitAmount` AS `Unit Amount`,
    Tb.`UnitAmount_fxcurrency` AS `Unit Amount FX`,
    Tb.`AmountDue` AS `Amount Due`,
    Tb.`AmountDue_fxcurrency` AS `Amount Due FX`,
    Tb.`URL` AS `URL`,
    Tb.`DueDate` AS `Due Date`,
    Acc.`SystemAccount` AS `System Account`,
    NULL AS `Invoice Total`,
    Acc.`Class` AS `Account Class`
FROM evadb_stage.c0000_xeroblue_journals Tb
LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
ON Tb.`JournalLine_AccountId` = Acc.`AccountId` AND Tb.`OrganisationID` = Acc.`OrganisationID`;

CREATE OR REPLACE VIEW bigoleshoecompany_client0000_xeroblue_transactionsblendcash_fxcurrency AS
SELECT 
    Tb.`Id` AS `ID`,
    Tb.`JournalId` AS `Journal ID`,
    Tb.`JournalNumber` AS `Index`,
    Tb.`JournalDate` AS `Journal Date`,
    Tb.`JournalNumber` AS `Journal Number`,
    Tb.`CreatedDateUTC` AS `Created Date UTC`,
    Tb.`Reference` AS `Reference`,
    Tb.`SourceId` AS `Source ID`,
    Tb.`SourceType` AS `Source Type`,
    Tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    Tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    Tb.`JournalLine_NetAmount` AS `Net Amount`,
    Tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    Tb.`JournalLine_TaxAmount` AS `Tax Amount`,
    Tb.`JournalLine_NetAmount_fxcurrency` AS `Net Amount FX`,
    Tb.`JournalLine_GrossAmount_fxcurrency` AS `Gross Amount FX`,
    Tb.`JournalLine_TaxAmount_fxcurrency` AS `Tax Amount FX`,
    Tb.`JournalLine_TaxType` AS `Tax Type`,
    Tb.`JournalLine_TaxName` AS `Tax Name`,
    Tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    Tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    Tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    Tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    Tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    Tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    Tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    Tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    Tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    Tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    Tb.`ClientID` AS `Client ID`,
    Tb.`OrganisationID` AS `Organisation ID`,
    Tb.`Split` AS `Split`,
    Tb.`ContactID` AS `Contact ID`,
    Tb.`ContactName` AS `Contact Name`,
    Tb.`ContactSource` AS `ContactSource`,
    Tb.`PaymentSourceID` AS `PaymentSourceID`,
    Tb.`PaymentType` AS `PaymentType`,
    Tb.`Changes` AS `Changes`,
    Tb.`User` AS `User`,
    Tb.`Details` AS `Details`,
    Tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    Tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
    Tb.`DayDifference` AS `DayDifference`,
    COALESCE(Tb.`InvoiceNumber`,Tb.`CreditNoteNumber`) AS `SourceNumber`,
    'Cash' AS `Cash/Accruals`,
    Tb.`ACC_ACCPAY` AS `ACC/ACCPAY`,
    Tb.`Accounts_Class` AS `Accounts.Class`,
    Tb.`PnL_BS` AS `PnL-BS`,
    Tb.`AgedMovement` AS `Aged Movement`,
    Tb.`CashReceived` AS `Cash Received`,
    Tb.`CashSpent` AS `Cash Spent`,
    Tb.`DebitGross` AS `Debit Gross`,
    Tb.`DebitNetAmount` AS `Debit Net Amount`,
    Tb.`CreditGross` AS `Credit Gross`,
    Tb.`CreditNetAmount` AS `Credit Net Amount`,
    Tb.`DebitGrossFX` AS `Debit Gross FX`,
    Tb.`DebitNetAmountFX` AS `Debit Net Amount FX`,
    Tb.`CreditGrossFX` AS `Credit Gross FX`,
    Tb.`CreditNetAmountFX` AS `Credit Net Amount FX`,
    Tb.`CashSummary` AS `Cash Summary`,
    Tb.`DetailedBreakdownAccountNames` AS `Detailed Breakdown Account Names`,
    CASE 
        WHEN Tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
        WHEN Tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
        WHEN Tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
        WHEN Tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
        WHEN Tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
        WHEN Tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Credit Note'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Approved' THEN 'Payable Credit Note'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Credit Note'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Edited' THEN 'Payable Credit Note'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Credited' THEN 'Payable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCRECCREDIT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ACCPAYCREDIT' AND Tb.`Changes` = 'Applied' THEN 'Payable Credit Note Allocation'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Prepayment'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Payable Prepayment'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Prepayment'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Payable Prepayment'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Payable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'ARPREPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Prepayment Note Allocation'
        WHEN Tb.`SourceType` = 'APPREPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Payable Prepayment Allocation'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Receivable Overpayment'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Approved' THEN 'Payable Overpayment'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Receivable Overpayment'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Edited' THEN 'Payable Overpayment'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Receivable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Credited' THEN 'Payable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'AROVERPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Receivable Overpayment Allocation'
        WHEN Tb.`SourceType` = 'APOVERPAYMENT' AND Tb.`Changes` = 'Applied' THEN 'Payable Overpayment Allocation'
        ELSE NULL 
    END AS `Source`,
    CASE
        WHEN Tb.`ContactSource` = 'PAYMENTS' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'INVOICES' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` = 'Approved' THEN
            TRIM(REPLACE (CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` = 'Edited' THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'CREDITNOTES' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'OVERPAYMENTS' AND Tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'OVERPAYMENTS' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'PREPAYMENTS' AND Tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`SourceId`), '  ', ' '))
        WHEN Tb.`ContactSource` = 'PREPAYMENTS' AND Tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(Tb.`JournalLine_AccountId`, ' | ', Tb.`PaymentSourceID`), '  ', ' '))
        ELSE NULL
    END AS `Sync`,
    Tb.`PlannedPaymentDate` AS `Planned Payment Date`,
    Tb.`ItemCode` AS `Item Code`,
    Tb.`Quantity` AS `Quantity`,
    Tb.`DiscountRate` AS `Discount Rate`,
    Tb.`UnitAmount` AS `Unit Amount`,
    Tb.`UnitAmount_fxcurrency` AS `Unit Amount FX`,
    Tb.`AmountDue` AS `Amount Due`,
    Tb.`AmountDue_fxcurrency` AS `Amount Due FX`,
    Tb.`URL` AS `URL`,
    Tb.`DueDate` AS `Due Date`,
    Acc.`SystemAccount` AS `System Account`,
    NULL AS `Invoice Total`,
    Acc.`Class` AS `Account Class`
FROM evadb_stage.c0000_xeroblue_journalscash Tb
LEFT JOIN evadb_stage.c0000_xeroblue_accounts Acc 
ON Tb.`JournalLine_AccountId` = Acc.`AccountId` AND Tb.`OrganisationID` = Acc.`OrganisationID`;