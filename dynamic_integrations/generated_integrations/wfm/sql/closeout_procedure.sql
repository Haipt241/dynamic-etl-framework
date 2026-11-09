-- =============================================
-- CloseOut Procedure for WFM Integration
-- Generated: Auto-generated
-- =============================================

USE vibedb_cms;

DELIMITER $$

DROP PROCEDURE IF EXISTS `Dynamic-ETL-WFM-Integration-CloseOut`$$

CREATE PROCEDURE `Dynamic-ETL-WFM-Integration-CloseOut`(
    IN p_ClientID VARCHAR(50),
    IN p_OrganisationID INT,
    IN p_EtaniClientID VARCHAR(100),
    IN p_TriggerType VARCHAR(20),
    IN p_JobRunID INT
)
BEGIN
    DECLARE v_ErrorMessage VARCHAR(4000);
    DECLARE v_IntegrationName VARCHAR(50) DEFAULT 'WFM';

    DECLARE exit handler for sqlexception
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_ErrorMessage = MESSAGE_TEXT;

        -- Log error (table may not exist yet, so wrap in BEGIN...END)
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                SET v_ErrorMessage = CONCAT('Error logging failed: ', v_ErrorMessage);

            INSERT INTO integration_closeout_errors (
                integration_name,
                organisation_id,
                error_message,
                created_at
            ) VALUES (
                v_IntegrationName,
                p_OrganisationID,
                v_ErrorMessage,
                UTC_TIMESTAMP()
            );
        END;

        ROLLBACK;
    END;

    START TRANSACTION;

    -- =============================================
    -- CLOSEOUT TASKS FOR WFM
    -- =============================================

    -- 1. Archive completed task records older than 30 days
    DELETE FROM task
    WHERE clientService = p_OrganisationID
      AND type = 'refresh'
      AND status = 'completed'
      AND createdAt < DATE_SUB(UTC_TIMESTAMP(), INTERVAL 30 DAY)
    LIMIT 100;

    -- 2. Update integration statistics in client_service
    UPDATE client_service
    SET
        LastRefreshDate = UTC_TIMESTAMP()
    WHERE Id = p_OrganisationID;

    -- 3. Clean up old temporary data (if applicable)
    -- Integration-specific cleanup can be added here

    -- 4. Update reconciliation summary table (if exists)
    -- Integration-specific reconciliation cleanup can be added here

    COMMIT;

    -- Log successful closeout
    SELECT CONCAT('[OK] CloseOut completed for ', v_IntegrationName, ' - OrgID: ', p_OrganisationID) AS CloseOutResult;

END$$

DELIMITER ;

-- =============================================
-- Grant Permissions
-- =============================================
-- GRANT EXECUTE ON PROCEDURE vibedb_cms.`Dynamic-ETL-WFM-Integration-CloseOut` TO 'etl_user'@'%';

-- =============================================
-- Usage Example:
-- =============================================
-- CALL `Dynamic-ETL-WFM-Integration-CloseOut`(
--     '6956',                              -- ClientID
--     1755241633,                          -- OrganisationID
--     'BIGOLESHOECOMPANY_CLIENT6956',      -- EtaniClientID
--     'MANUAL',                            -- TriggerType
--     0                                    -- JobRunID
-- );
