ALTER TABLE evadb_stage.c1518_7232_xeroblue_journalsstage
ADD COLUMN `IsVisible` BOOLEAN DEFAULT TRUE AFTER `DueDate`;

UPDATE c1518_xeroblue_journals J
LEFT JOIN (
        SELECT DISTINCT ID, Source, Status, OrganisationID FROM c1518_xeroblue_transactions
        WHERE Status IN ('VOIDED', 'DELETED')
    ) DELETED 
    ON DELETED.ID = J.SourceID AND DELETED.OrganisationID = J.OrganisationID
LEFT JOIN (
        SELECT BankTransferID, OrganisationID FROM c1518_xeroblue_bankTransfers
    ) BT 
    ON BT.BankTransferID = J.SourceID AND BT.OrganisationID = J.OrganisationID
SET isvisible = 0
WHERE (
    DELETED.ID IS NOT NULL 
    OR (
            J.SourceType = 'TRANSFER' 
        AND BT.BankTransferID IS NULL
        )
    );

WITH JournalTotals AS (
    SELECT 
        SourceId,
        JournalNumber,
        JournalDate,
        CreatedDateUTC,
        SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2))) AS Total_NetAmount,
        SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2))) AS Total_GrossAmount,
        LAG(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_NetAmount,
        LAG(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagTotal_GrossAmount,
        LAG(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LagCreatedDateUTC,
        LEAD(SUM(CAST(JournalLine_NetAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_NetAmount,
        LEAD(SUM(CAST(JournalLine_GrossAmount AS DECIMAL(10,2)))) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadTotal_GrossAmount,
        LEAD(CreatedDateUTC) OVER (PARTITION BY SourceId ORDER BY JournalNumber) AS LeadCreatedDateUTC
    FROM c1518_xeroblue_Journals
    WHERE JournalLine_JournalLineId IS NOT NULL
    GROUP BY 
        SourceId,
        JournalNumber,
        JournalDate,
        CreatedDateUTC
)
UPDATE c1518_xeroblue_Journals j
JOIN JournalTotals jt
ON j.SourceId = jt.SourceId
    AND j.JournalNumber = jt.JournalNumber
SET j.isvisible = 
    CASE 
        WHEN LagCreatedDateUTC IS NULL 
            AND LeadCreatedDateUTC <> jt.CreatedDateUTC
            AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
            AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
        THEN 0
        WHEN LeadCreatedDateUTC IS NOT NULL
            AND LagCreatedDateUTC <> jt.CreatedDateUTC
            AND (Total_NetAmount + COALESCE(LagTotal_NetAmount, 0) = 0) 
            AND (Total_GrossAmount + COALESCE(LagTotal_GrossAmount, 0) = 0) 
        THEN 0
        WHEN LeadCreatedDateUTC <> jt.CreatedDateUTC
            AND (Total_NetAmount + COALESCE(LeadTotal_NetAmount, 0) = 0) 
            AND (Total_GrossAmount + COALESCE(LeadTotal_GrossAmount, 0) = 0) 
        THEN 0
        ELSE 1
    END
WHERE ContactSource <> 'PAYMENTS' AND isvisible <> 0;


WITH invallocation AS (
  SELECT j.SourceId
    ,j.journalnumber 
    ,j.JournalDate
    ,j.createddateutc
    ,j.Sourcetype
    ,j.JournalLine_AccountName
    ,j.JournalLine_GrossAmount
    ,j.isvisible
    ,j.ContactSource
    ,j.InvoiceNumber
    ,t.PaymentSourceID
    ,t.PaymentType
    ,t.AllocationDate
    ,t.AllocationAmount
    ,ROW_NUMBER() OVER(
            PARTITION BY j.JournalLine_AccountName, j.JournalLine_GrossAmount 
            ORDER BY j.journalnumber DESC
        ) AS rn
  FROM c1518_xeroblue_Journals j
  JOIN c1518_xeroblue_transactions t
    ON t.ID = j.SourceID 
    AND t.OrganisationID = j.OrganisationID
    AND t.AllocationAmount = j.JournalLine_GrossAmount
  WHERE j.ContactSource IN ('CREDITNOTES', 'OVERPAYMENTS', 'PREPAYMENTS')
)
UPDATE c1518_xeroblue_Journals j
JOIN invallocation i
    ON i.journalnumber = j.journalnumber
SET j.isvisible = 
        CASE
            WHEN rn = 1 THEN 1
            ELSE 0
        END;


WITH journaloutdated AS (
  SELECT SourceId
    ,COUNT(DISTINCT journalnumber) AS rc
  FROM c1518_xeroblue_Journals
  GROUP BY SourceId
)
UPDATE c1518_xeroblue_Journals j
JOIN journaloutdated i
    ON i.SourceId = j.SourceId
    AND i.rc <= 2
SET j.isvisible = 1;

WITH inbetween AS (
    SELECT SourceId
      ,journalnumber
      ,LAG(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelag
      ,LEAD(isvisible) OVER(PARTITION BY SourceId ORDER BY journalnumber) AS isvisiblelead
      ,isvisible
    FROM c1518_xeroblue_Journals
    GROUP BY SourceId, journalnumber, isvisible
)
UPDATE c1518_xeroblue_Journals j
JOIN inbetween i
    ON i.SourceId = j.SourceId
    AND i.journalnumber = j.journalnumber
SET j.isvisible = 0
WHERE isvisiblelag = 0
    AND isvisiblelead = 0;


UPDATE c1518_xeroblue_Journals J
JOIN c1518_xeroblue_transactions T
    ON j.`SourceId` = t.`Id`
    AND j.`OrganisationID` = t.`OrganisationID`
    AND j.`JournalLine_GrossAmount` = 
            CASE WHEN ContactSource = 'CREDITNOTES' 
                THEN t.`AllocationAmount` * -1
            ELSE t.`AllocationAmount`
            END
SET  
    J.`PaymentSourceID` = t.`PaymentSourceID`,
    J.`PaymentType` = t.`PaymentType`
WHERE j.SystemAccount = 'DEBTORS';


UPDATE c1518_xeroblue_Journals J
SET  
    j.`AgedMovement` =
      CASE
          WHEN J.`SourceType` = 'ACCREC' THEN 'Accruals'
          WHEN J.`SourceType` = 'ACCPAY' THEN 'Accruals'
          WHEN J.`SourceType` = 'ACCRECCREDIT' AND J.PaymentSourceID IS NULL THEN 'Accruals'
          WHEN J.`SourceType` = 'ACCRECCREDIT' AND J.PaymentSourceID IS NOT NULL THEN 'Payments'
          WHEN J.`SourceType` = 'ACCRECPAYMENT' THEN 'Payments'
          WHEN J.`SourceType` = 'ACCPAYCREDIT' THEN 'Payments'
          WHEN J.`SourceType` = 'ARPREPAYMENT' THEN 'Payments'
          WHEN J.`SourceType` = 'AROVERPAYMENT' THEN 'Payments'
          WHEN J.`SourceType` = 'APOVERPAYMENT'  THEN 'CashOPPP'
          ELSE NULL
      END;