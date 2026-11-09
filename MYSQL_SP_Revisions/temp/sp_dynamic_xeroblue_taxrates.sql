CALL sp_dynamic_xeroblue_default('taxrates', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_taxrates  $$
CREATE PROCEDURE sp_dynamic_xeroblue_taxrates (
    IN p_clientID VARCHAR(100),
    IN p_orgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    SET @taxratesStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_taxratesstage');

	SET @delete_taxrates = CONCAT('
		DELETE FROM c',v_clientID,'_xeroblue_taxrates 
		 WHERE `OrganisationId` = ',v_OrganisationID,';
		');
	
--	SELECT @delete_taxrates;	
	PREPARE stmt FROM @delete_taxrates;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @insert_taxrates = CONCAT('
		INSERT INTO c',v_clientID,'_xeroblue_taxrates 
		 SELECT * from ',@taxratesStage,';
	');
--	SELECT @insert_taxrates;
	PREPARE stmt2 FROM @insert_taxrates;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;


END $$
DELIMITER ;
*/