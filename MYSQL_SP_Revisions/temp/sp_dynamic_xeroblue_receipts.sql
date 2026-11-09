CALL sp_dynamic_xeroblue_default('receipts', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_receipts $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_receipts()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE FROM c1518_xeroblue_receipts
	WHERE `OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_receipts
	select * from c1518_5393_xeroblue_receiptsstage;
END $$
DELIMITER ;
*/