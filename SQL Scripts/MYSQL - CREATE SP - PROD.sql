/******************************************************************
APPLIED CHANGES:
DATE            CHANGES
2025-03-07      Latest version

*******************************************************************/

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_xeroblue_lastrefreshdate $$
CREATE PROCEDURE sp_c1518_xeroblue_lastrefreshdate (
    IN p_TableName VARCHAR(255),
    IN p_RefreshRowCount INT,
    IN p_TotalRowCount INT,
    IN p_StartDate DATETIME,
    IN p_EndDate DATETIME,
    IN p_LastRefreshUTCDate DATETIME,
    IN p_LoadType VARCHAR(255),
    IN p_RefreshStatus VARCHAR(255),
    IN p_JobRunId BIGINT,
    IN p_DatabaseDestination VARCHAR(255),
    IN p_ClientID VARCHAR(255),
    IN p_OrganisationID INT,
    IN p_TriggerType VARCHAR(255),
    IN p_RefreshDetails VARCHAR(255)
)
BEGIN
    DECLARE v_NewID INT;

    SELECT COALESCE(MAX(ID), 0) + 1 INTO v_NewID FROM `c1518_xeroblue_lastrefreshdate`;

    INSERT INTO `c1518_xeroblue_lastrefreshdate` (
        `Id`,
        `TableName`, 
        `RefreshRowCount`, 
        `TotalRowCount`, 
        `StartDate`, 
        `EndDate`, 
        `LastRefreshUTCDate`, 
        `LoadType`, 
        `RefreshStatus`, 
        `JobRunId`,
        `DatabaseDestination`,
        `ClientID`, 
        `OrganisationID`,
        `TriggerType`,
        `RefreshDetails`
    ) VALUES (
        v_NewID,
        p_TableName, 
        p_RefreshRowCount, 
        p_TotalRowCount, 
        p_StartDate, 
        p_EndDate, 
        p_LastRefreshUTCDate, 
        p_LoadType, 
        p_RefreshStatus, 
        p_JobRunId, 
        p_DatabaseDestination, 
        p_ClientID, 
        p_OrganisationID,
        p_TriggerType,
        p_RefreshDetails
    )
    ON DUPLICATE KEY UPDATE
        `RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`),
        `TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`),
        `StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`),
        `EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`),
        `LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`),
        `LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`),
        `RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`),
        `JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`),
        `DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`),
        `TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`),
        `RefreshDetails` = VALUES(`RefreshDetails`);
END $$
DELIMITER ;