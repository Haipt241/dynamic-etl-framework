USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_items;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_items(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c',v_clientID,'_xeroblue_items');
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

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
	
    SET @defaultStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_itemsstage');

	

    SET @update_items = CONCAT('        
        UPDATE `',@defaultStage,'`
        SET
            `CodeUID` = CONCAT(`Code`, CAST(`OrganisationID` AS CHAR)),
            `InventoryCodeUID` = CONCAT(`InventoryAssetAccountCode`, CAST(`OrganisationID` AS CHAR));
        ');
    PREPARE stmt FROM @update_items;
	  EXECUTE stmt;
	  DEALLOCATE PREPARE stmt;

	SET @delete_default = CONCAT('
		DELETE FROM ',v_table_name,' 
		 WHERE `OrganisationId` = ',v_OrganisationID,';
		');	

	PREPARE stmt2 FROM @delete_default;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;


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
                'NULLIF(`', col_name, '`, NULL) AS `', col_name, '`, ');
        ELSE
            SET column_list2 = CONCAT(column_list2, '`', col_name, '`, ');
        END IF;
    END LOOP;
    CLOSE cur;

    -- Remove trailing comma from column_list
    SET column_list = LEFT(column_list, CHAR_LENGTH(column_list) - 2);
    SET column_list2 = LEFT(column_list2, CHAR_LENGTH(column_list2) - 2);

    -- Dynamic INSERT with transformed date values
    SET @insert_sql = CONCAT(
        'INSERT INTO ',v_table_name,'(',column_list,') 
        SELECT ', column_list2, ' FROM ', @defaultStage,'
        ;');

  PREPARE stmt FROM @insert_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;


END
$$

DELIMITER ;