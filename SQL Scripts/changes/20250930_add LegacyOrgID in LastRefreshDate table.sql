USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_update_xeroblue_legacy_organisation_id;

DELIMITER $$

CREATE 
    DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_update_xeroblue_legacy_organisation_id(
        IN p_client_id VARCHAR(255)
    )
BEGIN
    DECLARE v_table_name VARCHAR(255);
    DECLARE v_rows_updated INT DEFAULT 0;
    DECLARE column_exists INT DEFAULT 0;
    
    -- Build the dynamic table name
    SET v_table_name = CONCAT('c', p_client_id, '_xeroblue_lastrefreshdate');
    
    -- Check if LegacyOrganisationID column exists
    SELECT COUNT(*) INTO column_exists
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = v_table_name 
    AND COLUMN_NAME = 'LegacyOrganisationID';
    
    -- Add column if it doesn't exist
    IF column_exists = 0 THEN
        SET @add_column_sql = CONCAT('ALTER TABLE `', v_table_name, '` ADD COLUMN `LegacyOrganisationID` INT NULL');
        PREPARE add_column_stmt FROM @add_column_sql;
        EXECUTE add_column_stmt;
        DEALLOCATE PREPARE add_column_stmt;
        
        SELECT CONCAT('Added LegacyOrganisationID column to table ', v_table_name) AS result;
    END IF;
    
    -- Update LegacyOrganisationID based on the provided logic
    SET @update_sql = CONCAT('
        UPDATE `', v_table_name, '` xl
        JOIN etaniv2.client_service cs ON xl.OrganisationID = cs.id
        SET xl.LegacyOrganisationID = IFNULL(JSON_EXTRACT(cs.Details, ''$.Legacy.id''), cs.id)
        WHERE xl.LegacyOrganisationID IS NULL OR xl.LegacyOrganisationID != IFNULL(JSON_EXTRACT(cs.Details, ''$.Legacy.id''), cs.id)
    ');
    
    PREPARE update_stmt FROM @update_sql;
    EXECUTE update_stmt;
    
    -- Get the number of rows affected
    SET v_rows_updated = ROW_COUNT();
    
    DEALLOCATE PREPARE update_stmt;
    
    -- Return the result
    SELECT CONCAT('Updated ', v_rows_updated, ' rows in table ', v_table_name) AS result;
    
END$$

DELIMITER ;


CALL sp_update_xeroblue_legacy_organisation_id('1066');




set sql_generate_invisible_primary_key = off;

CREATE TABLE IF NOT EXISTS c1518_xeroblue_lastrefreshdate (
    `Id` INT, -- Unique ID for each table
    `TableName` VARCHAR(255) NULL, -- Production table name
    `RefreshRowCount` INT NULL, -- number of rows refreshed/inserted in Stage table
    `TotalRowCount` INT NULL, -- total number of rows in production table
    `StartDate` DATETIME NULL, -- Timestamp when table started to refresh
    `EndDate` DATETIME NULL, -- Timestamp when table stopped to refresh whether completed or failed
    `LastRefreshUTCDate` DATETIME NULL, -- UTC Date when table successfully refreshed
    `LoadType` VARCHAR(255) NULL, -- Full or Latest
    `RefreshStatus` VARCHAR(255) NULL, -- InProgress/Completed/Failed
    `RefreshDetails` TEXT NULL, -- Will populate with error details if Failed
    `JobRunId` BIGINT NULL, -- Unique ID for each table
    `DatabaseDestination` VARCHAR(255) NULL, -- Database Destination
    `TriggerType` VARCHAR(255) NULL, -- Manual or Scheduled
    `ClientID` VARCHAR(255) NULL, -- Client ID
    `OrganisationID` INT NULL, -- Organisation ID / Client Service ID
    `LegacyOrganisationID` INT NULL, -- Legacy Organisation ID
    PRIMARY KEY (`Id`),
    UNIQUE KEY `unique_table_client_org` (`TableName`, `ClientID`, `OrganisationID`)
);


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_lastrefreshdate;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_lastrefreshdate AS
SELECT 
    `Id` AS `Id`,
    `TableName` AS `Table Name`,
    `TotalRowCount` AS `Result Row Count`,
    `LastRefreshUTCDate` AS `Last Refresh UTC Date`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `LegacyOrganisationID` AS `Legacy Organisation ID`
FROM evadb_stage.c1518_xeroblue_lastrefreshdate;