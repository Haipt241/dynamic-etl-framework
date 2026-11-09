CALL sp_dynamic_xeroblue_default('repeatinginvoices', '1834', 6248);

/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_repeatinginvoices  $$
CREATE PROCEDURE sp_dynamic_xeroblue_repeatinginvoices (
    IN p_clientID VARCHAR(100),
    IN p_orgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    SET @repeatinginvoicesStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_repeatinginvoicesstage');

	SET @delete_repeatinginvoices = CONCAT('
		DELETE FROM c',v_clientID,'_xeroblue_repeatinginvoices 
		 WHERE `OrganisationId` = ',v_OrganisationID,';
		');
	
--	SELECT @delete_repeatinginvoices;	
	PREPARE stmt FROM @delete_repeatinginvoices;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @insert_repeatinginvoices = CONCAT('
		INSERT INTO c',v_clientID,'_xeroblue_repeatinginvoices 
		 SELECT * from ',@repeatinginvoicesStage,';
	');
--	SELECT @insert_repeatinginvoices;
	PREPARE stmt2 FROM @insert_repeatinginvoices;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;


END $$
DELIMITER ;
*/