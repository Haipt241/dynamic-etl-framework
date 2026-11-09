USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_overpayments;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_overpayments(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    -- Replace hardcoded table references with dynamic ones
    SET @overpaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_overpaymentsstage');
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

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
        
    -- Allocations temp table creation and population for speedier insertion
    CREATE TEMPORARY TABLE IF NOT EXISTS Allocations (
        AllocationID INT AUTO_INCREMENT PRIMARY KEY,
        OverpaymentId VARCHAR(100) NOT NULL,
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
        'INSERT INTO Allocations (OverpaymentId, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode)
          SELECT OverpaymentId, 1, Allocation1_Date, Allocation1_AppliedAmount, CurrencyCode
          FROM ', @overpaymentsStage, '
          WHERE Allocation1_Date IS NOT NULL
          UNION ALL
          SELECT OverpaymentId, 2, Allocation2_Date, Allocation2_AppliedAmount, CurrencyCode
          FROM ', @overpaymentsStage, '
          WHERE Allocation2_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 3, ovrpymt.Allocation3_Date, ovrpymt.Allocation3_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation3_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 4, ovrpymt.Allocation4_Date, ovrpymt.Allocation4_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation4_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 5, ovrpymt.Allocation5_Date, ovrpymt.Allocation5_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation5_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 6, ovrpymt.Allocation6_Date, ovrpymt.Allocation6_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation6_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 7, ovrpymt.Allocation7_Date, ovrpymt.Allocation7_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation7_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 8, ovrpymt.Allocation8_Date, ovrpymt.Allocation8_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation8_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 9, ovrpymt.Allocation9_Date, ovrpymt.Allocation9_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation9_Date IS NOT NULL
		    UNION ALL
		    SELECT
		    ovrpymt.OverpaymentId, 10, ovrpymt.Allocation10_Date, ovrpymt.Allocation10_AppliedAmount, ovrpymt.CurrencyCode
		    FROM ', @overpaymentsStage, ' AS ovrpymt
		    WHERE ovrpymt.Allocation10_Date IS NOT NULL
		    ;'
    );

    PREPARE stmt11 FROM @insertAllocationsQuery;
    EXECUTE stmt11;
    DEALLOCATE PREPARE stmt11;

    -- Update allocations currencies
    SET @update_allocations = CONCAT('
	    UPDATE Allocations AS alloc
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
    PREPARE stmt FROM @update_allocations;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
         
    

    SET @updateoverpaymentsStage3 = CONCAT(
        'UPDATE ', @overpaymentsStage, ' AS ovrpymt
	        LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = ovrpymt.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN ovrpymt.`Date` <= ''',v_minDate,''' THEN ''',v_minDate, '''
	                                                                        WHEN ovrpymt.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
	                                                                        ELSE ovrpymt.`Date` 
	                                                                END
	    SET `RemainingCredit_AUD` = ovrpymt.`RemainingCredit` * fx.`AUD`,
        `RemainingCredit_USD` = ovrpymt.`RemainingCredit` * fx.`USD`,
        `RemainingCredit_NZD` = ovrpymt.`RemainingCredit` * fx.`NZD`,
        `RemainingCredit_EUR` = ovrpymt.`RemainingCredit` * fx.`EUR`,
        `RemainingCredit_GBP` = ovrpymt.`RemainingCredit` * fx.`GBP`,
        `SubTotal_AUD` = ovrpymt.`SubTotal` * fx.`AUD`,
        `SubTotal_USD` = ovrpymt.`SubTotal` * fx.`USD`,
        `SubTotal_NZD` = ovrpymt.`SubTotal` * fx.`NZD`,
        `SubTotal_EUR` = ovrpymt.`SubTotal` * fx.`EUR`,
        `SubTotal_GBP` = ovrpymt.`SubTotal` * fx.`GBP`,
        `TotalTax_AUD` = ovrpymt.`TotalTax` * fx.`AUD`,
        `TotalTax_USD` = ovrpymt.`TotalTax` * fx.`USD`,
        `TotalTax_NZD` = ovrpymt.`TotalTax` * fx.`NZD`,
        `TotalTax_EUR` = ovrpymt.`TotalTax` * fx.`EUR`,
        `TotalTax_GBP` = ovrpymt.`TotalTax` * fx.`GBP`,
        `Total_AUD` = ovrpymt.`Total` * fx.`AUD`,
        `Total_USD` = ovrpymt.`Total` * fx.`USD`,
        `Total_NZD` = ovrpymt.`Total` * fx.`NZD`,
        `Total_EUR` = ovrpymt.`Total` * fx.`EUR`,
        `Total_GBP` = ovrpymt.`Total` * fx.`GBP`,
        `LineItem_UnitAmount_AUD` = ovrpymt.`LineItem_UnitAmount` * fx.`AUD`,
        `LineItem_UnitAmount_USD` = ovrpymt.`LineItem_UnitAmount` * fx.`USD`,
        `LineItem_UnitAmount_NZD` = ovrpymt.`LineItem_UnitAmount` * fx.`NZD`,
        `LineItem_UnitAmount_EUR` = ovrpymt.`LineItem_UnitAmount` * fx.`EUR`,
        `LineItem_UnitAmount_GBP` = ovrpymt.`LineItem_UnitAmount` * fx.`GBP`,
        `LineItem_TaxAmount_AUD` = ovrpymt.`LineItem_TaxAmount` * fx.`AUD`,
        `LineItem_TaxAmount_USD` = ovrpymt.`LineItem_TaxAmount` * fx.`USD`,
        `LineItem_TaxAmount_NZD` = ovrpymt.`LineItem_TaxAmount` * fx.`NZD`,
        `LineItem_TaxAmount_EUR` = ovrpymt.`LineItem_TaxAmount` * fx.`EUR`,
        `LineItem_TaxAmount_GBP` = ovrpymt.`LineItem_TaxAmount` * fx.`GBP`,
        `LineItem_LineAmount_AUD` = ovrpymt.`LineItem_LineAmount` * fx.`AUD`,
        `LineItem_LineAmount_USD` = ovrpymt.`LineItem_LineAmount` * fx.`USD`,
        `LineItem_LineAmount_NZD` = ovrpymt.`LineItem_LineAmount` * fx.`NZD`,
        `LineItem_LineAmount_EUR` = ovrpymt.`LineItem_LineAmount` * fx.`EUR`,
        `LineItem_LineAmount_GBP` = ovrpymt.`LineItem_LineAmount` * fx.`GBP`;'
		);		
		  
		PREPARE stmt4 FROM @updateoverpaymentsStage3;
		EXECUTE stmt4;
		DEALLOCATE PREPARE stmt4;
		
		SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_overpayments TRG
    		INNER JOIN ', @overpaymentsStage, ' STG 
        	ON TRG.`OverpaymentId` = STG.`OverpaymentId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    	PREPARE stmt5 FROM @delete_trg;
		EXECUTE stmt5;
		DEALLOCATE PREPARE stmt5;
		
	
		SET @insert_xeroblue_overpayments = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_overpayments (
        `OverpaymentId`,
        `Date`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
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
        ovrpymt.`OverpaymentId`,
        NULLIF(`Date`, '''') AS `Date`,
        `Type`,
        `RemainingCredit`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
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
        ovrpymt.`CurrencyCode`,
        ovrpymt.`CurrencyRate`,
        NULLIF(`UpdatedDateUTC`, '''') AS `UpdatedDateUTC`,
        alloc.`Allocation1_AppliedAmount`,
        NULLIF(`Allocation1_Date`, '''') AS `Allocation1_Date`,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, '''') AS `Allocation2_Date`,
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, '''') AS `Allocation3_Date`,
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, '''') AS `Allocation4_Date`,
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, '''') AS `Allocation5_Date`,
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, '''') AS `Allocation6_Date`,
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, '''') AS `Allocation7_Date`,
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, '''') AS `Allocation8_Date`,
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, '''') AS `Allocation9_Date`,
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, '''') AS `Allocation10_Date`,
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
    FROM ', @overpaymentsStage, ' ovrpymt
    LEFT JOIN (
    SELECT 
            OverpaymentId,
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
            MAX(CASE WHEN AllocationNumber = 10 THEN GBP END) AS  `Allocation10_AppliedAmount_GBP`       
         FROM Allocations
         GROUP BY OverpaymentId) alloc ON ovrpymt.OverpaymentId = alloc.OverpaymentId;
		');

		PREPARE stmt6 FROM @insert_xeroblue_overpayments;
		EXECUTE stmt6;
		DEALLOCATE PREPARE stmt6;

				
				
END
$$

DELIMITER ;