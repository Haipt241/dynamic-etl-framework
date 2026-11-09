/**************************************************************************************
FILENAME: CREATE STORED PROCEDURES - UPSERT
DESCRIPTION: LIST OF SQL SCRIPT FOR CREATING STORED PROCEDURES FOR UPSERT PACKAGE.
	REPLACE "NEW_CLIENT1" WITH CORRECT CLIENT ID.
HISTORY:
DATE					DESCRIPTION
2023-07-13				INTIAL VERSION
2023-03-01				New version of Transaction tables
2024-04-05				Updated Contacts, TrialBalance, TransactionBlends, BudgetSummary
**************************************************************************************/

--XEROBLUE_Accounts - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Accounts', 'P') IS NOT NULL
	DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Accounts
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Accounts
    @OrganisationID AS int 
AS  

    UPDATE dbo.NEW_CLIENT1_XEROBLUE_AccountsSTAGE
    SET
        [AccountType] = CAST(
                CASE 
                WHEN [Type] = 'BANK' THEN 'Bank'
                WHEN [Type] = 'CURRENT' THEN 'Current Assets'
                WHEN [Type] = 'CURRLIAB' THEN 'Current Liabilities'
                WHEN [Type] = 'DEPRECIATN' THEN 'Depreciation'
                WHEN [Type] = 'DIRECTCOSTS' THEN 'Direct Costs'
                WHEN [Type] = 'EQUITY' THEN 'Equity'
                WHEN [Type] = 'EXPENSE' THEN 'Expenses'
                WHEN [Type] = 'LIABILITY' THEN 'Non-Current Liabilities'
                WHEN [Type] = 'NONCURRENT' THEN 'Non-Current Assets'
                WHEN [Type] = 'OTHERINCOME' THEN 'Other Income'
                WHEN [Type] = 'REVENUE' THEN 'Revenue'
                WHEN [Type] = 'SALES' THEN 'Sales'
                WHEN [Type] = 'TERMLIAB' THEN 'Non-Current Liabilities'	
                WHEN [Type] = 'FIXED' THEN 'Fixed Assets'
                WHEN [Type] = 'INVENTORY' THEN 'Inventory Assets'
                WHEN [Type] = 'OVERHEADS' THEN 'Expenses'
                WHEN [Type] = 'PREPAYMENT' THEN 'Prepayment'
                WHEN [Type] = 'PAYGLIABILITY' THEN 'PAYG Liability'
                WHEN [Type] = 'SUPERANNUATIONEXPENSE' THEN 'Expenses'
                WHEN [Type] = 'SUPERANNUATIONLIABILITY' THEN 'Superannuation Liability'
                WHEN [Type] = 'WAGESEXPENSE' THEN 'Expenses'
                ELSE 'Unknown' END AS NVARCHAR(100)
            ),
        [BalanceSheetReportingType] = CAST(
                CASE 
                WHEN CHARINDEX('EXP', [ReportingCode]) > 0 THEN 'Retained Earnings'
                WHEN CHARINDEX('REV', [ReportingCode]) > 0 THEN 'Retained Earnings'
                WHEN CHARINDEX('LIA.CUR', [ReportingCode]) > 0 THEN 'Current Liabilities'
                WHEN CHARINDEX('ASS.NCA.FIX', [ReportingCode]) > 0 THEN 'Fixed Assets'
                WHEN CHARINDEX('ASS.NCA', [ReportingCode]) > 0 THEN 'Non-Current Assets'
                WHEN CHARINDEX('ASS.CUR.CAS.BAN', [ReportingCode]) > 0 THEN 'Bank'
                WHEN CHARINDEX('ASS.CUR', [ReportingCode]) > 0 THEN 'Current Assets'
                WHEN CHARINDEX('LIA.NCL', [ReportingCode]) > 0 THEN 'Non-Current Liabilities'
                WHEN CHARINDEX('EQU', [ReportingCode]) > 0 THEN 'Equity'
                WHEN CHARINDEX('LIA', [ReportingCode]) > 0 AND ([Type] = 'LIABILITY' OR [Type] = 'TERMLIAB' ) THEN 'Non-Current Liabilities'
                WHEN CHARINDEX('LIA', [ReportingCode]) > 0 AND [Type] = 'CURRLIAB' THEN 'Current Liabilities'
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 AND [Type] = 'CURRENT' THEN 'Current Assets'
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 AND [Type] = 'BANK' THEN 'Bank'
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 AND [Type] = 'NONCURRENT' THEN 'Non-Current Assets'
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 AND [Type] = 'FIXED' THEN 'Fixed Assets'
                ELSE 'UNKNOWN' END AS NVARCHAR(100)
            ),
        [P&LReportingTypeInterim] = CAST(
                CASE 
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 THEN 'Balance Sheet Item'
                WHEN CHARINDEX('LIA', [ReportingCode]) > 0 THEN 'Balance Sheet Item'
                WHEN CHARINDEX('REV.OTH', [ReportingCode]) > 0 THEN 'Other Income'
                WHEN CHARINDEX('REV.TRA', [ReportingCode]) > 0 THEN 'Trading Income'
                WHEN CHARINDEX('REV.INV', [ReportingCode]) > 0 THEN 'Other Income'
                WHEN CHARINDEX('EXP.INC', [ReportingCode]) > 0 THEN 'Non-Operating Expenses'
                WHEN CHARINDEX('EQU', [ReportingCode]) > 0 THEN 'Balance Sheet Item'
                WHEN CHARINDEX('EXP.COS', [ReportingCode]) > 0 THEN 'Cost of Sales'
                WHEN CHARINDEX('EXP.DIV', [ReportingCode]) > 0 THEN 'Non-Operating Expenses'
                WHEN CHARINDEX('EXP.FOR', [ReportingCode]) > 0 THEN 'Non-Operating Expenses'
                WHEN CHARINDEX('EXP.DEP', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.REN', [ReportingCode]) > 0  THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.EMP', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.INT', [ReportingCode]) > 0  THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.FBT', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.ENT', [ReportingCode]) > 0  THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.BAD', [ReportingCode]) > 0  THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.NON', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('REV.GRA', [ReportingCode]) > 0 THEN 'Other Income'
                WHEN CHARINDEX('EXP.VEH', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP.AMO', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('EXP', [ReportingCode]) > 0 THEN 'Operating Expenses'
                WHEN CHARINDEX('REV', [ReportingCode]) > 0 THEN 'Other Income'
                ELSE [ReportingCode] END AS NVARCHAR(100)
            )
    WHERE [OrganisationID] = @OrganisationID;

    UPDATE dbo.NEW_CLIENT1_XEROBLUE_AccountsSTAGE
    SET
        [AccountTypeOrder] = CAST(
                CASE 
                WHEN [AccountType] = 'Revenue' THEN '1'
                WHEN [AccountType] = 'Sales' THEN '2'
                WHEN [AccountType] = 'Direct Costs' THEN '3'
                WHEN [AccountType] = 'Other Income' THEN '4'
                WHEN [AccountType] = 'Depreciation' THEN '5'
                WHEN [AccountType] = 'Expenses' THEN '6'
                WHEN [AccountType] = 'Bank' THEN '7'
                WHEN [AccountType] = 'Current Assets' THEN '8'
                WHEN [AccountType] = 'Non-Current Assets' THEN '9'
                WHEN [AccountType] = 'Current Liabilities' THEN '10'
                WHEN [AccountType] = 'Non-Current Liabilities' THEN '11'
                WHEN [AccountType] = 'Equity' THEN '12'
                ELSE '13' END AS NVARCHAR(100)
            ),
        [P&LGroup] = CAST(
                CASE 
                WHEN [AccountType] = 'Direct Costs' THEN 'Direct Grouping'
                WHEN [AccountType] = 'Revenue' THEN 'Direct Grouping'
                WHEN [AccountType] = 'Sales' THEN 'Direct Grouping'
                WHEN [AccountType] = 'Other Income' THEN 'Other Income'
                WHEN [AccountType] = 'Expenses' THEN 'Expense'
                WHEN [AccountType] = 'Depreciation' THEN 'Expense'
                ELSE 'Unknown' END AS NVARCHAR(100)
            ),
        [BalanceSheetType] = CAST(
                CASE 
                WHEN [AccountType] = 'Direct Costs' THEN 'Equity'
                WHEN [AccountType] = 'Revenue' THEN 'Equity'
                WHEN [AccountType] = 'Sales' THEN 'Equity'
                WHEN [AccountType] = 'Other Income' THEN 'Equity'
                WHEN [AccountType] = 'Expenses' THEN 'Equity'
                WHEN [AccountType] = 'Depreciation' THEN 'Equity'
                ELSE [AccountType] END AS NVARCHAR(100)
            ),
        [StatementofCashflow] = CAST(
                CASE 
                WHEN [AccountType] = 'Revenue' THEN 'Receipts from customers'
                WHEN [AccountType] = 'Sales' THEN 'Receipts from customers'
                WHEN [AccountType] = 'Direct Costs' THEN 'Payments to suppliers and employees'
                WHEN [AccountType] = 'Other Income' THEN 'Cash receipts from other operating activities'
                WHEN [AccountType] = 'Fixed Assets' THEN 'Payment for property, plant and equipment'
                WHEN [AccountType] = 'Expenses' THEN 'Payments to suppliers and employees'
                WHEN [AccountType] = 'Prepayments' THEN 'Other cash items from investing activities'
                WHEN [AccountType] = 'Current Assets' THEN 'Other cash items from investing activities'
                WHEN [AccountType] = 'Non-Current Assets' THEN 'Other cash items from investing activities'
                WHEN [AccountType] = 'Current Liabilities' THEN 'Other cash items from financing activities'
                ELSE 'Working on It' END AS NVARCHAR(100)
            ),
        [BalanceSheetReportingGroup] = CAST(
                CASE 
                WHEN CHARINDEX('ASS', [ReportingCode]) > 0 THEN 'Assets'
                WHEN CHARINDEX('EXP', [ReportingCode]) > 0  THEN 'Equity'
                WHEN CHARINDEX('LIA', [ReportingCode]) > 0  THEN 'Liabilities'
                WHEN CHARINDEX('REV', [ReportingCode]) > 0  THEN 'Equity'
                WHEN CHARINDEX('EQU', [ReportingCode]) > 0  THEN 'Equity'
                ELSE 'UNKNOWN' END AS NVARCHAR(100)
            ),
        [P&LReportingType] = (
                CASE
                WHEN CHARINDEX('.', [P&LReportingTypeInterim]) > 0 THEN SUBSTRING( [P&LReportingTypeInterim], 0, CHARINDEX('.', [P&LReportingTypeInterim])) 
                ELSE [P&LReportingTypeInterim] END
            )
    WHERE [OrganisationID] = @OrganisationID;

    UPDATE dbo.NEW_CLIENT1_XEROBLUE_AccountsSTAGE
    SET
        [BalanceSheetGroup] = CAST(
                CASE 
                WHEN [BalanceSheetType] = 'Equity' THEN 'Equity'
                WHEN [BalanceSheetType] = 'Retained Earnings' THEN 'Equity'
                WHEN [BalanceSheetType] = 'Current Assets' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Fixed Assets' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Prepayment' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Bank' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Non-Current Assets' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Inventory Assets' THEN 'Assets'
                WHEN [BalanceSheetType] = 'Current Liabilities' THEN 'Liabilities'
                WHEN [BalanceSheetType] = 'Term Liability' THEN 'Liabilities'
                WHEN [BalanceSheetType] = 'PAYG Liability' THEN 'Liabilities'
                WHEN [BalanceSheetType] = 'Non-Current Liabilities' THEN 'Liabilities'
                ELSE 'UNKNOWN' END AS NVARCHAR(100)
            ),
        [CashflowActivities] = CAST(
                CASE 
                WHEN [StatementofCashflow] = 'Receipts from customers' THEN 'Operating Activities'
                WHEN [StatementofCashflow] = 'Payments to suppliers and employees' THEN 'Operating Activities'
                WHEN [StatementofCashflow] = 'Cash receipts from other operating activities' THEN 'Operating Activities'
                WHEN [StatementofCashflow] = 'Payment for property, plant and equipment' THEN 'Investing Activities'
                WHEN [StatementofCashflow] = 'Other cash items from investing activities' THEN 'Investing Activities'
                WHEN [StatementofCashflow] = 'Other cash items from financing activities' THEN 'Financing Activities' 
                ELSE 'Working on It' END AS NVARCHAR(100)
            ),
        [P&LReportingGroup] = CAST(
                CASE 
                WHEN [P&LReportingType] = 'Trading Income' THEN 'Direct'
                WHEN [P&LReportingType] = 'Cost of Sales' THEN 'Direct'
                WHEN [P&LReportingType] = 'Other Income' THEN 'Other Income'
                WHEN [P&LReportingType] = 'Operating Expenses' THEN 'Expenses'
                WHEN [P&LReportingType] = 'Non-Operating Expenses' THEN 'Expenses'
                ELSE 'Balance Sheet Item' END AS NVARCHAR(100)
            )
    WHERE [OrganisationID] = @OrganisationID;

    UPDATE dbo.NEW_CLIENT1_XEROBLUE_AccountsSTAGE
    SET
        [Class] = UPPER(LEFT([Class],1))+LOWER(SUBSTRING([Class],2,LEN([Class]))),
        [ClassOrder] = CAST(
                CASE 
                WHEN [Class] = 'REVENUE' THEN '1'
                WHEN [Class] = 'EXPENSE' THEN '2'
                WHEN [Class] = 'ASSET' THEN '3'
                WHEN [Class] = 'LIABILITY' THEN '4'
                WHEN [Class] = 'EQUITY' THEN '5'
                ELSE '6' END AS NVARCHAR(100)
            ),
        [P&LGroupOrder] = CAST(
                CASE 
                WHEN [P&LGroup] = 'Direct Grouping' THEN '1'
                WHEN [P&LGroup] = 'Other Income' THEN '2'
                WHEN [P&LGroup] = 'Expense' THEN '3'
                ELSE '4' END AS NVARCHAR(100)
            ),
        [BalanceSheetAccountName] = CAST(
                CASE 
                WHEN [P&LGroup] <> 'Unknown' THEN 'Retained Earnings'
                ELSE Name END AS NVARCHAR(100)
            ),
        [BalanceSheetReportingTypeOrder] = CAST(
                CASE 
                WHEN [BalanceSheetReportingType] = 'Bank' THEN '1'
                WHEN [BalanceSheetReportingType] = 'Current Assets' THEN '2'
                WHEN [BalanceSheetReportingType] = 'Current Assets' THEN '3'
                WHEN [BalanceSheetReportingType] = 'Non-Current Assets' THEN '4'
                WHEN [BalanceSheetReportingType] = 'Fixed Assets' THEN '5'
                WHEN [BalanceSheetReportingType] = 'Current Liabilities' THEN '6'
                WHEN [BalanceSheetReportingType] = 'Non-Current Liabilities' THEN '7'
                WHEN [BalanceSheetReportingType] = 'PAYG Liability' THEN '8'
                WHEN [BalanceSheetReportingType] = 'Superannuation Liability' THEN '9'
                WHEN [BalanceSheetReportingType] = 'Retained Earnings' THEN '10'
                WHEN [BalanceSheetReportingType] = 'Equity' THEN '11'
                WHEN [BalanceSheetReportingType] = 'Revenue' THEN '12'
                WHEN [BalanceSheetReportingType] = 'Sales' THEN '13'
                WHEN [BalanceSheetReportingType] = 'Direct Costs' THEN '14'
                WHEN [BalanceSheetReportingType] = 'Expenses' THEN '15'
                WHEN [BalanceSheetReportingType] = 'Depreciation' THEN '16'
                WHEN [BalanceSheetReportingType] = 'Other Income' THEN '17'
                WHEN [BalanceSheetReportingType] = 'Overheads' THEN '18'
                WHEN [BalanceSheetReportingType] = 'Prepayment' THEN '19'
                WHEN [BalanceSheetReportingType] = 'Superannuation Expense' THEN '20'
                WHEN [BalanceSheetReportingType] = 'Wages Expense' THEN '21'
                ELSE 'Unknown' END AS NVARCHAR(100)
            ),
        [BalanceSheetReportingGroupOrder] = CAST(
                CASE 
                WHEN [BalanceSheetReportingGroup] = 'Assets' THEN '1'
                WHEN [BalanceSheetReportingGroup] = 'Liabilities' THEN '2'
                WHEN [BalanceSheetReportingGroup] = 'Equity' THEN '3'
                ELSE 'Unknown' END AS NVARCHAR(100)
            ),
        [P&LReportingGroupOrder] = CAST(
                CASE 
                WHEN [P&LReportingGroup] = 'Direct' THEN '1'
                WHEN [P&LReportingGroup] = 'Other Income' THEN '2'
                WHEN [P&LReportingGroup] = 'Expenses' THEN '3'
                ELSE '4' END AS NVARCHAR(100)
            ),
        [P&LReportingTypeOrder] = CAST(
                CASE 
                WHEN [P&LReportingType] = 'Trading Income' THEN '1'
                WHEN [P&LReportingType] = 'Cost of Sales' THEN '2'
                WHEN [P&LReportingType] = 'Other Income' THEN '3'
                WHEN [P&LReportingType] = 'Operating Expenses' THEN '4'
                WHEN [P&LReportingType] = 'Non-Operating Expenses' THEN '5'
                ELSE '6' END AS NVARCHAR(100)
            ),
        [BalanceSheetGroupOrder] = CAST(
                CASE 
                WHEN [BalanceSheetGroup] = 'Assets' THEN '1'
                WHEN [BalanceSheetGroup] = 'Liabilities' THEN '2'
                WHEN [BalanceSheetGroup] = 'Equity' THEN '3'
                ELSE '4' END AS NVARCHAR(100)
            ),
        [CashflowActivitiesOrder] = CAST(
                CASE 
                WHEN [CashflowActivities] = 'Operating Activities' THEN '1'
                WHEN [CashflowActivities] = 'Investing Activities' THEN '2'
                WHEN [CashflowActivities] = 'Financing Activities' THEN '3'
                ELSE '4' END AS NVARCHAR(100)
            ),
        [StatementofCashflowOrder] = CAST(
                CASE 
                WHEN [StatementofCashflow] = 'Receipts from customers' THEN '1'
                WHEN [StatementofCashflow] = 'Payments to suppliers and employees' THEN '2'
                WHEN [StatementofCashflow] = 'Cash receipts from other operating activities' THEN '3'
                WHEN [StatementofCashflow] = 'Payment for property, plant and equipment' THEN '4'
                WHEN [StatementofCashflow] = 'Other cash items from investing activities' THEN '5'
                WHEN [StatementofCashflow] = 'Other cash items from financing activities' THEN '6'
                ELSE '7' END AS NVARCHAR(100)
            ),
        [CashIn/CashOut] = CAST(
                CASE 
                WHEN [Class] = 'Asset' THEN 'Cash In'
                WHEN [Class] = 'Liability' THEN 'Cash Out'
                WHEN [Class] = 'Revenue' THEN 'Cash In'
                WHEN [Class] = 'Expense' THEN 'Cash Out'
                ELSE 'UNKNOWN' END AS NVARCHAR(100)
            ),
        [Account_UID] = ISNULL([Code], 'BLANK') + '-' + CAST([OrganisationID] AS varchar),
        [AccountName_UID] = ISNULL([Name], 'BLANK') + CAST([OrganisationID] AS varchar)
    WHERE [OrganisationID] = @OrganisationID;

	BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_Accounts
        WHERE [OrganisationID] = @OrganisationID;
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Accounts
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_AccountsSTAGE
        WHERE [OrganisationID] = @OrganisationID;
    COMMIT;  

EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Accounts', 'NEW_CLIENT1_XEROBLUE_AccountsSTAGE'
GO


--XEROBLUE_OrganisationsCLIENTS - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_OrganisationsCLIENTS', 'P') IS NOT NULL
	DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_OrganisationsCLIENTS
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_OrganisationsCLIENTS
    @OrganisationID AS int 
AS  

    BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS 
        WHERE OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;

EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS', 'NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTSTAGE'
GO


--XEROBLUE_BankTransfers - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransfers', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransfers
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransfers
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	UPDATE bnktrnsfr
	SET  [Amount_AUD] = bnktrnsfr.[Amount] * fx.[AUD]
		,[Amount_USD] = bnktrnsfr.[Amount] * fx.[USD]
		,[Amount_NZD] = bnktrnsfr.[Amount] * fx.[NZD]
		,[Amount_EUR] = bnktrnsfr.[Amount] * fx.[EUR]
		,[Amount_GBP] = bnktrnsfr.[Amount] * fx.[GBP]
	FROM NEW_CLIENT1_XEROBLUE_BankTransfersSTAGE bnktrnsfr
	LEFT JOIN NEW_CLIENT1_XEROBLUE_Accounts acct ON bnktrnsfr.FromBankAccount_AccountId = acct.AccountId AND bnktrnsfr.OrganisationID = acct.OrganisationID
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = acct.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN bnktrnsfr.[Date] <= @minDate THEN @minDate 
									WHEN bnktrnsfr.[Date] >= @maxDate THEN @maxDate
									ELSE bnktrnsfr.[Date] 
								END
	WHERE bnktrnsfr.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransfers TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_BankTransfersSTAGE STG ON TRG.BankTransferId = STG.BankTransferId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BankTransfers 
		SELECT [BankTransferId]
			  ,[FromBankAccount_Code]
			  ,[FromBankAccount_AccountId]
			  ,[FromBankAccount_Name]
			  ,[ToBankAccount_Code]
			  ,[ToBankAccount_AccountId]
			  ,[ToBankAccount_Name]
			  ,[Amount]
			  ,[Date]
			  ,[CurrencyRate]
			  ,[FromBankTransactionID]
			  ,[ToBankTransactionID]
			  ,[HasAttachments]
			  ,[CreatedDateUTC]
			  ,[ClientID]
			  ,[OrganisationID]
			  ,[Amount_AUD]
			  ,[Amount_USD]
			  ,[Amount_NZD]
			  ,[Amount_EUR]
			  ,[Amount_GBP]
		FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransfersSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BankTransfers', 'NEW_CLIENT1_XEROBLUE_BankTransfersSTAGE'
GO


--XEROBLUE_BatchPayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BatchPayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BatchPayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BatchPayments
     @OrganisationID AS int 
AS 
    BEGIN TRANSACTION;
        DELETE TRG
        FROM dbo.NEW_CLIENT1_XEROBLUE_BatchPayments TRG
        INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_BatchPaymentsSTAGE STG ON TRG.BatchPaymentId = STG.BatchPaymentId
        WHERE TRG.OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BatchPayments 
        SELECT 
            Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY BatchPaymentId ORDER BY [Date]),'|',BatchPaymentId)
            ,BatchPaymentId
            ,AccountId
            ,Particulars
            ,Code
            ,Reference
            ,Details
            ,Narrative
            ,Date
            ,Payment_PaymentId = jPayment_PaymentId
            ,Payment_InvoiceId = jPayment_InvoiceId
            ,Payment_BankAccountNumber = jPayment_BankAccountNumber
            ,Payment_Particulars = jPayment_Particulars
            ,Payment_Code = jPayment_Code
            ,Payment_Reference = jPayment_Reference
            ,Payment_Details = jPayment_Details
            ,Payment_Amount = jPayment_Amount
            ,PaymentAggregate = NULL
            ,Type
            ,Status
            ,TotalAmount
            ,IsReconciled
            ,UpdatedDateUTC
            ,ClientID
            ,OrganisationID
        FROM dbo.NEW_CLIENT1_XEROBLUE_BatchPaymentsSTAGE
        CROSS APPLY OPENJSON(PaymentAggregate)
        WITH(
                jPayment_PaymentId NVARCHAR(MAX) '$.PaymentID'
                ,jPayment_InvoiceId NVARCHAR(MAX) '$.Invoice.InvoiceID'
                ,jPayment_BankAccountNumber NVARCHAR(MAX) '$.BankAccountNumber'
                ,jPayment_Particulars NVARCHAR(MAX) '$.Particulars'
                ,jPayment_Code NVARCHAR(MAX) '$.Code'
                ,jPayment_Reference NVARCHAR(MAX) '$.Reference'
                ,jPayment_Details NVARCHAR(MAX) '$.Details'
                ,jPayment_Amount NUMERIC(30,6) '$.Amount'
            )
        WHERE OrganisationId = @OrganisationID
        UNION ALL
        SELECT 
            Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY BatchPaymentId ORDER BY [Date]),'|',BatchPaymentId)
            ,BatchPaymentId
            ,AccountId
            ,Particulars
            ,Code
            ,Reference
            ,Details
            ,Narrative
            ,Date
            ,Payment_PaymentId
            ,Payment_InvoiceId
            ,Payment_BankAccountNumber
            ,Payment_Particulars
            ,Payment_Code
            ,Payment_Reference
            ,Payment_Details
            ,Payment_Amount
            ,PaymentAggregate = NULL
            ,Type
            ,Status
            ,TotalAmount
            ,IsReconciled
            ,UpdatedDateUTC
            ,ClientID
            ,OrganisationID
        FROM dbo.NEW_CLIENT1_XEROBLUE_BatchPaymentsSTAGE
        WHERE PaymentAggregate = '[]' AND OrganisationId = @OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BatchPayments', 'NEW_CLIENT1_XEROBLUE_BatchPaymentsSTAGE'
GO


--XEROBLUE_ContactGroups - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroups', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroups
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroups
     @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_ContactGroups
        WHERE OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ContactGroups
        select * from dbo.NEW_CLIENT1_XEROBLUE_ContactGroupsSTAGE
        WHERE OrganisationId = OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ContactGroups', 'NEW_CLIENT1_XEROBLUE_ContactGroupsSTAGE'
GO


--XEROBLUE_Contacts - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Contacts', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Contacts
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Contacts
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        UPDATE dbo.NEW_CLIENT1_XEROBLUE_ContactsSTAGE
        SET
            FullAddress = Street_AddressLine1 + ' ' + Street_City + ' ' + Street_Region + ' ' + Street_Country  + ' ' + Street_PostalCode,
            RegionAddress = Street_City + ' ' + Street_Region + ' ' + Street_Country
        WHERE OrganisationId = @OrganisationID;

        DELETE trgt
        FROM dbo.NEW_CLIENT1_XEROBLUE_Contacts trgt
        INNER JOIN NEW_CLIENT1_XEROBLUE_ContactsSTAGE stg
            ON trgt.OrganisationId = stg.OrganisationId AND trgt.ContactId = stg.ContactId
        WHERE trgt.OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Contacts 
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_ContactsSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Contacts', 'NEW_CLIENT1_XEROBLUE_ContactsSTAGE'
GO


--XEROBLUE_Employees - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Employees', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Employees
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Employees
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Employees
        WHERE OrganisationId =@OrganisationID ;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Employees
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_EmployeesSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Employees', 'NEW_CLIENT1_XEROBLUE_EmployeesSTAGE'
GO


--XEROBLUE_ExpenseClaims - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaims', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaims
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaims
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaims 
        WHERE OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaims 
        SELECT * FROM  dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimsSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ExpenseClaims', 'NEW_CLIENT1_XEROBLUE_ExpenseClaimsSTAGE'
GO


--XEROBLUE_Items - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Items', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Items
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Items
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        UPDATE dbo.NEW_CLIENT1_XEROBLUE_ItemsSTAGE
        SET
            CodeUID = Code + CAST(OrganisationID AS varchar),
            InventoryCodeUID = InventoryAssetAccountCode + CAST(OrganisationID AS varchar)
        WHERE OrganisationId = @OrganisationID;

        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Items 
        WHERE OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Items 
        SELECT * FROM  dbo.NEW_CLIENT1_XEROBLUE_ItemsSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Items', 'NEW_CLIENT1_XEROBLUE_ItemsSTAGE'
GO


--XEROBLUE_LinkedTransactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_LinkedTransactions', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_LinkedTransactions
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_LinkedTransactions
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_LinkedTransactions 
        WHERE OrganisationId =12345;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_LinkedTransactions 
        SELECT * FROM  dbo.NEW_CLIENT1_XEROBLUE_LinkedTransactionsSTAGE
        WHERE OrganisationId =12345;
    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_LinkedTransactions', 'NEW_CLIENT1_XEROBLUE_LinkedTransactionsSTAGE'
GO


--XEROBLUE_PurchaseOrders - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_PurchaseOrders', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_PurchaseOrders
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_PurchaseOrders
    @OrganisationID AS int 
AS
    BEGIN TRANSACTION;

        DELETE TRG
        FROM dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrders TRG
        INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrdersSTAGE STG ON TRG.PurchaseOrderId = STG.PurchaseOrderId
        WHERE TRG.OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrders 
        SELECT
            Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY PurchaseOrderId ORDER BY PurchaseOrderId, [Date]),'|',PurchaseOrderId)
            ,PurchaseOrderId
            ,PurchaseOrderNumber
            ,Reference
            ,Type
            ,Contact_ContactId
            ,Contact_Name
            ,DeliveryDate
            ,Date
            ,Status
            ,LineAmountTypes
            ,LineItem_LineItemId = jLineItem_LineItemId
            ,LineItem_Description = jLineItem_Description
            ,LineItem_Quantity = jLineItem_Quantity
            ,LineItem_UnitAmount = jLineItem_UnitAmount
            ,LineItem_ItemCode = jLineItem_ItemCode
            ,LineItem_AccountCode = jLineItem_AccountCode
            ,LineItem_TaxType = jLineItem_TaxType
            ,LineItem_TaxAmount = jLineItem_TaxAmount
            ,LineItem_LineAmount = jLineItem_LineAmount
            ,LineItem_DiscountRate = jLineItem_DiscountRate
            ,LineItemAggregate = NULL
            ,SubTotal
            ,TotalTax
            ,Total
            ,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
            ,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
            ,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
            ,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
            ,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
            ,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
            ,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
            ,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
            ,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
            ,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
            ,UpdatedDateUTC
            ,HasAttachments
            ,CurrencyCode
            ,BrandingThemeId
            ,CurrencyRate
            ,TotalDiscount
            ,SentToContact
            ,Telephone
            ,IsDiscounted
            ,ExpectedArrivalDate
            ,DeliveryInstructions
            ,DeliveryAddress
            ,ClientID
            ,OrganisationID
        FROM dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrdersSTAGE
        CROSS APPLY OPENJSON(LineItemAggregate)
        WITH(
            jLineItem_LineItemId NVARCHAR(MAX) '$.LineItemID'
            ,jLineItem_Description NVARCHAR(MAX) '$.Description'
            ,jLineItem_Quantity FLOAT '$.Quantity'
            ,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
            ,jLineItem_ItemCode NVARCHAR(MAX) '$.ItemCode'
            ,jLineItem_AccountCode NVARCHAR(MAX) '$.AccountCode'
            ,jLineItem_TaxType NVARCHAR(MAX) '$.TaxType'
            ,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
            ,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
            ,jLineItem_DiscountRate FLOAT '$.DiscountRate'
            ,jLineItem_TrackingCategory1_CategoryId NVARCHAR(MAX) '$.Tracking[0].TrackingCategoryID'
            ,jLineItem_TrackingCategory1_CategoryName NVARCHAR(MAX) '$.Tracking[0].Name'
            ,jLineItem_TrackingCategory1_OptionId NVARCHAR(MAX) '$.Tracking[0].TrackingOptionID'
            ,jLineItem_TrackingCategory1_OptionName NVARCHAR(MAX) '$.Tracking[0].Option'
            ,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(MAX) '$.Tracking[0].Status'
            ,jLineItem_TrackingCategory2_CategoryId NVARCHAR(MAX) '$.Tracking[1].TrackingCategoryID'
            ,jLineItem_TrackingCategory2_CategoryName NVARCHAR(MAX) '$.Tracking[1].Name'
            ,jLineItem_TrackingCategory2_OptionId NVARCHAR(MAX) '$.Tracking[1].TrackingOptionID'
            ,jLineItem_TrackingCategory2_OptionName NVARCHAR(MAX) '$.Tracking[1].Option'
            ,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(MAX) '$.Tracking[1].Status'
        )
        WHERE OrganisationID = @OrganisationID
        UNION ALL
        SELECT
            Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY PurchaseOrderId ORDER BY PurchaseOrderId, [Date]),'|',PurchaseOrderId)
            ,PurchaseOrderId
            ,PurchaseOrderNumber
            ,Reference
            ,Type
            ,Contact_ContactId
            ,Contact_Name
            ,DeliveryDate
            ,Date
            ,Status
            ,LineAmountTypes
            ,LineItem_LineItemId
            ,LineItem_Description
            ,LineItem_Quantity
            ,LineItem_UnitAmount
            ,LineItem_ItemCode
            ,LineItem_AccountCode
            ,LineItem_TaxType
            ,LineItem_TaxAmount
            ,LineItem_LineAmount
            ,LineItem_DiscountRate
            ,LineItemAggregate = NULL
            ,SubTotal
            ,TotalTax
            ,Total
            ,LineItem_TrackingCategory1_CategoryId
            ,LineItem_TrackingCategory1_CategoryName
            ,LineItem_TrackingCategory1_OptionId
            ,LineItem_TrackingCategory1_OptionName
            ,LineItem_TrackingCategory1_Option_Stat
            ,LineItem_TrackingCategory2_CategoryId
            ,LineItem_TrackingCategory2_CategoryName
            ,LineItem_TrackingCategory2_OptionId
            ,LineItem_TrackingCategory2_OptionName
            ,LineItem_TrackingCategory2_Option_Stat
            ,UpdatedDateUTC
            ,HasAttachments
            ,CurrencyCode
            ,BrandingThemeId
            ,CurrencyRate
            ,TotalDiscount
            ,SentToContact
            ,Telephone
            ,IsDiscounted
            ,ExpectedArrivalDate
            ,DeliveryInstructions
            ,DeliveryAddress
            ,ClientID
            ,OrganisationID
        FROM dbo.NEW_CLIENT1_XEROBLUE_PurchaseOrdersSTAGE
        WHERE LineItemAggregate = '[]' AND OrganisationID = @OrganisationID;

    COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_PurchaseOrders', 'NEW_CLIENT1_XEROBLUE_PurchaseOrdersSTAGE'
GO


--XEROBLUE_Receipts - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Receipts', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Receipts
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Receipts
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;

		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Receipts 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Receipts 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ReceiptId ORDER BY [Date]),'|',ReceiptId)
			,ReceiptId
			,Date
			,Contact_ContactId
			,Contact_Name
			,LineItem_Description = jLineItem_Description
			,LineItem_UnitAmount = jLineItem_UnitAmount
			,LineItem_AccountCode = jLineItem_AccountCode
			,LineItem_Quantity = jLineItem_Quantity
			,LineItem_TaxType = jLineItem_TaxType
			,LineItem_LineAmount = jLineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate = jLineItem_DiscountRate
			,LineItemAggregate = NULL
			,User_UserId
			,Reference
			,LineAmountTypes
			,SubTotal
			,TotalTax
			,Total
			,Status
			,ReceiptNumber
			,UpdatedDateUTC
			,HasAttachments
			,URL
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ReceiptsSTAGE
		CROSS APPLY OPENJSON(LineItemAggregate)
		WITH(
				jLineItem_Description NVARCHAR(MAX) '$.Description'
				,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
				,jLineItem_AccountCode NVARCHAR(MAX) '$.AccountCode'
				,jLineItem_Quantity FLOAT '$.Quantity'
				,jLineItem_TaxType NVARCHAR(MAX) '$.TaxType'
				,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
				,jLineItem_TrackingCategory1_CategoryId NVARCHAR(MAX) '$.Tracking[0].TrackingCategoryID'
				,jLineItem_TrackingCategory1_CategoryName NVARCHAR(MAX) '$.Tracking[0].Name'
				,jLineItem_TrackingCategory1_OptionId NVARCHAR(MAX) '$.Tracking[0].TrackingOptionID'
				,jLineItem_TrackingCategory1_OptionName NVARCHAR(MAX) '$.Tracking[0].Option'
				,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(MAX) '$.Tracking[0].Status'
				,jLineItem_TrackingCategory2_CategoryId NVARCHAR(MAX) '$.Tracking[1].TrackingCategoryID'
				,jLineItem_TrackingCategory2_CategoryName NVARCHAR(MAX) '$.Tracking[1].Name'
				,jLineItem_TrackingCategory2_OptionId NVARCHAR(MAX) '$.Tracking[1].TrackingOptionID'
				,jLineItem_TrackingCategory2_OptionName NVARCHAR(MAX) '$.Tracking[1].Option'
				,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(MAX) '$.Tracking[1].Status'
				,jLineItem_DiscountRate FLOAT '$.DiscountRate'
			)
		WHERE OrganisationId = @OrganisationID
		UNION ALL
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ReceiptId ORDER BY [Date]),'|',ReceiptId)
			,ReceiptId
			,Date
			,Contact_ContactId
			,Contact_Name
			,LineItem_Description
			,LineItem_UnitAmount
			,LineItem_AccountCode
			,LineItem_Quantity
			,LineItem_TaxType
			,LineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate
			,LineItemAggregate = NULL
			,User_UserId
			,Reference
			,LineAmountTypes
			,SubTotal
			,TotalTax
			,Total
			,Status
			,ReceiptNumber
			,UpdatedDateUTC
			,HasAttachments
			,URL
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ReceiptsSTAGE
		WHERE LineItemAggregate = '[]' AND OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Receipts', 'NEW_CLIENT1_XEROBLUE_ReceiptsSTAGE'
GO


--XEROBLUE_TaxRates - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_TaxRates', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_TaxRates
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_TaxRates
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_TaxRates 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_TaxRates 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_TaxRatesSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_TaxRates', 'NEW_CLIENT1_XEROBLUE_TaxRatesSTAGE'
GO


--XEROBLUE_BalanceSheet - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BalanceSheet', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BalanceSheet
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BalanceSheet
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;  

        DELETE dbo.NEW_CLIENT1_XEROBLUE_BalanceSheet
        WHERE [OrganisationID] = @OrganisationID;
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BalanceSheet
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_BalanceSheetSTAGE
        WHERE [OrganisationID] = @OrganisationID;

        DELETE dbo.NEW_CLIENT1_XEROBLUE_BalanceSheetPivot
        WHERE [OrganisationID] = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BalanceSheetPivot
        SELECT
            Details."ID" AS "ID",
            Details."Title" AS "Title",
            Details."Label1"  AS "Account Name",
            Details."Amount"  AS "Amount",
            Months."Month"  AS "Month",
            Details."AccountId"  AS "Account ID",
            Details."ClientID" AS "Client ID",
            Details."OrganisationID" AS "Organisation ID"
        FROM (
            SELECT ID, Title, Label1, Amount, "Label", AccountId, ClientID, OrganisationID
            FROM (
                SELECT 
                    *
                FROM dbo.NEW_CLIENT1_XEROBLUE_BalanceSheet 
                WHERE Label1 <> ''
                AND [OrganisationID] = @OrganisationID
            ) p
            UNPIVOT (
                Amount FOR "Label" IN
                (Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9,Label10,Label11,Label12,Label13)
            ) AS UNPVT ) Details
        INNER JOIN (
            SELECT ID, "Month", "Label", ClientID, OrganisationID
            FROM (
                SELECT 
                    *
                FROM dbo.NEW_CLIENT1_XEROBLUE_BalanceSheet 
                WHERE Label1 = ''
                AND [OrganisationID] = @OrganisationID
            ) p
            UNPIVOT (
                "Month" FOR "Label" IN
                (Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9,Label10,Label11,Label12,Label13)
            ) AS UNPVT ) Months 
        ON Months."Label" = Details."Label" AND Months.OrganisationID = Details.OrganisationID

    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BalanceSheet', 'NEW_CLIENT1_XEROBLUE_BalanceSheetSTAGE'
GO


--XEROBLUE_BankStatement - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BankStatement', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BankStatement
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BankStatement
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BankStatement 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BankStatement 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_BankStatementSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BankStatement', 'NEW_CLIENT1_XEROBLUE_BankStatementSTAGE'
GO


--XEROBLUE_BankSummary - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BankSummary', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BankSummary
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BankSummary
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BankSummary 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BankSummary 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_BankSummarySTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BankSummary', 'NEW_CLIENT1_XEROBLUE_BankSummarySTAGE'
GO



--XEROBLUE_BrandingThemes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BrandingThemes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BrandingThemes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BrandingThemes
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BrandingThemes 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BrandingThemes 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_BrandingThemesSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BrandingThemes', 'NEW_CLIENT1_XEROBLUE_BrandingThemesSTAGE'
GO


--XEROBLUE_Currencies - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Currencies', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Currencies
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Currencies
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Currencies 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Currencies 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_CurrenciesSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Currencies', 'NEW_CLIENT1_XEROBLUE_CurrenciesSTAGE'
GO


--XEROBLUE_ExecutiveSummary - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ExecutiveSummary', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ExecutiveSummary
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ExecutiveSummary
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_ExecutiveSummary 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ExecutiveSummary
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_ExecutiveSummarySTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ExecutiveSummary', 'NEW_CLIENT1_XEROBLUE_ExecutiveSummarySTAGE'
GO


--XEROBLUE_Quotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Quotes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Quotes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Quotes
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_Quotes TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_QuotesSTAGE STG ON TRG.QuoteId = STG.QuoteId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Quotes 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY QuoteId ORDER BY [Date]),'|',QuoteId)
			,QuoteId
			,ContactId
			,ContactName
			,Date
			,ExpiryDate
			,Status
			,LineItem_LineItemId = jLineItem_LineItemId
			,LineItem_Description = jLineItem_Description
			,LineItem_Quantity = jLineItem_Quantity
			,LineItem_UnitAmount = jLineItem_UnitAmount
			,LineItem_ItemCode = jLineItem_ItemCode
			,LineItem_AccountCode = jLineItem_AccountCode
			,LineItem_TaxType = jLineItem_TaxType
			,LineItem_TaxAmount = jLineItem_TaxAmount
			,LineItem_LineAmount = jLineItem_LineAmount
			,LineItem_DiscountRate = jLineItem_DiscountRate
			,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
			,QuoteNumber
			,LineAmountTypes
			,Reference
			,CurrencyCode
			,CurrencyRate
			,SubTotal
			,TotalTax
			,Total
			,TotalDiscount
			,BrandingThemeId
			,Terms
			,Title
			,Summary
			,UpdatedDateUTC
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_QuotesSTAGE
		CROSS APPLY OPENJSON(LineItem_LineItemId)
		WITH(
				jLineItem_LineItemId NVARCHAR(MAX) '$.LineItemID'
				,jLineItem_Description NVARCHAR(MAX) '$.Description'
				,jLineItem_Quantity FLOAT '$.Quantity'
				,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
				,jLineItem_ItemCode NVARCHAR(MAX) '$.ItemCode'
				,jLineItem_AccountCode NVARCHAR(MAX) '$.AccountCode'
				,jLineItem_TaxType NVARCHAR(MAX) '$.TaxType'
				,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
				,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
				,jLineItem_DiscountRate FLOAT '$.DiscountRate'
				,jLineItem_TrackingCategory1_CategoryId NVARCHAR(MAX) '$.Tracking[0].TrackingCategoryID'
				,jLineItem_TrackingCategory1_CategoryName NVARCHAR(MAX) '$.Tracking[0].Name'
				,jLineItem_TrackingCategory1_OptionId NVARCHAR(MAX) '$.Tracking[0].TrackingOptionID'
				,jLineItem_TrackingCategory1_OptionName NVARCHAR(MAX) '$.Tracking[0].Option'
				,jLineItem_TrackingCategory2_CategoryId NVARCHAR(MAX) '$.Tracking[1].TrackingCategoryID'
				,jLineItem_TrackingCategory2_CategoryName NVARCHAR(MAX) '$.Tracking[1].Name'
				,jLineItem_TrackingCategory2_OptionId NVARCHAR(MAX) '$.Tracking[1].TrackingOptionID'
				,jLineItem_TrackingCategory2_OptionName NVARCHAR(MAX) '$.Tracking[1].Option'
			)
		WHERE OrganisationID = @OrganisationID
		UNION ALL
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY QuoteId ORDER BY [Date]),'|',QuoteId)
			,QuoteId
			,ContactId
			,ContactName
			,Date
			,ExpiryDate
			,Status
			,LineItem_LineItemId = NULL
			,LineItem_Description
			,LineItem_Quantity
			,LineItem_UnitAmount
			,LineItem_ItemCode
			,LineItem_AccountCode
			,LineItem_TaxType
			,LineItem_TaxAmount
			,LineItem_LineAmount
			,LineItem_DiscountRate
			,LineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName
			,QuoteNumber
			,LineAmountTypes
			,Reference
			,CurrencyCode
			,CurrencyRate
			,SubTotal
			,TotalTax
			,Total
			,TotalDiscount
			,BrandingThemeId
			,Terms
			,Title
			,Summary
			,UpdatedDateUTC
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_QuotesSTAGE
		WHERE LineItem_LineItemId = '[]' AND OrganisationID = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Quotes', 'NEW_CLIENT1_XEROBLUE_QuotesSTAGE'
GO


--XEROBLUE_RepeatingInvoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_RepeatingInvoices', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_RepeatingInvoices
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_RepeatingInvoices
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;

		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_RepeatingInvoices 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_RepeatingInvoices 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY RepeatingInvoiceId ORDER BY Schedule_StartDate),'|',RepeatingInvoiceId)
			,RepeatingInvoiceId
			,Type
			,ContactId
			,ContactName
			,Schedule_Period
			,Schedule_Unit
			,Schedule_DueDate
			,Schedule_DueDateType
			,Schedule_StartDate
			,Schedule_NextScheduledDate
			,Schedule_EndDate
			,LineItem_LineItemId = jLineItem_LineItemId
			,LineItem_Description = jLineItem_Description
			,LineItem_Quantity = jLineItem_Quantity
			,LineItem_UnitAmount = jLineItem_UnitAmount
			,LineItem_ItemCode = jLineItem_ItemCode
			,LineItem_AccountCode = jLineItem_AccountCode
			,LineItem_TaxType = jLineItem_TaxType
			,LineItem_TaxAmount = jLineItem_TaxAmount
			,LineItem_LineAmount = jLineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate = jLineItem_DiscountRate
			,LineAmountTypes
			,Reference
			,BrandingThemeId
			,CurrencyCode
			,Status
			,SubTotal
			,TotalTax
			,Total
			,HasAttachments
			,UpdatedDateUTC
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_RepeatingInvoicesSTAGE
		CROSS APPLY OPENJSON(LineItem_LineItemId)
		WITH(
				jLineItem_LineItemId NVARCHAR(MAX) '$.LineItemID'
				,jLineItem_Description NVARCHAR(MAX) '$.Description'
				,jLineItem_Quantity FLOAT '$.Quantity'
				,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
				,jLineItem_ItemCode NVARCHAR(MAX) '$.ItemCode'
				,jLineItem_AccountCode NVARCHAR(MAX) '$.AccountCode'
				,jLineItem_TaxType NVARCHAR(MAX) '$.TaxType'
				,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
				,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
				,jLineItem_TrackingCategory1_CategoryId NVARCHAR(MAX) '$.Tracking[0].TrackingCategoryID'
				,jLineItem_TrackingCategory1_CategoryName NVARCHAR(MAX) '$.Tracking[0].Name'
				,jLineItem_TrackingCategory1_OptionId NVARCHAR(MAX) '$.Tracking[0].TrackingOptionID'
				,jLineItem_TrackingCategory1_OptionName NVARCHAR(MAX) '$.Tracking[0].Option'
				,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(MAX) '$.Tracking[0].Status'
				,jLineItem_TrackingCategory2_CategoryId NVARCHAR(MAX) '$.Tracking[1].TrackingCategoryID'
				,jLineItem_TrackingCategory2_CategoryName NVARCHAR(MAX) '$.Tracking[1].Name'
				,jLineItem_TrackingCategory2_OptionId NVARCHAR(MAX) '$.Tracking[1].TrackingOptionID'
				,jLineItem_TrackingCategory2_OptionName NVARCHAR(MAX) '$.Tracking[1].Option'
				,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(MAX) '$.Tracking[1].Status'
				,jLineItem_DiscountRate FLOAT '$.DiscountRate'
			)
		WHERE OrganisationId = @OrganisationID
		UNION ALL
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY RepeatingInvoiceId ORDER BY Schedule_StartDate),'|',RepeatingInvoiceId)
			,RepeatingInvoiceId
			,Type
			,ContactId
			,ContactName
			,Schedule_Period
			,Schedule_Unit
			,Schedule_DueDate
			,Schedule_DueDateType
			,Schedule_StartDate
			,Schedule_NextScheduledDate
			,Schedule_EndDate
			,LineItem_LineItemId = NULL
			,LineItem_Description
			,LineItem_Quantity
			,LineItem_UnitAmount
			,LineItem_ItemCode
			,LineItem_AccountCode
			,LineItem_TaxType
			,LineItem_TaxAmount
			,LineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate
			,LineAmountTypes
			,Reference
			,BrandingThemeId
			,CurrencyCode
			,Status
			,SubTotal
			,TotalTax
			,Total
			,HasAttachments
			,UpdatedDateUTC
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_RepeatingInvoicesSTAGE
		WHERE LineItem_LineItemId = '[]' AND OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_RepeatingInvoices', 'NEW_CLIENT1_XEROBLUE_RepeatingInvoicesSTAGE'
GO


--XEROBLUE_TrackingCategories - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategories', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategories
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategories
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategories 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_TrackingCategories 
		SELECT 
			Id = CONCAT(ROW_NUMBER() over(partition by TrackingCategoryId order by TrackingOptionId), '|', TrackingCategoryId)
			,TrackingCategoryId
			,Name
			,Status
			,TrackingOptionId
			,OptionName
			,OptionStatus
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoriesSTAGE
		WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_TrackingCategories', 'NEW_CLIENT1_XEROBLUE_TrackingCategoriesSTAGE'
GO


--XEROBLUE_TrialBalance - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_TrialBalance', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_TrialBalance
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_TrialBalance
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE trg
        FROM dbo.NEW_CLIENT1_XEROBLUE_TrialBalance trg
		JOIN dbo.NEW_CLIENT1_XEROBLUE_TrialBalanceSTAGE stg
			ON trg.Date = stg.Date
			AND trg.Title = stg.Title
			AND trg.Account = stg.Account
			AND trg.OrganisationId = stg.OrganisationId
		WHERE trg.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_TrialBalance 
		([ID], [Date], [Title], [Account], [Debit], [Credit], [YTDDebit], [YTDCredit], [AccountId], [ClientID], [OrganisationID])
		SELECT
			[ID] = ROW_NUMBER() OVER(ORDER BY [Date],[AccountId])
			,[Date]
			,[Title]
			,[Account]
			,[Debit]
			,[Credit]
			,[YTDDebit]
			,[YTDCredit]
			,[AccountId]
			,[ClientID]
			,[OrganisationID]
		FROM dbo.NEW_CLIENT1_XEROBLUE_TrialBalanceSTAGE
		WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_TrialBalance', 'NEW_CLIENT1_XEROBLUE_TrialBalanceSTAGE'
GO


--XEROBLUE_Users - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Users', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Users
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Users
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Users 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Users 
		select * from dbo.NEW_CLIENT1_XEROBLUE_UsersSTAGE
		WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Users', 'NEW_CLIENT1_XEROBLUE_UsersSTAGE'
GO


--XEROBLUE_ProfitandLoss - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ProfitandLoss', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ProfitandLoss
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ProfitandLoss
     @OrganisationID AS int 
AS  

	BEGIN TRANSACTION;  

        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_ProfitandLoss 
        WHERE OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ProfitandLoss 
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_ProfitandLossSTAGE
        WHERE OrganisationId = @OrganisationID;

        DELETE dbo.NEW_CLIENT1_XEROBLUE_ProfitandLossPivot
        WHERE [OrganisationID] = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ProfitandLossPivot
        SELECT
            Details."ID" AS "ID",
            Details."Title" AS "Title",
            Details."Label1"  AS "Account Name",
            Details."Amount"  AS "Amount",
            Months."Month"  AS "Month",
            Details."AccountId"  AS "Account ID",
            Details."ClientID" AS "Client ID",
            Details."OrganisationID" AS "Organisation ID"
        FROM (
            SELECT ID, Title, Label1, Amount, "Label", AccountId, ClientID, OrganisationID
            FROM (
                SELECT 
                    *
                FROM dbo.NEW_CLIENT1_XEROBLUE_ProfitandLoss 
                WHERE Label1 <> ''
                AND [OrganisationID] = @OrganisationID
            ) p
            UNPIVOT (
                Amount FOR "Label" IN
                (Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9,Label10,Label11,Label12,Label13)
            ) AS UNPVT ) Details
        INNER JOIN (
            SELECT ID, "Month", "Label", ClientID, OrganisationID
            FROM (
                SELECT 
                    *
                FROM dbo.NEW_CLIENT1_XEROBLUE_ProfitandLoss 
                WHERE Label1 = ''
                AND [OrganisationID] = @OrganisationID
            ) p
            UNPIVOT (
                "Month" FOR "Label" IN
                (Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9,Label10,Label11,Label12,Label13)
            ) AS UNPVT ) Months 
        ON Months."Label" = Details."Label" AND Months.OrganisationID = Details.OrganisationID

    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ProfitandLoss', 'NEW_CLIENT1_XEROBLUE_ProfitandLossSTAGE'
GO


--XEROBLUE_BankTransactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransactions', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransactions
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BankTransactions
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#BankTransactions') IS NOT NULL
	BEGIN
		DROP TABLE #BankTransactions
	END

	SELECT 
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY BankTransactionId ORDER BY BankTransactionId),'|',BankTransactionId)
        ,BankTransactionId
        ,Type
        ,Contact_ContactName
        ,Contact_ContactId
        ,BankAccount_AccountId
        ,BankAccount_AccountName
        ,BankAccount_Code
        ,LineItem_LineItemId = jLineItem_LineItemId
        ,LineItem_Description = jLineItem_Description
        ,LineItem_Quantity = jLineItem_Quantity
        ,LineItem_UnitAmount = jLineItem_UnitAmount
        ,LineItem_AccountCode = jLineItem_AccountCode
        ,LineItem_TaxType = jLineItem_TaxType
        ,LineItem_TaxAmount = jLineItem_TaxAmount
        ,LineItem_LineAmount = jLineItem_LineAmount
        ,LineItem_ItemCode = jLineItem_ItemCode
        ,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
        ,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
        ,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
        ,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
        ,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
        ,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
        ,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
        ,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
        ,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
        ,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
        ,LineItemAggregate = NULL
        ,IsReconciled
        ,Date
        ,Reference
        ,CurrencyRate
        ,URL
        ,Status
        ,LineAmountTypes
        ,SubTotal
        ,TotalTax
        ,Total
        ,PrepaymentId
        ,OverpaymentId
        ,UpdatedDateUTC
        ,FullyPaidOnDate
        ,CurrencyCode
        ,HasAttachments
        ,ClientID
        ,OrganisationID
        ,[LineItem_UnitAmount_AUD]
        ,[LineItem_UnitAmount_USD]
        ,[LineItem_UnitAmount_NZD]
        ,[LineItem_UnitAmount_EUR]
        ,[LineItem_UnitAmount_GBP]
        ,[LineItem_TaxAmount_AUD]
        ,[LineItem_TaxAmount_USD]
        ,[LineItem_TaxAmount_NZD]
        ,[LineItem_TaxAmount_EUR]
        ,[LineItem_TaxAmount_GBP]
        ,[LineItem_LineAmount_AUD]
        ,[LineItem_LineAmount_USD]
        ,[LineItem_LineAmount_NZD]
        ,[LineItem_LineAmount_EUR]
        ,[LineItem_LineAmount_GBP]
        ,[SubTotal_AUD]
        ,[SubTotal_USD]
        ,[SubTotal_NZD]
        ,[SubTotal_EUR]
        ,[SubTotal_GBP]
        ,[TotalTax_AUD]
        ,[TotalTax_USD]
        ,[TotalTax_NZD]
        ,[TotalTax_EUR]
        ,[TotalTax_GBP]
        ,[Total_AUD]
        ,[Total_USD]
        ,[Total_NZD]
        ,[Total_EUR]
        ,[Total_GBP]
        ,[ConditionalType]
        ,[Account_UID]
        ,[BankTansactionCashflowCalculation]
        ,[BankTansactionCashflowCalculation_AUD]
        ,[BankTansactionCashflowCalculation_USD]
        ,[BankTansactionCashflowCalculation_NZD]
        ,[BankTansactionCashflowCalculation_EUR]
        ,[BankTansactionCashflowCalculation_GBP]
        ,[LineAmountCalculatedIncTax]
        ,[LineAmountCalculatedIncTax_AUD]
        ,[LineAmountCalculatedIncTax_USD]
        ,[LineAmountCalculatedIncTax_NZD]
        ,[LineAmountCalculatedIncTax_EUR]
        ,[LineAmountCalculatedIncTax_GBP]
        ,[PaymentAmount]
        ,[PaymentAmount_AUD]
        ,[PaymentAmount_USD]
        ,[PaymentAmount_NZD]
        ,[PaymentAmount_EUR]
        ,[PaymentAmount_GBP]
	INTO #BankTransactions
	FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE stg
    CROSS APPLY OPENJSON(LineItemAggregate)
    WITH(
			jLineItem_LineItemId NVARCHAR(100) '$.LineItemID'
			,jLineItem_Description NVARCHAR(4000) '$.Description'
			,jLineItem_Quantity FLOAT '$.Quantity'
			,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
			,jLineItem_AccountCode NVARCHAR(100) '$.AccountCode'
			,jLineItem_TaxType NVARCHAR(100) '$.TaxType'
			,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
			,jLineItem_ItemCode NVARCHAR(100) '$.ItemCode'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.Tracking[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.Tracking[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.Tracking[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.Tracking[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.Tracking[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.Tracking[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.Tracking[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.Tracking[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.Tracking[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.Tracking[1].Status'
        )
    WHERE OrganisationId = @OrganisationID
	INSERT INTO #BankTransactions
	SELECT 
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY BankTransactionId ORDER BY BankTransactionId),'|',BankTransactionId)
        ,BankTransactionId
        ,Type
        ,Contact_ContactName
        ,Contact_ContactId
        ,BankAccount_AccountId
        ,BankAccount_AccountName
        ,BankAccount_Code
        ,LineItem_LineItemId
        ,LineItem_Description
        ,LineItem_Quantity
        ,LineItem_UnitAmount
        ,LineItem_AccountCode
        ,LineItem_TaxType
        ,LineItem_TaxAmount
        ,LineItem_LineAmount
        ,LineItem_ItemCode
        ,LineItem_TrackingCategory1_CategoryId
        ,LineItem_TrackingCategory1_CategoryName
        ,LineItem_TrackingCategory1_OptionId
        ,LineItem_TrackingCategory1_OptionName
        ,LineItem_TrackingCategory1_Option_Stat
        ,LineItem_TrackingCategory2_CategoryId
        ,LineItem_TrackingCategory2_CategoryName
        ,LineItem_TrackingCategory2_OptionId
        ,LineItem_TrackingCategory2_OptionName
        ,LineItem_TrackingCategory2_Option_Stat
        ,LineItemAggregate = NULL
        ,IsReconciled
        ,Date
        ,Reference
        ,CurrencyRate
        ,URL
        ,Status
        ,LineAmountTypes
        ,SubTotal
        ,TotalTax
        ,Total
        ,PrepaymentId
        ,OverpaymentId
        ,UpdatedDateUTC
        ,FullyPaidOnDate
        ,CurrencyCode
        ,HasAttachments
        ,ClientID
        ,OrganisationID
        ,[LineItem_UnitAmount_AUD]
        ,[LineItem_UnitAmount_USD]
        ,[LineItem_UnitAmount_NZD]
        ,[LineItem_UnitAmount_EUR]
        ,[LineItem_UnitAmount_GBP]
        ,[LineItem_TaxAmount_AUD]
        ,[LineItem_TaxAmount_USD]
        ,[LineItem_TaxAmount_NZD]
        ,[LineItem_TaxAmount_EUR]
        ,[LineItem_TaxAmount_GBP]
        ,[LineItem_LineAmount_AUD]
        ,[LineItem_LineAmount_USD]
        ,[LineItem_LineAmount_NZD]
        ,[LineItem_LineAmount_EUR]
        ,[LineItem_LineAmount_GBP]
        ,[SubTotal_AUD]
        ,[SubTotal_USD]
        ,[SubTotal_NZD]
        ,[SubTotal_EUR]
        ,[SubTotal_GBP]
        ,[TotalTax_AUD]
        ,[TotalTax_USD]
        ,[TotalTax_NZD]
        ,[TotalTax_EUR]
        ,[TotalTax_GBP]
        ,[Total_AUD]
        ,[Total_USD]
        ,[Total_NZD]
        ,[Total_EUR]
        ,[Total_GBP]
        ,[ConditionalType]
        ,[Account_UID]
        ,[BankTansactionCashflowCalculation]
        ,[BankTansactionCashflowCalculation_AUD]
        ,[BankTansactionCashflowCalculation_USD]
        ,[BankTansactionCashflowCalculation_NZD]
        ,[BankTansactionCashflowCalculation_EUR]
        ,[BankTansactionCashflowCalculation_GBP]
        ,[LineAmountCalculatedIncTax]
        ,[LineAmountCalculatedIncTax_AUD]
        ,[LineAmountCalculatedIncTax_USD]
        ,[LineAmountCalculatedIncTax_NZD]
        ,[LineAmountCalculatedIncTax_EUR]
        ,[LineAmountCalculatedIncTax_GBP]
        ,[PaymentAmount]
        ,[PaymentAmount_AUD]
        ,[PaymentAmount_USD]
        ,[PaymentAmount_NZD]
        ,[PaymentAmount_EUR]
        ,[PaymentAmount_GBP]
	FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE stg
    WHERE OrganisationId = @OrganisationID AND LineItemAggregate = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE WHERE OrganisationId = @OrganisationID
	INSERT INTO NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE
	SELECT * FROM #BankTransactions

    UPDATE NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE
    SET
        [ConditionalType] = CAST(
                CASE 
                WHEN Type = 'SPEND' THEN 'SPEND'
                WHEN Type = 'RECEIVE'THEN 'RECEIVE' 
                WHEN Type = 'SPEND-OVERPAYMENT' THEN 'SPEND'
                WHEN Type = 'RECEIVE-OVERPAYMENT' THEN 'RECEIVE'
                WHEN Type = 'SPEND-PREPAYMENT' THEN 'SPEND'
                WHEN Type = 'RECEIVE-PREPAYMENT' THEN 'RECEIVE' 
                WHEN Type = 'SPEND-TRANSFER' THEN 'NOTINCLUDED' 
                WHEN Type = 'RECEIVE-TRANSFER' THEN 'NOTINCLUDED'
                ELSE 'UNKNOWN' END AS VARCHAR
            ),
        [Account_UID] = ISNULL(LineItem_AccountCode, 'BLANK') + '-' + CAST(OrganisationID AS varchar)
    WHERE OrganisationId = @OrganisationID

    UPDATE NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE
    SET
    	[BankTansactionCashflowCalculation] = CAST(
                CASE 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Exclusive' THEN 0-([LineItem_LineAmount])  
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Exclusive' THEN ([LineItem_LineAmount]) 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'NoTax' THEN 0-([LineItem_LineAmount])  
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'NoTax' THEN ([LineItem_LineAmount]) 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Inclusive' THEN 0-([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Inclusive' THEN ([LineItem_LineAmount]-[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),  
        [LineAmountCalculatedIncTax] = CAST(
                CASE 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Exclusive' THEN 0-([LineItem_LineAmount]+[LineItem_TaxAmount]) 
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Exclusive' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount]) 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'NoTax' THEN 0-([LineItem_LineAmount]) 
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'NoTax' THEN ([LineItem_LineAmount])
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Inclusive' THEN 0-([LineItem_LineAmount]) 
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Inclusive' THEN ([LineItem_LineAmount])
                ELSE 0 END AS decimal(15,4)
            ),  		
        [PaymentAmount] = CAST(
                CASE 
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Exclusive' THEN 0-([LineItem_LineAmount])
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Exclusive' THEN ([LineItem_LineAmount])
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'NoTax' THEN 0-([LineItem_LineAmount])
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'NoTax' THEN ([LineItem_LineAmount])
                WHEN [ConditionalType] = 'SPEND' AND [LineAmountTypes] = 'Inclusive' THEN 0-([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN [ConditionalType] = 'RECEIVE' AND [LineAmountTypes] = 'Inclusive' THEN ([LineItem_LineAmount]-[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            )
    WHERE OrganisationId = @OrganisationID

	UPDATE bnktrnsxn
	SET  [LineItem_UnitAmount_AUD] = bnktrnsxn.[LineItem_UnitAmount] * fx.[AUD]
        ,[LineItem_UnitAmount_USD] = bnktrnsxn.[LineItem_UnitAmount] * fx.[USD]
        ,[LineItem_UnitAmount_NZD] = bnktrnsxn.[LineItem_UnitAmount] * fx.[NZD]
        ,[LineItem_UnitAmount_EUR] = bnktrnsxn.[LineItem_UnitAmount] * fx.[EUR]
        ,[LineItem_UnitAmount_GBP] = bnktrnsxn.[LineItem_UnitAmount] * fx.[GBP]
        ,[LineItem_TaxAmount_AUD] = bnktrnsxn.[LineItem_TaxAmount] * fx.[AUD]
        ,[LineItem_TaxAmount_USD] = bnktrnsxn.[LineItem_TaxAmount] * fx.[USD]
        ,[LineItem_TaxAmount_NZD] = bnktrnsxn.[LineItem_TaxAmount] * fx.[NZD]
        ,[LineItem_TaxAmount_EUR] = bnktrnsxn.[LineItem_TaxAmount] * fx.[EUR]
        ,[LineItem_TaxAmount_GBP] = bnktrnsxn.[LineItem_TaxAmount] * fx.[GBP]
        ,[LineItem_LineAmount_AUD] = bnktrnsxn.[LineItem_LineAmount] * fx.[AUD]
        ,[LineItem_LineAmount_USD] = bnktrnsxn.[LineItem_LineAmount] * fx.[USD]
        ,[LineItem_LineAmount_NZD] = bnktrnsxn.[LineItem_LineAmount] * fx.[NZD]
        ,[LineItem_LineAmount_EUR] = bnktrnsxn.[LineItem_LineAmount] * fx.[EUR]
        ,[LineItem_LineAmount_GBP] = bnktrnsxn.[LineItem_LineAmount] * fx.[GBP]
        ,[SubTotal_AUD] = bnktrnsxn.[SubTotal] * fx.[AUD]
        ,[SubTotal_USD] = bnktrnsxn.[SubTotal] * fx.[USD]
        ,[SubTotal_NZD] = bnktrnsxn.[SubTotal] * fx.[NZD]
        ,[SubTotal_EUR] = bnktrnsxn.[SubTotal] * fx.[EUR]
        ,[SubTotal_GBP] = bnktrnsxn.[SubTotal] * fx.[GBP]
        ,[TotalTax_AUD] = bnktrnsxn.[TotalTax] * fx.[AUD]
        ,[TotalTax_USD] = bnktrnsxn.[TotalTax] * fx.[USD]
        ,[TotalTax_NZD] = bnktrnsxn.[TotalTax] * fx.[NZD]
        ,[TotalTax_EUR] = bnktrnsxn.[TotalTax] * fx.[EUR]
        ,[TotalTax_GBP] = bnktrnsxn.[TotalTax] * fx.[GBP]
        ,[Total_AUD] = bnktrnsxn.[Total] * fx.[AUD]
        ,[Total_USD] = bnktrnsxn.[Total] * fx.[USD]
        ,[Total_NZD] = bnktrnsxn.[Total] * fx.[NZD]
        ,[Total_EUR] = bnktrnsxn.[Total] * fx.[EUR]
        ,[Total_GBP] = bnktrnsxn.[Total] * fx.[GBP]
        ,[BankTansactionCashflowCalculation_AUD] = [BankTansactionCashflowCalculation] * fx.[AUD]
        ,[BankTansactionCashflowCalculation_USD] = [BankTansactionCashflowCalculation] * fx.[USD]
        ,[BankTansactionCashflowCalculation_NZD] = [BankTansactionCashflowCalculation] * fx.[NZD]
        ,[BankTansactionCashflowCalculation_EUR] = [BankTansactionCashflowCalculation] * fx.[EUR]
        ,[BankTansactionCashflowCalculation_GBP] = [BankTansactionCashflowCalculation] * fx.[GBP]
        ,[LineAmountCalculatedIncTax_AUD] = [LineAmountCalculatedIncTax] * fx.[AUD]
        ,[LineAmountCalculatedIncTax_USD] = [LineAmountCalculatedIncTax] * fx.[USD]
        ,[LineAmountCalculatedIncTax_NZD] = [LineAmountCalculatedIncTax] * fx.[NZD]
        ,[LineAmountCalculatedIncTax_EUR] = [LineAmountCalculatedIncTax] * fx.[EUR]
        ,[LineAmountCalculatedIncTax_GBP] = [LineAmountCalculatedIncTax] * fx.[GBP]
        ,[PaymentAmount_AUD] = [PaymentAmount] * fx.[AUD]
        ,[PaymentAmount_USD] = [PaymentAmount] * fx.[USD]
        ,[PaymentAmount_NZD] = [PaymentAmount] * fx.[NZD]
        ,[PaymentAmount_EUR] = [PaymentAmount] * fx.[EUR]
        ,[PaymentAmount_GBP] = [PaymentAmount] * fx.[GBP]
	FROM NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE bnktrnsxn
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = bnktrnsxn.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN bnktrnsxn.[Date] <= @minDate THEN @minDate 
									WHEN bnktrnsxn.[Date] >= @maxDate THEN @maxDate
									ELSE bnktrnsxn.[Date] 
								END
	WHERE bnktrnsxn.OrganisationID = @OrganisationID;

    BEGIN TRANSACTION;
        DELETE TRG
        FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactions TRG
        INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE STG ON TRG.BankTransactionId = STG.BankTransactionId
        WHERE TRG.OrganisationId = @OrganisationID;

        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BankTransactions 
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE
        WHERE OrganisationId = @OrganisationID;
    COMMIT;

	IF OBJECT_ID('tempdb..#BankTransactions') IS NOT NULL
	BEGIN
		DROP TABLE #BankTransactions
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BankTransactions', 'NEW_CLIENT1_XEROBLUE_BankTransactionsSTAGE'
GO


--XEROBLUE_CreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_CreditNotes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_CreditNotes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_CreditNotes
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END

	IF OBJECT_ID('tempdb..#CreditNotes') IS NOT NULL
	BEGIN
		DROP TABLE #CreditNotes
	END

	SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
	INTO #FXTable
	FROM (
			SELECT
				BaseCurrency, Date, Currency, ExchangeRate
			FROM FOREIGNEXCHANGE_MASTER fx
			WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
			) AS SRC
			PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)
		) AS p
	
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY CreditNoteId ORDER BY CreditNoteId),'|',CreditNoteId)
		,CreditNoteId
		,CreditNoteNumber
		,Reference
		,Type
		,Contact_ContactId
		,Contact_Name
		,Date
		,Status
		,LineAmountTypes
		,LineItem_Description = jLineItem_Description
		,LineItem_Quantity = jLineItem_Quantity
		,LineItem_UnitAmount = jLineItem_UnitAmount
		,LineItem_ItemCode = jLineItem_ItemCode
		,LineItem_AccountCode = jLineItem_AccountCode
		,LineItem_TaxType = jLineItem_TaxType
		,LineItem_TaxAmount = jLineItem_TaxAmount
		,LineItem_LineAmount = jLineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate = jLineItem_DiscountRate
		,LineItemAggregate = NULL
		,SubTotal
		,TotalTax
		,Total
		,UpdatedDateUTC
		,CurrencyCode
		,FullyPaidOnDate
		,SentToContact
		,BrandingThemeId
		,CurrencyRate
		,RemainingCredit
		,Allocation1_AppliedAmount
		,Allocation1_Date
		,Allocation1_InvoiceId
		,Allocation1_InvoiceNumber
		,Allocation2_AppliedAmount
		,Allocation2_Date
		,Allocation2_InvoiceId
		,Allocation2_InvoiceNumber
		,Allocation3_AppliedAmount
		,Allocation3_Date
		,Allocation3_InvoiceId
		,Allocation3_InvoiceNumber
		,Allocation4_AppliedAmount
		,Allocation4_Date
		,Allocation4_InvoiceId
		,Allocation4_InvoiceNumber
		,Allocation5_AppliedAmount
		,Allocation5_Date
		,Allocation5_InvoiceId
		,Allocation5_InvoiceNumber
		,Allocation6_AppliedAmount
		,Allocation6_Date
		,Allocation6_InvoiceId
		,Allocation6_InvoiceNumber
		,Allocation7_AppliedAmount
		,Allocation7_Date
		,Allocation7_InvoiceId
		,Allocation7_InvoiceNumber
		,Allocation8_AppliedAmount
		,Allocation8_Date
		,Allocation8_InvoiceId
		,Allocation8_InvoiceNumber
		,Allocation9_AppliedAmount
		,Allocation9_Date
		,Allocation9_InvoiceId
		,Allocation9_InvoiceNumber
		,Allocation10_AppliedAmount
		,Allocation10_Date
		,Allocation10_InvoiceId
		,Allocation10_InvoiceNumber
		,Allocation11_AppliedAmount
		,Allocation11_Date
		,Allocation11_InvoiceId
		,Allocation11_InvoiceNumber
		,Allocation12_AppliedAmount
		,Allocation12_Date
		,Allocation12_InvoiceId
		,Allocation12_InvoiceNumber
		,Allocation13_AppliedAmount
		,Allocation13_Date
		,Allocation13_InvoiceId
		,Allocation13_InvoiceNumber
		,Allocation14_AppliedAmount
		,Allocation14_Date
		,Allocation14_InvoiceId
		,Allocation14_InvoiceNumber
		,Allocation15_AppliedAmount
		,Allocation15_Date
		,Allocation15_InvoiceId
		,Allocation15_InvoiceNumber
		,HasAttachments
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[RemainingCredit_AUD]
		,[RemainingCredit_USD]
		,[RemainingCredit_NZD]
		,[RemainingCredit_EUR]
		,[RemainingCredit_GBP]
		,[Allocation1_AppliedAmount_AUD]
		,[Allocation1_AppliedAmount_USD]
		,[Allocation1_AppliedAmount_NZD]
		,[Allocation1_AppliedAmount_EUR]
		,[Allocation1_AppliedAmount_GBP]
		,[Allocation2_AppliedAmount_AUD]
		,[Allocation2_AppliedAmount_USD]
		,[Allocation2_AppliedAmount_NZD]
		,[Allocation2_AppliedAmount_EUR]
		,[Allocation2_AppliedAmount_GBP]
		,[Allocation3_AppliedAmount_AUD]
		,[Allocation3_AppliedAmount_USD]
		,[Allocation3_AppliedAmount_NZD]
		,[Allocation3_AppliedAmount_EUR]
		,[Allocation3_AppliedAmount_GBP]
		,[Allocation4_AppliedAmount_AUD]
		,[Allocation4_AppliedAmount_USD]
		,[Allocation4_AppliedAmount_NZD]
		,[Allocation4_AppliedAmount_EUR]
		,[Allocation4_AppliedAmount_GBP]
		,[Allocation5_AppliedAmount_AUD]
		,[Allocation5_AppliedAmount_USD]
		,[Allocation5_AppliedAmount_NZD]
		,[Allocation5_AppliedAmount_EUR]
		,[Allocation5_AppliedAmount_GBP]
		,[Allocation6_AppliedAmount_AUD]
		,[Allocation6_AppliedAmount_USD]
		,[Allocation6_AppliedAmount_NZD]
		,[Allocation6_AppliedAmount_EUR]
		,[Allocation6_AppliedAmount_GBP]
		,[Allocation7_AppliedAmount_AUD]
		,[Allocation7_AppliedAmount_USD]
		,[Allocation7_AppliedAmount_NZD]
		,[Allocation7_AppliedAmount_EUR]
		,[Allocation7_AppliedAmount_GBP]
		,[Allocation8_AppliedAmount_AUD]
		,[Allocation8_AppliedAmount_USD]
		,[Allocation8_AppliedAmount_NZD]
		,[Allocation8_AppliedAmount_EUR]
		,[Allocation8_AppliedAmount_GBP]
		,[Allocation9_AppliedAmount_AUD]
		,[Allocation9_AppliedAmount_USD]
		,[Allocation9_AppliedAmount_NZD]
		,[Allocation9_AppliedAmount_EUR]
		,[Allocation9_AppliedAmount_GBP]
		,[Allocation10_AppliedAmount_AUD]
		,[Allocation10_AppliedAmount_USD]
		,[Allocation10_AppliedAmount_NZD]
		,[Allocation10_AppliedAmount_EUR]
		,[Allocation10_AppliedAmount_GBP]
		,[Allocation11_AppliedAmount_AUD]
		,[Allocation11_AppliedAmount_USD]
		,[Allocation11_AppliedAmount_NZD]
		,[Allocation11_AppliedAmount_EUR]
		,[Allocation11_AppliedAmount_GBP]
		,[Allocation12_AppliedAmount_AUD]
		,[Allocation12_AppliedAmount_USD]
		,[Allocation12_AppliedAmount_NZD]
		,[Allocation12_AppliedAmount_EUR]
		,[Allocation12_AppliedAmount_GBP]
		,[Allocation13_AppliedAmount_AUD]
		,[Allocation13_AppliedAmount_USD]
		,[Allocation13_AppliedAmount_NZD]
		,[Allocation13_AppliedAmount_EUR]
		,[Allocation13_AppliedAmount_GBP]
		,[Allocation14_AppliedAmount_AUD]
		,[Allocation14_AppliedAmount_USD]
		,[Allocation14_AppliedAmount_NZD]
		,[Allocation14_AppliedAmount_EUR]
		,[Allocation14_AppliedAmount_GBP]
		,[Allocation15_AppliedAmount_AUD]
		,[Allocation15_AppliedAmount_USD]
		,[Allocation15_AppliedAmount_NZD]
		,[Allocation15_AppliedAmount_EUR]
		,[Allocation15_AppliedAmount_GBP]
        ,[AccountUID]
        ,[LineAmountCreditNoteCalculation]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[LineAmountCreditNoteCalculation_AUD]
        ,[LineAmountCreditNoteCalculation_USD]
        ,[LineAmountCreditNoteCalculation_NZD]
        ,[LineAmountCreditNoteCalculation_EUR]
        ,[LineAmountCreditNoteCalculation_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
	INTO #CreditNotes
	FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE
	CROSS APPLY OPENJSON(LineItemAggregate)
	WITH(
			 jLineItem_Description NVARCHAR(4000) '$.Description'
			,jLineItem_Quantity FLOAT '$.Quantity'
			,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
			,jLineItem_ItemCode NVARCHAR(100) '$.ItemCode'
			,jLineItem_AccountCode NVARCHAR(100) '$.AccountCode'
			,jLineItem_TaxType NVARCHAR(100) '$.TaxType'
			,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.Tracking[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.Tracking[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.Tracking[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.Tracking[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.Tracking[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.Tracking[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.Tracking[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.Tracking[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.Tracking[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.Tracking[1].Status'
			,jLineItem_DiscountRate FLOAT '$.DiscountRate'
		)
	WHERE OrganisationId = @OrganisationID
	INSERT INTO #CreditNotes
	SELECT
		Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY CreditNoteId ORDER BY CreditNoteId),'|',CreditNoteId)
		,CreditNoteId
		,CreditNoteNumber
		,Reference
		,Type
		,Contact_ContactId
		,Contact_Name
		,Date
		,Status
		,LineAmountTypes
		,LineItem_Description
		,LineItem_Quantity
		,LineItem_UnitAmount
		,LineItem_ItemCode
		,LineItem_AccountCode
		,LineItem_TaxType
		,LineItem_TaxAmount
		,LineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate
		,LineItemAggregate = NULL
		,SubTotal
		,TotalTax
		,Total
		,UpdatedDateUTC
		,CurrencyCode
		,FullyPaidOnDate
		,SentToContact
		,BrandingThemeId
		,CurrencyRate
		,RemainingCredit
		,Allocation1_AppliedAmount
		,Allocation1_Date
		,Allocation1_InvoiceId
		,Allocation1_InvoiceNumber
		,Allocation2_AppliedAmount
		,Allocation2_Date
		,Allocation2_InvoiceId
		,Allocation2_InvoiceNumber
		,Allocation3_AppliedAmount
		,Allocation3_Date
		,Allocation3_InvoiceId
		,Allocation3_InvoiceNumber
		,Allocation4_AppliedAmount
		,Allocation4_Date
		,Allocation4_InvoiceId
		,Allocation4_InvoiceNumber
		,Allocation5_AppliedAmount
		,Allocation5_Date
		,Allocation5_InvoiceId
		,Allocation5_InvoiceNumber
		,Allocation6_AppliedAmount
		,Allocation6_Date
		,Allocation6_InvoiceId
		,Allocation6_InvoiceNumber
		,Allocation7_AppliedAmount
		,Allocation7_Date
		,Allocation7_InvoiceId
		,Allocation7_InvoiceNumber
		,Allocation8_AppliedAmount
		,Allocation8_Date
		,Allocation8_InvoiceId
		,Allocation8_InvoiceNumber
		,Allocation9_AppliedAmount
		,Allocation9_Date
		,Allocation9_InvoiceId
		,Allocation9_InvoiceNumber
		,Allocation10_AppliedAmount
		,Allocation10_Date
		,Allocation10_InvoiceId
		,Allocation10_InvoiceNumber
		,Allocation11_AppliedAmount
		,Allocation11_Date
		,Allocation11_InvoiceId
		,Allocation11_InvoiceNumber
		,Allocation12_AppliedAmount
		,Allocation12_Date
		,Allocation12_InvoiceId
		,Allocation12_InvoiceNumber
		,Allocation13_AppliedAmount
		,Allocation13_Date
		,Allocation13_InvoiceId
		,Allocation13_InvoiceNumber
		,Allocation14_AppliedAmount
		,Allocation14_Date
		,Allocation14_InvoiceId
		,Allocation14_InvoiceNumber
		,Allocation15_AppliedAmount
		,Allocation15_Date
		,Allocation15_InvoiceId
		,Allocation15_InvoiceNumber
		,HasAttachments
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[RemainingCredit_AUD]
		,[RemainingCredit_USD]
		,[RemainingCredit_NZD]
		,[RemainingCredit_EUR]
		,[RemainingCredit_GBP]
		,[Allocation1_AppliedAmount_AUD]
		,[Allocation1_AppliedAmount_USD]
		,[Allocation1_AppliedAmount_NZD]
		,[Allocation1_AppliedAmount_EUR]
		,[Allocation1_AppliedAmount_GBP]
		,[Allocation2_AppliedAmount_AUD]
		,[Allocation2_AppliedAmount_USD]
		,[Allocation2_AppliedAmount_NZD]
		,[Allocation2_AppliedAmount_EUR]
		,[Allocation2_AppliedAmount_GBP]
		,[Allocation3_AppliedAmount_AUD]
		,[Allocation3_AppliedAmount_USD]
		,[Allocation3_AppliedAmount_NZD]
		,[Allocation3_AppliedAmount_EUR]
		,[Allocation3_AppliedAmount_GBP]
		,[Allocation4_AppliedAmount_AUD]
		,[Allocation4_AppliedAmount_USD]
		,[Allocation4_AppliedAmount_NZD]
		,[Allocation4_AppliedAmount_EUR]
		,[Allocation4_AppliedAmount_GBP]
		,[Allocation5_AppliedAmount_AUD]
		,[Allocation5_AppliedAmount_USD]
		,[Allocation5_AppliedAmount_NZD]
		,[Allocation5_AppliedAmount_EUR]
		,[Allocation5_AppliedAmount_GBP]
		,[Allocation6_AppliedAmount_AUD]
		,[Allocation6_AppliedAmount_USD]
		,[Allocation6_AppliedAmount_NZD]
		,[Allocation6_AppliedAmount_EUR]
		,[Allocation6_AppliedAmount_GBP]
		,[Allocation7_AppliedAmount_AUD]
		,[Allocation7_AppliedAmount_USD]
		,[Allocation7_AppliedAmount_NZD]
		,[Allocation7_AppliedAmount_EUR]
		,[Allocation7_AppliedAmount_GBP]
		,[Allocation8_AppliedAmount_AUD]
		,[Allocation8_AppliedAmount_USD]
		,[Allocation8_AppliedAmount_NZD]
		,[Allocation8_AppliedAmount_EUR]
		,[Allocation8_AppliedAmount_GBP]
		,[Allocation9_AppliedAmount_AUD]
		,[Allocation9_AppliedAmount_USD]
		,[Allocation9_AppliedAmount_NZD]
		,[Allocation9_AppliedAmount_EUR]
		,[Allocation9_AppliedAmount_GBP]
		,[Allocation10_AppliedAmount_AUD]
		,[Allocation10_AppliedAmount_USD]
		,[Allocation10_AppliedAmount_NZD]
		,[Allocation10_AppliedAmount_EUR]
		,[Allocation10_AppliedAmount_GBP]
		,[Allocation11_AppliedAmount_AUD]
		,[Allocation11_AppliedAmount_USD]
		,[Allocation11_AppliedAmount_NZD]
		,[Allocation11_AppliedAmount_EUR]
		,[Allocation11_AppliedAmount_GBP]
		,[Allocation12_AppliedAmount_AUD]
		,[Allocation12_AppliedAmount_USD]
		,[Allocation12_AppliedAmount_NZD]
		,[Allocation12_AppliedAmount_EUR]
		,[Allocation12_AppliedAmount_GBP]
		,[Allocation13_AppliedAmount_AUD]
		,[Allocation13_AppliedAmount_USD]
		,[Allocation13_AppliedAmount_NZD]
		,[Allocation13_AppliedAmount_EUR]
		,[Allocation13_AppliedAmount_GBP]
		,[Allocation14_AppliedAmount_AUD]
		,[Allocation14_AppliedAmount_USD]
		,[Allocation14_AppliedAmount_NZD]
		,[Allocation14_AppliedAmount_EUR]
		,[Allocation14_AppliedAmount_GBP]
		,[Allocation15_AppliedAmount_AUD]
		,[Allocation15_AppliedAmount_USD]
		,[Allocation15_AppliedAmount_NZD]
		,[Allocation15_AppliedAmount_EUR]
		,[Allocation15_AppliedAmount_GBP]
        ,[AccountUID]
        ,[LineAmountCreditNoteCalculation]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[LineAmountCreditNoteCalculation_AUD]
        ,[LineAmountCreditNoteCalculation_USD]
        ,[LineAmountCreditNoteCalculation_NZD]
        ,[LineAmountCreditNoteCalculation_EUR]
        ,[LineAmountCreditNoteCalculation_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
	FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE 
    WHERE OrganisationId = @OrganisationID AND LineItemAggregate = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE WHERE OrganisationId = @OrganisationID
	INSERT INTO NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE
	SELECT * FROM #CreditNotes

    UPDATE NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE
    SET
         [AccountUID] = [LineItem_AccountCode] + '-' + CAST([OrganisationID] AS varchar)
        ,[LineAmountCreditNoteCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAYCREDIT' THEN 0-([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCRECCREDIT' THEN ([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCPAYCREDIT' THEN 0-([LineItem_LineAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCRECCREDIT' THEN ([LineItem_LineAmount])
                ELSE 0 END AS decimal(15,4)
            )
        ,[LineAmountTradeCreditorCalculation] =	CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAYCREDIT' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCPAYCREDIT' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCPAYCREDIT' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            )
        ,[LineAmountTradeDebtorCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCRECCREDIT' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCRECCREDIT' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCRECCREDIT' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            )	
    WHERE OrganisationId = @OrganisationID

	UPDATE crdt
	SET  [LineItem_UnitAmount_AUD] = crdt.[LineItem_UnitAmount] * fx.[AUD]
		,[LineItem_UnitAmount_USD] = crdt.[LineItem_UnitAmount] * fx.[USD]
		,[LineItem_UnitAmount_NZD] = crdt.[LineItem_UnitAmount] * fx.[NZD]
		,[LineItem_UnitAmount_EUR] = crdt.[LineItem_UnitAmount] * fx.[EUR]
		,[LineItem_UnitAmount_GBP] = crdt.[LineItem_UnitAmount] * fx.[GBP]
		,[LineItem_TaxAmount_AUD] = crdt.[LineItem_TaxAmount] * fx.[AUD]
		,[LineItem_TaxAmount_USD] = crdt.[LineItem_TaxAmount] * fx.[USD]
		,[LineItem_TaxAmount_NZD] = crdt.[LineItem_TaxAmount] * fx.[NZD]
		,[LineItem_TaxAmount_EUR] = crdt.[LineItem_TaxAmount] * fx.[EUR]
		,[LineItem_TaxAmount_GBP] = crdt.[LineItem_TaxAmount] * fx.[GBP]
		,[LineItem_LineAmount_AUD] = crdt.[LineItem_LineAmount] * fx.[AUD]
		,[LineItem_LineAmount_USD] = crdt.[LineItem_LineAmount] * fx.[USD]
		,[LineItem_LineAmount_NZD] = crdt.[LineItem_LineAmount] * fx.[NZD]
		,[LineItem_LineAmount_EUR] = crdt.[LineItem_LineAmount] * fx.[EUR]
		,[LineItem_LineAmount_GBP] = crdt.[LineItem_LineAmount] * fx.[GBP]
		,[SubTotal_AUD] = crdt.[SubTotal] * fx.[AUD]
		,[SubTotal_USD] = crdt.[SubTotal] * fx.[USD]
		,[SubTotal_NZD] = crdt.[SubTotal] * fx.[NZD]
		,[SubTotal_EUR] = crdt.[SubTotal] * fx.[EUR]
		,[SubTotal_GBP] = crdt.[SubTotal] * fx.[GBP]
		,[TotalTax_AUD] = crdt.[TotalTax] * fx.[AUD]
		,[TotalTax_USD] = crdt.[TotalTax] * fx.[USD]
		,[TotalTax_NZD] = crdt.[TotalTax] * fx.[NZD]
		,[TotalTax_EUR] = crdt.[TotalTax] * fx.[EUR]
		,[TotalTax_GBP] = crdt.[TotalTax] * fx.[GBP]
		,[Total_AUD] = crdt.[Total] * fx.[AUD]
		,[Total_USD] = crdt.[Total] * fx.[USD]
		,[Total_NZD] = crdt.[Total] * fx.[NZD]
		,[Total_EUR] = crdt.[Total] * fx.[EUR]
		,[Total_GBP] = crdt.[Total] * fx.[GBP]
		,[RemainingCredit_AUD] = crdt.[RemainingCredit] * fx.[AUD]
		,[RemainingCredit_USD] = crdt.[RemainingCredit] * fx.[USD]
		,[RemainingCredit_NZD] = crdt.[RemainingCredit] * fx.[NZD]
		,[RemainingCredit_EUR] = crdt.[RemainingCredit] * fx.[EUR]
		,[RemainingCredit_GBP] = crdt.[RemainingCredit] * fx.[GBP]
		,[Allocation1_AppliedAmount_AUD] = crdt.[Allocation1_AppliedAmount] * fx1.[AUD]
		,[Allocation1_AppliedAmount_USD] = crdt.[Allocation1_AppliedAmount] * fx1.[USD]
		,[Allocation1_AppliedAmount_NZD] = crdt.[Allocation1_AppliedAmount] * fx1.[NZD]
		,[Allocation1_AppliedAmount_EUR] = crdt.[Allocation1_AppliedAmount] * fx1.[EUR]
		,[Allocation1_AppliedAmount_GBP] = crdt.[Allocation1_AppliedAmount] * fx1.[GBP]
		,[Allocation2_AppliedAmount_AUD] = crdt.[Allocation2_AppliedAmount] * fx2.[AUD]
		,[Allocation2_AppliedAmount_USD] = crdt.[Allocation2_AppliedAmount] * fx2.[USD]
		,[Allocation2_AppliedAmount_NZD] = crdt.[Allocation2_AppliedAmount] * fx2.[NZD]
		,[Allocation2_AppliedAmount_EUR] = crdt.[Allocation2_AppliedAmount] * fx2.[EUR]
		,[Allocation2_AppliedAmount_GBP] = crdt.[Allocation2_AppliedAmount] * fx2.[GBP]
		,[Allocation3_AppliedAmount_AUD] = crdt.[Allocation3_AppliedAmount] * fx3.[AUD]
		,[Allocation3_AppliedAmount_USD] = crdt.[Allocation3_AppliedAmount] * fx3.[USD]
		,[Allocation3_AppliedAmount_NZD] = crdt.[Allocation3_AppliedAmount] * fx3.[NZD]
		,[Allocation3_AppliedAmount_EUR] = crdt.[Allocation3_AppliedAmount] * fx3.[EUR]
		,[Allocation3_AppliedAmount_GBP] = crdt.[Allocation3_AppliedAmount] * fx3.[GBP]
		,[Allocation4_AppliedAmount_AUD] = crdt.[Allocation4_AppliedAmount] * fx4.[AUD]
		,[Allocation4_AppliedAmount_USD] = crdt.[Allocation4_AppliedAmount] * fx4.[USD]
		,[Allocation4_AppliedAmount_NZD] = crdt.[Allocation4_AppliedAmount] * fx4.[NZD]
		,[Allocation4_AppliedAmount_EUR] = crdt.[Allocation4_AppliedAmount] * fx4.[EUR]
		,[Allocation4_AppliedAmount_GBP] = crdt.[Allocation4_AppliedAmount] * fx4.[GBP]
		,[Allocation5_AppliedAmount_AUD] = crdt.[Allocation5_AppliedAmount] * fx5.[AUD]
		,[Allocation5_AppliedAmount_USD] = crdt.[Allocation5_AppliedAmount] * fx5.[USD]
		,[Allocation5_AppliedAmount_NZD] = crdt.[Allocation5_AppliedAmount] * fx5.[NZD]
		,[Allocation5_AppliedAmount_EUR] = crdt.[Allocation5_AppliedAmount] * fx5.[EUR]
		,[Allocation5_AppliedAmount_GBP] = crdt.[Allocation5_AppliedAmount] * fx5.[GBP]
		,[Allocation6_AppliedAmount_AUD] = crdt.[Allocation6_AppliedAmount] * fx6.[AUD]
		,[Allocation6_AppliedAmount_USD] = crdt.[Allocation6_AppliedAmount] * fx6.[USD]
		,[Allocation6_AppliedAmount_NZD] = crdt.[Allocation6_AppliedAmount] * fx6.[NZD]
		,[Allocation6_AppliedAmount_EUR] = crdt.[Allocation6_AppliedAmount] * fx6.[EUR]
		,[Allocation6_AppliedAmount_GBP] = crdt.[Allocation6_AppliedAmount] * fx6.[GBP]
		,[Allocation7_AppliedAmount_AUD] = crdt.[Allocation7_AppliedAmount] * fx7.[AUD]
		,[Allocation7_AppliedAmount_USD] = crdt.[Allocation7_AppliedAmount] * fx7.[USD]
		,[Allocation7_AppliedAmount_NZD] = crdt.[Allocation7_AppliedAmount] * fx7.[NZD]
		,[Allocation7_AppliedAmount_EUR] = crdt.[Allocation7_AppliedAmount] * fx7.[EUR]
		,[Allocation7_AppliedAmount_GBP] = crdt.[Allocation7_AppliedAmount] * fx7.[GBP]
		,[Allocation8_AppliedAmount_AUD] = crdt.[Allocation8_AppliedAmount] * fx8.[AUD]
		,[Allocation8_AppliedAmount_USD] = crdt.[Allocation8_AppliedAmount] * fx8.[USD]
		,[Allocation8_AppliedAmount_NZD] = crdt.[Allocation8_AppliedAmount] * fx8.[NZD]
		,[Allocation8_AppliedAmount_EUR] = crdt.[Allocation8_AppliedAmount] * fx8.[EUR]
		,[Allocation8_AppliedAmount_GBP] = crdt.[Allocation8_AppliedAmount] * fx8.[GBP]
		,[Allocation9_AppliedAmount_AUD] = crdt.[Allocation9_AppliedAmount] * fx9.[AUD]
		,[Allocation9_AppliedAmount_USD] = crdt.[Allocation9_AppliedAmount] * fx9.[USD]
		,[Allocation9_AppliedAmount_NZD] = crdt.[Allocation9_AppliedAmount] * fx9.[NZD]
		,[Allocation9_AppliedAmount_EUR] = crdt.[Allocation9_AppliedAmount] * fx9.[EUR]
		,[Allocation9_AppliedAmount_GBP] = crdt.[Allocation9_AppliedAmount] * fx9.[GBP]
		,[Allocation10_AppliedAmount_AUD] = crdt.[Allocation10_AppliedAmount] * fx10.[AUD]
		,[Allocation10_AppliedAmount_USD] = crdt.[Allocation10_AppliedAmount] * fx10.[USD]
		,[Allocation10_AppliedAmount_NZD] = crdt.[Allocation10_AppliedAmount] * fx10.[NZD]
		,[Allocation10_AppliedAmount_EUR] = crdt.[Allocation10_AppliedAmount] * fx10.[EUR]
		,[Allocation10_AppliedAmount_GBP] = crdt.[Allocation10_AppliedAmount] * fx10.[GBP]
		,[Allocation11_AppliedAmount_AUD] = crdt.[Allocation11_AppliedAmount] * fx11.[AUD]
		,[Allocation11_AppliedAmount_USD] = crdt.[Allocation11_AppliedAmount] * fx11.[USD]
		,[Allocation11_AppliedAmount_NZD] = crdt.[Allocation11_AppliedAmount] * fx11.[NZD]
		,[Allocation11_AppliedAmount_EUR] = crdt.[Allocation11_AppliedAmount] * fx11.[EUR]
		,[Allocation11_AppliedAmount_GBP] = crdt.[Allocation11_AppliedAmount] * fx11.[GBP]
		,[Allocation12_AppliedAmount_AUD] = crdt.[Allocation12_AppliedAmount] * fx12.[AUD]
		,[Allocation12_AppliedAmount_USD] = crdt.[Allocation12_AppliedAmount] * fx12.[USD]
		,[Allocation12_AppliedAmount_NZD] = crdt.[Allocation12_AppliedAmount] * fx12.[NZD]
		,[Allocation12_AppliedAmount_EUR] = crdt.[Allocation12_AppliedAmount] * fx12.[EUR]
		,[Allocation12_AppliedAmount_GBP] = crdt.[Allocation12_AppliedAmount] * fx12.[GBP]
		,[Allocation13_AppliedAmount_AUD] = crdt.[Allocation13_AppliedAmount] * fx13.[AUD]
		,[Allocation13_AppliedAmount_USD] = crdt.[Allocation13_AppliedAmount] * fx13.[USD]
		,[Allocation13_AppliedAmount_NZD] = crdt.[Allocation13_AppliedAmount] * fx13.[NZD]
		,[Allocation13_AppliedAmount_EUR] = crdt.[Allocation13_AppliedAmount] * fx13.[EUR]
		,[Allocation13_AppliedAmount_GBP] = crdt.[Allocation13_AppliedAmount] * fx13.[GBP]
		,[Allocation14_AppliedAmount_AUD] = crdt.[Allocation14_AppliedAmount] * fx14.[AUD]
		,[Allocation14_AppliedAmount_USD] = crdt.[Allocation14_AppliedAmount] * fx14.[USD]
		,[Allocation14_AppliedAmount_NZD] = crdt.[Allocation14_AppliedAmount] * fx14.[NZD]
		,[Allocation14_AppliedAmount_EUR] = crdt.[Allocation14_AppliedAmount] * fx14.[EUR]
		,[Allocation14_AppliedAmount_GBP] = crdt.[Allocation14_AppliedAmount] * fx14.[GBP]
		,[Allocation15_AppliedAmount_AUD] = crdt.[Allocation15_AppliedAmount] * fx15.[AUD]
		,[Allocation15_AppliedAmount_USD] = crdt.[Allocation15_AppliedAmount] * fx15.[USD]
		,[Allocation15_AppliedAmount_NZD] = crdt.[Allocation15_AppliedAmount] * fx15.[NZD]
		,[Allocation15_AppliedAmount_EUR] = crdt.[Allocation15_AppliedAmount] * fx15.[EUR]
		,[Allocation15_AppliedAmount_GBP] = crdt.[Allocation15_AppliedAmount] * fx15.[GBP]
        ,[LineAmountCreditNoteCalculation_AUD] = crdt.[LineAmountCreditNoteCalculation] * fx.[AUD]
        ,[LineAmountCreditNoteCalculation_USD] = crdt.[LineAmountCreditNoteCalculation] * fx.[USD]
        ,[LineAmountCreditNoteCalculation_NZD] = crdt.[LineAmountCreditNoteCalculation] * fx.[NZD]
        ,[LineAmountCreditNoteCalculation_EUR] = crdt.[LineAmountCreditNoteCalculation] * fx.[EUR]
        ,[LineAmountCreditNoteCalculation_GBP] = crdt.[LineAmountCreditNoteCalculation] * fx.[GBP]
        ,[LineAmountTradeCreditorCalculation_AUD] = crdt.[LineAmountTradeCreditorCalculation] * fx.[AUD]
        ,[LineAmountTradeCreditorCalculation_USD] = crdt.[LineAmountTradeCreditorCalculation] * fx.[USD]
        ,[LineAmountTradeCreditorCalculation_NZD] = crdt.[LineAmountTradeCreditorCalculation] * fx.[NZD]
        ,[LineAmountTradeCreditorCalculation_EUR] = crdt.[LineAmountTradeCreditorCalculation] * fx.[EUR]
        ,[LineAmountTradeCreditorCalculation_GBP] = crdt.[LineAmountTradeCreditorCalculation] * fx.[GBP]
        ,[LineAmountTradeDebtorCalculation_AUD] = crdt.[LineAmountTradeDebtorCalculation] * fx.[AUD]
        ,[LineAmountTradeDebtorCalculation_USD] = crdt.[LineAmountTradeDebtorCalculation] * fx.[USD]
        ,[LineAmountTradeDebtorCalculation_NZD] = crdt.[LineAmountTradeDebtorCalculation] * fx.[NZD]
        ,[LineAmountTradeDebtorCalculation_EUR] = crdt.[LineAmountTradeDebtorCalculation] * fx.[EUR]
        ,[LineAmountTradeDebtorCalculation_GBP] = crdt.[LineAmountTradeDebtorCalculation] * fx.[GBP]
	FROM NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE crdt
	LEFT JOIN #FXTable fx ON fx.BaseCurrency = crdt.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN crdt.[Date] <= @minDate THEN @minDate 
									WHEN crdt.[Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Date] 
								END
	LEFT JOIN #FXTable fx1 ON fx1.BaseCurrency = crdt.CurrencyCode 
				AND fx1.[Date] = CASE 
									WHEN crdt.[Allocation1_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation1_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation1_Date] 
								END
	LEFT JOIN #FXTable fx2 ON fx2.BaseCurrency = crdt.CurrencyCode 
				AND fx2.[Date] = CASE 
									WHEN crdt.[Allocation2_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation2_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation2_Date] 
								END
	LEFT JOIN #FXTable fx3 ON fx3.BaseCurrency = crdt.CurrencyCode 
				AND fx3.[Date] = CASE 
									WHEN crdt.[Allocation3_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation3_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation3_Date] 
								END
	LEFT JOIN #FXTable fx4 ON fx4.BaseCurrency = crdt.CurrencyCode 
				AND fx4.[Date] = CASE 
									WHEN crdt.[Allocation4_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation4_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation4_Date] 
								END
	LEFT JOIN #FXTable fx5 ON fx5.BaseCurrency = crdt.CurrencyCode 
				AND fx5.[Date] = CASE 
									WHEN crdt.[Allocation5_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation5_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation5_Date] 
								END
	LEFT JOIN #FXTable fx6 ON fx6.BaseCurrency = crdt.CurrencyCode 
				AND fx6.[Date] = CASE 
									WHEN crdt.[Allocation6_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation6_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation6_Date] 
								END
	LEFT JOIN #FXTable fx7 ON fx7.BaseCurrency = crdt.CurrencyCode 
				AND fx7.[Date] = CASE 
									WHEN crdt.[Allocation7_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation7_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation7_Date] 
								END
	LEFT JOIN #FXTable fx8 ON fx8.BaseCurrency = crdt.CurrencyCode 
				AND fx8.[Date] = CASE 
									WHEN crdt.[Allocation8_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation8_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation8_Date] 
								END
	LEFT JOIN #FXTable fx9 ON fx9.BaseCurrency = crdt.CurrencyCode 
				AND fx9.[Date] = CASE 
									WHEN crdt.[Allocation9_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation9_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation9_Date] 
								END
	LEFT JOIN #FXTable fx10 ON fx10.BaseCurrency = crdt.CurrencyCode 
				AND fx10.[Date] = CASE 
									WHEN crdt.[Allocation10_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation10_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation10_Date] 
								END
	LEFT JOIN #FXTable fx11 ON fx11.BaseCurrency = crdt.CurrencyCode 
				AND fx11.[Date] = CASE 
									WHEN crdt.[Allocation11_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation11_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation11_Date] 
								END
	LEFT JOIN #FXTable fx12 ON fx12.BaseCurrency = crdt.CurrencyCode 
				AND fx12.[Date] = CASE 
									WHEN crdt.[Allocation12_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation12_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation12_Date] 
								END
	LEFT JOIN #FXTable fx13 ON fx13.BaseCurrency = crdt.CurrencyCode 
				AND fx13.[Date] = CASE 
									WHEN crdt.[Allocation13_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation13_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation13_Date] 
								END
	LEFT JOIN #FXTable fx14 ON fx14.BaseCurrency = crdt.CurrencyCode 
				AND fx14.[Date] = CASE 
									WHEN crdt.[Allocation14_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation14_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation14_Date] 
								END
	LEFT JOIN #FXTable fx15 ON fx15.BaseCurrency = crdt.CurrencyCode 
				AND fx15.[Date] = CASE 
									WHEN crdt.[Allocation15_Date] <= @minDate THEN @minDate 
									WHEN crdt.[Allocation15_Date] >= @maxDate THEN @maxDate
									ELSE crdt.[Allocation15_Date] 
								END
	WHERE crdt.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE STG ON TRG.CreditNoteId = STG.CreditNoteId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_CreditNotes 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE 
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END

	IF OBJECT_ID('tempdb..#CreditNotes') IS NOT NULL
	BEGIN
		DROP TABLE #CreditNotes
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_CreditNotes', 'NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE'
GO


--XEROBLUE_Invoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Invoices', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Invoices
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Invoices
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER
	
	IF OBJECT_ID('tempdb..#Invoices') IS NOT NULL
	BEGIN
		DROP TABLE #Invoices
	END
	
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY InvoiceId ORDER BY [Date]),'|',InvoiceId)
		,InvoiceId
		,Type
		,ContactId
		,ContactName
		,LineItem_LineItemId = jLineItem_LineItemId
		,LineItem_Description = jLineItem_Description
		,LineItem_Quantity = jLineItem_Quantity
		,LineItem_UnitAmount = jLineItem_UnitAmount
		,LineItem_ItemCode = jLineItem_ItemCode
		,LineItem_AccountCode = jLineItem_AccountCode
		,LineItem_TaxType = jLineItem_TaxType
		,LineItem_TaxAmount = jLineItem_TaxAmount
		,LineItem_LineAmount = jLineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate = jLineItem_DiscountRate
		,LineItem_DiscountAmount = jLineItem_DiscountAmount
		,LineItemAggregate = NULL
		,Date
		,DueDate
		,LineAmountTypes
		,InvoiceNumber
		,Reference
		,BrandingThemeId
		,URL
		,CurrencyCode
		,CurrencyRate
		,Status
		,SentToContact
		,ExpectedPaymentDate
		,PlannedPaymentDate
		,SubTotal
		,TotalTax
		,Total
		,TotalDiscount
		,HasAttachments
		,PaymentIds = CAST(PaymentIds AS NVARCHAR(4000))
		,PrePaymentIds = CAST(PrePaymentIds AS NVARCHAR(4000))
		,OverPaymentIds = CAST(OverPaymentIds AS NVARCHAR(4000))
		,CreditNoteIds = CAST(CreditNoteIds AS NVARCHAR(4000))
		,AmountDue
		,AmountPaid
		,CISDeduction
		,FullyPaidOnDate
		,AmountCredited
		,UpdatedDateUTC
		,CreditNotes = CAST(CreditNotes AS NVARCHAR(4000))
		,Prepayments = CAST(Prepayments AS NVARCHAR(4000))
		,Payments = CAST(Payments AS NVARCHAR(4000))
		,Overpayments = CAST(Overpayments AS NVARCHAR(4000))
		,RepeatingInvoiceID = CAST(RepeatingInvoiceID AS NVARCHAR(4000))
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[LineItem_DiscountAmount_AUD]
		,[LineItem_DiscountAmount_USD]
		,[LineItem_DiscountAmount_NZD]
		,[LineItem_DiscountAmount_EUR]
		,[LineItem_DiscountAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[TotalDiscount_AUD]
		,[TotalDiscount_USD]
		,[TotalDiscount_NZD]
		,[TotalDiscount_EUR]
		,[TotalDiscount_GBP]
		,[AmountDue_AUD]
		,[AmountDue_USD]
		,[AmountDue_NZD]
		,[AmountDue_EUR]
		,[AmountDue_GBP]
		,[AmountPaid_AUD]
		,[AmountPaid_USD]
		,[AmountPaid_NZD]
		,[AmountPaid_EUR]
		,[AmountPaid_GBP]
		,[CISDeduction_AUD]
		,[CISDeduction_USD]
		,[CISDeduction_NZD]
		,[CISDeduction_EUR]
		,[CISDeduction_GBP]
		,[AmountCredited_AUD]
		,[AmountCredited_USD]
		,[AmountCredited_NZD]
		,[AmountCredited_EUR]
		,[AmountCredited_GBP]
        ,[DiscountRate]
        ,[DiscountRate%]
        ,[LineAmountCalculation]
        ,[LineAmountCalculationIncTax]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[DayDifference]
        ,[LineAmountCalculation_AUD]
        ,[LineAmountCalculation_USD]
        ,[LineAmountCalculation_NZD]
        ,[LineAmountCalculation_EUR]
        ,[LineAmountCalculation_GBP]
        ,[LineAmountCalculationIncTax_AUD]
        ,[LineAmountCalculationIncTax_USD]
        ,[LineAmountCalculationIncTax_NZD]
        ,[LineAmountCalculationIncTax_EUR]
        ,[LineAmountCalculationIncTax_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
		,[Account_UID]
	INTO #Invoices
	FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
	CROSS APPLY OPENJSON(LineItemAggregate)
	WITH(
			jLineItem_LineItemId NVARCHAR(100) '$.LineItemID'
			,jLineItem_Description NVARCHAR(4000) '$.Description'
			,jLineItem_Quantity FLOAT '$.Quantity'
			,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
			,jLineItem_ItemCode NVARCHAR(100) '$.ItemCode'
			,jLineItem_AccountCode NVARCHAR(100) '$.AccountCode'
			,jLineItem_TaxType NVARCHAR(100) '$.TaxType'
			,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.Tracking[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.Tracking[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.Tracking[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.Tracking[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.Tracking[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.Tracking[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.Tracking[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.Tracking[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.Tracking[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.Tracking[1].Status'
			,jLineItem_DiscountRate FLOAT '$.DiscountRate'
			,jLineItem_DiscountAmount NUMERIC(30,6) '$.DiscountAmount'
		)
	WHERE OrganisationId = @OrganisationID
	INSERT INTO #Invoices
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY InvoiceId ORDER BY [Date]),'|',InvoiceId)
		,InvoiceId
		,Type
		,ContactId
		,ContactName
		,LineItem_LineItemId
		,LineItem_Description
		,LineItem_Quantity
		,LineItem_UnitAmount
		,LineItem_ItemCode
		,LineItem_AccountCode
		,LineItem_TaxType
		,LineItem_TaxAmount
		,LineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate
		,LineItem_DiscountAmount
		,LineItemAggregate = NULL
		,Date
		,DueDate
		,LineAmountTypes
		,InvoiceNumber
		,Reference
		,BrandingThemeId
		,URL
		,CurrencyCode
		,CurrencyRate
		,Status
		,SentToContact
		,ExpectedPaymentDate
		,PlannedPaymentDate
		,SubTotal
		,TotalTax
		,Total
		,TotalDiscount
		,HasAttachments
		,PaymentIds = CAST(PaymentIds AS NVARCHAR(4000))
		,PrePaymentIds = CAST(PrePaymentIds AS NVARCHAR(4000))
		,OverPaymentIds = CAST(OverPaymentIds AS NVARCHAR(4000))
		,CreditNoteIds = CAST(CreditNoteIds AS NVARCHAR(4000))
		,AmountDue
		,AmountPaid
		,CISDeduction
		,FullyPaidOnDate
		,AmountCredited
		,UpdatedDateUTC
		,CreditNotes = CAST(CreditNotes AS NVARCHAR(4000))
		,Prepayments = CAST(Prepayments AS NVARCHAR(4000))
		,Payments = CAST(Payments AS NVARCHAR(4000))
		,Overpayments = CAST(Overpayments AS NVARCHAR(4000))
		,RepeatingInvoiceID = CAST(RepeatingInvoiceID AS NVARCHAR(4000))
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[LineItem_DiscountAmount_AUD]
		,[LineItem_DiscountAmount_USD]
		,[LineItem_DiscountAmount_NZD]
		,[LineItem_DiscountAmount_EUR]
		,[LineItem_DiscountAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[TotalDiscount_AUD]
		,[TotalDiscount_USD]
		,[TotalDiscount_NZD]
		,[TotalDiscount_EUR]
		,[TotalDiscount_GBP]
		,[AmountDue_AUD]
		,[AmountDue_USD]
		,[AmountDue_NZD]
		,[AmountDue_EUR]
		,[AmountDue_GBP]
		,[AmountPaid_AUD]
		,[AmountPaid_USD]
		,[AmountPaid_NZD]
		,[AmountPaid_EUR]
		,[AmountPaid_GBP]
		,[CISDeduction_AUD]
		,[CISDeduction_USD]
		,[CISDeduction_NZD]
		,[CISDeduction_EUR]
		,[CISDeduction_GBP]
		,[AmountCredited_AUD]
		,[AmountCredited_USD]
		,[AmountCredited_NZD]
		,[AmountCredited_EUR]
		,[AmountCredited_GBP]
        ,[DiscountRate]
        ,[DiscountRate%]
        ,[LineAmountCalculation]
        ,[LineAmountCalculationIncTax]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[DayDifference]
        ,[LineAmountCalculation_AUD]
        ,[LineAmountCalculation_USD]
        ,[LineAmountCalculation_NZD]
        ,[LineAmountCalculation_EUR]
        ,[LineAmountCalculation_GBP]
        ,[LineAmountCalculationIncTax_AUD]
        ,[LineAmountCalculationIncTax_USD]
        ,[LineAmountCalculationIncTax_NZD]
        ,[LineAmountCalculationIncTax_EUR]
        ,[LineAmountCalculationIncTax_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
		,[Account_UID]
	FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
    WHERE OrganisationId = @OrganisationID AND LineItemAggregate = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE WHERE OrganisationId = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
	SELECT * FROM #Invoices;

    UPDATE NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
    SET
        [DiscountRate] = ISNULL([LineItem_DiscountRate], 0), 
        [DiscountRate%] = ISNULL([LineItem_DiscountRate] * 0.01, 0),
        [LineAmountCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'INCLUSIVE' AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'INCLUSIVE' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN ([LineAmountTypes] = 'EXCLUSIVE' OR [LineAmountTypes] = 'NOTAX') AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount])
                WHEN ([LineAmountTypes] = 'EXCLUSIVE' OR [LineAmountTypes] = 'NOTAX') AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                ELSE 0 END AS decimal(15,4)
            ),     
        [LineAmountCalculationIncTax] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),    	
        [LineAmountTradeCreditorCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),   
        [LineAmountTradeDebtorCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),
        [DayDifference] = DATEDIFF(DAY, [Date], [FullyPaidOnDate]),
		[Account_UID] = [LineItem_AccountCode] + '-' + CAST([OrganisationID] AS varchar)
    WHERE OrganisationId = @OrganisationID;

	UPDATE inv
	SET  [LineItem_UnitAmount_AUD] = inv.[LineItem_UnitAmount] * [AUD]
		,[LineItem_UnitAmount_USD] = inv.[LineItem_UnitAmount] * [USD]
		,[LineItem_UnitAmount_NZD] = inv.[LineItem_UnitAmount] * [NZD]
		,[LineItem_UnitAmount_EUR] = inv.[LineItem_UnitAmount] * [EUR]
		,[LineItem_UnitAmount_GBP] = inv.[LineItem_UnitAmount] * [GBP]
		,[LineItem_TaxAmount_AUD] = inv.[LineItem_TaxAmount] * [AUD]
		,[LineItem_TaxAmount_USD] = inv.[LineItem_TaxAmount] * [USD]
		,[LineItem_TaxAmount_NZD] = inv.[LineItem_TaxAmount] * [NZD]
		,[LineItem_TaxAmount_EUR] = inv.[LineItem_TaxAmount] * [EUR]
		,[LineItem_TaxAmount_GBP] = inv.[LineItem_TaxAmount] * [GBP]
		,[LineItem_LineAmount_AUD] = inv.[LineItem_LineAmount] * [AUD]
		,[LineItem_LineAmount_USD] = inv.[LineItem_LineAmount] * [USD]
		,[LineItem_LineAmount_NZD] = inv.[LineItem_LineAmount] * [NZD]
		,[LineItem_LineAmount_EUR] = inv.[LineItem_LineAmount] * [EUR]
		,[LineItem_LineAmount_GBP] = inv.[LineItem_LineAmount] * [GBP]
		,[LineItem_DiscountAmount_AUD] = inv.[LineItem_DiscountAmount] * [AUD]
		,[LineItem_DiscountAmount_USD] = inv.[LineItem_DiscountAmount] * [USD]
		,[LineItem_DiscountAmount_NZD] = inv.[LineItem_DiscountAmount] * [NZD]
		,[LineItem_DiscountAmount_EUR] = inv.[LineItem_DiscountAmount] * [EUR]
		,[LineItem_DiscountAmount_GBP] = inv.[LineItem_DiscountAmount] * [GBP]
		,[SubTotal_AUD] = inv.[SubTotal] * [AUD]
		,[SubTotal_USD] = inv.[SubTotal] * [USD]
		,[SubTotal_NZD] = inv.[SubTotal] * [NZD]
		,[SubTotal_EUR] = inv.[SubTotal] * [EUR]
		,[SubTotal_GBP] = inv.[SubTotal] * [GBP]
		,[TotalTax_AUD] = inv.[TotalTax] * [AUD]
		,[TotalTax_USD] = inv.[TotalTax] * [USD]
		,[TotalTax_NZD] = inv.[TotalTax] * [NZD]
		,[TotalTax_EUR] = inv.[TotalTax] * [EUR]
		,[TotalTax_GBP] = inv.[TotalTax] * [GBP]
		,[Total_AUD] = inv.[Total] * [AUD]
		,[Total_USD] = inv.[Total] * [USD]
		,[Total_NZD] = inv.[Total] * [NZD]
		,[Total_EUR] = inv.[Total] * [EUR]
		,[Total_GBP] = inv.[Total] * [GBP]
		,[TotalDiscount_AUD] = inv.[TotalDiscount] * [AUD]
		,[TotalDiscount_USD] = inv.[TotalDiscount] * [USD]
		,[TotalDiscount_NZD] = inv.[TotalDiscount] * [NZD]
		,[TotalDiscount_EUR] = inv.[TotalDiscount] * [EUR]
		,[TotalDiscount_GBP] = inv.[TotalDiscount] * [GBP]
		,[AmountDue_AUD] = inv.[AmountDue] * [AUD]
		,[AmountDue_USD] = inv.[AmountDue] * [USD]
		,[AmountDue_NZD] = inv.[AmountDue] * [NZD]
		,[AmountDue_EUR] = inv.[AmountDue] * [EUR]
		,[AmountDue_GBP] = inv.[AmountDue] * [GBP]
		,[AmountPaid_AUD] = inv.[AmountPaid] * [AUD]
		,[AmountPaid_USD] = inv.[AmountPaid] * [USD]
		,[AmountPaid_NZD] = inv.[AmountPaid] * [NZD]
		,[AmountPaid_EUR] = inv.[AmountPaid] * [EUR]
		,[AmountPaid_GBP] = inv.[AmountPaid] * [GBP]
		,[CISDeduction_AUD] = inv.[CISDeduction] * [AUD]
		,[CISDeduction_USD] = inv.[CISDeduction] * [USD]
		,[CISDeduction_NZD] = inv.[CISDeduction] * [NZD]
		,[CISDeduction_EUR] = inv.[CISDeduction] * [EUR]
		,[CISDeduction_GBP] = inv.[CISDeduction] * [GBP]
		,[AmountCredited_AUD] = inv.[AmountCredited] * [AUD]
		,[AmountCredited_USD] = inv.[AmountCredited] * [USD]
		,[AmountCredited_NZD] = inv.[AmountCredited] * [NZD]
		,[AmountCredited_EUR] = inv.[AmountCredited] * [EUR]
		,[AmountCredited_GBP] = inv.[AmountCredited] * [GBP]
        ,[LineAmountCalculation_AUD] = inv.[LineAmountCalculation] * [AUD]
        ,[LineAmountCalculation_USD] = inv.[LineAmountCalculation] * [USD]
        ,[LineAmountCalculation_NZD] = inv.[LineAmountCalculation] * [NZD]
        ,[LineAmountCalculation_EUR] = inv.[LineAmountCalculation] * [EUR]
        ,[LineAmountCalculation_GBP] = inv.[LineAmountCalculation] * [GBP]
        ,[LineAmountCalculationIncTax_AUD] = inv.[LineAmountCalculationIncTax] * [AUD]
        ,[LineAmountCalculationIncTax_USD] = inv.[LineAmountCalculationIncTax] * [USD]
        ,[LineAmountCalculationIncTax_NZD] = inv.[LineAmountCalculationIncTax] * [NZD]
        ,[LineAmountCalculationIncTax_EUR] = inv.[LineAmountCalculationIncTax] * [EUR]
        ,[LineAmountCalculationIncTax_GBP] = inv.[LineAmountCalculationIncTax] * [GBP]
        ,[LineAmountTradeCreditorCalculation_AUD] = inv.[LineAmountTradeCreditorCalculation] * [AUD]
        ,[LineAmountTradeCreditorCalculation_USD] = inv.[LineAmountTradeCreditorCalculation] * [USD]
        ,[LineAmountTradeCreditorCalculation_NZD] = inv.[LineAmountTradeCreditorCalculation] * [NZD]
        ,[LineAmountTradeCreditorCalculation_EUR] = inv.[LineAmountTradeCreditorCalculation] * [EUR]
        ,[LineAmountTradeCreditorCalculation_GBP] = inv.[LineAmountTradeCreditorCalculation] * [GBP]
        ,[LineAmountTradeDebtorCalculation_AUD] = inv.[LineAmountTradeDebtorCalculation] * [AUD]
        ,[LineAmountTradeDebtorCalculation_USD] = inv.[LineAmountTradeDebtorCalculation] * [USD]
        ,[LineAmountTradeDebtorCalculation_NZD] = inv.[LineAmountTradeDebtorCalculation] * [NZD]
        ,[LineAmountTradeDebtorCalculation_EUR] = inv.[LineAmountTradeDebtorCalculation] * [EUR]
        ,[LineAmountTradeDebtorCalculation_GBP] = inv.[LineAmountTradeDebtorCalculation] * [GBP]
	FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE inv
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = inv.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN inv.[Date] <= @minDate THEN @minDate 
									WHEN inv.[Date] >= @maxDate THEN @maxDate
									ELSE inv.[Date] 
								END
	WHERE inv.OrganisationID = @OrganisationID;

	--PaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.PaymentIds, j.jPaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jPaymentIds, ',') jPaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jPaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
				CROSS APPLY OPENJSON(Payments)
				WITH (jPaymentIds nvarchar(max) '$.PaymentID')
				WHERE REVERSE(Payments) LIKE ']%'
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET PaymentIds = jPaymentIds;

	--PrepaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.PrepaymentIds, j.jPrepaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jPrepaymentIds, ',') jPrepaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jPrepaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
				CROSS APPLY OPENJSON(Prepayments)
				WITH (jPrepaymentIds nvarchar(max) '$.PrepaymentID')
				WHERE REVERSE(Prepayments) LIKE ']%'
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET PrepaymentIds = jPrepaymentIds;

	--OverPaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.OverPaymentIds, j.jOverPaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jOverPaymentIds, ',') jOverPaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jOverPaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
				CROSS APPLY OPENJSON(Overpayments)
				WITH (jOverPaymentIds nvarchar(max) '$.OverpaymentID')
				WHERE REVERSE(Overpayments) LIKE ']%'
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET OverPaymentIds = jOverPaymentIds;

	--CreditNoteIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.CreditNoteIds, j.jCreditNoteIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jCreditNoteIds, ',') jCreditNoteIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jCreditNoteIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
				CROSS APPLY OPENJSON(CreditNotes)
				WITH (jCreditNoteIds nvarchar(max) '$.CreditNoteID')
				WHERE REVERSE(CreditNotes) LIKE ']%'
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET CreditNoteIds = jCreditNoteIds;

	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_InvoicesSTAGE STG ON TRG.InvoiceId = STG.InvoiceId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Invoices 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#Invoices') IS NOT NULL
	BEGIN
		DROP TABLE #Invoices
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Invoices', 'NEW_CLIENT1_XEROBLUE_InvoicesSTAGE'
GO


--XEROBLUE_Overpayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Overpayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Overpayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Overpayments
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END

	SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
	INTO #FXTable
	FROM (
			SELECT
				BaseCurrency, Date, Currency, ExchangeRate
			FROM FOREIGNEXCHANGE_MASTER fx
			WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
		) AS SRC
	PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p

	UPDATE ovrpymt
	SET  [RemainingCredit_AUD] = ovrpymt.[RemainingCredit] * fx.[AUD]
		,[RemainingCredit_USD] = ovrpymt.[RemainingCredit] * fx.[USD]
		,[RemainingCredit_NZD] = ovrpymt.[RemainingCredit] * fx.[NZD]
		,[RemainingCredit_EUR] = ovrpymt.[RemainingCredit] * fx.[EUR]
		,[RemainingCredit_GBP] = ovrpymt.[RemainingCredit] * fx.[GBP]
		,[SubTotal_AUD] = ovrpymt.[SubTotal] * fx.[AUD]
		,[SubTotal_USD] = ovrpymt.[SubTotal] * fx.[USD]
		,[SubTotal_NZD] = ovrpymt.[SubTotal] * fx.[NZD]
		,[SubTotal_EUR] = ovrpymt.[SubTotal] * fx.[EUR]
		,[SubTotal_GBP] = ovrpymt.[SubTotal] * fx.[GBP]
		,[TotalTax_AUD] = ovrpymt.[TotalTax] * fx.[AUD]
		,[TotalTax_USD] = ovrpymt.[TotalTax] * fx.[USD]
		,[TotalTax_NZD] = ovrpymt.[TotalTax] * fx.[NZD]
		,[TotalTax_EUR] = ovrpymt.[TotalTax] * fx.[EUR]
		,[TotalTax_GBP] = ovrpymt.[TotalTax] * fx.[GBP]
		,[Total_AUD] = ovrpymt.[Total] * fx.[AUD]
		,[Total_USD] = ovrpymt.[Total] * fx.[USD]
		,[Total_NZD] = ovrpymt.[Total] * fx.[NZD]
		,[Total_EUR] = ovrpymt.[Total] * fx.[EUR]
		,[Total_GBP] = ovrpymt.[Total] * fx.[GBP]
		,[LineItem_UnitAmount_AUD] = ovrpymt.[LineItem_UnitAmount] * fx.[AUD]
		,[LineItem_UnitAmount_USD] = ovrpymt.[LineItem_UnitAmount] * fx.[USD]
		,[LineItem_UnitAmount_NZD] = ovrpymt.[LineItem_UnitAmount] * fx.[NZD]
		,[LineItem_UnitAmount_EUR] = ovrpymt.[LineItem_UnitAmount] * fx.[EUR]
		,[LineItem_UnitAmount_GBP] = ovrpymt.[LineItem_UnitAmount] * fx.[GBP]
		,[LineItem_TaxAmount_AUD] = ovrpymt.[LineItem_TaxAmount] * fx.[AUD]
		,[LineItem_TaxAmount_USD] = ovrpymt.[LineItem_TaxAmount] * fx.[USD]
		,[LineItem_TaxAmount_NZD] = ovrpymt.[LineItem_TaxAmount] * fx.[NZD]
		,[LineItem_TaxAmount_EUR] = ovrpymt.[LineItem_TaxAmount] * fx.[EUR]
		,[LineItem_TaxAmount_GBP] = ovrpymt.[LineItem_TaxAmount] * fx.[GBP]
		,[LineItem_LineAmount_AUD] = ovrpymt.[LineItem_LineAmount] * fx.[AUD]
		,[LineItem_LineAmount_USD] = ovrpymt.[LineItem_LineAmount] * fx.[USD]
		,[LineItem_LineAmount_NZD] = ovrpymt.[LineItem_LineAmount] * fx.[NZD]
		,[LineItem_LineAmount_EUR] = ovrpymt.[LineItem_LineAmount] * fx.[EUR]
		,[LineItem_LineAmount_GBP] = ovrpymt.[LineItem_LineAmount] * fx.[GBP]
		,[Allocation1_AppliedAmount_AUD] = ovrpymt.[Allocation1_AppliedAmount] * fx1.[AUD]
		,[Allocation1_AppliedAmount_USD] = ovrpymt.[Allocation1_AppliedAmount] * fx1.[USD]
		,[Allocation1_AppliedAmount_NZD] = ovrpymt.[Allocation1_AppliedAmount] * fx1.[NZD]
		,[Allocation1_AppliedAmount_EUR] = ovrpymt.[Allocation1_AppliedAmount] * fx1.[EUR]
		,[Allocation1_AppliedAmount_GBP] = ovrpymt.[Allocation1_AppliedAmount] * fx1.[GBP]
		,[Allocation2_AppliedAmount_AUD] = ovrpymt.[Allocation2_AppliedAmount] * fx2.[AUD]
		,[Allocation2_AppliedAmount_USD] = ovrpymt.[Allocation2_AppliedAmount] * fx2.[USD]
		,[Allocation2_AppliedAmount_NZD] = ovrpymt.[Allocation2_AppliedAmount] * fx2.[NZD]
		,[Allocation2_AppliedAmount_EUR] = ovrpymt.[Allocation2_AppliedAmount] * fx2.[EUR]
		,[Allocation2_AppliedAmount_GBP] = ovrpymt.[Allocation2_AppliedAmount] * fx2.[GBP]
		,[Allocation3_AppliedAmount_AUD] = ovrpymt.[Allocation3_AppliedAmount] * fx3.[AUD]
		,[Allocation3_AppliedAmount_USD] = ovrpymt.[Allocation3_AppliedAmount] * fx3.[USD]
		,[Allocation3_AppliedAmount_NZD] = ovrpymt.[Allocation3_AppliedAmount] * fx3.[NZD]
		,[Allocation3_AppliedAmount_EUR] = ovrpymt.[Allocation3_AppliedAmount] * fx3.[EUR]
		,[Allocation3_AppliedAmount_GBP] = ovrpymt.[Allocation3_AppliedAmount] * fx3.[GBP]
		,[Allocation4_AppliedAmount_AUD] = ovrpymt.[Allocation4_AppliedAmount] * fx4.[AUD]
		,[Allocation4_AppliedAmount_USD] = ovrpymt.[Allocation4_AppliedAmount] * fx4.[USD]
		,[Allocation4_AppliedAmount_NZD] = ovrpymt.[Allocation4_AppliedAmount] * fx4.[NZD]
		,[Allocation4_AppliedAmount_EUR] = ovrpymt.[Allocation4_AppliedAmount] * fx4.[EUR]
		,[Allocation4_AppliedAmount_GBP] = ovrpymt.[Allocation4_AppliedAmount] * fx4.[GBP]
		,[Allocation5_AppliedAmount_AUD] = ovrpymt.[Allocation5_AppliedAmount] * fx5.[AUD]
		,[Allocation5_AppliedAmount_USD] = ovrpymt.[Allocation5_AppliedAmount] * fx5.[USD]
		,[Allocation5_AppliedAmount_NZD] = ovrpymt.[Allocation5_AppliedAmount] * fx5.[NZD]
		,[Allocation5_AppliedAmount_EUR] = ovrpymt.[Allocation5_AppliedAmount] * fx5.[EUR]
		,[Allocation5_AppliedAmount_GBP] = ovrpymt.[Allocation5_AppliedAmount] * fx5.[GBP]
		,[Allocation6_AppliedAmount_AUD] = ovrpymt.[Allocation6_AppliedAmount] * fx6.[AUD]
		,[Allocation6_AppliedAmount_USD] = ovrpymt.[Allocation6_AppliedAmount] * fx6.[USD]
		,[Allocation6_AppliedAmount_NZD] = ovrpymt.[Allocation6_AppliedAmount] * fx6.[NZD]
		,[Allocation6_AppliedAmount_EUR] = ovrpymt.[Allocation6_AppliedAmount] * fx6.[EUR]
		,[Allocation6_AppliedAmount_GBP] = ovrpymt.[Allocation6_AppliedAmount] * fx6.[GBP]
		,[Allocation7_AppliedAmount_AUD] = ovrpymt.[Allocation7_AppliedAmount] * fx7.[AUD]
		,[Allocation7_AppliedAmount_USD] = ovrpymt.[Allocation7_AppliedAmount] * fx7.[USD]
		,[Allocation7_AppliedAmount_NZD] = ovrpymt.[Allocation7_AppliedAmount] * fx7.[NZD]
		,[Allocation7_AppliedAmount_EUR] = ovrpymt.[Allocation7_AppliedAmount] * fx7.[EUR]
		,[Allocation7_AppliedAmount_GBP] = ovrpymt.[Allocation7_AppliedAmount] * fx7.[GBP]
		,[Allocation8_AppliedAmount_AUD] = ovrpymt.[Allocation8_AppliedAmount] * fx8.[AUD]
		,[Allocation8_AppliedAmount_USD] = ovrpymt.[Allocation8_AppliedAmount] * fx8.[USD]
		,[Allocation8_AppliedAmount_NZD] = ovrpymt.[Allocation8_AppliedAmount] * fx8.[NZD]
		,[Allocation8_AppliedAmount_EUR] = ovrpymt.[Allocation8_AppliedAmount] * fx8.[EUR]
		,[Allocation8_AppliedAmount_GBP] = ovrpymt.[Allocation8_AppliedAmount] * fx8.[GBP]
		,[Allocation9_AppliedAmount_AUD] = ovrpymt.[Allocation9_AppliedAmount] * fx9.[AUD]
		,[Allocation9_AppliedAmount_USD] = ovrpymt.[Allocation9_AppliedAmount] * fx9.[USD]
		,[Allocation9_AppliedAmount_NZD] = ovrpymt.[Allocation9_AppliedAmount] * fx9.[NZD]
		,[Allocation9_AppliedAmount_EUR] = ovrpymt.[Allocation9_AppliedAmount] * fx9.[EUR]
		,[Allocation9_AppliedAmount_GBP] = ovrpymt.[Allocation9_AppliedAmount] * fx9.[GBP]
		,[Allocation10_AppliedAmount_AUD] = ovrpymt.[Allocation10_AppliedAmount] * fx10.[AUD]
		,[Allocation10_AppliedAmount_USD] = ovrpymt.[Allocation10_AppliedAmount] * fx10.[USD]
		,[Allocation10_AppliedAmount_NZD] = ovrpymt.[Allocation10_AppliedAmount] * fx10.[NZD]
		,[Allocation10_AppliedAmount_EUR] = ovrpymt.[Allocation10_AppliedAmount] * fx10.[EUR]
		,[Allocation10_AppliedAmount_GBP] = ovrpymt.[Allocation10_AppliedAmount] * fx10.[GBP]
	FROM NEW_CLIENT1_XEROBLUE_OverpaymentsSTAGE ovrpymt
	LEFT JOIN #FXTable fx ON fx.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN ovrpymt.[Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Date] 
								END
	LEFT JOIN #FXTable fx1 ON fx1.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx1.[Date] = CASE 
									WHEN ovrpymt.[Allocation1_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation1_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation1_Date] 
								END
	LEFT JOIN #FXTable fx2 ON fx2.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx2.[Date] = CASE 
									WHEN ovrpymt.[Allocation2_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation2_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation2_Date] 
								END
	LEFT JOIN #FXTable fx3 ON fx3.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx3.[Date] = CASE 
									WHEN ovrpymt.[Allocation3_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation3_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation3_Date] 
								END
	LEFT JOIN #FXTable fx4 ON fx4.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx4.[Date] = CASE 
									WHEN ovrpymt.[Allocation4_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation4_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation4_Date] 
								END
	LEFT JOIN #FXTable fx5 ON fx5.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx5.[Date] = CASE 
									WHEN ovrpymt.[Allocation5_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation5_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation5_Date] 
								END
	LEFT JOIN #FXTable fx6 ON fx6.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx6.[Date] = CASE 
									WHEN ovrpymt.[Allocation6_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation6_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation6_Date] 
								END
	LEFT JOIN #FXTable fx7 ON fx7.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx7.[Date] = CASE 
									WHEN ovrpymt.[Allocation7_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation7_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation7_Date] 
								END
	LEFT JOIN #FXTable fx8 ON fx8.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx8.[Date] = CASE 
									WHEN ovrpymt.[Allocation8_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation8_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation8_Date] 
								END
	LEFT JOIN #FXTable fx9 ON fx9.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx9.[Date] = CASE 
									WHEN ovrpymt.[Allocation9_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation9_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation9_Date] 
								END
	LEFT JOIN #FXTable fx10 ON fx10.BaseCurrency = ovrpymt.CurrencyCode 
				AND fx10.[Date] = CASE 
									WHEN ovrpymt.[Allocation10_Date] <= @minDate THEN @minDate 
									WHEN ovrpymt.[Allocation10_Date] >= @maxDate THEN @maxDate
									ELSE ovrpymt.[Allocation10_Date] 
								END
	WHERE ovrpymt.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Overpayments 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Overpayments 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_OverpaymentsSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Overpayments', 'NEW_CLIENT1_XEROBLUE_OverpaymentsSTAGE'
GO


--XEROBLUE_Prepayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Prepayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Prepayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Prepayments
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END

	SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
	INTO #FXTable
	FROM (
			SELECT
				BaseCurrency, Date, Currency, ExchangeRate
			FROM FOREIGNEXCHANGE_MASTER fx
			WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
		) AS SRC
	PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p

	UPDATE prepymt
	SET  [RemainingCredit_AUD] = prepymt.[RemainingCredit] * fx.[AUD]
		,[RemainingCredit_USD] = prepymt.[RemainingCredit] * fx.[USD]
		,[RemainingCredit_NZD] = prepymt.[RemainingCredit] * fx.[NZD]
		,[RemainingCredit_EUR] = prepymt.[RemainingCredit] * fx.[EUR]
		,[RemainingCredit_GBP] = prepymt.[RemainingCredit] * fx.[GBP]
		,[SubTotal_AUD] = prepymt.[SubTotal] * fx.[AUD]
		,[SubTotal_USD] = prepymt.[SubTotal] * fx.[USD]
		,[SubTotal_NZD] = prepymt.[SubTotal] * fx.[NZD]
		,[SubTotal_EUR] = prepymt.[SubTotal] * fx.[EUR]
		,[SubTotal_GBP] = prepymt.[SubTotal] * fx.[GBP]
		,[TotalTax_AUD] = prepymt.[TotalTax] * fx.[AUD]
		,[TotalTax_USD] = prepymt.[TotalTax] * fx.[USD]
		,[TotalTax_NZD] = prepymt.[TotalTax] * fx.[NZD]
		,[TotalTax_EUR] = prepymt.[TotalTax] * fx.[EUR]
		,[TotalTax_GBP] = prepymt.[TotalTax] * fx.[GBP]
		,[Total_AUD] = prepymt.[Total] * fx.[AUD]
		,[Total_USD] = prepymt.[Total] * fx.[USD]
		,[Total_NZD] = prepymt.[Total] * fx.[NZD]
		,[Total_EUR] = prepymt.[Total] * fx.[EUR]
		,[Total_GBP] = prepymt.[Total] * fx.[GBP]
		,[LineItem_UnitAmount_AUD] = prepymt.[LineItem_UnitAmount] * fx.[AUD]
		,[LineItem_UnitAmount_USD] = prepymt.[LineItem_UnitAmount] * fx.[USD]
		,[LineItem_UnitAmount_NZD] = prepymt.[LineItem_UnitAmount] * fx.[NZD]
		,[LineItem_UnitAmount_EUR] = prepymt.[LineItem_UnitAmount] * fx.[EUR]
		,[LineItem_UnitAmount_GBP] = prepymt.[LineItem_UnitAmount] * fx.[GBP]
		,[LineItem_TaxAmount_AUD] = prepymt.[LineItem_TaxAmount] * fx.[AUD]
		,[LineItem_TaxAmount_USD] = prepymt.[LineItem_TaxAmount] * fx.[USD]
		,[LineItem_TaxAmount_NZD] = prepymt.[LineItem_TaxAmount] * fx.[NZD]
		,[LineItem_TaxAmount_EUR] = prepymt.[LineItem_TaxAmount] * fx.[EUR]
		,[LineItem_TaxAmount_GBP] = prepymt.[LineItem_TaxAmount] * fx.[GBP]
		,[LineItem_LineAmount_AUD] = prepymt.[LineItem_LineAmount] * fx.[AUD]
		,[LineItem_LineAmount_USD] = prepymt.[LineItem_LineAmount] * fx.[USD]
		,[LineItem_LineAmount_NZD] = prepymt.[LineItem_LineAmount] * fx.[NZD]
		,[LineItem_LineAmount_EUR] = prepymt.[LineItem_LineAmount] * fx.[EUR]
		,[LineItem_LineAmount_GBP] = prepymt.[LineItem_LineAmount] * fx.[GBP]
		,[Allocation1_AppliedAmount_AUD] = prepymt.[Allocation1_AppliedAmount] * fx1.[AUD]
		,[Allocation1_AppliedAmount_USD] = prepymt.[Allocation1_AppliedAmount] * fx1.[USD]
		,[Allocation1_AppliedAmount_NZD] = prepymt.[Allocation1_AppliedAmount] * fx1.[NZD]
		,[Allocation1_AppliedAmount_EUR] = prepymt.[Allocation1_AppliedAmount] * fx1.[EUR]
		,[Allocation1_AppliedAmount_GBP] = prepymt.[Allocation1_AppliedAmount] * fx1.[GBP]
		,[Allocation2_AppliedAmount_AUD] = prepymt.[Allocation2_AppliedAmount] * fx2.[AUD]
		,[Allocation2_AppliedAmount_USD] = prepymt.[Allocation2_AppliedAmount] * fx2.[USD]
		,[Allocation2_AppliedAmount_NZD] = prepymt.[Allocation2_AppliedAmount] * fx2.[NZD]
		,[Allocation2_AppliedAmount_EUR] = prepymt.[Allocation2_AppliedAmount] * fx2.[EUR]
		,[Allocation2_AppliedAmount_GBP] = prepymt.[Allocation2_AppliedAmount] * fx2.[GBP]
		,[Allocation3_AppliedAmount_AUD] = prepymt.[Allocation3_AppliedAmount] * fx3.[AUD]
		,[Allocation3_AppliedAmount_USD] = prepymt.[Allocation3_AppliedAmount] * fx3.[USD]
		,[Allocation3_AppliedAmount_NZD] = prepymt.[Allocation3_AppliedAmount] * fx3.[NZD]
		,[Allocation3_AppliedAmount_EUR] = prepymt.[Allocation3_AppliedAmount] * fx3.[EUR]
		,[Allocation3_AppliedAmount_GBP] = prepymt.[Allocation3_AppliedAmount] * fx3.[GBP]
		,[Allocation4_AppliedAmount_AUD] = prepymt.[Allocation4_AppliedAmount] * fx4.[AUD]
		,[Allocation4_AppliedAmount_USD] = prepymt.[Allocation4_AppliedAmount] * fx4.[USD]
		,[Allocation4_AppliedAmount_NZD] = prepymt.[Allocation4_AppliedAmount] * fx4.[NZD]
		,[Allocation4_AppliedAmount_EUR] = prepymt.[Allocation4_AppliedAmount] * fx4.[EUR]
		,[Allocation4_AppliedAmount_GBP] = prepymt.[Allocation4_AppliedAmount] * fx4.[GBP]
		,[Allocation5_AppliedAmount_AUD] = prepymt.[Allocation5_AppliedAmount] * fx5.[AUD]
		,[Allocation5_AppliedAmount_USD] = prepymt.[Allocation5_AppliedAmount] * fx5.[USD]
		,[Allocation5_AppliedAmount_NZD] = prepymt.[Allocation5_AppliedAmount] * fx5.[NZD]
		,[Allocation5_AppliedAmount_EUR] = prepymt.[Allocation5_AppliedAmount] * fx5.[EUR]
		,[Allocation5_AppliedAmount_GBP] = prepymt.[Allocation5_AppliedAmount] * fx5.[GBP]
		,[Allocation6_AppliedAmount_AUD] = prepymt.[Allocation6_AppliedAmount] * fx6.[AUD]
		,[Allocation6_AppliedAmount_USD] = prepymt.[Allocation6_AppliedAmount] * fx6.[USD]
		,[Allocation6_AppliedAmount_NZD] = prepymt.[Allocation6_AppliedAmount] * fx6.[NZD]
		,[Allocation6_AppliedAmount_EUR] = prepymt.[Allocation6_AppliedAmount] * fx6.[EUR]
		,[Allocation6_AppliedAmount_GBP] = prepymt.[Allocation6_AppliedAmount] * fx6.[GBP]
		,[Allocation7_AppliedAmount_AUD] = prepymt.[Allocation7_AppliedAmount] * fx7.[AUD]
		,[Allocation7_AppliedAmount_USD] = prepymt.[Allocation7_AppliedAmount] * fx7.[USD]
		,[Allocation7_AppliedAmount_NZD] = prepymt.[Allocation7_AppliedAmount] * fx7.[NZD]
		,[Allocation7_AppliedAmount_EUR] = prepymt.[Allocation7_AppliedAmount] * fx7.[EUR]
		,[Allocation7_AppliedAmount_GBP] = prepymt.[Allocation7_AppliedAmount] * fx7.[GBP]
		,[Allocation8_AppliedAmount_AUD] = prepymt.[Allocation8_AppliedAmount] * fx8.[AUD]
		,[Allocation8_AppliedAmount_USD] = prepymt.[Allocation8_AppliedAmount] * fx8.[USD]
		,[Allocation8_AppliedAmount_NZD] = prepymt.[Allocation8_AppliedAmount] * fx8.[NZD]
		,[Allocation8_AppliedAmount_EUR] = prepymt.[Allocation8_AppliedAmount] * fx8.[EUR]
		,[Allocation8_AppliedAmount_GBP] = prepymt.[Allocation8_AppliedAmount] * fx8.[GBP]
		,[Allocation9_AppliedAmount_AUD] = prepymt.[Allocation9_AppliedAmount] * fx9.[AUD]
		,[Allocation9_AppliedAmount_USD] = prepymt.[Allocation9_AppliedAmount] * fx9.[USD]
		,[Allocation9_AppliedAmount_NZD] = prepymt.[Allocation9_AppliedAmount] * fx9.[NZD]
		,[Allocation9_AppliedAmount_EUR] = prepymt.[Allocation9_AppliedAmount] * fx9.[EUR]
		,[Allocation9_AppliedAmount_GBP] = prepymt.[Allocation9_AppliedAmount] * fx9.[GBP]
		,[Allocation10_AppliedAmount_AUD] = prepymt.[Allocation10_AppliedAmount] * fx10.[AUD]
		,[Allocation10_AppliedAmount_USD] = prepymt.[Allocation10_AppliedAmount] * fx10.[USD]
		,[Allocation10_AppliedAmount_NZD] = prepymt.[Allocation10_AppliedAmount] * fx10.[NZD]
		,[Allocation10_AppliedAmount_EUR] = prepymt.[Allocation10_AppliedAmount] * fx10.[EUR]
		,[Allocation10_AppliedAmount_GBP] = prepymt.[Allocation10_AppliedAmount] * fx10.[GBP]
	FROM NEW_CLIENT1_XEROBLUE_PrepaymentsSTAGE prepymt
	LEFT JOIN #FXTable fx ON fx.BaseCurrency = prepymt.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN prepymt.[Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Date] 
								END
	LEFT JOIN #FXTable fx1 ON fx1.BaseCurrency = prepymt.CurrencyCode 
				AND fx1.[Date] = CASE 
									WHEN prepymt.[Allocation1_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation1_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation1_Date] 
								END
	LEFT JOIN #FXTable fx2 ON fx2.BaseCurrency = prepymt.CurrencyCode 
				AND fx2.[Date] = CASE 
									WHEN prepymt.[Allocation2_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation2_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation2_Date] 
								END
	LEFT JOIN #FXTable fx3 ON fx3.BaseCurrency = prepymt.CurrencyCode 
				AND fx3.[Date] = CASE 
									WHEN prepymt.[Allocation3_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation3_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation3_Date] 
								END
	LEFT JOIN #FXTable fx4 ON fx4.BaseCurrency = prepymt.CurrencyCode 
				AND fx4.[Date] = CASE 
									WHEN prepymt.[Allocation4_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation4_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation4_Date] 
								END
	LEFT JOIN #FXTable fx5 ON fx5.BaseCurrency = prepymt.CurrencyCode 
				AND fx5.[Date] = CASE 
									WHEN prepymt.[Allocation5_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation5_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation5_Date] 
								END
	LEFT JOIN #FXTable fx6 ON fx6.BaseCurrency = prepymt.CurrencyCode 
				AND fx6.[Date] = CASE 
									WHEN prepymt.[Allocation6_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation6_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation6_Date] 
								END
	LEFT JOIN #FXTable fx7 ON fx7.BaseCurrency = prepymt.CurrencyCode 
				AND fx7.[Date] = CASE 
									WHEN prepymt.[Allocation7_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation7_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation7_Date] 
								END
	LEFT JOIN #FXTable fx8 ON fx8.BaseCurrency = prepymt.CurrencyCode 
				AND fx8.[Date] = CASE 
									WHEN prepymt.[Allocation8_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation8_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation8_Date] 
								END
	LEFT JOIN #FXTable fx9 ON fx9.BaseCurrency = prepymt.CurrencyCode 
				AND fx9.[Date] = CASE 
									WHEN prepymt.[Allocation9_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation9_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation9_Date] 
								END
	LEFT JOIN #FXTable fx10 ON fx10.BaseCurrency = prepymt.CurrencyCode 
				AND fx10.[Date] = CASE 
									WHEN prepymt.[Allocation10_Date] <= @minDate THEN @minDate 
									WHEN prepymt.[Allocation10_Date] >= @maxDate THEN @maxDate
									ELSE prepymt.[Allocation10_Date] 
								END
	WHERE prepymt.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_Prepayments 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Prepayments 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_PrepaymentsSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
	
	IF OBJECT_ID('tempdb..#FXTable') IS NOT NULL
	BEGIN
		DROP TABLE #FXTable
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Prepayments', 'NEW_CLIENT1_XEROBLUE_PrepaymentsSTAGE'
GO


--XEROBLUE_ManualJournals - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ManualJournals', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ManualJournals
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ManualJournals
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#ManualJournals') IS NOT NULL
	BEGIN
		DROP TABLE #ManualJournals
	END
	
	SELECT
        Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ManualJournalId ORDER BY ManualJournalId, [Date]),'|',ManualJournalId)
        ,ManualJournalId
        ,Narration
        ,JournalLine_LineAmount = jJournalLine_LineAmount
        ,JournalLine_AccountCode = jJournalLine_AccountCode
        ,JournalLine_Description = jJournalLine_Description
        ,JournalLine_TaxType = jJournalLine_TaxType
        ,JournalLine_TaxAmount = jJournalLine_TaxAmount
        ,JournalLine_TrackingCategory1_CategoryId = jJournalLine_TrackingCategory1_CategoryId
        ,JournalLine_TrackingCategory1_CategoryName = jJournalLine_TrackingCategory1_CategoryName
        ,JournalLine_TrackingCategory1_OptionId = jJournalLine_TrackingCategory1_OptionId
        ,JournalLine_TrackingCategory1_OptionName = jJournalLine_TrackingCategory1_OptionName
        ,JournalLine_TrackingCategory1_Option_Stat = jJournalLine_TrackingCategory1_Option_Stat
        ,JournalLine_TrackingCategory2_CategoryId = jJournalLine_TrackingCategory2_CategoryId
        ,JournalLine_TrackingCategory2_CategoryName = jJournalLine_TrackingCategory2_CategoryName
        ,JournalLine_TrackingCategory2_OptionId = jJournalLine_TrackingCategory2_OptionId
        ,JournalLine_TrackingCategory2_OptionName = jJournalLine_TrackingCategory2_OptionName
        ,JournalLine_TrackingCategory2_Option_Stat = jJournalLine_TrackingCategory2_Option_Stat
        ,JournalLineAggregate = NULL
        ,Date
        ,Status
        ,URL
        ,ShowOnCashBasisReports
        ,LineAmountTypes
        ,UpdatedDateUTC
        ,HasAttachments
        ,ClientID
        ,OrganisationID
	    ,[JournalLine_TaxAmount_AUD]
	    ,[JournalLine_TaxAmount_USD]
	    ,[JournalLine_TaxAmount_NZD]
	    ,[JournalLine_TaxAmount_EUR]
	    ,[JournalLine_TaxAmount_GBP]
	    ,[JournalLine_LineAmount_AUD]
	    ,[JournalLine_LineAmount_USD]
	    ,[JournalLine_LineAmount_NZD]
	    ,[JournalLine_LineAmount_EUR]
	    ,[JournalLine_LineAmount_GBP]
    INTO #ManualJournals
    FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE
    CROSS APPLY OPENJSON(JournalLineAggregate)
    WITH(
            jJournalLine_LineAmount NUMERIC(30,6) '$.LineAmount'
            ,jJournalLine_AccountCode NVARCHAR(100) '$.AccountCode'
            ,jJournalLine_Description NVARCHAR(4000) '$.Description'
            ,jJournalLine_TaxType NVARCHAR(100) '$.TaxType'
            ,jJournalLine_TaxAmount NUMERIC(30,6) '$.TaxAmount'
            ,jJournalLine_TrackingCategory1_CategoryId NVARCHAR(100) '$.Tracking[0].TrackingCategoryID'
            ,jJournalLine_TrackingCategory1_CategoryName NVARCHAR(255) '$.Tracking[0].Name'
            ,jJournalLine_TrackingCategory1_OptionId NVARCHAR(100) '$.Tracking[0].TrackingOptionID'
            ,jJournalLine_TrackingCategory1_OptionName NVARCHAR(255) '$.Tracking[0].Option'
            ,jJournalLine_TrackingCategory1_Option_Stat NVARCHAR(100) '$.Tracking[0].Status'
            ,jJournalLine_TrackingCategory2_CategoryId NVARCHAR(100) '$.Tracking[1].TrackingCategoryID'
            ,jJournalLine_TrackingCategory2_CategoryName NVARCHAR(255) '$.Tracking[1].Name'
            ,jJournalLine_TrackingCategory2_OptionId NVARCHAR(100) '$.Tracking[1].TrackingOptionID'
            ,jJournalLine_TrackingCategory2_OptionName NVARCHAR(255) '$.Tracking[1].Option'
            ,jJournalLine_TrackingCategory2_Option_Stat NVARCHAR(100) '$.Tracking[1].Status'
        )
    WHERE OrganisationId = @OrganisationID
    INSERT INTO #ManualJournals
    SELECT
        Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ManualJournalId ORDER BY ManualJournalId, [Date]),'|',ManualJournalId)
        ,ManualJournalId
        ,Narration
        ,JournalLine_LineAmount
        ,JournalLine_AccountCode
        ,JournalLine_Description
        ,JournalLine_TaxType
        ,JournalLine_TaxAmount
        ,JournalLine_TrackingCategory1_CategoryId
        ,JournalLine_TrackingCategory1_CategoryName
        ,JournalLine_TrackingCategory1_OptionId
        ,JournalLine_TrackingCategory1_OptionName
        ,JournalLine_TrackingCategory1_Option_Stat
        ,JournalLine_TrackingCategory2_CategoryId
        ,JournalLine_TrackingCategory2_CategoryName
        ,JournalLine_TrackingCategory2_OptionId
        ,JournalLine_TrackingCategory2_OptionName
        ,JournalLine_TrackingCategory2_Option_Stat
        ,JournalLineAggregate = NULL
        ,Date
        ,Status
        ,URL
        ,ShowOnCashBasisReports
        ,LineAmountTypes
        ,UpdatedDateUTC
        ,HasAttachments
        ,ClientID
        ,OrganisationID
	    ,[JournalLine_TaxAmount_AUD]
	    ,[JournalLine_TaxAmount_USD]
	    ,[JournalLine_TaxAmount_NZD]
	    ,[JournalLine_TaxAmount_EUR]
	    ,[JournalLine_TaxAmount_GBP]
	    ,[JournalLine_LineAmount_AUD]
	    ,[JournalLine_LineAmount_USD]
	    ,[JournalLine_LineAmount_NZD]
	    ,[JournalLine_LineAmount_EUR]
	    ,[JournalLine_LineAmount_GBP]
    FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE
    WHERE JournalLineAggregate = '[]' AND OrganisationId = @OrganisationID;

	DELETE FROM NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE WHERE OrganisationId = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE
	SELECT * FROM #ManualJournals;

	UPDATE mnljrnl
	SET  [JournalLine_LineAmount_AUD] = [JournalLine_LineAmount] * [AUD]
		,[JournalLine_LineAmount_USD] = [JournalLine_LineAmount] * [USD]
		,[JournalLine_LineAmount_NZD] = [JournalLine_LineAmount] * [NZD]
		,[JournalLine_LineAmount_EUR] = [JournalLine_LineAmount] * [EUR]
		,[JournalLine_LineAmount_GBP] = [JournalLine_LineAmount] * [GBP]
		,[JournalLine_TaxAmount_AUD] = [JournalLine_TaxAmount] * [AUD]
		,[JournalLine_TaxAmount_USD] = [JournalLine_TaxAmount] * [USD]
		,[JournalLine_TaxAmount_NZD] = [JournalLine_TaxAmount] * [NZD]
		,[JournalLine_TaxAmount_EUR] = [JournalLine_TaxAmount] * [EUR]
		,[JournalLine_TaxAmount_GBP] = [JournalLine_TaxAmount] * [GBP]
	FROM NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE mnljrnl
	LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = mnljrnl.OrganisationID
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = org.BaseCurrency 
				AND fx.[Date] = CASE 
									WHEN mnljrnl.[Date] <= @minDate THEN @minDate 
									WHEN mnljrnl.[Date] >= @maxDate THEN @maxDate
									ELSE mnljrnl.[Date] 
								END
	WHERE mnljrnl.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE TRG
        FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournals TRG
        INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE STG ON TRG.ManualJournalId = STG.ManualJournalId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ManualJournals
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#ManualJournals') IS NOT NULL
	BEGIN
		DROP TABLE #ManualJournals
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ManualJournals', 'NEW_CLIENT1_XEROBLUE_ManualJournalsSTAGE'
GO


--XEROBLUE_Transactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Transactions', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Transactions
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Transactions
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_TransactionsSTAGE 
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
    FROM NEW_CLIENT1_XEROBLUE_CreditNotes C
    LEFT JOIN (
		SELECT DISTINCT
			CreditNoteId
			,InvoiceId
			,Dt
			,Amount
			,ClientID
			,OrganisationID
		FROM NEW_CLIENT1.XEROBLUETABLES_CreditnoteAllocations_AUD
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
    FROM NEW_CLIENT1_XEROBLUE_Invoices
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
        [CurrencyRate] = OP.[CurrencyRate],
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
    FROM NEW_CLIENT1_XEROBLUE_Overpayments OP
    LEFT JOIN (
        SELECT DISTINCT
            OverPaymentId
            ,InvoiceId
			,Dt
			,Amount
            ,[Client ID]
            ,[Organisation ID]
        FROM NEW_CLIENT1.XEROBLUETABLES_OverPaymentAllocation_AUD
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
    FROM NEW_CLIENT1_XEROBLUE_Prepayments PP
	LEFT JOIN (
		SELECT DISTINCT
			PrePaymentId
			,InvoiceId
			,Dt
			,Amount
			,[Client ID]
			,[Organisation ID]
		FROM NEW_CLIENT1.XEROBLUETABLES_PrePaymentAllocation_AUD
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
    FROM NEW_CLIENT1_XEROBLUE_ManualJournals
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
    FROM NEW_CLIENT1_XEROBLUE_BankTransactions
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
    FROM NEW_CLIENT1_XEROBLUE_Payments P
    LEFT JOIN NEW_CLIENT1_XEROBLUE_Invoices I 
        ON P.[InvoiceId] = I.[InvoiceId] AND P.[OrganisationID] = I.[OrganisationID]
    LEFT JOIN NEW_CLIENT1_Xeroblue_Creditnotes C
        ON P.[InvoiceId] = C.[CreditNoteID] AND P.[OrganisationID] = C.[OrganisationID]
    LEFT JOIN NEW_CLIENT1_Xeroblue_Prepayments PP
        ON P.[InvoiceId] = PP.[PrepaymentId] AND P.[OrganisationID] = PP.[OrganisationID]
    LEFT JOIN NEW_CLIENT1_Xeroblue_Overpayments OP
        ON P.[InvoiceId] = OP.[OverpaymentId] AND P.[OrganisationID] = OP.[OrganisationID]
    WHERE P.OrganisationID = @OrganisationID

    UPDATE trns
    SET
        trns.[Changes] = hist.[Changes],
        trns.Details = LEFT(hist.Details, 500),
        trns.[User] = hist.[User]
    FROM NEW_CLIENT1_XEROBLUE_TransactionsSTAGE trns
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
        FROM NEW_CLIENT1_XEROBLUEHN_Creditnotes
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
        FROM NEW_CLIENT1_XEROBLUEHN_Prepayments
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
        FROM NEW_CLIENT1_XEROBLUEHN_Overpayments
        WHERE OrganisationId = @OrganisationID AND [Changes] NOT IN ('Created')
        /*
        UNION ALL
        SELECT
			InvoiceId Id,
			[Changes],
			Details,
			[User],
			DateUTC,
			ClientID,
			OrganisationID,
			ROW_NUMBER() OVER(PARTITION BY InvoiceId ORDER BY DateUTC DESC) RN,
			'INVOICES' Source
		FROM NEW_CLIENT1_XEROBLUEHN_Invoices
		WHERE OrganisationId = @OrganisationID AND [Changes] NOT IN ('Created')
        */
    ) hist
    ON trns.Id = hist.Id and hist.RN = 1
    WHERE hist.Id is not null
    AND trns.OrganisationId = @OrganisationID

	BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_Transactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Transactions   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_TransactionsSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Transactions', 'NEW_CLIENT1_XEROBLUE_TransactionsSTAGE'
GO


--XEROBLUE_Journals - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Journals', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Journals
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Journals
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#Journals') IS NOT NULL
	BEGIN
		DROP TABLE #Journals
	END

	IF OBJECT_ID('tempdb..#JournalHistory') IS NOT NULL
	BEGIN
		DROP TABLE #JournalHistory
	END
	
	--Extract Journal LineItems
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY JournalId ORDER BY JournalDate),'|',JournalId)
		,JournalId
		,JournalDate
		,JournalNumber
		,CreatedDateUTC
		,Reference
		,SourceId
		,SourceType
		,JournalLine_JournalLineId = jJournalLine_JournalLineId
		,JournalLine_Description = jJournalLine_Description
		,JournalLine_AccountId = jJournalLine_AccountId
		,JournalLine_AccountCode = jJournalLine_AccountCode
		,JournalLine_AccountType = jJournalLine_AccountType
		,JournalLine_AccountName = jJournalLine_AccountName
		,JournalLine_NetAmount = jJournalLine_NetAmount
		,JournalLine_GrossAmount = jJournalLine_GrossAmount
		,JournalLine_TaxAmount = jJournalLine_TaxAmount
		,JournalLine_TaxType = jJournalLine_TaxType
		,JournalLine_TaxName = jJournalLine_TaxName
		,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
		,ClientID
		,OrganisationID
		,EtaniModifiedAfter
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
		,[InvoiceNumber]
		,[CreditNoteNumber]
	INTO #Journals
	FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE
	CROSS APPLY OPENJSON(JournalLine_JournalLineId)
	WITH(
			jJournalLine_JournalLineId NVARCHAR(100) '$.JournalLineID'
			,jJournalLine_Description NVARCHAR(4000) '$.Description'
			,jJournalLine_AccountId NVARCHAR(100) '$.AccountID'
			,jJournalLine_AccountCode NVARCHAR(100) '$.AccountCode'
			,jJournalLine_AccountType NVARCHAR(100) '$.AccountType'
			,jJournalLine_AccountName NVARCHAR(255) '$.AccountName'
			,jJournalLine_NetAmount NUMERIC(30,6) '$.NetAmount'
			,jJournalLine_GrossAmount NUMERIC(30,6) '$.GrossAmount'
			,jJournalLine_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jJournalLine_TaxType NVARCHAR(100) '$.TaxType'
			,jJournalLine_TaxName NVARCHAR(255) '$.TaxName'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.TrackingCategories[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.TrackingCategories[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.TrackingCategories[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.TrackingCategories[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.TrackingCategories[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.TrackingCategories[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.TrackingCategories[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.TrackingCategories[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.TrackingCategories[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.TrackingCategories[1].Status'
		)
	WHERE OrganisationId = @OrganisationID
	INSERT INTO #Journals
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY JournalId ORDER BY JournalDate),'|',JournalId)
		,JournalId
		,JournalDate
		,JournalNumber
		,CreatedDateUTC
		,Reference
		,SourceId
		,SourceType
		,JournalLine_JournalLineId = NULL
		,JournalLine_Description
		,JournalLine_AccountId
		,JournalLine_AccountCode
		,JournalLine_AccountType
		,JournalLine_AccountName
		,JournalLine_NetAmount
		,JournalLine_GrossAmount
		,JournalLine_TaxAmount
		,JournalLine_TaxType
		,JournalLine_TaxName
		,LineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat
		,ClientID
		,OrganisationID
		,EtaniModifiedAfter
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
		,[InvoiceNumber]
		,[CreditNoteNumber]
	FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE
    WHERE OrganisationId = @OrganisationID AND JournalLine_JournalLineId = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_JournalsSTAGE WHERE OrganisationId = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_JournalsSTAGE
	SELECT * FROM #Journals;

	--Update Additional Columns and FX columns
	UPDATE jrnl
	SET  
		 [JournalLine_NetAmount_AUD] = [JournalLine_NetAmount] * [AUD]
		,[JournalLine_NetAmount_USD] = [JournalLine_NetAmount] * [USD]
		,[JournalLine_NetAmount_NZD] = [JournalLine_NetAmount] * [NZD]
		,[JournalLine_NetAmount_EUR] = [JournalLine_NetAmount] * [EUR]
		,[JournalLine_NetAmount_GBP] = [JournalLine_NetAmount] * [GBP]
		,[JournalLine_GrossAmount_AUD] = [JournalLine_GrossAmount] * [AUD]
		,[JournalLine_GrossAmount_USD] = [JournalLine_GrossAmount] * [USD]
		,[JournalLine_GrossAmount_NZD] = [JournalLine_GrossAmount] * [NZD]
		,[JournalLine_GrossAmount_EUR] = [JournalLine_GrossAmount] * [EUR]
		,[JournalLine_GrossAmount_GBP] = [JournalLine_GrossAmount] * [GBP]
		,[JournalLine_TaxAmount_AUD] = [JournalLine_TaxAmount] * [AUD]
		,[JournalLine_TaxAmount_USD] = [JournalLine_TaxAmount] * [USD]
		,[JournalLine_TaxAmount_NZD] = [JournalLine_TaxAmount] * [NZD]
		,[JournalLine_TaxAmount_EUR] = [JournalLine_TaxAmount] * [EUR]
		,[JournalLine_TaxAmount_GBP] = [JournalLine_TaxAmount] * [GBP]
        ,[Split] = CAST(
                CASE 
                WHEN [SourceType] = 'ACCPAY' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCPAYCREDIT'THEN 'INVOICES' 
                WHEN [SourceType] = 'ACCPAYPAYMENT' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCREC' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCRECCREDIT' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCRECPAYMENT' THEN 'INVOICES' 
                WHEN [SourceType] = 'APCREDITPAYMENT' THEN 'INVOICES' 
                WHEN [SourceType] = 'ARCREDITPAYMENT' THEN 'INVOICES'
                ELSE 'JOURNALS' END AS varchar
            )
        ,[ContactID] = trns.[ContactID]
        ,[ContactName] = trns.[ContactName]
        ,[ContactSource] = trns.[Source]
        ,[PaymentSourceID] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentSourceID] ELSE NULL END
		,[PaymentType] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentType] ELSE NULL END
		,[ShowOnCashBasisReports] = trns.[ShowOnCashBasisReports]
		,[FullyPaidOnDate] = trns.[FullyPaidOnDate]
		,[DayDifference] = trns.[DayDifference]
		,[InvoiceNumber] = trns.[InvoiceNumber]
		,[CreditNoteNumber] = trns.[CreditNoteNumber]
	FROM NEW_CLIENT1_XEROBLUE_JournalsSTAGE jrnl
	LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = jrnl.OrganisationID
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = org.BaseCurrency 
				AND fx.[Date] = CASE 
									WHEN jrnl.[JournalDate] <= @minDate THEN @minDate 
									WHEN jrnl.[JournalDate] >= @maxDate THEN @maxDate
									ELSE jrnl.[JournalDate] 
								END
	LEFT JOIN dbo.NEW_CLIENT1_XEROBLUE_Transactions trns ON jrnl.SourceId = trns.Id
    WHERE jrnl.OrganisationID = @OrganisationID;

	/* Merge records to Production table */
	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsArchive TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE STG ON TRG.JournalId = STG.JournalId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_JournalsArchive
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_Journals TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE STG ON TRG.JournalId = STG.JournalId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Journals
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsNEW TRG
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_JournalsNEW
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE J
		FROM NEW_CLIENT1_XEROBLUE_JournalsNEW J
		LEFT JOIN (
			SELECT DISTINCT ID, Source, Status, OrganisationID FROM NEW_CLIENT1_XEROBLUE_Transactions
			WHERE Status IN ('VOIDED', 'DELETED')
		) DELETED ON DELETED.ID = J.SourceID AND DELETED.OrganisationID = J.OrganisationID
		LEFT JOIN (
			SELECT BankTransferID, OrganisationID FROM NEW_CLIENT1_XEROBLUE_BankTransfers
		) BT ON BT.BankTransferID = J.SourceID AND BT.OrganisationID = J.OrganisationID
		WHERE 
        (DELETED.ID IS NOT NULL 
        OR (J.SourceType = 'TRANSFER' 
        AND BT.BankTransferID IS NULL))
		AND J.OrganisationId = @OrganisationID;

	COMMIT;
	/* Merge records to Production table */

    --Get History of each Journal records
    SELECT jrnl.*, hist.[Changes], CAST(hist.Details AS NVARCHAR(500)) Details, hist.[User]
    INTO #JournalHistory
    FROM (
        SELECT j.*, DENSE_RANK() OVER(PARTITION BY j.SourceID ORDER BY j.JournalNumber) RN
        FROM (
            SELECT DISTINCT
                    JournalID,
                    JournalNumber,
                    CreatedDateUTC,
                    SourceID,
                    SourceType,
                    ContactSource,
                    JournalLine_AccountCode,
                    JournalLine_NetAmount
            FROM NEW_CLIENT1_XEROBLUE_JournalsArchive
            WHERE OrganisationId = @OrganisationID AND ContactSource IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS')
        ) j --order by j.SourceID,j.JournalNumber
    ) jrnl
    INNER JOIN (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY DateUTC) RN
        FROM (
            --CreditNoteId
            SELECT
                CreditNoteId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'CREDITNOTES' Source
            FROM NEW_CLIENT1_XEROBLUEHN_Creditnotes
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT
                CreditNoteId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'CREDITNOTES' Source
            FROM NEW_CLIENT1_XEROBLUEHN_Creditnotes
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
            --Prepayments
            UNION ALL
            SELECT 
                PrepaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'PREPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Prepayments
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT 
                PrepaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'PREPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Prepayments
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
            --Overpayments
            UNION ALL
            SELECT 
                OverpaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'OVERPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Overpayments
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT 
                OverpaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'OVERPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Overpayments
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
        ) A
    ) hist
    ON jrnl.SourceID = hist.Id AND jrnl.RN = hist.RN;

    --Update Journal table with history value (Changes)
	UPDATE jrnl
    SET
        jrnl.[Changes] = jh.[Changes],
        jrnl.[User] = jh.[User],
        jrnl.[Details] = jh.[Details]
    FROM NEW_CLIENT1_XEROBLUE_Journals jrnl
    INNER JOIN #JournalHistory jh
    ON jh.JournalID = jrnl.JournalID
    WHERE OrganisationID = @OrganisationID;

    UPDATE jrnl
    SET
        jrnl.[Changes] = jh.[Changes],
        jrnl.[User] = jh.[User],
        jrnl.[Details] = jh.[Details]
    FROM NEW_CLIENT1_XEROBLUE_JournalsNEW jrnl
    INNER JOIN #JournalHistory jh
    ON jh.JournalID = jrnl.JournalID
    WHERE OrganisationID = @OrganisationID;

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
	FROM NEW_CLIENT1_XEROBLUE_Journals jrnl
	LEFT JOIN NEW_CLIENT1_XEROBLUE_Accounts acc
		ON jrnl.OrganisationID = acc.OrganisationID
		and jrnl.JournalLine_AccountCode = acc.Code
	INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_Transactions trns 
		ON jrnl.SourceId = trns.Id 
		and jrnl.OrganisationID = trns.OrganisationID
		and jrnl.JournalDate = trns.AllocationDate
		and ABS(jrnl.[JournalLine_NetAmount]) = ABS(trns.AllocationAmount)
	WHERE 
        jrnl.OrganisationID = @OrganisationID
    AND ContactSource NOT IN ('INVOICES','PAYMENTS');

    --Delete journals without history
    DELETE FROM NEW_CLIENT1_XEROBLUE_JournalsNEW
    WHERE OrganisationID = @OrganisationID
    AND ContactSource IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS') 
    AND [Changes] IS NULL;

    --Delete Journals with duplicate SourceIds where changes made in (Approved, Edited)
    DELETE jrnl 
    FROM NEW_CLIENT1_XEROBLUE_JournalsNEW jrnl
    INNER JOIN (
        SELECT 
            jrnl.*,
            LagJrnl.JournalLine_AccountCode LagJournalLine_AccountCode,
            LagJrnl.JournalLine_NetAmount LagJournalLine_NetAmount,
            LeadJrnl.JournalLine_AccountCode LeadJournalLine_AccountCode,
            LeadJrnl.JournalLine_NetAmount LeadJournalLine_NetAmount,
            CASE 
                WHEN LagJrnl2.JournalNumber IS NOT NULL THEN 'N'
                WHEN LagJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                WHEN LeadJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                ELSE 'N'
            END AS ToDelete
        FROM (
            SELECT 
                distinctjrnl.*,
                jrnlamt.JournalLine_AccountCode,
                jrnlamt.JournalLine_NetAmount
            FROM (
                SELECT
                    *,
                    LAG(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LagJournalNumber,
                    LEAD(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LeadJournalNumber
                FROM (
                    SELECT DISTINCT
                        JournalNumber, 
                        SourceId, 
                        Changes
                    FROM #JournalHistory
                    WHERE Changes IN ('Approved', 'Edited')
                ) distinctjrnlhist
            )distinctjrnl
            INNER JOIN #JournalHistory jrnlamt
            ON jrnlamt.SourceId = distinctjrnl.SourceId
            AND jrnlamt.JournalNumber = distinctjrnl.JournalNumber
        ) jrnl
        LEFT JOIN #JournalHistory LagJrnl
            ON LagJrnl.SourceId = jrnl.SourceId
            AND LagJrnl.JournalNumber = jrnl.LagJournalNumber
            AND LagJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LagJournalNumber
        LEFT JOIN #JournalHistory LeadJrnl
            ON LeadJrnl.SourceId = jrnl.SourceId
            AND LeadJrnl.JournalNumber = jrnl.LeadJournalNumber
            AND LeadJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LeadJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LeadJournalNumber
            AND LagJrnl.JournalLine_NetAmount IS NULL
        LEFT JOIN #JournalHistory LagJrnl2
            ON LagJrnl.SourceId = LagJrnl2.SourceId
            AND LagJrnl.JournalLine_AccountCode = LagJrnl2.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = LagJrnl2.JournalLine_NetAmount*-1
            AND LagJrnl.JournalNumber > LagJrnl2.JournalNumber
            AND LagJrnl2.Changes IN ('Approved', 'Edited')
    ) jrnltodel
        ON jrnl.SourceId = jrnltodel.SourceId
        AND jrnl.JournalNumber = jrnltodel.JournalNumber
        AND jrnl.JournalLine_AccountCode = jrnltodel.JournalLine_AccountCode
        AND jrnl.JournalLine_NetAmount = jrnltodel.JournalLine_NetAmount
        AND jrnltodel.ToDelete = 'Y'
    WHERE jrnl.OrganisationID = @OrganisationID;

    --Delete Journals with duplicate SourceIds where changes made in (Applied, Credited, Credit Reversed)
    DELETE jrnl 
    FROM NEW_CLIENT1_XEROBLUE_JournalsNEW jrnl
    INNER JOIN (
        SELECT 
            jrnl.*,
            LagJrnl.JournalLine_AccountCode LagJournalLine_AccountCode,
            LagJrnl.JournalLine_NetAmount LagJournalLine_NetAmount,
            LeadJrnl.JournalLine_AccountCode LeadJournalLine_AccountCode,
            LeadJrnl.JournalLine_NetAmount LeadJournalLine_NetAmount,
            CASE 
                WHEN LagJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                WHEN LeadJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                ELSE 'N'
            END AS ToDelete
        FROM (
            SELECT 
                distinctjrnl.*,
                jrnlamt.JournalLine_AccountCode,
                jrnlamt.JournalLine_NetAmount
            FROM (
                SELECT
                    *,
                    LAG(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LagJournalNumber,
                    LEAD(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LeadJournalNumber
                FROM (
                    SELECT DISTINCT
                        JournalNumber, 
                        SourceId, 
                        Changes
                    FROM #JournalHistory
                    WHERE Changes IN ('Applied','Credited', 'Credit Reversed')
                ) distinctjrnlhist
            )distinctjrnl
            INNER JOIN #JournalHistory jrnlamt
            ON jrnlamt.SourceId = distinctjrnl.SourceId
            AND jrnlamt.JournalNumber = distinctjrnl.JournalNumber
        ) jrnl
        LEFT JOIN #JournalHistory LagJrnl
            ON LagJrnl.SourceId = jrnl.SourceId
            AND LagJrnl.JournalNumber = jrnl.LagJournalNumber
            AND LagJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LagJournalNumber
            AND LagJrnl.Changes <> 'Credit Reversed'
        LEFT JOIN #JournalHistory LeadJrnl
        ON LeadJrnl.SourceId = jrnl.SourceId
        AND LeadJrnl.JournalNumber = jrnl.LeadJournalNumber
        AND LeadJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
        AND LeadJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
        AND jrnl.JournalNumber <> jrnl.LeadJournalNumber
        AND LeadJrnl.Changes = 'Credit Reversed'
    ) jrnltodel
        ON jrnl.SourceId = jrnltodel.SourceId
        AND jrnl.JournalNumber = jrnltodel.JournalNumber
        AND jrnl.JournalLine_AccountCode = jrnltodel.JournalLine_AccountCode
        AND jrnl.JournalLine_NetAmount = jrnltodel.JournalLine_NetAmount
        AND jrnltodel.ToDelete = 'Y'
    WHERE jrnl.OrganisationID = @OrganisationID;

	--Delete Journals with duplicate SourceIds where contact source is not NULL and not in (Creditnotes, Prepayments, Overpayments)
	DELETE jrnl
	FROM NEW_CLIENT1_XEROBLUE_JournalsNEW jrnl
	LEFT JOIN (
		SELECT DISTINCT
			JournalId,
			SourceID,
			JournalNumber,
			ContactSource,
			DENSE_RANK() OVER(PARTITION BY SourceId ORDER BY SourceID,JournalNumber DESC) RN
		FROM NEW_CLIENT1_XEROBLUE_JournalsNEW
		WHERE 
		ContactSource NOT IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS') 
		AND ContactSource IS NOT NULL
		AND OrganisationID = @OrganisationID
	) del
	ON jrnl.JournalId = del.JournalId
	WHERE 
	(RN > 1 OR JournalLine_JournalLineId IS NULL)
	AND jrnl.OrganisationID = @OrganisationID;

	IF OBJECT_ID('tempdb..#Journals') IS NOT NULL
	BEGIN
		DROP TABLE #Journals
	END

	IF OBJECT_ID('tempdb..#JournalHistory') IS NOT NULL
	BEGIN
		DROP TABLE #JournalHistory
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Journals', 'NEW_CLIENT1_XEROBLUE_JournalsSTAGE'
GO


--XEROBLUE_JournalsCash - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_JournalsCash', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_JournalsCash
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_JournalsCash
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#Journals') IS NOT NULL
	BEGIN
		DROP TABLE #Journals
	END

	IF OBJECT_ID('tempdb..#DeletedJournals') IS NOT NULL
	BEGIN
		DROP TABLE #DeletedJournals
	END

	--Extract Journal LineItems
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY JournalId ORDER BY JournalDate),'|',JournalId)
		,JournalId
		,JournalDate
		,JournalNumber
		,CreatedDateUTC
		,Reference
		,SourceId
		,SourceType
		,JournalLine_JournalLineId = jJournalLine_JournalLineId
		,JournalLine_Description = jJournalLine_Description
		,JournalLine_AccountId = jJournalLine_AccountId
		,JournalLine_AccountCode = jJournalLine_AccountCode
		,JournalLine_AccountType = jJournalLine_AccountType
		,JournalLine_AccountName = jJournalLine_AccountName
		,JournalLine_NetAmount = jJournalLine_NetAmount
		,JournalLine_GrossAmount = jJournalLine_GrossAmount
		,JournalLine_TaxAmount = jJournalLine_TaxAmount
		,JournalLine_TaxType = jJournalLine_TaxType
		,JournalLine_TaxName = jJournalLine_TaxName
		,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
		,ClientID
		,OrganisationID
		,EtaniModifiedAfter
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
		,[InvoiceNumber]
		,[CreditNoteNumber]
	INTO #Journals
	FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
	CROSS APPLY OPENJSON(JournalLine_JournalLineId)
	WITH(
			jJournalLine_JournalLineId NVARCHAR(100) '$.JournalLineID'
			,jJournalLine_Description NVARCHAR(4000) '$.Description'
			,jJournalLine_AccountId NVARCHAR(100) '$.AccountID'
			,jJournalLine_AccountCode NVARCHAR(100) '$.AccountCode'
			,jJournalLine_AccountType NVARCHAR(100) '$.AccountType'
			,jJournalLine_AccountName NVARCHAR(255) '$.AccountName'
			,jJournalLine_NetAmount NUMERIC(30,6) '$.NetAmount'
			,jJournalLine_GrossAmount NUMERIC(30,6) '$.GrossAmount'
			,jJournalLine_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jJournalLine_TaxType NVARCHAR(100) '$.TaxType'
			,jJournalLine_TaxName NVARCHAR(255) '$.TaxName'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.TrackingCategories[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.TrackingCategories[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.TrackingCategories[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.TrackingCategories[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.TrackingCategories[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.TrackingCategories[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.TrackingCategories[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.TrackingCategories[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.TrackingCategories[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.TrackingCategories[1].Status'
		)
	WHERE OrganisationId = @OrganisationID
	INSERT INTO #Journals
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY JournalId ORDER BY JournalDate),'|',JournalId)
		,JournalId
		,JournalDate
		,JournalNumber
		,CreatedDateUTC
		,Reference
		,SourceId
		,SourceType
		,JournalLine_JournalLineId = NULL
		,JournalLine_Description
		,JournalLine_AccountId
		,JournalLine_AccountCode
		,JournalLine_AccountType
		,JournalLine_AccountName
		,JournalLine_NetAmount
		,JournalLine_GrossAmount
		,JournalLine_TaxAmount
		,JournalLine_TaxType
		,JournalLine_TaxName
		,LineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat
		,ClientID
		,OrganisationID
		,EtaniModifiedAfter
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
		,[InvoiceNumber]
		,[CreditNoteNumber]
	FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
    WHERE OrganisationId = @OrganisationID AND JournalLine_JournalLineId = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE WHERE OrganisationId = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
	SELECT * FROM #Journals;

	--Update Additional Columns and FX columns
	UPDATE jrnl
	SET  [JournalLine_NetAmount_AUD] = [JournalLine_NetAmount] * [AUD]
		,[JournalLine_NetAmount_USD] = [JournalLine_NetAmount] * [USD]
		,[JournalLine_NetAmount_NZD] = [JournalLine_NetAmount] * [NZD]
		,[JournalLine_NetAmount_EUR] = [JournalLine_NetAmount] * [EUR]
		,[JournalLine_NetAmount_GBP] = [JournalLine_NetAmount] * [GBP]
		,[JournalLine_GrossAmount_AUD] = [JournalLine_GrossAmount] * [AUD]
		,[JournalLine_GrossAmount_USD] = [JournalLine_GrossAmount] * [USD]
		,[JournalLine_GrossAmount_NZD] = [JournalLine_GrossAmount] * [NZD]
		,[JournalLine_GrossAmount_EUR] = [JournalLine_GrossAmount] * [EUR]
		,[JournalLine_GrossAmount_GBP] = [JournalLine_GrossAmount] * [GBP]
		,[JournalLine_TaxAmount_AUD] = [JournalLine_TaxAmount] * [AUD]
		,[JournalLine_TaxAmount_USD] = [JournalLine_TaxAmount] * [USD]
		,[JournalLine_TaxAmount_NZD] = [JournalLine_TaxAmount] * [NZD]
		,[JournalLine_TaxAmount_EUR] = [JournalLine_TaxAmount] * [EUR]
		,[JournalLine_TaxAmount_GBP] = [JournalLine_TaxAmount] * [GBP]
        ,[Split] = CAST(
                CASE 
                WHEN [SourceType] = 'ACCPAY' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCPAYCREDIT'THEN 'INVOICES' 
                WHEN [SourceType] = 'ACCPAYPAYMENT' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCREC' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCRECCREDIT' THEN 'INVOICES'
                WHEN [SourceType] = 'ACCRECPAYMENT' THEN 'INVOICES' 
                WHEN [SourceType] = 'APCREDITPAYMENT' THEN 'INVOICES' 
                WHEN [SourceType] = 'ARCREDITPAYMENT' THEN 'INVOICES'
                ELSE 'JOURNALS' END AS varchar
            )
        ,[ContactID] = trns.[ContactID]
        ,[ContactName] = trns.[ContactName]
		,[ContactSource] = trns.[Source]
		,[PaymentSourceID] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentSourceID] ELSE NULL END
		,[PaymentType] = CASE WHEN trns.[Source] = 'PAYMENTS' THEN trns.[PaymentType] ELSE NULL END
		,[ShowOnCashBasisReports] = trns.[ShowOnCashBasisReports]
		,[FullyPaidOnDate] = trns.[FullyPaidOnDate]
		,[DayDifference] = trns.[DayDifference]
		,[InvoiceNumber] = trns.[InvoiceNumber]
		,[CreditNoteNumber] = trns.[CreditNoteNumber]
	FROM NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE jrnl
	LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = jrnl.OrganisationID
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = org.BaseCurrency 
				AND fx.[Date] = CASE 
									WHEN jrnl.[JournalDate] <= @minDate THEN @minDate 
									WHEN jrnl.[JournalDate] >= @maxDate THEN @maxDate
									ELSE jrnl.[JournalDate] 
								END
	LEFT JOIN dbo.NEW_CLIENT1_XEROBLUE_Transactions trns ON jrnl.SourceId = trns.Id
    WHERE jrnl.OrganisationID = @OrganisationID;
    
	
	/* Merge records to Production table */
	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashArchive TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE STG ON TRG.JournalId = STG.JournalId
		WHERE TRG.OrganisationId = @OrganisationID;
		
		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_JournalsCashArchive 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCash TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE STG ON TRG.JournalId = STG.JournalId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_JournalsCash 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashNEW TRG
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_JournalsCashNEW 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE
		WHERE OrganisationId = @OrganisationID;

		DELETE J
		FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW J
		LEFT JOIN (
			SELECT DISTINCT ID, Source, Status, OrganisationID FROM NEW_CLIENT1_XEROBLUE_Transactions
			WHERE Status IN ('VOIDED', 'DELETED')
		) DELETED ON DELETED.ID = J.SourceID AND DELETED.OrganisationID = J.OrganisationID
		LEFT JOIN (
			SELECT BankTransferID, OrganisationID FROM NEW_CLIENT1_XEROBLUE_BankTransfers
		) BT ON BT.BankTransferID = J.SourceID AND BT.OrganisationID = J.OrganisationID
		WHERE 
        (DELETED.ID IS NOT NULL 
        OR (J.SourceType = 'TRANSFER' 
        AND BT.BankTransferID IS NULL))
		AND J.OrganisationId = @OrganisationID;

	COMMIT;
	/* Merge records to Production table */

    --Get History of each Journal records
    SELECT jrnl.*, hist.[Changes], CAST(hist.Details AS NVARCHAR(500)) Details, hist.[User]
    INTO #JournalHistory
    FROM (
        SELECT j.*, DENSE_RANK() OVER(PARTITION BY j.SourceID ORDER BY j.JournalNumber) RN
        FROM (
            SELECT DISTINCT
                    JournalID,
                    JournalNumber,
                    CreatedDateUTC,
                    SourceID,
                    SourceType,
                    ContactSource,
                    JournalLine_AccountCode,
                    JournalLine_NetAmount
            FROM NEW_CLIENT1_XEROBLUE_JournalsCashArchive
            WHERE OrganisationId = @OrganisationID AND ContactSource IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS')
        ) j --order by j.SourceID,j.JournalNumber
    ) jrnl
    INNER JOIN (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY Id ORDER BY DateUTC) RN
        FROM (
            --CreditNoteId
            SELECT
                CreditNoteId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'CREDITNOTES' Source
            FROM NEW_CLIENT1_XEROBLUEHN_Creditnotes
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT
                CreditNoteId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'CREDITNOTES' Source
            FROM NEW_CLIENT1_XEROBLUEHN_Creditnotes
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
            --Prepayments
            UNION ALL
            SELECT 
                PrepaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'PREPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Prepayments
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT 
                PrepaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'PREPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Prepayments
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
            --Overpayments
            UNION ALL
            SELECT 
                OverpaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'OVERPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Overpayments
            WHERE OrganisationId = @OrganisationID AND Changes NOT IN ('Created','File uploaded')
            UNION ALL
            SELECT 
                OverpaymentId Id,
                [Changes],
                Details,
                [User],
                DateUTC,
                ClientID,
                OrganisationID,
                'OVERPAYMENTS'
            FROM NEW_CLIENT1_XEROBLUEHN_Overpayments
            WHERE OrganisationId = @OrganisationID AND Changes IN ('Edited')
        ) A
    ) hist
    ON jrnl.SourceID = hist.Id AND jrnl.RN = hist.RN;

    --Update Journal table with history value (Changes)
    UPDATE jrnl
    SET
        jrnl.[Changes] = jh.[Changes],
        jrnl.[User] = jh.[User],
        jrnl.[Details] = jh.[Details]
    FROM NEW_CLIENT1_XEROBLUE_JournalsCash jrnl
    INNER JOIN #JournalHistory jh
    ON jh.JournalID = jrnl.JournalID
    WHERE OrganisationID = @OrganisationID;

    UPDATE jrnl
    SET
        jrnl.[Changes] = jh.[Changes],
        jrnl.[User] = jh.[User],
        jrnl.[Details] = jh.[Details]
    FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW jrnl
    INNER JOIN #JournalHistory jh
    ON jh.JournalID = jrnl.JournalID
    WHERE OrganisationID = @OrganisationID;


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
	FROM NEW_CLIENT1_XEROBLUE_JournalsCash jrnl
	LEFT JOIN NEW_CLIENT1_XEROBLUE_Accounts acc
		ON jrnl.OrganisationID = acc.OrganisationID
		and jrnl.JournalLine_AccountCode = acc.Code
	INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_Transactions trns 
		ON jrnl.SourceId = trns.Id 
		and jrnl.OrganisationID = trns.OrganisationID
		and jrnl.JournalDate = trns.AllocationDate
		and ABS(jrnl.[JournalLine_NetAmount]) = ABS(trns.AllocationAmount)
	WHERE 
        jrnl.OrganisationID = @OrganisationID
    AND ContactSource NOT IN ('INVOICES','PAYMENTS');

    --Delete journals without history
    DELETE FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW
    WHERE OrganisationID = @OrganisationID
    AND ContactSource IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS') 
    AND [Changes] IS NULL;

    --Delete Journals with duplicate SourceIds where changes made in (Approved, Edited)
    DELETE jrnl 
    FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW jrnl
    INNER JOIN (
        SELECT 
            jrnl.*,
            LagJrnl.JournalLine_AccountCode LagJournalLine_AccountCode,
            LagJrnl.JournalLine_NetAmount LagJournalLine_NetAmount,
            LeadJrnl.JournalLine_AccountCode LeadJournalLine_AccountCode,
            LeadJrnl.JournalLine_NetAmount LeadJournalLine_NetAmount,
            CASE 
                WHEN LagJrnl2.JournalNumber IS NOT NULL THEN 'N'
                WHEN LagJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                WHEN LeadJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                ELSE 'N'
            END AS ToDelete
        FROM (
            SELECT 
                distinctjrnl.*,
                jrnlamt.JournalLine_AccountCode,
                jrnlamt.JournalLine_NetAmount
            FROM (
                SELECT
                    *,
                    LAG(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LagJournalNumber,
                    LEAD(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LeadJournalNumber
                FROM (
                    SELECT DISTINCT
                        JournalNumber, 
                        SourceId, 
                        Changes
                    FROM #JournalHistory
                    WHERE Changes IN ('Approved', 'Edited')
                ) distinctjrnlhist
            )distinctjrnl
            INNER JOIN #JournalHistory jrnlamt
            ON jrnlamt.SourceId = distinctjrnl.SourceId
            AND jrnlamt.JournalNumber = distinctjrnl.JournalNumber
        ) jrnl
        LEFT JOIN #JournalHistory LagJrnl
            ON LagJrnl.SourceId = jrnl.SourceId
            AND LagJrnl.JournalNumber = jrnl.LagJournalNumber
            AND LagJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LagJournalNumber
        LEFT JOIN #JournalHistory LeadJrnl
            ON LeadJrnl.SourceId = jrnl.SourceId
            AND LeadJrnl.JournalNumber = jrnl.LeadJournalNumber
            AND LeadJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LeadJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LeadJournalNumber
            AND LagJrnl.JournalLine_NetAmount IS NULL
        LEFT JOIN #JournalHistory LagJrnl2
            ON LagJrnl.SourceId = LagJrnl2.SourceId
            AND LagJrnl.JournalLine_AccountCode = LagJrnl2.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = LagJrnl2.JournalLine_NetAmount*-1
            AND LagJrnl.JournalNumber > LagJrnl2.JournalNumber
            AND LagJrnl2.Changes IN ('Approved', 'Edited')
    ) jrnltodel
        ON jrnl.SourceId = jrnltodel.SourceId
        AND jrnl.JournalNumber = jrnltodel.JournalNumber
        AND jrnl.JournalLine_AccountCode = jrnltodel.JournalLine_AccountCode
        AND jrnl.JournalLine_NetAmount = jrnltodel.JournalLine_NetAmount
        AND jrnltodel.ToDelete = 'Y'
    WHERE jrnl.OrganisationID = @OrganisationID;

    --Delete Journals with duplicate SourceIds where changes made in (Applied, Credited, Credit Reversed)
    DELETE jrnl 
    FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW jrnl
    INNER JOIN (
        SELECT 
            jrnl.*,
            LagJrnl.JournalLine_AccountCode LagJournalLine_AccountCode,
            LagJrnl.JournalLine_NetAmount LagJournalLine_NetAmount,
            LeadJrnl.JournalLine_AccountCode LeadJournalLine_AccountCode,
            LeadJrnl.JournalLine_NetAmount LeadJournalLine_NetAmount,
            CASE 
                WHEN LagJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                WHEN LeadJrnl.JournalLine_NetAmount IS NOT NULL THEN 'Y'
                ELSE 'N'
            END AS ToDelete
        FROM (
            SELECT 
                distinctjrnl.*,
                jrnlamt.JournalLine_AccountCode,
                jrnlamt.JournalLine_NetAmount
            FROM (
                SELECT
                    *,
                    LAG(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LagJournalNumber,
                    LEAD(JournalNumber) OVER (PARTITION BY SourceId ORDER BY JournalNumber) LeadJournalNumber
                FROM (
                    SELECT DISTINCT
                        JournalNumber, 
                        SourceId, 
                        Changes
                    FROM #JournalHistory
                    WHERE Changes IN ('Applied','Credited', 'Credit Reversed')
                ) distinctjrnlhist
            )distinctjrnl
            INNER JOIN #JournalHistory jrnlamt
            ON jrnlamt.SourceId = distinctjrnl.SourceId
            AND jrnlamt.JournalNumber = distinctjrnl.JournalNumber
        ) jrnl
        LEFT JOIN #JournalHistory LagJrnl
            ON LagJrnl.SourceId = jrnl.SourceId
            AND LagJrnl.JournalNumber = jrnl.LagJournalNumber
            AND LagJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
            AND LagJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
            AND jrnl.JournalNumber <> jrnl.LagJournalNumber
            AND LagJrnl.Changes <> 'Credit Reversed'
        LEFT JOIN #JournalHistory LeadJrnl
        ON LeadJrnl.SourceId = jrnl.SourceId
        AND LeadJrnl.JournalNumber = jrnl.LeadJournalNumber
        AND LeadJrnl.JournalLine_AccountCode = jrnl.JournalLine_AccountCode
        AND LeadJrnl.JournalLine_NetAmount = jrnl.JournalLine_NetAmount*-1
        AND jrnl.JournalNumber <> jrnl.LeadJournalNumber
        AND LeadJrnl.Changes = 'Credit Reversed'
    ) jrnltodel
        ON jrnl.SourceId = jrnltodel.SourceId
        AND jrnl.JournalNumber = jrnltodel.JournalNumber
        AND jrnl.JournalLine_AccountCode = jrnltodel.JournalLine_AccountCode
        AND jrnl.JournalLine_NetAmount = jrnltodel.JournalLine_NetAmount
        AND jrnltodel.ToDelete = 'Y'
    WHERE jrnl.OrganisationID = @OrganisationID;

	--Delete Journals with duplicate SourceIds where contact source is not NULL and not in (Creditnotes, Prepayments, Overpayments)
	DELETE jrnl
	FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW jrnl
	LEFT JOIN (
		SELECT DISTINCT
			JournalId,
			SourceID,
			JournalNumber,
			ContactSource,
			DENSE_RANK() OVER(PARTITION BY SourceId ORDER BY SourceID,JournalNumber DESC) RN
		FROM NEW_CLIENT1_XEROBLUE_JournalsCashNEW
		WHERE 
		ContactSource NOT IN ('CREDITNOTES', 'PREPAYMENTS', 'OVERPAYMENTS') 
		AND ContactSource IS NOT NULL
		AND OrganisationID = @OrganisationID
	) del
	ON jrnl.JournalId = del.JournalId
	WHERE 
	(RN > 1 OR JournalLine_JournalLineId IS NULL)
	AND jrnl.OrganisationID = @OrganisationID;

	IF OBJECT_ID('tempdb..#Journals') IS NOT NULL
	BEGIN
		DROP TABLE #Journals
	END

	IF OBJECT_ID('tempdb..#JournalHistory') IS NOT NULL
	BEGIN
		DROP TABLE #JournalHistory
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_JournalsCash', 'NEW_CLIENT1_XEROBLUE_JournalsCashSTAGE'
GO


--XEROBLUE_Transactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_TransactionsBlend', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_TransactionsBlend
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_TransactionsBlend
     @OrganisationID AS int 
AS  

    DECLARE @MaxDate NVARCHAR(100)

    SELECT
        @MaxDate = CASE 
            WHEN ISNULL(MAX(CreatedDateUTC)-1, '1/1/2000') > GETDATE()-1 THEN GETDATE()-1 
            ELSE ISNULL(MAX(CreatedDateUTC)-1, '1/1/2000') 
        END
    FROM NEW_CLIENT1_XEROBLUE_TransactionsBlend WHERE OrganisationID = @OrganisationID

    INSERT INTO NEW_CLIENT1_XEROBLUE_TransactionsBlendSTAGE
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
    FROM NEW_CLIENT1_XEROBLUE_Journals C
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
    FROM NEW_CLIENT1_XEROBLUE_JournalsCash C
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
    FROM NEW_CLIENT1_XEROBLUE_TransactionsBlendSTAGE tb
    JOIN NEW_CLIENT1_XEROBLUE_Transactions t ON tb.SourceId = t.Id AND tb.OrganisationID = t.OrganisationID
    WHERE tb.OrganisationID = @OrganisationID

	BEGIN TRANSACTION;  
        DELETE trg
        FROM dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlend trg
        JOIN dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlendSTAGE stg
            ON trg.JournalID = stg.JournalID
            AND trg.CashOrAccruals = stg.CashOrAccruals
            AND trg.OrganisationID = stg.OrganisationID            
        WHERE trg.[OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlend   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_TransactionsBlendSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  

	--Update TransactionBlends table with history value (Changes)
    UPDATE trns
    SET
        trns.[Changes] = jrnl.[Changes],
        trns.[User] = jrnl.[User],
        trns.[Details] = jrnl.[Details],
        trns.PaymentSourceID = jrnl.PaymentSourceID,
        trns.PaymentType = jrnl.PaymentType
    FROM NEW_CLIENT1_XEROBLUE_TransactionsBlend trns
    INNER JOIN NEW_CLIENT1_XEROBLUE_Journals jrnl
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
    FROM NEW_CLIENT1_XEROBLUE_TransactionsBlend trns
    INNER JOIN NEW_CLIENT1_XEROBLUE_JournalsCash jrnl
    ON trns.JournalID = jrnl.JournalID
    AND trns.OrganisationID = jrnl.OrganisationID
    WHERE CashOrAccruals = 'Cash'
    AND trns.OrganisationID = @OrganisationID;

EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_TransactionsBlend', 'NEW_CLIENT1_XEROBLUE_TransactionsBlendSTAGE'
GO


--XEROBLUE_BudgetSummary - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_BudgetSummary', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_BudgetSummary
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_BudgetSummary
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	--XEROBLUE_BudgetSummary2018FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY
		WHERE OrganisationID = @OrganisationID;
	
		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY_View
		SELECT 
			 [ID] = bdgt2018fy.[ID]
			,[Title] = bdgt2018fy.[Title]
			,[AccountId] = bdgt2018fy.[AccountId]
			,[BankAccount] = bdgt2018fy.[BankAccount]
			,[ClientID] = bdgt2018fy.[ClientID]
			,[OrganisationID] = bdgt2018fy.[OrganisationID]
			,[FinancialYear] = CAST('2018' AS REAL)
			,[AccountName_UID] = bdgt2018fy.[BankAccount] + CAST(bdgt2018fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2018fy.[Amount]
			,[Month] = bdgt2018fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2018fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2018fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2018fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2018fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2018fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2017",
					"Period2" AS "Aug 2017",
					"Period3" AS "Sep 2017",
					"Period4" AS "Oct 2017",
					"Period5" AS "Nov 2017",
					"Period6" AS "Dec 2017",
					"Period7" AS "Jan 2018",
					"Period8" AS "Feb 2018",
					"Period9" AS "Mar 2018",
					"Period10" AS "Apr 2018",
					"Period11" AS "May 2018",
					"Period12" AS "Jun 2018"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2017", "Aug 2017", "Sep 2017", "Oct 2017", "Nov 2017", "Dec 2017", "Jan 2018", "Feb 2018", "Mar 2018", "Apr 2018", "May 2018", "Jun 2018")
			) AS bdgt2018fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2018fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2018fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2018fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2018fy.[Month]) 
									END
    END
    COMMIT;

	--XEROBLUE_BudgetSummary2019FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY_View
		SELECT 
			 [ID] = bdgt2019fy.[ID]
			,[Title] = bdgt2019fy.[Title]
			,[AccountId] = bdgt2019fy.[AccountId]
			,[BankAccount] = bdgt2019fy.[BankAccount]
			,[ClientID] = bdgt2019fy.[ClientID]
			,[OrganisationID] = bdgt2019fy.[OrganisationID]
			,[FinancialYear] = CAST('2019' AS REAL)
			,[AccountName_UID] = bdgt2019fy.[BankAccount] + CAST(bdgt2019fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2019fy.[Amount]
			,[Month] = bdgt2019fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2019fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2019fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2019fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2019fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2019fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2018",
					"Period2" AS "Aug 2018",
					"Period3" AS "Sep 2018",
					"Period4" AS "Oct 2018",
					"Period5" AS "Nov 2018",
					"Period6" AS "Dec 2018",
					"Period7" AS "Jan 2019",
					"Period8" AS "Feb 2019",
					"Period9" AS "Mar 2019",
					"Period10" AS "Apr 2019",
					"Period11" AS "May 2019",
					"Period12" AS "Jun 2019"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2018", "Aug 2018", "Sep 2018", "Oct 2018", "Nov 2018", "Dec 2018", "Jan 2019", "Feb 2019", "Mar 2019", "Apr 2019", "May 2019", "Jun 2019")
			) AS bdgt2019fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2019fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2019fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2019fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2019fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2020FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY_View
		SELECT 
			 [ID] = bdgt2020fy.[ID]
			,[Title] = bdgt2020fy.[Title]
			,[AccountId] = bdgt2020fy.[AccountId]
			,[BankAccount] = bdgt2020fy.[BankAccount]
			,[ClientID] = bdgt2020fy.[ClientID]
			,[OrganisationID] = bdgt2020fy.[OrganisationID]
			,[FinancialYear] = CAST('2020' AS REAL)
			,[AccountName_UID] = bdgt2020fy.[BankAccount] + CAST(bdgt2020fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2020fy.[Amount]
			,[Month] = bdgt2020fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2020fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2020fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2020fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2020fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2020fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2019",
					"Period2" AS "Aug 2019",
					"Period3" AS "Sep 2019",
					"Period4" AS "Oct 2019",
					"Period5" AS "Nov 2019",
					"Period6" AS "Dec 2019",
					"Period7" AS "Jan 2020",
					"Period8" AS "Feb 2020",
					"Period9" AS "Mar 2020",
					"Period10" AS "Apr 2020",
					"Period11" AS "May 2020",
					"Period12" AS "Jun 2020"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2019", "Aug 2019", "Sep 2019", "Oct 2019", "Nov 2019", "Dec 2019", "Jan 2020", "Feb 2020", "Mar 2020", "Apr 2020", "May 2020", "Jun 2020")
			) AS bdgt2020fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2020fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2020fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2020fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2020fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2021FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY_View
		SELECT 
			 [ID] = bdgt2021fy.[ID]
			,[Title] = bdgt2021fy.[Title]
			,[AccountId] = bdgt2021fy.[AccountId]
			,[BankAccount] = bdgt2021fy.[BankAccount]
			,[ClientID] = bdgt2021fy.[ClientID]
			,[OrganisationID] = bdgt2021fy.[OrganisationID]
			,[FinancialYear] = CAST('2021' AS REAL)
			,[AccountName_UID] = bdgt2021fy.[BankAccount] + CAST(bdgt2021fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2021fy.[Amount]
			,[Month] = bdgt2021fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2021fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2021fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2021fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2021fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2021fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2020",
					"Period2" AS "Aug 2020",
					"Period3" AS "Sep 2020",
					"Period4" AS "Oct 2020",
					"Period5" AS "Nov 2020",
					"Period6" AS "Dec 2020",
					"Period7" AS "Jan 2021",
					"Period8" AS "Feb 2021",
					"Period9" AS "Mar 2021",
					"Period10" AS "Apr 2021",
					"Period11" AS "May 2021",
					"Period12" AS "Jun 2021"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2020", "Aug 2020", "Sep 2020", "Oct 2020", "Nov 2020", "Dec 2020", "Jan 2021", "Feb 2021", "Mar 2021", "Apr 2021", "May 2021", "Jun 2021")
			) AS bdgt2021fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2021fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2021fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2021fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2021fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2022FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY_View
		SELECT 
			 [ID] = bdgt2022fy.[ID]
			,[Title] = bdgt2022fy.[Title]
			,[AccountId] = bdgt2022fy.[AccountId]
			,[BankAccount] = bdgt2022fy.[BankAccount]
			,[ClientID] = bdgt2022fy.[ClientID]
			,[OrganisationID] = bdgt2022fy.[OrganisationID]
			,[FinancialYear] = CAST('2022' AS REAL)
			,[AccountName_UID] = bdgt2022fy.[BankAccount] + CAST(bdgt2022fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2022fy.[Amount]
			,[Month] = bdgt2022fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2022fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2022fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2022fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2022fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2022fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2021",
					"Period2" AS "Aug 2021",
					"Period3" AS "Sep 2021",
					"Period4" AS "Oct 2021",
					"Period5" AS "Nov 2021",
					"Period6" AS "Dec 2021",
					"Period7" AS "Jan 2022",
					"Period8" AS "Feb 2022",
					"Period9" AS "Mar 2022",
					"Period10" AS "Apr 2022",
					"Period11" AS "May 2022",
					"Period12" AS "Jun 2022"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2021", "Aug 2021", "Sep 2021", "Oct 2021", "Nov 2021", "Dec 2021", "Jan 2022", "Feb 2022", "Mar 2022", "Apr 2022", "May 2022", "Jun 2022")
			) AS bdgt2022fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2022fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2022fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2022fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2022fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2023FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY_View
		SELECT 
			 [ID] = bdgt2023fy.[ID]
			,[Title] = bdgt2023fy.[Title]
			,[AccountId] = bdgt2023fy.[AccountId]
			,[BankAccount] = bdgt2023fy.[BankAccount]
			,[ClientID] = bdgt2023fy.[ClientID]
			,[OrganisationID] = bdgt2023fy.[OrganisationID]
			,[FinancialYear] = CAST('2023' AS REAL)
			,[AccountName_UID] = bdgt2023fy.[BankAccount] + CAST(bdgt2023fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2023fy.[Amount]
			,[Month] = bdgt2023fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2023fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2023fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2023fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2023fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2023fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2022",
					"Period2" AS "Aug 2022",
					"Period3" AS "Sep 2022",
					"Period4" AS "Oct 2022",
					"Period5" AS "Nov 2022",
					"Period6" AS "Dec 2022",
					"Period7" AS "Jan 2023",
					"Period8" AS "Feb 2023",
					"Period9" AS "Mar 2023",
					"Period10" AS "Apr 2023",
					"Period11" AS "May 2023",
					"Period12" AS "Jun 2023"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2022", "Aug 2022", "Sep 2022", "Oct 2022", "Nov 2022", "Dec 2022", "Jan 2023", "Feb 2023", "Mar 2023", "Apr 2023", "May 2023", "Jun 2023")
			) AS bdgt2023fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2023fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2023fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2023fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2023fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2024FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY_View
		SELECT 
			 [ID] = bdgt2024fy.[ID]
			,[Title] = bdgt2024fy.[Title]
			,[AccountId] = bdgt2024fy.[AccountId]
			,[BankAccount] = bdgt2024fy.[BankAccount]
			,[ClientID] = bdgt2024fy.[ClientID]
			,[OrganisationID] = bdgt2024fy.[OrganisationID]
			,[FinancialYear] = CAST('2024' AS REAL)
			,[AccountName_UID] = bdgt2024fy.[BankAccount] + CAST(bdgt2024fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2024fy.[Amount]
			,[Month] = bdgt2024fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2024fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2024fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2024fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2024fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2024fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2023",
					"Period2" AS "Aug 2023",
					"Period3" AS "Sep 2023",
					"Period4" AS "Oct 2023",
					"Period5" AS "Nov 2023",
					"Period6" AS "Dec 2023",
					"Period7" AS "Jan 2024",
					"Period8" AS "Feb 2024",
					"Period9" AS "Mar 2024",
					"Period10" AS "Apr 2024",
					"Period11" AS "May 2024",
					"Period12" AS "Jun 2024"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2023", "Aug 2023", "Sep 2023", "Oct 2023", "Nov 2023", "Dec 2023", "Jan 2024", "Feb 2024", "Mar 2024", "Apr 2024", "May 2024", "Jun 2024")
			) AS bdgt2024fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2024fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2024fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2024fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2024fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2025FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY_View
		SELECT 
			 [ID] = bdgt2025fy.[ID]
			,[Title] = bdgt2025fy.[Title]
			,[AccountId] = bdgt2025fy.[AccountId]
			,[BankAccount] = bdgt2025fy.[BankAccount]
			,[ClientID] = bdgt2025fy.[ClientID]
			,[OrganisationID] = bdgt2025fy.[OrganisationID]
			,[FinancialYear] = CAST('2025' AS REAL)
			,[AccountName_UID] = bdgt2025fy.[BankAccount] + CAST(bdgt2025fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2025fy.[Amount]
			,[Month] = bdgt2025fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2025fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2025fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2025fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2025fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2025fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2024",
					"Period2" AS "Aug 2024",
					"Period3" AS "Sep 2024",
					"Period4" AS "Oct 2024",
					"Period5" AS "Nov 2024",
					"Period6" AS "Dec 2024",
					"Period7" AS "Jan 2025",
					"Period8" AS "Feb 2025",
					"Period9" AS "Mar 2025",
					"Period10" AS "Apr 2025",
					"Period11" AS "May 2025",
					"Period12" AS "Jun 2025"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2024", "Aug 2024", "Sep 2024", "Oct 2024", "Nov 2024", "Dec 2024", "Jan 2025", "Feb 2025", "Mar 2025", "Apr 2025", "May 2025", "Jun 2025")
			) AS bdgt2025fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2025fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2025fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2025fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2025fy.[Month]) 
									END
    END
	COMMIT;

	--XEROBLUE_BudgetSummary2026FY
	BEGIN TRANSACTION;
    IF (SELECT COUNT(1) FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FYSTAGE WHERE OrganisationID = @OrganisationID) > 0
    BEGIN
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY 
		select * from dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FYSTAGE
		WHERE OrganisationID = @OrganisationID;

		DELETE NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY_View WHERE OrganisationID = @OrganisationID
		INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY_View
		SELECT 
			 [ID] = bdgt2026fy.[ID]
			,[Title] = bdgt2026fy.[Title]
			,[AccountId] = bdgt2026fy.[AccountId]
			,[BankAccount] = bdgt2026fy.[BankAccount]
			,[ClientID] = bdgt2026fy.[ClientID]
			,[OrganisationID] = bdgt2026fy.[OrganisationID]
			,[FinancialYear] = CAST('2026' AS REAL)
			,[AccountName_UID] = bdgt2026fy.[BankAccount] + CAST(bdgt2026fy.[OrganisationID] AS varchar)
			,[Amount] = bdgt2026fy.[Amount]
			,[Month] = bdgt2026fy.[Month]
			,[Amount_AUD] =  CAST(bdgt2026fy.[Amount] AS float) * [AUD]
			,[Amount_USD] =  CAST(bdgt2026fy.[Amount] AS float) * [USD]
			,[Amount_NZD] =  CAST(bdgt2026fy.[Amount] AS float) * [NZD]
			,[Amount_EUR] =  CAST(bdgt2026fy.[Amount] AS float) * [EUR]
			,[Amount_GBP] =  CAST(bdgt2026fy.[Amount] AS float) * [GBP]
		FROM (
				SELECT *,
					"Period1" AS "Jul 2025",
					"Period2" AS "Aug 2025",
					"Period3" AS "Sep 2025",
					"Period4" AS "Oct 2025",
					"Period5" AS "Nov 2025",
					"Period6" AS "Dec 2025",
					"Period7" AS "Jan 2026",
					"Period8" AS "Feb 2026",
					"Period9" AS "Mar 2026",
					"Period10" AS "Apr 2026",
					"Period11" AS "May 2026",
					"Period12" AS "Jun 2026"
				FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FYSTAGE 
				WHERE OrganisationID = @OrganisationID 
					AND BankAccount not in (
							'Account',
							'Gross Profit',
							'Net Profit',
							'Total Cost of Sales',
							'Total Expenses',
							'Total Expenses',
							'Total Operating Expenses'
						)
			) t
		UNPIVOT("Amount" FOR Month in ("Jul 2025", "Aug 2025", "Sep 2025", "Oct 2025", "Nov 2025", "Dec 2025", "Jan 2026", "Feb 2026", "Mar 2026", "Apr 2026", "May 2026", "Jun 2026")
			) AS bdgt2026fy
		LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt2026fy.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt2026fy.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt2026fy.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt2026fy.[Month]) 
									END
    END
	COMMIT;

    --XEROBLUE_BudgetSummaryInterim
	BEGIN TRANSACTION;
        DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim 
		WHERE OrganisationID = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim 
        (
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
        )
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2018FY_View AS A
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2019FY_View AS B
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2020FY_View AS C
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2021FY_View AS D
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2022FY_View AS E
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2023FY_View AS F
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2024FY_View AS G
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2025FY_View AS H
		WHERE OrganisationID = @OrganisationID
        UNION
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
        FROM   dbo.NEW_CLIENT1_XEROBLUE_BudgetSummary2026FY_View AS I
		WHERE OrganisationID = @OrganisationID

        UPDATE bdgt
        SET
            [TotalAmount] = (CASE 
                    WHEN acct."Class" = 'Revenue' THEN CAST(bdgt.[Amount] AS FLOAT)
                    WHEN acct."Class" = 'Expense' THEN (0-CAST(bdgt.[Amount] AS FLOAT))
                END )
        FROM NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim bdgt
        INNER JOIN NEW_CLIENT1_XEROBLUE_Accounts acct ON bdgt.AccountName_UID = acct.AccountName_UID AND bdgt.OrganisationID = acct.OrganisationID
        WHERE bdgt.OrganisationID = @OrganisationID;

        UPDATE bdgt
        SET
             [TotalAmount_AUD] = [TotalAmount] * [AUD]
            ,[TotalAmount_USD] = [TotalAmount] * [USD]
            ,[TotalAmount_NZD] = [TotalAmount] * [NZD]
            ,[TotalAmount_EUR] = [TotalAmount] * [EUR]
            ,[TotalAmount_GBP] = [TotalAmount] * [GBP]
        FROM NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim bdgt
        LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt.OrganisationID
		LEFT JOIN (
					SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
					FROM (
							SELECT
								BaseCurrency, Date, Currency, ExchangeRate
							FROM FOREIGNEXCHANGE_MASTER fx
							WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
						) AS SRC
					PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
				) fx ON fx.BaseCurrency = org.BaseCurrency 
					AND fx.[Date] = CASE 
										WHEN EOMONTH(bdgt.[Month]) <= @minDate THEN @minDate 
										WHEN EOMONTH(bdgt.[Month]) >= @maxDate THEN @maxDate
										ELSE EOMONTH(bdgt.[Month]) 
									END
		WHERE bdgt.OrganisationID = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim', 'NEW_CLIENT1_XEROBLUE_BudgetSummaryInterim'
GO


--XEROBLUE_Payments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Payments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Payments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Payments
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	UPDATE pymt
	SET  [Amount_AUD] = CASE WHEN org.BaseCurrency = 'AUD' AND CAST(pymt.CurrencyRate AS float) <> 0 THEN pymt.[Amount]/CAST(pymt.CurrencyRate AS float)
							ELSE pymt.[Amount] * [AUD] END
		,[Amount_USD] = CASE WHEN org.BaseCurrency = 'USD' AND CAST(pymt.CurrencyRate AS float) <> 0 THEN pymt.[Amount]/CAST(pymt.CurrencyRate AS float)
							ELSE pymt.[Amount] * [USD] END
		,[Amount_NZD] = CASE WHEN org.BaseCurrency = 'NZD' AND CAST(pymt.CurrencyRate AS float) <> 0 THEN pymt.[Amount]/CAST(pymt.CurrencyRate AS float)
							ELSE pymt.[Amount] * [NZD] END
		,[Amount_EUR] = CASE WHEN org.BaseCurrency = 'EUR' AND CAST(pymt.CurrencyRate AS float) <> 0 THEN pymt.[Amount]/CAST(pymt.CurrencyRate AS float)
							ELSE pymt.[Amount] * [EUR] END
		,[Amount_GBP] = CASE WHEN org.BaseCurrency = 'GBP' AND CAST(pymt.CurrencyRate AS float) <> 0 THEN pymt.[Amount]/CAST(pymt.CurrencyRate AS float)
							ELSE pymt.[Amount] * [GBP] END
	FROM NEW_CLIENT1_XEROBLUE_PaymentsSTAGE pymt
	LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = pymt.OrganisationID
	LEFT JOIN (SELECT InvoiceId, CurrencyCode FROM NEW_CLIENT1_XEROBLUE_Invoices WHERE OrganisationID = @OrganisationID) as inv ON pymt.InvoiceId = inv.InvoiceId
	LEFT JOIN (SELECT CreditNoteId, CurrencyCode FROM NEW_CLIENT1_XEROBLUE_CreditNotes WHERE OrganisationID = @OrganisationID) as cn ON pymt.InvoiceId = cn.CreditNoteId
	LEFT JOIN (SELECT OverPaymentId, CurrencyCode FROM NEW_CLIENT1_XEROBLUE_Overpayments WHERE OrganisationID = @OrganisationID) as op ON pymt.InvoiceId = op.OverPaymentId
	LEFT JOIN (SELECT PrePaymentId, CurrencyCode FROM NEW_CLIENT1_XEROBLUE_Prepayments WHERE OrganisationID = @OrganisationID) as pp ON pymt.InvoiceId = pp.PrePaymentId
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = CASE WHEN UPPER(pymt.PaymentType) in ('ACCRECPAYMENT','ACCPAYPAYMENT') THEN inv.CurrencyCode
										WHEN UPPER(pymt.PaymentType) in ('APCREDITPAYMENT','ARCREDITPAYMENT') THEN cn.CurrencyCode
										WHEN UPPER(pymt.PaymentType) in ('APOVERPAYMENTPAYMENT','AROVERPAYMENTPAYMENT') THEN op.CurrencyCode
										WHEN UPPER(pymt.PaymentType) in ('ARPREPAYMENTPAYMENT','APPREPAYMENTPAYMENT') THEN pp.CurrencyCode
										ELSE org.BaseCurrency END
				AND fx.[Date] = CASE 
									WHEN pymt.[Date] <= @minDate THEN @minDate 
									WHEN pymt.[Date] >= @maxDate THEN @maxDate
									ELSE pymt.[Date] 
								END
	WHERE pymt.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
	    DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_Payments TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_PaymentsSTAGE STG ON TRG.PaymentId = STG.PaymentId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Payments 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_PaymentsSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Payments', 'NEW_CLIENT1_XEROBLUE_PaymentsSTAGE'
GO


--XEROBLUE_Budgets - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_Budgets', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_Budgets
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_Budgets
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER

	IF OBJECT_ID('tempdb..#Budgets') IS NOT NULL
	BEGIN
		DROP TABLE #Budgets
	END

	SELECT
		 BudgetID
		,Status
		,Description
		,Type
		,UpdatedDateUTC
		,BudgetLines = NULL
		,[jBudgetLines.AccountID] AS [BudgetLines.AccountID]
		,[jBudgetLines.AccountCode] AS [BudgetLines.AccountCode]
		,[BudgetLines.BudgetBalances] = NULL
		,[jBudgetLines.BudgetBalances.Period] AS [BudgetLines.BudgetBalances.Period]
		,[jBudgetLines.BudgetBalances.Amount] AS [BudgetLines.BudgetBalances.Amount]
		,[jBudgetLines.BudgetBalances.Notes] AS [BudgetLines.BudgetBalances.Notes]
		,Tracking = NULL
		,[Tracking.1.Name]
		,[Tracking.1.Option]
		,[Tracking.1.TrackingCategoryID]
		,[Tracking.1.TrackingOptionID]
		,[Tracking.2.Name]
		,[Tracking.2.Option]
		,[Tracking.2.TrackingCategoryID]
		,[Tracking.2.TrackingOptionID]
		,ClientID
		,OrganisationID
		,[BudgetLines.BudgetBalances.Amount_AUD]
		,[BudgetLines.BudgetBalances.Amount_USD]
		,[BudgetLines.BudgetBalances.Amount_NZD]
		,[BudgetLines.BudgetBalances.Amount_EUR]
		,[BudgetLines.BudgetBalances.Amount_GBP]
	INTO #Budgets
	FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE
	CROSS APPLY OPENJSON(BudgetLines)
		WITH (
			[jBudgetLines.AccountID] nvarchar(100) '$.AccountID',
			[jBudgetLines.AccountCode] nvarchar(100) '$.AccountCode',
			[jBudgetLines.BudgetBalances] nvarchar(max) '$.BudgetBalances' AS JSON
		)
	CROSS APPLY OPENJSON([jBudgetLines.BudgetBalances])
		WITH (
			[jBudgetLines.BudgetBalances.Period] nvarchar(100) '$.Period',
			[jBudgetLines.BudgetBalances.Amount] float '$.Amount',
			[jBudgetLines.BudgetBalances.Notes] nvarchar(4000) '$.Notes'
		)
	WHERE OrganisationID = @OrganisationID
	INSERT INTO #Budgets
	SELECT
		BudgetID
		,Status
		,Description
		,Type
		,UpdatedDateUTC
		,BudgetLines = NULL
		,[BudgetLines.AccountID]
		,[BudgetLines.AccountCode]
		,[BudgetLines.BudgetBalances] = NULL
		,[BudgetLines.BudgetBalances.Period]
		,[BudgetLines.BudgetBalances.Amount]
		,[BudgetLines.BudgetBalances.Notes]
		,Tracking = NULL
		,[Tracking.1.Name]
		,[Tracking.1.Option]
		,[Tracking.1.TrackingCategoryID]
		,[Tracking.1.TrackingOptionID]
		,[Tracking.2.Name]
		,[Tracking.2.Option]
		,[Tracking.2.TrackingCategoryID]
		,[Tracking.2.TrackingOptionID]
		,ClientID
		,OrganisationID
		,[BudgetLines.BudgetBalances.Amount_AUD]
		,[BudgetLines.BudgetBalances.Amount_USD]
		,[BudgetLines.BudgetBalances.Amount_NZD]
		,[BudgetLines.BudgetBalances.Amount_EUR]
		,[BudgetLines.BudgetBalances.Amount_GBP]
	FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE
	WHERE OrganisationID = @OrganisationID AND BudgetLines = '[]';

	DELETE FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE WHERE OrganisationID = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_BudgetsSTAGE SELECT * FROM #Budgets;

    UPDATE bdgt
    SET
        [BudgetLines.BudgetBalances.Amount] = CASE 
                WHEN acct."Class" = 'Revenue' THEN bdgt."BudgetLines.BudgetBalances.Amount"
                WHEN acct."Class" = 'Expense' THEN (0-bdgt."BudgetLines.BudgetBalances.Amount")
        END
    FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE bdgt
    INNER JOIN NEW_CLIENT1_XEROBLUE_Accounts acct 
		ON bdgt.[BudgetLines.AccountID] = acct.[AccountID]
		AND bdgt.[BudgetLines.AccountCode] = acct.[Code];

	UPDATE bdgt
	SET 
         [BudgetLines.BudgetBalances.Amount_AUD] = bdgt.[BudgetLines.BudgetBalances.Amount] * [AUD]
		,[BudgetLines.BudgetBalances.Amount_USD] = bdgt.[BudgetLines.BudgetBalances.Amount] * [USD]
		,[BudgetLines.BudgetBalances.Amount_NZD] = bdgt.[BudgetLines.BudgetBalances.Amount] * [NZD]
		,[BudgetLines.BudgetBalances.Amount_EUR] = bdgt.[BudgetLines.BudgetBalances.Amount] * [EUR]
		,[BudgetLines.BudgetBalances.Amount_GBP] = bdgt.[BudgetLines.BudgetBalances.Amount] * [GBP]
	FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE bdgt
	LEFT JOIN NEW_CLIENT1_XEROBLUE_OrganisationsCLIENTS as org ON org.OrganisationID = bdgt.OrganisationID
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = org.BaseCurrency 
				AND fx.[Date] = CASE 
									WHEN EOMONTH(CONCAT(ISNULL(bdgt.[BudgetLines.BudgetBalances.Period],'1900-01'),'-01')) <= @minDate THEN @minDate 
									WHEN EOMONTH(CONCAT(ISNULL(bdgt.[BudgetLines.BudgetBalances.Period],'1900-01'),'-01')) >= @maxDate THEN @maxDate
									ELSE EOMONTH(CONCAT(ISNULL(bdgt.[BudgetLines.BudgetBalances.Period],'1900-01'),'-01')) 
								END
	WHERE bdgt.OrganisationID = @OrganisationID;

	BEGIN TRANSACTION;
		DELETE prd
		FROM dbo.NEW_CLIENT1_XEROBLUE_Budgets prd
		JOIN dbo.NEW_CLIENT1_XEROBLUE_BudgetsSTAGE stg 
		ON prd.BudgetID = stg.BudgetID
		AND prd.OrganisationId = stg.OrganisationId
		WHERE prd.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_Budgets 
		SELECT DISTINCT * FROM NEW_CLIENT1_XEROBLUE_BudgetsSTAGE
		WHERE OrganisationID = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#Budgets') IS NOT NULL
	BEGIN
		DROP TABLE #Budgets
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_Budgets', 'NEW_CLIENT1_XEROBLUE_BudgetsSTAGE'
GO


--XEROBLUE_CashValidation - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_CashValidation', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_CashValidation
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_CashValidation
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_CashValidation 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_CashValidation 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_CashValidationSTAGE
		WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_CashValidation', 'NEW_CLIENT1_XEROBLUE_CashValidationSTAGE'
GO


--XEROBLUE_ExpenseClaimPayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimPayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimPayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimPayments
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimPayments TRG
		INNER JOIN NEW_CLIENT1_XEROBLUE_ExpenseClaimPaymentsSTAGE STG ON TRG.ExpenseClaimId = STG.ExpenseClaimId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimPayments 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ExpenseClaimId ORDER BY ExpenseClaimId, [Date]),'|',ExpenseClaimId)
			,ExpenseClaimId
			,Date = jDate
			,Amount = jAmount
			,Reference = jReference
			,AccountId = jAccountId
			,AccountCode = jAccountCode
			,AccountName = jAccountName
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimPaymentsSTAGE
		CROSS APPLY OPENJSON(AccountId)
		WITH(
				jDate DATE '$.Date'
				,jAmount NUMERIC(30,6) '$.Amount'
				,jReference NVARCHAR(MAX) '$.Reference'
				,jAccountId NVARCHAR(MAX) '$.Account.AccountID'
				,jAccountCode NVARCHAR(MAX) '$.Account.Code'
				,jAccountName NVARCHAR(MAX) '$.Account.Name'
			)
		WHERE OrganisationID = @OrganisationID
		UNION ALL
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ExpenseClaimId ORDER BY ExpenseClaimId, [Date]),'|',ExpenseClaimId)
			,ExpenseClaimId
			,Date
			,Amount
			,Reference
			,AccountId = NULL
			,AccountCode
			,AccountName
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimPaymentsSTAGE
		WHERE AccountId = '[]' AND OrganisationID = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ExpenseClaimPayments', 'NEW_CLIENT1_XEROBLUE_ExpenseClaimPaymentsSTAGE'
GO


--XEROBLUE_ExpenseClaimReceipts - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimReceipts', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimReceipts
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ExpenseClaimReceipts
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;

		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceipts TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceiptsSTAGE STG ON TRG.ExpenseClaimId = STG.ExpenseClaimId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceipts 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ExpenseClaimId ORDER BY [Date]),'|',ExpenseClaimId)
			,ExpenseClaimId
			,ReceiptId = jReceiptId
			,Date = jDate
			,Contact_ContactId = jContact_ContactId
			,Contact_Name = jContact_Name
			,LineItem_Description = jLineItem_Description
			,LineItem_UnitAmount = jLineItem_UnitAmount
			,LineItem_AccountCode = jLineItem_AccountCode
			,LineItem_Quantity = jLineItem_Quantity
			,LineItem_TaxAmount = jLineItem_TaxAmount
			,LineItem_TaxType = jLineItem_TaxType
			,LineItem_LineAmount = jLineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate = jLineItem_DiscountRate
			,User_UserId = jUser_UserId
			,Reference = jReference
			,LineAmountTypes = jLineAmountTypes
			,SubTotal = jSubTotal
			,TotalTax = jTotalTax
			,Total = jTotal
			,Status = jStatus
			,ReceiptNumber = jReceiptNumber
			,UpdatedDateUTC = LEFT(REPLACE(jUpdatedDateUTC,'T',' '),19)
			,HasAttachments = jHasAttachments
			,URL = jURL
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceiptsSTAGE
		CROSS APPLY OPENJSON(ReceiptId)
		WITH(
				jReceiptId NVARCHAR(MAX) '$.ReceiptID'
				,jDate DATE '$.Date'
				,jContact_ContactId NVARCHAR(MAX) '$.Contact.ContactID'
				,jContact_Name NVARCHAR(MAX) '$.Contact.Name'
				,jUser_UserId NVARCHAR(MAX) '$.User.UserID'
				,jReference NVARCHAR(MAX) '$.Reference'
				,jLineAmountTypes NVARCHAR(MAX) '$.LineAmountTypes'
				,jSubTotal NUMERIC(30,6) '$.SubTotal'
				,jTotalTax NUMERIC(30,6) '$.TotalTax'
				,jTotal NUMERIC(30,6) '$.Total'
				,jStatus NVARCHAR(MAX) '$.Status'
				,jReceiptNumber NVARCHAR(MAX) '$.ReceiptNumber'
				,jUpdatedDateUTC NVARCHAR(MAX) '$.UpdatedDateUTC'
				,jHasAttachments BIT '$.HasAttachments'
				,jURL NVARCHAR(MAX) '$.URL'
				,jLineItems  NVARCHAR(MAX) '$.LineItems' AS JSON
			)
		CROSS APPLY OPENJSON(jLineItems)
		WITH(
				jLineItem_Description NVARCHAR(MAX) '$.Description'
				,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
				,jLineItem_AccountCode NVARCHAR(MAX) '$.AccountCode'
				,jLineItem_Quantity FLOAT '$.Quantity'
				,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
				,jLineItem_TaxType NVARCHAR(MAX) '$.TaxType'
				,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
				,jLineItem_TrackingCategory1_CategoryId NVARCHAR(MAX) '$.Tracking[0].TrackingCategoryID'
				,jLineItem_TrackingCategory1_CategoryName NVARCHAR(MAX) '$.Tracking[0].Name'
				,jLineItem_TrackingCategory1_OptionId NVARCHAR(MAX) '$.Tracking[0].TrackingOptionID'
				,jLineItem_TrackingCategory1_OptionName NVARCHAR(MAX) '$.Tracking[0].Option'
				,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(MAX) '$.Tracking[0].Status'
				,jLineItem_TrackingCategory2_CategoryId NVARCHAR(MAX) '$.Tracking[1].TrackingCategoryID'
				,jLineItem_TrackingCategory2_CategoryName NVARCHAR(MAX) '$.Tracking[1].Name'
				,jLineItem_TrackingCategory2_OptionId NVARCHAR(MAX) '$.Tracking[1].TrackingOptionID'
				,jLineItem_TrackingCategory2_OptionName NVARCHAR(MAX) '$.Tracking[1].Option'
				,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(MAX) '$.Tracking[1].Status'
				,jLineItem_DiscountRate FLOAT '$.DiscountRate'
			)
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceipts 
		SELECT
			Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY ExpenseClaimId ORDER BY [Date]),'|',ExpenseClaimId)
			,ExpenseClaimId
			,ReceiptId = NULL
			,Date
			,Contact_ContactId
			,Contact_Name
			,LineItem_Description
			,LineItem_UnitAmount
			,LineItem_AccountCode
			,LineItem_Quantity
			,LineItem_TaxAmount
			,LineItem_TaxType
			,LineItem_LineAmount
			,LineItem_TrackingCategory1_CategoryId
			,LineItem_TrackingCategory1_CategoryName
			,LineItem_TrackingCategory1_OptionId
			,LineItem_TrackingCategory1_OptionName
			,LineItem_TrackingCategory1_Option_Stat
			,LineItem_TrackingCategory2_CategoryId
			,LineItem_TrackingCategory2_CategoryName
			,LineItem_TrackingCategory2_OptionId
			,LineItem_TrackingCategory2_OptionName
			,LineItem_TrackingCategory2_Option_Stat
			,LineItem_DiscountRate
			,User_UserId
			,Reference
			,LineAmountTypes
			,SubTotal
			,TotalTax
			,Total
			,Status
			,ReceiptNumber
			,UpdatedDateUTC
			,HasAttachments
			,URL
			,ClientID
			,OrganisationID
		FROM dbo.NEW_CLIENT1_XEROBLUE_ExpenseClaimReceiptsSTAGE
		WHERE ReceiptId = '[]' AND OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ExpenseClaimReceipts', 'NEW_CLIENT1_XEROBLUE_ExpenseClaimReceiptsSTAGE'
GO


--XEROBLUE_TrackingCategoryConnections - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategoryConnections', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategoryConnections
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_TrackingCategoryConnections
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_TrackingCategoryConnectionsSTAGE 
    --Invoices
    SELECT ID, CategoryNumber, [CategoryID+Option], ClientID, OrganisationID
    FROM
        (SELECT
            ID
            ,[Category 1] = CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName)
            ,[Category 2] = CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName)
            ,ClientID
            ,OrganisationID
        FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesSTAGE
        WHERE Status in ('AUTHORISED', 'PAID')) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> '' AND OrganisationID = @OrganisationID
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
        FROM dbo.NEW_CLIENT1_XEROBLUE_JournalsSTAGE) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> '' AND OrganisationID = @OrganisationID
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
        FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotesSTAGE
        WHERE Status in ('AUTHORISED', 'PAID')) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> '' AND OrganisationID = @OrganisationID
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
        FROM dbo.NEW_CLIENT1_XEROBLUE_BudgetsSTAGE a 
        INNER JOIN NEW_CLIENT1_XEROBLUE_Accounts b 
        ON a.[BudgetLines.AccountID] = b.[AccountID] 
        AND a.[BudgetLines.AccountCode] = b.Code) p
    UNPIVOT
        ([CategoryID+Option] FOR CategoryNumber IN ([Category 1],[Category 2])) AS UNPVT
    WHERE [CategoryID+Option] <> '' AND OrganisationID = @OrganisationID

	BEGIN TRANSACTION;  
        DELETE TRG  
        FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoryConnections TRG  
        INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoryConnectionsSTAGE STG ON TRG.ID = STG.ID  
        WHERE TRG.OrganisationId = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoryConnections   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_TrackingCategoryConnectionsSTAGE  
        WHERE OrganisationId = @OrganisationID;  
    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_TrackingCategoryConnections', 'NEW_CLIENT1_XEROBLUE_TrackingCategoryConnectionsSTAGE'
GO


--XEROBLUE_ContactGroupMembers - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroupMembers', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroupMembers
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_ContactGroupMembers
    @OrganisationID AS int 
AS
	BEGIN TRANSACTION;
		DELETE FROM dbo.NEW_CLIENT1_XEROBLUE_ContactGroupMembers 
		WHERE OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_ContactGroupMembers 
		select * from dbo.NEW_CLIENT1_XEROBLUE_ContactGroupMembersSTAGE
		WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_ContactGroupMembers', 'NEW_CLIENT1_XEROBLUE_ContactGroupMembersSTAGE'
GO


--XEROBLUE_InvoicesDraft - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_InvoicesDraft', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_InvoicesDraft
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_InvoicesDraft
     @OrganisationID AS int 
AS  
	DECLARE 
		 @maxDate AS datetime
		,@minDate AS datetime

	SELECT
		 @maxDate = MAX(date)
		,@minDate = MIN(date) 
	FROM FOREIGNEXCHANGE_MASTER
	
	IF OBJECT_ID('tempdb..#InvoicesDraft') IS NOT NULL
	BEGIN
		DROP TABLE #InvoicesDraft
	END
	
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY InvoiceId ORDER BY [Date]),'|',InvoiceId)
		,InvoiceId
		,Type
		,ContactId
		,ContactName
		,LineItem_LineItemId = jLineItem_LineItemId
		,LineItem_Description = jLineItem_Description
		,LineItem_Quantity = jLineItem_Quantity
		,LineItem_UnitAmount = jLineItem_UnitAmount
		,LineItem_ItemCode = jLineItem_ItemCode
		,LineItem_AccountCode = jLineItem_AccountCode
		,LineItem_TaxType = jLineItem_TaxType
		,LineItem_TaxAmount = jLineItem_TaxAmount
		,LineItem_LineAmount = jLineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId = jLineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName = jLineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId = jLineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName = jLineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat = jLineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId = jLineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName = jLineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId = jLineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName = jLineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat = jLineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate = jLineItem_DiscountRate
		,LineItem_DiscountAmount = jLineItem_DiscountAmount
		,LineItemAggregate = NULL
		,Date
		,DueDate
		,LineAmountTypes
		,InvoiceNumber
		,Reference
		,BrandingThemeId
		,URL
		,CurrencyCode
		,CurrencyRate
		,Status
		,SentToContact
		,ExpectedPaymentDate
		,PlannedPaymentDate
		,SubTotal
		,TotalTax
		,Total
		,TotalDiscount
		,HasAttachments
		,PaymentIds = CAST(PaymentIds AS NVARCHAR(4000))
		,PrePaymentIds = CAST(PrePaymentIds AS NVARCHAR(4000))
		,OverPaymentIds = CAST(OverPaymentIds AS NVARCHAR(4000))
		,CreditNoteIds = CAST(CreditNoteIds AS NVARCHAR(4000))
		,AmountDue
		,AmountPaid
		,CISDeduction
		,FullyPaidOnDate
		,AmountCredited
		,UpdatedDateUTC
		,CreditNotes = CAST(CreditNotes AS NVARCHAR(4000))
		,Prepayments = CAST(Prepayments AS NVARCHAR(4000))
		,Payments = CAST(Payments AS NVARCHAR(4000))
		,Overpayments = CAST(Overpayments AS NVARCHAR(4000))
		,RepeatingInvoiceID = CAST(RepeatingInvoiceID AS NVARCHAR(4000))
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[LineItem_DiscountAmount_AUD]
		,[LineItem_DiscountAmount_USD]
		,[LineItem_DiscountAmount_NZD]
		,[LineItem_DiscountAmount_EUR]
		,[LineItem_DiscountAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[TotalDiscount_AUD]
		,[TotalDiscount_USD]
		,[TotalDiscount_NZD]
		,[TotalDiscount_EUR]
		,[TotalDiscount_GBP]
		,[AmountDue_AUD]
		,[AmountDue_USD]
		,[AmountDue_NZD]
		,[AmountDue_EUR]
		,[AmountDue_GBP]
		,[AmountPaid_AUD]
		,[AmountPaid_USD]
		,[AmountPaid_NZD]
		,[AmountPaid_EUR]
		,[AmountPaid_GBP]
		,[CISDeduction_AUD]
		,[CISDeduction_USD]
		,[CISDeduction_NZD]
		,[CISDeduction_EUR]
		,[CISDeduction_GBP]
		,[AmountCredited_AUD]
		,[AmountCredited_USD]
		,[AmountCredited_NZD]
		,[AmountCredited_EUR]
		,[AmountCredited_GBP]
        ,[DiscountRate]
        ,[DiscountRate%]
        ,[LineAmountCalculation]
        ,[LineAmountCalculationIncTax]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[DayDifference]
        ,[LineAmountCalculation_AUD]
        ,[LineAmountCalculation_USD]
        ,[LineAmountCalculation_NZD]
        ,[LineAmountCalculation_EUR]
        ,[LineAmountCalculation_GBP]
        ,[LineAmountCalculationIncTax_AUD]
        ,[LineAmountCalculationIncTax_USD]
        ,[LineAmountCalculationIncTax_NZD]
        ,[LineAmountCalculationIncTax_EUR]
        ,[LineAmountCalculationIncTax_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
	INTO #InvoicesDraft
	FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
	CROSS APPLY OPENJSON(LineItemAggregate)
	WITH(
			jLineItem_LineItemId NVARCHAR(100) '$.LineItemID'
			,jLineItem_Description NVARCHAR(4000) '$.Description'
			,jLineItem_Quantity FLOAT '$.Quantity'
			,jLineItem_UnitAmount NUMERIC(30,6) '$.UnitAmount'
			,jLineItem_ItemCode NVARCHAR(100) '$.ItemCode'
			,jLineItem_AccountCode NVARCHAR(100) '$.AccountCode'
			,jLineItem_TaxType NVARCHAR(100) '$.TaxType'
			,jLineItem_TaxAmount NUMERIC(30,6) '$.TaxAmount'
			,jLineItem_LineAmount NUMERIC(30,6) '$.LineAmount'
			,jLineItem_TrackingCategory1_CategoryId NVARCHAR(100) '$.Tracking[0].TrackingCategoryID'
			,jLineItem_TrackingCategory1_CategoryName NVARCHAR(255) '$.Tracking[0].Name'
			,jLineItem_TrackingCategory1_OptionId NVARCHAR(100) '$.Tracking[0].TrackingOptionID'
			,jLineItem_TrackingCategory1_OptionName NVARCHAR(255) '$.Tracking[0].Option'
			,jLineItem_TrackingCategory1_Option_Stat NVARCHAR(100) '$.Tracking[0].Status'
			,jLineItem_TrackingCategory2_CategoryId NVARCHAR(100) '$.Tracking[1].TrackingCategoryID'
			,jLineItem_TrackingCategory2_CategoryName NVARCHAR(255) '$.Tracking[1].Name'
			,jLineItem_TrackingCategory2_OptionId NVARCHAR(100) '$.Tracking[1].TrackingOptionID'
			,jLineItem_TrackingCategory2_OptionName NVARCHAR(255) '$.Tracking[1].Option'
			,jLineItem_TrackingCategory2_Option_Stat NVARCHAR(100) '$.Tracking[1].Status'
			,jLineItem_DiscountRate FLOAT '$.DiscountRate'
			,jLineItem_DiscountAmount NUMERIC(30,6) '$.DiscountAmount'
		)
	WHERE OrganisationId = @OrganisationID
	INSERT INTO #InvoicesDraft
	SELECT
		 Id = CONCAT(ROW_NUMBER() OVER(PARTITION BY InvoiceId ORDER BY [Date]),'|',InvoiceId)
		,InvoiceId
		,Type
		,ContactId
		,ContactName
		,LineItem_LineItemId
		,LineItem_Description
		,LineItem_Quantity
		,LineItem_UnitAmount
		,LineItem_ItemCode
		,LineItem_AccountCode
		,LineItem_TaxType
		,LineItem_TaxAmount
		,LineItem_LineAmount
		,LineItem_TrackingCategory1_CategoryId
		,LineItem_TrackingCategory1_CategoryName
		,LineItem_TrackingCategory1_OptionId
		,LineItem_TrackingCategory1_OptionName
		,LineItem_TrackingCategory1_Option_Stat
		,LineItem_TrackingCategory2_CategoryId
		,LineItem_TrackingCategory2_CategoryName
		,LineItem_TrackingCategory2_OptionId
		,LineItem_TrackingCategory2_OptionName
		,LineItem_TrackingCategory2_Option_Stat
		,LineItem_DiscountRate
		,LineItem_DiscountAmount
		,LineItemAggregate = NULL
		,Date
		,DueDate
		,LineAmountTypes
		,InvoiceNumber
		,Reference
		,BrandingThemeId
		,URL
		,CurrencyCode
		,CurrencyRate
		,Status
		,SentToContact
		,ExpectedPaymentDate
		,PlannedPaymentDate
		,SubTotal
		,TotalTax
		,Total
		,TotalDiscount
		,HasAttachments
		,PaymentIds = CAST(PaymentIds AS NVARCHAR(4000))
		,PrePaymentIds = CAST(PrePaymentIds AS NVARCHAR(4000))
		,OverPaymentIds = CAST(OverPaymentIds AS NVARCHAR(4000))
		,CreditNoteIds = CAST(CreditNoteIds AS NVARCHAR(4000))
		,AmountDue
		,AmountPaid
		,CISDeduction
		,FullyPaidOnDate
		,AmountCredited
		,UpdatedDateUTC
		,CreditNotes = CAST(CreditNotes AS NVARCHAR(4000))
		,Prepayments = CAST(Prepayments AS NVARCHAR(4000))
		,Payments = CAST(Payments AS NVARCHAR(4000))
		,Overpayments = CAST(Overpayments AS NVARCHAR(4000))
		,RepeatingInvoiceID = CAST(RepeatingInvoiceID AS NVARCHAR(4000))
		,ClientID
		,OrganisationID
		,[LineItem_UnitAmount_AUD]
		,[LineItem_UnitAmount_USD]
		,[LineItem_UnitAmount_NZD]
		,[LineItem_UnitAmount_EUR]
		,[LineItem_UnitAmount_GBP]
		,[LineItem_TaxAmount_AUD]
		,[LineItem_TaxAmount_USD]
		,[LineItem_TaxAmount_NZD]
		,[LineItem_TaxAmount_EUR]
		,[LineItem_TaxAmount_GBP]
		,[LineItem_LineAmount_AUD]
		,[LineItem_LineAmount_USD]
		,[LineItem_LineAmount_NZD]
		,[LineItem_LineAmount_EUR]
		,[LineItem_LineAmount_GBP]
		,[LineItem_DiscountAmount_AUD]
		,[LineItem_DiscountAmount_USD]
		,[LineItem_DiscountAmount_NZD]
		,[LineItem_DiscountAmount_EUR]
		,[LineItem_DiscountAmount_GBP]
		,[SubTotal_AUD]
		,[SubTotal_USD]
		,[SubTotal_NZD]
		,[SubTotal_EUR]
		,[SubTotal_GBP]
		,[TotalTax_AUD]
		,[TotalTax_USD]
		,[TotalTax_NZD]
		,[TotalTax_EUR]
		,[TotalTax_GBP]
		,[Total_AUD]
		,[Total_USD]
		,[Total_NZD]
		,[Total_EUR]
		,[Total_GBP]
		,[TotalDiscount_AUD]
		,[TotalDiscount_USD]
		,[TotalDiscount_NZD]
		,[TotalDiscount_EUR]
		,[TotalDiscount_GBP]
		,[AmountDue_AUD]
		,[AmountDue_USD]
		,[AmountDue_NZD]
		,[AmountDue_EUR]
		,[AmountDue_GBP]
		,[AmountPaid_AUD]
		,[AmountPaid_USD]
		,[AmountPaid_NZD]
		,[AmountPaid_EUR]
		,[AmountPaid_GBP]
		,[CISDeduction_AUD]
		,[CISDeduction_USD]
		,[CISDeduction_NZD]
		,[CISDeduction_EUR]
		,[CISDeduction_GBP]
		,[AmountCredited_AUD]
		,[AmountCredited_USD]
		,[AmountCredited_NZD]
		,[AmountCredited_EUR]
		,[AmountCredited_GBP]
        ,[DiscountRate]
        ,[DiscountRate%]
        ,[LineAmountCalculation]
        ,[LineAmountCalculationIncTax]
        ,[LineAmountTradeCreditorCalculation]
        ,[LineAmountTradeDebtorCalculation]
        ,[DayDifference]
        ,[LineAmountCalculation_AUD]
        ,[LineAmountCalculation_USD]
        ,[LineAmountCalculation_NZD]
        ,[LineAmountCalculation_EUR]
        ,[LineAmountCalculation_GBP]
        ,[LineAmountCalculationIncTax_AUD]
        ,[LineAmountCalculationIncTax_USD]
        ,[LineAmountCalculationIncTax_NZD]
        ,[LineAmountCalculationIncTax_EUR]
        ,[LineAmountCalculationIncTax_GBP]
        ,[LineAmountTradeCreditorCalculation_AUD]
        ,[LineAmountTradeCreditorCalculation_USD]
        ,[LineAmountTradeCreditorCalculation_NZD]
        ,[LineAmountTradeCreditorCalculation_EUR]
        ,[LineAmountTradeCreditorCalculation_GBP]
        ,[LineAmountTradeDebtorCalculation_AUD]
        ,[LineAmountTradeDebtorCalculation_USD]
        ,[LineAmountTradeDebtorCalculation_NZD]
        ,[LineAmountTradeDebtorCalculation_EUR]
        ,[LineAmountTradeDebtorCalculation_GBP]
	FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
    WHERE OrganisationId = @OrganisationID AND LineItemAggregate = '[]'

	DELETE FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE WHERE OrganisationId = @OrganisationID;
	INSERT INTO NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
	SELECT * FROM #InvoicesDraft;

    UPDATE NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
    SET
        [DiscountRate] = ISNULL([LineItem_DiscountRate], 0), 
        [DiscountRate%] = ISNULL([LineItem_DiscountRate] * 0.01, 0),
        [LineAmountCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'INCLUSIVE' AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'INCLUSIVE' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]-[LineItem_TaxAmount])
                WHEN ([LineAmountTypes] = 'EXCLUSIVE' OR [LineAmountTypes] = 'NOTAX') AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount])
                WHEN ([LineAmountTypes] = 'EXCLUSIVE' OR [LineAmountTypes] = 'NOTAX') AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                ELSE 0 END AS decimal(15,4)
            ),     
        [LineAmountCalculationIncTax] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCPAY' THEN 0-([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN ([LineAmountTypes] = 'Exclusive' OR [LineAmountTypes] = 'NoTax') AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),    	
        [LineAmountTradeCreditorCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCPAY' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),   
        [LineAmountTradeDebtorCalculation] = CAST(
                CASE 
                WHEN [LineAmountTypes] = 'Inclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount])
                WHEN [LineAmountTypes] = 'Exclusive' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                WHEN [LineAmountTypes] = 'NoTax' AND [Type] = 'ACCREC' THEN ([LineItem_LineAmount]+[LineItem_TaxAmount])
                ELSE 0 END AS decimal(15,4)
            ),
        [DayDifference] = DATEDIFF(DAY, [Date], [FullyPaidOnDate])
    WHERE OrganisationId = @OrganisationID;

	UPDATE inv
	SET  [LineItem_UnitAmount_AUD] = inv.[LineItem_UnitAmount] * [AUD]
		,[LineItem_UnitAmount_USD] = inv.[LineItem_UnitAmount] * [USD]
		,[LineItem_UnitAmount_NZD] = inv.[LineItem_UnitAmount] * [NZD]
		,[LineItem_UnitAmount_EUR] = inv.[LineItem_UnitAmount] * [EUR]
		,[LineItem_UnitAmount_GBP] = inv.[LineItem_UnitAmount] * [GBP]
		,[LineItem_TaxAmount_AUD] = inv.[LineItem_TaxAmount] * [AUD]
		,[LineItem_TaxAmount_USD] = inv.[LineItem_TaxAmount] * [USD]
		,[LineItem_TaxAmount_NZD] = inv.[LineItem_TaxAmount] * [NZD]
		,[LineItem_TaxAmount_EUR] = inv.[LineItem_TaxAmount] * [EUR]
		,[LineItem_TaxAmount_GBP] = inv.[LineItem_TaxAmount] * [GBP]
		,[LineItem_LineAmount_AUD] = inv.[LineItem_LineAmount] * [AUD]
		,[LineItem_LineAmount_USD] = inv.[LineItem_LineAmount] * [USD]
		,[LineItem_LineAmount_NZD] = inv.[LineItem_LineAmount] * [NZD]
		,[LineItem_LineAmount_EUR] = inv.[LineItem_LineAmount] * [EUR]
		,[LineItem_LineAmount_GBP] = inv.[LineItem_LineAmount] * [GBP]
		,[LineItem_DiscountAmount_AUD] = inv.[LineItem_DiscountAmount] * [AUD]
		,[LineItem_DiscountAmount_USD] = inv.[LineItem_DiscountAmount] * [USD]
		,[LineItem_DiscountAmount_NZD] = inv.[LineItem_DiscountAmount] * [NZD]
		,[LineItem_DiscountAmount_EUR] = inv.[LineItem_DiscountAmount] * [EUR]
		,[LineItem_DiscountAmount_GBP] = inv.[LineItem_DiscountAmount] * [GBP]
		,[SubTotal_AUD] = inv.[SubTotal] * [AUD]
		,[SubTotal_USD] = inv.[SubTotal] * [USD]
		,[SubTotal_NZD] = inv.[SubTotal] * [NZD]
		,[SubTotal_EUR] = inv.[SubTotal] * [EUR]
		,[SubTotal_GBP] = inv.[SubTotal] * [GBP]
		,[TotalTax_AUD] = inv.[TotalTax] * [AUD]
		,[TotalTax_USD] = inv.[TotalTax] * [USD]
		,[TotalTax_NZD] = inv.[TotalTax] * [NZD]
		,[TotalTax_EUR] = inv.[TotalTax] * [EUR]
		,[TotalTax_GBP] = inv.[TotalTax] * [GBP]
		,[Total_AUD] = inv.[Total] * [AUD]
		,[Total_USD] = inv.[Total] * [USD]
		,[Total_NZD] = inv.[Total] * [NZD]
		,[Total_EUR] = inv.[Total] * [EUR]
		,[Total_GBP] = inv.[Total] * [GBP]
		,[TotalDiscount_AUD] = inv.[TotalDiscount] * [AUD]
		,[TotalDiscount_USD] = inv.[TotalDiscount] * [USD]
		,[TotalDiscount_NZD] = inv.[TotalDiscount] * [NZD]
		,[TotalDiscount_EUR] = inv.[TotalDiscount] * [EUR]
		,[TotalDiscount_GBP] = inv.[TotalDiscount] * [GBP]
		,[AmountDue_AUD] = inv.[AmountDue] * [AUD]
		,[AmountDue_USD] = inv.[AmountDue] * [USD]
		,[AmountDue_NZD] = inv.[AmountDue] * [NZD]
		,[AmountDue_EUR] = inv.[AmountDue] * [EUR]
		,[AmountDue_GBP] = inv.[AmountDue] * [GBP]
		,[AmountPaid_AUD] = inv.[AmountPaid] * [AUD]
		,[AmountPaid_USD] = inv.[AmountPaid] * [USD]
		,[AmountPaid_NZD] = inv.[AmountPaid] * [NZD]
		,[AmountPaid_EUR] = inv.[AmountPaid] * [EUR]
		,[AmountPaid_GBP] = inv.[AmountPaid] * [GBP]
		,[CISDeduction_AUD] = inv.[CISDeduction] * [AUD]
		,[CISDeduction_USD] = inv.[CISDeduction] * [USD]
		,[CISDeduction_NZD] = inv.[CISDeduction] * [NZD]
		,[CISDeduction_EUR] = inv.[CISDeduction] * [EUR]
		,[CISDeduction_GBP] = inv.[CISDeduction] * [GBP]
		,[AmountCredited_AUD] = inv.[AmountCredited] * [AUD]
		,[AmountCredited_USD] = inv.[AmountCredited] * [USD]
		,[AmountCredited_NZD] = inv.[AmountCredited] * [NZD]
		,[AmountCredited_EUR] = inv.[AmountCredited] * [EUR]
		,[AmountCredited_GBP] = inv.[AmountCredited] * [GBP]
        ,[LineAmountCalculation_AUD] = inv.[LineAmountCalculation] * [AUD]
        ,[LineAmountCalculation_USD] = inv.[LineAmountCalculation] * [USD]
        ,[LineAmountCalculation_NZD] = inv.[LineAmountCalculation] * [NZD]
        ,[LineAmountCalculation_EUR] = inv.[LineAmountCalculation] * [EUR]
        ,[LineAmountCalculation_GBP] = inv.[LineAmountCalculation] * [GBP]
        ,[LineAmountCalculationIncTax_AUD] = inv.[LineAmountCalculationIncTax] * [AUD]
        ,[LineAmountCalculationIncTax_USD] = inv.[LineAmountCalculationIncTax] * [USD]
        ,[LineAmountCalculationIncTax_NZD] = inv.[LineAmountCalculationIncTax] * [NZD]
        ,[LineAmountCalculationIncTax_EUR] = inv.[LineAmountCalculationIncTax] * [EUR]
        ,[LineAmountCalculationIncTax_GBP] = inv.[LineAmountCalculationIncTax] * [GBP]
        ,[LineAmountTradeCreditorCalculation_AUD] = inv.[LineAmountTradeCreditorCalculation] * [AUD]
        ,[LineAmountTradeCreditorCalculation_USD] = inv.[LineAmountTradeCreditorCalculation] * [USD]
        ,[LineAmountTradeCreditorCalculation_NZD] = inv.[LineAmountTradeCreditorCalculation] * [NZD]
        ,[LineAmountTradeCreditorCalculation_EUR] = inv.[LineAmountTradeCreditorCalculation] * [EUR]
        ,[LineAmountTradeCreditorCalculation_GBP] = inv.[LineAmountTradeCreditorCalculation] * [GBP]
        ,[LineAmountTradeDebtorCalculation_AUD] = inv.[LineAmountTradeDebtorCalculation] * [AUD]
        ,[LineAmountTradeDebtorCalculation_USD] = inv.[LineAmountTradeDebtorCalculation] * [USD]
        ,[LineAmountTradeDebtorCalculation_NZD] = inv.[LineAmountTradeDebtorCalculation] * [NZD]
        ,[LineAmountTradeDebtorCalculation_EUR] = inv.[LineAmountTradeDebtorCalculation] * [EUR]
        ,[LineAmountTradeDebtorCalculation_GBP] = inv.[LineAmountTradeDebtorCalculation] * [GBP]
	FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE inv
	LEFT JOIN (
				SELECT BaseCurrency, Date, AUD, USD, NZD, EUR, GBP
				FROM (
						SELECT
							BaseCurrency, Date, Currency, ExchangeRate
						FROM FOREIGNEXCHANGE_MASTER fx
						WHERE fx.Currency IN ('AUD','USD','NZD','EUR','GBP')
					) AS SRC
				PIVOT (AVG(ExchangeRate) FOR Currency IN (AUD,USD,NZD,EUR,GBP)) AS p
			) fx ON fx.BaseCurrency = inv.CurrencyCode 
				AND fx.[Date] = CASE 
									WHEN inv.[Date] <= @minDate THEN @minDate 
									WHEN inv.[Date] >= @maxDate THEN @maxDate
									ELSE inv.[Date] 
								END
	WHERE inv.OrganisationID = @OrganisationID;

	--PaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.PaymentIds, j.jPaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jPaymentIds, ',') jPaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jPaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
				CROSS APPLY OPENJSON(Payments)
				WITH (jPaymentIds nvarchar(max) '$.PaymentID')
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET PaymentIds = jPaymentIds;

	--PrepaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.PrepaymentIds, j.jPrepaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jPrepaymentIds, ',') jPrepaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jPrepaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
				CROSS APPLY OPENJSON(Prepayments)
				WITH (jPrepaymentIds nvarchar(max) '$.PrepaymentID')
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET PrepaymentIds = jPrepaymentIds;

	--OverPaymentIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.OverPaymentIds, j.jOverPaymentIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jOverPaymentIds, ',') jOverPaymentIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jOverPaymentIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
				CROSS APPLY OPENJSON(Overpayments)
				WITH (jOverPaymentIds nvarchar(max) '$.OverpaymentID')
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET OverPaymentIds = jOverPaymentIds;

	--CreditNoteIds
	;WITH A AS (
		SELECT i.InvoiceId, i.LineItem_LineItemId, i.CreditNoteIds, j.jCreditNoteIds
		FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE i
		INNER JOIN (
		SELECT InvoiceId, LineItem_LineItemId, STRING_AGG(jCreditNoteIds, ',') jCreditNoteIds
		FROM (
				SELECT InvoiceId, LineItem_LineItemId, jCreditNoteIds
				FROM NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
				CROSS APPLY OPENJSON(CreditNotes)
				WITH (jCreditNoteIds nvarchar(max) '$.CreditNoteID')
			) j
		GROUP BY InvoiceId, LineItem_LineItemId) j ON j.InvoiceId = i.InvoiceId AND j.LineItem_LineItemId = i.LineItem_LineItemId
		WHERE i.OrganisationID = @OrganisationID
	)
	UPDATE A SET CreditNoteIds = jCreditNoteIds;

	BEGIN TRANSACTION;
		DELETE TRG
		FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraft TRG
		INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE STG ON TRG.InvoiceId = STG.InvoiceId
		WHERE TRG.OrganisationId = @OrganisationID;

		INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraft 
		SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE
		WHERE OrganisationId = @OrganisationID;
	COMMIT;

	IF OBJECT_ID('tempdb..#InvoicesDraft') IS NOT NULL
	BEGIN
		DROP TABLE #InvoicesDraft
	END
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_InvoicesDraft', 'NEW_CLIENT1_XEROBLUE_InvoicesDraftSTAGE'
GO


--XEROBLUE_Transactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueTransactions', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueTransactions
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueTransactions
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_UniqueTransactionsSTAGE
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
        FROM dbo.NEW_CLIENT1_XEROBLUE_Transactions
        WHERE ((Source = 'MANUALJOURNALS' AND Status = 'POSTED') OR Status IN ('AUTHORISED', 'PAID'))
        AND OrganisationID = @OrganisationID
    )A WHERE RN = 1

	BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactions   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactionsSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_UniqueTransactions', 'NEW_CLIENT1_XEROBLUE_UniqueTransactionsSTAGE'
GO


--XEROBLUE_UniqueBankTransactions - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueBankTransactions', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueBankTransactions
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueBankTransactions
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_UniqueBankTransactionsSTAGE
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
    FROM dbo.NEW_CLIENT1_XEROBLUE_BankTransactions b
    INNER JOIN dbo.NEW_CLIENT1_XEROBLUE_UniqueTransactions t ON b.Id = t.LineID
    WHERE t.Source = 'BANKTRANSACTIONS' AND b.[OrganisationID] = @OrganisationID; 

    BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_UniqueBankTransactions
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_UniqueBankTransactions   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueBankTransactionsSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT;  
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_UniqueBankTransactions', 'NEW_CLIENT1_XEROBLUE_UniqueBankTransactionsSTAGE'
GO


--XEROBLUE_UniqueInvoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueInvoices', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueInvoices
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueInvoices
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_UniqueInvoicesSTAGE
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
            FROM dbo.NEW_CLIENT1_XEROBLUE_Invoices
            WHERE Status in ('AUTHORISED', 'PAID')
            AND OrganisationID = @OrganisationID
        ) Invoices
    WHERE rn = 1

    BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_UniqueInvoices
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_UniqueInvoices   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueInvoicesSTAGE
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT; 
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_UniqueInvoices', 'NEW_CLIENT1_XEROBLUE_UniqueInvoicesSTAGE'
GO


--XEROBLUE_UniqueCreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueCreditNotes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueCreditNotes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUE_UniqueCreditNotes
     @OrganisationID AS int 
AS  

    INSERT INTO NEW_CLIENT1_XEROBLUE_UniqueCreditNotesSTAGE
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
	    FROM dbo.NEW_CLIENT1_XEROBLUE_CreditNotes WHERE Status in ('AUTHORISED', 'PAID')
        AND OrganisationID = @OrganisationID
    ) t WHERE rn = 1;

    BEGIN TRANSACTION;  
        DELETE dbo.NEW_CLIENT1_XEROBLUE_UniqueCreditNotes
        WHERE [OrganisationID] = @OrganisationID;  
  
        INSERT INTO dbo.NEW_CLIENT1_XEROBLUE_UniqueCreditNotes   
        SELECT * FROM dbo.NEW_CLIENT1_XEROBLUE_UniqueCreditNotesSTAGE  
        WHERE [OrganisationID] = @OrganisationID;  
    COMMIT; 
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUE_UniqueCreditNotes', 'NEW_CLIENT1_XEROBLUE_UniqueCreditNotesSTAGE'
GO


--XEROBLUEHN_CreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes 
	WHERE OrganisationId = @OrganisationID
	AND CreditNoteId IN (SELECT CreditNoteId FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_CreditNotes', 'NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE'
GO


--XEROBLUEHN_Overpayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments 
	WHERE OrganisationId = @OrganisationID
	AND OverpaymentId IN (SELECT OverpaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Overpayments', 'NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE'
GO


--XEROBLUEHN_Prepayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments 
	WHERE OrganisationId = @OrganisationID
	AND PrepaymentId IN (SELECT PrepaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Prepayments', 'NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE'
GO


--XEROBLUEHN_Invoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Invoices 
	WHERE OrganisationId = @OrganisationID
	AND InvoiceId IN (SELECT InvoiceId FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Invoices
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Invoices', 'NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE'
GO