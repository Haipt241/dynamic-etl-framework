--RevisionDate=2025-01-14 04:23:12
CREATE PROCEDURE sp_{clientID}_{orgID}_xeroblue_creditnotes()
BEGIN
    DECLARE v_OrganisationID INT DEFAULT {orgID};

    DECLARE v_maxDate DATETIME;
    DECLARE v_minDate DATETIME;

    SELECT MAX(date) INTO v_maxDate FROM FOREIGNEXCHANGE_MASTER;
    SELECT MIN(date) INTO v_minDate FROM FOREIGNEXCHANGE_MASTER;

    -- FXTable creation and population
    CREATE TEMPORARY TABLE IF NOT EXISTS FXTable (
        `BaseCurrency` VARCHAR(10),
        `Date` DATE,
        `AUD` DECIMAL(10, 4),
        `USD` DECIMAL(10, 4),
        `NZD` DECIMAL(10, 4),
        `EUR` DECIMAL(10, 4),
        `GBP` DECIMAL(10, 4)
    );

    CREATE INDEX IDX_FXTABLE_Date_currency ON FXTable(BaseCurrency, DATE);
    INSERT INTO FXTable (`BaseCurrency`, `Date`, `AUD`, `USD`, `NZD`, `EUR`, `GBP`)
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

    -- Allocations temp table creation and population for speedier insertion
    CREATE TEMPORARY TABLE IF NOT EXISTS Allocations (
    AllocationID INT AUTO_INCREMENT PRIMARY KEY,
    CreditNoteID INT NOT NULL, -- Foreign key to link to credit notes
    AllocationNumber INT NOT NULL, -- Allocation sequence (1, 2, 3, ...)
    AllocationDate DATE NOT NULL,
    AppliedAmount DECIMAL(18, 2) NOT NULL,
    CurrencyCode VARCHAR(10) NOT NULL,
    AUD DECIMAL(18, 6) DEFAULT NULL,
    USD DECIMAL(18, 6) DEFAULT NULL,
    NZD DECIMAL(18, 6) DEFAULT NULL,
    EUR DECIMAL(18, 6) DEFAULT NULL,
    GBP DECIMAL(18, 6) DEFAULT NULL,
    FOREIGN KEY (CreditNoteID) REFERENCES c1518_5393_xeroblue_creditnotesstage(CreditNoteID)
    );

    INSERT INTO Allocations (
    CreditNoteID, AllocationNumber, AllocationDate, AppliedAmount, CurrencyCode
    )
    SELECT
    crdt.CreditNoteID, 1, crdt.Allocation1_Date, crdt.Allocation1_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation1_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 2, crdt.Allocation2_Date, crdt.Allocation2_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation2_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 3, crdt.Allocation3_Date, crdt.Allocation3_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation3_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 4, crdt.Allocation4_Date, crdt.Allocation4_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation4_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 5, crdt.Allocation5_Date, crdt.Allocation5_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation5_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 6, crdt.Allocation6_Date, crdt.Allocation6_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation6_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 7, crdt.Allocation7_Date, crdt.Allocation7_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation7_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 8, crdt.Allocation8_Date, crdt.Allocation8_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation8_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 9, crdt.Allocation9_Date, crdt.Allocation9_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation9_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 10, crdt.Allocation10_Date, crdt.Allocation10_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation10_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 11, crdt.Allocation11_Date, crdt.Allocation11_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation11_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 12, crdt.Allocation12_Date, crdt.Allocation12_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation12_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 13, crdt.Allocation13_Date, crdt.Allocation13_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation13_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 14, crdt.Allocation14_Date, crdt.Allocation14_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation14_Date IS NOT NULL
    UNION ALL
    SELECT
    crdt.CreditNoteID, 15, crdt.Allocation15_Date, crdt.Allocation15_AppliedAmount, crdt.CurrencyCode
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
    WHERE crdt.Allocation15_Date IS NOT NULL;

    -- update allocations currencies
    UPDATE Allocations AS alloc
    JOIN FXTable AS fx
        ON fx.BaseCurrency = alloc.CurrencyCode
        AND fx.Date = CASE
            WHEN alloc.AllocationDate <= v_minDate THEN v_minDate
            WHEN alloc.AllocationDate >= v_maxDate THEN v_maxDate
            ELSE alloc.AllocationDate
        END
    SET alloc.AUD = alloc.AppliedAmount * fx.AUD,
        alloc.USD = alloc.AppliedAmount * fx.USD,
        alloc.NZD = alloc.AppliedAmount * fx.NZD,
        alloc.EUR = alloc.AppliedAmount * fx.EUR,
        alloc.GBP = alloc.AppliedAmount * fx.GBP;

    UPDATE {clientID}_{orgID}_xeroblue_creditnotesstage
	SET
		`LineAmountCreditNoteCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAYCREDIT' THEN 0 - (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` - `LineItem_TaxAmount`)
                WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCPAYCREDIT' THEN 0 - (`LineItem_LineAmount`)
                WHEN (`LineAmountTypes` = 'Exclusive' OR `LineAmountTypes` = 'NoTax') AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeCreditorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCPAYCREDIT' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCPAYCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCPAYCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        ),
        `LineAmountTradeDebtorCalculation` = CAST(
            CASE 
                WHEN `LineAmountTypes` = 'Inclusive' AND `Type` = 'ACCRECCREDIT' THEN `LineItem_LineAmount`
                WHEN `LineAmountTypes` = 'Exclusive' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                WHEN `LineAmountTypes` = 'NoTax' AND `Type` = 'ACCRECCREDIT' THEN (`LineItem_LineAmount` + `LineItem_TaxAmount`)
                ELSE 0 
            END AS DECIMAL(15, 4)
        );

    UPDATE {clientID}_{orgID}_xeroblue_creditnotesstage AS crdt
	LEFT JOIN FXTable AS fx ON fx.`BaseCurrency` = crdt.`CurrencyCode` 
				AND fx.`Date` = CASE 
									WHEN crdt.`Date` <= v_minDate THEN v_minDate 
									WHEN crdt.`Date` >= v_maxDate THEN v_maxDate
									ELSE crdt.`Date` 
								END
    SET  `LineItem_UnitAmount_AUD` = crdt.`LineItem_UnitAmount` * fx.`AUD`
		,`LineItem_UnitAmount_USD` = crdt.`LineItem_UnitAmount` * fx.`USD`
		,`LineItem_UnitAmount_NZD` = crdt.`LineItem_UnitAmount` * fx.`NZD`
		,`LineItem_UnitAmount_EUR` = crdt.`LineItem_UnitAmount` * fx.`EUR`
		,`LineItem_UnitAmount_GBP` = crdt.`LineItem_UnitAmount` * fx.`GBP`
		,`LineItem_TaxAmount_AUD` = crdt.`LineItem_TaxAmount` * fx.`AUD`
		,`LineItem_TaxAmount_USD` = crdt.`LineItem_TaxAmount` * fx.`USD`
		,`LineItem_TaxAmount_NZD` = crdt.`LineItem_TaxAmount` * fx.`NZD`
		,`LineItem_TaxAmount_EUR` = crdt.`LineItem_TaxAmount` * fx.`EUR`
		,`LineItem_TaxAmount_GBP` = crdt.`LineItem_TaxAmount` * fx.`GBP`
		,`LineItem_LineAmount_AUD` = crdt.`LineItem_LineAmount` * fx.`AUD`
		,`LineItem_LineAmount_USD` = crdt.`LineItem_LineAmount` * fx.`USD`
		,`LineItem_LineAmount_NZD` = crdt.`LineItem_LineAmount` * fx.`NZD`
		,`LineItem_LineAmount_EUR` = crdt.`LineItem_LineAmount` * fx.`EUR`
		,`LineItem_LineAmount_GBP` = crdt.`LineItem_LineAmount` * fx.`GBP`
		,`SubTotal_AUD` = crdt.`SubTotal` * fx.`AUD`
		,`SubTotal_USD` = crdt.`SubTotal` * fx.`USD`
		,`SubTotal_NZD` = crdt.`SubTotal` * fx.`NZD`
		,`SubTotal_EUR` = crdt.`SubTotal` * fx.`EUR`
		,`SubTotal_GBP` = crdt.`SubTotal` * fx.`GBP`
		,`TotalTax_AUD` = crdt.`TotalTax` * fx.`AUD`
		,`TotalTax_USD` = crdt.`TotalTax` * fx.`USD`
		,`TotalTax_NZD` = crdt.`TotalTax` * fx.`NZD`
		,`TotalTax_EUR` = crdt.`TotalTax` * fx.`EUR`
		,`TotalTax_GBP` = crdt.`TotalTax` * fx.`GBP`
		,`Total_AUD` = crdt.`Total` * fx.`AUD`
		,`Total_USD` = crdt.`Total` * fx.`USD`
		,`Total_NZD` = crdt.`Total` * fx.`NZD`
		,`Total_EUR` = crdt.`Total` * fx.`EUR`
		,`Total_GBP` = crdt.`Total` * fx.`GBP`
		,`RemainingCredit_AUD` = crdt.`RemainingCredit` * fx.`AUD`
		,`RemainingCredit_USD` = crdt.`RemainingCredit` * fx.`USD`
		,`RemainingCredit_NZD` = crdt.`RemainingCredit` * fx.`NZD`
		,`RemainingCredit_EUR` = crdt.`RemainingCredit` * fx.`EUR`
		,`RemainingCredit_GBP` = crdt.`RemainingCredit` * fx.`GBP`
        ,`LineAmountCreditNoteCalculation_AUD` = crdt.`LineAmountCreditNoteCalculation` * fx.`AUD`
        ,`LineAmountCreditNoteCalculation_USD` = crdt.`LineAmountCreditNoteCalculation` * fx.`USD`
        ,`LineAmountCreditNoteCalculation_NZD` = crdt.`LineAmountCreditNoteCalculation` * fx.`NZD`
        ,`LineAmountCreditNoteCalculation_EUR` = crdt.`LineAmountCreditNoteCalculation` * fx.`EUR`
        ,`LineAmountCreditNoteCalculation_GBP` = crdt.`LineAmountCreditNoteCalculation` * fx.`GBP`
        ,`LineAmountTradeCreditorCalculation_AUD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`AUD`
        ,`LineAmountTradeCreditorCalculation_USD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`USD`
        ,`LineAmountTradeCreditorCalculation_NZD` = crdt.`LineAmountTradeCreditorCalculation` * fx.`NZD`
        ,`LineAmountTradeCreditorCalculation_EUR` = crdt.`LineAmountTradeCreditorCalculation` * fx.`EUR`
        ,`LineAmountTradeCreditorCalculation_GBP` = crdt.`LineAmountTradeCreditorCalculation` * fx.`GBP`
        ,`LineAmountTradeDebtorCalculation_AUD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`AUD`
        ,`LineAmountTradeDebtorCalculation_USD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`USD`
        ,`LineAmountTradeDebtorCalculation_NZD` = crdt.`LineAmountTradeDebtorCalculation` * fx.`NZD`
        ,`LineAmountTradeDebtorCalculation_EUR` = crdt.`LineAmountTradeDebtorCalculation` * fx.`EUR`
        ,`LineAmountTradeDebtorCalculation_GBP` = crdt.`LineAmountTradeDebtorCalculation` * fx.`GBP`
        WHERE fx.Date = @v_maxDate;


    
   

    DELETE TRG
	FROM {clientID}_xeroblue_creditnotes TRG
    INNER JOIN {clientID}_{orgID}_xeroblue_creditnotesstage STG 
	ON TRG.`CreditNoteId` = STG.`CreditNoteId`
    WHERE TRG.`OrganisationId` = v_OrganisationID;

    INSERT INTO {clientID}_xeroblue_creditnotes (
        `Id`,
        `CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        `Date`,
        `Status`,
        `LineAmountTypes`,
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
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `UpdatedDateUTC`,
        `CurrencyCode`,
        `FullyPaidOnDate`,
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
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
        `Allocation11_AppliedAmount`,
        `Allocation11_Date`,
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        `Allocation12_AppliedAmount`,
        `Allocation12_Date`,
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        `Allocation13_AppliedAmount`,
        `Allocation13_Date`,
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        `Allocation14_AppliedAmount`,
        `Allocation14_Date`,
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        `Allocation15_AppliedAmount`,
        `Allocation15_Date`,
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
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
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        `Allocation10_AppliedAmount_GBP`,
        `Allocation11_AppliedAmount_AUD`,
        `Allocation11_AppliedAmount_USD`,
        `Allocation11_AppliedAmount_NZD`,
        `Allocation11_AppliedAmount_EUR`,
        `Allocation11_AppliedAmount_GBP`,
        `Allocation12_AppliedAmount_AUD`,
        `Allocation12_AppliedAmount_USD`,
        `Allocation12_AppliedAmount_NZD`,
        `Allocation12_AppliedAmount_EUR`,
        `Allocation12_AppliedAmount_GBP`,
        `Allocation13_AppliedAmount_AUD`,
        `Allocation13_AppliedAmount_USD`,
        `Allocation13_AppliedAmount_NZD`,
        `Allocation13_AppliedAmount_EUR`,
        `Allocation13_AppliedAmount_GBP`,
        `Allocation14_AppliedAmount_AUD`,
        `Allocation14_AppliedAmount_USD`,
        `Allocation14_AppliedAmount_NZD`,
        `Allocation14_AppliedAmount_EUR`,
        `Allocation14_AppliedAmount_GBP`,
        `Allocation15_AppliedAmount_AUD`,
        `Allocation15_AppliedAmount_USD`,
        `Allocation15_AppliedAmount_NZD`,
        `Allocation15_AppliedAmount_EUR`,
        `Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    )
     SELECT
        `Id`,
        crdt.`CreditNoteId`,
        `CreditNoteNumber`,
        `Reference`,
        `Type`,
        `Contact_ContactId`,
        `Contact_Name`,
        NULLIF(`Date`, ''),
        `Status`,
        `LineAmountTypes`,
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
        `LineItemAggregate`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        NULLIF(`UpdatedDateUTC`, ''),
        crdt.`CurrencyCode`,
        NULLIF(`FullyPaidOnDate`, ''),
        `SentToContact`,
        `BrandingThemeId`,
        `CurrencyRate`,
        `RemainingCredit`,
        alloc.`Allocation1_AppliedAmount`,
		  NULLIF(`Allocation1_Date`, '') ,
        `Allocation1_InvoiceId`,
        `Allocation1_InvoiceNumber`,
        alloc.`Allocation2_AppliedAmount`,
        NULLIF(`Allocation2_Date`, ''),
        `Allocation2_InvoiceId`,
        `Allocation2_InvoiceNumber`,
        alloc.`Allocation3_AppliedAmount`,
        NULLIF(`Allocation3_Date`, ''),
        `Allocation3_InvoiceId`,
        `Allocation3_InvoiceNumber`,
        alloc.`Allocation4_AppliedAmount`,
        NULLIF(`Allocation4_Date`, ''),
        `Allocation4_InvoiceId`,
        `Allocation4_InvoiceNumber`,
        alloc.`Allocation5_AppliedAmount`,
        NULLIF(`Allocation5_Date`, ''),
        `Allocation5_InvoiceId`,
        `Allocation5_InvoiceNumber`,
        alloc.`Allocation6_AppliedAmount`,
        NULLIF(`Allocation6_Date`, ''),
        `Allocation6_InvoiceId`,
        `Allocation6_InvoiceNumber`,
        alloc.`Allocation7_AppliedAmount`,
        NULLIF(`Allocation7_Date`, ''),
        `Allocation7_InvoiceId`,
        `Allocation7_InvoiceNumber`,
        alloc.`Allocation8_AppliedAmount`,
        NULLIF(`Allocation8_Date`, ''),
        `Allocation8_InvoiceId`,
        `Allocation8_InvoiceNumber`,
        alloc.`Allocation9_AppliedAmount`,
        NULLIF(`Allocation9_Date`, ''),
        `Allocation9_InvoiceId`,
        `Allocation9_InvoiceNumber`,
        alloc.`Allocation10_AppliedAmount`,
        NULLIF(`Allocation10_Date`, ''),
        `Allocation10_InvoiceId`,
        `Allocation10_InvoiceNumber`,
        alloc.`Allocation11_AppliedAmount`,
        NULLIF(`Allocation11_Date`, ''),
        `Allocation11_InvoiceId`,
        `Allocation11_InvoiceNumber`,
        alloc.`Allocation12_AppliedAmount`,
        NULLIF(`Allocation12_Date`, ''),
        `Allocation12_InvoiceId`,
        `Allocation12_InvoiceNumber`,
        alloc.`Allocation13_AppliedAmount`,
        NULLIF(`Allocation13_Date`, ''),
        `Allocation13_InvoiceId`,
        `Allocation13_InvoiceNumber`,
        alloc.`Allocation14_AppliedAmount`,
        NULLIF(`Allocation14_Date`, ''),
        `Allocation14_InvoiceId`,
        `Allocation14_InvoiceNumber`,
        alloc.`Allocation15_AppliedAmount`,
        NULLIF(`Allocation15_Date`, ''),
        `Allocation15_InvoiceId`,
        `Allocation15_InvoiceNumber`,
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
        `RemainingCredit_AUD`,
        `RemainingCredit_USD`,
        `RemainingCredit_NZD`,
        `RemainingCredit_EUR`,
        `RemainingCredit_GBP`,
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
        alloc.`Allocation10_AppliedAmount_GBP`,
        alloc.`Allocation11_AppliedAmount_AUD`,
        alloc.`Allocation11_AppliedAmount_USD`,
        alloc.`Allocation11_AppliedAmount_NZD`,
        alloc.`Allocation11_AppliedAmount_EUR`,
        alloc.`Allocation11_AppliedAmount_GBP`,
        alloc.`Allocation12_AppliedAmount_AUD`,
        alloc.`Allocation12_AppliedAmount_USD`,
        alloc.`Allocation12_AppliedAmount_NZD`,
        alloc.`Allocation12_AppliedAmount_EUR`,
        alloc.`Allocation12_AppliedAmount_GBP`,
        alloc.`Allocation13_AppliedAmount_AUD`,
        alloc.`Allocation13_AppliedAmount_USD`,
        alloc.`Allocation13_AppliedAmount_NZD`,
        alloc.`Allocation13_AppliedAmount_EUR`,
        alloc.`Allocation13_AppliedAmount_GBP`,
        alloc.`Allocation14_AppliedAmount_AUD`,
        alloc.`Allocation14_AppliedAmount_USD`,
        alloc.`Allocation14_AppliedAmount_NZD`,
        alloc.`Allocation14_AppliedAmount_EUR`,
        alloc.`Allocation14_AppliedAmount_GBP`,
        alloc.`Allocation15_AppliedAmount_AUD`,
        alloc.`Allocation15_AppliedAmount_USD`,
        alloc.`Allocation15_AppliedAmount_NZD`,
        alloc.`Allocation15_AppliedAmount_EUR`,
        alloc.`Allocation15_AppliedAmount_GBP`,
        `AccountUID`,
        `LineAmountCreditNoteCalculation`,
        `LineAmountTradeCreditorCalculation`,
        `LineAmountTradeDebtorCalculation`,
        `LineAmountCreditNoteCalculation_AUD`,
        `LineAmountCreditNoteCalculation_USD`,
        `LineAmountCreditNoteCalculation_NZD`,
        `LineAmountCreditNoteCalculation_EUR`,
        `LineAmountCreditNoteCalculation_GBP`,
        `LineAmountTradeCreditorCalculation_AUD`,
        `LineAmountTradeCreditorCalculation_USD`,
        `LineAmountTradeCreditorCalculation_NZD`,
        `LineAmountTradeCreditorCalculation_EUR`,
        `LineAmountTradeCreditorCalculation_GBP`,
        `LineAmountTradeDebtorCalculation_AUD`,
        `LineAmountTradeDebtorCalculation_USD`,
        `LineAmountTradeDebtorCalculation_NZD`,
        `LineAmountTradeDebtorCalculation_EUR`,
        `LineAmountTradeDebtorCalculation_GBP`
    FROM {clientID}_{orgID}_xeroblue_creditnotesstage crdt
    LEFT JOIN (
    SELECT 
	    CreditNoteID,
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
	 FROM Allocations
	 GROUP BY CreditNoteID) alloc ON crdt.CreditNoteId = alloc.CreditNoteId;
END