DELIMITER $$

DROP PROCEDURE IF EXISTS sp_insert_historic_last_refresh_date$$

CREATE PROCEDURE sp_insert_historic_last_refresh_date(
    IN p_task INT UNSIGNED,
    IN p_clientService INT UNSIGNED,
    IN p_business INT UNSIGNED,
    IN p_client INT UNSIGNED,
    IN p_service INT UNSIGNED,
    IN p_clientID VARCHAR(255),
    IN p_organisationID INT,
    OUT p_inserted_id INT UNSIGNED
)
BEGIN
    DECLARE v_json_result TEXT;
    DECLARE v_record_count INT DEFAULT 0;
    DECLARE v_table_name VARCHAR(255);
    DECLARE v_service_code VARCHAR(255);
    DECLARE v_sql_query TEXT;
    DECLARE v_count_query TEXT;
    DECLARE v_existing_id INT UNSIGNED;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start transaction
    START TRANSACTION;

    SET v_service_code = 
        CASE 
            WHEN p_service = 1 THEN 'xeroblue' 
            WHEN p_service = 4 THEN 'qbo' 
            WHEN p_service = 7 THEN 'myob' 
            WHEN p_service = 16 THEN 'simpro'
            WHEN p_service = 24 THEN 'xpm' 
            WHEN p_service = 27 THEN 'cin7'
            WHEN p_service = 38 THEN 'shopify'   
            WHEN p_service = 50 THEN 'karbon_hq' 
            WHEN p_service = 69 THEN 'wfm'
            WHEN p_service = 72 THEN 'fyi' 
        END;

    -- Build dynamic table name based on client ID
    -- Pattern: c{client_id}_xeroblue_lastrefreshdate
    SET v_table_name = CONCAT('c', CAST(p_client AS CHAR), '_', v_service_code,'_lastrefreshdate');

    -- Initialize user variables
    SET @json_result = NULL;
    SET @record_count = NULL;

    -- Build dynamic SQL query to get JSON array
    SET v_sql_query = CONCAT(
        'SELECT JSON_ARRAYAGG(',
            'JSON_OBJECT(',
                '''Id'', Id, ',
                '''TableName'', TableName, ',
                '''RefreshRowCount'', RefreshRowCount, ',
                '''TotalRowCount'', TotalRowCount, ',
                '''StartDate'', IFNULL(DATE_FORMAT(StartDate, ''%Y-%m-%dT%H:%i:%s.000Z''), NULL), ',
                '''EndDate'', IFNULL(DATE_FORMAT(EndDate, ''%Y-%m-%dT%H:%i:%s.000Z''), NULL), ',
                '''LastRefreshUTCDate'', IFNULL(DATE_FORMAT(LastRefreshUTCDate, ''%Y-%m-%dT%H:%i:%s.000Z''), NULL), ',
                '''LoadType'', LoadType, ',
                '''RefreshStatus'', RefreshStatus, ',
                '''RefreshDetails'', IFNULL(RefreshDetails, ''''), ',
                '''JobRunId'', JobRunId, ',
                '''DatabaseDestination'', DatabaseDestination, ',
                '''TriggerType'', TriggerType, ',
                '''ClientID'', ClientID, ',
                '''OrganisationID'', OrganisationID',
            ')',
        ') INTO @json_result ',
        'FROM evadb_stage.`', v_table_name, '` ',
        'WHERE ClientID = ? AND OrganisationID = ? ',
        'ORDER BY Id'
    );

    -- Prepare and execute the JSON query
    SET @sql_stmt = v_sql_query;
    PREPARE stmt FROM @sql_stmt;
    SET @client_id = p_clientID;
    SET @org_id = p_organisationID;
    EXECUTE stmt USING @client_id, @org_id;
    DEALLOCATE PREPARE stmt;

    -- Get the JSON result
    SET v_json_result = @json_result;

    -- Build dynamic SQL query to get count
    SET v_count_query = CONCAT(
        'SELECT COUNT(*) INTO @record_count ',
        'FROM evadb_stage.`', v_table_name, '` ',
        'WHERE ClientID = ? AND OrganisationID = ?'
    );

    -- Prepare and execute the count query
    SET @sql_stmt = v_count_query;
    PREPARE stmt FROM @sql_stmt;
    SET @client_id = p_clientID;
    SET @org_id = p_organisationID;
    EXECUTE stmt USING @client_id, @org_id;
    DEALLOCATE PREPARE stmt;

    -- Get the count result
    SET v_record_count = IFNULL(@record_count, 0);

    -- If no records found, set JSON to empty array
    IF v_json_result IS NULL THEN
        SET v_json_result = JSON_ARRAY();
    END IF;

    -- Upsert into historic_last_refresh_date table (update if exists by task + client + clientService)
    SET v_existing_id = NULL;
    SELECT id INTO v_existing_id
    FROM etaniv2.historic_last_refresh_date
    WHERE task = p_task
      AND client = p_client
      AND clientService = p_clientService
    LIMIT 1;

    IF v_existing_id IS NOT NULL THEN
        UPDATE etaniv2.historic_last_refresh_date
        SET lastRefreshDateRecord = v_json_result,
            updatedAt = NOW()
        WHERE id = v_existing_id;
        SET p_inserted_id = v_existing_id;
    ELSE
        INSERT INTO etaniv2.historic_last_refresh_date (
            task,
            clientService,
            business,
            client,
            service,
            lastRefreshDateRecord
        ) VALUES (
            p_task,
            p_clientService,
            p_business,
            p_client,
            p_service,
            v_json_result
        );
        SET p_inserted_id = LAST_INSERT_ID();
    END IF;

    WITH dup as (
        SELECT ID
            ,task
            ,clientService
            ,business
            ,client
            ,service
            ,lastRefreshDateRecord
            ,LAG(lastRefreshDateRecord) OVER (PARTITION BY task ORDER BY id desc) AS toplastRefreshDateRecord
            ,ROW_NUMBER() OVER(PARTITION BY task ORDER BY id desc) rn
        FROM etaniv2.historic_last_refresh_date
        WHERE clientService IN (p_clientService)
        ORDER BY id DESC
    )
    DELETE trgt
    FROM etaniv2.historic_last_refresh_date trgt
    INNER JOIN dup ON dup.id = trgt.id
    WHERE rn > 1 
    AND dup.lastRefreshDateRecord LIKE '%Pending%';

    -- Commit transaction
    COMMIT;

    -- Return the inserted ID
    SELECT p_inserted_id AS inserted_id, v_record_count AS records_included;

END$$

DELIMITER ;

