-- DQ_MYOBAR Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Contact
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_contact;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_contact(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_contact`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_contactstage`');

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
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            firstname,
            isindividual,
            displayid,
            isactive,
            addresses,
            notes,
            identifiers,
            customlist1,
            customlist2,
            customlist3,
            currentbalance,
            type,
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
            customfield1label,
            customfield1value,
            customfield2label,
            customfield2value,
            customfield3label,
            customfield3value,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ContactCustomer
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_contactcustomer;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_contactcustomer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_contactcustomer`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_contactcustomerstage`');

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
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            firstname,
            isindividual,
            displayid,
            isactive,
            addresses,
            currentbalance,
            sellingdetails,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
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

-- ContactSupplier
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_contactsupplier;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_contactsupplier(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_contactsupplier`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_contactsupplierstage`');

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
            companyname,
            isindividual,
            displayid,
            isactive,
            addresses,
            clientid,
            organisationid,
            buyingdetailspurchaselayout,
            buyingdetailsexpenseaccount,
            buyingdetailsexpenseaccountuid,
            buyingdetailsexpenseaccountname,
            paymentdetailsbsbnumber,
            paymentdetailsbankaccountnumber,
            paymentdetailsbankaccountname,
            paymentdetailsstatementtext,
            paymentdetailsrefund,
            paymentdetailsrefundpaymentmethod,
            paymentdetailsrefundcardnumber,
            paymentdetailsrefundnameoncard,
            paymentdetailsrefundnotes,
            paymentdetailsforeigncurrency,
            CASE 
                WHEN CAST(paymentdetailslastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paymentdetailslastmodified 
            END as paymentdetailslastmodified,
            paymentdetailsphotouri,
            paymentdetailsuri,
            paymentdetailsrowversion,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ContactEmployee
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_contactemployee;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_contactemployee(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_contactemployee`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_contactemployeestage`');

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
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            firstname,
            isindividual,
            displayid,
            isactive,
            addresses,
            uri,
            clientid,
            organisationid,
            employeepayrolldetailsuid,
            CASE 
                WHEN CAST(timebillingdetailsemployeebillingrateexcludingtax AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timebillingdetailsemployeebillingrateexcludingtax 
            END as timebillingdetailsemployeebillingrateexcludingtax,
            CASE 
                WHEN CAST(timebillingdetailscostperhour AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timebillingdetailscostperhour 
            END as timebillingdetailscostperhour,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- EmployeePayrollDetails
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_employeepayrolldetails;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_employeepayrolldetails(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_employeepayrolldetails`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_employeepayrolldetailsstage`');

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
            CASE 
                WHEN CAST(dateofbirth AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateofbirth 
            END as dateofbirth,
            CASE 
                WHEN CAST(gender AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gender 
            END as gender,
            CASE 
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            employmentbasis,
            uri,
            clientid,
            organisationid,
            employeeuid,
            employeename,
            employeedisplayid,
            employeeuri,
            wagepaybasis,
            wageannualsalary,
            wagepayfrequency,
            taxtaxfilenumber,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- EmployeePaymentDetails
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_employeepaymentdetails;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_employeepaymentdetails(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_employeepaymentdetails`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_employeepaymentdetailsstage`');

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
            paymentmethod,
            bankstatementtext,
            bankaccounts,
            uri,
            rowversion,
            clientid,
            organisationid,
            employeeuid,
            employeename,
            employeedisplayid,
            employeeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- EmployeeStandardPay
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_employeestandardpay;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_employeestandardpay(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_employeestandardpay`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_employeestandardpaystage`');

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
            payfrequency,
            hoursperpayfrequency,
            payrollcategories,
            clientid,
            organisationid,
            employeeuid,
            employeename,
            employeedisplayid,
            employeeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Personal
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_personal;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_personal(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_personal`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_personalstage`');

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
            CASE 
                WHEN CAST(lastname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastname 
            END as lastname,
            firstname,
            isindividual,
            displayid,
            isactive,
            currentbalance,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            clientid,
            organisationid,
            addressesstreet,
            addressescity,
            addressesstate,
            addressespostcode,
            addressescountry,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleInvoice
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleinvoice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleinvoice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleinvoice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleinvoicestage`');

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
            customer,
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
            invoicetype,
            shiptoaddress,
            terms,
            istaxinclusive,
            subtotal,
            totaltax,
            totalamount,
            freighttaxcode,
            category,
            salesperson,
            comment,
            shippingmethod,
            journalmemo,
            referralsource,
            orderuid,
            ordernumber,
            orderuri,
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
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
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

-- SaleCustomerPayment
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salecustomerpayment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salecustomerpayment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salecustomerpayment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salecustomerpaymentstage`');

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
            depositto,
            receiptnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amountreceived,
            paymentmethod,
            clientid,
            organisationid,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
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

-- SaleCreditRefund
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salecreditrefund;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salecreditrefund(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salecreditrefund`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salecreditrefundstage`');

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
            payee,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amount,
            memo,
            chequeprinted,
            deliverystatus,
            foreigncurrency,
            uri,
            rowversion,
            clientid,
            organisationid,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            invoiceuid,
            invoicenumber,
            invoiceuri,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleCreditSettlement
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salecreditsettlement;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salecreditsettlement(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salecreditsettlement`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salecreditsettlementstage`');

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
            creditamount,
            memo,
            foreigncurrencyuid,
            foreigncurrencycode,
            foreigncurrencycurrencyname,
            foreigncurrencyuri,
            uri,
            rowversion,
            clientid,
            organisationid,
            creditfrominvoiceuid,
            creditfrominvoicenumber,
            creditfrominvoiceuri,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleOrder
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_saleorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_saleorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_saleorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_saleorderstage`');

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
            subtotal,
            totalamount,
            status,
            ordertype,
            uri,
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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SaleQuote
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salequote;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salequote(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salequote`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salequotestage`');

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
            subtotal,
            freight,
            totaltax,
            totalamount,
            category,
            salesperson,
            journalmemo,
            referralsource,
            CASE 
                WHEN CAST(balancedueamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balancedueamount 
            END as balancedueamount,
            quotetype,
            foreigncurrency,
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

-- PurchaseBill
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasebill;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasebill(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasebill`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasebillstage`');

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
            billtype,
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
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
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

-- PurchaseOrder
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchaseorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchaseorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchaseorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchaseorderstage`');

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
            totalamount,
            status,
            ordertype,
            uri,
            clientid,
            organisationid,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseSupplierPayment
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasesupplierpayment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasesupplierpayment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasesupplierpayment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasesupplierpaymentstage`');

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
            payfrom,
            paymentnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amountpaid,
            clientid,
            organisationid,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseDebitRefund
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasedebitrefund;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasedebitrefund(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasedebitrefund`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasedebitrefundstage`');

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
            depositto,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amount,
            memo,
            paymentmethod,
            foreigncurrency,
            uri,
            rowversion,
            clientid,
            organisationid,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            billuid,
            billnumber,
            billuri,
            supplieruid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseDebitSettlement
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasedebitsettlement;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasedebitsettlement(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasedebitsettlement`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasedebitsettlementstage`');

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
            debitfrombilluid,
            debitfrombillnumber,
            debitfrombilluri,
            supplierluid,
            suppliername,
            supplierdisplayid,
            supplieruri,
            number,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            debitamount,
            memo,
            foreigncurrencyuid,
            foreigncurrencycode,
            foreigncurrencycurrencyname,
            foreigncurrencyuri,
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

-- Account
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_account;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_account(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_account`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_accountstage`');

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
            displayid,
            classification,
            type,
            number,
            description,
            isactive,
            level,
            openingbalance,
            currentbalance,
            isheader,
            CASE 
                WHEN CAST(lastreconcileddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastreconcileddate 
            END as lastreconcileddate,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            parentaccountuid,
            parentaccountname,
            parentaccountdisplayid,
            parentaccounturi,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            bankingdetailsbsbnumber,
            bankingdetailsbankaccountnumber,
            bankingdetailsbankaccountname,
            foreigncurrencycode,
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

-- AccountBudget
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_accountbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_accountbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_accountbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_accountbudgetstage`');

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
            financialyear,
            CASE 
                WHEN CAST(lastmonthinfinancialyear AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmonthinfinancialyear 
            END as lastmonthinfinancialyear,
            budgets,
            uri,
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

-- AccountingPro
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_accountingpro;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_accountingpro(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_accountingpro`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_accountingprostage`');

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
                WHEN CAST(conversiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE conversiondate 
            END as conversiondate,
            currentfinancialyear,
            CASE 
                WHEN CAST(lastmonthfinancialyear AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmonthfinancialyear 
            END as lastmonthfinancialyear,
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

-- Job
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_job;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_job(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_job`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_jobstage`');

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
            isheader,
            name,
            description,
            percentcomplete,
            CASE 
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            CASE 
                WHEN CAST(finishdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE finishdate 
            END as finishdate,
            contact,
            manager,
            isactive,
            trackreimbursables,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            parentjobuid,
            parentjobnumber,
            parentjobname,
            parentjoburi,
            linkedcustomeruid,
            linkedcustomername,
            linkedcustomerdisplayid,
            linkedcustomeruri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AccountRegister
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_accountregister;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_accountregister(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_accountregister`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_accountregisterstage`');

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
            year,
            month,
            activity,
            adjustment,
            CASE 
                WHEN CAST(yearendactivity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendactivity 
            END as yearendactivity,
            CASE 
                WHEN CAST(yearendadjustment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendadjustment 
            END as yearendadjustment,
            unitcount,
            uri,
            rowversion,
            clientid,
            organisationid,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Category
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_category;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_category(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_category`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_categorystage`');

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
            displayid,
            name,
            description,
            isactive,
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

-- CategoryRegister
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_categoryregister;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_categoryregister(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_categoryregister`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_categoryregisterstage`');

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
            year,
            month,
            activity,
            CASE 
                WHEN CAST(yearendactivity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendactivity 
            END as yearendactivity,
            rowversion,
            clientid,
            organisationid,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Currency
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_currency;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_currency(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_currency`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_currencystage`');

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
            code,
            currencyname,
            currencyrate,
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

-- GeneralJournal
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_generaljournal;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_generaljournal(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_generaljournal`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_generaljournalstage`');

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
            displayid,
            CASE 
                WHEN CAST(dateoccurred AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoccurred 
            END as dateoccurred,
            istaxinclusive,
            memo,
            gstreportingmethod,
            CASE 
                WHEN CAST(isyearendadjustment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isyearendadjustment 
            END as isyearendadjustment,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            foreigncurrencyuid,
            foreigncurrencycode,
            foreigncurrencycurrencyname,
            foreigncurrencyuri,
            uri,
            currencyexchangerate,
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

-- JobBudget
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_jobbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_jobbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_jobbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_jobbudgetstage`');

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
            budgets,
            uri,
            rowversion,
            clientid,
            organisationid,
            jobuid,
            jobnumber,
            jobname,
            joburi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JobRegister
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_jobregister;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_jobregister(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_jobregister`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_jobregisterstage`');

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
            job,
            account,
            year,
            month,
            activity,
            CASE 
                WHEN CAST(yearendactivity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendactivity 
            END as yearendactivity,
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

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- JournalTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_journaltransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_journaltransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_journaltransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_journaltransactionstage`');

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
            displayid,
            journaltype,
            sourcetransactionuid,
            sourcetransactiontransactiontype,
            sourcetransactionuri,
            CASE 
                WHEN CAST(dateoccurred AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoccurred 
            END as dateoccurred,
            CASE 
                WHEN CAST(dateposted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateposted 
            END as dateposted,
            description,
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

-- SpendMoneyTxn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_spendmoneytxn;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_spendmoneytxn(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_spendmoneytxn`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_spendmoneytxnstage`');

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
            payfrom,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            contactuid,
            contactname,
            contacttype,
            contactdisplayid,
            contacturi,
            payeeaddress,
            statementparticulars,
            statementcode,
            statementreference,
            paymentnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amountpaid,
            istaxinclusive,
            totaltax,
            memo,
            chequeprinted,
            deliverystatus,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            foreigncurrencyuid,
            foreigncurrencycode,
            foreigncurrencycurrencyname,
            foreigncurrencyuri,
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

-- ReceiveMoneyTxn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_receivemoneytxn;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_receivemoneytxn(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_receivemoneytxn`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_receivemoneytxnstage`');

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
            depositto,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            contactuid,
            contactname,
            contacttype,
            contactdisplayid,
            contacturi,
            receiptnumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amountreceived,
            istaxinclusive,
            totaltax,
            paymentmethod,
            memostring,
            categoryuid,
            categoryname,
            categorydisplayid,
            categoryuri,
            foreigncurrencyuid,
            foreigncurrencycode,
            foreigncurrencycurrencyname,
            foreigncurrencyuri,
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

-- TransferMoneyTxn
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_transfermoneytxn;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_transfermoneytxn(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_transfermoneytxn`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_transfermoneytxnstage`');

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
            uid,
            transfernumber,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            amount,
            memo,
            uri,
            rowversion,
            fromaccountuid,
            fromaccountname,
            fromaccountdisplayid,
            fromaccounturi,
            toaccountuid,
            toaccountname,
            toaccountdisplayid,
            toaccounturi,
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

-- Statement
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_statement;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_statement(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_statement`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_statementstage`');

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
            uid,
            CASE 
                WHEN CAST(statementdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE statementdate 
            END as statementdate,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            description,
            amount,
            iscredit,
            sourcetransactions,
            status,
            reference,
            uri,
            rowversion,
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- BankAccount
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_bankaccount;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_bankaccount(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_bankaccount`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_bankaccountstage`');

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
            uid,
            financialinstitution,
            bankaccountname,
            bsb,
            bankaccountnumber,
            cardname,
            cardnumber,
            account,
            banklinkstatus,
            CASE 
                WHEN CAST(lastreconcileddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastreconcileddate 
            END as lastreconcileddate,
            uri,
            rowversion,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Company
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_company;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_company(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_company`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_companystage`');

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
            companyname,
            serialnumber,
            address,
            phonenumber,
            faxnumber,
            emailaddress,
            abnortfn,
            abnbranch,
            acn,
            salestaxnumber,
            payeenumber,
            readonly,
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

-- CompanyPreferences
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_companypreferences;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_companypreferences(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_companypreferences`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_companypreferencesstage`');

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
            banking,
            sales,
            purchases,
            CASE 
                WHEN CAST(timesheets AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timesheets 
            END as timesheets,
            rowversion,
            clientid,
            organisationid,
            syscategorytracking,
            systransactionsmustbereversed,
            syslockperiodpriorto,
            sysusealphaacctidentifier,
            rptreporttaxablepayments,
            rptemaildefaults,
            rptemailsales,
            rptemailsalesinvoice,
            rptemailsalesinvsubject,
            rptemailsalesinvmessage,
            rptemailsalesinvincludenum,
            rptemailsalesorder,
            rptemailsalesordsubject,
            rptemailsalesordmessage,
            rptemailsalesordincludenum,
            rptemailsalesquote,
            rptemailsalesquotesubject,
            rptemailsalesquotemessage,
            rptemailsalesquoteincludenum,
            rptemailpurchases,
            rptemailpurchasesbill,
            rptemailpurchbillsubject,
            rptemailpurchbillmessage,
            rptemailpurchbillincludenum,
            rptemailpurchasesorder,
            rptemailpurchordsubject,
            rptemailpurchordmessage,
            rptemailpurchordincludenum,
            rptemailpurchasesquote,
            rptemailpurchquotesubject,
            rptemailpurchquotemessage,
            rptemailpurchquoteincludenum,
            rptemailpayslips,
            rptemailpayslipssubject,
            rptemailpayslipsmessage,
            rptemailcompanyprofile,
            rptemailcompprofileenabled,
            rptemailcompprofilefromname,
            rptemailcompprofilereplyto,
            rptbanking,
            rptbankinguseundepositedfunds,
            rptsales,
            rptsalesterms,
            CASE 
                WHEN CAST(rptsalestermspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptsalestermspaymentisdue 
            END as rptsalestermspaymentisdue,
            CASE 
                WHEN CAST(rptsalestermsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptsalestermsdiscountdate 
            END as rptsalestermsdiscountdate,
            CASE 
                WHEN CAST(rptsalestermsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptsalestermsbalanceduedate 
            END as rptsalestermsbalanceduedate,
            rptsalestermsearlydiscount,
            rptsalestermslatecharge,
            rptsalestermspricelevel,
            rptsalestermstaxcode,
            rptsalestermstaxcodeuid,
            rptsalestermstaxcodecode,
            rptsalestermstaxcodeuri,
            rptsalestermsusecustomertax,
            rptsalestermsfreighttaxcode,
            rptsalesfreighttaxcodeuid,
            rptsalesfreighttaxcodecode,
            rptsalesfreighttaxcodeuri,
            rptsalestermscreditlimit,
            rptpurchases,
            rptpurchasesterms,
            CASE 
                WHEN CAST(rptpurchtermspaymentisdue AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptpurchtermspaymentisdue 
            END as rptpurchtermspaymentisdue,
            CASE 
                WHEN CAST(rptpurchtermsdiscountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptpurchtermsdiscountdate 
            END as rptpurchtermsdiscountdate,
            CASE 
                WHEN CAST(rptpurchtermsbalanceduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rptpurchtermsbalanceduedate 
            END as rptpurchtermsbalanceduedate,
            rptpurchtermsearlydiscount,
            rptpurchtermstaxcode,
            rptpurchtermstaxcodeuid,
            rptpurchtermstaxcodecode,
            rptpurchtermstaxcodeuri,
            rptpurchtermsusesuppliertax,
            rptpurchtermsfreighttaxcode,
            rptpurchfreighttaxcodeuid,
            rptpurchfreighttaxcodecode,
            rptpurchfreighttaxcodeuri,
            rptpurchtermscreditlimit,
            CASE 
                WHEN CAST(rpttimesheets AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rpttimesheets 
            END as rpttimesheets,
            CASE 
                WHEN CAST(rpttimesheetsusefor AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rpttimesheetsusefor 
            END as rpttimesheetsusefor,
            CASE 
                WHEN CAST(rpttimesheetsweekstart AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rpttimesheetsweekstart 
            END as rpttimesheetsweekstart,
            rptrowversion,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ProfitAndLossSummary
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_profitandlosssummary;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_profitandlosssummary(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_profitandlosssummary`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_profitandlosssummarystage`');

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
            CASE 
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            CASE 
                WHEN CAST(enddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE enddate 
            END as enddate,
            reportingbasis,
            CASE 
                WHEN CAST(yearendadjust AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendadjust 
            END as yearendadjust,
            taxcodebreakdown,
            uri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- BalanceSheetSummary
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_balancesheetsummary;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_balancesheetsummary(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_balancesheetsummary`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_balancesheetsummarystage`');

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
            CASE 
                WHEN CAST(asofdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE asofdate 
            END as asofdate,
            CASE 
                WHEN CAST(yearendadjust AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE yearendadjust 
            END as yearendadjust,
            reportingbasis,
            accountsbreakdown,
            uri,
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

-- PayrollCategory
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_payrollcategory;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_payrollcategory(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_payrollcategory`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_payrollcategorystage`');

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
            hourlydetails,
            printonpayadvice,
            carryentitlementovertonextyear,
            calculationbasis,
            linkedpayrollcategorywages,
            exemptions,
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

-- SuperannuationFund
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_superannuationfund;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_superannuationfund(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_superannuationfund`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_superannuationfundstage`');

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
            employermembershipnumber,
            phonenumber,
            website,
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

-- Timesheet
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_timesheet;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_timesheet(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_timesheet`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_timesheetstage`');

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
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            CASE 
                WHEN CAST(enddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE enddate 
            END as enddate,
            `lines`,
            uri,
            clientid,
            organisationid,
            employeeuid,
            employeename,
            employeedisplayid,
            employeeuri,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Activity
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_activity;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_activity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_activity`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_activitystage`');

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
            displayid,
            name,
            description,
            isactive,
            type,
            unitofmeasurement,
            status,
            CASE 
                WHEN CAST(lastmodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodified 
            END as lastmodified,
            uri,
            rowversion,
            clientid,
            organisationid,
            chargeabledetailsusedescriptiononsales,
            chargeabledetailsincomeaccount,
            chargeabledetailsincomeaccountuid,
            chargeabledetailsincomeaccountname,
            chargeabledetailsincomeaccountdisplayid,
            chargeabledetailsincomeaccounturi,
            chargeabledetailstaxcode,
            chargeabledetailstaxcodeuid,
            chargeabledetailstaxcodecode,
            chargeabledetailstaxcodeuri,
            chargeabledetailsrate,
            chargeabledetailsactivityrateexcludingtax,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ActivitySlip
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_activityslip;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_activityslip(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_activityslip`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_activityslipstage`');

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
            displayid,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            CASE 
                WHEN CAST(isinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isinvoiced 
            END as isinvoiced,
            memo,
            quantity,
            duration,
            notes,
            uri,
            rowversion,
            clientid,
            organisationid,
            provideruid,
            providername,
            providertype,
            providerdisplayid,
            provideruri,
            customeruid,
            customername,
            customerdisplayid,
            customeruri,
            activityuid,
            activityname,
            CASE 
                WHEN CAST(activityuri AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE activityuri 
            END as activityuri,
            jobuid,
            jobnumber,
            jobname,
            joburi,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrentUser
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_currentuser;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_currentuser(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_currentuser`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_currentuserstage`');

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
            useraccess,
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

-- CustomerPymtInv
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_customerpymtinv;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_customerpymtinv(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_customerpymtinv`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_customerpymtinvstage`');

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
            number,
            uid,
            amountapplied,
            type,
            salecustomerpaymentid,
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

-- SaleCreditSettlementLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_salecreditsettlementlines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_salecreditsettlementlines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_salecreditsettlementlines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_salecreditsettlementlinesstage`');

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
            type,
            saleuid,
            salenumber,
            saleuri,
            amountapplied,
            salecreditsettlementid,
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

-- PurDebitSettleLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purdebitsettlelines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purdebitsettlelines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purdebitsettlelines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purdebitsettlelinesstage`');

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
            type,
            purchaseuid,
            purchasenumber,
            purchaseuri,
            amountapplied,
            purchasedebitsettlementid,
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

-- GeneralJournalLns
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_generaljournallns;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_generaljournallns(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_generaljournallns`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_generaljournallnsstage`');

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
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            jobuid,
            jobname,
            jobnumber,
            joburi,
            memo,
            taxcodeuid,
            taxcodecode,
            taxcodeuri,
            amount,
            amountforeign,
            iscredit,
            taxamount,
            taxamountforeign,
            isoverriddentaxamount,
            unitcount,
            rowversion,
            generaljournalid,
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

-- PurchaseSupPayLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_purchasesuppaylines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_purchasesuppaylines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_purchasesuppaylines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_purchasesuppaylinesstage`');

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
            purchaseuid,
            purchasenumber,
            purchaseuri,
            amountapplied,
            amountappliedforeign,
            rowversion,
            purchasesupplierpaymentid,
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

-- ReceiveMoneyTxnLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_receivemoneytxnlines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_receivemoneytxnlines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_receivemoneytxnlines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_receivemoneytxnlinesstage`');

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
            memo,
            amount,
            unitcount,
            rowversion,
            receivemoneytxnid,
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

-- SpendMoneyTxnLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_spendmoneytxnlines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_spendmoneytxnlines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_spendmoneytxnlines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_spendmoneytxnlinesstage`');

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
            memo,
            amount,
            unitcount,
            rowversion,
            CASE 
                WHEN CAST(spendmoneytxnid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE spendmoneytxnid 
            END as spendmoneytxnid,
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

-- JournalTransactionLines
DROP PROCEDURE IF EXISTS sp_dynamic_dq_myobar_journaltransactionlines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_dq_myobar_journaltransactionlines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_dq_myobar_journaltransactionlines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_dq_myobar_journaltransactionlinesstage`');

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
            accountuid,
            accountname,
            accountdisplayid,
            accounturi,
            jobuid,
            jobnumber,
            jobname,
            joburi,
            amount,
            iscredit,
            unitcount,
            linedescription,
            CASE 
                WHEN CAST(reconcileddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE reconcileddate 
            END as reconcileddate,
            uri,
            rowversion,
            journaltransactionid,
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
