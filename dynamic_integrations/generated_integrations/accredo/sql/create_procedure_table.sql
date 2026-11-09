-- ACCREDO Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- APBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apbudgetstage`');

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
            recno,
            creditorcode,
            creditorname,
            inactive,
            currencycode,
            creditorgroupcode,
            billtoaccountcode,
            otherpartycode,
            branchcode,
            category1,
            category2,
            departmentcode,
            yearno,
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

-- APCreditor
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apcreditor;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apcreditor(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apcreditor`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apcreditorstage`');

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
            creditorcode,
            creditorname,
            creditortype,
            creditorgroupcode,
            address1,
            address2,
            address3,
            address4,
            address5,
            postcode,
            otherpartycode,
            defaultexpensecode,
            webaddress,
            phoneno,
            phoneno2,
            phoneno3,
            currencycode,
            gstoverride,
            primarycontactid,
            billtoaccountcode,
            paymentpriority,
            paymentunit,
            paymentcount,
            paymentdayofmonth,
            discount,
            discountunit,
            discountcount,
            discountdayofmonth,
            comment,
            CASE 
                WHEN CAST(purchasesperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchasesperiodtodate 
            END as purchasesperiodtodate,
            CASE 
                WHEN CAST(purchasesyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchasesyeartodate 
            END as purchasesyeartodate,
            CASE 
                WHEN CAST(purchaseslastyear AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchaseslastyear 
            END as purchaseslastyear,
            CASE 
                WHEN CAST(discountperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountperiodtodate 
            END as discountperiodtodate,
            CASE 
                WHEN CAST(discountyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountyeartodate 
            END as discountyeartodate,
            CASE 
                WHEN CAST(discountlastyear AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountlastyear 
            END as discountlastyear,
            CASE 
                WHEN CAST(amountoflastpayment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE amountoflastpayment 
            END as amountoflastpayment,
            CASE 
                WHEN CAST(dateoflastpayment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastpayment 
            END as dateoflastpayment,
            physicaladdress1,
            physicaladdress2,
            physicaladdress3,
            physicaladdress4,
            physicaladdress5,
            physicalcountrycode,
            physicalpostcode,
            payeename,
            taxno,
            defaultpaymentmethod,
            bankaccountno,
            emailaddress,
            remittanceemail,
            orderemail,
            quoteemail,
            branchcode,
            locationcode,
            inactive,
            category1,
            category2,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            countrycode,
            CASE 
                WHEN CAST(purchasesperiodtodatebs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchasesperiodtodatebs 
            END as purchasesperiodtodatebs,
            CASE 
                WHEN CAST(purchasesyeartodatebs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchasesyeartodatebs 
            END as purchasesyeartodatebs,
            CASE 
                WHEN CAST(purchaseslastyearbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE purchaseslastyearbs 
            END as purchaseslastyearbs,
            CASE 
                WHEN CAST(discountperiodtodatebs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountperiodtodatebs 
            END as discountperiodtodatebs,
            CASE 
                WHEN CAST(discountyeartodatebs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountyeartodatebs 
            END as discountyeartodatebs,
            CASE 
                WHEN CAST(discountlastyearbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountlastyearbs 
            END as discountlastyearbs,
            bankname,
            bankreference,
            bankparticulars,
            bankaddress1,
            bankaddress2,
            bankaddress3,
            bankaddress4,
            bankaddress5,
            bankcountrycode,
            bankpostcode,
            bankidentifiercode,
            defaultcostcode,
            shipmentcostmode,
            shipmentemail,
            autoallocate,
            regimecode,
            physicallatitude,
            physicallongitude,
            latitude,
            longitude,
            CASE 
                WHEN CAST(leadtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE leadtime 
            END as leadtime,
            CASE 
                WHEN CAST(leadtimeunit AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE leadtimeunit 
            END as leadtimeunit,
            averagedaystopay,
            numberofinvoicespaid,
            totaldaystopay,
            businessno,
            einvoiceenabled,
            eshipmentenabled,
            departmentcode,
            editrevision,
            recordrevision,
            balancetotalexclfuture,
            balancetotalexclfuturebs,
            accounttype,
            gstinclusive,
            accountfile,
            accountcode,
            allowinactive,
            odataetag,
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

-- APExpenseBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apexpensebudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apexpensebudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apexpensebudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apexpensebudgetstage`');

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
            inactive,
            analysiscode,
            analysisname,
            accountclass,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            yearno,
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

-- APExpenseGroup
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apexpensegroup;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apexpensegroup(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apexpensegroup`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apexpensegroupstage`');

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
            recno,
            analysiscode,
            analysisname,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            accountclass,
            gstcode,
            analysisfilter,
            gsttype,
            jcdisbursement,
            hasregimeoverrides,
            branchcode,
            departmentcode,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
            odataetag,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- APShipmentList
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apshipmentlist;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apshipmentlist(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apshipmentlist`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apshipmentliststage`');

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
            recno,
            creditorcode,
            reference,
            comment,
            shipmentamount,
            documentid,
            documentclass,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            poststatus,
            invoicestatus,
            documenttype,
            haslinks,
            hasmemos,
            periodid,
            periodname,
            category1,
            receiptstatus,
            receiptperiodid,
            CASE 
                WHEN CAST(receiptdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE receiptdate 
            END as receiptdate,
            receiptreference,
            receiptperiodname,
            category2,
            defaultjobcode,
            creditorname,
            shipmentgross,
            CASE 
                WHEN CAST(originationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE originationdate 
            END as originationdate,
            currencycode,
            invoiceperiodid,
            invoicereference,
            invoiceperiodname,
            unallocatedamount,
            unallocatedamountbs,
            fullyallocated,
            aptransactionid,
            storepersoncode,
            jobname,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            regimecode,
            ratetype,
            branchcode,
            departmentcode,
            defaultlocationcode,
            narration,
            defaultexpensecode,
            fixedrate,
            einvoiceidentifier,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(discountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountdate 
            END as discountdate,
            manuallyapportion,
            defaultjctransactiontype,
            defaultcostcentrecode,
            defaultcomponentcode,
            custom1,
            custom2,
            costmode,
            approvalamount,
            approvaldiscount,
            holdamount,
            totalweight,
            totalvolume,
            ordernos,
            exchangerate,
            transactionamount,
            paymentdiscount,
            transactionamountbs,
            paymentdiscountbs,
            apportiontotalweight,
            apportiontotalvolume,
            apportiontotalcostbs,
            apportiontotalquantity,
            apportionweightamountbs,
            apportionvolumeamountbs,
            apportioncostamountbs,
            apportionquantityamountbs,
            apportionmanualamountbs,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            shipmentgstbs,
            shipmentamountbs,
            receiptscostbs,
            roundingamountbs,
            printstatus,
            costschanged,
            recordrevision,
            referencealpha,
            yearno,
            periodno,
            exchangerateraw,
            shipmentgrossbs,
            totaladditionalcostsbs,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- APShipments
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_apshipments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_apshipments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_apshipments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_apshipmentsstage`');

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
            recno,
            creditorcode,
            documentid,
            comment,
            documenttype,
            defaultexpensecode,
            shipmentamount,
            shipmentgst,
            transactionamount,
            paymentdiscount,
            approvalamount,
            approvaldiscount,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(discountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountdate 
            END as discountdate,
            reference,
            periodid,
            shipmentgross,
            defaultjobcode,
            defaultjctransactiontype,
            shipmentgrossbs,
            defaultcostcentrecode,
            receiptstatus,
            defaultcomponentcode,
            defaultlocationcode,
            receiptperiodid,
            CASE 
                WHEN CAST(receiptdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE receiptdate 
            END as receiptdate,
            receiptreference,
            documentclass,
            custom1,
            custom2,
            poststatus,
            ordernos,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            receiptscostbs,
            category1,
            CASE 
                WHEN CAST(originationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE originationdate 
            END as originationdate,
            category2,
            contactid,
            branchcode,
            departmentcode,
            totalweight,
            totalvolume,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            invoiceperiodid,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            invoicereference,
            transactionamountbs,
            paymentdiscountbs,
            shipmentamountbs,
            roundingamountbs,
            shipmentgstbs,
            holdamount,
            invoicestatus,
            manuallyapportion,
            costmode,
            apportiontotalweight,
            apportiontotalvolume,
            apportiontotalcostbs,
            apportiontotalquantity,
            apportionweightamountbs,
            apportionvolumeamountbs,
            apportioncostamountbs,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            apportionquantityamountbs,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            apportionmanualamountbs,
            netamount,
            recordrevision,
            netamountbs,
            totaladditionalcostsbs,
            currencycode,
            basecurrencycode,
            ratetype,
            shipmentinclusivebs,
            aptransactionid,
            totalquantity,
            printstatus,
            exchangerate,
            fixedrate,
            CASE 
                WHEN CAST(fxdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fxdate 
            END as fxdate,
            regimecode,
            storepersoncode,
            narration,
            einvoiceidentifier,
            costschanged,
            sourcedocumentid,
            accountfile,
            accountcode,
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

-- APTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_aptransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_aptransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_aptransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_aptransactionstage`');

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
            transactionid,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            creditorcode,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(discountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountdate 
            END as discountdate,
            transactionamount,
            unallocatedamount,
            unallocatedamountbs,
            unallocateddiscount,
            variationrealisedbs,
            variationunrealisedbs,
            glaccountcode,
            glaccountname,
            billfromaccountcode,
            paymentmethod,
            paymentreference,
            periodid,
            reference,
            sourcemodule,
            bankaccountcode,
            comment,
            narration,
            transactiondiscount,
            sourceid,
            branchcode,
            departmentcode,
            approvalamount,
            approvaldiscount,
            holdamount,
            CASE 
                WHEN CAST(paymentcreated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paymentcreated 
            END as paymentcreated,
            transactionamountbs,
            netamount,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            netamountbs,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(originationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE originationdate 
            END as originationdate,
            cbtransactionid,
            CASE 
                WHEN CAST(paymentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paymentdate 
            END as paymentdate,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            paymentperiodid,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            gstincluded,
            gstincludedbs,
            currencycode,
            ratetype,
            exchangerate,
            bankingextern,
            bankthrough,
            bankingratetype,
            bankingexchangerate,
            bankcharges,
            transactiondiscountbs,
            bankingcurrencycode,
            CASE 
                WHEN CAST(pendingbalancetotalbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingbalancetotalbs 
            END as pendingbalancetotalbs,
            variationbs,
            autoallocate,
            fixedrate,
            basecurrencycode,
            extern,
            transferredtogl,
            regimecode,
            bankingamount,
            payeename,
            printstatus,
            CASE 
                WHEN CAST(datefullypaid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE datefullypaid 
            END as datefullypaid,
            einvoiceidentifier,
            periodfullyallocated,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
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

-- ARBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arbudgetstage`');

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
            customercode,
            customername,
            inactive,
            currencycode,
            customergroupcode,
            billtoaccountcode,
            otherpartycode,
            salesareacode,
            salespersoncode,
            category1,
            category2,
            branchcode,
            departmentcode,
            yearno,
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

-- ARCustomer
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arcustomer;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arcustomer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arcustomer`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arcustomerstage`');

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
            recno,
            customercode,
            customername,
            customertype,
            customergroupcode,
            address1,
            address2,
            address3,
            address4,
            address5,
            postcode,
            otherpartycode,
            salespersoncode,
            webaddress,
            bankreference,
            bankparticulars,
            phoneno,
            phoneno2,
            phoneno3,
            statementstyle,
            salesareacode,
            pricecode,
            discountschedulecode,
            billtoaccountcode,
            comment,
            yearopeningbalance,
            creditlimit,
            CASE 
                WHEN CAST(amountoflastreceipt AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE amountoflastreceipt 
            END as amountoflastreceipt,
            CASE 
                WHEN CAST(dateoflastreceipt AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastreceipt 
            END as dateoflastreceipt,
            payername,
            taxno,
            backorder,
            stopcredit,
            ordernorequired,
            branchcode,
            locationcode,
            defaultdeliverycode,
            bankthrough,
            mediacode,
            statementemail,
            invoiceemail,
            packingslipemail,
            quoteemail,
            gstoverride,
            primarycontactid,
            emailaddress,
            bankaccountno,
            inactive,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            currencycode,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            category1,
            category2,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            countrycode,
            yearopeningbalancebs,
            autoallocate,
            regimecode,
            latitude,
            longitude,
            statementagingunit,
            statementagingcount,
            paymentunit,
            paymentcount,
            paymentdayofmonth,
            discount,
            discountunit,
            discountcount,
            discountdayofmonth,
            averagedaystopay,
            numberofinvoicespaid,
            totaldaystopay,
            ecreditenabled,
            departmentcode,
            businessno,
            einvoiceenabled,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
            allowinactive,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ARSalesArea
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalesarea;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalesarea(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalesarea`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalesareastage`');

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
            odataetag,
            recno,
            salesareacode,
            salesareaname,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            comment,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
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

-- ARSalesAreaBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalesareabudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalesareabudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalesareabudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalesareabudgetstage`');

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
            recno,
            inactive,
            salesareacode,
            salesareaname,
            yearno,
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

-- ARSalesGroup
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalesgroup;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalesgroup(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalesgroup`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalesgroupstage`');

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
            recno,
            analysiscode,
            analysisname,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            accountclass,
            gstcode,
            analysisfilter,
            gsttype,
            hasregimeoverrides,
            branchcode,
            departmentcode,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
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

-- ARSalesGroupBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalesgroupbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalesgroupbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalesgroupbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalesgroupbudgetstage`');

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
            recno,
            inactive,
            analysiscode,
            analysisname,
            accountclass,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            yearno,
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

-- ARSalesPerson
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalesperson;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalesperson(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalesperson`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalespersonstage`');

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
            recno,
            salespersoncode,
            salespersonname,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            comment,
            phoneno,
            phoneno2,
            phoneno3,
            emailaddress,
            role,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
            odataetag,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ARSalesPersonBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_arsalespersonbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_arsalespersonbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_arsalespersonbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_arsalespersonbudgetstage`');

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
            recno,
            inactive,
            salespersoncode,
            salespersonname,
            yearno,
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

-- ARTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_artransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_artransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_artransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_artransactionstage`');

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
            transactionid,
            customercode,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            salesareacode,
            salespersoncode,
            orderno,
            transactionamount,
            chargesamount,
            unallocatedamount,
            unallocatedamountbs,
            commissionamount,
            glaccountcode,
            variationrealisedbs,
            variationunrealisedbs,
            glaccountname,
            billfromaccountcode,
            billtooverride,
            periodid,
            sourcemodule,
            bankaccountcode,
            reference,
            comment,
            narration,
            transactiondiscount,
            sourceid,
            branchcode,
            departmentcode,
            commissionamountbs,
            unallocateddiscount,
            chargesamountbs,
            transactionamountbs,
            netamount,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            netamountbs,
            holdamount,
            cbtransactionid,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            gstincluded,
            gstincludedbs,
            currencycode,
            ratetype,
            exchangerate,
            bankingextern,
            bankthrough,
            bankingratetype,
            bankingexchangerate,
            bankcharges,
            transactiondiscountbs,
            bankingcurrencycode,
            CASE 
                WHEN CAST(pendingbalancetotalbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingbalancetotalbs 
            END as pendingbalancetotalbs,
            variationbs,
            autoallocate,
            fixedrate,
            basecurrencycode,
            stopcredit,
            creditlimit,
            extern,
            transferredtogl,
            regimecode,
            bankingamount,
            cashsale,
            internalreference,
            jobcode,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(discountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountdate 
            END as discountdate,
            CASE 
                WHEN CAST(datefullypaid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE datefullypaid 
            END as datefullypaid,
            einvoiceidentifier,
            periodfullyallocated,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
            bypasscreditlimit,
            odataetag,
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

-- CBAnalysisBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbanalysisbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbanalysisbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbanalysisbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbanalysisbudgetstage`');

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
            recno,
            inactive,
            analysiscode,
            analysisname,
            accountclass,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            yearno,
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

-- CBAutomaticPayment
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbautomaticpayment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbautomaticpayment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbautomaticpayment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbautomaticpaymentstage`');

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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CBBankAccount
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbbankaccount;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbbankaccount(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbbankaccount`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbbankaccountstage`');

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
            recno,
            bankaccountcode,
            accountno,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            nextwithdrawalno,
            nextdepositno,
            accountname,
            comment,
            CASE 
                WHEN CAST(statementdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE statementdate 
            END as statementdate,
            inactive,
            CASE 
                WHEN CAST(laststatementsequence AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE laststatementsequence 
            END as laststatementsequence,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            category1,
            category2,
            branchcode,
            departmentcode,
            currencycode,
            defaultincomecode,
            defaultexpensecode,
            webaddress,
            bankname,
            bankaddress1,
            bankaddress2,
            bankaddress3,
            bankaddress4,
            bankaddress5,
            bankcountrycode,
            bankpostcode,
            bankidentifiercode,
            registrationid,
            statementdefinitionfile,
            statementimportfile,
            matchafterimport,
            paymentdefinitionfile,
            paymentexportfile,
            CASE 
                WHEN CAST(paymentconsolidate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paymentconsolidate 
            END as paymentconsolidate,
            CASE 
                WHEN CAST(directdebitconsolidate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE directdebitconsolidate 
            END as directdebitconsolidate,
            directdebitdefinitionfile,
            directdebitexportfile,
            defaultregimecode,
            CASE 
                WHEN CAST(dateoflastimport AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastimport 
            END as dateoflastimport,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
            allowinactive,
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

-- CBBankingItems
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbbankingitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbbankingitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbbankingitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbbankingitemsstage`');

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
            itemid,
            itemtype,
            CASE 
                WHEN CAST(itemdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE itemdate 
            END as itemdate,
            transactionid,
            periodid,
            sourcemodule,
            bankingamount,
            mediacode,
            otherparty,
            reference,
            particulars,
            comment,
            bankaccountno,
            bankingamountbs,
            CASE 
                WHEN CAST(gllasttransferredbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gllasttransferredbs 
            END as gllasttransferredbs,
            gainloss,
            status,
            sourceid,
            branchcode,
            departmentcode,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            gstincluded,
            gstincludedbs,
            CASE 
                WHEN CAST(pendingbalancetotal AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingbalancetotal 
            END as pendingbalancetotal,
            currencycode,
            ratetype,
            exchangerate,
            basecurrencycode,
            extern,
            transferredtogl,
            regimecode,
            summaryid,
            lineno,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
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

-- CBExpenseCode
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbexpensecode;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbexpensecode(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbexpensecode`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbexpensecodestage`');

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
            analysiscode,
            analysisname,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            glaccountcode,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            accountclass,
            gstcode,
            analysisfilter,
            gsttype,
            jcdisbursement,
            hasregimeoverrides,
            branchcode,
            departmentcode,
            editrevision,
            recordrevision,
            accountfile,
            accountcode,
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

-- CBTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbtransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbtransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbtransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbtransactionstage`');

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
            transactionid,
            bankaccountcode,
            particulars,
            transactionamount,
            statementid,
            statementlineno,
            periodreconciled,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            periodid,
            reference,
            sourcemodule,
            otherparty,
            narration,
            comment,
            sourceid,
            branchcode,
            departmentcode,
            transactionamountbs,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            statementreference,
            transferaccountcode,
            gainloss,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            gstincluded,
            gstincludedbs,
            CASE 
                WHEN CAST(pendingbalancetotal AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingbalancetotal 
            END as pendingbalancetotal,
            currencycode,
            ratetype,
            exchangerate,
            fixedrate,
            basecurrencycode,
            extern,
            transferredtogl,
            regimecode,
            summaryid,
            reconciled,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
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

-- CBTransfer
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cbtransfer;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cbtransfer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cbtransfer`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cbtransferstage`');

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
            transactionid,
            bankaccountcode,
            currencycode,
            particulars,
            comment,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            periodid,
            reference,
            sourcemodule,
            sourceid,
            branchcode,
            departmentcode,
            gstincluded,
            gstincludedbs,
            CASE 
                WHEN CAST(pendingbalancetotal AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingbalancetotal 
            END as pendingbalancetotal,
            gainloss,
            transactionamount,
            ratetype,
            exchangerate,
            transactionamountbs,
            transferid,
            transfercurrencycode,
            transferamount,
            transferratetype,
            transferexchangerate,
            transferamountbs,
            transferstatementreference,
            statementlineno,
            statementid,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            summaryid,
            transferstatementid,
            transferextern,
            extern,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            periodreconciled,
            transferaccountcode,
            transferotherparty,
            basecurrencycode,
            otherparty,
            statementreference,
            narration,
            fixedrate,
            regimecode,
            transferredtogl,
            reconciled,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
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

-- COBranch
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_cobranch;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_cobranch(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_cobranch`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_cobranchstage`');

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
            recno,
            branchcode,
            branchname,
            address1,
            address2,
            address3,
            address4,
            address5,
            postcode,
            phoneno,
            phoneno2,
            phoneno3,
            emailaddress,
            custom1,
            custom2,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CODepartment
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_codepartment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_codepartment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_codepartment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_codepartmentstage`');

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
            departmentcode,
            departmentname,
            custom1,
            custom2,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            odataetag,
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

-- COUser
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_couser;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_couser(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_couser`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_couserstage`');

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
            etag,
            usercode,
            username,
            usertype,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            defaultsalespersoncode,
            defaultjobpersoncode,
            defaultauthorisationcode,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            usertypetext,
            smtppassword,
            recordrevision,
            permissiongroup,
            phoneno,
            phoneno2,
            phoneno3,
            imagepath,
            emailaddress,
            comment,
            details,
            imagetype,
            changepassword,
            inactive,
            custom1,
            custom2,
            defaultstorepersoncode,
            smtpserverusername,
            defaultintransitlocationcode,
            defaultlocationcode,
            defaultbranchcode,
            defaultdepartmentcode,
            accountfile,
            accountcode,
            serverusername,
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

-- FAAsset
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_faasset;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_faasset(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_faasset`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_faassetstage`');

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
            recno,
            assetcode,
            assetname,
            assetdescription,
            acquisitioncost,
            accumulateddepreciation,
            netbookvalue,
            currentvalue,
            depreciationmethod,
            depreciationrate,
            usefullifeyears,
            CASE 
                WHEN CAST(acquisitiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE acquisitiondate 
            END as acquisitiondate,
            CASE 
                WHEN CAST(depreciationstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE depreciationstartdate 
            END as depreciationstartdate,
            CASE 
                WHEN CAST(disposaldate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE disposaldate 
            END as disposaldate,
            assettype,
            assetclass,
            glaccountcode,
            costcentrecode,
            status,
            inactive,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            recordrevision,
            comment,
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

-- FATransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_fatransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_fatransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_fatransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_fatransactionstage`');

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
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- GLAccount
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_glaccount;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_glaccount(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_glaccount`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_glaccountstage`');

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
            odataetag,
            accountcode,
            accountname,
            CASE 
                WHEN CAST(friendlyaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE friendlyaccountcode 
            END as friendlyaccountcode,
            externalaccountcode,
            accounttype,
            accountclass,
            addtoaccountcode,
            posttoaccountcode,
            openingaccountcode,
            comment,
            inactive,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            category1,
            category2,
            CASE 
                WHEN CAST(consolidateaccountcode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE consolidateaccountcode 
            END as consolidateaccountcode,
            percentageaccountcode,
            alternateaccountcode,
            headingstyle,
            totalstyle,
            CASE 
                WHEN CAST(startnewpage AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startnewpage 
            END as startnewpage,
            linespacebefore,
            restricted,
            analysiscode,
            replicatear,
            replicateap,
            replicatecb,
            gstcode,
            fortotalaccountcode,
            linespaceafter,
            cashflowtype,
            cashflowdirection,
            aimcode,
            recordrevision,
            budgetcode,
            branch,
            department,
            periodactivity,
            yearactivity,
            yearbalance,
            accountfile,
            allowinactive,
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

-- GLTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_gltransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_gltransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_gltransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_gltransactionstage`');

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
            recno,
            transactionid,
            accountcode,
            periodid,
            batchid,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            branchcode,
            departmentcode,
            reference,
            comment,
            transactionamount,
            sourcemodule,
            sourceid,
            narration,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            sourcelineno,
            sourcecode,
            reconciliationid,
            reconciliationlineno,
            periodreconciled,
            recordrevision,
            yearno,
            periodno,
            referencealpha,
            reconciled,
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

-- GSTTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_gsttransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_gsttransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_gsttransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_gsttransactionstage`');

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
            transactionid,
            periodid,
            sourcemodule,
            returnid,
            currencycode,
            regimecode,
            transactionclass,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            reference,
            comment,
            narration,
            ratetype,
            exchangerate,
            fixedrate,
            transactionamount,
            transactionamountbs,
            totalamount,
            adjustmentamount,
            glaccountcode,
            glaccountname,
            branchcode,
            departmentcode,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            transferredtogl,
            transactionclasstype,
            extern,
            inactive,
            recno,
            sourcetransactionid,
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

-- ICBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_icbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_icbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_icbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_icbudgetstage`');

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
            recno,
            inactive,
            productcode,
            description,
            nondiminishing,
            alternatecode,
            baseuomcode,
            creditorcode,
            category1,
            category2,
            stockgroupcode,
            salesgroupcode,
            quantityallocated,
            yearno,
            location,
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

-- ICManufactureBatch
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_icmanufacturebatch;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_icmanufacturebatch(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_icmanufacturebatch`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_icmanufacturebatchstage`');

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
            batchid,
            periodid,
            details,
            reference,
            comment,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            storepersoncode,
            poststatus,
            printstatus,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            locationcode,
            branchcode,
            departmentcode,
            serialno,
            productcode,
            transactionquantity,
            unit,
            lotno,
            CASE 
                WHEN CAST(expirydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expirydate 
            END as expirydate,
            recno,
            accountfile,
            accountcode,
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

-- ICProduct
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_icproduct;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_icproduct(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_icproduct`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_icproductstage`');

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
            recno,
            productcode,
            description,
            details,
            alternatecode,
            unit,
            saleuomcode,
            purchaseuomcode,
            gstcode,
            discountschedulecode,
            stockgroupcode,
            salesgroupcode,
            creditorcode,
            CASE 
                WHEN CAST(leadtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE leadtime 
            END as leadtime,
            backorder,
            commissionpercentage,
            nondiminishing,
            manuallycosted,
            componentmode,
            weight,
            volume,
            comment,
            standardcost,
            latestcost,
            averagecost,
            sellingprice1,
            sellingprice2,
            sellingprice3,
            sellingprice4,
            sellingprice5,
            sellingprice6,
            sellingprice7,
            sellingprice8,
            sellingprice9,
            barcode,
            imagepath,
            inactive,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            category1,
            category2,
            duty,
            minimumquantity,
            maximumquantity,
            expensecode,
            discontinued,
            CASE 
                WHEN CAST(openingstockperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE openingstockperiodtodate 
            END as openingstockperiodtodate,
            CASE 
                WHEN CAST(salesquantityperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE salesquantityperiodtodate 
            END as salesquantityperiodtodate,
            CASE 
                WHEN CAST(receiptsperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE receiptsperiodtodate 
            END as receiptsperiodtodate,
            CASE 
                WHEN CAST(adjustmentsperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE adjustmentsperiodtodate 
            END as adjustmentsperiodtodate,
            CASE 
                WHEN CAST(usageperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE usageperiodtodate 
            END as usageperiodtodate,
            CASE 
                WHEN CAST(manufacturedperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manufacturedperiodtodate 
            END as manufacturedperiodtodate,
            CASE 
                WHEN CAST(nondiminishingperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE nondiminishingperiodtodate 
            END as nondiminishingperiodtodate,
            CASE 
                WHEN CAST(salesvalueperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE salesvalueperiodtodate 
            END as salesvalueperiodtodate,
            CASE 
                WHEN CAST(costofsalesperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE costofsalesperiodtodate 
            END as costofsalesperiodtodate,
            CASE 
                WHEN CAST(costvalueperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE costvalueperiodtodate 
            END as costvalueperiodtodate,
            CASE 
                WHEN CAST(revaluationperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE revaluationperiodtodate 
            END as revaluationperiodtodate,
            CASE 
                WHEN CAST(openingstockyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE openingstockyeartodate 
            END as openingstockyeartodate,
            CASE 
                WHEN CAST(salesquantityyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE salesquantityyeartodate 
            END as salesquantityyeartodate,
            CASE 
                WHEN CAST(receiptsyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE receiptsyeartodate 
            END as receiptsyeartodate,
            CASE 
                WHEN CAST(adjustmentsyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE adjustmentsyeartodate 
            END as adjustmentsyeartodate,
            CASE 
                WHEN CAST(usageyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE usageyeartodate 
            END as usageyeartodate,
            CASE 
                WHEN CAST(manufacturedyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manufacturedyeartodate 
            END as manufacturedyeartodate,
            CASE 
                WHEN CAST(nondiminishingyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE nondiminishingyeartodate 
            END as nondiminishingyeartodate,
            CASE 
                WHEN CAST(salesvalueyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE salesvalueyeartodate 
            END as salesvalueyeartodate,
            CASE 
                WHEN CAST(costofsalesyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE costofsalesyeartodate 
            END as costofsalesyeartodate,
            CASE 
                WHEN CAST(costvalueyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE costvalueyeartodate 
            END as costvalueyeartodate,
            CASE 
                WHEN CAST(revaluationyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE revaluationyeartodate 
            END as revaluationyeartodate,
            CASE 
                WHEN CAST(dateoflastsale AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastsale 
            END as dateoflastsale,
            CASE 
                WHEN CAST(dateoflastusage AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastusage 
            END as dateoflastusage,
            CASE 
                WHEN CAST(dateoflastreceipt AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastreceipt 
            END as dateoflastreceipt,
            CASE 
                WHEN CAST(dateoflastmanufacture AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflastmanufacture 
            END as dateoflastmanufacture,
            quantityinstock,
            stocktakevariance,
            quantityonorder,
            quantityallocated,
            quantityonbackorder,
            quantityshipped,
            quantitycommitted,
            hasparts,
            quantityreturned,
            quantitytransferin,
            quantitytransferout,
            quantityinproduction,
            hasregimeoverrides,
            imagetype,
            serialtracked,
            lottracked,
            CASE 
                WHEN CAST(expirydatetracked AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expirydatetracked 
            END as expirydatetracked,
            supplysinglelot,
            generatelotnos,
            serialnolength,
            lotnolength,
            minimumexpiryunit,
            minimumexpirycount,
            retainyearstracking,
            jctransactiontype,
            costcentrecode,
            componentcode,
            editrevision,
            CASE 
                WHEN CAST(dateoflaststocktake AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateoflaststocktake 
            END as dateoflaststocktake,
            recordrevision,
            z_cartonquantity,
            z_holesavailable,
            z_noholesavailable,
            z_lidholesavailable,
            z_clearavailable,
            z_blackavailable,
            z_colouredavailable,
            z_recyclingcode,
            z_manufacturebranchcode,
            z_approximatecapacity,
            z_trimlength,
            z_trimwidth,
            z_trimdepth,
            z_rawmaterialthickness,
            z_rawmaterialwidth,
            z_rawmaterialcolourcode,
            z_recipecode,
            z_cartoncode,
            z_finishedgoodsrequirements,
            z_packaging,
            z_quality1,
            z_quality2,
            z_quality3,
            z_quality4,
            z_quality5,
            z_quality6,
            CASE 
                WHEN CAST(closingperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE closingperiodtodate 
            END as closingperiodtodate,
            CASE 
                WHEN CAST(closingyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE closingyeartodate 
            END as closingyeartodate,
            CASE 
                WHEN CAST(marginperiodtodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE marginperiodtodate 
            END as marginperiodtodate,
            CASE 
                WHEN CAST(marginyeartodate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE marginyeartodate 
            END as marginyeartodate,
            quantityavailable,
            quantitytheoretical,
            quantityrecreorder,
            istracked,
            accountfile,
            accountcode,
            allowinactive,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ICStockGroup
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_icstockgroup;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_icstockgroup(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_icstockgroup`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_icstockgroupstage`');

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
            etag,
            stockgroupcode,
            stockgroupname,
            glstockonhandaccountcode,
            glcostofsalesaccountcode,
            glstockpurchasesaccountcode,
            glstockadjustmentsaccountcode,
            glstockwriteoffsaccountcode,
            glstockrevaluationaccountcode,
            glexpenserecoveryaccountcode,
            glclosingstockaccountcode,
            gltransferoutaccountcode,
            gltransferinaccountcode,
            inactive,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            zfinishedgoods,
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

-- ICTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_ictransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_ictransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_ictransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_ictransactionstage`');

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
            transactionid,
            odataetag,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            parentid,
            periodid,
            transactionquantity,
            productcode,
            unitcostprice,
            uomunitcostprice,
            costvalueexclusive,
            unitsellingprice,
            uomunitsellingprice,
            salesvalueexclusive,
            nondiminishing,
            jobcode,
            pricecode,
            gstcode,
            sellpricebasis,
            creditorcode,
            locationcode,
            uomcode,
            uommultiplier,
            glaccountname,
            transferlocationcode,
            uomtransactionquantity,
            sourcemodule,
            reference,
            serialno,
            sourceid,
            branchcode,
            departmentcode,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            transferredtogl,
            customercode,
            orderno,
            glaccountoverridden,
            stockgroupcode,
            sourcelineid,
            transferredvalue,
            sourcetype,
            recordrevision,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
            overridecost,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- INInvoice
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_ininvoice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_ininvoice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_ininvoice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_ininvoicestage`');

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
            documentid,
            documenttype,
            customercode,
            billtooverride,
            periodid,
            printstatus,
            sellpricebasis,
            pricecode,
            gstoverride,
            CASE 
                WHEN CAST(deliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverydate 
            END as deliverydate,
            orderno,
            packingslipno,
            packingslipcount,
            salesareacode,
            salespersoncode,
            discountschedulecode,
            internalreference,
            deliveryaddresscode,
            deliveryaddress1,
            deliveryaddress2,
            deliveryaddress3,
            deliveryaddress4,
            deliveryaddress5,
            deliverycountrycode,
            deliverypostcode,
            exclusivecost,
            exclusiveamount,
            chargesamount,
            gstamount,
            roundingamount,
            commissionamount,
            discountamount,
            discountamountbs,
            marginpercentage,
            totalvolume,
            documentno,
            totalweight,
            comment,
            defaultlocationcode,
            grossamount,
            sourceid,
            jobcost,
            jobcostbs,
            jobamount,
            jobamountbs,
            documentclass,
            poststatus,
            defaultcostcentrecode,
            sourcemodule,
            quotationreference,
            defaultcomponentcode,
            custom2,
            CASE 
                WHEN CAST(originationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE originationdate 
            END as originationdate,
            defaultjobcode,
            custom1,
            defaultjctransactiontype,
            category1,
            category2,
            contactid,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            departmentcode,
            branchcode,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            contactemail,
            usagecost,
            chargesamountbs,
            exclusivecostbs,
            documentclassno,
            exclusiveamountbs,
            gstamountbs,
            usagecostbs,
            roundingamountbs,
            commissionamountbs,
            sourceorderid,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            currencycode,
            basecurrencycode,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            CASE 
                WHEN CAST(discountdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE discountdate 
            END as discountdate,
            paymentdiscount,
            paymentdiscountbs,
            holdamount,
            ratetype,
            exchangerate,
            grossamountbs,
            grossmargin,
            artransactionid,
            grossmarginbs,
            grossmarginordered,
            grossmarginorderedbs,
            marginpercentageordered,
            fixedrate,
            CASE 
                WHEN CAST(fxdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fxdate 
            END as fxdate,
            regimecode,
            CASE 
                WHEN CAST(gstamountinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gstamountinvoiced 
            END as gstamountinvoiced,
            CASE 
                WHEN CAST(gstamountinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gstamountinvoicedbs 
            END as gstamountinvoicedbs,
            CASE 
                WHEN CAST(exclusiveamountinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusiveamountinvoiced 
            END as exclusiveamountinvoiced,
            CASE 
                WHEN CAST(exclusiveamountinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusiveamountinvoicedbs 
            END as exclusiveamountinvoicedbs,
            CASE 
                WHEN CAST(exclusivecostinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusivecostinvoiced 
            END as exclusivecostinvoiced,
            CASE 
                WHEN CAST(exclusivecostinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusivecostinvoicedbs 
            END as exclusivecostinvoicedbs,
            generationbasis,
            storepersoncode,
            einvoiceidentifier,
            narration,
            recno,
            sourcedocumentid,
            accountfile,
            accountcode,
            allowmanualnumbering,
            bypasscreditlimit,
            specialpricingactive,
            sourcedocumentmodule,
            insufficientsupply,
            invoicenorequired,
            packingslipnorequired,
            documentnofrompackingslipno,
            clientid,
            organisationid,
            CASE 
                WHEN CAST(etlcreatetime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE etlcreatetime 
            END as etlcreatetime,
            CASE 
                WHEN CAST(etlupdatetime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE etlupdatetime 
            END as etlupdatetime,
            etlinserttime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JCBatch
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jcbatch;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jcbatch(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jcbatch`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jcbatchstage`');

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
            batchid,
            periodid,
            details,
            comment,
            reference,
            unit,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            transactiontype,
            costcentrecode,
            componentcode,
            creditorcode,
            branchcode,
            departmentcode,
            locationcode,
            jobcode,
            jobpersoncode,
            productcode,
            batchclass,
            poststatus,
            printstatus,
            totalcost,
            totalquantity,
            totalsellbs,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            balanceamount,
            controltotal,
            sourcemodule,
            sourceid,
            uomcode,
            recordrevision,
            controlquantity,
            recno,
            sourcebatchid,
            accountfile,
            accountcode,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JCBudget
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jcbudget;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jcbudget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jcbudget`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jcbudgetstage`');

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
            recno,
            inactive,
            jobcode,
            jobname,
            sellcurrencycode,
            customercode,
            jobtype,
            jobstatus,
            category1,
            category2,
            jobgroupcode,
            relatedjobcode,
            periodtransfertogl,
            CASE 
                WHEN CAST(datecompleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE datecompleted 
            END as datecompleted,
            yearno,
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

-- JCDisbursement
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jcdisbursement;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jcdisbursement(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jcdisbursement`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jcdisbursementstage`');

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
            batchid,
            periodid,
            details,
            comment,
            reference,
            unit,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            transactiontype,
            costcentrecode,
            componentcode,
            creditorcode,
            branchcode,
            departmentcode,
            locationcode,
            jobcode,
            jobpersoncode,
            productcode,
            batchclass,
            poststatus,
            printstatus,
            totalcost,
            totalquantity,
            totalsellbs,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            balanceamount,
            controltotal,
            sourcemodule,
            sourceid,
            uomcode,
            recordrevision,
            controlquantity,
            recno,
            sourcebatchid,
            accountfile,
            accountcode,
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

-- JCJob
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jcjob;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jcjob(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jcjob`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jcjobstage`');

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
            jobcode,
            jobname,
            customercode,
            customername,
            jobtype,
            jobstatus,
            CASE 
                WHEN CAST(dateentered AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateentered 
            END as dateentered,
            CASE 
                WHEN CAST(daterequired AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE daterequired 
            END as daterequired,
            CASE 
                WHEN CAST(datecompleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE datecompleted 
            END as datecompleted,
            custom1,
            custom2,
            siteaddresscode,
            siteaddress1,
            siteaddress2,
            siteaddress3,
            siteaddress4,
            siteaddress5,
            sitecountrycode,
            sitepostcode,
            orderno,
            comment,
            pricecode,
            salespersoncode,
            discountschedulecode,
            defaultlocationcode,
            estimatedcost,
            estimatedsell,
            estimatedsellbs,
            estimatedprofit,
            quotedcost,
            quotedsell,
            quotedsellbs,
            actualscost,
            quotedprofit,
            quotedmargin,
            actualssell,
            actualssellbs,
            actualsprofit,
            actualsmargin,
            CASE 
                WHEN CAST(invoicedcost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedcost 
            END as invoicedcost,
            CASE 
                WHEN CAST(invoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamount 
            END as invoicedamount,
            CASE 
                WHEN CAST(invoicedamountbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamountbs 
            END as invoicedamountbs,
            CASE 
                WHEN CAST(invoicedprofit AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedprofit 
            END as invoicedprofit,
            CASE 
                WHEN CAST(invoicedmargin AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedmargin 
            END as invoicedmargin,
            estimatedmargin,
            inactive,
            CASE 
                WHEN CAST(lasthistoryperiod AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lasthistoryperiod 
            END as lasthistoryperiod,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            branchcode,
            departmentcode,
            jobgroupcode,
            quantity,
            drawingno,
            relatedjobcode,
            percentagecomplete,
            nonwip,
            productcode,
            contactid,
            contactemail,
            sellcurrencycode,
            ratetype,
            CASE 
                WHEN CAST(datevalued AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE datevalued 
            END as datevalued,
            exchangerate,
            fixedrate,
            CASE 
                WHEN CAST(pendingactualscost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingactualscost 
            END as pendingactualscost,
            CASE 
                WHEN CAST(pendingactualssell AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingactualssell 
            END as pendingactualssell,
            CASE 
                WHEN CAST(pendingactualssellbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendingactualssellbs 
            END as pendingactualssellbs,
            CASE 
                WHEN CAST(pendinginvoicedcost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedcost 
            END as pendinginvoicedcost,
            CASE 
                WHEN CAST(pendinginvoicedsell AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedsell 
            END as pendinginvoicedsell,
            CASE 
                WHEN CAST(pendinginvoicedsellbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedsellbs 
            END as pendinginvoicedsellbs,
            workinprogresscost,
            workinprogressrecovered,
            periodtransfertogl,
            transferredtogl,
            glclosingworkinprogressaccountcode,
            glworkinprogressaccountcode,
            workinprogress,
            periodcompletename,
            category1,
            category2,
            jobprofit,
            jobmargin,
            printstatus,
            sitelatitude,
            sitelongitude,
            CASE 
                WHEN CAST(timerequired AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timerequired 
            END as timerequired,
            jobpersoncode,
            editrevision,
            recordrevision,
            zrecipecode,
            zmachinecode,
            zrawmaterialcode,
            zreservationbatchid,
            ordernoalpha,
            exchangerateraw,
            periodcompleteforwip,
            accountfile,
            accountcode,
            allowinactive,
            allowmanualnumbering,
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

-- JCTimeSheet
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jctimesheet;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jctimesheet(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jctimesheet`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jctimesheetstage`');

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
            batchid,
            periodid,
            details,
            comment,
            reference,
            unit,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            transactiontype,
            costcentrecode,
            componentcode,
            creditorcode,
            branchcode,
            departmentcode,
            locationcode,
            jobcode,
            jobpersoncode,
            productcode,
            batchclass,
            poststatus,
            printstatus,
            totalcost,
            totalquantity,
            totalsellbs,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            balanceamount,
            controltotal,
            sourcemodule,
            sourceid,
            uomcode,
            recordrevision,
            controlquantity,
            recno,
            sourcebatchid,
            accountfile,
            accountcode,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JCTransaction
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_jctransaction;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_jctransaction(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_jctransaction`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_jctransactionstage`');

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
            transactionid,
            transactiontype,
            CASE 
                WHEN CAST(transactiondate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE transactiondate 
            END as transactiondate,
            periodid,
            sourcemodule,
            reference,
            sourceid,
            branchcode,
            departmentcode,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            lineno,
            jobcode,
            comment,
            costcentrecode,
            componentcode,
            productcode,
            transactionquantity,
            unit,
            unitcostprice,
            serialno,
            creditorcode,
            locationcode,
            markuppercentage,
            unitsellpricebs,
            unitsellprice,
            CASE 
                WHEN CAST(extendedcost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE extendedcost 
            END as extendedcost,
            CASE 
                WHEN CAST(extendedsell AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE extendedsell 
            END as extendedsell,
            CASE 
                WHEN CAST(extendedsellbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE extendedsellbs 
            END as extendedsellbs,
            completeforwip,
            periodcompleteforwip,
            transferredtogl,
            orderno,
            salesgroupcode,
            description,
            approvalinvoicequantity,
            linebreak,
            approvalinvoicecostprice,
            approvalinvoicemarkuppercentage,
            approvalinvoicesellpricebs,
            approvalinvoicesellprice,
            approvalinvoicecost,
            approvalinvoicesell,
            approvalinvoicesellbs,
            CASE 
                WHEN CAST(fullyinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fullyinvoiced 
            END as fullyinvoiced,
            sourcelineid,
            glaccountcode,
            narration,
            custom1,
            custom2,
            CASE 
                WHEN CAST(pendinginvoicedquantity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedquantity 
            END as pendinginvoicedquantity,
            CASE 
                WHEN CAST(pendinginvoicedcost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedcost 
            END as pendinginvoicedcost,
            CASE 
                WHEN CAST(pendinginvoicedsell AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedsell 
            END as pendinginvoicedsell,
            CASE 
                WHEN CAST(pendinginvoicedsellbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoicedsellbs 
            END as pendinginvoicedsellbs,
            CASE 
                WHEN CAST(invoicedquantity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedquantity 
            END as invoicedquantity,
            CASE 
                WHEN CAST(invoicedcost AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedcost 
            END as invoicedcost,
            CASE 
                WHEN CAST(invoicedsell AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedsell 
            END as invoicedsell,
            CASE 
                WHEN CAST(invoicedsellbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedsellbs 
            END as invoicedsellbs,
            batchid,
            sellcurrencycode,
            ratetype,
            exchangerate,
            uomunitcostprice,
            uomunitsellprice,
            uomunitsellpricebs,
            uomtransactionquantity,
            uomapprovalinvoicequantity,
            CASE 
                WHEN CAST(uompendinginvoicedquantity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE uompendinginvoicedquantity 
            END as uompendinginvoicedquantity,
            CASE 
                WHEN CAST(uominvoicedquantity AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE uominvoicedquantity 
            END as uominvoicedquantity,
            uomapprovalinvoicecostprice,
            uomapprovalinvoicesellprice,
            uomapprovalinvoicesellpricebs,
            uomcode,
            uommultiplier,
            CASE 
                WHEN CAST(approvalinvoicediscountpercentage AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE approvalinvoicediscountpercentage 
            END as approvalinvoicediscountpercentage,
            discountpercentage,
            baseuomcode,
            manuallycosted,
            ictransactionid,
            linespace,
            lotno,
            recordrevision,
            z_jobshiftquantity,
            recno,
            sourcetransactionid,
            accountfile,
            accountcode,
            specialpricingactive,
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

-- OEOrder
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_oeorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_oeorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_oeorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_oeorderstage`');

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
            documentid,
            documenttype,
            customercode,
            periodid,
            printstatus,
            sellpricebasis,
            pricecode,
            gstoverride,
            CASE 
                WHEN CAST(deliverydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deliverydate 
            END as deliverydate,
            orderno,
            packingslipno,
            packingslipcount,
            salesareacode,
            salespersoncode,
            discountschedulecode,
            quotationreference,
            grossamountorderedbs,
            internalreference,
            deliveryaddress1,
            deliveryaddress2,
            deliveryaddress3,
            deliveryaddress4,
            deliveryaddress5,
            deliverycountrycode,
            deliverypostcode,
            exclusivecost,
            exclusiveamount,
            chargesamount,
            gstamount,
            roundingamount,
            commissionamount,
            exclusiveamountordered,
            gstamountordered,
            deliveryaddresscode,
            category2,
            category1,
            sourcemodule,
            defaultlocationcode,
            grossamountordered,
            contactid,
            poststatus,
            branchcode,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            custom1,
            comment,
            documentclass,
            sourceid,
            grossamount,
            exclusivecostordered,
            marginpercentage,
            gstamountorderedbs,
            exclusivecostorderedbs,
            custom2,
            exclusiveamountorderedbs,
            CASE 
                WHEN CAST(originationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE originationdate 
            END as originationdate,
            totalweight,
            departmentcode,
            totalvolume,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            contactemail,
            usagecost,
            chargesamountbs,
            CASE 
                WHEN CAST(valuationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE valuationdate 
            END as valuationdate,
            exclusivecostbs,
            exclusiveamountbs,
            gstamountbs,
            usagecostbs,
            roundingamountbs,
            commissionamountbs,
            sourceorderid,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            invoiceid,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            totalweightordered,
            totalvolumeordered,
            currencycode,
            basecurrencycode,
            ratetype,
            exchangerate,
            grossamountbs,
            grossmargin,
            documentclassno,
            grossmarginbs,
            grossmarginordered,
            grossmarginorderedbs,
            marginpercentageordered,
            fixedrate,
            CASE 
                WHEN CAST(fxdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fxdate 
            END as fxdate,
            regimecode,
            generationbasis,
            storepersoncode,
            CASE 
                WHEN CAST(gstamountinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gstamountinvoiced 
            END as gstamountinvoiced,
            CASE 
                WHEN CAST(gstamountinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE gstamountinvoicedbs 
            END as gstamountinvoicedbs,
            CASE 
                WHEN CAST(exclusiveamountinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusiveamountinvoiced 
            END as exclusiveamountinvoiced,
            CASE 
                WHEN CAST(exclusiveamountinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusiveamountinvoicedbs 
            END as exclusiveamountinvoicedbs,
            CASE 
                WHEN CAST(exclusivecostinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusivecostinvoiced 
            END as exclusivecostinvoiced,
            CASE 
                WHEN CAST(exclusivecostinvoicedbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE exclusivecostinvoicedbs 
            END as exclusivecostinvoicedbs,
            originalamountordered,
            originalamountorderedbs,
            recno,
            sourcedocumentid,
            accountfile,
            accountcode,
            allowmanualnumbering,
            bypasscreditlimit,
            specialpricingactive,
            sourcedocumentmodule,
            packingslipnorequired,
            clientid,
            organisationid,
            CASE 
                WHEN CAST(etlcreatetime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE etlcreatetime 
            END as etlcreatetime,
            CASE 
                WHEN CAST(etlupdatetime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE etlupdatetime 
            END as etlupdatetime,
            etlinserttime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- POOrder
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_poorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_poorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_poorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_poorderstage`');

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
            documentid,
            clientid,
            organisationid,
            odataetag,
            printstatus,
            CASE 
                WHEN CAST(daterequired AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE daterequired 
            END as daterequired,
            defaultexpensecode,
            internalreference,
            authorisationcode,
            quotationreference,
            deliveryaddress1,
            deliveryaddress2,
            deliveryaddress3,
            deliveryaddress4,
            deliveryaddress5,
            deliverycountrycode,
            deliverypostcode,
            password,
            creditorcode,
            documenttype,
            periodid,
            documentno,
            defaultjobcode,
            defaultjctransactiontype,
            defaultcostcentrecode,
            orderedamount,
            orderedgst,
            quotegross,
            quotegrossbs,
            defaultcomponentcode,
            defaultlocationcode,
            documentclass,
            deliverycode,
            poststatus,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            sourceid,
            sourcemodule,
            category1,
            custom1,
            category2,
            contactid,
            quantityordered,
            branchcode,
            custom2,
            documentclassno,
            departmentcode,
            totalweight,
            totalvolume,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            contactemail,
            receiptedamount,
            CASE 
                WHEN CAST(invoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamount 
            END as invoicedamount,
            orderedamountbs,
            orderedgstbs,
            receiptedamountbs,
            CASE 
                WHEN CAST(invoicedamountbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamountbs 
            END as invoicedamountbs,
            quantityreceipted,
            CASE 
                WHEN CAST(quantityinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE quantityinvoiced 
            END as quantityinvoiced,
            quantityshipped,
            CASE 
                WHEN CAST(valuationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE valuationdate 
            END as valuationdate,
            CASE 
                WHEN CAST(quantitypendinginvoice AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE quantitypendinginvoice 
            END as quantitypendinginvoice,
            CASE 
                WHEN CAST(pendinginvoiceamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoiceamount 
            END as pendinginvoiceamount,
            CASE 
                WHEN CAST(pendinginvoiceamountbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoiceamountbs 
            END as pendinginvoiceamountbs,
            shippedamount,
            shippedamountbs,
            quantityoutstandingreceipt,
            quantityoutstandinginvoice,
            outstandingamountreceipt,
            outstandingamountreceiptbs,
            outstandingamountinvoice,
            outstandingamountinvoicebs,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            recordrevision,
            currencycode,
            basecurrencycode,
            ratetype,
            comment,
            exchangerate,
            fixedrate,
            CASE 
                WHEN CAST(fxdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE fxdate 
            END as fxdate,
            regimecode,
            CASE 
                WHEN CAST(dateexpected AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateexpected 
            END as dateexpected,
            recno,
            sourcedocumentid,
            accountfile,
            accountcode,
            allowmanualnumbering,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- POOrderList
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_poorderlist;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_poorderlist(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_accredo_poorderlist`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_accredo_poorderliststage`');

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
            recno,
            creditorcode,
            documentid,
            documentclass,
            documenttype,
            poststatus,
            haslinks,
            hasmemos,
            CASE 
                WHEN CAST(documentdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentdate 
            END as documentdate,
            CASE 
                WHEN CAST(daterequired AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE daterequired 
            END as daterequired,
            documentno,
            printstatus,
            quotegross,
            periodname,
            quantityordered,
            quantityreceipted,
            CASE 
                WHEN CAST(quantityinvoiced AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE quantityinvoiced 
            END as quantityinvoiced,
            orderedamount,
            receiptedamount,
            CASE 
                WHEN CAST(invoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamount 
            END as invoicedamount,
            internalreference,
            authorisationcode,
            defaultjobcode,
            quotationreference,
            defaultexpensecode,
            deliveryaddress1,
            deliveryaddress2,
            deliveryaddress3,
            deliveryaddress4,
            orderedgst,
            sourceid,
            periodid,
            category1,
            category2,
            creditorname,
            contactid,
            contactname,
            quantityshipped,
            CASE 
                WHEN CAST(quantitypendinginvoice AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE quantitypendinginvoice 
            END as quantitypendinginvoice,
            currencycode,
            jobname,
            CASE 
                WHEN CAST(createdusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercode 
            END as createdusercode,
            CASE 
                WHEN CAST(createddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createddate 
            END as createddate,
            CASE 
                WHEN CAST(createdtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdtime 
            END as createdtime,
            sourcemodule,
            regimecode,
            ratetype,
            branchcode,
            departmentcode,
            defaultlocationcode,
            deliveryaddress5,
            deliverycountrycode,
            deliverypostcode,
            contactemail,
            deliverycode,
            fixedrate,
            comment,
            defaultjctransactiontype,
            defaultcostcentrecode,
            defaultcomponentcode,
            custom1,
            custom2,
            totalweight,
            totalvolume,
            CASE 
                WHEN CAST(dateexpected AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE dateexpected 
            END as dateexpected,
            exchangerate,
            orderedgstbs,
            orderedamountbs,
            CASE 
                WHEN CAST(valuationdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE valuationdate 
            END as valuationdate,
            CASE 
                WHEN CAST(modifiedusercode AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedusercode 
            END as modifiedusercode,
            CASE 
                WHEN CAST(modifieddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifieddate 
            END as modifieddate,
            CASE 
                WHEN CAST(modifiedtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE modifiedtime 
            END as modifiedtime,
            receiptedamountbs,
            CASE 
                WHEN CAST(invoicedamountbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamountbs 
            END as invoicedamountbs,
            CASE 
                WHEN CAST(pendinginvoiceamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoiceamount 
            END as pendinginvoiceamount,
            CASE 
                WHEN CAST(pendinginvoiceamountbs AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE pendinginvoiceamountbs 
            END as pendinginvoiceamountbs,
            shippedamount,
            shippedamountbs,
            quantityoutstandingreceipt,
            outstandingamountreceipt,
            outstandingamountreceiptbs,
            quantityoutstandinginvoice,
            outstandingamountinvoice,
            outstandingamountinvoicebs,
            recordrevision,
            yearno,
            periodno,
            exchangerateraw,
            documentnoalpha,
            quotegrossbs,
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

-- ACCREDO LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_accredo_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_accredo_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_accredo_lastrefreshdate`');

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
