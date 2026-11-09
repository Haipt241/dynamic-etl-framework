/**************************************************************************************
FILENAME: CREATE FX VIEWS
DESCRIPTION: LIST OF SQL SCRIPT FOR CREATING VIEWS CONTAINING FOREIGN EXCHANGE CONVERTED
	AMOUNTS. REPLACE "NEW_CLIENT1" WITH CORRECT	CLIENT ID.
HISTORY:
DATE					DESCRIPTION
2023-07-13				INTIAL VERSION
2023-03-01				New version of Transaction tables
**************************************************************************************/

IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_banktransactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_banktransactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_banktransactions_AUD
as
SELECT
	"Id"										AS "Bank Transaction Line ID",
	"BankTransactionId"							AS "Bank Transaction ID",
	"Type"										AS "Type",
	"Contact_ContactName"						AS "Contact Name",
	"Contact_ContactId"							AS "Contact ID",
	"BankAccount_AccountId"						AS "Account ID",
	"BankAccount_AccountName"					AS "Bank Account Account Name",
	"BankAccount_Code"							AS "Bank Account Code",
	"LineItem_LineItemId"						AS "Line Item ID",
	"LineItem_Description"						AS "Description",
	"LineItem_Quantity"							AS "Quantity",
	"LineItem_UnitAmount"						AS "Unit Amount",
	"LineItem_UnitAmount_AUD"					AS "Unit Amount FX",
	"LineItem_AccountCode"						AS "Account Code Posted Against",
	 ISNULL("LineItem_TaxType", 'BLANK')		AS "Tax Type", 
	"LineItem_TaxAmount"						AS "Tax Amount",
	"LineItem_TaxAmount_AUD"					AS "Tax Amount FX",
	"LineItem_ItemCode"							AS "Item Code",
	"LineItem_LineAmount"						AS "Line Amount",
	"LineItem_LineAmount_AUD"					AS "Line Amount FX",
	"LineItem_TrackingCategory1_CategoryId"		AS "Tracking Category 1 CategoryID",
	"LineItem_TrackingCategory1_CategoryName"	AS "Tracking Category 1 Name",
	"LineItem_TrackingCategory1_OptionId"		AS "Tracking Category 1 Option ID",
	"LineItem_TrackingCategory1_OptionName"		AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat"	AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId"		AS "Tracking Category 2 CategoryID",
	"LineItem_TrackingCategory2_CategoryName"	AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId"		AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName"		AS "Tracking Category 2 Option Name",
	"LineItem_TrackingCategory2_Option_Stat"	AS "Tracking Category 2 Option Stat",
	"LineItemAggregate"							AS "Line Item Aggregate",
	"IsReconciled"								AS "Is Reconciled",
	"Date"							    		AS "Date",
	"Reference"									AS "Reference",
	"CurrencyCode"								AS "Currency Code",
	"CurrencyRate"								AS "Currency Rate",
	"URL"										AS "URL",
	"Status"									AS "Status",
	"SubTotal"									AS "Sub Total",
	"TotalTax" 									AS "Total Tax",
	"Total" 									AS "Total",
	"SubTotal_AUD"								AS "Sub Total FX",
	"TotalTax_AUD"								AS "Total Tax FX",
	"Total_AUD"									AS "Total FX",
	"PrepaymentId"								AS "Prepayment ID",
	"OverpaymentId"								AS "Overpayment ID",
	"UpdatedDateUTC"							AS "Updated Date UTC",
	"FullyPaidOnDate"							AS "Fully Paid On Date",
	"ClientID"									AS "Client ID",
	"OrganisationID"							AS "Organisation ID",
	"LineAmountTypes"							AS "Line Amount Types",
	"Account_UID" AS "Account_UID",
	"BankTansactionCashflowCalculation" AS "Bank Tansaction Cashflow Calculation",
	"LineAmountCalculatedIncTax" AS "Line Amount Calculated Inc Tax",
	"PaymentAmount" AS "Payment Amount",
	"BankTansactionCashflowCalculation_AUD" AS "Bank Tansaction Cashflow Calculation FX",  
	"LineAmountCalculatedIncTax_AUD" AS "Line Amount Calculated Inc Tax FX",  		
	"PaymentAmount_AUD" AS "Payment Amount FX"	
FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactions WHERE Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquebanktransactions_AUD
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
	"ConditionalType" AS "Conditional Type",
	"LineItem_TaxAmount_AUD" AS "Tax Amount FX",
	"LineItem_LineAmount_AUD" AS "Line Amount FX",
	"SubTotal_AUD" AS "Sub Total FX",
	"TotalTax_AUD" AS "Total Tax Fx",
	"Total_AUD" AS "Total FX"
FROM NEW_CLIENT1_XEROBLUE_UniqueBankTransactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_banktransfers_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_banktransfers_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_banktransfers_AUD
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
	"OrganisationID" AS "Organisation ID",
	"Amount_AUD" AS "Amount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransfers
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_creditnotes_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotes_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotes_AUD
as
SELECT 
	"Id"										AS "Credit Note Line ID",
	"CreditNoteId"								AS "Credit Note ID" ,
	"CreditNoteNumber"							AS "Credit Note Number",
	"Reference"									AS "Reference",
	"Type"										AS "Type",
	"Contact_ContactId"							AS "Contact ID" ,
	"Contact_Name"								AS "Contact Name",
	"Date"										AS "Date",
	"Status"									AS "Status",
	"LineAmountTypes"							AS "Line Amount Types",
	"LineItem_Description"						AS "Description",
	"LineItem_Quantity"							AS "Quantity",
	"LineItem_UnitAmount"						AS "Unit Amount",
	"LineItem_ItemCode"							AS "Item Code",
	"LineItem_AccountCode"						AS "Account Code" ,
	"LineItem_TaxType"							AS "Tax Type" ,
	"LineItem_TaxAmount"						AS "Tax Amount" ,
	"LineItem_LineAmount"						AS "Line Amount" ,
	"LineItem_TaxAmount_AUD"					AS "Tax FX Amount" ,
	"LineItem_LineAmount_AUD"					AS "Line FX Amount", 
	"LineItem_TrackingCategory1_CategoryId"		AS "Tracking Category 1 Category ID",
	"LineItem_TrackingCategory1_CategoryName"	AS "Tracking Category 1 Category Name" ,
	"LineItem_TrackingCategory1_OptionId"		AS "Tracking Category 1 Option ID" ,
	"LineItem_TrackingCategory1_OptionName"		AS "Tracking Category 1 Option Name",
	"LineItem_TrackingCategory1_Option_Stat"	AS "Tracking Category 1 Option Stat",
	"LineItem_TrackingCategory2_CategoryId"		AS "Tracking Category 2 Category ID",
	"LineItem_TrackingCategory2_CategoryName"	AS "Tracking Category 2 Category Name",
	"LineItem_TrackingCategory2_OptionId"		AS "Tracking Category 2 Option ID",
	"LineItem_TrackingCategory2_OptionName"		AS "Tracking Category 2 Option Name" ,
	"LineItem_TrackingCategory2_Option_Stat"	AS "Tracking Category 2 Option Stat",
	"LineItem_DiscountRate"						AS "Discount Rate",
	"LineItemAggregate"							AS "Line Item Aggregate",
	"SubTotal"									AS "Sub Total",
	"TotalTax" 									AS "Total Tax" ,
	"Total" 									AS "Total",
	"SubTotal_AUD"								AS "Sub FX Total",
	"TotalTax_AUD"								AS "Total FX Tax" ,
	"Total_AUD"									AS "FX Total",
	"UpdatedDateUTC"							AS "Updated Date UTC",
	"CurrencyCode"								AS "Currency Code",
	"FullyPaidOnDate"							AS "Fully Paid On Date" ,
	"SentToContact"								AS "Sent To Contact" ,
	"BrandingThemeId"							AS "Branding Theme ID" ,
	"CurrencyRate"								AS "Currency Rate",
	"RemainingCredit"							AS "Remaining Credit" ,
	"RemainingCredit_AUD"						AS "Remaining Credit FX" ,
	"Allocation1_AppliedAmount"					AS "Allocation 1 Applied Amount",
	"Allocation1_AppliedAmount_AUD"				AS "Allocation 1 Applied Amount FX",
	"Allocation1_Date"							AS "Allocation 1 Date" ,
	"Allocation1_InvoiceId"						AS "Allocation 1 Invoice ID" ,
	"Allocation1_InvoiceNumber"					AS "Allocation 1 Invoice Number",
	"Allocation2_AppliedAmount"					AS "Allocation 2 Applied Amount",
	"Allocation2_AppliedAmount_AUD"				AS "Allocation 2 Applied Amount FX",
	"Allocation2_Date"							AS "Allocation 2 Date" ,
	"Allocation2_InvoiceId"						AS "Allocation 2 Invoice ID" ,
	"Allocation2_InvoiceNumber"					AS "Allocation 2 Invoice Number",
	"HasAttachments"							AS "Has Attachments",
	"ClientID"									AS "Client ID" ,
	"OrganisationID"							AS "Organisation ID",
	"Allocation3_AppliedAmount"					AS "Allocation 3 Applied Amount",
	"Allocation3_AppliedAmount_AUD"				AS "Allocation 3 Applied Amount FX",
	"Allocation3_Date"							AS "Allocation 3 Date" ,
	"Allocation3_InvoiceId"						AS "Allocation 3 Invoice ID" ,
	"Allocation3_InvoiceNumber"					AS "Allocation 3 Invoice Number",
	"Allocation4_AppliedAmount"					AS "Allocation 4 Applied Amount",
	"Allocation4_AppliedAmount_AUD"				AS "Allocation 4 Applied Amount FX",
	"Allocation4_Date"							AS "Allocation 4 Date" ,
	"Allocation4_InvoiceId"						AS "Allocation 4 Invoice ID" ,
	"Allocation4_InvoiceNumber"					AS "Allocation 4 Invoice Number",
	"Allocation5_AppliedAmount"					AS "Allocation 5 Applied Amount",
	"Allocation5_AppliedAmount_AUD"				AS "Allocation 5 Applied Amount FX",
	"Allocation5_Date"							AS "Allocation 5 Date" ,
	"Allocation5_InvoiceId"						AS "Allocation 5 Invoice ID" ,
	"Allocation5_InvoiceNumber"					AS "Allocation 5 Invoice Number",
	"Allocation6_AppliedAmount"					AS "Allocation 6 Applied Amount",
	"Allocation6_AppliedAmount_AUD"				AS "Allocation 6 Applied Amount FX",
	"Allocation6_Date"							AS "Allocation 6 Date" ,
	"Allocation6_InvoiceId"						AS "Allocation 6 Invoice ID" ,
	"Allocation6_InvoiceNumber"					AS "Allocation 6 Invoice Number",
	"Allocation7_AppliedAmount"					AS "Allocation 7 Applied Amount",
	"Allocation7_AppliedAmount_AUD"				AS "Allocation 7 Applied Amount FX",
	"Allocation7_Date"							AS "Allocation 7 Date" ,
	"Allocation7_InvoiceId"						AS "Allocation 7 Invoice ID" ,
	"Allocation7_InvoiceNumber"					AS "Allocation 7 Invoice Number",
	"Allocation8_AppliedAmount"					AS "Allocation 8 Applied Amount",
	"Allocation8_AppliedAmount_AUD"				AS "Allocation 8 Applied Amount FX",
	"Allocation8_Date"							AS "Allocation 8 Date" ,
	"Allocation8_InvoiceId"						AS "Allocation 8 Invoice ID" ,
	"Allocation8_InvoiceNumber"					AS "Allocation 8 Invoice Number",
	"Allocation9_AppliedAmount"					AS "Allocation 9 Applied Amount",
	"Allocation9_AppliedAmount_AUD"				AS "Allocation 9 Applied Amount FX",
	"Allocation9_Date"							AS "Allocation 9 Date" ,
	"Allocation9_InvoiceId"						AS "Allocation 9 Invoice ID" ,
	"Allocation9_InvoiceNumber"					AS "Allocation 9 Invoice Number",
	"Allocation10_AppliedAmount"				AS "Allocation 10 Applied Amount",
	"Allocation10_AppliedAmount_AUD"			AS "Allocation 10 Applied Amount FX",
	"Allocation10_Date"							AS "Allocation 10 Date" ,
	"Allocation10_InvoiceId"					AS "Allocation 10 Invoice ID" ,
	"Allocation10_InvoiceNumber"				AS "Allocation 10 Invoice Number",
	"Allocation11_AppliedAmount"				AS "Allocation 11 Applied Amount",
	"Allocation11_AppliedAmount_AUD"			AS "Allocation 11 Applied Amount FX",
	"Allocation11_Date"							AS "Allocation 11 Date" ,
	"Allocation11_InvoiceId"					AS "Allocation 11 Invoice ID" ,
	"Allocation11_InvoiceNumber"				AS "Allocation 11 Invoice Number",
	"Allocation12_AppliedAmount"				AS "Allocation 12 Applied Amount",
	"Allocation12_AppliedAmount_AUD"			AS "Allocation 12 Applied Amount FX",
	"Allocation12_Date"							AS "Allocation 12 Date" ,
	"Allocation12_InvoiceId"					AS "Allocation 12 Invoice ID" ,
	"Allocation12_InvoiceNumber"				AS "Allocation 12 Invoice Number",
	"Allocation13_AppliedAmount"				AS "Allocation 13 Applied Amount",
	"Allocation13_AppliedAmount_AUD"			AS "Allocation 13 Applied Amount FX",
	"Allocation13_Date"							AS "Allocation 13 Date" ,
	"Allocation13_InvoiceId"					AS "Allocation 13 Invoice ID" ,
	"Allocation13_InvoiceNumber"				AS "Allocation 13 Invoice Number",
	"Allocation14_AppliedAmount"				AS "Allocation 14 Applied Amount",
	"Allocation14_AppliedAmount_AUD"			AS "Allocation 14 Applied Amount FX",
	"Allocation14_Date"							AS "Allocation 14 Date" ,
	"Allocation14_InvoiceId"					AS "Allocation 14 Invoice ID" ,
	"Allocation14_InvoiceNumber"				AS "Allocation 14 Invoice Number",
	"Allocation15_AppliedAmount"				AS "Allocation 15 Applied Amount",
	"Allocation15_AppliedAmount_AUD"			AS "Allocation 15 Applied Amount FX",
	"Allocation15_Date"							AS "Allocation 15 Date" ,
	"Allocation15_InvoiceId"					AS "Allocation 15 Invoice ID" ,
	"Allocation15_InvoiceNumber"				AS "Allocation 15 Invoice Number",
	"AccountUID" AS "Account UID",
	"LineAmountCreditNoteCalculation" AS "Line Amount Credit Note Calculation",   
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
  	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation",
	"LineAmountCreditNoteCalculation_AUD" AS "Line Amount Credit Note Calculation FX",   
 	"LineAmountTradeCreditorCalculation_AUD" AS "Line Amount Trade Creditor Calculation FX",   
  	"LineAmountTradeDebtorCalculation_AUD" AS "Line Amount Trade Debtor Calculation FX" 	 	 
FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes as p
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotesdq_AUD
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
	"AccountUID" AS "Account UID",
	"LineItem_TaxAmount_AUD" AS "Tax Ammount FX",
	"LineItem_LineAmount_AUD" AS "Line Amount FX",
	"SubTotal_AUD" AS "Sub Total FX",
	"TotalTax_AUD" AS "Total Tax FX",
	"Total_AUD" AS "Total FX",
	"RemainingCredit_AUD" AS "Remaining Credit FX",
	"Allocation1_AppliedAmount_AUD" AS "Allocation 1 Applied Amount FX",
	"Allocation2_AppliedAmount_AUD" AS "Allocation 2 Applied Amount FX",
	"Allocation3_AppliedAmount_AUD" AS "Allocation 3 Applied Amount FX",
	"Allocation4_AppliedAmount_AUD" AS "Allocation 4 Applied Amount FX",
	"Allocation5_AppliedAmount_AUD" AS "Allocation 5 Applied Amount FX",
	"Allocation6_AppliedAmount_AUD" AS "Allocation 6 Applied Amount FX",
	"Allocation7_AppliedAmount_AUD" AS "Allocation 7 Applied Amount FX",
	"Allocation8_AppliedAmount_AUD" AS "Allocation 8 Applied Amount FX",
	"Allocation9_AppliedAmount_AUD" AS "Allocation 9 Applied Amount FX",
	"Allocation10_AppliedAmount_AUD" AS "Allocation 10 Applied Amount FX",
	"Allocation11_AppliedAmount_AUD" AS "Allocation 11 Applied Amount FX",
	"Allocation12_AppliedAmount_AUD" AS "Allocation 12 Applied Amount FX",
	"Allocation13_AppliedAmount_AUD" AS "Allocation 13 Applied Amount FX",
	"Allocation14_AppliedAmount_AUD" AS "Allocation 14 Applied Amount FX",
	"Allocation15_AppliedAmount_AUD" AS "Allocation 15 Applied Amount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueCreditNotes
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoices_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoices_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoices_AUD
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
	"LineItem_UnitAmount"   AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_TaxAmount_AUD" AS "Tax FX Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_LineAmount_AUD" AS "Line FX Amount",
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
	"LineItem_DiscountAmount_AUD" AS "Discount FX Amount" ,
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
	"SubTotal_AUD" AS "Invoice - FX Sub Total" ,
	"TotalTax" AS "Invoice - Total Tax",
	"TotalTax_AUD" AS "Invoice - FX Total Tax",
	"Total_AUD" AS "Invoice Total" ,
	"TotalDiscount_AUD" AS "Total Discount",
	"HasAttachments" AS "Has Attachments",
	"AmountDue_AUD" AS "Invoice - Amount Due",
	"AmountPaid_AUD" AS "Invoice - Amount Paid",
	"CISDeduction_AUD" AS "CIS Deduction",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"AmountCredited_AUD" AS "Amount Credited" ,
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
	"LineAmountCalculation_AUD" AS "Line Amount FX Calculation", 
 	"LineAmountCalculationIncTax" AS "Line Amount Calculation Inc Tax",    	
	"LineAmountCalculationIncTax_AUD" AS "Line Amount FX Calculation Inc Tax", 
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
	"LineAmountTradeCreditorCalculation_AUD" AS "Line Amount FX Trade Creditor Calculation",    
 	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation",
 	"LineAmountTradeDebtorCalculation_AUD" AS "Line Amount FX Trade Debtor Calculation",   
	"DayDifference" AS "Day Difference"
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices as i
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices_AUD
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
	"DayDifference" AS "Day Difference",
	"LineItem_TaxAmount_AUD" AS "Tax Amount FX",
	"LineItem_LineAmount_AUD" AS "Line Amount FX",
	"LineItem_DiscountAmount_AUD" AS "Discount Amount FX",
	"SubTotal_AUD" AS "Invoice - Sub Total FX",
	"TotalTax_AUD" AS "Invoice - Total Tax FX",
	"Total_AUD" AS "Invoice Total FX",
	"TotalDiscount_AUD" AS "Total Discount FX",
	"AmountDue_AUD" AS "Invoice - Amount Due FX",
	"AmountPaid_AUD" AS "Invoice - Amount Paid FX",
	"CISDeduction_AUD" AS "CIS Deduction FX",
	"AmountCredited_AUD" AS "Amount Credited FX"
FROM NEW_CLIENT1_XEROBLUE_UniqueInvoices
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journals_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journals_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journals_AUD
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
	"JournalLine_NetAmount_AUD" AS "Net Amount FX",
	"JournalLine_GrossAmount_AUD" AS "Gross Amount FX",
	"JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalsCash_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCash_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCash_AUD
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
	"JournalLine_NetAmount_AUD" AS "Net Amount FX",
	"JournalLine_GrossAmount_AUD" AS "Gross Amount FX",
	"JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_payments_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_payments_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_payments_AUD
as
SELECT
	"PaymentId" AS "Payment ID",
	"Date" AS "Date",
	"Amount"   AS "Amount",
	"Amount_AUD" AS "Amount FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsummary_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsummary_AUD
as
SELECT 
	"ID" AS "ID",
	"Title" AS "Title",
	"AccountId" AS "AccountId",
	"BankAccount" AS "Account Name",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID",
	"FinancialYear" AS "Financial Year" ,
	"AccountName_UID" AS "AccountName_UID",
	"Amount" AS "Amount",
	"Month" AS "Month",
	"Amount_AUD" AS "Amount_AUD",
	"TotalAmount" AS "Total Amount",
	"TotalAmount_AUD" AS "Total Amount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
AS
SELECT 
	"CreditNoteId"  AS "CreditNoteId", 
	"ClientID" AS "ClientId",
	"OrganisationID" AS "OrganisationId",
	"CurrencyCode" AS "CurrencyCode",
	"Allocation1_AppliedAmount" AS "Allocation1_AppliedAmount" ,
	"Allocation1_AppliedAmount_AUD" AS "Allocation 1 Applied Amount FX",
	"Allocation1_Date" AS "Allocation1_Date",
	"Allocation1_InvoiceId" AS "Allocation1_InvoiceId" ,
	"Allocation2_AppliedAmount" AS "Allocation2_AppliedAmount" ,
	"Allocation2_AppliedAmount_AUD" AS "Allocation 2 Applied Amount FX",
	"Allocation2_Date" AS "Allocation2_Date",
	"Allocation2_InvoiceID" AS "Allocation2_InvoiceId" ,
	"Allocation3_AppliedAmount" AS "Allocation3_AppliedAmount" ,
	"Allocation3_AppliedAmount_AUD" AS "Allocation 3 Applied Amount FX",
	"Allocation3_Date" AS "Allocation3_Date",
	"Allocation3_InvoiceID" AS "Allocation3_InvoiceId" ,
	"Allocation4_AppliedAmount" AS "Allocation4_AppliedAmount" ,
	"Allocation4_AppliedAmount_AUD" AS "Allocation 4 Applied Amount FX",
	"Allocation4_Date" AS "Allocation4_Date",
	"Allocation4_InvoiceID" AS "Allocation4_InvoiceId" ,
	"Allocation5_AppliedAmount" AS "Allocation5_AppliedAmount" ,
	"Allocation5_AppliedAmount_AUD" AS "Allocation 5 Applied Amount FX",
	"Allocation5_Date" AS "Allocation5_Date",
	"Allocation5_InvoiceID" AS "Allocation5_InvoiceId" ,
	"Allocation6_AppliedAmount" AS "Allocation6_AppliedAmount" ,
	"Allocation6_AppliedAmount_AUD" AS "Allocation 6 Applied Amount FX",
	"Allocation6_Date" AS "Allocation6_Date",
	"Allocation6_InvoiceID" AS "Allocation6_InvoiceId" ,
	"Allocation7_AppliedAmount" AS "Allocation7_AppliedAmount" ,
	"Allocation7_AppliedAmount_AUD" AS "Allocation 7 Applied Amount FX",
	"Allocation7_Date" AS "Allocation7_Date",
	"Allocation7_InvoiceID" AS "Allocation7_InvoiceId" ,
	"Allocation8_AppliedAmount" AS "Allocation8_AppliedAmount" ,
	"Allocation8_AppliedAmount_AUD" AS "Allocation 8 Applied Amount FX",
	"Allocation8_Date" AS "Allocation8_Date",
	"Allocation8_InvoiceID" AS "Allocation8_InvoiceId" ,
	"Allocation9_AppliedAmount" AS "Allocation9_AppliedAmount" ,
	"Allocation9_AppliedAmount_AUD" AS "Allocation 9 Applied Amount FX",
	"Allocation9_Date" AS "Allocation9_Date",
	"Allocation9_InvoiceID" AS "Allocation9_InvoiceId" ,
	"Allocation10_AppliedAmount" AS "Allocation10_AppliedAmount" ,
	"Allocation10_AppliedAmount_AUD" AS "Allocation 10 Applied Amount FX",
	"Allocation10_Date" AS "Allocation10_Date",
	"Allocation10_InvoiceID" AS "Allocation10_InvoiceId" ,
	"Allocation11_AppliedAmount" AS "Allocation11_AppliedAmount" ,
	"Allocation11_AppliedAmount_AUD" AS "Allocation 11 Applied Amount FX",
	"Allocation11_Date" AS "Allocation11_Date",
	"Allocation11_InvoiceID" AS "Allocation11_InvoiceId" ,
	"Allocation12_AppliedAmount" AS "Allocation12_AppliedAmount" ,
	"Allocation12_AppliedAmount_AUD" AS "Allocation 12 Applied Amount FX",
	"Allocation12_Date" AS "Allocation12_Date",
	"Allocation12_InvoiceID" AS "Allocation12_InvoiceId" ,
	"Allocation13_AppliedAmount" AS "Allocation13_AppliedAmount" ,
	"Allocation13_AppliedAmount_AUD" AS "Allocation 13 Applied Amount FX",
	"Allocation13_Date" AS "Allocation13_Date",
	"Allocation13_InvoiceID" AS "Allocation13_InvoiceId" ,
	"Allocation14_AppliedAmount" AS "Allocation14_AppliedAmount" ,
	"Allocation14_AppliedAmount_AUD" AS "Allocation 14 Applied Amount FX",
	"Allocation14_Date" AS "Allocation14_Date",
	"Allocation14_InvoiceID" AS "Allocation14_InvoiceId" ,
	"Allocation15_AppliedAmount" AS "Allocation15_AppliedAmount" ,
	"Allocation15_AppliedAmount_AUD" AS "Allocation 15 Applied Amount FX",
	"Allocation15_Date" AS "Allocation15_Date",
	"Allocation15_InvoiceID" AS "Allocation15_InvoiceId" 
FROM NEW_CLIENT1_XEROBLUE_UniqueCreditNotes
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD
as
SELECT 
	   [OverpaymentId]
	  ,[Date]
      ,[Type]
      ,[RemainingCredit]
	  ,[RemainingCredit_AUD] 						AS "RemainingCredit FX" 
      ,[Contact_ContactId]							AS "Contact ID"
      ,[Contact_Name]								AS "Contact Name"
      ,[Status]								
	  ,[SubTotal] 
      ,[SubTotal_AUD] 								AS "SubTotal FX"
	  ,[TotalTax]
      ,[TotalTax_AUD] 								AS "TotalTax FX"
	  ,[Total]
      ,[Total_AUD] 									AS "Total FX"
      ,[LineItem_LineItemId]						AS "Line Item ID"
      ,[LineItem_Description]						AS "Description"
      ,[LineItem_Quantity]							AS "Quantity"
      ,[LineItem_UnitAmount]						AS "Unit Amount"
      ,[LineItem_ItemCode]							AS "Item Code"
      ,[LineItem_AccountCode]						AS "Account Code"
      ,[LineItem_TaxType]							AS "Tax Type"
	  ,[LineItem_TaxAmount]							AS "Tax Amount"
      ,[LineItem_TaxAmount_AUD] 					AS "Tax Amount FX"
	  ,[LineItem_LineAmount]						AS "Line Amount"					
      ,[LineItem_LineAmount_AUD] 					AS "Line Amount FX"
      ,[LineItem_TrackingCategory1_CategoryId]		AS "Tracking Category 1 Category ID"
      ,[LineItem_TrackingCategory1_CategoryName]	AS "Tracking Category 1 Category Name"
      ,[LineItem_TrackingCategory1_OptionId]		AS "Tracking Category 1 Option ID" 
      ,[LineItem_TrackingCategory1_OptionName]		AS "Tracking Category 1 Option Name" 
      ,[LineItem_TrackingCategory1_Option_Stat]		AS "Tracking Category 1 Option Stat" 
      ,[LineItem_TrackingCategory2_CategoryId]		AS "Tracking Category 2 Category ID" 
      ,[LineItem_TrackingCategory2_CategoryName]	AS "Tracking Category 2 Category Name" 	
      ,[LineItem_TrackingCategory2_OptionId]		AS "Tracking Category 2 Option ID" 
      ,[LineItem_TrackingCategory2_OptionName]		AS "Tracking Category 2 Option Name" 
      ,[LineItem_TrackingCategory2_Option_Stat]		AS "Tracking Category 2 Option Stat" 
      ,[LineItem_DiscountRate]						AS "Discount Rate"
      ,[LineAmountTypes]							AS "Line Amount Types"
      ,[CurrencyCode]								AS "Currency Code"
      ,[CurrencyRate]								AS "Currency Rate"
      ,[UpdatedDateUTC]								AS "Updated Date UTC"
	  ,[Allocation1_AppliedAmount]					AS "Allocation 1 Applied Amount"
      ,[Allocation1_AppliedAmount_AUD]				AS "Allocation 1 Applied Amount FX"
      ,[Allocation1_Date]							AS "Allocation 1 Date"	
      ,[Allocation1_InvoiceId]						AS "Allocation 1 Invoice ID"
      ,[Allocation1_InvoiceNumber]					AS "Allocation 1 Invoice Number"
	  ,[Allocation2_AppliedAmount]					AS "Allocation 2 Applied Amount"			
      ,[Allocation2_AppliedAmount_AUD]				AS "Allocation 2 Applied Amount FX"
      ,[Allocation2_Date]							AS "Allocation 2 Date"	
      ,[Allocation2_InvoiceId]						AS "Allocation 2 Invoice ID"
      ,[Allocation2_InvoiceNumber]					AS "Allocation 2 Invoice Number"
	  ,[Allocation3_AppliedAmount]					AS "Allocation 3 Applied Amount" 
      ,[Allocation3_AppliedAmount_AUD]				AS "Allocation 3 Applied Amount FX"
      ,[Allocation3_Date]							AS "Allocation 3 Date"	
      ,[Allocation3_InvoiceId]						AS "Allocation 3 Invoice ID"
      ,[Allocation3_InvoiceNumber]					AS "Allocation 3 Invoice Number"
	  ,[Allocation4_AppliedAmount] 					AS "Allocation 4 Applied Amount" 
      ,[Allocation4_AppliedAmount_AUD]				AS "Allocation 4 Applied Amount FX"
      ,[Allocation4_Date]							AS "Allocation 4 Date"
      ,[Allocation4_InvoiceId]						AS "Allocation 4 Invoice ID"
      ,[Allocation4_InvoiceNumber]					AS "Allocation 4 Invoice Number"
	  ,[Allocation5_AppliedAmount]  				AS "Allocation 5 Applied Amount" 
      ,[Allocation5_AppliedAmount_AUD]				AS "Allocation 5 Applied Amount FX"
      ,[Allocation5_Date]							AS "Allocation 5 Date"
      ,[Allocation5_InvoiceId]						AS "Allocation 5 Invoice ID"
      ,[Allocation5_InvoiceNumber]					AS "Allocation 5 Invoice Number"
	  ,[Allocation6_AppliedAmount]					AS "Allocation 6 Applied Amount" 
      ,[Allocation6_AppliedAmount_AUD]				AS "Allocation 6 Applied Amount FX"
      ,[Allocation6_Date]							AS "Allocation 6 Date"
      ,[Allocation6_InvoiceId]						AS "Allocation 6 Invoice ID"
      ,[Allocation6_InvoiceNumber]					AS "Allocation 6 Invoice Number"
	  ,[Allocation7_AppliedAmount]					AS "Allocation 7 Applied Amount" 
      ,[Allocation7_AppliedAmount_AUD]				AS "Allocation 7 Applied Amount FX"
      ,[Allocation7_Date]							AS "Allocation 7 Date"
      ,[Allocation7_InvoiceId]						AS "Allocation 7 Invoice ID"
      ,[Allocation7_InvoiceNumber]					AS "Allocation 7 Invoice Number"
	  ,[Allocation8_AppliedAmount] 					AS "Allocation 8 Applied Amount" 
      ,[Allocation8_AppliedAmount_AUD]				AS "Allocation 8 Applied Amount FX"
      ,[Allocation8_Date]							AS "Allocation 8 Date"
      ,[Allocation8_InvoiceId]						AS "Allocation 8 Invoice ID"
      ,[Allocation8_InvoiceNumber]					AS "Allocation 8 Invoice Number"
	  ,[Allocation9_AppliedAmount]  				AS "Allocation 9 Applied Amount"
      ,[Allocation9_AppliedAmount_AUD]				AS "Allocation 9 Applied Amount FX"
      ,[Allocation9_Date]							AS "Allocation 9 Date"
      ,[Allocation9_InvoiceId]						AS "Allocation 9 Invoice ID"
      ,[Allocation9_InvoiceNumber]					AS "Allocation 9 Invoice Number"
	  ,[Allocation10_AppliedAmount]   				AS "Allocation 10 Applied Amount"
      ,[Allocation10_AppliedAmount_AUD]				AS "Allocation 10 Applied Amount FX"
      ,[Allocation10_Date]							AS "Allocation 10 Date"
      ,[Allocation10_InvoiceId]						AS "Allocation 10 Invoice ID"
      ,[Allocation10_InvoiceNumber]					AS "Allocation 10 Invoice Number"
      ,[HasAttachments]								AS [Has Attachments]
      ,[Payments]
      ,[ClientID]									AS [Client ID]
      ,[OrganisationID]								AS [Organisation ID]
FROM dbo.NEW_CLIENT1_XEROBLUE_Overpayments a
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
as
SELECT 
	[Id]
    ,[CreditNoteId]
    ,[CreditNoteNumber]
    ,[Reference]
    ,[Type]
    ,[Contact_ContactId]
    ,[Contact_Name]
    ,[Date]
    ,[Status]
    ,[LineAmountTypes]
    ,[LineItem_Quantity]
    ,[LineItem_Description]
    ,[LineItem_UnitAmount]
    ,[LineItem_ItemCode]
    ,[LineItem_AccountCode]
    ,[LineItem_TaxType]
    ,[LineItem_TaxAmount] 
	,[LineItem_TaxAmount_AUD] AS "LineItem_TaxAmount FX"
    ,[LineItem_LineAmount]
	,[LineItem_LineAmount_AUD] AS "LineItem_LineAmount FX"
    ,[LineItem_TrackingCategory1_CategoryId]
    ,[LineItem_TrackingCategory1_CategoryName]
    ,[LineItem_TrackingCategory1_OptionId]
    ,[LineItem_TrackingCategory1_OptionName]
    ,[LineItem_TrackingCategory1_Option_Stat]
    ,[LineItem_TrackingCategory2_CategoryId]
    ,[LineItem_TrackingCategory2_CategoryName]
    ,[LineItem_TrackingCategory2_OptionId]
    ,[LineItem_TrackingCategory2_OptionName]
    ,[LineItem_TrackingCategory2_Option_Stat]
    ,[LineItem_DiscountRate]
    ,[LineItemAggregate]
	,[SubTotal]
    ,[SubTotal_AUD] AS "SubTotal FX"
    ,[TotalTax]
	,[TotalTax_AUD] AS "TotalTax FX"
    ,[Total]
	,[Total_AUD] AS "Total FX"
    ,[UpdatedDateUTC]
    ,[CurrencyCode]
    ,[FullyPaidOnDate]
    ,[SentToContact]
    ,[BrandingThemeId]
    ,[CurrencyRate]
    ,[RemainingCredit]
    ,[RemainingCredit_AUD] as "RemainingCredit FX"
    ,[Allocation1_AppliedAmount]
	,[Allocation1_AppliedAmount_AUD] as "Allocation1_AppliedAmount FX"
    ,[Allocation1_Date]
    ,[Allocation1_InvoiceId]
    ,[Allocation1_InvoiceNumber]
	,[Allocation2_AppliedAmount]
    ,[Allocation2_AppliedAmount_AUD] as "Allocation2_AppliedAmount FX"
    ,[Allocation2_Date]
    ,[Allocation2_InvoiceId]
    ,[Allocation2_InvoiceNumber]
	,[Allocation3_AppliedAmount]
    ,[Allocation3_AppliedAmount_AUD] as "Allocation3_AppliedAmount FX"
    ,[Allocation3_Date]
    ,[Allocation3_InvoiceId]
    ,[Allocation3_InvoiceNumber]
	,[Allocation4_AppliedAmount]
    ,[Allocation4_AppliedAmount_AUD] as "Allocation4_AppliedAmount FX"
    ,[Allocation4_Date]
    ,[Allocation4_InvoiceId]
    ,[Allocation4_InvoiceNumber]
	,[Allocation5_AppliedAmount]
    ,[Allocation5_AppliedAmount_AUD] as "Allocation5_AppliedAmount FX"
    ,[Allocation5_Date]
    ,[Allocation5_InvoiceId]
    ,[Allocation5_InvoiceNumber]
	,[Allocation6_AppliedAmount]
    ,[Allocation6_AppliedAmount_AUD] as "Allocation6_AppliedAmount FX"
    ,[Allocation6_Date]
    ,[Allocation6_InvoiceId]
    ,[Allocation6_InvoiceNumber]
	,[Allocation7_AppliedAmount]
    ,[Allocation7_AppliedAmount_AUD] as "Allocation7_AppliedAmount FX"
    ,[Allocation7_Date]
    ,[Allocation7_InvoiceId]
    ,[Allocation7_InvoiceNumber]
	,[Allocation8_AppliedAmount]
    ,[Allocation8_AppliedAmount_AUD] as "Allocation8_AppliedAmount FX"
    ,[Allocation8_Date]
    ,[Allocation8_InvoiceId]
    ,[Allocation8_InvoiceNumber]
	,[Allocation9_AppliedAmount]
    ,[Allocation9_AppliedAmount_AUD] as "Allocation9_AppliedAmount FX"
    ,[Allocation9_Date]
    ,[Allocation9_InvoiceId]
    ,[Allocation9_InvoiceNumber]
	,[Allocation10_AppliedAmount]
    ,[Allocation10_AppliedAmount_AUD] as "Allocation10_AppliedAmount FX"
    ,[Allocation10_Date]
    ,[Allocation10_InvoiceId]
    ,[Allocation10_InvoiceNumber]
	,[Allocation11_AppliedAmount]
    ,[Allocation11_AppliedAmount_AUD] as "Allocation11_AppliedAmount FX"
    ,[Allocation11_Date]
    ,[Allocation11_InvoiceId]
    ,[Allocation11_InvoiceNumber]
	,[Allocation12_AppliedAmount]
    ,[Allocation12_AppliedAmount_AUD] as "Allocation12_AppliedAmount FX"
    ,[Allocation12_Date]
    ,[Allocation12_InvoiceId]
    ,[Allocation12_InvoiceNumber]
	,[Allocation13_AppliedAmount]
    ,[Allocation13_AppliedAmount_AUD] as "Allocation13_AppliedAmount FX"
    ,[Allocation13_Date]
    ,[Allocation13_InvoiceId]
    ,[Allocation13_InvoiceNumber]
	,[Allocation14_AppliedAmount]
    ,[Allocation14_AppliedAmount_AUD] as "Allocation14_AppliedAmount FX"
    ,[Allocation14_Date]
    ,[Allocation14_InvoiceId]
    ,[Allocation14_InvoiceNumber]
	,[Allocation15_AppliedAmount]
    ,[Allocation15_AppliedAmount_AUD] as "Allocation15_AppliedAmount FX"
    ,[Allocation15_Date]
    ,[Allocation15_InvoiceId]
    ,[Allocation15_InvoiceNumber]
    ,[HasAttachments]
    ,[ClientID]
    ,[OrganisationID]
FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD
as
SELECT 
	   [PrepaymentId]
      ,[Date]
      ,[Reference]
      ,[Type]
      ,[RemainingCredit]
	  ,[RemainingCredit_AUD]   						AS "RemainingCredit FX"
      ,[Contact_ContactId]							AS "Contact ID"
      ,[Contact_Name]								AS "Contact Name"
      ,[Status]
      ,[SubTotal]
	  ,[SubTotal_AUD]  								AS "SubTotal FX"
      ,[TotalTax]  
	  ,[TotalTax_AUD]   							AS "TotalTax FX"
      ,[Total]
	  ,[Total_AUD]   								AS "Total FX"
      ,[LineItem_LineItemId]						AS "Line Item ID"
      ,[LineItem_Description]						AS "Description"
      ,[LineItem_Quantity]							AS "Quantity"
      ,[LineItem_UnitAmount]						AS "Unit Amount"
      ,[LineItem_ItemCode]							AS "Item Code"
      ,[LineItem_AccountCode]						AS "Account Code"
      ,[LineItem_TaxType]							AS "Tax Type"
	  ,[LineItem_TaxAmount]							AS "Tax Amount"
	  ,[LineItem_TaxAmount_AUD]  					AS "Tax Amount FX"
      ,[LineItem_LineAmount]						AS "Line Amount"
	  ,[LineItem_LineAmount_AUD]  					AS "Line Amount FX"
      ,[LineItem_TrackingCategory1_CategoryId]		AS "Tracking Category 1 Category ID"
      ,[LineItem_TrackingCategory1_CategoryName]	AS "Tracking Category 1 Category Name"
      ,[LineItem_TrackingCategory1_OptionId]		AS "Tracking Category 1 Option ID" 
      ,[LineItem_TrackingCategory1_OptionName]		AS "Tracking Category 1 Option Name" 
      ,[LineItem_TrackingCategory1_Option_Stat]		AS "Tracking Category 1 Option Stat" 
      ,[LineItem_TrackingCategory2_CategoryId]		AS "Tracking Category 2 Category ID" 
      ,[LineItem_TrackingCategory2_CategoryName]	AS "Tracking Category 2 Category Name" 	
      ,[LineItem_TrackingCategory2_OptionId]		AS "Tracking Category 2 Option ID" 
      ,[LineItem_TrackingCategory2_OptionName]		AS "Tracking Category 2 Option Name" 
      ,[LineItem_TrackingCategory2_Option_Stat]		AS "Tracking Category 2 Option Stat" 
      ,[LineItem_DiscountRate]						AS "Discount Rate"
      ,[LineAmountTypes]							AS "Line Amount Types"
      ,[CurrencyCode]
      ,[CurrencyRate]
      ,[UpdatedDateUTC]								AS [Updated Date UTC]
	  ,[Allocation1_AppliedAmount]					AS "Allocation 1 Applied Amount"
      ,[Allocation1_AppliedAmount_AUD]				AS "Allocation 1 Applied Amount FX"
      ,[Allocation1_Date]							AS "Allocation 1 Date"	
      ,[Allocation1_InvoiceId]						AS "Allocation 1 Invoice ID"
      ,[Allocation1_InvoiceNumber]					AS "Allocation 1 Invoice Number"
	  ,[Allocation2_AppliedAmount]					AS "Allocation 2 Applied Amount"			
      ,[Allocation2_AppliedAmount_AUD]				AS "Allocation 2 Applied Amount FX"
      ,[Allocation2_Date]							AS "Allocation 2 Date"	
      ,[Allocation2_InvoiceId]						AS "Allocation 2 Invoice ID"
      ,[Allocation2_InvoiceNumber]					AS "Allocation 2 Invoice Number"
	  ,[Allocation3_AppliedAmount]					AS "Allocation 3 Applied Amount" 
      ,[Allocation3_AppliedAmount_AUD]				AS "Allocation 3 Applied Amount FX"
      ,[Allocation3_Date]							AS "Allocation 3 Date"	
      ,[Allocation3_InvoiceId]						AS "Allocation 3 Invoice ID"
      ,[Allocation3_InvoiceNumber]					AS "Allocation 3 Invoice Number"
	  ,[Allocation4_AppliedAmount] 					AS "Allocation 4 Applied Amount" 
      ,[Allocation4_AppliedAmount_AUD]				AS "Allocation 4 Applied Amount FX"
      ,[Allocation4_Date]							AS "Allocation 4 Date"
      ,[Allocation4_InvoiceId]						AS "Allocation 4 Invoice ID"
      ,[Allocation4_InvoiceNumber]					AS "Allocation 4 Invoice Number"
	  ,[Allocation5_AppliedAmount]  				AS "Allocation 5 Applied Amount" 
      ,[Allocation5_AppliedAmount_AUD]				AS "Allocation 5 Applied Amount FX"
      ,[Allocation5_Date]							AS "Allocation 5 Date"
      ,[Allocation5_InvoiceId]						AS "Allocation 5 Invoice ID"
      ,[Allocation5_InvoiceNumber]					AS "Allocation 5 Invoice Number"
	  ,[Allocation6_AppliedAmount]					AS "Allocation 6 Applied Amount" 
      ,[Allocation6_AppliedAmount_AUD]				AS "Allocation 6 Applied Amount FX"
      ,[Allocation6_Date]							AS "Allocation 6 Date"
      ,[Allocation6_InvoiceId]						AS "Allocation 6 Invoice ID"
      ,[Allocation6_InvoiceNumber]					AS "Allocation 6 Invoice Number"
	  ,[Allocation7_AppliedAmount]					AS "Allocation 7 Applied Amount" 
      ,[Allocation7_AppliedAmount_AUD]				AS "Allocation 7 Applied Amount FX"
      ,[Allocation7_Date]							AS "Allocation 7 Date"
      ,[Allocation7_InvoiceId]						AS "Allocation 7 Invoice ID"
      ,[Allocation7_InvoiceNumber]					AS "Allocation 7 Invoice Number"
	  ,[Allocation8_AppliedAmount] 					AS "Allocation 8 Applied Amount" 
      ,[Allocation8_AppliedAmount_AUD]				AS "Allocation 8 Applied Amount FX"
      ,[Allocation8_Date]							AS "Allocation 8 Date"
      ,[Allocation8_InvoiceId]						AS "Allocation 8 Invoice ID"
      ,[Allocation8_InvoiceNumber]					AS "Allocation 8 Invoice Number"
	  ,[Allocation9_AppliedAmount]  				AS "Allocation 9 Applied Amount"
      ,[Allocation9_AppliedAmount_AUD]				AS "Allocation 9 Applied Amount FX"
      ,[Allocation9_Date]							AS "Allocation 9 Date"
      ,[Allocation9_InvoiceId]						AS "Allocation 9 Invoice ID"
      ,[Allocation9_InvoiceNumber]					AS "Allocation 9 Invoice Number"
	  ,[Allocation10_AppliedAmount]   				AS "Allocation 10 Applied Amount"
      ,[Allocation10_AppliedAmount_AUD]				AS "Allocation 10 Applied Amount FX"
      ,[Allocation10_Date]							AS "Allocation 10 Date"
      ,[Allocation10_InvoiceId]						AS "Allocation 10 Invoice ID"
      ,[Allocation10_InvoiceNumber]					AS "Allocation 10 Invoice Number"
      ,[HasAttachments]
      ,[Payments]
      ,[ClientID]									AS "Client ID"
      ,[OrganisationID]								AS [Organisation ID]
FROM dbo.NEW_CLIENT1_XEROBLUE_Prepayments
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal_AUD
as
SELECT 
	   [Id]
      ,[InvoiceId]
      ,[Type]
      ,[ContactId]
      ,[ContactName]
      ,[LineItem_LineItemId]
      ,[LineItem_Description]
      ,[LineItem_Quantity]
      ,[LineItem_UnitAmount]
      ,[LineItem_ItemCode]
      ,[LineItem_AccountCode]
      ,[LineItem_TaxType]
      ,[LineItem_TaxAmount]
	  ,[LineItem_TaxAmount_AUD] AS "LineItem_TaxAmount FX"
      ,[LineItem_LineAmount]
	  ,[LineItem_LineAmount_AUD] AS "LineItem_LineAmount FX"
      ,[LineItem_TrackingCategory1_CategoryId]
      ,[LineItem_TrackingCategory1_CategoryName]
      ,[LineItem_TrackingCategory1_OptionId]
      ,[LineItem_TrackingCategory1_OptionName]
      ,[LineItem_TrackingCategory1_Option_Stat]
      ,[LineItem_TrackingCategory2_CategoryId]
      ,[LineItem_TrackingCategory2_CategoryName]
      ,[LineItem_TrackingCategory2_OptionId]
      ,[LineItem_TrackingCategory2_OptionName]
      ,[LineItem_TrackingCategory2_Option_Stat]
      ,[LineItem_DiscountRate]
      ,[LineItem_DiscountAmount]
	  ,[LineItem_DiscountAmount_AUD] AS "LineItem_DiscountAmount FX"
      ,[LineItemAggregate]
      ,[Date]
      ,[DueDate]
      ,[LineAmountTypes]
      ,[InvoiceNumber]
      ,[Reference]
      ,[BrandingThemeId]
      ,[URL]
      ,[CurrencyCode]
      ,[CurrencyRate]
      ,[Status]
      ,[SentToContact]
      ,[ExpectedPaymentDate]
      ,[PlannedPaymentDate]
      ,[SubTotal]
	  ,[SubTotal_AUD] AS "SubTotal FX"
      ,[TotalTax]
	  ,[TotalTax_AUD] AS "TotalTax FX"
      ,[Total]
	  ,[Total_AUD] AS "Total FX"
      ,[TotalDiscount] 
	  ,[TotalDiscount_AUD] AS "TotalDiscount FX"
      ,[HasAttachments]
      ,[PaymentIds]
      ,[PrePaymentIds]
      ,[OverPaymentIds]
      ,[CreditNoteIds]
      ,[AmountDue] 
	  ,[AmountDue_AUD] AS "AmountDue FX"
      ,[AmountPaid]
	  ,[AmountPaid_AUD] AS "Amount Paid FX"
      ,[CISDeduction] 
	  ,[CISDeduction_AUD] AS "CISDeduction FX"
      ,[FullyPaidOnDate]
      ,[AmountCredited]
	  ,[AmountCredited_AUD] AS "AmountCredited FX"
      ,[UpdatedDateUTC]
      ,[CreditNotes]
      ,[Prepayments]
      ,[Payments]
      ,[Overpayments]
      ,[RepeatingInvoiceID]
      ,[ClientID]
      ,[OrganisationID]
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices  a
WHERE Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD
as
SELECT 
	 [PaymentId]
	,[Date]
	,[Amount]
	,[CurrencyRate]
	,[Reference]
	,[PaymentType]
	,[Status]
	,[UpdatedDateUTC]
	,[IsReconciled]
	,[BatchPaymentId]
	,[InvoiceId]
	,[InvoiceNumber]
	,[CreditNoteId]
	,[CreditNoteNumber]
	,[AccountId]
	,[AccountCode]
	,[ClientID]
	,[OrganisationID]
	,[Amount_AUD] AS "Amount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_Payments I
WHERE Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation_AUD
as
SELECT
	I.Id,
	I.InvoiceId,
	I.Type,
	I.ContactId,
	I.ContactName,
	I.LineItem_LineItemId,
	I.LineItem_Description,
	I.LineItem_Quantity,
	I.LineItem_UnitAmount,
	I.LineItem_ItemCode,
	I.LineItem_AccountCode,
	I.LineItem_TaxType,
	I.LineItem_TaxAmount,
	I.LineItem_LineAmount,
	I.LineItem_TrackingCategory1_CategoryId,
	I.LineItem_TrackingCategory1_CategoryName,
	I.LineItem_TrackingCategory1_OptionId,
	I.LineItem_TrackingCategory1_OptionName,
	I.LineItem_TrackingCategory1_Option_Stat,
	I.LineItem_TrackingCategory2_CategoryId,
	I.LineItem_TrackingCategory2_CategoryName,
	I.LineItem_TrackingCategory2_OptionId,
	I.LineItem_TrackingCategory2_OptionName,
	I.LineItem_TrackingCategory2_Option_Stat,
	I.LineItem_DiscountRate,
	I.LineItem_DiscountAmount,
	I.LineItemAggregate,
	I.Date,
	I.DueDate,
	I.LineAmountTypes,
	I.InvoiceNumber,
	I.Reference,
	I.BrandingThemeId,
	I.URL,
	I.CurrencyCode,
	I.CurrencyRate,
	I.Status,
	I.SentToContact,
	I.ExpectedPaymentDate,
	I.PlannedPaymentDate,
	I.SubTotal,
	I.TotalTax,
	I.Total,
	I.TotalDiscount,
	I.HasAttachments,
	I.PaymentIds,
	I.PrePaymentIds,
	I.OverPaymentIds,
	I.CreditNoteIds,
	I.AmountDue,
	I.AmountPaid,
	I.CISDeduction,
	I.FullyPaidOnDate,
	I.AmountCredited,
	I.UpdatedDateUTC,
	I.CreditNotes,
	I.Prepayments,
	I.Payments,
	I.Overpayments,
	I.RepeatingInvoiceID,
	I.ClientID,
	I.OrganisationID,		
	a.InvoiceId OverPaymentInvoiceId,
	OverPaymentId,
	Allocation OverPaymentAllocation,
	Dt OverPaymentDate,
	Amount OverPaymentAmount,
	I.LineItem_LineAmount_AUD AS "LineItem_LineAmount FX",
	I.LineItem_TaxAmount_AUD AS "LineItem_TaxAmount FX",
	I.AmountDue_AUD AS "AmountDue FX",
	I.AmountPaid_AUD AS "AmountPaid FX",
	I.CISDeduction_AUD AS "CISDeduction FX",
	I.AmountCredited_AUD AS "AmountCredited FX",
	[Amount FX] AS "OverPaymentAmount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I
INNER JOIN 
(	
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 1 Invoice ID] AS InvoiceId, 
		1 Allocation,
		[Allocation 1 Date] AS Dt,
		[Allocation 1 Applied Amount] AS Amount,
		[Allocation 1 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 1 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 2 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 2 Date] AS Dt,
		[Allocation 2 Applied Amount] AS Amount,
		[Allocation 2 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 2 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 3 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 3 Date] AS Dt,
		[Allocation 3 Applied Amount] AS Amount,
		[Allocation 3 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 3 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 4 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 4 Date] AS Dt,
		[Allocation 4 Applied Amount] AS Amount,
		[Allocation 4 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 4 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 5 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 5 Date] AS Dt,
		[Allocation 5 Applied Amount] AS Amount,
		[Allocation 5 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 5 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 6 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 6 Date] AS Dt,
		[Allocation 6 Applied Amount] AS Amount,
		[Allocation 6 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 6 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 7 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 7 Date] AS Dt,
		[Allocation 7 Applied Amount] AS Amount,
		[Allocation 7 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 7 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 8 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 8 Date] AS Dt,
		[Allocation 8 Applied Amount] AS Amount,
		[Allocation 8 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 8 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 9 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 9 Date] AS Dt,
		[Allocation 9 Applied Amount] AS Amount,
		[Allocation 9 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 9 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		OverpaymentID,
		[Allocation 10 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 10 Date] AS Dt,
		[Allocation 10 Applied Amount] AS Amount,
		[Allocation 10 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.[Organisation ID]
WHERE I.Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation_AUD
as
SELECT 
	 I.Id
	,I.InvoiceId
	,I.Type
	,I.ContactId
	,I.ContactName
	,I.LineItem_LineItemId
	,I.LineItem_Description
	,I.LineItem_Quantity
	,I.LineItem_UnitAmount
	,I.LineItem_ItemCode
	,I.LineItem_AccountCode
	,I.LineItem_TaxType
	,I.LineItem_TaxAmount
	,I.LineItem_LineAmount
	,I.LineItem_TrackingCategory1_CategoryId
	,I.LineItem_TrackingCategory1_CategoryName
	,I.LineItem_TrackingCategory1_OptionId
	,I.LineItem_TrackingCategory1_OptionName
	,I.LineItem_TrackingCategory1_Option_Stat
	,I.LineItem_TrackingCategory2_CategoryId
	,I.LineItem_TrackingCategory2_CategoryName
	,I.LineItem_TrackingCategory2_OptionId
	,I.LineItem_TrackingCategory2_OptionName
	,I.LineItem_TrackingCategory2_Option_Stat
	,I.LineItem_DiscountRate
	,I.LineItem_DiscountAmount
	,I.LineItemAggregate
	,I.Date
	,I.DueDate
	,I.LineAmountTypes
	,I.InvoiceNumber
	,I.Reference
	,I.BrandingThemeId
	,I.URL
	,I.CurrencyCode
	,I.CurrencyRate
	,I.Status
	,I.SentToContact
	,I.ExpectedPaymentDate
	,I.PlannedPaymentDate
	,I.SubTotal
	,I.TotalTax
	,I.Total
	,I.TotalDiscount
	,I.HasAttachments
	,I.PaymentIds
	,I.PrePaymentIds
	,I.OverPaymentIds
	,I.CreditNoteIds
	,I.AmountDue
	,I.AmountPaid
	,I.CISDeduction
	,I.FullyPaidOnDate
	,I.AmountCredited
	,I.UpdatedDateUTC
	,I.CreditNotes
	,I.Prepayments
	,I.Payments
	,I.Overpayments
	,I.RepeatingInvoiceID
	,I.ClientID
	,I.OrganisationID
	,a.InvoiceId PrePaymentInvoiceId
	,PrePaymentId
	,Allocation PrePaymentAllocation
	,Dt PrePaymentDate
	,Amount PrePaymentAmount
	,CAST(I."OrganisationID" AS VARCHAR) + I."LineItem_AccountCode" AS "Account UID"
	,I.AmountCredited_AUD AS "AmountCredited FX"
	,I.AmountDue_AUD AS "AmountDue FX"
	,I.AmountPaid_AUD AS "AmountPaid FX"
	,I.CISDeduction_AUD AS "CISDeduction FX"
	,I.LineItem_DiscountAmount_AUD AS "LineItem_DiscountAmount FX"
	,I.LineItem_LineAmount_AUD AS "LineItem_LineAmount FX"
	,I.LineItem_TaxAmount_AUD AS "LineItem_TaxAmount FX"
	,I.SubTotal_AUD AS "SubTotal FX"
	,I.Total_AUD AS "Total FX"
	,I.TotalTax_AUD AS "TotalTax FX"
	,I.TotalDiscount_AUD AS "TotalDiscount FX"
	,[Amount FX] AS "PrePaymentAmount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I
INNER JOIN 
(
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 1 Invoice ID] AS InvoiceId, 
		1 Allocation,
		[Allocation 1 Date] AS Dt,
		[Allocation 1 Applied Amount] AS Amount,
		[Allocation 1 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 1 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 2 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 2 Date] AS Dt,
		[Allocation 2 Applied Amount] AS Amount,
		[Allocation 2 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 2 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 3 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 3 Date] AS Dt,
		[Allocation 3 Applied Amount] AS Amount,
		[Allocation 3 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 3 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 4 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 4 Date] AS Dt,
		[Allocation 4 Applied Amount] AS Amount,
		[Allocation 4 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 4 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 5 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 5 Date] AS Dt,
		[Allocation 5 Applied Amount] AS Amount,
		[Allocation 5 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 5 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 6 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 6 Date] AS Dt,
		[Allocation 6 Applied Amount] AS Amount,
		[Allocation 6 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 6 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 7 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 7 Date] AS Dt,
		[Allocation 7 Applied Amount] AS Amount,
		[Allocation 7 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 7 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 8 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 8 Date] AS Dt,
		[Allocation 8 Applied Amount] AS Amount,
		[Allocation 8 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 8 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 9 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 9 Date] AS Dt,
		[Allocation 9 Applied Amount] AS Amount,
		[Allocation 9 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 9 Applied Amount] IS not null
	UNION ALL
	SELECT 
		[Organisation ID],
		PrepaymentId,
		[Allocation 10 Invoice ID] AS InvoiceId, 
		2 Allocation,
		[Allocation 10 Date] AS Dt,
		[Allocation 10 Applied Amount] AS Amount,
		[Allocation 10 Applied Amount FX] AS [Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.[Organisation ID]
WHERE I.Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation_AUD
as
SELECT
	I.Id
	,I.InvoiceId
	,I.Type
	,I.ContactId
	,I.ContactName
	,I.LineItem_LineItemId
	,I.LineItem_Description
	,I.LineItem_Quantity
	,I.LineItem_UnitAmount
	,I.LineItem_ItemCode
	,I.LineItem_AccountCode
	,I.LineItem_TaxType
	,I.LineItem_TaxAmount
	,I.LineItem_LineAmount
	,I.LineItem_TrackingCategory1_CategoryId
	,I.LineItem_TrackingCategory1_CategoryName
	,I.LineItem_TrackingCategory1_OptionId
	,I.LineItem_TrackingCategory1_OptionName
	,I.LineItem_TrackingCategory1_Option_Stat
	,I.LineItem_TrackingCategory2_CategoryId
	,I.LineItem_TrackingCategory2_CategoryName
	,I.LineItem_TrackingCategory2_OptionId
	,I.LineItem_TrackingCategory2_OptionName
	,I.LineItem_TrackingCategory2_Option_Stat
	,I.LineItem_DiscountRate
	,I.LineItem_DiscountAmount
	,I.LineItemAggregate
	,I.Date
	,I.DueDate
	,I.LineAmountTypes
	,I.InvoiceNumber
	,I.Reference
	,I.BrandingThemeId
	,I.URL
	,I.CurrencyCode
	,I.CurrencyRate
	,I.Status
	,I.SentToContact
	,I.ExpectedPaymentDate
	,I.PlannedPaymentDate
	,I.SubTotal
	,I.TotalTax
	,I.Total
	,I.TotalDiscount
	,I.HasAttachments
	,I.PaymentIds
	,I.PrePaymentIds
	,I.OverPaymentIds
	,I.CreditNoteIds
	,I.AmountDue
	,I.AmountPaid
	,I.CISDeduction
	,I.FullyPaidOnDate
	,I.AmountCredited
	,I.UpdatedDateUTC
	,I.CreditNotes
	,I.Prepayments
	,I.Payments
	,I.Overpayments
	,I.RepeatingInvoiceID
	,I.ClientID
	,I.OrganisationID
	,a.InvoiceId CreditNoteInvoiceId
	,CreditNoteId
	,Allocation CreditNoteAllocation
	,Dt CreditNoteDate
	,Amount CreditNoteAmount
	,[Allocation 1 Applied Amount FX] AS "CreditNoteAmount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices I 
INNER JOIN 
(
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount,
		[Allocation 1 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation1_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount,
		[Allocation 2 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation2_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount,
		[Allocation 3 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation3_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount,
		[Allocation 4 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation4_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount,			
		[Allocation 5 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation6_InvoiceId AS InvoiceId, 
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount,
		[Allocation 6 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation6_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount,
		[Allocation 7 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation7_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount,
		[Allocation 8 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation8_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount,
		[Allocation 9 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation9_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount,
		[Allocation 10 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation10_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation11_InvoiceId AS InvoiceId,
		11 Allocation,
		Allocation11_Date AS Dt,
		Allocation11_AppliedAmount AS Amount,
		[Allocation 11 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation11_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation12_InvoiceId AS InvoiceId,
		12 Allocation,
		Allocation12_Date AS Dt,
		Allocation12_AppliedAmount AS Amount,
		[Allocation 12 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation12_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation13_InvoiceId AS InvoiceId,
		13 Allocation,
		Allocation13_Date AS Dt,
		Allocation13_AppliedAmount AS Amount,
		[Allocation 13 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation13_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation14_InvoiceId AS InvoiceId,
		14 Allocation,
		Allocation14_Date AS Dt,
		Allocation14_AppliedAmount AS Amount,
		[Allocation 14 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation14_AppliedAmount IS not null
	UNION ALL
	SELECT 
		OrganisationId, 
		CreditNoteId,
		Allocation15_InvoiceId AS InvoiceId,
		15 Allocation,
		Allocation15_Date AS Dt,
		Allocation15_AppliedAmount AS Amount,
		[Allocation 15 Applied Amount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_uniquecreditnotes_AUD
	WHERE Allocation15_AppliedAmount IS not null
) a ON I.InvoiceId = a.InvoiceId AND i.OrganisationId = a.OrganisationId
WHERE I.Status in ('AUTHORISED', 'PAID')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceAllocations_AUD
as
SELECT
	* 
FROM
(
	SELECT
		I.*,
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
		ppa.[PrePaymentAmount FX],
		opa.OverpaymentId, 
		opa.OverPaymentAllocation,
		opa.OverPaymentDate, 
		opa.OverPaymentAmount,
		opa.[OverPaymentAmount FX],
		ISNULL(I."LineItem_AccountCode",'BLANK') + '-' + CAST(I."OrganisationID" AS varchar) AS "Account_UID" ,
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
   			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
   			ELSE 0 END AS decimal(15,4)
 		) AS "OP Allocation Amount FX",  
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
   			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
   			ELSE 0 END AS decimal(15,4)
 		) AS "PP Allocation Amount FX",   	

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
   				WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]-I.[LineItem_TaxAmount FX])*(ca.[CreditNoteAmount]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
   			ELSE 0 END AS decimal(15,4)
 		) AS "CN Allocation Amount FX",   
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
   			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND opa.[OverPaymentAmount] <> 0 AND opa.[OverPaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(opa.[OverPaymentAmount FX]/I.[Total FX]))
   			ELSE 0 END AS decimal(15,4)
 		) AS "OP Allocation Amount Inc Tax FX",  
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
   				WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX]))
				WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ppa.[PrePaymentAmount] <> 0 AND ppa.[PrePaymentAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(ppa.[PrePaymentAmount FX]/I.[Total FX] ))
			ELSE 0 END AS decimal(15,4)
 		) AS "PP Allocation Amount Inc Tax FX",   	
		CAST(
			CASE 
   			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount])*(ca.[CreditNoteAmount]/I.[Total]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount]+I.[LineItem_TaxAmount])*(ca.[CreditNoteAmount]/I.[Total]))
   			ELSE 0 END AS decimal(15,4)
 			) AS "CN Allocation Amount Inc Tax"	,
		CAST(
			CASE 
   			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCREC' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN ((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Inclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
			WHEN I."LineAmountTypes" = 'Exclusive' AND I.Type = 'ACCPAY' AND ca.[CreditNoteAmount] <> 0 AND ca.[CreditNoteAmount] IS NOT NULL  THEN 0-((I.[LineItem_LineAmount FX]+I.[LineItem_TaxAmount FX])*(ca.[CreditNoteAmount FX]/I.[Total FX]))
   			ELSE 0 END AS decimal(15,4)
 		) AS "CN Allocation Amount Inc Tax FX"	
	FROM NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal_AUD I
		LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteAllocation_AUD AS ca
			ON I.InvoiceId = ca.InvoiceId and I.LineItem_LineItemId = ca.LineItem_LineItemId
		LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentAllocation_AUD PPA
			ON I.InvoiceId = PPA.InvoiceId and I.LineItem_LineItemId = PPA.LineItem_LineItemId
		LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentAllocation_AUD OPA
			ON I.InvoiceId = OPA.InvoiceId and I.LineItem_LineItemId = OPA.LineItem_LineItemId
	WHERE CA.InvoiceId IS NOT NULL OR PPA.InvoiceId IS NOT NULL  OR OPA.InvoiceId IS NOT NULL AND I.Status in ('AUTHORISED', 'PAID')
) as t
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePaymentCash_AUD
AS
SELECT I.*,
	P.Date AS PaymentDate,
	P.Amount AS PaymentAmount,
	P.[Amount FX] AS "PaymentAmount FX",
	P.PaymentType,
	P.AccountId PaymentAccountID,
	P.Status AS PaymentStatus,
	ISNULL(I."LineItem_AccountCode",'BLANK') + '-' + CAST(I."OrganisationID" AS varchar) AS "Account_UID" ,
	ISNULL(I."LineItem_DiscountRate", 0) AS "Discount Rate", 
	ISNULL(I."LineItem_DiscountRate" * 0.01, 0) AS "Discount Rate %",
	CAST(
		CASE 
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"-I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"-I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount",
	CAST(
		CASE 
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX"-I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX"-I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount FX",
 	CAST(
		CASE 
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		WHEN I."Total" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount"+I."LineItem_TaxAmount")*(P."Amount"/I."Total"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount Inc Tax", 	
	CAST(
		CASE 
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX"+I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCREC' THEN ((I."LineItem_LineAmount FX"+I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Inclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'Exclusive' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX"+I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		WHEN I."Total FX" <> 0 AND I.LineAmountTypes = 'NoTax' AND I.Type = 'ACCPAY' THEN 0-((I."LineItem_LineAmount FX"+I."LineItem_TaxAmount FX")*(P."Amount FX"/I."Total FX"))
		ELSE 0 END AS decimal(15,4)
 	) AS "Payments Calculated Amount Inc Tax FX"	
FROM NEW_CLIENT1.XEROBLUETABLES_invoicesOriginal_AUD I
INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD P ON I.InvoiceId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('ACCRECPAYMENT','ACCPAYPAYMENT') AND I.Status in ('AUTHORISED', 'PAID') AND P.Status in ('AUTHORISED')
GO

IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoicePrePaymentCash_AUD
AS
SELECT PP.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.[Amount FX] "PaymentAmount FX",
	P.PaymentType,
	P.Status PaymentStatus,
	P.AccountId PaymentAccountID,
	ISNULL(PP."Account Code",'BLANK') + '-' + CAST(PP."Organisation ID" AS varchar) AS "Account UID" ,
	CAST(
		CASE 
   		WHEN PP."Line Amount Types" = 'Inclusive' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL  THEN (PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."Line Amount Types" = 'NoTax' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN (PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."Line Amount Types" = 'Inclusive' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total]*(P.[Amount]/PP.[Total]))
		WHEN PP."Line Amount Types" = 'NoTax' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total]*(P.[Amount]/PP.[Total]))
   		ELSE 0 END AS decimal(15,4)
 	) AS "Prepayments Calculated Amount"  ,
	CAST(
		CASE 
   		WHEN PP.[Line Amount Types] = 'Inclusive' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL  THEN (PP.[Total FX]*(P.[Amount FX]/PP.[Total FX]))
		WHEN PP.[Line Amount Types] = 'NoTax' AND PP.Type = 'RECEIVE-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN (PP.[Total FX]*(P.[Amount FX]/PP.[Total FX]))
		WHEN PP.[Line Amount Types] = 'Inclusive' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total FX]*(P.[Amount FX]/PP.[Total FX]))
		WHEN PP.[Line Amount Types] = 'NoTax' AND PP.Type = 'SPEND-PREPAYMENT' AND PP.[Total] <> 0 AND PP.[Total] IS NOT NULL THEN 0-(PP.[Total FX]*(P.[Amount FX]/PP.[Total FX]))
   		ELSE 0 END AS decimal(15,4)
 	) AS "Prepayments Calculated Amount FX"  
FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD PP
INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD P ON PP.PrePaymentId = P.InvoiceId
WHERE UPPER(p.PaymentType) IN ('ARPREPAYMENTPAYMENT','APPREPAYMENTPAYMENT') AND PP.Status IN ('AUTHORISED', 'PAID') AND P.Status IN ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceOverPaymentCash_AUD
AS
SELECT OP.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.[Amount FX] "PaymentAmount FX",
	P.PaymentType,
	P.Status PaymentStatus,
	P.AccountId PaymentAccountID,
	OP."Account Code" + '-' + CAST(OP."Organisation ID" AS varchar) AS "Account_UID" ,
	CAST(
		CASE 
   		WHEN OP."Line Amount Types" = 'Inclusive' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL  THEN (OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."Line Amount Types" = 'NoTax' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN (OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."Line Amount Types" = 'Inclusive' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total]*(P.[Amount]/OP.[Total]))
		WHEN OP."Line Amount Types" = 'NoTax' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total]*(P.[Amount]/OP.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Overpayments Calculated Amount" , 
	CAST(
		CASE 
   		WHEN OP."Line Amount Types" = 'Inclusive' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL  THEN (OP.[Total FX]*(P.[Amount FX]/OP.[Total FX]))
		WHEN OP."Line Amount Types" = 'NoTax' AND OP.Type = 'RECEIVE-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN (OP.[Total FX]*(P.[Amount FX]/OP.[Total FX]))
		WHEN OP."Line Amount Types" = 'Inclusive' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total FX]*(P.[Amount FX]/OP.[Total FX]))
		WHEN OP."Line Amount Types" = 'NoTax' AND OP.Type = 'SPEND-OVERPAYMENT' AND OP.[Total] <> 0 AND OP.[Total] IS NOT NULL THEN 0-(OP.[Total FX]*(P.[Amount FX]/OP.[Total FX]))
   		ELSE 0 END AS decimal(15,4)
 	) AS "Overpayments Calculated Amount FX"  
FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD OP
INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD P ON OP.OverPaymentId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('APOVERPAYMENTPAYMENT','AROVERPAYMENTPAYMENT') AND OP.Status IN ('AUTHORISED', 'PAID') AND P.Status IN ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_InvoiceCreditNoteCash_AUD
AS
SELECT c.*,
	P.Date PaymentDate,
	P.Amount PaymentAmount,
	P.[Amount FX] "PaymentAmount FX",
	P.PaymentType,
	P.Status PaymentStatus,
	P.AccountId PaymentAccountID,
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
   		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN 0-(c.[LineItem_LineAmount FX]*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN 0-((c.[LineItem_LineAmount FX]-c.[LineItem_TaxAmount FX])*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN (c.[LineItem_LineAmount FX]*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN ((c.[LineItem_LineAmount FX]-c.[LineItem_TaxAmount FX])*(P.[Amount FX]/c.[Total FX]))
   		ELSE 0 END AS decimal(15,4)
 	) AS "Credit Note Allocation Calculated Amount FX"  ,
	CAST(
		CASE 
   		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN 0-((c.[LineItem_LineAmount]+c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN 0-((c.[LineItem_LineAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN ((c.[LineItem_LineAmount]+c.[LineItem_TaxAmount])*(P.[Amount]/c.[Total]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN ((c.[LineItem_LineAmount])*(P.[Amount]/c.[Total]))
   		ELSE 0 END AS decimal(15,4)
 		) AS "Credit Note Allocation Calculated Amount Inc Tax" ,
	CAST(
		CASE 
   		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN 0-((c.[LineItem_LineAmount FX]+c.[LineItem_TaxAmount FX])*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type = 'ACCRECCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN 0-((c.[LineItem_LineAmount FX])*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Exclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL  THEN ((c.[LineItem_LineAmount FX]+c.[LineItem_TaxAmount FX])*(P.[Amount FX]/c.[Total FX]))
		WHEN c."LineAmountTypes" = 'Inclusive' AND c.Type  = 'ACCPAYCREDIT' AND c.[LineItem_LineAmount] <> 0 AND c.[LineItem_LineAmount] IS NOT NULL THEN ((c.[LineItem_LineAmount FX])*(P.[Amount FX]/c.[Total FX]))
   		ELSE 0 END AS decimal(15,4)
 	) AS "Credit Note Allocation Calculated Amount Inc Tax FX" 
FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD c
INNER JOIN NEW_CLIENT1.XEROBLUETABLES_paymentsOriginal_AUD P ON c.CreditNoteId = P.InvoiceId
WHERE UPPER(p.PaymentType) in ('APCREDITPAYMENT','ARCREDITPAYMENT') AND c.Status in ('AUTHORISED', 'PAID') AND P.Status in ('AUTHORISED')
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations_AUD
AS
SELECT 
	a.*,
	ISNULL("LineItem_AccountCode",'BLANK') + '-' + CAST("OrganisationID" AS varchar) AS "Account UID",
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
	) AS "Credit Note Allocation Calculated Amount Inc Tax",
	CAST(
		CASE 
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount FX]-[LineItem_TaxAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount FX]-[LineItem_TaxAmount FX])*([Amount FX]/[Total FX]))
		ELSE 0 END AS decimal(15,4)
	) AS "Credit Note Allocation Calculated Amount FX",

	CAST(
		CASE 
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount FX]+[LineItem_TaxAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCRECCREDIT' THEN (0-([LineItem_LineAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Exclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount FX]+[LineItem_TaxAmount FX])*([Amount FX]/[Total FX]))
		WHEN LineAmountTypes = 'Inclusive' AND Type = 'ACCPAYCREDIT' THEN (([LineItem_LineAmount FX])*([Amount FX]/[Total FX]))
		ELSE 0 END AS decimal(15,4)
	) AS "Credit Note Allocation Calculated Amount Inc Tax FX" 
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
		Allocation1_AppliedAmount AS Amount,
		[Allocation1_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD 
	WHERE Allocation1_AppliedAmount IS not null
	UNION ALL
	SELECT 
		Id ,
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
		Allocation2_AppliedAmount AS Amount,
		[Allocation2_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD 
	WHERE Allocation2_AppliedAmount IS not null		
	UNION ALL
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
		Allocation3_AppliedAmount AS Amount,
		[Allocation3_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation3_AppliedAmount IS not null
	UNION ALL
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
		Allocation4_AppliedAmount AS Amount,
		[Allocation4_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation4_AppliedAmount IS not null
	UNION ALL
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
		Allocation5_AppliedAmount AS Amount,
		[Allocation5_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION ALL
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
		Allocation6_AppliedAmount AS Amount,
		[Allocation6_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation6_AppliedAmount IS not null
	UNION ALL
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
		Allocation7_AppliedAmount AS Amount,
		[Allocation7_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation7_AppliedAmount IS not null
	UNION ALL
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
		,[Allocation8_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation8_AppliedAmount IS not null
	UNION ALL
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
		,[Allocation9_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation9_AppliedAmount IS not null
	UNION ALL
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
		,[Allocation10_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation10_AppliedAmount IS not NULL
	UNION ALL
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
		,[Allocation11_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation11_AppliedAmount IS not NULL
	UNION ALL
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
		,[Allocation12_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation12_AppliedAmount IS not NULL
	UNION ALL
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
		,[Allocation13_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation13_AppliedAmount IS not NULL
	UNION ALL
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
		,[Allocation14_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation14_AppliedAmount IS not NULL
	UNION ALL
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
		,[Allocation15_AppliedAmount FX] AS [Amount FX],
		[LineItem_TaxAmount FX],
		[LineItem_LineAmount FX],
		[SubTotal FX],
		[TotalTax FX],
		[Total FX],
		[RemainingCredit FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation15_AppliedAmount IS not null
) as a
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation_AUD
as
SELECT 
	a.*
 	,ISNULL("Account Code",'BLANK') + '-' + CAST("Organisation ID" AS varchar) AS "Account UID" 
FROM (
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 1 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 1 Date] AS Dt,
		[Allocation 1 Applied Amount] AS Amount,
		[Allocation 1 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 1 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 2 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 2 Date] AS Dt,
		[Allocation 2 Applied Amount] AS Amount,
		[Allocation 2 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 2 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 3 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 3 Date] AS Dt,
		[Allocation 3 Applied Amount] AS Amount,
		[Allocation 3 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 3 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 4 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 4 Date] AS Dt,
		[Allocation 4 Applied Amount] AS Amount,
		[Allocation 4 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 4 Applied Amount] IS not null
	UNION ALL
		SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 5 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 5 Date] AS Dt,
		[Allocation 5 Applied Amount] AS Amount,
		[Allocation 5 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 5 Applied Amount] IS not null
	UNION ALL
		SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 6 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 6 Date] AS Dt,
		[Allocation 6 Applied Amount] AS Amount,
		[Allocation 6 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 6 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 7 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 7 Date] AS Dt,
		[Allocation 7 Applied Amount] AS Amount,
		[Allocation 7 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 7 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 8 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 8 Date] AS Dt,
		[Allocation 8 Applied Amount] AS Amount,
		[Allocation 8 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 8 Applied Amount] IS not null
	UNION ALL
	SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 9 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 9 Date] AS Dt,
		[Allocation 9 Applied Amount] AS Amount,
		[Allocation 9 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 9 Applied Amount] IS not null
	UNION ALL
		SELECT "PrepaymentId",
		"Date" DATE ,
		"Reference" ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"CurrencyCode" ,
		"CurrencyRate" ,
		"Updated Date UTC" ,
		"HasAttachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 10 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 10 Date] AS Dt,
		[Allocation 10 Applied Amount] AS Amount,
		[Allocation 10 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS [SubTotal FX],
		"TotalTax FX" AS [TotalTax FX],
		"Total FX" AS [Total FX],
		"Tax Amount FX" AS [TaxAmount FX],
		"Line Amount FX" AS [LineAmount FX]
	FROM NEW_CLIENT1.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null
	
) a
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation_AUD
as
SELECT 
	a.*
	,ISNULL("Account Code",'BLANK') + '-' + CAST("Organisation ID" AS varchar) AS "Account UID" 
FROM (
		SELECT "OverpaymentId",
		"Date" DATE ,
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 1 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 1 Date] AS Dt,
		[Allocation 1 Applied Amount] AS Amount,
		[Allocation 1 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 1 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 2 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 2 Date] AS Dt,
		[Allocation 2 Applied Amount] AS Amount,
		[Allocation 2 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 2 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 3 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 3 Date] AS Dt,
		[Allocation 3 Applied Amount] AS Amount,
		[Allocation 3 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 3 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 4 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 4 Date] AS Dt,
		[Allocation 4 Applied Amount] AS Amount,
		[Allocation 4 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 4 Applied Amount] IS not null
	UNION ALL
		SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 5 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 5 Date] AS Dt,
		[Allocation 5 Applied Amount] AS Amount,
		[Allocation 5 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 5 Applied Amount] IS not null
	UNION ALL
		SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 6 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 6 Date] AS Dt,
		[Allocation 6 Applied Amount] AS Amount,
		[Allocation 6 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 6 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 7 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 7 Date] AS Dt,
		[Allocation 7 Applied Amount] AS Amount,
		[Allocation 7 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 7 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 8 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 8 Date] AS Dt,
		[Allocation 8 Applied Amount] AS Amount,
		[Allocation 8 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 8 Applied Amount] IS not null
	UNION ALL
	SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 9 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 9 Date] AS Dt,
		[Allocation 9 Applied Amount] AS Amount,
		[Allocation 9 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 9 Applied Amount] IS not null
	UNION ALL
		SELECT "OverpaymentId",
		"Date" DATE ,
			
		"Type" ,
		"RemainingCredit" ,
		"Contact ID",
		"Contact Name" ,
		"Status" ,
		"SubTotal",
		"TotalTax" ,
		"Total" ,
		"Line Item ID" ,
		"Description" ,
		"Quantity" ,
		"Unit Amount",
		"Item Code" ,
		"Account Code" ,
		"Tax Type" ,
		"Tax Amount",
		"Line Amount",
		"Tracking Category 1 Category ID" ,
		"Tracking Category 1 Category Name",
		"Tracking Category 1 Option ID" ,
		"Tracking Category 1 Option Name",
		"Tracking Category 1 Option Stat",
		"Tracking Category 2 Category ID" ,
		"Tracking Category 2 Category Name",
		"Tracking Category 2 Option ID" ,
		"Tracking Category 2 Option Name",
		"Tracking Category 2 Option Stat",
		"Discount Rate" ,
		"Line Amount Types" ,
		"Currency Code" ,
		"Currency Rate" ,
		"Updated Date UTC" ,
		"Has Attachments",
		"Payments",
		"Client ID" ,
		"Organisation ID",
		[Allocation 10 Invoice ID] AS InvoiceId, 1 Allocation,
		[Allocation 10 Date] AS Dt,
		[Allocation 10 Applied Amount] AS Amount,
		[Allocation 10 Applied Amount] AS [Amount FX],
		"SubTotal FX" AS "SubTotal FX",
		"TotalTax FX" AS "TotalTax FX",
		"Total FX" AS "Total FX",
		"Tax Amount FX" AS "Tax Amount FX",
		"Line Amount FX" AS "Line Amount FX"
	FROM NEW_CLIENT1.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null
) a
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgets_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgets_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgets_AUD
as
SELECT 
	"BudgetID" AS "Budget ID",
	"Status" AS "Status",
	"Type" AS "Type",
	"Description" AS "Description",
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
	"OrganisationID" AS "OrganisationID",
    "BudgetLines.BudgetBalances.Amount_AUD" AS "Budget Lines Budget Balances Amount FX"
FROM dbo.NEW_CLIENT1_XEROBLUE_Budgets
WHERE [BudgetLines.AccountID] IS NOT NULL
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_CashAggregated_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_CashAggregated_AUD
GO
CREATE VIEW [NEW_CLIENT1].[XEROBLUETABLES_CashAggregated_AUD]
AS
SELECT 	
	a.InvoiceId												AS "Cash Source ID"
	,a.Type													AS "Type"
	,a.ContactId											AS "Contact ID"
	,a.[Date]												AS "Date"
	,a.PaymentDate											AS "Payment Date"
	,a.OrganisationID										AS "Organisation ID"
	,a.PaymentAccountID	 									AS "Payment Account ID"
	,a.[Payments Calculated Amount FX]						AS "Payment Calculated Amount FX"
	,a.[Payments Calculated Amount Inc Tax FX]				AS "Payment Calculated Amount Inc Tax FX"
	,'Invoice'												AS "Cash Type"
	,a.Account_UID											AS "Account_UID"
FROM 
	[NEW_CLIENT1].[XEROBLUETABLES_InvoicePaymentCash_AUD] a
UNION ALL
SELECT 
	
	 b.CreditNoteId												AS "Cash Source ID"
	,b.Type														AS "Type"
	,b.[Contact_ContactId]										AS "Contact ID"
	,b.[Date]													AS "Date"
	,b.PaymentDate												AS "Payment Date"
	,b.OrganisationID											AS "Organisation ID"
	,b.PaymentAccountID											AS "Payment Account ID"
	,b.[Credit Note Allocation Calculated Amount FX]			AS "Payment Calculated Amount FX"
	,b.[Credit Note Allocation Calculated Amount Inc Tax FX]	AS "Payment Calculated Amount Inc Tax FX"
	,'Credit Note'												AS "Cash Type"
	,b.[Account UID]											AS "Account_UID"
FROM 
	[NEW_CLIENT1].[XEROBLUETABLES_InvoiceCreditNoteCash_AUD] b
UNION ALL
SELECT 
	
	 b.OverpaymentId											AS "Cash Source ID"
	,b.Type														AS "Type"
	,b.[Contact ID]												AS "Contact ID"
	,b.[Date]													AS "Date"
	,b.PaymentDate												AS "Payment Date"
	,b.[Organisation ID]										AS "Organisation ID"
	,b.PaymentAccountID											AS "Payment Account ID"
	,b.[Overpayments Calculated Amount FX] 						AS "Payment Calculated Amount FX"
	,b.[Overpayments Calculated Amount FX] + b.[TotalTax FX]	AS "Payment Calculated Amount Inc Tax FX"
	,'Overpayment'												AS "Cash Type"
	,b.Account_UID												AS "Account_UID"
FROM 
	[NEW_CLIENT1].[XEROBLUETABLES_InvoiceOverPaymentCash_AUD] b
UNION ALL
SELECT 	
	 b.PrepaymentId												AS "Cash Source ID"
	,b.Type														AS "Type"
	,b.[Contact ID]												AS "Contact ID"
	,b.[Date]													AS "Date"
	,b.PaymentDate												AS "Payment Date"
	,b.[Organisation ID]										AS "Organisation ID"
	,b.PaymentAccountID											AS "Payment Account ID"
	,b.[Prepayments Calculated Amount FX]						AS "Payment Calculated Amount FX"
	,b.[Prepayments Calculated Amount FX] + b.[TotalTax FX]		AS "Payment Calculated Amount Inc Tax FX"
	,'Prepayment'												AS "Cash Type"
	,b.[Account UID]											AS "Account_UID"
FROM 
	[NEW_CLIENT1].[XEROBLUETABLES_InvoicePrePaymentCash_AUD] b
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_AllocationAggregated_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_AllocationAggregated_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_AllocationAggregated_AUD
AS
SELECT 
	
	 b.InvoiceId											 AS "Invoice ID"
	,b.CreditNoteId											 AS "Allocation Source ID"
	,b.Type													 AS "Type"
	,b.Contact_ContactId									 AS "Contact ID"
	,b.ClientID												 AS "Client ID"
	,b.OrganisationID										 AS "Organisation ID"
	,b.Dt													 AS "Allocation Date"
	,b.Date													 AS "Allocation Invoiced Date"
	,b."SubTotal FX"										 AS [SubTotal FX]
	,b."TotalTax FX"										 AS [TotalTax FX]
	,b."Total FX"											 AS [Total FX]
	,b."LineItem_TaxAmount"									 AS [Tax Amount FX]
	,b."LineItem_LineAmount"								 AS [Line Amount FX]
	,b.[Amount FX]											 AS [Amount FX]
	,b.[Credit Note Allocation Calculated Amount FX]		 AS [Allocation Calculated Amount FX]
	,b.[Credit Note Allocation Calculated Amount Inc Tax FX] AS [Allocation Calculated Amount Inc Tax FX]
	,b.[Account UID]					                     AS [Account UID]
	,'Credit Note Allocations'								 AS "SOURCE"
	
FROM NEW_CLIENT1.XEROBLUETABLES_CreditNoteAllocations_AUD b
UNION ALL
SELECT 
	 c.InvoiceId							AS "Invoice ID" 
	,c.PrepaymentId							AS "Allocation Source ID"
	,c.Type									AS "Type"
	,c.[Contact ID]							AS "Contact ID"
	,c.[Client ID]							AS "Client ID"
	,c.[Organisation ID]					AS "Organisation ID"
	,c.Dt									AS "Allocation Date"
	,c.DATE									AS "Allocation Invoiced Date"
	,C."SubTotal FX"						AS [SubTotal FX]
	,C."TotalTax FX"						AS [TotalTax FX]
	,c."Total FX"							AS [Total FX]
	,c.[TaxAmount FX]						AS [Tax Amount FX]
	,c.[LineAmount FX]						AS [Line Amount FX]
	,c.[Amount FX]							AS [Amount FX]
	,c.[LineAmount FX]						AS [Allocation Calculated Amount Inc]
	,c.[LineAmount FX] + c.[TaxAmount FX]	AS [Allocation Calculated Amount Inc Tax FX]
	,c.[Account UID]						AS [Account UID]
	,'PrePayment Allocation'				AS "SOURCE"
FROM NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation_AUD c
UNION ALL
SELECT 
	 c.InvoiceId							AS "Invoice ID"  
	,c.OverpaymentId						AS "Allocation Source ID"
	,c.Type									AS "Type"
	,c.[Contact ID]							AS "Contact ID"
	,c.[Client ID]							AS "Client ID"
	,c.[Organisation ID]					AS "Organisation ID"
	,c.Dt									AS "Allocation Date"
	,c.DATE									AS "Allocation Invoiced Date"
	,C."SubTotal FX"						AS [SubTotal FX]
	,C."TotalTax FX"						AS [TotalTax FX]
	,c."Total FX"							AS [Total FX]
	,c."Tax Amount FX"						AS [Tax Amount FX]
	,c."Line Amount FX"						AS [Line Amount FX]
	,c.[Amount FX]							AS [Amount FX]
	,c.[Line Amount FX]						AS [Allocation Calculated Amount Inc]
	,c.[Line Amount FX] + c.[Tax Amount FX]	AS [Allocation Calculated Amount Inc Tax FX]
	,c.[Account UID]						AS [Account UID]
	,'OverPayment Allocation'				AS "SOURCE"
FROM NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation_AUD c
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_invoicesDraft_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesDraft_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_invoicesDraft_AUD
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
	"LineItem_UnitAmount"   AS "Unit Amount" ,
	"LineItem_ItemCode" AS "Item Code",
	"LineItem_AccountCode" AS "Account Code",
	"LineItem_TaxType" AS "Tax Type" ,
	"LineItem_TaxAmount" AS "Tax Amount" ,
	"LineItem_TaxAmount_AUD" AS "Tax FX Amount" ,
	"LineItem_LineAmount" AS "Line Amount",
	"LineItem_LineAmount_AUD" AS "Line FX Amount",
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
	"LineItem_DiscountAmount_AUD" AS "Discount FX Amount" ,
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
	"SubTotal_AUD" AS "Invoice - FX Sub Total" ,
	"TotalTax" AS "Invoice - Total Tax",
	"TotalTax_AUD" AS "Invoice - FX Total Tax",
	"Total_AUD" AS "Invoice Total" ,
	"TotalDiscount_AUD" AS "Total Discount",
	"HasAttachments" AS "Has Attachments",
	"AmountDue_AUD" AS "Invoice - Amount Due",
	"AmountPaid_AUD" AS "Invoice - Amount Paid",
	"CISDeduction_AUD" AS "CIS Deduction",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"AmountCredited_AUD" AS "Amount Credited" ,
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
	"LineAmountCalculation_AUD" AS "Line Amount FX Calculation", 
 	"LineAmountCalculationIncTax" AS "Line Amount Calculation Inc Tax",    	
	"LineAmountCalculationIncTax_AUD" AS "Line Amount FX Calculation Inc Tax", 
 	"LineAmountTradeCreditorCalculation" AS "Line Amount Trade Creditor Calculation",   
	"LineAmountTradeCreditorCalculation_AUD" AS "Line Amount FX Trade Creditor Calculation",    
 	"LineAmountTradeDebtorCalculation" AS "Line Amount Trade Debtor Calculation",
 	"LineAmountTradeDebtorCalculation_AUD" AS "Line Amount FX Trade Debtor Calculation",   
	"DayDifference" AS "Day Difference"
FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraft
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_transactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_transactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_transactions_AUD
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
	"UnitAmount_AUD" AS "Unit Amount FX",
	"ItemCode" AS "Item Code",
	"AccountCode" AS "Account Code",
	"TaxType" AS "Tax Type",
	"TaxAmount" AS "Tax Amount",
	"TaxAmount_AUD" AS "Tax Amount FX",
	"LineAmount" AS "Line Amount",
	"LineAmount_AUD" AS "Line Amount FX",
	"LineAmountTypes" AS "Line Amount Types",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"SubTotal_AUD" AS "Sub Total FX",
	"TotalTax" AS "Total Tax",
	"TotalTax_AUD" AS "Total Tax FX",
	"Total" AS "Total",
	"Total_AUD" AS "Total FX",
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
	"RemainingCredit_AUD" AS "Remaining Credit FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalswithcontacts_AUD
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
	"JournalLine_NetAmount_AUD" AS "Net Amount FX",
	"JournalLine_GrossAmount_AUD" AS "Gross Amount FX",
	"JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_journalsCashWithContacts_AUD
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
	"JournalLine_NetAmount_AUD" AS "Net Amount FX",
	"JournalLine_GrossAmount_AUD" AS "Gross Amount FX",
	"JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
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


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_manualjournals_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_manualjournals_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_manualjournals_AUD
as
SELECT
	"Id" AS "ID",
	"ManualJournalId" AS "Manual Journal ID" ,
	"Narration" AS "Narration",
	"JournalLine_LineAmount" AS "Line Amount",
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
 	) AS "Manual Journal Cash Calculation",
	"JournalLine_LineAmount_AUD" AS "Line Amount FX",
	"JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
	CAST(
		CASE 
		WHEN ("LineAmountTypes" = 'Inclusive' OR "LineAmountTypes" = 'NoTax') THEN 0-([JournalLine_LineAmount_AUD])
		WHEN "LineAmountTypes" = 'Exclusive' AND ("JournalLine_TaxType" = 'INPUT' OR "JournalLine_TaxType" = 'OUTPUT' OR "JournalLine_TaxType" = 'CAPEXINPUT') THEN 0-([JournalLine_LineAmount_AUD]+([JournalLine_LineAmount_AUD]*0.1))
		WHEN "LineAmountTypes" = 'Exclusive' THEN 0-([JournalLine_LineAmount_AUD])
		ELSE 0 END AS decimal(15,4)
 	) AS "Manual Journal Cash Calculation FX"
FROM (
	SELECT *, 
		Row_number() OVER(PARTITION BY "Id" ORDER BY Id) rn 
	FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournals
	WHERE Status IN ('POSTED')
) t WHERE rn = 1
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_uniquetransactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_uniquetransactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_uniquetransactions_AUD
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
	"UnitAmount_AUD" AS "Unit Amount FX",
	"ItemCode" AS "Item Code",
	"AccountCode" AS "Account Code",
	"TaxType" AS "Tax Type",
	"TaxAmount" AS "Tax Amount",
	"TaxAmount_AUD" AS "Tax Amount FX",
	"LineAmount" AS "Line Amount",
	"LineAmount_AUD" AS "Line Amount FX",
	"LineAmountTypes" AS "Line Amount Types",
	"Status" AS "Status",
	"SubTotal" AS "Sub Total",
	"SubTotal_AUD" AS "Sub Total FX",
	"TotalTax" AS "Total Tax",
	"TotalTax_AUD" AS "Total Tax FX",
	"Total" AS "Total",
	"Total_AUD" AS "Total FX",
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
	"RemainingCredit_AUD" AS "Remaining Credit FX",
	"FullyPaidOnDate" AS "Fully Paid On Date",
	"Reference" AS "Reference",
	"Source" AS "Source",
	"ClientID" AS "Client ID",
	"OrganisationID" AS "Organisation ID"
FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactions
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_transactionsblend_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_transactionsblend_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_transactionsblend_AUD
as
SELECT 
	tb."Id" AS "ID",
	tb."JournalId" AS "Journal ID",
	ROW_NUMBER() OVER (ORDER BY tb."JournalDate" ASC) AS "Index",
	tb."JournalDate" AS "Journal Date",
	tb."JournalNumber" AS "Journal Number",
	tb."CreatedDateUTC" AS "Created Date UTC" ,
	tb."Reference" AS "Reference" ,
	tb."SourceId" AS "Source ID" ,
	ISNULL(tb."SourceType", 'NULL VALUE') AS "Source Type",
	tb."JournalLine_JournalLineId" AS "Journal Line ID" ,
	tb."JournalLine_Description" AS "Description",
	Acc."AccountID" AS "Account ID",
	Acc."Code" AS "Account Code",
	Acc."AccountType" AS "Account Type",
	Acc."Name" AS "Account Name",
	tb."JournalLine_NetAmount" AS "Net Amount",
	tb."JournalLine_GrossAmount" AS "Gross Amount",
	tb."JournalLine_TaxAmount" AS "Tax Amount",
	tb."JournalLine_NetAmount_AUD" AS "Net Amount FX",
	tb."JournalLine_GrossAmount_AUD" AS "Gross Amount FX",
	tb."JournalLine_TaxAmount_AUD" AS "Tax Amount FX",
	tb."JournalLine_TaxType" AS "Tax Type",
	tb."JournalLine_TaxName" AS "Tax Name",
	tb."LineItem_TrackingCategory1_CategoryId" AS "Tracking Category 1 Category ID",
	tb."LineItem_TrackingCategory1_CategoryName" AS "Tracking Category 1 Category Name",
	tb."LineItem_TrackingCategory1_OptionId" AS "Tracking Category 1 Option ID",
	tb."LineItem_TrackingCategory1_OptionName" AS "Tracking Category 1 Option Name",
	tb."LineItem_TrackingCategory1_Option_Stat" AS "Tracking Category 1 Option Stat",
	tb."LineItem_TrackingCategory2_CategoryId" AS "Tracking Category 2 Category ID",
	tb."LineItem_TrackingCategory2_CategoryName" AS "Tracking Category 2 Category Name",
	tb."LineItem_TrackingCategory2_OptionId" AS "Tracking Category 2 Option ID",
	tb."LineItem_TrackingCategory2_OptionName" AS "Tracking Category 2 Option Name",
	tb."LineItem_TrackingCategory2_Option_Stat" AS "Tracking Category 2 Option Stat",
	tb."ClientID" AS "Client ID" ,
	tb."OrganisationID" AS "Organisation ID",
    tb."Split" AS "Split",
    tb."ContactID" AS "Contact ID",
    tb."ContactName" AS "Contact Name",
	tb."ContactSource" AS "ContactSource",
	tb."PaymentSourceID" AS "PaymentSourceID",
	tb."PaymentType" AS "PaymentType",
	tb."Changes" AS "Changes",
	tb."User" AS "User",
	tb."Details" AS "Details",
    tb."ShowOnCashBasisReports" AS "ShowOnCashBasisReports",
    tb."FullyPaidOnDate" AS "FullyPaidOnDate",
    tb."DayDifference" AS "DayDifference",
    tb."SourceNumber" AS "SourceNumber",
    tb."CashOrAccruals" AS "Cash/Accruals",
    CASE 
        WHEN CHARINDEX('ACCREC', tb."SourceType") > 0 THEN 'ACCREC'
        WHEN CHARINDEX('ACCPAY', tb."SourceType") > 0 THEN 'ACCPAY'
        WHEN LEFT(tb."SourceType", 2) = 'AR' THEN 'ACCREC'
        WHEN LEFT(tb."SourceType", 2) = 'AP' THEN 'ACCPAY'
        ELSE 'OTHER UNRELATED TO AR/AP'
    END AS "ACC/ACCPAY",
	Acc."Class" AS "Accounts.Class",
    CASE 
        WHEN Acc."Class" = 'Revenue' THEN 'PnL'
        WHEN Acc."Class" = 'Expense' THEN 'PnL'
		WHEN Acc."Class" = 'Asset' THEN 'BS'
        WHEN Acc."Class" = 'Liability' THEN 'BS'
		WHEN Acc."Class" = 'Equity' THEN 'BS'
        ELSE null
    END AS "PnL-BS",
    CASE
        WHEN tb."SourceType" = 'ACCREC' AND tb."CashOrAccruals" = 'Accruals' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCPAY' AND tb."CashOrAccruals" = 'Accruals' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCREC' AND tb."CashOrAccruals" = 'Cash' THEN 'Cash'
        WHEN tb."SourceType" = 'ACCPAY' AND tb."CashOrAccruals" = 'Cash' THEN 'Cash'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Applied' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Applied' THEN 'Payments'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Approved' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Approved' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Edited' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Edited' THEN 'Accruals'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Credited' THEN 'Payments'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Credited' THEN 'Payments'
        WHEN tb."SourceType" = 'ACCRECPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'Payments'
        WHEN tb."SourceType" = 'ACCPAYPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'Payments'
        WHEN tb."SourceType" = 'ARCREDITPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'Payments'
        WHEN tb."SourceType" = 'APCREDITPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'Payments'
        WHEN tb."SourceType" = 'ARPREPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'CashOPPP'
        WHEN tb."SourceType" = 'APPREPAYMENT' AND tb."CashOrAccruals" = 'Accruals' THEN 'CashOPPP'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Applied' THEN 'Accruals'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Applied' THEN 'Accruals'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Approved' THEN 'Accruals'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Approved' THEN 'Accruals'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Edited' THEN 'Accruals'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Edited' THEN 'Accruals'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Credited' THEN 'CashOPPP'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Credited' THEN 'CashOPPP'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Cash Refunded' THEN 'CashOPPP'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."CashOrAccruals" = 'Accruals' AND tb."Changes" = 'Cash Refunded' THEN 'CashOPPP'
        ELSE NULL
    END AS "Aged Movement",
    CASE
        WHEN Acc."Type" = 'BANK' AND tb."JournalLine_GrossAmount_AUD" >= 0 THEN tb."JournalLine_GrossAmount_AUD"
        ELSE NULL
    END AS "Cash Received",
    CASE
        WHEN Acc."Type" = 'BANK' AND tb."JournalLine_GrossAmount_AUD" < 0 THEN 0-tb."JournalLine_GrossAmount_AUD"
        ELSE NULL
    END AS "Cash Spent",
    CASE
        WHEN tb."JournalLine_GrossAmount" >= 0 THEN tb."JournalLine_GrossAmount"
        ELSE NULL
    END AS "Debit Gross",
    CASE
        WHEN tb."JournalLine_NetAmount" >= 0 THEN tb."JournalLine_NetAmount"
        ELSE NULL
    END AS "Debit Net Amount",
    CASE
        WHEN tb."JournalLine_GrossAmount" < 0 THEN 0-tb."JournalLine_GrossAmount"
        ELSE NULL
    END AS "Credit Gross",
    CASE
        WHEN tb."JournalLine_NetAmount" < 0 THEN 0-tb."JournalLine_NetAmount"
        ELSE NULL
    END AS "Credit Net Amount",
    CASE
        WHEN tb."JournalLine_GrossAmount_AUD" >= 0 THEN tb."JournalLine_GrossAmount_AUD"
        ELSE NULL
    END AS "Debit Gross FX",
    CASE
        WHEN tb."JournalLine_NetAmount_AUD" >= 0 THEN tb."JournalLine_NetAmount_AUD"
        ELSE NULL
    END AS "Debit Net Amount FX",
    CASE
        WHEN tb."JournalLine_GrossAmount_AUD" < 0 THEN 0-tb."JournalLine_GrossAmount_AUD"
        ELSE NULL
    END AS "Credit Gross FX",
    CASE
        WHEN tb."JournalLine_NetAmount_AUD" < 0 THEN 0-tb."JournalLine_NetAmount_AUD"
        ELSE NULL
    END AS "Credit Net Amount FX",
    CASE
        WHEN 
          (CASE 
            WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" < 0 THEN 'GST Collected'
            WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" >= 0 THEN 'GST Paid'
            ELSE tb."JournalLine_AccountName"
          END) = 'GST Collected' THEN 'PLUS GST Movements'
        WHEN 
          (CASE 
            WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" < 0 THEN 'GST Collected'
            WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" >= 0 THEN 'GST Paid'
            ELSE tb."JournalLine_AccountName"
          END) = 'GST Paid' THEN 'PLUS GST Movements'
        WHEN Acc.[Type] = 'BANK' THEN 'Cash Surplus (Deficit)'
        WHEN Acc."Class" = 'Asset' THEN 'Income'
        WHEN Acc."Class" = 'Revenue' THEN 'Income'
        WHEN Acc."Class" = 'Liability' THEN 'Less Expenses'
        WHEN Acc."Class" = 'Expense' THEN 'Less Expenses'
        WHEN Acc."Class" = 'Equity' THEN 'Less Expenses'
        ELSE Acc.[Name]
    END AS "Cash Summary",
    CASE    
        WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" < 0 THEN 'GST Collected'
        WHEN tb."JournalLine_AccountName" = 'GST' AND tb."JournalLine_NetAmount_AUD" >= 0 THEN 'GST Paid'
        ELSE tb."JournalLine_AccountName"
    END AS "Detailed Breakdown Account Names",
    CASE 
        WHEN tb."SourceType" = 'ACCREC' THEN 'Receivable Invoice'
        WHEN tb."SourceType" = 'ACCPAY' THEN 'Payable Invoice'
        WHEN tb."SourceType" = 'ACCRECPAYMENT' THEN 'Receivable Payment'
        WHEN tb."SourceType" = 'ACCPAYPAYMENT' THEN 'Payable Payment'
        WHEN tb."SourceType" = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
        WHEN tb."SourceType" = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."Changes" = 'Approved' THEN 'Receivable Credit Note'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."Changes" = 'Approved' THEN 'Payable Credit Note'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."Changes" = 'Edited' THEN 'Receivable Credit Note'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."Changes" = 'Edited' THEN 'Payable Credit Note'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."Changes" = 'Credited' THEN 'Receivable Credit Note Allocation'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."Changes" = 'Credited' THEN 'Payable Credit Note Allocation'
        WHEN tb."SourceType" = 'ACCRECCREDIT' AND tb."Changes" = 'Applied' THEN 'Receivable Credit Note Allocation'
        WHEN tb."SourceType" = 'ACCPAYCREDIT' AND tb."Changes" = 'Applied' THEN 'Payable Credit Note Allocation'
        WHEN tb."SourceType" = 'ARPREPAYMENT' AND tb."Changes" = 'Approved' THEN 'Receivable Prepayment'
        WHEN tb."SourceType" = 'APPREPAYMENT' AND tb."Changes" = 'Approved' THEN 'Payable Prepayment'
        WHEN tb."SourceType" = 'ARPREPAYMENT' AND tb."Changes" = 'Edited' THEN 'Receivable Prepayment'
        WHEN tb."SourceType" = 'APPREPAYMENT' AND tb."Changes" = 'Edited' THEN 'Payable Prepayment'
        WHEN tb."SourceType" = 'ARPREPAYMENT' AND tb."Changes" = 'Credited' THEN 'Receivable Prepayment Allocation'
        WHEN tb."SourceType" = 'APPREPAYMENT' AND tb."Changes" = 'Credited' THEN 'Payable Prepayment Allocation'
        WHEN tb."SourceType" = 'ARPREPAYMENT' AND tb."Changes" = 'Applied' THEN 'Receivable Prepayment Note Allocation'
        WHEN tb."SourceType" = 'APPREPAYMENT' AND tb."Changes" = 'Applied' THEN 'Payable Prepayment Allocation'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."Changes" = 'Approved' THEN 'Receivable Overpayment'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."Changes" = 'Approved' THEN 'Payable Overpayment'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."Changes" = 'Edited' THEN 'Receivable Overpayment'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."Changes" = 'Edited' THEN 'Payable Overpayment'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."Changes" = 'Credited' THEN 'Receivable Overpayment Allocation'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."Changes" = 'Credited' THEN 'Payable Overpayment Allocation'
        WHEN tb."SourceType" = 'AROVERPAYMENT' AND tb."Changes" = 'Applied' THEN 'Receivable Overpayment Allocation'
        WHEN tb."SourceType" = 'APOVERPAYMENT' AND tb."Changes" = 'Applied' THEN 'Payable Overpayment Allocation'
        ELSE NULL 
    END AS 'Source',
    CASE
        WHEN tb."ContactSource" = 'PAYMENTS' THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."PaymentSourceID"), '  ', ' '))
        WHEN tb."ContactSource" = 'INVOICES' THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."SourceId"), '  ', ' '))
        WHEN tb."ContactSource" = 'CREDITNOTES' AND tb."Changes" = 'Approved' THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."SourceId"), '  ', ' '))
        WHEN tb."ContactSource" = 'CREDITNOTES' AND tb."Changes" = 'Edited' THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."SourceId"), '  ', ' '))
        WHEN tb."ContactSource" = 'CREDITNOTES' AND tb."Changes" IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."PaymentSourceID"), '  ', ' '))
        WHEN tb."ContactSource" = 'OVERPAYMENTS' AND tb."Changes" IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."SourceId"), '  ', ' '))
        WHEN tb."ContactSource" = 'OVERPAYMENTS' AND tb."Changes" IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."PaymentSourceID"), '  ', ' '))
        WHEN tb."ContactSource" = 'PREPAYMENTS' AND tb."Changes" IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."SourceId"), '  ', ' '))
        WHEN tb."ContactSource" = 'PREPAYMENTS' AND tb."Changes" IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb."JournalLine_AccountId", ' | ', tb."PaymentSourceID"), '  ', ' '))
        ELSE NULL
    END AS 'Sync',
    TB."PlannedPaymentDate" AS "Planned Payment Date",
    TB."ItemCode" AS "Item Code",
    TB."Quantity" AS "Quantity",
    TB."DiscountRate" AS "Discount Rate",
    TB."UnitAmount" AS "Unit Amount",
    TB."UnitAmount_AUD" AS "Unit Amount FX",
    TB."AmountDue" AS "Amount Due",
    TB."AmountDue_AUD" AS "Amount Due FX",
    TB."URL" AS "URL",
    TB."DueDate" AS "Due Date",
	Acc."SystemAccount" AS "System Account"
	,I."Invoice Total" AS "Invoice Total"
FROM dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlend Tb
LEFT JOIN dbo.NEW_CLIENT1_XEROBLUE_Accounts Acc on tb."JournalLine_AccountId" = Acc.[AccountId] AND tb.OrganisationID = Acc.[OrganisationID]
LEFT JOIN NEW_CLIENT1.XEROBLUETABLES_uniqueinvoices_AUD I on tb."SourceId" = I.[Invoice ID] AND tb.OrganisationID = I.[Organisation ID]
GO