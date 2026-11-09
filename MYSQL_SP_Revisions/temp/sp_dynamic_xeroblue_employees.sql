DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_employees $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_employees()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_employees
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_employees
	select * from c1518_5393_xeroblue_employeesstage;
END $$
DELIMITER ;
