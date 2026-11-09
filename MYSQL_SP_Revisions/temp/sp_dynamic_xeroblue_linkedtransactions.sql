CALL sp_dynamic_xeroblue_default('linkedtransactions', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_linkedtransactions $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_linkedtransactions()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_linkedtransactions
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_linkedtransactions
	select * from c1518_5393_xeroblue_linkedtransactionsstage;
END $$
DELIMITER ;
*/