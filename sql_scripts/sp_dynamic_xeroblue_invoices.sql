BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

    -- Replace hardcoded table references with dynamic ones
    SET @invoicesStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_invoicesstage');
    
    

    SELECT MAX(date) INTO v_maxDate FROM foreignexchange_master;
    SELECT MIN(date) INTO v_minDate FROM foreignexchange_master;
    
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
        AVG(CASE WHEN `Currency` = 'AUD' THEN `ExchangeRate` END) AS `AUD`,
        AVG(CASE WHEN `Currency` = 'USD' THEN `ExchangeRate` END) AS `USD`,
        AVG(CASE WHEN `Currency` = 'NZD' THEN `ExchangeRate` END) AS `NZD`,
        AVG(CASE WHEN `Currency` = 'EUR' THEN `ExchangeRate` END) AS `EUR`,
        AVG(CASE WHEN `Currency` = 'GBP' THEN `ExchangeRate` END) AS `GBP`
    FROM foreignexchange_master
    WHERE `Currency` IN ('AUD', 'USD', 'NZD', 'EUR', 'GBP')
    GROUP BY `BaseCurrency`, `Date`;
    ');
    PREPARE stmt0 FROM @insert_fxtable;
    EXECUTE stmt0;
    DEALLOCATE PREPARE stmt0;
        
        
    SET @updateinvoicesStage = CONCAT(
        'UPDATE ', @invoicesStage, '
        SET
		`DiscountRate` = IFNULL(`LineItem_DiscountRate`, 0), 
		`DiscountRate%` = IFNULL(`LineItem_DiscountRate` * 0.01, 0),
		`LineAmountCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'INCLUSIVE' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'EXCLUSIVE' OR `LineAmountTypes` = 'NOTAX') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),     
		`LineAmountCalculationIncTax` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCPAY' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),    	
		`LineAmountTradeCreditorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCPAY' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),   
		`LineAmountTradeDebtorCalculation` = CAST(
			CASE 
				WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount`)
				WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCREC' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
				ELSE 0 
			END AS DECIMAL(15, 4)
		),
		`DayDifference` =
            CASE
                WHEN NULLIF(`FullyPaidOnDate`,'') IS NOT NULL THEN DATEDIFF(CAST(`FullyPaidOnDate` AS DATE), CAST(`Date` AS DATE))
                ELSE NULL END,
		`Account_UID` = CONCAT(`LineItem_AccountCode`, '-', `OrganisationID`);'
    );

    PREPARE stmt1 FROM @updateinvoicesStage;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    

    

    SET @updateinvoicesStage3 = CONCAT(
        'UPDATE ', @invoicesStage, ' AS inv
	        LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = inv.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN inv.`Date` <= '',v_minDate,'' THEN '',v_minDate, ''
	                                                                        WHEN inv.`Date` >= '',v_maxDate,'' THEN '',v_maxDate, ''
	                                                                        ELSE inv.`Date` 
	                                                                END
	    SET  `LineItem_UnitAmount_AUD` = `inv`.`LineItem_UnitAmount` * `AUD`,
		`LineItem_UnitAmount_USD` = `inv`.`LineItem_UnitAmount` * `USD`,
		`LineItem_UnitAmount_NZD` = `inv`.`LineItem_UnitAmount` * `NZD`,
		`LineItem_UnitAmount_EUR` = `inv`.`LineItem_UnitAmount` * `EUR`,
		`LineItem_UnitAmount_GBP` = `inv`.`LineItem_UnitAmount` * `GBP`,
		`LineItem_TaxAmount_AUD` = `inv`.`LineItem_TaxAmount` * `AUD`,
		`LineItem_TaxAmount_USD` = `inv`.`LineItem_TaxAmount` * `USD`,
		`LineItem_TaxAmount_NZD` = `inv`.`LineItem_TaxAmount` * `NZD`,
		`LineItem_TaxAmount_EUR` = `inv`.`LineItem_TaxAmount` * `EUR`,
		`LineItem_TaxAmount_GBP` = `inv`.`LineItem_TaxAmount` * `GBP`,
		`LineItem_LineAmount_AUD` = `inv`.`LineItem_LineAmount` * `AUD`,
		`LineItem_LineAmount_USD` = `inv`.`LineItem_LineAmount` * `USD`,
		`LineItem_LineAmount_NZD` = `inv`.`LineItem_LineAmount` * `NZD`,
		`LineItem_LineAmount_EUR` = `inv`.`LineItem_LineAmount` * `EUR`,
		`LineItem_LineAmount_GBP` = `inv`.`LineItem_LineAmount` * `GBP`,
		`LineItem_DiscountAmount_AUD` = `inv`.`LineItem_DiscountAmount` * `AUD`,
		`LineItem_DiscountAmount_USD` = `inv`.`LineItem_DiscountAmount` * `USD`,
		`LineItem_DiscountAmount_NZD` = `inv`.`LineItem_DiscountAmount` * `NZD`,
		`LineItem_DiscountAmount_EUR` = `inv`.`LineItem_DiscountAmount` * `EUR`,
		`LineItem_DiscountAmount_GBP` = `inv`.`LineItem_DiscountAmount` * `GBP`,
		`SubTotal_AUD` = `inv`.`SubTotal` * `AUD`,
		`SubTotal_USD` = `inv`.`SubTotal` * `USD`,
		`SubTotal_NZD` = `inv`.`SubTotal` * `NZD`,
		`SubTotal_EUR` = `inv`.`SubTotal` * `EUR`,
		`SubTotal_GBP` = `inv`.`SubTotal` * `GBP`,
		`TotalTax_AUD` = `inv`.`TotalTax` * `AUD`,
		`TotalTax_USD` = `inv`.`TotalTax` * `USD`,
		`TotalTax_NZD` = `inv`.`TotalTax` * `NZD`,
		`TotalTax_EUR` = `inv`.`TotalTax` * `EUR`,
		`TotalTax_GBP` = `inv`.`TotalTax` * `GBP`,
		`Total_AUD` = `inv`.`Total` * `AUD`,
		`Total_USD` = `inv`.`Total` * `USD`,
		`Total_NZD` = `inv`.`Total` * `NZD`,
		`Total_EUR` = `inv`.`Total` * `EUR`,
		`Total_GBP` = `inv`.`Total` * `GBP`,
		`TotalDiscount_AUD` = `inv`.`TotalDiscount` * `AUD`,
		`TotalDiscount_USD` = `inv`.`TotalDiscount` * `USD`,
		`TotalDiscount_NZD` = `inv`.`TotalDiscount` * `NZD`,
		`TotalDiscount_EUR` = `inv`.`TotalDiscount` * `EUR`,
		`TotalDiscount_GBP` = `inv`.`TotalDiscount` * `GBP`,
		`AmountDue_AUD` = `inv`.`AmountDue` * `AUD`,
		`AmountDue_USD` = `inv`.`AmountDue` * `USD`,
		`AmountDue_NZD` = `inv`.`AmountDue` * `NZD`,
		`AmountDue_EUR` = `inv`.`AmountDue` * `EUR`,
		`AmountDue_GBP` = `inv`.`AmountDue` * `GBP`,
		`AmountPaid_AUD` = `inv`.`AmountPaid` * `AUD`,
		`AmountPaid_USD` = `inv`.`AmountPaid` * `USD`,
		`AmountPaid_NZD` = `inv`.`AmountPaid` * `NZD`,
		`AmountPaid_EUR` = `inv`.`AmountPaid` * `EUR`,
		`AmountPaid_GBP` = `inv`.`AmountPaid` * `GBP`,
		`CISDeduction_AUD` = `inv`.`CISDeduction` * `AUD`,
		`CISDeduction_USD` = `inv`.`CISDeduction` * `USD`,
		`CISDeduction_NZD` = `inv`.`CISDeduction` * `NZD`,
		`CISDeduction_EUR` = `inv`.`CISDeduction` * `EUR`,
		`CISDeduction_GBP` = `inv`.`CISDeduction` * `GBP`,
		`AmountCredited_AUD` = `inv`.`AmountCredited` * `AUD`,
		`AmountCredited_USD` = `inv`.`AmountCredited` * `USD`,
		`AmountCredited_NZD` = `inv`.`AmountCredited` * `NZD`,
		`AmountCredited_EUR` = `inv`.`AmountCredited` * `EUR`,
		`AmountCredited_GBP` = `inv`.`AmountCredited` * `GBP`,
		`LineAmountCalculation_AUD` = `inv`.`LineAmountCalculation` * `AUD`,
		`LineAmountCalculation_USD` = `inv`.`LineAmountCalculation` * `USD`,
		`LineAmountCalculation_NZD` = `inv`.`LineAmountCalculation` * `NZD`,
		`LineAmountCalculation_EUR` = `inv`.`LineAmountCalculation` * `EUR`,
		`LineAmountCalculation_GBP` = `inv`.`LineAmountCalculation` * `GBP`,
		`LineAmountCalculationIncTax_AUD` = `inv`.`LineAmountCalculationIncTax` * `AUD`,
		`LineAmountCalculationIncTax_USD` = `inv`.`LineAmountCalculationIncTax` * `USD`,
		`LineAmountCalculationIncTax_NZD` = `inv`.`LineAmountCalculationIncTax` * `NZD`,
		`LineAmountCalculationIncTax_EUR` = `inv`.`LineAmountCalculationIncTax` * `EUR`,
		`LineAmountCalculationIncTax_GBP` = `inv`.`LineAmountCalculationIncTax` * `GBP`,
		`LineAmountTradeCreditorCalculation_AUD` = `inv`.`LineAmountTradeCreditorCalculation` * `AUD`,
		`LineAmountTradeCreditorCalculation_USD` = `inv`.`LineAmountTradeCreditorCalculation` * `USD`,
		`LineAmountTradeCreditorCalculation_NZD` = `inv`.`LineAmountTradeCreditorCalculation` * `NZD`,
		`LineAmountTradeCreditorCalculation_EUR` = `inv`.`LineAmountTradeCreditorCalculation` * `EUR`,
		`LineAmountTradeCreditorCalculation_GBP` = `inv`.`LineAmountTradeCreditorCalculation` * `GBP`,
		`LineAmountTradeDebtorCalculation_AUD` = `inv`.`LineAmountTradeDebtorCalculation` * `AUD`,
		`LineAmountTradeDebtorCalculation_USD` = `inv`.`LineAmountTradeDebtorCalculation` * `USD`,
		`LineAmountTradeDebtorCalculation_NZD` = `inv`.`LineAmountTradeDebtorCalculation` * `NZD`,
		`LineAmountTradeDebtorCalculation_EUR` = `inv`.`LineAmountTradeDebtorCalculation` * `EUR`,
		`LineAmountTradeDebtorCalculation_GBP` = `inv`.`LineAmountTradeDebtorCalculation` * `GBP`;'
		  );

		PREPARE stmt2 FROM @updateinvoicesStage3;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
		
	  -- init batching vars
        SET @ffset = 0;
        SET @rowcount = 1;
        SET @batchsize = 500;
    
        WHILE @rowcount > 0 DO
          SET @delete_trg = CONCAT(
          'DELETE TRG FROM c',v_clientID,'_xeroblue_invoices TRG
          INNER JOIN (
          SELECT InvoiceId FROM `',@invoicesStage,'`
          GROUP BY InvoiceId
          ORDER BY InvoiceId
          LIMIT ', @batchsize, ' OFFSET ', @ffset, '
          )STG  ON TRG.`InvoiceId` = STG.`InvoiceId`
          WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
          );
    	    PREPARE del_stmt FROM @delete_trg;
		    EXECUTE del_stmt;
        SELECT ROW_COUNT() INTO @rowcount;
		    DEALLOCATE PREPARE del_stmt;            
        SET @ffset = @ffset + @batchsize;
        END WHILE;

    SET @ffset = 0;
    SET @rowcount = 1;

    WHILE @rowcount > 0 DO
		SET @insert_sql = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_invoices (
        `Id`,
        `InvoiceId`,
        `Type`,
        `ContactId`,
        `ContactName`,
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
        `LineItem_DiscountAmount`,
        `LineItemAggregate`,
        `Date`,
        `DueDate`,
        `LineAmountTypes`,
        `InvoiceNumber`,
        `Reference`,
        `BrandingThemeId`,
        `URL`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Status`,
        `SentToContact`,
        `ExpectedPaymentDate`,
        `PlannedPaymentDate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        `PaymentIds`,
        `PrePaymentIds`,
        `OverPaymentIds`,
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        `FullyPaidOnDate`,
        `AmountCredited`,
        `UpdatedDateUTC`,
        `CreditNotes`,
        `Prepayments`,
        `Payments`,
        `Overpayments`,
        `RepeatingInvoiceID`,
        `ClientID`,
        `OrganisationID`,
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
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
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
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`,
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    )
    SELECT
        NULLIF(`Id`, ''),
        NULLIF(`InvoiceId`, ''),
        NULLIF(`Type`, ''),
        NULLIF(`ContactId`, ''),
        NULLIF(`ContactName`, ''),
        NULLIF(`LineItem_LineItemId`, ''),
        NULLIF(`LineItem_Description`, ''),
        `LineItem_Quantity`,
        `LineItem_UnitAmount`,
        NULLIF(`LineItem_ItemCode`, ''),
        NULLIF(`LineItem_AccountCode`, ''),
        NULLIF(`LineItem_TaxType`, ''),
        `LineItem_TaxAmount`,
        `LineItem_LineAmount`,
        NULLIF(`LineItem_TrackingCategory1_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory1_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory1_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory1_Option_Stat`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryId`, ''),
        NULLIF(`LineItem_TrackingCategory2_CategoryName`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionId`, ''),
        NULLIF(`LineItem_TrackingCategory2_OptionName`, ''),
        NULLIF(`LineItem_TrackingCategory2_Option_Stat`, ''),
        `LineItem_DiscountRate`,
        `LineItem_DiscountAmount`,
        NULLIF(`LineItemAggregate`, ''),
        NULLIF(`Date`, ''),
        NULLIF(NULLIF(`DueDate`, ''), '1753-01-31 00:00:00+00:00'),
        NULLIF(`LineAmountTypes`, ''),
        NULLIF(`InvoiceNumber`, ''),
        NULLIF(`Reference`, ''),
        NULLIF(`BrandingThemeId`, ''),
        NULLIF(`URL`, ''),
        NULLIF(`CurrencyCode`, ''),
        `CurrencyRate`,
        NULLIF(`Status`, ''),
        `SentToContact`,
        NULLIF(`ExpectedPaymentDate`, ''),
        NULLIF(`PlannedPaymentDate`, ''),
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `TotalDiscount`,
        `HasAttachments`,
        NULLIF(`PaymentIds`, ''),
        NULLIF(`PrePaymentIds`, ''),
        NULLIF(`OverPaymentIds`, ''),
        `AmountDue`,
        `AmountPaid`,
        `CISDeduction`,
        NULLIF(`FullyPaidOnDate`, ''),
        `AmountCredited`,
        NULLIF(`UpdatedDateUTC`, ''),
        NULLIF(`CreditNotes`, ''),
        NULLIF(`Prepayments`, ''),
        NULLIF(`Payments`, ''),
        NULLIF(`Overpayments`, ''),
        NULLIF(`RepeatingInvoiceID`, ''),
        NULLIF(`ClientID`, ''),
        NULLIF(`OrganisationID`, ''),
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
        `LineItem_DiscountAmount_AUD`,
        `LineItem_DiscountAmount_USD`,
        `LineItem_DiscountAmount_NZD`,
        `LineItem_DiscountAmount_EUR`,
        `LineItem_DiscountAmount_GBP`,
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
        `TotalDiscount_AUD`,
        `TotalDiscount_USD`,
        `TotalDiscount_NZD`,
        `TotalDiscount_EUR`,
        `TotalDiscount_GBP`,
        `AmountDue_AUD`,
        `AmountDue_USD`,
        `AmountDue_NZD`,
        `AmountDue_EUR`,
        `AmountDue_GBP`,
        `AmountPaid_AUD`,
        `AmountPaid_USD`,
        `AmountPaid_NZD`,
        `AmountPaid_EUR`,
        `AmountPaid_GBP`,
        `CISDeduction_AUD`,
        `CISDeduction_USD`,
        `CISDeduction_NZD`,
        `CISDeduction_EUR`,
        `CISDeduction_GBP`,
        `AmountCredited_AUD`,
        `AmountCredited_USD`,
        `AmountCredited_NZD`,
        `AmountCredited_EUR`,
        `AmountCredited_GBP`,
        `DiscountRate`,
        `DiscountRate%`,
        `LineAmountCalculation`,
        `LineAmountCalculationIncTax`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `DayDifference`, 
        `LineAmountCalculation_AUD`,
        `LineAmountCalculation_USD`,
        `LineAmountCalculation_NZD`,
        `LineAmountCalculation_EUR`,
        `LineAmountCalculation_GBP`,
        `LineAmountCalculationIncTax_AUD`,
        `LineAmountCalculationIncTax_USD`,
        `LineAmountCalculationIncTax_NZD`,
        `LineAmountCalculationIncTax_EUR`,
        `LineAmountCalculationIncTax_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`,
        `Account_UID`
    FROM ', @invoicesStage, '
    ORDER BY InvoiceId
    LIMIT ',@batchsize,' OFFSET ',@ffset,';'
    );

		PREPARE ins_stmt FROM @insert_sql;
      EXECUTE ins_stmt;
      SELECT ROW_COUNT() INTO @rowcount;
      DEALLOCATE PREPARE ins_stmt;
      SET @ffset = @ffset + @batchsize;
     END WHILE;
    
END