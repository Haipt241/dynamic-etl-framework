USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_reprocess_sp;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_reprocess_sp(
  IN p_endpoint VARCHAR(255)  
 )
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_client_id INT;
    DECLARE v_org_id INT;
    DECLARE v_legacy_id INT;

    DECLARE cur CURSOR FOR
    SELECT s.client as client_id, s.id AS org_id, 
      IFNULL(JSON_UNQUOTE(JSON_EXTRACT(s.Details, '$.Legacy.id')), s.id) AS legacy_id
    FROM etaniv2.client_service s
    JOIN evadb_stage.firms_with_containers fwc ON fwc.firm_id = s.AccountingFirm
    JOIN etaniv2.client c on s.Client = c.id
      WHERE s.status = 1
      AND s.service = 1
      and c.Status <> 2;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_client_id, v_org_id, v_legacy_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET @tablestage = CONCAT('c',v_client_id,'_',v_org_id,'_xeroblue_',p_endpoint,'stage');
        -- Call stored procedure for each row
        IF EXISTS (SELECT 1 FROM information_schema.tables 
                      WHERE table_schema = DATABASE() 
                      AND table_name = @tablestage ) 
        THEN
          SET @sp_sql = CONCAT('
          CALL sp_dynamic_xeroblue_',p_endpoint,'(',v_client_id,',',v_org_id,',',v_legacy_id,');
          ');
          PREPARE stmt FROM @sp_sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
        END IF;

    END LOOP;

    CLOSE cur;
END
$$

DELIMITER ;