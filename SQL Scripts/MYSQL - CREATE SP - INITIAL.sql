/******************************************************************
APPLIED CHANGES:
DATE            CHANGES
2025-03-07      Latest version

*******************************************************************/

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_python_package_log $$
CREATE PROCEDURE sp_python_package_log(
    IN job_id BIGINT,
    IN jobrun_id BIGINT,
    IN datasource VARCHAR(255),
    IN taskname VARCHAR(255),
    IN status_message VARCHAR(255)
)
BEGIN
    INSERT INTO python_package_log (`JobId`, `JobRunId`, `DataSource`, `TaskName`, `StatusMessage`, `LogTimestamp`)
    VALUES (job_id, jobrun_id, datasource, taskname, status_message, UTC_TIMESTAMP());
END $$
DELIMITER ;