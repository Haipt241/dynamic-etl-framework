/******************************************************************
APPLIED CHANGES:
DATE            CHANGES
2025-03-07      20250305_new transactionsblend-journals views

*******************************************************************/

DROP VIEW IF EXISTS `FOREIGNEXCHANGE_MASTER`;
CREATE VIEW `FOREIGNEXCHANGE_MASTER` AS
SELECT * FROM evadb_stage.FOREIGNEXCHANGE_MASTER;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_lastrefreshdate;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_lastrefreshdate AS
SELECT 
    `Id` AS `Id`,
    `TableName` AS `Table Name`,
    `TotalRowCount` AS `Result Row Count`,
    `LastRefreshUTCDate` AS `Last Refresh UTC Date`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `LegacyOrganisationID` AS `Legacy Organisation ID`
FROM evadb_stage.c1518_xeroblue_lastrefreshdate;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_accounts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_accounts AS
SELECT 
    `P&LReportingTypeInterim` AS `P&L Reporting Type Interim`,
    `AccountId` AS `Account ID`,
    `Code` AS `Code`,
    `Name` AS `Name`,
    `Type` AS `Type`,
    `Description` AS `Description`,
    `TaxType` AS `Tax Type`,
    `EnablePaymentsToAccount` AS `Enable Payments To Account`,
    `ShowInExpenseClaims` AS `Show In Expense Claims`,
    `Class` AS `Class`,
    `Status` AS `Status`,
    `SystemAccount` AS `System Account`,
    `BankAccountNumber` AS `Bank Account Number`,
    `CurrencyCode` AS `Currency Code`,
    `ReportingCode` AS `Reporting Code`,
    `ReportingCodeName` AS `Reporting Code Name`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `BankAccountType` AS `Bank Account Type`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `AccountType` AS `Account Type`,
    `ClassOrder` AS `Class Order`,
    `AccountTypeOrder` AS `Account Type Order`,
    `P&LGroup` AS `P&L Group`,
    `P&LGroupOrder` AS `P&L Group Order`,
    `BalanceSheetType` AS `Balance Sheet Type`,
    `BalanceSheetGroup` AS `Balance Sheet Group`,
    `BalanceSheetAccountName` AS `Balance Sheet Account Name`,
    `BalanceSheetReportingGroup` AS `Balance Sheet Reporting Group`,
    `BalanceSheetReportingType` AS `Balance Sheet Reporting Type`,
    `BalanceSheetReportingTypeOrder` AS `Balance Sheet Reporting Type Order`,
    `BalanceSheetReportingGroupOrder` AS `Balance Sheet Reporting Group Order`,
    `P&LReportingType` AS `P&L Reporting Type`,
    `P&LReportingGroup` AS `P&L Reporting Group`,
    `P&LReportingGroupOrder` AS `P&L Reporting Group Order`,
    `P&LReportingTypeOrder` AS `P&L Reporting Type Order`,
    `BalanceSheetGroupOrder` AS `Balance Sheet Group Order`,
    `StatementofCashflow` AS `Statement of Cashflow`,
    `CashflowActivities` AS `Cashflow Activities`,
    `CashflowActivitiesOrder` AS `Cashflow Activities Order`,
    `StatementofCashflowOrder` AS `Statement of Cashflow Order`,
    `CashIn/CashOut` AS `Cash In / Cash Out`,
    `Account_UID` AS `Account_UID`,
    `AccountName_UID` AS `AccountName_UID`
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY IFNULL(`Code`, 'BLANK'), CAST(`OrganisationID` AS CHAR) ORDER BY `AccountId`) rn 
    FROM evadb_stage.c1518_xeroblue_accounts 
    WHERE `Code` IS NOT NULL
) t;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_banktransactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_banktransactions AS
SELECT 
    `Id` AS `Bank Transaction Line ID`,
    `BankTransactionId` AS `Bank Transaction ID`,
    `Type` AS `Type`,
    `Contact_ContactName` AS `Contact Name`,
    `Contact_ContactId` AS `Contact ID`,
    `BankAccount_AccountId` AS `Account ID`,
    `BankAccount_AccountName` AS `Bank Account Account Name`,
    `BankAccount_Code` AS `Bank Account Code`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_AccountCode` AS `Account Code Posted Against`,
    IFNULL(`LineItem_TaxType`, 'BLANK') AS `Tax Type`, 
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 CategoryID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 CategoryID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItemAggregate` AS `Line Item Aggregate`,
    `IsReconciled` AS `Is Reconciled`,
    `Date` AS `Date`,
    `Reference` AS `Reference`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `URL` AS `URL`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `PrepaymentId` AS `Prepayment ID`,
    `OverpaymentId` AS `Overpayment ID`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `LineAmountTypes` AS `Line Amount Types`,
    `Account_UID` AS `Account_UID`,
    `BankTansactionCashflowCalculation` AS `Bank Tansaction Cashflow Calculation`,
    `LineAmountCalculatedIncTax` AS `Line Amount Calculated Inc Tax`,
    `PaymentAmount` AS `Payment Amount`
FROM evadb_stage.c1518_xeroblue_banktransactions 
WHERE `Status` IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_banktransfers;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_banktransfers AS
SELECT
	`BankTransferId` AS `Bank Transfer ID`, 
	`FromBankAccount_Code` AS `From Bank Account Code`,
	`FromBankAccount_AccountId` AS `FromBankAccount_AccountId` ,
	`FromBankAccount_Name` AS `From Bank Account Name` ,
	`ToBankAccount_Code` AS `To Bank Account Code` ,
	`ToBankAccount_AccountId` AS `ToBankAccount_AccountId` ,
	`ToBankAccount_Name` AS `To Bank Account Name`,
	`Amount`  AS `Amount` ,
	`Date` AS `Date` ,
	`CurrencyRate` AS `Currency Rate` ,
	`FromBankTransactionID` AS `From Bank Transaction ID` ,
	`ToBankTransactionID` AS `To Bank Transaction ID` ,
	`HasAttachments` AS `Has Attachments` ,
	`CreatedDateUTC` AS `Created Date UTC` ,
	`ClientID` AS `Client ID` ,
	`OrganisationID` AS `Organisation ID` 
FROM evadb_stage.c1518_xeroblue_banktransfers;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_brandingthemes;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_brandingthemes AS
SELECT 
    `BrandingThemeId` AS `Branding Theme ID`,
	`Name` AS `Name`,
	`SortOrder` AS `Sort Order`,
	`CreatedDateUTC` AS `Created Date UTC`,
	`ClientID` AS `Client ID`,
	`OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_brandingthemes;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_contactgroups;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_contactgroups AS
SELECT 
    `Id` AS `ID`,
    `ContactGroupId` AS `Contact Group ID`,
    `Name` AS `Name`,
    `Status` AS `Status`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_contactgroups;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_contacts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_contacts AS
SELECT 
    `ContactId` AS `Contact ID`,
    `Name` AS `Name`,
    `AccountNumber` AS `Account Number`,
    `ContactNumber` AS `Contact Number`,
    `ContactStatus` AS `Contact Status`,
    `FirstName` AS `First Name`,
    `LastName` AS `Last Name`,
    `EmailAddress` AS `Email Address`,
    `SkypeUserName` AS `Skype User Name`,
    `ContactPerson1_FirstName` AS `Contact Person 1 First Name`,
    `ContactPerson1_LastName` AS `Contact Person 1 Last Name`,
    `ContactPerson1_EmailAddress` AS `Contact Person 1 Email Address`,
    `ContactPerson1_IncludeInEmails` AS `Contact Person 1 Include In Emails`,
    `ContactPerson2_FirstName` AS `Contact Person 2 First Name`,
    `ContactPerson2_LastName` AS `Contact Person 2 Last Name`,
    `ContactPerson2_EmailAddress` AS `Contact Person 2 Email Address`,
    `ContactPerson2_IncludeInEmails` AS `Contact Person 2 Include In Emails`,
    `ContactPerson3_FirstName` AS `Contact Person 3 First Name`,
    `ContactPerson3_LastName` AS `Contact Person 3 Last Name`,
    `ContactPerson3_EmailAddress` AS `Contact Person 3 Email Address`,
    `ContactPerson3_IncludeInEmails` AS `Contact Person 3 Include In Emails`,
    `ContactPerson4_FirstName` AS `Contact Person 4 First Name`,
    `ContactPerson4_LastName` AS `Contact Person 4 Last Name`,
    `ContactPerson4_EmailAddress` AS `Contact Person 4 Email Address`,
    `ContactPerson4_IncludeInEmails` AS `Contact Person 4 Include In Emails`,
    `BankAccountDetails` AS `Bank Account Details`,
    `TaxNumber` AS `Tax Number`,
    `AccountsReceivableTaxType` AS `Accounts Receivable Tax Type`,
    `AccountsPayableTaxType` AS `Accounts Payable Tax Type`,
    `Street_AddressLine1` AS `Address Line 1`,
    `Street_AddressLine2` AS `Address Line 2`,
    `Street_AddressLine3` AS `Address Line 3`,
    `Street_AddressLine4` AS `Address Line 4`,
    `Street_City` AS `Suburb`,
    `Street_Region` AS `Region`,
    `Street_PostalCode` AS `Postal Code`,
    `Street_Country` AS `Country`,
    `Street_AttentionTo` AS `Street Attention To`,
    `POBox_AddressLine1` AS `PO Box Address Line 1`,
    `POBox_AddressLine2` AS `PO Box Address Line 2`,
    `POBox_AddressLine3` AS `PO Box Address Line 3`,
    `POBox_AddressLine4` AS `PO Box Address Line 4`,
    `POBox_City` AS `PO Box City`,
    `POBox_Region` AS `PO Box Region`,
    `POBox_PostalCode` AS `PO Box Postal Code`,
    `POBox_Country` AS `PO Box Country`,
    `POBox_AttentionTo` AS `PO Box Attention To`,
    `DDI_PhoneNumber` AS `DDI Phone Number`,
    `DDI_PhoneAreaCode` AS `DDI Phone Area Code`,
    `DDI_PhoneCountryCode` AS `DDI Phone Country Code`,
    `Default_PhoneNumber` AS `Default Phone Number`,
    `Default_PhoneAreaCode` AS `Default Phone Area Code`,
    `Default_PhoneCountryCode` AS `Default Phone Country Code`,
    `Fax_PhoneNumber` AS `Fax Phone Number`,
    `Fax_PhoneAreaCode` AS `Fax Phone Area Code`,
    `Fax_PhoneCountryCode` AS `Fax Phone Country Code`,
    `Mobile_PhoneNumber` AS `Mobile Phone Number`,
    `Mobile_PhoneAreaCode` AS `Mobile Phone Area Code`,
    `Mobile_PhoneCountryCode` AS `Mobile Phone Country Code`,
    `UpdatedDateUTC` AS `Updated Date UTC`, 
    `ContactGroupId` AS `Contact Group ID`,
    `IsSupplier` AS `Is Supplier`,
    `IsCustomer` AS `Is Customer`,
    `DefaultCurrency` AS `Default Currency`,
    `Website` AS `Website`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `BrandingThemeName` AS `Branding Theme Name`,
    `PurchasesDefaultAccountCode` AS `Purchases Default Account Code`,
    `SalesDefaultAccountCode` AS `Sales Default Account Code`,
    `BatchPayments_BankAccountNumber` AS `Batch Payments Bank Account Number`,
    `BatchPayments_BankAccountName` AS `Batch Payments Bank Account Name`,
    `BatchPayments_Details` AS `Batch Payments Details`,
    `BatchPayments_Code` AS `Batch Payments Code`,
    `BatchPayments_Reference` AS `Batch Payments Reference`,
    `Discount` AS `Discount`,
    `Balances_AccountsReceivable_Outstanding` AS `Balances Accounts Receivable Outstanding`,
    `Balances_AccountsReceivable_Overdue` AS `Balances Accounts Receivable Overdue`,
    `Balances_AccountsPayable_Outstanding` AS `Balances Accounts Payable Outstanding`,
    `Balances_AccountsPayable_Overdue` AS `Balances Accounts Payable Overdue`,
    `PaymentTerms_Bills_Day` AS `Payment Terms Bills Day`,
    `PaymentTerms_Bills_Type` AS `Payment Terms Bills Type`,
    `PaymentTerms_Sales_Day` AS `Payment Terms Sales Day`,
    `PaymentTerms_Sales_Type` AS `Payment Terms Sales Type`,
    `SalesTrackingCategory1_Name` AS `Sales Tracking Category 1 Name`,
    `SalesTrackingOption1_Name` AS `Sales Tracking Option 1 Name`,
    `SalesTrackingCategory2_Name` AS `Sales Tracking Category 2 Name`,
    `SalesTrackingOption2_Name` AS `Sales Tracking Option 2 Name`,
    `PurchaseTrackingCategory1_Name` AS `Purchase Tracking Category 1 Name`,
    `PurchaseTrackingOption1_Name` AS `Purchase Tracking Option 1 Name`,
    `PurchaseTrackingCategory2_Name` AS `Purchase Tracking Category 2 Name`,
    `PurchaseTrackingOption2_Name` AS `Purchase Tracking Option 2 Name`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `FullAddress` AS `Full Address`,
    `RegionAddress` AS `Region Address`
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY `ContactId` ORDER BY `ContactId`) AS rn 
    FROM evadb_stage.c1518_xeroblue_contacts
) t WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnotes;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnotes AS
SELECT 
    `Id` AS `Credit Note Line ID`,
    `CreditNoteId` AS `Credit Note ID`,
    `CreditNoteNumber` AS `Credit Note Number`,
    `Reference` AS `Reference`,
    `Type` AS `Type`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `Date` AS `Date`,
    `Status` AS `Status`,
    `LineAmountTypes` AS `Line Amount Types`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineItemAggregate` AS `Line Item Aggregate`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `CurrencyCode` AS `Currency Code`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `SentToContact` AS `Sent To Contact`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `CurrencyRate` AS `Currency Rate`,
    `RemainingCredit` AS `Remaining Credit`,
    `Allocation1_AppliedAmount` AS `Allocation 1 Applied Amount`,
    `Allocation1_Date` AS `Allocation 1 Date`,
    `Allocation1_InvoiceId` AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber` AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount` AS `Allocation 2 Applied Amount`,
    `Allocation2_Date` AS `Allocation 2 Date`,
    `Allocation2_InvoiceId` AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber` AS `Allocation 2 Invoice Number`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Allocation3_AppliedAmount` AS `Allocation 3 Applied Amount`,
    `Allocation3_Date` AS `Allocation 3 Date`,
    `Allocation3_InvoiceId` AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber` AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount` AS `Allocation 4 Applied Amount`,
    `Allocation4_Date` AS `Allocation 4 Date`,
    `Allocation4_InvoiceId` AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber` AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount` AS `Allocation 5 Applied Amount`,
    `Allocation5_Date` AS `Allocation 5 Date`,
    `Allocation5_InvoiceId` AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber` AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount` AS `Allocation 6 Applied Amount`,
    `Allocation6_Date` AS `Allocation 6 Date`,
    `Allocation6_InvoiceId` AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber` AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount` AS `Allocation 7 Applied Amount`,
    `Allocation7_Date` AS `Allocation 7 Date`,
    `Allocation7_InvoiceId` AS ` Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber` AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount` AS `Allocation 8 Applied Amount`,
    `Allocation8_Date` AS `Allocation 8 Date`,
    `Allocation8_InvoiceId` AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber` AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount` AS `Allocation 9 Applied Amount`,
    `Allocation9_Date` AS `Allocation 9 Date`,
    `Allocation9_InvoiceId` AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber` AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount` AS `Allocation 10 Applied Amount`,
    `Allocation10_Date` AS `Allocation 10 Date`,
    `Allocation10_InvoiceId` AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber` AS `Allocation 10 Invoice Number`,
    `Allocation11_AppliedAmount` AS `Allocation 11 Applied Amount`,
    `Allocation11_Date` AS `Allocation 11 Date`,
    `Allocation11_InvoiceId` AS `Allocation 11 Invoice ID`,
    `Allocation11_InvoiceNumber` AS `Allocation 11 Invoice Number`,
    `Allocation12_AppliedAmount` AS `Allocation 12 Applied Amount`,
    `Allocation12_Date` AS `Allocation 12 Date`,
    `Allocation12_InvoiceId` AS `Allocation 12 Invoice ID`,
    `Allocation12_InvoiceNumber` AS `Allocation 12 Invoice Number`,
    `Allocation13_AppliedAmount` AS `Allocation 13 Applied Amount`,
    `Allocation13_Date` AS `Allocation 13 Date`,
    `Allocation13_InvoiceId` AS `Allocation 13 Invoice ID`,
    `Allocation13_InvoiceNumber` AS `Allocation 13 Invoice Number`,
    `Allocation14_AppliedAmount` AS `Allocation 14 Applied Amount`,
    `Allocation14_Date` AS `Allocation 14 Date`,
    `Allocation14_InvoiceId` AS `Allocation 14 Invoice ID`,
    `Allocation14_InvoiceNumber` AS `Allocation 14 Invoice Number`,
    `Allocation15_AppliedAmount` AS `Allocation 15 Applied Amount`,
    `Allocation15_Date` AS `Allocation 15 Date`,
    `Allocation15_InvoiceId` AS `Allocation 15 Invoice ID`,
    `Allocation15_InvoiceNumber` AS `Allocation 15 Invoice Number`,
    `AccountUID` AS `Account UID`,
    `LineAmountCreditNoteCalculation` AS `Line Amount Credit Note Calculation`,
    `LineAmountTradeCreditorCalculation` AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation` AS `Line Amount Trade Debtor Calculation`
FROM evadb_stage.c1518_xeroblue_creditnotes
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_currencies;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_currencies AS
SELECT 
    `Code` AS `Code`,
    `Description` AS `Description`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_currencies;

DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_employees;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_employees AS
SELECT 
    `EmployeeId` AS `Employee ID`,
    `Status` AS `Status`,
    `FirstName` AS `First Name`,
    `LastName` AS `Last Name`,
    `ExternalLink_URL` AS `External Link URL`,
    `ExternalLink_Description` AS `External Link Description`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_employees;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoices;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoices AS
SELECT
    `Id` AS `Invoice Line ID`,
    `InvoiceId` AS `Invoice ID`,
    `Type` AS `Type`,
    `ContactId` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Line Item - Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `DiscountRate%` AS `Discount Rate %`,
    `LineItem_DiscountAmount` AS `Discount Amount`,
    `LineItemAggregate` AS `Aggregate`,
    `Date` AS `Date`,
    `DueDate` AS `Due Date`,
    `LineAmountTypes` AS `Line Amount Types`,
    `InvoiceNumber` AS `Invoice Number`,
    `Reference` AS `Reference`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `URL` AS `URL`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `Status` AS `Status`,
    `SentToContact` AS `Sent To Contact`,
    `ExpectedPaymentDate` AS `Expected Payment Date`,
    `PlannedPaymentDate` AS `Planned Payment Date`,
    `SubTotal` AS `Invoice - Sub Total`,
    `TotalTax` AS `Invoice - Total Tax`,
    `Total` AS `Invoice Total`,
    `TotalDiscount` AS `Total Discount`,
    `HasAttachments` AS `Has Attachments`,
    `AmountDue` AS `Invoice - Amount Due`,
    `AmountPaid` AS `Invoice - Amount Paid`,
    `CISDeduction` AS `CIS Deduction`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `AmountCredited` AS `Amount Credited`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `CreditNotes` AS `Credit Notes`,
    `Payments` AS `Payments`,
    `Prepayments` AS `Pre Payments`,
    `Overpayments` AS `Over Payments`,
    `RepeatingInvoiceID` AS `Repeating Invoice ID`,
    `Account_UID` AS `Account_UID`,
    `PaymentIds` AS `Payment ID`,
    `PrePaymentIds` AS `Pre Payment ID`,
    `OverPaymentIds` AS `Over Payment ID`,
    `CreditNoteIDs` AS `Credit Note ID`,
    `LineAmountCalculation` AS `Line Amount Calculation`,
    `LineAmountCalculationIncTax` AS `Line Amount Calculation Inc Tax`,
    `LineAmountTradeCreditorCalculation` AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation` AS `Line Amount Trade Debtor Calculation`,
    `DayDifference` AS `Day Difference`
FROM evadb_stage.c1518_xeroblue_invoices
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniqueinvoices;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniqueinvoices AS
SELECT 
    `Id` AS `Invoice Line ID`,
    `InvoiceId` AS `Invoice ID`,
    `Type` AS `Type`,
    `ContactId` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Line Item - Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `DiscountRate%` AS `Discount Rate %`,
    `LineItem_DiscountAmount` AS `Discount Amount`,
    `LineItemAggregate` AS `Aggregate`,
    `Date` AS `Date`,
    `DueDate` AS `Due Date`,
    `LineAmountTypes` AS `Line Amount Types`,
    `InvoiceNumber` AS `Invoice Number`,
    `Reference` AS `Reference`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `URL` AS `URL`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `Status` AS `Status`,
    `SentToContact` AS `Sent To Contact`,
    `ExpectedPaymentDate` AS `Expected Payment Date`,
    `PlannedPaymentDate` AS `Planned Payment Date`,
    `SubTotal` AS `Invoice - Sub Total`,
    `TotalTax` AS `Invoice - Total Tax`,
    `Total` AS `Invoice Total`,
    `TotalDiscount` AS `Total Discount`,
    `HasAttachments` AS `Has Attachments`,
    `PaymentIds` AS `Payment ID`,
    `PrePaymentIds` AS `Pre Payment ID`,
    `OverPaymentIds` AS `Over Payment ID`,
    `CreditNoteIDs` AS `Credit Note ID`,
    `AmountDue` AS `Invoice - Amount Due`,
    `AmountPaid` AS `Invoice - Amount Paid`,
    `CISDeduction` AS `CIS Deduction`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `AmountCredited` AS `Amount Credited`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `CreditNotes` AS `Credit Notes`,
    `Payments` AS `Payments`,
    `Prepayments` AS `Pre Payments`,
    `Overpayments` AS `Over Payments`,
    `RepeatingInvoiceID` AS `Repeating Invoice ID`,
    `Account_UID` AS `Account_UID`,
    `DayDifference` AS `Day Difference`
FROM (
        SELECT *, Row_number() OVER(PARTITION BY `InvoiceId`, `OrganisationID` ORDER BY Id) rn 
        FROM evadb_stage.c1518_XEROBLUE_Invoices
        WHERE Status in ('AUTHORISED', 'PAID')
    ) Invoices
WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_items;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_items AS
SELECT 
    `ItemId` AS `Item ID`,
    `Code` AS `Code`,
    `InventoryAssetAccountCode` AS `Inventory Asset Account Code`,
    `Name` AS `Name`,
    `PurchaseDescription` AS `Purchase Description`,
    `Description` AS `Description`,
    `PurchaseDetails_UnitPrice` AS `Purchase Details - Unit Price`,
    `PurchaseDetails_COGSAccountCode` AS `Purchase Details - COGS Account Code`,
    `PurchaseDetails_AccountCode` AS `Purchase Details - Account Code`,
    `PurchaseDetails_TaxType` AS `Purchase Details - Tax Type`,
    `SalesDetails_UnitPrice` AS `Sales Details - Unit Price`,
    `SalesDetails_COGSAccountCode` AS `Sales Details - COGS Account Code`,
    `SalesDetails_AccountCode` AS `Sales Details - Account Code`,
    `SalesDetails_TaxType` AS `Sales Details - Tax Type`,
    `IsTrackedAsInventory` AS `Is Tracked As Inventory`,
    `TotalCostPool` AS `Total Cost Pool`,
    `QuantityOnHand` AS `Quantity On Hand`,
    `IsSold` AS `Is Sold`,
    `IsPurchased` AS `Is Purchased`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `CodeUID` AS `Code UID`,
    `InventoryCodeUID` AS `Inventory Code UID`
FROM evadb_stage.c1518_xeroblue_items;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journals;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journals AS
SELECT
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`
FROM evadb_stage.c1518_xeroblue_journals;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscash AS
SELECT
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`
FROM evadb_stage.c1518_xeroblue_journalscash;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_payroll;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_payroll AS
SELECT 
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`
FROM evadb_stage.c1518_xeroblue_journals WHERE `SourceType` IN ('INTEGRATEDPAYROLLPE');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_linkedtransactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_linkedtransactions AS
SELECT 
    `LinkedTransactionID` AS `Linked Transaction ID`,
    `SourceTransactionID` AS `Source Transaction ID`,
    `SourceLineItemID` AS `Source Line Item ID`,
    `SourceTransactionTypeCode` AS `Source Transaction Type Code`,
    `ContactID` AS `Contact ID`,
    `TargetTransactionID` AS `Target Transaction ID`,
    `TargetLineItemID` AS `Target Line Item ID`,
    `Status` AS `Status`,
    `Type` AS `Type`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_linkedtransactions;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_manualjournals;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_manualjournals AS
SELECT
    `Id` AS `ID`,
    `ManualJournalId` AS `Manual Journal ID`,
    `Narration` AS `Narration`,
    `JournalLine_LineAmount` AS `Line Amount`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `JournalLine_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `JournalLine_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `JournalLine_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `JournalLine_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `JournalLine_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `JournalLine_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `JournalLine_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `JournalLine_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `JournalLine_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `JournalLineAggregate` AS `Journal Line Aggregate`,
    `Date` AS `Date`,
    `Status` AS `Status`,
    `URL` AS `URL`,
    `ShowOnCashBasisReports` AS `Show On Cash Basis Reports`,
    `LineAmountTypes` AS `Line Amount Types`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    IFNULL(`JournalLine_AccountCode`, 'BLANK') + '-' + CAST(`OrganisationID` AS CHAR) AS `Account UID`,
    CAST(
        CASE 
        WHEN (`LineAmountTypes` = 'Inclusive' OR `LineAmountTypes` = 'NoTax') THEN 0-(`JournalLine_LineAmount`)
        WHEN `LineAmountTypes` = 'Exclusive' AND (`JournalLine_TaxType` = 'INPUT' OR `JournalLine_TaxType` = 'OUTPUT' OR `JournalLine_TaxType` = 'CAPEXINPUT') THEN 0-(`JournalLine_LineAmount`+(`JournalLine_LineAmount`*0.1))
        WHEN `LineAmountTypes` = 'Exclusive' THEN 0-(`JournalLine_LineAmount`)
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Manual Journal Cash Calculation`
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY `Id`, `OrganisationID` ORDER BY `Id`) rn 
    FROM evadb_stage.c1518_xeroblue_manualjournals
    WHERE `Status` IN ('POSTED')
) t WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_organisations;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_organisations AS
SELECT 
    `ShortCode` AS `Short Code`,
    `APIKey` AS `API Key`,
    `Name` AS `Name`,
    `LegalName` AS `Legal Name`,
    `PaysTax` AS `Pays Tax`,
    `Version` AS `Version`,
    `BaseCurrency` AS `Base Currency`,
    `CountryCode` AS `Country Code`,
    `IsDemoCompany` AS `Is Demo Company`,
    `OrganisationStatus` AS `Organisation Status`,
    `RegistrationNumber` AS `Registration Number`,
    `TaxNumber` AS `Tax Number`,
    `FinancialYearEndDay` AS `Financial Year End Day`,
    `FinancialYearEndMonth` AS `Financial Year End Month`,
    `PeriodLockDate` AS `Period Lock Date`,
    `EndOfYearLockDate` AS `End Of Year Lock Date`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `OrganisationEntityType` AS `Organisation Entity Type`,
    `Timezone` AS `Timezone`,
    `Edition` AS `Edition`,
    `Class` AS `Class`,
    `LineOfBusiness` AS `Line Of Business`,
    `Street_AddressLine1` AS `Street Address Line 1`,
    `Street_AddressLine2` AS `Street Address Line 2`,
    `Street_AddressLine3` AS `Street Address Line 3`,
    `Street_AddressLine4` AS `Street Address Line 4`,
    `Street_City` AS `Street City`,
    `Street_PostalCode` AS `Street Postal Code`,
    `Street_Country` AS `Street Country`,
    `Street_Region` AS `Street Region`,
    `Street_AttentionTo` AS `Street Attention To`,
    `POBox_AddressLine1` AS `PO Box Address Line 1`,
    `POBox_AddressLine2` AS `PO Box Address Line 2`,
    `POBox_AddressLine3` AS `PO Box Address Line 3`,
    `POBox_AddressLine4` AS `PO Box Address Line 4`,
    `POBox_City` AS `PO Box City`,
    `POBox_PostalCode` AS `PO Box Postal Code`,
    `POBox_Country` AS `PO Box Country`,
    `POBox_Region` AS `PO Box Region`,
    `POBox_AttentionTo` AS `PO Box Attention To`,
    `DDI_PhoneNumber` AS `DDI Phone Number`,
    `DDI_PhoneAreaCode` AS `DDI Phone Area Code`,
    `DDI_PhoneCountryCode` AS `DDI Phone Country Code`,
    `Default_PhoneNumber` AS `Default Phone Number`,
    `Default_PhoneAreaCode` AS `Default Phone Area Code`,
    `Default_PhoneCountryCode` AS `Default Phone Country Code`,
    `Fax_PhoneNumber` AS `Fax Phone Number`,
    `Fax_PhoneAreaCode` AS `Fax Phone Area Code`,
    `Fax_PhoneCountryCode` AS `Fax Phone Country Code`,
    `Mobile_PhoneNumber` AS `Mobile Phone Number`,
    `Mobile_PhoneAreaCode` AS `Mobile Phone Area Code`,
    `Mobile_PhoneCountryCode` AS `Mobile Phone Country Code`,
    `Facebook_URL` AS `Facebook URL`,
    `Twitter_URL` AS `Twitter URL`,
    `GooglePlus_URL` AS `GooglePlus URL`,
    `LinkedIn_URL` AS `LinkedIn URL`,
    `Website_URL` AS `Website URL`,
    `PaymentTerms_Bills_Day` AS `Payment Terms Bills Day`,
    `PaymentTerms_Bills_Type` AS `Payment Terms Bills Type`,
    `PaymentTerms_Sales_Day` AS `Payment Terms Sales Day`,
    `PaymentTerms_Sales_Type` AS `Payment Terms Sales Type`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_organisationsclients;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpayments;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpayments AS
SELECT 
    `OverpaymentId` AS `Overpayment ID`,
    `Date` AS `Date`,
    `Type` AS `Type`,
    `RemainingCredit` AS `Remaining Credit`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineAmountTypes` AS `Line Amount Types`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `Allocation1_AppliedAmount` AS `Allocation 1 Applied Amount`,
    `Allocation1_Date` AS `Allocation 1 Date`,
    `Allocation1_InvoiceId` AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber` AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount` AS `Allocation 2 Applied Amount`,
    `Allocation2_Date` AS `Allocation 2 Date`,
    `Allocation2_InvoiceId` AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber` AS `Allocation 2 Invoice Number`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Allocation3_AppliedAmount` AS `Allocation 3 Applied Amount`,
    `Allocation3_Date` AS `Allocation 3 Date`,
    `Allocation3_InvoiceId` AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber` AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount` AS `Allocation 4 Applied Amount`,
    `Allocation4_Date` AS `Allocation 4 Date`,
    `Allocation4_InvoiceId` AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber` AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount` AS `Allocation 5 Applied Amount`,
    `Allocation5_Date` AS `Allocation 5 Date`,
    `Allocation5_InvoiceId` AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber` AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount` AS `Allocation 6 Applied Amount`,
    `Allocation6_Date` AS `Allocation 6 Date`,
    `Allocation6_InvoiceId` AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber` AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount` AS `Allocation 7 Applied Amount`,
    `Allocation7_Date` AS `Allocation 7 Date`,
    `Allocation7_InvoiceId` AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber` AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount` AS `Allocation 8 Applied Amount`,
    `Allocation8_Date` AS `Allocation 8 Date`,
    `Allocation8_InvoiceId` AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber` AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount` AS `Allocation 9 Applied Amount`,
    `Allocation9_Date` AS `Allocation 9 Date`,
    `Allocation9_InvoiceId` AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber` AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount` AS `Allocation 10 Applied Amount`,
    `Allocation10_Date` AS `Allocation 10 Date`,
    `Allocation10_InvoiceId` AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber` AS `Allocation 10 Invoice Number`,
    `Payments` AS `Payments`,
    CONCAT(`LineItem_AccountCode`, '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation1_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation1_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 1 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation2_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation2_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 2 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation3_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation3_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 3 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation4_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation4_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 4 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation5_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation5_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 5 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation6_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation6_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 6 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation7_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation7_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 7 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation8_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation8_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 8 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation9_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation9_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 9 Calculated Amount`,
    CAST(
        CASE 
        WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN (0-(`SubTotal`)*(`Allocation10_AppliedAmount`/`Total`))
        WHEN `Type` = 'SPEND-OVERPAYMENT' THEN ((`SubTotal`)*(`Allocation10_AppliedAmount`/`Total`))
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Overpayment Allocation 10 Calculated Amount`
FROM evadb_stage.c1518_xeroblue_overpayments 
WHERE `Status` in ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_payments;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_payments AS
SELECT 
    `PaymentId` AS `Payment ID`,
    `Date` AS `Date`,
    `Amount` AS `Amount`,
    `CurrencyRate` AS `Currency Rate`,
    `Reference` AS `Reference`,
    `PaymentType` AS `Payment Type`,
    `Status` AS `Status`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `IsReconciled` AS `Is Reconciled`,
    `BatchPaymentId` AS `Batch Payment ID`,
    `InvoiceId` AS `Invoice ID`,
    `InvoiceNumber` AS `Invoice Number`,
    `CreditNoteId` AS `Credit Note ID`,
    `CreditNoteNumber` AS `Credit Note Number`,
    `AccountId` AS `Account ID`,
    `AccountCode` AS `Account Code`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY `PaymentId`, `OrganisationID` ORDER BY `PaymentId`) rn 
    FROM evadb_stage.c1518_xeroblue_payments
    WHERE `Status` IN ('AUTHORISED')
) t
WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepayments;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepayments AS
SELECT 
    `PrepaymentId` AS `Prepayment ID`,
    `Date` AS `Date`,
    `Reference` AS `Reference`,
    `Type` AS `Type`,
    `RemainingCredit` AS `Remaining Credit`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `LineItems` AS `Line Items`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineAmountTypes` AS `Line Amount Types`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `Allocation1_AppliedAmount` AS `Allocation 1 Applied Amount`,
    `Allocation1_Date` AS `Allocation 1 Date`,
    `Allocation1_InvoiceId` AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber` AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount` AS `Allocation 2 Applied Amount`,
    `Allocation2_Date` AS `Allocation 2 Date`,
    `Allocation2_InvoiceId` AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber` AS `Allocation 2 Invoice Number`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Allocation3_AppliedAmount` AS `Allocation 3 Applied Amount`,
    `Allocation3_Date` AS `Allocation 3 Date`,
    `Allocation3_InvoiceId` AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber` AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount` AS `Allocation 4 Applied Amount`,
    `Allocation4_Date` AS `Allocation 4 Date`,
    `Allocation4_InvoiceId` AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber` AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount` AS `Allocation 5 Applied Amount`,
    `Allocation5_Date` AS `Allocation 5 Date`,
    `Allocation5_InvoiceId` AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber` AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount` AS `Allocation 6 Applied Amount`,
    `Allocation6_Date` AS `Allocation 6 Date`,
    `Allocation6_InvoiceId` AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber` AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount` AS `Allocation 7 Applied Amount`,
    `Allocation7_Date` AS `Allocation 7 Date`,
    `Allocation7_InvoiceId` AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber` AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount` AS `Allocation 8 Applied Amount`,
    `Allocation8_Date` AS `Allocation 8 Date`,
    `Allocation8_InvoiceId` AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber` AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount` AS `Allocation 9 Applied Amount`,
    `Allocation9_Date` AS `Allocation 9 Date`,
    `Allocation9_InvoiceId` AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber` AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount` AS `Allocation 10 Applied Amount`,
    `Allocation10_Date` AS `Allocation 10 Date`,
    `Allocation10_InvoiceId` AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber` AS `Allocation 10 Invoice Number`,
    `Payments` AS `Payments`,
    CONCAT(`LineItem_AccountCode`, '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`
FROM evadb_stage.c1518_xeroblue_prepayments
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_purchaseorders;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_purchaseorders AS
SELECT 
    `Id` AS `ID`,
    `PurchaseOrderId` AS `Purchase Order ID`,
    `PurchaseOrderNumber` AS `Purchase Order Number`,
    `Reference` AS `Reference`,
    `Type` AS `Type`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `DeliveryDate` AS `Delivery Date`,
    `Date` AS `Date`,
    `Status` AS `Status`,
    `LineAmountTypes` AS `Line Amount Types`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineItemAggregate` AS `Aggregate`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `CurrencyCode` AS `Currency Code`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `CurrencyRate` AS `Currency Rate`,
    `TotalDiscount` AS `Total Discount`,
    `SentToContact` AS `Sent To Contact`,
    `Telephone` AS `Telephone`,
    `IsDiscounted` AS `Is Discounted`,
    `ExpectedArrivalDate` AS `Expected Arrival Date`,
    `DeliveryInstructions` AS `Delivery Instructions`,
    `DeliveryAddress` AS `Delivery Address`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_purchaseorders;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_receipts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_receipts AS
SELECT 
    `Id` AS `ID`,
    `ReceiptId` AS `Receipt ID`,
    `Date` AS `Date`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `LineItem_Description` AS `Description`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineItemAggregate` AS `Aggregate`,
    `User _UserId` AS `User  ID`,
    `Reference` AS `Reference`,
    `LineAmountTypes` AS `Line Amount Types`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `Status` AS `Status`,
    `ReceiptNumber` AS `Receipt Number`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `URL` AS `URL`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_receipts;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_repeatinginvoices;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_repeatinginvoices AS
SELECT 
    `Id` AS `ID`,
    `RepeatingInvoiceId` AS `Repeating Invoice ID`,
    `Type` AS `Type`,
    `ContactId` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `Schedule_Period` AS `Schedule Period`,
    `Schedule_Unit` AS `Schedule Unit`,
    `Schedule_DueDate` AS `Schedule Due Date`,
    `Schedule_DueDateType` AS `Schedule Due Date Type`,
    `Schedule_StartDate` AS `Schedule Start Date`,
    `Schedule_NextScheduledDate` AS `Schedule Next Scheduled Date`,
    `Schedule_EndDate` AS `Schedule End Date`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineAmountTypes` AS `Line Amount Types`,
    `Reference` AS `Reference`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `CurrencyCode` AS `Currency Code`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `HasAttachments` AS `Has Attachments`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_repeatinginvoices;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_taxrates;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_taxrates AS
SELECT 
    `Id` AS `ID`,
    `TaxType` AS `Tax Type`,
    `Name` AS `Name`,
    `TaxComponent_Name` AS `Tax Component Name`,
    `TaxComponent_Rate` AS `Tax Component Rate`,
    `TaxComponents_IsNonRecoverable` AS `Tax Components Is Non Recoverable`,
    `TaxComponent_IsCompound` AS `Tax Component Is Compound`,
    `TaxComponentAggregate` AS `Tax Component Aggregate`,
    `Status` AS `Status`,
    `ReportTaxType` AS `Report Tax Type`,
    `CanApplyToAssets` AS `Can Apply To Assets`,
    `CanApplyToEquity` AS `Can Apply To Equity`,
    `CanApplyToExpenses` AS `Can Apply To Expenses`,
    `CanApplyToLiabilities` AS `Can Apply To Liabilities`,
    `CanApplyToRevenue` AS `Can Apply To Revenue`,
    `DisplayTaxRate` AS `Display Tax Rate`,
    `EffectiveRate` AS `Effective Rate`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_taxrates;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_trackingcategories;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_trackingcategories AS
SELECT 
    `Id` AS `ID`,
    `TrackingCategoryId` AS `Tracking Category ID`,
    `Name` AS `Name`,
    `Status` AS `Status`,
    `TrackingOptionId` AS `Tracking Option ID`,
    `OptionName` AS `Option Name`,
    `OptionStatus` AS `Option Status`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM (
    SELECT *, 
    ROW_NUMBER() OVER(PARTITION BY `TrackingCategoryId`, `OptionName`, `OrganisationID` ORDER BY `Id`) rn 
    FROM evadb_stage.c1518_xeroblue_trackingcategories
    WHERE `Status` IN ('ACTIVE')
) t
WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_users;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_users AS
SELECT 
    `UserId` AS `User  ID`,
    `FirstName` AS `First Name`,
    `LastName` AS `Last Name`,
    `EmailAddress` AS `Email Address`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `IsSubscriber` AS `Is Subscriber`,
    `OrganisationRole` AS `Organisation Role`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_users;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquecreditnotes;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquecreditnotes AS
SELECT 
    `CreditNoteId`, 
    `Allocation1_AppliedAmount`,
    `Allocation1_Date`,
    `Allocation1_InvoiceId`,
    `Allocation2_AppliedAmount`,
    `Allocation2_Date`,
    `Allocation2_InvoiceId`,
    `ClientId`, 
    `OrganisationId`,
    `Allocation3_AppliedAmount`,
    `Allocation3_Date`,
    `Allocation3_InvoiceId`,
    `Allocation4_AppliedAmount`,
    `Allocation4_Date`,
    `Allocation4_InvoiceId`,
    `Allocation5_AppliedAmount`,
    `Allocation5_Date`,
    `Allocation5_InvoiceId`,
    `Allocation6_AppliedAmount`,
    `Allocation6_Date`,
    `Allocation6_InvoiceId`,
    `Allocation7_AppliedAmount`,
    `Allocation7_Date`,
    `Allocation7_InvoiceId`,
    `Allocation8_AppliedAmount`,
    `Allocation8_Date`,
    `Allocation8_InvoiceId`,
    `Allocation9_AppliedAmount`,
    `Allocation9_Date`,
    `Allocation9_InvoiceId`,
    `Allocation10_AppliedAmount`,
    `Allocation10_Date`,
    `Allocation10_InvoiceId`,
    `Allocation11_AppliedAmount`,
    `Allocation11_Date`,
    `Allocation11_InvoiceId`,
    `Allocation12_AppliedAmount`,
    `Allocation12_Date`,
    `Allocation12_InvoiceId`,
    `Allocation13_AppliedAmount`,
    `Allocation13_Date`,
    `Allocation13_InvoiceId`,
    `Allocation14_AppliedAmount`,
    `Allocation14_Date`,
    `Allocation14_InvoiceId`,
    `Allocation15_AppliedAmount`,
    `Allocation15_Date`,
    `Allocation15_InvoiceId`
FROM (
    SELECT *, Row_number() OVER(PARTITION BY `CreditNoteId`, `OrganisationID` ORDER BY Id) rn 
    FROM evadb_stage.c1518_xeroblue_creditnotes
) t WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal AS
SELECT * FROM evadb_stage.c1518_xeroblue_overpayments WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal AS
SELECT * FROM evadb_stage.c1518_xeroblue_prepayments WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicesoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicesoriginal AS
SELECT 
    `Id`                                        AS `Id`, 
    `InvoiceId`                                 AS `InvoiceId`,
    `Type`                                      AS `Type`,
    `ContactId`                                 AS `ContactId`,
    `ContactName`                               AS `ContactName`,
    `LineItem_LineItemId`                       AS `LineItem_LineItemId`,
    `LineItem_Description`                      AS `LineItem_Description`,
    `LineItem_Quantity`                         AS `LineItem_Quantity`,
    `LineItem_UnitAmount`                       AS `LineItem_UnitAmount`,
    `LineItem_ItemCode`                         AS `LineItem_ItemCode`,
    `LineItem_AccountCode`                      AS `LineItem_AccountCode`,
    `LineItem_TaxType`                          AS `LineItem_TaxType`,
    `LineItem_TaxAmount`                        AS `LineItem_TaxAmount`,
    `LineItem_LineAmount`                       AS `LineItem_LineAmount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `LineItem_TrackingCategory1_CategoryId`,
    `LineItem_TrackingCategory1_CategoryName`   AS `LineItem_TrackingCategory1_CategoryName`,
    `LineItem_TrackingCategory1_OptionId`       AS `LineItem_TrackingCategory1_OptionId`,
    `LineItem_TrackingCategory1_OptionName`     AS `LineItem_TrackingCategory1_OptionName`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `LineItem_TrackingCategory1_Option_Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `LineItem_TrackingCategory2_CategoryId`,
    `LineItem_TrackingCategory2_CategoryName`   AS `LineItem_TrackingCategory2_CategoryName`,
    `LineItem_TrackingCategory2_OptionId`       AS `LineItem_TrackingCategory2_OptionId`,
    `LineItem_TrackingCategory2_OptionName`     AS `LineItem_TrackingCategory2_OptionName`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `LineItem_TrackingCategory2_Option_Stat`,
    `LineItem_DiscountRate`                     AS `LineItem_DiscountRate`,
    `LineItem_DiscountAmount`                   AS `LineItem_DiscountAmount`,
    `LineItemAggregate`                         AS `LineItemAggregate`,
    `Date`                                      AS `Date`,
    `DueDate`                                   AS `DueDate`,
    `LineAmountTypes`                           AS `LineAmountTypes`,
    `InvoiceNumber`                             AS `InvoiceNumber`,
    `Reference`                                 AS `Reference`,
    `BrandingThemeId`                           AS `BrandingThemeId`,
    `URL`                                       AS `URL`,
    `CurrencyCode`                              AS `CurrencyCode`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `Status`                                    AS `Status`,
    `SentToContact`                             AS `SentToContact`,
    `ExpectedPaymentDate`                       AS `ExpectedPaymentDate`,
    `PlannedPaymentDate`                        AS `PlannedPaymentDate`,
    `SubTotal`                                  AS `SubTotal`,
    `TotalTax`                                  AS `TotalTax`,
    `Total`                                     AS `Total`,
    `TotalDiscount`                             AS `TotalDiscount`,
    `HasAttachments`                            AS `HasAttachments`,
    `PaymentIds`                                AS `PaymentIds`,
    `PrePaymentIds`                             AS `PrePaymentIds`,
    `OverPaymentIds`                            AS `OverPaymentIds`,
    `CreditNoteIds`                             AS `CreditNoteIds`,
    `AmountDue`                                 AS `AmountDue`,
    `AmountPaid`                                AS `AmountPaid`,
    `CISDeduction`                              AS `CISDeduction`,
    `FullyPaidOnDate`                         AS `FullyPaidOnDate`,
    `AmountCredited`                          AS `AmountCredited`,
    `UpdatedDateUTC`                          AS `UpdatedDateUTC`,
    `CreditNotes`                             AS `CreditNotes`,
    `Prepayments`                             AS `Prepayments`,
    `Payments`                                AS `Payments`,
    `Overpayments`                            AS `Overpayments`,
    `RepeatingInvoiceID`                      AS `RepeatingInvoiceID`,
    `ClientID`                                AS `ClientID`,
    `OrganisationID`                          AS `OrganisationID`
FROM evadb_stage.c1518_xeroblue_invoices WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_paymentsoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_paymentsoriginal AS
SELECT * FROM evadb_stage.c1518_xeroblue_payments WHERE `Status` IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnotesoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnotesoriginal AS
SELECT 
    `Id`                                        AS `Id`, 
    `CreditNoteId`                              AS `CreditNoteId`,
    `CreditNoteNumber`                          AS `CreditNoteNumber`,
    `Reference`                                 AS `Reference`,
    `Type`                                      AS `Type`,
    `Contact_ContactId`                         AS `Contact_ContactId`,
    `Contact_Name`                              AS `Contact_Name`,
    `Date`                                      AS `Date`,
    `Status`                                    AS `Status`,
    `LineAmountTypes`                           AS `LineAmountTypes`,
    `LineItem_Quantity`                         AS `LineItem_Quantity`,
    `LineItem_Description`                      AS `LineItem_Description`,
    `LineItem_UnitAmount`                       AS `LineItem_UnitAmount`,
    `LineItem_ItemCode`                         AS `LineItem_ItemCode`,
    `LineItem_AccountCode`                      AS `LineItem_AccountCode`,
    `LineItem_TaxType`                          AS `LineItem_TaxType`,
    `LineItem_TaxAmount`                        AS `LineItem_TaxAmount`,
    `LineItem_LineAmount`                       AS `LineItem_LineAmount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `LineItem_TrackingCategory1_CategoryId`,
    `LineItem_TrackingCategory1_CategoryName`   AS `LineItem_TrackingCategory1_CategoryName`,
    `LineItem_TrackingCategory1_OptionId`       AS `LineItem_TrackingCategory1_OptionId`,
    `LineItem_TrackingCategory1_OptionName`     AS `LineItem_TrackingCategory1_OptionName`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `LineItem_TrackingCategory1_Option_Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `LineItem_TrackingCategory2_CategoryId`,
    `LineItem_TrackingCategory2_CategoryName`   AS `LineItem_TrackingCategory2_CategoryName`,
    `LineItem_TrackingCategory2_OptionId`       AS `LineItem_TrackingCategory2_OptionId`,
    `LineItem_TrackingCategory2_OptionName`     AS `LineItem_TrackingCategory2_OptionName`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `LineItem_TrackingCategory2_Option_Stat`,
    `LineItem_DiscountRate`                     AS `LineItem_DiscountRate`,
    `LineItemAggregate`                         AS `LineItemAggregate`,
    `SubTotal`                                  AS `SubTotal`,
    `TotalTax`                                  AS `TotalTax`,
    `Total`                                     AS `Total`,
    `UpdatedDateUTC`                            AS `UpdatedDateUTC`,
    `CurrencyCode`                              AS `CurrencyCode`,
    `FullyPaidOnDate`                           AS `FullyPaidOnDate`,
    `SentToContact`                             AS `SentToContact`,
    `BrandingThemeId`                           AS `BrandingThemeId`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `RemainingCredit`                           AS `RemainingCredit`,
    `Allocation1_AppliedAmount`                 AS `Allocation1_AppliedAmount`,
    `Allocation1_Date`                          AS `Allocation1_Date`,
    `Allocation1_InvoiceId`                     AS `Allocation1_InvoiceId`,
    `Allocation1_InvoiceNumber`                 AS `Allocation1_InvoiceNumber`,
    `Allocation2_AppliedAmount`                 AS `Allocation2_AppliedAmount`,
    `Allocation2_Date`                          AS `Allocation2_Date`,
    `Allocation2_InvoiceId`                     AS `Allocation2_InvoiceId`,
    `Allocation2_InvoiceNumber`                 AS `Allocation2_InvoiceNumber`,
    `Allocation3_AppliedAmount`                 AS `Allocation3_AppliedAmount`,
    `Allocation3_Date`                         AS `Allocation3_Date`,
    `Allocation3_InvoiceId`                    AS `Allocation3_InvoiceId`,
    `Allocation3_InvoiceNumber`                AS `Allocation3_InvoiceNumber`,
    `Allocation4_AppliedAmount`                AS `Allocation4_AppliedAmount`,
    `Allocation4_Date`                         AS `Allocation4_Date`,
    `Allocation4_InvoiceId`                    AS `Allocation4_InvoiceId`,
    `Allocation4_InvoiceNumber`                AS `Allocation4_InvoiceNumber`,
    `Allocation5_AppliedAmount`                AS `Allocation5_AppliedAmount`,
    `Allocation5_Date`                         AS `Allocation5_Date`,
    `Allocation5_InvoiceId`                    AS `Allocation5_InvoiceId`,
    `Allocation5_InvoiceNumber`                AS `Allocation5_InvoiceNumber`,
    `Allocation6_AppliedAmount`                AS `Allocation6_AppliedAmount`,
    `Allocation6_Date`                         AS `Allocation6_Date`,
    `Allocation6_InvoiceId`                    AS `Allocation6_InvoiceId`,
    `Allocation6_InvoiceNumber`                AS `Allocation6_InvoiceNumber`,
    `Allocation7_AppliedAmount`                AS `Allocation7_AppliedAmount`,
    `Allocation7_Date`                         AS `Allocation7_Date`,
    `Allocation7_InvoiceId`                    AS `Allocation7_InvoiceId`,
    `Allocation7_InvoiceNumber`                AS `Allocation7_InvoiceNumber`,
    `Allocation8_AppliedAmount`                AS `Allocation8_AppliedAmount`,
    `Allocation8_Date`                         AS `Allocation8_Date`,
    `Allocation8_InvoiceId`                    AS `Allocation8_InvoiceId`,
    `Allocation8_InvoiceNumber`                AS `Allocation8_InvoiceNumber`,
    `Allocation9_AppliedAmount`                AS `Allocation9_AppliedAmount`,
    `Allocation9_Date`                         AS `Allocation9_Date`,
    `Allocation9_InvoiceId`                    AS `Allocation9_InvoiceId`,
    `Allocation9_InvoiceNumber`                AS `Allocation9_InvoiceNumber`,
    `Allocation10_AppliedAmount`               AS `Allocation10_AppliedAmount`,
    `Allocation10_Date`                        AS `Allocation10_Date`,
    `Allocation10_InvoiceId`                   AS `Allocation10_InvoiceId`,
    `Allocation10_InvoiceNumber`               AS `Allocation10_InvoiceNumber`,
    `Allocation11_AppliedAmount`               AS `Allocation11_AppliedAmount`,
    `Allocation11_Date`                        AS `Allocation11_Date`,
    `Allocation11_InvoiceId`                   AS `Allocation11_InvoiceId`,
    `Allocation11_InvoiceNumber`               AS `Allocation11_InvoiceNumber`,
    `Allocation12_AppliedAmount`               AS `Allocation12_AppliedAmount`,
    `Allocation12_Date`                        AS `Allocation12_Date`,
    `Allocation12_InvoiceId`                   AS `Allocation12_InvoiceId`,
    `Allocation12_InvoiceNumber`               AS `Allocation12_InvoiceNumber`,
    `Allocation13_AppliedAmount`               AS `Allocation13_AppliedAmount`,
    `Allocation13_Date`                        AS `Allocation13_Date`,
    `Allocation13_InvoiceId`                   AS `Allocation13_InvoiceId`,
    `Allocation13_InvoiceNumber`               AS `Allocation13_InvoiceNumber`,
    `Allocation14_AppliedAmount`               AS `Allocation14_AppliedAmount`,
    `Allocation14_Date`                        AS `Allocation14_Date`,
    `Allocation14_InvoiceId`                   AS `Allocation14_InvoiceId`,
    `Allocation14_InvoiceNumber`               AS `Allocation14_InvoiceNumber`,
    `Allocation15_AppliedAmount`               AS `Allocation15_AppliedAmount`,
    `Allocation15_Date`                        AS `Allocation15_Date`,
    `Allocation15_InvoiceId`                   AS `Allocation15_InvoiceId`,
    `Allocation15_InvoiceNumber`               AS `Allocation15_InvoiceNumber`,
    `HasAttachments`                           AS `HasAttachments`,
    `ClientID`                                 AS `ClientID`,
    `OrganisationID`                           AS `OrganisationID`
FROM evadb_stage.c1518_xeroblue_creditnotes WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invovrpymtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invovrpymtallo AS
SELECT
    i.*,
    a.invoiceid                 AS `OverPaymentInvoiceId`,
    a.OverPaymentId,
    a.allocation                AS `OverPaymentAllocation`,
    a.dt                        AS `OverPaymentDate`,
    a.amount                    AS `OverPaymentAmount`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation1_InvoiceId` AS `invoiceid`, 
        1 AS `allocation`,
        `Allocation1_Date` AS `dt`,
        `Allocation1_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation1_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation2_InvoiceId` AS `invoiceid`, 
        2 AS `allocation`,
        `Allocation2_Date` AS `dt`,
        `Allocation2_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation2_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation3_InvoiceId` AS `invoiceid`, 
        3 AS `allocation`,
        `Allocation3_Date` AS `dt`,
        `Allocation3_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation3_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation4_InvoiceId` AS `invoiceid`, 
        4 AS `allocation`,
        `Allocation4_Date` AS `dt`,
        `Allocation4_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation4_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation5_InvoiceId` AS `invoiceid`, 
        5 AS `allocation`,
        `Allocation5_Date` AS `dt`,
        `Allocation5_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation5_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation6_InvoiceId` AS `invoiceid`, 
        6 AS `allocation`,
        `Allocation6_Date` AS `dt`,
        `Allocation6_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation6_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation7_InvoiceId` AS `invoiceid`, 
        7 AS `allocation`,
        `Allocation7_Date` AS `dt`,
        `Allocation7_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation7_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation8_InvoiceId` AS `invoiceid`, 
        8 AS `allocation`,
        `Allocation8_Date` AS `dt`,
        `Allocation8_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation8_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation9_InvoiceId` AS `invoiceid`, 
        9 AS `allocation`,
        `Allocation9_Date` AS `dt`,
        `Allocation9_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation9_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation10_InvoiceId` AS `invoiceid`, 
        10 AS `allocation`,
        `Allocation10_Date` AS `dt`,
        `Allocation10_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation10_AppliedAmount` IS NOT NULL
) a ON i.`invoiceid` = a.`invoiceid` AND i.`organisationid` = a.`OrganisationID`
WHERE i.`status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invprepymtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invprepymtallo AS
SELECT 
    i.*,
    a.invoiceid                         AS `PrePaymentInvoiceId`,
    a.prepaymentid                      AS `PrePaymentId`,
    a.allocation                        AS `PrePaymentAllocation`,
    a.dt                                AS `PrePaymentDate`,
    a.amount                            AS `PrePaymentAmount`,
    CONCAT(CAST(i.organisationid AS CHAR), i.lineitem_accountcode)  AS `Account UID`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation1_InvoiceId` AS invoiceid, 
        1 AS allocation,
        `Allocation1_Date` AS dt,
        `Allocation1_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation1_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation2_InvoiceId` AS invoiceid, 
        2 AS allocation,
        `Allocation2_Date` AS dt,
        `Allocation2_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation2_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation3_InvoiceId` AS invoiceid, 
        3 AS allocation,
        `Allocation3_Date` AS dt,
        `Allocation3_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation3_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation4_InvoiceId` AS invoiceid, 
        4 AS allocation,
        `Allocation4_Date` AS dt,
        `Allocation4_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation4_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation5_InvoiceId` AS invoiceid, 
        5 AS allocation,
        `Allocation5_Date` AS dt,
        `Allocation5_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation5_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation6_InvoiceId` AS invoiceid, 
        6 AS allocation,
        `Allocation6_Date` AS dt,
        `Allocation6_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation6_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation7_InvoiceId` AS invoiceid, 
        7 AS allocation,
        `Allocation7_Date` AS dt,
        `Allocation7_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation7_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation8_InvoiceId` AS invoiceid, 
        8 AS allocation,
        `Allocation8_Date` AS dt,
        `Allocation8_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation8_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation9_InvoiceId` AS invoiceid, 
        9 AS allocation,
        `Allocation9_Date` AS dt,
        `Allocation9_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation9_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation10_InvoiceId` AS invoiceid, 
        10 AS allocation,
        `Allocation10_Date` AS dt,
        `Allocation10_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation10_AppliedAmount` IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.`organisationid`
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invcrdtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invcrdtallo AS
SELECT
    i.*,
    a.invoiceid AS CreditNoteInvoiceId,
    a.CreditNoteId,
    a.allocation AS CreditNoteAllocation,
    a.dt AS CreditNoteDate,
    a.amount AS CreditNoteAmount
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        organisationid, 
        creditnoteid,
        allocation1_invoiceid AS invoiceid, 
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation6_invoiceid AS invoiceid, 
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation10_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation15_appliedamount IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.organisationid
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceallocations;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceallocations AS
SELECT
    i.*,
    ca.CreditNoteInvoiceId, 
    ca.CreditNoteAllocation, 
    ca.CreditNoteAmount, 
    ca.CreditNoteDate,
    IFNULL(ca.`lineitem_discountrate`, 0) AS `Discount Rate`, 
    IFNULL(ca.`lineitem_discountrate` * 0.01, 0) AS `Discount Rate %`,
    ppa.PrepaymentId, 
    ppa.PrePaymentAllocation,
    ppa.PrePaymentDate, 
    ppa.PrePaymentAmount,
    opa.OverpaymentId, 
    opa.OverPaymentAllocation,
    opa.OverPaymentDate, 
    opa.OverPaymentAmount,
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `OP Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `PP Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `CN Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `OP Allocation Amount Inc Tax`,  
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `PP Allocation Amount Inc Tax`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `CN Allocation Amount Inc Tax`
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal i
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invcrdtallo AS ca
    ON i.invoiceid = ca.invoiceid AND i.lineitem_lineitemid = ca.lineitem_lineitemid
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invprepymtallo ppa
    ON i.invoiceid = ppa.invoiceid AND i.lineitem_lineitemid = ppa.lineitem_lineitemid
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invovrpymtallo opa
    ON i.invoiceid = opa.invoiceid AND i.lineitem_lineitemid = opa.lineitem_lineitemid
WHERE ca.invoiceid IS NOT NULL OR ppa.invoiceid IS NOT NULL OR opa.invoiceid IS NOT NULL AND i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicepaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicepaymentcash AS
SELECT 
    i.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.paymenttype                               AS `PaymentType`,
    p.accountid                                 AS `PaymentAccountID`,
    p.status                                    AS `PaymentStatus`,
    CONCAT(IFNULL(i.`lineitem_accountcode`, 'BLANK'), '-', CAST(i.`organisationid` AS CHAR)) AS `Account_UID`,
    IFNULL(i.`lineitem_discountrate`, 0)        AS `Discount Rate`,
    IFNULL(i.`lineitem_discountrate` * 0.01, 0) AS `Discount Rate %`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax`	
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal i
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON i.invoiceid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') 
AND i.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash AS
SELECT 
    pp.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `paymentamount`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(IFNULL(pp.`LineItem_AccountCode`, 'BLANK'), '-', CAST(pp.`OrganisationID` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN pp.`LineAmountTypes` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal pp
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON pp.prepaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') 
AND pp.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash AS
SELECT 
    op.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(op.`LineItem_AccountCode`, '-', CAST(op.`organisationid` AS CHAR)) AS `Account_UID`,
    CAST(
        CASE 
            WHEN op.`LineAmountTypes` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal op
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON op.overpaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APOVERPAYMENTPAYMENT', 'AROVERPAYMENTPAYMENT') 
AND op.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash AS
SELECT 
    c.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(c.`lineitem_accountcode`, '-', CAST(c.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`
FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal c
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON c.creditnoteid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APCREDITPAYMENT', 'ARCREDITPAYMENT') 
AND c.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnoteallocations;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnoteallocations AS
SELECT 
    Id,
    CreditNoteId ,
    CreditNoteNumber ,
    Reference ,
    Type ,
    Contact_ContactId ,
    Contact_Name ,
    Date ,
    Status,
    LineAmountTypes ,
    LineItem_Description ,
    LineItem_Quantity ,
    LineItem_UnitAmount,
    LineItem_ItemCode ,
    LineItem_AccountCode ,
    LineItem_TaxType ,
    LineItem_TaxAmount ,
    LineItem_LineAmount ,
    LineItem_TrackingCategory1_CategoryId ,
    LineItem_TrackingCategory1_CategoryName,
    LineItem_TrackingCategory1_OptionId ,
    LineItem_TrackingCategory1_OptionName,
    LineItem_TrackingCategory1_Option_Stat,
    LineItem_TrackingCategory2_CategoryId ,
    LineItem_TrackingCategory2_CategoryName,
    LineItem_TrackingCategory2_OptionId ,
    LineItem_TrackingCategory2_OptionName,
    LineItem_TrackingCategory2_Option_Stat,
    LineItem_DiscountRate ,
    SubTotal ,
    TotalTax ,
    Total ,
    UpdatedDateUTC ,
    CurrencyCode ,
    FullyPaidOnDate ,
    SentToContact ,
    BrandingThemeId,
    CurrencyRate ,
    RemainingCredit,  HasAttachments,ClientID,OrganisationID,
    InvoiceId,
    Allocation,
    Dt,
    Amount,
    CONCAT(IFNULL(a.`lineitem_accountcode`, 'BLANK'), '-', CAST(a.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax FX`
FROM (
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation6_invoiceid AS invoiceid,
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation15_appliedamount IS NOT NULL
) AS a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentallocation;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentallocation AS
SELECT 
    *,
    CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`
FROM (
    SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation1_InvoiceId AS InvoiceId, 1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation2_InvoiceId AS InvoiceId,2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation3_InvoiceId AS InvoiceId,3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation4_InvoiceId AS InvoiceId,4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation5_InvoiceId AS InvoiceId,5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation6_InvoiceId AS InvoiceId,6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation7_InvoiceId AS InvoiceId,7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation8_InvoiceId AS InvoiceId,8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation9_InvoiceId AS InvoiceId,9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation10_InvoiceId AS InvoiceId,10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation10_AppliedAmount IS not null
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentallocation;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentallocation AS
SELECT 
    a.*,
    CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`
FROM (
    SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation6_InvoiceId AS InvoiceId,
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT 
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
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation10_AppliedAmount IS not NULL
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_batchpayments;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_batchpayments AS
SELECT
    `Id` AS `Id`,
    `BatchPaymentId` AS `Batch Payment Id`,
    `AccountId` AS `Account Id`,
    `Particulars` AS `Particulars`,
    `Code` AS `Code`,
    `Reference` AS `Reference`,
    `Details` AS `Details`,
    `Narrative` AS `Narrative`,
    `Date` AS `Date`,
    `Payment_PaymentId` AS `Payment Id`,
    `Payment_InvoiceId` AS `Payment Invoice Id`,
    `Payment_BankAccountNumber` AS `Payment Bank Account Number`,
    `Payment_Particulars` AS `Payment Particulars`,
    `Payment_Code` AS `Payment Code`,
    `Payment_Reference` AS `Payment Reference`,
    `Payment_Details` AS `Payment Details`,
    `Payment_Amount` AS `Payment Amount`,
    `PaymentAggregate` AS `Payment Aggregate`,
    `Type` AS `Type`,
    `Status` AS `Status`,
    `TotalAmount` AS `Total Amount`,
    `IsReconciled` AS `Is Reconciled`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_batchpayments;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_quotes;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_quotes AS
SELECT
    `Id` AS `Id`,
    `QuoteId` AS `Quote Id`,
    `ContactId` AS `Contact Id`,
    `ContactName` AS `Contact Name`,
    `Date` AS `Date`,
    `ExpiryDate` AS `Expiry Date`,
    `Status` AS `Status`,
    `LineItem_LineItemId` AS `LineItem Id`,
    `LineItem_Description` AS `LineItem Description`,
    `LineItem_Quantity` AS `LineItem Quantity`,
    `LineItem_UnitAmount` AS `LineItem Unit Amount`,
    `LineItem_ItemCode` AS `LineItem Item Code`,
    `LineItem_AccountCode` AS `LineItem Account Code`,
    `LineItem_TaxType` AS `LineItem Tax Type`,
    `LineItem_TaxAmount` AS `LineItem Tax Amount`,
    `LineItem_LineAmount` AS `LineItem Line Amount`,
    `LineItem_DiscountRate` AS `LineItem Discount Rate`,
    `LineItem_TrackingCategory1_CategoryId` AS `LineItem Tracking Category 1 Category Id`,
    `LineItem_TrackingCategory1_CategoryName` AS `LineItem Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `LineItem Tracking Category 1 Option Id`,
    `LineItem_TrackingCategory1_OptionName` AS `LineItem Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory2_CategoryId` AS `LineItem Tracking Category 2 Category Id`,
    `LineItem_TrackingCategory2_CategoryName` AS `LineItem Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `LineItem Tracking Category 2 Option Id`,
    `LineItem_TrackingCategory2_OptionName` AS `LineItem Tracking Category 2 Option Name`,
    `QuoteNumber` AS `Quote Number`,
    `LineAmountTypes` AS `Line Amount Types`,
    `Reference` AS `Reference`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `SubTotal` AS `SubTotal`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `TotalDiscount` AS `Total Discount`,
    `BrandingThemeId` AS `Branding Theme Id`,
    `Terms` AS `Terms`,
    `Title` AS `Title`,
    `Summary` AS `Summary`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_quotes;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgets;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgets AS
SELECT 
    `BudgetID` AS `Budget ID`,
    `Status` AS `Status`,
    `Description` AS `Description`,
    `Type` AS `Type`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `BudgetLines` AS `Budget Lines`,
    `BudgetLines.AccountID` AS `Budget Lines Account ID`,
    `BudgetLines.AccountCode` AS `Budget Lines Account Code`,
    `BudgetLines.BudgetBalances` AS `Budget Lines Budget Balances`,
    `BudgetLines.BudgetBalances.Period` AS `Budget Lines Budget Balances Period`,
    `BudgetLines.BudgetBalances.Amount` AS `Budget Lines Budget Balances Amount`,
    `BudgetLines.BudgetBalances.Notes` AS `Budget Lines Budget Balances Notes`,
    `Tracking` AS `Tracking`,
    `Tracking.1.Name` AS `Tracking 1 Name`,
    `Tracking.1.Option` AS `Tracking 1 Option`,
    `Tracking.1.TrackingCategoryID` AS `Tracking 1 Tracking Category ID`,
    `Tracking.1.TrackingOptionID` AS `Tracking 1 Tracking Option ID`,
    `Tracking.2.Name` AS `Tracking 2 Name`,
    `Tracking.2.Option` AS `Tracking 2 Option`,
    `Tracking.2.TrackingCategoryID` AS `Tracking 2 Tracking Category ID`,
    `Tracking.2.TrackingOptionID` AS `Tracking 2 Tracking Option ID`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_budgets;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicesdraft;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicesdraft AS
SELECT
    `Id` AS `Invoice Line ID`,
    `InvoiceId` AS `Invoice ID`,
    `Type` AS `Type`,
    `ContactId` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Line Item - Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `DiscountRate%` AS `Discount Rate %`,
    `LineItem_DiscountAmount` AS `Discount Amount`,
    `LineItemAggregate` AS `Aggregate`,
    `Date` AS `Date`,
    `DueDate` AS `Due Date`,
    `LineAmountTypes` AS `Line Amount Types`,
    `InvoiceNumber` AS `Invoice Number`,
    `Reference` AS `Reference`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `URL` AS `URL`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `Status` AS `Status`,
    `SentToContact` AS `Sent To Contact`,
    `ExpectedPaymentDate` AS `Expected Payment Date`,
    `PlannedPaymentDate` AS `Planned Payment Date`,
    `SubTotal` AS `Invoice - Sub Total`,
    `TotalTax` AS `Invoice - Total Tax`,
    `Total` AS `Invoice Total`,
    `TotalDiscount` AS `Total Discount`,
    `HasAttachments` AS `Has Attachments`,
    `AmountDue` AS `Invoice - Amount Due`,
    `AmountPaid` AS `Invoice - Amount Paid`,
    `CISDeduction` AS `CIS Deduction`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `AmountCredited` AS `Amount Credited`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `CreditNotes` AS `Credit Notes`,
    `Payments` AS `Payments`,
    `Prepayments` AS `Pre Payments`,
    `Overpayments` AS `Over Payments`,
    `RepeatingInvoiceID` AS `Repeating Invoice ID`,
    CONCAT(`LineItem_AccountCode`, '-', `OrganisationID`) AS `Account_UID`,
    `PaymentIds` AS `Payment ID`,
    `PrePaymentIds` AS `Pre Payment ID`,
    `OverPaymentIds` AS `Over Payment ID`,
    `CreditNoteIDs` AS `Credit Note ID`,
    `LineAmountCalculation` AS `Line Amount Calculation`,
    `LineAmountCalculationIncTax` AS `Line Amount Calculation Inc Tax`,
    `LineAmountTradeCreditorCalculation` AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation` AS `Line Amount Trade Debtor Calculation`,
    `DayDifference` AS `Day Difference`
FROM evadb_stage.c1518_xeroblue_invoicesdraft;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactions AS
SELECT 
    `lineid` AS `Line ID`,
    `id` AS `ID`,
    `date` AS `Date`,
    `type` AS `Type`,
    `contactid` AS `Contact ID`,
    `contactname` AS `Contact Name`,
    `lineitemid` AS `Line Item ID`,
    `description` AS `Description`,
    `quantity` AS `Quantity`,
    `unitamount` AS `Unit Amount`,
    `itemcode` AS `Item Code`,
    `accountcode` AS `Account Code`,
    `taxtype` AS `Tax Type`,
    `taxamount` AS `Tax Amount`,
    `lineamount` AS `Line Amount`,
    `lineamounttypes` AS `Line Amount Types`,
    `status` AS `Status`,
    `subtotal` AS `Sub Total`,
    `totaltax` AS `Total Tax`,
    `total` AS `Total`,
    `trackingcategory1categoryid` AS `Tracking Category 1 Category ID`,
    `trackingcategory1categoryname` AS `Tracking Category 1 Category Name`,
    `trackingcategory1optionid` AS `Tracking Category 1 Option ID`,
    `trackingcategory1optionname` AS `Tracking Category 1 Option Name`,
    `trackingcategory1optionstat` AS `Tracking Category 1 Option Stat`,
    `trackingcategory2categoryid` AS `Tracking Category 2 Category ID`,
    `trackingcategory2categoryname` AS `Tracking Category 2 Category Name`,
    `trackingcategory2optionid` AS `Tracking Category 2 Option ID`,
    `trackingcategory2optionname` AS `Tracking Category 2 Option Name`,
    `trackingcategory2optionstat` AS `Tracking Category 2 Option Stat`,
    `discountrate` AS `Discount Rate`,
    `currencycode` AS `Currency Code`,
    `currencyrate` AS `Currency Rate`,
    `updateddateutc` AS `Updated Date UTC`,
    `accountuid` AS `Account UID`,
    `hasattachments` AS `Has Attachments`,
    `creditnotenumber` AS `Credit Note Number`,
    `remainingcredit` AS `Remaining Credit`,
    `fullypaidondate` AS `Fully Paid On Date`,
    `reference` AS `Reference`,
    `source` AS `Source`,
    `clientid` AS `Client ID`,
    `organisationid` AS `Organisation ID`,
    `showoncashbasisreports` AS `ShowOnCashBasisReports`,
    `duedate` AS `DueDate`,
    `invoicenumber` AS `InvoiceNumber`,
    `paymentsourceid` AS `PaymentSourceID`,
    `paymenttype` AS `PaymentType`,
    `allocationdate` AS `AllocationDate`,
    `allocationamount` AS `AllocationAmount`,
    `changes` AS `Changes`,
    `user` AS `User`,
    `details` AS `Details`,
    `daydifference` AS `DayDifference`
FROM evadb_stage.c1518_xeroblue_transactions;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscontacts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscontacts AS
SELECT 
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `ContactSource` AS `ContactSource`,
    `PaymentSourceID` AS `PaymentSourceID`,
    `PaymentType` AS `PaymentType`,
    `Changes` AS `Changes`,
    `User` AS `User`,
    `Details` AS `Details`,
    `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    `FullyPaidOnDate` AS `FullyPaidOnDate`,
    `DayDifference` AS `DayDifference`,
    `InvoiceNumber` AS `InvoiceNumber`,
    `CreditNoteNumber` AS `CreditNoteNumber`
FROM evadb_stage.c1518_xeroblue_journals;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscashcontacts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscashcontacts AS
SELECT 
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `ContactSource` AS `ContactSource`,
    `PaymentSourceID` AS `PaymentSourceID`,
    `PaymentType` AS `PaymentType`,
    `Changes` AS `Changes`,
    `User` AS `User`,
    `Details` AS `Details`,
    `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    `FullyPaidOnDate` AS `FullyPaidOnDate`,
    `DayDifference` AS `DayDifference`,
    `InvoiceNumber` AS `InvoiceNumber`,
    `CreditNoteNumber` AS `CreditNoteNumber`
FROM evadb_stage.c1518_xeroblue_journalscash;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquetransactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquetransactions AS
SELECT
    `LineID` AS `Line ID`,
    `ID` AS `ID`,
    `Date` AS `Date`,
    `Type` AS `Type`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItemID` AS `Line Item ID`,
    `Description` AS `Description`,
    `Quantity` AS `Quantity`,
    `UnitAmount` AS `Unit Amount`,
    `ItemCode` AS `Item Code`,
    `AccountCode` AS `Account Code`,
    `TaxType` AS `Tax Type`,
    `TaxAmount` AS `Tax Amount`,
    `LineAmount` AS `Line Amount`,
    `LineAmountTypes` AS `Line Amount Types`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `TrackingCategory1CategoryID` AS `Tracking Category 1 Category ID`,
    `TrackingCategory1CategoryName` AS `Tracking Category 1 Category Name`,
    `TrackingCategory1OptionID` AS `Tracking Category 1 Option ID`,
    `TrackingCategory1OptionName` AS `Tracking Category 1 Option Name`,
    `TrackingCategory1OptionStat` AS `Tracking Category 1 Option Stat`,
    `TrackingCategory2CategoryID` AS `Tracking Category 2 Category ID`,
    `TrackingCategory2CategoryName` AS `Tracking Category 2 Category Name`,
    `TrackingCategory2OptionID` AS `Tracking Category 2 Option ID`,
    `TrackingCategory2OptionName` AS `Tracking Category 2 Option Name`,
    `TrackingCategory2OptionStat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `AccountUID` AS `Account UID`,
    `HasAttachments` AS `Has Attachments`,
    `CreditNoteNumber` AS `Credit Note Number`,
    `RemainingCredit` AS `Remaining Credit`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `Reference` AS `Reference`,
    `Source` AS `Source`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM (
    SELECT *, row_number() over(partition by `ID`, `OrganisationID` order by `LineID`) AS rn
    FROM evadb_stage.c1518_XEROBLUE_Transactions
    WHERE ((`Source` = 'MANUALJOURNALS' AND `Status` = 'POSTED') OR `Status` IN ('AUTHORISED', 'PAID'))
)A WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactionsblend;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactionsblend AS
SELECT 
    tb.`Id` AS `ID`,
    tb.`JournalId` AS `Journal ID`,
    tb.`JournalNumber` AS `Index`,
    tb.`JournalDate` AS `Journal Date`,
    tb.`JournalNumber` AS `Journal Number`,
    tb.`CreatedDateUTC` AS `Created Date UTC`,
    tb.`Reference` AS `Reference`,
    tb.`SourceId` AS `Source ID`,
    IFNULL(tb.`SourceType`, 'NULL VALUE') AS `Source Type`,
    tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    tb.`JournalLine_NetAmount` AS `Net Amount`,
    tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    tb.`JournalLine_TaxAmount` AS `Tax Amount`,
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
FROM evadb_stage.c1518_xeroblue_journals Tb
LEFT JOIN evadb_stage.c1518_xeroblue_accounts Acc 
ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactionsblendcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactionsblendcash AS
SELECT 
    tb.`Id` AS `ID`,
    tb.`JournalId` AS `Journal ID`,
    tb.`JournalNumber` AS `Index`,
    tb.`JournalDate` AS `Journal Date`,
    tb.`JournalNumber` AS `Journal Number`,
    tb.`CreatedDateUTC` AS `Created Date UTC`,
    tb.`Reference` AS `Reference`,
    tb.`SourceId` AS `Source ID`,
    IFNULL(tb.`SourceType`, 'NULL VALUE') AS `Source Type`,
    tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    tb.`JournalLine_NetAmount` AS `Net Amount`,
    tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    tb.`JournalLine_TaxAmount` AS `Tax Amount`,
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
FROM evadb_stage.c1518_xeroblue_journalscash Tb
LEFT JOIN evadb_stage.c1518_xeroblue_accounts Acc 
ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquebanktransactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquebanktransactions AS
SELECT
    b.`Id`                                        AS `Bank Transaction Line ID`,
    b.`BankTransactionId`                         AS `Bank Transaction ID`,
    b.`Type`                                      AS `Type`,
    b.`Contact_ContactName`                       AS `Contact Name`,
    b.`Contact_ContactId`                         AS `Contact ID`,
    b.`BankAccount_AccountId`                     AS `Account ID`,
    b.`BankAccount_AccountName`                   AS `Bank Account Account Name`,
    b.`BankAccount_Code`                          AS `Bank Account Code`,
    b.`LineItem_LineItemId`                       AS `Line Item ID`,
    b.`LineItem_Description`                      AS `Description`,
    b.`LineItem_Quantity`                         AS `Quantity`,
    b.`LineItem_UnitAmount`                       AS `Unit Amount`,
    b.`LineItem_AccountCode`                      AS `Account Code Posted Against`,
    b.`LineItem_TaxType`                          AS `Tax Type`, 
    b.`LineItem_TaxAmount`                        AS `Tax Amount`,
    b.`LineItem_ItemCode`                         AS `Item Code`,
    b.`LineItem_LineAmount`                       AS `Line Amount`,
    b.`LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 CategoryID`,
    b.`LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Name`,
    b.`LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    b.`LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    b.`LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    b.`LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 CategoryID`,
    b.`LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    b.`LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    b.`LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    b.`LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    b.`LineItemAggregate`                         AS `Line Item Aggregate`,
    b.`IsReconciled`                              AS `Is Reconciled`,
    b.`Date`                                      AS `Date`,
    b.`Reference`                                 AS `Reference`,
    b.`CurrencyCode`                              AS `Currency Code`,
    b.`CurrencyRate`                              AS `Currency Rate`,
    b.`URL`                                       AS `URL`,
    b.`Status`                                    AS `Status`,
    b.`SubTotal`                                  AS `Sub Total`,
    b.`TotalTax`                                  AS `Total Tax`,
    b.`Total`                                     AS `Total`,
    b.`PrepaymentId`                              AS `Prepayment ID`,
    b.`OverpaymentId`                             AS `Overpayment ID`,
    b.`UpdatedDateUTC`                            AS `Updated Date UTC`,
    b.`FullyPaidOnDate`                           AS `Fully Paid On Date`,
    b.`ClientID`                                  AS `Client ID`,
    b.`OrganisationID`                            AS `Organisation ID`,
    b.`LineAmountTypes`                           AS `Line Amount Types`,
    b.`Account_UID`                               AS `Account_UID`,
    b.`ConditionalType`                           AS `Conditional Type`
FROM evadb_stage.c1518_xeroblue_banktransactions b
INNER JOIN bigoleshoecompany_client1518_xeroblue_uniquetransactions t 
    ON b.`Id` = t.`Line ID` AND b.`OrganisationID` = t.`Organisation ID`
WHERE t.`Source` = 'BANKTRANSACTIONS';

DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_trackingcategoryconn;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_trackingcategoryconn AS
SELECT
    `ID` AS `ID`,
    `CategoryNumber` AS `CategoryNumber`,
    `CategoryID+Option` AS `CategoryID+Option`,
    `ClientID` AS `ClientID`,
    `OrganisationID` AS `OrganisationID`
FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY ID, OrganisationID ORDER BY ID) AS rn
    FROM evadb_stage.c1518_xeroblue_trackingcategoryconnections
) t 
WHERE t.rn = 1;

DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_trialbalance;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_trialbalance AS
SELECT 
	`ID` AS `ID`,
	`Date` AS `Date`,
	`Title` AS `Title`,
	`Account` AS `Account`,
	`Debit` AS `Debit`,
	`Credit` AS `Credit` ,
	`YTDDebit` AS `YTD Debit` ,
	`YTDCredit` AS `YTD Credit`,
	`AccountId` AS `Account ID`,
	`ClientID` AS `Client ID`,
	`OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_trialbalance;

-- source table data load process not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_cashvalidation;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_cashvalidation AS
SELECT 
    `accountId` AS `account Id`,
    `bankStatement.currentStatement.endBalance` AS `current Statement end Balance`,
    `bankStatement.currentStatement.endDate` AS `current Statement end Date`,
    `bankStatement.currentStatement.importedDateTimeUtc` AS `current Statement imported Date Time Utc`,
    `bankStatement.currentStatement.importSourceType` AS `current Statement import Source Type`,
    `bankStatement.currentStatement.startBalance` AS `current Statement.startBalance`,
    `bankStatement.currentStatement.startDate` AS `current Statement start Date`,
    `bankStatement.statementLines.avgDaysUnreconciledNeg` AS `statement Lines avg Days Unreconciled Neg`,
    `bankStatement.statementLines.avgDaysUnreconciledPos` AS `statement Lines avg Days Unreconciled Pos`,
    `bankStatement.statementLines.dataSource.directBankFeed` AS `statement Lines dataSource direct Bank Feed`,
    `bankStatement.statementLines.dataSource.directBankFeedNeg` AS `statement Lines dataSource direct Bank Feed Neg`,
    `bankStatement.statementLines.dataSource.directBankFeedPos` AS `statementLines dataSource direct Bank Feed Pos`,
    `bankStatement.statementLines.dataSource.fileUpload` AS `statement Lines dataSource file Upload`,
    `bankStatement.statementLines.dataSource.fileUploadNeg` AS `statement Lines dataSource file Upload Neg`,
    `bankStatement.statementLines.dataSource.fileUploadPos` AS `statement Lines dataSource file Upload Pos`,
    `bankStatement.statementLines.dataSource.indirectBankFeed` AS `statement Lines dataSource indirect Bank Feed`,
    `bankStatement.statementLines.dataSource.indirectBankFeedNeg` AS `statement Lines dataSource indirect Bank Feed Neg`,
    `bankStatement.statementLines.dataSource.indirectBankFeedPos` AS `statement Lines dataSource indirect Bank Feed Pos`,
    `bankStatement.statementLines.dataSource.manual` AS `statement Lines dataSource manual`,
    `bankStatement.statementLines.dataSource.manualNeg` AS `statement Lines dataSource manual Neg`,
    `bankStatement.statementLines.dataSource.manualPos` AS `statement Lines dataSource manual Pos`,
    `bankStatement.statementLines.dataSource.other` AS `statement Lines dataSource other`,
    `bankStatement.statementLines.dataSource.otherNeg` AS `statement Lines dataSource other Neg`,
    `bankStatement.statementLines.dataSource.otherPos` AS `statement Lines dataSource other Pos`,
    `bankStatement.statementLines.deletedAmount` AS `statement Lines deleted Amount`,
    `bankStatement.statementLines.earliestReconciledTransaction` AS `statement Lines earliest Reconciled Transaction`,
    `bankStatement.statementLines.earliestUnreconciledTransaction` AS `statement Lines earliest Unreconciled Transaction`,
    `bankStatement.statementLines.latestReconciledTransaction` AS `statement Lines latest Reconciled Transaction`,
    `bankStatement.statementLines.latestUnreconciledTransaction` AS `statement Lines latest Unreconciled Transaction`,
    `bankStatement.statementLines.reconciledAmountNeg` AS `sStatement Lines reconciled Amount Neg`,
    `bankStatement.statementLines.reconciledAmountPos` AS `statement Lines reconciled Amount Pos`,
    `bankStatement.statementLines.reconciledLines` AS `statement Lines reconciled Lines`,
    `bankStatement.statementLines.totalAmount` AS `statement Lines total Amount`,
    `bankStatement.statementLines.totalAmountNeg` AS `statement Lines total Amount Neg`,
    `bankStatement.statementLines.totalAmountPos` AS `statement Lines total Amount Pos`,
    `bankStatement.statementLines.unreconciledAmountNeg` AS `statement Lines unreconciled Amount Neg`,
    `bankStatement.statementLines.unreconciledAmountPos` AS `statement Lines unreconciled Amount Pos`,
    `bankStatement.statementLines.unreconciledLines` AS `statement Lines unreconciled Lines`,
    `cashAccount.accountBalance` AS `cash Account account Balance`,
    `cashAccount.balanceCurrency` AS `cash Account balance Currency`,
    `cashAccount.startingBalance` AS `cash Account starting Balance`,
    `cashAccount.unreconciledAmountNeg` AS `cash Account unreconciled Amount Neg`,
    `cashAccount.unreconciledAmountPos` AS `cash Account unreconciled Amount Pos`,
    `statementBalance.type` AS `statement Balance type`,
    `statementBalance.value` AS `statement Balance value`,
    `statementBalanceDate` AS `statement Balance Date`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_cashvalidation;










-- Source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgetsummary2026fy;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgetsummary2026fy AS
SELECT *
FROM evadb_stage.c1518_xeroblue_budgetsummary2026fy_view;



-- Source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_contactgroupmembers;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_contactgroupmembers AS
SELECT
    `ContactID` AS `ContactID`,
    `Name` AS `Name`,
    `ContactGroupID` AS `ContactGroupID`,
    `ContactGroups_Name` AS `ContactGroups_Name`,
    `ContactGroups_Status` AS `ContactGroups_Status`,
    `ClientID` AS `ClientID`,
    `OrganisationID` AS `OrganisationID`
FROM evadb_stage.c1518_xeroblue_contactgroupmembers;


-- Source table not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_balancesheet;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_balancesheet AS
SELECT 
    `ID` AS `ID`,
    `Title` AS `Title`,
    `AccountName` AS `Account Name`,
    `Amount` AS `Amount`,
    `Month` AS `Month`,
    `AccountId` AS `Account ID`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_balancesheetpivot;


-- Source table not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_bankstatement;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_bankstatement AS
SELECT 
    `BankAccountId` AS `Bank Account ID`,
    `Date` AS `Date`,
    `Description` AS `Description`,
    `Reference` AS `Reference`,
    `Reconciled` AS `Reconciled`,
    `Source` AS `Source`,
    `Amount` AS `Amount`,
    `Balance` AS `Balance`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_bankstatement;


-- Source table not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_banksummary;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_banksummary AS
SELECT 
    `ID` AS `ID`,
    `BankAccount` AS `Bank Account`,
    `OpeningBalance` AS `Opening Balance`,
    `CashReceived` AS `Cash Received`,
    `CashSpent` AS `Cash Spent`,
    `FXGain` AS `FX Gain`,
    `ClosingBalance` AS `Closing Balance`,
    `AccountID` AS `Account ID`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_banksummary
WHERE `BankAccount` NOT IN ('Total');


-- source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_profitandloss;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_profitandloss AS
SELECT
    `ID` AS `ID`,
    `Title` AS `Title`,
    `AccountName` AS `Account Name`,
    `Amount` AS `Amount`,
    `Month` AS `Month`,
    `AccountId` AS `Account ID`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_profitandlosspivot;


-- source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_expenseclaimpayments;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_expenseclaimpayments AS
SELECT
    `Id` AS `Id`,
    `ExpenseClaimId` AS `Expense Claim Id`,
    `Date` AS `Date`,
    `Amount` AS `Amount`,
    `Reference` AS `Reference`,
    `AccountId` AS `Account Id`,
    `AccountCode` AS `Account Code`,
    `AccountName` AS `Account Name`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_expenseclaimpayments;


-- source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_expenseclaimreceipts;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_expenseclaimreceipts AS
SELECT
    `Id` AS `Id`,
    `ExpenseClaimId` AS `Expense Claim Id`,
    `ReceiptId` AS `Receipt Id`,
    `Date` AS `Date`,
    `Contact_ContactId` AS `Contact Id`,
    `Contact_Name` AS `Contact Name`,
    `LineItem_Description` AS `LineItem Description`,
    `LineItem_UnitAmount` AS `LineItem UnitAmount`,
    `LineItem_AccountCode` AS `LineItem AccountCode`,
    `LineItem_Quantity` AS `LineItem Quantity`,
    `LineItem_TaxAmount` AS `LineItem TaxAmount`,
    `LineItem_TaxType` AS `LineItem TaxType`,
    `LineItem_LineAmount` AS `LineItem LineAmount`,
    `LineItem_TrackingCategory1_CategoryId` AS `LineItem Tracking Category 1 Category Id`,
    `LineItem_TrackingCategory1_CategoryName` AS `LineItem Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `LineItem Tracking Category 1 Option Id`,
    `LineItem_TrackingCategory1_OptionName` AS `LineItem Tracking Category 1 OptionName`,
    `LineItem_TrackingCategory1_Option_Stat` AS `LineItem Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `LineItem Tracking Category 2 Category Id`,
    `LineItem_TrackingCategory2_CategoryName` AS `LineItem Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `LineItem Tracking Category 2 Option Id`,
    `LineItem_TrackingCategory2_OptionName` AS `LineItem Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `LineItem Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `LineItem Discount Rate`,
    `User_UserId` AS `User Id`,
    `Reference` AS `Reference`,
    `LineAmountTypes` AS `Line Amount Types`,
    `SubTotal` AS `SubTotal`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `Status` AS `Status`,
    `ReceiptNumber` AS `Receipt Number`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `URL` AS `URL`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_expenseclaimreceipts;


-- source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_executivesummary;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_executivesummary AS
SELECT
    `Title` AS `Title`,
    `Metric` AS `Metric`,
    `ThisMonth` AS `This Month`,
    `PreviousMonth` AS `Previous Month`,
    `Variance` AS `Variance`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_executivesummary;


-- Source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgetsummaryinterim;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgetsummaryinterim AS
SELECT 
    `ID`,
    `Title`,
    `AccountId`,
    `BankAccount`,
    `ClientID`,
    `OrganisationID`,
    `FinancialYear`,
    `AccountName_UID`,
    `Amount`,
    `Month`,
    `Amount_AUD`,
    `Amount_USD`,
    `Amount_NZD`,
    `Amount_EUR`,
    `Amount_GBP`
FROM evadb_stage.c1518_xeroblue_budgetsummaryInterim;


-- Source not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgetsummary;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgetsummary AS
SELECT 
    `ID`,
    `Title`,
    `AccountId`,
    `BankAccount`,
    `ClientID`,
    `OrganisationID`,
    `FinancialYear`,
    `AccountName_UID`,
    `Amount`,
    `Month`,
    `Amount_AUD`,
    `Amount_USD`,
    `Amount_NZD`,
    `Amount_EUR`,
    `Amount_GBP`,
    `TotalAmount` AS `Total Amount`
FROM evadb_stage.c1518_xeroblue_budgetsummaryInterim;


-- Duplicate view - should bew deleted
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquecreditnotesdq;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquecreditnotesdq AS
SELECT
    `CreditNoteId` AS `Credit Note ID`,
    `Id` AS `Credit Note Line ID`,
    `CreditNoteNumber` AS `Credit Note Number`,
    `Reference` AS `Reference`,
    `Type` AS `Type`,
    `Contact_ContactId` AS `Contact ID`,
    `Contact_Name` AS `Contact Name`,
    `Date` AS `Date`,
    `Status` AS `Status`,
    `LineAmountTypes` AS `Line Amount Types`,
    `LineItem_Description` AS `Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate` AS `Discount Rate`,
    `LineItemAggregate` AS `Line Item Aggregate`,
    `SubTotal` AS `Sub Total`,
    `TotalTax` AS `Total Tax`,
    `Total` AS `Total`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `CurrencyCode` AS `Currency Code`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `SentToContact` AS `Sent To Contact`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `CurrencyRate` AS `Currency Rate`,
    `RemainingCredit` AS `Remaining Credit`,
    `Allocation1_AppliedAmount` AS `Allocation 1 Applied Amount`,
    `Allocation1_Date` AS `Allocation 1 Date`,
    `Allocation1_InvoiceId` AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber` AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount` AS `Allocation 2 Applied Amount`,
    `Allocation2_Date` AS `Allocation 2 Date`,
    `Allocation2_InvoiceId` AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber` AS `Allocation 2 Invoice Number`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Allocation3_AppliedAmount` AS `Allocation 3 Applied Amount`,
    `Allocation3_Date` AS `Allocation 3 Date`,
    `Allocation3_InvoiceId` AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber` AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount` AS `Allocation 4 Applied Amount`,
    `Allocation4_Date` AS `Allocation 4 Date`,
    `Allocation4_InvoiceId` AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber` AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount` AS `Allocation 5 Applied Amount`,
    `Allocation5_Date` AS `Allocation 5 Date`,
    `Allocation5_InvoiceId` AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber` AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount` AS `Allocation 6 Applied Amount`,
    `Allocation6_Date` AS `Allocation 6 Date`,
    `Allocation6_InvoiceId` AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber` AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount` AS `Allocation 7 Applied Amount`,
    `Allocation7_Date` AS `Allocation 7 Date`,
    `Allocation7_InvoiceId` AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber` AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount` AS `Allocation 8 Applied Amount`,
    `Allocation8_Date` AS `Allocation 8 Date`,
    `Allocation8_InvoiceId` AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber` AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount` AS `Allocation 9 Applied Amount`,
    `Allocation9_Date` AS `Allocation 9 Date`,
    `Allocation9_InvoiceId` AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber` AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount` AS `Allocation 10 Applied Amount`,
    `Allocation10_Date` AS `Allocation 10 Date`,
    `Allocation10_InvoiceId` AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber` AS `Allocation 10 Invoice Number`,
    `Allocation11_AppliedAmount` AS `Allocation 11 Applied Amount`,
    `Allocation11_Date` AS `Allocation 11 Date`,
    `Allocation11_InvoiceId` AS `Allocation 11 Invoice ID`,
    `Allocation11_InvoiceNumber` AS `Allocation 11 Invoice Number`,
    `Allocation12_AppliedAmount` AS `Allocation 12 Applied Amount`,
    `Allocation12_Date` AS `Allocation 12 Date`,
    `Allocation12_InvoiceId` AS `Allocation 12 Invoice ID`,
    `Allocation12_InvoiceNumber` AS `Allocation 12 Invoice Number`,
    `Allocation13_AppliedAmount` AS `Allocation 13 Applied Amount`,
    `Allocation13_Date` AS `Allocation 13 Date`,
    `Allocation13_InvoiceId` AS `Allocation 13 Invoice ID`,
    `Allocation13_InvoiceNumber` AS `Allocation 13 Invoice Number`,
    `Allocation14_AppliedAmount` AS `Allocation 14 Applied Amount`,
    `Allocation14_Date` AS `Allocation 14 Date`,
    `Allocation14_InvoiceId` AS `Allocation 14 Invoice ID`,
    `Allocation14_InvoiceNumber` AS `Allocation 14 Invoice Number`,
    `Allocation15_AppliedAmount` AS `Allocation 15 Applied Amount`,
    `Allocation15_Date` AS `Allocation 15 Date`,
    `Allocation15_InvoiceId` AS `Allocation 15 Invoice ID`,
    `Allocation15_InvoiceNumber` AS `Allocation 15 Invoice Number`,
    `AccountUID` AS `Account UID`
FROM (
    SELECT *, Row_number() OVER(PARTITION BY `CreditNoteId`, `OrganisationID` ORDER BY Id) rn 
    FROM evadb_stage.c1518_xeroblue_creditnotes
) t WHERE rn = 1;


-- endpoint deprecated
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_expenseclaims;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_expenseclaims AS
SELECT 
    `ExpenseClaimId` AS `Expense Claim ID`,
    `UserId` AS `User  ID`,
    `Status` AS `Status`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `Total` AS `Total`,
    `AmountDue` AS `Amount Due`,
    `AmountPaid` AS `Amount Paid`,
    `PaymentDueDate` AS `Payment Due Date`,
    `ReportingDate` AS `Reporting Date`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_expenseclaims;