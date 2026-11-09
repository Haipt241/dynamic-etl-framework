DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_contactgroups $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_contactgroups()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_contactgroups
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_contactgroups
	select * from c1518_5393_xeroblue_contactgroupsstage;
END $$
DELIMITER ;