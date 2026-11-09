--new objects for reporting API - Not yet applied - 02-26-2025

CREATE TABLE IF NOT EXISTS c1518_5393_xeroblue_balancesheetstage (
	`ID` INT NULL,
    `Title` VARCHAR(255) NULL,
    `Label1` VARCHAR(255) NULL,
    `Label2` VARCHAR(100) NULL,
    `Label3` VARCHAR(100) NULL,
    `Label4` VARCHAR(100) NULL,
    `Label5` VARCHAR(100) NULL,
    `Label6` VARCHAR(100) NULL,
    `Label7` VARCHAR(100) NULL,
    `Label8` VARCHAR(100) NULL,
    `Label9` VARCHAR(100) NULL,
    `Label10` VARCHAR(100) NULL,
    `Label11` VARCHAR(100) NULL,
    `Label12` VARCHAR(100) NULL,
    `Label13` VARCHAR(100) NULL,
    `AccountId` VARCHAR(100) NULL,
    `ClientID` VARCHAR(255) NULL,
    `OrganisationID` INT NULL
);

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_balancesheet $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_balancesheet()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    SELECT
        @m1 := Label2 ,@m2 := Label3 ,@m3 := Label4 ,@m4 := Label5 ,@m5 := Label6 ,@m6 := Label7
        ,@m7 := Label8 ,@m8 := Label9 ,@m9 := Label10 ,@m10 := Label11 ,@m11 := Label12 ,@m12 := Label13
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID = 0;

    DELETE FROM c1518_xeroblue_balancesheetpivot
    WHERE OrganisationID = v_OrganisationID;

    INSERT INTO c1518_xeroblue_balancesheetpivot
    SELECT
        ID ,Title
        ,Label1 AS `AccountName`
        ,Label2 AS `Amount`
        ,@m1 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label3 AS `Amount`
        ,@m2 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label4 AS `Amount`
        ,@m3 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label5 AS `Amount`
        ,@m4 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label6 AS `Amount`
        ,@m5 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label7 AS `Amount`
        ,@m6 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label8 AS `Amount`
        ,@m7 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label9 AS `Amount`
        ,@m8 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label10 AS `Amount`
        ,@m9 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label11 AS `Amount`
        ,@m10 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label12 AS `Amount`
        ,@m11 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> ''
    UNION ALL
    SELECT
        ID
        ,Title
        ,Label1 AS `AccountName`
        ,Label13 AS `Amount`
        ,@m12 AS `Month`
        ,AccountId
        ,ClientID
        ,OrganisationID
    FROM c1518_5393_xeroblue_balancesheetstage
    WHERE ID <> 0 AND Label1 <> '';
END $$
DELIMITER ;