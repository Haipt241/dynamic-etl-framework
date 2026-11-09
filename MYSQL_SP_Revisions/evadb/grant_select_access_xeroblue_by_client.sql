DELIMITER $$

DROP PROCEDURE IF EXISTS Grant_Select_Access_XeroBlue_By_Client$$

CREATE PROCEDURE Grant_Select_Access_XeroBlue_By_Client(
    IN client_id VARCHAR(100), 
    IN _username VARCHAR(100),
    IN _password VARCHAR(100)
)
BEGIN
    -- Declare necessary variables
    DECLARE username VARCHAR(255);
    DECLARE tablename VARCHAR(255);
    DECLARE done INT DEFAULT 0;

    -- Cursor for iterating over table names with table name filtering by account code
    DECLARE table_cursor CURSOR FOR 
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'evadb'
          (table_name LIKE CONCAT('%client', client_id, '%') 
            OR TABLE_NAME LIKE 'FOREIGNEXCHANGE_MASTER')
          AND table_type IN ('BASE TABLE', 'VIEW');

    -- Declare NOT FOUND handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- If no account code is found, return an error message
    IF accountcode IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No account code found for the provided firm_id.';
    END IF;

    -- Construct the username based on the account code and ensure the user exists (calls the CreateUserIfNotExists procedure)
    IF _username IS NULL THEN
        SET username = CONCAT(accountcode, '_admin@etani.au');
        CALL CreateUserIfNotExists(username, CONCAT(accountcode, '55a4eb44'));
    ELSE 
        SET username = _username;
        CALL CreateUserIfNotExists(username, _password);
    END IF;

    -- Open the cursor
    OPEN table_cursor;

    -- Iterate over each table
    table_loop: LOOP
        FETCH table_cursor INTO tablename;
        IF done THEN
            LEAVE table_loop;
        END IF;

        -- Construct and execute GRANT statement dynamically for each table
        SET @grant_sql = CONCAT('GRANT SELECT ON `evadb`.`', tablename, '` TO ''', username, '''@''%'';');
        
        -- Debug: Display generated SQL for each table
        SELECT @grant_sql;
        
        -- Prepare and execute the dynamic SQL
        PREPARE stmt FROM @grant_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    -- Close the cursor
    CLOSE table_cursor;

    -- Optional: Provide feedback
    SELECT 'GRANT statements executed successfully.' AS message;
END$$

DELIMITER ;
