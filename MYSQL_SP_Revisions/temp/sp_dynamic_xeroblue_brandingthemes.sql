DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_brandingthemes $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_brandingthemes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_brandingthemes 
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_brandingthemes
	SELECT * FROM c1518_5393_xeroblue_brandingthemesstage;
END $$
DELIMITER ;