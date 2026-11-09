-- QBO Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Account
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_account;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_account(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_account`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_accountstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            acctnum,
            accounttype,
            accountsubtype,
            classification,
            fullyqualifiedname,
            active,
            currentbalance,
            currentbalancewithsubaccounts,
            parentref_value,
            parentref_name,
            currencyref_value,
            currencyref_name,
            description,
            subaccount,
            taxcoderef_value,
            taxcoderef_name,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Customer
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_customer;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_customer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_customer`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_customerstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            companyname,
            givenname,
            middlename,
            familyname,
            suffix,
            fullyqualifiedname,
            printoncheckname,
            active,
            taxable,
            job,
            billwithparent,
            balance,
            balancewithjobs,
            creditlimit,
            acctnum,
            notes,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_line4,
            shipaddr_line5,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            primaryemailaddr_address,
            webaddr_uri,
            primaryphone_freeformnumber,
            mobile_freeformnumber,
            fax_freeformnumber,
            alternatephone_freeformnumber,
            parentref_value,
            parentref_name,
            currencyref_value,
            currencyref_name,
            salestermref_value,
            salestermref_name,
            paymentmethodref_value,
            paymentmethodref_name,
            taxcoderef_value,
            taxcoderef_name,
            defaulttaxcoderef_value,
            defaulttaxcoderef_name,
            preferreddeliverymethod,
            resalenum,
            secondarytaxidentifier,
            araccountref_value,
            araccountref_name,
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

-- Vendor
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_vendor;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_vendor(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_vendor`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_vendorstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            companyname,
            displayname,
            printoncheckname,
            active,
            CASE 
                WHEN CAST(vendor1099 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendor1099 
            END as vendor1099,
            acctnum,
            givenname,
            familyname,
            middlename,
            suffix,
            title,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            primaryphone_freeformnumber,
            alternatephone_freeformnumber,
            mobile_freeformnumber,
            fax_freeformnumber,
            primaryemailaddr_address,
            webaddr_uri,
            contactname,
            taxidentifier,
            businessnumber,
            balance,
            CASE 
                WHEN CAST(openbalancedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE openbalancedate 
            END as openbalancedate,
            currencyref_value,
            currencyref_name,
            apaccountref_value,
            apaccountref_name,
            termref_value,
            termref_name,
            parentref_value,
            parentref_name,
            CASE 
                WHEN CAST(vendorpaymentbankdetail_bankname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorpaymentbankdetail_bankname 
            END as vendorpaymentbankdetail_bankname,
            CASE 
                WHEN CAST(vendorpaymentbankdetail_accountnumber AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorpaymentbankdetail_accountnumber 
            END as vendorpaymentbankdetail_accountnumber,
            CASE 
                WHEN CAST(vendorpaymentbankdetail_routingnumber AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorpaymentbankdetail_routingnumber 
            END as vendorpaymentbankdetail_routingnumber,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Item
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_item;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_item(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_item`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_itemstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            description,
            active,
            fullyqualifiedname,
            taxable,
            unitprice,
            type,
            itemcategorytype,
            parentref_value,
            parentref_name,
            level,
            qtyonhand,
            CASE 
                WHEN CAST(invstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invstartdate 
            END as invstartdate,
            trackqtyonhand,
            sku,
            salestaxincluded,
            purchasetaxincluded,
            purchasedesc,
            purchasecost,
            taxclassificationref_value,
            taxclassificationref_name,
            salestaxcoderef_value,
            salestaxcoderef_name,
            purchasetaxcoderef_value,
            purchasetaxcoderef_name,
            itemcategoryref_value,
            itemcategoryref_name,
            classref_value,
            classref_name,
            unitref_value,
            unitref_name,
            incomeaccountref_value,
            incomeaccountref_name,
            expenseaccountref_value,
            expenseaccountref_name,
            assetaccountref_value,
            assetaccountref_name,
            cogsaccountref_value,
            cogsaccountref_name,
            CASE 
                WHEN CAST(preferredvendor_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE preferredvendor_value 
            END as preferredvendor_value,
            CASE 
                WHEN CAST(preferredvendor_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE preferredvendor_name 
            END as preferredvendor_name,
            CASE 
                WHEN CAST(vendor1099 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendor1099 
            END as vendor1099,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Employee
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_employee;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_employee(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_employee`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_employeestage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            displayname,
            title,
            givenname,
            middlename,
            familyname,
            suffix,
            employeenumber,
            ssn,
            primaryaddr_id,
            primaryaddr_line1,
            primaryaddr_line2,
            primaryaddr_line3,
            primaryaddr_line4,
            primaryaddr_line5,
            primaryaddr_city,
            primaryaddr_country,
            primaryaddr_countrysubdivisioncode,
            primaryaddr_postalcode,
            primaryaddr_lat,
            primaryaddr_long,
            primaryphone_freeformnumber,
            mobile_freeformnumber,
            primaryemailaddr_address,
            employeetype,
            status,
            CASE 
                WHEN CAST(billabletime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billabletime 
            END as billabletime,
            CASE 
                WHEN CAST(hireddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE hireddate 
            END as hireddate,
            CASE 
                WHEN CAST(releaseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE releaseddate 
            END as releaseddate,
            CASE 
                WHEN CAST(birthdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE birthdate 
            END as birthdate,
            CASE 
                WHEN CAST(gender AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gender 
            END as gender,
            active,
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

-- Class
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_class;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_class(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_class`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_classstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            subclass,
            parentref_value,
            parentref_name,
            fullyqualifiedname,
            active,
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

-- Department
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_department;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_department(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_department`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_departmentstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            fullyqualifiedname,
            active,
            parentref_value,
            parentref_name,
            subdepartment,
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

-- TaxCode
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxcode;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_taxcode(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_taxcode`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_taxcodestage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            description,
            active,
            taxable,
            taxgroup,
            salestaxrateref_value,
            salestaxrateref_name,
            salestaxtypeapplicable,
            salestaxorder,
            purchasetaxrateref_value,
            purchasetaxrateref_name,
            purchasetaxtypeapplicable,
            purchasetaxorder,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PaymentMethod
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_paymentmethod;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_paymentmethod(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_paymentmethod`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_paymentmethodstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            active,
            type,
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

-- Term
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_term;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_term(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_term`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_termstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            type,
            discountpercent,
            CASE 
                WHEN CAST(duedays AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedays 
            END as duedays,
            discountdays,
            CASE 
                WHEN CAST(dayofmonthdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dayofmonthdue 
            END as dayofmonthdue,
            CASE 
                WHEN CAST(duenextmonthdays AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duenextmonthdays 
            END as duenextmonthdays,
            discountdayofmonth,
            active,
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

-- Currency
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_currency;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_currency(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_currency`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_currencystage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            code,
            name,
            active,
            globaltaxcalculation,
            userref_value,
            userref_name,
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

-- Invoice
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_invoice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_invoice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_invoice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_invoicestage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(shipdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE shipdate 
            END as shipdate,
            trackingnum,
            totalamt,
            hometotalamt,
            balance,
            homebalance,
            txntaxdetail_totaltax,
            txntaxdetail_taxrate,
            customerref_value,
            customerref_name,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_line4,
            shipaddr_line5,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            currencyref_value,
            currencyref_name,
            exchangerate,
            globaltaxcalculation,
            salestermref_value,
            salestermref_name,
            classref_value,
            classref_name,
            departmentref_value,
            departmentref_name,
            printstatus,
            emailstatus,
            billemail_address,
            deliveryinfo_deliverytype,
            CASE 
                WHEN CAST(deliveryinfo_deliverytime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliveryinfo_deliverytime 
            END as deliveryinfo_deliverytime,
            invoicelink,
            recurdataref_value,
            recurdataref_name,
            taxexemptionref_value,
            taxexemptionref_name,
            allowipnpayment,
            allowonlinepayment,
            allowonlinecreditcardpayment,
            allowonlineachpayment,
            customermemo_value,
            deposit,
            deposittoaccountref_value,
            deposittoaccountref_name,
            applytaxafterdiscount,
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

-- Bill
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_bill;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_bill(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_bill`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_billstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(vendorref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_value 
            END as vendorref_value,
            CASE 
                WHEN CAST(vendorref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_name 
            END as vendorref_name,
            apaccountref_value,
            apaccountref_name,
            totalamt,
            currencyref_value,
            currencyref_name,
            exchangerate,
            salestermref_value,
            salestermref_name,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            balance,
            homebalance,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Payment
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_payment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_payment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_payment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_paymentstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            totalamt,
            unappliedamt,
            processpayment,
            paymentrefnum,
            customerref_value,
            customerref_name,
            araccountref_value,
            araccountref_name,
            deposittoaccountref_value,
            deposittoaccountref_name,
            paymentmethodref_value,
            paymentmethodref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            taxexemptionref_value,
            taxexemptionref_name,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- BillPayment
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_billpayment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_billpayment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_billpayment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_billpaymentstage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            CASE 
                WHEN CAST(vendorref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_value 
            END as vendorref_value,
            CASE 
                WHEN CAST(vendorref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_name 
            END as vendorref_name,
            paytype,
            totalamt,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            processbillpayment,
            checkpayment_bankaccountref_value,
            checkpayment_bankaccountref_name,
            checkpayment_printstatus,
            creditcardpayment_ccaccountref_value,
            creditcardpayment_ccaccountref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SalesReceipt
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_salesreceipt;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_salesreceipt(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_salesreceipt`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_salesreceiptstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            customermemo,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_line4,
            shipaddr_line5,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            classref_value,
            classref_name,
            salestermref_value,
            salestermref_name,
            totalamt,
            hometotalamt,
            applytaxafterdiscount,
            printstatus,
            emailstatus,
            billemail_address,
            balance,
            paymentmethodref_value,
            paymentmethodref_name,
            paymentrefnum,
            customerref_value,
            customerref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            departmentref_value,
            departmentref_name,
            deposittoaccountref_value,
            deposittoaccountref_name,
            shipmethodref_value,
            shipmethodref_name,
            CASE 
                WHEN CAST(shipdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE shipdate 
            END as shipdate,
            trackingnum,
            globaltaxcalculation,
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

-- Estimate
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_estimate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_estimate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_estimate`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_estimatestage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(expirationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expirationdate 
            END as expirationdate,
            acceptedby,
            CASE 
                WHEN CAST(accepteddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE accepteddate 
            END as accepteddate,
            customerref_value,
            customerref_name,
            customermemo_value,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            classref_value,
            classref_name,
            salestermref_value,
            salestermref_name,
            totalamt,
            applytaxafterdiscount,
            printstatus,
            emailstatus,
            billemail_address,
            currencyref_value,
            currencyref_name,
            exchangerate,
            globaltaxcalculation,
            txnstatus,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrder
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_purchaseorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_purchaseorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_purchaseorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_purchaseorderstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            docnumber,
            CASE 
                WHEN CAST(vendorref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_value 
            END as vendorref_value,
            CASE 
                WHEN CAST(vendorref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_name 
            END as vendorref_name,
            apaccountref_value,
            apaccountref_name,
            totalamt,
            CASE 
                WHEN CAST(vendoraddr_id AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_id 
            END as vendoraddr_id,
            CASE 
                WHEN CAST(vendoraddr_line1 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_line1 
            END as vendoraddr_line1,
            CASE 
                WHEN CAST(vendoraddr_line2 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_line2 
            END as vendoraddr_line2,
            CASE 
                WHEN CAST(vendoraddr_line3 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_line3 
            END as vendoraddr_line3,
            CASE 
                WHEN CAST(vendoraddr_line4 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_line4 
            END as vendoraddr_line4,
            CASE 
                WHEN CAST(vendoraddr_line5 AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_line5 
            END as vendoraddr_line5,
            CASE 
                WHEN CAST(vendoraddr_city AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_city 
            END as vendoraddr_city,
            CASE 
                WHEN CAST(vendoraddr_country AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_country 
            END as vendoraddr_country,
            CASE 
                WHEN CAST(vendoraddr_countrysubdivisioncode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_countrysubdivisioncode 
            END as vendoraddr_countrysubdivisioncode,
            CASE 
                WHEN CAST(vendoraddr_postalcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_postalcode 
            END as vendoraddr_postalcode,
            CASE 
                WHEN CAST(vendoraddr_lat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_lat 
            END as vendoraddr_lat,
            CASE 
                WHEN CAST(vendoraddr_long AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendoraddr_long 
            END as vendoraddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_line4,
            shipaddr_line5,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            classref_value,
            classref_name,
            salestermref_value,
            salestermref_name,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(vendorcreditref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorcreditref_value 
            END as vendorcreditref_value,
            CASE 
                WHEN CAST(vendorcreditref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorcreditref_name 
            END as vendorcreditref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            globaltaxcalculation,
            txntaxdetail_totaltax,
            postatus,
            emailstatus,
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

-- JournalEntry
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_journalentry;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_journalentry(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_journalentry`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_journalentrystage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            adjustment,
            currencyref_value,
            currencyref_name,
            exchangerate,
            totalamt,
            hometotalamt,
            line_id,
            line_description,
            line_amount,
            line_detailtype,
            line_journalentrylinedetail_postingtype,
            line_journalentrylinedetail_accountref_value,
            line_journalentrylinedetail_accountref_name,
            line_journalentrylinedetail_classref_value,
            line_journalentrylinedetail_classref_name,
            line_journalentrylinedetail_departmentref_value,
            line_journalentrylinedetail_departmentref_name,
            line_journalentrylinedetail_entity_type,
            line_journalentrylinedetail_entity_entityref_value,
            line_journalentrylinedetail_entity_entityref_name,
            line_journalentrylinedetail_taxcoderef_value,
            line_journalentrylinedetail_taxcoderef_name,
            line_journalentrylinedetail_taxapplicableon,
            line_journalentrylinedetail_taxamount,
            line_journalentrylinedetail_billablestatus,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CreditMemo
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_creditmemo;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_creditmemo(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_creditmemo`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_creditmemostage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            customerref_value,
            customerref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            billaddr_id,
            billaddr_line1,
            billaddr_line2,
            billaddr_line3,
            billaddr_line4,
            billaddr_line5,
            billaddr_city,
            billaddr_country,
            billaddr_countrysubdivisioncode,
            billaddr_postalcode,
            billaddr_lat,
            billaddr_long,
            shipaddr_id,
            shipaddr_line1,
            shipaddr_line2,
            shipaddr_line3,
            shipaddr_line4,
            shipaddr_line5,
            shipaddr_city,
            shipaddr_country,
            shipaddr_countrysubdivisioncode,
            shipaddr_postalcode,
            shipaddr_lat,
            shipaddr_long,
            paymentmethodref_value,
            paymentmethodref_name,
            salestermref_value,
            salestermref_name,
            classref_value,
            classref_name,
            departmentref_value,
            departmentref_name,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            totalamt,
            applytaxafterdiscount,
            printstatus,
            emailstatus,
            billemail_address,
            balance,
            remainingcredit,
            txntaxdetail_txntaxcoderef_value,
            txntaxdetail_totaltax,
            customermemo_value,
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

-- VendorCredit
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_vendorcredit;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_vendorcredit(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_vendorcredit`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_vendorcreditstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            CASE 
                WHEN CAST(vendorref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_value 
            END as vendorref_value,
            CASE 
                WHEN CAST(vendorref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_name 
            END as vendorref_name,
            apaccountref_value,
            apaccountref_name,
            totalamt,
            currencyref_value,
            currencyref_name,
            exchangerate,
            balance,
            status,
            globaltaxcalculation,
            hometotalamt,
            recurdataref_value,
            recurdataref_name,
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

-- Deposit
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_deposit;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_deposit(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_deposit`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_depositstage`');

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

-- Transfer
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_transfer;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_transfer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_transfer`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_transferstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            amount,
            fromaccountref_value,
            fromaccountref_name,
            toaccountref_value,
            toaccountref_name,
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

-- RefundReceipt
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_refundreceipt;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_refundreceipt(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_refundreceipt`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_refundreceiptstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            docnumber,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            customerref_value,
            customerref_name,
            currencyref_value,
            currencyref_name,
            exchangerate,
            totalamt,
            hometotalamt,
            printstatus,
            emailstatus,
            customermemo_value,
            checkpayment_checknum,
            checkpayment_status,
            checkpayment_nameonacct,
            checkpayment_acctnum,
            checkpayment_bankname,
            creditcardpayment_creditchargeinfo_type,
            creditcardpayment_creditchargeinfo_nameonacct,
            creditcardpayment_creditchargeinfo_ccexpirymonth,
            creditcardpayment_creditchargeinfo_ccexpiryyear,
            creditcardpayment_creditchargeinfo_billaddrstreet,
            creditcardpayment_creditchargeinfo_postalcode,
            creditcardpayment_creditchargeinfo_amount,
            creditcardpayment_creditchargeinfo_processpayment,
            applytaxafterdiscount,
            globaltaxcalculation,
            txntaxdetail_txntaxcoderef_value,
            txntaxdetail_totaltax,
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

-- TimeActivity
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_timeactivity;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_timeactivity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_timeactivity`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_timeactivitystage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            CASE 
                WHEN CAST(txndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE txndate 
            END as txndate,
            nameof,
            employeeref_value,
            employeeref_name,
            CASE 
                WHEN CAST(vendorref_value AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_value 
            END as vendorref_value,
            CASE 
                WHEN CAST(vendorref_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorref_name 
            END as vendorref_name,
            customerref_value,
            customerref_name,
            itemref_value,
            itemref_name,
            classref_value,
            classref_name,
            departmentref_value,
            departmentref_name,
            billablestatus,
            taxable,
            hourlyrate,
            hours,
            minutes,
            CASE 
                WHEN CAST(starttime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE starttime 
            END as starttime,
            CASE 
                WHEN CAST(endtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE endtime 
            END as endtime,
            description,
            breakhours,
            breakminutes,
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

-- Preferences
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_preferences;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_preferences(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_preferences`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_preferencesstage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            accountinginfoprefs_firstmonthoffiscalyear,
            accountinginfoprefs_useaccountnumbers,
            accountinginfoprefs_taxyearmonth,
            accountinginfoprefs_taxform,
            CASE 
                WHEN CAST(accountinginfoprefs_bookclosedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE accountinginfoprefs_bookclosedate 
            END as accountinginfoprefs_bookclosedate,
            accountinginfoprefs_deferredrevenueenabled,
            productandservicesprefs_quantitywithpriceandrate,
            productandservicesprefs_quantityonhand,
            productandservicesprefs_uomfeatureenabled,
            salesformsprefs_customfield1label,
            salesformsprefs_customfield2label,
            salesformsprefs_customfield3label,
            salesformsprefs_defaultcustomermessage,
            salesformsprefs_defaultdiscountaccount,
            salesformsprefs_defaultshippingaccount,
            salesformsprefs_defaultterms,
            salesformsprefs_etransactionpaymentenabled,
            salesformsprefs_etransactionenabledstatus,
            salesformsprefs_usingpricelevels,
            salesformsprefs_usingprogressinvoicing,
            CASE 
                WHEN CAST(vendorandpurchasesprefs_trackingbycustomer AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorandpurchasesprefs_trackingbycustomer 
            END as vendorandpurchasesprefs_trackingbycustomer,
            CASE 
                WHEN CAST(vendorandpurchasesprefs_billableexpensetracking AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorandpurchasesprefs_billableexpensetracking 
            END as vendorandpurchasesprefs_billableexpensetracking,
            CASE 
                WHEN CAST(vendorandpurchasesprefs_tparenabled AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorandpurchasesprefs_tparenabled 
            END as vendorandpurchasesprefs_tparenabled,
            CASE 
                WHEN CAST(vendorandpurchasesprefs_usespurchaseorders AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorandpurchasesprefs_usespurchaseorders 
            END as vendorandpurchasesprefs_usespurchaseorders,
            emailmessagesprefs_invoicemessage,
            emailmessagesprefs_estimatemessage,
            emailmessagesprefs_salesreceiptmessage,
            emailmessagesprefs_statementmessage,
            reportprefs_reportbasis,
            CASE 
                WHEN CAST(reportprefs_calcagingreportfromtxndate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportprefs_calcagingreportfromtxndate 
            END as reportprefs_calcagingreportfromtxndate,
            otherprefs_namevalue,
            taxprefs_usingsalestax,
            taxprefs_paysalestax,
            currencyprefs_multicurrencyenabled,
            currencyprefs_homecurrency,
            CASE 
                WHEN CAST(timetrackingprefs_useservices AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetrackingprefs_useservices 
            END as timetrackingprefs_useservices,
            CASE 
                WHEN CAST(timetrackingprefs_billcustomers AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetrackingprefs_billcustomers 
            END as timetrackingprefs_billcustomers,
            CASE 
                WHEN CAST(timetrackingprefs_showbillratetoall AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetrackingprefs_showbillratetoall 
            END as timetrackingprefs_showbillratetoall,
            CASE 
                WHEN CAST(timetrackingprefs_workweekstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetrackingprefs_workweekstartdate 
            END as timetrackingprefs_workweekstartdate,
            CASE 
                WHEN CAST(timetrackingprefs_marktimeentriesbillable AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetrackingprefs_marktimeentriesbillable 
            END as timetrackingprefs_marktimeentriesbillable,
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

-- TaxRate
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxrate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_taxrate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_taxrate`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_taxratestage`');

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
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            description,
            active,
            ratevalue,
            agencyref_value,
            agencyref_name,
            taxreturnlineref_value,
            taxreturnlineref_name,
            specialtaxtype,
            displaytype,
            effectivetaxrate_ratevalue,
            CASE 
                WHEN CAST(effectivetaxrate_effectivedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE effectivetaxrate_effectivedate 
            END as effectivetaxrate_effectivedate,
            CASE 
                WHEN CAST(effectivetaxrate_enddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE effectivetaxrate_enddate 
            END as effectivetaxrate_enddate,
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

-- TaxService
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_taxservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_taxservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_taxservicestage`');

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
            clientid,
            organisationid,
            id,
            synctoken,
            CASE 
                WHEN CAST(metadata_createtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE metadata_createtime 
            END as metadata_createtime,
            name,
            description,
            active,
            taxable,
            taxgroup,
            salestaxratelist,
            purchasetaxratelist,
            referencecode,
            taxcodeconfigtype,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ProfitAndLoss
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_profitandloss;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_profitandloss(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_profitandloss`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_profitandlossstage`');

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
            clientid,
            organisationid,
            reportname,
            CASE 
                WHEN CAST(startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startperiod 
            END as startperiod,
            CASE 
                WHEN CAST(endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE endperiod 
            END as endperiod,
            currency,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            header_reportname,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            header_currency,
            header_option_name,
            header_option_value,
            columns_coltitle,
            columns_coltype,
            row_number,
            row_group,
            coldata_value,
            coldata_href,
            coldata_id,
            accountname,
            accounttype,
            amount,
            percentofincome,
            linetype,
            level,
            issubtotal,
            istotal,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- BalanceSheet
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_balancesheet;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_balancesheet(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_balancesheet`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_balancesheetstage`');

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
            clientid,
            organisationid,
            header_reportname,
            header_reportbasis,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            header_currency,
            header_option_name,
            header_option_value,
            columns_coltitle,
            columns_coltype,
            rows_group,
            rows_coldata_value,
            rows_coldata_id,
            rows_coldata_href,
            rows_rows_group,
            rows_rows_coldata_value,
            rows_rows_coldata_id,
            accountname,
            accounttype,
            balance,
            CASE 
                WHEN CAST(reportdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportdate 
            END as reportdate,
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

-- CashFlow
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_cashflow;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_cashflow(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_cashflow`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_cashflowstage`');

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
            header_reportname,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            header_currency,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            header_reportbasis,
            column_title,
            column_type,
            column_metadata,
            row_group,
            row_coldata_value,
            row_coldata_href,
            row_coldata_id,
            id,
            clientid,
            organisationid,
            CASE 
                WHEN CAST(reportdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportdate 
            END as reportdate,
            cashatbeginningofperiod,
            CASE 
                WHEN CAST(cashatendofperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cashatendofperiod 
            END as cashatendofperiod,
            netcashincrease,
            operatingactivitiestotal,
            investingactivitiestotal,
            financingactivitiestotal,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- GeneralLedger
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_generalledger;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_generalledger(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_generalledger`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_generalledgerstage`');

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
            header_reportname,
            header_reportbasis,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            header_currency,
            header_option_name,
            header_option_value,
            columns_coltitle,
            columns_coltype,
            rows_group,
            rows_coldata_value,
            rows_coldata_href,
            rows_coldata_id,
            account_id,
            account_name,
            account_accounttype,
            account_accountsubtype,
            transaction_id,
            transaction_txntype,
            CASE 
                WHEN CAST(transaction_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transaction_date 
            END as transaction_date,
            transaction_refnumber,
            transaction_name,
            transaction_memo,
            transaction_split,
            transaction_debitamount,
            transaction_creditamount,
            transaction_balance,
            runningbalance,
            rowid,
            clientid,
            organisationid,
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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- TrialBalance
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_trialbalance;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_trialbalance(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_trialbalance`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_trialbalancestage`');

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
            header_reportname,
            header_reportbasis,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            header_currency,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            columns_coltitle,
            columns_coltype,
            rows_group,
            coldata_value,
            coldata_id,
            accountname,
            accountnumber,
            accounttype,
            debitamount,
            creditamount,
            balance,
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

-- AgedReceivables
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_agedreceivables;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_agedreceivables(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_agedreceivables`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_agedreceivablesstage`');

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
            header_reportname,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            CASE 
                WHEN CAST(header_datemacro AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_datemacro 
            END as header_datemacro,
            header_summarizecolumnsby,
            header_currency,
            header_option_name,
            header_option_value,
            columns_coltitle,
            columns_coltype,
            columns_metadata,
            row_group,
            coldata_value,
            coldata_id,
            customername,
            current,
            days1_30,
            days31_60,
            days61_90,
            days91_andover,
            total,
            clientid,
            organisationid,
            CASE 
                WHEN CAST(reportdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportdate 
            END as reportdate,
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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AgedPayables
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_agedpayables;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_agedpayables(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_agedpayables`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_agedpayablesstage`');

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
            header_reportname,
            CASE 
                WHEN CAST(header_startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_startperiod 
            END as header_startperiod,
            CASE 
                WHEN CAST(header_endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_endperiod 
            END as header_endperiod,
            header_currency,
            CASE 
                WHEN CAST(header_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE header_time 
            END as header_time,
            header_reportbasis,
            header_summarizecolumnsby,
            column_title,
            column_type,
            row_group,
            row_data_value,
            row_data_id,
            CASE 
                WHEN CAST(vendorname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendorname 
            END as vendorname,
            current,
            days1to30,
            days31to60,
            days61to90,
            daysover90,
            total,
            reportid,
            clientid,
            organisationid,
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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ClassSales
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_classsales;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_classsales(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_classsales`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_classsalesstage`');

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
            reportname,
            CASE 
                WHEN CAST(startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startperiod 
            END as startperiod,
            CASE 
                WHEN CAST(endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE endperiod 
            END as endperiod,
            currency,
            CASE 
                WHEN CAST(reporttime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reporttime 
            END as reporttime,
            classid,
            classrefid,
            classname,
            totalamount,
            percentofincome,
            columntitle,
            columntype,
            clientid,
            organisationid,
            CASE 
                WHEN CAST(reportgenerateddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportgenerateddate 
            END as reportgenerateddate,
            accountingmethod,
            summarizecolumnsby,
            reportbasis,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DepartmentSales
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_departmentsales;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_departmentsales(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_qbo_departmentsales`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_qbo_departmentsalesstage`');

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
            clientid,
            organisationid,
            reportname,
            CASE 
                WHEN CAST(startperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startperiod 
            END as startperiod,
            CASE 
                WHEN CAST(endperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE endperiod 
            END as endperiod,
            currency,
            rowgroup,
            department,
            total_amount,
            total_amount_id,
            percent_of_total_income,
            column1_title,
            column2_title,
            column3_title,
            column1_type,
            column2_type,
            column3_type,
            row_type,
            CASE 
                WHEN CAST(reportdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reportdate 
            END as reportdate,
            CASE 
                WHEN CAST(generatedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE generatedtime 
            END as generatedtime,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- QBO LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_qbo_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_qbo_lastrefreshdate`');

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
