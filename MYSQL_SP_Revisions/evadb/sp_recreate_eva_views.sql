
--
-- Set default database
--
USE evadb;

--
-- Drop procedure `sp_recreate_eva_views`
--
DROP PROCEDURE IF EXISTS sp_recreate_eva_views;

--
-- Set default database
--
USE evadb;

DELIMITER $$

--
-- Create procedure `sp_recreate_eva_views`
--
CREATE
DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_recreate_eva_views (
IN `_firm_id` int,
IN `_service_id` int,
IN _view_sql text
)
BEGIN
  -- Declare necessary variables
  DECLARE firm_id int DEFAULT _firm_id;
  DECLARE service_id int DEFAULT _service_id;
  DECLARE view_sql text DEFAULT _view_sql;
  DECLARE clientID int;
  DECLARE clientPrefix varchar(200);
  DECLARE currency varchar(10);
  DECLARE done int DEFAULT 0;
  DECLARE grant_sql TEXT;


  DECLARE firm_cursor CURSOR FOR
   SELECT c.id as clientId, CONCAT(REPLACE(af.code,'-',''),'_client',c.id) AS clientPrefix, c.Currency  
    FROM etaniv2.client_service cs
    JOIN etaniv2.client c ON cs.Client = c.id
    JOIN etaniv2.accounting_firm af ON cs.AccountingFirm = af.id
    JOIN evadb_stage.firms_with_containers fwc ON af.id = fwc.firm_id
   WHERE af.id = firm_id AND cs.Service = service_id 
   AND fwc.integration = 'XB'
        and c.status <> 2
        AND fwc.firm_id = 37
        AND cs.status <> 2
        AND REPLACE(JSON_EXTRACT(cs.Details, '$.dbDestination'),'"','') = 'DW'
   GROUP BY c.id, af.code, c.Currency;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

OPEN firm_cursor;

    IF service_id = 1 THEN 
        SET @integration = 'xeroblue';
    ELSEIF service_id = 7 THEN 
        SET @integration = 'myob';
    ELSEIF service_id = 24 THEN
        SET @integration = 'xpm';
    ELSEIF service_id = 68 THEN
        SET @integration = 'wfmcustom';
    ELSEIF service_id = 69 THEN
        SET @integration = 'wfm';
    ELSE 
        SET @integration = 'wfmcustom';
    END IF;

firm_loop: LOOP
    FETCH firm_cursor INTO clientID, clientPrefix, currency;
    IF done THEN
       LEAVE firm_loop;
    END IF;

   SET @view_type = '';
   SET @integration = '';

    IF LOCATE('ACCRUALS', view_sql) > 0 THEN 
        SET @view_type = 'accrualtransactions';
    ELSEIF LOCATE('CASH', view_sql) > 0 THEN 
        SET @view_type = 'cashtransactions';
    ELSE 
        SET @view_type = 'budgets_eva';
    END IF;

    

   SET @view_name = CONCAT(clientPrefix,'_',@integration,'_',@view_type,'_',currency);

    SET @drop_sql = CONCAT('DROP VIEW IF EXISTS ',@view_name,';');
    PREPARE drop_stmt FROM @drop_sql;
    EXECUTE drop_stmt;
    DEALLOCATE PREPARE drop_stmt;

    
    SET @view_sql = REPLACE(REPLACE(REPLACE(view_sql,'ClientPrefix', clientPrefix),'ClientCurrency', currency),'ClientID', clientID);
    PREPARE view_stmt FROM @view_sql;
    EXECUTE view_stmt;
    DEALLOCATE PREPARE view_stmt;        

    SELECT GROUP_CONCAT(CONCAT('GRANT ', PRIVILEGE_TYPE, ' ON ', @view_name, ' TO ', GRANTEE) SEPARATOR '; ')
        INTO grant_sql
        FROM information_schema.table_privileges
        WHERE TABLE_SCHEMA = 'evadb'
        AND TABLE_NAME LIKE CONCAT(clientPrefix,'%')
        GROUP BY GRANTEE, PRIVILEGE_TYPE;

    IF grant_sql IS NOT NULL THEN
        SET @grant_sql = grant_sql;
        PREPARE grant_stmt FROM @grant_sql;
        EXECUTE grant_stmt;
        DEALLOCATE PREPARE grant_stmt;
    END IF;

END LOOP;

CLOSE firm_cursor;
       

END$$

DELIMITER ;