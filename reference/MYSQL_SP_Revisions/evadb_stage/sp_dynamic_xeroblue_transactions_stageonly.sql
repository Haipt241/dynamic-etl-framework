CREATE DEFINER=`etaniadmin`@`%` PROCEDURE `sp_dynamic_xeroblue_transactions_stageonly`(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT,
	IN `p_legacyClientId` VARCHAR(255)
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    DECLARE v_legacyClientID VARCHAR(255) DEFAULT p_legacyClientId;
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    -- Replace hardcoded table references with dynamic ones
    SET @transactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_transactionsstage');
    SET @creditnotesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_creditnotesstage');
    SET @invoicesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_invoicesstage');
    SET @overpaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_overpaymentsstage');
    SET @prepaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_prepaymentsstage');
    SET @manualJournalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_manualjournalsstage');
    SET @banktransactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransactionsstage');
    SET @paymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_paymentsstage');

    SET @transactionsProd = CONCAT('c', v_clientID, '_xeroblue_transactions');
    SET @creditnotesProd = CONCAT('c', v_clientID, '_xeroblue_creditnotes');
    SET @invoicesProd = CONCAT('c', v_clientID, '_xeroblue_invoices');
    SET @overpaymentsProd = CONCAT('c', v_clientID, '_xeroblue_overpayments');
    SET @prepaymentsProd = CONCAT('c', v_clientID, '_xeroblue_prepayments');
    SET @manualJournalsProd = CONCAT('c', v_clientID, '_xeroblue_manualjournals');
    SET @banktransactionsProd = CONCAT('c', v_clientID, '_xeroblue_banktransactions');
    SET @paymentsProd = CONCAT('c', v_clientID, '_xeroblue_payments');

    SET @paymentsIndexCols = 'OrganisationID,InvoiceId,PaymentType';
    SET @invoicesIndexOrgId = 'OrganisationID';
    SET @creditnotesIndexCols = 'CreditNoteId,OrganisationID';
    SET @prepaymentsIndexCols = 'OrganisationID,PrepaymentId';
    SET @overpaymentsIndexCols = 'OrganisationID,OverpaymentId';
    SET @manualJournalsIndexCols = 'OrganisationID';
    SET @banktransactionsIndexCols = 'OrganisationID';
    
    SELECT index_name INTO @paymentsIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_payments%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @paymentsIndexCols
        LIMIT 1;

    SELECT index_name INTO @invoicesIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_invoices%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @invoicesIndexOrgId
        LIMIT 1;

    SELECT index_name INTO @creditnotesIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_creditnotes%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @creditnotesIndexCols
        LIMIT 1;

    SELECT index_name INTO @prepaymentsIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_prepayments%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @prepaymentsIndexCols
        LIMIT 1;
    
    SELECT index_name INTO @overpaymentsIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_overpayments%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @overpaymentsIndexCols
        LIMIT 1;

    SELECT index_name INTO @manualJournalsIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_manualjournals%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @manualJournalsIndexCols
        LIMIT 1;

    SELECT index_name INTO @banktransactionsIndexName
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name LIKE CONCAT('c', v_clientID, '_xeroblue_banktransactions%')
        GROUP BY index_name
        HAVING GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',') = @banktransactionsIndexCols
        LIMIT 1;

    
    SET @trunc_table = CONCAT('
        TRUNCATE TABLE ',@transactionsStage,';
    ');
    PREPARE stmt FROM @trunc_table;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @batchsize = 1000;
    SET @ffset = 0;
    SET @done = 0;
    
    WHILE @done = 0 DO    
	    SET @insert_intostage = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                C.`Id` AS `LineID`,
                C.`CreditNoteId` AS `ID`,
                C.`Date` AS `Date`,
                C.`Type` AS `Type`,
                C.`Contact_ContactId` AS `ContactID`,
                C.`Contact_Name` AS `ContactName`,
                NULL AS `LineItemID`,
                C.`LineItem_Description` AS `Description`,
                C.`LineItem_Quantity` AS `Quantity`,
                C.`LineItem_UnitAmount` AS `UnitAmount`,
                C.`LineItem_ItemCode` AS `ItemCode`,
                C.`LineItem_AccountCode` AS `AccountCode`,
                C.`LineItem_TaxType` AS `TaxType`,
                C.`LineItem_TaxAmount` AS `TaxAmount`,
                C.`LineItem_LineAmount` AS `LineAmount`,
                C.`LineAmountTypes` AS `LineAmountTypes`,
                C.`Status` AS `Status`,
                C.`SubTotal` AS `SubTotal`,
                C.`TotalTax` AS `TotalTax`,
                C.`Total` AS `Total`,
                C.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                C.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                C.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                C.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                C.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                C.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                C.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                C.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                C.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                C.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                C.`LineItem_DiscountRate` AS `DiscountRate`,
                C.`CurrencyCode` AS `CurrencyCode`,
                CAST(C.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                C.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(C.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(C.`OrganisationID` AS CHAR)) AS `AccountUID`,
                C.`HasAttachments` AS `HasAttachments`,
                C.`CreditNoteNumber` AS `CreditNoteNumber`,
                C.`RemainingCredit` AS `RemainingCredit`,
                C.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                C.`Reference` AS `Reference`,
                ''CREDITNOTES'' AS `Source`,
                C.`ClientID` AS `ClientID`,
                C.`OrganisationID` AS `OrganisationID`,
                C.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                C.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                C.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                C.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                C.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                C.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                C.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                C.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                C.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                C.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                C.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                C.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                C.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                C.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                C.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                C.`SubTotal_AUD` AS `SubTotal_AUD`,
                C.`SubTotal_USD` AS `SubTotal_USD`,
                C.`SubTotal_NZD` AS `SubTotal_NZD`,
                C.`SubTotal_EUR` AS `SubTotal_EUR`,
                C.`SubTotal_GBP` AS `SubTotal_GBP`,
                C.`TotalTax_AUD` AS `TotalTax_AUD`,
                C.`TotalTax_USD` AS `TotalTax_USD`,
                C.`TotalTax_NZD` AS `TotalTax_NZD`,
                C.`TotalTax_EUR` AS `TotalTax_EUR`,
                C.`TotalTax_GBP` AS `TotalTax_GBP`,
                C.`Total_AUD` AS `Total_AUD`,
                C.`Total_USD` AS `Total_USD`,
                C.`Total_NZD` AS `Total_NZD`,
                C.`Total_EUR` AS `Total_EUR`,
                C.`Total_GBP` AS `Total_GBP`,
                C.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                C.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                C.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                C.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                C.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                CA.InvoiceId AS `PaymentSourceID`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Dt ELSE NULL END AS `AllocationDate`,
                CASE WHEN CA.InvoiceId IS NOT NULL THEN CA.Amount ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User`,
                NULL AS `Details`,
                DATEDIFF(C.`FullyPaidOnDate`, C.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                C.`RemainingCredit` AS `AmountDue`,
                C.`RemainingCredit_AUD` AS `AmountDue_AUD`,
                C.`RemainingCredit_USD` AS `AmountDue_USD`,
                C.`RemainingCredit_NZD` AS `AmountDue_NZD`,
                C.`RemainingCredit_EUR` AS `AmountDue_EUR`,
                C.`RemainingCredit_GBP` AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ',@creditnotesProd,' C  FORCE INDEX(',@creditnotesIndexName,') 
            INNER JOIN ',@creditnotesStage,' CS ON C.`CreditNoteID` = CS.`CreditNoteID`
            LEFT JOIN (
                SELECT DISTINCT
                    `CreditNoteId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `ClientID`,
                    `OrganisationID`
                FROM evadb.',v_legacyClientID,'_xeroblue_creditnoteallocations_aud
                WHERE `OrganisationID` = ',v_OrganisationID,'
            ) CA
                ON C.`CreditNoteID` = CA.`CreditNoteID` 
                AND C.`OrganisationID` = CA.`OrganisationID`
            WHERE c.OrganisationID = ',v_OrganisationID,'
            LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
	    PREPARE stmt1 FROM @insert_intostage;
	    EXECUTE stmt1;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
	    DEALLOCATE PREPARE stmt1;
	   
	   SET @ffset = @ffset + @batchsize;	   
	END WHILE;
    
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage2 = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                I.`Id` AS `LineID`,
                I.`InvoiceId` AS `ID`,
                I.`Date` AS `Date`,
                I.`Type` AS `Type`,
                I.`ContactId` AS `ContactID`,
                I.`ContactName` AS `ContactName`,
                I.`LineItem_LineItemId` AS `LineItemID`,
                I.`LineItem_Description` AS `Description`,
                I.`LineItem_Quantity` AS `Quantity`,
                I.`LineItem_UnitAmount` AS `UnitAmount`,
                I.`LineItem_ItemCode` AS `ItemCode`,
                I.`LineItem_AccountCode` AS `AccountCode`,
                I.`LineItem_TaxType` AS `TaxType`,
                I.`LineItem_TaxAmount` AS `TaxAmount`,
                I.`LineItem_LineAmount` AS `LineAmount`,
                I.`LineAmountTypes` AS `LineAmountTypes`,
                I.`Status` AS `Status`,
                I.`SubTotal` AS `SubTotal`,
                I.`TotalTax` AS `TotalTax`,
                I.`Total` AS `Total`,
                I.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                I.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                I.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                I.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                I.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                I.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                I.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                I.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                I.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                I.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                I.`LineItem_DiscountRate` AS `DiscountRate`,
                I.`CurrencyCode` AS `CurrencyCode`,
                CAST(I.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
                I.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(I.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(I.`OrganisationID` AS CHAR)) AS `AccountUID`,
                I.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                I.`FullyPaidOnDate` AS `FullyPaidOnDate`,
                I.`Reference` AS `Reference`,
                ''INVOICES'' AS `Source`,
                I.`ClientID` AS `ClientID`,
                I.`OrganisationID` AS `OrganisationID`,
                I.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                I.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                I.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                I.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                I.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                I.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                I.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                I.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                I.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                I.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                I.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                I.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                I.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                I.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                I.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                I.`SubTotal_AUD` AS `SubTotal_AUD`,
                I.`SubTotal_USD` AS `SubTotal_USD`,
                I.`SubTotal_NZD` AS `SubTotal_NZD`,
                I.`SubTotal_EUR` AS `SubTotal_EUR`,
                I.`SubTotal_GBP` AS `SubTotal_GBP`,
                I.`TotalTax_AUD` AS `TotalTax_AUD`,
                I.`TotalTax_USD` AS `TotalTax_USD`,
                I.`TotalTax_NZD` AS `TotalTax_NZD`,
                I.`TotalTax_EUR` AS `TotalTax_EUR`,
                I.`TotalTax_GBP` AS `TotalTax_GBP`,
                I.`Total_AUD` AS `Total_AUD`,
                I.`Total_USD` AS `Total_USD`,
                I.`Total_NZD` AS `Total_NZD`,
                I.`Total_EUR` AS `Total_EUR`,
                I.`Total_GBP` AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                I.`DueDate` AS `DueDate`,
                LEFT(I.`InvoiceNumber`,100) AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User`,
                NULL AS `Details`,
                DATEDIFF(I.`FullyPaidOnDate`, I.`Date`) AS `DayDifference`,
                I.`PlannedPaymentDate` AS `PlannedPaymentDate`,
                I.`AmountDue` AS `AmountDue`,
                I.`AmountDue_AUD` AS `AmountDue_AUD`,
                I.`AmountDue_USD` AS `AmountDue_USD`,
                I.`AmountDue_NZD` AS `AmountDue_NZD`,
                I.`AmountDue_EUR` AS `AmountDue_EUR`,
                I.`AmountDue_GBP` AS `AmountDue_GBP`,
                I.`URL` AS `URL`
            FROM ',@invoicesProd,' I FORCE INDEX(',@invoicesIndexName,')
            INNER JOIN ',@invoicesStage,' INVS ON I.`InvoiceId` = INVS.`InvoiceId`
            WHERE I.`OrganisationID` = ',v_OrganisationID,'
            LIMIT ',@batchsize, ' OFFSET ',@ffset,';
            ');
        PREPARE stmt2 FROM @insert_intostage2;
        EXECUTE stmt2;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt2;
        
        SET @ffset = @ffset + @batchsize;	   
        END WHILE;
        
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage3 = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                OP.`OverpaymentId` AS `LineID`,
                OP.`OverpaymentId` AS `ID`,
                OP.`Date` AS `Date`,
                OP.`Type` AS `Type`,
                OP.`Contact_ContactId` AS `ContactID`,
                OP.`Contact_Name` AS `ContactName`,
                OP.`LineItem_LineItemId` AS `LineItemID`,
                OP.`LineItem_Description` AS `Description`,
                OP.`LineItem_Quantity` AS `Quantity`,
                OP.`LineItem_UnitAmount` AS `UnitAmount`,
                OP.`LineItem_ItemCode` AS `ItemCode`,
                OP.`LineItem_AccountCode` AS `AccountCode`,
                OP.`LineItem_TaxType` AS `TaxType`,
                OP.`LineItem_TaxAmount` AS `TaxAmount`,
                OP.`LineItem_LineAmount` AS `LineAmount`,
                OP.`LineAmountTypes` AS `LineAmountTypes`,
                OP.`Status` AS `Status`,
                OP.`SubTotal` AS `SubTotal`,
                OP.`TotalTax` AS `TotalTax`,
                OP.`Total` AS `Total`,
                OP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                OP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                OP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                OP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                OP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                OP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                OP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                OP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                OP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                OP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                OP.`LineItem_DiscountRate` AS `DiscountRate`,
                OP.`CurrencyCode` AS `CurrencyCode`,
                CAST(NULLIF(OP.`CurrencyRate`,'''') AS FLOAT) AS `CurrencyRate`,
                OP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(OP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(OP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                OP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                OP.`RemainingCredit` AS `RemainingCredit`,
                OP.`Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                ''OVERPAYMENTS'' AS `Source`,
                OP.`ClientID` AS `ClientID`,
                OP.`OrganisationID` AS `OrganisationID`,
                OP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                OP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                OP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                OP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                OP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                OP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                OP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                OP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                OP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                OP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                OP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                OP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                OP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                OP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                OP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                OP.`SubTotal_AUD` AS `SubTotal_AUD`,
                OP.`SubTotal_USD` AS `SubTotal_USD`,
                OP.`SubTotal_NZD` AS `SubTotal_NZD`,
                OP.`SubTotal_EUR` AS `SubTotal_EUR`,
                OP.`SubTotal_GBP` AS `SubTotal_GBP`,
                OP.`TotalTax_AUD` AS `TotalTax_AUD`,
                OP.`TotalTax_USD` AS `TotalTax_USD`,
                OP.`TotalTax_NZD` AS `TotalTax_NZD`,
                OP.`TotalTax_EUR` AS `TotalTax_EUR`,
                OP.`TotalTax_GBP` AS `TotalTax_GBP`,
                OP.`Total_AUD` AS `Total_AUD`,
                OP.`Total_USD` AS `Total_USD`,
                OP.`Total_NZD` AS `Total_NZD`,
                OP.`Total_EUR` AS `Total_EUR`,
                OP.`Total_GBP` AS `Total_GBP`,
                OP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                OP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                OP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                OP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                OP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                OPA.`InvoiceId` AS `PaymentSourceID`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Dt` ELSE NULL END AS `AllocationDate`,
                CASE WHEN OPA.`InvoiceId` IS NOT NULL THEN OPA.`Amount` ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(OP.`Date`, OP.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ',@overpaymentsProd,' OP FORCE INDEX (',@overpaymentsIndexName,')
            INNER JOIN ',@overpaymentsStage,' OPS ON OP.`OverPaymentId` = OPS.`OverPaymentId`
            LEFT JOIN (
                SELECT DISTINCT
                    `OverPaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.',v_legacyClientID,'_xeroblue_overpaymentallocation_aud
                WHERE `Organisation ID` = ',v_OrganisationID,'
            ) OPA 
                ON OP.`OverPaymentId` = OPA.`OverPaymentId` 
                AND OP.`OrganisationID` = OPA.`Organisation ID`
            WHERE OP.`OrganisationID` = ',v_OrganisationID,'
            LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
        PREPARE stmt3 FROM @insert_intostage3;
        EXECUTE stmt3;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt3;
            SET @ffset = @ffset + @batchsize;	   
        END WHILE;
        
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage4 = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                PP.`PrepaymentId` AS `LineID`,
                PP.`PrepaymentId` AS `ID`,
                PP.`Date` AS `Date`,
                PP.`Type` AS `Type`,
                PP.`Contact_ContactId` AS `ContactID`,
                PP.`Contact_Name` AS `ContactName`,
                PP.`LineItem_LineItemId` AS `LineItemID`,
                PP.`LineItem_Description` AS `Description`,
                PP.`LineItem_Quantity` AS `Quantity`,
                PP.`LineItem_UnitAmount` AS `UnitAmount`,
                PP.`LineItem_ItemCode` AS `ItemCode`,
                PP.`LineItem_AccountCode` AS `AccountCode`,
                PP.`LineItem_TaxType` AS `TaxType`,
                PP.`LineItem_TaxAmount` AS `TaxAmount`,
                PP.`LineItem_LineAmount` AS `LineAmount`,
                PP.`LineAmountTypes` AS `LineAmountTypes`,
                PP.`Status` AS `Status`,
                PP.`SubTotal` AS `SubTotal`,
                PP.`TotalTax` AS `TotalTax`,
                PP.`Total` AS `Total`,
                PP.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                PP.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                PP.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                PP.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                PP.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                PP.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                PP.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                PP.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                PP.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                PP.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                PP.`LineItem_DiscountRate` AS `DiscountRate`,
                PP.`CurrencyCode` AS `CurrencyCode`,
                NULLIF(PP.`CurrencyRate`,'''') AS `CurrencyRate`,
                PP.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(PP.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(PP.`OrganisationID` AS CHAR)) AS `AccountUID`,
                PP.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                PP.`RemainingCredit` AS `RemainingCredit`,
                PP.`Date` AS `FullyPaidOnDate`,
                PP.`Reference` AS `Reference`,
                ''PREPAYMENTS'' AS `Source`,
                PP.`ClientID` AS `ClientID`,
                PP.`OrganisationID` AS `OrganisationID`,
                PP.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
                PP.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
                PP.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
                PP.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
                PP.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
                PP.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
                PP.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
                PP.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
                PP.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
                PP.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
                PP.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
                PP.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
                PP.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
                PP.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
                PP.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
                PP.`SubTotal_AUD` AS `SubTotal_AUD`,
                PP.`SubTotal_USD` AS `SubTotal_USD`,
                PP.`SubTotal_NZD` AS `SubTotal_NZD`,
                PP.`SubTotal_EUR` AS `SubTotal_EUR`,
                PP.`SubTotal_GBP` AS `SubTotal_GBP`,
                PP.`TotalTax_AUD` AS `TotalTax_AUD`,
                PP.`TotalTax_USD` AS `TotalTax_USD`,
                PP.`TotalTax_NZD` AS `TotalTax_NZD`,
                PP.`TotalTax_EUR` AS `TotalTax_EUR`,
                PP.`TotalTax_GBP` AS `TotalTax_GBP`, 
                PP.`Total_AUD` AS `Total_AUD`,
                PP.`Total_USD` AS `Total_USD`,
                PP.`Total_NZD` AS `Total_NZD`,
                PP.`Total_EUR` AS `Total_EUR`,
                PP.`Total_GBP` AS `Total_GBP`,
                PP.`RemainingCredit_AUD` AS `RemainingCredit_AUD`,
                PP.`RemainingCredit_USD` AS `RemainingCredit_USD`,
                PP.`RemainingCredit_NZD` AS `RemainingCredit_NZD`,
                PP.`RemainingCredit_EUR` AS `RemainingCredit_EUR`,
                PP.`RemainingCredit_GBP` AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                PPA.`InvoiceId` AS `PaymentSourceID`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN ''INVOICES'' ELSE NULL END AS `PaymentType`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Dt` ELSE NULL END AS `AllocationDate`,
                CASE WHEN PPA.`InvoiceId` IS NOT NULL THEN PPA.`Amount` ELSE NULL END AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(PP.`Date`, PP.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ',@prepaymentsProd,' PP FORCE INDEX (',@prepaymentsIndexName,')
            INNER JOIN ',@prepaymentsStage,' PS ON PP.`PrePaymentId` = PS.`PrePaymentId`
            LEFT JOIN (
                SELECT DISTINCT
                    `PrePaymentId`,
                    `InvoiceId`,
                    `Dt`,
                    `Amount`,
                    `Client ID`,
                    `Organisation ID`
                FROM evadb.',v_legacyClientID,'_xeroblue_prepaymentallocation_aud
                WHERE `Organisation ID` = ',v_OrganisationID,'
            ) PPA 
                ON PP.`PrePaymentId` = PPA.`PrePaymentId` 
                AND PP.`OrganisationID` = PPA.`Organisation ID`
            WHERE PP.`OrganisationID` = ',v_OrganisationID,'    
            LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
        PREPARE stmt4 FROM @insert_intostage4;
        EXECUTE stmt4;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt4;
            SET @ffset = @ffset + @batchsize;	   
        END WHILE;
        
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage5 = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT DISTINCT
                MJ.`Id` AS `LineID`,
                MJ.`ManualJournalId` AS `ID`,
                MJ.`Date` AS `Date`,
                NULL AS `Type`,
                NULL AS `ContactID`,
                NULL AS `ContactName`,
                NULL AS `LineItemID`,
                MJ.`JournalLine_Description` AS `Description`,
                NULL AS `Quantity`,
                NULL AS `UnitAmount`,
                NULL AS `ItemCode`,
                MJ.`JournalLine_AccountCode` AS `AccountCode`,
                MJ.`JournalLine_TaxType` AS `TaxType`,
                MJ.`JournalLine_TaxAmount` AS `TaxAmount`,
                MJ.`JournalLine_LineAmount` AS `LineAmount`,
                MJ.`LineAmountTypes` AS `LineAmountTypes`,
                MJ.`Status` AS `Status`,
                NULL AS `SubTotal`,
                NULL AS `TotalTax`,
                NULL AS `Total`,
                MJ.`JournalLine_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
                MJ.`JournalLine_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
                MJ.`JournalLine_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
                MJ.`JournalLine_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
                MJ.`JournalLine_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
                MJ.`JournalLine_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
                MJ.`JournalLine_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
                MJ.`JournalLine_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
                MJ.`JournalLine_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
                MJ.`JournalLine_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                NULL AS `CurrencyCode`,
                NULL AS `CurrencyRate`,
                MJ.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(MJ.`JournalLine_AccountCode`, ''BLANK''), ''-'', CAST(MJ.`OrganisationID` AS CHAR)) AS `AccountUID`,
                MJ.`HasAttachments` AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                MJ.`Date` AS `FullyPaidOnDate`,
                NULL AS `Reference`,
                ''MANUALJOURNALS'' AS `Source`,
                MJ.`ClientID` AS `ClientID`,
                MJ.`OrganisationID` AS `OrganisationID`,
                NULL AS `UnitAmount_AUD`,
                NULL AS `UnitAmount_USD`,
                NULL AS `UnitAmount_NZD`,
                NULL AS `UnitAmount_EUR`,
                NULL AS `UnitAmount_GBP`,
                MJ.`JournalLine_TaxAmount_AUD` AS `TaxAmount_AUD`,
                MJ.`JournalLine_TaxAmount_USD` AS `TaxAmount_USD`,
                MJ.`JournalLine_TaxAmount_NZD` AS `TaxAmount_NZD`,
                MJ.`JournalLine_TaxAmount_EUR` AS `TaxAmount_EUR`,
                MJ.`JournalLine_TaxAmount_GBP` AS `TaxAmount_GBP`,
                MJ.`JournalLine_LineAmount_AUD` AS `LineAmount_AUD`,
                MJ.`JournalLine_LineAmount_USD` AS `LineAmount_USD`,
                MJ.`JournalLine_LineAmount_NZD` AS `LineAmount_NZD`,
                MJ.`JournalLine_LineAmount_EUR` AS `LineAmount_EUR`,
                MJ.`JournalLine_LineAmount_GBP` AS `LineAmount_GBP`,
                NULL AS `SubTotal_AUD`,
                NULL AS `SubTotal_USD`,
                NULL AS `SubTotal_NZD`,
                NULL AS `SubTotal_EUR`,
                NULL AS `SubTotal_GBP`,
                NULL AS `TotalTax_AUD`,
                NULL AS `TotalTax_USD`,
                NULL AS `TotalTax_NZD`,
                NULL AS `TotalTax_EUR`,
                NULL AS `TotalTax_GBP`,
                NULL AS `Total_AUD`,
                NULL AS `Total_USD`,
                NULL AS `Total_NZD`,
                NULL AS `Total_EUR`,
                NULL AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                MJ.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                NULL AS `PaymentSourceID`,
                NULL AS `PaymentType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User  `,
                NULL AS `Details`,
                DATEDIFF(MJ.`Date`, MJ.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ',@manualJournalsProd,' MJ FORCE INDEX (',@manualJournalsIndexName,')
            INNER JOIN ',@manualJournalsStage,' MJS ON MJ.`ManualJournalId` = MJS.`ManualJournalId`
            WHERE MJ.`OrganisationID` = ',v_OrganisationID,'
            LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
        PREPARE stmt5 FROM @insert_intostage5;
        EXECUTE stmt5;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt5;
            SET @ffset = @ffset + @batchsize;
        
        END WHILE;
        
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage6 = CONCAT('
        INSERT IGNORE INTO ',@transactionsStage,'
        (
            `LineID`,
            `ID`,
            `Date`,
            `Type`,
            `ContactID`,
            `ContactName`,
            `LineItemID`,
            `Description`,
            `Quantity`,
            `UnitAmount`,
            `ItemCode`,
            `AccountCode`,
            `TaxType`,
            `TaxAmount`,
            `LineAmount`,
            `LineAmountTypes`,
            `Status`,
            `SubTotal`,
            `TotalTax`,
            `Total`,
            `TrackingCategory1CategoryID`,
            `TrackingCategory1CategoryName`,
            `TrackingCategory1OptionID`,
            `TrackingCategory1OptionName`,
            `TrackingCategory1OptionStat`,
            `TrackingCategory2CategoryID`,
            `TrackingCategory2CategoryName`,
            `TrackingCategory2OptionID`,
            `TrackingCategory2OptionName`,
            `TrackingCategory2OptionStat`,
            `DiscountRate`,
            `CurrencyCode`,
            `CurrencyRate`,
            `UpdatedDateUTC`,
            `AccountUID`,
            `HasAttachments`,
            `CreditNoteNumber`,
            `RemainingCredit`,
            `FullyPaidOnDate`,
            `Reference`,
            `Source`,
            `ClientID`,
            `OrganisationID`,
            `UnitAmount_AUD`,
            `UnitAmount_USD`,
            `UnitAmount_NZD`,
            `UnitAmount_EUR`,
            `UnitAmount_GBP`,
            `TaxAmount_AUD`,
            `TaxAmount_USD`,
            `TaxAmount_NZD`,
            `TaxAmount_EUR`,
            `TaxAmount_GBP`,
            `LineAmount_AUD`,
            `LineAmount_USD`,
            `LineAmount_NZD`,
            `LineAmount_EUR`,
            `LineAmount_GBP`,
            `SubTotal_AUD`,
            `SubTotal_USD`,
            `SubTotal_NZD`,
            `SubTotal_EUR`,
            `SubTotal_GBP`,
            `TotalTax_AUD`,
            `TotalTax_USD`,
            `TotalTax_NZD`,
            `TotalTax_EUR`,
            `TotalTax_GBP`,
            `Total_AUD`,
            `Total_USD`,
            `Total_NZD`,
            `Total_EUR`,
            `Total_GBP`,
            `RemainingCredit_AUD`,
            `RemainingCredit_USD`,
            `RemainingCredit_NZD`,
            `RemainingCredit_EUR`,
            `RemainingCredit_GBP`,
            `ShowOnCashBasisReports`,
            `DueDate`,
            `InvoiceNumber`,
            `PaymentSourceID`,
            `PaymentType`,
            `AllocationDate`,
            `AllocationAmount`,
            `Changes`,
            `User`,
            `Details`,
            `DayDifference`,
            `PlannedPaymentDate`,
            `AmountDue`,
            `AmountDue_AUD`,
            `AmountDue_USD`,
            `AmountDue_NZD`,
            `AmountDue_EUR`,
            `AmountDue_GBP`,
            `URL`
        )
        SELECT DISTINCT
            BT.`Id` AS `LineID`,
            BT.`BankTransactionId` AS `ID`,
            BT.`Date` AS `Date`,
            BT.`Type` AS `Type`,
            BT.`Contact_ContactId` AS `ContactID`,
            BT.`Contact_ContactName` AS `ContactName`,
            BT.`LineItem_LineItemId` AS `LineItemID`,
            BT.`LineItem_Description` AS `Description`,
            BT.`LineItem_Quantity` AS `Quantity`,
            BT.`LineItem_UnitAmount` AS `UnitAmount`,
            BT.`LineItem_ItemCode` AS `ItemCode`,
            BT.`LineItem_AccountCode` AS `AccountCode`,
            BT.`LineItem_TaxType` AS `TaxType`,
            BT.`LineItem_TaxAmount` AS `TaxAmount`,
            BT.`LineItem_LineAmount` AS `LineAmount`,
            BT.`LineAmountTypes` AS `LineAmountTypes`,
            BT.`Status` AS `Status`,
            BT.`SubTotal` AS `SubTotal`,
            BT.`TotalTax` AS `TotalTax`,
            BT.`Total` AS `Total`,
            BT.`LineItem_TrackingCategory1_CategoryId` AS `TrackingCategory1CategoryID`,
            BT.`LineItem_TrackingCategory1_CategoryName` AS `TrackingCategory1CategoryName`,
            BT.`LineItem_TrackingCategory1_OptionId` AS `TrackingCategory1OptionID`,
            BT.`LineItem_TrackingCategory1_OptionName` AS `TrackingCategory1OptionName`,
            BT.`LineItem_TrackingCategory1_Option_Stat` AS `TrackingCategory1OptionStat`,
            BT.`LineItem_TrackingCategory2_CategoryId` AS `TrackingCategory2CategoryID`,
            BT.`LineItem_TrackingCategory2_CategoryName` AS `TrackingCategory2CategoryName`,
            BT.`LineItem_TrackingCategory2_OptionId` AS `TrackingCategory2OptionID`,
            BT.`LineItem_TrackingCategory2_OptionName` AS `TrackingCategory2OptionName`,
            BT.`LineItem_TrackingCategory2_Option_Stat` AS `TrackingCategory2OptionStat`,
            NULL AS `DiscountRate`,
            BT.`CurrencyCode` AS `CurrencyCode`,
            CAST(BT.`CurrencyRate` AS DECIMAL(30, 6)) AS `CurrencyRate`,
            BT.`UpdatedDateUTC` AS `UpdatedDateUTC`,
            CONCAT(IFNULL(BT.`LineItem_AccountCode`, ''BLANK''), ''-'', CAST(BT.`OrganisationID` AS CHAR)) AS `AccountUID`,
            BT.`HasAttachments` AS `HasAttachments`,
            NULL AS `CreditNoteNumber`,
            NULL AS `RemainingCredit`,
            BT.`FullyPaidOnDate` AS `FullyPaidOnDate`,
            BT.`Reference` AS `Reference`,
            ''BANKTRANSACTIONS'' AS `Source`,
            BT.`ClientID` AS `ClientID`,
            BT.`OrganisationID` AS `OrganisationID`,
            BT.`LineItem_UnitAmount_AUD` AS `UnitAmount_AUD`,
            BT.`LineItem_UnitAmount_USD` AS `UnitAmount_USD`,
            BT.`LineItem_UnitAmount_NZD` AS `UnitAmount_NZD`,
            BT.`LineItem_UnitAmount_EUR` AS `UnitAmount_EUR`,
            BT.`LineItem_UnitAmount_GBP` AS `UnitAmount_GBP`,
            BT.`LineItem_TaxAmount_AUD` AS `TaxAmount_AUD`,
            BT.`LineItem_TaxAmount_USD` AS `TaxAmount_USD`,
            BT.`LineItem_TaxAmount_NZD` AS `TaxAmount_NZD`,
            BT.`LineItem_TaxAmount_EUR` AS `TaxAmount_EUR`,
            BT.`LineItem_TaxAmount_GBP` AS `TaxAmount_GBP`,
            BT.`LineItem_LineAmount_AUD` AS `LineAmount_AUD`,
            BT.`LineItem_LineAmount_USD` AS `LineAmount_USD`,
            BT.`LineItem_LineAmount_NZD` AS `LineAmount_NZD`,
            BT.`LineItem_LineAmount_EUR` AS `LineAmount_EUR`,
            BT.`LineItem_LineAmount_GBP` AS `LineAmount_GBP`,
            BT.`SubTotal_AUD` AS `SubTotal_AUD`,
            BT.`SubTotal_USD` AS `SubTotal_USD`,
            BT.`SubTotal_NZD` AS `SubTotal_NZD`,
            BT.`SubTotal_EUR` AS `SubTotal_EUR`,
            BT.`SubTotal_GBP` AS `SubTotal_GBP`,
            BT.`TotalTax_AUD` AS `TotalTax_AUD`,
            BT.`TotalTax_USD` AS `TotalTax_USD`,
            BT.`TotalTax_NZD` AS `TotalTax_NZD`,
            BT.`TotalTax_EUR` AS `TotalTax_EUR`,
            BT.`TotalTax_GBP` AS `TotalTax_GBP`,
            BT.`Total_AUD` AS `Total_AUD`,
            BT.`Total_USD` AS `Total_USD`,
            BT.`Total_NZD` AS `Total_NZD`,
            BT.`Total_EUR` AS `Total_EUR`,
            BT.`Total_GBP` AS `Total_GBP`,
            NULL AS `RemainingCredit_AUD`,
            NULL AS `Remaining Credit_USD`,
            NULL AS `RemainingCredit_NZD`,
            NULL AS `RemainingCredit_EUR`,
            NULL AS `RemainingCredit_GBP`,
            NULL AS `ShowOnCashBasisReports`,
            NULL AS `DueDate`,
            NULL AS `InvoiceNumber`,
            NULL AS `PaymentSourceID`,
            NULL AS `PaymentType`,
            NULL AS `AllocationDate`,
            NULL AS `AllocationAmount`,
            NULL AS `Changes`,
            NULL AS `User `,
            NULL AS `Details`,
            DATEDIFF(BT.`Date`, BT.`FullyPaidOnDate`) AS `DayDifference`,
            NULL AS `PlannedPaymentDate`,
            NULL AS `AmountDue`,
            NULL AS `AmountDue_AUD`,
            NULL AS `AmountDue_USD`,
            NULL AS `AmountDue_NZD`,
            NULL AS `AmountDue_EUR`,
            NULL AS `AmountDue_GBP`,
            NULL AS `URL`
        FROM ',@banktransactionsProd,' BT FORCE INDEX (',@banktransactionsIndexName,')
        INNER JOIN ',@banktransactionsStage,' BTS ON BT.`BankTransactionId` = BTS.`BankTransactionId`
        WHERE BT.`OrganisationID` = ',v_OrganisationID,'
        LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
        PREPARE stmt6 FROM @insert_intostage6;
        EXECUTE stmt6;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt6;
            SET @ffset = @ffset + @batchsize;
        
        END WHILE;
        
    SET @ffset = 0;
    SET @done = 0; 
    
    WHILE @done = 0 DO
        SET @insert_intostage7 = CONCAT('
            INSERT IGNORE INTO ',@transactionsStage,'
            (
                `LineID`,
                `ID`,
                `Date`,
                `Type`,
                `ContactID`,
                `ContactName`,
                `LineItemID`,
                `Description`,
                `Quantity`,
                `UnitAmount`,
                `ItemCode`,
                `AccountCode`,
                `TaxType`,
                `TaxAmount`,
                `LineAmount`,
                `LineAmountTypes`,
                `Status`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `TrackingCategory1CategoryID`,
                `TrackingCategory1CategoryName`,
                `TrackingCategory1OptionID`,
                `TrackingCategory1OptionName`,
                `TrackingCategory1OptionStat`,
                `TrackingCategory2CategoryID`,
                `TrackingCategory2CategoryName`,
                `TrackingCategory2OptionID`,
                `TrackingCategory2OptionName`,
                `TrackingCategory2OptionStat`,
                `DiscountRate`,
                `CurrencyCode`,
                `CurrencyRate`,
                `UpdatedDateUTC`,
                `AccountUID`,
                `HasAttachments`,
                `CreditNoteNumber`,
                `RemainingCredit`,
                `FullyPaidOnDate`,
                `Reference`,
                `Source`,
                `ClientID`,
                `OrganisationID`,
                `UnitAmount_AUD`,
                `UnitAmount_USD`,
                `UnitAmount_NZD`,
                `UnitAmount_EUR`,
                `UnitAmount_GBP`,
                `TaxAmount_AUD`,
                `TaxAmount_USD`,
                `TaxAmount_NZD`,
                `TaxAmount_EUR`,
                `TaxAmount_GBP`,
                `LineAmount_AUD`,
                `LineAmount_USD`,
                `LineAmount_NZD`,
                `LineAmount_EUR`,
                `LineAmount_GBP`,
                `SubTotal_AUD`,
                `SubTotal_USD`,
                `SubTotal_NZD`,
                `SubTotal_EUR`,
                `SubTotal_GBP`,
                `TotalTax_AUD`,
                `TotalTax_USD`,
                `TotalTax_NZD`,
                `TotalTax_EUR`,
                `TotalTax_GBP`,
                `Total_AUD`,
                `Total_USD`,
                `Total_NZD`,
                `Total_EUR`,
                `Total_GBP`,
                `RemainingCredit_AUD`,
                `RemainingCredit_USD`,
                `RemainingCredit_NZD`,
                `RemainingCredit_EUR`,
                `RemainingCredit_GBP`,
                `ShowOnCashBasisReports`,
                `DueDate`,
                `InvoiceNumber`,
                `PaymentSourceID`,
                `PaymentType`,
                `AllocationDate`,
                `AllocationAmount`,
                `Changes`,
                `User`,
                `Details`,
                `DayDifference`,
                `PlannedPaymentDate`,
                `AmountDue`,
                `AmountDue_AUD`,
                `AmountDue_USD`,
                `AmountDue_NZD`,
                `AmountDue_EUR`,
                `AmountDue_GBP`,
                `URL`
            )
            SELECT  DISTINCT
                P.`PaymentId` AS `LineID`,
                P.`PaymentId` AS `ID`,
                P.`Date` AS `Date`,
                P.`PaymentType` AS `Type`,
                X.ContactId as `ContactID`,
                X.ContactName AS `ContactName`,
                P.`PaymentId` AS `LineItemID`,
                NULL AS `Description`,
                NULL AS `Quantity`,
                NULL AS `UnitAmount`,
                NULL AS `ItemCode`,
                P.`AccountCode` AS `AccountCode`,
                NULL AS `TaxType`,
                NULL AS `TaxAmount`,
                P.`Amount` AS `LineAmount`,
                NULL AS `LineAmountTypes`,
                P.`Status` AS `Status`,
                NULL AS `SubTotal`,
                NULL AS `TotalTax`,
                NULL AS `Total`,
                NULL AS `TrackingCategory1CategoryID`,
                NULL AS `TrackingCategory1CategoryName`,
                NULL AS `TrackingCategory1OptionID`,
                NULL AS `TrackingCategory1OptionName`,
                NULL AS `TrackingCategory1OptionStat`,
                NULL AS `TrackingCategory2CategoryID`,
                NULL AS `TrackingCategory2CategoryName`,
                NULL AS `TrackingCategory2OptionID`,
                NULL AS `TrackingCategory2OptionName`,
                NULL AS `TrackingCategory2OptionStat`,
                NULL AS `DiscountRate`,
                NULL AS `CurrencyCode`,
                CASE WHEN P.`CurrencyRate` LIKE ''%E%'' THEN LEFT(P.`CurrencyRate`, LENGTH(P.`CurrencyRate`)-POSITION(''E'' IN REVERSE(P.`CurrencyRate`))) ELSE P.`CurrencyRate` END AS `CurrencyRate`,
                P.`UpdatedDateUTC` AS `UpdatedDateUTC`,
                CONCAT(IFNULL(P.`AccountCode`, ''BLANK''), ''-'', CAST(P.`OrganisationID` AS CHAR)) AS `AccountUID`,
                NULL AS `HasAttachments`,
                NULL AS `CreditNoteNumber`,
                NULL AS `RemainingCredit`,
                P.`Date` AS `FullyPaidOnDate`,
                P.`Reference` AS `Reference`,
                ''PAYMENTS'' AS `Source`,
                P.`ClientID` AS `ClientID`,
                P.`OrganisationID` AS `OrganisationID`,
                NULL AS `UnitAmount_AUD`,
                NULL AS `UnitAmount_USD`,
                NULL AS `UnitAmount_NZD`,
                NULL AS `UnitAmount_EUR`,
                NULL AS `UnitAmount_GBP`,
                NULL AS `TaxAmount_AUD`,
                NULL AS `TaxAmount_USD`,
                NULL AS `TaxAmount_NZD`,
                NULL AS `TaxAmount_EUR`,
                NULL AS `TaxAmount_GBP`,
                P.`Amount_AUD` AS `LineAmount_AUD`,
                P.`Amount_USD` AS `LineAmount_USD`,
                P.`Amount_NZD` AS `LineAmount_NZD`,
                P.`Amount_EUR` AS `LineAmount_EUR`,
                P.`Amount_GBP` AS `LineAmount_GBP`,
                NULL AS `SubTotal_AUD`,
                NULL AS `SubTotal_USD`,
                NULL AS `SubTotal_NZD`,
                NULL AS `SubTotal_EUR`,
                NULL AS `SubTotal_GBP`,
                NULL AS `TotalTax_AUD`,
                NULL AS `TotalTax_USD`,
                NULL AS `TotalTax_NZD`,
                NULL AS `TotalTax_EUR`,
                NULL AS `TotalTax_GBP`,
                NULL AS `Total_AUD`,
                NULL AS `Total_USD`,
                NULL AS `Total_NZD`,
                NULL AS `Total_EUR`,
                NULL AS `Total_GBP`,
                NULL AS `RemainingCredit_AUD`,
                NULL AS `RemainingCredit_USD`,
                NULL AS `RemainingCredit_NZD`,
                NULL AS `RemainingCredit_EUR`,
                NULL AS `RemainingCredit_GBP`,
                NULL AS `ShowOnCashBasisReports`,
                NULL AS `DueDate`,
                NULL AS `InvoiceNumber`,
                P.`InvoiceId` AS `PaymentSourceID`,
                X.Type AS `PaymentSourceType`,
                NULL AS `AllocationDate`,
                NULL AS `AllocationAmount`,
                NULL AS `Changes`,
                NULL AS `User `,
                NULL AS `Details`,
                DATEDIFF(P.`Date`, P.`Date`) AS `DayDifference`,
                NULL AS `PlannedPaymentDate`,
                NULL AS `AmountDue`,
                NULL AS `AmountDue_AUD`,
                NULL AS `AmountDue_USD`,
                NULL AS `AmountDue_NZD`,
                NULL AS `AmountDue_EUR`,
                NULL AS `AmountDue_GBP`,
                NULL AS `URL`
            FROM ',@paymentsProd,' P FORCE INDEX (',@paymentsIndexName,')
            INNER JOIN ',@paymentsStage,' PS ON P.`PaymentId` = PS.`PaymentId`
            JOIN (
                SELECT OrganisationId, ''INVOICES'' AS Type, InvoiceId AS PaymentSourceID, ContactId, ContactName 
                FROM c',v_clientID,'_xeroblue_invoices  FORCE INDEX(',@invoicesIndexName,') 
                WHERE OrganisationId =  ',v_OrganisationID,' 
                UNION ALL
                SELECT OrganisationId, ''CREDITNOTES'' AS Type, CreditNoteID AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c',v_clientID,'_xeroblue_creditnotes FORCE INDEX(',@creditnotesIndexName,')
                WHERE OrganisationId =  ',v_OrganisationID,' 
                UNION ALL
                SELECT OrganisationId, ''PREPAYMENTS'' AS Type, PrepaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c',v_clientID,'_xeroblue_prepayments FORCE INDEX(',@prepaymentsIndexName,')
                WHERE OrganisationId =  ',v_OrganisationID,' 
                UNION ALL
                SELECT OrganisationId, ''OVERPAYMENTS'' AS Type, OverpaymentId AS PaymentSourceID, Contact_ContactId, Contact_Name 
                FROM c',v_clientID,'_xeroblue_overpayments FORCE INDEX(',@overpaymentsIndexName,')
                WHERE OrganisationId =  ',v_OrganisationID,' 
            ) AS X ON X.OrganisationId = P.OrganisationID AND P.InvoiceId = X.PaymentSourceID
            WHERE P.`OrganisationID` = ',v_OrganisationID,'
            LIMIT ',@batchsize,' OFFSET ',@ffset,';
            ');
            
        PREPARE stmt7 FROM @insert_intostage7;
        EXECUTE stmt7;
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
        DEALLOCATE PREPARE stmt7;
            SET @ffset = @ffset + @batchsize;	   
	    END WHILE;
    
    SET @rowcount = 1;
	SET @batch_size = 1000;
	SET @delete_table = CONCAT('
	    DELETE trg
        FROM c', v_clientID, '_xeroblue_transactions trg
        JOIN ', @transactionsStage, ' src ON trg.`id` = src.`id`
	    WHERE trg.`OrganisationID` = ', v_OrganisationID, '
	    LIMIT ', @batch_size, ';
	');
	
	WHILE @rowcount > 0 DO
    PREPARE stmt8 FROM @delete_table;
    EXECUTE stmt8;
    SELECT ROW_COUNT() INTO @rowcount;  
    IF @rowcount = 0 THEN SET @done = 1; END IF;  
    DEALLOCATE PREPARE stmt8;
	END WHILE;
	
	SET @done = 0;
	SET @ffset = 0;

    WHILE @done = 0 DO
	    SET @insert_tofinal = CONCAT('
	        INSERT IGNORE INTO `c',v_clientID,'_xeroblue_transactions`
	        SELECT * FROM `',@transactionsStage,'`
			LIMIT ',@batchsize,' OFFSET ',@ffset,';
		    ');
    	PREPARE stmt9 FROM @insert_tofinal;
		EXECUTE stmt9;  
        SELECT ROW_COUNT() INTO @rowcount;  
        IF @rowcount = 0 THEN SET @done = 1; END IF;
		DEALLOCATE PREPARE stmt9;
	 	SET @ffset = @ffset + @batchsize;	   
	END WHILE;

END