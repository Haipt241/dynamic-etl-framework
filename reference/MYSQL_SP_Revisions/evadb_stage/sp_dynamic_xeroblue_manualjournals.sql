USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_manualjournals;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_manualjournals(
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
    SET @manualjournalsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_manualjournalsstage');

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
        
    SET @updatemanualjournalsStage3 = CONCAT(
        'UPDATE ', @manualjournalsStage, ' AS mnljrnl
         LEFT JOIN c1518_xeroblue_organisationsclients AS `org`  ON `org`.`OrganisationID` = `mnljrnl`.`OrganisationID`
	      LEFT JOIN ',@fx_table,' AS fx ON fx.`BaseCurrency` = `org`.`BaseCurrency` 
	                                AND fx.`Date` = CASE 
	                                                                        WHEN mnljrnl.`Date` <= ''',v_minDate,''' THEN ''',v_minDate, '''
	                                                                        WHEN mnljrnl.`Date` >= ''',v_maxDate,''' THEN ''',v_maxDate, '''
	                                                                        ELSE mnljrnl.`Date` 
	                                                                END
	    SET  `JournalLine_LineAmount_AUD` = `mnljrnl`.`JournalLine_LineAmount` * `AUD`
		,`JournalLine_LineAmount_USD` = `mnljrnl`.`JournalLine_LineAmount` * `USD`
		,`JournalLine_LineAmount_NZD` = `mnljrnl`.`JournalLine_LineAmount` * `NZD`
		,`JournalLine_LineAmount_EUR` = `mnljrnl`.`JournalLine_LineAmount` * `EUR`
		,`JournalLine_LineAmount_GBP` = `mnljrnl`.`JournalLine_LineAmount` * `GBP`
		,`JournalLine_TaxAmount_AUD` = `mnljrnl`.`JournalLine_TaxAmount` * `AUD`
		,`JournalLine_TaxAmount_USD` = `mnljrnl`.`JournalLine_TaxAmount` * `USD`
		,`JournalLine_TaxAmount_NZD` = `mnljrnl`.`JournalLine_TaxAmount` * `NZD`
		,`JournalLine_TaxAmount_EUR` = `mnljrnl`.`JournalLine_TaxAmount` * `EUR`
		,`JournalLine_TaxAmount_GBP` = `mnljrnl`.`JournalLine_TaxAmount` * `GBP`;
		');
		  
		PREPARE stmt1 FROM @updatemanualjournalsStage3;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;
		
		SET @delete_trg = CONCAT(
		'DELETE TRG FROM c',v_clientID,'_xeroblue_manualjournals TRG
    		INNER JOIN ', @manualjournalsStage, ' STG 
        	ON TRG.`ManualJournalId` = STG.`ManualJournalId`
    	WHERE TRG.`OrganisationId` = ',v_OrganisationID,';'
    	);
    	
    	PREPARE stmt2 FROM @delete_trg;
		EXECUTE stmt2;
		DEALLOCATE PREPARE stmt2;
		
	
		SET @insert_xeroblue_manualjournals = CONCAT(
		'INSERT INTO c',v_clientID,'_xeroblue_manualjournals (
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        `Date`,
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        `UpdatedDateUTC`,
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    )
     SELECT
        `Id`,
        `ManualJournalId`,
        `Narration`,
        `JournalLine_LineAmount`,
        `JournalLine_AccountCode`,
        `JournalLine_Description`,
        `JournalLine_TaxType`,
        `JournalLine_TaxAmount`,
        `JournalLine_TrackingCategory1_CategoryId`,
        `JournalLine_TrackingCategory1_CategoryName`,
        `JournalLine_TrackingCategory1_OptionId`,
        `JournalLine_TrackingCategory1_OptionName`,
        `JournalLine_TrackingCategory1_Option_Stat`,
        `JournalLine_TrackingCategory2_CategoryId`,
        `JournalLine_TrackingCategory2_CategoryName`,
        `JournalLine_TrackingCategory2_OptionId`,
        `JournalLine_TrackingCategory2_OptionName`,
        `JournalLine_TrackingCategory2_Option_Stat`,
        `JournalLineAggregate`,
        NULLIF(`Date`, ''''),
        `Status`,
        `URL`,
        `ShowOnCashBasisReports`,
        `LineAmountTypes`,
        NULLIF(`UpdatedDateUTC`, ''''),
        `HasAttachments`,
        `ClientID`,
        `OrganisationID`,
        `JournalLine_TaxAmount_AUD`,
        `JournalLine_TaxAmount_USD`,
        `JournalLine_TaxAmount_NZD`,
        `JournalLine_TaxAmount_EUR`,
        `JournalLine_TaxAmount_GBP`,
        `JournalLine_LineAmount_AUD`,
        `JournalLine_LineAmount_USD`,
        `JournalLine_LineAmount_NZD`,
        `JournalLine_LineAmount_EUR`,
        `JournalLine_LineAmount_GBP`
    FROM ', @manualjournalsStage, ';
		');

		PREPARE stmt3 FROM @insert_xeroblue_manualjournals;
		EXECUTE stmt3;
		DEALLOCATE PREPARE stmt3;

				
				
END
$$

DELIMITER ;