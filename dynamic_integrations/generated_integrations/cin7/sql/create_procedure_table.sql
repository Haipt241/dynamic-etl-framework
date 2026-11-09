-- CIN7 Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Contacts
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_contacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_contacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_contacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_contactsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            isactive,
            company,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            jobtitle,
            email,
            website,
            phone,
            fax,
            mobile,
            address1,
            address2,
            city,
            state,
            postcode,
            country,
            postaladdress1,
            postaladdress2,
            postalcity,
            postalpostcode,
            postalstate,
            postalcountry,
            notes,
            integrationref,
            customfields,
            type,
            salespersonid,
            accountnumber,
            billingid,
            billingcompany,
            accountsfirstname,
            CASE 
                WHEN CAST(accountslastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE accountslastname 
            END as accountslastname,
            billingemail,
            accountsphone,
            billingcostcenter,
            costcenter,
            pricecolumn,
            percentageoff,
            paymentterms,
            taxstatus,
            taxnumber,
            creditlimit,
            balanceowing,
            onhold,
            `group`,
            subgroup,
            stages,
            clientid,
            organisationid,
            accountingintegrationidxero,
            accountingintegrationidquickbooksonline,
            accountingintegrationidquickbooksdesktop,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CreditNotes
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_creditnotes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_creditnotes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_creditnotes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_creditnotesstage`');

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
            status,
            memberemail,
            salesreference,
            creditnotenumber,
            CASE 
                WHEN CAST(creditnotedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE creditnotedate 
            END as creditnotedate,
            CASE 
                WHEN CAST(completeddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE completeddate 
            END as completeddate,
            customerreport,
            alternativeaccountcode,
            salespersonid,
            logisticscarrier,
            logisticsstatus,
            accountingattributes,
            CASE 
                WHEN CAST(modifiedcogsdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedcogsdate 
            END as modifiedcogsdate,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            memberid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            deliveryfirstname,
            CASE 
                WHEN CAST(deliverylastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverylastname 
            END as deliverylastname,
            deliverycompany,
            deliveryaddress1,
            deliveryaddress2,
            deliverycity,
            deliverystate,
            deliverypostalcode,
            deliverycountry,
            billingfirstname,
            CASE 
                WHEN CAST(billinglastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billinglastname 
            END as billinglastname,
            billingcompany,
            billingaddress1,
            billingaddress2,
            billingcity,
            billingpostalcode,
            billingstate,
            billingcountry,
            branchid,
            branchemail,
            projectname,
            trackingcode,
            internalcomments,
            producttotal,
            freighttotal,
            freightdescription,
            surcharge,
            surchargedescription,
            discounttotal,
            discountdescription,
            total,
            currencycode,
            currencyrate,
            currencysymbol,
            taxstatus,
            taxrate,
            source,
            customfields,
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

-- BomMasters
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_bommasters;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_bommasters(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_bommasters`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_bommastersstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            CASE 
                WHEN CAST(modifiedby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedby 
            END as modifiedby,
            productionnotes,
            reference,
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

-- ProductionJob
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productionjob;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productionjob(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productionjob`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productionjobstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(completeddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE completeddate 
            END as completeddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            completedby,
            isapproved,
            branchid,
            company,
            projectname,
            productionnotes,
            reference,
            source,
            totalcost,
            customfields,
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

-- User
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_user;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_user(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_user`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_userstage`');

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
            isactive,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            jobtitle,
            email,
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

-- SalesOrdersWithCartons
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_salesorderswithcartons;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_salesorderswithcartons(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_salesorderswithcartons`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_salesorderswithcartonsstage`');

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
            ssccnumber,
            cartonswithlineitems,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            invoicenumber,
            CASE 
                WHEN CAST(dispatcheddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dispatcheddate 
            END as dispatcheddate,
            logisticscarrier,
            logisticsstatus,
            edistatus,
            distributionbranchid,
            departmentnumber,
            storelocationnumber,
            distributioncenter,
            isvoid,
            accountingattributes,
            status,
            stage,
            memberemail,
            membercostcenter,
            memberalternativetaxrate,
            costcenter,
            alternativetaxrate,
            CASE 
                WHEN CAST(estimateddeliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE estimateddeliverydate 
            END as estimateddeliverydate,
            salespersonid,
            salespersonemail,
            paymentterms,
            customerorderno,
            vouchercode,
            deliveryinstructions,
            CASE 
                WHEN CAST(cancellationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancellationdate 
            END as cancellationdate,
            CASE 
                WHEN CAST(modifiedcogsdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedcogsdate 
            END as modifiedcogsdate,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            memberid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            deliveryfirstname,
            CASE 
                WHEN CAST(deliverylastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverylastname 
            END as deliverylastname,
            deliverycompany,
            deliveryaddress1,
            deliveryaddress2,
            deliverycity,
            deliverystate,
            deliverypostalcode,
            deliverycountry,
            billingfirstname,
            CASE 
                WHEN CAST(billinglastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billinglastname 
            END as billinglastname,
            billingcompany,
            billingaddress1,
            billingaddress2,
            billingcity,
            billingpostalcode,
            billingstate,
            billingcountry,
            branchid,
            branchemail,
            projectname,
            trackingcode,
            internalcomments,
            producttotal,
            freighttotal,
            freightdescription,
            surcharge,
            surchargedescription,
            discounttotal,
            discountdescription,
            total,
            currencycode,
            currencyrate,
            currencysymbol,
            taxstatus,
            taxrate,
            source,
            customfields,
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

-- Branches
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_branches;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_branches(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_branches`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_branchesstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            isactive,
            company,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            jobtitle,
            email,
            website,
            phone,
            fax,
            mobile,
            address1,
            address2,
            city,
            state,
            postcode,
            country,
            postaladdress1,
            postaladdress2,
            postalcity,
            postalpostcode,
            postalstate,
            postalcountry,
            notes,
            integrationref,
            customfields,
            branchtype,
            stockcontroloptions,
            taxstatus,
            accountnumber,
            branchlocations,
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

-- ProductCategories
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productcategories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productcategories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productcategories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productcategoriesstage`');

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
            parentid,
            isactive,
            sort,
            name,
            description,
            image,
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

-- Products
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_products;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_products(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_products`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productsstage`');

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
            status,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            stylecode,
            name,
            description,
            tags,
            images,
            pdfupload,
            pdfdescription,
            supplierid,
            brand,
            category,
            subcategory,
            categoryidarray,
            channels,
            weight,
            height,
            width,
            length,
            volume,
            stockcontrol,
            ordertype,
            producttype,
            productsubtype,
            projectname,
            optionlabel1,
            optionlabel2,
            optionlabel3,
            salesaccount,
            purchasesaccount,
            importcustomsduty,
            sizerangeid,
            clientid,
            organisationid,
            customfieldsproducts1000,
            customfieldsproducts1001,
            customfieldsproducts1002,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ProductOption
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productoption;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productoption(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productoption`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productoptionstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            status,
            productid,
            code,
            barcode,
            productoptioncode,
            productoptionsizecode,
            productoptionbarcode,
            productoptionsizebarcode,
            suppliercode,
            option1,
            option2,
            option3,
            optionweight,
            size,
            sizeid,
            retailprice,
            wholesaleprice,
            vipprice,
            specialprice,
            CASE 
                WHEN CAST(specialsstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE specialsstartdate 
            END as specialsstartdate,
            specialdays,
            stockavailable,
            stockonhand,
            uomoptions,
            clientid,
            organisationid,
            imagelink,
            pricecolumnspriceaud,
            pricecolumnspricegbp,
            pricecolumnscostnzd,
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

-- SerialNumber
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_serialnumber;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_serialnumber(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_serialnumber`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_serialnumberstage`');

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
            serialnumber,
            productid,
            productoptionid,
            lineitemid,
            code,
            holdinggroup,
            branchid,
            available,
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

-- SalesOrder
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_salesorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_salesorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_salesorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_salesorderstage`');

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
            clientid,
            organisationid,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            memberid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            deliveryfirstname,
            CASE 
                WHEN CAST(deliverylastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverylastname 
            END as deliverylastname,
            deliverycompany,
            deliveryaddress1,
            deliveryaddress2,
            deliverycity,
            deliverystate,
            deliverypostalcode,
            deliverycountry,
            billingfirstname,
            CASE 
                WHEN CAST(billinglastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billinglastname 
            END as billinglastname,
            billingcompany,
            billingaddress1,
            billingaddress2,
            billingcity,
            billingpostalcode,
            billingstate,
            billingcountry,
            branchid,
            branchemail,
            projectname,
            trackingcode,
            internalcomments,
            producttotal,
            freighttotal,
            freightdescription,
            surcharge,
            surchargedescription,
            discounttotal,
            discountdescription,
            total,
            currencycode,
            currencyrate,
            currencysymbol,
            taxstatus,
            taxrate,
            source,
            customfields,
            isvoid,
            accountingattributes,
            memberemail,
            membercostcenter,
            memberalternativetaxrate,
            costcenter,
            alternativetaxrate,
            CASE 
                WHEN CAST(estimateddeliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE estimateddeliverydate 
            END as estimateddeliverydate,
            salespersonid,
            salespersonemail,
            paymentterms,
            customerorderno,
            vouchercode,
            deliveryinstructions,
            CASE 
                WHEN CAST(cancellationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancellationdate 
            END as cancellationdate,
            CASE 
                WHEN CAST(modifiedcogsdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedcogsdate 
            END as modifiedcogsdate,
            status,
            stage,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            invoicenumber,
            CASE 
                WHEN CAST(dispatcheddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dispatcheddate 
            END as dispatcheddate,
            logisticscarrier,
            logisticsstatus,
            edistatus,
            distributionbranchid,
            departmentnumber,
            storelocationnumber,
            distributioncenter,
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
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_payments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_payments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_payments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_paymentsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(paymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paymentdate 
            END as paymentdate,
            amount,
            method,
            isauthorized,
            transactionref,
            comments,
            orderid,
            orderref,
            paymentimportedref,
            batchreference,
            CASE 
                WHEN CAST(reconciledate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reconciledate 
            END as reconciledate,
            branchid,
            ordertype,
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

-- Quotes
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_quotes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_quotes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_quotes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_quotesstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            memberid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            deliveryfirstname,
            CASE 
                WHEN CAST(deliverylastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverylastname 
            END as deliverylastname,
            deliverycompany,
            deliveryaddress1,
            deliveryaddress2,
            deliverycity,
            deliverystate,
            deliverypostalcode,
            deliverycountry,
            billingfirstname,
            CASE 
                WHEN CAST(billinglastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billinglastname 
            END as billinglastname,
            billingcompany,
            billingaddress1,
            billingaddress2,
            billingcity,
            billingpostalcode,
            billingstate,
            billingcountry,
            branchid,
            branchemail,
            projectname,
            trackingcode,
            internalcomments,
            producttotal,
            freighttotal,
            freightdescription,
            surcharge,
            surchargedescription,
            discounttotal,
            discountdescription,
            total,
            currencycode,
            currencyrate,
            currencysymbol,
            taxstatus,
            taxrate,
            source,
            customfields,
            memberemail,
            membercostcenter,
            memberalternativetaxrate,
            costcenter,
            alternativetaxrate,
            CASE 
                WHEN CAST(estimateddeliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE estimateddeliverydate 
            END as estimateddeliverydate,
            salespersonid,
            salespersonemail,
            paymentterms,
            customerorderno,
            vouchercode,
            deliveryinstructions,
            CASE 
                WHEN CAST(cancellationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancellationdate 
            END as cancellationdate,
            CASE 
                WHEN CAST(modifiedcogsdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedcogsdate 
            END as modifiedcogsdate,
            status,
            stage,
            probability,
            CASE 
                WHEN CAST(expectedorderdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expectedorderdate 
            END as expectedorderdate,
            CASE 
                WHEN CAST(acceptancedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE acceptancedate 
            END as acceptancedate,
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

-- PurchaseOrder
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_purchaseorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_purchaseorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_purchaseorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_purchaseorderstage`');

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
            supplierinvoicereference,
            CASE 
                WHEN CAST(supplieracceptancedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE supplieracceptancedate 
            END as supplieracceptancedate,
            port,
            CASE 
                WHEN CAST(estimatedarrivaldate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE estimatedarrivaldate 
            END as estimatedarrivaldate,
            CASE 
                WHEN CAST(fullyreceiveddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fullyreceiveddate 
            END as fullyreceiveddate,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            logisticscarrier,
            logisticsstatus,
            accountingattributes,
            isvoid,
            status,
            stage,
            memberemail,
            membercostcenter,
            memberalternativetaxrate,
            costcenter,
            alternativetaxrate,
            CASE 
                WHEN CAST(estimateddeliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE estimateddeliverydate 
            END as estimateddeliverydate,
            salespersonid,
            salespersonemail,
            paymentterms,
            customerorderno,
            vouchercode,
            deliveryinstructions,
            CASE 
                WHEN CAST(cancellationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancellationdate 
            END as cancellationdate,
            CASE 
                WHEN CAST(modifiedcogsdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedcogsdate 
            END as modifiedcogsdate,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            memberid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            deliveryfirstname,
            CASE 
                WHEN CAST(deliverylastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverylastname 
            END as deliverylastname,
            deliverycompany,
            deliveryaddress1,
            deliveryaddress2,
            deliverycity,
            deliverystate,
            deliverypostalcode,
            deliverycountry,
            billingfirstname,
            CASE 
                WHEN CAST(billinglastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billinglastname 
            END as billinglastname,
            billingcompany,
            billingaddress1,
            billingaddress2,
            billingcity,
            billingpostalcode,
            billingstate,
            billingcountry,
            branchid,
            branchemail,
            projectname,
            trackingcode,
            internalcomments,
            producttotal,
            freighttotal,
            freightdescription,
            surcharge,
            surchargedescription,
            discounttotal,
            discountdescription,
            total,
            currencycode,
            currencyrate,
            currencysymbol,
            taxstatus,
            taxrate,
            source,
            customfields,
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

-- Stock
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_stock;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_stock(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_stock`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_stockstage`');

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
            productid,
            productoptionid,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            stylecode,
            code,
            barcode,
            branchid,
            branchname,
            productname,
            option1,
            option2,
            option3,
            size,
            available,
            stockonhand,
            opensales,
            incoming,
            `virtual`,
            holding,
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

-- BranchTransfers
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_branchtransfers;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_branchtransfers(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_branchtransfers`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_branchtransfersstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            approvedby,
            isapproved,
            reference,
            branchemail,
            deliveryinstructions,
            internalcomments,
            producttotal,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            email,
            phone,
            mobile,
            fax,
            projectname,
            trackingcode,
            source,
            sourcebranchid,
            destinationbranchid,
            CASE 
                WHEN CAST(approvaldate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE approvaldate 
            END as approvaldate,
            CASE 
                WHEN CAST(dispatcheddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dispatcheddate 
            END as dispatcheddate,
            CASE 
                WHEN CAST(receiveddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE receiveddate 
            END as receiveddate,
            stage,
            clientid,
            organisationid,
            customfieldssamplestring1,
            customfieldssamplestring3,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Adjustments
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_adjustments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_adjustments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_adjustments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_adjustmentsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(createdby AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdby 
            END as createdby,
            processedby,
            isapproved,
            reference,
            branchid,
            CASE 
                WHEN CAST(completeddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE completeddate 
            END as completeddate,
            CASE 
                WHEN CAST(adjustinaccountingsystem AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE adjustinaccountingsystem 
            END as adjustinaccountingsystem,
            adjustmentreason,
            alternativeaccountcode,
            producttotal,
            source,
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

-- Voucher
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_voucher;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_voucher(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_voucher`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_voucherstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            status,
            code,
            type,
            description,
            CASE 
                WHEN CAST(expirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expirydate 
            END as expirydate,
            amount,
            customerid,
            customeremail,
            redeemedcount,
            redeemedcountlimit,
            redeemedamount,
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

-- contactsSecContacts
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_contactsseccontacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_contactsseccontacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_contactsseccontacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_contactsseccontactsstage`');

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
            company,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            jobtitle,
            email,
            mobile,
            phone,
            contactsid,
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

-- CreditNotesLineItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_creditnoteslineitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_creditnoteslineitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_creditnoteslineitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_creditnoteslineitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            stylecode,
            barcode,
            sizecodes,
            linecomments,
            unitcost,
            unitprice,
            discount,
            qtyshipped,
            accountcode,
            creditnotesid,
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

-- BomMastersProds
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_bommastersprods;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_bommastersprods(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_bommastersprods`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_bommastersprodsstage`');

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
            productid,
            productoptionid,
            type,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            notes,
            qty,
            unitcost,
            bommastersid,
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

-- BomMastersProdComp
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_bommastersprodcomp;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_bommastersprodcomp(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_bommastersprodcomp`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_bommastersprodcompstage`');

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
            productid,
            productoptionid,
            type,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            notes,
            qty,
            unitcost,
            bommastersid,
            bommastersproductsid,
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

-- ProductionJobProds
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productionjobprods;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productionjobprods(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productionjobprods`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productionjobprodsstage`');

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
            productid,
            productoptionid,
            type,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            notes,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            standardqty,
            actualqty,
            unitcost,
            productionjobid,
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

-- ProductionJobProdComp
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productionjobprodcomp;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productionjobprodcomp(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productionjobprodcomp`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productionjobprodcompstage`');

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
            productid,
            productoptionid,
            type,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            notes,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            standardqty,
            actualqty,
            unitcost,
            productionjobid,
            productionjobproductsid,
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

-- SalesOrdersWithCartonItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_salesorderswithcartonitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_salesorderswithcartonitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_salesorderswithcartonitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_salesorderswithcartonitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            stylecode,
            barcode,
            sizecodes,
            linecomments,
            unitcost,
            unitprice,
            uomprice,
            discount,
            uomqtyordered,
            uomqtyshipped,
            uomsize,
            qtyshipped,
            holdingqty,
            accountcode,
            stockcontrol,
            stockmovements,
            sizes,
            salesorderswithcartonsid,
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

-- BranchesSecContacts
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_branchesseccontacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_branchesseccontacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_branchesseccontacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_branchesseccontactsstage`');

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
            company,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            jobtitle,
            email,
            mobile,
            phone,
            branchesid,
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

-- ProductsProductoptions
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_productsproductoptions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_productsproductoptions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_productsproductoptions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_productsproductoptionsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            status,
            productid,
            code,
            barcode,
            productoptioncode,
            productoptionsizecode,
            productoptionbarcode,
            productoptionsizebarcode,
            suppliercode,
            option1,
            option2,
            option3,
            optionweight,
            size,
            sizeid,
            retailprice,
            wholesaleprice,
            vipprice,
            specialprice,
            CASE 
                WHEN CAST(specialsstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE specialsstartdate 
            END as specialsstartdate,
            specialdays,
            stockavailable,
            stockonhand,
            uomoptions,
            imagelink,
            pricecolumnspriceaud,
            pricecolumnspricegbp,
            pricecolumnscostnzd,
            productsid,
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

-- SalesOrderItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_salesorderitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_salesorderitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_salesorderitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_salesorderitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            stylecode,
            barcode,
            sizecodes,
            linecomments,
            unitcost,
            unitprice,
            uomprice,
            discount,
            uomqtyordered,
            uomqtyshipped,
            uomsize,
            qtyshipped,
            holdingqty,
            accountcode,
            stockcontrol,
            stockmovements,
            sizes,
            salesorderid,
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

-- QuotesLineitems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_quoteslineitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_quoteslineitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_quoteslineitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_quoteslineitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            stylecode,
            barcode,
            sizecodes,
            linecomments,
            unitcost,
            unitprice,
            discount,
            qtyshipped,
            holdingqty,
            quotesid,
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

-- PurchaseOrderLineItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_purchaseorderlineitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_purchaseorderlineitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_purchaseorderlineitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_purchaseorderlineitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            stylecode,
            barcode,
            sizecodes,
            linecomments,
            unitprice,
            discount,
            qtyshipped,
            holdingqty,
            accountcode,
            purchaseorderid,
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

-- BranchTransfersLineItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_branchtransferslineitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_branchtransferslineitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_branchtransferslineitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_branchtransferslineitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            id,
            qtytransferred,
            unitcost,
            sizes,
            branchtransfersid,
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

-- AdjustmentsLineItems
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_adjustmentslineitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_adjustmentslineitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_cin7_adjustmentslineitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_cin7_adjustmentslineitemsstage`');

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
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            transactionid,
            parentid,
            productid,
            productoptionid,
            integrationref,
            sort,
            code,
            name,
            option1,
            option2,
            option3,
            qty,
            qtyadjusted,
            holdingqty,
            account,
            unitcost,
            adjustmentsid,
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

-- CIN7 LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_cin7_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_cin7_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_cin7_lastrefreshdate`');

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
