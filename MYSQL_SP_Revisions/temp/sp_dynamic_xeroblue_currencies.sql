DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_currencies $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_currencies()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE FROM c1518_xeroblue_currencies 
    WHERE `OrganisationId` = v_OrganisationID;

    INSERT INTO c1518_xeroblue_currencies 
    SELECT * FROM c1518_5393_xeroblue_currenciesstage;
END $$
DELIMITER ;