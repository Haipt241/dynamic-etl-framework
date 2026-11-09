USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_banktransfers;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_banktransfers(
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
    SET @bankTransfersStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_banktransfersstage');

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
    PREPARE stmt0 FROM @insert_fxtable;
    EXECUTE stmt0;
    DEALLOCATE PREPARE stmt0;
        
           
    SET @updatebankTransfersStage = CONCAT(
        'UPDATE ', @bankTransfersStage, '
        AS `bnktrnsfr`
    LEFT JOIN `c1518_xeroblue_accounts` AS `acct` 
        ON `bnktrnsfr`.`FromBankAccount_AccountId` = `acct`.`AccountId` 
        AND `bnktrnsfr`.`OrganisationID` = `acct`.`OrganisationID`
    LEFT JOIN ',@fx_table,' AS `fx` ON `fx`.`BaseCurrency` = `acct`.`CurrencyCode` 
        AND `fx`.`Date` = CASE 
            WHEN `bnktrnsfr`.`Date` <= ''',v_minDate,''' THEN ''',v_minDate,''' 
            WHEN `bnktrnsfr`.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate,'''
            ELSE `bnktrnsfr`.`Date` 
        END
    SET  
        `Amount_AUD` = `bnktrnsfr`.`Amount` * `fx`.`AUD`,
        `Amount_USD` = `bnktrnsfr`.`Amount` * `fx`.`USD`,
        `Amount_NZD` = `bnktrnsfr`.`Amount` * `fx`.`NZD`,
        `Amount_EUR` = `bnktrnsfr`.`Amount` * `fx`.`EUR`,
        `Amount_GBP` = `bnktrnsfr`.`Amount` * `fx`.`GBP`;'
    );

    PREPARE stmt1 FROM @updatebankTransfersStage;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    

		SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_banktransfers TRG
    		INNER JOIN ', @bankTransfersStage, ' STG 
        	ON TRG.`BankTransferId` = STG.`BankTransferId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    	PREPARE stmt2 FROM @delete_trg;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
		
	
		SET @insert_xeroblue_banktransfers = CONCAT(
		'INSERT INTO `c',v_clientID,'_xeroblue_banktransfers` 
        SELECT 
            `BankTransferId`,
            `FromBankAccount_Code`,
            `FromBankAccount_AccountId`,
            `FromBankAccount_Name`,
            `ToBankAccount_Code`,
            `ToBankAccount_AccountId`,
            `ToBankAccount_Name`,
            `Amount`,
            NULLIF(`Date`,''''),
            `CurrencyRate`,
            `FromBankTransactionID`,
            `ToBankTransactionID`,
            `HasAttachments`,
            `CreatedDateUTC`,
            `ClientID`,
            `OrganisationID`,
            `Amount_AUD`,
            `Amount_USD`,
            `Amount_NZD`,
            `Amount_EUR`,
            `Amount_GBP`
        FROM `c1518_5393_xeroblue_banktransfersstage`
		');

		PREPARE stmt3 FROM @insert_xeroblue_banktransfers;
		EXECUTE stmt3;
		DEALLOCATE PREPARE stmt3;

				
				
END
$$

DELIMITER ;