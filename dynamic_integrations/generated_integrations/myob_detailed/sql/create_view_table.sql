-- DQ_MYOBAR Views - Auto Generated
-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InventoryItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventoryitem;
CREATE VIEW {etani_client_id}_dq_myobar_inventoryitem AS
SELECT
    uid,
    number,
    name,
    isactive,
    description,
    usedescription,
    customlist1,
    customlist2,
    customlist3,
    customfield1,
    customfield2,
    customfield3,
    quantityonhand,
    quantitycommitted,
    quantityonorder,
    quantityavailable,
    averagecost,
    currentvalue,
    basesellingprice,
    isbought,
    issold,
    isinventoried,
    expenseaccount,
    locationdetails,
    lastmodified,
    photouri,
    uri,
    rowversion,
    clientid,
    organisationid,
    costofsalesaccountuid AS `costofsalesaccount.uid`,
    costofsalesaccountname AS `costofsalesaccount.name`,
    costofsalesaccountdisplayid AS `costofsalesaccount.displayid`,
    costofsalesaccounturi AS `costofsalesaccount.uri`,
    incomeaccountuid AS `incomeaccount.uid`,
    incomeaccountname AS `incomeaccount.name`,
    incomeaccountdisplayid AS `incomeaccount.displayid`,
    incomeaccounturi AS `incomeaccount.uri`,
    assetaccountuid AS `assetaccount.uid`,
    assetaccountname AS `assetaccount.name`,
    assetaccountdisplayid AS `assetaccount.displayid`,
    assetaccounturi AS `assetaccount.uri`,
    buyingdetailslastpurchaseprice AS `buyingdetails.lastpurchaseprice`,
    buyingdetailsstandardcost AS `buyingdetails.standardcost`,
    buyingdetailsbuyingunitofmeasure AS `buyingdetails.buyingunitofmeasure`,
    buyingdetailsitemsperbuyingunit AS `buyingdetails.itemsperbuyingunit`,
    buyingdetailstaxcode AS `buyingdetails.taxcode`,
    buyingdetailstaxcodeuid AS `buyingdetails_taxcode.uid`,
    buyingdetailstaxcodecode AS `buyingdetails_taxcode.code`,
    buyingdetailstaxcodeuri AS `buyingdetails_taxcode.uri`,
    buyingdetailsrestockinginformation AS `buyingdetails.restockinginformation`,
    buyingdetailsrestockinginformationminimumlevelforrestockingalert,
    buyingdetailsrestockinginformationsupplier AS `buyingdetails_restockinginformation.supplier`,
    buyingdetailsrestockinginformationsupplieruid AS `buyingdetails_restockinginformation_supplier.uid`,
    buyingdetailsrestockinginformationsuppliername AS `buyingdetails_restockinginformation_supplier.name`,
    buyingdetailsrestockinginformationsupplierdisplayid AS `buyingdetails_restockinginformation_supplier.displayid`,
    buyingdetailsrestockinginformationsupplieruri AS `buyingdetails_restockinginformation_supplier.uri`,
    buyingdetailsrestockinginformationsupplieritemnumber AS `buyingdetails_restockinginformation.supplieritemnumber`,
    buyingdetailsrestockinginformationdefaultorderquantity AS `buyingdetails_restockinginformation.defaultorderquantity`,
    buyingdetailsstandardcosttaxinclusive AS `buyingdetails.standardcosttaxinclusive`,
    sellingdetailsbasesellingprice AS `sellingdetails.basesellingprice`,
    sellingdetailssellingunitofmeasure AS `sellingdetails.sellingunitofmeasure`,
    sellingdetailsitemsperbuyingunit AS `sellingdetails.itemsperbuyingunit`,
    sellingdetailstaxcode AS `sellingdetails.taxcode`,
    sellingdetailstaxcodeuid AS `sellingdetails_taxcode.uid`,
    sellingdetailstaxcodecode AS `sellingdetails_taxcode.code`,
    sellingdetailstaxcodeuri AS `sellingdetails_taxcode.uri`,
    sellingdetailsistaxinclusive AS `sellingdetails.istaxinclusive`,
    sellingdetailscalculatesalestaxon AS `sellingdetails.calculatesalestaxon`,
    sellingdetailspricematrixuri AS `sellingdetails.pricematrixuri`,
    defaultselllocationuid AS `defaultselllocation.uid`,
    defaultselllocationidentifier AS `defaultselllocation.identifier`,
    defaultselllocationname AS `defaultselllocation.name`,
    defaultselllocationuri AS `defaultselllocation.uri`,
    defaultreceivelocationuid AS `defaultreceivelocation.uid`,
    defaultreceivelocationidentifier AS `defaultreceivelocation.identifier`,
    defaultreceivelocationname AS `defaultreceivelocation.name`,
    defaultreceivelocationuri AS `defaultreceivelocation.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventoryitem;

-- ItemPriceMatrix View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_itempricematrix;
CREATE VIEW {etani_client_id}_dq_myobar_itempricematrix AS
SELECT
    uid,
    sellingprices,
    uri,
    rowversion,
    clientid,
    organisationid,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_itempricematrix;

-- PriceLevelDetail View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_priceleveldetail;
CREATE VIEW {etani_client_id}_dq_myobar_priceleveldetail AS
SELECT
    name,
    value,
    rowversion,
    nextpagelink,
    count,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_priceleveldetail;

-- InventoryAdjustment View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventoryadjustment;
CREATE VIEW {etani_client_id}_dq_myobar_inventoryadjustment AS
SELECT
    uid,
    inventoryjournalnumber,
    date,
    isyearendadjustment,
    memo,
    clientid,
    organisationid,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventoryadjustment;

-- InventoryLocation View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventorylocation;
CREATE VIEW {etani_client_id}_dq_myobar_inventorylocation AS
SELECT
    uid,
    identifier,
    name,
    isactive,
    cansell,
    notes,
    uri,
    rowversion,
    clientid,
    organisationid,
    addressstreet AS `address.street`,
    addresscity AS `address.city`,
    addressstate AS `address.state`,
    addresspostcode AS `address.postcode`,
    addresscountry AS `address.country`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventorylocation;

-- InventoryBuild View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventorybuild;
CREATE VIEW {etani_client_id}_dq_myobar_inventorybuild AS
SELECT
    uid,
    inventoryjournalnumber,
    date,
    memo,
    uri,
    rowversion,
    clientid,
    organisationid,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventorybuild;

-- SaleInvoiceItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoiceitem;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoiceitem AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    promiseddate,
    balancedueamount,
    balancedueamountforeign,
    status,
    `lines`,
    shiptoaddress,
    istaxinclusive,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    salesperson,
    comment,
    shippingmethod,
    journalmemo,
    referralsource,
    invoicedeliverystatus,
    lastpaymentdate,
    canapplysurcharge,
    `order`,
    onlinepaymentmethod,
    foreigncurrency,
    currencyexchangerate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    termsfinancechargeforeign AS `terms.financechargeforeign`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoiceitem;

-- SaleInvoiceService View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoiceservice;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoiceservice AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    promiseddate,
    balancedueamount,
    balancedueamountforeign,
    status,
    `lines`,
    shiptoaddress,
    istaxinclusive,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    comment,
    shippingmethod,
    journalmemo,
    referralsource,
    invoicedeliverystatus,
    lastpaymentdate,
    canapplysurcharge,
    onlinepaymentmethod,
    foreigncurrency,
    currencyexchangerate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    termsfinancechargeforeign AS `terms.financechargeforeign`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    orderuid AS `order.uid`,
    ordernumber AS `order.number`,
    orderuri AS `order.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoiceservice;

-- SaleInvoiceProfessional View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoiceprofessional;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoiceprofessional AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    promiseddate,
    balancedueamount,
    status,
    `lines`,
    istaxinclusive,
    subtotal,
    totaltax,
    totalamount,
    comment,
    journalmemo,
    referralsource,
    invoicedeliverystatus,
    lastpaymentdate,
    canapplysurcharge,
    `order`,
    onlinepaymentmethod,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoiceprofessional;

-- SaleInvoiceTimeBilling View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoicetimebilling;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoicetimebilling AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    promiseddate,
    balancedueamount,
    status,
    shiptoaddress,
    istaxinclusive,
    subtotal,
    freight,
    totaltax,
    totalamount,
    comment,
    shippingmethod,
    journalmemo,
    referralsource,
    invoicedeliverystatus,
    lastpaymentdate,
    canapplysurcharge,
    `order`,
    onlinepaymentmethod,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoicetimebilling;


-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInvoiceMiscellaneous View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoicemiscellaneous;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoicemiscellaneous AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    balancedueamount,
    status,
    `lines`,
    istaxinclusive,
    subtotal,
    totaltax,
    totalamount,
    journalmemo,
    referralsource,
    lastpaymentdate,
    canapplysurcharge,
    `order`,
    onlinepaymentmethod,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoicemiscellaneous;

-- SaleOrderItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorderitem;
CREATE VIEW {etani_client_id}_dq_myobar_saleorderitem AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    salesperson,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    appliedtodate,
    appliedtodateforeign,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    foreigncurrency,
    currencyexchangerate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    termsfinancechargeforeign AS `terms.financechargeforeign`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorderitem;

-- SaleOrderService View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorderservice;
CREATE VIEW {etani_client_id}_dq_myobar_saleorderservice AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    appliedtodate,
    appliedtodateforeign,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    foreigncurrency,
    currencyexchangerate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    termsfinancechargeforeign AS `terms.financechargeforeign`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorderservice;

-- SaleOrderProfessional View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorderprofessional;
CREATE VIEW {etani_client_id}_dq_myobar_saleorderprofessional AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    comment,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorderprofessional;

-- SaleOrderTimeBilling View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleordertimebilling;
CREATE VIEW {etani_client_id}_dq_myobar_saleordertimebilling AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    freight,
    totaltax,
    totalamount,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleordertimebilling;

-- SaleOrderMiscellaneous View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleordermiscellaneous;
CREATE VIEW {etani_client_id}_dq_myobar_saleordermiscellaneous AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    journalmemo,
    referralsource,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleordermiscellaneous;

-- SaleQuoteMiscellaneous View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequotemiscellaneous;
CREATE VIEW {etani_client_id}_dq_myobar_salequotemiscellaneous AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    comment,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    balancedueamount,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequotemiscellaneous;

-- SaleQuoteTimeBilling View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequotetimebilling;
CREATE VIEW {etani_client_id}_dq_myobar_salequotetimebilling AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    freight,
    totaltax,
    totalamount,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    balancedueamount,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequotetimebilling;

-- SaleQuoteProfessional View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteprofessional;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteprofessional AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    comment,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    balancedueamount,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    salespersonuid AS `salesperson.uid`,
    salespersonname AS `salesperson.name`,
    salespersondisplayid AS `salesperson.displayid`,
    salespersonuri AS `salesperson.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteprofessional;

-- SaleQuoteService View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteservice;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteservice AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    freight,
    totaltax,
    totalamount,
    category,
    salesperson,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    balancedueamount,
    foreigncurrency,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteservice;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleQuoteItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteitem;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteitem AS
SELECT
    uid,
    number,
    date,
    shiptoaddress,
    customerpurchaseordernumber,
    istaxinclusive,
    `lines`,
    subtotal,
    freight,
    totaltax,
    totalamount,
    salesperson,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    deliverystatus,
    referralsource,
    balancedueamount,
    foreigncurrency,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteitem;

-- PurchaseBillItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillitem;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillitem AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    `lines`,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    category,
    comment,
    shippingmethod,
    promiseddate,
    journalmemo,
    billdeliverystatus,
    appliedtodate,
    appliedtodateforeign,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    foreigncurrency,
    currencyexchangerate,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    orderuid AS `order.uid`,
    ordernumber AS `order.number`,
    orderuri AS `order.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillitem;

-- PurchaseBillService View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillservice;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillservice AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    `lines`,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    category,
    comment,
    shippingmethod,
    promiseddate,
    journalmemo,
    billdeliverystatus,
    appliedtodate,
    appliedtodateforeign,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    `order`,
    foreigncurrency,
    currencyexchangerate,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillservice;

-- PurchaseBillProfessional View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillprofessional;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillprofessional AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    istaxinclusive,
    isreportable,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    category,
    comment,
    promiseddate,
    journalmemo,
    billdeliverystatus,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    `order`,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillprofessional;

-- PurchaseBillMiscellaneous View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillmiscellaneous;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillmiscellaneous AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    istaxinclusive,
    isreportable,
    `lines`,
    subtotal,
    totaltax,
    totalamount,
    category,
    journalmemo,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    `order`,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillmiscellaneous;

-- PurchaseOrderItem View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorderitem;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorderitem AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    category,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    appliedtodate,
    appliedtodateforeign,
    orderdeliverystatus,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    foreigncurrency,
    currencyexchangerate,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorderitem;

-- PurchaseOrderService View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorderservice;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorderservice AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    category,
    comment,
    shippingmethod,
    journalmemo,
    promiseddate,
    appliedtodate,
    appliedtodateforeign,
    orderdeliverystatus,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    foreigncurrency,
    currencyexchangerate,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorderservice;

-- PurchaseOrderProfessional View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorderprofessional;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorderprofessional AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    subtotal,
    totaltax,
    totalamount,
    category,
    comment,
    journalmemo,
    promiseddate,
    appliedtodate,
    orderdeliverystatus,
    balancedueamount,
    status,
    lastpaymentdate,
    foreigncurrency,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorderprofessional;

-- PurOrderMisc View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purordermisc;
CREATE VIEW {etani_client_id}_dq_myobar_purordermisc AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    subtotal,
    totaltax,
    totalamount,
    category,
    journalmemo,
    appliedtodate,
    balancedueamount,
    status,
    lastpaymentdate,
    foreigncurrency,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purordermisc;

-- PayrollCategoryWage View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategorywage;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategorywage AS
SELECT
    uid,
    name,
    type,
    wagetype,
    stpcategory,
    overriddenwagesexpenseaccount,
    exemptions,
    uri,
    rowversion,
    clientid,
    organisationid,
    hourlydetailspayrate AS `hourlydetails.payrate`,
    hourlydetailsregularratemultiplier AS `hourlydetails.regularratemultiplier`,
    hourlydetailsfixedhourlyrate AS `hourlydetails.fixedhourlyrate`,
    hourlydetailsautomaticallyadjustbaseamounts AS `hourlydetails.automaticallyadjustbaseamounts`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategorywage;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayrollCatEntitle View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcatentitle;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcatentitle AS
SELECT
    uid,
    name,
    type,
    printonpayadvice,
    stpcategory,
    carryentitlementovertonextyear,
    exemptions,
    uri,
    rowversion,
    clientid,
    organisationid,
    calculationbasistype AS `calculationbasis.type`,
    calculationbasispercentageof AS `calculationbasis.percentageof`,
    calculationbasispayrollcategory AS `calculationbasis.payrollcategory`,
    calculationbasisfixedhoursof AS `calculationbasis.fixedhoursof`,
    calculationbasisaccrualperiod AS `calculationbasis.accrualperiod`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcatentitle;

-- PayrollCategoryDeduction View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategorydeduction;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategorydeduction AS
SELECT
    uid,
    name,
    type,
    stpcategory,
    exemptions,
    uri,
    rowversion,
    clientid,
    organisationid,
    payableaccountuid AS `payableaccount.uid`,
    payableaccountname AS `payableaccount.name`,
    payableaccountdisplayid AS `payableaccount.displayid`,
    payableaccounturi AS `payableaccount.uri`,
    calculationbasistype AS `calculationbasis.type`,
    calculationbasispercentageof AS `calculationbasis.percentageof`,
    calculationbasispayrollcategory AS `calculationbasis.payrollcategory`,
    calculationbasisfixeddollarsof AS `calculationbasis.fixeddollarsof`,
    calculationbasisaccrualperiod AS `calculationbasis.accrualperiod`,
    limittype AS `limit.type`,
    limitpercentageof AS `limit.percentageof`,
    limitpayrollcategory AS `limit.payrollcategory`,
    limitfixeddollarsof AS `limit.fixeddollarsof`,
    limitaccrualperiod AS `limit.accrualperiod`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategorydeduction;

-- PayrollCategoryExpense View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategoryexpense;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategoryexpense AS
SELECT
    uid,
    name,
    type,
    stpcategory,
    printonpayadvice,
    threshold,
    exemptions,
    uri,
    rowversion,
    clientid,
    organisationid,
    expenseaccountuid AS `expenseaccount.uid`,
    expenseaccountname AS `expenseaccount.name`,
    expenseaccountdisplayid AS `expenseaccount.displayid`,
    expenseaccounturi AS `expenseaccount.uri`,
    payableaccountuid AS `payableaccount.uid`,
    payableaccountname AS `payableaccount.name`,
    payableaccountdisplayid AS `payableaccount.displayid`,
    payableaccounturi AS `payableaccount.uri`,
    calculationbasistype AS `calculationbasis.type`,
    calculationbasispercentageof AS `calculationbasis.percentageof`,
    calculationbasispayrollcategory AS `calculationbasis.payrollcategory`,
    calculationbasispayrollcategoryuid AS `calculationbasis.payrollcategory.uid`,
    calculationbasispayrollcategoryname AS `calculationbasis.payrollcategory.name`,
    calculationbasispayrollcategorytype AS `calculationbasis.payrollcategory.type`,
    calculationbasispayrollcategoryuri AS `calculationbasis.payrollcategory.uri`,
    calculationbasisfixeddollarsof AS `calculationbasis.fixeddollarsof`,
    calculationbasisaccrualperiod AS `calculationbasis.accrualperiod`,
    limittype AS `limit.type`,
    limitpercentageof AS `limit.percentageof`,
    limitpayrollcategory AS `limit.payrollcategory`,
    limitfixeddollarsof AS `limit.fixeddollarsof`,
    limitaccrualperiod AS `limit.accrualperiod`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategoryexpense;

-- PayrollCatSuper View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcatsuper;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcatsuper AS
SELECT
    uid,
    name,
    type,
    stpcategory,
    contributiontype,
    printonpayadvice,
    exclusion,
    threshold,
    uri,
    rowversion,
    clientid,
    organisationid,
    expenseaccountuid AS `expenseaccount.uid`,
    expenseaccountname AS `expenseaccount.name`,
    expenseaccountdisplayid AS `expenseaccount.displayid`,
    expenseaccounturi AS `expenseaccount.uri`,
    payableaccountuid AS `payableaccount.uid`,
    payableaccountname AS `payableaccount.name`,
    payableaccountdisplayid AS `payableaccount.displayid`,
    payableaccounturi AS `payableaccount.uri`,
    calculationbasistype AS `calculationbasis.type`,
    calculationbasispercentageof AS `calculationbasis.percentageof`,
    calculationbasispayrollcategory AS `calculationbasis.payrollcategory`,
    calculationbasispayrollcategoryuid AS `calculationbasis.payrollcategory.uid`,
    calculationbasispayrollcategoryname AS `calculationbasis.payrollcategory.name`,
    calculationbasispayrollcategorytype AS `calculationbasis.payrollcategory.type`,
    calculationbasispayrollcategoryuri AS `calculationbasis.payrollcategory.uri`,
    calculationbasisfixeddollarsof AS `calculationbasis.fixeddollarsof`,
    calculationbasisaccrualperiod AS `calculationbasis.accrualperiod`,
    limittype AS `limit.type`,
    limitpercentageof AS `limit.percentageof`,
    limitpayrollcategory AS `limit.payrollcategory`,
    limitfixeddollarsof AS `limit.fixeddollarsof`,
    limitaccrualperiod AS `limit.accrualperiod`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcatsuper;

-- PayrollCategoryTax View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategorytax;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategorytax AS
SELECT
    uid,
    name,
    type,
    stpcategory,
    taxtablerevisiondate,
    uri,
    rowversion,
    clientid,
    organisationid,
    payableaccountuid AS `payableaccount.uid`,
    payableaccountname AS `payableaccount.name`,
    payableaccountdisplayid AS `payableaccount.displayid`,
    payableaccounturi AS `payableaccount.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategorytax;

-- PayrollCategoryTaxTable View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategorytaxtable;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategorytaxtable AS
SELECT
    uid,
    name,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategorytaxtable;

-- InvItemLocDetails View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_invitemlocdetails;
CREATE VIEW {etani_client_id}_dq_myobar_invitemlocdetails AS
SELECT
    uid,
    identifier,
    name,
    uri,
    quantityonhand,
    inventoryitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_invitemlocdetails;

-- InventoryAdjLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventoryadjln;
CREATE VIEW {etani_client_id}_dq_myobar_inventoryadjln AS
SELECT
    itemuid,
    itemnumber,
    itemname,
    locationuid,
    locationname,
    quantitybefore,
    quantitychange,
    quantityafter,
    unitcost,
    amount,
    memo,
    inventoryadjustmentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventoryadjln;

-- SaleInvoiceSvcLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoicesvclns;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoicesvclns AS
SELECT
    linenumber,
    type,
    description,
    quantity,
    unitprice,
    discount,
    taxamount,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    accountuid,
    accountname,
    total,
    saleinvoiceserviceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoicesvclns;

-- SaleInvTimeBillLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvtimebilllines;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvtimebilllines AS
SELECT
    rowid,
    type,
    date,
    hours,
    activity,
    units,
    item,
    rate,
    description,
    total,
    job,
    taxcode,
    rowversion,
    invoiceuid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvtimebilllines;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInvMiscellaneousLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvmiscellaneouslines;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvmiscellaneouslines AS
SELECT
    invoiceuid,
    rowid,
    type,
    description,
    total,
    account,
    job,
    taxcode,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvmiscellaneouslines;

-- SaleQuoteItemLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteitemlines;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteitemlines AS
SELECT
    quoteuid,
    rowid,
    type,
    description,
    shipquantity,
    unitprice,
    unitofmeasure,
    unitcount,
    discountpercent,
    total,
    item,
    account,
    job,
    taxcode,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteitemlines;

-- PurchaseBillServiceLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillservicelines;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillservicelines AS
SELECT
    billuid,
    rowid,
    type,
    description,
    unitprice,
    unitofmeasure,
    unitcount,
    unitpriceforeign,
    discountpercent,
    total,
    totalforeign,
    account,
    job,
    taxcode,
    rowversion,
    purchasebillserviceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillservicelines;

-- PurBillMiscLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purbillmisclines;
CREATE VIEW {etani_client_id}_dq_myobar_purbillmisclines AS
SELECT
    billuid,
    rowid,
    type,
    description,
    total,
    account,
    job,
    taxcode,
    rowversion,
    purchasebillmiscellaneousid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purbillmisclines;

-- InventoryBldLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_inventorybldlns;
CREATE VIEW {etani_client_id}_dq_myobar_inventorybldlns AS
SELECT
    rowid,
    quantity,
    unitcost,
    amount,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    memo,
    locationuid AS `location.uid`,
    locationidentifier AS `location.identifier`,
    locationname AS `location.name`,
    locationuri AS `location.uri`,
    rowversion,
    inventorybuildid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_inventorybldlns;

-- SaleInvoiceItmLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoiceitmlns;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoiceitmlns AS
SELECT
    rowid,
    type,
    description,
    shipquantity,
    unitprice,
    unitofmeasure,
    unitcount,
    unitpriceforeign,
    discountpercent,
    costofgoodssold,
    total,
    totalforeign,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    account,
    locationuid AS `location.uid`,
    locationidentifier AS `location.identifier`,
    locationname AS `location.name`,
    locationuri AS `location.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    saleinvoiceitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoiceitmlns;

-- SaleInvoiceProfLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoiceproflines;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoiceproflines AS
SELECT
    rowid,
    type,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    date,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    saleinvoiceprofessionalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoiceproflines;

-- SaleOrderItmLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorderitmlns;
CREATE VIEW {etani_client_id}_dq_myobar_saleorderitmlns AS
SELECT
    rowid,
    type,
    description,
    shipquantity,
    unitprice,
    unitpriceforeign,
    discountpercent,
    total,
    totalforeign,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    locationuid AS `location.uid`,
    locationidentifier AS `location.identifier`,
    locationname AS `location.name`,
    locationuri AS `location.uri`,
    rowversion,
    saleorderitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorderitmlns;

-- SaleOrderSvcLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleordersvcln;
CREATE VIEW {etani_client_id}_dq_myobar_saleordersvcln AS
SELECT
    rowid,
    type,
    description,
    rowversion,
    saleorderserviceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleordersvcln;

-- SaleOrderProfLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorderprofln;
CREATE VIEW {etani_client_id}_dq_myobar_saleorderprofln AS
SELECT
    rowid,
    type,
    date,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    saleorderprofessionalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorderprofln;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleOrderTmBillLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleordertmbillln;
CREATE VIEW {etani_client_id}_dq_myobar_saleordertmbillln AS
SELECT
    rowid,
    type,
    description,
    date,
    hours,
    activityuid AS `activity.uid`,
    activityname AS `activity.name`,
    activityuri AS `activity.uri`,
    units,
    item,
    rate,
    total,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    saleordertimebillingid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleordertmbillln;

-- SaleOrderMiscLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleordermiscln;
CREATE VIEW {etani_client_id}_dq_myobar_saleordermiscln AS
SELECT
    rowid,
    type,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    saleordermiscellaneousid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleordermiscln;

-- SaleQuoteMiscLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequotemisclines;
CREATE VIEW {etani_client_id}_dq_myobar_salequotemisclines AS
SELECT
    rowid,
    type,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    salequotemiscellaneousid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequotemisclines;

-- SaleQuoteTimeBillLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequotetimebillln;
CREATE VIEW {etani_client_id}_dq_myobar_salequotetimebillln AS
SELECT
    rowid,
    type,
    description,
    date,
    hours,
    activityuid AS `activity.uid`,
    activityname AS `activity.name`,
    activityuri AS `activity.uri`,
    units,
    item,
    rate,
    total,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    salequotetimebillingid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequotetimebillln;

-- SaleQuoteProfLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteprofln;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteprofln AS
SELECT
    rowid,
    type,
    date,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    salequoteprofessionalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteprofln;

-- SaleQuoteSvcLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequotesvcln;
CREATE VIEW {etani_client_id}_dq_myobar_salequotesvcln AS
SELECT
    rowid,
    type,
    description,
    rowversion,
    salequoteserviceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequotesvcln;

-- SaleQuoteItmLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequoteitmlns;
CREATE VIEW {etani_client_id}_dq_myobar_salequoteitmlns AS
SELECT
    rowid,
    type,
    description,
    shipquantity,
    unitprice,
    unitofmeasure,
    unitcount,
    discountpercent,
    total,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    account,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    salequoteitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequoteitmlns;

-- PurchaseBillItmLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillitmln;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillitmln AS
SELECT
    rowid,
    type,
    description,
    billquantity,
    receivedquantity,
    backorderquantity,
    total,
    totalforeign,
    unitprice,
    unitofmeasure,
    unitcount,
    unitpriceforeign,
    job,
    discountpercent,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    account,
    locationuid AS `location.uid`,
    locationidentifier AS `location.identifier`,
    locationname AS `location.name`,
    locationuri AS `location.uri`,
    rowversion,
    purchasebillitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillitmln;

-- PurchaseBillProfLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebillprofln;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebillprofln AS
SELECT
    rowid,
    type,
    date,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    purchasebillprofessionalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebillprofln;

-- PurchaseOrderItmLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorderitmln;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorderitmln AS
SELECT
    rowid,
    type,
    description,
    billquantity,
    receivedquantity,
    unitprice,
    unitpriceforeign,
    discountpercent,
    total,
    totalforeign,
    itemuid AS `item.uid`,
    itemnumber AS `item.number`,
    itemname AS `item.name`,
    itemuri AS `item.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    locationuid AS `location.uid`,
    locationidentifier AS `location.identifier`,
    locationname AS `location.name`,
    locationuri AS `location.uri`,
    rowversion,
    purchaseorderitemid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorderitmln;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrderSvcLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseordersvcln;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseordersvcln AS
SELECT
    rowid,
    type,
    description,
    total,
    totalforeign,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    purchaseorderserviceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseordersvcln;

-- PurchaseOrderProfLn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorderprofln;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorderprofln AS
SELECT
    rowid,
    type,
    date,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    purchaseorderprofessionalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorderprofln;

-- PurchaseOrderMiscLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseordermisclns;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseordermisclns AS
SELECT
    rowid,
    type,
    description,
    total,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    job,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    rowversion,
    purordermiscid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseordermisclns;

-- LinkedPayrollCatWages View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_linkedpayrollcatwages;
CREATE VIEW {etani_client_id}_dq_myobar_linkedpayrollcatwages AS
SELECT
    uid,
    name,
    type,
    uri,
    payrollcatentitleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_linkedpayrollcatwages;

-- PayrollCatSuperExempt View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcatsuperexempt;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcatsuperexempt AS
SELECT
    uid,
    name,
    type,
    uri,
    payrollcatsuperid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcatsuperexempt;