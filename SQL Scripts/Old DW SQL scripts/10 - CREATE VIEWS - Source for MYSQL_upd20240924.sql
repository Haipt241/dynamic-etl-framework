IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_accrualtransactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_accrualtransactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_accrualtransactions_AUD
as
SELECT
	Date = t.[Journal Date]
	,Reference = t.Reference
	,SourceType = t.[Source Type]
	,Description = t.Description
	,AccountID = t.[Account ID]
	,AccountCode = t.[Account Code]
	,AccountType = t.[Account Type]
	,AccountName = t.[Account Name]
	,Amount = t.[Net Amount]
	,TaxAmount = t.[Tax Amount]
	,TrackingCategoryCategoryName = t.[Tracking Category 1 Category Name]
	,TrackingCategoryOptionName = t.[Tracking Category 1 Option Name]
	,ContactID = t.[Contact ID]
	,ContactName = t.[Contact Name]
	,InvoiceOrBill = t.[Source Type]
	,AccountsClass = a.Class
	,OrganisationID = CAST(t.[Organisation ID] AS NVARCHAR(MAX))
	,ID = t.[ID]
	,JournalID = t.[Journal ID]
	,JournalDate = CAST(t.[Journal Date] AS NVARCHAR(MAX))
	,JournalNumber = CAST(t.[Journal Number] AS NVARCHAR(MAX))
	,CreatedDateUTC = CAST(t.[Created Date UTC] AS NVARCHAR(MAX))
	,SourceID = t.[Source ID]
	,JournalLineID = t.[Journal Line ID]
	,GrossAmountFX = CAST(t.[Gross Amount] AS NVARCHAR(MAX))
	,TaxType = t.[Tax Type]
	,TaxName = t.[Tax Name]
	,TrackingCategoryCategoryID = t.[Tracking Category 1 Category ID]
	,TrackingCategoryOptionID = t.[Tracking Category 1 Option ID]
	,TrackingCategoryOptionStat = t.[Tracking Category 1 Option Stat]
	,TrackingCategory2CategoryID = t.[Tracking Category 2 Category ID]
	,TrackingCategory2CategoryName = t.[Tracking Category 2 Category Name]
	,TrackingCategory2OptionID = t.[Tracking Category 2 Option ID]
	,TrackingCategory2OptionName = t.[Tracking Category 2 Option Name]
	,TrackingCategory2OptionStat = t.[Tracking Category 2 Option Stat]
	,ClientID = t.[Client ID]
	,Split = t.[Split]
	,ContactSource = t.[ContactSource]
	,PaymentSourceID = t.[PaymentSourceID]
	,PaymentType = t.[PaymentType]
	,Changes = t.[Changes]
	,[User] = t.[User]
	,Details = t.[Details]
	,ShowOnCashBasisReports = CAST(t.[ShowOnCashBasisReports] AS NVARCHAR(MAX))
	,FullyPaidOnDate = CAST(t.[FullyPaidOnDate] AS NVARCHAR(MAX))
	,DayDifference = CAST(t.[DayDifference] AS NVARCHAR(MAX))
	,JournalType = 'ACCRUALS'
	,OrganisationName = o.[Name]
	,[Index] = t.[Index]
	,SystemAccount = a.[System Account]
	,SourceNumber = t.[SourceNumber]
	,ACCorACCPAY = t.[ACC/ACCPAY]
	,AgedMovement = t.[Aged Movement]
	,DebitGross = t.[Debit Gross]
	,DebitNetAmount = t.[Debit Net Amount]
	,CreditGross = t.[Credit Gross]
	,CreditNetAmount = t.[Credit Net Amount]
	,CashSummary = t.[Cash Summary]
	,[Source] = t.[Source]
	,Sync = t.[Sync]
	,PlannedPaymentDate = t.[Planned Payment Date]
	,ItemCode = t.[Item Code]
	,[Quantity] = t.[Quantity]
	,DiscountRate = t.[Discount Rate]
	,UnitAmount = t.[Unit Amount]
	,[URL] = t.[URL]
	,DueDate = t.[Due Date]
	,InvoiceTotal = t.[Invoice Total]
FROM NEW_CLIENT1.XEROBLUETABLES_TransactionsBlend_AUD t
JOIN NEW_CLIENT1.XEROBLUETABLES_Accounts a ON t.[Account ID] = a.[Account ID] AND t.[Organisation ID] = a.[Organisation ID]
JOIN NEW_CLIENT1.XEROBLUETABLES_organisations o ON t.[Organisation ID] = o.[Organisation ID]
WHERE [Cash/Accruals] = 'ACCRUALS'
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_cashtransactions_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_cashtransactions_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_cashtransactions_AUD
as
SELECT
	Date = t.[Journal Date]
	,Reference = t.Reference
	,SourceType = t.[Source Type]
	,Description = t.Description
	,AccountID = t.[Account ID]
	,AccountCode = t.[Account Code]
	,AccountType = t.[Account Type]
	,AccountName = t.[Account Name]
	,Amount = t.[Net Amount]
	,TaxAmount = t.[Tax Amount]
	,TrackingCategoryCategoryName = t.[Tracking Category 1 Category Name]
	,TrackingCategoryOptionName = t.[Tracking Category 1 Option Name]
	,ContactID = t.[Contact ID]
	,ContactName = t.[Contact Name]
	,InvoiceOrBill = t.[Source Type]
	,AccountsClass = a.Class
	,OrganisationID = CAST(t.[Organisation ID] AS NVARCHAR(MAX))
	,ID = t.[ID]
	,JournalID = t.[Journal ID]
	,JournalDate = CAST(t.[Journal Date] AS NVARCHAR(MAX))
	,JournalNumber = CAST(t.[Journal Number] AS NVARCHAR(MAX))
	,CreatedDateUTC = CAST(t.[Created Date UTC] AS NVARCHAR(MAX))
	,SourceID = t.[Source ID]
	,JournalLineID = t.[Journal Line ID]
	,GrossAmountFX = CAST(t.[Gross Amount] AS NVARCHAR(MAX))
	,TaxType = t.[Tax Type]
	,TaxName = t.[Tax Name]
	,TrackingCategoryCategoryID = t.[Tracking Category 1 Category ID]
	,TrackingCategoryOptionID = t.[Tracking Category 1 Option ID]
	,TrackingCategoryOptionStat = t.[Tracking Category 1 Option Stat]
	,TrackingCategory2CategoryID = t.[Tracking Category 2 Category ID]
	,TrackingCategory2CategoryName = t.[Tracking Category 2 Category Name]
	,TrackingCategory2OptionID = t.[Tracking Category 2 Option ID]
	,TrackingCategory2OptionName = t.[Tracking Category 2 Option Name]
	,TrackingCategory2OptionStat = t.[Tracking Category 2 Option Stat]
	,ClientID = t.[Client ID]
	,Split = t.[Split]
	,ContactSource = t.[ContactSource]
	,PaymentSourceID = t.[PaymentSourceID]
	,PaymentType = t.[PaymentType]
	,Changes = t.[Changes]
	,[User] = t.[User]
	,Details = t.[Details]
	,ShowOnCashBasisReports = CAST(t.[ShowOnCashBasisReports] AS NVARCHAR(MAX))
	,FullyPaidOnDate = CAST(t.[FullyPaidOnDate] AS NVARCHAR(MAX))
	,DayDifference = CAST(t.[DayDifference] AS NVARCHAR(MAX))
	,JournalType = 'ACCRUALS'
	,OrganisationName = o.[Name]
	,[Index] = t.[Index]
	,SystemAccount = a.[System Account]
	,SourceNumber = t.[SourceNumber]
	,ACCorACCPAY = t.[ACC/ACCPAY]
	,AgedMovement = t.[Aged Movement]
	,DebitGross = t.[Debit Gross]
	,DebitNetAmount = t.[Debit Net Amount]
	,CreditGross = t.[Credit Gross]
	,CreditNetAmount = t.[Credit Net Amount]
	,CashSummary = t.[Cash Summary]
	,[Source] = t.[Source]
	,Sync = t.[Sync]
	,PlannedPaymentDate = t.[Planned Payment Date]
	,ItemCode = t.[Item Code]
	,[Quantity] = t.[Quantity]
	,DiscountRate = t.[Discount Rate]
	,UnitAmount = t.[Unit Amount]
	,[URL] = t.[URL]
	,DueDate = t.[Due Date]
	,InvoiceTotal = t.[Invoice Total]
FROM NEW_CLIENT1.XEROBLUETABLES_TransactionsBlend_AUD t
JOIN NEW_CLIENT1.XEROBLUETABLES_Accounts a ON t.[Account ID] = a.[Account ID] AND t.[Organisation ID] = a.[Organisation ID]
JOIN NEW_CLIENT1.XEROBLUETABLES_organisations o ON t.[Organisation ID] = o.[Organisation ID]
WHERE [Cash/Accruals] = 'CASH'
GO


IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_budgetsMySQL_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsMySQL_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_budgetsMySQL_AUD
as
SELECT
	Status = b.Status
	,Description = b.Description
	,Type = b.Type
	,TrackingName = b.[Tracking 1 Name]
	,TrackingOption = b.[Tracking 1 Option]
	,AccountCode = b.[Budget Lines Account Code]
	,Notes = b.[Budget Lines Budget Balances Notes]
	,Amount = b.[Budget Lines Budget Balances Amount]
	,Date = CAST(CONCAT(b.[Budget Lines Budget Balances Period],'-01') AS DATETIME)
	,AccountName = a.[Name]
	,AccountClass = a.[Class]
	,AccountType = a.[Account Type]
    ,OrganisationID = b.OrganisationID
	,OrganisationName = o.[Name]
FROM NEW_CLIENT1.XEROBLUETABLES_budgets_AUD b
JOIN NEW_CLIENT1.XEROBLUETABLES_Accounts a
ON b.[Budget Lines Account ID] = a.[Account ID]
AND b.OrganisationID = a.[Organisation ID]
JOIN NEW_CLIENT1.XEROBLUETABLES_organisations o
ON b.[OrganisationID] = o.[Organisation ID]
GO




/*
DELETED VIEWS

IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_balancesheetaccruals_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_balancesheetaccruals_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_balancesheetaccruals_AUD
as
SELECT
	Date = t.[Journal Date]
	,Reference = t.Reference
	,SourceType = t.[Source Type]
	,Description = t.Description
	,AccountID = t.[Account ID]
	,AccountCode = t.[Account Code]
	,AccountType = t.[Account Type]
	,AccountName = t.[Account Name]
	,Amount = t.[Net Amount]
	,TaxAmount = t.[Tax Amount]
	,TrackingCategoryCategoryName = t.[Tracking Category 1 Category Name]
	,TrackingCategoryOptionName = t.[Tracking Category 1 Option Name]
	,ContactID = t.[Contact ID]
	,ContactName = t.[Contact Name]
	,InvoiceOrBill = t.[Source Type]
	,AccountsClass = a.Class
	,OrganisationID = CAST(t.[Organisation ID] AS NVARCHAR(MAX))
	,ID = t.[ID]
	,JournalID = t.[Journal ID]
	,JournalDate = CAST(t.[Journal Date] AS NVARCHAR(MAX))
	,JournalNumber = CAST(t.[Journal Number] AS NVARCHAR(MAX))
	,CreatedDateUTC = CAST(t.[Created Date UTC] AS NVARCHAR(MAX))
	,SourceID = t.[Source ID]
	,JournalLineID = t.[Journal Line ID]
	,GrossAmountFX = CAST(t.[Gross Amount] AS NVARCHAR(MAX))
	,TaxType = t.[Tax Type]
	,TaxName = t.[Tax Name]
	,TrackingCategoryCategoryID = t.[Tracking Category 1 Category ID]
	,TrackingCategoryOptionID = t.[Tracking Category 1 Option ID]
	,TrackingCategoryOptionStat = t.[Tracking Category 1 Option Stat]
	,TrackingCategory2CategoryID = t.[Tracking Category 2 Category ID]
	,TrackingCategory2CategoryName = t.[Tracking Category 2 Category Name]
	,TrackingCategory2OptionID = t.[Tracking Category 2 Option ID]
	,TrackingCategory2OptionName = t.[Tracking Category 2 Option Name]
	,TrackingCategory2OptionStat = t.[Tracking Category 2 Option Stat]
	,ClientID = t.[Client ID]
	,Split = t.[Split]
	,ContactSource = t.[ContactSource]
	,PaymentSourceID = t.[PaymentSourceID]
	,PaymentType = t.[PaymentType]
	,Changes = t.[Changes]
	,[User] = t.[User]
	,Details = t.[Details]
	,ShowOnCashBasisReports = CAST(t.[ShowOnCashBasisReports] AS NVARCHAR(MAX))
	,FullyPaidOnDate = CAST(t.[FullyPaidOnDate] AS NVARCHAR(MAX))
	,DayDifference = CAST(t.[DayDifference] AS NVARCHAR(MAX))
	,JournalType = 'ACCRUALS'
	,OrganisationName = o.[Name]
	,[Index] = t.[Index]
	,SystemAccount = a.[System Account]
	,SourceNumber = t.[SourceNumber]
	,ACCorACCPAY = t.[ACC/ACCPAY]
	,AgedMovement = t.[Aged Movement]
	,DebitGross = t.[Debit Gross]
	,DebitNetAmount = t.[Debit Net Amount]
	,CreditGross = t.[Credit Gross]
	,CreditNetAmount = t.[Credit Net Amount]
	,CashSummary = t.[Cash Summary]
	,[Source] = t.[Source]
	,Sync = t.[Sync]
	,PlannedPaymentDate = t.[Planned Payment Date]
	,ItemCode = t.[Item Code]
	,[Quantity] = t.[Quantity]
	,DiscountRate = t.[Discount Rate]
	,UnitAmount = t.[Unit Amount]
	,[URL] = t.[URL]
	,DueDate = t.[Due Date]
	,InvoiceTotal = t.[Invoice Total]
FROM NEW_CLIENT1.XEROBLUETABLES_TransactionsBlend_AUD t
JOIN NEW_CLIENT1.XEROBLUETABLES_Accounts a ON t.[Account ID] = a.[Account ID] AND t.[Organisation ID] = a.[Organisation ID]
JOIN NEW_CLIENT1.XEROBLUETABLES_organisations o ON t.[Organisation ID] = o.[Organisation ID]
WHERE a.Class IN ('Asset', 'Liability') and [Cash/Accruals] = 'ACCRUALS'
GO



IF OBJECT_ID('NEW_CLIENT1.XEROBLUETABLES_profitandlossaccruals_AUD','v') IS NOT NULL
DROP VIEW NEW_CLIENT1.XEROBLUETABLES_profitandlossaccruals_AUD
GO
CREATE VIEW NEW_CLIENT1.XEROBLUETABLES_profitandlossaccruals_AUD
as
SELECT
	Date = t.[Journal Date]
	,Reference = t.Reference
	,SourceType = t.[Source Type]
	,Description = t.Description
	,AccountID = t.[Account ID]
	,AccountCode = t.[Account Code]
	,AccountType = t.[Account Type]
	,AccountName = t.[Account Name]
	,Amount = t.[Net Amount]
	,TaxAmount = t.[Tax Amount]
	,TrackingCategoryCategoryName = t.[Tracking Category 1 Category Name]
	,TrackingCategoryOptionName = t.[Tracking Category 1 Option Name]
	,ContactID = t.[Contact ID]
	,ContactName = t.[Contact Name]
	,InvoiceOrBill = t.[Source Type]
	,AccountsClass = a.Class
	,OrganisationID = CAST(t.[Organisation ID] AS NVARCHAR(MAX))
	,ID = t.[ID]
	,JournalID = t.[Journal ID]
	,JournalDate = CAST(t.[Journal Date] AS NVARCHAR(MAX))
	,JournalNumber = CAST(t.[Journal Number] AS NVARCHAR(MAX))
	,CreatedDateUTC = CAST(t.[Created Date UTC] AS NVARCHAR(MAX))
	,SourceID = t.[Source ID]
	,JournalLineID = t.[Journal Line ID]
	,GrossAmountFX = CAST(t.[Gross Amount] AS NVARCHAR(MAX))
	,TaxType = t.[Tax Type]
	,TaxName = t.[Tax Name]
	,TrackingCategoryCategoryID = t.[Tracking Category 1 Category ID]
	,TrackingCategoryOptionID = t.[Tracking Category 1 Option ID]
	,TrackingCategoryOptionStat = t.[Tracking Category 1 Option Stat]
	,TrackingCategory2CategoryID = t.[Tracking Category 2 Category ID]
	,TrackingCategory2CategoryName = t.[Tracking Category 2 Category Name]
	,TrackingCategory2OptionID = t.[Tracking Category 2 Option ID]
	,TrackingCategory2OptionName = t.[Tracking Category 2 Option Name]
	,TrackingCategory2OptionStat = t.[Tracking Category 2 Option Stat]
	,ClientID = t.[Client ID]
	,Split = t.[Split]
	,ContactSource = t.[ContactSource]
	,PaymentSourceID = t.[PaymentSourceID]
	,PaymentType = t.[PaymentType]
	,Changes = t.[Changes]
	,[User] = t.[User]
	,Details = t.[Details]
	,ShowOnCashBasisReports = CAST(t.[ShowOnCashBasisReports] AS NVARCHAR(MAX))
	,FullyPaidOnDate = CAST(t.[FullyPaidOnDate] AS NVARCHAR(MAX))
	,DayDifference = CAST(t.[DayDifference] AS NVARCHAR(MAX))
	,JournalType = 'ACCRUALS'
	,OrganisationName = o.[Name]
	,[Index] = t.[Index]
	,SystemAccount = a.[System Account]
	,SourceNumber = t.[SourceNumber]
	,ACCorACCPAY = t.[ACC/ACCPAY]
	,AgedMovement = t.[Aged Movement]
	,DebitGross = t.[Debit Gross]
	,DebitNetAmount = t.[Debit Net Amount]
	,CreditGross = t.[Credit Gross]
	,CreditNetAmount = t.[Credit Net Amount]
	,CashSummary = t.[Cash Summary]
	,[Source] = t.[Source]
	,Sync = t.[Sync]
	,PlannedPaymentDate = t.[Planned Payment Date]
	,ItemCode = t.[Item Code]
	,[Quantity] = t.[Quantity]
	,DiscountRate = t.[Discount Rate]
	,UnitAmount = t.[Unit Amount]
	,[URL] = t.[URL]
	,DueDate = t.[Due Date]
	,InvoiceTotal = t.[Invoice Total]
FROM NEW_CLIENT1.XEROBLUETABLES_TransactionsBlend_AUD t
JOIN NEW_CLIENT1.XEROBLUETABLES_Accounts a ON t.[Account ID] = a.[Account ID] AND t.[Organisation ID] = a.[Organisation ID]
JOIN NEW_CLIENT1.XEROBLUETABLES_organisations o ON t.[Organisation ID] = o.[Organisation ID]
WHERE a.Class IN ('Expense', 'Revenue') and [Cash/Accruals] = 'ACCRUALS'
GO
*/