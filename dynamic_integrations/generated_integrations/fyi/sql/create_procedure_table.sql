-- FYI Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- Cabinet
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_cabinet;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_cabinet(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_cabinet`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_cabinetstage`');

    SET @delete_default = CONCAT('
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
            type,
            isknowledge,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
            jobsenabled,
            jobsrequired,
            jobsordering,
            tagsenabled,
            tagsrequired,
            tagsordering,
            accountsenabled,
            accountsrequired,
            accountsordering,
            keywordsordering,
            keywordsrequired,
            keywordsenabled,
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

-- Category
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_category;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_category(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_category`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_categorystage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            visibletemplates,
            visibleprocesses,
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

-- Comment
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_comment;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_comment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_comment`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_commentstage`');

    SET @delete_default = CONCAT('
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
            source,
            sourceid,
            message,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
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

-- Contact
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_contact;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_contact(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_contact`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_contactstage`');

    SET @delete_default = CONCAT('
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
            source,
            sourceid,
            addressee,
            email,
            mobile,
            name,
            phone,
            position,
            salutation,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
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

-- CustomFieldEntity
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_customfieldentity;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_customfieldentity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_customfieldentity`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_customfieldentitystage`');

    SET @delete_default = CONCAT('
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
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(deleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deleteduserid 
            END as deleteduserid,
            source,
            sourceid,
            name,
            fieldtype,
            applies_to,
            isshared,
            external_ids,
            clientid,
            organisationid,
            detailsid,
            detailsname,
            detailstype,
            detailssha1,
            detailsusejob,
            detailsuselead,
            detailsuseclient,
            detailsusecontact,
            detailsusejobcost,
            detailsusejobtask,
            CASE 
                WHEN CAST(detailsusejobtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE detailsusejobtime 
            END as detailsusejobtime,
            detailsusesupplier,
            detailsvalueelement,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CustomFieldJob
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_customfieldjob;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_customfieldjob(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_customfieldjob`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_customfieldjobstage`');

    SET @delete_default = CONCAT('
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
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(deleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deleteduserid 
            END as deleteduserid,
            source,
            sourceid,
            name,
            fieldtype,
            applies_to,
            isshared,
            external_ids,
            clientid,
            organisationid,
            detailsid,
            detailsname,
            detailstype,
            detailssha1,
            detailsxpmid,
            detailsusejob,
            detailsuselead,
            detailsuseclient,
            detailsusecontact,
            detailsusejobcost,
            detailsusejobtask,
            CASE 
                WHEN CAST(detailsusejobtime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE detailsusejobtime 
            END as detailsusejobtime,
            detailsusesupplier,
            detailsvalueelement,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Document
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_document;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_document(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_document`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_documentstage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            externalid,
            CASE 
                WHEN CAST(lastsavedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastsavedon 
            END as lastsavedon,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            name,
            originalfilename,
            documenttype,
            referencenumber,
            details,
            keywords,
            status,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
            versionid,
            linkid,
            threadid,
            cabinetid,
            cabinetname,
            cabinettype,
            cabinetisknowledge,
            CASE 
                WHEN CAST(cabinetlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cabinetlastmodifiedon 
            END as cabinetlastmodifiedon,
            CASE 
                WHEN CAST(cabinetcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cabinetcreatedon 
            END as cabinetcreatedon,
            CASE 
                WHEN CAST(cabinetisdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE cabinetisdeleted 
            END as cabinetisdeleted,
            cabinetjobsenabled,
            cabinetjobsrequired,
            cabinetjobsordering,
            cabinettagsenabled,
            cabinettagsrequired,
            cabinettagsordering,
            cabinetaccountsenabled,
            cabinetaccountsrequired,
            cabinetaccountsordering,
            cabinetkeywordsordering,
            cabinetkeywordsrequired,
            cabinetkeywordsenabled,
            cabinetcategories,
            cabinetcategoriesoptions,
            jobname,
            jobid,
            jobentityid,
            jobjobstateid,
            CASE 
                WHEN CAST(jobstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobstartdate 
            END as jobstartdate,
            jobjobtypeid,
            jobcabinetid,
            jobmanageruserid,
            jobpartneruserid,
            CASE 
                WHEN CAST(jobcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreateduserid 
            END as jobcreateduserid,
            CASE 
                WHEN CAST(jobcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreatedon 
            END as jobcreatedon,
            CASE 
                WHEN CAST(joblastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifiedon 
            END as joblastmodifiedon,
            CASE 
                WHEN CAST(joblastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifieduserid 
            END as joblastmodifieduserid,
            jobcommentscount,
            jobprimary,
            jobtype,
            jobworkflowenabled,
            jobvalue,
            CASE 
                WHEN CAST(jobduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobduedate 
            END as jobduedate,
            jobsource,
            jobsourceid,
            jobbudgetminutes,
            jobactualminutes,
            jobbudgetamount,
            jobactualamount,
            jobwipamount,
            jobwriteonoff,
            CASE 
                WHEN CAST(jobinvoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobinvoicedamount 
            END as jobinvoicedamount,
            jobparentid,
            jobusers,
            jobtemplateid,
            jobjobcustomfields,
            jobxpmactualminutes,
            jobxpmestimatedminutes,
            jobxpmvarianceminutes,
            entityid,
            entityname,
            entitydetails,
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
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_employee;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_employee(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_employee`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_employeestage`');

    SET @delete_default = CONCAT('
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
            name,
            email,
            source,
            sourceid,
            entitygroupid,
            details,
            contacts,
            entity_custom_fields,
            mobile,
            phone,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            manageruserid,
            manageruserdisplayname,
            CASE 
                WHEN CAST(managerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreatedon 
            END as managerusercreatedon,
            CASE 
                WHEN CAST(managerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreateduserid 
            END as managerusercreateduserid,
            CASE 
                WHEN CAST(manageruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifiedon 
            END as manageruserlastmodifiedon,
            CASE 
                WHEN CAST(manageruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifieduserid 
            END as manageruserlastmodifieduserid,
            CASE 
                WHEN CAST(manageruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserdeleteduserid 
            END as manageruserdeleteduserid,
            manageruseremail,
            manageruseremailalias,
            manageruserinactive,
            manageruserproductivitytarget,
            manageruserworkinghours,
            managerusersource,
            manageruseruserrole,
            manageruserpermissionuserrole,
            partneruserid,
            partneruserdisplayname,
            CASE 
                WHEN CAST(partnerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreatedon 
            END as partnerusercreatedon,
            CASE 
                WHEN CAST(partnerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreateduserid 
            END as partnerusercreateduserid,
            CASE 
                WHEN CAST(partneruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifiedon 
            END as partneruserlastmodifiedon,
            CASE 
                WHEN CAST(partneruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifieduserid 
            END as partneruserlastmodifieduserid,
            CASE 
                WHEN CAST(partneruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserdeleteduserid 
            END as partneruserdeleteduserid,
            partneruseremail,
            partneruseremailalias,
            partneruserinactive,
            partneruserproductivitytarget,
            partneruserworkinghours,
            partnerusersource,
            partneruseruserrole,
            partneruserpermissionuserrole,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Entity
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_entity;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_entity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_entity`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_entitystage`');

    SET @delete_default = CONCAT('
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
            name,
            email,
            source,
            sourceid,
            entitygroupid,
            mobile,
            phone,
            address,
            city,
            region,
            postcode,
            country,
            postaladdress,
            postalcity,
            postalregion,
            postalpostcode,
            postalcountry,
            businessnumber,
            companynumber,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
            manageruserid,
            manageruserdisplayname,
            CASE 
                WHEN CAST(managerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreatedon 
            END as managerusercreatedon,
            CASE 
                WHEN CAST(managerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreateduserid 
            END as managerusercreateduserid,
            CASE 
                WHEN CAST(manageruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifiedon 
            END as manageruserlastmodifiedon,
            CASE 
                WHEN CAST(manageruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifieduserid 
            END as manageruserlastmodifieduserid,
            CASE 
                WHEN CAST(manageruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserdeleteduserid 
            END as manageruserdeleteduserid,
            manageruseremail,
            manageruseremailalias,
            manageruserinactive,
            manageruserproductivitytarget,
            manageruserworkinghours,
            managerusersource,
            manageruseruserrole,
            manageruserpermissionuserrole,
            partneruserid,
            partneruserdisplayname,
            CASE 
                WHEN CAST(partnerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreatedon 
            END as partnerusercreatedon,
            CASE 
                WHEN CAST(partnerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreateduserid 
            END as partnerusercreateduserid,
            CASE 
                WHEN CAST(partneruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifiedon 
            END as partneruserlastmodifiedon,
            CASE 
                WHEN CAST(partneruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifieduserid 
            END as partneruserlastmodifieduserid,
            CASE 
                WHEN CAST(partneruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserdeleteduserid 
            END as partneruserdeleteduserid,
            partneruseremail,
            partneruseremailalias,
            partneruserinactive,
            partneruserproductivitytarget,
            partneruserworkinghours,
            partnerusersource,
            partneruseruserrole,
            partneruserpermissionuserrole,
            detailsclientcode,
            detailsexportcode,
            detailsuuid,
            detailsbusinessstructure,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- EntityRelationship
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_entityrelationship;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_entityrelationship(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_entityrelationship`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_entityrelationshipstage`');

    SET @delete_default = CONCAT('
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
            type,
            entityrelationshiptype,
            entityid,
            relatedentityid,
            percentage,
            numberofshares,
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
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
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

-- Group
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_group;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_group(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_group`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_groupstage`');

    SET @delete_default = CONCAT('
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
            source,
            primaryentityid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
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
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_invoice;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_invoice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_invoice`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_invoicestage`');

    SET @delete_default = CONCAT('
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
            entityid,
            amountoutstanding,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            amountincludingtax,
            invoiceamount,
            CASE 
                WHEN CAST(invoicedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedate 
            END as invoicedate,
            invoicenumber,
            jobid,
            paidamount,
            CASE 
                WHEN CAST(paiddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE paiddate 
            END as paiddate,
            status,
            type,
            tenantid,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
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
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_job;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_job(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_job`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobstage`');

    SET @delete_default = CONCAT('
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
            entityid,
            jobstateid,
            CASE 
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            jobtypeid,
            cabinetid,
            manageruserid,
            partneruserid,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            commentscount,
            `primary`,
            xpminternalid,
            type,
            workflowenabled,
            value,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            sourceid,
            budgetminutes,
            actualminutes,
            varianceminutes,
            budgetamount,
            actualamount,
            CASE 
                WHEN CAST(invoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamount 
            END as invoicedamount,
            varianceamount,
            parentid,
            CASE 
                WHEN CAST(lastcomment AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastcomment 
            END as lastcomment,
            customfieldcf1,
            xpmactualminutes,
            xpmestimatedminutes,
            xpmvarianceminutes,
            clientid,
            organisationid,
            jobtypename,
            jobtypestatus,
            CASE 
                WHEN CAST(jobtypecreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobtypecreatedon 
            END as jobtypecreatedon,
            CASE 
                WHEN CAST(jobtypecreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobtypecreateduserid 
            END as jobtypecreateduserid,
            CASE 
                WHEN CAST(jobtypelastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobtypelastmodifiedon 
            END as jobtypelastmodifiedon,
            CASE 
                WHEN CAST(jobtypelastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobtypelastmodifieduserid 
            END as jobtypelastmodifieduserid,
            jobtypesource,
            jobtypesourceid,
            jobstatename,
            manageruserdisplayname,
            CASE 
                WHEN CAST(managerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreatedon 
            END as managerusercreatedon,
            CASE 
                WHEN CAST(managerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE managerusercreateduserid 
            END as managerusercreateduserid,
            CASE 
                WHEN CAST(manageruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifiedon 
            END as manageruserlastmodifiedon,
            CASE 
                WHEN CAST(manageruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserlastmodifieduserid 
            END as manageruserlastmodifieduserid,
            CASE 
                WHEN CAST(manageruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE manageruserdeleteduserid 
            END as manageruserdeleteduserid,
            manageruseremail,
            manageruseremailalias,
            manageruserinactive,
            manageruserproductivitytarget,
            manageruserworkinghours,
            managerusersource,
            manageruseruserrole,
            manageruserpermissionuserrole,
            partneruserdisplayname,
            CASE 
                WHEN CAST(partnerusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreatedon 
            END as partnerusercreatedon,
            CASE 
                WHEN CAST(partnerusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partnerusercreateduserid 
            END as partnerusercreateduserid,
            CASE 
                WHEN CAST(partneruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifiedon 
            END as partneruserlastmodifiedon,
            CASE 
                WHEN CAST(partneruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserlastmodifieduserid 
            END as partneruserlastmodifieduserid,
            CASE 
                WHEN CAST(partneruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE partneruserdeleteduserid 
            END as partneruserdeleteduserid,
            partneruseremail,
            partneruseremailalias,
            partneruserinactive,
            partneruserproductivitytarget,
            partneruserworkinghours,
            partnerusersource,
            partneruseruserrole,
            partneruserpermissionuserrole,
            CASE 
                WHEN CAST(createduserdisplayname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserdisplayname 
            END as createduserdisplayname,
            CASE 
                WHEN CAST(createdusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercreatedon 
            END as createdusercreatedon,
            CASE 
                WHEN CAST(createdusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusercreateduserid 
            END as createdusercreateduserid,
            CASE 
                WHEN CAST(createduserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserlastmodifiedon 
            END as createduserlastmodifiedon,
            CASE 
                WHEN CAST(createduserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserlastmodifieduserid 
            END as createduserlastmodifieduserid,
            CASE 
                WHEN CAST(createduserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserdeleteduserid 
            END as createduserdeleteduserid,
            CASE 
                WHEN CAST(createduseremail AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseremail 
            END as createduseremail,
            CASE 
                WHEN CAST(createduseremailalias AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseremailalias 
            END as createduseremailalias,
            CASE 
                WHEN CAST(createduserinactive AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserinactive 
            END as createduserinactive,
            CASE 
                WHEN CAST(createduserproductivitytarget AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserproductivitytarget 
            END as createduserproductivitytarget,
            CASE 
                WHEN CAST(createduserworkinghours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserworkinghours 
            END as createduserworkinghours,
            CASE 
                WHEN CAST(createdusersource AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdusersource 
            END as createdusersource,
            CASE 
                WHEN CAST(createduseruserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseruserrole 
            END as createduseruserrole,
            CASE 
                WHEN CAST(createduserpermissionuserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserpermissionuserrole 
            END as createduserpermissionuserrole,
            CASE 
                WHEN CAST(lastmodifieduserdisplayname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserdisplayname 
            END as lastmodifieduserdisplayname,
            CASE 
                WHEN CAST(lastmodifiedusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedusercreatedon 
            END as lastmodifiedusercreatedon,
            CASE 
                WHEN CAST(lastmodifiedusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedusercreateduserid 
            END as lastmodifiedusercreateduserid,
            CASE 
                WHEN CAST(lastmodifieduserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserlastmodifiedon 
            END as lastmodifieduserlastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserlastmodifieduserid 
            END as lastmodifieduserlastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifieduserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserdeleteduserid 
            END as lastmodifieduserdeleteduserid,
            CASE 
                WHEN CAST(lastmodifieduseremail AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduseremail 
            END as lastmodifieduseremail,
            CASE 
                WHEN CAST(lastmodifieduseremailalias AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduseremailalias 
            END as lastmodifieduseremailalias,
            CASE 
                WHEN CAST(lastmodifieduserinactive AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserinactive 
            END as lastmodifieduserinactive,
            CASE 
                WHEN CAST(lastmodifieduserproductivitytarget AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserproductivitytarget 
            END as lastmodifieduserproductivitytarget,
            CASE 
                WHEN CAST(lastmodifieduserworkinghours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserworkinghours 
            END as lastmodifieduserworkinghours,
            CASE 
                WHEN CAST(lastmodifiedusersource AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedusersource 
            END as lastmodifiedusersource,
            CASE 
                WHEN CAST(lastmodifieduseruserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduseruserrole 
            END as lastmodifieduseruserrole,
            CASE 
                WHEN CAST(lastmodifieduserpermissionuserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserpermissionuserrole 
            END as lastmodifieduserpermissionuserrole,
            entityname,
            entityemail,
            entitygroupid,
            entitygroupname,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- JobState
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobstate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobstate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobstate`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobstatestage`');

    SET @delete_default = CONCAT('
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
            name,
            type,
            sourceid,
            details,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(deleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deleteduserid 
            END as deleteduserid,
            displayorder,
            availableboard,
            color,
            CASE 
                WHEN CAST(locktimes AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE locktimes 
            END as locktimes,
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

-- JobTemplate
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobtemplate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobtemplate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobtemplate`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobtemplatestage`');

    SET @delete_default = CONCAT('
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
            status,
            salesaccount,
            brandingtheme,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            source,
            sourceid,
            itemdescription,
            mode,
            type,
            referencecustomfieldid,
            jobname,
            parent_ids,
            budgetamount,
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

-- JobType
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobtype;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobtype(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobtype`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobtypestage`');

    SET @delete_default = CONCAT('
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
            status,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            source,
            sourceid,
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

-- Notification
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_notification;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_notification(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_notification`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_notificationstage`');

    SET @delete_default = CONCAT('
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
            state,
            type,
            sourcetable,
            userid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            clientid,
            organisationid,
            taskid,
            CASE 
                WHEN CAST(taskcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreatedon 
            END as taskcreatedon,
            CASE 
                WHEN CAST(tasklastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE tasklastmodifiedon 
            END as tasklastmodifiedon,
            tasksubject,
            taskmessage,
            CASE 
                WHEN CAST(taskduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskduedate 
            END as taskduedate,
            taskstatus,
            CASE 
                WHEN CAST(taskstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskstartdate 
            END as taskstartdate,
            taskentity,
            taskentityid,
            taskentityname,
            taskentityemail,
            taskentitysource,
            taskentitysourceid,
            taskentityentitygroupid,
            taskentitydetails,
            taskentitycollaborate,
            taskentitymobile,
            taskentityphone,
            taskentitybusinessnumber,
            CASE 
                WHEN CAST(taskentityisdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskentityisdeleted 
            END as taskentityisdeleted,
            CASE 
                WHEN CAST(taskentitylastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskentitylastmodifieduserid 
            END as taskentitylastmodifieduserid,
            CASE 
                WHEN CAST(taskentitylastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskentitylastmodifiedon 
            END as taskentitylastmodifiedon,
            taskassigneduser,
            taskassigneduserid,
            taskassigneduserdisplayname,
            CASE 
                WHEN CAST(taskassignedusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskassignedusercreatedon 
            END as taskassignedusercreatedon,
            CASE 
                WHEN CAST(taskassignedusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskassignedusercreateduserid 
            END as taskassignedusercreateduserid,
            CASE 
                WHEN CAST(taskassigneduserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskassigneduserlastmodifiedon 
            END as taskassigneduserlastmodifiedon,
            CASE 
                WHEN CAST(taskassigneduserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskassigneduserlastmodifieduserid 
            END as taskassigneduserlastmodifieduserid,
            CASE 
                WHEN CAST(taskassigneduserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskassigneduserdeleteduserid 
            END as taskassigneduserdeleteduserid,
            taskassigneduseremail,
            taskassigneduseremailalias,
            taskassigneduserinactive,
            taskassigneduserproductivitytarget,
            taskassigneduserworkinghours,
            taskassignedusersource,
            taskassigneduseruserrole,
            taskassigneduserpermissionuserrole,
            CASE 
                WHEN CAST(taskcreateduser AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduser 
            END as taskcreateduser,
            CASE 
                WHEN CAST(taskcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserid 
            END as taskcreateduserid,
            CASE 
                WHEN CAST(taskcreateduserdisplayname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserdisplayname 
            END as taskcreateduserdisplayname,
            CASE 
                WHEN CAST(taskcreatedusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreatedusercreatedon 
            END as taskcreatedusercreatedon,
            CASE 
                WHEN CAST(taskcreatedusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreatedusercreateduserid 
            END as taskcreatedusercreateduserid,
            CASE 
                WHEN CAST(taskcreateduserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserlastmodifiedon 
            END as taskcreateduserlastmodifiedon,
            CASE 
                WHEN CAST(taskcreateduserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserlastmodifieduserid 
            END as taskcreateduserlastmodifieduserid,
            CASE 
                WHEN CAST(taskcreateduserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserdeleteduserid 
            END as taskcreateduserdeleteduserid,
            CASE 
                WHEN CAST(taskcreateduseremail AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduseremail 
            END as taskcreateduseremail,
            CASE 
                WHEN CAST(taskcreateduseremailalias AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduseremailalias 
            END as taskcreateduseremailalias,
            CASE 
                WHEN CAST(taskcreateduserinactive AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserinactive 
            END as taskcreateduserinactive,
            CASE 
                WHEN CAST(taskcreateduserproductivitytarget AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserproductivitytarget 
            END as taskcreateduserproductivitytarget,
            CASE 
                WHEN CAST(taskcreateduserworkinghours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserworkinghours 
            END as taskcreateduserworkinghours,
            CASE 
                WHEN CAST(taskcreatedusersource AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreatedusersource 
            END as taskcreatedusersource,
            CASE 
                WHEN CAST(taskcreateduseruserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduseruserrole 
            END as taskcreateduseruserrole,
            CASE 
                WHEN CAST(taskcreateduserpermissionuserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskcreateduserpermissionuserrole 
            END as taskcreateduserpermissionuserrole,
            taskcategories,
            taskcategoriesoptions,
            taskjob,
            taskjobname,
            taskjobid,
            taskjobentityid,
            taskjobjobstateid,
            CASE 
                WHEN CAST(taskjobstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjobstartdate 
            END as taskjobstartdate,
            taskjobjobtypeid,
            taskjobcabinetid,
            taskjobmanageruserid,
            taskjobpartneruserid,
            CASE 
                WHEN CAST(taskjobcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjobcreateduserid 
            END as taskjobcreateduserid,
            CASE 
                WHEN CAST(taskjobcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjobcreatedon 
            END as taskjobcreatedon,
            CASE 
                WHEN CAST(taskjoblastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjoblastmodifiedon 
            END as taskjoblastmodifiedon,
            CASE 
                WHEN CAST(taskjoblastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjoblastmodifieduserid 
            END as taskjoblastmodifieduserid,
            taskjobcommentscount,
            taskjobprimary,
            taskjobtype,
            taskjobworkflowenabled,
            taskjobvalue,
            CASE 
                WHEN CAST(taskjobduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjobduedate 
            END as taskjobduedate,
            taskjobsource,
            taskjobsourceid,
            taskjobbudgetminutes,
            taskjobactualminutes,
            taskjobbudgetamount,
            taskjobactualamount,
            taskjobwipamount,
            taskjobwriteonoff,
            CASE 
                WHEN CAST(taskjobinvoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskjobinvoicedamount 
            END as taskjobinvoicedamount,
            taskjobparentid,
            taskjobusers,
            taskjobtemplateid,
            taskjobjobcustomfields,
            taskjobxpmactualminutes,
            taskjobxpmestimatedminutes,
            taskjobxpmvarianceminutes,
            taskdelegatoruser,
            taskdelegatoruserid,
            taskdelegatoruserdisplayname,
            CASE 
                WHEN CAST(taskdelegatorusercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskdelegatorusercreatedon 
            END as taskdelegatorusercreatedon,
            CASE 
                WHEN CAST(taskdelegatorusercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskdelegatorusercreateduserid 
            END as taskdelegatorusercreateduserid,
            CASE 
                WHEN CAST(taskdelegatoruserlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskdelegatoruserlastmodifiedon 
            END as taskdelegatoruserlastmodifiedon,
            CASE 
                WHEN CAST(taskdelegatoruserlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskdelegatoruserlastmodifieduserid 
            END as taskdelegatoruserlastmodifieduserid,
            CASE 
                WHEN CAST(taskdelegatoruserdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE taskdelegatoruserdeleteduserid 
            END as taskdelegatoruserdeleteduserid,
            taskdelegatoruseremail,
            taskdelegatoruseremailalias,
            taskdelegatoruserinactive,
            taskdelegatoruserproductivitytarget,
            taskdelegatoruserworkinghours,
            taskdelegatorusersource,
            taskdelegatoruseruserrole,
            taskdelegatoruserpermissionuserrole,
            useremail,
            userdisplayname,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createduseremail AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseremail 
            END as createduseremail,
            CASE 
                WHEN CAST(createduserdisplayname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserdisplayname 
            END as createduserdisplayname,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Rate
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_rate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_rate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_rate`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_ratestage`');

    SET @delete_default = CONCAT('
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
            type,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            taxrate,
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

-- Tag
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_tag;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_tag(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_tag`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_tagstage`');

    SET @delete_default = CONCAT('
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
            name,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(deleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deleteduserid 
            END as deleteduserid,
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

-- Task
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_task;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_task(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_task`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_taskstage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            subject,
            message,
            CASE 
                WHEN CAST(duedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE duedate 
            END as duedate,
            status,
            CASE 
                WHEN CAST(startdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startdate 
            END as startdate,
            commentcount,
            categories,
            clientid,
            organisationid,
            entityid,
            entityname,
            entityemail,
            entitydetails,
            CASE 
                WHEN CAST(entityisdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE entityisdeleted 
            END as entityisdeleted,
            documentid,
            CASE 
                WHEN CAST(documentcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentcreatedon 
            END as documentcreatedon,
            documentexternalid,
            CASE 
                WHEN CAST(documentlastsavedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentlastsavedon 
            END as documentlastsavedon,
            CASE 
                WHEN CAST(documentlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE documentlastmodifiedon 
            END as documentlastmodifiedon,
            documentname,
            documentdocumenttype,
            documentreferencenumber,
            documentdetails,
            documentkeywords,
            assigneduserdisplayname,
            assigneduseremail,
            assigneduseremailalias,
            assigneduseruserrole,
            assigneduserpermissionuserrole,
            CASE 
                WHEN CAST(createduserdisplayname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserdisplayname 
            END as createduserdisplayname,
            CASE 
                WHEN CAST(createduseremail AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseremail 
            END as createduseremail,
            CASE 
                WHEN CAST(createduseremailalias AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseremailalias 
            END as createduseremailalias,
            CASE 
                WHEN CAST(createduseruserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduseruserrole 
            END as createduseruserrole,
            CASE 
                WHEN CAST(createduserpermissionuserrole AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserpermissionuserrole 
            END as createduserpermissionuserrole,
            cabinetid,
            cabinetname,
            cabinettype,
            cabinetisknowledge,
            jobname,
            jobid,
            jobentityid,
            jobjobstateid,
            CASE 
                WHEN CAST(jobstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobstartdate 
            END as jobstartdate,
            jobjobtypeid,
            jobcabinetid,
            jobmanageruserid,
            jobmanageruser,
            jobmanageruserdisplayname,
            jobmanageruseremail,
            jobmanageruseremailalias,
            jobmanageruseruserrole,
            jobmanageruserpermissionuserrole,
            jobpartneruserid,
            jobpartneruser,
            jobpartneruserdisplayname,
            jobpartneruseremail,
            jobpartneruseremailalias,
            jobpartneruseruserrole,
            jobpartneruserpermissionuserrole,
            CASE 
                WHEN CAST(jobcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreateduserid 
            END as jobcreateduserid,
            CASE 
                WHEN CAST(jobcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreatedon 
            END as jobcreatedon,
            CASE 
                WHEN CAST(joblastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifiedon 
            END as joblastmodifiedon,
            CASE 
                WHEN CAST(joblastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifieduserid 
            END as joblastmodifieduserid,
            jobcommentscount,
            jobprimary,
            jobtype,
            jobworkflowenabled,
            jobvalue,
            CASE 
                WHEN CAST(jobduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobduedate 
            END as jobduedate,
            jobsource,
            jobsourceid,
            jobbudgetminutes,
            jobactualminutes,
            jobbudgetamount,
            jobactualamount,
            jobwipamount,
            jobwriteonoff,
            CASE 
                WHEN CAST(jobinvoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobinvoicedamount 
            END as jobinvoicedamount,
            jobparentid,
            jobusers,
            jobtemplateid,
            jobjobcustomfields,
            jobxpmactualminutes,
            jobxpmestimatedminutes,
            jobxpmvarianceminutes,
            delegatoruserdisplayname,
            delegatoruseremail,
            delegatoruseremailalias,
            delegatoruseruserrole,
            delegatoruserpermissionuserrole,
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

-- TimeEntry
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_timeentry;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_timeentry(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_timeentry`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_timeentrystage`');

    SET @delete_default = CONCAT('
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
            entrytype,
            userid,
            entityid,
            jobid,
            CASE 
                WHEN CAST(entrydate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE entrydate 
            END as entrydate,
            minutes,
            CASE 
                WHEN CAST(starttime AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE starttime 
            END as starttime,
            status,
            billable,
            xpmtaskid,
            notes,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            writeonoff,
            billableamount,
            CASE 
                WHEN CAST(invoiceddate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoiceddate 
            END as invoiceddate,
            CASE 
                WHEN CAST(invoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoicedamount 
            END as invoicedamount,
            CASE 
                WHEN CAST(timetypeid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timetypeid 
            END as timetypeid,
            quantity,
            category,
            invoiceid,
            documentid,
            clientid,
            organisationid,
            userdisplayname,
            CASE 
                WHEN CAST(usercreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE usercreatedon 
            END as usercreatedon,
            CASE 
                WHEN CAST(usercreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE usercreateduserid 
            END as usercreateduserid,
            CASE 
                WHEN CAST(userlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userlastmodifiedon 
            END as userlastmodifiedon,
            CASE 
                WHEN CAST(userlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userlastmodifieduserid 
            END as userlastmodifieduserid,
            CASE 
                WHEN CAST(userdeleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userdeleteduserid 
            END as userdeleteduserid,
            useremail,
            useremailalias,
            userinactive,
            userproductivitytarget,
            userworkinghours,
            usersource,
            useruserrole,
            userpermissionuserrole,
            entityname,
            entityemail,
            entitysource,
            entitysourceid,
            entityentitygroupid,
            entitydetailsclientcode,
            entitydetailsexportcode,
            entitydetailsuuid,
            entitydetailsbusinessstructure,
            entitycollaborate,
            entitymobile,
            entityphone,
            entityaddress,
            entitycity,
            entityregion,
            entitypostcode,
            entitycountry,
            entitypostaladdress,
            entitypostalcity,
            entitypostalregion,
            entitypostalpostcode,
            entitypostalcountry,
            entitybusinessnumber,
            entitycompanynumber,
            CASE 
                WHEN CAST(entityisdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE entityisdeleted 
            END as entityisdeleted,
            CASE 
                WHEN CAST(entitylastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE entitylastmodifieduserid 
            END as entitylastmodifieduserid,
            CASE 
                WHEN CAST(entitylastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE entitylastmodifiedon 
            END as entitylastmodifiedon,
            jobname,
            jobentityid,
            jobjobstateid,
            CASE 
                WHEN CAST(jobstartdate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobstartdate 
            END as jobstartdate,
            jobjobtypeid,
            jobcabinetid,
            jobmanageruserid,
            jobpartneruserid,
            CASE 
                WHEN CAST(jobcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreateduserid 
            END as jobcreateduserid,
            CASE 
                WHEN CAST(jobcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobcreatedon 
            END as jobcreatedon,
            CASE 
                WHEN CAST(joblastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifiedon 
            END as joblastmodifiedon,
            CASE 
                WHEN CAST(joblastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE joblastmodifieduserid 
            END as joblastmodifieduserid,
            jobcommentscount,
            jobprimary,
            jobtype,
            jobworkflowenabled,
            jobvalue,
            CASE 
                WHEN CAST(jobduedate AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobduedate 
            END as jobduedate,
            jobsource,
            jobsourceid,
            jobbudgetminutes,
            jobactualminutes,
            jobbudgetamount,
            jobactualamount,
            jobwipamount,
            jobwriteonoff,
            CASE 
                WHEN CAST(jobinvoicedamount AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE jobinvoicedamount 
            END as jobinvoicedamount,
            jobparentid,
            jobusers,
            jobtemplateid,
            jobjobcustomfields,
            jobxpmactualminutes,
            jobxpmestimatedminutes,
            jobxpmvarianceminutes,
            rateversionid,
            CASE 
                WHEN CAST(rateversionstartfrom AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE rateversionstartfrom 
            END as rateversionstartfrom,
            rateversionbillablerate,
            rateversionbaserate,
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
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_user;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_user(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_user`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_userstage`');

    SET @delete_default = CONCAT('
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
            displayname,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            CASE 
                WHEN CAST(deleteduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE deleteduserid 
            END as deleteduserid,
            email,
            emailalias,
            inactive,
            productivitytarget,
            workinghours,
            source,
            clientid,
            organisationid,
            userroleid,
            userrolename,
            userroleoptions,
            userroleoptionsrole,
            userroleoptionsaccess,
            userroleoptionsaccessviews,
            userroleoptionsaccessprocess,
            userroleoptionsaccesseditjobs,
            userroleoptionsaccessknowledge,
            userroleoptionsaccesstemplates,
            userroleoptionsaccesscreatejob,
            userroleoptionsaccessprocessrunworkspace,
            userroleoptionscabinets,
            CASE 
                WHEN CAST(userrolecreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userrolecreatedon 
            END as userrolecreatedon,
            CASE 
                WHEN CAST(userrolecreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userrolecreateduserid 
            END as userrolecreateduserid,
            CASE 
                WHEN CAST(userrolelastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userrolelastmodifiedon 
            END as userrolelastmodifiedon,
            CASE 
                WHEN CAST(userrolelastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE userrolelastmodifieduserid 
            END as userrolelastmodifieduserid,
            permissionuserroleid,
            permissionuserrolename,
            permissionuserroleoptions,
            permissionuserroleoptionsrole,
            permissionuserroleoptionsaccess,
            permissionuserroleoptionsaccessviews,
            permissionuserroleoptionsaccessprocess,
            permissionuserroleoptionsaccesseditjobs,
            permissionuserroleoptionsaccessknowledge,
            permissionuserroleoptionsaccesstemplates,
            permissionuserroleoptionsaccesscreatejob,
            permissionuserroleoptionsaccessprocessrunworkspace,
            permissionuserroleoptionscabinets,
            CASE 
                WHEN CAST(permissionuserrolecreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE permissionuserrolecreatedon 
            END as permissionuserrolecreatedon,
            CASE 
                WHEN CAST(permissionuserrolecreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE permissionuserrolecreateduserid 
            END as permissionuserrolecreateduserid,
            CASE 
                WHEN CAST(permissionuserrolelastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE permissionuserrolelastmodifiedon 
            END as permissionuserrolelastmodifiedon,
            CASE 
                WHEN CAST(permissionuserrolelastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE permissionuserrolelastmodifieduserid 
            END as permissionuserrolelastmodifieduserid,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- UserRole
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_userrole;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_userrole(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_userrole`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_userrolestage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            CASE 
                WHEN CAST(createduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createduserid 
            END as createduserid,
            CASE 
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(lastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifieduserid 
            END as lastmodifieduserid,
            clientid,
            organisationid,
            optionsrole,
            optionsaccess,
            optionsaccessviews,
            optionsaccessprocess,
            optionsaccesseditjobs,
            optionsaccessknowledge,
            optionsaccesstemplates,
            optionsaccesscreatejob,
            optionsaccesscollaborate,
            optionsaccesscreatereport,
            optionsaccessprocessrunlist,
            optionsaccesscustomfieldedit,
            optionsaccessexportclientlist,
            optionsaccessprocessrunworkspace,
            optionscabinets,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- InvoiceJobs
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_invoicejobs;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_invoicejobs(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_invoicejobs`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_invoicejobsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            jobid,
            jobname,
            amount,
            wipamount,
            invoiceid,
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

-- CabinetCategories
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_cabinetcategories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_cabinetcategories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_cabinetcategories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_cabinetcategoriesstage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(lastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lastmodifiedon 
            END as lastmodifiedon,
            CASE 
                WHEN CAST(createdon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE createdon 
            END as createdon,
            displayorder,
            isrequired,
            visibletemplates,
            visibleprocesses,
            cabinetid,
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

-- CabinetCatOpts
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_cabinetcatopts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_cabinetcatopts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_cabinetcatopts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_cabinetcatoptsstage`');

    SET @delete_default = CONCAT('
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
            displayorder,
            categoryid,
            detailscabinets,
            detailsconditional,
            cabinetid,
            cabinetcategoriesid,
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

-- CategoryOptions
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_categoryoptions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_categoryoptions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_categoryoptions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_categoryoptionsstage`');

    SET @delete_default = CONCAT('
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
            displayorder,
            categoryid,
            details,
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

-- DocCategories
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_doccategories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_doccategories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_doccategories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_doccategoriesstage`');

    SET @delete_default = CONCAT('
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
            categoryid,
            options,
            documentid,
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

-- DocumentTags
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_documenttags;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_documenttags(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_documenttags`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_documenttagsstage`');

    SET @delete_default = CONCAT('
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
            documentid,
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

-- EntityContacts
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_entitycontacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_entitycontacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_entitycontacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_entitycontactsstage`');

    SET @delete_default = CONCAT('
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
            source,
            sourceid,
            addressee,
            email,
            mobile,
            name,
            phone,
            position,
            salutation,
            CASE 
                WHEN CAST(isdeleted AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE isdeleted 
            END as isdeleted,
            entityid,
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

-- EntityCustomFields
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_entitycustomfields;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_entitycustomfields(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_entitycustomfields`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_entitycustomfieldsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            customfieldid,
            value,
            CASE 
                WHEN CAST(customfieldfieldtype AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldfieldtype 
            END as customfieldfieldtype,
            CASE 
                WHEN CAST(customfieldname AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldname 
            END as customfieldname,
            CASE 
                WHEN CAST(customfieldcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreatedon 
            END as customfieldcreatedon,
            CASE 
                WHEN CAST(customfieldcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreateduserid 
            END as customfieldcreateduserid,
            CASE 
                WHEN CAST(customfieldlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifiedon 
            END as customfieldlastmodifiedon,
            CASE 
                WHEN CAST(customfieldlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifieduserid 
            END as customfieldlastmodifieduserid,
            entityid,
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

-- JobUsers
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobusers;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobusers(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobusers`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobusersstage`');

    SET @delete_default = CONCAT('
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
            jobid,
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

-- JobJobCustFields
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobjobcustfields;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobjobcustfields(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobjobcustfields`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobjobcustfieldsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            customfieldid,
            value,
            customfieldfieldtype,
            customfieldname,
            CASE 
                WHEN CAST(customfieldcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreatedon 
            END as customfieldcreatedon,
            CASE 
                WHEN CAST(customfieldcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreateduserid 
            END as customfieldcreateduserid,
            CASE 
                WHEN CAST(customfieldlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifiedon 
            END as customfieldlastmodifiedon,
            CASE 
                WHEN CAST(customfieldlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifieduserid 
            END as customfieldlastmodifieduserid,
            jobid,
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

-- JobTemplateCustFields
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_jobtemplatecustfields;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_jobtemplatecustfields(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_jobtemplatecustfields`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_jobtemplatecustfieldsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            customfieldid,
            value,
            jobtemplateid,
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

-- RateVersions
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_rateversions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_rateversions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_rateversions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_rateversionsstage`');

    SET @delete_default = CONCAT('
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
                WHEN CAST(startfrom AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE startfrom 
            END as startfrom,
            billablerate,
            baserate,
            rateid,
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

-- TimeEntryCustomFields
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_timeentrycustomfields;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_timeentrycustomfields(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_fyi_timeentrycustomfields`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_fyi_timeentrycustomfieldsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            customfieldid,
            value,
            customfieldfieldtype,
            customfieldname,
            CASE 
                WHEN CAST(customfieldcreatedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreatedon 
            END as customfieldcreatedon,
            CASE 
                WHEN CAST(customfieldcreateduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldcreateduserid 
            END as customfieldcreateduserid,
            CASE 
                WHEN CAST(customfieldlastmodifiedon AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifiedon 
            END as customfieldlastmodifiedon,
            CASE 
                WHEN CAST(customfieldlastmodifieduserid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE customfieldlastmodifieduserid 
            END as customfieldlastmodifieduserid,
            CASE 
                WHEN CAST(timeentryid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timeentryid 
            END as timeentryid,
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

-- FYI LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_fyi_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_fyi_lastrefreshdate(
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

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_fyi_lastrefreshdate`');

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
