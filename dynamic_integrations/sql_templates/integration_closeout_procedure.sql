-- =============================================
-- Integration CloseOut Stored Procedure Template
-- =============================================
-- This procedure is called at the end of each integration run to perform cleanup tasks
-- Name format: Dynamic-ETL-{INTEGRATION_NAME}-Integration-CloseOut
--
-- Parameters:
--   @ClientID: Client ID number (e.g., 6956)
--   @OrganisationID: Organisation ID (e.g., 1755241633)
--   @EtaniClientID: Full client ID string (e.g., 'REDACTED')
--   @TriggerType: Trigger type ('MANUAL' or 'SCHEDULED')
--   @JobRunID: Job run ID for tracking
-- =============================================

USE vibedb_cms;

DELIMITER $$

DROP PROCEDURE IF EXISTS `Dynamic-ETL-{INTEGRATION_NAME}-Integration-CloseOut`$$

CREATE PROCEDURE `Dynamic-ETL-{INTEGRATION_NAME}-Integration-CloseOut`(
    IN p_ClientID VARCHAR(50),
    IN p_OrganisationID INT,
    IN p_EtaniClientID VARCHAR(100),
    IN p_TriggerType VARCHAR(20),
    IN p_JobRunID INT
)
BEGIN
    DECLARE v_ErrorMessage VARCHAR(4000);
    DECLARE exit handler for sqlexception
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_ErrorMessage = MESSAGE_TEXT;

        -- Log error to container_logs or error tracking table
        INSERT INTO integration_errors (
            integration_name,
            organisation_id,
            error_message,
            created_at
        ) VALUES (
            '{INTEGRATION_NAME}',
            p_OrganisationID,
            v_ErrorMessage,
            UTC_TIMESTAMP()
        );

        ROLLBACK;
    END;

    START TRANSACTION;

    -- =============================================
    -- CLOSEOUT TASKS
    -- =============================================

    -- 1. Archive completed task records older than 30 days
    DELETE FROM task
    WHERE clientService = p_OrganisationID
      AND type = 'refresh'
      AND status = 'completed'
      AND createdAt < DATE_SUB(UTC_TIMESTAMP(), INTERVAL 30 DAY);

    -- 2. Update integration statistics
    UPDATE client_service
    SET
        LastRefreshDate = UTC_TIMESTAMP(),
        RefreshCount = IFNULL(RefreshCount, 0) + 1
    WHERE Id = p_OrganisationID;

    -- 3. Clean up old error logs (keep last 100 per org)
    DELETE FROM integration_errors
    WHERE organisation_id = p_OrganisationID
      AND integration_name = '{INTEGRATION_NAME}'
      AND created_at NOT IN (
          SELECT created_at FROM (
              SELECT created_at
              FROM integration_errors
              WHERE organisation_id = p_OrganisationID
                AND integration_name = '{INTEGRATION_NAME}'
              ORDER BY created_at DESC
              LIMIT 100
          ) AS recent_errors
      );

    -- 4. Update reconciliation summary
    -- (Add your integration-specific reconciliation logic here)

    -- 5. Trigger any post-processing alerts or notifications
    -- (Add your integration-specific notification logic here)

    COMMIT;

    -- Log successful closeout
    SELECT CONCAT('CloseOut completed for ', p_EtaniClientID, ' (OrgID: ', p_OrganisationID, ')') AS Result;

END$$

DELIMITER ;

-- =============================================
-- Usage Example:
-- =============================================
-- CALL `Dynamic-ETL-PAYROLL_AU-Integration-CloseOut`(
--     '6956',                              -- ClientID
--     1755241633,                          -- OrganisationID
--     'REDACTED',      -- EtaniClientID
--     'MANUAL',                            -- TriggerType
--     0                                    -- JobRunID
-- );
