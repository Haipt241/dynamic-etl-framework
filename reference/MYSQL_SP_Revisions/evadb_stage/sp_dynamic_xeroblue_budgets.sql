USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_budgets;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_budgets(IN p_clientID INT, IN p_orgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;   
    
    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
    -- Replace hardcoded table references with dynamic ones
    SET @budgetsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_budgetsstage');

    SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());
    
    -- FXTable creation and population
    SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ',@fx_table,' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );'
		 );
	PREPARE fx_stmt FROM @create_fxtable;
	EXECUTE fx_stmt;
   	DEALLOCATE PREPARE fx_stmt;
    
    
	 SET @insert_fxtable = CONCAT('
        INSERT INTO ',@fx_table,' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
        SELECT 
            `BaseCurrency`,
            `Date`,
            AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
            AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
            AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
            AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
            AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
        FROM FOREIGNEXCHANGE_MASTER
        WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
        GROUP BY `BaseCurrency`, `Date`;
    ');
    PREPARE ins_fx_stmt FROM @insert_fxtable;
    EXECUTE ins_fx_stmt;
    DEALLOCATE PREPARE ins_fx_stmt;

    SET @update_sql = CONCAT('
        UPDATE `',@budgetsStage,'` bdgt
        INNER JOIN c',v_clientID,'_xeroblue_accounts acct 
            ON bdgt.`BudgetLines.AccountID` = acct.`AccountID`
            AND bdgt.`BudgetLines.AccountCode` = acct.`Code`
            AND bdgt.`OrganisationID` = acct.`OrganisationID`
        SET bdgt.`BudgetLines.BudgetBalances.Amount` = CASE 
                WHEN acct.`Class` = ''Revenue'' THEN bdgt.`BudgetLines.BudgetBalances.Amount`
                WHEN acct.`Class` = ''Expense'' THEN (0 - bdgt.`BudgetLines.BudgetBalances.Amount`)
            END
        WHERE acct.`Class` IN (''Revenue'', ''Expense'');
        ');   
    PREPARE upd_stmt FROM @update_sql;
    EXECUTE upd_stmt;
    DEALLOCATE PREPARE upd_stmt;


    SET @update_sql = CONCAT('
        UPDATE `',@budgetsStage,'` AS `bdgt`
        LEFT JOIN `c',v_clientID,'_xeroblue_organisationsclients` AS `org` 
            ON `org`.`OrganisationID` = `bdgt`.`OrganisationID`
        LEFT JOIN ',@fx_table,' AS `fx` ON fx.`BaseCurrency` = `org`.`BaseCurrency`
                AND `fx`.`Date` = CASE 
                    WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) <= ''',v_minDate,''' THEN ''',v_minDate, ''' 
                    WHEN LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
                    ELSE LAST_DAY(CONCAT(IFNULL(`bdgt`.`BudgetLines.BudgetBalances.Period`, ''1900-01''), ''-01'')) 
                END
        SET 
            `bdgt`.`BudgetLines.BudgetBalances.Amount_AUD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`AUD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_USD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`USD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_NZD` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`NZD`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_EUR` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`EUR`,
            `bdgt`.`BudgetLines.BudgetBalances.Amount_GBP` = `bdgt`.`BudgetLines.BudgetBalances.Amount` * `fx`.`GBP`
        ;');
    PREPARE upd_stmt FROM @update_sql;
    EXECUTE upd_stmt;
    DEALLOCATE PREPARE upd_stmt;

    SET @delete_sql = CONCAT('
        DELETE FROM c',v_clientID,'_xeroblue_budgets 
        WHERE `OrganisationId` = ',v_OrganisationID,';
        ');
    PREPARE del_stmt FROM @delete_sql;
    EXECUTE del_stmt;
    DEALLOCATE PREPARE del_stmt;

    SET @insert_sql = CONCAT('
        INSERT INTO `c',v_clientID,'_xeroblue_budgets` 
        SELECT DISTINCT * FROM `',@budgetsStage,'`;
        ');
    PREPARE ins_stmt FROM @insert_sql;
    EXECUTE ins_stmt;
    DEALLOCATE PREPARE ins_stmt;
END
$$

DELIMITER ;