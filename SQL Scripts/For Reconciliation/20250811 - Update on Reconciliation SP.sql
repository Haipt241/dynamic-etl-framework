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
    SET @banktransfertable = CONCAT('c',v_clientid,'_xeroblue_banktransfers');
    SET @trackingcattable = CONCAT('c',v_clientid,'_xeroblue_trackingcategories');

    SET @sql = '';

    -- Add isvisible column if missing - Start
    WITH missing_columns AS (
        SELECT 'isvisible' AS column_name, 'boolean NULL DEFAULT TRUE AFTER `DueDate`' AS column_definition 
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
        SELECT 'isvisible' AS column_name, 'boolean NULL DEFAULT TRUE AFTER `DueDate`' AS column_definition 
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
    -- Add isvisible column if missing - End

    -- Get next ID if not provided
    IF p_id = 0 THEN
        SET @sql = CONCAT('SELECT IFNULL(MAX(id)+1, 1) INTO @id FROM xeroblue_reconciliation LIMIT 1;');
        PREPARE idstmt FROM @sql;
        EXECUTE idstmt;
        DEALLOCATE PREPARE idstmt;
        SET v_id = @id;
        SET @sql = CONCAT(
            'INSERT INTO xeroblue_reconciliation (
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

    -- Check for duplicate journal numbers
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

    -- Check for missing journal numbers
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
    
    IF v_id != 0 THEN
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

    -- Fix missing details - Start
    -- Check and update journals with missing contact details
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
            WHERE j.ContactID IS NULL AND j.SourceID IS NOT NULL AND j.OrganisationID = ',v_organisationid,';'
            );
    PREPARE updatestmt1 FROM @sql;
    EXECUTE updatestmt1;
    DEALLOCATE PREPARE updatestmt1;

    -- Check and update journals with NULL SourceID
    SET @sql = CONCAT('UPDATE ',@finaltable,'       
            SET  `SourceID` = ''unknown''
            WHERE ContactID IS null AND SourceID IS null AND OrganisationID = ',v_organisationid,';'
            );
    PREPARE updatestmt2 FROM @sql;
    EXECUTE updatestmt2;
    DEALLOCATE PREPARE updatestmt2;

    -- Check and update journals with missing option names
    SET @sql = CONCAT('UPDATE ',@finaltable,' j
            JOIN ',@trackingcattable,' tc
            ON j.LineItem_TrackingCategory1_CategoryId  = tc.TrackingCategoryId
            AND j.LineItem_TrackingCategory1_OptionId  = tc.TrackingOptionId
            AND J.OrganisationID = tc.OrganisationID
            SET
            j.LineItem_TrackingCategory1_OptionName = tc.OptionName
            WHERE j.LineItem_TrackingCategory1_OptionName <> tc.OptionName 
            AND j.OrganisationID = ',v_organisationid,';'
            );
    PREPARE updatestmt3 FROM @sql;
    EXECUTE updatestmt3;
    DEALLOCATE PREPARE updatestmt3;

    SET @sql = CONCAT('UPDATE ',@finaltable,' j
            JOIN ',@trackingcattable,' tc
            ON j.LineItem_TrackingCategory2_CategoryId  = tc.TrackingCategoryId
            AND j.LineItem_TrackingCategory2_OptionId  = tc.TrackingOptionId
            AND J.OrganisationID = tc.OrganisationID
            SET
            j.LineItem_TrackingCategory2_OptionName = tc.OptionName
            WHERE j.LineItem_TrackingCategory2_OptionName <> tc.OptionName 
            AND j.OrganisationID = ',v_organisationid,';'
            );
    PREPARE updatestmt4 FROM @sql;
    EXECUTE updatestmt4;
    DEALLOCATE PREPARE updatestmt4;

    -- Update PaymentSourceID and PaymentType for Credit Notes with allocations
    SET @sql = CONCAT('UPDATE ',@finaltable,' J
        JOIN ',@transtable,' T
            ON j.`SourceId` = t.`Id`
            AND j.`OrganisationID` = t.`OrganisationID`
            AND j.`JournalLine_GrossAmount` = 
                    CASE WHEN ContactSource = ''CREDITNOTES'' 
                        THEN t.`AllocationAmount` * -1
                    ELSE t.`AllocationAmount`
                    END
        SET  
            J.`PaymentSourceID` = t.`PaymentSourceID`,
            J.`PaymentType` = t.`PaymentType`
        WHERE j.SystemAccount = ''DEBTORS''
        AND j.OrganisationId = ',v_organisationid,';');
    PREPARE updatestmt10 FROM @sql;
    EXECUTE updatestmt10;
    DEALLOCATE PREPARE updatestmt10;

    -- Update AgedMovement for journals
    SET @sql = CONCAT('UPDATE ',@finaltable,' J
        SET  
            j.`AgedMovement` =
            CASE
                WHEN J.`SourceType` = ''ACCREC'' THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCPAY'' THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCRECCREDIT'' AND J.PaymentSourceID IS NULL THEN ''Accruals''
                WHEN J.`SourceType` = ''ACCRECCREDIT'' AND J.PaymentSourceID IS NOT NULL THEN ''Payments''
                WHEN J.`SourceType` = ''ACCRECPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''ACCPAYCREDIT'' THEN ''Payments''
                WHEN J.`SourceType` = ''ARPREPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''AROVERPAYMENT'' THEN ''Payments''
                WHEN J.`SourceType` = ''APOVERPAYMENT''  THEN ''CashOPPP''
                ELSE NULL
            END
        WHERE OrganisationId = ',v_organisationid,';');
    PREPARE updatestmt11 FROM @sql;
    EXECUTE updatestmt11;
    DEALLOCATE PREPARE updatestmt11;
    -- Fix missing details - End


    -- Hide journals with following criterias - Start
    -- Check and hide journals with duplicate line items for same SourceID
    SET @sql = CONCAT('WITH JournalTotals AS (
            SELECT 
                SourceId,
                JournalNumber,
                JournalDate,
                CreatedDateUTC,
                SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2))) AS Total_NetAmount,
                SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2))) AS Total_GrossAmount,
                LAG(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_NetAmount,
                LAG(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_GrossAmount,
                LAG(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagCreatedDateUTC,
                LEAD(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_NetAmount,
                LEAD(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_GrossAmount,
                LEAD(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadCreatedDateUTC
            FROM ',@finaltable,'
            WHERE JournalLine_JournalLineId IS NOT NULL
                AND SourceId IS NOT NULL
                AND SourceID != ''unknown''
                AND OrganisationId = ',v_organisationid,'
            GROUP BY 
                SourceId,
                JournalNumber,
                JournalDate,
                CreatedDateUTC
            )
            UPDATE ',@finaltable,' j
            JOIN JournalTotals jt
            ON j.SourceId = jt.SourceId
                AND j.JournalNumber = jt.JournalNumber
            SET j.isvisible = 
                CASE 
                    WHEN LagCreatedDateUTC IS NULL 
                        AND LeadCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    WHEN LeadCreatedDateUTC IS NOT NULL
                        AND LagCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LagTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LagTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    WHEN LeadCreatedDateUTC <> jt.CreatedDateUTC
                        AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
                        AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
                    THEN 0
                    ELSE 1
                END
            WHERE OrganisationId = ',v_organisationid,';'
            );
    PREPARE updatestmt6 FROM @sql;
    EXECUTE updatestmt6;
    DEALLOCATE PREPARE updatestmt6;
    
    -- Check and show journals for invoice allocation
    SET @sql = CONCAT('WITH invallocation AS (
            SELECT j.SourceId
                ,j.journalnumber 
                ,j.JournalDate
                ,j.createddateutc
                ,j.Sourcetype
                ,j.JournalLine_AccountName
                ,j.JournalLine_GrossAmount
                ,j.isvisible
                ,j.ContactSource
                ,j.InvoiceNumber
                ,t.PaymentSourceID
                ,t.PaymentType
                ,t.AllocationDate
                ,t.AllocationAmount
                ,ROW_NUMBER() OVER(
                        PARTITION BY j.JournalLine_AccountName, j.JournalLine_GrossAmount 
                        ORDER BY j.journalnumber DESC
                    ) AS rn
            FROM ',@finaltable,' j
            JOIN ',@transtable,' t
                ON t.ID = j.SourceID 
                AND t.OrganisationID = j.OrganisationID
                AND t.AllocationAmount = j.JournalLine_GrossAmount
            WHERE j.ContactSource IN (''CREDITNOTES'', ''OVERPAYMENTS'', ''PREPAYMENTS'')
                AND j.OrganisationId = ',v_organisationid,'
            )
            UPDATE ',@finaltable,' j
            JOIN invallocation i
                ON i.journalnumber = j.journalnumber
            SET j.isvisible = 
                    CASE
                        WHEN rn = 1 THEN 1
                        ELSE 0
                    END
            WHERE j.OrganisationId = ',v_organisationid,';'
            );
    PREPARE updatestmt7 FROM @sql;
    EXECUTE updatestmt7;
    DEALLOCATE PREPARE updatestmt7;

    -- Check and show journals with 2 or less records for SourceID
    SET @sql = CONCAT('WITH journaloutdated AS (
            SELECT SourceId
                ,COUNT(DISTINCT journalnumber) AS rc
            FROM ',@finaltable,'
            WHERE OrganisationId = ',v_organisationid,'
            GROUP BY SourceId
            )
            UPDATE ',@finaltable,' j
            JOIN journaloutdated i
                ON i.SourceId = j.SourceId
                AND i.rc <= 2
            SET j.isvisible = 1
            WHERE j.OrganisationId = ',v_organisationid,';'
            );
    PREPARE updatestmt8 FROM @sql;
    EXECUTE updatestmt8;
    DEALLOCATE PREPARE updatestmt8;

    -- Check and hide outliers from journals
    SET @sql = CONCAT('WITH outliers AS (
            SELECT SourceId
                ,journalnumber
                ,LAG(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelag
                ,LEAD(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelead
                ,isvisible
            FROM ',@finaltable,'
            WHERE OrganisationId = ',v_organisationid,'
            GROUP BY SourceId, journalnumber, isvisible
            )
            UPDATE ',@finaltable,' j
            JOIN outliers i
                ON i.SourceId = j.SourceId
                AND i.journalnumber = j.journalnumber
            SET j.isvisible = 0
            WHERE isvisiblelag = 0 AND isvisiblelead = 0
            AND j.OrganisationId = ',v_organisationid,';'
            );
    PREPARE updatestmt9 FROM @sql;
    EXECUTE updatestmt9;
    DEALLOCATE PREPARE updatestmt9;

    -- Check and hide journals with VOIDED/DELETED/TRANSFERRED status of SourceID
    SET @sql = CONCAT('UPDATE ',@finaltable,' J
            LEFT JOIN (
                    SELECT DISTINCT ID, Source, Status, OrganisationID FROM ',@transtable,'
                    WHERE Status IN (''VOIDED'', ''DELETED'')
                ) DELETED 
                ON DELETED.ID = J.SourceID AND DELETED.OrganisationID = J.OrganisationID
            LEFT JOIN (
                    SELECT BankTransferID, OrganisationID FROM ',@banktransfertable,'
                ) BT 
                ON BT.BankTransferID = J.SourceID AND BT.OrganisationID = J.OrganisationID
            SET isvisible = 0
            WHERE (
                DELETED.ID IS NOT NULL 
                OR (
                        J.SourceType = ''TRANSFER''
                    AND BT.BankTransferID IS NULL
                    )
                )
            AND J.OrganisationId = ',v_organisationid,';'
            );
    PREPARE updatestmt5 FROM @sql;
    EXECUTE updatestmt5;
    DEALLOCATE PREPARE updatestmt5;
    -- Hide journals with following criterias - End

    -- Update the reconciliation record
    SET @sql = CONCAT(
        'UPDATE xeroblue_reconciliation
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

    -- Fetch the reconciliation record
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
        FROM xeroblue_reconciliation
        WHERE id = ',v_id,';');
    PREPARE selectstmt FROM @sql;
    EXECUTE selectstmt;
    DEALLOCATE PREPARE selectstmt;
END