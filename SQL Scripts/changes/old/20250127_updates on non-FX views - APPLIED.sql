DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactions;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactions AS
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
    `itemcode` AS `Item Code`,
    `accountcode` AS `Account Code`,
    `taxtype` AS `Tax Type`,
    `taxamount` AS `Tax Amount`,
    `lineamount` AS `Line Amount`,
    `lineamounttypes` AS `Line Amount Types`,
    `status` AS `Status`,
    `subtotal` AS `Sub Total`,
    `totaltax` AS `Total Tax`,
    `total` AS `Total`,
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


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicepaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicepaymentcash AS
SELECT 
    i.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
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
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax`	
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal i
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON i.invoiceid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') 
AND i.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invcrdtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invcrdtallo AS
SELECT
    i.*,
    a.invoiceid AS CreditNoteInvoiceId,
    a.CreditNoteId,
    a.allocation AS CreditNoteAllocation,
    a.dt AS CreditNoteDate,
    a.amount AS CreditNoteAmount
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        organisationid, 
        creditnoteid,
        allocation1_invoiceid AS invoiceid, 
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation6_invoiceid AS invoiceid, 
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation10_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes
    WHERE allocation15_appliedamount IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.organisationid
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash AS
SELECT 
    c.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
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
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`
FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal c
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON c.creditnoteid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APCREDITPAYMENT', 'ARCREDITPAYMENT') 
AND c.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnoteallocations;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnoteallocations AS
SELECT 
    Id,
    CreditNoteId ,
    CreditNoteNumber ,
    Reference ,
    Type ,
    Contact_ContactId ,
    Contact_Name ,
    Date ,
    Status,
    LineAmountTypes ,
    LineItem_Description ,
    LineItem_Quantity ,
    LineItem_UnitAmount,
    LineItem_ItemCode ,
    LineItem_AccountCode ,
    LineItem_TaxType ,
    LineItem_TaxAmount ,
    LineItem_LineAmount ,
    LineItem_TrackingCategory1_CategoryId ,
    LineItem_TrackingCategory1_CategoryName,
    LineItem_TrackingCategory1_OptionId ,
    LineItem_TrackingCategory1_OptionName,
    LineItem_TrackingCategory1_Option_Stat,
    LineItem_TrackingCategory2_CategoryId ,
    LineItem_TrackingCategory2_CategoryName,
    LineItem_TrackingCategory2_OptionId ,
    LineItem_TrackingCategory2_OptionName,
    LineItem_TrackingCategory2_Option_Stat,
    LineItem_DiscountRate ,
    SubTotal ,
    TotalTax ,
    Total ,
    UpdatedDateUTC ,
    CurrencyCode ,
    FullyPaidOnDate ,
    SentToContact ,
    BrandingThemeId,
    CurrencyRate ,
    RemainingCredit,  HasAttachments,ClientID,OrganisationID,
    InvoiceId,
    Allocation,
    Dt,
    Amount,
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
        allocation1_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation2_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation3_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation4_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation5_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation6_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation7_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation8_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation9_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation10_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation11_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation12_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation13_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation14_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
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
        allocation15_appliedamount AS amount
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal
    WHERE allocation15_appliedamount IS NOT NULL
) AS a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal AS
SELECT * FROM evadb_stage.c1518_xeroblue_overpayments WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invovrpymtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invovrpymtallo AS
SELECT
    i.*,
    a.invoiceid                 AS `OverPaymentInvoiceId`,
    a.OverPaymentId,
    a.allocation                AS `OverPaymentAllocation`,
    a.dt                        AS `OverPaymentDate`,
    a.amount                    AS `OverPaymentAmount`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation1_InvoiceId` AS `invoiceid`, 
        1 AS `allocation`,
        `Allocation1_Date` AS `dt`,
        `Allocation1_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation1_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation2_InvoiceId` AS `invoiceid`, 
        2 AS `allocation`,
        `Allocation2_Date` AS `dt`,
        `Allocation2_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation2_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation3_InvoiceId` AS `invoiceid`, 
        3 AS `allocation`,
        `Allocation3_Date` AS `dt`,
        `Allocation3_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation3_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation4_InvoiceId` AS `invoiceid`, 
        4 AS `allocation`,
        `Allocation4_Date` AS `dt`,
        `Allocation4_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation4_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation5_InvoiceId` AS `invoiceid`, 
        5 AS `allocation`,
        `Allocation5_Date` AS `dt`,
        `Allocation5_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation5_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation6_InvoiceId` AS `invoiceid`, 
        6 AS `allocation`,
        `Allocation6_Date` AS `dt`,
        `Allocation6_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation6_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation7_InvoiceId` AS `invoiceid`, 
        7 AS `allocation`,
        `Allocation7_Date` AS `dt`,
        `Allocation7_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation7_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation8_InvoiceId` AS `invoiceid`, 
        8 AS `allocation`,
        `Allocation8_Date` AS `dt`,
        `Allocation8_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation8_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation9_InvoiceId` AS `invoiceid`, 
        9 AS `allocation`,
        `Allocation9_Date` AS `dt`,
        `Allocation9_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation9_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `OrganisationID`,
        `OverpaymentId`,
        `Allocation10_InvoiceId` AS `invoiceid`, 
        10 AS `allocation`,
        `Allocation10_Date` AS `dt`,
        `Allocation10_AppliedAmount` AS `amount`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal 
    WHERE `Allocation10_AppliedAmount` IS NOT NULL
) a ON i.`invoiceid` = a.`invoiceid` AND i.`organisationid` = a.`OrganisationID`
WHERE i.`status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash AS
SELECT 
    op.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(op.`LineItem_AccountCode`, '-', CAST(op.`organisationid` AS CHAR)) AS `Account_UID`,
    CAST(
        CASE 
            WHEN op.`LineAmountTypes` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`LineAmountTypes` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal op
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON op.overpaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APOVERPAYMENTPAYMENT', 'AROVERPAYMENTPAYMENT') 
AND op.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentallocation;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentallocation AS
SELECT 
    a.*,
    CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`
FROM (
    SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation1_InvoiceId AS InvoiceId, 
		1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation2_InvoiceId AS InvoiceId,
		2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation3_InvoiceId AS InvoiceId,
		3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation4_InvoiceId AS InvoiceId,
		4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation5_InvoiceId AS InvoiceId,
		5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation6_InvoiceId AS InvoiceId,
		6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation7_InvoiceId AS InvoiceId,
		7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation8_InvoiceId AS InvoiceId,
		8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation9_InvoiceId AS InvoiceId,
		9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT 
		`OverpaymentId`,
		`Date`,
		`Type`,
		`RemainingCredit`,
		`Contact_ContactId`,
		`Contact_Name`,
		`Status`,
		`SubTotal`,
		`TotalTax`,
		`Total`,
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
		`LineAmountTypes`,
		`CurrencyCode`,
		`CurrencyRate`,
		`UpdatedDateUTC`,
		`HasAttachments`,
		`Payments`,
		`ClientID`,
		`OrganisationID`,
		Allocation10_InvoiceId AS InvoiceId,
		10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal
	WHERE Allocation10_AppliedAmount IS not NULL
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal AS
SELECT * FROM evadb_stage.c1518_xeroblue_prepayments WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invprepymtallo;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invprepymtallo AS
SELECT 
    i.*,
    a.invoiceid                         AS `PrePaymentInvoiceId`,
    a.prepaymentid                      AS `PrePaymentId`,
    a.allocation                        AS `PrePaymentAllocation`,
    a.dt                                AS `PrePaymentDate`,
    a.amount                            AS `PrePaymentAmount`,
    CONCAT(CAST(i.organisationid AS CHAR), i.lineitem_accountcode)  AS `Account UID`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation1_InvoiceId` AS invoiceid, 
        1 AS allocation,
        `Allocation1_Date` AS dt,
        `Allocation1_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation1_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation2_InvoiceId` AS invoiceid, 
        2 AS allocation,
        `Allocation2_Date` AS dt,
        `Allocation2_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation2_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation3_InvoiceId` AS invoiceid, 
        3 AS allocation,
        `Allocation3_Date` AS dt,
        `Allocation3_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation3_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation4_InvoiceId` AS invoiceid, 
        4 AS allocation,
        `Allocation4_Date` AS dt,
        `Allocation4_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation4_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation5_InvoiceId` AS invoiceid, 
        5 AS allocation,
        `Allocation5_Date` AS dt,
        `Allocation5_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation5_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation6_InvoiceId` AS invoiceid, 
        6 AS allocation,
        `Allocation6_Date` AS dt,
        `Allocation6_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation6_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation7_InvoiceId` AS invoiceid, 
        7 AS allocation,
        `Allocation7_Date` AS dt,
        `Allocation7_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation7_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation8_InvoiceId` AS invoiceid, 
        8 AS allocation,
        `Allocation8_Date` AS dt,
        `Allocation8_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation8_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation9_InvoiceId` AS invoiceid, 
        9 AS allocation,
        `Allocation9_Date` AS dt,
        `Allocation9_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation9_AppliedAmount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisationid`,
        prepaymentid,
        `Allocation10_InvoiceId` AS invoiceid, 
        10 AS allocation,
        `Allocation10_Date` AS dt,
        `Allocation10_AppliedAmount` AS amount
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal 
    WHERE `Allocation10_AppliedAmount` IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.`organisationid`
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash AS
SELECT 
    pp.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `paymentamount`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(IFNULL(pp.`LineItem_AccountCode`, 'BLANK'), '-', CAST(pp.`OrganisationID` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN pp.`LineAmountTypes` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`LineAmountTypes` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal pp
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal p ON pp.prepaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') 
AND pp.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentallocation;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentallocation AS
SELECT 
    *,
    CONCAT(IFNULL(`LineItem_AccountCode`, 'BLANK'), '-', CAST(`OrganisationID` AS CHAR)) AS `Account UID`
FROM (
    SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation1_InvoiceId AS InvoiceId, 1 Allocation,
		Allocation1_Date AS Dt,
		Allocation1_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation1_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation2_InvoiceId AS InvoiceId,2 Allocation,
		Allocation2_Date AS Dt,
		Allocation2_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation2_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation3_InvoiceId AS InvoiceId,3 Allocation,
		Allocation3_Date AS Dt,
		Allocation3_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation3_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation4_InvoiceId AS InvoiceId,4 Allocation,
		Allocation4_Date AS Dt,
		Allocation4_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation4_AppliedAmount IS not null
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation5_InvoiceId AS InvoiceId,5 Allocation,
		Allocation5_Date AS Dt,
		Allocation5_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation5_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation6_InvoiceId AS InvoiceId,6 Allocation,
		Allocation6_Date AS Dt,
		Allocation6_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation6_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation7_InvoiceId AS InvoiceId,7 Allocation,
		Allocation7_Date AS Dt,
		Allocation7_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation7_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation8_InvoiceId AS InvoiceId,8 Allocation,
		Allocation8_Date AS Dt,
		Allocation8_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation8_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation9_InvoiceId AS InvoiceId,9 Allocation,
		Allocation9_Date AS Dt,
		Allocation9_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation9_AppliedAmount IS not NULL
	UNION
	SELECT `PrepaymentId`,
		`Date` DATE ,
		`Reference` ,
		`Type` ,
		`RemainingCredit` ,
		`Contact_ContactId`,
		`Contact_Name` ,
		`Status` ,
		`SubTotal`,
		`TotalTax` ,
		`Total` ,
		`LineItem_LineItemId` ,
		`LineItem_Description` ,
		`LineItem_Quantity` ,
		`LineItem_UnitAmount`,
		`LineItem_ItemCode` ,
		`LineItem_AccountCode` ,
		`LineItem_TaxType` ,
		`LineItem_TaxAmount`,
		`LineItem_LineAmount`,
		`LineItem_TrackingCategory1_CategoryId` ,
		`LineItem_TrackingCategory1_CategoryName`,
		`LineItem_TrackingCategory1_OptionId` ,
		`LineItem_TrackingCategory1_OptionName`,
		`LineItem_TrackingCategory1_Option_Stat`,
		`LineItem_TrackingCategory2_CategoryId` ,
		`LineItem_TrackingCategory2_CategoryName`,
		`LineItem_TrackingCategory2_OptionId` ,
		`LineItem_TrackingCategory2_OptionName`,
		`LineItem_TrackingCategory2_Option_Stat`,
		`LineItem_DiscountRate` ,
		`LineAmountTypes` ,
		`CurrencyCode` ,
		`CurrencyRate` ,
		`UpdatedDateUTC` ,
		`HasAttachments`,
		`Payments`,
		`ClientID` ,
		`OrganisationID`,
		Allocation10_InvoiceId AS InvoiceId,10 Allocation,
		Allocation10_Date AS Dt,
		Allocation10_AppliedAmount AS Amount
	FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal
	WHERE Allocation10_AppliedAmount IS not null
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceallocations;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceallocations AS
SELECT
    i.*,
    ca.CreditNoteInvoiceId, 
    ca.CreditNoteAllocation, 
    ca.CreditNoteAmount, 
    ca.CreditNoteDate,
    IFNULL(ca.`lineitem_discountrate`, 0) AS `Discount Rate`, 
    IFNULL(ca.`lineitem_discountrate` * 0.01, 0) AS `Discount Rate %`,
    ppa.PrepaymentId, 
    ppa.PrePaymentAllocation,
    ppa.PrePaymentDate, 
    ppa.PrePaymentAmount,
    opa.OverpaymentId, 
    opa.OverPaymentAllocation,
    opa.OverPaymentDate, 
    opa.OverPaymentAmount,
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `OP Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `PP Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `CN Allocation Amount`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `OP Allocation Amount Inc Tax`,  
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `PP Allocation Amount Inc Tax`,   
    CAST(
        CASE 
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
            ELSE 0 END AS decimal(15,4)
        ) AS `CN Allocation Amount Inc Tax`
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal i
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invcrdtallo AS ca
    ON i.invoiceid = ca.invoiceid AND i.lineitem_lineitemid = ca.lineitem_lineitemid
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invprepymtallo ppa
    ON i.invoiceid = ppa.invoiceid AND i.lineitem_lineitemid = ppa.lineitem_lineitemid
LEFT JOIN bigoleshoecompany_client1518_xeroblue_invovrpymtallo opa
    ON i.invoiceid = opa.invoiceid AND i.lineitem_lineitemid = opa.lineitem_lineitemid
WHERE ca.invoiceid IS NOT NULL OR ppa.invoiceid IS NOT NULL OR opa.invoiceid IS NOT NULL AND i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS `FOREIGNEXCHANGE_MASTER`;
CREATE VIEW `FOREIGNEXCHANGE_MASTER` AS
SELECT * FROM evadb_stage.FOREIGNEXCHANGE_MASTER;