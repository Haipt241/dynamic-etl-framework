USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_trackingcategoryconnections;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_trackingcategoryconnections(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT
)
BEGIN
            DECLARE v_OrganisationID INT DEFAULT p_orgID;
            DECLARE v_clientID INT DEFAULT p_clientID;

            SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
	
            SET @defaultTable = CONCAT('c',v_clientID,'_xeroblue_trackingcategoryconnections');

            SET @delete_sql = CONCAT('
                DELETE FROM c',v_clientID,'_xeroblue_trackingcategoryconnections
                WHERE OrganisationID = ',v_OrganisationID,';
            ');
            PREPARE del_stmt FROM @delete_sql;
            EXECUTE del_stmt;
            DEALLOCATE PREPARE del_stmt;

            SET @insert_sql = CONCAT('
                INSERT INTO c', v_clientID, '_xeroblue_trackingcategoryconnections
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_invoices
                    WHERE Status in (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ',v_OrganisationID,'
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_invoices
                    WHERE Status in (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ',v_OrganisationID,'
                ) inv WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_journals
                    WHERE OrganisationID = ',v_OrganisationID,'
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_journals
                    WHERE OrganisationID = ',v_OrganisationID,'
                ) jrnl WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory1_CategoryId,LineItem_TrackingCategory1_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_creditnotes
                    WHERE Status IN (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ',v_OrganisationID,'
                    UNION ALL
                    SELECT
                        ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(LineItem_TrackingCategory2_CategoryId,LineItem_TrackingCategory2_OptionName) AS `CategoryID+Option`
                        ,ClientID
                        ,OrganisationID
                    FROM c', v_clientID, '_xeroblue_creditnotes
                    WHERE Status IN (''AUTHORISED'', ''PAID'') 
                    AND OrganisationID = ',v_OrganisationID,'
                ) crdt WHERE `CategoryID+Option` IS NOT NULL
                UNION ALL
                SELECT * FROM (
                    SELECT
                        CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, ''-01''), ''%Y-%m-%d''), ''%b-%Y'')) AS ID
                        ,''Category 1'' AS CategoryNumber
                        ,CONCAT(`Tracking.1.TrackingCategoryID`,`Tracking.1.Option`) AS `CategoryID+Option`
                        ,a.ClientID
                        ,a.OrganisationID
                    FROM c', v_clientID, '_xeroblue_budgets a
                    INNER JOIN c', v_clientID, '_xeroblue_accounts b 
                        ON a.`BudgetLines.AccountID` = b.`AccountID` 
                        AND a.`BudgetLines.AccountCode` = b.`Code`
                        AND a.`OrganisationID` = b.`OrganisationID`
                    WHERE a.OrganisationID = ',v_OrganisationID,'
                    UNION ALL
                    SELECT
                        CONCAT(BudgetID, `BudgetLines.AccountID`, DATE_FORMAT(STR_TO_DATE(CONCAT(`BudgetLines.BudgetBalances.Period`, ''-01''), ''%Y-%m-%d''), ''%b-%Y'')) AS ID
                        ,''Category 2'' AS CategoryNumber
                        ,CONCAT(`Tracking.2.TrackingCategoryID`,`Tracking.2.Option`) AS `CategoryID+Option`
                        ,a.ClientID
                        ,a.OrganisationID
                    FROM c', v_clientID, '_xeroblue_budgets a
                    INNER JOIN c', v_clientID, '_xeroblue_accounts b 
                        ON a.`BudgetLines.AccountID` = b.`AccountID` 
                        AND a.`BudgetLines.AccountCode` = b.`Code`
                        AND a.`OrganisationID` = b.`OrganisationID`
                    WHERE a.OrganisationID = ',v_OrganisationID,'
                ) bdgt WHERE `CategoryID+Option` IS NOT NULL;
            ');

            PREPARE ins_stmt FROM @insert_sql;
            EXECUTE ins_stmt;
            DEALLOCATE PREPARE ins_stmt;
            

            
        END
$$

DELIMITER ;