/**************************************************************************************
FILENAME: CREATE VIEWS
DESCRIPTION: LIST OF SQL SCRIPT FOR CREATING VIEWS. REPLACE "NEW_CLIENT1" WITH CORRECT
	CLIENT ID.
HISTORY:
DATE					DESCRIPTION
2023-07-13				INTIAL VERSION
**************************************************************************************/


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_accounts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_accounts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_accounts
as
SELECT 
	"P&LReportingTypeInterim" AS "P&L Reporting Type Interim",
	"AccountId" AS "Account ID",
	"Code" AS "Code",
	"Name" AS "Name",
	"Type" AS "Type",
	"Description" AS "Description",
	"TaxType" AS "Tax Type",
	"EnablePaymentsToAccount" AS "Enable Payments To Account",
	"ShowInExpenseClaims" AS "Show In Expense Claims",
	"Class" AS "Class",
	"Status" AS "Status",
	"SystemAccount" AS "System Account",
	"BankAccountNumber" AS "Bank Account Number",
	"CurrencyCode" AS "Currency Code",
	"ReportingCode" AS "Reporting Code",
	"ReportingCodeName" AS "Reporting Code Name",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"HasAttachments" AS "Has Attachments",
	"BankAccountType" AS "Bank Account Type",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"AccountType" AS "Account Type",
	"ClassOrder" AS "Class Order",
	"AccountTypeOrder" AS "Account Type Order",
	"P&LGroup" AS "P&L Group",
	"P&LGroupOrder" AS "P&L Group Order",
	"BalanceSheetType" AS "Balance Sheet Type",
	"BalanceSheetGroup" AS "Balance Sheet Group",
	"BalanceSheetAccountName" AS "Balance Sheet Account Name",
	"BalanceSheetReportingGroup" AS "Balance Sheet Reporting Group",
	"BalanceSheetReportingType" AS "Balance Sheet Reporting Type",
	"BalanceSheetReportingTypeOrder" AS "Balance Sheet Reporting Type Order",
	"BalanceSheetReportingGroupOrder" AS "Balance Sheet Reporting Group Order",
	"P&LReportingType" AS "P&L Reporting Type",
	"P&LReportingGroup" AS "P&L Reporting Group",
	"P&LReportingGroupOrder" AS "P&L Reporting Group Order",
	"P&LReportingTypeOrder" AS "P&L Reporting Type Order",
	"BalanceSheetGroupOrder" AS "Balance Sheet Group Order",
	"StatementofCashflow" AS "Statement of Cashflow",
	"CashflowActivities" AS "Cashflow Activities",
	"CashflowActivitiesOrder" AS "Cashflow Activities Order",
	"StatementofCashflowOrder" AS "Statement of Cashflow Order",
	"CashIn/CashOut" AS "Cash In / Cash Out",
	"Account_UID" AS "Account_UID",
	"AccountName_UID" AS "AccountName_UID"
FROM (
        SELECT *, 
            Row_number() OVER(PARTITION BY ISNULL("Code", 'BLANK'), CAST("OrganisationID" AS VARCHAR) ORDER BY AccountId) rn 
        FROM dbo.NEW_CLIENT1_XEROBLUE_Accounts 
        WHERE Code IS not NULL
    ) t 
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_balancesheet','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_balancesheet
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_balancesheet
as
SELECT
	"ID" AS "ID",
	"Title" AS "Title",
	"AccountName"  AS "Account Name",
	"Amount"  AS "Amount",
	"Month"  AS "Month",
	"AccountId"  AS "Account ID",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_BalanceSheetPivot
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_bankstatement','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_bankstatement
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_bankstatement
as
SELECT 
	"BankAccountId" AS "Bank Account ID",
	"Date" AS "Date",
	"Description" AS "Description",
	"Reference" AS "Reference",
	"Reconciled" AS "Reconciled",
	"Source" AS "Source" ,
	"Amount" AS "Amount",
	"Balance" AS "Balance",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_BankStatement
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_banksummary','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_banksummary
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_banksummary
as
SELECT 
	"ID" AS "ID",
	"BankAccount" AS "Bank Account",
	"OpeningBalance" AS "Opening Balance",
	"CashReceived" AS "Cash Received",
	"CashSpent" AS "Cash Spent", 
	"FXGain" AS "FX Gain",
	"ClosingBalance" AS "Closing Balance",
	"AccountID" AS "AccountID",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_BankSummary WHERE BankAccount NOT IN ('Total')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_banktransactions','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_banktransactions
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_banktransactions
as
SELECT 
	"Id" AS "Bank Transaction Line ID",
	"BankTransactionId" AS "Bank Transaction ID",
	"Type" AS "Type",
	"Contact_ContactName" AS "Contact Name",
	"Contact_ContactId" AS "Contact ID",
	"BankAccount_AccountId" AS "Account ID",
	"BankAccount_AccountName" AS "Bank Account Account Name",
	"BankAccount_Code" AS "Bank Account Code",
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_AccountCode" AS "Account Code Posted Against",
	 ISNULL("LineItem_TaxType", 'BLANK') AS "Tax Type", 
	"LineItem_TaxAmount" AS "Tax Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 CategoryID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 CategoryID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItemAggregate" AS "Line Item Aggregate",
	"IsReconciled" AS "Is Reconciled",
	"Date" AS "Date",
	"Reference" AS "Reference",
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"URL" AS "URL",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"PrepaymentId" AS "Prepayment ID",
	"OverpaymentId" AS "Overpayment ID",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"LineAmountTypes" AS "Line Amount Types",
	"Account_UID" AS "Account_UID",
	"BankTansactionCashflowCalculation" AS "Bank Tansaction Cashflow Calculation",
	"LineAmountCalculatedIncTax" AS "Line Amount Calculated Inc Tax",
	"PaymentAmount" AS "Payment Amount"
FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactions WHERE Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions
as
SELECT 
	"Id" AS "Bank Transaction Line ID",
	"BankTransactionId" AS "Bank Transaction ID",
	"Type" AS "Type",
	"Contact_ContactName" AS "Contact Name",
	"Contact_ContactId" AS "Contact ID",
	"BankAccount_AccountId" AS "Account ID",
	"BankAccount_AccountName" AS "Bank Account Account Name",
	"BankAccount_Code" AS "Bank Account Code",
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_AccountCode" AS "Account Code Posted Against",
	"LineItem_TaxType" AS "Tax Type", 
	"LineItem_TaxAmount" AS "Tax Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 CategoryID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 CategoryID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItemAggregate" AS "Line Item Aggregate",
	"IsReconciled" AS "Is Reconciled",
	"Date" AS "Date",
	"Reference" AS "Reference",
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"URL" AS "URL",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"PrepaymentId" AS "Prepayment ID",
	"OverpaymentId" AS "Overpayment ID",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"LineAmountTypes" AS "Line Amount Types",
	"Account_UID" AS "Account_UID",
	"ConditionalType" AS "Conditional Type"
FROM NEW_CLIENT1_XEROBLUE_UniqueBankTransactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_banktransfers','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_banktransfers
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_banktransfers
as
SELECT
	"BankTransferId" AS "Bank Transfer ID", 
	"FromBankAccount_Code" AS "From Bank Account Code",
	"FromBankAccount_AccountId" AS "FromBankAccount_AccountId" ,
	"FromBankAccount_Name" AS "From Bank Account Name" ,
	"ToBankAccount_Code" AS "To Bank Account Code" ,
	"ToBankAccount_AccountId" AS "ToBankAccount_AccountId" ,
	"ToBankAccount_Name" AS "To Bank Account Name",
	"Amount"  AS "Amount" ,
	"Date" AS "Date" ,
	"CurrencyRate" AS "Currency Rate" ,
	"FromBankTransactionID" AS "From Bank Transaction ID" ,
	"ToBankTransactionID" AS "To Bank Transaction ID" ,
	"HasAttachments" AS "Has Attachments" ,
	"CreatedDateUTC" AS "Created Date UTC" ,
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransfers
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_brandingthemes','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_brandingthemes
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_brandingthemes
as
SELECT 
   "BrandingThemeId" AS "Branding Theme ID",
	"Name" AS "Name",
	"SortOrder" AS "Sort Order",
	"CreatedDateUTC" AS "Created Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_BrandingThemes
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_contactgroups','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_contactgroups
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_contactgroups
as
SELECT 
	"Id" AS "ID",
	"ContactGroupId" AS "Contact Group ID",
	"Name" AS "Name",
	"Status" AS "Status",
	"Contact_ContactId" AS "Contact ID" ,
	"Contact_Name" AS "Contact Name" ,
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_ContactGroups
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_contacts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_contacts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_contacts
as
SELECT 
	"ContactId" AS "Contact ID",
	"Name" AS "Name",
	"AccountNumber" AS "Account Number",
	"ContactNumber" AS "Contact Number",
	"ContactStatus" AS "Contact Status",
	"FirstName" AS "First Name",
	"LastName" AS "Last Name",
	"EmailAddress" AS "Email Address",
	"SkypeUserName" AS "Skype User Name",
	"ContactPerson1_FirstName" AS "Contact Person 1 First Name" ,
	"ContactPerson1_LastName" AS "Contact Person 1 Last Name" ,
	"ContactPerson1_EmailAddress" AS "Contact Person 1 Email Address",
	"ContactPerson1_IncludeInEmails" AS "Contact Person 1 Include In Emails",
	"ContactPerson2_FirstName" AS "Contact Person 2 First Name",
	"ContactPerson2_LastName" AS "Contact Person 2 Last Name",
	"ContactPerson2_EmailAddress" AS "Contact Person 2 Email Address",
	"ContactPerson2_IncludeInEmails" AS "Contact Person 2_Include In Emails",
	"ContactPerson3_FirstName" AS "Contact Person 3 First Name",
	"ContactPerson3_LastName" AS "Contact Person 3 Last Name",
	"ContactPerson3_EmailAddress" AS "Contact Person 3 Email Address",
	"ContactPerson3_IncludeInEmails" AS "Contact Person 3 Include In Emails" ,
	"ContactPerson4_FirstName" AS "Contact Person 4 First Name" ,
	"ContactPerson4_LastName" AS "Contact Person 4 Last Name",
	"ContactPerson4_EmailAddress" AS "Contact Person 4 Email Address" ,
	"ContactPerson4_IncludeInEmails" AS "Contact Person 4 Include In Emails",
	"BankAccountDetails" AS "Bank Account Details",
	"TaxNumber" AS "Tax Number",
	"AccountsReceivableTaxType" AS "Accounts Receivable Tax Type" ,
	"AccountsPayableTaxType" AS "Accounts Payable Tax Type",
	"Street_AddressLine1" AS "Address Line 1",
	"Street_AddressLine2" AS "Address Line 2",
	"Street_AddressLine3" AS "Address Line 3",
	"Street_AddressLine4" AS "Address Line 4",
	"Street_City" AS "Suburb",
	"Street_Region" AS "Region",
	"Street_PostalCode" AS "Postal Code",
	"Street_Country" AS "Country",
	"Street_AttentionTo" AS "Street Attention To",
	"POBox_AddressLine1" AS "PO Box Address Line 1" ,
	"POBox_AddressLine2" AS "PO Box Address Line 2",
	"POBox_AddressLine3" AS "PO Box Address Line 3" ,
	"POBox_AddressLine4" AS "PO Box Address Line 4",
	"POBox_City" AS "PO Box City",
	"POBox_Region" AS "PO Box Region",
	"POBox_PostalCode" AS "PO Box Postal Code",
	"POBox_Country" AS "PO Box Country",
	"POBox_AttentionTo" AS "PO Box Attention To",
	"DDI_PhoneNumber" AS "DDI Phone Number" ,
	"DDI_PhoneAreaCode" AS "DDI Phone Area Code" ,
	"DDI_PhoneCountryCode" AS "DDI Phone Country Code",
	"Default_PhoneNumber" AS "Default Phone Number",
	"Default_PhoneAreaCode" AS "Default Phone Area Code",
	"Default_PhoneCountryCode" AS "Default Phone Country Code",
	"Fax_PhoneNumber" AS "Fax Phone Number",
	"Fax_PhoneAreaCode" AS "Fax Phone Area Code",
	"Fax_PhoneCountryCode" AS "Fax Phone Country Code",
	"Mobile_PhoneNumber" AS "Mobile Phone Number",
	"Mobile_PhoneAreaCode" AS "Mobile Phone Area Code",
	"Mobile_PhoneCountryCode" AS "Mobile Phone Country Code",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ContactGroupId" AS "Contact Group ID",
	"IsSupplier" AS "Is Supplier",
	"IsCustomer" AS "Is Customer",
	"DefaultCurrency" AS "Default Currency",
	"Website" AS "Website",
	"BrandingThemeId" AS "Branding Theme ID",
	"BrandingThemeName" AS "Branding Theme Name",
	"PurchasesDefaultAccountCode" AS "Purchases Default Account Code",
	"SalesDefaultAccountCode" AS "Sales Default Account Code",
	"BatchPayments_BankAccountNumber" AS "Batch Payments Bank Account Number" ,
	"BatchPayments_BankAccountName" AS "Batch Payments Bank Account Name",
	"BatchPayments_Details" AS "Batch Payments Details",
	"BatchPayments_Code" AS "Batch Payments Code",
	"BatchPayments_Reference" AS "Batch Payments Reference",
	"Discount" AS "Discount",
	"Balances_AccountsReceivable_Outstanding" AS "Balances Accounts Receivable Outstanding",
	"Balances_AccountsReceivable_Overdue" AS "Balances Accounts Receivable Overdue",
	"Balances_AccountsPayable_Outstanding" AS "Balances Accounts Payable Outstanding",
	"Balances_AccountsPayable_Overdue" AS "Balances Accounts Payable Overdue",
	"PaymentTerms_Bills_Day" AS "Payment Terms Bills Day",
	"PaymentTerms_Bills_Type" AS "Payment Terms Bills Type" ,
	"PaymentTerms_Sales_Day" AS "Payment Terms Sales Day" ,
	"PaymentTerms_Sales_Type" AS "Payment Terms Sales Type",
	"SalesTrackingCategory1_Name" AS "Sales Tracking Category 1 Name",
	"SalesTrackingOption1_Name" AS "Sales Tracking Option 1 Name",
	"SalesTrackingCategory2_Name" AS "Sales Tracking Category 2 Name",
	"SalesTrackingOption2_Name" AS "Sales Tracking Option 2 Name",
	"PurchaseTrackingCategory1_Name" AS "Purchase Tracking Category 1 Name",
	"PurchaseTrackingOption1_Name" AS "Purchase Tracking Option 1 Name",
	"PurchaseTrackingCategory2_Name" AS "Purchase Tracking Category 2 Name",
	"PurchaseTrackingOption2_Name" AS "Purchase Tracking Option 2 Name",
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"FullAddress" AS "Full Address",
	"RegionAddress" AS "Region Address" 
FROM (
	SELECT *, 
		Row_number() OVER(PARTITION BY "ContactId" ORDER BY ContactId) rn 
	FROM dbo.NEW_CLIENT1_XEROBLUE_Contacts
) t WHERE rn = 1
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_creditnotes','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotes
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotes
as
SELECT 
	"Id" AS "Credit Note Line ID",
	"CreditNoteId" AS "Credit Note ID" ,
	"CreditNoteNumber" AS "Credit Note Number",
	"Reference" AS "Reference",
	"Type" AS "Type",
	"Contact_ContactId" AS "Contact ID" ,
	"Contact_Name" AS "Contact Name",
	"Date" AS "Date",
	"Status" AS "Status",
	"LineAmountTypes" AS "Line Amount Types",
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code" ,
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount" ,
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name" ,
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID" ,
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItem_DiscountRate" AS "Discount Rate",
	"LineItemAggregate" AS "Line Item Aggregate",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax" ,
	"Total" AS "Total",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"CurrencyCode" AS "Currency Code",
	"FullyPaidOnDate" AS "Fully Paid On Date" ,
	"SentToContact" AS "Sent To Contact" ,
	"BrandingThemeId" AS "Branding Theme ID" ,
	"CurrencyRate" AS "Currency Rate",
	"RemainingCredit" AS "Remaining Credit" ,
	"Allocation1_AppliedAmount" AS "Allocation 1 Applied Amount",
	"Allocation1_Date" AS "Allocation 1 Date" ,
	"Allocation1_InvoiceId" AS "Allocation 1 Invoice ID" ,
	"Allocation1_InvoiceNumber" AS "Allocation 1 Invoice Number",
	"Allocation2_AppliedAmount" AS "Allocation 2 Applied Amount",
	"Allocation2_Date" AS "Allocation 2 Date" ,
	"Allocation2_InvoiceId" AS "Allocation 2 Invoice ID" ,
	"Allocation2_InvoiceNumber" AS "Allocation 2 Invoice Number",
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Allocation3_AppliedAmount" AS "Allocation 3 Applied Amount",
	"Allocation3_Date" AS "Allocation 3 Date" ,
	"Allocation3_InvoiceId" AS "Allocation 3 Invoice ID" ,
	"Allocation3_InvoiceNumber" AS "Allocation 3 Invoice Number",
	"Allocation4_AppliedAmount" AS "Allocation 4 Applied Amount",
	"Allocation4_Date" AS "Allocation 4 Date" ,
	"Allocation4_InvoiceId" AS "Allocation 4 Invoice ID" ,
	"Allocation4_InvoiceNumber" AS "Allocation 4 Invoice Number",
	"Allocation5_AppliedAmount" AS "Allocation 5 Applied Amount",
	"Allocation5_Date" AS "Allocation 5 Date" ,
	"Allocation5_InvoiceId" AS "Allocation 5 Invoice ID" ,
	"Allocation5_InvoiceNumber" AS "Allocation 5 Invoice Number",
	"Allocation6_AppliedAmount" AS "Allocation 6 Applied Amount",
	"Allocation6_Date" AS "Allocation 6 Date" ,
	"Allocation6_InvoiceId" AS "Allocation 6 Invoice ID" ,
	"Allocation6_InvoiceNumber" AS "Allocation 6 Invoice Number",
	"Allocation7_AppliedAmount" AS "Allocation 7 Applied Amount",
	"Allocation7_Date" AS "Allocation 7 Date" ,
	"Allocation7_InvoiceId" AS "Allocation 7 Invoice ID" ,
	"Allocation7_InvoiceNumber" AS "Allocation 7 Invoice Number",
	"Allocation8_AppliedAmount" AS "Allocation 8 Applied Amount",
	"Allocation8_Date" AS "Allocation 8 Date" ,
	"Allocation8_InvoiceId" AS "Allocation 8 Invoice ID" ,
	"Allocation8_InvoiceNumber" AS "Allocation 8 Invoice Number",
	"Allocation9_AppliedAmount" AS "Allocation 9 Applied Amount",
	"Allocation9_Date" AS "Allocation 9 Date" ,
	"Allocation9_InvoiceId" AS "Allocation 9 Invoice ID" ,
	"Allocation9_InvoiceNumber" AS "Allocation 9 Invoice Number",
	"Allocation10_AppliedAmount" AS "Allocation 10 Applied Amount",
	"Allocation10_Date" AS "Allocation 10 Date" ,
	"Allocation10_InvoiceId" AS "Allocation 10 Invoice ID" ,
	"Allocation10_InvoiceNumber" AS "Allocation 10 Invoice Number",
	"Allocation11_AppliedAmount" AS "Allocation 11 Applied Amount",
	"Allocation11_Date" AS "Allocation 11 Date" ,
	"Allocation11_InvoiceId" AS "Allocation 11 Invoice ID" ,
	"Allocation11_InvoiceNumber" AS "Allocation 11 Invoice Number",
	"Allocation12_AppliedAmount" AS "Allocation 12 Applied Amount",
	"Allocation12_Date" AS "Allocation 12 Date" ,
	"Allocation12_InvoiceId" AS "Allocation 12 Invoice ID" ,
	"Allocation12_InvoiceNumber" AS "Allocation 12 Invoice Number",
	"Allocation13_AppliedAmount" AS "Allocation 13 Applied Amount",
	"Allocation13_Date" AS "Allocation 13 Date" ,
	"Allocation13_InvoiceId" AS "Allocation 13 Invoice ID" ,
	"Allocation13_InvoiceNumber" AS "Allocation 13 Invoice Number",
	"Allocation14_AppliedAmount" AS "Allocation 14 Applied Amount",
	"Allocation14_Date" AS "Allocation 14 Date" ,
	"Allocation14_InvoiceId" AS "Allocation 14 Invoice ID" ,
	"Allocation14_InvoiceNumber" AS "Allocation 14 Invoice Number",
	"Allocation15_AppliedAmount" AS "Allocation 15 Applied Amount",
	"Allocation15_Date" AS "Allocation 15 Date" ,
	"Allocation15_InvoiceId" AS "Allocation 15 Invoice ID" ,
	"Allocation15_InvoiceNumber" AS "Allocation 15 Invoice Number",
	"AccountUID" AS "Account UID",
	"LineAmountCreditNoteCalculation" AS "Line Amount Credit Note Calculation",   
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
  	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation" 	
FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq
as
SELECT
	"CreditNoteId" AS "Credit Note ID", 
	"Id" AS "Credit Note Line ID",
	"CreditNoteNumber" AS "Credit Note Number",
	"Reference" AS "Reference",
	"Type" AS "Type",
	"Contact_ContactId" AS "Contact ID" ,
	"Contact_Name" AS "Contact Name",
	"Date" AS "Date",
	"Status" AS "Status",
	"LineAmountTypes" AS "Line Amount Types",
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code" ,
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount" ,
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name" ,
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID" ,
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItem_DiscountRate" AS "Discount Rate",
	"LineItemAggregate" AS "Line Item Aggregate",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax" ,
	"Total" AS "Total",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"CurrencyCode" AS "Currency Code",
	"FullyPaidOnDate" AS "Fully Paid On Date" ,
	"SentToContact" AS "Sent To Contact" ,
	"BrandingThemeId" AS "Branding Theme ID" ,
	"CurrencyRate" AS "Currency Rate",
	"RemainingCredit" AS "Remaining Credit" ,
	"Allocation1_AppliedAmount" AS "Allocation 1 Applied Amount",
	"Allocation1_Date" AS "Allocation 1 Date" ,
	"Allocation1_InvoiceId" AS "Allocation 1 Invoice ID" ,
	"Allocation1_InvoiceNumber" AS "Allocation 1 Invoice Number",
	"Allocation2_AppliedAmount" AS "Allocation 2 Applied Amount",
	"Allocation2_Date" AS "Allocation 2 Date" ,
	"Allocation2_InvoiceId" AS "Allocation 2 Invoice ID" ,
	"Allocation2_InvoiceNumber" AS "Allocation 2 Invoice Number",
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Allocation3_AppliedAmount" AS "Allocation 3 Applied Amount",
	"Allocation3_Date" AS "Allocation 3 Date" ,
	"Allocation3_InvoiceId" AS "Allocation 3 Invoice ID" ,
	"Allocation3_InvoiceNumber" AS "Allocation 3 Invoice Number",
	"Allocation4_AppliedAmount" AS "Allocation 4 Applied Amount",
	"Allocation4_Date" AS "Allocation 4 Date" ,
	"Allocation4_InvoiceId" AS "Allocation 4 Invoice ID" ,
	"Allocation4_InvoiceNumber" AS "Allocation 4 Invoice Number",
	"Allocation5_AppliedAmount" AS "Allocation 5 Applied Amount",
	"Allocation5_Date" AS "Allocation 5 Date" ,
	"Allocation5_InvoiceId" AS "Allocation 5 Invoice ID" ,
	"Allocation5_InvoiceNumber" AS "Allocation 5 Invoice Number",
	"Allocation6_AppliedAmount" AS "Allocation 6 Applied Amount",
	"Allocation6_Date" AS "Allocation 6 Date" ,
	"Allocation6_InvoiceId" AS "Allocation 6 Invoice ID" ,
	"Allocation6_InvoiceNumber" AS "Allocation 6 Invoice Number",
	"Allocation7_AppliedAmount" AS "Allocation 7 Applied Amount",
	"Allocation7_Date" AS "Allocation 7 Date" ,
	"Allocation7_InvoiceId" AS "Allocation 7 Invoice ID" ,
	"Allocation7_InvoiceNumber" AS "Allocation 7 Invoice Number",
	"Allocation8_AppliedAmount" AS "Allocation 8 Applied Amount",
	"Allocation8_Date" AS "Allocation 8 Date" ,
	"Allocation8_InvoiceId" AS "Allocation 8 Invoice ID" ,
	"Allocation8_InvoiceNumber" AS "Allocation 8 Invoice Number",
	"Allocation9_AppliedAmount" AS "Allocation 9 Applied Amount",
	"Allocation9_Date" AS "Allocation 9 Date" ,
	"Allocation9_InvoiceId" AS "Allocation 9 Invoice ID" ,
	"Allocation9_InvoiceNumber" AS "Allocation 9 Invoice Number",
	"Allocation10_AppliedAmount" AS "Allocation 10 Applied Amount",
	"Allocation10_Date" AS "Allocation 10 Date" ,
	"Allocation10_InvoiceId" AS "Allocation 10 Invoice ID" ,
	"Allocation10_InvoiceNumber" AS "Allocation 10 Invoice Number",
	"Allocation11_AppliedAmount" AS "Allocation 11 Applied Amount",
	"Allocation11_Date" AS "Allocation 11 Date" ,
	"Allocation11_InvoiceId" AS "Allocation 11 Invoice ID" ,
	"Allocation11_InvoiceNumber" AS "Allocation 11 Invoice Number",
	"Allocation12_AppliedAmount" AS "Allocation 12 Applied Amount",
	"Allocation12_Date" AS "Allocation 12 Date" ,
	"Allocation12_InvoiceId" AS "Allocation 12 Invoice ID" ,
	"Allocation12_InvoiceNumber" AS "Allocation 12 Invoice Number",
	"Allocation13_AppliedAmount" AS "Allocation 13 Applied Amount",
	"Allocation13_Date" AS "Allocation 13 Date" ,
	"Allocation13_InvoiceId" AS "Allocation 13 Invoice ID" ,
	"Allocation13_InvoiceNumber" AS "Allocation 13 Invoice Number",
	"Allocation14_AppliedAmount" AS "Allocation 14 Applied Amount",
	"Allocation14_Date" AS "Allocation 14 Date" ,
	"Allocation14_InvoiceId" AS "Allocation 14 Invoice ID" ,
	"Allocation14_InvoiceNumber" AS "Allocation 14 Invoice Number",
	"Allocation15_AppliedAmount" AS "Allocation 15 Applied Amount",
	"Allocation15_Date" AS "Allocation 15 Date" ,
	"Allocation15_InvoiceId" AS "Allocation 15 Invoice ID" ,
	"Allocation15_InvoiceNumber" AS "Allocation 15 Invoice Number",
	"AccountUID" AS "Account UID" 
FROM NEW_CLIENT1_XEROBLUE_UniqueCreditNotes
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_currencies','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_currencies
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_currencies
as
SELECT 
	"Code" AS "Code",
	"Description" AS "Description",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_Currencies
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_employees','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_employees
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_employees
as
SELECT 
	"EmployeeId" AS "Employee ID",
	"Status" AS "Status",
	"FirstName" AS "First Name" ,
	"LastName" AS "Last Name" ,
	"ExternalLink_URL" AS "External Link URL" ,
	"ExternalLink_Description" AS "External Link Description",
	"UpdatedDateUTC" AS "Updated Date UTC" ,
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_Employees
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_expenseclaims','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaims
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaims
as
SELECT 
	"ExpenseClaimId" AS "Expense Claim ID",
	"UserId" AS "User ID",
	"Status" AS "Status" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"Total" AS "Total",
	"AmountDue" AS "Amount Due",
	"AmountPaid" AS "Amount Paid",
	"PaymentDueDate" AS "Payment Due Date",
	"ReportingDate" AS "Reporting Date",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaims
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoices','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoices
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoices
as
SELECT
	"Id" AS "Invoice Line ID",
	"InvoiceId" AS "Invoice ID",
	"Type" AS "Type",
	"ContactId" AS "Contact ID",
	"ContactName" AS "Contact Name" ,
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Line Item - Description" ,
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 - Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name" ,
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat" ,
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 - Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"DiscountRate" AS "Discount Rate", 
	"DiscountRate%" AS "Discount Rate %",
	"LineItem_DiscountAmount" AS "Discount Amount" ,
	"LineItemAggregate" AS "Aggregate" ,
	"Date" AS "Date" ,
	"DueDate" AS "Due Date" ,
	"LineAmountTypes" AS "Line Amount Types",
	"InvoiceNumber" AS "Invoice Number" ,
	"Reference" AS "Reference" ,
	"BrandingThemeId" AS "Branding Theme ID",
	"URL" AS "URL" ,
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate" ,
	"Status" AS "Status",
	"SentToContact" AS "Sent To Contact",
	"ExpectedPaymentDate" AS "Expected Payment Date",
	"PlannedPaymentDate" AS "Planned Payment Date" ,
	"SubTotal" AS "Invoice - Sub Total" ,
	"TotalTax" AS "Invoice - Total Tax",
	"Total" AS "Invoice Total" ,
	"TotalDiscount" AS "Total Discount",
	"HasAttachments" AS "Has Attachments",
	"AmountDue" AS "Invoice - Amount Due",
	"AmountPaid" AS "Invoice - Amount Paid",
	"CISDeduction" AS "CIS Deduction",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"AmountCredited" AS "Amount Credited" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"CreditNotes" AS "Credit Notes",
	"Payments" AS "Payments",
	"Prepayments" AS "Pre Payments",
	"Overpayments" AS "Over Payments",
	"RepeatingInvoiceID" AS "Repeating Invoice ID",
	"Account_UID" AS "Account_UID",
	"PaymentIds" AS "Payment ID",
	"PrePaymentIds" AS "Pre Payment ID",
	"OverPaymentIds" AS "Over Payment ID",
	"CreditNoteIDs" AS "Credit Note ID",
	"LineAmountCalculation" AS "Line Amount Calculation",     
 	"LineAmountCalculationIncTax" AS "Line Amount Calculation Inc Tax",    	
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
 	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation",
	"DayDifference" AS "Day Difference"
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices
as
SELECT 
	"Id" AS "Invoice Line ID",
	"InvoiceId" AS "Invoice ID",
	"Type" AS "Type",
	"ContactId" AS "Contact ID",
	"ContactName" AS "Contact Name" ,
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Line Item - Description" ,
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 - Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name" ,
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat" ,
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 - Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"DiscountRate" AS "Discount Rate", 
	"DiscountRate%" AS "Discount Rate %",
	"LineItem_DiscountAmount" AS "Discount Amount" ,
	"LineItemAggregate" AS "Aggregate" ,
	"Date" AS "Date" ,
	"DueDate" AS "Due Date" ,
	"LineAmountTypes" AS "Line Amount Types",
	"InvoiceNumber" AS "Invoice Number" ,
	"Reference" AS "Reference" ,
	"BrandingThemeId" AS "Branding Theme ID",
	"URL" AS "URL" ,
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate" ,
	"Status" AS "Status",
	"SentToContact" AS "Sent To Contact",
	"ExpectedPaymentDate" AS "Expected Payment Date",
	"PlannedPaymentDate" AS "Planned Payment Date" ,
	"SubTotal" AS "Invoice - Sub Total" ,
	"TotalTax" AS "Invoice - Total Tax",
	"Total" AS "Invoice Total" ,
	"TotalDiscount" AS "Total Discount",
	"HasAttachments" AS "Has Attachments",
	"PaymentIds" AS "Payment ID",
	"PrePaymentIds" AS "Pre Payment ID",
	"OverPaymentIds" AS "Over Payment ID",
	"CreditNoteIDs" AS "Credit Note ID",
	"AmountDue" AS "Invoice - Amount Due",
	"AmountPaid" AS "Invoice - Amount Paid",
	"CISDeduction" AS "CIS Deduction",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"AmountCredited" AS "Amount Credited" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"CreditNotes" AS "Credit Notes",
	"Payments" AS "Payments",
	"Prepayments" AS "Pre Payments",
	"Overpayments" AS "Over Payments",
	"RepeatingInvoiceID" AS "Repeating Invoice ID",
	"Account_UID" AS "Account_UID" ,
	"DayDifference" AS "Day Difference" 
FROM NEW_CLIENT1_XEROBLUE_UniqueInvoices
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_items','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_items
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_items
as
SELECT 
	"ItemId" AS "Item ID",
	"Code" AS "Code",
	"InventoryAssetAccountCode" AS "Inventory Asset Account Code",
	"Name" AS "Name",
	"PurchaseDescription" AS "Purchase Description",
	"Description" AS "Description" ,
	"PurchaseDetails_UnitPrice" AS "Purchase Details - Unit Price",
	"PurchaseDetails_COGSAccountCode" AS "Purchase Details - COGS Account Code",
	"PurchaseDetails_AccountCode" AS "Purchase Details - Account Code" ,
	"PurchaseDetails_TaxType" AS "Purchase Details - Tax Type" ,
	"SalesDetails_UnitPrice" AS "Sales Details - Unit Price" ,
	"SalesDetails_COGSAccountCode" AS "Sales Details - COGS Account Code",
	"SalesDetails_AccountCode" AS "Sales Details - Account Code",
	"SalesDetails_TaxType" AS "Sales Details - Tax Type" ,
	"IsTrackedAsInventory" AS "Is Tracked As Inventory",
	"TotalCostPool" AS "Total Cost Pool" ,
	"QuantityOnHand" AS "Quantity On Hand" ,
	"IsSold" AS "Is Sold" ,
	"IsPurchased" AS "Is Purchased",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"CodeUID" AS "Code UID" ,
	"InventoryCodeUID" AS "Inventory Code UID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_Items
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journals','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journals
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journals
as
SELECT
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Split" AS "Split"
FROM dbo.NEW_CLIENT1_XEROBLUE_Journals
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalsCash','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCash
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCash
as
SELECT
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Split" AS "Split"
FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCash
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_payroll','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_payroll
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_payroll
as
SELECT 
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Split" AS "Split"
FROM dbo.NEW_CLIENT1_XEROBLUE_Journals WHERE SourceType in ('INTEGRATEDPAYROLLPE')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_linkedtransactions','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_linkedtransactions
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_linkedtransactions
as
SELECT 
	"LinkedTransactionID" AS "Linked Transaction ID",
	"SourceTransactionID" AS "Source Transaction ID",
	"SourceLineItemID" AS "Source Line Item ID" ,
	"SourceTransactionTypeCode" AS "Source Transaction Type Code",
	"ContactID" AS "Contact ID",
	"TargetTransactionID" AS "Target Transaction ID",
	"TargetLineItemID" AS "Target Line Item ID",
	"Status" AS "Status",
	"Type" AS "Type",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_LinkedTransactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_manualjournals','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_manualjournals
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_manualjournals
as
SELECT
	"Id" AS "ID",
	"ManualJournalId" AS "Manual Journal ID" ,
	"Narration" AS "Narration",
	"JournalLine_LineAmount" AS "Line Amount" ,
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_Description" AS "Description",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"JournalLine_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"JournalLine_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID" ,
	"JournalLine_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"JournalLine_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"JournalLine_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"JournalLine_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"JournalLine_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"JournalLine_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"JournalLine_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"JournalLineAggregate" AS "Journal Line Aggregate",
	"Date" AS "Date",
	"Status" AS "Status" ,
	"URL" AS "URL" ,
	"ShowOnCashBasisReports" AS "Show On Cash Basis Reports" ,
	"LineAmountTypes" AS "Line Amount Types",
	"UpdatedDateUTC" AS "Updated Date UTC" ,
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	ISNULL("JournalLine_AccountCode",'BLANK') + '-' + CAST("OrganisationID" AS varchar) AS "Account UID",
	CAST(
		CASE 
		WHEN ("LineAmountTypes" = 'Inclusive' OR "LineAmountTypes" = 'NoTax') THEN 0-([JournalLine_LineAmount])
		WHEN "LineAmountTypes" = 'Exclusive' AND ("JournalLine_TaxType" = 'INPUT' OR "JournalLine_TaxType" = 'OUTPUT' OR "JournalLine_TaxType" = 'CAPEXINPUT') THEN 0-([JournalLine_LineAmount]+([JournalLine_LineAmount]*0.1))
		WHEN "LineAmountTypes" = 'Exclusive' THEN 0-([JournalLine_LineAmount])
		ELSE 0 END AS decimal(15,4)
 	) AS "Manual Journal Cash Calculation"
FROM (
	SELECT *, 
		Row_number() OVER(PARTITION BY "Id" ORDER BY Id) rn 
	FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournals
	WHERE Status IN ('POSTED')
) t WHERE rn = 1
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_organisations','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_organisations
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_organisations
as
SELECT 
	"ShortCode" AS "Short Code",
	"APIKey" AS "API Key",
	"Name" AS "Name",
	"LegalName" AS "Legal Name",
	"PaysTax" AS "Pays Tax",
	"Version" AS "Version",
	"BaseCurrency" AS "Base Currency",
	"CountryCode" AS "Country Code",
	"IsDemoCompany" AS "Is Demo Company",
	"OrganisationStatus" AS "Organisation Status",
	"RegistrationNumber" AS "Registration Number" ,
	"TaxNumber" AS "Tax Number",
	"FinancialYearEndDay" AS "Financial Year End Day",
	"FinancialYearEndMonth" AS "Financial Year End Month",
	"PeriodLockDate" AS "Period Lock Date" ,
	"EndOfYearLockDate" AS "End Of Year Lock Date",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"OrganisationEntityType" AS "Organisation Entity Type",
	"Timezone" AS "Timezone",
	"Edition" AS "Edition",
	"Class" AS "Class",
	"LineOfBusiness" AS "Line Of Business",
	"Street_AddressLine1" AS "Street Address Line 1",
	"Street_AddressLine2" AS "Street Address Line 2",
	"Street_AddressLine3" AS "Street Address Line 3",
	"Street_AddressLine4" AS "Street Address Line 4",
	"Street_City" AS "Street City",
	"Street_PostalCode" AS "Street Postal Code",
	"Street_Country" AS "Street Country",
	"Street_Region" AS "Street Region" ,
	"Street_AttentionTo" AS "Street Attention To" ,
	"POBox_AddressLine1" AS "PO Box Address Line 1" ,
	"POBox_AddressLine2" AS "PO Box Address Line 2",
	"POBox_AddressLine3" AS "PO Box Address Line 3",
	"POBox_AddressLine4" AS "PO Box Address Line 4",
	"POBox_City" AS "PO Box City",
	"POBox_PostalCode" AS "PO Box Postal Code" ,
	"POBox_Country" AS "PO Box Country" ,
	"POBox_Region" AS "PO Box Region",
	"POBox_AttentionTo" AS "PO Box Attention To",
	"DDI_PhoneNumber" AS "DDI Phone Number" ,
	"DDI_PhoneAreaCode" AS "DDI Phone Area Code",
	"DDI_PhoneCountryCode" AS "DDI Phone Country Code",
	"Default_PhoneNumber" AS "Default Phone Number",
	"Default_PhoneAreaCode" AS "Default Phone Area Code",
	"Default_PhoneCountryCode" AS "Default Phone Country Code" ,
	"Fax_PhoneNumber" AS "Fax Phone Number",
	"Fax_PhoneAreaCode" AS "Fax Phone Area Code" ,
	"Fax_PhoneCountryCode" AS "Fax Phone Country Code",
	"Mobile_PhoneNumber" AS "Mobile Phone Number" ,
	"Mobile_PhoneAreaCode" AS "Mobile Phone Area Code",
	"Mobile_PhoneCountryCode" AS "Mobile Phone Country Code" ,
	"Facebook_URL" AS "Facebook URL",
	"Twitter_URL" AS "Twitter URL" ,
	"GooglePlus_URL" AS "GooglePlus URL" ,
	"LinkedIn_URL" AS "LinkedIn URL",
	"Website_URL" AS "Website URL",
	"PaymentTerms_Bills_Day" AS "Payment Terms Bills Day",
	"PaymentTerms_Bills_Type" AS "Payment Terms Bills Type" ,
	"PaymentTerms_Sales_Day" AS "Payment Terms Sales Day",
	"PaymentTerms_Sales_Type" AS "Payment Terms Sales Type" ,
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_overpayments','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_overpayments
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_overpayments
as
SELECT 
	"OverpaymentId" AS "Overpayment ID",
	"Date" AS "Date",
	"Type" AS "Type",
	"RemainingCredit" AS "Remaining Credit",
	"Contact_ContactId" AS "Contact ID",
	"Contact_Name" AS "Contact Name",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total" ,
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Description" ,
	"LineItem_Quantity" AS "Quantity" ,
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code" ,
	"LineItem_TaxType" AS "Tax Type",
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount" ,
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name" ,
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItem_DiscountRate" AS "Discount Rate" ,
	"LineAmountTypes" AS "Line Amount Types" ,
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"Allocation1_AppliedAmount" AS "Allocation 1 Applied Amount" ,
	"Allocation1_Date" AS "Allocation 1 Date" ,
	"Allocation1_InvoiceId" AS "Allocation 1 Invoice ID",
	"Allocation1_InvoiceNumber" AS "Allocation 1 Invoice Number",
	"Allocation2_AppliedAmount" AS "Allocation 2 Applied Amount",
	"Allocation2_Date" AS "Allocation 2 Date" ,
	"Allocation2_InvoiceId" AS "Allocation 2 Invoice ID",
	"Allocation2_InvoiceNumber" AS "Allocation 2 Invoice Number" ,
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" ,
	"Allocation3_AppliedAmount" AS "Allocation 3 Applied Amount",
	"Allocation3_Date" AS "Allocation 3 Date" ,
	"Allocation3_InvoiceId" AS "Allocation 3 Invoice ID" ,
	"Allocation3_InvoiceNumber" AS "Allocation 3 Invoice Number" ,
	"Allocation4_AppliedAmount" AS "Allocation 4 Applied Amount",
	"Allocation4_Date" AS "Allocation 4 Date",
	"Allocation4_InvoiceId" AS "Allocation 4 Invoice ID",
	"Allocation4_InvoiceNumber" AS "Allocation 4 Invoice Number" ,
	"Allocation5_AppliedAmount" AS "Allocation 5 Applied Amount",
	"Allocation5_Date" AS "Allocation 5 Date" ,
	"Allocation5_InvoiceId" AS "Allocation 5 Invoice ID" ,
	"Allocation5_InvoiceNumber" AS "Allocation 5 Invoice Number" ,
	"Allocation6_AppliedAmount" AS "Allocation 6 Applied Amount",
	"Allocation6_Date" AS "Allocation 6 Date" ,
	"Allocation6_InvoiceId" AS "Allocation 6 Invoice ID" ,
	"Allocation6_InvoiceNumber" AS "Allocation 6 Invoice Number" ,
	"Allocation7_AppliedAmount" AS "Allocation 7 Applied Amount",
	"Allocation7_Date" AS "Allocation 7 Date",
	"Allocation7_InvoiceId" AS "Allocation 7 Invoice ID",
	"Allocation7_InvoiceNumber" AS "Allocation 7 Invoice Number" ,
	"Allocation8_AppliedAmount" AS "Allocation 8 Applied Amount",
	"Allocation8_Date" AS "Allocation 8 Date" ,
	"Allocation8_InvoiceId" AS "Allocation 8 Invoice ID" ,
	"Allocation8_InvoiceNumber" AS "Allocation 8 Invoice Number" ,
	"Allocation9_AppliedAmount" AS "Allocation 9 Applied Amount",
	"Allocation9_Date" AS "Allocation 9 Date",
	"Allocation9_InvoiceId" AS "Allocation 9 Invoice ID",
	"Allocation9_InvoiceNumber" AS "Allocation 9 Invoice Number" ,
	"Allocation10_AppliedAmount" AS "Allocation 10 Applied Amount",
	"Allocation10_Date" AS "Allocation 10 Date" ,
	"Allocation10_InvoiceId" AS "Allocation 10 Invoice ID" ,
	"Allocation10_InvoiceNumber" AS "Allocation 10 Invoice Number" ,
	"Payments" AS "Payments",
	"LineItem_AccountCode" + '-' + CAST("OrganisationID" AS varchar) AS "Account UID",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation1_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation1_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 1 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation2_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation2_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 2 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation3_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation3_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 3 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation4_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation4_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 4 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation5_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation5_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 5 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation6_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation6_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 6 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation7_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation7_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 7 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation8_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation8_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 8 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation9_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation9_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 9 Calculated Amount",
	CAST(
		CASE 
		WHEN Type = 'RECEIVE-OVERPAYMENT' THEN (0-("SubTotal")*("Allocation10_AppliedAmount"/"Total"))
		WHEN Type = 'SPEND-OVERPAYMENT' THEN (([SubTotal])*("Allocation10_AppliedAmount"/"Total"))
		WHEN Type IS NULL THEN 0 ELSE 0 END AS decimal(15,4)
	) AS "Overpayment Allocation 10 Calculated Amount"
FROM dbo.NEW_CLIENT1_XEROBLUE_Overpayments WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_payments','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_payments
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_payments
as
SELECT
	"PaymentId" AS "Payment ID",
	"Date" AS "Date",
	"Amount" AS "Amount",
	"CurrencyRate" AS "Currency Rate",
	"Reference" AS "Reference",
	"PaymentType" AS "Payment Type",
	"Status" AS "Status",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"IsReconciled" AS "Is Reconciled" ,
	"BatchPaymentId" AS "Batch Payment ID" ,
	"InvoiceId" AS "Invoice ID" ,
	"InvoiceNumber" AS "Invoice Number",
	"CreditNoteId" AS "Credit Note ID" ,
	"CreditNoteNumber" AS "Credit Note Number",
	"AccountId" AS "Account ID",
	"AccountCode" AS "Account Code",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM (
	SELECT *, 
		Row_number() OVER(PARTITION BY "PaymentId" ORDER BY PaymentId) rn 
	FROM dbo.NEW_CLIENT1_XEROBLUE_Payments
	WHERE Status in ('AUTHORISED')
) t WHERE rn = 1
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_prepayments','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_prepayments
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_prepayments
as
SELECT 
	"PrepaymentId" AS "Prepayment ID",
	"Date" AS "Date" ,
	"Reference" AS "Reference" ,
	"Type" AS "Type",
	"RemainingCredit" AS "Remaining Credit",
	"Contact_ContactId" AS "Contact ID",
	"Contact_Name" AS "Contact Name" ,
	"Status" AS "Status" ,
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax" ,
	"Total" AS "Total",
	"LineItems" AS "Line Items",
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code" ,
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat" ,
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"LineItem_DiscountRate" AS "Discount Rate" ,
	"LineAmountTypes" AS "Line Amount Types" ,
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"Allocation1_AppliedAmount" AS "Allocation 1 Applied Amount",
	"Allocation1_Date" AS "Allocation 1 Date" ,
	"Allocation1_InvoiceId" AS "Allocation 1 Invoice ID",
	"Allocation1_InvoiceNumber" AS "Allocation 1 Invoice Number",
	"Allocation2_AppliedAmount" AS "Allocation 2 Applied Amount",
	"Allocation2_Date" AS "Allocation 2 Date",
	"Allocation2_InvoiceId" AS "Allocation 2 Invoice ID" ,
	"Allocation2_InvoiceNumber" AS "Allocation 2 Invoice Number",
	"HasAttachments" AS "Has Attachments",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" ,
	"Allocation3_AppliedAmount" AS "Allocation 3 Applied Amount" ,
	"Allocation3_Date" AS "Allocation 3 Date",
	"Allocation3_InvoiceId" AS "Allocation 3 Invoice ID",
	"Allocation3_InvoiceNumber" AS "Allocation 3 Invoice Number" ,
	"Allocation4_AppliedAmount" AS "Allocation 4 Applied Amount",
	"Allocation4_Date" AS "Allocation 4 Date",
	"Allocation4_InvoiceId" AS "Allocation 4 Invoice ID",
	"Allocation4_InvoiceNumber" AS "Allocation 4 Invoice Number",
	"Allocation5_AppliedAmount" AS "Allocation 5 Applied Amount",
	"Allocation5_Date" AS "Allocation 5 Date",
	"Allocation5_InvoiceId" AS "Allocation 5 Invoice ID" ,
	"Allocation5_InvoiceNumber" AS "Allocation 5 Invoice Number",
	"Allocation6_AppliedAmount" AS "Allocation 6 Applied Amount" ,
	"Allocation6_Date" AS "Allocation 6 Date",
	"Allocation6_InvoiceId" AS "Allocation 6 Invoice ID",
	"Allocation6_InvoiceNumber" AS "Allocation 6 Invoice Number" ,
	"Allocation7_AppliedAmount" AS "Allocation 7 Applied Amount",
	"Allocation7_Date" AS "Allocation 7 Date",
	"Allocation7_InvoiceId" AS "Allocation 7 Invoice ID",
	"Allocation7_InvoiceNumber" AS "Allocation 7 Invoice Number",
	"Allocation8_AppliedAmount" AS "Allocation 8 Applied Amount",
	"Allocation8_Date" AS "Allocation 8 Date",
	"Allocation8_InvoiceId" AS "Allocation 8 Invoice ID" ,
	"Allocation8_InvoiceNumber" AS "Allocation 8 Invoice Number",
	"Allocation9_AppliedAmount" AS "Allocation 9 Applied Amount",
	"Allocation9_Date" AS "Allocation 9 Date",
	"Allocation9_InvoiceId" AS "Allocation 9 Invoice ID",
	"Allocation9_InvoiceNumber" AS "Allocation 9 Invoice Number",
	"Allocation10_AppliedAmount" AS "Allocation 10 Applied Amount",
	"Allocation10_Date" AS "Allocation 10 Date",
	"Allocation10_InvoiceId" AS "Allocation 10 Invoice ID" ,
	"Allocation10_InvoiceNumber" AS "Allocation 10 Invoice Number",
	"Payments" AS "Payments",
	"LineItem_AccountCode" + '-' + CAST("OrganisationID" AS varchar) AS "Account UID"
FROM dbo.NEW_CLIENT1_XEROBLUE_Prepayments WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_purchaseorders','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_purchaseorders
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_purchaseorders
as
SELECT 
	"Id" AS "ID",
	"PurchaseOrderId" AS "Purchase Order ID" ,
	"PurchaseOrderNumber" AS "Purchase Order Number",
	"Reference" AS "Reference" ,
	"Type" AS "Type",
	"Contact_ContactId" AS "Contact ID",
	"Contact_Name" AS "Contact Name",
	"DeliveryDate" AS "Delivery Date" ,
	"Date" AS "Date" ,
	"Status" AS "Status" ,
	"LineAmountTypes" AS "Line Amount Types" ,
	"LineItem_LineItemId" AS "Line Item ID" ,
	"LineItem_Description" AS "Description",
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code" ,
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount" ,
	"LineItem_DiscountRate" AS "Discount Rate",
	"LineItemAggregate" AS "Aggregate",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total" ,
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat" ,
	"UpdatedDateUTC" AS "Updated Date UTC" ,
	"HasAttachments" AS "Has Attachments" ,
	"CurrencyCode" AS "Currency Code",
	"BrandingThemeId" AS "Branding Theme ID",
	"CurrencyRate" AS "Currency Rate",
	"TotalDiscount" AS "Total Discount",
	"SentToContact" AS "Sent To Contact",
	"Telephone" AS "Telephone",
	"IsDiscounted" AS "Is Discounted",
	"ExpectedArrivalDate" AS "Expected Arrival Date",
	"DeliveryInstructions" AS "Delivery Instructions",
	"DeliveryAddress" AS "Delivery Address",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrders
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_receipts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_receipts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_receipts
as
SELECT 
	"Id" AS "ID",
	"ReceiptId" AS "Receipt ID" ,
	"Date" AS "Date" ,
	"Contact_ContactId" AS "Contact ID",
	"Contact_Name" AS "Contact Name",
	"LineItem_Description" AS "Description",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_Quantity" AS "Quantity" ,
	"LineItem_TaxType" AS "Tax Type",
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name" ,
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name" ,
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat" ,
	"LineItem_DiscountRate" AS "Discount Rate",
	"LineItemAggregate" AS "Aggregate",
	"User_UserId" AS "User ID",
	"Reference" AS "Reference" ,
	"LineAmountTypes" AS "Line Amount Types",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"Status" AS "Status" ,
	"ReceiptNumber" AS "Receipt Number" ,
	"UpdatedDateUTC" AS "Updated Date UTC" ,
	"HasAttachments" AS "Has Attachments",
	"URL" AS "URL",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID"  
FROM dbo.NEW_CLIENT1_XEROBLUE_Receipts
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_repeatinginvoices','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_repeatinginvoices
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_repeatinginvoices
as
SELECT  
	"Id" AS "ID",
	"RepeatingInvoiceId" AS "Repeating Invoice ID",
	"Type" AS "Type" ,
	"ContactId" AS "Contact ID" ,
	"ContactName" AS "Contact Name",
	"Schedule_Period" AS "Schedule Period"  ,
	"Schedule_Unit" AS "Schedule Unit" ,
	"Schedule_DueDate" AS "Schedule Due Date",
	"Schedule_DueDateType" AS "Schedule Due Date Type" ,
	"Schedule_StartDate" AS "Schedule Start Date" ,
	"Schedule_NextScheduledDate" AS "Schedule Next Scheduled Date" ,
	"Schedule_EndDate" AS "Schedule End Date" ,
	"LineItem_LineItemId" AS "Line Item ID" ,
	"LineItem_Description" AS "Description" ,
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount",
	"LineItem_ItemCode" AS "Item Code" ,
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount",
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID" ,
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name" ,
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID" ,
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name" ,
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat"  ,
	"LineItem_DiscountRate" AS "Discount Rate",
	"LineAmountTypes" AS "Line Amount Types" ,
	"Reference" AS "Reference",
	"BrandingThemeId" AS "Branding Theme ID" ,
	"CurrencyCode" AS "Currency Code",
	"Status" AS "Status" ,
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax" ,
	"Total" AS "Total",
	"HasAttachments" AS "Has Attachments",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_RepeatingInvoices
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_taxrates','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_taxrates
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_taxrates
as
SELECT  
	"Id" AS "ID",
	"TaxType" AS "Tax Type" ,
	"Name" AS "Name",
	"TaxComponent_Name" AS "Tax Component Name" ,
	"TaxComponent_Rate" AS "Tax Component Rate",
	"TaxComponents_IsNonRecoverable" AS "Tax Components Is Non Recoverable",
	"TaxComponent_IsCompound" AS "Tax Component Is Compound" ,
	"TaxComponentAggregate" AS "Tax Component Aggregate" ,
	"Status" AS "Status" ,
	"ReportTaxType" AS "Report Tax Type",
	"CanApplyToAssets" AS "Can Apply To Assets",
	"CanApplyToEquity" AS "Can Apply To Equity",
	"CanApplyToExpenses" AS "Can Apply To Expenses",
	"CanApplyToLiabilities" AS "Can Apply To Liabilities",
	"CanApplyToRevenue" AS "Can Apply To Revenue",
	"DisplayTaxRate" AS "Display Tax Rate",
	"EffectiveRate" AS "Effective Rate",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_TaxRates
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_trackingcategories','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_trackingcategories
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_trackingcategories
as
SELECT 
	"Id" AS "ID",
	"TrackingCategoryId" AS "Tracking Category ID",
	"Name" AS "Name" ,
	"Status" AS "Status",
	"TrackingOptionId" AS "Tracking Option ID" ,
	"OptionName" AS "Option Name",
	"OptionStatus" AS "Option Status",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID"
FROM (
	SELECT *, 
	Row_number() OVER(PARTITION BY "TrackingCategoryId","OptionName","OrganisationID" ORDER BY Id) rn 
	FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategories
	WHERE Status in ('ACTIVE')
) t WHERE rn = 1
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_trialbalance','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_trialbalance
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_trialbalance
as
SELECT 
	"ID" AS "ID",
	"Date" AS "Date",
	"Title" AS "Title",
	"Account" AS "Account",
	"Debit" AS "Debit" ,
	"Credit" AS "Credit" ,
	"YTDDebit" AS "YTD Debit" ,
	"YTDCredit" AS "YTD Credit",
	"AccountId" AS "Account ID" ,
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_TrialBalance
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_users','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_users
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_users
as
SELECT 
	"UserId" AS "User ID" ,
	"FirstName" AS "First Name",
	"LastName" AS "Last Name" ,
	"EmailAddress" AS "Email Address",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"IsSubscriber" AS "Is Subscriber" ,
	"OrganisationRole" AS "Organisation Role",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_Users
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2018fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2018fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2018fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2019fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2019fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2019fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2020fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2020fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2020fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2021fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2021fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2021fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2022fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2022fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2022fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2023fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2023fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2023fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2024fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2024fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2024fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2025fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2025fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2025fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary2026fy','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2026fy
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary2026fy
as
SELECT *
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY_view
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummaryInterim','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummaryInterim
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummaryInterim
AS
    SELECT 
        [ID],
        [Title],
        [AccountId],
        [BankAccount],
        [ClientID],
        [OrganisationID],
        [FinancialYear],
        [AccountName_UID],
        [Amount],
        [Month],
        [Amount_AUD],
        [Amount_USD],
        [Amount_NZD],
        [Amount_EUR],
        [Amount_GBP]
    FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary
as
SELECT 
	[ID],
    [Title],
    [AccountId],
    [BankAccount],
    [ClientID],
    [OrganisationID],
    [FinancialYear],
    [AccountName_UID],
    [Amount],
    [Month],
    [Amount_AUD],
    [Amount_USD],
    [Amount_NZD],
    [Amount_EUR],
    [Amount_GBP],
	"TotalAmount" AS "Total Amount"
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
AS
SELECT 
	CreditNoteId, 
	Allocation1_AppliedAmount ,
	Allocation1_Date,
	Allocation1_InvoiceId,
	Allocation2_AppliedAmount,
	Allocation2_Date,
	Allocation2_InvoiceId,
	ClientId, OrganisationId,
	Allocation3_AppliedAmount,
	Allocation3_Date,
	Allocation3_InvoiceId,
	Allocation4_AppliedAmount,
	Allocation4_Date,
	Allocation4_InvoiceId,
	Allocation5_AppliedAmount,
	Allocation5_Date,
	Allocation5_InvoiceId,
	Allocation6_AppliedAmount,
	Allocation6_Date,
	Allocation6_InvoiceId,
	Allocation7_AppliedAmount,
	Allocation7_Date,
	Allocation7_InvoiceId,
	Allocation8_AppliedAmount,
	Allocation8_Date,
	Allocation8_InvoiceId,
	Allocation9_AppliedAmount,
	Allocation9_Date,
	Allocation9_InvoiceId,
	Allocation10_AppliedAmount,
	Allocation10_Date,
	Allocation10_InvoiceId,
	Allocation11_AppliedAmount,
	Allocation11_Date,
	Allocation11_InvoiceId,
	Allocation12_AppliedAmount,
	Allocation12_Date,
	Allocation12_InvoiceId,
	Allocation13_AppliedAmount,
	Allocation13_Date,
	Allocation13_InvoiceId,
	Allocation14_AppliedAmount,
	Allocation14_Date,
	Allocation14_InvoiceId,
	Allocation15_AppliedAmount,
	Allocation15_Date,
	Allocation15_InvoiceId
FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueCreditNotes
GO



/*************************************Duplicate views for below calcs ************************************/



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
as
SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_Overpayments WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
as
SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_Prepayments WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal
as
SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal
as
SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_Payments WHERE Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
as
SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes WHERE Status in ('AUTHORISED', 'PAID')
GO


/*************************************Allocation views************************************/


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation
as
SELECT I.*,
	a.InvoiceId OverPaymentInvoiceId,
	OverPaymentId,
	Allocation OverPaymentAllocation,
	Dt OverPaymentDate,
	Amount OverPaymentAmount
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I 
INNER JOIN 
(
	SELECT 
		OrganisationId,
		OverpaymentId,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId,
		OverpaymentId,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId,
		OverpaymentId,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId,
		OverpaymentId,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation5_AppliedAmount IS not NULL

	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation6_InvoiceId AS InvoiceId,
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		OverpaymentId,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation10_AppliedAmount IS not NULL
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.OrganisationId
WHERE I.Status in ('AUTHORISED', 'PAID')
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation
as
SELECT I.*,
	a.InvoiceId PrePaymentInvoiceId,
	PrePaymentId,
	Allocation PrePaymentAllocation,
	Dt PrePaymentDate,
	Amount PrePaymentAmount,
	CAST(I."OrganisationID" AS VARCHAR) + I."LineItem_AccountCode" AS "Account UID" 
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I 
INNER JOIN 
(
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId,
		PrepaymentId,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation5_AppliedAmount IS not NULL

	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation6_InvoiceId AS InvoiceId,
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		PrepaymentId,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT OrganisationId, PrepaymentId,Allocation10_InvoiceId AS InvoiceId,10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation10_AppliedAmount IS not null
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.OrganisationId
WHERE I.Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation
as
SELECT I.*,
	a.InvoiceId CreditNoteInvoiceId,
	CreditNoteId,
	Allocation CreditNoteAllocation,
	Dt CreditNoteDate,
	Amount CreditNoteAmount
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I 
INNER JOIN 
(
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation6_InvoiceId AS InvoiceId, 
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation6_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation7_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation8_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation9_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation10_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation11_InvoiceId AS InvoiceId,
		11 Allocation,
		Allocation11_Date AS Dt,
		Allocation11_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation11_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation12_InvoiceId AS InvoiceId,
		12 Allocation,
		Allocation12_Date AS Dt,
		Allocation12_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation12_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation13_InvoiceId AS InvoiceId,
		13 Allocation,
		Allocation13_Date AS Dt,
		Allocation13_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation13_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation14_InvoiceId AS InvoiceId,
		14 Allocation,
		Allocation14_Date AS Dt,
		Allocation14_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation14_AppliedAmount IS not null
	UNION
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation15_InvoiceId AS InvoiceId,
		15 Allocation,
		Allocation15_Date AS Dt,
		Allocation15_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes
	WHERE Allocation15_AppliedAmount IS not null
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.OrganisationId
WHERE I.Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations
as
SELECT I.*,
	CA.CreditNoteInvoiceId, 
	ca.CreditNoteAllocation, 
	ca.CreditNoteAmount, 
	ca.CreditNoteDate,
	ISNULL(ca."LineItem_DiscountRate", 0) AS "Discount Rate", 
	ISNULL(ca."LineItem_DiscountRate" * 0.01, 0) AS "Discount Rate %",
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
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(opa.[OverPaymentAmount]/I.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "OP Allocation Amount",  
	CAST(
		CASE 
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "PP Allocation Amount",   	
	CAST(
		CASE 
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]-I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "CN Allocation Amount",   
 		CAST(
		CASE 
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(opa.[OverPaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(opa.[OverPaymentAmount]/I.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "OP Allocation Amount Inc Tax",  
	CAST(
		CASE 
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ppa.[PrePaymentAmount]/I.[Total]))
   ELSE 0 END AS decimal(15,4)
 		) AS "PP Allocation Amount Inc Tax",   	
	CAST(
		CASE 
   		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
		WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "CN Allocation Amount Inc Tax"	
FROM NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal I
	LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation ca
		ON I.InvoiceId = ca.InvoiceId and I.LineItem_LineItemId = ca.LineItem_LineItemId
	LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation PPA
		ON I.InvoiceId = PPA.InvoiceId and I.LineItem_LineItemId = PPA.LineItem_LineItemId
	LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation OPA
		ON I.InvoiceId = OPA.InvoiceId and I.LineItem_LineItemId = OPA.LineItem_LineItemId
WHERE CA.InvoiceId IS NOT NULL OR PPA.InvoiceId IS NOT NULL  OR OPA.InvoiceId IS NOT NULL AND I.Status in ('AUTHORISED', 'PAID')
GO



/*************************************Cash flow views************************************/


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash
AS
SELECT I.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.PaymentType,
	P.Status PaymentStatus,
	ISNULL(I."LineItem_DiscountRate", 0) AS "Discount Rate", 
	ISNULL(I."LineItem_DiscountRate" * 0.01, 0) AS "Discount Rate %",
	CAST(
		CASE 
		WHEN I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"-I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"-I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount",
 	CAST(
		CASE 
		WHEN I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount Inc Tax"	   
FROM NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal I
	INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal P ON I.InvoiceId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('ACCRECPAYMENT','ACCPAYPAYMENT') AND I.Status in ('AUTHORISED', 'PAID') AND P.Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash
AS
SELECT PP.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.PaymentType,
	P.Status PaymentStatus,
	P.AccountId PaymentAccountID,
	ISNULL(PP."LineItem_AccountCode",'BLANK') + '-' + CAST(PP."OrganisationID" AS varchar) AS "Account UID" ,
	CAST(
		CASE 
   		WHEN PP."LineAmountTypes" = 'Inclusive' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL  THEN (PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."LineAmountTypes" = 'NoTax' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN (PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."LineAmountTypes" = 'Inclusive' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."LineAmountTypes" = 'NoTax' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total]*(P.[Amount]/PP.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Prepayments Calculated Amount"  
FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal PP
	INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal P ON PP.PrePaymentId = P.InvoiceId
WHERE UPPER(p.PaymentType) IN ('ARPREPAYMENTPAYMENT','APPREPAYMENTPAYMENT') AND PP.Status IN ('AUTHORISED', 'PAID') AND P.Status IN ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash
AS
SELECT OP.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.PaymentType,
	P.Status PaymentStatus,
	P.AccountId PaymentAccountID,
	OP."LineItem_AccountCode" + '-' + CAST(OP."OrganisationID" AS varchar) AS "Account_UID" ,
	CAST(
		CASE 
   		WHEN OP."LineAmountTypes" = 'Inclusive' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL  THEN (OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."LineAmountTypes" = 'NoTax' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN (OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."LineAmountTypes" = 'Inclusive' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."LineAmountTypes" = 'NoTax' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total]*(P.[Amount]/OP.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Overpayments Calculated Amount"  
FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal OP
	INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal P ON OP.OverPaymentId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('APOVERPAYMENTPAYMENT','AROVERPAYMENTPAYMENT') AND OP.Status IN ('AUTHORISED', 'PAID') AND P.Status IN ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash
AS
SELECT c.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.PaymentType,
	P.Status PaymentStatus,
	c."LineItem_AccountCode" + '-' + CAST(c."OrganisationID" AS varchar) AS "Account UID" ,
	CAST(
		CASE 
   		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN 0-(c.[LineItem_LineAmount]*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN 0-((c.[LineItem_LineAmount]-c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN (c.[LineItem_LineAmount]*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN ((c.[LineItem_LineAmount]-c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Credit Note Allocation Calculated Amount"  ,
	CAST(
		CASE 
   		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN 0-((c.[LineItem_LineAmount]+c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN 0-((c.[LineItem_LineAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN ((c.[LineItem_LineAmount]+c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN ((c.[LineItem_LineAmount])*(P.[Amount]/c.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Credit Note Allocation Calculated Amount Inc Tax" 
FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal c
	INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal P ON c.CreditNoteId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('APCREDITPAYMENT','ARCREDITPAYMENT') AND c.Status in ('AUTHORISED', 'PAID') AND P.Status in ('AUTHORISED')
GO



/*************************************Allocations NOT on Invoices side ************************************/


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations
AS
SELECT *,
	ISNULL("LineItem_AccountCode",'BLANK') + '-' + CAST("OrganisationID" AS varchar) AS "Account UID" ,
	CAST(
		CASE 
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount]-[LineItem_TaxAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount]-[LineItem_TaxAmount])*([Amount]/[Total]))
		ELSE 0 END AS decimal(15,4)
	) AS "Credit Note Allocation Calculated Amount",
	CAST(
		CASE 
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount]+[LineItem_TaxAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount]+[LineItem_TaxAmount])*([Amount]/[Total]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount])*([Amount]/[Total]))
		ELSE 0 END AS decimal(15,4)
	) AS "Credit Note Allocation Calculated Amount Inc Tax"  
FROM (
	SELECT Id ,
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
		Allocation1_InvoiceId AS InvoiceId, 1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		Allocation2_InvoiceId AS InvoiceId,2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation3_InvoiceId AS InvoiceId,3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation4_InvoiceId AS InvoiceId,4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
	RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation5_InvoiceId AS InvoiceId,5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation6_InvoiceId AS InvoiceId, 6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation6_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation7_InvoiceId AS InvoiceId,7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation7_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation8_InvoiceId AS InvoiceId,8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation8_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation9_InvoiceId AS InvoiceId,9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation9_AppliedAmount IS not null
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation10_InvoiceId AS InvoiceId,10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation10_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation11_InvoiceId AS InvoiceId,11 Allocation,
		Allocation11_Date AS Dt,
		Allocation11_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation11_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation12_InvoiceId AS InvoiceId,12 Allocation,
		Allocation12_Date AS Dt,
		Allocation12_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation12_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation13_InvoiceId AS InvoiceId,13 Allocation,
		Allocation13_Date AS Dt,
		Allocation13_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation13_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation14_InvoiceId AS InvoiceId,14 Allocation,
		Allocation14_Date AS Dt,
		Allocation14_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation14_AppliedAmount IS not NULL
	UNION
	SELECT Id ,
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
		RemainingCredit,  HasAttachments,ClientID,OrganisationID,Allocation15_InvoiceId AS InvoiceId,15 Allocation,
		Allocation15_Date AS Dt,
		Allocation15_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal
	WHERE Allocation15_AppliedAmount IS not null
) a
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation
as
SELECT *,
 	ISNULL("LineItem_AccountCode",'BLANK') + '-' + CAST("OrganisationID" AS varchar) AS "Account UID" 
FROM (
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation1_InvoiceId AS InvoiceId, 1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation2_InvoiceId AS InvoiceId,2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation3_InvoiceId AS InvoiceId,3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation4_InvoiceId AS InvoiceId,4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation5_InvoiceId AS InvoiceId,5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation6_InvoiceId AS InvoiceId,6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation7_InvoiceId AS InvoiceId,7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation8_InvoiceId AS InvoiceId,8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation9_InvoiceId AS InvoiceId,9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode" ,
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC" ,
		"HasAttachments",
		"Payments",
		"ClientID" ,
		"OrganisationID",
		Allocation10_InvoiceId AS InvoiceId,10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal
	WHERE Allocation10_AppliedAmount IS not null
) a
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation
as
SELECT *,
ISNULL("LineItem_AccountCode",'BLANK') + '-' + CAST("OrganisationID" AS varchar) AS "Account UID" 
FROM (
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID" ,
		"OrganisationID" ,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation6_InvoiceId AS InvoiceId,
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT 
		"OverpaymentId" ,
		"Date" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact_ContactId",
		"Contact_Name" ,
		"Status" ,
		"SubTotal" ,
		"TotalTax" ,
		"Total" ,
		"LineItem_LineItemId" ,
		"LineItem_Description" ,
		"LineItem_Quantity" ,
		"LineItem_UnitAmount",
		"LineItem_ItemCode" ,
		"LineItem_AccountCode",
		"LineItem_TaxType" ,
		"LineItem_TaxAmount",
		"LineItem_LineAmount",
		"LineItem_TrackingCategory1_CategoryId" ,
		"LineItem_TrackingCategory1_CategoryName",
		"LineItem_TrackingCategory1_OptionId" ,
		"LineItem_TrackingCategory1_OptionName",
		"LineItem_TrackingCategory1_Option_Stat",
		"LineItem_TrackingCategory2_CategoryId" ,
		"LineItem_TrackingCategory2_CategoryName",
		"LineItem_TrackingCategory2_OptionId" ,
		"LineItem_TrackingCategory2_OptionName",
		"LineItem_TrackingCategory2_Option_Stat",
		"LineItem_DiscountRate" ,
		"LineAmountTypes" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"UpdatedDateUTC",
		"HasAttachments" ,
		"Payments",
		"ClientID",
		"OrganisationID" ,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal
	WHERE Allocation10_AppliedAmount IS not NULL
) a
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_batchpayments','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_batchpayments
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_batchpayments
as
SELECT
	"Id" AS "Id",
	"BatchPaymentId" AS "Batch Payment Id",
	"AccountId" AS "Account Id",
	"Particulars" AS "Particulars",
	"Code" AS "Code",
	"Reference" AS "Reference",
	"Details" AS "Details",
	"Narrative" AS "Narrative",
	"Date" AS "Date",
	"Payment_PaymentId" AS "Payment Id",
	"Payment_InvoiceId" AS "Payment Invoice Id",
	"Payment_BankAccountNumber" AS "Payment Bank Account Number",
	"Payment_Particulars" AS "Payment Particulars",
	"Payment_Code" AS "Payment Code",
	"Payment_Reference" AS "Payment Reference",
	"Payment_Details" AS "Payment Details",
	"Payment_Amount" AS "Payment Amount",
	"PaymentAggregate" AS "Payment Aggregate",
	"Type" AS "Type",
	"Status" AS "Status",
	"TotalAmount" AS "Total Amount",
	"IsReconciled" AS "Is Reconciled",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_BatchPayments
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_executivesummary','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_executivesummary
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_executivesummary
as
SELECT
    "Title" AS "Title",
	"Metric" AS "Metric",
	"ThisMonth" AS "This Month",
	"PreviousMonth" AS "Previous Month",
	"Variance" AS "Variance",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_ExecutiveSummary
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_expenseclaimpayments','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaimpayments
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaimpayments
as
SELECT
	"Id" AS "Id",
	"ExpenseClaimId" AS "Expense Claim Id",
	"Date" AS "Date",
	"Amount" AS "Amount",
	"Reference" AS "Reference",
	"AccountId" AS "Account Id",
	"AccountCode" AS "Account Code",
	"AccountName" AS "Account Name",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimPayments
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_expenseclaimreceipts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaimreceipts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_expenseclaimreceipts
as
SELECT
	"Id" AS "Id",
	"ExpenseClaimId" AS "Expense Claim Id",
	"ReceiptId" AS "Receipt Id",
	"Date" AS "Date",
	"Contact_ContactId" AS "Contact Id",
	"Contact_Name" AS "Contact Name",
	"LineItem_Description" AS "LineItem Description",
	"LineItem_UnitAmount" AS "LineItem UnitAmount",
	"LineItem_AccountCode" AS "LineItem AccountCode",
	"LineItem_Quantity" AS "LineItem Quantity",
    "LineItem_TaxAmount" AS "LineItem TaxAmount",
	"LineItem_TaxType" AS "LineItem TaxType",
	"LineItem_LineAmount" AS "LineItem LineAmount",
	"LineItem_TrackingCategory1_CategoryId" AS "LineItem Tracking Category 1 Category Id",
	"LineItem_TrackingCategory1_CategoryName" AS "LineItem Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "LineItem Tracking Category 1 Option Id",
	"LineItem_TrackingCategory1_OptionName" AS "LineItem Tracking Category 1 OptionName",
	"LineItem_TrackingCategory1_Option_Stat" AS "LineItem Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "LineItem Tracking Category 2 Category Id",
	"LineItem_TrackingCategory2_CategoryName" AS "LineItem Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "LineItem Tracking Category 2 Option Id",
	"LineItem_TrackingCategory2_OptionName" AS "LineItem Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "LineItem Tracking Category 2 Option Stat",
	"LineItem_DiscountRate" AS "LineItem Discount Rate",
	"User_UserId" AS "User Id",
	"Reference" AS "Reference",
	"LineAmountTypes" AS "Line Amount Types",
	"SubTotal" AS "SubTotal",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"Status" AS "Status",
	"ReceiptNumber" AS "Receipt Number",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"HasAttachments" AS "Has Attachments",
	"URL" AS "URL",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceipts
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_profitandloss','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_profitandloss
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_profitandloss
as
SELECT
	"ID" AS "ID",
	"Title" AS "Title",
	"AccountName"  AS "Account Name",
	"Amount"  AS "Amount",
	"Month"  AS "Month",
	"AccountId"  AS "Account ID",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_ProfitandLossPivot
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_quotes','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_quotes
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_quotes
as
SELECT
	"Id" AS "Id",
	"QuoteId" AS "Quote Id",
	"ContactId" AS "Contact Id",
	"ContactName" AS "Contact Name",
	"Date" AS "Date",
	"ExpiryDate" AS "Expiry Date",
	"Status" AS "Status",
	"LineItem_LineItemId" AS "LineItem Id",
	"LineItem_Description" AS "LineItem Description",
	"LineItem_Quantity" AS "LineItem Quantity",
	"LineItem_UnitAmount" AS "LineItem Unit Amount",
	"LineItem_ItemCode" AS "LineItem Item Code",
	"LineItem_AccountCode" AS "LineItem Account Code",
	"LineItem_TaxType" AS "LineItem Tax Type",
	"LineItem_TaxAmount" AS "LineItem Tax Amount",
	"LineItem_LineAmount" AS "LineItem Line Amount",
	"LineItem_DiscountRate" AS "LineItem Discount Rate",
	"LineItem_TrackingCategory1_CategoryId" AS "LineItem Tracking Category 1 Category Id",
	"LineItem_TrackingCategory1_CategoryName" AS "LineItem Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "LineItem Tracking Category 1 Option Id",
	"LineItem_TrackingCategory1_OptionName" AS "LineItem Tracking Category 1 Option Name",
	"LineItem_TrackingCategory2_CategoryId" AS "LineItem Tracking Category 2 Category Id",
	"LineItem_TrackingCategory2_CategoryName" AS "LineItem Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "LineItem Tracking Category 2 Option Id",
	"LineItem_TrackingCategory2_OptionName" AS "LineItem Tracking Category 2 Option Name",
	"QuoteNumber" AS "Quote Number",
	"LineAmountTypes" AS "Line Amount Types",
	"Reference" AS "Reference",
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"SubTotal" AS "SubTotal",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"TotalDiscount" AS "Total Discount",
	"BrandingThemeId" AS "Branding Theme Id",
	"Terms" AS "Terms",
    "Title" AS "Title",
    "Summary" AS "Summary",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_Quotes
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_lastrefreshdate','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_lastrefreshdate
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_lastrefreshdate
as
SELECT 
    "Id" AS "Id",
	"TableName" AS "Table Name",
	"ResultRowCount" AS "Result Row Count",
	"LastRefreshUTCDate" AS "Last Refresh UTC Date",
	"ClientID" AS "Client ID",
    "OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_LastRefreshDate
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgets','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgets
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgets
as
SELECT 
	"BudgetID" AS "Budge tID",
	"Status" AS "Status",
	"Description" AS "Description",
	"Type" AS "Type",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"BudgetLines" AS "Budget Lines",
    "BudgetLines.AccountID" AS "Budget Lines Account ID",
	"BudgetLines.AccountCode" AS "Budget Lines Account Code",
	"BudgetLines.BudgetBalances" AS "Budget Lines Budget Balances",
	"BudgetLines.BudgetBalances.Period" AS "Budget Lines Budget Balances Period",
	"BudgetLines.BudgetBalances.Amount" AS "Budget Lines Budget Balances Amount",
	"BudgetLines.BudgetBalances.Notes" AS "Budget Lines Budget Balances Notes",
	"Tracking" AS "Tracking",
	"Tracking.1.Name" AS "Tracking 1 Name",
	"Tracking.1.Option" AS "Tracking 1 Option",
	"Tracking.1.TrackingCategoryID" AS "Tracking 1 Tracking Category ID",
	"Tracking.1.TrackingOptionID" AS "Tracking 1 Tracking Option ID",
	"Tracking.2.Name" AS "Tracking 2 Name",
	"Tracking.2.Option" AS "Tracking 2 Option",
	"Tracking.2.TrackingCategoryID" AS "Tracking 2 Tracking Category ID",
	"Tracking.2.TrackingOptionID" AS "Tracking 2 Tracking Option ID",
	"ClientID" AS "ClientID",
	"OrganisationID" AS "OrganisationID"
FROM dbo.NEW_CLIENT1_XEROBLUE_Budgets
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_cashvalidation','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_cashvalidation
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_cashvalidation
as
SELECT 
    "accountId" AS "account Id",
    "bankStatement.currentStatement.endBalance" AS "current Statement end Balance",
    "bankStatement.currentStatement.endDate" AS "current Statement end Date",
    "bankStatement.currentStatement.importedDateTimeUtc" AS "current Statement imported Date Time Utc",
    "bankStatement.currentStatement.importSourceType" AS "current Statement import Source Type",
    "bankStatement.currentStatement.startBalance" AS "current Statement.startBalance",
    "bankStatement.currentStatement.startDate" AS "current Statement start Date",
    "bankStatement.statementLines.avgDaysUnreconciledNeg" AS "statement Lines avg Days Unreconciled Neg",
    "bankStatement.statementLines.avgDaysUnreconciledPos" AS "statement Lines avg Days Unreconciled Pos",
    "bankStatement.statementLines.dataSource.directBankFeed" AS "statement Lines dataSource direct Bank Feed",
    "bankStatement.statementLines.dataSource.directBankFeedNeg" AS "statement Lines dataSource direct Bank Feed Neg",
    "bankStatement.statementLines.dataSource.directBankFeedPos" AS "statementLines dataSource direct Bank Feed Pos",
    "bankStatement.statementLines.dataSource.fileUpload" AS "statement Lines dataSource file Upload",
    "bankStatement.statementLines.dataSource.fileUploadNeg" AS "statement Lines dataSource file Upload Neg",
    "bankStatement.statementLines.dataSource.fileUploadPos" AS "statement Lines dataSource file Upload Pos",
    "bankStatement.statementLines.dataSource.indirectBankFeed" AS "statement Lines dataSource indirect Bank Feed",
    "bankStatement.statementLines.dataSource.indirectBankFeedNeg" AS "statement Lines dataSource indirect Bank Feed Neg",
    "bankStatement.statementLines.dataSource.indirectBankFeedPos" AS "statement Lines dataSource indirect Bank Feed Pos",
    "bankStatement.statementLines.dataSource.manual" AS "statement Lines dataSource manual",
    "bankStatement.statementLines.dataSource.manualNeg" AS "statement Lines dataSource manual Neg",
    "bankStatement.statementLines.dataSource.manualPos" AS "statement Lines dataSource manual Pos",
    "bankStatement.statementLines.dataSource.other" AS "statement Lines dataSource other",
    "bankStatement.statementLines.dataSource.otherNeg" AS "statement Lines dataSource other Neg",
    "bankStatement.statementLines.dataSource.otherPos" AS "statement Lines dataSource other Pos",
    "bankStatement.statementLines.deletedAmount" AS "statement Lines deleted Amount",
    "bankStatement.statementLines.earliestReconciledTransaction" AS "statement Lines earliest Reconciled Transaction",
    "bankStatement.statementLines.earliestUnreconciledTransaction" AS "statement Lines earliest Unreconciled Transaction",
    "bankStatement.statementLines.latestReconciledTransaction" AS "statement Lines latest Reconciled Transaction",
    "bankStatement.statementLines.latestUnreconciledTransaction" AS "statement Lines latest Unreconciled Transaction",
    "bankStatement.statementLines.reconciledAmountNeg" AS "sStatement Lines reconciled Amount Neg",
    "bankStatement.statementLines.reconciledAmountPos" AS "statement Lines reconciled Amount Pos",
    "bankStatement.statementLines.reconciledLines" AS "statement Lines reconciled Lines",
    "bankStatement.statementLines.totalAmount" AS "statement Lines total Amount",
    "bankStatement.statementLines.totalAmountNeg" AS "statement Lines total Amount Neg",
    "bankStatement.statementLines.totalAmountPos" AS "statement Lines total Amount Pos",
    "bankStatement.statementLines.unreconciledAmountNeg" AS "statement Lines unreconciled Amount Neg",
    "bankStatement.statementLines.unreconciledAmountPos" AS "statement Lines unreconciled Amount Pos",
    "bankStatement.statementLines.unreconciledLines" AS "statement Lines unreconciled Lines",
    "cashAccount.accountBalance" AS "cash Account account Balance",
    "cashAccount.balanceCurrency" AS "cash Account balance Currency",
    "cashAccount.startingBalance" AS "cash Account starting Balance",
    "cashAccount.unreconciledAmountNeg" AS "cash Account unreconciled Amount Neg",
    "cashAccount.unreconciledAmountPos" AS "cash Account unreconciled Amount Pos",
    "statementBalance.type" AS "statement Balance type",
    "statementBalance.value" AS "statement Balance value",
    "statementBalanceDate" AS "statement Balance Date",
    "ClientID" AS "Client ID",
    "OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_CashValidation
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_TrackingCategoryConnections','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_TrackingCategoryConnections
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_TrackingCategoryConnections
as
SELECT
	"ID" AS "ID",
	"CategoryNumber" AS "CategoryNumber",
	"CategoryID+Option" AS "CategoryID+Option",
	"ClientID" AS "ClientID",
	"OrganisationID" AS "OrganisationID"
FROM (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY "ID" ORDER BY (SELECT NULL)) AS rn
	FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoryConnections
) t WHERE t.rn = 1;
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_ContactGroupMembers','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_ContactGroupMembers
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_ContactGroupMembers
as
SELECT
	"ContactID" AS "ContactID",
	"Name" AS "Name",
	"ContactGroupID" AS "ContactGroupID",
	"ContactGroups_Name" AS "ContactGroups_Name",
	"ContactGroups_Status" AS "ContactGroups_Status",
	"ClientID" AS "ClientID",
	"OrganisationID" AS "OrganisationID"
FROM dbo.NEW_CLIENT1_XEROBLUE_ContactGroupMembers
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoicesDraft','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesDraft
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesDraft
as
SELECT
	"Id" AS "Invoice Line ID",
	"InvoiceId" AS "Invoice ID",
	"Type" AS "Type",
	"ContactId" AS "Contact ID",
	"ContactName" AS "Contact Name" ,
	"LineItem_LineItemId" AS "Line Item ID",
	"LineItem_Description" AS "Line Item - Description" ,
	"LineItem_Quantity" AS "Quantity",
	"LineItem_UnitAmount" AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 - Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name" ,
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat" ,
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID" ,
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 - Option ID" ,
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"DiscountRate" AS "Discount Rate", 
	"DiscountRate%" AS "Discount Rate %",
	"LineItem_DiscountAmount" AS "Discount Amount" ,
	"LineItemAggregate" AS "Aggregate" ,
	"Date" AS "Date" ,
	"DueDate" AS "Due Date" ,
	"LineAmountTypes" AS "Line Amount Types",
	"InvoiceNumber" AS "Invoice Number" ,
	"Reference" AS "Reference" ,
	"BrandingThemeId" AS "Branding Theme ID",
	"URL" AS "URL" ,
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate" ,
	"Status" AS "Status",
	"SentToContact" AS "Sent To Contact",
	"ExpectedPaymentDate" AS "Expected Payment Date",
	"PlannedPaymentDate" AS "Planned Payment Date" ,
	"SubTotal" AS "Invoice - Sub Total" ,
	"TotalTax" AS "Invoice - Total Tax",
	"Total" AS "Invoice Total" ,
	"TotalDiscount" AS "Total Discount",
	"HasAttachments" AS "Has Attachments",
	"AmountDue" AS "Invoice - Amount Due",
	"AmountPaid" AS "Invoice - Amount Paid",
	"CISDeduction" AS "CIS Deduction",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"AmountCredited" AS "Amount Credited" ,
	"UpdatedDateUTC" AS "Updated Date UTC",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"CreditNotes" AS "Credit Notes",
	"Payments" AS "Payments",
	"Prepayments" AS "Pre Payments",
	"Overpayments" AS "Over Payments",
	"RepeatingInvoiceID" AS "Repeating Invoice ID",
	"LineItem_AccountCode" + '-' + CAST("OrganisationID" AS varchar)  AS "Account_UID",
	"PaymentIds" AS "Payment ID",
	"PrePaymentIds" AS "Pre Payment ID",
	"OverPaymentIds" AS "Over Payment ID",
	"CreditNoteIDs" AS "Credit Note ID",
	"LineAmountCalculation" AS "Line Amount Calculation",     
 	"LineAmountCalculationIncTax" AS "Line Amount Calculation Inc Tax",    	
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
 	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation",
	"DayDifference" AS "Day Difference"
FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraft
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_transactions','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_transactions
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_transactions
AS
SELECT
	"LineID" AS "Line ID",
	"ID" AS "ID",
	"Date" AS "Date",
	"Type" AS "Type",
	"ContactID" AS "Contact ID",
	"ContactName" AS "Contact Name",
	"LineItemID" AS "Line Item ID",
	"Description" AS "Description",
	"Quantity" AS "Quantity",
	"UnitAmount" AS "Unit Amount",
	"ItemCode" AS "Item Code",
	"AccountCode" AS "Account Code",
	"TaxType" AS "Tax Type",
	"TaxAmount" AS "Tax Amount",
	"LineAmount" AS "Line Amount",
	"LineAmountTypes" AS "Line Amount Types",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"TrackingCategory1CategoryID" AS "Tracking Category 1 Category ID",
	"TrackingCategory1CategoryName" AS "Tracking Category 1 Category Name",
	"TrackingCategory1OptionID" AS "Tracking Category 1 Option ID",
	"TrackingCategory1OptionName" AS "Tracking Category 1 Option Name",
	"TrackingCategory1OptionStat" AS "Tracking Category 1 Option Stat",
	"TrackingCategory2CategoryID" AS "Tracking Category 2 Category ID",
	"TrackingCategory2CategoryName" AS "Tracking Category 2 Category Name",
	"TrackingCategory2OptionID" AS "Tracking Category 2 Option ID",
	"TrackingCategory2OptionName" AS "Tracking Category 2 Option Name",
	"TrackingCategory2OptionStat" AS "Tracking Category 2 Option Stat",
	"DiscountRate" AS "Discount Rate",
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"AccountUID" AS "Account UID",
	"HasAttachments" AS "Has Attachments",
	"CreditNoteNumber" AS "Credit Note Number",
	"RemainingCredit" AS "Remaining Credit",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"Reference" AS "Reference",
	"Source" AS "Source",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
    "ShowOnCashBasisReports" AS "ShowOnCashBasisReports",
	"DueDate" AS "DueDate",
	"InvoiceNumber" AS "InvoiceNumber",
	"PaymentSourceID" AS "PaymentSourceID",
	"PaymentType" AS "PaymentType",
    "AllocationDate" AS "AllocationDate",
    "AllocationAmount" AS "AllocationAmount",
	"Changes" AS "Changes",
	"User" AS "User",
	"Details" AS "Details",
	"DayDifference" AS "DayDifference"
FROM dbo.NEW_CLIENT1_XEROBLUE_Transactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts
as
SELECT 
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
    "Split" AS "Split",
    "ContactID" AS "Contact ID",
    "ContactName" AS "Contact Name",
	"ContactSource" AS "ContactSource",
	"PaymentSourceID" AS "PaymentSourceID",
	"PaymentType" AS "PaymentType",
	"Changes" AS "Changes",
	"User" AS "User",
	"Details" AS "Details",
    "ShowOnCashBasisReports" AS "ShowOnCashBasisReports",
    "FullyPaidOnDate" AS "FullyPaidOnDate",
    "DayDifference" AS "DayDifference",
    "InvoiceNumber" AS "InvoiceNumber",
    "CreditNoteNumber" AS "CreditNoteNumber"
FROM dbo.NEW_CLIENT1_XEROBLUE_Journals
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts
as
SELECT
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
	"Split" AS "Split",
	"ContactID" AS "ContactID",
	"ContactName" AS "ContactName",
	"ContactSource" AS "ContactSource",
	"PaymentSourceID" AS "PaymentSourceID",
	"PaymentType" AS "PaymentType",
	"Changes" AS "Changes",
	"User" AS "User",
	"Details" AS "Details",
    "ShowOnCashBasisReports" AS "ShowOnCashBasisReports",
    "FullyPaidOnDate" AS "FullyPaidOnDate",
    "DayDifference" AS "DayDifference",
    "InvoiceNumber" AS "InvoiceNumber",
    "CreditNoteNumber" AS "CreditNoteNumber"
FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCash
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquetransactions','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquetransactions
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquetransactions
AS
SELECT
	"LineID" AS "Line ID",
	"ID" AS "ID",
	"Date" AS "Date",
	"Type" AS "Type",
	"ContactID" AS "Contact ID",
	"ContactName" AS "Contact Name",
	"LineItemID" AS "Line Item ID",
	"Description" AS "Description",
	"Quantity" AS "Quantity",
	"UnitAmount" AS "Unit Amount",
	"ItemCode" AS "Item Code",
	"AccountCode" AS "Account Code",
	"TaxType" AS "Tax Type",
	"TaxAmount" AS "Tax Amount",
	"LineAmount" AS "Line Amount",
	"LineAmountTypes" AS "Line Amount Types",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"TotalTax" AS "Total Tax",
	"Total" AS "Total",
	"TrackingCategory1CategoryID" AS "Tracking Category 1 Category ID",
	"TrackingCategory1CategoryName" AS "Tracking Category 1 Category Name",
	"TrackingCategory1OptionID" AS "Tracking Category 1 Option ID",
	"TrackingCategory1OptionName" AS "Tracking Category 1 Option Name",
	"TrackingCategory1OptionStat" AS "Tracking Category 1 Option Stat",
	"TrackingCategory2CategoryID" AS "Tracking Category 2 Category ID",
	"TrackingCategory2CategoryName" AS "Tracking Category 2 Category Name",
	"TrackingCategory2OptionID" AS "Tracking Category 2 Option ID",
	"TrackingCategory2OptionName" AS "Tracking Category 2 Option Name",
	"TrackingCategory2OptionStat" AS "Tracking Category 2 Option Stat",
	"DiscountRate" AS "Discount Rate",
	"CurrencyCode" AS "Currency Code",
	"CurrencyRate" AS "Currency Rate",
	"UpdatedDateUTC" AS "Updated Date UTC",
	"AccountUID" AS "Account UID",
	"HasAttachments" AS "Has Attachments",
	"CreditNoteNumber" AS "Credit Note Number",
	"RemainingCredit" AS "Remaining Credit",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"Reference" AS "Reference",
	"Source" AS "Source",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_transactionsblend','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_transactionsblend
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_transactionsblend
as
SELECT 
	"Id" AS "ID",
	"JournalId" AS "Journal ID",
	"JournalDate" AS "Journal Date",
	"JournalNumber" AS "Journal Number",
	"CreatedDateUTC" AS "Created Date UTC" ,
	"Reference" AS "Reference" ,
	"SourceId" AS "Source ID" ,
	"SourceType" AS "Source Type",
	"JournalLine_JournalLineId" AS "Journal Line ID" ,
	"JournalLine_Description" AS "Description",
	"JournalLine_AccountId" AS "Account ID",
	"JournalLine_AccountCode" AS "Account Code",
	"JournalLine_AccountType" AS "Account Type",
	"JournalLine_AccountName" AS "Account Name" ,
	"JournalLine_NetAmount" AS "Net Amount",
	"JournalLine_GrossAmount" AS "Gross Amount",
	"JournalLine_TaxAmount" AS "Tax Amount",
	"JournalLine_TaxType" AS "Tax Type",
	"JournalLine_TaxName" AS "Tax Name",
	"LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	"LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	"ClientID" AS "Client ID" ,
	"OrganisationID" AS "Organisation ID",
    "Split" AS "Split",
    "ContactID" AS "Contact ID",
    "ContactName" AS "Contact Name",
	"ContactSource" AS "ContactSource",
	"PaymentSourceID" AS "PaymentSourceID",
	"PaymentType" AS "PaymentType",
	"Changes" AS "Changes",
	"User" AS "User",
	"Details" AS "Details",
    "ShowOnCashBasisReports" AS "ShowOnCashBasisReports",
    "FullyPaidOnDate" AS "FullyPaidOnDate",
    "DayDifference" AS "DayDifference",
    "SourceNumber" AS "SourceNumber",
    "CashOrAccruals" AS "CashOrAccruals"
FROM dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlend
GO