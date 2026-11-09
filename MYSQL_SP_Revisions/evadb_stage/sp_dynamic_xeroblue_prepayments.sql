USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_prepayments;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_prepayments(
    IN p_clientID VARCHAR(100),
    IN p_orgID INT,
    IN p_legacyOrgID INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
    -- Replace hardcoded table references with dynamic ones
    SET @prepaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_prepaymentsstage');

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;
    
    SET @fx_table = CONCAT('FXTable_', CONNECTION_ID());
    
    -- FXTable creation and population
    SET @create_fxtable = CONCAT('
	    CREATE TEMPORARY TABLE IF NOT EXISTS ',@fx_table,' (
	        `BaseCurrency` VARCHAR(10),
	        `Date` DATE,
	        `AUD` DECIMAL(10, 4),
	        `USD` DECIMAL(10, 4),
	        `NZD` DECIMAL(10, 4),
	        `EUR` DECIMAL(10, 4),
	        `GBP` DECIMAL(10, 4)
			  ,INDEX(BaseCurrency, DATE)
		    );'
		 );
		 PREPARE stmt FROM @create_fxtable;
	    EXECUTE stmt;
   	 DEALLOCATE PREPARE stmt;
    
    
	 SET @insert_fxtable = CONCAT('
    INSERT INTO ',@fx_table,' (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
    SELECT 
        `BaseCurrency`,
        `Date`,
        AVG(CASE WHEN `Currency` = ''AUD'' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = ''USD'' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = ''NZD'' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = ''EUR'' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = ''GBP'' THEN `ExchangeRate` END) AS `GBP`
    FROM FOREIGNEXCHANGE_MASTER
    WHERE `Currency` IN (''AUD'', ''USD'', ''NZD'', ''EUR'', ''GBP'')
    GROUP BY `BaseCurrency`, `Date`;
    ');
    PREPARE stmt10 FROM @insert_fxtable;
    EXECUTE stmt10;
    DEALLOCATE PREPARE stmt10;
   

    -- prepaymentsAllocations temp table creation and population for speedier insertion
    CREATE TEMPORARY TABLE IF NOT EXISTS prepaymentsAllocations (
        AllocationID INT AUTO_INCREMENT PRIMARY KEY,
        PrepaymentId VARCHAR(100) NOT NULL,
        AllocationNumber INT NOT NULL,
        AllocationDate DATE NOT NULL,
        AppliedAmount DECIMAL(18, 2) NOT NULL,
        CurrencyCode VARCHAR(10) NOT NULL,
        AUD DECIMAL(18, 6) DEFAULT NULL,
        USD DECIMAL(18, 6) DEFAULT NULL,
        NZD DECIMAL(18, 6) DEFAULT NULL,
        EUR DECIMAL(18, 6) DEFAULT NULL,
        GBP DECIMAL(18, 6) DEFAULT NULL
    );

    SET @insertAllocationsQuery = CONCAT(
        'INSERT INTO prepaymentsAllocations (PrepaymentId, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode)
          SELECT PrepaymentId, 1, Allocation1_Date, Allocation1_AppliedAmount, CurrencyCode
          FROM ', @prepaymentsStage, '
          WHERE Allocation1_Date IS NOT NULL
          UNION ALL
          SELECT PrepaymentId, 2, Allocation2_Date, Allocation2_AppliedAmount, CurrencyCode
          FROM ', @prepaymentsStage, '
          WHERE Allocation2_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 3, prepymt.Allocation3_Date, prepymt.Allocation3_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation3_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 4, prepymt.Allocation4_Date, prepymt.Allocation4_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation4_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 5, prepymt.Allocation5_Date, prepymt.Allocation5_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation5_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 6, prepymt.Allocation6_Date, prepymt.Allocation6_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation6_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 7, prepymt.Allocation7_Date, prepymt.Allocation7_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation7_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 8, prepymt.Allocation8_Date, prepymt.Allocation8_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation8_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 9, prepymt.Allocation9_Date, prepymt.Allocation9_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation9_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    prepymt.PrepaymentId, 10, prepymt.Allocation10_Date, prepymt.Allocation10_AppliedAmount, prepymt.CurrencyCode
		    FROM ', @prepaymentsStage, ' AS prepymt
		    WHERE prepymt.Allocation10_Date IS NOT NULL;'
    );

    PREPARE stmt FROM @insertAllocationsQuery;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
	
    -- Update prepaymentsAllocations currencies
    SET @update_allocations = CONCAT('
	    UPDATE prepaymentsAllocations AS alloc
	    JOIN ',@fx_table,' AS fx
	        ON fx.BaseCurrency = alloc.CurrencyCode
	        AND fx.Date = CASE
	            WHEN alloc.AllocationDate <= ''',v_minDate,''' THEN ''',v_minDate,'''
	            WHEN alloc.AllocationDate >= ''',v_maxDate,''' THEN ''',v_maxDate,'''
	            ELSE alloc.AllocationDate
	        END
	    SET alloc.AUD = alloc.AppliedAmount * fx.AUD,
	        alloc.USD = alloc.AppliedAmount * fx.USD,
	        alloc.NZD = alloc.AppliedAmount * fx.NZD,
	        alloc.EUR = alloc.AppliedAmount * fx.EUR,
	        alloc.GBP = alloc.AppliedAmount * fx.GBP;
	    ');
    PREPARE stmt1 FROM @update_allocations;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
        
    SET @updateprepaymentsStage = CONCAT(
        'UPDATE ', @prepaymentsStage, ' AS prepymt
	     LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = prepymt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN prepymt.`Date` <= ''',v_minDate,''' THEN ''',v_minDate,'''
									WHEN prepymt.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate,'''
									ELSE prepymt.`Date` 
								END
	    SET `RemainingCredit_AUD` = prepymt.`RemainingCredit` * fx.`AUD`,
            `RemainingCredit_USD` = prepymt.`RemainingCredit` * fx.`USD`,
            `RemainingCredit_NZD` = prepymt.`RemainingCredit` * fx.`NZD`,
            `RemainingCredit_EUR` = prepymt.`RemainingCredit` * fx.`EUR`,
            `RemainingCredit_GBP` = prepymt.`RemainingCredit` * fx.`GBP`,
            `SubTotal_AUD` = prepymt.`SubTotal` * fx.`AUD`,
            `SubTotal_USD` = prepymt.`SubTotal` * fx.`USD`,
            `SubTotal_NZD` = prepymt.`SubTotal` * fx.`NZD`,
            `SubTotal_EUR` = prepymt.`SubTotal` * fx.`EUR`,
            `SubTotal_GBP` = prepymt.`SubTotal` * fx.`GBP`,
            `TotalTax_AUD` = prepymt.`TotalTax` * fx.`AUD`,
            `TotalTax_USD` = prepymt.`TotalTax` * fx.`USD`,
            `TotalTax_NZD` = prepymt.`TotalTax` * fx.`NZD`,
            `TotalTax_EUR` = prepymt.`TotalTax` * fx.`EUR`,
            `TotalTax_GBP` = prepymt.`TotalTax` * fx.`GBP`,
            `Total_AUD` = prepymt.`Total` * fx.`AUD`,
            `Total_USD` = prepymt.`Total` * fx.`USD`,
            `Total_NZD` = prepymt.`Total` * fx.`NZD`,
            `Total_EUR` = prepymt.`Total` * fx.`EUR`,
            `Total_GBP` = prepymt.`Total` * fx.`GBP`,
            `LineItem_UnitAmount_AUD` = prepymt.`LineItem_UnitAmount` * fx.`AUD`,
            `LineItem_UnitAmount_USD` = prepymt.`LineItem_UnitAmount` * fx.`USD`,
            `LineItem_UnitAmount_NZD` = prepymt.`LineItem_UnitAmount` * fx.`NZD`,
            `LineItem_UnitAmount_EUR` = prepymt.`LineItem_UnitAmount` * fx.`EUR`,
            `LineItem_UnitAmount_GBP` = prepymt.`LineItem_UnitAmount` * fx.`GBP`,
            `LineItem_TaxAmount_AUD` = prepymt.`LineItem_TaxAmount` * fx.`AUD`,
            `LineItem_TaxAmount_USD` = prepymt.`LineItem_TaxAmount` * fx.`USD`,
            `LineItem_TaxAmount_NZD` = prepymt.`LineItem_TaxAmount` * fx.`NZD`,
            `LineItem_TaxAmount_EUR` = prepymt.`LineItem_TaxAmount` * fx.`EUR`,
            `LineItem_TaxAmount_GBP` = prepymt.`LineItem_TaxAmount` * fx.`GBP`,
            `LineItem_LineAmount_AUD` = prepymt.`LineItem_LineAmount` * fx.`AUD`,
            `LineItem_LineAmount_USD` = prepymt.`LineItem_LineAmount` * fx.`USD`,
            `LineItem_LineAmount_NZD` = prepymt.`LineItem_LineAmount` * fx.`NZD`,
            `LineItem_LineAmount_EUR` = prepymt.`LineItem_LineAmount` * fx.`EUR`,
            `LineItem_LineAmount_GBP` = prepymt.`LineItem_LineAmount` * fx.`GBP`;'
        );

    PREPARE stmt2 FROM @updateprepaymentsStage;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
    
		
	SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_prepayments TRG
    		INNER JOIN ', @prepaymentsStage, ' STG 
        	ON TRG.`PrepaymentId` = STG.`PrepaymentId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    PREPARE stmt5 FROM @delete_trg;
	EXECUTE stmt5;
	DEALLOCATE PREPARE stmt5;
	
	
		SET @insert_xeroblue_prepayments = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_prepayments (
        `PrepaymentId`,
        `Date`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        `LineItem_TrackingCategory1_CategoryId`,
        `LineItem_TrackingCategory1_CategoryName`,
        `LineItem_TrackingCategory1_OptionId`,
        `LineItem_TrackingCategory1_OptionName`,
        `LineItem_TrackingCategory1_Option_Stat`,
        `LineItem_TrackingCategory2_CategoryId`,
        `LineItem_TrackingCategory2_CategoryName`,
        `LineItem_TrackingCategory2_OptionId`,
        `LineItem_TrackingCategory2_OptionName`,
        `LineItem_TrackingCategory2_Option_Stat`,
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        `CurrencyCode`,
        `CurrencyRate`,
        `UpdatedDateUTC`,
        `Allocation1_AppliedAmount`,
        `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        `Allocation2_AppliedAmount`,
        `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        `Allocation3_AppliedAmount`,
        `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        `Allocation4_AppliedAmount`,
        `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        `Allocation5_AppliedAmount`,
        `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        `Allocation6_AppliedAmount`,
        `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        `Allocation7_AppliedAmount`,
        `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        `Allocation8_AppliedAmount`,
        `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        `Allocation9_AppliedAmount`,
        `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        `Allocation10_AppliedAmount`,
        `Allocation10_Date`,
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        `Allocation1_AppliedAmount_AUD`,
        `Allocation1_AppliedAmount_USD`,
        `Allocation1_AppliedAmount_NZD`,
        `Allocation1_AppliedAmount_EUR`,
        `Allocation1_AppliedAmount_GBP`,
        `Allocation2_AppliedAmount_AUD`,
        `Allocation2_AppliedAmount_USD`,
        `Allocation2_AppliedAmount_NZD`,
        `Allocation2_AppliedAmount_EUR`,
        `Allocation2_AppliedAmount_GBP`,
        `Allocation3_AppliedAmount_AUD`,
        `Allocation3_AppliedAmount_USD`,
        `Allocation3_AppliedAmount_NZD`,
        `Allocation3_AppliedAmount_EUR`,
        `Allocation3_AppliedAmount_GBP`,
        `Allocation4_AppliedAmount_AUD`,
        `Allocation4_AppliedAmount_USD`,
        `Allocation4_AppliedAmount_NZD`,
        `Allocation4_AppliedAmount_EUR`,
        `Allocation4_AppliedAmount_GBP`,
        `Allocation5_AppliedAmount_AUD`,
        `Allocation5_AppliedAmount_USD`,
        `Allocation5_AppliedAmount_NZD`,
        `Allocation5_AppliedAmount_EUR`,
        `Allocation5_AppliedAmount_GBP`,
        `Allocation6_AppliedAmount_AUD`,
        `Allocation6_AppliedAmount_USD`,
        `Allocation6_AppliedAmount_NZD`,
        `Allocation6_AppliedAmount_EUR`,
        `Allocation6_AppliedAmount_GBP`,
        `Allocation7_AppliedAmount_AUD`,
        `Allocation7_AppliedAmount_USD`,
        `Allocation7_AppliedAmount_NZD`,
        `Allocation7_AppliedAmount_EUR`,
        `Allocation7_AppliedAmount_GBP`,
        `Allocation8_AppliedAmount_AUD`,
        `Allocation8_AppliedAmount_USD`,
        `Allocation8_AppliedAmount_NZD`,
        `Allocation8_AppliedAmount_EUR`,
        `Allocation8_AppliedAmount_GBP`,
        `Allocation9_AppliedAmount_AUD`,
        `Allocation9_AppliedAmount_USD`,
        `Allocation9_AppliedAmount_NZD`,
        `Allocation9_AppliedAmount_EUR`,
        `Allocation9_AppliedAmount_GBP`,
        `Allocation10_AppliedAmount_AUD`,
        `Allocation10_AppliedAmount_USD`,
        `Allocation10_AppliedAmount_NZD`,
        `Allocation10_AppliedAmount_EUR`,
        `Allocation10_AppliedAmount_GBP`
    )
    SELECT 
        prepymt.`PrepaymentId`,
        NULLIF(`Date`, ''''),
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `LineItems`,
        `LineItem_LineItemId`,
        `LineItem_Description`,
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        `LineItem_ItemCode`,
        `LineItem_AccountCode`,
        `LineItem_TaxType`,
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        `LineItem_TrackingCategory1_CategoryId`,
        `LineItem_TrackingCategory1_CategoryName`,
        `LineItem_TrackingCategory1_OptionId`,
        `LineItem_TrackingCategory1_OptionName`,
        `LineItem_TrackingCategory1_Option_Stat`,
        `LineItem_TrackingCategory2_CategoryId`,
        `LineItem_TrackingCategory2_CategoryName`,
        `LineItem_TrackingCategory2_OptionId`,
        `LineItem_TrackingCategory2_OptionName`,
        `LineItem_TrackingCategory2_Option_Stat`,
        `LineItem_DiscountRate`,
        `LineAmountTypes`,
        `CurrencyCode`,
        `CurrencyRate`,
        NULLIF(`UpdatedDateUTC`, ''''),
        alloc.`Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, ''''),
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        `HasAttachments`,
        `Payments`,
        `ClientID`,
        `OrganisationID`,
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `LineItem_UnitAmount_AUD`,
        `LineItem_UnitAmount_USD`,
        `LineItem_UnitAmount_NZD`,
        `LineItem_UnitAmount_EUR`,
        `LineItem_UnitAmount_GBP`,
        `LineItem_TaxAmount_AUD`,
        `LineItem_TaxAmount_USD`,
        `LineItem_TaxAmount_NZD`,
        `LineItem_TaxAmount_EUR`,
        `LineItem_TaxAmount_GBP`,
        `LineItem_LineAmount_AUD`,
        `LineItem_LineAmount_USD`,
        `LineItem_LineAmount_NZD`,
        `LineItem_LineAmount_EUR`,
        `LineItem_LineAmount_GBP`,
        alloc.`Allocation1_AppliedAmount_AUD`,
        alloc.`Allocation1_AppliedAmount_USD`,
        alloc.`Allocation1_AppliedAmount_NZD`,
        alloc.`Allocation1_AppliedAmount_EUR`,
        alloc.`Allocation1_AppliedAmount_GBP`,
        alloc.`Allocation2_AppliedAmount_AUD`,
        alloc.`Allocation2_AppliedAmount_USD`,
        alloc.`Allocation2_AppliedAmount_NZD`,
        alloc.`Allocation2_AppliedAmount_EUR`,
        alloc.`Allocation2_AppliedAmount_GBP`,
        alloc.`Allocation3_AppliedAmount_AUD`,
        alloc.`Allocation3_AppliedAmount_USD`,
        alloc.`Allocation3_AppliedAmount_NZD`,
        alloc.`Allocation3_AppliedAmount_EUR`,
        alloc.`Allocation3_AppliedAmount_GBP`,
        alloc.`Allocation4_AppliedAmount_AUD`,
        alloc.`Allocation4_AppliedAmount_USD`,
        alloc.`Allocation4_AppliedAmount_NZD`,
        alloc.`Allocation4_AppliedAmount_EUR`,
        alloc.`Allocation4_AppliedAmount_GBP`,
        alloc.`Allocation5_AppliedAmount_AUD`,
        alloc.`Allocation5_AppliedAmount_USD`,
        alloc.`Allocation5_AppliedAmount_NZD`,
        alloc.`Allocation5_AppliedAmount_EUR`,
        alloc.`Allocation5_AppliedAmount_GBP`,
        alloc.`Allocation6_AppliedAmount_AUD`,
        alloc.`Allocation6_AppliedAmount_USD`,
        alloc.`Allocation6_AppliedAmount_NZD`,
        alloc.`Allocation6_AppliedAmount_EUR`,
        alloc.`Allocation6_AppliedAmount_GBP`,
        alloc.`Allocation7_AppliedAmount_AUD`,
        alloc.`Allocation7_AppliedAmount_USD`,
        alloc.`Allocation7_AppliedAmount_NZD`,
        alloc.`Allocation7_AppliedAmount_EUR`,
        alloc.`Allocation7_AppliedAmount_GBP`,
        alloc.`Allocation8_AppliedAmount_AUD`,
        alloc.`Allocation8_AppliedAmount_USD`,
        alloc.`Allocation8_AppliedAmount_NZD`,
        alloc.`Allocation8_AppliedAmount_EUR`,
        alloc.`Allocation8_AppliedAmount_GBP`,
        alloc.`Allocation9_AppliedAmount_AUD`,
        alloc.`Allocation9_AppliedAmount_USD`,
        alloc.`Allocation9_AppliedAmount_NZD`,
        alloc.`Allocation9_AppliedAmount_EUR`,
        alloc.`Allocation9_AppliedAmount_GBP`,
        alloc.`Allocation10_AppliedAmount_AUD`,
        alloc.`Allocation10_AppliedAmount_USD`,
        alloc.`Allocation10_AppliedAmount_NZD`,
        alloc.`Allocation10_AppliedAmount_EUR`,
        alloc.`Allocation10_AppliedAmount_GBP`
    FROM ', @prepaymentsStage, ' prepymt
    LEFT JOIN (
    SELECT 
            PrepaymentId,
            MAX(CASE WHEN AllocationNumber = 1 THEN AppliedAmount END) AS Allocation1_AppliedAmount,
                 MAX(CASE WHEN AllocationNumber = 1 THEN AUD END) AS `Allocation1_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN USD END) AS  `Allocation1_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN NZD END) AS  `Allocation1_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 1 THEN EUR END) AS  `Allocation1_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 1 THEN GBP END) AS  `Allocation1_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 2 THEN AppliedAmount END) AS Allocation2_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 2 THEN AUD END) AS `Allocation2_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN USD END) AS  `Allocation2_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN NZD END) AS  `Allocation2_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 2 THEN EUR END) AS  `Allocation2_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 2 THEN GBP END) AS  `Allocation2_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 3 THEN AppliedAmount END) AS Allocation3_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 3 THEN AUD END) AS `Allocation3_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN USD END) AS  `Allocation3_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN NZD END) AS  `Allocation3_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 3 THEN EUR END) AS  `Allocation3_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 3 THEN GBP END) AS  `Allocation3_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 4 THEN AppliedAmount END) AS Allocation4_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 4 THEN AUD END) AS `Allocation4_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN USD END) AS  `Allocation4_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN NZD END) AS  `Allocation4_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 4 THEN EUR END) AS  `Allocation4_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 4 THEN GBP END) AS  `Allocation4_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 5 THEN AppliedAmount END) AS Allocation5_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 5 THEN AUD END) AS `Allocation5_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN USD END) AS  `Allocation5_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN NZD END) AS  `Allocation5_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 5 THEN EUR END) AS  `Allocation5_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 5 THEN GBP END) AS  `Allocation5_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 6 THEN AppliedAmount END) AS Allocation6_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 6 THEN AUD END) AS `Allocation6_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN USD END) AS  `Allocation6_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN NZD END) AS  `Allocation6_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 6 THEN EUR END) AS  `Allocation6_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 6 THEN GBP END) AS  `Allocation6_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 7 THEN AppliedAmount END) AS Allocation7_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 7 THEN AUD END) AS `Allocation7_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN USD END) AS  `Allocation7_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN NZD END) AS  `Allocation7_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 7 THEN EUR END) AS  `Allocation7_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 7 THEN GBP END) AS  `Allocation7_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 8 THEN AppliedAmount END) AS Allocation8_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 8 THEN AUD END) AS `Allocation8_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN USD END) AS  `Allocation8_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN NZD END) AS  `Allocation8_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 8 THEN EUR END) AS  `Allocation8_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 8 THEN GBP END) AS  `Allocation8_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 9 THEN AppliedAmount END) AS Allocation9_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 9 THEN AUD END) AS `Allocation9_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN USD END) AS  `Allocation9_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN NZD END) AS  `Allocation9_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 9 THEN EUR END) AS  `Allocation9_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 9 THEN GBP END) AS  `Allocation9_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 10 THEN AppliedAmount END) AS Allocation10_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 10 THEN AUD END) AS `Allocation10_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN USD END) AS  `Allocation10_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN NZD END) AS  `Allocation10_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 10 THEN EUR END) AS  `Allocation10_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 10 THEN GBP END) AS  `Allocation10_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 11 THEN AppliedAmount END) AS Allocation11_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 11 THEN AUD END) AS `Allocation11_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN USD END) AS  `Allocation11_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN NZD END) AS  `Allocation11_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 11 THEN EUR END) AS  `Allocation11_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 11 THEN GBP END) AS  `Allocation11_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 12 THEN AppliedAmount END) AS Allocation12_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 12 THEN AUD END) AS `Allocation12_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN USD END) AS  `Allocation12_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN NZD END) AS  `Allocation12_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 12 THEN EUR END) AS  `Allocation12_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 12 THEN GBP END) AS  `Allocation12_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 13 THEN AppliedAmount END) AS Allocation13_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 13 THEN AUD END) AS `Allocation13_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN USD END) AS  `Allocation13_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN NZD END) AS  `Allocation13_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 13 THEN EUR END) AS  `Allocation13_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 13 THEN GBP END) AS  `Allocation13_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 14 THEN AppliedAmount END) AS Allocation14_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 14 THEN AUD END) AS `Allocation14_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN USD END) AS  `Allocation14_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN NZD END) AS  `Allocation14_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 14 THEN EUR END) AS  `Allocation14_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 14 THEN GBP END) AS  `Allocation14_AppliedAmount_GBP`,
            MAX(CASE WHEN AllocationNumber = 15 THEN AppliedAmount END) AS Allocation15_AppliedAmount,
            MAX(CASE WHEN AllocationNumber = 15 THEN AUD END) AS `Allocation15_AppliedAmount_AUD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN USD END) AS  `Allocation15_AppliedAmount_USD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN NZD END) AS  `Allocation15_AppliedAmount_NZD`,
       MAX(CASE WHEN AllocationNumber = 15 THEN EUR END) AS  `Allocation15_AppliedAmount_EUR`,
       MAX(CASE WHEN AllocationNumber = 15 THEN GBP END) AS  `Allocation15_AppliedAmount_GBP`
         FROM prepaymentsAllocations
         GROUP BY PrepaymentId) alloc ON prepymt.PrepaymentId = alloc.PrepaymentId;
		');

		PREPARE stmt6 FROM @insert_xeroblue_prepayments;
		EXECUTE stmt6;
		DEALLOCATE PREPARE stmt6;


				
END
$$

DELIMITER ;