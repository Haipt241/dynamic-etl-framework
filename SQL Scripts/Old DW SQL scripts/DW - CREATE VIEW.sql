IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_CreditNotes
WHERE Status in ('AUTHORISED', 'PAID')
GO

IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD
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
FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Overpayments a
WHERE Status in ('AUTHORISED', 'PAID')
GO

IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_CreditNoteAllocations_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_CreditNoteAllocations_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_CreditNoteAllocations_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_creditnotesOriginal_AUD
	WHERE Allocation15_AppliedAmount IS not null
) as a
GO

IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_OverPaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_OverPaymentAllocation_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_OverPaymentAllocation_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_overpaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null
) a
GO

IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD
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
FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Prepayments
WHERE Status in ('AUTHORISED', 'PAID')
GO

IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_PrePaymentAllocation_AUD','v') IS NOT NULL
DROP VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_PrePaymentAllocation_AUD
GO
CREATE VIEW BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_PrePaymentAllocation_AUD
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
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
	FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_prepaymentsOriginal_AUD 
	WHERE [Allocation 10 Applied Amount] IS not null	
) a
GO