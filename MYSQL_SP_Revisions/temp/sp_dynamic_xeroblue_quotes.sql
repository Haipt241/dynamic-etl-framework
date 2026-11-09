CALL sp_dynamic_xeroblue_default('quotes', '1834', 6248);
/*
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_quotes $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_quotes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

	DELETE `TRG`
    FROM `c1518_xeroblue_quotes` `TRG`
    INNER JOIN `c1518_5393_xeroblue_quotesstage` `STG` 
        ON `TRG`.`QuoteId` = `STG`.`QuoteId`
    WHERE `TRG`.`OrganisationId` = v_OrganisationID;

	INSERT INTO c1518_xeroblue_quotes
	select * from c1518_5393_xeroblue_quotesstage;
END $$
DELIMITER ;
*/