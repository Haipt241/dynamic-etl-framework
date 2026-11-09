/******************************************************************
APPLIED CHANGES:
DATE            CHANGES
2025-03-07      Latest version

*******************************************************************/

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_organisationsclients $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_organisationsclients()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_organisationsclients TRG
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_organisationsclients
    SELECT * FROM c1518_5393_xeroblue_organisationsclientsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_accounts $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_accounts()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    UPDATE c1518_5393_xeroblue_accountsstage
    SET
        `AccountType` = CASE 
            WHEN `Type` = 'BANK' THEN 'Bank'
            WHEN `Type` = 'CURRENT' THEN 'Current Assets'
            WHEN `Type` = 'CURRLIAB' THEN 'Current Liabilities'
            WHEN `Type` = 'DEPRECIATN' THEN 'Depreciation'
            WHEN `Type` = 'DIRECTCOSTS' THEN 'Direct Costs'
            WHEN `Type` = 'EQUITY' THEN 'Equity'
            WHEN `Type` = 'EXPENSE' THEN 'Expenses'
            WHEN `Type` = 'LIABILITY' THEN 'Non-Current Liabilities'
            WHEN `Type` = 'NONCURRENT' THEN 'Non-Current Assets'
            WHEN `Type` = 'OTHERINCOME' THEN 'Other Income'
            WHEN `Type` = 'REVENUE' THEN 'Revenue'
            WHEN `Type` = 'SALES' THEN 'Sales'
            WHEN `Type` = 'TERMLIAB' THEN 'Non-Current Liabilities'    
            WHEN `Type` = 'FIXED' THEN 'Fixed Assets'
            WHEN `Type` = 'INVENTORY' THEN 'Inventory Assets'
            WHEN `Type` = 'OVERHEADS' THEN 'Expenses'
            WHEN `Type` = 'PREPAYMENT' THEN 'Prepayment'
            WHEN `Type` = 'PAYGLIABILITY' THEN 'PAYG Liability'
            WHEN `Type` = 'SUPERANNUATIONEXPENSE' THEN 'Expenses'
            WHEN `Type` = 'SUPERANNUATIONLIABILITY' THEN 'Superannuation Liability'
            WHEN `Type` = 'WAGESEXPENSE' THEN 'Expenses'
            ELSE 'Unknown' END,
        `BalanceSheetReportingType` = CASE 
            WHEN `ReportingCode` LIKE '%EXP%' THEN 'Retained Earnings'
            WHEN `ReportingCode` LIKE '%REV%' THEN 'Retained Earnings'
            WHEN `ReportingCode` LIKE '%LIA.CUR%' THEN 'Current Liabilities'
            WHEN `ReportingCode` LIKE '%ASS.NCA.FIX%' THEN 'Fixed Assets'
            WHEN `ReportingCode` LIKE '%ASS.NCA%' THEN 'Non-Current Assets'
            WHEN `ReportingCode` LIKE '%ASS.CUR.CAS.BAN%' THEN 'Bank'
            WHEN `ReportingCode` LIKE '%ASS.CUR%' THEN 'Current Assets'
            WHEN `ReportingCode` LIKE '%LIA.NCL%' THEN 'Non-Current Liabilities'
            WHEN `ReportingCode` LIKE '%EQU%' THEN 'Equity'
            WHEN `ReportingCode` LIKE '%LIA%' AND (Type = 'LIABILITY' OR Type = 'TERMLIAB') THEN 'Non-Current Liabilities'
            WHEN `ReportingCode` LIKE '%LIA%' AND Type = 'CURRLIAB' THEN 'Current Liabilities'
            WHEN `ReportingCode` LIKE '%ASS%' AND Type = 'CURRENT' THEN 'Current Assets'
            WHEN `ReportingCode` LIKE '%ASS%' AND Type = 'BANK' THEN 'Bank'
            WHEN `ReportingCode` LIKE '%ASS%' AND Type = 'NONCURRENT' THEN 'Non-Current Assets'
            WHEN `ReportingCode` LIKE '%ASS%' AND Type = 'FIXED' THEN 'Fixed Assets'
            ELSE 'UNKNOWN' END,
        `P&LReportingTypeInterim` = CASE 
            WHEN `ReportingCode` LIKE '%ASS%' THEN 'Balance Sheet Item'
            WHEN `ReportingCode` LIKE '%LIA%' THEN 'Balance Sheet Item'
            WHEN `ReportingCode` LIKE '%REV.OTH%' THEN 'Other Income'
            WHEN `ReportingCode` LIKE '%REV.TRA%' THEN 'Trading Income'
            WHEN `ReportingCode` LIKE '%REV.INV%' THEN 'Other Income'
            WHEN `ReportingCode` LIKE '%EXP.INC%' THEN 'Non-Operating Expenses'
            WHEN `ReportingCode` LIKE '%EQU%' THEN 'Balance Sheet Item'
            WHEN `ReportingCode` LIKE '%EXP.COS%' THEN 'Cost of Sales'
            WHEN `ReportingCode` LIKE '%EXP.DIV%' THEN 'Non-Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.FOR%' THEN 'Non-Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.DEP%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.REN%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.EMP%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.INT%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.FBT%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.ENT%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.BAD%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.NON%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%REV.GRA%' THEN 'Other Income'
            WHEN `ReportingCode` LIKE '%EXP.VEH%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP.AMO%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%EXP%' THEN 'Operating Expenses'
            WHEN `ReportingCode` LIKE '%REV%' THEN 'Other Income'
            ELSE `ReportingCode` END;

    UPDATE c1518_5393_xeroblue_accountsstage
    SET
        `AccountTypeOrder` = CASE 
            WHEN `AccountType` = 'Revenue' THEN '1'
            WHEN `AccountType` = 'Sales' THEN '2'
            WHEN `AccountType` = 'Direct Costs' THEN '3'
            WHEN `AccountType` = 'Other Income' THEN '4'
            WHEN `AccountType` = 'Depreciation' THEN '5'
            WHEN `AccountType` = 'Expenses' THEN '6'
            WHEN `AccountType` = 'Bank' THEN '7'
            WHEN `AccountType` = 'Current Assets' THEN '8'
            WHEN `AccountType` = 'Non-Current Assets' THEN '9'
            WHEN `AccountType` = 'Current Liabilities' THEN '10'
            WHEN `AccountType` = 'Non-Current Liabilities' THEN '11'
            WHEN `AccountType` = 'Equity' THEN '12'
            ELSE '13' END,
        `P&LGroup` = CASE 
            WHEN `AccountType` = 'Direct Costs' THEN 'Direct Grouping'
            WHEN `AccountType` = 'Revenue' THEN 'Direct Grouping'
            WHEN `AccountType` = 'Sales' THEN 'Direct Grouping'
            WHEN `AccountType` = 'Other Income' THEN 'Other Income'
            WHEN `AccountType` = 'Expenses' THEN 'Expense'
            WHEN `AccountType` = 'Depreciation' THEN 'Expense'
            ELSE 'Unknown' END,
        `BalanceSheetType` = CASE 
            WHEN `AccountType` = 'Direct Costs' THEN 'Equity'
            WHEN `AccountType` = 'Revenue' THEN 'Equity'
            WHEN `AccountType` = 'Sales' THEN 'Equity'
            WHEN `AccountType` = 'Other Income' THEN 'Equity'
            WHEN `AccountType` = 'Expenses' THEN 'Equity'
            WHEN `AccountType` = 'Depreciation' THEN 'Equity'
            ELSE `AccountType` END,
        `StatementofCashflow` = CASE 
            WHEN `AccountType` = 'Revenue' THEN 'Receipts from customers'
            WHEN `AccountType` = 'Sales' THEN 'Receipts from customers'
            WHEN `AccountType` = 'Direct Costs' THEN 'Payments to suppliers and employees'
            WHEN `AccountType` = 'Other Income' THEN 'Cash receipts from other operating activities'
            WHEN `AccountType` = 'Fixed Assets' THEN 'Payment for property, plant and equipment'
            WHEN `AccountType` = 'Expenses' THEN 'Payments to suppliers and employees'
            WHEN `AccountType` = 'Prepayments' THEN 'Other cash items from investing activities'
            WHEN `AccountType` = 'Current Assets' THEN 'Other cash items from investing activities'
            WHEN `AccountType` = 'Non-Current Assets' THEN 'Other cash items from investing activities'
            WHEN `AccountType` = 'Current Liabilities' THEN 'Other cash items from financing activities'
            ELSE 'Working on It' END,
        `BalanceSheetReportingGroup` = CASE 
            WHEN `ReportingCode` LIKE '%ASS%' THEN 'Assets'
            WHEN `ReportingCode` LIKE '%EXP%' THEN 'Equity'
            WHEN `ReportingCode` LIKE '%LIA%' THEN 'Liabilities'
            WHEN `ReportingCode` LIKE '%REV%' THEN 'Equity'
            WHEN `ReportingCode` LIKE '%EQU%' THEN 'Equity'
            ELSE 'UNKNOWN' END,
        `P&LReportingType` = CASE
            WHEN LOCATE('.', `P&LReportingTypeInterim`) > 0 THEN 
                SUBSTRING_INDEX(`P&LReportingTypeInterim`, '.', 1)
            ELSE 
                `P&LReportingTypeInterim`
            END;

    UPDATE c1518_5393_xeroblue_accountsstage
    SET
        `BalanceSheetGroup` = CASE 
            WHEN `BalanceSheetType` = 'Equity' THEN 'Equity'
            WHEN `BalanceSheetType` = 'Retained Earnings' THEN 'Equity'
            WHEN `BalanceSheetType` = 'Current Assets' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Fixed Assets' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Prepayment' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Bank' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Non-Current Assets' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Inventory Assets' THEN 'Assets'
            WHEN `BalanceSheetType` = 'Current Liabilities' THEN 'Liabilities'
            WHEN `BalanceSheetType` = 'Term Liability' THEN 'Liabilities'
            WHEN `BalanceSheetType` = 'PAYG Liability' THEN 'Liabilities'
            WHEN `BalanceSheetType` = 'Non-Current Liabilities' THEN 'Liabilities'
            ELSE 'UNKNOWN' END,
        `CashflowActivities` = CASE 
            WHEN `StatementofCashflow` = 'Receipts from customers' THEN 'Operating Activities'
            WHEN `StatementofCashflow` = 'Payments to suppliers and employees' THEN 'Operating Activities'
            WHEN `StatementofCashflow` = 'Cash receipts from other operating activities' THEN 'Operating Activities'
            WHEN `StatementofCashflow` = 'Payment for property, plant and equipment' THEN 'Investing Activities'
            WHEN `StatementofCashflow` = 'Other cash items from investing activities' THEN 'Investing Activities'
            WHEN `StatementofCashflow` = 'Other cash items from financing activities' THEN 'Financing Activities' 
            ELSE 'Working on It' END,
        `P&LReportingGroup` = CASE 
            WHEN `P&LReportingType` = 'Trading Income' THEN 'Direct'
            WHEN `P&LReportingType` = 'Cost of Sales' THEN 'Direct'
            WHEN `P&LReportingType` = 'Other Income' THEN 'Other Income'
            WHEN `P&LReportingType` = 'Operating Expenses' THEN 'Expenses'
            WHEN `P&LReportingType` = 'Non-Operating Expenses' THEN 'Expenses'
            ELSE 'Balance Sheet Item' END;

    UPDATE c1518_5393_xeroblue_accountsstage
    SET
        `Class` = CONCAT(UPPER(LEFT(`Class`, 1)), LOWER(SUBSTRING(`Class`, 2))),
        `ClassOrder` = CASE 
            WHEN `Class` = 'REVENUE' THEN '1'
            WHEN `Class` = 'EXPENSE' THEN '2'
            WHEN `Class` = 'ASSET' THEN '3'
            WHEN `Class` = 'LIABILITY' THEN '4'
            WHEN `Class` = 'EQUITY' THEN '5'
            ELSE '6' END,
        `P&LGroupOrder` = CASE 
            WHEN `P&LGroup` = 'Direct Grouping' THEN '1'
            WHEN `P&LGroup` = 'Other Income' THEN '2'
            WHEN `P&LGroup` = 'Expense' THEN '3'
            ELSE '4' END,
        `BalanceSheetAccountName` = CASE 
            WHEN `P&LGroup` <> 'Unknown' THEN 'Retained Earnings'
            ELSE Name END,
        `BalanceSheetReportingTypeOrder` = CASE 
            WHEN `BalanceSheetReportingType` = 'Bank' THEN '1'
            WHEN `BalanceSheetReportingType` = 'Current Assets' THEN '2'
            WHEN `BalanceSheetReportingType` = 'Non-Current Assets' THEN '3'
            WHEN `BalanceSheetReportingType` = 'Fixed Assets' THEN '4'
            WHEN `BalanceSheetReportingType` = 'Current Liabilities' THEN '5'
            WHEN `BalanceSheetReportingType` = 'Non-Current Liabilities' THEN '6'
            WHEN `BalanceSheetReportingType` = 'PAYG Liability' THEN '7'
            WHEN `BalanceSheetReportingType` = 'Superannuation Liability' THEN '8'
            WHEN `BalanceSheetReportingType` = 'Retained Earnings' THEN '9'
            WHEN `BalanceSheetReportingType` = 'Equity' THEN '10'
            WHEN `BalanceSheetReportingType` = 'Revenue' THEN '11'
            WHEN `BalanceSheetReportingType` = 'Sales' THEN '12'
            WHEN `BalanceSheetReportingType` = 'Direct Costs' THEN '13'
            WHEN `BalanceSheetReportingType` = 'Expenses' THEN '14'
            WHEN `BalanceSheetReportingType` = 'Depreciation' THEN '15'
            WHEN `BalanceSheetReportingType` = 'Other Income' THEN '16'
            WHEN `BalanceSheetReportingType` = 'Overheads' THEN '17'
            WHEN `BalanceSheetReportingType` = 'Prepayment' THEN '18'
            WHEN `BalanceSheetReportingType` = 'Superannuation Expense' THEN '19'
            WHEN `BalanceSheetReportingType` = 'Wages Expense' THEN '20'
            ELSE 'Unknown' END,
        `BalanceSheetReportingGroupOrder` = CASE 
            WHEN `BalanceSheetReportingGroup` = 'Assets' THEN '1'
            WHEN `BalanceSheetReportingGroup` = 'Liabilities' THEN '2'
            WHEN `BalanceSheetReportingGroup` = 'Equity' THEN '3'
            ELSE 'Unknown' END,
        `P&LReportingGroupOrder` = CASE 
            WHEN `P&LReportingGroup` = 'Direct' THEN '1'
            WHEN `P&LReportingGroup` = 'Other Income' THEN '2'
            WHEN `P&LReportingGroup` = 'Expenses' THEN '3'
            ELSE '4' END,
        `P&LReportingTypeOrder` = CASE 
            WHEN `P&LReportingType` = 'Trading Income' THEN '1'
            WHEN `P&LReportingType` = 'Cost of Sales' THEN '2'
            WHEN `P&LReportingType` = 'Other Income' THEN '3'
            WHEN `P&LReportingType` = 'Operating Expenses' THEN '4'
            WHEN `P&LReportingType` = 'Non-Operating Expenses' THEN '5'
            ELSE '6' END,
        `BalanceSheetGroupOrder` = CASE 
            WHEN `BalanceSheetGroup` = 'Assets' THEN '1'
            WHEN `BalanceSheetGroup` = 'Liabilities' THEN '2'
            WHEN `BalanceSheetGroup` = 'Equity' THEN '3'
            ELSE '4' END,
        `CashflowActivitiesOrder` = CASE 
            WHEN `CashflowActivities` = 'Operating Activities' THEN '1'
            WHEN `CashflowActivities` = 'Investing Activities' THEN '2'
            WHEN `CashflowActivities` = 'Financing Activities' THEN '3'
            ELSE '4' END,
        `StatementofCashflowOrder` = CASE 
            WHEN `StatementofCashflow` = 'Receipts from customers' THEN '1'
            WHEN `StatementofCashflow` = 'Payments to suppliers and employees' THEN '2'
            WHEN `StatementofCashflow` = 'Cash receipts from other operating activities' THEN '3'
            WHEN `StatementofCashflow` = 'Payment for property, plant and equipment' THEN '4'
            WHEN `StatementofCashflow` = 'Other cash items from investing activities' THEN '5'
            WHEN `StatementofCashflow` = 'Other cash items from financing activities' THEN '6'
            ELSE '7' END,
        `CashIn/CashOut` = CASE 
            WHEN `Class` = 'Asset' THEN 'Cash In'
            WHEN `Class` = 'Liability' THEN 'Cash Out'
            WHEN `Class` = 'Revenue' THEN 'Cash In'
            WHEN `Class` = 'Expense' THEN 'Cash Out'
            ELSE 'UNKNOWN' END,
        `Account_UID` = CONCAT(IFNULL(`Code`, 'BLANK'), '-', `OrganisationID`),
        `AccountName_UID` = CONCAT(IFNULL(`Name`, 'BLANK'), `OrganisationID`);

    DELETE FROM c1518_xeroblue_accounts
    WHERE `OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_accounts
    SELECT * FROM c1518_5393_xeroblue_accountsstage;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_invoices $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_invoices()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

	UPDATE c1518_5393_xeroblue_invoicesstage
	SET
		`DiscountRate` = IFNULL(`LineItem_DiscountRate`, 0), 
		`DiscountRate%` = IFNULL(`LineItem_DiscountRate` * 0.01, 0),
		`LineAmountCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),     
		`LineAmountCalculationIncTax` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),    	
		`LineAmountTradeCreditorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),   
		`LineAmountTradeDebtorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),
		`DayDifference` = 
			CASE 
				WHEN NULLIF(`FullyPaidOnDate`,'') IS NOT NULL THEN DATEDIFF(CAST(`FullyPaidOnDate` AS DATE), CAST(`Date` AS DATE))
				ELSE NULL END,
		`Account_UID` = CONCAT(`LineItem_AccountCode`, '-', `OrganisationID`);

	UPDATE `c1518_5393_xeroblue_invoicesstage` AS `inv`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, 
				`Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM 
				`foreignexchange_master` AS `fx`
			WHERE 
				`fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY 
				`BaseCurrency`, 
				`Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `inv`.`CurrencyCode` 
			AND `fx`.`Date` = CASE 
				WHEN `inv`.`Date` <= v_minDate THEN v_minDate
				WHEN `inv`.`Date` >= v_maxDate THEN v_maxDate
				ELSE `inv`.`Date` 
			END
	SET  
		`LineItem_UnitAmount_AUD` = `inv`.`LineItem_UnitAmount` * `AUD`,
		`LineItem_UnitAmount_USD` = `inv`.`LineItem_UnitAmount` * `USD`,
		`LineItem_UnitAmount_NZD` = `inv`.`LineItem_UnitAmount` * `NZD`,
		`LineItem_UnitAmount_EUR` = `inv`.`LineItem_UnitAmount` * `EUR`,
		`LineItem_UnitAmount_GBP` = `inv`.`LineItem_UnitAmount` * `GBP`,
		`LineItem_TaxAmount_AUD` = `inv`.`LineItem_TaxAmount` * `AUD`,
		`LineItem_TaxAmount_USD` = `inv`.`LineItem_TaxAmount` * `USD`,
		`LineItem_TaxAmount_NZD` = `inv`.`LineItem_TaxAmount` * `NZD`,
		`LineItem_TaxAmount_EUR` = `inv`.`LineItem_TaxAmount` * `EUR`,
		`LineItem_TaxAmount_GBP` = `inv`.`LineItem_TaxAmount` * `GBP`,
		`LineItem_LineAmount_AUD` = `inv`.`LineItem_LineAmount` * `AUD`,
		`LineItem_LineAmount_USD` = `inv`.`LineItem_LineAmount` * `USD`,
		`LineItem_LineAmount_NZD` = `inv`.`LineItem_LineAmount` * `NZD`,
		`LineItem_LineAmount_EUR` = `inv`.`LineItem_LineAmount` * `EUR`,
		`LineItem_LineAmount_GBP` = `inv`.`LineItem_LineAmount` * `GBP`,
		`LineItem_DiscountAmount_AUD` = `inv`.`LineItem_DiscountAmount` * `AUD`,
		`LineItem_DiscountAmount_USD` = `inv`.`LineItem_DiscountAmount` * `USD`,
		`LineItem_DiscountAmount_NZD` = `inv`.`LineItem_DiscountAmount` * `NZD`,
		`LineItem_DiscountAmount_EUR` = `inv`.`LineItem_DiscountAmount` * `EUR`,
		`LineItem_DiscountAmount_GBP` = `inv`.`LineItem_DiscountAmount` * `GBP`,
		`SubTotal_AUD` = `inv`.`SubTotal` * `AUD`,
		`SubTotal_USD` = `inv`.`SubTotal` * `USD`,
		`SubTotal_NZD` = `inv`.`SubTotal` * `NZD`,
		`SubTotal_EUR` = `inv`.`SubTotal` * `EUR`,
		`SubTotal_GBP` = `inv`.`SubTotal` * `GBP`,
		`TotalTax_AUD` = `inv`.`TotalTax` * `AUD`,
		`TotalTax_USD` = `inv`.`TotalTax` * `USD`,
		`TotalTax_NZD` = `inv`.`TotalTax` * `NZD`,
		`TotalTax_EUR` = `inv`.`TotalTax` * `EUR`,
		`TotalTax_GBP` = `inv`.`TotalTax` * `GBP`,
		`Total_AUD` = `inv`.`Total` * `AUD`,
		`Total_USD` = `inv`.`Total` * `USD`,
		`Total_NZD` = `inv`.`Total` * `NZD`,
		`Total_EUR` = `inv`.`Total` * `EUR`,
		`Total_GBP` = `inv`.`Total` * `GBP`,
		`TotalDiscount_AUD` = `inv`.`TotalDiscount` * `AUD`,
		`TotalDiscount_USD` = `inv`.`TotalDiscount` * `USD`,
		`TotalDiscount_NZD` = `inv`.`TotalDiscount` * `NZD`,
		`TotalDiscount_EUR` = `inv`.`TotalDiscount` * `EUR`,
		`TotalDiscount_GBP` = `inv`.`TotalDiscount` * `GBP`,
		`AmountDue_AUD` = `inv`.`AmountDue` * `AUD`,
		`AmountDue_USD` = `inv`.`AmountDue` * `USD`,
		`AmountDue_NZD` = `inv`.`AmountDue` * `NZD`,
		`AmountDue_EUR` = `inv`.`AmountDue` * `EUR`,
		`AmountDue_GBP` = `inv`.`AmountDue` * `GBP`,
		`AmountPaid_AUD` = `inv`.`AmountPaid` * `AUD`,
		`AmountPaid_USD` = `inv`.`AmountPaid` * `USD`,
		`AmountPaid_NZD` = `inv`.`AmountPaid` * `NZD`,
		`AmountPaid_EUR` = `inv`.`AmountPaid` * `EUR`,
		`AmountPaid_GBP` = `inv`.`AmountPaid` * `GBP`,
		`CISDeduction_AUD` = `inv`.`CISDeduction` * `AUD`,
		`CISDeduction_USD` = `inv`.`CISDeduction` * `USD`,
		`CISDeduction_NZD` = `inv`.`CISDeduction` * `NZD`,
		`CISDeduction_EUR` = `inv`.`CISDeduction` * `EUR`,
		`CISDeduction_GBP` = `inv`.`CISDeduction` * `GBP`,
		`AmountCredited_AUD` = `inv`.`AmountCredited` * `AUD`,
		`AmountCredited_USD` = `inv`.`AmountCredited` * `USD`,
		`AmountCredited_NZD` = `inv`.`AmountCredited` * `NZD`,
		`AmountCredited_EUR` = `inv`.`AmountCredited` * `EUR`,
		`AmountCredited_GBP` = `inv`.`AmountCredited` * `GBP`,
		`LineAmountCalculation_AUD` = `inv`.`LineAmountCalculation` * `AUD`,
		`LineAmountCalculation_USD` = `inv`.`LineAmountCalculation` * `USD`,
		`LineAmountCalculation_NZD` = `inv`.`LineAmountCalculation` * `NZD`,
		`LineAmountCalculation_EUR` = `inv`.`LineAmountCalculation` * `EUR`,
		`LineAmountCalculation_GBP` = `inv`.`LineAmountCalculation` * `GBP`,
		`LineAmountCalculationIncTax_AUD` = `inv`.`LineAmountCalculationIncTax` * `AUD`,
		`LineAmountCalculationIncTax_USD` = `inv`.`LineAmountCalculationIncTax` * `USD`,
		`LineAmountCalculationIncTax_NZD` = `inv`.`LineAmountCalculationIncTax` * `NZD`,
		`LineAmountCalculationIncTax_EUR` = `inv`.`LineAmountCalculationIncTax` * `EUR`,
		`LineAmountCalculationIncTax_GBP` = `inv`.`LineAmountCalculationIncTax` * `GBP`,
		`LineAmountTradeCreditorCalculation_AUD` = `inv`.`LineAmountTradeCreditorCalculation` * `AUD`,
		`LineAmountTradeCreditorCalculation_USD` = `inv`.`LineAmountTradeCreditorCalculation` * `USD`,
		`LineAmountTradeCreditorCalculation_NZD` = `inv`.`LineAmountTradeCreditorCalculation` * `NZD`,
		`LineAmountTradeCreditorCalculation_EUR` = `inv`.`LineAmountTradeCreditorCalculation` * `EUR`,
		`LineAmountTradeCreditorCalculation_GBP` = `inv`.`LineAmountTradeCreditorCalculation` * `GBP`,
		`LineAmountTradeDebtorCalculation_AUD` = `inv`.`LineAmountTradeDebtorCalculation` * `AUD`,
		`LineAmountTradeDebtorCalculation_USD` = `inv`.`LineAmountTradeDebtorCalculation` * `USD`,
		`LineAmountTradeDebtorCalculation_NZD` = `inv`.`LineAmountTradeDebtorCalculation` * `NZD`,
		`LineAmountTradeDebtorCalculation_EUR` = `inv`.`LineAmountTradeDebtorCalculation` * `EUR`,
		`LineAmountTradeDebtorCalculation_GBP` = `inv`.`LineAmountTradeDebtorCalculation` * `GBP`;

    DELETE TRG
	FROM c1518_xeroblue_invoices TRG
    INNER JOIN c1518_5393_xeroblue_invoicesstage STG 
	ON TRG.`InvoiceId` = STG.`InvoiceId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_invoices (
        `Id`,
        `InvoiceId`,
        `Type`,
        `ContactId`,
        `ContactName`,
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
        `LineItem_DiscountAmount`,
        `LineItemAggregate`,
        `Date`,
        `DueDate`,
        `LineAmountTypes`,
        `InvoiceNumber`,
        `Reference`,
        `BrandingThemeId`,
        `URL`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Status`,
        `SentToContact`,
        `ExpectedPaymentDate`,
        `PlannedPaymentDate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        `PaymentIds`,
        `PrePaymentIds`,
        `OverPaymentIds`,
        `CreditNoteIds`,
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        `FullyPaidOnDate`,
        `AmountCredited`,
        `UpdatedDateUTC`,
        `CreditNotes`,
        `Prepayments`,
        `Payments`,
        `Overpayments`,
        `RepeatingInvoiceID`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`,
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    )
    SELECT
        NULLIF(`Id`, ''),
        NULLIF(`InvoiceId`, ''),
        NULLIF(`Type`, ''),
        NULLIF(`ContactId`, ''),
        NULLIF(`ContactName`, ''),
        NULLIF(`LineItem_LineItemId`, ''),
        NULLIF(`LineItem_Description`, ''),
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        NULLIF(`LineItem_ItemCode`, ''),
        NULLIF(`LineItem_AccountCode`, ''),
        NULLIF(`LineItem_TaxType`, ''),
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        NULLIF(`LineItem_TrackingCategory1_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory1_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory1_Option_Stat`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory2_Option_Stat`, ''),
        `LineItem_DiscountRate`,
        `LineItem_DiscountAmount`,
        NULLIF(`LineItemAggregate`, ''),
        NULLIF(`Date`, ''),
        NULLIF(`DueDate`, ''),
        NULLIF(`LineAmountTypes`, ''),
        NULLIF(`InvoiceNumber`, ''),
        NULLIF(`Reference`, ''),
        NULLIF(`BrandingThemeId`, ''),
        NULLIF(`URL`, ''),
        NULLIF(`CurrencyCode`, ''),
        `CurrencyRate`,
        NULLIF(`Status`, ''),
        `SentToContact`,
        NULLIF(`ExpectedPaymentDate`, ''),
        NULLIF(`PlannedPaymentDate`, ''),
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        NULLIF(`PaymentIds`, ''),
        NULLIF(`PrePaymentIds`, ''),
        NULLIF(`OverPaymentIds`, ''),
        NULLIF(`CreditNoteIds`, ''),
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        NULLIF(`FullyPaidOnDate`, ''),
        `AmountCredited`,
        NULLIF(`UpdatedDateUTC`, ''),
        NULLIF(`CreditNotes`, ''),
        NULLIF(`Prepayments`, ''),
        NULLIF(`Payments`, ''),
        NULLIF(`Overpayments`, ''),
        NULLIF(`RepeatingInvoiceID`, ''),
        NULLIF(`ClientID`, ''),
        NULLIF(`OrganisationID`, ''),
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`, 
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    FROM c1518_5393_xeroblue_invoicesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_creditnotes $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_creditnotes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    CREATE TEMPORARY TABLE IF NOT EXISTS FXTable (
        `BaseCurrency` VARCHAR(10),
        `Date` DATE,
        `AUD` DECIMAL(10, 4),
        `USD` DECIMAL(10, 4),
        `NZD` DECIMAL(10, 4),
        `EUR` DECIMAL(10, 4),
        `GBP` DECIMAL(10, 4)
    );

    INSERT INTO FXTable (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
    GROUP BY `BaseCurrency`, `Date`;

    UPDATE c1518_5393_xeroblue_creditnotesstage
	SET
		`LineAmountCreditNoteCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAYCREDIT' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCPAYCREDIT' THEN 0 - (`LineItem_LineAmount`)
                WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeCreditorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAYCREDIT' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCPAYCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCPAYCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeDebtorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCRECCREDIT' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        );

    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx ON fx.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN crdt.`Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Date` 
								END
    SET  `LineItem_UnitAmount_AUD` = crdt.`LineItem_UnitAmount` * fx.`AUD`
		,`LineItem_UnitAmount_USD` = crdt.`LineItem_UnitAmount` * fx.`USD`
		,`LineItem_UnitAmount_NZD` = crdt.`LineItem_UnitAmount` * fx.`NZD`
		,`LineItem_UnitAmount_EUR` = crdt.`LineItem_UnitAmount` * fx.`EUR`
		,`LineItem_UnitAmount_GBP` = crdt.`LineItem_UnitAmount` * fx.`GBP`
		,`LineItem_TaxAmount_AUD` = crdt.`LineItem_TaxAmount` * fx.`AUD`
		,`LineItem_TaxAmount_USD` = crdt.`LineItem_TaxAmount` * fx.`USD`
		,`LineItem_TaxAmount_NZD` = crdt.`LineItem_TaxAmount` * fx.`NZD`
		,`LineItem_TaxAmount_EUR` = crdt.`LineItem_TaxAmount` * fx.`EUR`
		,`LineItem_TaxAmount_GBP` = crdt.`LineItem_TaxAmount` * fx.`GBP`
		,`LineItem_LineAmount_AUD` = crdt.`LineItem_LineAmount` * fx.`AUD`
		,`LineItem_LineAmount_USD` = crdt.`LineItem_LineAmount` * fx.`USD`
		,`LineItem_LineAmount_NZD` = crdt.`LineItem_LineAmount` * fx.`NZD`
		,`LineItem_LineAmount_EUR` = crdt.`LineItem_LineAmount` * fx.`EUR`
		,`LineItem_LineAmount_GBP` = crdt.`LineItem_LineAmount` * fx.`GBP`
		,`SubTotal_AUD` = crdt.`SubTotal` * fx.`AUD`
		,`SubTotal_USD` = crdt.`SubTotal` * fx.`USD`
		,`SubTotal_NZD` = crdt.`SubTotal` * fx.`NZD`
		,`SubTotal_EUR` = crdt.`SubTotal` * fx.`EUR`
		,`SubTotal_GBP` = crdt.`SubTotal` * fx.`GBP`
		,`TotalTax_AUD` = crdt.`TotalTax` * fx.`AUD`
		,`TotalTax_USD` = crdt.`TotalTax` * fx.`USD`
		,`TotalTax_NZD` = crdt.`TotalTax` * fx.`NZD`
		,`TotalTax_EUR` = crdt.`TotalTax` * fx.`EUR`
		,`TotalTax_GBP` = crdt.`TotalTax` * fx.`GBP`
		,`Total_AUD` = crdt.`Total` * fx.`AUD`
		,`Total_USD` = crdt.`Total` * fx.`USD`
		,`Total_NZD` = crdt.`Total` * fx.`NZD`
		,`Total_EUR` = crdt.`Total` * fx.`EUR`
		,`Total_GBP` = crdt.`Total` * fx.`GBP`
		,`RemainingCredit_AUD` = crdt.`RemainingCredit` * fx.`AUD`
		,`RemainingCredit_USD` = crdt.`RemainingCredit` * fx.`USD`
		,`RemainingCredit_NZD` = crdt.`RemainingCredit` * fx.`NZD`
		,`RemainingCredit_EUR` = crdt.`RemainingCredit` * fx.`EUR`
		,`RemainingCredit_GBP` = crdt.`RemainingCredit` * fx.`GBP`
        ,`LineAmountCreditNoteCalculation_AUD` = crdt.`LineAmountCreditNoteCalculation` * fx.`AUD`
        ,`LineAmountCreditNoteCalculation_USD` = crdt.`LineAmountCreditNoteCalculation` * fx.`USD`
        ,`LineAmountCreditNoteCalculation_NZD` = crdt.`LineAmountCreditNoteCalculation` * fx.`NZD`
        ,`LineAmountCreditNoteCalculation_EUR` = crdt.`LineAmountCreditNoteCalculation` * fx.`EUR`
        ,`LineAmountCreditNoteCalculation_GBP` = crdt.`LineAmountCreditNoteCalculation` * fx.`GBP`
        ,`LineAmountTradeCreditorCalculation_AUD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`AUD`
        ,`LineAmountTradeCreditorCalculation_USD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`USD`
        ,`LineAmountTradeCreditorCalculation_NZD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`NZD`
        ,`LineAmountTradeCreditorCalculation_EUR` = crdt.`LineAmountTradeCreditorCalculation` * fx.`EUR`
        ,`LineAmountTradeCreditorCalculation_GBP` = crdt.`LineAmountTradeCreditorCalculation` * fx.`GBP`
        ,`LineAmountTradeDebtorCalculation_AUD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`AUD`
        ,`LineAmountTradeDebtorCalculation_USD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`USD`
        ,`LineAmountTradeDebtorCalculation_NZD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`NZD`
        ,`LineAmountTradeDebtorCalculation_EUR` = crdt.`LineAmountTradeDebtorCalculation` * fx.`EUR`
        ,`LineAmountTradeDebtorCalculation_GBP` = crdt.`LineAmountTradeDebtorCalculation` * fx.`GBP`;


    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx1 ON fx1.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx1.`Date` = CASE 
									WHEN crdt.`Allocation1_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation1_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation1_Date` 
								END
	SET `Allocation1_AppliedAmount_AUD` = crdt.`Allocation1_AppliedAmount` * fx1.`AUD`
		,`Allocation1_AppliedAmount_USD` = crdt.`Allocation1_AppliedAmount` * fx1.`USD`
		,`Allocation1_AppliedAmount_NZD` = crdt.`Allocation1_AppliedAmount` * fx1.`NZD`
		,`Allocation1_AppliedAmount_EUR` = crdt.`Allocation1_AppliedAmount` * fx1.`EUR`
		,`Allocation1_AppliedAmount_GBP` = crdt.`Allocation1_AppliedAmount` * fx1.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx2 ON fx2.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx2.`Date` = CASE 
									WHEN crdt.`Allocation2_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation2_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation2_Date` 
								END
	SET `Allocation2_AppliedAmount_AUD` = crdt.`Allocation2_AppliedAmount` * fx2.`AUD`
		,`Allocation2_AppliedAmount_USD` = crdt.`Allocation2_AppliedAmount` * fx2.`USD`
		,`Allocation2_AppliedAmount_NZD` = crdt.`Allocation2_AppliedAmount` * fx2.`NZD`
		,`Allocation2_AppliedAmount_EUR` = crdt.`Allocation2_AppliedAmount` * fx2.`EUR`
		,`Allocation2_AppliedAmount_GBP` = crdt.`Allocation2_AppliedAmount` * fx2.`GBP`;

    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx3 ON fx3.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx3.`Date` = CASE 
									WHEN crdt.`Allocation3_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation3_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation3_Date` 
								END
	SET `Allocation3_AppliedAmount_AUD` = crdt.`Allocation3_AppliedAmount` * fx3.`AUD`
		,`Allocation3_AppliedAmount_USD` = crdt.`Allocation3_AppliedAmount` * fx3.`USD`
		,`Allocation3_AppliedAmount_NZD` = crdt.`Allocation3_AppliedAmount` * fx3.`NZD`
		,`Allocation3_AppliedAmount_EUR` = crdt.`Allocation3_AppliedAmount` * fx3.`EUR`
		,`Allocation3_AppliedAmount_GBP` = crdt.`Allocation3_AppliedAmount` * fx3.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx4 ON fx4.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx4.`Date` = CASE 
									WHEN crdt.`Allocation4_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation4_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation4_Date` 
								END
	SET `Allocation4_AppliedAmount_AUD` = crdt.`Allocation4_AppliedAmount` * fx4.`AUD`
		,`Allocation4_AppliedAmount_USD` = crdt.`Allocation4_AppliedAmount` * fx4.`USD`
		,`Allocation4_AppliedAmount_NZD` = crdt.`Allocation4_AppliedAmount` * fx4.`NZD`
		,`Allocation4_AppliedAmount_EUR` = crdt.`Allocation4_AppliedAmount` * fx4.`EUR`
		,`Allocation4_AppliedAmount_GBP` = crdt.`Allocation4_AppliedAmount` * fx4.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx5 ON fx5.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx5.`Date` = CASE 
									WHEN crdt.`Allocation5_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation5_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation5_Date` 
								END
	SET `Allocation5_AppliedAmount_AUD` = crdt.`Allocation5_AppliedAmount` * fx5.`AUD`
		,`Allocation5_AppliedAmount_USD` = crdt.`Allocation5_AppliedAmount` * fx5.`USD`
		,`Allocation5_AppliedAmount_NZD` = crdt.`Allocation5_AppliedAmount` * fx5.`NZD`
		,`Allocation5_AppliedAmount_EUR` = crdt.`Allocation5_AppliedAmount` * fx5.`EUR`
		,`Allocation5_AppliedAmount_GBP` = crdt.`Allocation5_AppliedAmount` * fx5.`GBP`;

    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx6 ON fx6.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx6.`Date` = CASE 
									WHEN crdt.`Allocation6_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation6_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation6_Date` 
								END
	SET `Allocation6_AppliedAmount_AUD` = crdt.`Allocation6_AppliedAmount` * fx6.`AUD`
		,`Allocation6_AppliedAmount_USD` = crdt.`Allocation6_AppliedAmount` * fx6.`USD`
		,`Allocation6_AppliedAmount_NZD` = crdt.`Allocation6_AppliedAmount` * fx6.`NZD`
		,`Allocation6_AppliedAmount_EUR` = crdt.`Allocation6_AppliedAmount` * fx6.`EUR`
		,`Allocation6_AppliedAmount_GBP` = crdt.`Allocation6_AppliedAmount` * fx6.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx7 ON fx7.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx7.`Date` = CASE 
									WHEN crdt.`Allocation7_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation7_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation7_Date` 
								END
	SET `Allocation7_AppliedAmount_AUD` = crdt.`Allocation7_AppliedAmount` * fx7.`AUD`
		,`Allocation7_AppliedAmount_USD` = crdt.`Allocation7_AppliedAmount` * fx7.`USD`
		,`Allocation7_AppliedAmount_NZD` = crdt.`Allocation7_AppliedAmount` * fx7.`NZD`
		,`Allocation7_AppliedAmount_EUR` = crdt.`Allocation7_AppliedAmount` * fx7.`EUR`
		,`Allocation7_AppliedAmount_GBP` = crdt.`Allocation7_AppliedAmount` * fx7.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx8 ON fx8.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx8.`Date` = CASE 
									WHEN crdt.`Allocation8_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation8_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation8_Date` 
								END
	SET `Allocation8_AppliedAmount_AUD` = crdt.`Allocation8_AppliedAmount` * fx8.`AUD`
		,`Allocation8_AppliedAmount_USD` = crdt.`Allocation8_AppliedAmount` * fx8.`USD`
		,`Allocation8_AppliedAmount_NZD` = crdt.`Allocation8_AppliedAmount` * fx8.`NZD`
		,`Allocation8_AppliedAmount_EUR` = crdt.`Allocation8_AppliedAmount` * fx8.`EUR`
		,`Allocation8_AppliedAmount_GBP` = crdt.`Allocation8_AppliedAmount` * fx8.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx9 ON fx9.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx9.`Date` = CASE 
									WHEN crdt.`Allocation9_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation9_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation9_Date` 
								END
	SET `Allocation9_AppliedAmount_AUD` = crdt.`Allocation9_AppliedAmount` * fx9.`AUD`
		,`Allocation9_AppliedAmount_USD` = crdt.`Allocation9_AppliedAmount` * fx9.`USD`
		,`Allocation9_AppliedAmount_NZD` = crdt.`Allocation9_AppliedAmount` * fx9.`NZD`
		,`Allocation9_AppliedAmount_EUR` = crdt.`Allocation9_AppliedAmount` * fx9.`EUR`
		,`Allocation9_AppliedAmount_GBP` = crdt.`Allocation9_AppliedAmount` * fx9.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx10 ON fx10.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx10.`Date` = CASE 
									WHEN crdt.`Allocation10_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation10_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation10_Date` 
								END
	SET `Allocation10_AppliedAmount_AUD` = crdt.`Allocation10_AppliedAmount` * fx10.`AUD`
		,`Allocation10_AppliedAmount_USD` = crdt.`Allocation10_AppliedAmount` * fx10.`USD`
		,`Allocation10_AppliedAmount_NZD` = crdt.`Allocation10_AppliedAmount` * fx10.`NZD`
		,`Allocation10_AppliedAmount_EUR` = crdt.`Allocation10_AppliedAmount` * fx10.`EUR`
		,`Allocation10_AppliedAmount_GBP` = crdt.`Allocation10_AppliedAmount` * fx10.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx11 ON fx11.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx11.`Date` = CASE 
									WHEN crdt.`Allocation11_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation11_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation11_Date` 
								END
	SET `Allocation11_AppliedAmount_AUD` = crdt.`Allocation11_AppliedAmount` * fx11.`AUD`
		,`Allocation11_AppliedAmount_USD` = crdt.`Allocation11_AppliedAmount` * fx11.`USD`
		,`Allocation11_AppliedAmount_NZD` = crdt.`Allocation11_AppliedAmount` * fx11.`NZD`
		,`Allocation11_AppliedAmount_EUR` = crdt.`Allocation11_AppliedAmount` * fx11.`EUR`
		,`Allocation11_AppliedAmount_GBP` = crdt.`Allocation11_AppliedAmount` * fx11.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx12 ON fx12.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx12.`Date` = CASE 
									WHEN crdt.`Allocation12_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation12_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation12_Date` 
								END
	SET `Allocation12_AppliedAmount_AUD` = crdt.`Allocation12_AppliedAmount` * fx12.`AUD`
		,`Allocation12_AppliedAmount_USD` = crdt.`Allocation12_AppliedAmount` * fx12.`USD`
		,`Allocation12_AppliedAmount_NZD` = crdt.`Allocation12_AppliedAmount` * fx12.`NZD`
		,`Allocation12_AppliedAmount_EUR` = crdt.`Allocation12_AppliedAmount` * fx12.`EUR`
		,`Allocation12_AppliedAmount_GBP` = crdt.`Allocation12_AppliedAmount` * fx12.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx13 ON fx13.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx13.`Date` = CASE 
									WHEN crdt.`Allocation13_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation13_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation13_Date` 
								END
	SET `Allocation13_AppliedAmount_AUD` = crdt.`Allocation13_AppliedAmount` * fx13.`AUD`
		,`Allocation13_AppliedAmount_USD` = crdt.`Allocation13_AppliedAmount` * fx13.`USD`
		,`Allocation13_AppliedAmount_NZD` = crdt.`Allocation13_AppliedAmount` * fx13.`NZD`
		,`Allocation13_AppliedAmount_EUR` = crdt.`Allocation13_AppliedAmount` * fx13.`EUR`
		,`Allocation13_AppliedAmount_GBP` = crdt.`Allocation13_AppliedAmount` * fx13.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx14 ON fx14.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx14.`Date` = CASE 
									WHEN crdt.`Allocation14_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation14_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation14_Date` 
								END
	SET `Allocation14_AppliedAmount_AUD` = crdt.`Allocation14_AppliedAmount` * fx14.`AUD`
		,`Allocation14_AppliedAmount_USD` = crdt.`Allocation14_AppliedAmount` * fx14.`USD`
		,`Allocation14_AppliedAmount_NZD` = crdt.`Allocation14_AppliedAmount` * fx14.`NZD`
		,`Allocation14_AppliedAmount_EUR` = crdt.`Allocation14_AppliedAmount` * fx14.`EUR`
		,`Allocation14_AppliedAmount_GBP` = crdt.`Allocation14_AppliedAmount` * fx14.`GBP`;
    
    UPDATE c1518_5393_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx15 ON fx15.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx15.`Date` = CASE 
									WHEN crdt.`Allocation15_Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Allocation15_Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Allocation15_Date` 
								END
	SET `Allocation15_AppliedAmount_AUD` = crdt.`Allocation15_AppliedAmount` * fx15.`AUD`
		,`Allocation15_AppliedAmount_USD` = crdt.`Allocation15_AppliedAmount` * fx15.`USD`
		,`Allocation15_AppliedAmount_NZD` = crdt.`Allocation15_AppliedAmount` * fx15.`NZD`
		,`Allocation15_AppliedAmount_EUR` = crdt.`Allocation15_AppliedAmount` * fx15.`EUR`
		,`Allocation15_AppliedAmount_GBP` = crdt.`Allocation15_AppliedAmount` * fx15.`GBP`;

    DELETE TRG
	FROM c1518_xeroblue_creditnotes TRG
    INNER JOIN c1518_5393_xeroblue_creditnotesstage STG 
	ON TRG.`CreditNoteId` = STG.`CreditNoteId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_creditnotes (
        `Id`,
        `CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Date`,
        `Status`,
        `LineAmountTypes`,
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
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `UpdatedDateUTC`,
        `CurrencyCode`,
        `FullyPaidOnDate`,
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `Allocation11_AppliedAmount`,
        `Allocation11_Date`,
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        `Allocation12_AppliedAmount`,
        `Allocation12_Date`,
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        `Allocation13_AppliedAmount`,
        `Allocation13_Date`,
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        `Allocation14_AppliedAmount`,
        `Allocation14_Date`,
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        `Allocation15_AppliedAmount`,
        `Allocation15_Date`,
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`,
        `Allocation11_AppliedAmount_AUD`,
        `Allocation11_AppliedAmount_USD`,
        `Allocation11_AppliedAmount_NZD`,
        `Allocation11_AppliedAmount_EUR`,
        `Allocation11_AppliedAmount_GBP`,
        `Allocation12_AppliedAmount_AUD`,
        `Allocation12_AppliedAmount_USD`,
        `Allocation12_AppliedAmount_NZD`,
        `Allocation12_AppliedAmount_EUR`,
        `Allocation12_AppliedAmount_GBP`,
        `Allocation13_AppliedAmount_AUD`,
        `Allocation13_AppliedAmount_USD`,
        `Allocation13_AppliedAmount_NZD`,
        `Allocation13_AppliedAmount_EUR`,
        `Allocation13_AppliedAmount_GBP`,
        `Allocation14_AppliedAmount_AUD`,
        `Allocation14_AppliedAmount_USD`,
        `Allocation14_AppliedAmount_NZD`,
        `Allocation14_AppliedAmount_EUR`,
        `Allocation14_AppliedAmount_GBP`,
        `Allocation15_AppliedAmount_AUD`,
        `Allocation15_AppliedAmount_USD`,
        `Allocation15_AppliedAmount_NZD`,
        `Allocation15_AppliedAmount_EUR`,
        `Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    )
    SELECT
        `Id`,
        `CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        NULLIF(`Date`, ''),
        `Status`,
        `LineAmountTypes`,
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
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        NULLIF(`UpdatedDateUTC`, ''),
        `CurrencyCode`,
        NULLIF(`FullyPaidOnDate`, ''),
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
        `Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, ''),
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `Allocation11_AppliedAmount`,
        NULLIF(`Allocation11_Date`, ''),
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        `Allocation12_AppliedAmount`,
        NULLIF(`Allocation12_Date`, ''),
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        `Allocation13_AppliedAmount`,
        NULLIF(`Allocation13_Date`, ''),
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        `Allocation14_AppliedAmount`,
        NULLIF(`Allocation14_Date`, ''),
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        `Allocation15_AppliedAmount`,
        NULLIF(`Allocation15_Date`, ''),
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`,
        `Allocation11_AppliedAmount_AUD`,
        `Allocation11_AppliedAmount_USD`,
        `Allocation11_AppliedAmount_NZD`,
        `Allocation11_AppliedAmount_EUR`,
        `Allocation11_AppliedAmount_GBP`,
        `Allocation12_AppliedAmount_AUD`,
        `Allocation12_AppliedAmount_USD`,
        `Allocation12_AppliedAmount_NZD`,
        `Allocation12_AppliedAmount_EUR`,
        `Allocation12_AppliedAmount_GBP`,
        `Allocation13_AppliedAmount_AUD`,
        `Allocation13_AppliedAmount_USD`,
        `Allocation13_AppliedAmount_NZD`,
        `Allocation13_AppliedAmount_EUR`,
        `Allocation13_AppliedAmount_GBP`,
        `Allocation14_AppliedAmount_AUD`,
        `Allocation14_AppliedAmount_USD`,
        `Allocation14_AppliedAmount_NZD`,
        `Allocation14_AppliedAmount_EUR`,
        `Allocation14_AppliedAmount_GBP`,
        `Allocation15_AppliedAmount_AUD`,
        `Allocation15_AppliedAmount_USD`,
        `Allocation15_AppliedAmount_NZD`,
        `Allocation15_AppliedAmount_EUR`,
        `Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    FROM c1518_5393_xeroblue_creditnotesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_overpayments $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_overpayments()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    CREATE TEMPORARY TABLE IF NOT EXISTS FXTable (
        `BaseCurrency` VARCHAR(10),
        `Date` DATE,
        `AUD` DECIMAL(10, 4),
        `USD` DECIMAL(10, 4),
        `NZD` DECIMAL(10, 4),
        `EUR` DECIMAL(10, 4),
        `GBP` DECIMAL(10, 4)
    );

    INSERT INTO FXTable (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
    GROUP BY `BaseCurrency`, `Date`;

    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx ON fx.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN ovrpymt.`Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Date` 
								END
    SET `RemainingCredit_AUD` = ovrpymt.`RemainingCredit` * fx.`AUD`,
        `RemainingCredit_USD` = ovrpymt.`RemainingCredit` * fx.`USD`,
        `RemainingCredit_NZD` = ovrpymt.`RemainingCredit` * fx.`NZD`,
        `RemainingCredit_EUR` = ovrpymt.`RemainingCredit` * fx.`EUR`,
        `RemainingCredit_GBP` = ovrpymt.`RemainingCredit` * fx.`GBP`,
        `SubTotal_AUD` = ovrpymt.`SubTotal` * fx.`AUD`,
        `SubTotal_USD` = ovrpymt.`SubTotal` * fx.`USD`,
        `SubTotal_NZD` = ovrpymt.`SubTotal` * fx.`NZD`,
        `SubTotal_EUR` = ovrpymt.`SubTotal` * fx.`EUR`,
        `SubTotal_GBP` = ovrpymt.`SubTotal` * fx.`GBP`,
        `TotalTax_AUD` = ovrpymt.`TotalTax` * fx.`AUD`,
        `TotalTax_USD` = ovrpymt.`TotalTax` * fx.`USD`,
        `TotalTax_NZD` = ovrpymt.`TotalTax` * fx.`NZD`,
        `TotalTax_EUR` = ovrpymt.`TotalTax` * fx.`EUR`,
        `TotalTax_GBP` = ovrpymt.`TotalTax` * fx.`GBP`,
        `Total_AUD` = ovrpymt.`Total` * fx.`AUD`,
        `Total_USD` = ovrpymt.`Total` * fx.`USD`,
        `Total_NZD` = ovrpymt.`Total` * fx.`NZD`,
        `Total_EUR` = ovrpymt.`Total` * fx.`EUR`,
        `Total_GBP` = ovrpymt.`Total` * fx.`GBP`,
        `LineItem_UnitAmount_AUD` = ovrpymt.`LineItem_UnitAmount` * fx.`AUD`,
        `LineItem_UnitAmount_USD` = ovrpymt.`LineItem_UnitAmount` * fx.`USD`,
        `LineItem_UnitAmount_NZD` = ovrpymt.`LineItem_UnitAmount` * fx.`NZD`,
        `LineItem_UnitAmount_EUR` = ovrpymt.`LineItem_UnitAmount` * fx.`EUR`,
        `LineItem_UnitAmount_GBP` = ovrpymt.`LineItem_UnitAmount` * fx.`GBP`,
        `LineItem_TaxAmount_AUD` = ovrpymt.`LineItem_TaxAmount` * fx.`AUD`,
        `LineItem_TaxAmount_USD` = ovrpymt.`LineItem_TaxAmount` * fx.`USD`,
        `LineItem_TaxAmount_NZD` = ovrpymt.`LineItem_TaxAmount` * fx.`NZD`,
        `LineItem_TaxAmount_EUR` = ovrpymt.`LineItem_TaxAmount` * fx.`EUR`,
        `LineItem_TaxAmount_GBP` = ovrpymt.`LineItem_TaxAmount` * fx.`GBP`,
        `LineItem_LineAmount_AUD` = ovrpymt.`LineItem_LineAmount` * fx.`AUD`,
        `LineItem_LineAmount_USD` = ovrpymt.`LineItem_LineAmount` * fx.`USD`,
        `LineItem_LineAmount_NZD` = ovrpymt.`LineItem_LineAmount` * fx.`NZD`,
        `LineItem_LineAmount_EUR` = ovrpymt.`LineItem_LineAmount` * fx.`EUR`,
        `LineItem_LineAmount_GBP` = ovrpymt.`LineItem_LineAmount` * fx.`GBP`;

    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx1 ON fx1.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx1.`Date` = CASE 
									WHEN ovrpymt.`Allocation1_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation1_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation1_Date` 
								END
	SET `Allocation1_AppliedAmount_AUD` = ovrpymt.`Allocation1_AppliedAmount` * fx1.`AUD`
		,`Allocation1_AppliedAmount_USD` = ovrpymt.`Allocation1_AppliedAmount` * fx1.`USD`
		,`Allocation1_AppliedAmount_NZD` = ovrpymt.`Allocation1_AppliedAmount` * fx1.`NZD`
		,`Allocation1_AppliedAmount_EUR` = ovrpymt.`Allocation1_AppliedAmount` * fx1.`EUR`
		,`Allocation1_AppliedAmount_GBP` = ovrpymt.`Allocation1_AppliedAmount` * fx1.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx2 ON fx2.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx2.`Date` = CASE 
									WHEN ovrpymt.`Allocation2_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation2_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation2_Date` 
								END
	SET `Allocation2_AppliedAmount_AUD` = ovrpymt.`Allocation2_AppliedAmount` * fx2.`AUD`
		,`Allocation2_AppliedAmount_USD` = ovrpymt.`Allocation2_AppliedAmount` * fx2.`USD`
		,`Allocation2_AppliedAmount_NZD` = ovrpymt.`Allocation2_AppliedAmount` * fx2.`NZD`
		,`Allocation2_AppliedAmount_EUR` = ovrpymt.`Allocation2_AppliedAmount` * fx2.`EUR`
		,`Allocation2_AppliedAmount_GBP` = ovrpymt.`Allocation2_AppliedAmount` * fx2.`GBP`;

    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx3 ON fx3.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx3.`Date` = CASE 
									WHEN ovrpymt.`Allocation3_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation3_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation3_Date` 
								END
	SET `Allocation3_AppliedAmount_AUD` = ovrpymt.`Allocation3_AppliedAmount` * fx3.`AUD`
		,`Allocation3_AppliedAmount_USD` = ovrpymt.`Allocation3_AppliedAmount` * fx3.`USD`
		,`Allocation3_AppliedAmount_NZD` = ovrpymt.`Allocation3_AppliedAmount` * fx3.`NZD`
		,`Allocation3_AppliedAmount_EUR` = ovrpymt.`Allocation3_AppliedAmount` * fx3.`EUR`
		,`Allocation3_AppliedAmount_GBP` = ovrpymt.`Allocation3_AppliedAmount` * fx3.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx4 ON fx4.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx4.`Date` = CASE 
									WHEN ovrpymt.`Allocation4_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation4_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation4_Date` 
								END
	SET `Allocation4_AppliedAmount_AUD` = ovrpymt.`Allocation4_AppliedAmount` * fx4.`AUD`
		,`Allocation4_AppliedAmount_USD` = ovrpymt.`Allocation4_AppliedAmount` * fx4.`USD`
		,`Allocation4_AppliedAmount_NZD` = ovrpymt.`Allocation4_AppliedAmount` * fx4.`NZD`
		,`Allocation4_AppliedAmount_EUR` = ovrpymt.`Allocation4_AppliedAmount` * fx4.`EUR`
		,`Allocation4_AppliedAmount_GBP` = ovrpymt.`Allocation4_AppliedAmount` * fx4.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx5 ON fx5.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx5.`Date` = CASE 
									WHEN ovrpymt.`Allocation5_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation5_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation5_Date` 
								END
	SET `Allocation5_AppliedAmount_AUD` = ovrpymt.`Allocation5_AppliedAmount` * fx5.`AUD`
		,`Allocation5_AppliedAmount_USD` = ovrpymt.`Allocation5_AppliedAmount` * fx5.`USD`
		,`Allocation5_AppliedAmount_NZD` = ovrpymt.`Allocation5_AppliedAmount` * fx5.`NZD`
		,`Allocation5_AppliedAmount_EUR` = ovrpymt.`Allocation5_AppliedAmount` * fx5.`EUR`
		,`Allocation5_AppliedAmount_GBP` = ovrpymt.`Allocation5_AppliedAmount` * fx5.`GBP`;

    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx6 ON fx6.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx6.`Date` = CASE 
									WHEN ovrpymt.`Allocation6_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation6_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation6_Date` 
								END
	SET `Allocation6_AppliedAmount_AUD` = ovrpymt.`Allocation6_AppliedAmount` * fx6.`AUD`
		,`Allocation6_AppliedAmount_USD` = ovrpymt.`Allocation6_AppliedAmount` * fx6.`USD`
		,`Allocation6_AppliedAmount_NZD` = ovrpymt.`Allocation6_AppliedAmount` * fx6.`NZD`
		,`Allocation6_AppliedAmount_EUR` = ovrpymt.`Allocation6_AppliedAmount` * fx6.`EUR`
		,`Allocation6_AppliedAmount_GBP` = ovrpymt.`Allocation6_AppliedAmount` * fx6.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx7 ON fx7.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx7.`Date` = CASE 
									WHEN ovrpymt.`Allocation7_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation7_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation7_Date` 
								END
	SET `Allocation7_AppliedAmount_AUD` = ovrpymt.`Allocation7_AppliedAmount` * fx7.`AUD`
		,`Allocation7_AppliedAmount_USD` = ovrpymt.`Allocation7_AppliedAmount` * fx7.`USD`
		,`Allocation7_AppliedAmount_NZD` = ovrpymt.`Allocation7_AppliedAmount` * fx7.`NZD`
		,`Allocation7_AppliedAmount_EUR` = ovrpymt.`Allocation7_AppliedAmount` * fx7.`EUR`
		,`Allocation7_AppliedAmount_GBP` = ovrpymt.`Allocation7_AppliedAmount` * fx7.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx8 ON fx8.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx8.`Date` = CASE 
									WHEN ovrpymt.`Allocation8_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation8_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation8_Date` 
								END
	SET `Allocation8_AppliedAmount_AUD` = ovrpymt.`Allocation8_AppliedAmount` * fx8.`AUD`
		,`Allocation8_AppliedAmount_USD` = ovrpymt.`Allocation8_AppliedAmount` * fx8.`USD`
		,`Allocation8_AppliedAmount_NZD` = ovrpymt.`Allocation8_AppliedAmount` * fx8.`NZD`
		,`Allocation8_AppliedAmount_EUR` = ovrpymt.`Allocation8_AppliedAmount` * fx8.`EUR`
		,`Allocation8_AppliedAmount_GBP` = ovrpymt.`Allocation8_AppliedAmount` * fx8.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx9 ON fx9.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx9.`Date` = CASE 
									WHEN ovrpymt.`Allocation9_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation9_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation9_Date` 
								END
	SET `Allocation9_AppliedAmount_AUD` = ovrpymt.`Allocation9_AppliedAmount` * fx9.`AUD`
		,`Allocation9_AppliedAmount_USD` = ovrpymt.`Allocation9_AppliedAmount` * fx9.`USD`
		,`Allocation9_AppliedAmount_NZD` = ovrpymt.`Allocation9_AppliedAmount` * fx9.`NZD`
		,`Allocation9_AppliedAmount_EUR` = ovrpymt.`Allocation9_AppliedAmount` * fx9.`EUR`
		,`Allocation9_AppliedAmount_GBP` = ovrpymt.`Allocation9_AppliedAmount` * fx9.`GBP`;
    
    UPDATE c1518_5393_xeroblue_overpaymentsstage AS ovrpymt
	LEFT JOIN FXTable AS fx10 ON fx10.`BaseCurrency` = ovrpymt.`CurrencyCode` 
				AND fx10.`Date` = CASE 
									WHEN ovrpymt.`Allocation10_Date` <= v_minDate THEN v_minDate 
									WHEN ovrpymt.`Allocation10_Date` >= v_maxDate THEN v_maxDate
									ELSE ovrpymt.`Allocation10_Date` 
								END
	SET `Allocation10_AppliedAmount_AUD` = ovrpymt.`Allocation10_AppliedAmount` * fx10.`AUD`
		,`Allocation10_AppliedAmount_USD` = ovrpymt.`Allocation10_AppliedAmount` * fx10.`USD`
		,`Allocation10_AppliedAmount_NZD` = ovrpymt.`Allocation10_AppliedAmount` * fx10.`NZD`
		,`Allocation10_AppliedAmount_EUR` = ovrpymt.`Allocation10_AppliedAmount` * fx10.`EUR`
		,`Allocation10_AppliedAmount_GBP` = ovrpymt.`Allocation10_AppliedAmount` * fx10.`GBP`;

    DELETE TRG
	FROM c1518_xeroblue_overpayments TRG
    INNER JOIN c1518_5393_xeroblue_overpaymentsstage STG 
	ON TRG.`OverpaymentId` = STG.`OverpaymentId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_overpayments (
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
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    )
    SELECT 
        `OverpaymentId`,
        NULLIF(`Date`, '') AS `Date`,
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
        NULLIF(`UpdatedDateUTC`, '') AS `UpdatedDateUTC`,
        `Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, '') AS `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, '') AS `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, '') AS `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, '') AS `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, '') AS `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, '') AS `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, '') AS `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, '') AS `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, '') AS `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, '') AS `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    FROM c1518_5393_xeroblue_overpaymentsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_prepayments $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_prepayments()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    CREATE TEMPORARY TABLE IF NOT EXISTS FXTable (
        `BaseCurrency` VARCHAR(10),
        `Date` DATE,
        `AUD` DECIMAL(10, 4),
        `USD` DECIMAL(10, 4),
        `NZD` DECIMAL(10, 4),
        `EUR` DECIMAL(10, 4),
        `GBP` DECIMAL(10, 4)
    );

    INSERT INTO FXTable (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
    GROUP BY `BaseCurrency`, `Date`;

	
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx ON fx.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN prepymt.`Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Date` 
								END
	SET `RemainingCredit_AUD` = prepymt.`RemainingCredit` * fx.`AUD`,
        `RemainingCredit_USD` = prepymt.`RemainingCredit` * fx.`USD`,
        `RemainingCredit_NZD` = prepymt.`RemainingCredit` * fx.`NZD`,
        `RemainingCredit_EUR` = prepymt.`RemainingCredit` * fx.`EUR`,
        `RemainingCredit_GBP` = prepymt.`RemainingCredit` * fx.`GBP`,
        `SubTotal_AUD` = prepymt.`SubTotal` * fx.`AUD`,
        `SubTotal_USD` = prepymt.`SubTotal` * fx.`USD`,
        `SubTotal_NZD` = prepymt.`SubTotal` * fx.`NZD`,
        `SubTotal_EUR` = prepymt.`SubTotal` * fx.`EUR`,
        `SubTotal_GBP` = prepymt.`SubTotal` * fx.`GBP`,
        `TotalTax_AUD` = prepymt.`TotalTax` * fx.`AUD`,
        `TotalTax_USD` = prepymt.`TotalTax` * fx.`USD`,
        `TotalTax_NZD` = prepymt.`TotalTax` * fx.`NZD`,
        `TotalTax_EUR` = prepymt.`TotalTax` * fx.`EUR`,
        `TotalTax_GBP` = prepymt.`TotalTax` * fx.`GBP`,
        `Total_AUD` = prepymt.`Total` * fx.`AUD`,
        `Total_USD` = prepymt.`Total` * fx.`USD`,
        `Total_NZD` = prepymt.`Total` * fx.`NZD`,
        `Total_EUR` = prepymt.`Total` * fx.`EUR`,
        `Total_GBP` = prepymt.`Total` * fx.`GBP`,
        `LineItem_UnitAmount_AUD` = prepymt.`LineItem_UnitAmount` * fx.`AUD`,
        `LineItem_UnitAmount_USD` = prepymt.`LineItem_UnitAmount` * fx.`USD`,
        `LineItem_UnitAmount_NZD` = prepymt.`LineItem_UnitAmount` * fx.`NZD`,
        `LineItem_UnitAmount_EUR` = prepymt.`LineItem_UnitAmount` * fx.`EUR`,
        `LineItem_UnitAmount_GBP` = prepymt.`LineItem_UnitAmount` * fx.`GBP`,
        `LineItem_TaxAmount_AUD` = prepymt.`LineItem_TaxAmount` * fx.`AUD`,
        `LineItem_TaxAmount_USD` = prepymt.`LineItem_TaxAmount` * fx.`USD`,
        `LineItem_TaxAmount_NZD` = prepymt.`LineItem_TaxAmount` * fx.`NZD`,
        `LineItem_TaxAmount_EUR` = prepymt.`LineItem_TaxAmount` * fx.`EUR`,
        `LineItem_TaxAmount_GBP` = prepymt.`LineItem_TaxAmount` * fx.`GBP`,
        `LineItem_LineAmount_AUD` = prepymt.`LineItem_LineAmount` * fx.`AUD`,
        `LineItem_LineAmount_USD` = prepymt.`LineItem_LineAmount` * fx.`USD`,
        `LineItem_LineAmount_NZD` = prepymt.`LineItem_LineAmount` * fx.`NZD`,
        `LineItem_LineAmount_EUR` = prepymt.`LineItem_LineAmount` * fx.`EUR`,
        `LineItem_LineAmount_GBP` = prepymt.`LineItem_LineAmount` * fx.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx1 ON fx1.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx1.`Date` = CASE 
									WHEN prepymt.`Allocation1_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation1_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation1_Date` 
								END
	SET `Allocation1_AppliedAmount_AUD` = prepymt.`Allocation1_AppliedAmount` * fx1.`AUD`
		,`Allocation1_AppliedAmount_USD` = prepymt.`Allocation1_AppliedAmount` * fx1.`USD`
		,`Allocation1_AppliedAmount_NZD` = prepymt.`Allocation1_AppliedAmount` * fx1.`NZD`
		,`Allocation1_AppliedAmount_EUR` = prepymt.`Allocation1_AppliedAmount` * fx1.`EUR`
		,`Allocation1_AppliedAmount_GBP` = prepymt.`Allocation1_AppliedAmount` * fx1.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx2 ON fx2.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx2.`Date` = CASE 
									WHEN prepymt.`Allocation2_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation2_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation2_Date` 
								END
	SET `Allocation2_AppliedAmount_AUD` = prepymt.`Allocation2_AppliedAmount` * fx2.`AUD`
		,`Allocation2_AppliedAmount_USD` = prepymt.`Allocation2_AppliedAmount` * fx2.`USD`
		,`Allocation2_AppliedAmount_NZD` = prepymt.`Allocation2_AppliedAmount` * fx2.`NZD`
		,`Allocation2_AppliedAmount_EUR` = prepymt.`Allocation2_AppliedAmount` * fx2.`EUR`
		,`Allocation2_AppliedAmount_GBP` = prepymt.`Allocation2_AppliedAmount` * fx2.`GBP`;

    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx3 ON fx3.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx3.`Date` = CASE 
									WHEN prepymt.`Allocation3_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation3_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation3_Date` 
								END
	SET `Allocation3_AppliedAmount_AUD` = prepymt.`Allocation3_AppliedAmount` * fx3.`AUD`
		,`Allocation3_AppliedAmount_USD` = prepymt.`Allocation3_AppliedAmount` * fx3.`USD`
		,`Allocation3_AppliedAmount_NZD` = prepymt.`Allocation3_AppliedAmount` * fx3.`NZD`
		,`Allocation3_AppliedAmount_EUR` = prepymt.`Allocation3_AppliedAmount` * fx3.`EUR`
		,`Allocation3_AppliedAmount_GBP` = prepymt.`Allocation3_AppliedAmount` * fx3.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx4 ON fx4.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx4.`Date` = CASE 
									WHEN prepymt.`Allocation4_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation4_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation4_Date` 
								END
	SET `Allocation4_AppliedAmount_AUD` = prepymt.`Allocation4_AppliedAmount` * fx4.`AUD`
		,`Allocation4_AppliedAmount_USD` = prepymt.`Allocation4_AppliedAmount` * fx4.`USD`
		,`Allocation4_AppliedAmount_NZD` = prepymt.`Allocation4_AppliedAmount` * fx4.`NZD`
		,`Allocation4_AppliedAmount_EUR` = prepymt.`Allocation4_AppliedAmount` * fx4.`EUR`
		,`Allocation4_AppliedAmount_GBP` = prepymt.`Allocation4_AppliedAmount` * fx4.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx5 ON fx5.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx5.`Date` = CASE 
									WHEN prepymt.`Allocation5_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation5_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation5_Date` 
								END
	SET `Allocation5_AppliedAmount_AUD` = prepymt.`Allocation5_AppliedAmount` * fx5.`AUD`
		,`Allocation5_AppliedAmount_USD` = prepymt.`Allocation5_AppliedAmount` * fx5.`USD`
		,`Allocation5_AppliedAmount_NZD` = prepymt.`Allocation5_AppliedAmount` * fx5.`NZD`
		,`Allocation5_AppliedAmount_EUR` = prepymt.`Allocation5_AppliedAmount` * fx5.`EUR`
		,`Allocation5_AppliedAmount_GBP` = prepymt.`Allocation5_AppliedAmount` * fx5.`GBP`;

    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx6 ON fx6.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx6.`Date` = CASE 
									WHEN prepymt.`Allocation6_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation6_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation6_Date` 
								END
	SET `Allocation6_AppliedAmount_AUD` = prepymt.`Allocation6_AppliedAmount` * fx6.`AUD`
		,`Allocation6_AppliedAmount_USD` = prepymt.`Allocation6_AppliedAmount` * fx6.`USD`
		,`Allocation6_AppliedAmount_NZD` = prepymt.`Allocation6_AppliedAmount` * fx6.`NZD`
		,`Allocation6_AppliedAmount_EUR` = prepymt.`Allocation6_AppliedAmount` * fx6.`EUR`
		,`Allocation6_AppliedAmount_GBP` = prepymt.`Allocation6_AppliedAmount` * fx6.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx7 ON fx7.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx7.`Date` = CASE 
									WHEN prepymt.`Allocation7_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation7_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation7_Date` 
								END
	SET `Allocation7_AppliedAmount_AUD` = prepymt.`Allocation7_AppliedAmount` * fx7.`AUD`
		,`Allocation7_AppliedAmount_USD` = prepymt.`Allocation7_AppliedAmount` * fx7.`USD`
		,`Allocation7_AppliedAmount_NZD` = prepymt.`Allocation7_AppliedAmount` * fx7.`NZD`
		,`Allocation7_AppliedAmount_EUR` = prepymt.`Allocation7_AppliedAmount` * fx7.`EUR`
		,`Allocation7_AppliedAmount_GBP` = prepymt.`Allocation7_AppliedAmount` * fx7.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx8 ON fx8.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx8.`Date` = CASE 
									WHEN prepymt.`Allocation8_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation8_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation8_Date` 
								END
	SET `Allocation8_AppliedAmount_AUD` = prepymt.`Allocation8_AppliedAmount` * fx8.`AUD`
		,`Allocation8_AppliedAmount_USD` = prepymt.`Allocation8_AppliedAmount` * fx8.`USD`
		,`Allocation8_AppliedAmount_NZD` = prepymt.`Allocation8_AppliedAmount` * fx8.`NZD`
		,`Allocation8_AppliedAmount_EUR` = prepymt.`Allocation8_AppliedAmount` * fx8.`EUR`
		,`Allocation8_AppliedAmount_GBP` = prepymt.`Allocation8_AppliedAmount` * fx8.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx9 ON fx9.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx9.`Date` = CASE 
									WHEN prepymt.`Allocation9_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation9_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation9_Date` 
								END
	SET `Allocation9_AppliedAmount_AUD` = prepymt.`Allocation9_AppliedAmount` * fx9.`AUD`
		,`Allocation9_AppliedAmount_USD` = prepymt.`Allocation9_AppliedAmount` * fx9.`USD`
		,`Allocation9_AppliedAmount_NZD` = prepymt.`Allocation9_AppliedAmount` * fx9.`NZD`
		,`Allocation9_AppliedAmount_EUR` = prepymt.`Allocation9_AppliedAmount` * fx9.`EUR`
		,`Allocation9_AppliedAmount_GBP` = prepymt.`Allocation9_AppliedAmount` * fx9.`GBP`;
    
    UPDATE c1518_5393_xeroblue_prepaymentsstage AS prepymt
	LEFT JOIN FXTable AS fx10 ON fx10.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx10.`Date` = CASE 
									WHEN prepymt.`Allocation10_Date` <= v_minDate THEN v_minDate 
									WHEN prepymt.`Allocation10_Date` >= v_maxDate THEN v_maxDate
									ELSE prepymt.`Allocation10_Date` 
								END
	SET `Allocation10_AppliedAmount_AUD` = prepymt.`Allocation10_AppliedAmount` * fx10.`AUD`
		,`Allocation10_AppliedAmount_USD` = prepymt.`Allocation10_AppliedAmount` * fx10.`USD`
		,`Allocation10_AppliedAmount_NZD` = prepymt.`Allocation10_AppliedAmount` * fx10.`NZD`
		,`Allocation10_AppliedAmount_EUR` = prepymt.`Allocation10_AppliedAmount` * fx10.`EUR`
		,`Allocation10_AppliedAmount_GBP` = prepymt.`Allocation10_AppliedAmount` * fx10.`GBP`;

	DELETE TRG
	FROM c1518_xeroblue_prepayments TRG
    INNER JOIN c1518_5393_xeroblue_prepaymentsstage STG 
	ON TRG.`PrepaymentId` = STG.`PrepaymentId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_prepayments (
        `PrepaymentId`,
        `Date`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
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
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    )
    SELECT 
        `PrepaymentId`,
        NULLIF(`Date`, ''),
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
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
        NULLIF(`UpdatedDateUTC`, ''),
        `Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, ''),
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    FROM c1518_5393_xeroblue_prepaymentsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_manualjournals $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_manualjournals()
BEGIN
	DECLARE v_OrganisationID INT DEFAULT 5393;

	DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;
	
	UPDATE c1518_5393_xeroblue_manualjournalsstage AS `mnljrnl`
    LEFT JOIN c1518_xeroblue_organisationsclients AS `org` 
        ON `org`.`OrganisationID` = `mnljrnl`.`OrganisationID`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, 
				`Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM 
				`foreignexchange_master` AS `fx`
			WHERE 
				`fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY 
				`BaseCurrency`, 
				`Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `org`.`BaseCurrency` 
			AND `fx`.`Date` = CASE 
				WHEN `mnljrnl`.`Date` <= v_minDate THEN v_minDate
				WHEN `mnljrnl`.`Date` >= v_maxDate THEN v_maxDate
				ELSE `mnljrnl`.`Date` 
			END
	SET  `JournalLine_LineAmount_AUD` = `mnljrnl`.`JournalLine_LineAmount` * `AUD`
		,`JournalLine_LineAmount_USD` = `mnljrnl`.`JournalLine_LineAmount` * `USD`
		,`JournalLine_LineAmount_NZD` = `mnljrnl`.`JournalLine_LineAmount` * `NZD`
		,`JournalLine_LineAmount_EUR` = `mnljrnl`.`JournalLine_LineAmount` * `EUR`
		,`JournalLine_LineAmount_GBP` = `mnljrnl`.`JournalLine_LineAmount` * `GBP`
		,`JournalLine_TaxAmount_AUD` = `mnljrnl`.`JournalLine_TaxAmount` * `AUD`
		,`JournalLine_TaxAmount_USD` = `mnljrnl`.`JournalLine_TaxAmount` * `USD`
		,`JournalLine_TaxAmount_NZD` = `mnljrnl`.`JournalLine_TaxAmount` * `NZD`
		,`JournalLine_TaxAmount_EUR` = `mnljrnl`.`JournalLine_TaxAmount` * `EUR`
		,`JournalLine_TaxAmount_GBP` = `mnljrnl`.`JournalLine_TaxAmount` * `GBP`;

	DELETE TRG
	FROM c1518_xeroblue_manualjournals TRG
    INNER JOIN c1518_5393_xeroblue_manualjournalsstage STG 
	ON TRG.`ManualJournalId` = STG.`ManualJournalId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_manualjournals (
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        `Date`,
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        `UpdatedDateUTC`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    )
    SELECT
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        NULLIF(`Date`, ''),
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        NULLIF(`UpdatedDateUTC`, ''),
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    FROM c1518_5393_xeroblue_manualjournalsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_payments $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_payments()
BEGIN
	DECLARE v_OrganisationID INT DEFAULT 5393;

	DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

	UPDATE `c1518_5393_xeroblue_paymentsstage` AS `pymt`
    LEFT JOIN `c1518_xeroblue_organisationsclients` AS `org` ON `org`.`OrganisationID` = `pymt`.`OrganisationID`
    LEFT JOIN (SELECT `InvoiceId`, `CurrencyCode` FROM `c1518_xeroblue_invoices` WHERE `OrganisationID` = v_OrganisationID) AS `inv` ON `pymt`.`InvoiceId` = `inv`.`InvoiceId`
    LEFT JOIN (SELECT `CreditNoteId`, `CurrencyCode` FROM `c1518_xeroblue_creditnotes` WHERE `OrganisationID` = v_OrganisationID) AS `cn` ON `pymt`.`InvoiceId` = `cn`.`CreditNoteId`
    LEFT JOIN (SELECT `OverPaymentId`, `CurrencyCode` FROM `c1518_xeroblue_overpayments` WHERE `OrganisationID` = v_OrganisationID) AS `op` ON `pymt`.`InvoiceId` = `op`.`OverPaymentId`
    LEFT JOIN (SELECT `PrePaymentId`, `CurrencyCode` FROM `c1518_xeroblue_prepayments` WHERE `OrganisationID` = v_OrganisationID) AS `pp` ON `pymt`.`InvoiceId` = `pp`.`PrePaymentId`
    LEFT JOIN (
        SELECT `BaseCurrency`, `Date`, 
            AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
            AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
            AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
            AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
            AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
        FROM `foreignexchange_master` AS `fx`
        WHERE `fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
        GROUP BY `BaseCurrency`, `Date`
    ) AS `fx` ON `fx`.`BaseCurrency` = CASE 
            WHEN UPPER(`pymt`.`PaymentType`) IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN `inv`.`CurrencyCode`
            WHEN UPPER(`pymt`.`PaymentType`) IN ('APCREDITPAYMENT', 'ARCREDITPAYMENT') THEN `cn`.`CurrencyCode`
            WHEN UPPER(`pymt`.`PaymentType`) IN ('APOVERPAYMENTPAYMENT', 'AROVERPAYMENTPAYMENT') THEN `op`.`CurrencyCode`
            WHEN UPPER(`pymt`.`PaymentType`) IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN `pp`.`CurrencyCode`
            ELSE `org`.`BaseCurrency` 
        END
        AND `fx`.`Date` = CASE 
            WHEN `pymt`.`Date` <= v_minDate THEN v_minDate 
            WHEN `pymt`.`Date` >= v_maxDate THEN v_maxDate
            ELSE `pymt`.`Date` 
        END
    SET 
        `Amount_AUD` = CASE 
            WHEN `org`.`BaseCurrency` = 'AUD' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`AUD` 
        END,
        `Amount_USD` = CASE 
            WHEN `org`.`BaseCurrency` = 'USD' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`USD` 
        END,
        `Amount_NZD` = CASE 
            WHEN `org`.`BaseCurrency` = 'NZD' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`NZD` 
        END,
        `Amount_EUR` = CASE 
            WHEN `org`.`BaseCurrency` = 'EUR' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
                    ELSE `pymt`.`Amount` * `fx`.`EUR` 
        END,
        `Amount_GBP` = CASE 
            WHEN `org`.`BaseCurrency` = 'GBP' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`GBP` 
        END;

    DELETE TRG
	FROM c1518_xeroblue_payments TRG
    INNER JOIN c1518_5393_xeroblue_paymentsstage STG 
	ON TRG.`PaymentId` = STG.`PaymentId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_payments (
            `PaymentId`,
            `Date`,
            `Amount`,
            `CurrencyRate`,
            `Reference`,
            `PaymentType`,
            `Status`,
            `UpdatedDateUTC`,
            `IsReconciled`,
            `BatchPaymentId`,
            `InvoiceId`,
            `InvoiceNumber`,
            `CreditNoteId`,
            `CreditNoteNumber`,
            `AccountId`,
            `AccountCode`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
    )
    SELECT
            `PaymentId`,
            NULLIF(`Date`, ''),
            `Amount`,
            `CurrencyRate`,
            `Reference`,
            `PaymentType`,
            `Status`,
            NULLIF(`UpdatedDateUTC`, ''),
            `IsReconciled`,
            `BatchPaymentId`,
            `InvoiceId`,
            `InvoiceNumber`,
            `CreditNoteId`,
            `CreditNoteNumber`,
            `AccountId`,
            `AccountCode`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
    FROM c1518_5393_xeroblue_paymentsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_banktransactions $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_banktransactions()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    UPDATE `c1518_5393_xeroblue_banktransactionsstage`
    SET
        `ConditionalType` = CASE 
            WHEN `Type` = 'SPEND' THEN 'SPEND'
            WHEN `Type` = 'RECEIVE' THEN 'RECEIVE'
            WHEN `Type` = 'SPEND-OVERPAYMENT' THEN 'SPEND'
            WHEN `Type` = 'RECEIVE-OVERPAYMENT' THEN 'RECEIVE'
            WHEN `Type` = 'SPEND-PREPAYMENT' THEN 'SPEND'
            WHEN `Type` = 'RECEIVE-PREPAYMENT' THEN 'RECEIVE'
            WHEN `Type` = 'SPEND-TRANSFER' THEN 'NOTINCLUDED'
            WHEN `Type` = 'RECEIVE-TRANSFER' THEN 'NOTINCLUDED'
            ELSE 'UNKNOWN' 
        END,
        `Account_UID` = CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', `OrganisationID`);

    UPDATE c1518_5393_xeroblue_banktransactionsstage
    SET
        `BankTansactionCashflowCalculation` = CAST(
            CASE 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Exclusive' THEN 0 - (`LineItem_LineAmount`)  
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Exclusive' THEN (`LineItem_LineAmount`) 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'NoTax' THEN 0 - (`LineItem_LineAmount`)  
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'NoTax' THEN (`LineItem_LineAmount`) 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Inclusive' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Inclusive' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15,4)
        ),  
        `LineAmountCalculatedIncTax` = CAST(
            CASE 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Exclusive' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Exclusive' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'NoTax' THEN 0 - (`LineItem_LineAmount`) 
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'NoTax' THEN (`LineItem_LineAmount`)
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Inclusive' THEN 0 - (`LineItem_LineAmount`) 
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Inclusive' THEN (`LineItem_LineAmount`)
                ELSE 0 
            END AS DECIMAL(15,4)
        ),  		
        `PaymentAmount` = CAST(
            CASE 
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Exclusive' THEN 0 - (`LineItem_LineAmount`)
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Exclusive' THEN (`LineItem_LineAmount`)
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'NoTax' THEN 0 - (`LineItem_LineAmount`)
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'NoTax' THEN (`LineItem_LineAmount`)
                WHEN `ConditionalType` = 'SPEND' AND `LineAmountTypes` = 'Inclusive' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN `ConditionalType` = 'RECEIVE' AND `LineAmountTypes` = 'Inclusive' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15,4)
        );

    UPDATE c1518_5393_xeroblue_banktransactionsstage AS `bnktrnsxn`
    LEFT JOIN (
            SELECT 
                `BaseCurrency`, `Date`,
                AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
                AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
                AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
                AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
                AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
            FROM `foreignexchange_master` AS `fx`
            WHERE `fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
            GROUP BY `BaseCurrency`, `Date`
        ) AS `fx` ON `fx`.`BaseCurrency` = `bnktrnsxn`.`CurrencyCode` 
            AND `fx`.`Date` = CASE 
                WHEN `bnktrnsxn`.`Date` <= v_minDate THEN v_minDate
                WHEN `bnktrnsxn`.`Date` >= v_maxDate THEN v_maxDate
                ELSE `bnktrnsxn`.`Date` 
                END
	SET  
        `LineItem_UnitAmount_AUD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`AUD`,
        `LineItem_UnitAmount_USD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`USD`,
        `LineItem_UnitAmount_NZD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`NZD`,
        `LineItem_UnitAmount_EUR` = bnktrnsxn.`LineItem_UnitAmount` * fx.`EUR`,
        `LineItem_UnitAmount_GBP` = bnktrnsxn.`LineItem_UnitAmount` * fx.`GBP`,
        `LineItem_TaxAmount_AUD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`AUD`,
        `LineItem_TaxAmount_USD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`USD`,
        `LineItem_TaxAmount_NZD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`NZD`,
        `LineItem_TaxAmount_EUR` = bnktrnsxn.`LineItem_TaxAmount` * fx.`EUR`,
        `LineItem_TaxAmount_GBP` = bnktrnsxn.`LineItem_TaxAmount` * fx.`GBP`,
        `LineItem_LineAmount_AUD` = bnktrnsxn.`LineItem_LineAmount` * fx.`AUD`,
        `LineItem_LineAmount_USD` = bnktrnsxn.`LineItem_LineAmount` * fx.`USD`,
        `LineItem_LineAmount_NZD` = bnktrnsxn.`LineItem_LineAmount` * fx.`NZD`,
        `LineItem_LineAmount_EUR` = bnktrnsxn.`LineItem_LineAmount` * fx.`EUR`,
        `LineItem_LineAmount_GBP` = bnktrnsxn.`LineItem_LineAmount` * fx.`GBP`,
        `SubTotal_AUD` = bnktrnsxn.`SubTotal` * fx.`AUD`,
        `SubTotal_USD` = bnktrnsxn.`SubTotal` * fx.`USD`,
        `SubTotal_NZD` = bnktrnsxn.`SubTotal` * fx.`NZD`,
        `SubTotal_EUR` = bnktrnsxn.`SubTotal` * fx.`EUR`,
        `SubTotal_GBP` = bnktrnsxn.`SubTotal` * fx.`GBP`,
        `TotalTax_AUD` = bnktrnsxn.`TotalTax` * fx.`AUD`,
        `TotalTax_USD` = bnktrnsxn.`TotalTax` * fx.`USD`,
        `TotalTax_NZD` = bnktrnsxn.`TotalTax` * fx.`NZD`,
        `TotalTax_EUR` = bnktrnsxn.`TotalTax` * fx.`EUR`,
        `TotalTax_GBP` = bnktrnsxn.`TotalTax` * fx.`GBP`,
        `Total_AUD` = bnktrnsxn.`Total` * fx.`AUD`,
        `Total_USD` = bnktrnsxn.`Total` * fx.`USD`,
        `Total_NZD` = bnktrnsxn.`Total` * fx.`NZD`,
        `Total_EUR` = bnktrnsxn.`Total` * fx.`EUR`,
        `Total_GBP` = bnktrnsxn.`Total` * fx.`GBP`,
        `BankTansactionCashflowCalculation_AUD` = `BankTansactionCashflowCalculation` * fx.`AUD`,
        `BankTansactionCashflowCalculation_USD` = `BankTansactionCashflowCalculation` * fx.`USD`,
        `BankTansactionCashflowCalculation_NZD` = `BankTansactionCashflowCalculation` * fx.`NZD`,
        `BankTansactionCashflowCalculation_EUR` = `BankTansactionCashflowCalculation` * fx.`EUR`,
        `BankTansactionCashflowCalculation_GBP` = `BankTansactionCashflowCalculation` * fx.`GBP`,
        `LineAmountCalculatedIncTax_AUD` = `LineAmountCalculatedIncTax` * fx.`AUD`,
        `LineAmountCalculatedIncTax_USD` = `LineAmountCalculatedIncTax` * fx.`USD`,
        `LineAmountCalculatedIncTax_NZD` = `LineAmountCalculatedIncTax` * fx.`NZD`,
        `LineAmountCalculatedIncTax_EUR` = `LineAmountCalculatedIncTax` * fx.`EUR`,
        `LineAmountCalculatedIncTax_GBP` = `LineAmountCalculatedIncTax` * fx.`GBP`,
        `PaymentAmount_AUD` = `PaymentAmount` * fx.`AUD`,
        `PaymentAmount_USD` = `PaymentAmount` * fx.`USD`,
        `PaymentAmount_NZD` = `PaymentAmount` * fx.`NZD`,
        `PaymentAmount_EUR` = `PaymentAmount` * fx.`EUR`,
        `PaymentAmount_GBP` = `PaymentAmount` * fx.`GBP`;

    DELETE TRG
    FROM c1518_xeroblue_banktransactions TRG
    INNER JOIN c1518_5393_xeroblue_banktransactionsstage STG ON TRG.`BankTransactionId` = STG.`BankTransactionId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_banktransactions (
        `Id`,
        `BankTransactionId`,
        `Type`,
        `Contact_ContactName`,
        `Contact_ContactId`,
        `BankAccount_AccountId`,
        `BankAccount_AccountName`,
        `BankAccount_Code`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        `LineItem_ItemCode`,
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
        `LineItemAggregate`,
        `IsReconciled`,
        `Date`,
        `Reference`,
        `CurrencyRate`,
        `URL`,
        `Status`,
        `LineAmountTypes`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `PrepaymentId`,
        `OverpaymentId`,
        `UpdatedDateUTC`,
        `FullyPaidOnDate`,
        `CurrencyCode`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `ConditionalType`,
        `Account_UID`,
        `BankTansactionCashflowCalculation`,
        `BankTansactionCashflowCalculation_AUD`,
        `BankTansactionCashflowCalculation_USD`,
        `BankTansactionCashflowCalculation_NZD`,
        `BankTansactionCashflowCalculation_EUR`,
        `BankTansactionCashflowCalculation_GBP`,
        `LineAmountCalculatedIncTax`,
        `LineAmountCalculatedIncTax_AUD`,
        `LineAmountCalculatedIncTax_USD`,
        `LineAmountCalculatedIncTax_NZD`,
        `LineAmountCalculatedIncTax_EUR`,
        `LineAmountCalculatedIncTax_GBP`,
        `PaymentAmount`,
        `PaymentAmount_AUD`,
        `PaymentAmount_USD`,
        `PaymentAmount_NZD`,
        `PaymentAmount_EUR`,
        `PaymentAmount_GBP` 
    )
    SELECT
        `Id`,
        `BankTransactionId`,
        `Type`,
        `Contact_ContactName`,
        `Contact_ContactId`,
        `BankAccount_AccountId`,
        `BankAccount_AccountName`,
        `BankAccount_Code`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        `LineItem_ItemCode`,
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
        `LineItemAggregate`,
        `IsReconciled`,
        NULLIF(`Date`, ''),
        `Reference`,
        `CurrencyRate`,
        `URL`,
        `Status`,
        `LineAmountTypes`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `PrepaymentId`,
        `OverpaymentId`,
        NULLIF(`UpdatedDateUTC`, ''),
        NULLIF(`FullyPaidOnDate`, ''),
        `CurrencyCode`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `ConditionalType`,
        `Account_UID`,
        `BankTansactionCashflowCalculation`,
        `BankTansactionCashflowCalculation_AUD`,
        `BankTansactionCashflowCalculation_USD`,
        `BankTansactionCashflowCalculation_NZD`,
        `BankTansactionCashflowCalculation_EUR`,
        `BankTansactionCashflowCalculation_GBP`,
        `LineAmountCalculatedIncTax`,
        `LineAmountCalculatedIncTax_AUD`,
        `LineAmountCalculatedIncTax_USD`,
        `LineAmountCalculatedIncTax_NZD`,
        `LineAmountCalculatedIncTax_EUR`,
        `LineAmountCalculatedIncTax_GBP`,
        `PaymentAmount`,
        `PaymentAmount_AUD`,
        `PaymentAmount_USD`,
        `PaymentAmount_NZD`,
        `PaymentAmount_EUR`,
        `PaymentAmount_GBP` 
    FROM c1518_5393_xeroblue_banktransactionsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_journals $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_journals()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    UPDATE c1518_5393_xeroblue_journalsstage AS `jrnl`
    LEFT JOIN c1518_xeroblue_organisationsclients AS `org` 
        ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, `Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM `foreignexchange_master` AS `fx`
			WHERE `fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY `BaseCurrency`, `Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `org`.`BaseCurrency` 
			AND `fx`.`Date` = CASE 
				WHEN `jrnl`.`JournalDate` <= v_minDate THEN v_minDate
				WHEN `jrnl`.`JournalDate` >= v_maxDate THEN v_maxDate
				ELSE `jrnl`.`JournalDate` 
			END
	SET  
		 `JournalLine_NetAmount_AUD` = `jrnl`.`JournalLine_NetAmount` * `AUD`
		,`JournalLine_NetAmount_USD` = `jrnl`.`JournalLine_NetAmount` * `USD`
		,`JournalLine_NetAmount_NZD` = `jrnl`.`JournalLine_NetAmount` * `NZD`
		,`JournalLine_NetAmount_EUR` = `jrnl`.`JournalLine_NetAmount` * `EUR`
		,`JournalLine_NetAmount_GBP` = `jrnl`.`JournalLine_NetAmount` * `GBP`
		,`JournalLine_GrossAmount_AUD` = `jrnl`.`JournalLine_GrossAmount` * `AUD`
		,`JournalLine_GrossAmount_USD` = `jrnl`.`JournalLine_GrossAmount` * `USD`
		,`JournalLine_GrossAmount_NZD` = `jrnl`.`JournalLine_GrossAmount` * `NZD`
		,`JournalLine_GrossAmount_EUR` = `jrnl`.`JournalLine_GrossAmount` * `EUR`
		,`JournalLine_GrossAmount_GBP` = `jrnl`.`JournalLine_GrossAmount` * `GBP`
		,`JournalLine_TaxAmount_AUD` = `jrnl`.`JournalLine_TaxAmount` * `AUD`
		,`JournalLine_TaxAmount_USD` = `jrnl`.`JournalLine_TaxAmount` * `USD`
		,`JournalLine_TaxAmount_NZD` = `jrnl`.`JournalLine_TaxAmount` * `NZD`
		,`JournalLine_TaxAmount_EUR` = `jrnl`.`JournalLine_TaxAmount` * `EUR`
		,`JournalLine_TaxAmount_GBP` = `jrnl`.`JournalLine_TaxAmount` * `GBP`
        ,`Split` =CASE 
            WHEN `SourceType` = 'ACCPAY' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCPAYCREDIT'THEN 'INVOICES' 
            WHEN `SourceType` = 'ACCPAYPAYMENT' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCREC' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCRECCREDIT' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCRECPAYMENT' THEN 'INVOICES' 
            WHEN `SourceType` = 'APCREDITPAYMENT' THEN 'INVOICES' 
            WHEN `SourceType` = 'ARCREDITPAYMENT' THEN 'INVOICES'
            ELSE 'JOURNALS' END;

    DELETE TRG
    FROM c1518_xeroblue_journals TRG
    INNER JOIN c1518_5393_xeroblue_journalsstage STG ON TRG.`JournalId` = STG.`JournalId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_journals
    SELECT * FROM c1518_5393_xeroblue_journalsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_journalscash $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_journalscash()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    UPDATE c1518_5393_xeroblue_journalscashstage AS `jrnl`
    LEFT JOIN c1518_xeroblue_organisationsclients AS `org` 
        ON `org`.`OrganisationID` = `jrnl`.`OrganisationID`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, `Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM `foreignexchange_master` AS `fx`
			WHERE `fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY `BaseCurrency`, `Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `org`.`BaseCurrency` 
			AND `fx`.`Date` = CASE 
				WHEN `jrnl`.`JournalDate` <= v_minDate THEN v_minDate
				WHEN `jrnl`.`JournalDate` >= v_maxDate THEN v_maxDate
				ELSE `jrnl`.`JournalDate` 
			END
	SET  
		 `JournalLine_NetAmount_AUD` = `jrnl`.`JournalLine_NetAmount` * `AUD`
		,`JournalLine_NetAmount_USD` = `jrnl`.`JournalLine_NetAmount` * `USD`
		,`JournalLine_NetAmount_NZD` = `jrnl`.`JournalLine_NetAmount` * `NZD`
		,`JournalLine_NetAmount_EUR` = `jrnl`.`JournalLine_NetAmount` * `EUR`
		,`JournalLine_NetAmount_GBP` = `jrnl`.`JournalLine_NetAmount` * `GBP`
		,`JournalLine_GrossAmount_AUD` = `jrnl`.`JournalLine_GrossAmount` * `AUD`
		,`JournalLine_GrossAmount_USD` = `jrnl`.`JournalLine_GrossAmount` * `USD`
		,`JournalLine_GrossAmount_NZD` = `jrnl`.`JournalLine_GrossAmount` * `NZD`
		,`JournalLine_GrossAmount_EUR` = `jrnl`.`JournalLine_GrossAmount` * `EUR`
		,`JournalLine_GrossAmount_GBP` = `jrnl`.`JournalLine_GrossAmount` * `GBP`
		,`JournalLine_TaxAmount_AUD` = `jrnl`.`JournalLine_TaxAmount` * `AUD`
		,`JournalLine_TaxAmount_USD` = `jrnl`.`JournalLine_TaxAmount` * `USD`
		,`JournalLine_TaxAmount_NZD` = `jrnl`.`JournalLine_TaxAmount` * `NZD`
		,`JournalLine_TaxAmount_EUR` = `jrnl`.`JournalLine_TaxAmount` * `EUR`
		,`JournalLine_TaxAmount_GBP` = `jrnl`.`JournalLine_TaxAmount` * `GBP`
        ,`Split` =CASE 
            WHEN `SourceType` = 'ACCPAY' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCPAYCREDIT'THEN 'INVOICES' 
            WHEN `SourceType` = 'ACCPAYPAYMENT' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCREC' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCRECCREDIT' THEN 'INVOICES'
            WHEN `SourceType` = 'ACCRECPAYMENT' THEN 'INVOICES' 
            WHEN `SourceType` = 'APCREDITPAYMENT' THEN 'INVOICES' 
            WHEN `SourceType` = 'ARCREDITPAYMENT' THEN 'INVOICES'
            ELSE 'JOURNALS' END;

    DELETE TRG
    FROM c1518_xeroblue_journalscash TRG
    INNER JOIN c1518_5393_xeroblue_journalscashstage STG ON TRG.`JournalId` = STG.`JournalId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_journalscash
    SELECT * FROM c1518_5393_xeroblue_journalscashstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_budgets $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_budgets()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    UPDATE c1518_5393_xeroblue_budgetsstage bdgt
    INNER JOIN c1518_xeroblue_accounts acct 
        ON bdgt.`BudgetLines.AccountID` = acct.`AccountID`
        AND bdgt.`BudgetLines.AccountCode` = acct.`Code`
        AND bdgt.`OrganisationID` = acct.`OrganisationID`
    SET bdgt.`BudgetLines.BudgetBalances.Amount` = CASE 
            WHEN acct.`Class` = 'Revenue' THEN bdgt.`BudgetLines.BudgetBalances.Amount`
            WHEN acct.`Class` = 'Expense' THEN (0 - bdgt.`BudgetLines.BudgetBalances.Amount`)
        END
    WHERE acct.`Class` IN ('Revenue', 'Expense');

	UPDATE c1518_5393_xeroblue_budgetsstage `bdgt`
    LEFT JOIN c1518_xeroblue_organisationsclients AS `org` 
        ON `org`.`OrganisationID` = `bdgt`.`OrganisationID`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, `Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM `foreignexchange_master` AS `fx`
			WHERE `fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY `BaseCurrency`, `Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `org`.`BaseCurrency` 
			AND `fx`.`Date` = CASE 
                WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, '1900-01'), '-01')) <= v_minDate THEN v_minDate 
                WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, '1900-01'), '-01')) >= v_maxDate THEN v_maxDate
                ELSE LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, '1900-01'), '-01')) 
            END
    SET 
        `bdgt`.`BudgetLines.BudgetBalances.Amount_AUD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`AUD`,
        `bdgt`.`BudgetLines.BudgetBalances.Amount_USD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`USD`,
        `bdgt`.`BudgetLines.BudgetBalances.Amount_NZD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`NZD`,
        `bdgt`.`BudgetLines.BudgetBalances.Amount_EUR` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`EUR`,
        `bdgt`.`BudgetLines.BudgetBalances.Amount_GBP` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`GBP`;

    DELETE FROM c1518_xeroblue_budgets 
    WHERE `OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_budgets 
    SELECT DISTINCT * FROM c1518_5393_xeroblue_budgetsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_banktransfers $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_banktransfers()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    UPDATE `c1518_5393_xeroblue_banktransfersstage` AS `bnktrnsfr`
    LEFT JOIN `c1518_xeroblue_accounts` AS `acct` 
        ON `bnktrnsfr`.`FromBankAccount_AccountId` = `acct`.`AccountId` 
        AND `bnktrnsfr`.`OrganisationID` = `acct`.`OrganisationID`
    LEFT JOIN (
			SELECT 
				`BaseCurrency`, 
				`Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM 
				`foreignexchange_master` AS `fx`
			WHERE 
				`fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY 
				`BaseCurrency`, 
				`Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `acct`.`CurrencyCode` 
        AND `fx`.`Date` = CASE 
            WHEN `bnktrnsfr`.`Date` <= v_minDate THEN v_minDate 
            WHEN `bnktrnsfr`.`Date` >= v_maxDate THEN v_maxDate
            ELSE `bnktrnsfr`.`Date` 
        END
    SET  
        `Amount_AUD` = `bnktrnsfr`.`Amount` * `fx`.`AUD`,
        `Amount_USD` = `bnktrnsfr`.`Amount` * `fx`.`USD`,
        `Amount_NZD` = `bnktrnsfr`.`Amount` * `fx`.`NZD`,
        `Amount_EUR` = `bnktrnsfr`.`Amount` * `fx`.`EUR`,
        `Amount_GBP` = `bnktrnsfr`.`Amount` * `fx`.`GBP`;

    DELETE `TRG`
    FROM `c1518_xeroblue_banktransfers` AS `TRG`
    INNER JOIN `c1518_5393_xeroblue_banktransfersstage` AS `STG` 
        ON `TRG`.`BankTransferId` = `STG`.`BankTransferId`
    WHERE `TRG`.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_banktransfers`
    SELECT 
        `BankTransferId`,
        `FromBankAccount_Code`,
        `FromBankAccount_AccountId`,
        `FromBankAccount_Name`,
        `ToBankAccount_Code`,
        `ToBankAccount_AccountId`,
        `ToBankAccount_Name`,
        `Amount`,
        NULLIF(`Date`,''),
        `CurrencyRate`,
        `FromBankTransactionID`,
        `ToBankTransactionID`,
        `HasAttachments`,
        `CreatedDateUTC`,
        `ClientID`,
        `OrganisationID`,
        `Amount_AUD`,
        `Amount_USD`,
        `Amount_NZD`,
        `Amount_EUR`,
        `Amount_GBP`
    FROM `c1518_5393_xeroblue_banktransfersstage`;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_batchpayments $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_batchpayments()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE `TRG`
    FROM `c1518_xeroblue_batchpayments` `TRG`
    INNER JOIN `c1518_5393_xeroblue_batchpaymentsstage` `STG` 
        ON `TRG`.`BatchPaymentId` = `STG`.`BatchPaymentId`
        AND `TRG`.`OrganisationId` = `STG`.`OrganisationId`
    WHERE `TRG`.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_batchpayments` 
    SELECT 
        `Id`,
        `BatchPaymentId`,
        `AccountId`,
        `Particulars`,
        `Code`,
        `Reference`,
        `Details`,
        `Narrative`,
        NULLIF(`Date`,''),
        `Payment_PaymentId`,
        `Payment_InvoiceId`,
        `Payment_BankAccountNumber`,
        `Payment_Particulars`,
        `Payment_Code`,
        `Payment_Reference`,
        `Payment_Details`,
        `Payment_Amount`,
        `PaymentAggregate`,
        `Type`,
        `Status`,
        `TotalAmount`,
        `IsReconciled`,
        NULLIF(`UpdatedDateUTC`,''),
        `ClientID`,
        `OrganisationID`
    FROM `c1518_5393_xeroblue_batchpaymentsstage`;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_brandingthemes $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_brandingthemes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_brandingthemes 
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_brandingthemes
	SELECT * FROM c1518_5393_xeroblue_brandingthemesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_contacts $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_contacts()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    UPDATE `c1518_5393_xeroblue_contactsstage`
    SET
        `FullAddress` = CONCAT(`Street_AddressLine1`, ' ', `Street_City`, ' ', `Street_Region`, ' ', `Street_Country`, ' ', `Street_PostalCode`),
        `RegionAddress` = CONCAT(`Street_City`, ' ', `Street_Region`, ' ', `Street_Country`)
    WHERE `OrganisationId` = v_OrganisationID;

    DELETE `trgt`
    FROM `c1518_xeroblue_contacts` `trgt`
    INNER JOIN `c1518_5393_xeroblue_contactsstage` `stg`
        ON `trgt`.`OrganisationId` = `stg`.`OrganisationId` 
        AND `trgt`.`ContactId` = `stg`.`ContactId`
    WHERE `trgt`.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_contacts`
    SELECT * 
    FROM `c1518_5393_xeroblue_contactsstage`
    WHERE `OrganisationId` = v_OrganisationID;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_currencies $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_currencies()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_currencies 
    WHERE `OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_currencies 
    SELECT * FROM c1518_5393_xeroblue_currenciesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_invoicesdraft $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_invoicesdraft()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

	UPDATE c1518_5393_xeroblue_invoicesdraftstage
	SET
		`DiscountRate` = IFNULL(`LineItem_DiscountRate`, 0), 
		`DiscountRate%` = IFNULL(`LineItem_DiscountRate` * 0.01, 0),
		`LineAmountCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),     
		`LineAmountCalculationIncTax` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),    	
		`LineAmountTradeCreditorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),   
		`LineAmountTradeDebtorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),
		`DayDifference` = DATEDIFF(NULLIF(`FullyPaidOnDate`,''), `Date`),
		`Account_UID` = CONCAT(`LineItem_AccountCode`, '-', `OrganisationID`);

	UPDATE `c1518_5393_xeroblue_invoicesdraftstage` AS `inv`
	LEFT JOIN (
			SELECT 
				`BaseCurrency`, 
				`Date`,
				AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
				AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
				AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
				AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
				AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
			FROM 
				`foreignexchange_master` AS `fx`
			WHERE 
				`fx`.`Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
			GROUP BY 
				`BaseCurrency`, 
				`Date`
		) AS `fx` ON `fx`.`BaseCurrency` = `inv`.`CurrencyCode` 
			AND `fx`.`Date` = CASE 
				WHEN `inv`.`Date` <= v_minDate THEN v_minDate
				WHEN `inv`.`Date` >= v_maxDate THEN v_maxDate
				ELSE `inv`.`Date` 
			END
	SET  
		`LineItem_UnitAmount_AUD` = `inv`.`LineItem_UnitAmount` * `AUD`,
		`LineItem_UnitAmount_USD` = `inv`.`LineItem_UnitAmount` * `USD`,
		`LineItem_UnitAmount_NZD` = `inv`.`LineItem_UnitAmount` * `NZD`,
		`LineItem_UnitAmount_EUR` = `inv`.`LineItem_UnitAmount` * `EUR`,
		`LineItem_UnitAmount_GBP` = `inv`.`LineItem_UnitAmount` * `GBP`,
		`LineItem_TaxAmount_AUD` = `inv`.`LineItem_TaxAmount` * `AUD`,
		`LineItem_TaxAmount_USD` = `inv`.`LineItem_TaxAmount` * `USD`,
		`LineItem_TaxAmount_NZD` = `inv`.`LineItem_TaxAmount` * `NZD`,
		`LineItem_TaxAmount_EUR` = `inv`.`LineItem_TaxAmount` * `EUR`,
		`LineItem_TaxAmount_GBP` = `inv`.`LineItem_TaxAmount` * `GBP`,
		`LineItem_LineAmount_AUD` = `inv`.`LineItem_LineAmount` * `AUD`,
		`LineItem_LineAmount_USD` = `inv`.`LineItem_LineAmount` * `USD`,
		`LineItem_LineAmount_NZD` = `inv`.`LineItem_LineAmount` * `NZD`,
		`LineItem_LineAmount_EUR` = `inv`.`LineItem_LineAmount` * `EUR`,
		`LineItem_LineAmount_GBP` = `inv`.`LineItem_LineAmount` * `GBP`,
		`LineItem_DiscountAmount_AUD` = `inv`.`LineItem_DiscountAmount` * `AUD`,
		`LineItem_DiscountAmount_USD` = `inv`.`LineItem_DiscountAmount` * `USD`,
		`LineItem_DiscountAmount_NZD` = `inv`.`LineItem_DiscountAmount` * `NZD`,
		`LineItem_DiscountAmount_EUR` = `inv`.`LineItem_DiscountAmount` * `EUR`,
		`LineItem_DiscountAmount_GBP` = `inv`.`LineItem_DiscountAmount` * `GBP`,
		`SubTotal_AUD` = `inv`.`SubTotal` * `AUD`,
		`SubTotal_USD` = `inv`.`SubTotal` * `USD`,
		`SubTotal_NZD` = `inv`.`SubTotal` * `NZD`,
		`SubTotal_EUR` = `inv`.`SubTotal` * `EUR`,
		`SubTotal_GBP` = `inv`.`SubTotal` * `GBP`,
		`TotalTax_AUD` = `inv`.`TotalTax` * `AUD`,
		`TotalTax_USD` = `inv`.`TotalTax` * `USD`,
		`TotalTax_NZD` = `inv`.`TotalTax` * `NZD`,
		`TotalTax_EUR` = `inv`.`TotalTax` * `EUR`,
		`TotalTax_GBP` = `inv`.`TotalTax` * `GBP`,
		`Total_AUD` = `inv`.`Total` * `AUD`,
		`Total_USD` = `inv`.`Total` * `USD`,
		`Total_NZD` = `inv`.`Total` * `NZD`,
		`Total_EUR` = `inv`.`Total` * `EUR`,
		`Total_GBP` = `inv`.`Total` * `GBP`,
		`TotalDiscount_AUD` = `inv`.`TotalDiscount` * `AUD`,
		`TotalDiscount_USD` = `inv`.`TotalDiscount` * `USD`,
		`TotalDiscount_NZD` = `inv`.`TotalDiscount` * `NZD`,
		`TotalDiscount_EUR` = `inv`.`TotalDiscount` * `EUR`,
		`TotalDiscount_GBP` = `inv`.`TotalDiscount` * `GBP`,
		`AmountDue_AUD` = `inv`.`AmountDue` * `AUD`,
		`AmountDue_USD` = `inv`.`AmountDue` * `USD`,
		`AmountDue_NZD` = `inv`.`AmountDue` * `NZD`,
		`AmountDue_EUR` = `inv`.`AmountDue` * `EUR`,
		`AmountDue_GBP` = `inv`.`AmountDue` * `GBP`,
		`AmountPaid_AUD` = `inv`.`AmountPaid` * `AUD`,
		`AmountPaid_USD` = `inv`.`AmountPaid` * `USD`,
		`AmountPaid_NZD` = `inv`.`AmountPaid` * `NZD`,
		`AmountPaid_EUR` = `inv`.`AmountPaid` * `EUR`,
		`AmountPaid_GBP` = `inv`.`AmountPaid` * `GBP`,
		`CISDeduction_AUD` = `inv`.`CISDeduction` * `AUD`,
		`CISDeduction_USD` = `inv`.`CISDeduction` * `USD`,
		`CISDeduction_NZD` = `inv`.`CISDeduction` * `NZD`,
		`CISDeduction_EUR` = `inv`.`CISDeduction` * `EUR`,
		`CISDeduction_GBP` = `inv`.`CISDeduction` * `GBP`,
		`AmountCredited_AUD` = `inv`.`AmountCredited` * `AUD`,
		`AmountCredited_USD` = `inv`.`AmountCredited` * `USD`,
		`AmountCredited_NZD` = `inv`.`AmountCredited` * `NZD`,
		`AmountCredited_EUR` = `inv`.`AmountCredited` * `EUR`,
		`AmountCredited_GBP` = `inv`.`AmountCredited` * `GBP`,
		`LineAmountCalculation_AUD` = `inv`.`LineAmountCalculation` * `AUD`,
		`LineAmountCalculation_USD` = `inv`.`LineAmountCalculation` * `USD`,
		`LineAmountCalculation_NZD` = `inv`.`LineAmountCalculation` * `NZD`,
		`LineAmountCalculation_EUR` = `inv`.`LineAmountCalculation` * `EUR`,
		`LineAmountCalculation_GBP` = `inv`.`LineAmountCalculation` * `GBP`,
		`LineAmountCalculationIncTax_AUD` = `inv`.`LineAmountCalculationIncTax` * `AUD`,
		`LineAmountCalculationIncTax_USD` = `inv`.`LineAmountCalculationIncTax` * `USD`,
		`LineAmountCalculationIncTax_NZD` = `inv`.`LineAmountCalculationIncTax` * `NZD`,
		`LineAmountCalculationIncTax_EUR` = `inv`.`LineAmountCalculationIncTax` * `EUR`,
		`LineAmountCalculationIncTax_GBP` = `inv`.`LineAmountCalculationIncTax` * `GBP`,
		`LineAmountTradeCreditorCalculation_AUD` = `inv`.`LineAmountTradeCreditorCalculation` * `AUD`,
		`LineAmountTradeCreditorCalculation_USD` = `inv`.`LineAmountTradeCreditorCalculation` * `USD`,
		`LineAmountTradeCreditorCalculation_NZD` = `inv`.`LineAmountTradeCreditorCalculation` * `NZD`,
		`LineAmountTradeCreditorCalculation_EUR` = `inv`.`LineAmountTradeCreditorCalculation` * `EUR`,
		`LineAmountTradeCreditorCalculation_GBP` = `inv`.`LineAmountTradeCreditorCalculation` * `GBP`,
		`LineAmountTradeDebtorCalculation_AUD` = `inv`.`LineAmountTradeDebtorCalculation` * `AUD`,
		`LineAmountTradeDebtorCalculation_USD` = `inv`.`LineAmountTradeDebtorCalculation` * `USD`,
		`LineAmountTradeDebtorCalculation_NZD` = `inv`.`LineAmountTradeDebtorCalculation` * `NZD`,
		`LineAmountTradeDebtorCalculation_EUR` = `inv`.`LineAmountTradeDebtorCalculation` * `EUR`,
		`LineAmountTradeDebtorCalculation_GBP` = `inv`.`LineAmountTradeDebtorCalculation` * `GBP`;

    DELETE TRG
	FROM c1518_xeroblue_invoicesdraft TRG
    INNER JOIN c1518_5393_xeroblue_invoicesdraftstage STG 
	ON TRG.`InvoiceId` = STG.`InvoiceId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_invoicesdraft (
        `Id`,
        `InvoiceId`,
        `Type`,
        `ContactId`,
        `ContactName`,
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
        `LineItem_DiscountAmount`,
        `LineItemAggregate`,
        `Date`,
        `DueDate`,
        `LineAmountTypes`,
        `InvoiceNumber`,
        `Reference`,
        `BrandingThemeId`,
        `URL`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Status`,
        `SentToContact`,
        `ExpectedPaymentDate`,
        `PlannedPaymentDate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        `PaymentIds`,
        `PrePaymentIds`,
        `OverPaymentIds`,
        `CreditNoteIds`,
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        `FullyPaidOnDate`,
        `AmountCredited`,
        `UpdatedDateUTC`,
        `CreditNotes`,
        `Prepayments`,
        `Payments`,
        `Overpayments`,
        `RepeatingInvoiceID`,
        `ClientID`,
        `OrganisationID`,
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`,
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    )
    SELECT
        NULLIF(`Id`, ''),
        NULLIF(`InvoiceId`, ''),
        NULLIF(`Type`, ''),
        NULLIF(`ContactId`, ''),
        NULLIF(`ContactName`, ''),
        NULLIF(`LineItem_LineItemId`, ''),
        NULLIF(`LineItem_Description`, ''),
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        NULLIF(`LineItem_ItemCode`, ''),
        NULLIF(`LineItem_AccountCode`, ''),
        NULLIF(`LineItem_TaxType`, ''),
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        NULLIF(`LineItem_TrackingCategory1_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory1_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory1_Option_Stat`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory2_Option_Stat`, ''),
        `LineItem_DiscountRate`,
        `LineItem_DiscountAmount`,
        NULLIF(`LineItemAggregate`, ''),
        NULLIF(`Date`, ''),
        NULLIF(`DueDate`, ''),
        NULLIF(`LineAmountTypes`, ''),
        NULLIF(`InvoiceNumber`, ''),
        NULLIF(`Reference`, ''),
        NULLIF(`BrandingThemeId`, ''),
        NULLIF(`URL`, ''),
        NULLIF(`CurrencyCode`, ''),
        `CurrencyRate`,
        NULLIF(`Status`, ''),
        `SentToContact`,
        NULLIF(`ExpectedPaymentDate`, ''),
        NULLIF(`PlannedPaymentDate`, ''),
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        NULLIF(`PaymentIds`, ''),
        NULLIF(`PrePaymentIds`, ''),
        NULLIF(`OverPaymentIds`, ''),
        NULLIF(`CreditNoteIds`, ''),
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        NULLIF(`FullyPaidOnDate`, ''),
        `AmountCredited`,
        NULLIF(`UpdatedDateUTC`, ''),
        NULLIF(`CreditNotes`, ''),
        NULLIF(`Prepayments`, ''),
        NULLIF(`Payments`, ''),
        NULLIF(`Overpayments`, ''),
        NULLIF(`RepeatingInvoiceID`, ''),
        NULLIF(`ClientID`, ''),
        NULLIF(`OrganisationID`, ''),
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`, 
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    FROM c1518_5393_xeroblue_invoicesdraftstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_repeatinginvoices $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_repeatinginvoices()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM `c1518_xeroblue_repeatinginvoices`
    WHERE `OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_repeatinginvoices`
    SELECT *
    FROM `c1518_5393_xeroblue_repeatinginvoicesstage`;

END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_taxrates $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_taxrates()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_taxrates
    WHERE OrganisationId = v_OrganisationID;

    INSERT INTO c1518_xeroblue_taxrates
    SELECT * FROM c1518_5393_xeroblue_taxratesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_users $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_users()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_users
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_users
	select * from c1518_5393_xeroblue_usersstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_contactgroups $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_contactgroups()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_contactgroups
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_contactgroups
	select * from c1518_5393_xeroblue_contactgroupsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_expenseclaims $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_expenseclaims()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_expenseclaims
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_expenseclaims
	select * from c1518_5393_xeroblue_expenseclaimsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_items $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_items()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	UPDATE `c1518_5393_xeroblue_itemsstage`
    SET
        `CodeUID` = CONCAT(`Code`, CAST(`OrganisationID` AS CHAR)),
        `InventoryCodeUID` = CONCAT(`InventoryAssetAccountCode`, CAST(`OrganisationID` AS CHAR));

    DELETE FROM `c1518_xeroblue_items` 
    WHERE `OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_items`
    SELECT * 
    FROM `c1518_5393_xeroblue_itemsstage`;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_purchaseorders $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_purchaseorders()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE TRG
	FROM c1518_xeroblue_purchaseorders TRG
    INNER JOIN c1518_5393_xeroblue_purchaseordersstage STG 
	ON TRG.`PurchaseOrderId` = STG.`PurchaseOrderId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_purchaseorders`
    SELECT * FROM `c1518_5393_xeroblue_purchaseordersstage`;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_receipts $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_receipts()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_receipts
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_receipts
	select * from c1518_5393_xeroblue_receiptsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_trackingcategories $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_trackingcategories()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_trackingcategories
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_trackingcategories
	select * from c1518_5393_xeroblue_trackingcategoriesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_employees $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_employees()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_employees
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_employees
	select * from c1518_5393_xeroblue_employeesstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_linkedtransactions $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_linkedtransactions()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_linkedtransactions
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_linkedtransactions
	select * from c1518_5393_xeroblue_linkedtransactionsstage;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_quotes $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_quotes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE `TRG`
    FROM `c1518_xeroblue_quotes` `TRG`
    INNER JOIN `c1518_5393_xeroblue_quotesstage` `STG` 
        ON `TRG`.`QuoteId` = `STG`.`QuoteId`
    WHERE `TRG`.`OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_quotes
	select * from c1518_5393_xeroblue_quotesstage;
END $$
DELIMITER ;

# Updated - Feb 13, 2025 - Package now using Dynamic SP
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_transactions $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_transactions()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    TRUNCATE TABLE c1518_5393_xeroblue_transactionsstage;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        C.`Id` AS `LineID`,
        C.`CreditNoteId` AS `ID`,
        C.`Date` AS `Date`,
        C.`Type` AS `Type`,
        C.`Contact_ContactId` AS `ContactID`,
        C.`Contact_Name` AS `ContactName`,
        NULL AS `LineItemID`,
        C.`LineItem_Description` AS `Description`,
        C.`LineItem_Quantity` AS `Quantity`,
        C.`LineItem_UnitAmount` AS `UnitAmount`,
        C.`LineItem_ItemCode` AS `ItemCode`,
        C.`LineItem_AccountCode` AS `AccountCode`,
        C.`LineItem_TaxType` AS `TaxType`,
        C.`LineItem_TaxAmount` AS `TaxAmount`,
        C.`LineItem_LineAmount` AS `LineAmount`,
        C.`LineAmountTypes` AS `LineAmountTypes`,
        C.`Status` AS `Status`,
        C.`SubTotal` AS `SubTotal`,
        C.`TotalTax` AS `TotalTax`,
        C.`Total` AS `Total`,
        C.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        C.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        C.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        C.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        C.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        C.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        C.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        C.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        C.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        C.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        C.`LineItem_DiscountRate` AS `DiscountRate`,
        C.`CurrencyCode` AS `CurrencyCode`,
        CAST(C.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
        C.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(C.`LineItem_AccountCode`, 'BLANK'), '-', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
        C.`HasAttachments` AS `HasAttachments`,
        C.`CreditNoteNumber` AS `CreditNoteNumber`,
        C.`RemainingCredit` AS `RemainingCredit`,
        C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
        C.`Reference` AS `Reference`,
        'CREDITNOTES' AS `Source`,
        C.`ClientID` AS `ClientID`,
        C.`OrganisationID` AS `OrganisationID`,
        C.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
        C.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
        C.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
        C.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
        C.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
        C.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
        C.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
        C.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
        C.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
        C.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
        C.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
        C.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
        C.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
        C.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
        C.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
        C.`SubTotal_AUD` AS `SubTotal_AUD`,
        C.`SubTotal_USD` AS `SubTotal_USD`,
        C.`SubTotal_NZD` AS `SubTotal_NZD`,
        C.`SubTotal_EUR` AS `SubTotal_EUR`,
        C.`SubTotal_GBP` AS `SubTotal_GBP`,
        C.`TotalTax_AUD` AS `TotalTax_AUD`,
        C.`TotalTax_USD` AS `TotalTax_USD`,
        C.`TotalTax_NZD` AS `TotalTax_NZD`,
        C.`TotalTax_EUR` AS `TotalTax_EUR`,
        C.`TotalTax_GBP` AS `TotalTax_GBP`,
        C.`Total_AUD` AS `Total_AUD`,
        C.`Total_USD` AS `Total_USD`,
        C.`Total_NZD` AS `Total_NZD`,
        C.`Total_EUR` AS `Total_EUR`,
        C.`Total_GBP` AS `Total_GBP`,
        C.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
        C.`RemainingCredit_USD` AS `RemainingCredit_USD`,
        C.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
        C.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
        C.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        CA.InvoiceId AS `PaymentSourceID`,
        CASE WHEN CA.InvoiceId IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
        CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Dt ELSE NULL END AS `AllocationDate`,
        CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Amount ELSE NULL END AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User`,
        NULL AS `Details`,
        DATEDIFF(C.`FullyPaidOnDate`, C.`Date`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        C.`RemainingCredit` AS `AmountDue`,
        C.`RemainingCredit_AUD` AS `AmountDue_AUD`,
        C.`RemainingCredit_USD` AS `AmountDue_USD`,
        C.`RemainingCredit_NZD` AS `AmountDue_NZD`,
        C.`RemainingCredit_EUR` AS `AmountDue_EUR`,
        C.`RemainingCredit_GBP` AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_creditnotes C
    LEFT JOIN (
        SELECT DISTINCT
            `CreditNoteId`,
            `InvoiceId`,
            `Dt`,
            `Amount`,
            `ClientID`,
            `OrganisationID`
        FROM evadb.bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud
        WHERE `OrganisationID` = v_OrganisationID
    ) CA
        ON C.`CreditNoteID` = CA.`CreditNoteID` 
        AND C.`OrganisationID` = CA.`OrganisationID`
    WHERE c.OrganisationID = v_OrganisationID;
    
    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        `Id` AS `LineID`,
        `InvoiceId` AS `ID`,
        `Date` AS `Date`,
        `Type` AS `Type`,
        `ContactId` AS `ContactID`,
        `ContactName` AS `ContactName`,
        `LineItem_LineItemId` AS `LineItemID`,
        `LineItem_Description` AS `Description`,
        `LineItem_Quantity` AS `Quantity`,
        `LineItem_UnitAmount` AS `UnitAmount`,
        `LineItem_ItemCode` AS `ItemCode`,
        `LineItem_AccountCode` AS `AccountCode`,
        `LineItem_TaxType` AS `TaxType`,
        `LineItem_TaxAmount` AS `TaxAmount`,
        `LineItem_LineAmount` AS `LineAmount`,
        `LineAmountTypes` AS `LineAmountTypes`,
        `Status` AS `Status`,
        `SubTotal` AS `SubTotal`,
        `TotalTax` AS `TotalTax`,
        `Total` AS `Total`,
        `LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        `LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        `LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        `LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        `LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        `LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        `LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        `LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        `LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        `LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        `LineItem_DiscountRate` AS `DiscountRate`,
        `CurrencyCode` AS `CurrencyCode`,
        CAST(`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
        `UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `FullyPaidOnDate` AS `FullyPaidOnDate`,
        `Reference` AS `Reference`,
        'INVOICES' AS `Source`,
        `ClientID` AS `ClientID`,
        `OrganisationID` AS `OrganisationID`,
        `LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
        `LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
        `LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
        `LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
        `LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
        `LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
        `LineItem_LineAmount_USD` AS `LineAmount_USD`,
        `LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
        `LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
        `LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
        `SubTotal_AUD` AS `SubTotal_AUD`,
        `SubTotal_USD` AS `SubTotal_USD`,
        `SubTotal_NZD` AS `SubTotal_NZD`,
        `SubTotal_EUR` AS `SubTotal_EUR`,
        `SubTotal_GBP` AS `SubTotal_GBP`,
        `TotalTax_AUD` AS `TotalTax_AUD`,
        `TotalTax_USD` AS `TotalTax_USD`,
        `TotalTax_NZD` AS `TotalTax_NZD`,
        `TotalTax_EUR` AS `TotalTax_EUR`,
        `TotalTax_GBP` AS `TotalTax_GBP`,
        `Total_AUD` AS `Total_AUD`,
        `Total_USD` AS `Total_USD`,
        `Total_NZD` AS `Total_NZD`,
        `Total_EUR` AS `Total_EUR`,
        `Total_GBP` AS `Total_GBP`,
        NULL AS `RemainingCredit_AUD`,
        NULL AS `RemainingCredit_USD`,
        NULL AS `RemainingCredit_NZD`,
        NULL AS `RemainingCredit_EUR`,
        NULL AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        `DueDate` AS `DueDate`,
        `InvoiceNumber` AS `InvoiceNumber`,
        NULL AS `PaymentSourceID`,
        NULL AS `PaymentType`,
        NULL AS `AllocationDate`,
        NULL AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User`,
        NULL AS `Details`,
        DATEDIFF(`FullyPaidOnDate`, `Date`) AS `DayDifference`,
        `PlannedPaymentDate` AS `PlannedPaymentDate`,
        `AmountDue` AS `AmountDue`,
        `AmountDue_AUD` AS `AmountDue_AUD`,
        `AmountDue_USD` AS `AmountDue_USD`,
        `AmountDue_NZD` AS `AmountDue_NZD`,
        `AmountDue_EUR` AS `AmountDue_EUR`,
        `AmountDue_GBP` AS `AmountDue_GBP`,
        `URL` AS `URL`
    FROM c1518_xeroblue_invoices
    WHERE `OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        OP.`OverpaymentId` AS `LineID`,
        OP.`OverpaymentId` AS `ID`,
        OP.`Date` AS `Date`,
        OP.`Type` AS `Type`,
        OP.`Contact_ContactId` AS `ContactID`,
        OP.`Contact_Name` AS `ContactName`,
        OP.`LineItem_LineItemId` AS `LineItemID`,
        OP.`LineItem_Description` AS `Description`,
        OP.`LineItem_Quantity` AS `Quantity`,
        OP.`LineItem_UnitAmount` AS `UnitAmount`,
        OP.`LineItem_ItemCode` AS `ItemCode`,
        OP.`LineItem_AccountCode` AS `AccountCode`,
        OP.`LineItem_TaxType` AS `TaxType`,
        OP.`LineItem_TaxAmount` AS `TaxAmount`,
        OP.`LineItem_LineAmount` AS `LineAmount`,
        OP.`LineAmountTypes` AS `LineAmountTypes`,
        OP.`Status` AS `Status`,
        OP.`SubTotal` AS `SubTotal`,
        OP.`TotalTax` AS `TotalTax`,
        OP.`Total` AS `Total`,
        OP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        OP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        OP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        OP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        OP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        OP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        OP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        OP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        OP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        OP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        OP.`LineItem_DiscountRate` AS `DiscountRate`,
        OP.`CurrencyCode` AS `CurrencyCode`,
        CAST(NULLIF(OP.`CurrencyRate`,'') AS FLOAT) AS `CurrencyRate`,
        OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(OP.`LineItem_AccountCode`, 'BLANK'), '-', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
        OP.`HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        OP.`RemainingCredit` AS `RemainingCredit`,
        OP.`Date` AS `FullyPaidOnDate`,
        NULL AS `Reference`,
        'OVERPAYMENTS' AS `Source`,
        OP.`ClientID` AS `ClientID`,
        OP.`OrganisationID` AS `OrganisationID`,
        OP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
        OP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
        OP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
        OP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
        OP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
        OP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
        OP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
        OP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
        OP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
        OP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
        OP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
        OP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
        OP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
        OP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
        OP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
        OP.`SubTotal_AUD` AS `SubTotal_AUD`,
        OP.`SubTotal_USD` AS `SubTotal_USD`,
        OP.`SubTotal_NZD` AS `SubTotal_NZD`,
        OP.`SubTotal_EUR` AS `SubTotal_EUR`,
        OP.`SubTotal_GBP` AS `SubTotal_GBP`,
        OP.`TotalTax_AUD` AS `TotalTax_AUD`,
        OP.`TotalTax_USD` AS `TotalTax_USD`,
        OP.`TotalTax_NZD` AS `TotalTax_NZD`,
        OP.`TotalTax_EUR` AS `TotalTax_EUR`,
        OP.`TotalTax_GBP` AS `TotalTax_GBP`,
        OP.`Total_AUD` AS `Total_AUD`,
        OP.`Total_USD` AS `Total_USD`,
        OP.`Total_NZD` AS `Total_NZD`,
        OP.`Total_EUR` AS `Total_EUR`,
        OP.`Total_GBP` AS `Total_GBP`,
        OP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
        OP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
        OP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
        OP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
        OP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        OPA.`InvoiceId` AS `PaymentSourceID`,
        CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
        CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Dt` ELSE NULL END AS `AllocationDate`,
        CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Amount` ELSE NULL END AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User `,
        NULL AS `Details`,
        DATEDIFF(OP.`Date`, OP.`Date`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        NULL AS `AmountDue`,
        NULL AS `AmountDue_AUD`,
        NULL AS `AmountDue_USD`,
        NULL AS `AmountDue_NZD`,
        NULL AS `AmountDue_EUR`,
        NULL AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_overpayments OP
    LEFT JOIN (
        SELECT DISTINCT
            `OverPaymentId`,
            `InvoiceId`,
            `Dt`,
            `Amount`,
            `Client ID`,
            `Organisation ID`
        FROM evadb.bigoleshoecompany_client1518_xeroblue_overpaymentallocation_aud
        WHERE `Organisation ID` = v_OrganisationID
    ) OPA 
        ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
        AND OP.`OrganisationID` = OPA.`Organisation ID`
    WHERE OP.`OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        PP.`PrepaymentId` AS `LineID`,
        PP.`PrepaymentId` AS `ID`,
        PP.`Date` AS `Date`,
        PP.`Type` AS `Type`,
        PP.`Contact_ContactId` AS `ContactID`,
        PP.`Contact_Name` AS `ContactName`,
        PP.`LineItem_LineItemId` AS `LineItemID`,
        PP.`LineItem_Description` AS `Description`,
        PP.`LineItem_Quantity` AS `Quantity`,
        PP.`LineItem_UnitAmount` AS `UnitAmount`,
        PP.`LineItem_ItemCode` AS `ItemCode`,
        PP.`LineItem_AccountCode` AS `AccountCode`,
        PP.`LineItem_TaxType` AS `TaxType`,
        PP.`LineItem_TaxAmount` AS `TaxAmount`,
        PP.`LineItem_LineAmount` AS `LineAmount`,
        PP.`LineAmountTypes` AS `LineAmountTypes`,
        PP.`Status` AS `Status`,
        PP.`SubTotal` AS `SubTotal`,
        PP.`TotalTax` AS `TotalTax`,
        PP.`Total` AS `Total`,
        PP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        PP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        PP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        PP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        PP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        PP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        PP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        PP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        PP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        PP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        PP.`LineItem_DiscountRate` AS `DiscountRate`,
        PP.`CurrencyCode` AS `CurrencyCode`,
        NULLIF(PP.`CurrencyRate`,'') AS `CurrencyRate`,
        PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(PP.`LineItem_AccountCode`, 'BLANK'), '-', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
        PP.`HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        PP.`RemainingCredit` AS `RemainingCredit`,
        PP.`Date` AS `FullyPaidOnDate`,
        PP.`Reference` AS `Reference`,
        'PREPAYMENTS' AS `Source`,
        PP.`ClientID` AS `ClientID`,
        PP.`OrganisationID` AS `OrganisationID`,
        PP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
        PP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
        PP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
        PP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
        PP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
        PP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
        PP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
        PP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
        PP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
        PP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
        PP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
        PP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
        PP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
        PP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
        PP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
        PP.`SubTotal_AUD` AS `SubTotal_AUD`,
        PP.`SubTotal_USD` AS `SubTotal_USD`,
        PP.`SubTotal_NZD` AS `SubTotal_NZD`,
        PP.`SubTotal_EUR` AS `SubTotal_EUR`,
        PP.`SubTotal_GBP` AS `SubTotal_GBP`,
        PP.`TotalTax_AUD` AS `TotalTax_AUD`,
        PP.`TotalTax_USD` AS `TotalTax_USD`,
        PP.`TotalTax_NZD` AS `TotalTax_NZD`,
        PP.`TotalTax_EUR` AS `TotalTax_EUR`,
        PP.`TotalTax_GBP` AS `TotalTax_GBP`, 
        PP.`Total_AUD` AS `Total_AUD`,
        PP.`Total_USD` AS `Total_USD`,
        PP.`Total_NZD` AS `Total_NZD`,
        PP.`Total_EUR` AS `Total_EUR`,
        PP.`Total_GBP` AS `Total_GBP`,
        PP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
        PP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
        PP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
        PP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
        PP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        PPA.`InvoiceId` AS `PaymentSourceID`,
        CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN 'INVOICES' ELSE NULL END AS `PaymentType`,
        CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Dt` ELSE NULL END AS `AllocationDate`,
        CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Amount` ELSE NULL END AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User `,
        NULL AS `Details`,
        DATEDIFF(PP.`Date`, PP.`Date`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        NULL AS `AmountDue`,
        NULL AS `AmountDue_AUD`,
        NULL AS `AmountDue_USD`,
        NULL AS `AmountDue_NZD`,
        NULL AS `AmountDue_EUR`,
        NULL AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_prepayments PP
    LEFT JOIN (
        SELECT DISTINCT
            `PrePaymentId`,
            `InvoiceId`,
            `Dt`,
            `Amount`,
            `Client ID`,
            `Organisation ID`
        FROM evadb.bigoleshoecompany_client1518_xeroblue_prepaymentallocation_aud
        WHERE `Organisation ID` = v_OrganisationID
    ) PPA 
        ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
        AND PP.`OrganisationID` = PPA.`Organisation ID`
    WHERE PP.`OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        `Id` AS `LineID`,
        `ManualJournalId` AS `ID`,
        `Date` AS `Date`,
        NULL AS `Type`,
        NULL AS `ContactID`,
        NULL AS `ContactName`,
        NULL AS `LineItemID`,
        `JournalLine_Description` AS `Description`,
        NULL AS `Quantity`,
        NULL AS `UnitAmount`,
        NULL AS `ItemCode`,
        `JournalLine_AccountCode` AS `AccountCode`,
        `JournalLine_TaxType` AS `TaxType`,
        `JournalLine_TaxAmount` AS `TaxAmount`,
        `JournalLine_LineAmount` AS `LineAmount`,
        `LineAmountTypes` AS `LineAmountTypes`,
        `Status` AS `Status`,
        NULL AS `SubTotal`,
        NULL AS `TotalTax`,
        NULL AS `Total`,
        `JournalLine_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        `JournalLine_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        `JournalLine_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        `JournalLine_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        `JournalLine_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        `JournalLine_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        `JournalLine_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        `JournalLine_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        NULL AS `DiscountRate`,
        NULL AS `CurrencyCode`,
        NULL AS `CurrencyRate`,
        `UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(`JournalLine_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `Date` AS `FullyPaidOnDate`,
        NULL AS `Reference`,
        'MANUALJOURNALS' AS `Source`,
        `ClientID` AS `ClientID`,
        `OrganisationID` AS `OrganisationID`,
        NULL AS `UnitAmount_AUD`,
        NULL AS `UnitAmount_USD`,
        NULL AS `UnitAmount_NZD`,
        NULL AS `UnitAmount_EUR`,
        NULL AS `UnitAmount_GBP`,
        `JournalLine_TaxAmount_AUD` AS `TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD` AS `TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD` AS `TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR` AS `TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP` AS `TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD` AS `LineAmount_AUD`,
        `JournalLine_LineAmount_USD` AS `LineAmount_USD`,
        `JournalLine_LineAmount_NZD` AS `LineAmount_NZD`,
        `JournalLine_LineAmount_EUR` AS `LineAmount_EUR`,
        `JournalLine_LineAmount_GBP` AS `LineAmount_GBP`,
        NULL AS `SubTotal_AUD`,
        NULL AS `SubTotal_USD`,
        NULL AS `SubTotal_NZD`,
        NULL AS `SubTotal_EUR`,
        NULL AS `SubTotal_GBP`,
        NULL AS `TotalTax_AUD`,
        NULL AS `TotalTax_USD`,
        NULL AS `TotalTax_NZD`,
        NULL AS `TotalTax_EUR`,
        NULL AS `TotalTax_GBP`,
        NULL AS `Total_AUD`,
        NULL AS `Total_USD`,
        NULL AS `Total_NZD`,
        NULL AS `Total_EUR`,
        NULL AS `Total_GBP`,
        NULL AS `RemainingCredit_AUD`,
        NULL AS `RemainingCredit_USD`,
        NULL AS `RemainingCredit_NZD`,
        NULL AS `RemainingCredit_EUR`,
        NULL AS `RemainingCredit_GBP`,
        `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        NULL AS `PaymentSourceID`,
        NULL AS `PaymentType`,
        NULL AS `AllocationDate`,
        NULL AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User  `,
        NULL AS `Details`,
        DATEDIFF(`Date`, `Date`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        NULL AS `AmountDue`,
        NULL AS `AmountDue_AUD`,
        NULL AS `AmountDue_USD`,
        NULL AS `AmountDue_NZD`,
        NULL AS `AmountDue_EUR`,
        NULL AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_manualjournals
    WHERE `OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        `Id` AS `LineID`,
        `BankTransactionId` AS `ID`,
        `Date` AS `Date`,
        `Type` AS `Type`,
        `Contact_ContactId` AS `ContactID`,
        `Contact_ContactName` AS `ContactName`,
        `LineItem_LineItemId` AS `LineItemID`,
        `LineItem_Description` AS `Description`,
        `LineItem_Quantity` AS `Quantity`,
        `LineItem_UnitAmount` AS `UnitAmount`,
        `LineItem_ItemCode` AS `ItemCode`,
        `LineItem_AccountCode` AS `AccountCode`,
        `LineItem_TaxType` AS `TaxType`,
        `LineItem_TaxAmount` AS `TaxAmount`,
        `LineItem_LineAmount` AS `LineAmount`,
        `LineAmountTypes` AS `LineAmountTypes`,
        `Status` AS `Status`,
        `SubTotal` AS `SubTotal`,
        `TotalTax` AS `TotalTax`,
        `Total` AS `Total`,
        `LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
        `LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
        `LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
        `LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
        `LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
        `LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
        `LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
        `LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
        `LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
        `LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
        NULL AS `DiscountRate`,
        `CurrencyCode` AS `CurrencyCode`,
        CAST(`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
        `UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `AccountUID`,
        `HasAttachments` AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        `FullyPaidOnDate` AS `FullyPaidOnDate`,
        `Reference` AS `Reference`,
        'BANKTRANSACTIONS' AS `Source`,
        `ClientID` AS `ClientID`,
        `OrganisationID` AS `OrganisationID`,
        `LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
        `LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
        `LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
        `LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
        `LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
        `LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
        `LineItem_LineAmount_USD` AS `LineAmount_USD`,
        `LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
        `LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
        `LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
        `SubTotal_AUD` AS `SubTotal_AUD`,
        `SubTotal_USD` AS `SubTotal_USD`,
        `SubTotal_NZD` AS `SubTotal_NZD`,
        `SubTotal_EUR` AS `SubTotal_EUR`,
        `SubTotal_GBP` AS `SubTotal_GBP`,
        `TotalTax_AUD` AS `TotalTax_AUD`,
        `TotalTax_USD` AS `TotalTax_USD`,
        `TotalTax_NZD` AS `TotalTax_NZD`,
        `TotalTax_EUR` AS `TotalTax_EUR`,
        `TotalTax_GBP` AS `TotalTax_GBP`,
        `Total_AUD` AS `Total_AUD`,
        `Total_USD` AS `Total_USD`,
        `Total_NZD` AS `Total_NZD`,
        `Total_EUR` AS `Total_EUR`,
        `Total_GBP` AS `Total_GBP`,
        NULL AS `RemainingCredit_AUD`,
        NULL AS `Remaining Credit_USD`,
        NULL AS `RemainingCredit_NZD`,
        NULL AS `RemainingCredit_EUR`,
        NULL AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        NULL AS `PaymentSourceID`,
        NULL AS `PaymentType`,
        NULL AS `AllocationDate`,
        NULL AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User `,
        NULL AS `Details`,
        DATEDIFF(`Date`, `FullyPaidOnDate`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        NULL AS `AmountDue`,
        NULL AS `AmountDue_AUD`,
        NULL AS `AmountDue_USD`,
        NULL AS `AmountDue_NZD`,
        NULL AS `AmountDue_EUR`,
        NULL AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_banktransactions
    WHERE `OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_5393_xeroblue_transactionsstage
    (
        `LineID`,
        `ID`,
        `Date`,
        `Type`,
        `ContactID`,
        `ContactName`,
        `LineItemID`,
        `Description`,
        `Quantity`,
        `UnitAmount`,
        `ItemCode`,
        `AccountCode`,
        `TaxType`,
        `TaxAmount`,
        `LineAmount`,
        `LineAmountTypes`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TrackingCategory1CategoryID`,
        `TrackingCategory1CategoryName`,
        `TrackingCategory1OptionID`,
        `TrackingCategory1OptionName`,
        `TrackingCategory1OptionStat`,
        `TrackingCategory2CategoryID`,
        `TrackingCategory2CategoryName`,
        `TrackingCategory2OptionID`,
        `TrackingCategory2OptionName`,
        `TrackingCategory2OptionStat`,
        `DiscountRate`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `AccountUID`,
        `HasAttachments`,
        `CreditNoteNumber`,
        `RemainingCredit`,
        `FullyPaidOnDate`,
        `Reference`,
        `Source`,
        `ClientID`,
        `OrganisationID`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `TaxAmount_AUD`,
        `TaxAmount_USD`,
        `TaxAmount_NZD`,
        `TaxAmount_EUR`,
        `TaxAmount_GBP`,
        `LineAmount_AUD`,
        `LineAmount_USD`,
        `LineAmount_NZD`,
        `LineAmount_EUR`,
        `LineAmount_GBP`,
        `SubTotal_AUD`,
        `SubTotal_USD`,
        `SubTotal_NZD`,
        `SubTotal_EUR`,
        `SubTotal_GBP`,
        `TotalTax_AUD`,
        `TotalTax_USD`,
        `TotalTax_NZD`,
        `TotalTax_EUR`,
        `TotalTax_GBP`,
        `Total_AUD`,
        `Total_USD`,
        `Total_NZD`,
        `Total_EUR`,
        `Total_GBP`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
        `ShowOnCashBasisReports`,
        `DueDate`,
        `InvoiceNumber`,
        `PaymentSourceID`,
        `PaymentType`,
        `AllocationDate`,
        `AllocationAmount`,
        `Changes`,
        `User`,
        `Details`,
        `DayDifference`,
        `PlannedPaymentDate`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`
    )
    SELECT DISTINCT
        P.`PaymentId` AS `LineID`,
        P.`PaymentId` AS `ID`,
        P.`Date` AS `Date`,
        P.`PaymentType` AS `Type`,
        CASE 
            WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.`ContactId`
            WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.`Contact_ContactId`
            WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.`Contact_ContactId`
            WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.`Contact_ContactId`
            END AS `ContactID`,
        CASE 
            WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN I.`ContactName`
            WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN C.`Contact_Name`
            WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN PP.`Contact_Name`
            WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN OP.`Contact_Name`
            END AS `ContactName`,
        P.`PaymentId` AS `LineItemID`,
        NULL AS `Description`,
        NULL AS `Quantity`,
        NULL AS `UnitAmount`,
        NULL AS `ItemCode`,
        P.`AccountCode` AS `AccountCode`,
        NULL AS `TaxType`,
        NULL AS `TaxAmount`,
        P.`Amount` AS `LineAmount`,
        NULL AS `LineAmountTypes`,
        P.`Status` AS `Status`,
        NULL AS `SubTotal`,
        NULL AS `TotalTax`,
        NULL AS `Total`,
        NULL AS `TrackingCategory1CategoryID`,
        NULL AS `TrackingCategory1CategoryName`,
        NULL AS `TrackingCategory1OptionID`,
        NULL AS `TrackingCategory1OptionName`,
        NULL AS `TrackingCategory1OptionStat`,
        NULL AS `TrackingCategory2CategoryID`,
        NULL AS `TrackingCategory2CategoryName`,
        NULL AS `TrackingCategory2OptionID`,
        NULL AS `TrackingCategory2OptionName`,
        NULL AS `TrackingCategory2OptionStat`,
        NULL AS `DiscountRate`,
        NULL AS `CurrencyCode`,
        CASE WHEN P.`CurrencyRate` LIKE '%E%' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION('E' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
        P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
        CONCAT(IFNULL(P.`AccountCode`, 'BLANK'), '-', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
        NULL AS `HasAttachments`,
        NULL AS `CreditNoteNumber`,
        NULL AS `RemainingCredit`,
        P.`Date` AS `FullyPaidOnDate`,
        P.`Reference` AS `Reference`,
        'PAYMENTS' AS `Source`,
        P.`ClientID` AS `ClientID`,
        P.`OrganisationID` AS `OrganisationID`,
        NULL AS `UnitAmount_AUD`,
        NULL AS `UnitAmount_USD`,
        NULL AS `UnitAmount_NZD`,
        NULL AS `UnitAmount_EUR`,
        NULL AS `UnitAmount_GBP`,
        NULL AS `TaxAmount_AUD`,
        NULL AS `TaxAmount_USD`,
        NULL AS `TaxAmount_NZD`,
        NULL AS `TaxAmount_EUR`,
        NULL AS `TaxAmount_GBP`,
        P.`Amount_AUD` AS `LineAmount_AUD`,
        P.`Amount_USD` AS `LineAmount_USD`,
        P.`Amount_NZD` AS `LineAmount_NZD`,
        P.`Amount_EUR` AS `LineAmount_EUR`,
        P.`Amount_GBP` AS `LineAmount_GBP`,
        NULL AS `SubTotal_AUD`,
        NULL AS `SubTotal_USD`,
        NULL AS `SubTotal_NZD`,
        NULL AS `SubTotal_EUR`,
        NULL AS `SubTotal_GBP`,
        NULL AS `TotalTax_AUD`,
        NULL AS `TotalTax_USD`,
        NULL AS `TotalTax_NZD`,
        NULL AS `TotalTax_EUR`,
        NULL AS `TotalTax_GBP`,
        NULL AS `Total_AUD`,
        NULL AS `Total_USD`,
        NULL AS `Total_NZD`,
        NULL AS `Total_EUR`,
        NULL AS `Total_GBP`,
        NULL AS `RemainingCredit_AUD`,
        NULL AS `RemainingCredit_USD`,
        NULL AS `RemainingCredit_NZD`,
        NULL AS `RemainingCredit_EUR`,
        NULL AS `RemainingCredit_GBP`,
        NULL AS `ShowOnCashBasisReports`,
        NULL AS `DueDate`,
        NULL AS `InvoiceNumber`,
        P.`InvoiceId` AS `PaymentSourceID`,
        CASE 
            WHEN P.`PaymentType` IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') THEN 'INVOICES'
            WHEN P.`PaymentType` IN ('ARCREDITPAYMENT', 'APCREDITPAYMENT') THEN 'CREDITNOTES'
            WHEN P.`PaymentType` IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') THEN 'PREPAYMENTS'
            WHEN P.`PaymentType` IN ('AROVERPAYMENTPAYMENT', 'APOVERPAYMENTPAYMENT') THEN 'OVERPAYMENTS'
            END AS `PaymentSourceType`,
        NULL AS `AllocationDate`,
        NULL AS `AllocationAmount`,
        NULL AS `Changes`,
        NULL AS `User `,
        NULL AS `Details`,
        DATEDIFF(P.`Date`, P.`Date`) AS `DayDifference`,
        NULL AS `PlannedPaymentDate`,
        NULL AS `AmountDue`,
        NULL AS `AmountDue_AUD`,
        NULL AS `AmountDue_USD`,
        NULL AS `AmountDue_NZD`,
        NULL AS `AmountDue_EUR`,
        NULL AS `AmountDue_GBP`,
        NULL AS `URL`
    FROM c1518_xeroblue_payments P
    LEFT JOIN c1518_xeroblue_invoices I 
        ON P.`InvoiceId` = I.`InvoiceId` AND P.`OrganisationID` = I.`OrganisationID`
    LEFT JOIN c1518_xeroblue_creditnotes C
        ON P.`InvoiceId` = C.`CreditNoteID` AND P.`OrganisationID` = C.`OrganisationID`
    LEFT JOIN c1518_xeroblue_prepayments PP
        ON P.`InvoiceId` = PP.`PrepaymentId` AND P.`OrganisationID` = PP.`OrganisationID`
    LEFT JOIN c1518_xeroblue_overpayments OP
        ON P.`InvoiceId` = OP.`OverpaymentId` AND P.`OrganisationID` = OP.`OrganisationID`
    WHERE P.`OrganisationID` = v_OrganisationID;

    DELETE FROM c1518_xeroblue_transactions WHERE `OrganisationID` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_transactions
    SELECT * FROM c1518_5393_xeroblue_transactionsstage;
END $$
DELIMITER ;

# Updated - Feb 25, 2025 - Package now using Dynamic SP - Not Applied yet
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_transactionsblend $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_transactionsblend()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DECLARE v_MaxJournal INT DEFAULT 0;

    SELECT v_MaxJournal = MAX(`JournalNumber`) 
    FROM c1518_xeroblue_transactionsblend
    WHERE OrganisationID = v_OrganisationID

	TRUNCATE TABLE c1518_5393_xeroblue_transactionsblendstage;

    INSERT INTO `c1518_5393_xeroblue_transactionsblendstage`
    (
        `Id`,
        `JournalId`,
        `JournalDate`,
        `JournalNumber`,
        `CreatedDateUTC`,
        `SourceId`,
        `SourceType`,
        `JournalLine_JournalLineId`,
        `JournalLine_Description`,
        `JournalLine_AccountId`,
        `JournalLine_AccountCode`,
        `JournalLine_AccountType`,
        `JournalLine_AccountName`,
        `JournalLine_NetAmount`,
        `JournalLine_GrossAmount`,
        `JournalLine_TaxAmount`,
        `JournalLine_TaxType`,
        `JournalLine_TaxName`,
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
        `ClientID`,
        `OrganisationID`,
        `JournalLine_NetAmount_AUD`,
        `JournalLine_NetAmount_USD`,
        `JournalLine_NetAmount_NZD`,
        `JournalLine_NetAmount_EUR`,
        `JournalLine_NetAmount_GBP`,
        `JournalLine_GrossAmount_AUD`,
        `JournalLine_GrossAmount_USD`,
        `JournalLine_GrossAmount_NZD`,
        `JournalLine_GrossAmount_EUR`,
        `JournalLine_GrossAmount_GBP`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `Split`,
        `Changes`,
        `User`,
        `Details`,
        `SourceNumber`,
        `CashOrAccruals`,
        `ContactID`,
        `ContactName`,
        `ContactSource`,
        `PaymentSourceID`,
		`PaymentType`,
		`ShowOnCashBasisReports`,
		`FullyPaidOnDate`,
		`DayDifference`,
        `PlannedPaymentDate`,
        `ItemCode`,
        `Quantity`,
        `DiscountRate`,
        `UnitAmount`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`,
        `DueDate`,
        `Reference`
    )
    SELECT DISTINCT
        tb.`Id`,
        tb.`JournalId`,
        tb.`JournalDate`,
        tb.`JournalNumber`,
        tb.`CreatedDateUTC`,
        tb.`SourceId`,
        tb.`SourceType`,
        tb.`JournalLine_JournalLineId`,
        tb.`JournalLine_Description`,
        tb.`JournalLine_AccountId`,
        tb.`JournalLine_AccountCode`,
        tb.`JournalLine_AccountType`,
        tb.`JournalLine_AccountName`,
        tb.`JournalLine_NetAmount`,
        tb.`JournalLine_GrossAmount`,
        tb.`JournalLine_TaxAmount`,
        tb.`JournalLine_TaxType`,
        tb.`JournalLine_TaxName`,
        tb.`LineItem_TrackingCategory1_CategoryId`,
        tb.`LineItem_TrackingCategory1_CategoryName`,
        tb.`LineItem_TrackingCategory1_OptionId`,
        tb.`LineItem_TrackingCategory1_OptionName`,
        tb.`LineItem_TrackingCategory1_Option_Stat`,
        tb.`LineItem_TrackingCategory2_CategoryId`,
        tb.`LineItem_TrackingCategory2_CategoryName`,
        tb.`LineItem_TrackingCategory2_OptionId`,
        tb.`LineItem_TrackingCategory2_OptionName`,
        tb.`LineItem_TrackingCategory2_Option_Stat`,
        tb.`ClientID`,
        tb.`OrganisationID`,
        tb.`JournalLine_NetAmount_AUD`,
        tb.`JournalLine_NetAmount_USD`,
        tb.`JournalLine_NetAmount_NZD`,
        tb.`JournalLine_NetAmount_EUR`,
        tb.`JournalLine_NetAmount_GBP`,
        tb.`JournalLine_GrossAmount_AUD`,
        tb.`JournalLine_GrossAmount_USD`,
        tb.`JournalLine_GrossAmount_NZD`,
        tb.`JournalLine_GrossAmount_EUR`,
        tb.`JournalLine_GrossAmount_GBP`,
        tb.`JournalLine_TaxAmount_AUD`,
        tb.`JournalLine_TaxAmount_USD`,
        tb.`JournalLine_TaxAmount_NZD`,
        tb.`JournalLine_TaxAmount_EUR`,
        tb.`JournalLine_TaxAmount_GBP`,
        tb.`Split`,
        tb.`Changes`,
        tb.`User`,
        tb.`Details`,
        COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
        'Accruals' AS `CashOrAccruals`,
        t2.`ContactID` AS `ContactID`,
        t2.`ContactName` AS `ContactName`,
        t2.`Source` AS `ContactSource`,
        CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
        CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END `PaymentType`,
        t2.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
        t2.`FullyPaidOnDate` AS `FullyPaidOnDate`,
        t2.`DayDifference` AS `DayDifference`,
        t.`PlannedPaymentDate` AS `PlannedPaymentDate`,
        t.`ItemCode` AS `ItemCode`,
        t.`Quantity` AS `Quantity`,
        t.`DiscountRate` AS `DiscountRate`,
        t.`UnitAmount` AS `UnitAmount`,
        t.`UnitAmount_AUD` AS `UnitAmount_AUD`,
        t.`UnitAmount_USD` AS `UnitAmount_USD`,
        t.`UnitAmount_NZD` AS `UnitAmount_NZD`,
        t.`UnitAmount_EUR` AS `UnitAmount_EUR`,
        t.`UnitAmount_GBP` AS `UnitAmount_GBP`,
        t.`AmountDue` AS `AmountDue`,
        t.`AmountDue_AUD` AS `AmountDue_AUD`,
        t.`AmountDue_USD` AS `AmountDue_USD`,
        t.`AmountDue_NZD` AS `AmountDue_NZD`,
        t.`AmountDue_EUR` AS `AmountDue_EUR`,
        t.`AmountDue_GBP` AS `AmountDue_GBP`,
        t.`URL` AS `URL`,
        t.`DueDate` AS `DueDate`,
        CASE WHEN tb.`Reference` IS NULL THEN t.`Reference` ELSE tb.`Reference` END AS `Reference`
    FROM `c1518_xeroblue_journals` tb
    LEFT JOIN c1518_xeroblue_transactions AS t 
    ON tb.`SourceId` = t.Id 
    AND tb.`OrganisationID` = t.`OrganisationID`
    AND tb.`JournalLine_AccountCode` = t.`AccountCode`
    AND tb.`JournalLine_NetAmount` = t.`LineAmount`
    LEFT JOIN (
        SELECT DISTINCT
            `Id`,
            `ContactID`,
            `ContactName`,
            `Source`,
            `ShowOnCashBasisReports`,
            `FullyPaidOnDate`,
            `DayDifference`,
            `OrganisationID`
        FROM c1518_xeroblue_transactions
        WHERE `OrganisationID` = v_OrganisationID
    ) AS t2
    ON tb.`SourceId` = t2.Id 
    AND tb.`OrganisationID` = t2.`OrganisationID`
    WHERE tb.`OrganisationID` = v_OrganisationID
    AND tb.JournalNumber >= v_MaxJournal
    
    UNION ALL
    SELECT DISTINCT
        tb.`Id`,
        tb.`JournalId`,
        tb.`JournalDate`,
        tb.`JournalNumber`,
        tb.`CreatedDateUTC`,
        tb.`SourceId`,
        tb.`SourceType`,
        tb.`JournalLine_JournalLineId`,
        tb.`JournalLine_Description`,
        tb.`JournalLine_AccountId`,
        tb.`JournalLine_AccountCode`,
        tb.`JournalLine_AccountType`,
        tb.`JournalLine_AccountName`,
        tb.`JournalLine_NetAmount`,
        tb.`JournalLine_GrossAmount`,
        tb.`JournalLine_TaxAmount`,
        tb.`JournalLine_TaxType`,
        tb.`JournalLine_TaxName`,
        tb.`LineItem_TrackingCategory1_CategoryId`,
        tb.`LineItem_TrackingCategory1_CategoryName`,
        tb.`LineItem_TrackingCategory1_OptionId`,
        tb.`LineItem_TrackingCategory1_OptionName`,
        tb.`LineItem_TrackingCategory1_Option_Stat`,
        tb.`LineItem_TrackingCategory2_CategoryId`,
        tb.`LineItem_TrackingCategory2_CategoryName`,
        tb.`LineItem_TrackingCategory2_OptionId`,
        tb.`LineItem_TrackingCategory2_OptionName`,
        tb.`LineItem_TrackingCategory2_Option_Stat`,
        tb.`ClientID`,
        tb.`OrganisationID`,
        tb.`JournalLine_NetAmount_AUD`,
        tb.`JournalLine_NetAmount_USD`,
        tb.`JournalLine_NetAmount_NZD`,
        tb.`JournalLine_NetAmount_EUR`,
        tb.`JournalLine_NetAmount_GBP`,
        tb.`JournalLine_GrossAmount_AUD`,
        tb.`JournalLine_GrossAmount_USD`,
        tb.`JournalLine_GrossAmount_NZD`,
        tb.`JournalLine_GrossAmount_EUR`,
        tb.`JournalLine_GrossAmount_GBP`,
        tb.`JournalLine_TaxAmount_AUD`,
        tb.`JournalLine_TaxAmount_USD`,
        tb.`JournalLine_TaxAmount_NZD`,
        tb.`JournalLine_TaxAmount_EUR`,
        tb.`JournalLine_TaxAmount_GBP`,
        tb.`Split`,
        tb.`Changes`,
        tb.`User`,
        tb.`Details`,
        COALESCE(tb.`InvoiceNumber`,tb.`CreditNoteNumber`) AS `SourceNumber`,
        'Cash' AS `CashOrAccruals`,
        t2.`ContactID` AS `ContactID`,
        t2.`ContactName` AS `ContactName`,
        t2.`Source` AS `ContactSource`,
        CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END AS `PaymentSourceID`,
        CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END `PaymentType`,
        t2.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
        t2.`FullyPaidOnDate` AS `FullyPaidOnDate`,
        t2.`DayDifference` AS `DayDifference`,
        t.`PlannedPaymentDate` AS `PlannedPaymentDate`,
        t.`ItemCode` AS `ItemCode`,
        t.`Quantity` AS `Quantity`,
        t.`DiscountRate` AS `DiscountRate`,
        t.`UnitAmount` AS `UnitAmount`,
        t.`UnitAmount_AUD` AS `UnitAmount_AUD`,
        t.`UnitAmount_USD` AS `UnitAmount_USD`,
        t.`UnitAmount_NZD` AS `UnitAmount_NZD`,
        t.`UnitAmount_EUR` AS `UnitAmount_EUR`,
        t.`UnitAmount_GBP` AS `UnitAmount_GBP`,
        t.`AmountDue` AS `AmountDue`,
        t.`AmountDue_AUD` AS `AmountDue_AUD`,
        t.`AmountDue_USD` AS `AmountDue_USD`,
        t.`AmountDue_NZD` AS `AmountDue_NZD`,
        t.`AmountDue_EUR` AS `AmountDue_EUR`,
        t.`AmountDue_GBP` AS `AmountDue_GBP`,
        t.`URL` AS `URL`,
        t.`DueDate` AS `DueDate`,
        CASE WHEN tb.`Reference` IS NULL THEN t.`Reference` ELSE tb.`Reference` END AS `Reference`
    FROM `c1518_xeroblue_journalscash` tb
    LEFT JOIN c1518_xeroblue_transactions AS t 
    ON tb.`SourceId` = t.Id
    AND tb.`OrganisationID` = t.`OrganisationID`
    AND tb.`JournalLine_AccountCode` = t.`AccountCode`
    AND tb.`JournalLine_NetAmount` = t.`LineAmount`
    LEFT JOIN (
        SELECT DISTINCT
            `Id`,
            `ContactID`,
            `ContactName`,
            `Source`,
            `ShowOnCashBasisReports`,
            `FullyPaidOnDate`,
            `DayDifference`,
            `OrganisationID`
        FROM c1518_xeroblue_transactions
        WHERE `OrganisationID` = v_OrganisationID
    ) AS t2
    ON tb.`SourceId` = t2.Id 
    AND tb.`OrganisationID` = t2.`OrganisationID`
    WHERE tb.`OrganisationID` = v_OrganisationID
    AND tb.JournalNumber >= v_MaxJournal;

    DELETE FROM `c1518_xeroblue_transactionsblend` 
    WHERE `OrganisationId` = v_OrganisationID
    AND JournalNumber >= v_MaxJournal;

	INSERT INTO c1518_xeroblue_transactionsblend
    (
        `Id`,
        `JournalId`,
        `JournalDate`,
        `JournalNumber`,
        `CreatedDateUTC`,
        `SourceId`,
        `SourceType`,
        `JournalLine_JournalLineId`,
        `JournalLine_Description`,
        `JournalLine_AccountId`,
        `JournalLine_AccountCode`,
        `JournalLine_AccountType`,
        `JournalLine_AccountName`,
        `JournalLine_NetAmount`,
        `JournalLine_GrossAmount`,
        `JournalLine_TaxAmount`,
        `JournalLine_TaxType`,
        `JournalLine_TaxName`,
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
        `ClientID`,
        `OrganisationID`,
        `JournalLine_NetAmount_AUD`,
        `JournalLine_NetAmount_USD`,
        `JournalLine_NetAmount_NZD`,
        `JournalLine_NetAmount_EUR`,
        `JournalLine_NetAmount_GBP`,
        `JournalLine_GrossAmount_AUD`,
        `JournalLine_GrossAmount_USD`,
        `JournalLine_GrossAmount_NZD`,
        `JournalLine_GrossAmount_EUR`,
        `JournalLine_GrossAmount_GBP`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `Split`,
        `Changes`,
        `User`,
        `Details`,
        `SourceNumber`,
        `CashOrAccruals`,
        `ContactID`,
        `ContactName`,
        `ContactSource`,
        `PaymentSourceID`,
		`PaymentType`,
		`ShowOnCashBasisReports`,
		`FullyPaidOnDate`,
		`DayDifference`,
        `PlannedPaymentDate`,
        `ItemCode`,
        `Quantity`,
        `DiscountRate`,
        `UnitAmount`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`,
        `DueDate`,
        `Reference` 
    )
	SELECT
        `Id`,
        `JournalId`,
        `JournalDate`,
        `JournalNumber`,
        `CreatedDateUTC`,
        `SourceId`,
        `SourceType`,
        `JournalLine_JournalLineId`,
        `JournalLine_Description`,
        `JournalLine_AccountId`,
        `JournalLine_AccountCode`,
        `JournalLine_AccountType`,
        `JournalLine_AccountName`,
        `JournalLine_NetAmount`,
        `JournalLine_GrossAmount`,
        `JournalLine_TaxAmount`,
        `JournalLine_TaxType`,
        `JournalLine_TaxName`,
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
        `ClientID`,
        `OrganisationID`,
        `JournalLine_NetAmount_AUD`,
        `JournalLine_NetAmount_USD`,
        `JournalLine_NetAmount_NZD`,
        `JournalLine_NetAmount_EUR`,
        `JournalLine_NetAmount_GBP`,
        `JournalLine_GrossAmount_AUD`,
        `JournalLine_GrossAmount_USD`,
        `JournalLine_GrossAmount_NZD`,
        `JournalLine_GrossAmount_EUR`,
        `JournalLine_GrossAmount_GBP`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `Split`,
        `Changes`,
        `User`,
        `Details`,
        `SourceNumber`,
        `CashOrAccruals`,
        `ContactID`,
        `ContactName`,
        `ContactSource`,
        `PaymentSourceID`,
		`PaymentType`,
		`ShowOnCashBasisReports`,
		`FullyPaidOnDate`,
		`DayDifference`,
        `PlannedPaymentDate`,
        `ItemCode`,
        `Quantity`,
        `DiscountRate`,
        `UnitAmount`,
        `UnitAmount_AUD`,
        `UnitAmount_USD`,
        `UnitAmount_NZD`,
        `UnitAmount_EUR`,
        `UnitAmount_GBP`,
        `AmountDue`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `URL`,
        `DueDate`,
        `Reference` 
    FROM (
    SELECT
        *
        ,ROW_NUMBER() OVER(PARTITION BY CashOrAccruals,JournalNumber,id ORDER BY CashOrAccruals,JournalNumber,id) AS RN
    FROM c1518_5393_xeroblue_transactionsblendstage
    ) a WHERE RN = 1;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_trackingcategoryconnections $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_trackingcategoryconnections()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_trackingcategoryconnections
    WHERE OrganisationID = v_OrganisationID;

    INSERT INTO c1518_xeroblue_trackingcategoryconnections
    SELECT * FROM (
        SELECT
            ID
            ,'Category 1' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_invoices
        WHERE Status in ('AUTHORISED', 'PAID') 
        AND OrganisationID = v_OrganisationID
        UNION ALL
        SELECT
            ID
            ,'Category 2' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_invoices
        WHERE Status in ('AUTHORISED', 'PAID') 
        AND OrganisationID = v_OrganisationID
    ) inv WHERE `CategoryID+Option` IS NOT NULL
    UNION ALL
    SELECT * FROM (
        SELECT
            ID
            ,'Category 1' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_journals
        WHERE OrganisationID = v_OrganisationID
        UNION ALL
        SELECT
            ID
            ,'Category 2' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_journals
        WHERE OrganisationID = v_OrganisationID
    ) jrnl WHERE `CategoryID+Option` IS NOT NULL
    UNION ALL
    SELECT * FROM (
        SELECT
            ID
            ,'Category 1' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_creditnotes
        WHERE Status in ('AUTHORISED', 'PAID') 
        AND OrganisationID = v_OrganisationID
        UNION ALL
        SELECT
            ID
            ,'Category 2' AS CategoryNumber
            ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
            ,ClientID
            ,OrganisationID
        FROM c1518_xeroblue_creditnotes
        WHERE Status in ('AUTHORISED', 'PAID') 
        AND OrganisationID = v_OrganisationID
    ) crdt WHERE `CategoryID+Option` IS NOT NULL
    UNION ALL
    SELECT * FROM (
        SELECT
            CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, '-01'), '%Y-%m-%d'), '%b-%Y')) AS ID
            ,'Category 1' AS CategoryNumber
            ,CONCAT(`Tracking.1.TrackingCategoryID`,`Tracking.1.Option`) AS `CategoryID+Option`
            ,a.ClientID
            ,a.OrganisationID
        FROM c1518_xeroblue_budgets a
        INNER JOIN c1518_xeroblue_accounts b 
            ON a.`BudgetLines.AccountID` = b.`AccountID` 
            AND a.`BudgetLines.AccountCode` = b.`Code`
            AND a.`OrganisationID` = b.`OrganisationID`
        WHERE a.OrganisationID = v_OrganisationID
        UNION ALL
        SELECT
            CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, '-01'), '%Y-%m-%d'), '%b-%Y')) AS ID
            ,'Category 2' AS CategoryNumber
            ,CONCAT(`Tracking.2.TrackingCategoryID`,`Tracking.2.Option`) AS `CategoryID+Option`
            ,a.ClientID
            ,a.OrganisationID
        FROM c1518_xeroblue_budgets a
        INNER JOIN c1518_xeroblue_accounts b 
            ON a.`BudgetLines.AccountID` = b.`AccountID` 
            AND a.`BudgetLines.AccountCode` = b.`Code`
            AND a.`OrganisationID` = b.`OrganisationID`
        WHERE a.OrganisationID = v_OrganisationID
    ) bdgt WHERE `CategoryID+Option` IS NOT NULL;
END $$
DELIMITER ;


# New - Feb 4, 2025 - Not Applied yet
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_balancesheet $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_balancesheet()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    SELECT
        @m1 := Label2 ,@m2 := Label3 ,@m3 := Label4 ,@m4 := Label5 ,@m5 := Label6 ,@m6 := Label7
        ,@m7 := Label8 ,@m8 := Label9 ,@m9 := Label10 ,@m10 := Label11 ,@m11 := Label12 ,@m12 := Label13
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID = 0;

    DELETE FROM c1518_xeroblue_balancesheetpivot
    WHERE OrganisationID = v_OrganisationID;

    INSERT INTO c1518_xeroblue_balancesheetpivot
    SELECT
        ID ,Title
        ,Label1 AS `AccountName`
        ,Label2 AS `Amount`
        ,@m1 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label3 AS `Amount`
        ,@m2 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label4 AS `Amount`
        ,@m3 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label5 AS `Amount`
        ,@m4 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label6 AS `Amount`
        ,@m5 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label7 AS `Amount`
        ,@m6 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label8 AS `Amount`
        ,@m7 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label9 AS `Amount`
        ,@m8 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label10 AS `Amount`
        ,@m9 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label11 AS `Amount`
        ,@m10 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label12 AS `Amount`
        ,@m11 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label13 AS `Amount`
        ,@m12 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> '';
END $$
DELIMITER ;