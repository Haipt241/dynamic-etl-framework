
DROP TABLE IF EXISTS c1518_xeroblue_reconciliation;
CREATE TABLE IF NOT EXISTS c1518_xeroblue_reconciliation (
    id int PRIMARY KEY,
    clientid varchar(255) NULL,
    organisationid varchar(255) NULL,
    tablename varchar(255) NULL,
    uniquekey varchar(255) NULL,
    filterkey varchar(255) NULL,
    recordcount int NULL,
    uniquerecordcount int NULL,
    filterkeycount int NULL,
    minfilterkey int NULL,
    maxfilterkey int NULL,    
    date varchar(255) NULL,
    status varchar(255) NULL,
    comment text NULL
);


DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_reconciliation $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_reconciliation (
        IN p_id int
    )
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_recordcount INT;
    DECLARE v_uniquerecordcount INT;
    DECLARE v_filterkeycount INT;
    DECLARE v_minfilterkey INT;
    DECLARE v_maxfilterkey INT;
    DECLARE v_comment text DEFAULT '';
    DECLARE v_missingids text DEFAULT '';
    DECLARE v_duplicateids text DEFAULT '';
    DECLARE v_status varchar(255) DEFAULT '';

    SELECT 
        COUNT(*) AS recordcount 
        ,COUNT(DISTINCT ID) AS uniquerecordcount
        ,COUNT(DISTINCT JournalNumber) AS filterkeycount
        ,MIN(JournalNumber) AS minfilterkey
        ,MAX(JournalNumber) AS maxfilterkey
    INTO
        v_recordcount, 
        v_uniquerecordcount, 
        v_filterkeycount, 
        v_minfilterkey, 
        v_maxfilterkey
    FROM c1518_xeroblue_journals
    WHERE OrganisationID = 5393
    GROUP BY clientid, OrganisationID;

    IF p_id = 0 THEN
        SELECT IFNULL(MAX(id)+1, 1) INTO v_id FROM c1518_xeroblue_reconciliation 
        WHERE OrganisationID = v_OrganisationID 
        AND tablename = 'c1518_xeroblue_journals'
        LIMIT 1;

        INSERT INTO c1518_xeroblue_reconciliation (
            id,
            clientid,
            organisationid,
            tablename,
            uniquekey,
            filterkey,
            date
        )
        SELECT
            v_id
            ,clientid
            ,OrganisationID
            ,'c1518_xeroblue_journals' AS tablename
            ,'ID' AS uniquekey
            ,'JournalNumber' AS filterkey
            ,NOW() AS date
        FROM c1518_xeroblue_journals
        WHERE OrganisationID = 5393
        GROUP BY clientid, OrganisationID;

    ELSE
        set v_id = p_id;
    END IF;
    
    IF v_recordcount > v_uniquerecordcount THEN
        SET v_comment = CONCAT(v_comment, '"possibleDuplicate": ');
        WITH duplicates AS (
            SELECT
                ID
                ,JournalNumber
                ,SourceID
                ,ROW_NUMBER() OVER(PARTITION BY JournalNumber,id ORDER BY JournalNumber,id) AS RN
                ,OrganisationID
            FROM c1518_xeroblue_journals
            WHERE OrganisationID = v_OrganisationID
        )
        SELECT GROUP_CONCAT(CONCAT('"',ID,'"') SEPARATOR ', ')
        INTO v_duplicateids
        FROM duplicates WHERE RN > 1;

        SET v_comment = CONCAT(v_comment, '[', v_duplicateids ,']');
    END IF;
    
    IF v_maxfilterkey > v_filterkeycount OR v_minfilterkey > 1 THEN

        IF v_comment != '[{' THEN
            SET  v_comment = CONCAT(v_comment, ', ');
            END IF;
        SET v_comment = CONCAT(v_comment, '"missingJournalNumbers": ');
        WITH RECURSIVE gaps AS (
            SELECT 
                JournalNumber AS MaxID,
                IFNULL(LAG(JournalNumber) OVER (ORDER BY JournalNumber),0) AS MinID
            FROM c1518_xeroblue_journals 
            WHERE OrganisationID = v_OrganisationID
        ),
        gap_ranges AS (
            SELECT 
                MinID + 1 AS start_id,
                MaxID - 1 AS end_id
            FROM gaps
            WHERE MaxID - MinID > 1
        )
        SELECT 
            GROUP_CONCAT(
            CASE 
            WHEN start_id = end_id THEN CONCAT('"',start_id,'"')
            ELSE CONCAT('"',start_id,'-',end_id,'"') 
            END SEPARATOR ',') AS missing_journalnumbers
        INTO v_missingids
        FROM gap_ranges;

        SET v_comment = CONCAT(v_comment, '[', v_missingids ,']');
    END IF;
    SET v_comment = CONCAT('[{', v_comment, '}]');
    
    IF p_id = v_id THEN
        SET v_status = CASE
            WHEN v_recordcount = v_uniquerecordcount 
                AND v_maxfilterkey = v_filterkeycount
                AND v_minfilterkey = 1
                THEN'DONE'
                ELSE 'FAILED'
            END;
    ELSE
        SET v_status = 'PENDING';
    END IF;

    UPDATE c1518_xeroblue_reconciliation
    SET 
        recordcount = v_recordcount
        ,uniquerecordcount = v_uniquerecordcount
        ,filterkeycount = v_filterkeycount
        ,minfilterkey = v_minfilterkey
        ,maxfilterkey = v_maxfilterkey
        ,comment = v_comment
        ,status = v_status
    WHERE id = v_id;

    SELECT 
        id, 
        clientid, 
        organisationid, 
        tablename,
        uniquekey,
        filterkey,
        recordcount, 
        uniquerecordcount, 
        filterkeycount, 
        minfilterkey, 
        maxfilterkey, 
        date, 
        status, 
        comment
    FROM c1518_xeroblue_reconciliation
    WHERE id = v_id;

END $$
DELIMITER ;


CREATE DEFINER=`etaniadmin`@`%` PROCEDURE `sp_dynamic_xeroblue_reconciliation`(
        IN p_id int,
        IN p_endpoint varchar(255),
        IN p_clientid int,
        IN p_organisationid int,
        IN p_legacyorganisationid int
    )
BEGIN
    DECLARE v_organisationid INT DEFAULT p_organisationid;
    DECLARE v_clientid INT DEFAULT p_clientid;
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_recordcount INT;
    DECLARE v_uniquerecordcount INT;
    DECLARE v_filterkeycount INT;
    DECLARE v_minfilterkey INT;
    DECLARE v_maxfilterkey INT;
    DECLARE v_comment text DEFAULT '';
    DECLARE v_missingids text DEFAULT '';
    DECLARE v_duplicateids text DEFAULT '';
    DECLARE v_status varchar(255) DEFAULT '';
    DECLARE v_table varchar(255) DEFAULT p_endpoint;

    SET v_organisationid = CASE WHEN p_legacyorganisationid <> 0 THEN p_legacyorganisationid ELSE p_organisationid END;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET SESSION group_concat_max_len = 4294967295;
    SET @stagetable = CONCAT('c', v_clientid, '_', p_organisationid, '_xeroblue_', v_table, 'stage');
    SET @finaltable = CONCAT('c',v_clientid,'_xeroblue_', v_table);
    SET @transtable = CONCAT('c',v_clientid,'_xeroblue_transactions');

    SET @sql = '';
    WITH missing_columns AS (
        SELECT 'isvisible' AS column_name, 'boolean NULL' AS column_definition 
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set1
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @finaltable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    WITH missing_columns AS (
        SELECT 'isvisible' AS column_name, 'boolean NULL' AS column_definition 
    )
    SELECT GROUP_CONCAT(CONCAT('ADD COLUMN `', mc.column_name, '` ', mc.column_definition,CHAR(10)))
    INTO @columns_to_add_set2
    FROM missing_columns mc
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS ic
        ON ic.TABLE_SCHEMA = DATABASE()
        AND ic.TABLE_NAME = @stagetable
        AND ic.COLUMN_NAME = mc.column_name
    WHERE ic.COLUMN_NAME IS NULL;

    IF @columns_to_add_set1 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @finaltable, ' ', @columns_to_add_set1);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    IF @columns_to_add_set2 IS NOT NULL THEN
        SET @sql = CONCAT('ALTER TABLE ', @stagetable, ' ', @columns_to_add_set2);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    SET @sql = CONCAT(
        'SELECT 
            COUNT(*) AS recordcount 
            ,COUNT(DISTINCT ID) AS uniquerecordcount
            ,COUNT(DISTINCT JournalNumber) AS filterkeycount
            ,MIN(JournalNumber) AS minfilterkey
            ,MAX(JournalNumber) AS maxfilterkey
        INTO 
            @recordcount,
            @uniquerecordcount,
            @filterkeycount, 
            @minfilterkey, 
            @maxfilterkey
        FROM ',@finaltable,' 
        WHERE OrganisationID = ',v_organisationid,'
        GROUP BY clientid, OrganisationID;');
    PREPARE checkstmt FROM @sql;
    EXECUTE checkstmt;
    DEALLOCATE PREPARE checkstmt;

    IF p_id = 0 THEN
        SET @sql = CONCAT('SELECT IFNULL(MAX(id)+1, 1) INTO @id FROM c',v_clientid,'_xeroblue_reconciliation LIMIT 1;');
        PREPARE idstmt FROM @sql;
        EXECUTE idstmt;
        DEALLOCATE PREPARE idstmt;
        SET v_id = @id;
        SET @sql = CONCAT(
            'INSERT INTO c',v_clientid,'_xeroblue_reconciliation (
                id,
                clientid,
                organisationid,
                tablename,
                uniquekey,
                filterkey,
                date,
                recordcount, 
                uniquerecordcount, 
                filterkeycount, 
                minfilterkey, 
                maxfilterkey
            )
            SELECT
                ',v_id,'
                ,clientid
                ,OrganisationID
                ,''',@finaltable,''' AS tablename
                ,''ID'' AS uniquekey
                ,''JournalNumber'' AS filterkey
                ,NOW() AS date,
                @recordcount, 
                @uniquerecordcount, 
                @filterkeycount, 
                @minfilterkey, 
                @maxfilterkey
            FROM ',@finaltable,'
            WHERE OrganisationID = ',v_organisationid,'
            GROUP BY clientid, OrganisationID;');
        PREPARE insertstmt FROM @sql;
        EXECUTE insertstmt;
        DEALLOCATE PREPARE insertstmt;

    ELSE
        set v_id = p_id;
    END IF;
    -- Check for duplicates
    IF @recordcount > @uniquerecordcount THEN
        SET v_comment = CONCAT(v_comment, '"possibleDuplicate": ');
        SET @sql = CONCAT(
            'WITH duplicates AS (
                SELECT
                    ID
                    ,JournalNumber
                    ,SourceID
                    ,ROW_NUMBER() OVER(PARTITION BY JournalNumber,id ORDER BY JournalNumber,id) AS RN
                    ,OrganisationID
                FROM ',@finaltable,'
                WHERE OrganisationID = ',v_organisationid,'
            )
            SELECT GROUP_CONCAT(CONCAT(''"'',ID,''"'') SEPARATOR '', '')
            INTO @duplicateids
            FROM duplicates WHERE RN > 1;');
        PREPARE dupstmt FROM @sql;
        EXECUTE dupstmt;
        DEALLOCATE PREPARE dupstmt;

        SET v_comment = CONCAT(v_comment, '[', @duplicateids ,']');
    END IF;
    -- Check for missing
    IF @maxfilterkey > @filterkeycount OR @minfilterkey > 1 THEN

        IF v_comment != '' THEN
            SET  v_comment = CONCAT(v_comment, ', ');
            END IF;
        SET v_comment = CONCAT(v_comment, '"missingJournalNumbers": ');
        SET @sql = CONCAT(
            'WITH RECURSIVE gaps AS (
                SELECT 
                    JournalNumber AS MaxID,
                    IFNULL(LAG(JournalNumber) OVER (ORDER BY JournalNumber),0) AS MinID
                FROM ',@finaltable,'
                WHERE OrganisationID = ',v_organisationid,'
            ),
            gap_ranges AS (
                SELECT 
                    MinID + 1 AS start_id,
                    MaxID - 1 AS end_id
                FROM gaps
                WHERE MaxID - MinID > 1
            )
            SELECT 
                GROUP_CONCAT(
                CASE 
                WHEN start_id = end_id THEN CONCAT(''"'',start_id,''"'')
                ELSE CONCAT(''"'',start_id,''-'',end_id,''"'') 
                END SEPARATOR '', '') AS missing_journalnumbers
            INTO @missingids
            FROM gap_ranges;');
            PREPARE missingstmt FROM @sql;
            EXECUTE missingstmt;
            DEALLOCATE PREPARE missingstmt;

        SET v_comment = CONCAT(v_comment, '[', @missingids ,']');
    END IF;

    SET v_comment = CONCAT('[{', v_comment, '}]');
    
    IF p_id = v_id THEN
        SET v_status = CASE
            WHEN @recordcount = @uniquerecordcount 
                AND @maxfilterkey = @filterkeycount
                AND @minfilterkey = 1
                THEN'DONE'
                ELSE 'FAILED'
            END;
    ELSE
        SET v_status = 'PENDING';
    END IF;


    SET @sql = CONCAT('UPDATE ',@finaltable,' J
            LEFT JOIN ',@transtable,' T
                    ON j.`SourceId` = t.`Id`
                    AND j.`OrganisationID` = t.`OrganisationID`        
            SET  J.`ContactId` = t.`ContactID`, 
                J.`ContactName` = t.`ContactName`, 
                J.`ContactSource` = t.`Source`,
                J.`PaymentSourceID` = CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentSourceID` ELSE NULL END,
                J.`PaymentType` =  CASE WHEN t.`Source` = ''PAYMENTS'' THEN t.`PaymentType` ELSE NULL END,
                J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
                J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
                J.`DayDifference` = t.`DayDifference`, 
                J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
                J.`ItemCode` = t.`ItemCode`, 
                J.`Quantity` = t.`Quantity`,
                J.`DiscountRate` = t.`DiscountRate`, 
                J.`CreditNoteNumber` = t.`CreditNoteNumber`,
                J.`UnitAmount` = t.`UnitAmount`, 
                J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
                J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
                J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
                J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
                J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
                J.`AmountDue` = t.`AmountDue`, 
                J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
                J.`AmountDue_USD` = t.`AmountDue_USD`, 
                J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
                J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
                J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
                J.`URL` = t.`URL`, 
                J.`InvoiceNumber` = t.`InvoiceNumber`,
                J.`DueDate` = t.`DueDate`, 
                J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END
            WHERE j.ContactID IS null'
            );
    PREPARE updatestmt FROM @sql;
    EXECUTE updatestmt;
    DEALLOCATE PREPARE updatestmt;

    SET @sql = CONCAT('UPDATE ',@finaltable,'       
            SET  `SourceID` = ''unknown''
            WHERE ContactID IS null and SourceID IS null'
            );
    PREPARE updatestmt2 FROM @sql;
    EXECUTE updatestmt2;
    DEALLOCATE PREPARE updatestmt2;
    
    SET @sql = CONCAT(
        'UPDATE c',v_clientid,'_xeroblue_reconciliation
        SET 
            recordcount = @recordcount
            ,uniquerecordcount = @uniquerecordcount
            ,filterkeycount = @filterkeycount
            ,minfilterkey = @minfilterkey
            ,maxfilterkey = @maxfilterkey
            ,comment = ''',v_comment,'''
            ,status = ''',v_status,'''
        WHERE id = ',v_id,';');
    PREPARE updstmt FROM @sql;
    EXECUTE updstmt;
    DEALLOCATE PREPARE updstmt;

    SET @sql = CONCAT(
        'SELECT 
            id, 
            clientid, 
            organisationid, 
            tablename,
            uniquekey,
            filterkey,
            recordcount, 
            uniquerecordcount, 
            filterkeycount, 
            minfilterkey, 
            maxfilterkey, 
            date, 
            status, 
            comment
        FROM c',v_clientid,'_xeroblue_reconciliation
        WHERE id = ',v_id,';');
    PREPARE selectstmt FROM @sql;
    EXECUTE selectstmt;
    DEALLOCATE PREPARE selectstmt;

END