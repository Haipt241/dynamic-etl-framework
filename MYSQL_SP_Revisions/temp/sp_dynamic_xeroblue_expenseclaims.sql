DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_expenseclaims $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_expenseclaims()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_expenseclaims
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_expenseclaims
	select * from c1518_5393_xeroblue_expenseclaimsstage;
END $$
DELIMITER ;