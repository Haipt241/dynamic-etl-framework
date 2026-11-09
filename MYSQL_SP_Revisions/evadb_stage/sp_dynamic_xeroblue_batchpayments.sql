USE evadb_stage;

DROP PROCEDURE IF EXISTS sp_dynamic_xeroblue_batchpayments;

DELIMITER $$

CREATE 
	DEFINER = 'etaniadmin'@'%'
PROCEDURE sp_dynamic_xeroblue_batchpayments(IN p_clientID INT, IN p_orgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID INT DEFAULT p_clientID;
    SET v_OrganisationID = CASE WHEN p_legacyOrgID <> 0 THEN p_legacyOrgID ELSE p_orgID END;

    -- Replace hardcoded table references with dynamic ones
    SET @batchPaymentsStage = CONCAT('c', v_clientID, '_', p_orgID, '_xeroblue_batchpaymentsstage');

    SET @delete_sql = CONCAT('
        DELETE `TRG`
        FROM `c',v_clientID,'_xeroblue_batchpayments` `TRG`
        INNER JOIN `',@batchPaymentsStage,'` `STG` 
            ON `TRG`.`BatchPaymentId` = `STG`.`BatchPaymentId`
            AND `TRG`.`OrganisationId` = `STG`.`OrganisationId`
        WHERE `TRG`.`OrganisationId` = ',v_OrganisationID,'
        ;');
    PREPARE del_stmt FROM @delete_sql;
    EXECUTE del_stmt;
    DEALLOCATE PREPARE del_stmt;

    SET @insert_sql = CONCAT('
        INSERT INTO `c',v_clientID,'_xeroblue_batchpayments` 
        SELECT 
            `Id`,
            `BatchPaymentId`,
            `AccountId`,
            `Particulars`,
            `Code`,
            `Reference`,
            `Details`,
            `Narrative`,
            NULLIF(`Date`,''''),
            `Payment_PaymentId`,
            `Payment_InvoiceId`,
            `Payment_BankAccountNumber`,
            `Payment_Particulars`,
            `Payment_Code`,
            `Payment_Reference`,
            `Payment_Details`,
            `Payment_Amount`,
            `PaymentAggregate`,
            `Type`,
            `Status`,
            `TotalAmount`,
            `IsReconciled`,
            NULLIF(`UpdatedDateUTC`,''''),
            `ClientID`,
            `OrganisationID`
        FROM `',@batchPaymentsStage,'`
        ;');
END
$$

DELIMITER ;