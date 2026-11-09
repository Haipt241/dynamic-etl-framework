CALL sp_dynamic_xeroblue_default('trackingcategories', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_trackingcategories  $$
CREATE PROCEDURE sp_dynamic_xeroblue_trackingcategories (
    IN p_clientID VARCHAR(100),
    IN p_orgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    SET @trackingcategoriesStage = CONCAT('c', v_clientID, '_', v_OrganisationID, '_xeroblue_trackingcategoriesstage');

	SET @delete_trackingcategories = CONCAT('
		DELETE FROM c',v_clientID,'_xeroblue_trackingcategories 
		 WHERE `OrganisationId` = ',v_OrganisationID,';
		');
	
--	SELECT @delete_trackingcategories;	
	PREPARE stmt FROM @delete_trackingcategories;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET @insert_trackingcategories = CONCAT('
		INSERT INTO c',v_clientID,'_xeroblue_trackingcategories 
		 SELECT * from ',@trackingcategoriesStage,';
	');
--	SELECT @insert_trackingcategories;
	PREPARE stmt2 FROM @insert_trackingcategories;
	EXECUTE stmt2;
	DEALLOCATE PREPARE stmt2;


END $$
DELIMITER ;
*/