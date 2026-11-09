-- SHOPIFY Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Customers
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_customers;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_customers(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_customers`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_customersstage`');

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
            email,
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
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            orderscount,
            state,
            totalspent,
            CASE 
                WHEN CAST(lastorderid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastorderid 
            END as lastorderid,
            note,
            verifiedemail,
            multipassidentifier,
            taxexempt,
            tags,
            CASE 
                WHEN CAST(lastordername AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastordername 
            END as lastordername,
            currency,
            phone,
            tax_exemptions,
            admingraphqlapiid,
            clientid,
            organisationid,
            emailmarketingconsentstate,
            emailmarketingconsentoptinlevel,
            CASE 
                WHEN CAST(emailmarketingconsentconsentupdatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE emailmarketingconsentconsentupdatedat 
            END as emailmarketingconsentconsentupdatedat,
            smsmarketingconsentstate,
            smsmarketingconsentoptinlevel,
            CASE 
                WHEN CAST(smsmarketingconsentconsentupdatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE smsmarketingconsentconsentupdatedat 
            END as smsmarketingconsentconsentupdatedat,
            smsmarketingconsentconsentcollectedfrom,
            defaultaddressid,
            defaultaddresscustomerid,
            defaultaddressfirstname,
            CASE 
                WHEN CAST(defaultaddresslastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE defaultaddresslastname 
            END as defaultaddresslastname,
            defaultaddresscompany,
            defaultaddressaddress1,
            defaultaddressaddress2,
            defaultaddresscity,
            defaultaddressprovince,
            defaultaddresscountry,
            defaultaddresszip,
            defaultaddressphone,
            defaultaddressname,
            defaultaddressprovincecode,
            defaultaddresscountrycode,
            defaultaddresscountryname,
            defaultaddressdefault,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ApplicationCharge
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_applicationcharge;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_applicationcharge(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_applicationcharge`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_applicationchargestage`');

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
            apiclientid,
            price,
            status,
            returnurl,
            test,
            externalid,
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
            currency,
            chargetype,
            decoratedreturnurl,
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

-- ApplicationCredit
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_applicationcredit;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_applicationcredit(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_applicationcredit`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_applicationcreditstage`');

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
            amount,
            description,
            test,
            currency,
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

-- RecurringApplicationCharge
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_recurringapplicationcharge;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_recurringapplicationcharge(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_recurringapplicationcharge`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_recurringapplicationchargestage`');

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
            price,
            CASE 
                WHEN CAST(billingon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billingon 
            END as billingon,
            status,
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
            CASE 
                WHEN CAST(activatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE activatedon 
            END as activatedon,
            returnurl,
            test,
            CASE 
                WHEN CAST(cancelledon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancelledon 
            END as cancelledon,
            trialdays,
            CASE 
                WHEN CAST(trialendson AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE trialendson 
            END as trialendson,
            apiclientid,
            decoratedreturnurl,
            currency,
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

-- Orders
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_orders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_orders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_orders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersstage`');

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
            admingraphqlapiid,
            appid,
            browserip,
            buyeracceptsmarketing,
            cancelreason,
            CASE 
                WHEN CAST(cancelledat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cancelledat 
            END as cancelledat,
            carttoken,
            checkoutid,
            checkouttoken,
            CASE 
                WHEN CAST(closedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE closedat 
            END as closedat,
            confirmationnumber,
            confirmed,
            contactemail,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            currency,
            currentsubtotalprice,
            current_total_additional_fees_set,
            currenttotaldiscounts,
            current_total_duties_set,
            currenttotalprice,
            currenttotaltax,
            customerlocale,
            deviceid,
            discount_codes,
            dutiesincluded,
            email,
            estimatedtaxes,
            financialstatus,
            fulfillmentstatus,
            landingsite,
            landingsiteref,
            locationid,
            merchantbusinessentityid,
            merchantofrecordappid,
            name,
            note,
            note_attributes,
            number,
            ordernumber,
            orderstatusurl,
            original_total_additional_fees_set,
            original_total_duties_set,
            payment_gateway_names,
            phone,
            ponumber,
            presentmentcurrency,
            CASE 
                WHEN CAST(processedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE processedat 
            END as processedat,
            reference,
            referringsite,
            sourceidentifier,
            sourcename,
            sourceurl,
            subtotalprice,
            tags,
            taxexempt,
            tax_lines,
            taxesincluded,
            test,
            token,
            totaldiscounts,
            totallineitemsprice,
            totaloutstanding,
            totalprice,
            totaltax,
            totaltipreceived,
            totalweight,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            userid,
            discount_applications,
            payment_terms,
            clientid,
            organisationid,
            clientdetailsacceptlanguage,
            clientdetailsbrowserheight,
            clientdetailsbrowserip,
            clientdetailsbrowserwidth,
            clientdetailssessionhash,
            clientdetailsuseragent,
            currentsubtotalpricesetshopmoney,
            currentsubtotalpricesetshopmoneyamount,
            currentsubtotalpricesetshopmoneycurrencycode,
            currentsubtotalpricesetpresentmentmoney,
            currentsubtotalpricesetpresentmentmoneyamount,
            currentsubtotalpricesetpresentmentmoneycurrcode,
            currenttotaldiscountssetshopmoney,
            currenttotaldiscountssetshopmoneyamount,
            currenttotaldiscountssetshopmoneycurrencycode,
            currenttotaldiscountssetpresentmentmoney,
            currenttotaldiscountssetpresentmentmoneyamount,
            currenttotaldiscountssetpresentmentmoneycurrcode,
            currenttotalpricesetshopmoney,
            currenttotalpricesetshopmoneyamount,
            currenttotalpricesetshopmoneycurrencycode,
            currenttotalpricesetpresentmentmoney,
            currenttotalpricesetpresentmentmoneyamount,
            currenttotalpricesetpresentmentmoneycurrcode,
            currenttotaltaxsetshopmoney,
            currenttotaltaxsetshopmoneyamount,
            currenttotaltaxsetshopmoneycurrencycode,
            currenttotaltaxsetpresentmentmoney,
            currenttotaltaxsetpresentmentmoneyamount,
            currenttotaltaxsetpresentmentmoneycurrencycode,
            subtotalpricesetshopmoney,
            subtotalpricesetshopmoneyamount,
            subtotalpricesetshopmoneycurrencycode,
            subtotalpricesetpresentmentmoney,
            subtotalpricesetpresentmentmoneyamount,
            subtotalpricesetpresentmentmoneycurrencycode,
            totalcashroundingpaymentadjsetshopmoney,
            totalcashroundingpaymentadjsetshopmoneyamount,
            totalcashroundingpaymentadjsetshopmoneycurrcode,
            totalcashroundingpaymentadjsetpresentmentmoney,
            totalcashroundingpaymentadjsetpresentmentmoneyamt,
            totalcashroundingpaymentadjsetpresentmentmoneycurrcode,
            totalcashroundingrefundadjustmentsetshopmoney,
            totalcashroundingrefundadjsetshopmoneyamount,
            totalcashroundingrefundadjsetshopmoneycurrcode,
            totalcashroundingrefundadjsetpresentmentmoney,
            totalcashroundingrefundadjsetpresentmentmoneyamt,
            totalcashroundingrefundadjsetpresentmentmoneycurrcode,
            totaldiscountssetshopmoney,
            totaldiscountssetshopmoneyamount,
            totaldiscountssetshopmoneycurrencycode,
            totaldiscountssetpresentmentmoney,
            totaldiscountssetpresentmentmoneyamount,
            totaldiscountssetpresentmentmoneycurrencycode,
            totallineitemspricesetshopmoney,
            totallineitemspricesetshopmoneyamount,
            totallineitemspricesetshopmoneycurrencycode,
            totallineitemspricesetpresentmentmoney,
            totallineitemspricesetpresentmentmoneyamount,
            totallineitemspricesetpresentmentmoneycurrcode,
            totalpricesetshopmoney,
            totalpricesetshopmoneyamount,
            totalpricesetshopmoneycurrencycode,
            totalpricesetpresentmentmoney,
            totalpricesetpresentmentmoneyamount,
            totalpricesetpresentmentmoneycurrencycode,
            totalshippingpricesetshopmoney,
            totalshippingpricesetshopmoneyamount,
            totalshippingpricesetshopmoneycurrencycode,
            totalshippingpricesetpresentmentmoney,
            totalshippingpricesetpresentmentmoneyamount,
            totalshippingpricesetpresentmentmoneycurrcode,
            totaltaxsetshopmoney,
            totaltaxsetshopmoneyamount,
            totaltaxsetshopmoneycurrencycode,
            totaltaxsetpresentmentmoney,
            totaltaxsetpresentmentmoneyamount,
            totaltaxsetpresentmentmoneycurrencycode,
            billingaddressfirstname,
            billingaddressaddress1,
            billingaddressphone,
            billingaddresscity,
            billingaddresszip,
            billingaddressprovince,
            billingaddresscountry,
            CASE 
                WHEN CAST(billingaddresslastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE billingaddresslastname 
            END as billingaddresslastname,
            billingaddressaddress2,
            billingaddresscompany,
            billingaddresslatitude,
            billingaddresslongitude,
            billingaddressname,
            billingaddresscountrycode,
            billingaddressprovincecode,
            customerid,
            customeremail,
            CASE 
                WHEN CAST(customercreatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customercreatedat 
            END as customercreatedat,
            CASE 
                WHEN CAST(customerupdatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customerupdatedat 
            END as customerupdatedat,
            customerfirstname,
            CASE 
                WHEN CAST(customerlastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customerlastname 
            END as customerlastname,
            customerstate,
            customernote,
            customerverifiedemail,
            customermultipassidentifier,
            customertaxexempt,
            customerphone,
            customeremailmarketingconsent,
            customeremailmarketingconsentstate,
            customeremailmarketingconsentoptinlevel,
            CASE 
                WHEN CAST(customeremailmarketingconsentconsentupdatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customeremailmarketingconsentconsentupdatedat 
            END as customeremailmarketingconsentconsentupdatedat,
            customersmsmarketingconsent,
            customersmsmarketingconsentstate,
            customersmsmarketingconsentoptinlevel,
            CASE 
                WHEN CAST(customersmsmarketingconsentconsentupdatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customersmsmarketingconsentconsentupdatedat 
            END as customersmsmarketingconsentconsentupdatedat,
            customersmsmarketingconsentcollectedfrom,
            customertags,
            customercurrency,
            customertaxexemptions,
            customeradmingraphqlapiid,
            customerdefaultaddress,
            customerdefaultaddressid,
            customerdefaultaddresscustomerid,
            customerdefaultaddressfirstname,
            CASE 
                WHEN CAST(customerdefaultaddresslastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customerdefaultaddresslastname 
            END as customerdefaultaddresslastname,
            customerdefaultaddresscompany,
            customerdefaultaddressaddress1,
            customerdefaultaddressaddress2,
            customerdefaultaddresscity,
            customerdefaultaddressprovince,
            customerdefaultaddresscountry,
            customerdefaultaddresszip,
            customerdefaultaddressphone,
            customerdefaultaddressname,
            customerdefaultaddressprovincecode,
            customerdefaultaddresscountrycode,
            customerdefaultaddresscountryname,
            customerdefaultaddressdefault,
            shippingaddressfirstname,
            shippingaddressaddress1,
            shippingaddressphone,
            shippingaddresscity,
            shippingaddresszip,
            shippingaddressprovince,
            shippingaddresscountry,
            CASE 
                WHEN CAST(shippingaddresslastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE shippingaddresslastname 
            END as shippingaddresslastname,
            shippingaddressaddress2,
            shippingaddresscompany,
            shippingaddresslatitude,
            shippingaddresslongitude,
            shippingaddressname,
            shippingaddresscountrycode,
            shippingaddressprovincecode,
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
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_products;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_products(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_products`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_productsstage`');

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
            title,
            bodyhtml,
            CASE 
                WHEN CAST(vendor AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendor 
            END as vendor,
            producttype,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            handle,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            CASE 
                WHEN CAST(publishedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE publishedat 
            END as publishedat,
            templatesuffix,
            publishedscope,
            tags,
            status,
            admingraphqlapiid,
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

-- PriceRules
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_pricerules;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_pricerules(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_pricerules`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_pricerulesstage`');

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
                WHEN CAST(created_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE created_at 
            END as created_at,
            CASE 
                WHEN CAST(updated_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updated_at 
            END as updated_at,
            value_type,
            value,
            target_type,
            CASE 
                WHEN CAST(starts_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE starts_at 
            END as starts_at,
            CASE 
                WHEN CAST(ends_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE ends_at 
            END as ends_at,
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

-- DiscountCodes
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_discountcodes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_discountcodes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_discountcodes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_discountcodesstage`');

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
            price_rule_id,
            code,
            usage_count,
            CASE 
                WHEN CAST(created_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE created_at 
            END as created_at,
            CASE 
                WHEN CAST(updated_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updated_at 
            END as updated_at,
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
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_locations;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_locations(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_locations`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_locationsstage`');

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
            address1,
            address2,
            city,
            zip,
            province,
            country,
            phone,
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
            countrycode,
            countryname,
            provincecode,
            legacy,
            active,
            admingraphqlapiid,
            localizedcountryname,
            localizedprovincename,
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

-- InventoryItems
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_inventoryitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_inventoryitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_inventoryitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_inventoryitemsstage`');

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
            sku,
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
            requiresshipping,
            cost,
            countrycodeoforigin,
            provincecodeoforigin,
            harmonizedsystemcode,
            tracked,
            country_harmonized_system_codes,
            admingraphqlapiid,
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

-- Blog
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_blog;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_blog(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_blog`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_blogstage`');

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
            handle,
            title,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            commentable,
            feedburner,
            feedburnerlocation,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            templatesuffix,
            tags,
            admingraphqlapiid,
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

-- Metafield
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_metafield;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_metafield(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_metafield`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_metafieldstage`');

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
            namespace,
            `key`,
            value,
            description,
            ownerid,
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
            ownerresource,
            type,
            admingraphqlapiid,
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

-- TenderTransactions
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_tendertransactions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_tendertransactions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_tendertransactions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_tendertransactionsstage`');

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
            orderid,
            amount,
            currency,
            userid,
            test,
            CASE 
                WHEN CAST(processedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE processedat 
            END as processedat,
            remotereference,
            payment_details,
            paymentmethod,
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

-- CustomersAddr
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_customersaddr;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_customersaddr(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_customersaddr`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_customersaddrstage`');

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
            customerid,
            firstname,
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            company,
            address1,
            address2,
            city,
            province,
            country,
            zip,
            phone,
            name,
            provincecode,
            countrycode,
            countryname,
            `default`,
            customersid,
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

-- OrdersFulfl
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersfulfl;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersfulfl(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersfulfl`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersfulflstage`');

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
            admingraphqlapiid,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            locationid,
            name,
            orderid,
            receipttestcase,
            receiptauthorization,
            service,
            shipmentstatus,
            status,
            trackingcompany,
            trackingnumber,
            trackingnumbers,
            trackingurl,
            trackingurls,
            CASE 
                WHEN CAST(updatedat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE updatedat 
            END as updatedat,
            ordersid,
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

-- OrdersFulfillLinItms
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersfulfilllinitms;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersfulfilllinitms(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersfulfilllinitms`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersfulfilllinitmsstage`');

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
            admingraphqlapiid,
            attributedstaffs,
            currentquantity,
            fulfillablequantity,
            fulfillmentservice,
            fulfillmentstatus,
            giftcard,
            grams,
            name,
            price,
            pricesetshopmoney,
            pricesetshopmoneyamount,
            pricesetshopmoneycurrencycode,
            pricesetpresentmentmoney,
            pricesetpresentmentmoneyamount,
            pricesetpresentmentmoneycurrencycode,
            productexists,
            productid,
            properties,
            quantity,
            requiresshipping,
            sku,
            taxable,
            title,
            totaldiscount,
            totaldiscountsetshopmoney,
            totaldiscountsetshopmoneyamount,
            totaldiscountsetshopmoneycurrencycode,
            totaldiscountsetpresentmentmoney,
            totaldiscountsetpresentmentmoneyamount,
            totaldiscountsetpresentmentmoneycurrencycode,
            variantid,
            variantinventorymanagement,
            varianttitle,
            CASE 
                WHEN CAST(vendor AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendor 
            END as vendor,
            taxlines,
            duties,
            discountallocations,
            ordersid,
            ordersfulfillmentsid,
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

-- OrdersLine_Items
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersline_items;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersline_items(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersline_items`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersline_itemsstage`');

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
            admingraphqlapiid,
            attributedstaffs,
            currentquantity,
            fulfillablequantity,
            fulfillmentservice,
            fulfillmentstatus,
            giftcard,
            grams,
            name,
            price,
            pricesetshopmoney,
            pricesetshopmoneyamount,
            pricesetshopmoneycurrencycode,
            pricesetpresentmentmoney,
            pricesetpresentmentmoneyamount,
            pricesetpresentmentmoneycurrencycode,
            productexists,
            productid,
            properties,
            quantity,
            requiresshipping,
            sku,
            taxable,
            title,
            totaldiscount,
            totaldiscountsetshopmoney,
            totaldiscountsetshopmoneyamount,
            totaldiscountsetshopmoneycurrencycode,
            totaldiscountsetpresentmentmoney,
            totaldiscountsetpresentmentmoneyamount,
            totaldiscountsetpresentmentmoneycurrencycode,
            variantid,
            variantinventorymanagement,
            varianttitle,
            CASE 
                WHEN CAST(vendor AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE vendor 
            END as vendor,
            taxlines,
            duties,
            discountallocations,
            ordersid,
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

-- OrdersRefunds
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersrefunds;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersrefunds(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersrefunds`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersrefundsstage`');

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
            admingraphqlapiid,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            note,
            orderid,
            processedat,
            restock,
            totaladditionalfeessetshopmoney,
            totaladditionalfeessetshopmoneyamount,
            totaladditionalfeessetshopmoneycurrencycode,
            totaladditionalfeessetpresentmentmoney,
            totaladditionalfeessetpresentmentmoneyamount,
            totaladditionalfeessetpresentmentmoneycurrcode,
            totaldutiessetshopmoney,
            totaldutiessetshopmoneyamount,
            totaldutiessetshopmoneycurrencycode,
            totaldutiessetpresentmentmoney,
            totaldutiessetpresentmentmoneyamount,
            totaldutiessetpresentmentmoneycurrencycode,
            userid,
            orderadjustments,
            duties,
            additionalfees,
            ordersid,
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

-- OrdersRefTrans
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersreftrans;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersreftrans(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersreftrans`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersreftransstage`');

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
            admingraphqlapiid,
            amount,
            authorization,
            CASE 
                WHEN CAST(createdat AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdat 
            END as createdat,
            currency,
            deviceid,
            errorcode,
            gateway,
            kind,
            locationid,
            message,
            orderid,
            parentid,
            paymentid,
            processedat,
            sourcename,
            status,
            test,
            userid,
            ordersid,
            ordersrefundsid,
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

-- OrdersRefundItems
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersrefunditems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersrefunditems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersrefunditems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersrefunditemsstage`');

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
            lineitemid,
            locationid,
            quantity,
            restocktype,
            subtotal,
            subtotalsetshopmoney,
            subtotalsetshopmoneyamount,
            subtotalsetshopmoneycurrencycode,
            subtotalsetpresentmentmoney,
            subtotalsetpresentmentmoneyamount,
            subtotalsetpresentmentmoneycurrencycode,
            totaltax,
            totaltaxsetshopmoney,
            totaltaxsetshopmoneyamount,
            totaltaxsetshopmoneycurrencycode,
            totaltaxsetpresentmentmoney,
            totaltaxsetpresentmentmoneyamount,
            totaltaxsetpresentmentmoneycurrencycode,
            lineitemadmingraphqlapiid,
            lineitemattributedstaffs,
            lineitemcurrentquantity,
            lineitemfulfillablequantity,
            lineitemfulfillmentservice,
            lineitemfulfillmentstatus,
            lineitemgiftcard,
            lineitemgrams,
            lineitemname,
            lineitemprice,
            lineitempriceset,
            lineitempricesetshopmoney,
            lineitempricesetshopmoneyamount,
            lineitempricesetshopmoneycurrencycode,
            lineitempricesetpresentmentmoney,
            lineitempricesetpresentmentmoneyamount,
            lineitempricesetpresentmentmoneycurrencycode,
            lineitemproductexists,
            lineitemproductid,
            lineitemproperties,
            lineitemquantity,
            lineitemrequiresshipping,
            lineitemsku,
            lineitemtaxable,
            lineitemtitle,
            lineitemtotaldiscount,
            lineitemtotaldiscountset,
            lineitemtotaldiscountsetshopmoney,
            lineitemtotaldiscountsetshopmoneyamount,
            lineitemtotaldiscountsetshopmoneycurrencycode,
            lineitemtotaldiscountsetpresentmentmoney,
            lineitemtotaldiscountsetpresentmentmoneyamt,
            lineitemtotaldiscountsetpresentmentmoneycurrcode,
            lineitemvariantid,
            lineitemvariantinventorymanagement,
            lineitemvarianttitle,
            CASE 
                WHEN CAST(lineitemvendor AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lineitemvendor 
            END as lineitemvendor,
            lineitemtaxlines,
            lineitemduties,
            lineitemdiscountallocations,
            ordersid,
            ordersrefundsid,
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

-- OrdersShipLines
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_ordersshiplines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_ordersshiplines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_ordersshiplines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_ordersshiplinesstage`');

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
            carrieridentifier,
            code,
            discountedprice,
            discountedpricesetshopmoney,
            discountedpricesetshopmoneyamount,
            discountedpricesetshopmoneycurrencycode,
            discountedpricesetpresentmentmoney,
            discountedpricesetpresentmentmoneyamount,
            discountedpricesetpresentmentmoneycurrencycode,
            isremoved,
            phone,
            price,
            pricesetshopmoney,
            pricesetshopmoneyamount,
            pricesetshopmoneycurrencycode,
            pricesetpresentmentmoney,
            pricesetpresentmentmoneyamount,
            pricesetpresentmentmoneycurrencycode,
            requestedfulfillmentserviceid,
            source,
            title,
            taxlines,
            discountallocations,
            ordersid,
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

-- ProductsVariants
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_productsvariants;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_productsvariants(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_productsvariants`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_productsvariantsstage`');

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
            title,
            price,
            position,
            inventorypolicy,
            compareatprice,
            option1,
            option2,
            option3,
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
            taxable,
            barcode,
            fulfillmentservice,
            grams,
            inventorymanagement,
            requiresshipping,
            sku,
            weight,
            weightunit,
            inventoryitemid,
            inventoryquantity,
            oldinventoryquantity,
            presentmentprices,
            admingraphqlapiid,
            imageid,
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

-- ProductsOptions
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_productsoptions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_productsoptions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_productsoptions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_productsoptionsstage`');

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
            name,
            position,
            `values`,
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

-- ProductsImages
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_productsimages;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_productsimages(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_productsimages`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_productsimagesstage`');

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
            alt,
            position,
            productid,
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
            admingraphqlapiid,
            width,
            height,
            src,
            variantids,
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

-- ProductsImage
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_productsimage;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_productsimage(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_shopify_productsimage`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_shopify_productsimagestage`');

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
            alt,
            position,
            productid,
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
            admingraphqlapiid,
            width,
            height,
            src,
            variantids,
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

-- SHOPIFY LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_shopify_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_shopify_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_shopify_lastrefreshdate`');

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
