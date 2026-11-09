USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_contacts;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_contacts(
    IN p_clientID VARCHAR(100),
    IN p_orgID INT,
    IN p_legacyOrgID INT    
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
	
    -- Replace hardcoded table references with dynamic ones
    SET @contactsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_contactsstage');

    SET @update_stage = CONCAT('
        UPDATE `',@contactsStage,'`
        SET
            `FullAddress` = CONCAT(`Street_AddressLine1`, '' '', `Street_City`, '' '', `Street_Region`, '' '', `Street_Country`, '' '', `Street_PostalCode`),
            `RegionAddress` = CONCAT(`Street_City`, '' '', `Street_Region`, '' '', `Street_Country`)
        WHERE `OrganisationId` = ',v_OrganisationID,';
    ');
    PREPARE stmt FROM @update_stage;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @delete_table = CONCAT('
        DELETE `trgt`
        FROM `c',v_clientID,'_xeroblue_contacts` `trgt`
        INNER JOIN `',@contactsStage,'` `stg`
            ON `trgt`.`OrganisationId` = `stg`.`OrganisationId` 
            AND `trgt`.`ContactId` = `stg`.`ContactId`
        WHERE `trgt`.`OrganisationId` = ',v_OrganisationID,';
    ');
    PREPARE stmt2 FROM @delete_table;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SET @insert_tofinal = CONCAT('
        INSERT INTO `c',v_clientID,'_xeroblue_contacts`
        SELECT * 
        FROM `',@contactsStage,'`
        WHERE `OrganisationId` = ',v_OrganisationID,';
    ');
    PREPARE stmt3 FROM @insert_tofinal;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;

END
$$

DELIMITER ;