-- JOBMAN Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Accounts
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_accounts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_accounts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_accounts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_accountsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Organisation
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_organisation;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_organisation(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_organisation`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_organisationstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Users
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_users;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_users(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_users`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_usersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Catalogue Materials
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_catalogue materials;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_catalogue materials(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_catalogue materials`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_catalogue materialsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Catalogue Material Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_catalogue material detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_catalogue material detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_catalogue material detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_catalogue material detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Catalogue Products
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_catalogue products;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_catalogue products(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_catalogue products`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_catalogue productsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Catalogue Product Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_catalogue product detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_catalogue product detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_catalogue product detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_catalogue product detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Catalogue Services
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_catalogue services;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_catalogue services(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_catalogue services`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_catalogue servicesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Contacts
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_contacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_contacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_contacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_contactsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Contact Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_contact detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_contact detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_contact detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_contact detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;


-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Customers
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_customers;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_customers(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_customers`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_customersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Customer Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_customer detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_customer detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_customer detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_customer detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Employees
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_employees;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_employees(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_employees`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_employeesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Employee Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_employee detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_employee detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_employee detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_employee detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Locations
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_locations;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_locations(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_locations`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_locationsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Location Detail
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_location detail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_location detail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_location detail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_location detailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Categories
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_categories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_categories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_categories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_categoriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Jobs
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_jobs;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_jobs(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_jobs`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_jobsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Job Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_job details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_job details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_job details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_job detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Invoices
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_invoices;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_invoices(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_invoices`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_invoicesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Invoice Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_invoice details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_invoice details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_invoice details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_invoice detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Time Entries
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_time entries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_time entries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_time entries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_time entriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Time Entry Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_time entry details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_time entry details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_time entry details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_time entry detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Estimates
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_estimates;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_estimates(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_estimates`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_estimatesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Estimate Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_estimate details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_estimate details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_estimate details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_estimate detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Purchase Orders
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_purchase orders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_purchase orders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_purchase orders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_purchase ordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Purchase Order Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_purchase order details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_purchase order details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_purchase order details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_purchase order detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Expenses
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_expenses;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_expenses(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_expenses`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_expensesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Expense Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_expense details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_expense details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_expense details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_expense detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Payments
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_payments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_payments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_payments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_paymentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Payment Details
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_payment details;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_payment details(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_payment details`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_payment detailsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Job Tasks
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_job tasks;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_job tasks(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_job tasks`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_job tasksstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Job Time Entries
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_job time entries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_job time entries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_job time entries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_job time entriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Job Expenses
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_job expenses;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_job expenses(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_jobman_job expenses`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_jobman_job expensesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            clientid,
            organisationid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JOBMAN LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_jobman_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_jobman_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_jobman_lastrefreshdate`');

    SET @newid_sql = CONCAT('SELECT COALESCE(MAX(ID), 0) + 1 INTO @v_NewID FROM ', @lastRefreshDateTable, ';');
    PREPARE new_stmt FROM @newid_sql;
    EXECUTE new_stmt;
    DEALLOCATE PREPARE new_stmt;
    SET v_NewID = @v_NewID;

    SET @insert_sql = CONCAT(
        'INSERT INTO ', @lastRefreshDateTable, ' (',
        '`Id`, `TableName`, `RefreshRowCount`, `TotalRowCount`, `StartDate`, `EndDate`, ',
        '`LastRefreshUTCDate`, `LoadType`, `RefreshStatus`, `JobRunId`, `DatabaseDestination`, ',
        '`ClientID`, `OrganisationID`, `TriggerType`, `RefreshDetails`) VALUES (',
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
END $$
DELIMITER ;
