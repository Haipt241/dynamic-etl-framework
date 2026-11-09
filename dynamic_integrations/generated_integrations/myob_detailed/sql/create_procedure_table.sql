-- DQ_MYOBAR Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- InventoryItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventoryitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventoryitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventoryitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventoryitemstage`');

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
            uid,
            number,
            name,
            isactive,
            description,
            usedescription,
            customlist1,
            customlist2,
            customlist3,
            customfield1,
            customfield2,
            customfield3,
            quantityonhand,
            quantitycommitted,
            quantityonorder,
            quantityavailable,
            averagecost,
            currentvalue,
            basesellingprice,
            isbought,
            issold,
            isinventoried,
            expenseaccount,
            locationdetails,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            photouri,
            uri,
            rowversion,
            clientid,
            organisationid,
            costofsalesaccountuid,
            costofsalesaccountname,
            costofsalesaccountdisplayid,
            costofsalesaccounturi,
            incomeaccountuid,
            incomeaccountname,
            incomeaccountdisplayid,
            incomeaccounturi,
            assetaccountuid,
            assetaccountname,
            assetaccountdisplayid,
            assetaccounturi,
            CASE 
                WHEN CAST(buyingdetailslastpurchaseprice AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE buyingdetailslastpurchaseprice 
            END as buyingdetailslastpurchaseprice,
            buyingdetailsstandardcost,
            buyingdetailsbuyingunitofmeasure,
            buyingdetailsitemsperbuyingunit,
            buyingdetailstaxcode,
            buyingdetailstaxcodeuid,
            buyingdetailstaxcodecode,
            buyingdetailstaxcodeuri,
            buyingdetailsrestockinginformation,
            buyingdetailsrestockinginformationminimumlevelforrestockingalert,
            buyingdetailsrestockinginformationsupplier,
            buyingdetailsrestockinginformationsupplieruid,
            buyingdetailsrestockinginformationsuppliername,
            buyingdetailsrestockinginformationsupplierdisplayid,
            buyingdetailsrestockinginformationsupplieruri,
            buyingdetailsrestockinginformationsupplieritemnumber,
            buyingdetailsrestockinginformationdefaultorderquantity,
            buyingdetailsstandardcosttaxinclusive,
            sellingdetailsbasesellingprice,
            sellingdetailssellingunitofmeasure,
            sellingdetailsitemsperbuyingunit,
            sellingdetailstaxcode,
            sellingdetailstaxcodeuid,
            sellingdetailstaxcodecode,
            sellingdetailstaxcodeuri,
            sellingdetailsistaxinclusive,
            sellingdetailscalculatesalestaxon,
            sellingdetailspricematrixuri,
            defaultselllocationuid,
            defaultselllocationidentifier,
            defaultselllocationname,
            defaultselllocationuri,
            defaultreceivelocationuid,
            defaultreceivelocationidentifier,
            defaultreceivelocationname,
            defaultreceivelocationuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ItemPriceMatrix
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_itempricematrix;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_itempricematrix(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_itempricematrix`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_itempricematrixstage`');

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
            uid,
            sellingprices,
            uri,
            rowversion,
            clientid,
            organisationid,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PriceLevelDetail
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_priceleveldetail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_priceleveldetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_priceleveldetail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_priceleveldetailstage`');

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
            name,
            value,
            rowversion,
            nextpagelink,
            count,
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

-- InventoryAdjustment
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventoryadjustment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventoryadjustment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventoryadjustment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventoryadjustmentstage`');

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
            uid,
            inventoryjournalnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            CASE 
                WHEN CAST(isyearendadjustment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isyearendadjustment 
            END as isyearendadjustment,
            memo,
            clientid,
            organisationid,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- InventoryLocation
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventorylocation;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventorylocation(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventorylocation`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventorylocationstage`');

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
            uid,
            identifier,
            name,
            isactive,
            cansell,
            notes,
            uri,
            rowversion,
            clientid,
            organisationid,
            addressstreet,
            addresscity,
            addressstate,
            addresspostcode,
            addresscountry,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- InventoryBuild
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventorybuild;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventorybuild(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventorybuild`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventorybuildstage`');

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
            uid,
            inventoryjournalnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            memo,
            uri,
            rowversion,
            clientid,
            organisationid,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleInvoiceItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoiceitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoiceitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoiceitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoiceitemstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            `lines`,
            shiptoaddress,
            istaxinclusive,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            salesperson,
            comment,
            shippingmethod,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(invoicedeliverystatus AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedeliverystatus 
            END as invoicedeliverystatus,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            canapplysurcharge,
            `order`,
            onlinepaymentmethod,
            foreigncurrency,
            currencyexchangerate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            termsfinancechargeforeign,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleInvoiceService
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoiceservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoiceservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoiceservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoiceservicestage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            `lines`,
            shiptoaddress,
            istaxinclusive,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            comment,
            shippingmethod,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(invoicedeliverystatus AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedeliverystatus 
            END as invoicedeliverystatus,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            canapplysurcharge,
            onlinepaymentmethod,
            foreigncurrency,
            currencyexchangerate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            termsfinancechargeforeign,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            orderuid,
            ordernumber,
            orderuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleInvoiceProfessional
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoiceprofessional;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoiceprofessional(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoiceprofessional`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoiceprofessionalstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            `lines`,
            istaxinclusive,
            subtotal,
            totaltax,
            totalamount,
            comment,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(invoicedeliverystatus AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedeliverystatus 
            END as invoicedeliverystatus,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            canapplysurcharge,
            `order`,
            onlinepaymentmethod,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleInvoiceTimeBilling
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoicetimebilling;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoicetimebilling(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoicetimebilling`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoicetimebillingstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            shiptoaddress,
            istaxinclusive,
            subtotal,
            freight,
            totaltax,
            totalamount,
            comment,
            shippingmethod,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(invoicedeliverystatus AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedeliverystatus 
            END as invoicedeliverystatus,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            canapplysurcharge,
            `order`,
            onlinepaymentmethod,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
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

-- SaleInvoiceMiscellaneous
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoicemiscellaneous;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoicemiscellaneous(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoicemiscellaneous`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoicemiscellaneousstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            `lines`,
            istaxinclusive,
            subtotal,
            totaltax,
            totalamount,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            canapplysurcharge,
            `order`,
            onlinepaymentmethod,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrderItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorderitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorderitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorderitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderitemstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            salesperson,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            currencyexchangerate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            termsfinancechargeforeign,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrderService
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorderservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorderservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorderservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderservicestage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            currencyexchangerate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            termsfinancechargeforeign,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrderProfessional
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorderprofessional;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorderprofessional(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorderprofessional`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderprofessionalstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            comment,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrderTimeBilling
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleordertimebilling;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleordertimebilling(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleordertimebilling`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleordertimebillingstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            freight,
            totaltax,
            totalamount,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrderMiscellaneous
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleordermiscellaneous;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleordermiscellaneous(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleordermiscellaneous`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleordermiscellaneousstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleQuoteMiscellaneous
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequotemiscellaneous;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequotemiscellaneous(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequotemiscellaneous`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotemiscellaneousstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            comment,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleQuoteTimeBilling
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequotetimebilling;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequotetimebilling(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequotetimebilling`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotetimebillingstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            freight,
            totaltax,
            totalamount,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleQuoteProfessional
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteprofessional;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteprofessional(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteprofessional`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteprofessionalstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            comment,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            salespersonuid,
            salespersonname,
            salespersondisplayid,
            salespersonuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleQuoteService
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteservicestage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            freight,
            totaltax,
            totalamount,
            category,
            salesperson,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            foreigncurrency,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
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

-- SaleQuoteItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteitemstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            shiptoaddress,
            customerpurchaseordernumber,
            istaxinclusive,
            `lines`,
            subtotal,
            freight,
            totaltax,
            totalamount,
            salesperson,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            deliverystatus,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            foreigncurrency,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            termsfinancecharge,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseBillItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillitemstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            `lines`,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            category,
            comment,
            shippingmethod,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            journalmemo,
            billdeliverystatus,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            currencyexchangerate,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            orderuid,
            ordernumber,
            orderuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseBillService
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillservicestage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            `lines`,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            category,
            comment,
            shippingmethod,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            journalmemo,
            billdeliverystatus,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            `order`,
            foreigncurrency,
            currencyexchangerate,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseBillProfessional
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillprofessional;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillprofessional(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillprofessional`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillprofessionalstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            istaxinclusive,
            isreportable,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            category,
            comment,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            journalmemo,
            billdeliverystatus,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            `order`,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseBillMiscellaneous
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillmiscellaneous;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillmiscellaneous(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillmiscellaneous`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillmiscellaneousstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            istaxinclusive,
            isreportable,
            `lines`,
            subtotal,
            totaltax,
            totalamount,
            category,
            journalmemo,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            `order`,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            termsmonthlychargeforlatepayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderItem
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorderitem;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorderitem(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorderitem`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderitemstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            category,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            orderdeliverystatus,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            currencyexchangerate,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderService
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorderservice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorderservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorderservice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderservicestage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            subtotal,
            subtotalforeign,
            freight,
            freightforeign,
            totaltax,
            totaltaxforeign,
            totalamount,
            totalamountforeign,
            category,
            comment,
            shippingmethod,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(appliedtodateforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodateforeign 
            END as appliedtodateforeign,
            orderdeliverystatus,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            CASE 
                WHEN CAST(balancedueamountforeign AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamountforeign 
            END as balancedueamountforeign,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            currencyexchangerate,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            termsdiscountforeign,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            freighttaxcodeuid,
            freighttaxcodecode,
            freighttaxcodeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderProfessional
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorderprofessional;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorderprofessional(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorderprofessional`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderprofessionalstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            subtotal,
            totaltax,
            totalamount,
            category,
            comment,
            journalmemo,
            CASE 
                WHEN CAST(promiseddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE promiseddate 
            END as promiseddate,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            orderdeliverystatus,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurOrderMisc
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purordermisc;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purordermisc(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purordermisc`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purordermiscstage`');

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
            uid,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            supplierinvoicenumber,
            shiptoaddress,
            istaxinclusive,
            isreportable,
            subtotal,
            totaltax,
            totalamount,
            category,
            journalmemo,
            CASE 
                WHEN CAST(appliedtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE appliedtodate 
            END as appliedtodate,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            status,
            CASE 
                WHEN CAST(lastpaymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastpaymentdate 
            END as lastpaymentdate,
            foreigncurrency,
            uri,
            rowversion,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            CASE 
                WHEN CAST(termspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termspaymentisdue 
            END as termspaymentisdue,
            CASE 
                WHEN CAST(termsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountdate 
            END as termsdiscountdate,
            CASE 
                WHEN CAST(termsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsbalanceduedate 
            END as termsbalanceduedate,
            termsdiscountforearlypayment,
            CASE 
                WHEN CAST(termsdiscountexpirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsdiscountexpirydate 
            END as termsdiscountexpirydate,
            termsdiscount,
            CASE 
                WHEN CAST(termsduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE termsduedate 
            END as termsduedate,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCategoryWage
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategorywage;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategorywage(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategorywage`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategorywagestage`');

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
            uid,
            name,
            type,
            wagetype,
            stpcategory,
            overriddenwagesexpenseaccount,
            exemptions,
            uri,
            rowversion,
            clientid,
            organisationid,
            hourlydetailspayrate,
            hourlydetailsregularratemultiplier,
            hourlydetailsfixedhourlyrate,
            hourlydetailsautomaticallyadjustbaseamounts,
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

-- PayrollCatEntitle
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcatentitle;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcatentitle(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcatentitle`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcatentitlestage`');

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
            uid,
            name,
            type,
            printonpayadvice,
            stpcategory,
            carryentitlementovertonextyear,
            exemptions,
            uri,
            rowversion,
            clientid,
            organisationid,
            calculationbasistype,
            calculationbasispercentageof,
            calculationbasispayrollcategory,
            calculationbasisfixedhoursof,
            calculationbasisaccrualperiod,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCategoryDeduction
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategorydeduction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategorydeduction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategorydeduction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategorydeductionstage`');

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
            uid,
            name,
            type,
            stpcategory,
            exemptions,
            uri,
            rowversion,
            clientid,
            organisationid,
            payableaccountuid,
            payableaccountname,
            payableaccountdisplayid,
            payableaccounturi,
            calculationbasistype,
            calculationbasispercentageof,
            calculationbasispayrollcategory,
            calculationbasisfixeddollarsof,
            calculationbasisaccrualperiod,
            limittype,
            limitpercentageof,
            limitpayrollcategory,
            limitfixeddollarsof,
            limitaccrualperiod,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCategoryExpense
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategoryexpense;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategoryexpense(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategoryexpense`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategoryexpensestage`');

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
            uid,
            name,
            type,
            stpcategory,
            printonpayadvice,
            threshold,
            exemptions,
            uri,
            rowversion,
            clientid,
            organisationid,
            expenseaccountuid,
            expenseaccountname,
            expenseaccountdisplayid,
            expenseaccounturi,
            payableaccountuid,
            payableaccountname,
            payableaccountdisplayid,
            payableaccounturi,
            calculationbasistype,
            calculationbasispercentageof,
            calculationbasispayrollcategory,
            calculationbasispayrollcategoryuid,
            calculationbasispayrollcategoryname,
            calculationbasispayrollcategorytype,
            calculationbasispayrollcategoryuri,
            calculationbasisfixeddollarsof,
            calculationbasisaccrualperiod,
            limittype,
            limitpercentageof,
            limitpayrollcategory,
            limitfixeddollarsof,
            limitaccrualperiod,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCatSuper
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcatsuper;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcatsuper(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcatsuper`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcatsuperstage`');

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
            uid,
            name,
            type,
            stpcategory,
            contributiontype,
            printonpayadvice,
            exclusion,
            threshold,
            uri,
            rowversion,
            clientid,
            organisationid,
            expenseaccountuid,
            expenseaccountname,
            expenseaccountdisplayid,
            expenseaccounturi,
            payableaccountuid,
            payableaccountname,
            payableaccountdisplayid,
            payableaccounturi,
            calculationbasistype,
            calculationbasispercentageof,
            calculationbasispayrollcategory,
            calculationbasispayrollcategoryuid,
            calculationbasispayrollcategoryname,
            calculationbasispayrollcategorytype,
            calculationbasispayrollcategoryuri,
            calculationbasisfixeddollarsof,
            calculationbasisaccrualperiod,
            limittype,
            limitpercentageof,
            limitpayrollcategory,
            limitfixeddollarsof,
            limitaccrualperiod,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCategoryTax
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategorytax;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategorytax(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategorytax`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategorytaxstage`');

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
            uid,
            name,
            type,
            stpcategory,
            CASE 
                WHEN CAST(taxtablerevisiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taxtablerevisiondate 
            END as taxtablerevisiondate,
            uri,
            rowversion,
            clientid,
            organisationid,
            payableaccountuid,
            payableaccountname,
            payableaccountdisplayid,
            payableaccounturi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PayrollCategoryTaxTable
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategorytaxtable;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategorytaxtable(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategorytaxtable`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategorytaxtablestage`');

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
            uid,
            name,
            uri,
            rowversion,
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

-- InvItemLocDetails
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_invitemlocdetails;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_invitemlocdetails(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_invitemlocdetails`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_invitemlocdetailsstage`');

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
            uid,
            identifier,
            name,
            uri,
            quantityonhand,
            inventoryitemid,
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

-- InventoryAdjLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventoryadjln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventoryadjln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventoryadjln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventoryadjlnstage`');

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
            itemuid,
            itemnumber,
            itemname,
            locationuid,
            locationname,
            quantitybefore,
            quantitychange,
            quantityafter,
            unitcost,
            amount,
            memo,
            inventoryadjustmentid,
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

-- SaleInvoiceSvcLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoicesvclns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoicesvclns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoicesvclns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoicesvclnsstage`');

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
            linenumber,
            type,
            description,
            quantity,
            unitprice,
            discount,
            taxamount,
            taxcodeuid,
            taxcodecode,
            accountuid,
            accountname,
            total,
            saleinvoiceserviceid,
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

-- SaleInvTimeBillLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvtimebilllines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvtimebilllines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvtimebilllines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvtimebilllinesstage`');

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
            rowid,
            type,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            hours,
            activity,
            units,
            item,
            rate,
            description,
            total,
            job,
            taxcode,
            rowversion,
            invoiceuid,
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

-- SaleInvMiscellaneousLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvmiscellaneouslines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvmiscellaneouslines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvmiscellaneouslines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvmiscellaneouslinesstage`');

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
            invoiceuid,
            rowid,
            type,
            description,
            total,
            account,
            job,
            taxcode,
            rowversion,
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

-- SaleQuoteItemLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteitemlines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteitemlines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteitemlines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteitemlinesstage`');

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
            quoteuid,
            rowid,
            type,
            description,
            shipquantity,
            unitprice,
            unitofmeasure,
            unitcount,
            discountpercent,
            total,
            item,
            account,
            job,
            taxcode,
            rowversion,
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

-- PurchaseBillServiceLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillservicelines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillservicelines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillservicelines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillservicelinesstage`');

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
            billuid,
            rowid,
            type,
            description,
            unitprice,
            unitofmeasure,
            unitcount,
            unitpriceforeign,
            discountpercent,
            total,
            totalforeign,
            account,
            job,
            taxcode,
            rowversion,
            purchasebillserviceid,
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

-- PurBillMiscLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purbillmisclines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purbillmisclines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purbillmisclines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purbillmisclinesstage`');

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
            billuid,
            rowid,
            type,
            description,
            total,
            account,
            job,
            taxcode,
            rowversion,
            purchasebillmiscellaneousid,
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

-- InventoryBldLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_inventorybldlns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_inventorybldlns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_inventorybldlns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_inventorybldlnsstage`');

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
            rowid,
            quantity,
            unitcost,
            amount,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            memo,
            locationuid,
            locationidentifier,
            locationname,
            locationuri,
            rowversion,
            inventorybuildid,
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

-- SaleInvoiceItmLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoiceitmlns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoiceitmlns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoiceitmlns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoiceitmlnsstage`');

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
            rowid,
            type,
            description,
            shipquantity,
            unitprice,
            unitofmeasure,
            unitcount,
            unitpriceforeign,
            discountpercent,
            costofgoodssold,
            total,
            totalforeign,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            account,
            locationuid,
            locationidentifier,
            locationname,
            locationuri,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            saleinvoiceitemid,
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

-- SaleInvoiceProfLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoiceproflines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoiceproflines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoiceproflines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoiceproflinesstage`');

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
            rowid,
            type,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            jobuid,
            jobnumber,
            jobname,
            joburi,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            saleinvoiceprofessionalid,
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

-- SaleOrderItmLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorderitmlns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorderitmlns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorderitmlns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderitmlnsstage`');

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
            rowid,
            type,
            description,
            shipquantity,
            unitprice,
            unitpriceforeign,
            discountpercent,
            total,
            totalforeign,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            locationuid,
            locationidentifier,
            locationname,
            locationuri,
            rowversion,
            saleorderitemid,
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

-- SaleOrderSvcLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleordersvcln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleordersvcln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleordersvcln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleordersvclnstage`');

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
            rowid,
            type,
            description,
            rowversion,
            saleorderserviceid,
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

-- SaleOrderProfLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorderprofln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorderprofln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorderprofln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderproflnstage`');

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
            rowid,
            type,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            saleorderprofessionalid,
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

-- SaleOrderTmBillLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleordertmbillln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleordertmbillln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleordertmbillln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleordertmbilllnstage`');

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
            rowid,
            type,
            description,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            hours,
            activityuid,
            activityname,
            CASE 
                WHEN CAST(activityuri AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE activityuri 
            END as activityuri,
            units,
            item,
            rate,
            total,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            CASE 
                WHEN CAST(saleordertimebillingid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE saleordertimebillingid 
            END as saleordertimebillingid,
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

-- SaleOrderMiscLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleordermiscln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleordermiscln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleordermiscln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleordermisclnstage`');

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
            rowid,
            type,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            saleordermiscellaneousid,
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

-- SaleQuoteMiscLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequotemisclines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequotemisclines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequotemisclines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotemisclinesstage`');

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
            rowid,
            type,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            salequotemiscellaneousid,
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

-- SaleQuoteTimeBillLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequotetimebillln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequotetimebillln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequotetimebillln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotetimebilllnstage`');

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
            rowid,
            type,
            description,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            hours,
            activityuid,
            activityname,
            CASE 
                WHEN CAST(activityuri AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE activityuri 
            END as activityuri,
            units,
            item,
            rate,
            total,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            CASE 
                WHEN CAST(salequotetimebillingid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE salequotetimebillingid 
            END as salequotetimebillingid,
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

-- SaleQuoteProfLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteprofln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteprofln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteprofln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteproflnstage`');

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
            rowid,
            type,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            salequoteprofessionalid,
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

-- SaleQuoteSvcLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequotesvcln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequotesvcln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequotesvcln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotesvclnstage`');

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
            rowid,
            type,
            description,
            rowversion,
            salequoteserviceid,
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

-- SaleQuoteItmLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequoteitmlns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequoteitmlns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequoteitmlns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequoteitmlnsstage`');

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
            rowid,
            type,
            description,
            shipquantity,
            unitprice,
            unitofmeasure,
            unitcount,
            discountpercent,
            total,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            account,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            salequoteitemid,
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

-- PurchaseBillItmLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillitmln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillitmln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillitmln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillitmlnstage`');

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
            rowid,
            type,
            description,
            billquantity,
            receivedquantity,
            backorderquantity,
            total,
            totalforeign,
            unitprice,
            unitofmeasure,
            unitcount,
            unitpriceforeign,
            job,
            discountpercent,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            account,
            locationuid,
            locationidentifier,
            locationname,
            locationuri,
            rowversion,
            purchasebillitemid,
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

-- PurchaseBillProfLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebillprofln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebillprofln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebillprofln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillproflnstage`');

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
            rowid,
            type,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            jobuid,
            jobnumber,
            jobname,
            joburi,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            purchasebillprofessionalid,
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

-- PurchaseOrderItmLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorderitmln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorderitmln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorderitmln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderitmlnstage`');

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
            rowid,
            type,
            description,
            billquantity,
            receivedquantity,
            unitprice,
            unitpriceforeign,
            discountpercent,
            total,
            totalforeign,
            itemuid,
            itemnumber,
            itemname,
            itemuri,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            locationuid,
            locationidentifier,
            locationname,
            locationuri,
            rowversion,
            purchaseorderitemid,
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

-- PurchaseOrderSvcLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseordersvcln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseordersvcln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseordersvcln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseordersvclnstage`');

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
            rowid,
            type,
            description,
            total,
            totalforeign,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            purchaseorderserviceid,
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

-- PurchaseOrderProfLn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorderprofln;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorderprofln(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorderprofln`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderproflnstage`');

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
            rowid,
            type,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            purchaseorderprofessionalid,
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

-- PurchaseOrderMiscLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseordermisclns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseordermisclns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseordermisclns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseordermisclnsstage`');

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
            rowid,
            type,
            description,
            total,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            job,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            rowversion,
            purordermiscid,
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

-- LinkedPayrollCatWages
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_linkedpayrollcatwages;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_linkedpayrollcatwages(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_linkedpayrollcatwages`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_linkedpayrollcatwagesstage`');

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
            uid,
            name,
            type,
            uri,
            payrollcatentitleid,
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

-- PayrollCatSuperExempt
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcatsuperexempt;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcatsuperexempt(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcatsuperexempt`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcatsuperexemptstage`');

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
            uid,
            name,
            type,
            uri,
            payrollcatsuperid,
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

-- DQ_MYOBAR LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_dq_myobar_lastrefreshdate`');

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
