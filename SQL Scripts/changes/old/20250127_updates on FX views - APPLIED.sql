--Changes

DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud AS
SELECT 
    `OverpaymentId`                              AS `OverpaymentId`, 
    `Date`                                       AS `Date`,
    `Type`                                       AS `Type`,
    `RemainingCredit`                            AS `RemainingCredit`,
    `RemainingCredit_AUD`                        AS `RemainingCredit FX`,
    `Contact_ContactId`                          AS `Contact ID`,
    `Contact_Name`                               AS `Contact Name`,
    `Status`                                     AS `Status`,
    `SubTotal`                                   AS `SubTotal`,
    `SubTotal_AUD`                               AS `SubTotal FX`,
    `TotalTax`                                   AS `TotalTax`,
    `TotalTax_AUD`                               AS `TotalTax FX`,
    `Total`                                      AS `Total`,
    `Total_AUD`                                  AS `Total FX`,
    `LineItem_LineItemId`                        AS `Line Item ID`,
    `LineItem_Description`                       AS `Description`,
    `LineItem_Quantity`                          AS `Quantity`,
    `LineItem_UnitAmount`                        AS `Unit Amount`,
    `LineItem_ItemCode`                          AS `Item Code`,
    `LineItem_AccountCode`                       AS `Account Code`,
    `LineItem_TaxType`                           AS `Tax Type`,
    `LineItem_TaxAmount`                         AS `Tax Amount`,
    `LineItem_TaxAmount_AUD`                     AS `Tax Amount FX`,
    `LineItem_LineAmount`                        AS `Line Amount`,
    `LineItem_LineAmount_AUD`                    AS `Line Amount FX`,
    `LineItem_TrackingCategory1_CategoryId`      AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`    AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`        AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`      AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`     AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`      AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`    AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`        AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`      AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`     AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate`                      AS `Discount Rate`,
    `LineAmountTypes`                            AS `Line Amount Types`,
    `CurrencyCode`                               AS `Currency Code`,
    `CurrencyRate`                               AS `Currency Rate`,
    `UpdatedDateUTC`                             AS `Updated Date UTC`,
    `Allocation1_AppliedAmount`                  AS `Allocation 1 Applied Amount`,
    `Allocation1_AppliedAmount_AUD`              AS `Allocation 1 Applied Amount FX`,
    `Allocation1_Date`                           AS `Allocation 1 Date`,
    `Allocation1_InvoiceId`                      AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber`                  AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount`                  AS `Allocation 2 Applied Amount`,
    `Allocation2_AppliedAmount_AUD`              AS `Allocation 2 Applied Amount FX`,
    `Allocation2_Date`                           AS `Allocation 2 Date`,
    `Allocation2_InvoiceId`                      AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber`                  AS `Allocation 2 Invoice Number`,
    `Allocation3_AppliedAmount`                  AS `Allocation 3 Applied Amount`,
    `Allocation3_AppliedAmount_AUD`              AS `Allocation 3 Applied Amount FX`,
    `Allocation3_Date`                           AS `Allocation 3 Date`,
    `Allocation3_InvoiceId`                      AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber`                  AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount`                  AS `Allocation 4 Applied Amount`,
    `Allocation4_AppliedAmount_AUD`              AS `Allocation 4 Applied Amount FX`,
    `Allocation4_Date`                           AS `Allocation 4 Date`,
    `Allocation4_InvoiceId`                      AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber`                  AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount`                  AS `Allocation 5 Applied Amount`,
    `Allocation5_AppliedAmount_AUD`              AS `Allocation 5 Applied Amount FX`,
    `Allocation5_Date`                           AS `Allocation 5 Date`,
    `Allocation5_InvoiceId`                      AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber`                  AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount`                  AS `Allocation 6 Applied Amount`,
    `Allocation6_AppliedAmount_AUD`              AS `Allocation 6 Applied Amount FX`,
    `Allocation6_Date`                           AS `Allocation 6 Date`,
    `Allocation6_InvoiceId`                      AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber`                  AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount`                  AS `Allocation 7 Applied Amount`,
    `Allocation7_AppliedAmount_AUD`              AS `Allocation 7 Applied Amount FX`,
    `Allocation7_Date`                           AS `Allocation 7 Date`,
    `Allocation7_InvoiceId`                      AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber`                  AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount`                  AS `Allocation 8 Applied Amount`,
    `Allocation8_AppliedAmount_AUD`              AS `Allocation 8 Applied Amount FX`,
    `Allocation8_Date`                           AS `Allocation 8 Date`,
    `Allocation8_InvoiceId`                      AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber`                  AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount`                  AS `Allocation 9 Applied Amount`,
    `Allocation9_AppliedAmount_AUD`              AS `Allocation 9 Applied Amount FX`,
    `Allocation9_Date`                           AS `Allocation 9 Date`,
    `Allocation9_InvoiceId`                      AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber`                  AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount`                 AS `Allocation 10 Applied Amount`,
    `Allocation10_AppliedAmount_AUD`             AS `Allocation 10 Applied Amount FX`,
    `Allocation10_Date`                          AS `Allocation 10 Date`,
    `Allocation10_InvoiceId`                     AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber`                 AS `Allocation 10 Invoice Number`,
    `HasAttachments`                             AS `Has Attachments`,
    `Payments`                                   AS `Payments`,
    `ClientID`                                   AS `Client ID`,
    `OrganisationID`                             AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_overpayments
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud AS
SELECT 
    i.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.accountid                                 AS `PaymentAccountID`,
    p.status                                    AS `PaymentStatus`,
    CONCAT(IFNULL(i.`lineitem_accountcode`, 'BLANK'), '-', CAST(i.`organisationid` AS CHAR)) AS `Account_UID`,
    IFNULL(i.`lineitem_discountrate`, 0)        AS `Discount Rate`,
    IFNULL(i.`lineitem_discountrate` * 0.01, 0) AS `Discount Rate %`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount`,
    CAST(
        CASE 
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` - i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` - i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount FX`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax`, 	
    CAST(
        CASE 
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax FX`	
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal_aud i
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON i.invoiceid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') 
AND i.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud AS
SELECT 
    pp.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(IFNULL(pp.`account code`, 'BLANK'), '-', CAST(pp.`organisation id` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount`,
    CAST(
        CASE 
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN 0 - (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN 0 - (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount FX`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud pp
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON pp.prepaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') 
AND pp.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud AS
SELECT 
    op.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(op.`account code`, '-', CAST(op.`organisation id` AS CHAR)) AS `Account_UID`,
    CAST(
        CASE 
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount`,
    CAST(
        CASE 
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN 0 - (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN 0 - (op.`total fx` * (p.`amount fx` / op.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount FX`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud op
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON op.overpaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APOVERPAYMENTPAYMENT', 'AROVERPAYMENTPAYMENT') 
AND op.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud AS
SELECT 
    c.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(c.`lineitem_accountcode`, '-', CAST(c.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - (c.`lineitem_lineamount fx` * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx` - c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN (c.`lineitem_lineamount fx` * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx` - c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount FX`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx` + c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx` + c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx`) * (p.`amount fx` / c.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax FX`
FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud c
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON c.creditnoteid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APCREDITPAYMENT', 'ARCREDITPAYMENT') 
AND c.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud AS
SELECT 
    a.*,
    CONCAT(IFNULL(a.`lineitem_accountcode`, 'BLANK'), '-', CAST(a.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx` - a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx` - a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount FX`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx` + a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx` + a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax FX` 
FROM (
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount,
        `allocation1_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount,
        `allocation2_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount,
        `allocation3_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount,
        `allocation4_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount,
        `allocation5_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation6_invoiceid AS invoiceid,
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount,
        `allocation6_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount,
        `allocation7_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount,
        `allocation8_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount,
        `allocation9_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount,
        `allocation10_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount,
        `allocation11_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount,
        `allocation12_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount,
        `allocation13_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount,
        `allocation14_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount,
        `allocation15_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation15_appliedamount IS NOT NULL
) AS a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_cashaggregated_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_cashaggregated_aud AS
SELECT 
    a.`InvoiceId` AS `Cash Source ID`,
    a.`Type` AS `Type`,
    a.`ContactId` AS `Contact ID`,
    a.`Date` AS `Date`,
    a.`PaymentDate` AS `Payment Date`,
    a.`OrganisationID` AS `Organisation ID`,
    a.`PaymentAccountID` AS `Payment Account ID`,
    a.`Payments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    a.`Payments Calculated Amount Inc Tax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Invoice' AS `Cash Type`,
    a.`Account_UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud a
UNION ALL
SELECT 
    b.`CreditNoteId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact_ContactId` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`OrganisationID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Credit Note Allocation Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Credit Note Allocation Calculated Amount Inc Tax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Credit Note' AS `Cash Type`,
    b.`Account UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud b
UNION ALL
SELECT 
    b.`OverpaymentId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact ID` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`Organisation ID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Overpayments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Overpayments Calculated Amount FX` + b.`TotalTax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Overpayment' AS `Cash Type`,
    b.`Account_UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud b
UNION ALL
SELECT 
    b.`PrepaymentId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact ID` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`Organisation ID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Prepayments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Prepayments Calculated Amount FX` + b.`TotalTax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Prepayment' AS `Cash Type`,
    b.`Account UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud b;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_allocationaggregated_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_allocationaggregated_aud AS
SELECT 
    b.`InvoiceId`          AS `Invoice ID`
    ,b.`CreditNoteId`      AS `Allocation Source ID`
    ,b.`Type`              AS `Type`
    ,b.`Contact_ContactId` AS `Contact ID`
    ,b.`ClientID`          AS `Client ID`
    ,b.`OrganisationID`    AS `Organisation ID`
    ,b.`Dt`               AS `Allocation Date`
    ,b.`Date`              AS `Allocation Invoiced Date`
    ,b.`SubTotal FX`    AS `SubTotal FX`
    ,b.`TotalTax FX`    AS `TotalTax FX`
    ,b.`Total FX`       AS `Total FX`
    ,b.`LineItem_TaxAmount` AS `Tax Amount FX`
    ,b.`LineItem_LineAmount` AS `Line Amount FX`
    ,b.`Amount FX`      AS `Amount FX`
    ,b.`Credit Note Allocation Calculated Amount FX` AS `Allocation Calculated Amount FX`
    ,b.`Credit Note Allocation Calculated Amount Inc Tax FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,b.`Account UID`    AS `Account UID`
    ,'Credit Note Allocations' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud b
UNION ALL
SELECT 
    c.`InvoiceId`          AS `Invoice ID`
    ,c.`PrepaymentId`      AS `Allocation Source ID`
    ,c.`Type`              AS `Type`
    ,c.`Contact ID`      AS `Contact ID`
    ,c.`Client ID`       AS `Client ID`
    ,c.`Organisation ID` AS `Organisation ID`
    ,c.`Dt`               AS `Allocation Date`
    ,c.`DATE`              AS `Allocation Invoiced Date`
    ,c.`SubTotal FX`    AS `SubTotal FX`
    ,c.`TotalTax FX`    AS `TotalTax FX`
    ,c.`Total FX`       AS `Total FX`
    ,c.`TaxAmount FX`   AS `Tax Amount FX`
    ,c.`LineAmount FX`  AS `Line Amount FX`
    ,c.`Amount FX`      AS `Amount FX`
    ,c.`LineAmount FX`  AS `Allocation Calculated Amount Inc`
    ,c.`LineAmount FX` + c.`TaxAmount FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,c.`Account UID`    AS `Account UID`
    ,'PrePayment Allocation' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentallocation_aud c
UNION ALL
SELECT 
    c.`InvoiceId`          AS `Invoice ID`
    ,c.`OverpaymentId`     AS `Allocation Source ID`
    ,c.`Type`              AS `Type`
    ,c.`Contact ID`      AS `Contact ID`
    ,c.`Client ID`       AS `Client ID`
    ,c.`Organisation ID` AS `Organisation ID`
    ,c.`Dt`               AS `Allocation Date`
    ,c.`DATE`              AS `Allocation Invoiced Date`
    ,c.`SubTotal FX`    AS `SubTotal FX`
    ,c.`TotalTax FX`    AS `TotalTax FX`
    ,c.`Total FX`       AS `Total FX`
    ,c.`Tax Amount FX`  AS `Tax Amount FX`
    ,c.`Line Amount FX` AS `Line Amount FX`
    ,c.`Amount FX`      AS `Amount FX`
    ,c.`Line Amount FX` AS `Allocation Calculated Amount Inc`
    ,c.`Line Amount FX` + c.`Tax Amount FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,c.`Account UID`    AS `Account UID`
    ,'OverPayment Allocation' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentallocation_aud c;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactions_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactions_aud AS
SELECT 
    `lineid` AS `Line ID`,
    `id` AS `ID`,
    `date` AS `Date`,
    `type` AS `Type`,
    `contactid` AS `Contact ID`,
    `contactname` AS `Contact Name`,
    `lineitemid` AS `Line Item ID`,
    `description` AS `Description`,
    `quantity` AS `Quantity`,
    `unitamount` AS `Unit Amount`,
    `unitamount_aud` AS `Unit Amount FX`,
    `itemcode` AS `Item Code`,
    `accountcode` AS `Account Code`,
    `taxtype` AS `Tax Type`,
    `taxamount` AS `Tax Amount`,
    `taxamount_aud` AS `Tax Amount FX`,
    `lineamount` AS `Line Amount`,
    `lineamount_aud` AS `Line Amount FX`,
    `lineamounttypes` AS `Line Amount Types`,
    `status` AS `Status`,
    `subtotal` AS `Sub Total`,
    `subtotal_aud` AS `Sub Total FX`,
    `totaltax` AS `Total Tax`,
    `totaltax_aud` AS `Total Tax FX`,
    `total` AS `Total`,
    `total_aud` AS `Total FX`,
    `trackingcategory1categoryid` AS `Tracking Category 1 Category ID`,
    `trackingcategory1categoryname` AS `Tracking Category 1 Category Name`,
    `trackingcategory1optionid` AS `Tracking Category 1 Option ID`,
    `trackingcategory1optionname` AS `Tracking Category 1 Option Name`,
    `trackingcategory1optionstat` AS `Tracking Category 1 Option Stat`,
    `trackingcategory2categoryid` AS `Tracking Category 2 Category ID`,
    `trackingcategory2categoryname` AS `Tracking Category 2 Category Name`,
    `trackingcategory2optionid` AS `Tracking Category 2 Option ID`,
    `trackingcategory2optionname` AS `Tracking Category 2 Option Name`,
    `trackingcategory2optionstat` AS `Tracking Category 2 Option Stat`,
    `discountrate` AS `Discount Rate`,
    `currencycode` AS `Currency Code`,
    `currencyrate` AS `Currency Rate`,
    `updateddateutc` AS `Updated Date UTC`,
    `accountuid` AS `Account UID`,
    `hasattachments` AS `Has Attachments`,
    `creditnotenumber` AS `Credit Note Number`,
    `remainingcredit` AS `Remaining Credit`,
    `remainingcredit_aud` AS `Remaining Credit FX`,
    `fullypaidondate` AS `Fully Paid On Date`,
    `reference` AS `Reference`,
    `source` AS `Source`,
    `clientid` AS `Client ID`,
    `organisationid` AS `Organisation ID`,
    `showoncashbasisreports` AS `ShowOnCashBasisReports`,
    `duedate` AS `DueDate`,
    `invoicenumber` AS `InvoiceNumber`,
    `paymentsourceid` AS `PaymentSourceID`,
    `paymenttype` AS `PaymentType`,
    `allocationdate` AS `AllocationDate`,
    `allocationamount` AS `AllocationAmount`,
    `changes` AS `Changes`,
    `user` AS `User`,
    `details` AS `Details`,
    `daydifference` AS `DayDifference`
FROM evadb_stage.c1518_xeroblue_transactions;