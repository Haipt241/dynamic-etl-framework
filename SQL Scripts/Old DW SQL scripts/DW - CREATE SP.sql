--XEROBLUE_Journals - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Journals_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Journals_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Journals_py
     @OrganisationID AS int 
AS  
	--Update Additional Columns and FX columns
	UPDATE jrnl
	SET  
		 [ContactID] = trns.[ContactID]
        ,[ContactName] = trns.[ContactName]
        ,[ContactSource] = trns.[Source]
        ,[PaymentSourceID] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentSourceID] ELSE NULL END
		,[PaymentType] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentType] ELSE NULL END
		,[ShowOnCashBasisReports] = trns.[ShowOnCashBasisReports]
		,[FullyPaidOnDate] = trns.[FullyPaidOnDate]
		,[DayDifference] = trns.[DayDifference]
		,[InvoiceNumber] = trns.[InvoiceNumber]
		,[CreditNoteNumber] = trns.[CreditNoteNumber]
	FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Journals jrnl
	LEFT JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions trns ON jrnl.SourceId = trns.Id
    WHERE jrnl.OrganisationID = @OrganisationID;

	--Update PaymentSourceID for 'CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS'
	UPDATE jrnl
	SET
		[PaymentSourceID] = CASE 
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN jrnl.SourceId
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN trns.[PaymentSourceID]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN trns.[PaymentSourceID]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN jrnl.SourceId
			END
		,[PaymentType] = CASE 
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN jrnl.ContactSource
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN trns.[PaymentType]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN trns.[PaymentType]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN jrnl.ContactSource
			END
	FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Journals jrnl
	LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Accounts acc
		ON jrnl.OrganisationID = acc.OrganisationID
		and jrnl.JournalLine_AccountCode = acc.Code
	INNER JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions trns 
		ON jrnl.SourceId = trns.Id 
		and jrnl.OrganisationID = trns.OrganisationID
		and jrnl.JournalDate = trns.AllocationDate
		and ABS(jrnl.[JournalLine_NetAmount]) = ABS(trns.AllocationAmount)
	WHERE 
        jrnl.OrganisationID = @OrganisationID
    AND ContactSource NOT IN ('INVOICES','PAYMENTS');

    --Update Additional Columns and FX columns
	UPDATE jrnl
	SET  
		 [ContactID] = trns.[ContactID]
        ,[ContactName] = trns.[ContactName]
        ,[ContactSource] = trns.[Source]
        ,[PaymentSourceID] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentSourceID] ELSE NULL END
		,[PaymentType] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentType] ELSE NULL END
		,[ShowOnCashBasisReports] = trns.[ShowOnCashBasisReports]
		,[FullyPaidOnDate] = trns.[FullyPaidOnDate]
		,[DayDifference] = trns.[DayDifference]
		,[InvoiceNumber] = trns.[InvoiceNumber]
		,[CreditNoteNumber] = trns.[CreditNoteNumber]
	FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_JournalsCash jrnl
	LEFT JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions trns ON jrnl.SourceId = trns.Id
    WHERE jrnl.OrganisationID = @OrganisationID;

	--Update PaymentSourceID for 'CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS'
	UPDATE jrnl
	SET
		[PaymentSourceID] = CASE 
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN jrnl.SourceId
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN trns.[PaymentSourceID]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN trns.[PaymentSourceID]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN jrnl.SourceId
			END
		,[PaymentType] = CASE 
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN jrnl.ContactSource
			WHEN acc.SystemAccount = 'DEBTORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN trns.[PaymentType]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount 
			THEN trns.[PaymentType]
			WHEN acc.SystemAccount = 'CREDITORS' AND jrnl.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS') 
			AND jrnl.[Changes] NOT IN ('Approved', 'Edited') AND jrnl.[JournalLine_NetAmount] = trns.AllocationAmount*-1 
			THEN jrnl.ContactSource
			END
	FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_JournalsCash jrnl
	LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Accounts acc
		ON jrnl.OrganisationID = acc.OrganisationID
		and jrnl.JournalLine_AccountCode = acc.Code
	INNER JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions trns 
		ON jrnl.SourceId = trns.Id 
		and jrnl.OrganisationID = trns.OrganisationID
		and jrnl.JournalDate = trns.AllocationDate
		and ABS(jrnl.[JournalLine_NetAmount]) = ABS(trns.AllocationAmount)
	WHERE 
        jrnl.OrganisationID = @OrganisationID
    AND ContactSource NOT IN ('INVOICES','PAYMENTS');
GO

CREATE PROC usp_CreateDWIndexes
    @clientId nvarchar(100)
 AS
 BEGIN
    DECLARE @sql_text nvarchar(max)

    SET @sql_text = '
        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_CreditNotes'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_CreditNotes'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_CreditNotes 
            ON '+@clientId+'_XEROBLUE_CreditNotes(OrganisationID,CreditNoteID)
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_Invoices'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_Invoices'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_Invoices
            ON '+@clientId+'_XEROBLUE_Invoices(OrganisationID, InvoiceId)
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_Xeroblue_Prepayments'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_Xeroblue_Prepayments'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_Xeroblue_Prepayments
            ON '+@clientId+'_Xeroblue_Prepayments(OrganisationID, PrePaymentId)
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_Xeroblue_Overpayments'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_Xeroblue_Overpayments'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_Xeroblue_Overpayments
            ON '+@clientId+'_Xeroblue_Overpayments(OrganisationID, OverPaymentId)
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_BankTransactions'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_BankTransactions'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_BankTransactions
            ON '+@clientId+'_XEROBLUE_BankTransactions(OrganisationID, BankTransactionId)
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_ManualJournals'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_ManualJournals'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_ManualJournals
            ON '+@clientId+'_XEROBLUE_ManualJournals(OrganisationID, ManualJournalId)
        END;


        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_Payments'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_Payments'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_Payments
            ON '+@clientId+'_XEROBLUE_Payments(OrganisationID, InvoiceId)
        END

        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_TransactionsSTAGE'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_TransactionsSTAGE'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_TransactionsSTAGE
            ON '+@clientId+'_XEROBLUE_TransactionsSTAGE(OrganisationId)
        END;


        IF NOT EXISTS (
            SELECT 1
            FROM sys.indexes
            WHERE name = ''IX_'+@clientId+'_XEROBLUE_Transactions'' AND object_id = OBJECT_ID(''dbo.'+@clientId+'_XEROBLUE_Transactions'')
        )
        BEGIN
            CREATE INDEX IX_'+@clientId+'_XEROBLUE_Transactions
            ON '+@clientId+'_XEROBLUE_Transactions(OrganisationId)
        END;
        '
    EXEC sp_executesql @sql_text

 END
GO
--EXEC usp_CreateDWIndexes 'SWAU_CLIENT1834'



--XEROBLUE_Transactions - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Transactions_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Transactions_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Transactions_py
     @OrganisationID AS int 
AS  
    DELETE FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsSTAGE
    WHERE OrganisationID = @OrganisationID

    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsSTAGE 
    SELECT DISTINCT
        [LineID] = C.[Id],
        [ID] = C.[CreditNoteId],
        [Date] = C.[Date],
        [Type] = C.[Type],
        [ContactID] = C.[Contact_ContactId],
        [ContactName] = C.[Contact_Name],
        [LineItemID] =  NULL,
        [Description] = C.[LineItem_Description],
        [Quantity] = C.[LineItem_Quantity],
        [UnitAmount] = C.[LineItem_UnitAmount],
        [ItemCode] = C.[LineItem_ItemCode],
        [AccountCode] = C.[LineItem_AccountCode],
        [TaxType] = C.[LineItem_TaxType],
        [TaxAmount] = C.[LineItem_TaxAmount],
        [LineAmount] = C.[LineItem_LineAmount],
        [LineAmountTypes] = C.[LineAmountTypes],
        [Status] = C.[Status],
        [SubTotal] = C.[SubTotal],
        [TotalTax] = C.[TotalTax],
        [Total] = C.[Total],
        [TrackingCategory1CategoryID] = C.[LineItem_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName] = C.[LineItem_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID] = C.[LineItem_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName] = C.[LineItem_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat] = C.[LineItem_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID] = C.[LineItem_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName] = C.[LineItem_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID] = C.[LineItem_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName] = C.[LineItem_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat] = C.[LineItem_TrackingCategory2_Option_Stat],
        [DiscountRate] = C.[LineItem_DiscountRate],
        [CurrencyCode] = C.[CurrencyCode],
        [CurrencyRate] = C.[CurrencyRate],
        [UpdatedDateUTC] = C.[UpdatedDateUTC],
        [AccountUID] = ISNULL(C.[LineItem_AccountCode],'BLANK') + '-' + CAST(C.[OrganisationID] AS varchar),
        [HasAttachments] = C.[HasAttachments],
        [CreditNoteNumber] = C.[CreditNoteNumber],
        [RemainingCredit] = C.[RemainingCredit],
        [FullyPaidOnDate] = C.[FullyPaidOnDate],
        [Reference] = C.[Reference],
        [Source] = 'CREDITNOTES',
        [ClientID] = C.[ClientID],
        [OrganisationID] = C.[OrganisationID],
        [UnitAmount_AUD] = C.[LineItem_UnitAmount_AUD],
        [UnitAmount_USD] = C.[LineItem_UnitAmount_USD],
        [UnitAmount_NZD] = C.[LineItem_UnitAmount_NZD],
        [UnitAmount_EUR] = C.[LineItem_UnitAmount_EUR],
        [UnitAmount_GBP] = C.[LineItem_UnitAmount_GBP],
        [TaxAmount_AUD] = C.[LineItem_TaxAmount_AUD],
        [TaxAmount_USD] = C.[LineItem_TaxAmount_USD],
        [TaxAmount_NZD] = C.[LineItem_TaxAmount_NZD],
        [TaxAmount_EUR] = C.[LineItem_TaxAmount_EUR],
        [TaxAmount_GBP] = C.[LineItem_TaxAmount_GBP],
        [LineAmount_AUD] = C.[LineItem_LineAmount_AUD],
        [LineAmount_USD] = C.[LineItem_LineAmount_USD],
        [LineAmount_NZD] = C.[LineItem_LineAmount_NZD],
        [LineAmount_EUR] = C.[LineItem_LineAmount_EUR],
        [LineAmount_GBP] = C.[LineItem_LineAmount_GBP],
        [SubTotal_AUD] = C.[SubTotal_AUD],
        [SubTotal_USD] = C.[SubTotal_USD],
        [SubTotal_NZD] = C.[SubTotal_NZD],
        [SubTotal_EUR] = C.[SubTotal_EUR],
        [SubTotal_GBP] = C.[SubTotal_GBP],
        [TotalTax_AUD] = C.[TotalTax_AUD],
        [TotalTax_USD] = C.[TotalTax_USD],
        [TotalTax_NZD] = C.[TotalTax_NZD],
        [TotalTax_EUR] = C.[TotalTax_EUR],
        [TotalTax_GBP] = C.[TotalTax_GBP],
        [Total_AUD] = C.[Total_AUD],
        [Total_USD] = C.[Total_USD],
        [Total_NZD] = C.[Total_NZD],
        [Total_EUR] = C.[Total_EUR],
        [Total_GBP] = C.[Total_GBP],
        [RemainingCredit_AUD] = C.[RemainingCredit_AUD],
        [RemainingCredit_USD] = C.[RemainingCredit_USD],
        [RemainingCredit_NZD] = C.[RemainingCredit_NZD],
        [RemainingCredit_EUR] = C.[RemainingCredit_EUR],
        [RemainingCredit_GBP] = C.[RemainingCredit_GBP],
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = CA.InvoiceId,
        [PaymentType] = CASE WHEN CA.InvoiceId IS NOT NULL THEN 'INVOICES' ELSE NULL END,
        [AllocationDate] = CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Dt ELSE NULL END,
        [AllocationAmount] = CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Amount ELSE NULL END,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, C.[Date], C.[FullyPaidOnDate]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = C.[RemainingCredit],
        [AmountDue_AUD] = C.[RemainingCredit_AUD],
        [AmountDue_USD] = C.[RemainingCredit_USD],
        [AmountDue_NZD] = C.[RemainingCredit_NZD],
        [AmountDue_EUR] = C.[RemainingCredit_EUR],
        [AmountDue_GBP] = C.[RemainingCredit_GBP],
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_CreditNotes C
    LEFT JOIN (
		SELECT DISTINCT
			CreditNoteId
			,InvoiceId
			,Dt
			,Amount
			,ClientID
			,OrganisationID
		FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_CreditnoteAllocations_AUD
	) CA
        ON C.CreditNoteID = CA.CreditNoteID AND C.OrganisationID = CA.OrganisationID
    WHERE C.OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID] = [Id],
        [ID] = [InvoiceId],
        [Date] = [Date],
        [Type] = [Type],
        [ContactID] = [ContactId],
        [ContactName] = [ContactName],
        [LineItemID] = [LineItem_LineItemId],
        [Description] = [LineItem_Description],
        [Quantity] = [LineItem_Quantity],
        [UnitAmount] = [LineItem_UnitAmount],
        [ItemCode] = [LineItem_ItemCode],
        [AccountCode] = [LineItem_AccountCode],
        [TaxType] = [LineItem_TaxType],
        [TaxAmount] = [LineItem_TaxAmount],
        [LineAmount] = [LineItem_LineAmount],
        [LineAmountTypes] = [LineAmountTypes],
        [Status] = [Status],
        [SubTotal] = [SubTotal],
        [TotalTax] = [TotalTax],
        [Total] = [Total],
        [TrackingCategory1CategoryID] = [LineItem_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName] = [LineItem_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID] = [LineItem_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName] = [LineItem_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat] = [LineItem_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID] = [LineItem_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName] = [LineItem_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID] = [LineItem_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName] = [LineItem_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat] = [LineItem_TrackingCategory2_Option_Stat],
        [DiscountRate] = [LineItem_DiscountRate],
        [CurrencyCode] = [CurrencyCode],
        [CurrencyRate] = [CurrencyRate],
        [UpdatedDateUTC] = [UpdatedDateUTC],
        [AccountUID] = ISNULL([LineItem_AccountCode],'BLANK') + '-' + CAST([OrganisationID] AS varchar),
        [HasAttachments] = [HasAttachments],
        [CreditNoteNumber] = NULL,
        [RemainingCredit] = NULL,
        [FullyPaidOnDate] = [FullyPaidOnDate],
        [Reference] = [Reference],
        [Source] = 'INVOICES',
        [ClientID] = [ClientID],
        [OrganisationID] = [OrganisationID],
        [UnitAmount_AUD] = [LineItem_UnitAmount_AUD],
        [UnitAmount_USD] = [LineItem_UnitAmount_USD],
        [UnitAmount_NZD] = [LineItem_UnitAmount_NZD],
        [UnitAmount_EUR] = [LineItem_UnitAmount_EUR],
        [UnitAmount_GBP] = [LineItem_UnitAmount_GBP],
        [TaxAmount_AUD] = [LineItem_TaxAmount_AUD],
        [TaxAmount_USD] = [LineItem_TaxAmount_USD],
        [TaxAmount_NZD] = [LineItem_TaxAmount_NZD],
        [TaxAmount_EUR] = [LineItem_TaxAmount_EUR],
        [TaxAmount_GBP] = [LineItem_TaxAmount_GBP],
        [LineAmount_AUD] = [LineItem_LineAmount_AUD],
        [LineAmount_USD] = [LineItem_LineAmount_USD],
        [LineAmount_NZD] = [LineItem_LineAmount_NZD],
        [LineAmount_EUR] = [LineItem_LineAmount_EUR],
        [LineAmount_GBP] = [LineItem_LineAmount_GBP],
        [SubTotal_AUD] = [SubTotal_AUD],
        [SubTotal_USD] = [SubTotal_USD],
        [SubTotal_NZD] = [SubTotal_NZD],
        [SubTotal_EUR] = [SubTotal_EUR],
        [SubTotal_GBP] = [SubTotal_GBP],
        [TotalTax_AUD] = [TotalTax_AUD],
        [TotalTax_USD] = [TotalTax_USD],
        [TotalTax_NZD] = [TotalTax_NZD],
        [TotalTax_EUR] = [TotalTax_EUR],
        [TotalTax_GBP] = [TotalTax_GBP],
        [Total_AUD] = [Total_AUD],
        [Total_USD] = [Total_USD],
        [Total_NZD] = [Total_NZD],
        [Total_EUR] = [Total_EUR],
        [Total_GBP] = [Total_GBP],
        [RemainingCredit_AUD] = NULL,
        [RemainingCredit_USD] = NULL,
        [RemainingCredit_NZD] = NULL,
        [RemainingCredit_EUR] = NULL,
        [RemainingCredit_GBP] = NULL,
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = [DueDate],
        [InvoiceNumber] = [InvoiceNumber],
        [PaymentSourceID] = NULL,
        [PaymentType] = NULL,
        [AllocationDate] = NULL,
        [AllocationAmount] = NULL,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, [Date], [FullyPaidOnDate]),
        [PlannedPaymentDate] = [PlannedPaymentDate],
        [AmountDue] = [AmountDue],
        [AmountDue_AUD] = [AmountDue_AUD],
        [AmountDue_USD] = [AmountDue_USD],
        [AmountDue_NZD] = [AmountDue_NZD],
        [AmountDue_EUR] = [AmountDue_EUR],
        [AmountDue_GBP] = [AmountDue_GBP],
        [URL] = [URL]
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Invoices
    WHERE OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID] = OP.[OverpaymentId],
        [ID] = OP.[OverpaymentId],
        [Date] = OP.[Date],
        [Type] = OP.[Type],
        [ContactID] = OP.[Contact_ContactId],
        [ContactName] = OP.[Contact_Name],
        [LineItemID] = OP.[LineItem_LineItemId],
        [Description] = OP.[LineItem_Description],
        [Quantity] = OP.[LineItem_Quantity],
        [UnitAmount] = OP.[LineItem_UnitAmount],
        [ItemCode] = OP.[LineItem_ItemCode],
        [AccountCode] = OP.[LineItem_AccountCode],
        [TaxType] = OP.[LineItem_TaxType],
        [TaxAmount] = OP.[LineItem_TaxAmount],
        [LineAmount] = OP.[LineItem_LineAmount],
        [LineAmountTypes] = OP.[LineAmountTypes],
        [Status] = OP.[Status],
        [SubTotal] = OP.[SubTotal],
        [TotalTax] = OP.[TotalTax],
        [Total] = OP.[Total],
        [TrackingCategory1CategoryID] = OP.[LineItem_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName] = OP.[LineItem_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID] = OP.[LineItem_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName] = OP.[LineItem_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat] = OP.[LineItem_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID] = OP.[LineItem_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName] = OP.[LineItem_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID] = OP.[LineItem_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName] = OP.[LineItem_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat] = OP.[LineItem_TrackingCategory2_Option_Stat],
        [DiscountRate] = OP.[LineItem_DiscountRate],
        [CurrencyCode] = OP.[CurrencyCode],
        [CurrencyRate] = CAST(OP.[CurrencyRate] AS FLOAT),
        [UpdatedDateUTC] = OP.[UpdatedDateUTC],
        [AccountUID] = ISNULL(OP.[LineItem_AccountCode],'BLANK') + '-' + CAST(OP.[OrganisationID] AS varchar),
        [HasAttachments] = OP.[HasAttachments],
        [CreditNoteNumber] = NULL,
        [RemainingCredit] = OP.[RemainingCredit],
        [FullyPaidOnDate] = OP.[Date],
        [Reference] = NULL,
        [Source] = 'OVERPAYMENTS',
        [ClientID] = OP.[ClientID],
        [OrganisationID] = OP.[OrganisationID],
        [UnitAmount_AUD] = OP.[LineItem_UnitAmount_AUD],
        [UnitAmount_USD] = OP.[LineItem_UnitAmount_USD],
        [UnitAmount_NZD] = OP.[LineItem_UnitAmount_NZD],
        [UnitAmount_EUR] = OP.[LineItem_UnitAmount_EUR],
        [UnitAmount_GBP] = OP.[LineItem_UnitAmount_GBP],
        [TaxAmount_AUD] = OP.[LineItem_TaxAmount_AUD],
        [TaxAmount_USD] = OP.[LineItem_TaxAmount_USD],
        [TaxAmount_NZD] = OP.[LineItem_TaxAmount_NZD],
        [TaxAmount_EUR] = OP.[LineItem_TaxAmount_EUR],
        [TaxAmount_GBP] = OP.[LineItem_TaxAmount_GBP],
        [LineAmount_AUD] = OP.[LineItem_LineAmount_AUD],
        [LineAmount_USD] = OP.[LineItem_LineAmount_USD],
        [LineAmount_NZD] = OP.[LineItem_LineAmount_NZD],
        [LineAmount_EUR] = OP.[LineItem_LineAmount_EUR],
        [LineAmount_GBP] = OP.[LineItem_LineAmount_GBP],
        [SubTotal_AUD] = OP.[SubTotal_AUD],
        [SubTotal_USD] = OP.[SubTotal_USD],
        [SubTotal_NZD] = OP.[SubTotal_NZD],
        [SubTotal_EUR] = OP.[SubTotal_EUR],
        [SubTotal_GBP] = OP.[SubTotal_GBP],
        [TotalTax_AUD] = OP.[TotalTax_AUD],
        [TotalTax_USD] = OP.[TotalTax_USD],
        [TotalTax_NZD] = OP.[TotalTax_NZD],
        [TotalTax_EUR] = OP.[TotalTax_EUR],
        [TotalTax_GBP] = OP.[TotalTax_GBP],
        [Total_AUD] = OP.[Total_AUD],
        [Total_USD] = OP.[Total_USD],
        [Total_NZD] = OP.[Total_NZD],
        [Total_EUR] = OP.[Total_EUR],
        [Total_GBP] = OP.[Total_GBP],
        [RemainingCredit_AUD] = OP.[RemainingCredit_AUD],
        [RemainingCredit_USD] = OP.[RemainingCredit_USD],
        [RemainingCredit_NZD] = OP.[RemainingCredit_NZD],
        [RemainingCredit_EUR] = OP.[RemainingCredit_EUR],
        [RemainingCredit_GBP] = OP.[RemainingCredit_GBP],
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = OPA.InvoiceId,
        [PaymentType] = CASE WHEN OPA.InvoiceId IS NOT NULL THEN 'INVOICES' ELSE NULL END,
        [AllocationDate] = CASE WHEN OPA.InvoiceId IS NOT NULL THEN OPA.Dt ELSE NULL END,
        [AllocationAmount] = CASE WHEN OPA.InvoiceId IS NOT NULL THEN OPA.Amount ELSE NULL END,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, OP.[Date], OP.[Date]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = NULL,
        [AmountDue_AUD] = NULL,
        [AmountDue_USD] = NULL,
        [AmountDue_NZD] = NULL,
        [AmountDue_EUR] = NULL,
        [AmountDue_GBP] = NULL,
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Overpayments OP
    LEFT JOIN (
        SELECT DISTINCT
            OverPaymentId
            ,InvoiceId
			,Dt
			,Amount
            ,[Client ID]
            ,[Organisation ID]
        FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_OverPaymentAllocation_AUD
	) OPA
        ON OP.OverPaymentId = OPA.OverPaymentId AND OP.OrganisationID = OPA.[Organisation ID]
    WHERE OP.OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID]  = PP.[PrepaymentId],
        [ID]  = PP.[PrepaymentId],
        [Date]  = PP.[Date],
        [Type]  = PP.[Type],
        [ContactID]  = PP.[Contact_ContactId],
        [ContactName]  = PP.[Contact_Name],
        [LineItemID]  = PP.[LineItem_LineItemId],
        [Description]  = PP.[LineItem_Description],
        [Quantity]  = PP.[LineItem_Quantity],
        [UnitAmount]  = PP.[LineItem_UnitAmount],
        [ItemCode]  = PP.[LineItem_ItemCode],
        [AccountCode]  = PP.[LineItem_AccountCode],
        [TaxType]  = PP.[LineItem_TaxType],
        [TaxAmount]  = PP.[LineItem_TaxAmount],
        [LineAmount]  = PP.[LineItem_LineAmount],
        [LineAmountTypes]  = PP.[LineAmountTypes],
        [Status]  = PP.[Status],
        [SubTotal]  = PP.[SubTotal],
        [TotalTax]  = PP.[TotalTax],
        [Total]  = PP.[Total],
        [TrackingCategory1CategoryID]  = PP.[LineItem_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName]  = PP.[LineItem_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID]  = PP.[LineItem_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName]  = PP.[LineItem_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat]  = PP.[LineItem_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID]  = PP.[LineItem_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName]  = PP.[LineItem_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID]  = PP.[LineItem_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName]  = PP.[LineItem_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat]  = PP.[LineItem_TrackingCategory2_Option_Stat],
        [DiscountRate]  = PP.[LineItem_DiscountRate],
        [CurrencyCode]  = PP.[CurrencyCode],
        [CurrencyRate]  = PP.[CurrencyRate],
        [UpdatedDateUTC]  = PP.[UpdatedDateUTC],
        [AccountUID] = ISNULL(PP.[LineItem_AccountCode],'BLANK') + '-' + CAST(PP.[OrganisationID] AS varchar),
        [HasAttachments]  = PP.[HasAttachments],
        [CreditNoteNumber] = NULL,
        [RemainingCredit]  = PP.[RemainingCredit],
        [FullyPaidOnDate]  = PP.[Date],
        [Reference]  = PP.[Reference],
        [Source] = 'PREPAYMENTS',
        [ClientID]  = PP.[ClientID],
        [OrganisationID]  = PP.[OrganisationID],
        [UnitAmount_AUD]  = PP.[LineItem_UnitAmount_AUD],
        [UnitAmount_USD]  = PP.[LineItem_UnitAmount_USD],
        [UnitAmount_NZD]  = PP.[LineItem_UnitAmount_NZD],
        [UnitAmount_EUR]  = PP.[LineItem_UnitAmount_EUR],
        [UnitAmount_GBP]  = PP.[LineItem_UnitAmount_GBP],
        [TaxAmount_AUD]  = PP.[LineItem_TaxAmount_AUD],
        [TaxAmount_USD]  = PP.[LineItem_TaxAmount_USD],
        [TaxAmount_NZD]  = PP.[LineItem_TaxAmount_NZD],
        [TaxAmount_EUR]  = PP.[LineItem_TaxAmount_EUR],
        [TaxAmount_GBP]  = PP.[LineItem_TaxAmount_GBP],
        [LineAmount_AUD]  = PP.[LineItem_LineAmount_AUD],
        [LineAmount_USD]  = PP.[LineItem_LineAmount_USD],
        [LineAmount_NZD]  = PP.[LineItem_LineAmount_NZD],
        [LineAmount_EUR]  = PP.[LineItem_LineAmount_EUR],
        [LineAmount_GBP]  = PP.[LineItem_LineAmount_GBP],
        [SubTotal_AUD]  = PP.[SubTotal_AUD],
        [SubTotal_USD]  = PP.[SubTotal_USD],
        [SubTotal_NZD]  = PP.[SubTotal_NZD],
        [SubTotal_EUR]  = PP.[SubTotal_EUR],
        [SubTotal_GBP]  = PP.[SubTotal_GBP],
        [TotalTax_AUD]  = PP.[TotalTax_AUD],
        [TotalTax_USD]  = PP.[TotalTax_USD],
        [TotalTax_NZD]  = PP.[TotalTax_NZD],
        [TotalTax_EUR]  = PP.[TotalTax_EUR],
        [TotalTax_GBP]  = PP.[TotalTax_GBP],
        [Total_AUD]  = PP.[Total_AUD],
        [Total_USD]  = PP.[Total_USD],
        [Total_NZD]  = PP.[Total_NZD],
        [Total_EUR]  = PP.[Total_EUR],
        [Total_GBP]  = PP.[Total_GBP],
        [RemainingCredit_AUD]  = PP.[RemainingCredit_AUD],
        [RemainingCredit_USD]  = PP.[RemainingCredit_USD],
        [RemainingCredit_NZD]  = PP.[RemainingCredit_NZD],
        [RemainingCredit_EUR]  = PP.[RemainingCredit_EUR],
        [RemainingCredit_GBP]  = PP.[RemainingCredit_GBP],
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = PPA.InvoiceId,
        [PaymentType] = CASE WHEN PPA.InvoiceId IS NOT NULL THEN 'INVOICES' ELSE NULL END,
        [AllocationDate] = CASE WHEN PPA.InvoiceId IS NOT NULL THEN PPA.Dt ELSE NULL END,
        [AllocationAmount] = CASE WHEN PPA.InvoiceId IS NOT NULL THEN PPA.Amount ELSE NULL END,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, PP.[Date], PP.[Date]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = NULL,
        [AmountDue_AUD] = NULL,
        [AmountDue_USD] = NULL,
        [AmountDue_NZD] = NULL,
        [AmountDue_EUR] = NULL,
        [AmountDue_GBP] = NULL,
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Prepayments PP
	LEFT JOIN (
		SELECT DISTINCT
			PrePaymentId
			,InvoiceId
			,Dt
			,Amount
			,[Client ID]
			,[Organisation ID]
		FROM BIGOLESHOECOMPANY_CLIENT1518.XEROBLUETABLES_PrePaymentAllocation_AUD
	) PPA
        ON PP.PrePaymentId = PPA.PrePaymentId AND PP.OrganisationID = PPA.[Organisation ID]
    WHERE PP.OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID] = [Id],
        [ID] = [ManualJournalId],
        [Date] = [Date],
        [Type] = NULL,
        [ContactID] = NULL,
        [ContactName] = NULL,
        [LineItemID] = NULL,
        [Description] = [JournalLine_Description],
        [Quantity] = NULL,
        [UnitAmount] = NULL,
        [ItemCode] = NULL,
        [AccountCode] = [JournalLine_AccountCode],
        [TaxType] = [JournalLine_TaxType],
        [TaxAmount] = [JournalLine_TaxAmount],
        [LineAmount] = [JournalLine_LineAmount],
        [LineAmountTypes] = [LineAmountTypes],
        [Status] = [Status],
        [SubTotal] = NULL,
        [TotalTax] = NULL,
        [Total] = NULL,
        [TrackingCategory1CategoryID] = [JournalLine_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName] = [JournalLine_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID] = [JournalLine_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName] = [JournalLine_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat] = [JournalLine_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID] = [JournalLine_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName] = [JournalLine_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID] = [JournalLine_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName] = [JournalLine_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat] = [JournalLine_TrackingCategory2_Option_Stat],
        [DiscountRate] = NULL,
        [CurrencyCode] = NULL,
        [CurrencyRate] = NULL,
        [UpdatedDateUTC] = [UpdatedDateUTC],
        [AccountUID] = ISNULL([JournalLine_AccountCode],'BLANK') + '-' + CAST([OrganisationID] AS varchar),
        [HasAttachments] = [HasAttachments],
        [CreditNoteNumber] = NULL,
        [RemainingCredit] = NULL,
        [FullyPaidOnDate] = [Date],
        [Reference] = NULL,
        [Source] = 'MANUALJOURNALS',
        [ClientID] = [ClientID],
        [OrganisationID] = [OrganisationID],
        [UnitAmount_AUD] = NULL,
        [UnitAmount_USD] = NULL,
        [UnitAmount_NZD] = NULL,
        [UnitAmount_EUR] = NULL,
        [UnitAmount_GBP] = NULL,
        [TaxAmount_AUD] = [JournalLine_TaxAmount_AUD],
        [TaxAmount_USD] = [JournalLine_TaxAmount_USD],
        [TaxAmount_NZD] = [JournalLine_TaxAmount_NZD],
        [TaxAmount_EUR] = [JournalLine_TaxAmount_EUR],
        [TaxAmount_GBP] = [JournalLine_TaxAmount_GBP],
        [LineAmount_AUD] = [JournalLine_LineAmount_AUD],
        [LineAmount_USD] = [JournalLine_LineAmount_USD],
        [LineAmount_NZD] = [JournalLine_LineAmount_NZD],
        [LineAmount_EUR] = [JournalLine_LineAmount_EUR],
        [LineAmount_GBP] = [JournalLine_LineAmount_GBP],
        [SubTotal_AUD] = NULL,
        [SubTotal_USD] = NULL,
        [SubTotal_NZD] = NULL,
        [SubTotal_EUR] = NULL,
        [SubTotal_GBP] = NULL,
        [TotalTax_AUD] = NULL,
        [TotalTax_USD] = NULL,
        [TotalTax_NZD] = NULL,
        [TotalTax_EUR] = NULL,
        [TotalTax_GBP] = NULL,
        [Total_AUD] = NULL,
        [Total_USD] = NULL,
        [Total_NZD] = NULL,
        [Total_EUR] = NULL,
        [Total_GBP] = NULL,
        [RemainingCredit_AUD] = NULL,
        [RemainingCredit_USD] = NULL,
        [RemainingCredit_NZD] = NULL,
        [RemainingCredit_EUR] = NULL,
        [RemainingCredit_GBP] = NULL,
        [ShowOnCashBasisReports] = [ShowOnCashBasisReports],
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = NULL,
        [PaymentType] = NULL,
        [AllocationDate] = NULL,
        [AllocationAmount] = NULL,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, [Date], [Date]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = NULL,
        [AmountDue_AUD] = NULL,
        [AmountDue_USD] = NULL,
        [AmountDue_NZD] = NULL,
        [AmountDue_EUR] = NULL,
        [AmountDue_GBP] = NULL,
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_ManualJournals
    WHERE OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID] = [Id],
        [ID] = [BankTransactionId],
        [Date] = [Date],
        [Type] = [Type],
        [ContactID] = [Contact_ContactId],
        [ContactName] = [Contact_ContactName],
        [LineItemID] = [LineItem_LineItemId],
        [Description] = [LineItem_Description],
        [Quantity] = [LineItem_Quantity],
        [UnitAmount] = [LineItem_UnitAmount],
        [ItemCode] = [LineItem_ItemCode],
        [AccountCode] = [LineItem_AccountCode],
        [TaxType] = [LineItem_TaxType],
        [TaxAmount] = [LineItem_TaxAmount],
        [LineAmount] = [LineItem_LineAmount],
        [LineAmountTypes] = [LineAmountTypes],
        [Status] = [Status],
        [SubTotal] = [SubTotal],
        [TotalTax] = [TotalTax],
        [Total] = [Total],
        [TrackingCategory1CategoryID] = [LineItem_TrackingCategory1_CategoryId],
        [TrackingCategory1CategoryName] = [LineItem_TrackingCategory1_CategoryName],
        [TrackingCategory1OptionID] = [LineItem_TrackingCategory1_OptionId],
        [TrackingCategory1OptionName] = [LineItem_TrackingCategory1_OptionName],
        [TrackingCategory1OptionStat] = [LineItem_TrackingCategory1_Option_Stat],
        [TrackingCategory2CategoryID] = [LineItem_TrackingCategory2_CategoryId],
        [TrackingCategory2CategoryName] = [LineItem_TrackingCategory2_CategoryName],
        [TrackingCategory2OptionID] = [LineItem_TrackingCategory2_OptionId],
        [TrackingCategory2OptionName] = [LineItem_TrackingCategory2_OptionName],
        [TrackingCategory2OptionStat] = [LineItem_TrackingCategory2_Option_Stat],
        [DiscountRate] = NULL,
        [CurrencyCode] = [CurrencyCode],
        [CurrencyRate] = [CurrencyRate],
        [UpdatedDateUTC] = [UpdatedDateUTC],
        [AccountUID] = ISNULL([LineItem_AccountCode],'BLANK') + '-' + CAST([OrganisationID] AS varchar),
        [HasAttachments] = [HasAttachments],
        [CreditNoteNumber] = NULL,
        [RemainingCredit] = NULL,
        [FullyPaidOnDate] = [FullyPaidOnDate],
        [Reference] = [Reference],
        [Source] = 'BANKTRANSACTIONS',
        [ClientID] = [ClientID],
        [OrganisationID] = [OrganisationID],
        [UnitAmount_AUD] = [LineItem_UnitAmount_AUD],
        [UnitAmount_USD] = [LineItem_UnitAmount_USD],
        [UnitAmount_NZD] = [LineItem_UnitAmount_NZD],
        [UnitAmount_EUR] = [LineItem_UnitAmount_EUR],
        [UnitAmount_GBP] = [LineItem_UnitAmount_GBP],
        [TaxAmount_AUD] = [LineItem_TaxAmount_AUD],
        [TaxAmount_USD] = [LineItem_TaxAmount_USD],
        [TaxAmount_NZD] = [LineItem_TaxAmount_NZD],
        [TaxAmount_EUR] = [LineItem_TaxAmount_EUR],
        [TaxAmount_GBP] = [LineItem_TaxAmount_GBP],
        [LineAmount_AUD] = [LineItem_LineAmount_AUD],
        [LineAmount_USD] = [LineItem_LineAmount_USD],
        [LineAmount_NZD] = [LineItem_LineAmount_NZD],
        [LineAmount_EUR] = [LineItem_LineAmount_EUR],
        [LineAmount_GBP] = [LineItem_LineAmount_GBP],
        [SubTotal_AUD] = [SubTotal_AUD],
        [SubTotal_USD] = [SubTotal_USD],
        [SubTotal_NZD] = [SubTotal_NZD],
        [SubTotal_EUR] = [SubTotal_EUR],
        [SubTotal_GBP] = [SubTotal_GBP],
        [TotalTax_AUD] = [TotalTax_AUD],
        [TotalTax_USD] = [TotalTax_USD],
        [TotalTax_NZD] = [TotalTax_NZD],
        [TotalTax_EUR] = [TotalTax_EUR],
        [TotalTax_GBP] = [TotalTax_GBP],
        [Total_AUD] = [Total_AUD],
        [Total_USD] = [Total_USD],
        [Total_NZD] = [Total_NZD],
        [Total_EUR] = [Total_EUR],
        [Total_GBP] = [Total_GBP],
        [RemainingCredit_AUD] = NULL,
        [RemainingCredit_USD] = NULL,
        [RemainingCredit_NZD] = NULL,
        [RemainingCredit_EUR] = NULL,
        [RemainingCredit_GBP] = NULL,
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = NULL,
        [PaymentType] = NULL,
        [AllocationDate] = NULL,
        [AllocationAmount] = NULL,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, [Date], [FullyPaidOnDate]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = NULL,
        [AmountDue_AUD] = NULL,
        [AmountDue_USD] = NULL,
        [AmountDue_NZD] = NULL,
        [AmountDue_EUR] = NULL,
        [AmountDue_GBP] = NULL,
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_BankTransactions
    WHERE OrganisationID = @OrganisationID
    UNION ALL
    SELECT DISTINCT
        [LineID] = P.[PaymentId],
        [ID] = P.[PaymentId],
        [Date] = P.[Date],
        [Type] = P.[PaymentType],
        [ContactID] = CASE 
            WHEN P.[PaymentType] IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.[ContactId]
            WHEN P.[PaymentType] IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.[Contact_ContactId]
            WHEN P.[PaymentType] IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.[Contact_ContactId]
            WHEN P.[PaymentType] IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.[Contact_ContactId]
            END,
        [ContactName] = CASE 
            WHEN P.[PaymentType] IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.[ContactName]
            WHEN P.[PaymentType] IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.[Contact_Name]
            WHEN P.[PaymentType] IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.[Contact_Name]
            WHEN P.[PaymentType] IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.[Contact_Name]
            END,
        [LineItemID] = P.[PaymentId],
        [Description] = NULL,
        [Quantity] = NULL,
        [UnitAmount] = NULL,
        [ItemCode] = NULL,
        [AccountCode] = P.[AccountCode],
        [TaxType] = NULL,
        [TaxAmount] = NULL,
        [LineAmount] = P.[Amount],
        [LineAmountTypes] = NULL,
        [Status] = P.[Status],
        [SubTotal] = NULL,
        [TotalTax] = NULL,
        [Total] = NULL,
        [TrackingCategory1CategoryID] = NULL,
        [TrackingCategory1CategoryName] = NULL,
        [TrackingCategory1OptionID] = NULL,
        [TrackingCategory1OptionName] = NULL,
        [TrackingCategory1OptionStat] = NULL,
        [TrackingCategory2CategoryID] = NULL,
        [TrackingCategory2CategoryName] = NULL,
        [TrackingCategory2OptionID] = NULL,
        [TrackingCategory2OptionName] = NULL,
        [TrackingCategory2OptionStat] = NULL,
        [DiscountRate] = NULL,
        [CurrencyCode] = NULL,
        [CurrencyRate] = CASE WHEN P.CurrencyRate LIKE '%E%' THEN LEFT(P.CurrencyRate, LEN(P.CurrencyRate)-CHARINDEX('E',REVERSE(P.CurrencyRate))) ELSE P.CurrencyRate END,
        [UpdatedDateUTC] = P.[UpdatedDateUTC],
        [AccountUID] = ISNULL(P.[AccountCode],'BLANK')+'-'+CAST(P.[OrganisationID] AS NVARCHAR(10)),
        [HasAttachments] = NULL,
        [CreditNoteNumber] = NULL,
        [RemainingCredit] = NULL,
        [FullyPaidOnDate] = P.[Date],
        [Reference] = P.[Reference],
        [Source] = 'PAYMENTS',
        [ClientID] = P.[ClientID],
        [OrganisationID] = P.[OrganisationID],
        [UnitAmount_AUD] = NULL,
        [UnitAmount_USD] = NULL,
        [UnitAmount_NZD] = NULL,
        [UnitAmount_EUR] = NULL,
        [UnitAmount_GBP] = NULL,
        [TaxAmount_AUD] = NULL,
        [TaxAmount_USD] = NULL,
        [TaxAmount_NZD] = NULL,
        [TaxAmount_EUR] = NULL,
        [TaxAmount_GBP] = NULL,
        [LineAmount_AUD] = P.[Amount_AUD],
        [LineAmount_USD] = P.[Amount_USD],
        [LineAmount_NZD] = P.[Amount_NZD],
        [LineAmount_EUR] = P.[Amount_EUR],
        [LineAmount_GBP] = P.[Amount_GBP],
        [SubTotal_AUD] = NULL,
        [SubTotal_USD] = NULL,
        [SubTotal_NZD] = NULL,
        [SubTotal_EUR] = NULL,
        [SubTotal_GBP] = NULL,
        [TotalTax_AUD] = NULL,
        [TotalTax_USD] = NULL,
        [TotalTax_NZD] = NULL,
        [TotalTax_EUR] = NULL,
        [TotalTax_GBP] = NULL,
        [Total_AUD] = NULL,
        [Total_USD] = NULL,
        [Total_NZD] = NULL,
        [Total_EUR] = NULL,
        [Total_GBP] = NULL,
        [RemainingCredit_AUD] = NULL,
        [RemainingCredit_USD] = NULL,
        [RemainingCredit_NZD] = NULL,
        [RemainingCredit_EUR] = NULL,
        [RemainingCredit_GBP] = NULL,
        [ShowOnCashBasisReports] = NULL,
        [DueDate] = NULL,
        [InvoiceNumber] = NULL,
        [PaymentSourceID] = P.[InvoiceId],
        [PaymentSourceType] = CASE 
            WHEN [PaymentType] IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN 'INVOICES'
            WHEN [PaymentType] IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN 'CREDITNOTES'
            WHEN [PaymentType] IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN 'PREPAYMENTS'
            WHEN [PaymentType] IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN 'OVERPAYMENTS'
            END,
        [AllocationDate] = NULL,
        [AllocationAmount] = NULL,
		[Changes] = NULL,
		[User] = NULL,
		[Details] = NULL,
        [DayDifference] = DATEDIFF(DD, P.[Date], P.[Date]),
        [PlannedPaymentDate] = NULL,
        [AmountDue] = NULL,
        [AmountDue_AUD] = NULL,
        [AmountDue_USD] = NULL,
        [AmountDue_NZD] = NULL,
        [AmountDue_EUR] = NULL,
        [AmountDue_GBP] = NULL,
        [URL] = NULL
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Payments P
    LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Invoices I 
        ON P.[InvoiceId] = I.[InvoiceId] AND P.[OrganisationID] = I.[OrganisationID]
    LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_Xeroblue_Creditnotes C
        ON P.[InvoiceId] = C.[CreditNoteID] AND P.[OrganisationID] = C.[OrganisationID]
    LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_Xeroblue_Prepayments PP
        ON P.[InvoiceId] = PP.[PrepaymentId] AND P.[OrganisationID] = PP.[OrganisationID]
    LEFT JOIN BIGOLESHOECOMPANY_CLIENT1518_Xeroblue_Overpayments OP
        ON P.[InvoiceId] = OP.[OverpaymentId] AND P.[OrganisationID] = OP.[OrganisationID]
    WHERE P.OrganisationID = @OrganisationID

    UPDATE trns
    SET
        trns.[Changes] = hist.[Changes],
        trns.Details = hist.Details,
        trns.[User] = hist.[User]
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsSTAGE trns
    LEFT JOIN (
        SELECT
            CreditNoteId Id,
            [Changes],
            Details,
            [User],
            DateUTC,
            ClientID,
            OrganisationID,
            ROW_NUMBER() OVER(PARTITION BY CreditNoteId ORDER BY DateUTC DESC) RN,
            'CREDITNOTES' Source
        FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUEHN_Creditnotes
        WHERE OrganisationId = @OrganisationID AND [Changes] NOT IN ('Created')
        UNION ALL
        SELECT 
            PrepaymentId Id,
            [Changes],
            Details,
            [User],
            DateUTC,
            ClientID,
            OrganisationID,
            ROW_NUMBER() OVER(PARTITION BY PrepaymentId ORDER BY DateUTC DESC) RN,
            'PREPAYMENTS'
        FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUEHN_Prepayments
        WHERE OrganisationId = @OrganisationID AND [Changes] NOT IN ('Created')
        UNION ALL
        SELECT 
            OverpaymentId Id,
            [Changes],
            Details,
            [User],
            DateUTC,
            ClientID,
            OrganisationID,
            ROW_NUMBER() OVER(PARTITION BY OverpaymentId ORDER BY DateUTC DESC) RN,
            'OVERPAYMENTS'
        FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUEHN_Overpayments
        WHERE OrganisationId = @OrganisationID AND [Changes] NOT IN ('Created')
    ) hist
    ON trns.Id = hist.Id and hist.RN = 1
    WHERE hist.Id is not null
    AND trns.OrganisationId = @OrganisationID

	BEGIN TRANSACTION;  
        DELETE dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  

    EXEC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_Journals_py @OrganisationID;
GO

--XEROBLUE_TransactionsBlend - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TransactionsBlend_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TransactionsBlend_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TransactionsBlend_py
     @OrganisationID AS int 
AS  
    DECLARE @MaxDate NVARCHAR(100)

    SELECT
        @MaxDate = CASE 
            WHEN ISNULL(MAX(CreatedDateUTC)-1, '1/1/2000') > GETDATE()-1 THEN GETDATE()-1 
            ELSE ISNULL(MAX(CreatedDateUTC)-1, '1/1/2000') 
        END
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlend WHERE OrganisationID = @OrganisationID

    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlendSTAGE
    (
         [Id]
		,[JournalId]
		,[JournalDate]
		,[JournalNumber]
		,[CreatedDateUTC]
		,[Reference]
		,[SourceId]
		,[SourceType]
		,[JournalLine_JournalLineId]
		,[JournalLine_Description]
		,[JournalLine_AccountId]
		,[JournalLine_AccountCode]
		,[JournalLine_AccountType]
		,[JournalLine_AccountName]
		,[JournalLine_NetAmount]
		,[JournalLine_GrossAmount]
		,[JournalLine_TaxAmount]
		,[JournalLine_TaxType]
		,[JournalLine_TaxName]
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
		,[ClientID]
		,[OrganisationID]
		,[EtaniModifiedAfter]
		,[JournalLine_NetAmount_AUD]
		,[JournalLine_NetAmount_USD]
		,[JournalLine_NetAmount_NZD]
		,[JournalLine_NetAmount_EUR]
		,[JournalLine_NetAmount_GBP]
		,[JournalLine_GrossAmount_AUD]
		,[JournalLine_GrossAmount_USD]
		,[JournalLine_GrossAmount_NZD]
		,[JournalLine_GrossAmount_EUR]
		,[JournalLine_GrossAmount_GBP]
		,[JournalLine_TaxAmount_AUD]
		,[JournalLine_TaxAmount_USD]
		,[JournalLine_TaxAmount_NZD]
		,[JournalLine_TaxAmount_EUR]
		,[JournalLine_TaxAmount_GBP]
		,[Split]
		,[ContactID]
		,[ContactName]
		,[ContactSource]
		,[PaymentSourceID]
		,[PaymentType]
		,[Changes]
		,[User]
		,[Details]
		,[ShowOnCashBasisReports]
		,[FullyPaidOnDate]
		,[DayDifference]
		,[SourceNumber]
        ,[CashOrAccruals]
    )
    SELECT
        [Id]
		,[JournalId]
		,[JournalDate]
		,[JournalNumber]
		,[CreatedDateUTC]
		,[Reference]
		,[SourceId]
		,[SourceType]
		,[JournalLine_JournalLineId]
		,[JournalLine_Description]
		,[JournalLine_AccountId]
		,[JournalLine_AccountCode]
		,[JournalLine_AccountType]
		,[JournalLine_AccountName]
		,[JournalLine_NetAmount]
		,[JournalLine_GrossAmount]
		,[JournalLine_TaxAmount]
		,[JournalLine_TaxType]
		,[JournalLine_TaxName]
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
		,[ClientID]
		,[OrganisationID]
		,[EtaniModifiedAfter]
		,[JournalLine_NetAmount_AUD]
		,[JournalLine_NetAmount_USD]
		,[JournalLine_NetAmount_NZD]
		,[JournalLine_NetAmount_EUR]
		,[JournalLine_NetAmount_GBP]
		,[JournalLine_GrossAmount_AUD]
		,[JournalLine_GrossAmount_USD]
		,[JournalLine_GrossAmount_NZD]
		,[JournalLine_GrossAmount_EUR]
		,[JournalLine_GrossAmount_GBP]
		,[JournalLine_TaxAmount_AUD]
		,[JournalLine_TaxAmount_USD]
		,[JournalLine_TaxAmount_NZD]
		,[JournalLine_TaxAmount_EUR]
		,[JournalLine_TaxAmount_GBP]
		,[Split]
		,[ContactID]
		,[ContactName]
		,[ContactSource]
		,[PaymentSourceID]
		,[PaymentType]
		,[Changes]
		,[User]
		,[Details]
		,[ShowOnCashBasisReports]
		,[FullyPaidOnDate]
		,[DayDifference]
		,[SourceNumber] = COALESCE([InvoiceNumber],[CreditNoteNumber])
        ,[CashOrAccruals] = 'Accruals'
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Journals C
    WHERE C.OrganisationID = @OrganisationID AND CreatedDateUTC >= @MaxDate
    UNION ALL
    SELECT
        [Id]
		,[JournalId]
		,[JournalDate]
		,[JournalNumber]
		,[CreatedDateUTC]
		,[Reference]
		,[SourceId]
		,[SourceType]
		,[JournalLine_JournalLineId]
		,[JournalLine_Description]
		,[JournalLine_AccountId]
		,[JournalLine_AccountCode]
		,[JournalLine_AccountType]
		,[JournalLine_AccountName]
		,[JournalLine_NetAmount]
		,[JournalLine_GrossAmount]
		,[JournalLine_TaxAmount]
		,[JournalLine_TaxType]
		,[JournalLine_TaxName]
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
		,[ClientID]
		,[OrganisationID]
		,[EtaniModifiedAfter]
		,[JournalLine_NetAmount_AUD]
		,[JournalLine_NetAmount_USD]
		,[JournalLine_NetAmount_NZD]
		,[JournalLine_NetAmount_EUR]
		,[JournalLine_NetAmount_GBP]
		,[JournalLine_GrossAmount_AUD]
		,[JournalLine_GrossAmount_USD]
		,[JournalLine_GrossAmount_NZD]
		,[JournalLine_GrossAmount_EUR]
		,[JournalLine_GrossAmount_GBP]
		,[JournalLine_TaxAmount_AUD]
		,[JournalLine_TaxAmount_USD]
		,[JournalLine_TaxAmount_NZD]
		,[JournalLine_TaxAmount_EUR]
		,[JournalLine_TaxAmount_GBP]
		,[Split]
		,[ContactID]
		,[ContactName]
		,[ContactSource]
		,[PaymentSourceID]
		,[PaymentType]
		,[Changes]
		,[User]
		,[Details]
		,[ShowOnCashBasisReports]
		,[FullyPaidOnDate]
		,[DayDifference]
		,[SourceNumber] = COALESCE([InvoiceNumber],[CreditNoteNumber])
        ,[CashOrAccruals] = 'Cash'
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_JournalsCash C
    WHERE C.OrganisationID = @OrganisationID AND CreatedDateUTC >= @MaxDate
    
    UPDATE tb
    SET
        [PlannedPaymentDate] = t.[PlannedPaymentDate],
        [ItemCode] = t.[ItemCode],
        [Quantity] = t.[Quantity],
        [DiscountRate] = t.[DiscountRate],
        [UnitAmount] = t.[UnitAmount],
        [UnitAmount_AUD] = t.[UnitAmount_AUD],
        [UnitAmount_USD] = t.[UnitAmount_USD],
        [UnitAmount_NZD] = t.[UnitAmount_NZD],
        [UnitAmount_EUR] = t.[UnitAmount_EUR],
        [UnitAmount_GBP] = t.[UnitAmount_GBP],
        [AmountDue] = t.[AmountDue],
        [AmountDue_AUD] = t.[AmountDue_AUD],
        [AmountDue_USD] = t.[AmountDue_USD],
        [AmountDue_NZD] = t.[AmountDue_NZD],
        [AmountDue_EUR] = t.[AmountDue_EUR],
        [AmountDue_GBP] = t.[AmountDue_GBP],
        [URL] = t.[URL],
        [DueDate] = t.[DueDate],
        [Reference] = CASE WHEN tb.[Reference] IS NULL THEN t.[Reference] ELSE tb.[Reference] END
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlendSTAGE tb
    JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions t ON tb.SourceId = t.Id AND tb.OrganisationID = t.OrganisationID
    WHERE tb.OrganisationID = @OrganisationID

	BEGIN TRANSACTION;  
        DELETE trg
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlend trg
        JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlendSTAGE stg
            ON trg.JournalID = stg.JournalID
            AND trg.CashOrAccruals = stg.CashOrAccruals
            AND trg.OrganisationID = stg.OrganisationID            
        WHERE trg.[OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlend   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlendSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  

    UPDATE trns
    SET
        trns.[Changes] = jrnl.[Changes],
        trns.[User] = jrnl.[User],
        trns.[Details] = jrnl.[Details],
        trns.PaymentSourceID = jrnl.PaymentSourceID,
        trns.PaymentType = jrnl.PaymentType
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlend trns
    INNER JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Journals jrnl
    ON trns.JournalID = jrnl.JournalID
    AND trns.OrganisationID = jrnl.OrganisationID
    WHERE CashOrAccruals = 'Accruals'
    AND trns.OrganisationID = @OrganisationID;

    UPDATE trns
    SET
        trns.[Changes] = jrnl.[Changes],
        trns.[User] = jrnl.[User],
        trns.[Details] = jrnl.[Details],
        trns.PaymentSourceID = jrnl.PaymentSourceID,
        trns.PaymentType = jrnl.PaymentType
    FROM BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TransactionsBlend trns
    INNER JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_JournalsCash jrnl
    ON trns.JournalID = jrnl.JournalID
    AND trns.OrganisationID = jrnl.OrganisationID
    WHERE CashOrAccruals = 'Cash'
    AND trns.OrganisationID = @OrganisationID;
GO

--XEROBLUE_TrackingCategoryConnections - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TrackingCategoryConnections_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TrackingCategoryConnections_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_TrackingCategoryConnections_py
     @OrganisationID AS int 
AS  

    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TrackingCategoryConnectionsSTAGE 
    --Invoices
    SELECT ID, CategoryNumber, [CategoryID+Option], ClientID, OrganisationID
    FROM
        (SELECT
            ID
            ,[Category 1] = CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName)
            ,[Category 2] = CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName)
            ,ClientID
            ,OrganisationID
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Invoices
        WHERE Status in ('AUTHORISED', 'PAID') AND OrganisationID = @OrganisationID) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> ''
    UNION ALL

    --Journals
    SELECT ID, CategoryNumber, [CategoryID+Option], ClientID, OrganisationID
    FROM
        (SELECT
            ID
            ,[Category 1] = CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName)
            ,[Category 2] = CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName)
            ,ClientID
            ,OrganisationID
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Journals
        WHERE OrganisationID = @OrganisationID) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> ''
    UNION ALL

    --CreditNotes
    SELECT ID, CategoryNumber, [CategoryID+Option], ClientID, OrganisationID
    FROM
        (SELECT
            ID
            ,[Category 1] = CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName)
            ,[Category 2] = CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName)
            ,ClientID
            ,OrganisationID
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_CreditNotes
        WHERE Status in ('AUTHORISED', 'PAID') AND OrganisationID = @OrganisationID) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> ''
    UNION ALL

    --Budgets
    SELECT ID, CategoryNumber, [CategoryID+Option], ClientID, OrganisationID
    FROM
        (SELECT 
            ID = CONCAT(BudgetID, [BudgetLines.AccountID], FORMAT(CONVERT(DATE,[BudgetLines.BudgetBalances.Period]+'-01'), N'MMM yyyy', 'en-US'))
            ,[Category 1] = CONCAT([Tracking.1.TrackingCategoryID],[Tracking.1.Option])
            ,[Category 2] = CONCAT([Tracking.2.TrackingCategoryID],[Tracking.2.Option])
            ,a.ClientID
            ,a.OrganisationID
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Budgets a 
        INNER JOIN BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Accounts b 
        ON a.[BudgetLines.AccountID] = b.[AccountID] 
        AND a.[BudgetLines.AccountCode] = b.Code
        AND a.OrganisationID = b.OrganisationID
        WHERE a.OrganisationID = @OrganisationID) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> ''

	BEGIN TRANSACTION;  
        DELETE TRG  
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TrackingCategoryConnections TRG  
        INNER JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TrackingCategoryConnectionsSTAGE STG ON TRG.ID = STG.ID  
        WHERE TRG.OrganisationId = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TrackingCategoryConnections   
        SELECT DISTINCT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_TrackingCategoryConnectionsSTAGE  
        WHERE OrganisationId = @OrganisationID;  
    COMMIT;  
GO

--XEROBLUE_Transactions - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueTransactions_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueTransactions_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueTransactions_py
     @OrganisationID AS int 
AS  
    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueTransactionsSTAGE
    SELECT
        [LineID],
        [ID],
        [Date],
        [Type],
        [ContactID],
        [ContactName],
        [LineItemID],
        [Description],
        [Quantity],
        [UnitAmount],
        [ItemCode],
        [AccountCode],
        [TaxType],
        [TaxAmount],
        [LineAmount],
        [LineAmountTypes],
        [Status],
        [SubTotal],
        [TotalTax],
        [Total],
        [TrackingCategory1CategoryID],
        [TrackingCategory1CategoryName],
        [TrackingCategory1OptionID],
        [TrackingCategory1OptionName],
        [TrackingCategory1OptionStat],
        [TrackingCategory2CategoryID],
        [TrackingCategory2CategoryName],
        [TrackingCategory2OptionID],
        [TrackingCategory2OptionName],
        [TrackingCategory2OptionStat],
        [DiscountRate],
        [CurrencyCode],
        [CurrencyRate],
        [UpdatedDateUTC],
        [AccountUID],
        [HasAttachments],
        [CreditNoteNumber],
        [RemainingCredit],
        [FullyPaidOnDate],
        [Reference],
        [Source],
        [ClientID],
        [OrganisationID],
        [UnitAmount_AUD],
        [UnitAmount_USD],
        [UnitAmount_NZD],
        [UnitAmount_EUR],
        [UnitAmount_GBP],
        [TaxAmount_AUD],
        [TaxAmount_USD],
        [TaxAmount_NZD],
        [TaxAmount_EUR],
        [TaxAmount_GBP],
        [LineAmount_AUD],
        [LineAmount_USD],
        [LineAmount_NZD],
        [LineAmount_EUR],
        [LineAmount_GBP],
        [SubTotal_AUD],
        [SubTotal_USD],
        [SubTotal_NZD],
        [SubTotal_EUR],
        [SubTotal_GBP],
        [TotalTax_AUD],
        [TotalTax_USD],
        [TotalTax_NZD],
        [TotalTax_EUR],
        [TotalTax_GBP],
        [Total_AUD],
        [Total_USD],
        [Total_NZD],
        [Total_EUR],
        [Total_GBP],
        [RemainingCredit_AUD],
        [RemainingCredit_USD],
        [RemainingCredit_NZD],
        [RemainingCredit_EUR],
        [RemainingCredit_GBP]
    FROM (
        SELECT *, RN = row_number() over(partition by ID order by LineID)
        FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Transactions
        WHERE ((Source = 'MANUALJOURNALS' AND Status = 'POSTED') OR Status IN ('AUTHORISED', 'PAID'))
        AND OrganisationID = @OrganisationID
    )A WHERE RN = 1

	BEGIN TRANSACTION;  
        DELETE dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueTransactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueTransactions   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueTransactionsSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  
GO

--XEROBLUE_UniqueBankTransactions - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueBankTransactions_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueBankTransactions_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueBankTransactions_py
     @OrganisationID AS int 
AS  
    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueBankTransactionsSTAGE
    SELECT
        b.[Id],
        b.[BankTransactionId],
        b.[Type],
        b.[Contact_ContactName],
        b.[Contact_ContactId],
        b.[BankAccount_AccountId],
        b.[BankAccount_AccountName],
        b.[BankAccount_Code],
        b.[LineItem_LineItemId],
        b.[LineItem_Description],
        b.[LineItem_Quantity],
        b.[LineItem_UnitAmount],
        b.[LineItem_AccountCode],
        [LineItem_TaxType] = ISNULL(b.[LineItem_TaxType], 'BLANK'),
        b.[LineItem_TaxAmount],
        b.[LineItem_LineAmount],
        b.[LineItem_ItemCode],
        b.[LineItem_TrackingCategory1_CategoryId],
        b.[LineItem_TrackingCategory1_CategoryName],
        b.[LineItem_TrackingCategory1_OptionId],
        b.[LineItem_TrackingCategory1_OptionName],
        b.[LineItem_TrackingCategory1_Option_Stat],
        b.[LineItem_TrackingCategory2_CategoryId],
        b.[LineItem_TrackingCategory2_CategoryName],
        b.[LineItem_TrackingCategory2_OptionId],
        b.[LineItem_TrackingCategory2_OptionName],
        b.[LineItem_TrackingCategory2_Option_Stat],
        b.[LineItemAggregate],
        b.[IsReconciled],
        b.[Date],
        b.[Reference],
        b.[CurrencyRate],
        b.[URL],
        b.[Status],
        b.[LineAmountTypes],
        b.[SubTotal],
        b.[TotalTax],
        b.[Total],
        b.[PrepaymentId],
        b.[OverpaymentId],
        b.[UpdatedDateUTC],
        b.[FullyPaidOnDate],
        b.[CurrencyCode],
        b.[HasAttachments],
        b.[ClientID],
        b.[OrganisationID],
        b.[LineItem_UnitAmount_AUD],
        b.[LineItem_UnitAmount_USD],
        b.[LineItem_UnitAmount_NZD],
        b.[LineItem_UnitAmount_EUR],
        b.[LineItem_UnitAmount_GBP],
        b.[LineItem_TaxAmount_AUD],
        b.[LineItem_TaxAmount_USD],
        b.[LineItem_TaxAmount_NZD],
        b.[LineItem_TaxAmount_EUR],
        b.[LineItem_TaxAmount_GBP],
        b.[LineItem_LineAmount_AUD],
        b.[LineItem_LineAmount_USD],
        b.[LineItem_LineAmount_NZD],
        b.[LineItem_LineAmount_EUR],
        b.[LineItem_LineAmount_GBP],
        b.[SubTotal_AUD],
        b.[SubTotal_USD],
        b.[SubTotal_NZD],
        b.[SubTotal_EUR],
        b.[SubTotal_GBP],
        b.[TotalTax_AUD],
        b.[TotalTax_USD],
        b.[TotalTax_NZD],
        b.[TotalTax_EUR],
        b.[TotalTax_GBP],
        b.[Total_AUD],
        b.[Total_USD],
        b.[Total_NZD],
        b.[Total_EUR],
        b.[Total_GBP],
        b.[ConditionalType],
        b.[Account_UID],
        b.[BankTansactionCashflowCalculation],
        b.[BankTansactionCashflowCalculation_AUD],
        b.[BankTansactionCashflowCalculation_USD],
        b.[BankTansactionCashflowCalculation_NZD],
        b.[BankTansactionCashflowCalculation_EUR],
        b.[BankTansactionCashflowCalculation_GBP],
        b.[LineAmountCalculatedIncTax],
        b.[LineAmountCalculatedIncTax_AUD],
        b.[LineAmountCalculatedIncTax_USD],
        b.[LineAmountCalculatedIncTax_NZD],
        b.[LineAmountCalculatedIncTax_EUR],
        b.[LineAmountCalculatedIncTax_GBP],
        b.[PaymentAmount],
        b.[PaymentAmount_AUD],
        b.[PaymentAmount_USD],
        b.[PaymentAmount_NZD],
        b.[PaymentAmount_EUR],
        b.[PaymentAmount_GBP]
    FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_BankTransactions b
    INNER JOIN dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueTransactions t ON b.Id = t.LineID
    WHERE t.Source = 'BANKTRANSACTIONS' AND b.[OrganisationID] = @OrganisationID; 

    BEGIN TRANSACTION;  
        DELETE dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueBankTransactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueBankTransactions   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueBankTransactionsSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  
GO

--XEROBLUE_UniqueInvoices - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueInvoices_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueInvoices_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueInvoices_py
     @OrganisationID AS int 
AS  
    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueInvoicesSTAGE
    SELECT
        [Id],
        [InvoiceId],
        [Type],
        [ContactId],
        [ContactName],
        [LineItem_LineItemId],
        [LineItem_Description],
        [LineItem_Quantity],
        [LineItem_UnitAmount],
        [LineItem_ItemCode],
        [LineItem_AccountCode],
        [LineItem_TaxType],
        [LineItem_TaxAmount],
        [LineItem_LineAmount],
        [LineItem_TrackingCategory1_CategoryId],
        [LineItem_TrackingCategory1_CategoryName],
        [LineItem_TrackingCategory1_OptionId],
        [LineItem_TrackingCategory1_OptionName],
        [LineItem_TrackingCategory1_Option_Stat],
        [LineItem_TrackingCategory2_CategoryId],
        [LineItem_TrackingCategory2_CategoryName],
        [LineItem_TrackingCategory2_OptionId],
        [LineItem_TrackingCategory2_OptionName],
        [LineItem_TrackingCategory2_Option_Stat],
        [LineItem_DiscountRate],
        [LineItem_DiscountAmount],
        [LineItemAggregate],
        [Date],
        [DueDate],
        [LineAmountTypes],
        [InvoiceNumber],
        [Reference],
        [BrandingThemeId],
        [URL],
        [CurrencyCode],
        [CurrencyRate],
        [Status],
        [SentToContact],
        [ExpectedPaymentDate],
        [PlannedPaymentDate],
        [SubTotal],
        [TotalTax],
        [Total],
        [TotalDiscount],
        [HasAttachments],
        [PaymentIds],
        [PrePaymentIds],
        [OverPaymentIds],
        [CreditNoteIds],
        [AmountDue],
        [AmountPaid],
        [CISDeduction],
        [FullyPaidOnDate],
        [AmountCredited],
        [UpdatedDateUTC],
        [CreditNotes],
        [Prepayments],
        [Payments],
        [Overpayments],
        [RepeatingInvoiceID],
        [ClientID],
        [OrganisationID],
        [LineItem_UnitAmount_AUD],
        [LineItem_UnitAmount_USD],
        [LineItem_UnitAmount_NZD],
        [LineItem_UnitAmount_EUR],
        [LineItem_UnitAmount_GBP],
        [LineItem_TaxAmount_AUD],
        [LineItem_TaxAmount_USD],
        [LineItem_TaxAmount_NZD],
        [LineItem_TaxAmount_EUR],
        [LineItem_TaxAmount_GBP],
        [LineItem_LineAmount_AUD],
        [LineItem_LineAmount_USD],
        [LineItem_LineAmount_NZD],
        [LineItem_LineAmount_EUR],
        [LineItem_LineAmount_GBP],
        [LineItem_DiscountAmount_AUD],
        [LineItem_DiscountAmount_USD],
        [LineItem_DiscountAmount_NZD],
        [LineItem_DiscountAmount_EUR],
        [LineItem_DiscountAmount_GBP],
        [SubTotal_AUD],
        [SubTotal_USD],
        [SubTotal_NZD],
        [SubTotal_EUR],
        [SubTotal_GBP],
        [TotalTax_AUD],
        [TotalTax_USD],
        [TotalTax_NZD],
        [TotalTax_EUR],
        [TotalTax_GBP],
        [Total_AUD],
        [Total_USD],
        [Total_NZD],
        [Total_EUR],
        [Total_GBP],
        [TotalDiscount_AUD],
        [TotalDiscount_USD],
        [TotalDiscount_NZD],
        [TotalDiscount_EUR],
        [TotalDiscount_GBP],
        [AmountDue_AUD],
        [AmountDue_USD],
        [AmountDue_NZD],
        [AmountDue_EUR],
        [AmountDue_GBP],
        [AmountPaid_AUD],
        [AmountPaid_USD],
        [AmountPaid_NZD],
        [AmountPaid_EUR],
        [AmountPaid_GBP],
        [CISDeduction_AUD],
        [CISDeduction_USD],
        [CISDeduction_NZD],
        [CISDeduction_EUR],
        [CISDeduction_GBP],
        [AmountCredited_AUD],
        [AmountCredited_USD],
        [AmountCredited_NZD],
        [AmountCredited_EUR],
        [AmountCredited_GBP],
        [DiscountRate],
        [DiscountRate%],
        [LineAmountCalculation],
        [LineAmountCalculationIncTax],
        [LineAmountTradeCreditorCalculation],
        [LineAmountTradeDebtorCalculation],
        [DayDifference],
        [LineAmountCalculation_AUD],
        [LineAmountCalculation_USD],
        [LineAmountCalculation_NZD],
        [LineAmountCalculation_EUR],
        [LineAmountCalculation_GBP],
        [LineAmountCalculationIncTax_AUD],
        [LineAmountCalculationIncTax_USD],
        [LineAmountCalculationIncTax_NZD],
        [LineAmountCalculationIncTax_EUR],
        [LineAmountCalculationIncTax_GBP],
        [LineAmountTradeCreditorCalculation_AUD],
        [LineAmountTradeCreditorCalculation_USD],
        [LineAmountTradeCreditorCalculation_NZD],
        [LineAmountTradeCreditorCalculation_EUR],
        [LineAmountTradeCreditorCalculation_GBP],
        [LineAmountTradeDebtorCalculation_AUD],
        [LineAmountTradeDebtorCalculation_USD],
        [LineAmountTradeDebtorCalculation_NZD],
        [LineAmountTradeDebtorCalculation_EUR],
        [LineAmountTradeDebtorCalculation_GBP],
        [Account_UID] = [LineItem_AccountCode] + '-' + CAST([OrganisationID] AS varchar)
    FROM (
            SELECT *, 
            Row_number() OVER(PARTITION BY "InvoiceId" ORDER BY Id) rn 
            FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_Invoices
            WHERE Status in ('AUTHORISED', 'PAID')
            AND OrganisationID = @OrganisationID
        ) Invoices
    WHERE rn = 1

    BEGIN TRANSACTION;  
        DELETE dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueInvoices
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueInvoices   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueInvoicesSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT; 
GO

--XEROBLUE_UniqueCreditNotes - STORED PROCEDURE
IF OBJECT_ID('BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueCreditNotes_py', 'P') IS NOT NULL
DROP PROC BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueCreditNotes_py
GO
CREATE PROCEDURE BIGOLESHOECOMPANY_CLIENT1518.uspUpsert_XEROBLUE_UniqueCreditNotes_py
     @OrganisationID AS int 
AS  

    INSERT INTO BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueCreditNotesSTAGE
    SELECT
        [Id],
        [CreditNoteId],
        [CreditNoteNumber],
        [Reference],
        [Type],
        [Contact_ContactId],
        [Contact_Name],
        [Date],
        [Status],
        [LineAmountTypes],
        [LineItem_Description],
        [LineItem_Quantity],
        [LineItem_UnitAmount],
        [LineItem_ItemCode],
        [LineItem_AccountCode],
        [LineItem_TaxType],
        [LineItem_TaxAmount],
        [LineItem_LineAmount],
        [LineItem_TrackingCategory1_CategoryId],
        [LineItem_TrackingCategory1_CategoryName],
        [LineItem_TrackingCategory1_OptionId],
        [LineItem_TrackingCategory1_OptionName],
        [LineItem_TrackingCategory1_Option_Stat],
        [LineItem_TrackingCategory2_CategoryId],
        [LineItem_TrackingCategory2_CategoryName],
        [LineItem_TrackingCategory2_OptionId],
        [LineItem_TrackingCategory2_OptionName],
        [LineItem_TrackingCategory2_Option_Stat],
        [LineItem_DiscountRate],
        [LineItemAggregate],
        [SubTotal],
        [TotalTax],
        [Total],
        [UpdatedDateUTC],
        [CurrencyCode],
        [FullyPaidOnDate],
        [SentToContact],
        [BrandingThemeId],
        [CurrencyRate],
        [RemainingCredit],
        [Allocation1_AppliedAmount],
        [Allocation1_Date],
        [Allocation1_InvoiceId],
        [Allocation1_InvoiceNumber],
        [Allocation2_AppliedAmount],
        [Allocation2_Date],
        [Allocation2_InvoiceId],
        [Allocation2_InvoiceNumber],
        [Allocation3_AppliedAmount],
        [Allocation3_Date],
        [Allocation3_InvoiceId],
        [Allocation3_InvoiceNumber],
        [Allocation4_AppliedAmount],
        [Allocation4_Date],
        [Allocation4_InvoiceId],
        [Allocation4_InvoiceNumber],
        [Allocation5_AppliedAmount],
        [Allocation5_Date],
        [Allocation5_InvoiceId],
        [Allocation5_InvoiceNumber],
        [Allocation6_AppliedAmount],
        [Allocation6_Date],
        [Allocation6_InvoiceId],
        [Allocation6_InvoiceNumber],
        [Allocation7_AppliedAmount],
        [Allocation7_Date],
        [Allocation7_InvoiceId],
        [Allocation7_InvoiceNumber],
        [Allocation8_AppliedAmount],
        [Allocation8_Date],
        [Allocation8_InvoiceId],
        [Allocation8_InvoiceNumber],
        [Allocation9_AppliedAmount],
        [Allocation9_Date],
        [Allocation9_InvoiceId],
        [Allocation9_InvoiceNumber],
        [Allocation10_AppliedAmount],
        [Allocation10_Date],
        [Allocation10_InvoiceId],
        [Allocation10_InvoiceNumber],
        [Allocation11_AppliedAmount],
        [Allocation11_Date],
        [Allocation11_InvoiceId],
        [Allocation11_InvoiceNumber],
        [Allocation12_AppliedAmount],
        [Allocation12_Date],
        [Allocation12_InvoiceId],
        [Allocation12_InvoiceNumber],
        [Allocation13_AppliedAmount],
        [Allocation13_Date],
        [Allocation13_InvoiceId],
        [Allocation13_InvoiceNumber],
        [Allocation14_AppliedAmount],
        [Allocation14_Date],
        [Allocation14_InvoiceId],
        [Allocation14_InvoiceNumber],
        [Allocation15_AppliedAmount],
        [Allocation15_Date],
        [Allocation15_InvoiceId],
        [Allocation15_InvoiceNumber],
        [HasAttachments],
        [ClientID],
        [OrganisationID],
        [LineItem_UnitAmount_AUD],
        [LineItem_UnitAmount_USD],
        [LineItem_UnitAmount_NZD],
        [LineItem_UnitAmount_EUR],
        [LineItem_UnitAmount_GBP],
        [LineItem_TaxAmount_AUD],
        [LineItem_TaxAmount_USD],
        [LineItem_TaxAmount_NZD],
        [LineItem_TaxAmount_EUR],
        [LineItem_TaxAmount_GBP],
        [LineItem_LineAmount_AUD],
        [LineItem_LineAmount_USD],
        [LineItem_LineAmount_NZD],
        [LineItem_LineAmount_EUR],
        [LineItem_LineAmount_GBP],
        [SubTotal_AUD],
        [SubTotal_USD],
        [SubTotal_NZD],
        [SubTotal_EUR],
        [SubTotal_GBP],
        [TotalTax_AUD],
        [TotalTax_USD],
        [TotalTax_NZD],
        [TotalTax_EUR],
        [TotalTax_GBP],
        [Total_AUD],
        [Total_USD],
        [Total_NZD],
        [Total_EUR],
        [Total_GBP],
        [RemainingCredit_AUD],
        [RemainingCredit_USD],
        [RemainingCredit_NZD],
        [RemainingCredit_EUR],
        [RemainingCredit_GBP],
        [Allocation1_AppliedAmount_AUD],
        [Allocation1_AppliedAmount_USD],
        [Allocation1_AppliedAmount_NZD],
        [Allocation1_AppliedAmount_EUR],
        [Allocation1_AppliedAmount_GBP],
        [Allocation2_AppliedAmount_AUD],
        [Allocation2_AppliedAmount_USD],
        [Allocation2_AppliedAmount_NZD],
        [Allocation2_AppliedAmount_EUR],
        [Allocation2_AppliedAmount_GBP],
        [Allocation3_AppliedAmount_AUD],
        [Allocation3_AppliedAmount_USD],
        [Allocation3_AppliedAmount_NZD],
        [Allocation3_AppliedAmount_EUR],
        [Allocation3_AppliedAmount_GBP],
        [Allocation4_AppliedAmount_AUD],
        [Allocation4_AppliedAmount_USD],
        [Allocation4_AppliedAmount_NZD],
        [Allocation4_AppliedAmount_EUR],
        [Allocation4_AppliedAmount_GBP],
        [Allocation5_AppliedAmount_AUD],
        [Allocation5_AppliedAmount_USD],
        [Allocation5_AppliedAmount_NZD],
        [Allocation5_AppliedAmount_EUR],
        [Allocation5_AppliedAmount_GBP],
        [Allocation6_AppliedAmount_AUD],
        [Allocation6_AppliedAmount_USD],
        [Allocation6_AppliedAmount_NZD],
        [Allocation6_AppliedAmount_EUR],
        [Allocation6_AppliedAmount_GBP],
        [Allocation7_AppliedAmount_AUD],
        [Allocation7_AppliedAmount_USD],
        [Allocation7_AppliedAmount_NZD],
        [Allocation7_AppliedAmount_EUR],
        [Allocation7_AppliedAmount_GBP],
        [Allocation8_AppliedAmount_AUD],
        [Allocation8_AppliedAmount_USD],
        [Allocation8_AppliedAmount_NZD],
        [Allocation8_AppliedAmount_EUR],
        [Allocation8_AppliedAmount_GBP],
        [Allocation9_AppliedAmount_AUD],
        [Allocation9_AppliedAmount_USD],
        [Allocation9_AppliedAmount_NZD],
        [Allocation9_AppliedAmount_EUR],
        [Allocation9_AppliedAmount_GBP],
        [Allocation10_AppliedAmount_AUD],
        [Allocation10_AppliedAmount_USD],
        [Allocation10_AppliedAmount_NZD],
        [Allocation10_AppliedAmount_EUR],
        [Allocation10_AppliedAmount_GBP],
        [Allocation11_AppliedAmount_AUD],
        [Allocation11_AppliedAmount_USD],
        [Allocation11_AppliedAmount_NZD],
        [Allocation11_AppliedAmount_EUR],
        [Allocation11_AppliedAmount_GBP],
        [Allocation12_AppliedAmount_AUD],
        [Allocation12_AppliedAmount_USD],
        [Allocation12_AppliedAmount_NZD],
        [Allocation12_AppliedAmount_EUR],
        [Allocation12_AppliedAmount_GBP],
        [Allocation13_AppliedAmount_AUD],
        [Allocation13_AppliedAmount_USD],
        [Allocation13_AppliedAmount_NZD],
        [Allocation13_AppliedAmount_EUR],
        [Allocation13_AppliedAmount_GBP],
        [Allocation14_AppliedAmount_AUD],
        [Allocation14_AppliedAmount_USD],
        [Allocation14_AppliedAmount_NZD],
        [Allocation14_AppliedAmount_EUR],
        [Allocation14_AppliedAmount_GBP],
        [Allocation15_AppliedAmount_AUD],
        [Allocation15_AppliedAmount_USD],
        [Allocation15_AppliedAmount_NZD],
        [Allocation15_AppliedAmount_EUR],
        [Allocation15_AppliedAmount_GBP],
        [AccountUID],
        [LineAmountCreditNoteCalculation],
        [LineAmountTradeCreditorCalculation],
        [LineAmountTradeDebtorCalculation],
        [LineAmountCreditNoteCalculation_AUD],
        [LineAmountCreditNoteCalculation_USD],
        [LineAmountCreditNoteCalculation_NZD],
        [LineAmountCreditNoteCalculation_EUR],
        [LineAmountCreditNoteCalculation_GBP],
        [LineAmountTradeCreditorCalculation_AUD],
        [LineAmountTradeCreditorCalculation_USD],
        [LineAmountTradeCreditorCalculation_NZD],
        [LineAmountTradeCreditorCalculation_EUR],
        [LineAmountTradeCreditorCalculation_GBP],
        [LineAmountTradeDebtorCalculation_AUD],
        [LineAmountTradeDebtorCalculation_USD],
        [LineAmountTradeDebtorCalculation_NZD],
        [LineAmountTradeDebtorCalculation_EUR],
        [LineAmountTradeDebtorCalculation_GBP]
    FROM (
	    SELECT *, 
		Row_number() OVER(PARTITION BY "CreditNoteId" ORDER BY Id) rn 
	    FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_CreditNotes WHERE Status in ('AUTHORISED', 'PAID')
        AND OrganisationID = @OrganisationID
    ) t WHERE rn = 1;

    BEGIN TRANSACTION;  
        DELETE dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueCreditNotes
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueCreditNotes   
        SELECT * FROM dbo.BIGOLESHOECOMPANY_CLIENT1518_XEROBLUE_UniqueCreditNotesSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT; 
GO