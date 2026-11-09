DELIMITER $$
DROP PROCEDURE IF EXISTS sp_c1518_5393_xeroblue_batchpayments $$
CREATE PROCEDURE sp_c1518_5393_xeroblue_batchpayments()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT 5393;

    DELETE `TRG`
    FROM `c1518_xeroblue_batchpayments` `TRG`
    INNER JOIN `c1518_5393_xeroblue_batchpaymentsstage` `STG` 
        ON `TRG`.`BatchPaymentId` = `STG`.`BatchPaymentId`
        AND `TRG`.`OrganisationId` = `STG`.`OrganisationId`
    WHERE `TRG`.`OrganisationId` = v_OrganisationID;

    INSERT INTO `c1518_xeroblue_batchpayments` 
    SELECT 
        `Id`,
        `BatchPaymentId`,
        `AccountId`,
        `Particulars`,
        `Code`,
        `Reference`,
        `Details`,
        `Narrative`,
        NULLIF(`Date`,''),
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
        NULLIF(`UpdatedDateUTC`,''),
        `ClientID`,
        `OrganisationID`
    FROM `c1518_5393_xeroblue_batchpaymentsstage`;
END $$
DELIMITER ;