DELIMITER $$
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_accounts $$
CREATE PROCEDURE sp_c1518_5393_xeroblusp_dynamic_xeroblue_accountse_accounts(
    IN p_clientID VARCHAR(100),
    IN p_orgID INT,
    IN p_legacyOrgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c',v_clientID,'_xeroblue_accounts');
    DECLARE column_list TEXT DEFAULT '';
    DECLARE column_list2 text DEFAULT '';
    DECLARE done INT DEFAULT 0;
    DECLARE col_name VARCHAR(255);
    DECLARE col_type VARCHAR(255);

    -- Declare cursor to retrieve column names and types dynamically
    DECLARE cur CURSOR FOR
        SELECT COLUMN_NAME, DATA_TYPE 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = v_table_name AND TABLE_SCHEMA = DATABASE();


	SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

    SET @accountsStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_accountsstage');

    set @update_accounts_sql = CONCAT('
    UPDATE ',@accountsStage,'
    SET
        `AccountType` = CASE 
            WHEN `Type` = ''BANK'' THEN ''Bank''
            WHEN `Type` = ''CURRENT'' THEN ''Current Assets''
            WHEN `Type` = ''CURRLIAB'' THEN ''Current Liabilities''
            WHEN `Type` = ''DEPRECIATN'' THEN ''Depreciation''
            WHEN `Type` = ''DIRECTCOSTS'' THEN ''Direct Costs''
            WHEN `Type` = ''EQUITY'' THEN ''Equity''
            WHEN `Type` = ''EXPENSE'' THEN ''Expenses''
            WHEN `Type` = ''LIABILITY'' THEN ''Non-Current Liabilities''
            WHEN `Type` = ''NONCURRENT'' THEN ''Non-Current Assets''
            WHEN `Type` = ''OTHERINCOME'' THEN ''Other Income''
            WHEN `Type` = ''REVENUE'' THEN ''Revenue''
            WHEN `Type` = ''SALES'' THEN ''Sales''
            WHEN `Type` = ''TERMLIAB'' THEN ''Non-Current Liabilities''    
            WHEN `Type` = ''FIXED'' THEN ''Fixed Assets''
            WHEN `Type` = ''INVENTORY'' THEN ''Inventory Assets''
            WHEN `Type` = ''OVERHEADS'' THEN ''Expenses''
            WHEN `Type` = ''PREPAYMENT'' THEN ''Prepayment''
            WHEN `Type` = ''PAYGLIABILITY'' THEN ''PAYG Liability''
            WHEN `Type` = ''SUPERANNUATIONEXPENSE'' THEN ''Expenses''
            WHEN `Type` = ''SUPERANNUATIONLIABILITY'' THEN ''Superannuation Liability''
            WHEN `Type` = ''WAGESEXPENSE'' THEN ''Expenses''
            ELSE ''Unknown'' END,
        `BalanceSheetReportingType` = CASE 
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Retained Earnings''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Retained Earnings''
            WHEN `ReportingCode` LIKE ''%LIA.CUR%'' THEN ''Current Liabilities''
            WHEN `ReportingCode` LIKE ''%ASS.NCA.FIX%'' THEN ''Fixed Assets''
            WHEN `ReportingCode` LIKE ''%ASS.NCA%'' THEN ''Non-Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS.CUR.CAS.BAN%'' THEN ''Bank''
            WHEN `ReportingCode` LIKE ''%ASS.CUR%'' THEN ''Current Assets''
            WHEN `ReportingCode` LIKE ''%LIA.NCL%'' THEN ''Non-Current Liabilities''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%LIA%'' AND (Type = ''LIABILITY'' OR Type = ''TERMLIAB'') THEN ''Non-Current Liabilities''
            WHEN `ReportingCode` LIKE ''%LIA%'' AND Type = ''CURRLIAB'' THEN ''Current Liabilities''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''CURRENT'' THEN ''Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''BANK'' THEN ''Bank''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''NONCURRENT'' THEN ''Non-Current Assets''
            WHEN `ReportingCode` LIKE ''%ASS%'' AND Type = ''FIXED'' THEN ''Fixed Assets''
            ELSE ''UNKNOWN'' END,
        `P&LReportingTypeInterim` = CASE 
            WHEN `ReportingCode` LIKE ''%ASS%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%LIA%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%REV.OTH%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%REV.TRA%'' THEN ''Trading Income''
            WHEN `ReportingCode` LIKE ''%REV.INV%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%EXP.INC%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Balance Sheet Item''
            WHEN `ReportingCode` LIKE ''%EXP.COS%'' THEN ''Cost of Sales''
            WHEN `ReportingCode` LIKE ''%EXP.DIV%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.FOR%'' THEN ''Non-Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.DEP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.REN%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.EMP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.INT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.FBT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.ENT%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.BAD%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.NON%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%REV.GRA%'' THEN ''Other Income''
            WHEN `ReportingCode` LIKE ''%EXP.VEH%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP.AMO%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Operating Expenses''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Other Income''
            ELSE `ReportingCode` END;
        ');            

    PREPARE stmt FROM @update_accounts_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @update_accounts_sql2 = CONCAT('
        UPDATE ',@accountsStage,'
        SET
        `AccountTypeOrder` = CASE 
            WHEN `AccountType` = ''Revenue'' THEN ''1''
            WHEN `AccountType` = ''Sales'' THEN ''2''
            WHEN `AccountType` = ''Direct Costs'' THEN ''3''
            WHEN `AccountType` = ''Other Income'' THEN ''4''
            WHEN `AccountType` = ''Depreciation'' THEN ''5''
            WHEN `AccountType` = ''Expenses'' THEN ''6''
            WHEN `AccountType` = ''Bank'' THEN ''7''
            WHEN `AccountType` = ''Current Assets'' THEN ''8''
            WHEN `AccountType` = ''Non-Current Assets'' THEN ''9''
            WHEN `AccountType` = ''Current Liabilities'' THEN ''10''
            WHEN `AccountType` = ''Non-Current Liabilities'' THEN ''11''
            WHEN `AccountType` = ''Equity'' THEN ''12''
            ELSE ''13'' END,
        `P&LGroup` = CASE 
            WHEN `AccountType` = ''Direct Costs'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Revenue'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Sales'' THEN ''Direct Grouping''
            WHEN `AccountType` = ''Other Income'' THEN ''Other Income''
            WHEN `AccountType` = ''Expenses'' THEN ''Expense''
            WHEN `AccountType` = ''Depreciation'' THEN ''Expense''
            ELSE ''Unknown'' END,
        `BalanceSheetType` = CASE 
            WHEN `AccountType` = ''Direct Costs'' THEN ''Equity''
            WHEN `AccountType` = ''Revenue'' THEN ''Equity''
            WHEN `AccountType` = ''Sales'' THEN ''Equity''
            WHEN `AccountType` = ''Other Income'' THEN ''Equity''
            WHEN `AccountType` = ''Expenses'' THEN ''Equity''
            WHEN `AccountType` = ''Depreciation'' THEN ''Equity''
            ELSE `AccountType` END,
        `StatementofCashflow` = CASE 
            WHEN `AccountType` = ''Revenue'' THEN ''Receipts from customers''
            WHEN `AccountType` = ''Sales'' THEN ''Receipts from customers''
            WHEN `AccountType` = ''Direct Costs'' THEN ''Payments to suppliers and employees''
            WHEN `AccountType` = ''Other Income'' THEN ''Cash receipts from other operating activities''
            WHEN `AccountType` = ''Fixed Assets'' THEN ''Payment for property, plant and equipment''
            WHEN `AccountType` = ''Expenses'' THEN ''Payments to suppliers and employees''
            WHEN `AccountType` = ''Prepayments'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Current Assets'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Non-Current Assets'' THEN ''Other cash items from investing activities''
            WHEN `AccountType` = ''Current Liabilities'' THEN ''Other cash items from financing activities''
            ELSE ''Working on It'' END,
        `BalanceSheetReportingGroup` = CASE 
            WHEN `ReportingCode` LIKE ''%ASS%'' THEN ''Assets''
            WHEN `ReportingCode` LIKE ''%EXP%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%LIA%'' THEN ''Liabilities''
            WHEN `ReportingCode` LIKE ''%REV%'' THEN ''Equity''
            WHEN `ReportingCode` LIKE ''%EQU%'' THEN ''Equity''
            ELSE ''UNKNOWN'' END,
        `P&LReportingType` = CASE
            WHEN LOCATE(''.'', `P&LReportingTypeInterim`) > 0 THEN 
                SUBSTRING_INDEX(`P&LReportingTypeInterim`, ''.'', 1)
            ELSE 
                `P&LReportingTypeInterim`
            END;
        ');
    PREPARE stmt2 FROM @update_accounts_sql2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SET @update_accounts_sql3 = CONCAT('
    UPDATE c1518_5393_xeroblue_accountsstage
    SET
        `BalanceSheetGroup` = CASE 
            WHEN `BalanceSheetType` = ''Equity'' THEN ''Equity''
            WHEN `BalanceSheetType` = ''Retained Earnings'' THEN ''Equity''
            WHEN `BalanceSheetType` = ''Current Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Fixed Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Prepayment'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Bank'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Non-Current Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Inventory Assets'' THEN ''Assets''
            WHEN `BalanceSheetType` = ''Current Liabilities'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''Term Liability'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''PAYG Liability'' THEN ''Liabilities''
            WHEN `BalanceSheetType` = ''Non-Current Liabilities'' THEN ''Liabilities''
            ELSE ''UNKNOWN'' END,
        `CashflowActivities` = CASE 
            WHEN `StatementofCashflow` = ''Receipts from customers'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Payments to suppliers and employees'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Cash receipts from other operating activities'' THEN ''Operating Activities''
            WHEN `StatementofCashflow` = ''Payment for property, plant and equipment'' THEN ''Investing Activities''
            WHEN `StatementofCashflow` = ''Other cash items from investing activities'' THEN ''Investing Activities''
            WHEN `StatementofCashflow` = ''Other cash items from financing activities'' THEN ''Financing Activities' '
            ELSE ''Working on It'' END,
        `P&LReportingGroup` = CASE 
            WHEN `P&LReportingType` = ''Trading Income'' THEN ''Direct''
            WHEN `P&LReportingType` = ''Cost of Sales'' THEN ''Direct''
            WHEN `P&LReportingType` = ''Other Income'' THEN ''Other Income''
            WHEN `P&LReportingType` = ''Operating Expenses'' THEN ''Expenses''
            WHEN `P&LReportingType` = ''Non-Operating Expenses'' THEN ''Expenses''
            ELSE ''Balance Sheet Item'' END;
        ');
    PREPARE stmt3 FROM @update_accounts_sql3;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;

    SET @update_accounts_sql4 = CONCAT('
        UPDATE c1518_5393_xeroblue_accountsstage
        SET
            `Class` = CONCAT(UPPER(LEFT(`Class`, 1)), LOWER(SUBSTRING(`Class`, 2))),
            `ClassOrder` = CASE 
                WHEN `Class` = ''REVENUE'' THEN ''1''
                WHEN `Class` = ''EXPENSE'' THEN ''2''
                WHEN `Class` = ''ASSET'' THEN ''3''
                WHEN `Class` = ''LIABILITY'' THEN ''4''
                WHEN `Class` = ''EQUITY'' THEN ''5''
                ELSE ''6'' END,
            `P&LGroupOrder` = CASE 
                WHEN `P&LGroup` = ''Direct Grouping'' THEN ''1''
                WHEN `P&LGroup` = ''Other Income'' THEN ''2''
                WHEN `P&LGroup` = ''Expense'' THEN ''3''
                ELSE ''4'' END,
            `BalanceSheetAccountName` = CASE 
                WHEN `P&LGroup` <> ''Unknown'' THEN ''Retained Earnings''
                ELSE Name END,
            `BalanceSheetReportingTypeOrder` = CASE 
                WHEN `BalanceSheetReportingType` = ''Bank'' THEN ''1''
                WHEN `BalanceSheetReportingType` = ''Current Assets'' THEN ''2''
                WHEN `BalanceSheetReportingType` = ''Non-Current Assets'' THEN ''3''
                WHEN `BalanceSheetReportingType` = ''Fixed Assets'' THEN ''4''
                WHEN `BalanceSheetReportingType` = ''Current Liabilities'' THEN ''5''
                WHEN `BalanceSheetReportingType` = ''Non-Current Liabilities'' THEN ''6''
                WHEN `BalanceSheetReportingType` = ''PAYG Liability'' THEN ''7''
                WHEN `BalanceSheetReportingType` = ''Superannuation Liability'' THEN ''8''
                WHEN `BalanceSheetReportingType` = ''Retained Earnings'' THEN ''9''
                WHEN `BalanceSheetReportingType` = ''Equity'' THEN ''10''
                WHEN `BalanceSheetReportingType` = ''Revenue'' THEN ''11''
                WHEN `BalanceSheetReportingType` = ''Sales'' THEN ''12''
                WHEN `BalanceSheetReportingType` = ''Direct Costs'' THEN ''13''
                WHEN `BalanceSheetReportingType` = ''Expenses'' THEN ''14''
                WHEN `BalanceSheetReportingType` = ''Depreciation'' THEN ''15''
                WHEN `BalanceSheetReportingType` = ''Other Income'' THEN ''16''
                WHEN `BalanceSheetReportingType` = ''Overheads'' THEN ''17''
                WHEN `BalanceSheetReportingType` = ''Prepayment'' THEN ''18''
                WHEN `BalanceSheetReportingType` = ''Superannuation Expense'' THEN ''19''
                WHEN `BalanceSheetReportingType` = ''Wages Expense'' THEN ''20''
                ELSE ''Unknown'' END,
            `BalanceSheetReportingGroupOrder` = CASE 
                WHEN `BalanceSheetReportingGroup` = ''Assets'' THEN ''1''
                WHEN `BalanceSheetReportingGroup` = ''Liabilities'' THEN ''2''
                WHEN `BalanceSheetReportingGroup` = ''Equity'' THEN ''3''
                ELSE ''Unknown'' END,
            `P&LReportingGroupOrder` = CASE 
                WHEN `P&LReportingGroup` = ''Direct'' THEN ''1''
                WHEN `P&LReportingGroup` = ''Other Income'' THEN ''2''
                WHEN `P&LReportingGroup` = ''Expenses'' THEN ''3''
                ELSE ''4'' END,
            `P&LReportingTypeOrder` = CASE 
                WHEN `P&LReportingType` = ''Trading Income'' THEN ''1''
                WHEN `P&LReportingType` = ''Cost of Sales'' THEN ''2''
                WHEN `P&LReportingType` = ''Other Income'' THEN ''3''
                WHEN `P&LReportingType` = ''Operating Expenses'' THEN ''4''
                WHEN `P&LReportingType` = ''Non-Operating Expenses'' THEN ''5''
                ELSE ''6'' END,
            `BalanceSheetGroupOrder` = CASE 
                WHEN `BalanceSheetGroup` = ''Assets'' THEN ''1''
                WHEN `BalanceSheetGroup` = ''Liabilities'' THEN ''2''
                WHEN `BalanceSheetGroup` = ''Equity'' THEN ''3''
                ELSE ''4'' END,
            `CashflowActivitiesOrder` = CASE 
                WHEN `CashflowActivities` = ''Operating Activities'' THEN ''1''
                WHEN `CashflowActivities` = ''Investing Activities'' THEN ''2''
                WHEN `CashflowActivities` = ''Financing Activities'' THEN ''3''
                ELSE ''4'' END,
            `StatementofCashflowOrder` = CASE 
                WHEN `StatementofCashflow` = ''Receipts from customers'' THEN ''1''
                WHEN `StatementofCashflow` = ''Payments to suppliers and employees'' THEN ''2''
                WHEN `StatementofCashflow` = ''Cash receipts from other operating activities'' THEN ''3''
                WHEN `StatementofCashflow` = ''Payment for property, plant and equipment'' THEN ''4''
                WHEN `StatementofCashflow` = ''Other cash items from investing activities'' THEN ''5''
                WHEN `StatementofCashflow` = ''Other cash items from financing activities'' THEN ''6''
                ELSE ''7'' END,
            `CashIn/CashOut` = CASE 
                WHEN `Class` = ''Asset'' THEN ''Cash In''
                WHEN `Class` = ''Liability'' THEN ''Cash Out''
                WHEN `Class` = ''Revenue'' THEN ''Cash In''
                WHEN `Class` = ''Expense'' THEN ''Cash Out''
                ELSE ''UNKNOWN'' END,
            `Account_UID` = CONCAT(IFNULL(`Code`, ''BLANK''), '-', `OrganisationID`),
            `AccountName_UID` = CONCAT(IFNULL(`Name`, ''BLANK''), `OrganisationID`);
        ');
    PREPARE stmt4 FROM @update_accounts_sql4;
    EXECUTE stmt4;
    DEALLOCATE PREPARE stmt4;

    SET @delete_trans = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_accounts 
    	    WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
      	
    PREPARE stmt5 FROM @delete_trans;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;

     -- Process columns dynamically
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO col_name, col_type;
        IF done THEN 
            LEAVE read_loop;
        END IF;
      
        SET column_list = CONCAT(column_list, '`', col_name, '`, ');
        -- Handle date/datetime columns: convert '' to NULL
        IF col_type IN ('date', 'datetime', 'timestamp') THEN
            SET column_list2 = CONCAT(column_list2, 
                'NULLIF(`', col_name, '`, '''') AS `', col_name, '`, ');
        ELSE
            SET column_list2 = CONCAT(column_list2, '`', col_name, '`, ');
        END IF;
    END LOOP;
    CLOSE cur;

    -- Remove trailing comma from column_list
    SET column_list = LEFT(column_list, CHAR_LENGTH(column_list) - 2);
    SET column_list2 = LEFT(column_list2, CHAR_LENGTH(column_list2) - 2);

    -- Dynamic INSERT with transformed date values
    SET @sql_query = CONCAT(
        'INSERT INTO ',v_table_name,'(',column_list,') 
        SELECT ', column_list2, ' FROM ', @defaultStage,'
        ;');

    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
/*
    SET @insert_trans = CONCAT('
        INSERT INTO c1518_xeroblue_accounts
        SELECT * FROM c1518_5393_xeroblue_accountsstage;
    ');
    PREPARE stmt6 FROM @insert_trans;
	EXECUTE stmt6;
	DEALLOCATE PREPARE stmt6;
*/    
END$$
DELIMITER ;