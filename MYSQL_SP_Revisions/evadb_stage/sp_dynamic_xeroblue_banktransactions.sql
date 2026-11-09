USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_banktransactions;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_banktransactions(
	IN `p_clientID` VARCHAR(100),
	IN `p_orgID` INT,
	IN `p_legacyOrgID` INT
)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;
    
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;
	
    -- Replace hardcoded table references with dynamic ones
    SET @banktransactionsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransactionsstage');

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
    PREPARE stmt1 FROM @insert_fxtable;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
        
            
    SET @updatebanktransactionsStage = CONCAT(
        'UPDATE ', @banktransactionsStage, '
        SET
                `ConditionalType` = CASE 
                    WHEN `Type` = ''SPEND'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-OVERPAYMENT'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE-OVERPAYMENT'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-PREPAYMENT'' THEN ''SPEND''
                    WHEN `Type` = ''RECEIVE-PREPAYMENT'' THEN ''RECEIVE''
                    WHEN `Type` = ''SPEND-TRANSFER'' THEN ''NOTINCLUDED''
                    WHEN `Type` = ''RECEIVE-TRANSFER'' THEN ''NOTINCLUDED''
                    ELSE ''UNKNOWN'' 
                END,
                `Account_UID` = CONCAT(IFNULL(`LineItem_AccountCode`, ''BLANK''), ''-'', `OrganisationID`);'
    );

    PREPARE stmt2 FROM @updatebanktransactionsStage;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SET @updatebanktransactionsStage = CONCAT(
        'UPDATE ', @banktransactionsStage, '
                SET
                `BankTansactionCashflowCalculation` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount`)  
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`)  
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                ),  
                `LineAmountCalculatedIncTax` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`) 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount`) 
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                ),  		
                `PaymentAmount` = CAST(
                    CASE 
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Exclusive'' THEN 0 - (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Exclusive'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''NoTax'' THEN 0 - (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''NoTax'' THEN (`LineItem_LineAmount`)
                        WHEN `ConditionalType` = ''SPEND'' AND `LineAmountTypes` = ''Inclusive'' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        WHEN `ConditionalType` = ''RECEIVE'' AND `LineAmountTypes` = ''Inclusive'' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                        ELSE 0 
                    END AS DECIMAL(15,4)
                );'
    );

    PREPARE stmt3 FROM @updatebanktransactionsStage;
    EXECUTE stmt3;
    DEALLOCATE PREPARE stmt3;
    

    

    SET @updatebanktransactionsStage3 = CONCAT(
        'UPDATE ', @banktransactionsStage, ' AS bnktrnsxn
	        LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = bnktrnsxn.`CurrencyCode` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN bnktrnsxn.`Date` <= ''',v_minDate,''' THEN ''',v_minDate, '''
	                                                                        WHEN bnktrnsxn.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
	                                                                        ELSE bnktrnsxn.`Date` 
	                                                                END
	    	SET  
                `LineItem_UnitAmount_AUD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`AUD`,
                `LineItem_UnitAmount_USD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`USD`,
                `LineItem_UnitAmount_NZD` = bnktrnsxn.`LineItem_UnitAmount` * fx.`NZD`,
                `LineItem_UnitAmount_EUR` = bnktrnsxn.`LineItem_UnitAmount` * fx.`EUR`,
                `LineItem_UnitAmount_GBP` = bnktrnsxn.`LineItem_UnitAmount` * fx.`GBP`,
                `LineItem_TaxAmount_AUD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`AUD`,
                `LineItem_TaxAmount_USD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`USD`,
                `LineItem_TaxAmount_NZD` = bnktrnsxn.`LineItem_TaxAmount` * fx.`NZD`,
                `LineItem_TaxAmount_EUR` = bnktrnsxn.`LineItem_TaxAmount` * fx.`EUR`,
                `LineItem_TaxAmount_GBP` = bnktrnsxn.`LineItem_TaxAmount` * fx.`GBP`,
                `LineItem_LineAmount_AUD` = bnktrnsxn.`LineItem_LineAmount` * fx.`AUD`,
                `LineItem_LineAmount_USD` = bnktrnsxn.`LineItem_LineAmount` * fx.`USD`,
                `LineItem_LineAmount_NZD` = bnktrnsxn.`LineItem_LineAmount` * fx.`NZD`,
                `LineItem_LineAmount_EUR` = bnktrnsxn.`LineItem_LineAmount` * fx.`EUR`,
                `LineItem_LineAmount_GBP` = bnktrnsxn.`LineItem_LineAmount` * fx.`GBP`,
                `SubTotal_AUD` = bnktrnsxn.`SubTotal` * fx.`AUD`,
                `SubTotal_USD` = bnktrnsxn.`SubTotal` * fx.`USD`,
                `SubTotal_NZD` = bnktrnsxn.`SubTotal` * fx.`NZD`,
                `SubTotal_EUR` = bnktrnsxn.`SubTotal` * fx.`EUR`,
                `SubTotal_GBP` = bnktrnsxn.`SubTotal` * fx.`GBP`,
                `TotalTax_AUD` = bnktrnsxn.`TotalTax` * fx.`AUD`,
                `TotalTax_USD` = bnktrnsxn.`TotalTax` * fx.`USD`,
                `TotalTax_NZD` = bnktrnsxn.`TotalTax` * fx.`NZD`,
                `TotalTax_EUR` = bnktrnsxn.`TotalTax` * fx.`EUR`,
                `TotalTax_GBP` = bnktrnsxn.`TotalTax` * fx.`GBP`,
                `Total_AUD` = bnktrnsxn.`Total` * fx.`AUD`,
                `Total_USD` = bnktrnsxn.`Total` * fx.`USD`,
                `Total_NZD` = bnktrnsxn.`Total` * fx.`NZD`,
                `Total_EUR` = bnktrnsxn.`Total` * fx.`EUR`,
                `Total_GBP` = bnktrnsxn.`Total` * fx.`GBP`,
                `BankTansactionCashflowCalculation_AUD` = `BankTansactionCashflowCalculation` * fx.`AUD`,
                `BankTansactionCashflowCalculation_USD` = `BankTansactionCashflowCalculation` * fx.`USD`,
                `BankTansactionCashflowCalculation_NZD` = `BankTansactionCashflowCalculation` * fx.`NZD`,
                `BankTansactionCashflowCalculation_EUR` = `BankTansactionCashflowCalculation` * fx.`EUR`,
                `BankTansactionCashflowCalculation_GBP` = `BankTansactionCashflowCalculation` * fx.`GBP`,
                `LineAmountCalculatedIncTax_AUD` = `LineAmountCalculatedIncTax` * fx.`AUD`,
                `LineAmountCalculatedIncTax_USD` = `LineAmountCalculatedIncTax` * fx.`USD`,
                `LineAmountCalculatedIncTax_NZD` = `LineAmountCalculatedIncTax` * fx.`NZD`,
                `LineAmountCalculatedIncTax_EUR` = `LineAmountCalculatedIncTax` * fx.`EUR`,
                `LineAmountCalculatedIncTax_GBP` = `LineAmountCalculatedIncTax` * fx.`GBP`,
                `PaymentAmount_AUD` = `PaymentAmount` * fx.`AUD`,
                `PaymentAmount_USD` = `PaymentAmount` * fx.`USD`,
                `PaymentAmount_NZD` = `PaymentAmount` * fx.`NZD`,
                `PaymentAmount_EUR` = `PaymentAmount` * fx.`EUR`,
                `PaymentAmount_GBP` = `PaymentAmount` * fx.`GBP`;'
		  );
		  
		PREPARE stmt4 FROM @updatebanktransactionsStage3;
		EXECUTE stmt4;
		DEALLOCATE PREPARE stmt4;
		
		SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_banktransactions TRG
    		INNER JOIN ', @banktransactionsStage, ' STG 
        	ON TRG.`BankTransactionId` = STG.`BankTransactionId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    	PREPARE stmt5 FROM @delete_trg;
		EXECUTE stmt5;
		DEALLOCATE PREPARE stmt5;
		
	
		SET @insert_xeroblue_banktransactions = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_banktransactions (
        `Id`,
                `BankTransactionId`,
                `Type`,
                `Contact_ContactName`,
                `Contact_ContactId`,
                `BankAccount_AccountId`,
                `BankAccount_AccountName`,
                `BankAccount_Code`,
                `LineItem_LineItemId`,
                `LineItem_Description`,
                `LineItem_Quantity`,
                `LineItem_UnitAmount`,
                `LineItem_AccountCode`,
                `LineItem_TaxType`,
                `LineItem_TaxAmount`,
                `LineItem_LineAmount`,
                `LineItem_ItemCode`,
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
                `LineItemAggregate`,
                `IsReconciled`,
                `Date`,
                `Reference`,
                `CurrencyRate`,
                `URL`,
                `Status`,
                `LineAmountTypes`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `PrepaymentId`,
                `OverpaymentId`,
                `UpdatedDateUTC`,
                `FullyPaidOnDate`,
                `CurrencyCode`,
                `HasAttachments`,
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
                `ConditionalType`,
                `Account_UID`,
                `BankTansactionCashflowCalculation`,
                `BankTansactionCashflowCalculation_AUD`,
                `BankTansactionCashflowCalculation_USD`,
                `BankTansactionCashflowCalculation_NZD`,
                `BankTansactionCashflowCalculation_EUR`,
                `BankTansactionCashflowCalculation_GBP`,
                `LineAmountCalculatedIncTax`,
                `LineAmountCalculatedIncTax_AUD`,
                `LineAmountCalculatedIncTax_USD`,
                `LineAmountCalculatedIncTax_NZD`,
                `LineAmountCalculatedIncTax_EUR`,
                `LineAmountCalculatedIncTax_GBP`,
                `PaymentAmount`,
                `PaymentAmount_AUD`,
                `PaymentAmount_USD`,
                `PaymentAmount_NZD`,
                `PaymentAmount_EUR`,
                `PaymentAmount_GBP` 
            )
            SELECT
                `Id`,
                `BankTransactionId`,
                `Type`,
                `Contact_ContactName`,
                `Contact_ContactId`,
                `BankAccount_AccountId`,
                `BankAccount_AccountName`,
                `BankAccount_Code`,
                `LineItem_LineItemId`,
                SUBSTRING(`LineItem_Description`,1,100),
                `LineItem_Quantity`,
                `LineItem_UnitAmount`,
                `LineItem_AccountCode`,
                `LineItem_TaxType`,
                `LineItem_TaxAmount`,
                `LineItem_LineAmount`,
                `LineItem_ItemCode`,
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
                `LineItemAggregate`,
                `IsReconciled`,
                NULLIF(`Date`, ''''),
                LEFT(`Reference`,100),
                `CurrencyRate`,
                `URL`,
                `Status`,
                `LineAmountTypes`,
                `SubTotal`,
                `TotalTax`,
                `Total`,
                `PrepaymentId`,
                `OverpaymentId`,
                NULLIF(`UpdatedDateUTC`, ''''),
                NULLIF(`FullyPaidOnDate`, ''''),
                `CurrencyCode`,
                `HasAttachments`,
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
                `ConditionalType`,
                `Account_UID`,
                `BankTansactionCashflowCalculation`,
                `BankTansactionCashflowCalculation_AUD`,
                `BankTansactionCashflowCalculation_USD`,
                `BankTansactionCashflowCalculation_NZD`,
                `BankTansactionCashflowCalculation_EUR`,
                `BankTansactionCashflowCalculation_GBP`,
                `LineAmountCalculatedIncTax`,
                `LineAmountCalculatedIncTax_AUD`,
                `LineAmountCalculatedIncTax_USD`,
                `LineAmountCalculatedIncTax_NZD`,
                `LineAmountCalculatedIncTax_EUR`,
                `LineAmountCalculatedIncTax_GBP`,
                `PaymentAmount`,
                `PaymentAmount_AUD`,
                `PaymentAmount_USD`,
                `PaymentAmount_NZD`,
                `PaymentAmount_EUR`,
                `PaymentAmount_GBP` 
        FROM ', @banktransactionsStage, ' bnktrnsxn;
		');

		PREPARE stmt6 FROM @insert_xeroblue_banktransactions;
		EXECUTE stmt6;
		DEALLOCATE PREPARE stmt6;

				
				
END
$$

DELIMITER ;