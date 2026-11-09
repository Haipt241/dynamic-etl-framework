CALL sp_dynamic_xeroblue_default('purchaseorders', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_purchaseorders $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_purchaseorders()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE TRG
	FROM c1518_xeroblue_purchaseorders TRG
    INNER JOIN c1518_5393_xeroblue_purchaseordersstage STG 
	ON TRG.`PurchaseOrderId` = STG.`PurchaseOrderId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_purchaseorders`
    SELECT * FROM `c1518_5393_xeroblue_purchaseordersstage`;
END $$
DELIMITER ;
*/