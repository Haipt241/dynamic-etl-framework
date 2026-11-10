USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_payments;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_payments(
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
    SET @paymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_paymentsstage');

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
        
     

    SET @updatepaymentsStage3 = CONCAT(
        'UPDATE ', @paymentsStage, ' AS pymt
        JOIN `c',v_clientID,'_xeroblue_organisationsclients` AS `org` ON `org`.`OrganisationID` = `pymt`.`OrganisationID`
        JOIN (SELECT `InvoiceId`, `CurrencyCode` FROM `c',v_clientID,'_xeroblue_invoices` WHERE `OrganisationID` = ',v_OrganisationID,') AS `inv` ON `pymt`.`InvoiceId` = `inv`.`InvoiceId`
        JOIN (SELECT `CreditNoteId`, `CurrencyCode` FROM `c',v_clientID,'_xeroblue_creditnotes` WHERE `OrganisationID` = ',v_OrganisationID,') AS `cn` ON `pymt`.`InvoiceId` = `cn`.`CreditNoteId`
        JOIN (SELECT `OverPaymentId`, `CurrencyCode` FROM `c',v_clientID,'_xeroblue_overpayments` WHERE `OrganisationID` = ',v_OrganisationID,') AS `op` ON `pymt`.`InvoiceId` = `op`.`OverPaymentId`
        JOIN (SELECT `PrePaymentId`, `CurrencyCode` FROM `c',v_clientID,'_xeroblue_prepayments` WHERE `OrganisationID` = ',v_OrganisationID,') AS `pp` ON `pymt`.`InvoiceId` = `pp`.`PrePaymentId`
	     LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = CASE 
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''ACCRECPAYMENT'', ''ACCPAYPAYMENT'') THEN `inv`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''APCREDITPAYMENT'', ''ARCREDITPAYMENT'') THEN `cn`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''APOVERPAYMENTPAYMENT'', ''AROVERPAYMENTPAYMENT'') THEN `op`.`CurrencyCode`
                    WHEN UPPER(`pymt`.`PaymentType`) IN (''ARPREPAYMENTPAYMENT'', ''APPREPAYMENTPAYMENT'') THEN `pp`.`CurrencyCode`
                    ELSE `org`.`BaseCurrency` 
                END
	            AND fx.`Date` = CASE 
	            	WHEN pymt.`Date` <= ''',v_minDate,''' THEN ''',v_minDate, '''
						WHEN pymt.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
						ELSE pymt.`Date` 
					END
	    SET
	    `Amount_AUD` = CASE 
            WHEN `org`.`BaseCurrency` = ''AUD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`AUD` 
        END,
        `Amount_USD` = CASE 
            WHEN `org`.`BaseCurrency` = ''USD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`USD` 
        END,
        `Amount_NZD` = CASE 
            WHEN `org`.`BaseCurrency` = ''NZD'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`NZD` 
        END,
        `Amount_EUR` = CASE 
            WHEN `org`.`BaseCurrency` = ''EUR'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
                    ELSE `pymt`.`Amount` * `fx`.`EUR` 
        END,
        `Amount_GBP` = CASE 
            WHEN `org`.`BaseCurrency` = ''GBP'' AND CAST(`pymt`.`CurrencyRate` AS DECIMAL) <> 0 THEN `pymt`.`Amount` / CAST(`pymt`.`CurrencyRate` AS DECIMAL)
            ELSE `pymt`.`Amount` * `fx`.`GBP` 
        END;'
		  );
		  
		PREPARE stmt2 FROM @updatepaymentsStage3;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
		
		SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_payments TRG
    		INNER JOIN ', @paymentsStage, ' STG 
        	ON TRG.`PaymentId` = STG.`PaymentId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    	PREPARE stmt3 FROM @delete_trg;
		EXECUTE stmt3;
		DEALLOCATE PREPARE stmt3;
		
	
		SET @insert_xeroblue_payments = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_payments (
         `PaymentId`,
            `Date`,
            `Amount`,
            `CurrencyRate`,
            `Reference`,
            `PaymentType`,
            `Status`,
            `UpdatedDateUTC`,
            `IsReconciled`,
            `BatchPaymentId`,
            `InvoiceId`,
            `InvoiceNumber`,
            `CreditNoteId`,
            `CreditNoteNumber`,
            `AccountId`,
            `AccountCode`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
        )
        SELECT
            `PaymentId`,
                NULLIF(`Date`, ''''),
                `Amount`,
                `CurrencyRate`,
                `Reference`,
                `PaymentType`,
                `Status`,
                NULLIF(`UpdatedDateUTC`, ''''),
                `IsReconciled`,
                `BatchPaymentId`,
                `InvoiceId`,
                `InvoiceNumber`,
                `CreditNoteId`,
                `CreditNoteNumber`,
                `AccountId`,
                `AccountCode`,
                `ClientID`,
                `OrganisationID`,
                `Amount_AUD`,
                `Amount_USD`,
                `Amount_NZD`,
                `Amount_EUR`,
                `Amount_GBP`
        FROM ', @paymentsStage, ' pymt;    
		');

		PREPARE stmt4 FROM @insert_xeroblue_payments;
		EXECUTE stmt4;
		DEALLOCATE PREPARE stmt4;

				
				
END
$$

DELIMITER ;