-- CIN7_DEAR Views - Auto Generated
-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Sale View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_sale;
CREATE VIEW {etani_client_id}_cin7_dear_sale AS
SELECT
    id,
    customer,
    customerid,
    contact,
    phone,
    email,
    defaultaccount,
    skipquote,
    billingaddressdisplayaddressline1 AS `billingaddress.displayaddressline1`,
    billingaddressdisplayaddressline2 AS `billingaddress.displayaddressline2`,
    billingaddressline1 AS `billingaddress.line1`,
    billingaddressline2 AS `billingaddress.line2`,
    billingaddresscity AS `billingaddress.city`,
    billingaddressstate AS `billingaddress.state`,
    billingaddresspostcode AS `billingaddress.postcode`,
    billingaddresscountry AS `billingaddress.country`,
    shippingaddressdisplayaddressline1 AS `shippingaddress.displayaddressline1`,
    shippingaddressdisplayaddressline2 AS `shippingaddress.displayaddressline2`,
    shippingaddressline1 AS `shippingaddress.line1`,
    shippingaddressline2 AS `shippingaddress.line2`,
    shippingaddresscity AS `shippingaddress.city`,
    shippingaddressstate AS `shippingaddress.state`,
    shippingaddresspostcode AS `shippingaddress.postcode`,
    shippingaddresscountry AS `shippingaddress.country`,
    shippingaddresscompany AS `shippingaddress.company`,
    shippingaddresscontact AS `shippingaddress.contact`,
    shippingaddressshiptoother AS `shippingaddress.shiptoother`,
    shippingnotes,
    basecurrency,
    customercurrency,
    taxrule,
    taxcalculation,
    terms,
    pricetier,
    shipby,
    location,
    saleorderdate,
    lastmodifiedon,
    note,
    customerreference,
    cogsamount,
    status,
    combinedpickingstatus,
    combinedpackingstatus,
    combinedshippingstatus,
    fulfilmentstatus,
    combinedinvoicestatus,
    combinedpaymentstatus,
    combinedtrackingnumbers,
    carrier,
    currencyrate,
    salesrepresentative,
    serviceonly,
    type,
    sourcechannel,
    quotememo AS `quote.memo`,
    quotestatus AS `quote.status`,
    quotetotalbeforetax AS `quote.totalbeforetax`,
    quotetax AS `quote.tax`,
    quotetotal AS `quote.total`,
    ordersaleordernumber AS `order.saleordernumber`,
    ordermemo AS `order.memo`,
    orderstatus AS `order.status`,
    ordertotalbeforetax AS `order.totalbeforetax`,
    ordertax AS `order.tax`,
    ordertotal AS `order.total`,
    manualjournalsstatus AS `manualjournals.status`,
    externalid,
    additionalattribute1 AS `additionalattributes.additionalattribute1`,
    additionalattribute2 AS `additionalattributes.additionalattribute2`,
    additionalattribute3 AS `additionalattributes.additionalattribute3`,
    additionalattribute4 AS `additionalattributes.additionalattribute4`,
    additionalattribute5 AS `additionalattributes.additionalattribute5`,
    additionalattribute6 AS `additionalattributes.additionalattribute6`,
    additionalattribute7 AS `additionalattributes.additionalattribute7`,
    additionalattribute8 AS `additionalattributes.additionalattribute8`,
    additionalattribute9 AS `additionalattributes.additionalattribute9`,
    additionalattribute10 AS `additionalattributes.additionalattribute10`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_sale;

-- SaleQuoteLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salequotelines;
CREATE VIEW {etani_client_id}_cin7_dear_salequotelines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    averagecost,
    taxrule,
    comment,
    dropship,
    backorder,
    backorderquantity,
    total,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salequotelines;

-- SaleQuoteAdditionalCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salequoteadditionalcharges;
CREATE VIEW {etani_client_id}_cin7_dear_salequoteadditionalcharges AS
SELECT
    description,
    price,
    quantity,
    discount,
    tax,
    total,
    taxrule,
    comment,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salequoteadditionalcharges;

-- SaleQuotePrepayments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salequoteprepayments;
CREATE VIEW {etani_client_id}_cin7_dear_salequoteprepayments AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salequoteprepayments;

-- SaleOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleorderlines;
CREATE VIEW {etani_client_id}_cin7_dear_saleorderlines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    averagecost,
    taxrule,
    comment,
    dropship,
    backorder,
    backorderquantity,
    total,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleorderlines;

-- SaleOrderAdditionalCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleorderadditionalcharges;
CREATE VIEW {etani_client_id}_cin7_dear_saleorderadditionalcharges AS
SELECT
    description,
    price,
    quantity,
    discount,
    tax,
    total,
    taxrule,
    comment,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleorderadditionalcharges;

-- SaleFulfilments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salefulfilments;
CREATE VIEW {etani_client_id}_cin7_dear_salefulfilments AS
SELECT
    taskid,
    fulfillmentnumber,
    linkedinvoicenumber,
    fulfilmentstatus,
    pickstatus AS `pick.status`,
    packstatus AS `pack.status`,
    shipstatus AS `ship.status`,
    shiprequireby AS `ship.requireby`,
    shipshippingnotes AS `ship.shippingnotes`,
    shipaddressdisplayaddressline1 AS `ship.shippingaddress.displayaddressline1`,
    shipaddressdisplayaddressline2 AS `ship.shippingaddress.displayaddressline2`,
    shipaddressline1 AS `ship.shippingaddress.line1`,
    shipaddressline2 AS `ship.shippingaddress.line2`,
    shipaddresscity AS `ship.shippingaddress.city`,
    shipaddressstate AS `ship.shippingaddress.state`,
    shipaddresspostcode AS `ship.shippingaddress.postcode`,
    shipaddresscountry AS `ship.shippingaddress.country`,
    shipaddresscompany AS `ship.shippingaddress.company`,
    shipaddresscontact AS `ship.shippingaddress.contact`,
    shipaddressshiptoother AS `ship.shippingaddress.shiptoother`,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salefulfilments;

-- SaleFulfilmentsPickLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salefulfilmentspicklines;
CREATE VIEW {etani_client_id}_cin7_dear_salefulfilmentspicklines AS
SELECT
    productid,
    sku,
    name,
    location,
    locationid,
    quantity,
    batchsn,
    expirydate,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    salefulfilmentsid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salefulfilmentspicklines;

-- SaleFulfilmentsPackLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salefulfilmentspacklines;
CREATE VIEW {etani_client_id}_cin7_dear_salefulfilmentspacklines AS
SELECT
    productid,
    sku,
    name,
    location,
    locationid,
    box,
    quantity,
    batchsn,
    expirydate,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    salefulfilmentsid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salefulfilmentspacklines;

-- SaleFulfilmentsShipLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salefulfilmentsshiplines;
CREATE VIEW {etani_client_id}_cin7_dear_salefulfilmentsshiplines AS
SELECT
    id,
    shipmentdate,
    carrier,
    boxes,
    trackingnumber,
    trackingurl,
    isshipped,
    salefulfilmentsid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salefulfilmentsshiplines;


-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInvoices View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleinvoices;
CREATE VIEW {etani_client_id}_cin7_dear_saleinvoices AS
SELECT
    taskid,
    invoicenumber,
    memo,
    status,
    invoicedate,
    invoiceduedate,
    currencyconversionrate,
    billingaddressline1,
    billingaddressline2,
    linkedfulfillmentnumber,
    totalbeforetax,
    tax,
    total,
    paid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleinvoices;

-- SaleInvoicesLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleinvoiceslines;
CREATE VIEW {etani_client_id}_cin7_dear_saleinvoiceslines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    total,
    averagecost,
    taxrule,
    account,
    comment,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    saleinvoicesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleinvoiceslines;

-- SaleInvoicesAdditionalCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleinvoicesadditionalcharges;
CREATE VIEW {etani_client_id}_cin7_dear_saleinvoicesadditionalcharges AS
SELECT
    description,
    quantity,
    price,
    discount,
    tax,
    total,
    taxrule,
    account,
    comment,
    saleinvoicesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleinvoicesadditionalcharges;

-- SaleInvoicesPayments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleinvoicespayments;
CREATE VIEW {etani_client_id}_cin7_dear_saleinvoicespayments AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    saleinvoicesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleinvoicespayments;

-- SaleCreditNotes View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salecreditnotes;
CREATE VIEW {etani_client_id}_cin7_dear_salecreditnotes AS
SELECT
    taskid,
    creditnoteinvoicenumber,
    memo,
    status,
    creditnotedate,
    creditnotenumber,
    creditnoteconversionrate,
    totalbeforetax,
    tax,
    total,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salecreditnotes;

-- SaleCreditNotesLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salecreditnoteslines;
CREATE VIEW {etani_client_id}_cin7_dear_salecreditnoteslines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    total,
    averagecost,
    taxrule,
    account,
    comment,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    salecreditnotesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salecreditnoteslines;

-- SaleCreditNotesAddCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salecreditnotesaddcharges;
CREATE VIEW {etani_client_id}_cin7_dear_salecreditnotesaddcharges AS
SELECT
    description,
    quantity,
    price,
    discount,
    tax,
    total,
    taxrule,
    account,
    comment,
    salecreditnotesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salecreditnotesaddcharges;

-- SaleCreditNotesRefunds View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salecreditnotesrefunds;
CREATE VIEW {etani_client_id}_cin7_dear_salecreditnotesrefunds AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    salecreditnotesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salecreditnotesrefunds;

-- SaleCreditNotesRestock View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salecreditnotesrestock;
CREATE VIEW {etani_client_id}_cin7_dear_salecreditnotesrestock AS
SELECT
    productid,
    sku,
    name,
    location,
    locationid,
    quantity,
    batchsn,
    expirydate,
    salecreditnotesid,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salecreditnotesrestock;

-- SaleAttachments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleattachments;
CREATE VIEW {etani_client_id}_cin7_dear_saleattachments AS
SELECT
    id,
    contenttype,
    filename,
    downloadurl,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleattachments;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInventoryMovements View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saleinventorymovements;
CREATE VIEW {etani_client_id}_cin7_dear_saleinventorymovements AS
SELECT
    taskid,
    productid,
    date,
    cogs,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saleinventorymovements;

-- SaleTransactions View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_saletransactions;
CREATE VIEW {etani_client_id}_cin7_dear_saletransactions AS
SELECT
    taskid,
    transactionid,
    debit,
    credit,
    description,
    amount,
    effectivedate,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_saletransactions;

-- SaleManualJournalsLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_salemanualjournalslines;
CREATE VIEW {etani_client_id}_cin7_dear_salemanualjournalslines AS
SELECT
    reference,
    amount,
    date,
    debit,
    credit,
    saleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_salemanualjournalslines;

-- ProductCategory View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productcategory;
CREATE VIEW {etani_client_id}_cin7_dear_productcategory AS
SELECT
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productcategory;

-- UnitOfMeasure View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_unitofmeasure;
CREATE VIEW {etani_client_id}_cin7_dear_unitofmeasure AS
SELECT
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_unitofmeasure;

-- Brand View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_brand;
CREATE VIEW {etani_client_id}_cin7_dear_brand AS
SELECT
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_brand;

-- Location View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_location;
CREATE VIEW {etani_client_id}_cin7_dear_location AS
SELECT
    id,
    name,
    isdefault,
    isdeprecated,
    bins,
    fixedassetslocation,
    parentid,
    parentname,
    referencecount,
    addressline1,
    addressline2,
    addresscitysuburb,
    addressstateprovince,
    addresszippostcode,
    addresscountry,
    pickzones,
    isshopfloor,
    iscoman,
    isstaging,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_location;

-- AttributeSet View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_attributeset;
CREATE VIEW {etani_client_id}_cin7_dear_attributeset AS
SELECT
    id,
    name,
    attribute1name,
    attribute1type,
    attribute1values,
    attribute2name,
    attribute2type,
    attribute2values,
    attribute3name,
    attribute3type,
    attribute3values,
    attribute4name,
    attribute4type,
    attribute4values,
    attribute5name,
    attribute5type,
    attribute5values,
    attribute6name,
    attribute6type,
    attribute6values,
    attribute7name,
    attribute7type,
    attribute7values,
    attribute8name,
    attribute8type,
    attribute8values,
    attribute9name,
    attribute9type,
    attribute9values,
    attribute10name,
    attribute10type,
    attribute10values,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_attributeset;

-- AttributeSetAttributes View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_attributesetattributes;
CREATE VIEW {etani_client_id}_cin7_dear_attributesetattributes AS
SELECT
    name,
    type,
    `values`,
    attributesetid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_attributesetattributes;

-- Product View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_product;
CREATE VIEW {etani_client_id}_cin7_dear_product AS
SELECT
    id,
    sku,
    name,
    category,
    brand,
    type,
    costingmethod,
    dropshipmode,
    defaultlocation,
    length,
    width,
    height,
    weight,
    uom,
    weightunits,
    dimensionsunits,
    barcode,
    minimumbeforereorder,
    reorderquantity,
    pricetier1,
    pricetier2,
    pricetier3,
    pricetier4,
    pricetier5,
    pricetier6,
    pricetier7,
    pricetier8,
    pricetier9,
    pricetier10,
    pricetierstier1 AS `pricetiers.tier 1`,
    pricetierstier2 AS `pricetiers.tier 2`,
    pricetierstier3 AS `pricetiers.tier 3`,
    pricetierstier4 AS `pricetiers.tier 4`,
    pricetierstier5 AS `pricetiers.tier 5`,
    pricetierstier6 AS `pricetiers.tier 6`,
    pricetierstier7 AS `pricetiers.tier 7`,
    pricetierstier8 AS `pricetiers.tier 8`,
    pricetierstier9 AS `pricetiers.tier 9`,
    pricetierstier10 AS `pricetiers.tier 10`,
    averagecost,
    shortdescription,
    description,
    internalnote,
    additionalattribute1,
    additionalattribute2,
    additionalattribute3,
    additionalattribute4,
    additionalattribute5,
    additionalattribute6,
    additionalattribute7,
    additionalattribute8,
    additionalattribute9,
    additionalattribute10,
    attributeset,
    discountrule,
    tags,
    status,
    stocklocator,
    cogsaccount,
    revenueaccount,
    expenseaccount,
    inventoryaccount,
    purchasetaxrule,
    saletaxrule,
    lastmodifiedon,
    sellable,
    pickzones,
    billofmaterial,
    autoassembly,
    autodisassembly,
    quantitytoproduce,
    assemblyinstructionurl,
    assemblycostestimationmethod,
    cartonheight,
    cartonwidth,
    cartonlength,
    cartonquantity,
    cartoninnerquantity,
    hscode,
    countryoforigin,
    countryoforigincode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_product;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProductSuppliers View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productsuppliers;
CREATE VIEW {etani_client_id}_cin7_dear_productsuppliers AS
SELECT
    productid,
    id AS `supplierid`,
    suppliername,
    productsku,
    productsupplierid,
    supplierinventorycode,
    supplierproductname,
    cost,
    fixedcost,
    currency,
    dropship,
    supplierproducturl,
    lastsupplied,
    defaultsupplier,
    defaultprice,
    minimumorderqty,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productsuppliers;

-- ProductSupplierOptions View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productsupplieroptions;
CREATE VIEW {etani_client_id}_cin7_dear_productsupplieroptions AS
SELECT
    id,
    locationid,
    locationname,
    reorderquantity,
    `lead`,
    safety,
    minimumtoreorder,
    supplyintervals,
    productsupplierid,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productsupplieroptions;

-- ProductSupplierOptionsIntervals View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productsupplieroptionsintervals;
CREATE VIEW {etani_client_id}_cin7_dear_productsupplieroptionsintervals AS
SELECT
    id,
    deliverymethod,
    intervaldays,
    intervalstartdate,
    ismonday,
    istuesday,
    iswednesday,
    isthursday,
    isfriday,
    issaturday,
    issunday,
    productsupplieroptionid,
    productsupplierid,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productsupplieroptionsintervals;

-- ProductReorderLevels View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productreorderlevels;
CREATE VIEW {etani_client_id}_cin7_dear_productreorderlevels AS
SELECT
    locationid,
    locationname,
    minimumbeforereorder,
    reorderquantity,
    stocklocator,
    pickzones,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productreorderlevels;

-- ProductBillOfMaterialsProducts View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productbillofmaterialsproducts;
CREATE VIEW {etani_client_id}_cin7_dear_productbillofmaterialsproducts AS
SELECT
    componentproductid,
    productcode,
    name,
    quantity,
    wastagepercent,
    wastagequantity,
    costpercentage,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productbillofmaterialsproducts;

-- ProductBillOfMaterialsServices View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productbillofmaterialsservices;
CREATE VIEW {etani_client_id}_cin7_dear_productbillofmaterialsservices AS
SELECT
    componentproductid,
    name,
    quantity,
    expenseaccount,
    pricetier,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productbillofmaterialsservices;

-- ProductMovements View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productmovements;
CREATE VIEW {etani_client_id}_cin7_dear_productmovements AS
SELECT
    taskid,
    type,
    date,
    number,
    quantity,
    amount,
    location,
    batchsn,
    expirydate,
    fromto,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productmovements;

-- ProductAttachments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productattachments;
CREATE VIEW {etani_client_id}_cin7_dear_productattachments AS
SELECT
    id,
    contenttype,
    filename,
    downloadurl,
    productid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productattachments;

-- ProductCustomPrices View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productcustomprices;
CREATE VIEW {etani_client_id}_cin7_dear_productcustomprices AS
SELECT
    productid,
    customerproductid,
    productname,
    productsku,
    price,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productcustomprices;

-- ProductFamily View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productfamily;
CREATE VIEW {etani_client_id}_cin7_dear_productfamily AS
SELECT
    id,
    sku,
    name,
    category,
    defaultlocation,
    brand,
    costingmethod,
    uom,
    minimumbeforereorder,
    reorderquantity,
    pricetier1,
    pricetier2,
    pricetier3,
    pricetier4,
    pricetier5,
    pricetier6,
    pricetier7,
    pricetier8,
    pricetier9,
    pricetier10,
    shortdescription,
    description,
    attributeset,
    discountrule,
    tags,
    cogsaccount,
    revenueaccount,
    inventoryaccount,
    purchasetaxrule,
    saletaxrule,
    dropshipmode,
    option1name,
    option2name,
    option3name,
    option1values,
    option2values,
    option3values,
    lastmodifiedon,
    hscode,
    countryoforigin,
    countryoforigincode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productfamily;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProductFamilyProducts View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productfamilyproducts;
CREATE VIEW {etani_client_id}_cin7_dear_productfamilyproducts AS
SELECT
    id,
    sku,
    name,
    option1,
    option2,
    option3,
    productfamilyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productfamilyproducts;

-- ProductFamilyAttachments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productfamilyattachments;
CREATE VIEW {etani_client_id}_cin7_dear_productfamilyattachments AS
SELECT
    id,
    contenttype,
    filename,
    downloadurl,
    productfamilyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productfamilyattachments;

-- Account View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_account;
CREATE VIEW {etani_client_id}_cin7_dear_account AS
SELECT
    code,
    status,
    name,
    type,
    description,
    class,
    systemaccount,
    bankaccountnumber,
    bankaccountid,
    forpayments,
    displayname,
    oldcode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_account;

-- Tax View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_tax;
CREATE VIEW {etani_client_id}_cin7_dear_tax AS
SELECT
    id,
    name,
    account,
    isactive,
    taxinclusive,
    taxpercent,
    istaxforsale,
    istaxforpurchase,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_tax;

-- TaxComponents View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_taxcomponents;
CREATE VIEW {etani_client_id}_cin7_dear_taxcomponents AS
SELECT
    id,
    name,
    percent,
    accountcode,
    compound,
    componentorder,
    taxid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_taxcomponents;

-- PaymentTerm View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_paymentterm;
CREATE VIEW {etani_client_id}_cin7_dear_paymentterm AS
SELECT
    id,
    name,
    duration,
    method,
    isactive,
    isdefault,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_paymentterm;

-- Carrier View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_carrier;
CREATE VIEW {etani_client_id}_cin7_dear_carrier AS
SELECT
    carrierid,
    description,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_carrier;

-- Supplier View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_supplier;
CREATE VIEW {etani_client_id}_cin7_dear_supplier AS
SELECT
    id,
    name,
    currency,
    paymentterm,
    taxrule,
    discount,
    comments,
    accountpayable,
    taxnumber,
    additionalattribute1,
    additionalattribute2,
    additionalattribute3,
    additionalattribute4,
    additionalattribute5,
    additionalattribute6,
    additionalattribute7,
    additionalattribute8,
    additionalattribute9,
    additionalattribute10,
    attributeset,
    status,
    lastmodifiedon,
    addresses,
    contacts,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_supplier;

-- SupplierAddresses View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_supplieraddresses;
CREATE VIEW {etani_client_id}_cin7_dear_supplieraddresses AS
SELECT
    addressindex,
    line1,
    line2,
    city,
    state,
    postcode,
    country,
    type,
    defaultfortype,
    supplierid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_supplieraddresses;

-- SupplierContacts View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_suppliercontacts;
CREATE VIEW {etani_client_id}_cin7_dear_suppliercontacts AS
SELECT
    contactindex,
    name,
    phone,
    mobilephone,
    fax,
    email,
    website,
    `default`,
    comment,
    includeinemail,
    supplierid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_suppliercontacts;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Customer View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_customer;
CREATE VIEW {etani_client_id}_cin7_dear_customer AS
SELECT
    id,
    name,
    displayname,
    currency,
    paymentterm,
    discount,
    taxrule,
    carrier,
    salesrepresentative,
    location,
    comments,
    accountreceivable,
    revenueaccount,
    pricetier,
    taxnumber,
    additionalattribute1,
    additionalattribute2,
    additionalattribute3,
    additionalattribute4,
    additionalattribute5,
    additionalattribute6,
    additionalattribute7,
    additionalattribute8,
    additionalattribute9,
    additionalattribute10,
    attributeset,
    tags,
    status,
    creditlimit,
    isoncredithold,
    lastmodifiedon,
    addresses,
    contacts,
    productprices,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_customer;

-- CustomerAddresses View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_customeraddresses;
CREATE VIEW {etani_client_id}_cin7_dear_customeraddresses AS
SELECT
    id,
    line1,
    line2,
    city,
    state,
    postcode,
    country,
    type,
    defaultfortype,
    customerid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_customeraddresses;

-- CustomerContacts View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_customercontacts;
CREATE VIEW {etani_client_id}_cin7_dear_customercontacts AS
SELECT
    id,
    name,
    jobtitle,
    phone,
    mobilephone,
    fax,
    email,
    website,
    `default`,
    comment,
    includeinemail,
    marketingconsent,
    customerid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_customercontacts;

-- CustomerProductPrices View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_customerproductprices;
CREATE VIEW {etani_client_id}_cin7_dear_customerproductprices AS
SELECT
    productid,
    productname,
    productsku,
    price,
    customerid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_customerproductprices;

-- Disassembly View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_disassembly;
CREATE VIEW {etani_client_id}_cin7_dear_disassembly AS
SELECT
    taskid,
    disassemblynumber,
    status,
    productid,
    productcode,
    productname,
    locationid,
    location,
    completiondate,
    wipaccount,
    quantity,
    assemblyinstructionurl,
    errors,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_disassembly;

-- DisassemblyPickLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_disassemblypicklines;
CREATE VIEW {etani_client_id}_cin7_dear_disassemblypicklines AS
SELECT
    binid,
    bin,
    date,
    batchsn,
    expirydate,
    available,
    unitcost,
    quantity,
    totalcost,
    disassemblyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_disassemblypicklines;

-- DisassemblyOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_disassemblyorderlines;
CREATE VIEW {etani_client_id}_cin7_dear_disassemblyorderlines AS
SELECT
    productid,
    productcode,
    name,
    binid,
    bin,
    unit,
    batchsn,
    expirydate,
    account,
    quantity,
    cost,
    disassemblyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_disassemblyorderlines;

-- DisassemblyOrderServiceLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_disassemblyorderservicelines;
CREATE VIEW {etani_client_id}_cin7_dear_disassemblyorderservicelines AS
SELECT
    productid,
    name,
    account,
    comments,
    amount,
    disassemblyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_disassemblyorderservicelines;

-- DisassemblyTransactions View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_disassemblytransactions;
CREATE VIEW {etani_client_id}_cin7_dear_disassemblytransactions AS
SELECT
    id,
    effectivedate,
    debit,
    credit,
    amount,
    disassemblyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_disassemblytransactions;

-- FinishedGoods View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_finishedgoods;
CREATE VIEW {etani_client_id}_cin7_dear_finishedgoods AS
SELECT
    taskid,
    assemblynumber,
    status,
    productid,
    productcode,
    productname,
    locationid,
    location,
    binid,
    bin,
    wipaccount,
    wipdate,
    account,
    quantity,
    assemblyinstructionurl,
    completiondate,
    batchsn,
    expirydate,
    notes,
    customfield1,
    customfield2,
    customfield3,
    customfield4,
    customfield5,
    customfield6,
    customfield7,
    customfield8,
    customfield9,
    customfield10,
    errors,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_finishedgoods;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- FinishedGoodsOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_finishedgoodsorderlines;
CREATE VIEW {etani_client_id}_cin7_dear_finishedgoodsorderlines AS
SELECT
    productid,
    productcode,
    name,
    expenseaccount,
    quantity,
    unit,
    wastagepercent,
    wastagequantity,
    totalquantity,
    totalcost,
    finishedgoodsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_finishedgoodsorderlines;

-- FinishedGoodsPickLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_finishedgoodspicklines;
CREATE VIEW {etani_client_id}_cin7_dear_finishedgoodspicklines AS
SELECT
    productid,
    productcode,
    name,
    binid,
    bin,
    batchsn,
    expirydate,
    quantity,
    unit,
    cost,
    finishedgoodsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_finishedgoodspicklines;

-- FinishedGoodsTransactions View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_finishedgoodstransactions;
CREATE VIEW {etani_client_id}_cin7_dear_finishedgoodstransactions AS
SELECT
    id,
    effectivedate,
    debit,
    credit,
    amount,
    finishedgoodsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_finishedgoodstransactions;

-- Purchase View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchase;
CREATE VIEW {etani_client_id}_cin7_dear_purchase AS
SELECT
    id,
    supplierid,
    supplier,
    contact,
    phone,
    inventoryaccount,
    blindreceipt,
    approach,
    billingaddressdisplayline1,
    billingaddressdisplayline2,
    billingaddressline1,
    billingaddressline2,
    billingaddresscity,
    billingaddressstate,
    billingaddresspostcode,
    billingaddresscountry,
    shippingaddressdisplayline1,
    shippingaddressdisplayline2,
    shippingaddressline1,
    shippingaddressline2,
    shippingaddresscity,
    shippingaddressstate,
    shippingaddresspostcode,
    shippingaddresscountry,
    shippingaddressshiptoother,
    basecurrency,
    suppliercurrency,
    taxrule,
    taxcalculation,
    terms,
    requiredby,
    location,
    note,
    ordernumber,
    orderdate,
    status,
    relateddropshipsaletask,
    currencyrate,
    lastupdateddate,
    ordermemo,
    orderstatus,
    ordertotalbeforetax,
    ordertax,
    ordertotal,
    stockreceivedstatus,
    invoicedate,
    invoiceduedate,
    invoicenumber,
    invoicestatus,
    invoicetotalbeforetax,
    invoicetax,
    invoicetotal,
    invoicepaid,
    creditnotenumber,
    creditnotedate,
    creditnotestatus,
    creditnotetotalbeforetax,
    creditnotetax,
    creditnotetotal,
    unstockstatus,
    manualjournalsstatus,
    additionalattribute1,
    additionalattribute2,
    additionalattribute3,
    additionalattribute4,
    additionalattribute5,
    additionalattribute6,
    additionalattribute7,
    additionalattribute8,
    additionalattribute9,
    additionalattribute10,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchase;

-- PurchaseOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseorderlines;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseorderlines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    taxrule,
    suppliersku,
    comment,
    total,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseorderlines;

-- PurchaseOrderAdditionalCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseorderadditionalcharges;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseorderadditionalcharges AS
SELECT
    description,
    reference,
    price,
    quantity,
    discount,
    tax,
    total,
    taxrule,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseorderadditionalcharges;

-- PurchaseOrderPrepayments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseorderprepayments;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseorderprepayments AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseorderprepayments;

-- PurchaseStockReceivedLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchasestockreceivedlines;
CREATE VIEW {etani_client_id}_cin7_dear_purchasestockreceivedlines AS
SELECT
    date,
    quantity,
    productid,
    sku,
    name,
    location,
    locationid,
    received,
    batchsn,
    suppliersku,
    expirydate,
    cardid,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchasestockreceivedlines;

-- PurchaseInvoiceLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseinvoicelines;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseinvoicelines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    taxrule,
    account,
    comment,
    total,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseinvoicelines;

-- PurchaseInvoiceAddCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseinvoiceaddcharges;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseinvoiceaddcharges AS
SELECT
    description,
    reference,
    quantity,
    price,
    discount,
    tax,
    taxrule,
    account,
    total,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseinvoiceaddcharges;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseInvoicePayments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseinvoicepayments;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseinvoicepayments AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseinvoicepayments;

-- PurchaseCreditNoteLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchasecreditnotelines;
CREATE VIEW {etani_client_id}_cin7_dear_purchasecreditnotelines AS
SELECT
    productid,
    sku,
    name,
    quantity,
    price,
    discount,
    tax,
    taxrule,
    account,
    comment,
    total,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchasecreditnotelines;

-- PurCreditNoteAddCharges View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purcreditnoteaddcharges;
CREATE VIEW {etani_client_id}_cin7_dear_purcreditnoteaddcharges AS
SELECT
    description,
    reference,
    quantity,
    price,
    discount,
    tax,
    taxrule,
    account,
    total,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purcreditnoteaddcharges;

-- PurchaseCreditNoteRefunds View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchasecreditnoterefunds;
CREATE VIEW {etani_client_id}_cin7_dear_purchasecreditnoterefunds AS
SELECT
    id,
    reference,
    amount,
    datepaid,
    account,
    currencyrate,
    datecreated,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchasecreditnoterefunds;

-- PurchaseCreditNoteUnstockLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchasecreditnoteunstocklines;
CREATE VIEW {etani_client_id}_cin7_dear_purchasecreditnoteunstocklines AS
SELECT
    cardid,
    date,
    quantity,
    productid,
    sku,
    name,
    location,
    batchsn,
    expirydate,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchasecreditnoteunstocklines;

-- PurchaseManualJournalLines View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchasemanualjournallines;
CREATE VIEW {etani_client_id}_cin7_dear_purchasemanualjournallines AS
SELECT
    reference,
    amount,
    date,
    debit,
    credit,
    issystem,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchasemanualjournallines;

-- PurchaseAttachments View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseattachments;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseattachments AS
SELECT
    id,
    contenttype,
    filename,
    downloadurl,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseattachments;

-- PurchaseInventoryMovements View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_purchaseinventorymovements;
CREATE VIEW {etani_client_id}_cin7_dear_purchaseinventorymovements AS
SELECT
    taskid,
    productid,
    date,
    cogs,
    productlength,
    productwidth,
    productheight,
    productweight,
    weightunits,
    dimensionsunits,
    productcustomfield1,
    productcustomfield2,
    productcustomfield3,
    productcustomfield4,
    productcustomfield5,
    productcustomfield6,
    productcustomfield7,
    productcustomfield8,
    productcustomfield9,
    productcustomfield10,
    purchaseid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_purchaseinventorymovements;

-- ProductAvailability View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productavailability;
CREATE VIEW {etani_client_id}_cin7_dear_productavailability AS
SELECT
    id,
    sku,
    name,
    barcode,
    location,
    bin,
    batch,
    expirydate,
    onhand,
    allocated,
    available,
    onorder,
    stockonhand,
    intransit,
    nextdeliverydate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productavailability;

-- ChartOfAccount View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_chartofaccount;
CREATE VIEW {etani_client_id}_cin7_dear_chartofaccount AS
SELECT
    code,
    status,
    name,
    type,
    description,
    class,
    systemaccount,
    bankaccountnumber,
    bankaccountid,
    forpayments,
    displayname,
    oldcode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_chartofaccount;

-- Pattern: {etani_client_id}_cin7_dear_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProductAttachment View
DROP VIEW IF EXISTS {etani_client_id}_cin7_dear_productattachment;
CREATE VIEW {etani_client_id}_cin7_dear_productattachment AS
SELECT
    id,
    contenttype,
    isdefault,
    filename,
    downloadurl,
    clientid,
    organisationid,
    productid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_cin7_dear_productattachment;