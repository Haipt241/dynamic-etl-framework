USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_cleanup_client_data;

DELIMITER $$

CREATE 
    DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_cleanup_client_data(
        IN p_client_id VARCHAR(255),
        IN p_organisation_id INT DEFAULT NULL
    )
BEGIN
    DECLARE v_client_status INT DEFAULT 0;
    DECLARE v_org_status INT DEFAULT 0;
    DECLARE v_client_exists INT DEFAULT 0;
    DECLARE v_org_exists INT DEFAULT 0;
    DECLARE v_table_name VARCHAR(255);
    DECLARE v_stage_table_name VARCHAR(255);
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_tables_dropped INT DEFAULT 0;
    DECLARE v_records_deleted INT DEFAULT 0;
    DECLARE v_error_count INT DEFAULT 0;
    
    -- Cursor for iterating through tables
    DECLARE table_cursor CURSOR FOR 
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = 'evadb' 
        AND TABLE_NAME LIKE CONCAT('c', p_client_id, '_xeroblue_%');
    
    DECLARE stage_table_cursor CURSOR FOR 
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_SCHEMA = 'evadb_stage' 
        AND TABLE_NAME LIKE CONCAT('c', p_client_id, '_%_xeroblue_%stage');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET v_error_count = v_error_count + 1;
        GET DIAGNOSTICS CONDITION 1
            @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        SELECT CONCAT('Error: ', @errno, ' - ', @text) AS error_message;
    END;
    
    -- Check if client exists in etaniv2.client
    SELECT COUNT(*) INTO v_client_exists
    FROM etaniv2.client 
    WHERE id = p_client_id;
    
    IF v_client_exists = 0 THEN
        SELECT CONCAT('Client ID ', p_client_id, ' does not exist in etaniv2.client') AS result;
        LEAVE sp_cleanup_client_data;
    END IF;
    
    -- Get client status
    SELECT status INTO v_client_status
    FROM etaniv2.client 
    WHERE id = p_client_id;
    
    -- If client status is 2, drop all MySQL objects for this client
    IF v_client_status = 2 THEN
        SELECT CONCAT('Client ', p_client_id, ' has status 2 - Dropping all MySQL objects') AS action;
        
        -- Drop all client tables in evadb
        OPEN table_cursor;
        read_loop: LOOP
            FETCH table_cursor INTO v_table_name;
            IF v_done THEN
                LEAVE read_loop;
            END IF;
            
            SET @drop_sql = CONCAT('DROP TABLE IF EXISTS evadb.', v_table_name);
            PREPARE drop_stmt FROM @drop_sql;
            EXECUTE drop_stmt;
            DEALLOCATE PREPARE drop_stmt;
            
            SET v_tables_dropped = v_tables_dropped + 1;
            SELECT CONCAT('Dropped table: evadb.', v_table_name) AS dropped_table;
        END LOOP;
        CLOSE table_cursor;
        
        -- Drop all stage tables in evadb_stage
        SET v_done = FALSE;
        OPEN stage_table_cursor;
        stage_read_loop: LOOP
            FETCH stage_table_cursor INTO v_stage_table_name;
            IF v_done THEN
                LEAVE stage_read_loop;
            END IF;
            
            SET @drop_stage_sql = CONCAT('DROP TABLE IF EXISTS evadb_stage.', v_stage_table_name);
            PREPARE drop_stage_stmt FROM @drop_stage_sql;
            EXECUTE drop_stage_stmt;
            DEALLOCATE PREPARE drop_stage_stmt;
            
            SET v_tables_dropped = v_tables_dropped + 1;
            SELECT CONCAT('Dropped stage table: evadb_stage.', v_stage_table_name) AS dropped_table;
        END LOOP;
        CLOSE stage_table_cursor;
        
        -- Drop views if they exist
        SET @drop_views_sql = CONCAT('
            SELECT CONCAT("DROP VIEW IF EXISTS ", TABLE_SCHEMA, ".", TABLE_NAME, ";") AS drop_statement
            FROM INFORMATION_SCHEMA.VIEWS 
            WHERE TABLE_NAME LIKE "', p_client_id, '%"
            AND TABLE_SCHEMA IN ("evadb", "evadb_stage")
        ');
        
        -- Drop stored procedures if they exist
        SET @drop_procedures_sql = CONCAT('
            SELECT CONCAT("DROP PROCEDURE IF EXISTS ", ROUTINE_SCHEMA, ".", ROUTINE_NAME, ";") AS drop_statement
            FROM INFORMATION_SCHEMA.ROUTINES 
            WHERE ROUTINE_NAME LIKE "%', p_client_id, '%"
            AND ROUTINE_SCHEMA IN ("evadb", "evadb_stage")
            AND ROUTINE_TYPE = "PROCEDURE"
        ');
        
        SELECT CONCAT('Completed cleanup for client ', p_client_id, '. Dropped ', v_tables_dropped, ' tables.') AS result;
        
    ELSE
        -- Client status is not 2, check organisation status if provided
        IF p_organisation_id IS NOT NULL THEN
            -- Check if organisation exists in etaniv2.client_service
            SELECT COUNT(*) INTO v_org_exists
            FROM etaniv2.client_service 
            WHERE id = p_organisation_id AND client_id = p_client_id;
            
            IF v_org_exists = 0 THEN
                SELECT CONCAT('Organisation ID ', p_organisation_id, ' does not exist for client ', p_client_id) AS result;
                LEAVE sp_cleanup_client_data;
            END IF;
            
            -- Get organisation status
            SELECT status INTO v_org_status
            FROM etaniv2.client_service 
            WHERE id = p_organisation_id AND client_id = p_client_id;
            
            -- If organisation status is 2, delete records and drop stage tables
            IF v_org_status = 2 THEN
                SELECT CONCAT('Organisation ', p_organisation_id, ' has status 2 - Deleting records and dropping stage tables') AS action;
                
                -- Delete records from evadb_stage tables (non-stage tables) filtered by organisationID
                SET v_done = FALSE;
                OPEN table_cursor;
                delete_loop: LOOP
                    FETCH table_cursor INTO v_table_name;
                    IF v_done THEN
                        LEAVE delete_loop;
                    END IF;
                    
                    -- Check if table has OrganisationID column
                    SET @check_column_sql = CONCAT('
                        SELECT COUNT(*) INTO @has_org_id
                        FROM INFORMATION_SCHEMA.COLUMNS 
                        WHERE TABLE_SCHEMA = "evadb_stage" 
                        AND TABLE_NAME = "', v_table_name, '" 
                        AND COLUMN_NAME = "OrganisationID"
                    ');
                    PREPARE check_column_stmt FROM @check_column_sql;
                    EXECUTE check_column_stmt;
                    DEALLOCATE PREPARE check_column_stmt;
                    
                    -- Delete records if OrganisationID column exists
                    IF @has_org_id > 0 THEN
                        SET @delete_sql = CONCAT('DELETE FROM evadb_stage.', v_table_name, ' WHERE OrganisationID = ', p_organisation_id);
                        PREPARE delete_stmt FROM @delete_sql;
                        EXECUTE delete_stmt;
                        SET v_records_deleted = v_records_deleted + ROW_COUNT();
                        DEALLOCATE PREPARE delete_stmt;
                        
                        SELECT CONCAT('Deleted records from evadb_stage.', v_table_name, ' for OrganisationID ', p_organisation_id) AS deleted_records;
                    END IF;
                END LOOP;
                CLOSE table_cursor;
                
                -- Drop stage tables for this organisation
                SET v_done = FALSE;
                OPEN stage_table_cursor;
                stage_delete_loop: LOOP
                    FETCH stage_table_cursor INTO v_stage_table_name;
                    IF v_done THEN
                        LEAVE stage_delete_loop;
                    END IF;
                    
                    -- Check if this is a stage table for the specific organisation
                    IF v_stage_table_name LIKE CONCAT('c', p_client_id, '_', p_organisation_id, '_xeroblue_%stage') THEN
                        SET @drop_stage_sql = CONCAT('DROP TABLE IF EXISTS evadb_stage.', v_stage_table_name);
                        PREPARE drop_stage_stmt FROM @drop_stage_sql;
                        EXECUTE drop_stage_stmt;
                        DEALLOCATE PREPARE drop_stage_stmt;
                        
                        SET v_tables_dropped = v_tables_dropped + 1;
                        SELECT CONCAT('Dropped stage table: evadb_stage.', v_stage_table_name) AS dropped_table;
                    END IF;
                END LOOP;
                CLOSE stage_table_cursor;
                
                SELECT CONCAT('Completed cleanup for organisation ', p_organisation_id, '. Deleted ', v_records_deleted, ' records and dropped ', v_tables_dropped, ' stage tables.') AS result;
                
            ELSE
                SELECT CONCAT('Organisation ', p_organisation_id, ' status is ', v_org_status, ' (not 2) - No cleanup performed') AS result;
            END IF;
            
        ELSE
            SELECT CONCAT('Client ', p_client_id, ' status is ', v_client_status, ' (not 2) and no OrganisationID provided - No cleanup performed') AS result;
        END IF;
    END IF;
    
    -- Summary
    SELECT CONCAT('Cleanup completed. Errors: ', v_error_count, ', Tables dropped: ', v_tables_dropped, ', Records deleted: ', v_records_deleted) AS summary;
    
END$$

DELIMITER ;

-- Example usage:
-- CALL sp_cleanup_client_data('1066'); -- Cleanup all data for client 1066 if status = 2
-- CALL sp_cleanup_client_data('1066', 7035); -- Cleanup organisation 7035 data for client 1066 if org status = 2
