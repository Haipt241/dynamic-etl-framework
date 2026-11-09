-- UNLEASHED Views - Auto Generated
-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_companies;
CREATE VIEW {etani_client_id}_unleashed_companies AS
SELECT
    id AS `guid`,
    companyname,
    basecurrencycode,
    defaulttaxrate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_companies;

-- Assemblies View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_assemblies;
CREATE VIEW {etani_client_id}_unleashed_assemblies AS
SELECT
    id AS `guid`,
    assemblynumber,
    assemblydate,
    assemblytype,
    assemblystatus,
    customassemblystatus,
    autoassembly,
    quantity,
    assembleby,
    comments,
    canassemblequantity,
    batchnumbers,
    serialnumbers,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    assemblylines,
    suppliercosts,
    sourcewarehouseguid AS `sourcewarehouse.guid`,
    sourcewarehousecode AS `sourcewarehouse.warehousecode`,
    sourcewarehousename AS `sourcewarehouse.warehousename`,
    destinationwarehouseguid AS `destinationwarehouse.guid`,
    destinationwarehousecode AS `destinationwarehouse.warehousecode`,
    destinationwarehousename AS `destinationwarehouse.warehousename`,
    total,
    totalcost,
    disassemblecosttotal,
    suppliercoststax,
    suppliercostssubtotal,
    salesordernumber,
    expectedduration,
    actualduration,
    estimatedstartdate,
    durationcomments,
    productionpersonguid AS `productionperson.guid`,
    productionpersonfullname AS `productionperson.fullname`,
    productionpersonemail AS `productionperson.email`,
    lastmodifiedby,
    createdby,
    createdon,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_assemblies;

-- AssemblyLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_assemblylines;
CREATE VIEW {etani_client_id}_unleashed_assemblylines AS
SELECT
    id AS `guid`,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    quantity,
    wastagequantity,
    unitcost,
    totalcost,
    assembliesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_assemblylines;

-- AssemblySupplierCosts View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_assemblysuppliercosts;
CREATE VIEW {etani_client_id}_unleashed_assemblysuppliercosts AS
SELECT
    id AS `guid`,
    supplierguid AS `supplier.guid`,
    suppliercode AS `supplier.suppliercode`,
    cost,
    currencycode AS `currency.currencycode`,
    taxrate,
    assembliesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_assemblysuppliercosts;

-- AssemblyBatchNumbers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_assemblybatchnumbers;
CREATE VIEW {etani_client_id}_unleashed_assemblybatchnumbers AS
SELECT
    id AS `guid`,
    batchnumber AS `number`,
    quantity,
    expirydate,
    assembliesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_assemblybatchnumbers;

-- AssemblySerialNumbers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_assemblyserialnumbers;
CREATE VIEW {etani_client_id}_unleashed_assemblyserialnumbers AS
SELECT
    id AS `guid`,
    serialnumber,
    assembliesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_assemblyserialnumbers;

-- SalesShipments View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipments;
CREATE VIEW {etani_client_id}_unleashed_salesshipments AS
SELECT
    id AS `guid`,
    ordernumber,
    orderguid,
    shipmentnumber,
    shipmentstatus,
    dispatchdate,
    trackingnumber,
    shippingcompany,
    comments,
    createdon,
    createdby,
    lastmodifiedby,
    lastmodifiedon,
    salesshipmentlines,
    receivereori,
    shippereori,
    incoterm,
    natureoftransactioncode,
    totalcommercialvalue,
    numberofpackages,
    shipmentweight,
    deliveryinstruction,
    deliveryname,
    deliverystreetaddress,
    deliverystreetaddress2,
    deliverysuburb,
    deliverycity,
    deliveryregion,
    deliverycountry,
    deliverypostcode,
    customerref,
    warehouse,
    customer,
    deliverycontact,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipments;

-- SalesShipmentLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipmentlines;
CREATE VIEW {etani_client_id}_unleashed_salesshipmentlines AS
SELECT
    id AS `guid`,
    linenumber,
    shipmentqty,
    unitcost,
    unitcostattimeofdispatch,
    commercialmonetaryvalue,
    salesorderlinenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    salesshipmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipmentlines;

-- SalesShipmentsCustomer View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipmentscustomer;
CREATE VIEW {etani_client_id}_unleashed_salesshipmentscustomer AS
SELECT
    id AS `guid`,
    customercode,
    customername,
    salesshipmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipmentscustomer;

-- SalesShipmentsWarehouse View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipmentswarehouse;
CREATE VIEW {etani_client_id}_unleashed_salesshipmentswarehouse AS
SELECT
    id AS `guid`,
    warehousecode,
    warehousename,
    salesshipmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipmentswarehouse;


-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalesShipmentsShippingCompany View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipmentsshippingcompany;
CREATE VIEW {etani_client_id}_unleashed_salesshipmentsshippingcompany AS
SELECT
    id AS `guid`,
    companyname,
    salesshipmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipmentsshippingcompany;

-- SalesShipmentsDeliveryContact View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesshipmentsdeliverycontact;
CREATE VIEW {etani_client_id}_unleashed_salesshipmentsdeliverycontact AS
SELECT
    id AS `guid`,
    contactname,
    contactphone,
    contactemail,
    salesshipmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesshipmentsdeliverycontact;

-- SellPriceTiers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_sellpricetiers;
CREATE VIEW {etani_client_id}_unleashed_sellpricetiers AS
SELECT
    id AS `tier`,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_sellpricetiers;

-- ShippingCompanies View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_shippingcompanies;
CREATE VIEW {etani_client_id}_unleashed_shippingcompanies AS
SELECT
    id AS `guid`,
    name,
    obsolete,
    createdby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_shippingcompanies;

-- StockAdjustments View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_stockadjustments;
CREATE VIEW {etani_client_id}_unleashed_stockadjustments AS
SELECT
    id AS `guid`,
    adjustmentnumber,
    adjustmentdate,
    adjustmentreason,
    status,
    accountcode,
    confirmedby,
    confirmedon,
    createdby,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    warehouseisdefault AS `warehouse.isdefault`,
    warehouseobsolete AS `warehouse.obsolete`,
    stockadjustmentlines,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_stockadjustments;

-- StockAdjustmentLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_stockadjustmentlines;
CREATE VIEW {etani_client_id}_unleashed_stockadjustmentlines AS
SELECT
    id AS `guid`,
    linenumber,
    newquantity,
    newactualvalue,
    comments,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.description`,
    serialnumbers,
    batchnumbers,
    lastmodifiedon,
    stockadjustmentsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_stockadjustmentlines;

-- StockAdjSerialNumbers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_stockadjserialnumbers;
CREATE VIEW {etani_client_id}_unleashed_stockadjserialnumbers AS
SELECT
    id AS `guid`,
    identifier,
    lastmodifiedon,
    stockadjlinesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_stockadjserialnumbers;

-- StockAdjBatchNumbers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_stockadjbatchnumbers;
CREATE VIEW {etani_client_id}_unleashed_stockadjbatchnumbers AS
SELECT
    id AS `guid`,
    number,
    quantity,
    expirydate,
    lastmodifiedon,
    stockadjlinesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_stockadjbatchnumbers;

-- StockOnHand View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_stockonhand;
CREATE VIEW {etani_client_id}_unleashed_stockonhand AS
SELECT
    id AS `guid`,
    productcode,
    productdescription,
    productguid,
    productsourceid,
    productgroupname,
    warehouseid,
    warehouse,
    warehousecode,
    dayssincelastsale,
    onpurchase,
    allocatedqty,
    availableqty,
    qtyonhand,
    avgcost,
    totalcost,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_stockonhand;

-- SupplierReturnReasons View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supplierreturnreasons;
CREATE VIEW {etani_client_id}_unleashed_supplierreturnreasons AS
SELECT
    reason,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supplierreturnreasons;

-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SupplierReturns View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supplierreturns;
CREATE VIEW {etani_client_id}_unleashed_supplierreturns AS
SELECT
    id AS `guid`,
    supplierreturnnumber,
    supplierguid AS `supplier.guid`,
    suppliercode AS `supplier.suppliercode`,
    suppliername AS `supplier.suppliername`,
    purchaseorderguid AS `purchaseorder.guid`,
    purchaseordernumber AS `purchaseorder.ordernumber`,
    purchaseorderdate AS `purchaseorder.orderdate`,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.description`,
    status,
    comments,
    exchangerate,
    taxrate,
    xerotaxcode,
    supplierref,
    createdby,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    returndate,
    subtotal,
    basesubtotal,
    taxtotal,
    total,
    basereturncosttaxtotal,
    basereturncosttotal,
    basetaxtotal,
    basetotal,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supplierreturns;

-- SupplierReturnLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supplierreturnlines;
CREATE VIEW {etani_client_id}_unleashed_supplierreturnlines AS
SELECT
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    orderquantity,
    orderprice,
    returnquantity,
    returnprice,
    returncost,
    linetax,
    taxrate,
    returnreason,
    returntosupplier,
    comments,
    requireddate,
    xerotaxcode,
    supplierreturnsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supplierreturnlines;

-- SupplierReturnCosts View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supplierreturncosts;
CREATE VIEW {etani_client_id}_unleashed_supplierreturncosts AS
SELECT
    id AS `guid`,
    cost,
    taxcost,
    totalcost,
    bccost,
    bctaxcost,
    bctotalcost,
    exchangerate,
    refund,
    taxrate,
    taxcode,
    costdate,
    costsupplierguid AS `supplier.guid`,
    costsuppliercode AS `supplier.suppliercode`,
    costsuppliername AS `supplier.suppliername`,
    supplierreturnsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supplierreturncosts;

-- SupReturnProductBatches View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supreturnproductbatches;
CREATE VIEW {etani_client_id}_unleashed_supreturnproductbatches AS
SELECT
    id AS `guid`,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    batches,
    supplierreturnsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supreturnproductbatches;

-- SupReturnProductSerials View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supreturnproductserials;
CREATE VIEW {etani_client_id}_unleashed_supreturnproductserials AS
SELECT
    id AS `guid`,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    serialnumbers,
    supplierreturnsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supreturnproductserials;

-- SupReturnBatches View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supreturnbatches;
CREATE VIEW {etani_client_id}_unleashed_supreturnbatches AS
SELECT
    id AS `guid`,
    batchnumber,
    quantity,
    expirydate,
    supreturnproductbatchesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supreturnbatches;

-- Suppliers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_suppliers;
CREATE VIEW {etani_client_id}_unleashed_suppliers AS
SELECT
    id AS `guid`,
    suppliercode,
    suppliername,
    gstvatnumber,
    bankname,
    bankbranch,
    bankaccount,
    website,
    phonenumber,
    faxnumber,
    mobilenumber,
    ddinumber,
    tollfreenumber,
    purchaseordercostdistributionmethod,
    email,
    notes,
    taxable,
    xerocontactid,
    lastmodifiedon,
    obsolete,
    leadtimedays,
    taxrate,
    minimumordervalue,
    paymentterm,
    purchaseorderprinttemplate,
    supplierreturnprinttemplate,
    reminder,
    defaultwarehouseguid AS `defaultwarehouse.guid`,
    defaultwarehousecode AS `defaultwarehouse.warehousecode`,
    defaultwarehousename AS `defaultwarehouse.warehousename`,
    createdby,
    createdon,
    lastmodifiedby,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_suppliers;

-- SupplierAddresses View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_supplieraddresses;
CREATE VIEW {etani_client_id}_unleashed_supplieraddresses AS
SELECT
    id AS `guid`,
    addresstype,
    addressname,
    streetaddress,
    streetaddress2,
    suburb,
    city,
    region,
    country,
    postalcode,
    suppliersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_supplieraddresses;

-- UnitOfMeasure View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_unitofmeasure;
CREATE VIEW {etani_client_id}_unleashed_unitofmeasure AS
SELECT
    guid,
    name,
    obsolete,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_unitofmeasure;

-- Warehouse View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_warehouse;
CREATE VIEW {etani_client_id}_unleashed_warehouse AS
SELECT
    warehousecode,
    warehousename,
    isdefault,
    streetno,
    addressline1,
    addressline2,
    city,
    region,
    country,
    postcode,
    phonenumber,
    faxnumber,
    mobilenumber,
    ddinumber,
    contactname,
    obsolete,
    guid,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_warehouse;

-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WarehouseStockTransfer View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_warehousestocktransfer;
CREATE VIEW {etani_client_id}_unleashed_warehousestocktransfer AS
SELECT
    id AS `guid`,
    transferordernumber,
    orderdate,
    sourcewarehouseguid AS `sourcewarehouse.guid`,
    sourcewarehousecode AS `sourcewarehouse.warehousecode`,
    sourcewarehousename AS `sourcewarehouse.warehousename`,
    sourcewarehouseisdefault AS `sourcewarehouse.isdefault`,
    sourcewarehouseobsolete AS `sourcewarehouse.obsolete`,
    destinationwarehouseguid AS `destinationwarehouse.guid`,
    destinationwarehousecode AS `destinationwarehouse.warehousecode`,
    destinationwarehousename AS `destinationwarehouse.warehousename`,
    destinationwarehouseisdefault AS `destinationwarehouse.isdefault`,
    destinationwarehouseobsolete AS `destinationwarehouse.obsolete`,
    deliverydate,
    transferstatus,
    comments,
    createdby,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_warehousestocktransfer;

-- TransferDetails View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_transferdetails;
CREATE VIEW {etani_client_id}_unleashed_transferdetails AS
SELECT
    transferguid,
    id AS `guid`,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    orderquantity,
    serialnumber,
    batchnumber,
    expirydate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_transferdetails;

-- AttributeSet View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_attributeset;
CREATE VIEW {etani_client_id}_unleashed_attributeset AS
SELECT
    id AS `guid`,
    setname,
    type,
    attributes,
    createdby,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_attributeset;

-- BatchNumber View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_batchnumber;
CREATE VIEW {etani_client_id}_unleashed_batchnumber AS
SELECT
    id AS `guid`,
    number,
    expirydate,
    quantity,
    originalqty,
    productcode,
    warehousecode,
    status,
    lastmodifiedby,
    lastmodifiedon,
    createdby,
    createdon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_batchnumber;

-- BillOfMaterials View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_billofmaterials;
CREATE VIEW {etani_client_id}_unleashed_billofmaterials AS
SELECT
    id AS `guid`,
    billnumber,
    canautoassemble,
    canautodisassemble,
    sortbyproductcode,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    productbarcode AS `product.barcode`,
    productunitofmeasurename AS `product.unitofmeasure.name`,
    productiscomponent AS `product.iscomponent`,
    productisassembledproduct AS `product.isassembledproduct`,
    productdefaultsellprice AS `product.defaultsellprice`,
    productlastcost AS `product.lastcost`,
    totalcost,
    obsolete,
    createdon,
    createdby,
    lastmodifiedby,
    lastmodifiedon,
    assemblylayoutid,
    expectedduration,
    productionhoursperday,
    productiondaysperweek,
    durationtype,
    averageduration,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_billofmaterials;

-- BillOfMaterialLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_billofmateriallines;
CREATE VIEW {etani_client_id}_unleashed_billofmateriallines AS
SELECT
    billofmaterialsguid,
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    productunitofmeasurename AS `product.unitofmeasure.name`,
    productlastcost AS `product.lastcost`,
    quantity,
    wastagequantity,
    totallinecost,
    unitcost,
    expenseaccount,
    subbillofmaterialguid,
    createdby,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_billofmateriallines;

-- CreditNotes View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_creditnotes;
CREATE VIEW {etani_client_id}_unleashed_creditnotes AS
SELECT
    creditnumber,
    creditdate,
    salesinvoicedate,
    requireddeliverydate,
    reference,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    customerguid AS `customer.guid`,
    customercode AS `customer.customercode`,
    customername AS `customer.customername`,
    creditstatus,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.description`,
    total,
    invoicenumber,
    referencenumber,
    comments,
    taxrate,
    xerotaxcode,
    taxtotal,
    subtotal,
    taxguid AS `tax.guid`,
    taxcode AS `tax.taxcode`,
    taxdescription AS `tax.description`,
    lastmodifiedby,
    lastmodifiedon,
    createdby,
    createdon,
    salesorderguid AS `salesorder.guid`,
    salesordernumber AS `salesorder.ordernumber`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_creditnotes;

-- CreditNotesLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_creditnoteslines;
CREATE VIEW {etani_client_id}_unleashed_creditnoteslines AS
SELECT
    creditnoteguid,
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    creditquantity,
    creditprice,
    linetotal,
    linetax,
    taxrate,
    comments,
    reason,
    returntostock,
    disassemble,
    xerosalesaccount,
    xerotaxcode,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_creditnoteslines;

-- CustomerDeliveryAddress View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customerdeliveryaddress;
CREATE VIEW {etani_client_id}_unleashed_customerdeliveryaddress AS
SELECT
    id AS `customerid`,
    customercode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customerdeliveryaddress;

-- CustomerDeliveryAddresses View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customerdeliveryaddresses;
CREATE VIEW {etani_client_id}_unleashed_customerdeliveryaddresses AS
SELECT
    customerdeliveryguid,
    id AS `guid`,
    addressname,
    streetaddress,
    streetaddress2,
    suburb,
    city,
    region,
    country,
    postalcode,
    addresstype,
    deliveryinstruction,
    obsolete,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customerdeliveryaddresses;

-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Customers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customers;
CREATE VIEW {etani_client_id}_unleashed_customers AS
SELECT
    id AS `guid`,
    clientid,
    organisationid,
    bankaccount,
    bankbranch,
    bankname,
    contactfirstname,
    contactlastname,
    createdby,
    createdon,
    creditlimit,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.description`,
    customercode,
    customername,
    customertype,
    customertypeguid,
    ddinumber,
    defaultwarehouseguid AS `defaultwarehouse.guid`,
    defaultwarehousecode AS `defaultwarehouse.warehousecode`,
    defaultwarehousename AS `defaultwarehouse.warehousename`,
    deliveryinstruction,
    deliverymethod,
    discountrate,
    email,
    emailcc,
    eorinumber,
    faxnumber,
    gstvatnumber,
    hascreditlimit,
    lastmodifiedby,
    lastmodifiedon,
    mobilenumber,
    notes,
    obsolete,
    paymentterm,
    phonenumber,
    printinvoice,
    printpackingslipinsteadofinvoice,
    reminder,
    salesordergroup,
    salespersonguid AS `salesperson.guid`,
    salespersonfullname AS `salesperson.fullname`,
    salespersonemail AS `salesperson.email`,
    sellpricetier,
    sellpricetierreferenceguid AS `sellpricetierreference.guid`,
    sellpricetierreferencename AS `sellpricetierreference.tiername`,
    stopcredit,
    taxable,
    taxcode,
    taxrate,
    tollfreenumber,
    website,
    xerocostofgoodsaccount,
    xerosalesaccount,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customers;

-- CustomerAddresses View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customeraddresses;
CREATE VIEW {etani_client_id}_unleashed_customeraddresses AS
SELECT
    customerguid,
    id AS `guid`,
    addresstype,
    addressname,
    streetaddress,
    streetaddress2,
    suburb,
    city,
    region,
    country,
    postalcode,
    isdefault,
    deliveryinstruction,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customeraddresses;

-- CustomerContacts View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customercontacts;
CREATE VIEW {etani_client_id}_unleashed_customercontacts AS
SELECT
    customerguid,
    id AS `guid`,
    firstname,
    lastname,
    emailaddress,
    officephone,
    phonenumber,
    mobilephone,
    faxnumber,
    website,
    deliveryaddress,
    forinvoicing,
    forordering,
    forshipping,
    isdefault,
    notes,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customercontacts;

-- CustomerTypes View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_customertypes;
CREATE VIEW {etani_client_id}_unleashed_customertypes AS
SELECT
    id AS `guid`,
    clientid,
    organisationid,
    typename,
    lastmodifiedon,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_customertypes;

-- Invoices View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_invoices;
CREATE VIEW {etani_client_id}_unleashed_invoices AS
SELECT
    id AS `guid`,
    clientid,
    organisationid,
    invoicenumber,
    ordernumber,
    quotenumber,
    invoicedate,
    duedate,
    invoicestatus,
    customerguid AS `customer.guid`,
    customercode AS `customer.customercode`,
    customername AS `customer.customername`,
    comments,
    postaladdressname AS `postaladdress.addressname`,
    postalstreetaddress AS `postaladdress.streetaddress`,
    postalcity AS `postaladdress.city`,
    postalregion AS `postaladdress.region`,
    postalcountry AS `postaladdress.country`,
    postalpostalcode AS `postaladdress.postalcode`,
    deliveryaddressname AS `deliveryaddress.addressname`,
    deliverystreetaddress AS `deliveryaddress.streetaddress`,
    deliverycity AS `deliveryaddress.city`,
    deliveryregion AS `deliveryaddress.region`,
    deliverycountry AS `deliveryaddress.country`,
    deliverypostalcode AS `deliveryaddress.postalcode`,
    deliveryinstruction,
    exchangerate,
    subtotal,
    taxtotal,
    total,
    bcsubtotal,
    bctaxtotal,
    bctotal,
    createdby,
    paymentterm,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.description`,
    paymentreceived,
    lastmodifiedon,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_invoices;

-- InvoiceLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_invoicelines;
CREATE VIEW {etani_client_id}_unleashed_invoicelines AS
SELECT
    invoiceguid,
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    invoicequantity,
    invoiceprice,
    linetotal,
    linetax,
    taxrate,
    comments,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    orderlineguid AS `orderline.guid`,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_invoicelines;

-- PaymentTerms View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_paymentterms;
CREATE VIEW {etani_client_id}_unleashed_paymentterms AS
SELECT
    id AS `guid`,
    type,
    days,
    obsolete,
    paymenttermdescription,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_paymentterms;

-- ProductGroups View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_productgroups;
CREATE VIEW {etani_client_id}_unleashed_productgroups AS
SELECT
    id AS `guid`,
    groupname,
    parentgroupguid,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_productgroups;

-- ProductPrice View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_productprice;
CREATE VIEW {etani_client_id}_unleashed_productprice AS
SELECT
    id AS `guid`,
    product,
    productgroup,
    customer,
    pricetype,
    discountvalue,
    minimumquantity,
    defaultsellprice,
    customerprice,
    validfrom,
    validto,
    comments,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_productprice;

-- Product View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_product;
CREATE VIEW {etani_client_id}_unleashed_product AS
SELECT
    id AS `guid`,
    productcode,
    productdescription,
    barcode,
    packsize,
    width,
    height,
    depth,
    weight,
    minstockalertlevel,
    maxstockalertlevel,
    reorderpoint,
    unitofmeasureguid AS `unitofmeasure.guid`,
    unitofmeasurename AS `unitofmeasure.name`,
    neverdiminishing,
    lastcost,
    defaultpurchaseprice,
    defaultpurchasesunitofmeasureguid AS `defaultpurchasesunitofmeasure.guid`,
    defaultpurchasesunitofmeasurename AS `defaultpurchasesunitofmeasure.name`,
    defaultsellprice,
    customersellprice,
    averagelandprice,
    obsolete,
    notes,
    imageurl,
    sellpricetier1,
    sellpricetier2,
    sellpricetier3,
    sellpricetier4,
    sellpricetier5,
    sellpricetier6,
    sellpricetier7,
    sellpricetier8,
    sellpricetier9,
    sellpricetier10,
    xerotaxcode,
    xerotaxrate,
    taxablepurchase,
    taxablesales,
    xerosalestaxcode,
    xerosalestaxrate,
    iscomponent,
    isassembledproduct,
    productgroupguid AS `productgroup.guid`,
    productgroupname AS `productgroup.groupname`,
    productsubgroupguid AS `productsubgroup.guid`,
    productsubgroupname AS `productsubgroup.groupname`,
    productbrandguid AS `productbrand.guid`,
    productbrandname AS `productbrand.brandname`,
    xerosalesaccount,
    xerocostofgoodsaccount,
    purchaseaccount,
    binlocation,
    supplierguid AS `supplier.guid`,
    suppliercode AS `supplier.suppliercode`,
    suppliername AS `supplier.suppliername`,
    supplierproductcode AS `supplier.supplierproductcode`,
    sourceid,
    sourcevariantparentid,
    isserialized,
    isbatchtracked,
    ispurchasable,
    issellable,
    minimumsellprice,
    minimumsalequantity,
    minimumorderquantity,
    nominalcost,
    createdby,
    createdon,
    lastmodifiedby,
    commercecode,
    customsdescription,
    supplementaryclassificationabbreviation,
    icccountrycode,
    icccountryname,
    automaticchargecost,
    comments,
    copycommentsforsales,
    copycommentsforpurchases,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_product;

-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProductImages View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_productimages;
CREATE VIEW {etani_client_id}_unleashed_productimages AS
SELECT
    productguid,
    imageurl AS `url`,
    isdefault,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_productimages;

-- ProductInventoryDetails View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_productinventorydetails;
CREATE VIEW {etani_client_id}_unleashed_productinventorydetails AS
SELECT
    productguid,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    binlocation,
    warehouseminstockalertlevel,
    warehousemaxstockalertlevel,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_productinventorydetails;

-- ProductAlternateUnits View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_productalternateunits;
CREATE VIEW {etani_client_id}_unleashed_productalternateunits AS
SELECT
    productguid,
    id AS `guid`,
    unitname AS `name`,
    conversionrate,
    forpurchases,
    barcode,
    packsize,
    weight,
    width,
    height,
    depth,
    cubictotal,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_productalternateunits;

-- PurchaseOrder View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_purchaseorder;
CREATE VIEW {etani_client_id}_unleashed_purchaseorder AS
SELECT
    id AS `guid`,
    ordernumber,
    orderdate,
    completeddate,
    supplierguid AS `supplier.guid`,
    suppliercode AS `supplier.suppliercode`,
    suppliername AS `supplier.suppliername`,
    supplierref,
    comments,
    printed,
    orderstatus,
    customorderstatus,
    receiveddate,
    deliveryname,
    deliverystreetaddress,
    deliverystreetaddress2,
    deliverysuburb,
    deliveryregion,
    deliverycity,
    deliverycountry,
    deliverypostcode,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.currencydescription`,
    exchangerate,
    taxguid AS `tax.guid`,
    taxtaxcode AS `tax.taxcode`,
    taxtaxrate AS `tax.taxrate`,
    taxrate,
    taxcode,
    subtotal,
    taxtotal,
    total,
    totalvolume,
    totalweight,
    supplierinvoicedate,
    bcsubtotal,
    bctaxtotal,
    bctotal,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    lastmodifiedon,
    discountrate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_purchaseorder;

-- PurchaseOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_purchaseorderlines;
CREATE VIEW {etani_client_id}_unleashed_purchaseorderlines AS
SELECT
    purchaseorderid,
    id AS `guid`,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    orderquantity,
    receivedquantity,
    unitprice,
    linetotal,
    unitofmeasureguid AS `unitofmeasure.guid`,
    unitofmeasurename AS `unitofmeasure.name`,
    duedate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_purchaseorderlines;

-- SalesOrderGroup View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesordergroup;
CREATE VIEW {etani_client_id}_unleashed_salesordergroup AS
SELECT
    id AS `guid`,
    name,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesordergroup;

-- SalesOrder View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesorder;
CREATE VIEW {etani_client_id}_unleashed_salesorder AS
SELECT
    id AS `guid`,
    ordernumber,
    orderdate,
    requireddate,
    completeddate,
    orderstatus,
    customerguid AS `customer.guid`,
    customercode AS `customer.customercode`,
    customername AS `customer.customername`,
    customerref,
    comments,
    warehouseguid AS `warehouse.guid`,
    warehousecode AS `warehouse.warehousecode`,
    warehousename AS `warehouse.warehousename`,
    receiveddate,
    deliverycontactfirstname AS `deliverycontact.firstname`,
    deliverycontactlastname AS `deliverycontact.lastname`,
    deliverycontactemail AS `deliverycontact.emailaddress`,
    deliverycontactphone AS `deliverycontact.phonenumber`,
    deliveryinstruction,
    deliveryname,
    deliverystreetaddress,
    deliverystreetaddress2,
    deliverysuburb,
    deliverycity,
    deliveryregion,
    deliverycountry,
    deliverypostcode,
    currencyguid AS `currency.guid`,
    currencycode AS `currency.currencycode`,
    currencydescription AS `currency.description`,
    exchangerate,
    discountrate,
    taxguid AS `tax.guid`,
    taxtaxcode AS `tax.taxcode`,
    taxtaxrate AS `tax.taxrate`,
    taxrate,
    xerotaxcode,
    subtotal,
    taxtotal,
    total,
    totalvolume,
    totalweight,
    bcsubtotal,
    bctaxtotal,
    bctotal,
    paymentduedate,
    allocateproduct,
    salesordergroup,
    deliverymethod,
    salespersonguid AS `salesperson.guid`,
    salespersonfullname AS `salesperson.fullname`,
    salespersonemail AS `salesperson.email`,
    sendaccountingjournalonly,
    sourceid,
    createdby,
    customorderstatus,
    createdon,
    lastmodifiedby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesorder;

-- SalesOrderLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesorderlines;
CREATE VIEW {etani_client_id}_unleashed_salesorderlines AS
SELECT
    salesorderid,
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    orderquantity,
    unitprice,
    discountrate,
    linetotal,
    linetax,
    taxrate,
    unitofmeasureguid AS `unitofmeasure.guid`,
    unitofmeasurename AS `unitofmeasure.name`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesorderlines;

-- Salespersons View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salespersons;
CREATE VIEW {etani_client_id}_unleashed_salespersons AS
SELECT
    id AS `guid`,
    fullname,
    email,
    obsolete,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salespersons;

-- SalesQuotes View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotes;
CREATE VIEW {etani_client_id}_unleashed_salesquotes AS
SELECT
    id AS `guid`,
    quotenumber,
    quotedate,
    quoteexpirydate,
    accepteddate,
    quotestatus,
    customerref,
    comments,
    deliveryname,
    deliverystreetaddress,
    deliverystreetaddress2,
    deliverysuburb,
    deliverycity,
    deliveryregion,
    deliverycountry,
    deliverypostcode,
    exchangerate,
    discountrate,
    taxrate,
    xerotaxcode,
    subtotal,
    taxtotal,
    total,
    totalvolume,
    totalweight,
    bcsubtotal,
    bctaxtotal,
    bctotal,
    salesordergroup,
    deliverymethod,
    sourceid,
    createdby,
    lastmodifiedon,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotes;

-- Pattern: {etani_client_id}_unleashed_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalesQuoteCustomers View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotecustomers;
CREATE VIEW {etani_client_id}_unleashed_salesquotecustomers AS
SELECT
    salesquoteid,
    id AS `guid`,
    customercode,
    customername,
    currencyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotecustomers;

-- SalesQuoteWarehouses View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotewarehouses;
CREATE VIEW {etani_client_id}_unleashed_salesquotewarehouses AS
SELECT
    salesquoteid,
    id AS `guid`,
    warehousecode,
    warehousename,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotewarehouses;

-- SalesQuoteCurrencies View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotecurrencies;
CREATE VIEW {etani_client_id}_unleashed_salesquotecurrencies AS
SELECT
    salesquoteid,
    id AS `guid`,
    currencycode,
    description,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotecurrencies;

-- SalesQuoteTaxes View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotetaxes;
CREATE VIEW {etani_client_id}_unleashed_salesquotetaxes AS
SELECT
    salesquoteid,
    id AS `guid`,
    taxcode,
    taxrate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotetaxes;

-- SalesQuoteSalespersons View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotesalespersons;
CREATE VIEW {etani_client_id}_unleashed_salesquotesalespersons AS
SELECT
    salesquoteid,
    id AS `guid`,
    fullname,
    email,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotesalespersons;

-- SalesQuoteLines View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquotelines;
CREATE VIEW {etani_client_id}_unleashed_salesquotelines AS
SELECT
    salesquoteid,
    id AS `guid`,
    linenumber,
    productguid AS `product.guid`,
    productcode AS `product.productcode`,
    productdescription AS `product.productdescription`,
    quotequantity,
    unitprice,
    discountrate,
    linetotal,
    unitcost,
    taxrate,
    linetax,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquotelines;

-- SalesQuoteOrders View
DROP VIEW IF EXISTS {etani_client_id}_unleashed_salesquoteorders;
CREATE VIEW {etani_client_id}_unleashed_salesquoteorders AS
SELECT
    salesquoteid,
    id AS `guid`,
    ordernumber,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_unleashed_salesquoteorders;