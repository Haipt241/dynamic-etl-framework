CALL sp_dynamic_xeroblue_default('users', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_accounts $$
CREATE PROCEDURE sp_dynamic_xeroblue_accounts(
    IN p_clientID VARCHAR(100),
    IN p_orgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    SET @usersStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_usersstage');

	SET @delete_users = CONCAT('
		DELETE FROM c',v_clientID,'_xeroblue_users
		 WHERE `OrganisationId` = ',v_OrganisationID,';
		');
	
--	SELECT @delete_users;	
	PREPARE stmt FROM @delete_users;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @insert_users = CONCAT('
		INSERT INTO c',v_clientID,'_xeroblue_users
		 SELECT * from ',@usersstage,';
	');
--	SELECT @insert_users;
	PREPARE stmt2 FROM @insert_users;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;


END $$
DELIMITER ;
*/