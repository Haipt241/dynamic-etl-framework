USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_lastrefreshdate;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_lastrefreshdate(
            IN p_CID INT,
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

            SELECT COALESCE(MAX(ID), 0) + 1 INTO v_NewID FROM `c1834_xeroblue_lastrefreshdate`;

            SET @lastRefreshDateTable = CONCAT('c',p_CID,'_xeroblue_lastrefreshdate');
    
            SET @newid_sql = CONCAT('SELECT COALESCE(MAX(ID), 0) + 1 INTO @v_NewID FROM `',@lastRefreshDateTable,'`;');
            PREPARE new_stmt FROM @newid_sql;
            EXECUTE new_stmt;
            DEALLOCATE PREPARE new_stmt;
            SET v_NewID = @v_NewID;
            
            SET @insert_sql = CONCAT(
              'INSERT INTO `', COALESCE(@lastRefreshDateTable, ''), '` (',
              '`Id`, `TableName`, `RefreshRowCount`, `TotalRowCount`, `StartDate`, `EndDate`, ',
              '`LastRefreshUTCDate`, `LoadType`, `RefreshStatus`, `JobRunId`, `DatabaseDestination`, ',
              '`ClientID`, `OrganisationID`, `TriggerType`, `RefreshDetails` ) VALUES (',
              COALESCE(v_NewID, 0), ', ',
              '''', COALESCE(p_TableName, ''), ''', ',
              COALESCE(p_RefreshRowCount, 0), ', ',
              COALESCE(p_TotalRowCount, 0), ', ',
              IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_StartDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
              IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_EndDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
              IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_LastRefreshUTCDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
              '''', COALESCE(p_LoadType, ''), ''', ',
              '''', COALESCE(p_RefreshStatus, ''), ''', ',
              COALESCE(p_JobRunId, 'NULL'), ', ',
              '''', COALESCE(p_DatabaseDestination, ''), ''', ',
              '''', COALESCE(p_ClientID, ''), ''', ',
              COALESCE(p_OrganisationID, 'NULL'), ', ',
              '''', COALESCE(p_TriggerType, ''), ''', ',
              '''', COALESCE(p_RefreshDetails, ''), '''',
              ') ON DUPLICATE KEY UPDATE ',
              '`RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`), ',
              '`TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`), ',
              '`StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`), ',
              '`EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`), ',
              '`LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`), ',
              '`LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`), ',
              '`RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`), ',
              '`JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`), ',
              '`DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`), ',
              '`TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`), ',
              '`RefreshDetails` = VALUES(`RefreshDetails`)'
          );


         PREPARE ins_stmt FROM @insert_sql;
         EXECUTE ins_stmt;
         DEALLOCATE PREPARE ins_stmt;
END
$$

DELIMITER ;