-- UNLEASHED Production Tables - Auto Generated
-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_companies;
CREATE TABLE c{clientID}_unleashed_companies (
    id VARCHAR(255) NOT NULL,
    companyname VARCHAR(255),
    basecurrencycode VARCHAR(10),
    defaulttaxrate DECIMAL(10,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Assemblies Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_assemblies;
CREATE TABLE c{clientID}_unleashed_assemblies (
    id VARCHAR(255) NOT NULL,
    assemblynumber VARCHAR(255),
    assemblydate DATETIME,
    assemblytype VARCHAR(255),
    assemblystatus VARCHAR(255),
    customassemblystatus VARCHAR(255),
    autoassembly BOOLEAN,
    quantity DECIMAL(18,6),
    assembleby DATETIME,
    comments TEXT,
    canassemblequantity DECIMAL(10,2),
    batchnumbers JSON,
    serialnumbers JSON,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    assemblylines JSON,
    suppliercosts JSON,
    sourcewarehouseguid VARCHAR(255),
    sourcewarehousecode VARCHAR(15),
    sourcewarehousename VARCHAR(100),
    destinationwarehouseguid VARCHAR(255),
    destinationwarehousecode VARCHAR(15),
    destinationwarehousename VARCHAR(100),
    total DECIMAL(15,2),
    totalcost DECIMAL(15,2),
    disassemblecosttotal DECIMAL(15,2),
    suppliercoststax DECIMAL(15,2),
    suppliercostssubtotal DECIMAL(15,2),
    salesordernumber VARCHAR(255),
    expectedduration VARCHAR(50),
    actualduration VARCHAR(50),
    estimatedstartdate DATETIME,
    durationcomments TEXT,
    productionpersonguid VARCHAR(255),
    productionpersonfullname VARCHAR(256),
    productionpersonemail VARCHAR(256),
    lastmodifiedby VARCHAR(255),
    createdby VARCHAR(255),
    createdon DATETIME,
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AssemblyLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_assemblylines;
CREATE TABLE c{clientID}_unleashed_assemblylines (
    id VARCHAR(255) NOT NULL,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    quantity DECIMAL(18,6),
    wastagequantity DECIMAL(18,6),
    unitcost DECIMAL(15,2),
    totalcost DECIMAL(15,2),
    assembliesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AssemblySupplierCosts Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_assemblysuppliercosts;
CREATE TABLE c{clientID}_unleashed_assemblysuppliercosts (
    id VARCHAR(255) NOT NULL,
    supplierguid VARCHAR(255),
    suppliercode VARCHAR(500),
    cost DECIMAL(15,2),
    currencycode VARCHAR(3),
    taxrate DECIMAL(5,2),
    assembliesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AssemblyBatchNumbers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_assemblybatchnumbers;
CREATE TABLE c{clientID}_unleashed_assemblybatchnumbers (
    id VARCHAR(255) NOT NULL,
    batchnumber VARCHAR(50),
    quantity DECIMAL(18,6),
    expirydate DATETIME,
    assembliesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AssemblySerialNumbers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_assemblyserialnumbers;
CREATE TABLE c{clientID}_unleashed_assemblyserialnumbers (
    id VARCHAR(255) NOT NULL,
    serialnumber VARCHAR(50),
    assembliesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesShipments Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipments;
CREATE TABLE c{clientID}_unleashed_salesshipments (
    id VARCHAR(255) NOT NULL,
    ordernumber VARCHAR(255),
    orderguid VARCHAR(255),
    shipmentnumber VARCHAR(255),
    shipmentstatus VARCHAR(255),
    dispatchdate DATETIME,
    trackingnumber VARCHAR(255),
    shippingcompany VARCHAR(255),
    comments TEXT,
    createdon DATETIME,
    createdby VARCHAR(255),
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    salesshipmentlines JSON,
    receivereori VARCHAR(255),
    shippereori VARCHAR(255),
    incoterm VARCHAR(255),
    natureoftransactioncode VARCHAR(255),
    totalcommercialvalue DECIMAL(18,2),
    numberofpackages INT,
    shipmentweight VARCHAR(255),
    deliveryinstruction VARCHAR(255),
    deliveryname VARCHAR(255),
    deliverystreetaddress VARCHAR(255),
    deliverystreetaddress2 VARCHAR(255),
    deliverysuburb VARCHAR(255),
    deliverycity VARCHAR(255),
    deliveryregion VARCHAR(255),
    deliverycountry VARCHAR(255),
    deliverypostcode VARCHAR(255),
    customerref VARCHAR(255),
    warehouse JSON,
    customer JSON,
    deliverycontact JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesShipmentLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipmentlines;
CREATE TABLE c{clientID}_unleashed_salesshipmentlines (
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    shipmentqty DECIMAL(18,6),
    unitcost DECIMAL(15,2),
    unitcostattimeofdispatch DECIMAL(15,2),
    commercialmonetaryvalue DECIMAL(15,2),
    salesorderlinenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    salesshipmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesShipmentsCustomer Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipmentscustomer;
CREATE TABLE c{clientID}_unleashed_salesshipmentscustomer (
    id VARCHAR(255) NOT NULL,
    customercode VARCHAR(255),
    customername VARCHAR(500),
    salesshipmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesShipmentsWarehouse Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipmentswarehouse;
CREATE TABLE c{clientID}_unleashed_salesshipmentswarehouse (
    id VARCHAR(255) NOT NULL,
    warehousecode VARCHAR(255),
    warehousename VARCHAR(500),
    salesshipmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalesShipmentsShippingCompany Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipmentsshippingcompany;
CREATE TABLE c{clientID}_unleashed_salesshipmentsshippingcompany (
    id VARCHAR(255) NOT NULL,
    companyname VARCHAR(500),
    salesshipmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesShipmentsDeliveryContact Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesshipmentsdeliverycontact;
CREATE TABLE c{clientID}_unleashed_salesshipmentsdeliverycontact (
    id VARCHAR(255) NOT NULL,
    contactname VARCHAR(500),
    contactphone VARCHAR(255),
    contactemail VARCHAR(255),
    salesshipmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SellPriceTiers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_sellpricetiers;
CREATE TABLE c{clientID}_unleashed_sellpricetiers (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ShippingCompanies Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_shippingcompanies;
CREATE TABLE c{clientID}_unleashed_shippingcompanies (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    obsolete BOOLEAN,
    createdby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockAdjustments Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_stockadjustments;
CREATE TABLE c{clientID}_unleashed_stockadjustments (
    id VARCHAR(255) NOT NULL,
    adjustmentnumber VARCHAR(20),
    adjustmentdate DATETIME,
    adjustmentreason VARCHAR(20),
    status VARCHAR(20),
    accountcode VARCHAR(50),
    confirmedby VARCHAR(50),
    confirmedon DATETIME,
    createdby VARCHAR(256),
    createdon DATETIME,
    lastmodifiedby VARCHAR(50),
    lastmodifiedon DATETIME,
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(15),
    warehousename VARCHAR(100),
    warehouseisdefault BOOLEAN,
    warehouseobsolete BOOLEAN,
    stockadjustmentlines JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockAdjustmentLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_stockadjustmentlines;
CREATE TABLE c{clientID}_unleashed_stockadjustmentlines (
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    newquantity DECIMAL(18,6),
    newactualvalue DECIMAL(15,2),
    comments VARCHAR(200),
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    serialnumbers JSON,
    batchnumbers JSON,
    lastmodifiedon DATETIME,
    stockadjustmentsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockAdjSerialNumbers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_stockadjserialnumbers;
CREATE TABLE c{clientID}_unleashed_stockadjserialnumbers (
    id VARCHAR(255) NOT NULL,
    identifier VARCHAR(50),
    lastmodifiedon DATETIME,
    stockadjlinesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockAdjBatchNumbers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_stockadjbatchnumbers;
CREATE TABLE c{clientID}_unleashed_stockadjbatchnumbers (
    id VARCHAR(255) NOT NULL,
    number VARCHAR(50),
    quantity DECIMAL(18,6),
    expirydate DATETIME,
    lastmodifiedon DATETIME,
    stockadjlinesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockOnHand Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_stockonhand;
CREATE TABLE c{clientID}_unleashed_stockonhand (
    id VARCHAR(255) NOT NULL,
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    productguid VARCHAR(255),
    productsourceid VARCHAR(500),
    productgroupname VARCHAR(450),
    warehouseid VARCHAR(255),
    warehouse VARCHAR(100),
    warehousecode VARCHAR(15),
    dayssincelastsale INT,
    onpurchase DECIMAL(18,4),
    allocatedqty DECIMAL(18,4),
    availableqty DECIMAL(18,4),
    qtyonhand DECIMAL(18,4),
    avgcost DECIMAL(18,4),
    totalcost DECIMAL(18,4),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupplierReturnReasons Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supplierreturnreasons;
CREATE TABLE c{clientID}_unleashed_supplierreturnreasons (
    reason VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reason)
);

-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SupplierReturns Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supplierreturns;
CREATE TABLE c{clientID}_unleashed_supplierreturns (
    id VARCHAR(255) NOT NULL,
    supplierreturnnumber VARCHAR(20),
    supplierguid VARCHAR(255),
    suppliercode VARCHAR(500),
    suppliername VARCHAR(500),
    purchaseorderguid VARCHAR(255),
    purchaseordernumber VARCHAR(20),
    purchaseorderdate DATETIME,
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(15),
    warehousename VARCHAR(100),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(3),
    currencydescription VARCHAR(200),
    status VARCHAR(20),
    comments VARCHAR(1024),
    exchangerate DECIMAL(18,6),
    taxrate DECIMAL(18,6),
    xerotaxcode VARCHAR(50),
    supplierref VARCHAR(500),
    createdby VARCHAR(50),
    createdon DATETIME,
    lastmodifiedby VARCHAR(50),
    lastmodifiedon DATETIME,
    returndate DATETIME,
    subtotal DECIMAL(18,2),
    basesubtotal DECIMAL(18,2),
    taxtotal DECIMAL(18,2),
    total DECIMAL(18,2),
    basereturncosttaxtotal DECIMAL(18,2),
    basereturncosttotal DECIMAL(18,2),
    basetaxtotal DECIMAL(18,2),
    basetotal DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupplierReturnLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supplierreturnlines;
CREATE TABLE c{clientID}_unleashed_supplierreturnlines (
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    orderquantity DECIMAL(18,6),
    orderprice DECIMAL(18,6),
    returnquantity DECIMAL(18,6),
    returnprice DECIMAL(18,6),
    returncost DECIMAL(18,6),
    linetax DECIMAL(18,6),
    taxrate DECIMAL(18,6),
    returnreason VARCHAR(25),
    returntosupplier BOOLEAN,
    comments VARCHAR(1024),
    requireddate DATETIME,
    xerotaxcode VARCHAR(50),
    supplierreturnsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupplierReturnCosts Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supplierreturncosts;
CREATE TABLE c{clientID}_unleashed_supplierreturncosts (
    id VARCHAR(255) NOT NULL,
    cost DECIMAL(18,6),
    taxcost DECIMAL(18,6),
    totalcost DECIMAL(18,6),
    bccost DECIMAL(18,6),
    bctaxcost DECIMAL(18,6),
    bctotalcost DECIMAL(18,6),
    exchangerate DECIMAL(18,6),
    refund BOOLEAN,
    taxrate DECIMAL(18,6),
    taxcode VARCHAR(50),
    costdate DATETIME,
    costsupplierguid VARCHAR(255),
    costsuppliercode VARCHAR(500),
    costsuppliername VARCHAR(500),
    supplierreturnsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupReturnProductBatches Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supreturnproductbatches;
CREATE TABLE c{clientID}_unleashed_supreturnproductbatches (
    id VARCHAR(255) NOT NULL,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    batches JSON,
    supplierreturnsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupReturnProductSerials Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supreturnproductserials;
CREATE TABLE c{clientID}_unleashed_supreturnproductserials (
    id VARCHAR(255) NOT NULL,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    serialnumbers JSON,
    supplierreturnsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupReturnBatches Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supreturnbatches;
CREATE TABLE c{clientID}_unleashed_supreturnbatches (
    id VARCHAR(255) NOT NULL,
    batchnumber VARCHAR(50),
    quantity DECIMAL(18,6),
    expirydate DATETIME,
    supreturnproductbatchesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Suppliers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_suppliers;
CREATE TABLE c{clientID}_unleashed_suppliers (
    id VARCHAR(255) NOT NULL,
    suppliercode VARCHAR(500),
    suppliername VARCHAR(500),
    gstvatnumber VARCHAR(255),
    bankname VARCHAR(500),
    bankbranch VARCHAR(500),
    bankaccount VARCHAR(500),
    website VARCHAR(500),
    phonenumber VARCHAR(500),
    faxnumber VARCHAR(500),
    mobilenumber VARCHAR(500),
    ddinumber VARCHAR(500),
    tollfreenumber VARCHAR(500),
    purchaseordercostdistributionmethod VARCHAR(15),
    email VARCHAR(500),
    notes VARCHAR(1024),
    taxable BOOLEAN,
    xerocontactid VARCHAR(255),
    lastmodifiedon DATETIME,
    obsolete BOOLEAN,
    leadtimedays INT,
    taxrate DECIMAL(18,6),
    minimumordervalue DECIMAL(18,2),
    paymentterm VARCHAR(100),
    purchaseorderprinttemplate VARCHAR(50),
    supplierreturnprinttemplate VARCHAR(50),
    reminder VARCHAR(1024),
    defaultwarehouseguid VARCHAR(255),
    defaultwarehousecode VARCHAR(15),
    defaultwarehousename VARCHAR(100),
    createdby VARCHAR(256),
    createdon DATETIME,
    lastmodifiedby VARCHAR(50),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupplierAddresses Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_supplieraddresses;
CREATE TABLE c{clientID}_unleashed_supplieraddresses (
    id VARCHAR(255) NOT NULL,
    addresstype VARCHAR(20),
    addressname VARCHAR(500),
    streetaddress VARCHAR(500),
    streetaddress2 VARCHAR(500),
    suburb VARCHAR(500),
    city VARCHAR(500),
    region VARCHAR(500),
    country VARCHAR(100),
    postalcode VARCHAR(500),
    suppliersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- UnitOfMeasure Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_unitofmeasure;
CREATE TABLE c{clientID}_unleashed_unitofmeasure (
    guid VARCHAR(255),
    name VARCHAR(255),
    obsolete BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (guid)
);

-- Warehouse Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_warehouse;
CREATE TABLE c{clientID}_unleashed_warehouse (
    warehousecode VARCHAR(255),
    warehousename VARCHAR(255),
    isdefault BOOLEAN,
    streetno VARCHAR(255),
    addressline1 VARCHAR(255),
    addressline2 VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    country VARCHAR(255),
    postcode VARCHAR(255),
    phonenumber VARCHAR(255),
    faxnumber VARCHAR(255),
    mobilenumber VARCHAR(255),
    ddinumber VARCHAR(255),
    contactname VARCHAR(255),
    obsolete BOOLEAN,
    guid VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (guid)
);

-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WarehouseStockTransfer Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_warehousestocktransfer;
CREATE TABLE c{clientID}_unleashed_warehousestocktransfer (
    id VARCHAR(255) NOT NULL,
    transferordernumber VARCHAR(20),
    orderdate DATETIME,
    sourcewarehouseguid VARCHAR(255),
    sourcewarehousecode VARCHAR(15),
    sourcewarehousename VARCHAR(100),
    sourcewarehouseisdefault BOOLEAN,
    sourcewarehouseobsolete BOOLEAN,
    destinationwarehouseguid VARCHAR(255),
    destinationwarehousecode VARCHAR(15),
    destinationwarehousename VARCHAR(100),
    destinationwarehouseisdefault BOOLEAN,
    destinationwarehouseobsolete BOOLEAN,
    deliverydate DATETIME,
    transferstatus VARCHAR(20),
    comments VARCHAR(1024),
    createdby VARCHAR(255),
    createdon DATETIME,
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TransferDetails Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_transferdetails;
CREATE TABLE c{clientID}_unleashed_transferdetails (
    transferguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    orderquantity DECIMAL(18,4),
    serialnumber VARCHAR(100),
    batchnumber VARCHAR(100),
    expirydate DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (transferguid, id)
);

-- AttributeSet Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_attributeset;
CREATE TABLE c{clientID}_unleashed_attributeset (
    id VARCHAR(255) NOT NULL,
    setname VARCHAR(255),
    type VARCHAR(255),
    attributes JSON,
    createdby VARCHAR(255),
    createdon DATETIME,
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BatchNumber Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_batchnumber;
CREATE TABLE c{clientID}_unleashed_batchnumber (
    id VARCHAR(255) NOT NULL,
    number VARCHAR(255),
    expirydate DATETIME,
    quantity DECIMAL(18,2),
    originalqty VARCHAR(255),
    productcode VARCHAR(255),
    warehousecode VARCHAR(255),
    status VARCHAR(255),
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    createdby VARCHAR(255),
    createdon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BillOfMaterials Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_billofmaterials;
CREATE TABLE c{clientID}_unleashed_billofmaterials (
    id VARCHAR(255) NOT NULL,
    billnumber VARCHAR(255),
    canautoassemble BOOLEAN,
    canautodisassemble BOOLEAN,
    sortbyproductcode BOOLEAN,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    productbarcode VARCHAR(100),
    productunitofmeasurename VARCHAR(50),
    productiscomponent BOOLEAN,
    productisassembledproduct BOOLEAN,
    productdefaultsellprice DECIMAL(18,2),
    productlastcost DECIMAL(18,2),
    totalcost DECIMAL(18,2),
    obsolete BOOLEAN,
    createdon DATETIME,
    createdby VARCHAR(255),
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    assemblylayoutid VARCHAR(255),
    expectedduration VARCHAR(255),
    productionhoursperday INT,
    productiondaysperweek VARCHAR(255),
    durationtype VARCHAR(255),
    averageduration VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BillOfMaterialLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_billofmateriallines;
CREATE TABLE c{clientID}_unleashed_billofmateriallines (
    billofmaterialsguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    productunitofmeasurename VARCHAR(50),
    productlastcost DECIMAL(18,2),
    quantity DECIMAL(18,4) NOT NULL,
    wastagequantity DECIMAL(18,4),
    totallinecost DECIMAL(18,2),
    unitcost DECIMAL(18,2),
    expenseaccount VARCHAR(500),
    subbillofmaterialguid VARCHAR(255),
    createdby VARCHAR(255),
    createdon DATETIME,
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (billofmaterialsguid, id)
);

-- CreditNotes Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_creditnotes;
CREATE TABLE c{clientID}_unleashed_creditnotes (
    creditnumber VARCHAR(255) NOT NULL,
    creditdate DATETIME,
    salesinvoicedate DATETIME,
    requireddeliverydate DATETIME,
    reference VARCHAR(255),
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(15),
    warehousename VARCHAR(100),
    customerguid VARCHAR(255),
    customercode VARCHAR(500),
    customername VARCHAR(500),
    creditstatus VARCHAR(255),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(3),
    currencydescription VARCHAR(200),
    total DECIMAL(18,4),
    invoicenumber VARCHAR(255),
    referencenumber VARCHAR(255),
    comments TEXT,
    taxrate DECIMAL(18,4),
    xerotaxcode VARCHAR(255),
    taxtotal DECIMAL(18,4),
    subtotal DECIMAL(18,4),
    taxguid VARCHAR(255),
    taxcode VARCHAR(25),
    taxdescription VARCHAR(50),
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    createdby VARCHAR(255),
    createdon DATETIME,
    salesorderguid VARCHAR(255),
    salesordernumber VARCHAR(20),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (creditnumber)
);

-- CreditNotesLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_creditnoteslines;
CREATE TABLE c{clientID}_unleashed_creditnoteslines (
    creditnoteguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    creditquantity DECIMAL(18,4),
    creditprice DECIMAL(18,4),
    linetotal DECIMAL(18,4),
    linetax DECIMAL(18,4),
    taxrate DECIMAL(18,4),
    comments VARCHAR(1024),
    reason VARCHAR(100),
    returntostock BOOLEAN,
    disassemble BOOLEAN,
    xerosalesaccount VARCHAR(255),
    xerotaxcode VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (creditnoteguid, id)
);

-- CustomerDeliveryAddress Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customerdeliveryaddress;
CREATE TABLE c{clientID}_unleashed_customerdeliveryaddress (
    id VARCHAR(255) NOT NULL,
    customercode VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerDeliveryAddresses Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customerdeliveryaddresses;
CREATE TABLE c{clientID}_unleashed_customerdeliveryaddresses (
    customerdeliveryguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    addressname VARCHAR(255),
    streetaddress VARCHAR(500),
    streetaddress2 VARCHAR(500),
    suburb VARCHAR(255),
    city VARCHAR(255),
    region VARCHAR(255),
    country VARCHAR(255),
    postalcode VARCHAR(50),
    addresstype VARCHAR(100),
    deliveryinstruction VARCHAR(500),
    obsolete BOOLEAN,
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customerdeliveryguid, id)
);

-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Customers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customers;
CREATE TABLE c{clientID}_unleashed_customers (
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    bankaccount VARCHAR(500),
    bankbranch VARCHAR(500),
    bankname VARCHAR(500),
    contactfirstname VARCHAR(500),
    contactlastname VARCHAR(500),
    createdby VARCHAR(50),
    createdon DATETIME,
    creditlimit DECIMAL(18,4),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(3),
    currencydescription VARCHAR(200),
    customercode VARCHAR(500),
    customername VARCHAR(500),
    customertype VARCHAR(50),
    customertypeguid VARCHAR(255),
    ddinumber VARCHAR(500),
    defaultwarehouseguid VARCHAR(255),
    defaultwarehousecode VARCHAR(15),
    defaultwarehousename VARCHAR(100),
    deliveryinstruction VARCHAR(500),
    deliverymethod VARCHAR(50),
    discountrate DECIMAL(18,4),
    email VARCHAR(500),
    emailcc VARCHAR(500),
    eorinumber VARCHAR(20),
    faxnumber VARCHAR(500),
    gstvatnumber VARCHAR(500),
    hascreditlimit BOOLEAN,
    lastmodifiedby VARCHAR(50),
    lastmodifiedon DATETIME,
    mobilenumber VARCHAR(500),
    notes VARCHAR(1024),
    obsolete BOOLEAN,
    paymentterm VARCHAR(100),
    phonenumber VARCHAR(500),
    printinvoice BOOLEAN,
    printpackingslipinsteadofinvoice BOOLEAN,
    reminder VARCHAR(1024),
    salesordergroup VARCHAR(50),
    salespersonguid VARCHAR(255),
    salespersonfullname VARCHAR(256),
    salespersonemail VARCHAR(256),
    sellpricetier VARCHAR(25),
    sellpricetierreferenceguid VARCHAR(255),
    sellpricetierreferencename VARCHAR(100),
    stopcredit BOOLEAN,
    taxable BOOLEAN,
    taxcode VARCHAR(50),
    taxrate DECIMAL(18,6),
    tollfreenumber VARCHAR(500),
    website VARCHAR(500),
    xerocostofgoodsaccount VARCHAR(500),
    xerosalesaccount VARCHAR(500),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerAddresses Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customeraddresses;
CREATE TABLE c{clientID}_unleashed_customeraddresses (
    customerguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    addresstype VARCHAR(20),
    addressname VARCHAR(500),
    streetaddress VARCHAR(500),
    streetaddress2 VARCHAR(500),
    suburb VARCHAR(500),
    city VARCHAR(500),
    region VARCHAR(500),
    country VARCHAR(500),
    postalcode VARCHAR(500),
    isdefault BOOLEAN,
    deliveryinstruction VARCHAR(500),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customerguid, id)
);

-- CustomerContacts Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customercontacts;
CREATE TABLE c{clientID}_unleashed_customercontacts (
    customerguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    firstname VARCHAR(500),
    lastname VARCHAR(500),
    emailaddress VARCHAR(500),
    officephone VARCHAR(500),
    phonenumber VARCHAR(500),
    mobilephone VARCHAR(500),
    faxnumber VARCHAR(500),
    website VARCHAR(500),
    deliveryaddress VARCHAR(500),
    forinvoicing BOOLEAN,
    forordering BOOLEAN,
    forshipping BOOLEAN,
    isdefault BOOLEAN,
    notes VARCHAR(1024),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customerguid, id)
);

-- CustomerTypes Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_customertypes;
CREATE TABLE c{clientID}_unleashed_customertypes (
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    typename VARCHAR(255),
    lastmodifiedon DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Invoices Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_invoices;
CREATE TABLE c{clientID}_unleashed_invoices (
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    invoicenumber VARCHAR(255),
    ordernumber VARCHAR(255),
    quotenumber VARCHAR(255),
    invoicedate DATETIME,
    duedate DATETIME,
    invoicestatus VARCHAR(50),
    customerguid VARCHAR(255),
    customercode VARCHAR(500),
    customername VARCHAR(500),
    comments TEXT,
    postaladdressname VARCHAR(500),
    postalstreetaddress VARCHAR(500),
    postalcity VARCHAR(500),
    postalregion VARCHAR(500),
    postalcountry VARCHAR(500),
    postalpostalcode VARCHAR(500),
    deliveryaddressname VARCHAR(500),
    deliverystreetaddress VARCHAR(500),
    deliverycity VARCHAR(500),
    deliveryregion VARCHAR(500),
    deliverycountry VARCHAR(500),
    deliverypostalcode VARCHAR(500),
    deliveryinstruction VARCHAR(500),
    exchangerate DECIMAL(18,6),
    subtotal DECIMAL(18,3),
    taxtotal DECIMAL(18,3),
    total DECIMAL(18,3),
    bcsubtotal DECIMAL(18,3),
    bctaxtotal DECIMAL(18,3),
    bctotal DECIMAL(18,3),
    createdby VARCHAR(255),
    paymentterm VARCHAR(100),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(3),
    currencydescription VARCHAR(200),
    paymentreceived BOOLEAN,
    lastmodifiedon DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- InvoiceLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_invoicelines;
CREATE TABLE c{clientID}_unleashed_invoicelines (
    invoiceguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(100),
    productdescription VARCHAR(500),
    invoicequantity DECIMAL(18,4),
    invoiceprice DECIMAL(18,4),
    linetotal DECIMAL(18,4),
    linetax DECIMAL(18,4),
    taxrate DECIMAL(18,4),
    comments VARCHAR(1024),
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(15),
    warehousename VARCHAR(100),
    orderlineguid VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (invoiceguid, id)
);

-- PaymentTerms Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_paymentterms;
CREATE TABLE c{clientID}_unleashed_paymentterms (
    id VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    days INT,
    obsolete BOOLEAN,
    paymenttermdescription VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductGroups Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_productgroups;
CREATE TABLE c{clientID}_unleashed_productgroups (
    id VARCHAR(255) NOT NULL,
    groupname VARCHAR(255),
    parentgroupguid VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductPrice Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_productprice;
CREATE TABLE c{clientID}_unleashed_productprice (
    id VARCHAR(255) NOT NULL,
    product JSON,
    productgroup JSON,
    customer JSON,
    pricetype VARCHAR(255),
    discountvalue DECIMAL(18,4),
    minimumquantity INT,
    defaultsellprice DECIMAL(18,4),
    customerprice DECIMAL(18,4),
    validfrom DATETIME,
    validto DATETIME,
    comments TEXT,
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Product Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_product;
CREATE TABLE c{clientID}_unleashed_product (
    id VARCHAR(255) NOT NULL,
    productcode VARCHAR(255),
    productdescription VARCHAR(500),
    barcode VARCHAR(255),
    packsize DECIMAL(18,4),
    width DECIMAL(18,4),
    height DECIMAL(18,4),
    depth DECIMAL(18,4),
    weight DECIMAL(18,4),
    minstockalertlevel DECIMAL(18,4),
    maxstockalertlevel DECIMAL(18,4),
    reorderpoint DECIMAL(18,4),
    unitofmeasureguid VARCHAR(255),
    unitofmeasurename VARCHAR(20),
    neverdiminishing BOOLEAN,
    lastcost DECIMAL(18,4),
    defaultpurchaseprice DECIMAL(18,4),
    defaultpurchasesunitofmeasureguid VARCHAR(255),
    defaultpurchasesunitofmeasurename VARCHAR(20),
    defaultsellprice DECIMAL(18,4),
    customersellprice DECIMAL(18,4),
    averagelandprice DECIMAL(18,4),
    obsolete BOOLEAN,
    notes TEXT,
    imageurl VARCHAR(1000),
    sellpricetier1 JSON,
    sellpricetier2 JSON,
    sellpricetier3 JSON,
    sellpricetier4 JSON,
    sellpricetier5 JSON,
    sellpricetier6 JSON,
    sellpricetier7 JSON,
    sellpricetier8 JSON,
    sellpricetier9 JSON,
    sellpricetier10 JSON,
    xerotaxcode VARCHAR(255),
    xerotaxrate DECIMAL(18,4),
    taxablepurchase BOOLEAN,
    taxablesales BOOLEAN,
    xerosalestaxcode VARCHAR(255),
    xerosalestaxrate DECIMAL(18,4),
    iscomponent BOOLEAN,
    isassembledproduct BOOLEAN,
    productgroupguid VARCHAR(255),
    productgroupname VARCHAR(450),
    productsubgroupguid VARCHAR(255),
    productsubgroupname VARCHAR(450),
    productbrandguid VARCHAR(255),
    productbrandname VARCHAR(50),
    xerosalesaccount VARCHAR(255),
    xerocostofgoodsaccount VARCHAR(255),
    purchaseaccount VARCHAR(255),
    binlocation VARCHAR(255),
    supplierguid VARCHAR(255),
    suppliercode VARCHAR(500),
    suppliername VARCHAR(500),
    supplierproductcode VARCHAR(100),
    sourceid VARCHAR(255),
    sourcevariantparentid VARCHAR(255),
    isserialized BOOLEAN,
    isbatchtracked BOOLEAN,
    ispurchasable BOOLEAN,
    issellable BOOLEAN,
    minimumsellprice DECIMAL(18,4),
    minimumsalequantity DECIMAL(18,4),
    minimumorderquantity DECIMAL(18,4),
    nominalcost DECIMAL(18,4),
    createdby VARCHAR(255),
    createdon DATETIME,
    lastmodifiedby VARCHAR(255),
    commercecode VARCHAR(255),
    customsdescription TEXT,
    supplementaryclassificationabbreviation VARCHAR(255),
    icccountrycode VARCHAR(255),
    icccountryname VARCHAR(255),
    automaticchargecost DECIMAL(18,4),
    comments TEXT,
    copycommentsforsales BOOLEAN,
    copycommentsforpurchases BOOLEAN,
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProductImages Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_productimages;
CREATE TABLE c{clientID}_unleashed_productimages (
    productguid VARCHAR(255) NOT NULL,
    imageurl VARCHAR(1000),
    isdefault BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (productguid, organisationid)
);

-- ProductInventoryDetails Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_productinventorydetails;
CREATE TABLE c{clientID}_unleashed_productinventorydetails (
    productguid VARCHAR(255) NOT NULL,
    warehouseguid VARCHAR(255) NOT NULL,
    warehousecode VARCHAR(15),
    warehousename VARCHAR(100),
    binlocation VARCHAR(50),
    warehouseminstockalertlevel DECIMAL(18,4),
    warehousemaxstockalertlevel DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (productguid, warehouseguid, organisationid)
);

-- ProductAlternateUnits Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_productalternateunits;
CREATE TABLE c{clientID}_unleashed_productalternateunits (
    productguid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    unitname VARCHAR(20),
    conversionrate DECIMAL(18,6) NOT NULL,
    forpurchases BOOLEAN,
    barcode VARCHAR(200),
    packsize DECIMAL(18,4),
    weight DECIMAL(18,4),
    width DECIMAL(18,4),
    height DECIMAL(18,4),
    depth DECIMAL(18,4),
    cubictotal DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (productguid, id, organisationid)
);

-- PurchaseOrder Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_purchaseorder;
CREATE TABLE c{clientID}_unleashed_purchaseorder (
    id VARCHAR(255) NOT NULL,
    ordernumber VARCHAR(255),
    orderdate DATETIME,
    completeddate DATETIME,
    supplierguid VARCHAR(255),
    suppliercode VARCHAR(255),
    suppliername VARCHAR(255),
    supplierref VARCHAR(255),
    comments TEXT,
    printed BOOLEAN,
    orderstatus VARCHAR(255),
    customorderstatus VARCHAR(255),
    receiveddate DATETIME,
    deliveryname VARCHAR(255),
    deliverystreetaddress VARCHAR(255),
    deliverystreetaddress2 VARCHAR(255),
    deliverysuburb VARCHAR(255),
    deliveryregion VARCHAR(255),
    deliverycity VARCHAR(255),
    deliverycountry VARCHAR(255),
    deliverypostcode VARCHAR(255),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(10),
    currencydescription VARCHAR(255),
    exchangerate DECIMAL(18,6),
    taxguid VARCHAR(255),
    taxtaxcode VARCHAR(255),
    taxtaxrate DECIMAL(18,6),
    taxrate DECIMAL(18,6),
    taxcode VARCHAR(255),
    subtotal DECIMAL(18,2),
    taxtotal DECIMAL(18,2),
    total DECIMAL(18,2),
    totalvolume DECIMAL(18,6),
    totalweight DECIMAL(18,6),
    supplierinvoicedate DATETIME,
    bcsubtotal DECIMAL(18,2),
    bctaxtotal DECIMAL(18,2),
    bctotal DECIMAL(18,2),
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(255),
    warehousename VARCHAR(255),
    lastmodifiedon DATETIME,
    discountrate DECIMAL(18,6),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_purchaseorderlines;
CREATE TABLE c{clientID}_unleashed_purchaseorderlines (
    purchaseorderid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    productguid VARCHAR(255),
    productcode VARCHAR(255),
    productdescription TEXT,
    orderquantity DECIMAL(18,6),
    receivedquantity DECIMAL(18,6),
    unitprice DECIMAL(18,2),
    linetotal DECIMAL(18,2),
    unitofmeasureguid VARCHAR(255),
    unitofmeasurename VARCHAR(255),
    duedate DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrderGroup Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesordergroup;
CREATE TABLE c{clientID}_unleashed_salesordergroup (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrder Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesorder;
CREATE TABLE c{clientID}_unleashed_salesorder (
    id VARCHAR(255) NOT NULL,
    ordernumber VARCHAR(255),
    orderdate DATETIME,
    requireddate DATETIME,
    completeddate DATETIME,
    orderstatus VARCHAR(255),
    customerguid VARCHAR(255),
    customercode VARCHAR(255),
    customername VARCHAR(255),
    customerref VARCHAR(255),
    comments TEXT,
    warehouseguid VARCHAR(255),
    warehousecode VARCHAR(255),
    warehousename VARCHAR(255),
    receiveddate DATETIME,
    deliverycontactfirstname VARCHAR(255),
    deliverycontactlastname VARCHAR(255),
    deliverycontactemail VARCHAR(255),
    deliverycontactphone VARCHAR(255),
    deliveryinstruction TEXT,
    deliveryname VARCHAR(255),
    deliverystreetaddress VARCHAR(255),
    deliverystreetaddress2 VARCHAR(255),
    deliverysuburb VARCHAR(255),
    deliverycity VARCHAR(255),
    deliveryregion VARCHAR(255),
    deliverycountry VARCHAR(255),
    deliverypostcode VARCHAR(255),
    currencyguid VARCHAR(255),
    currencycode VARCHAR(10),
    currencydescription VARCHAR(255),
    exchangerate DECIMAL(18,6),
    discountrate DECIMAL(18,6),
    taxguid VARCHAR(255),
    taxtaxcode VARCHAR(255),
    taxtaxrate DECIMAL(18,6),
    taxrate DECIMAL(18,6),
    xerotaxcode VARCHAR(255),
    subtotal DECIMAL(18,2),
    taxtotal DECIMAL(18,2),
    total DECIMAL(18,2),
    totalvolume DECIMAL(18,6),
    totalweight DECIMAL(18,6),
    bcsubtotal DECIMAL(18,2),
    bctaxtotal DECIMAL(18,2),
    bctotal DECIMAL(18,2),
    paymentduedate DATETIME,
    allocateproduct BOOLEAN,
    salesordergroup VARCHAR(50),
    deliverymethod VARCHAR(50),
    salespersonguid VARCHAR(255),
    salespersonfullname VARCHAR(255),
    salespersonemail VARCHAR(255),
    sendaccountingjournalonly BOOLEAN,
    sourceid VARCHAR(255),
    createdby VARCHAR(255),
    customorderstatus VARCHAR(255),
    createdon DATETIME,
    lastmodifiedby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrderLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesorderlines;
CREATE TABLE c{clientID}_unleashed_salesorderlines (
    salesorderid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(255),
    productdescription TEXT,
    orderquantity DECIMAL(18,6),
    unitprice DECIMAL(18,2),
    discountrate DECIMAL(18,6),
    linetotal DECIMAL(18,2),
    linetax DECIMAL(18,2),
    taxrate DECIMAL(18,6),
    unitofmeasureguid VARCHAR(255),
    unitofmeasurename VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Salespersons Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salespersons;
CREATE TABLE c{clientID}_unleashed_salespersons (
    id VARCHAR(255) NOT NULL,
    fullname VARCHAR(255),
    email VARCHAR(255),
    obsolete BOOLEAN,
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuotes Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotes;
CREATE TABLE c{clientID}_unleashed_salesquotes (
    id VARCHAR(255) NOT NULL,
    quotenumber VARCHAR(255),
    quotedate DATETIME,
    quoteexpirydate DATETIME,
    accepteddate DATETIME,
    quotestatus VARCHAR(255),
    customerref VARCHAR(255),
    comments TEXT,
    deliveryname VARCHAR(255),
    deliverystreetaddress VARCHAR(255),
    deliverystreetaddress2 VARCHAR(255),
    deliverysuburb VARCHAR(255),
    deliverycity VARCHAR(255),
    deliveryregion VARCHAR(255),
    deliverycountry VARCHAR(255),
    deliverypostcode VARCHAR(255),
    exchangerate DECIMAL(18,6),
    discountrate DECIMAL(18,6),
    taxrate DECIMAL(18,6),
    xerotaxcode VARCHAR(255),
    subtotal DECIMAL(18,2),
    taxtotal DECIMAL(18,2),
    total DECIMAL(18,2),
    totalvolume DECIMAL(18,6),
    totalweight DECIMAL(18,6),
    bcsubtotal DECIMAL(18,2),
    bctaxtotal DECIMAL(18,2),
    bctotal DECIMAL(18,2),
    salesordergroup VARCHAR(255),
    deliverymethod VARCHAR(255),
    sourceid VARCHAR(255),
    createdby VARCHAR(255),
    lastmodifiedon DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_unleashed_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalesQuoteCustomers Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotecustomers;
CREATE TABLE c{clientID}_unleashed_salesquotecustomers (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    customercode VARCHAR(255),
    customername VARCHAR(255),
    currencyid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteWarehouses Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotewarehouses;
CREATE TABLE c{clientID}_unleashed_salesquotewarehouses (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    warehousecode VARCHAR(255),
    warehousename VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteCurrencies Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotecurrencies;
CREATE TABLE c{clientID}_unleashed_salesquotecurrencies (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    currencycode VARCHAR(10),
    description VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteTaxes Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotetaxes;
CREATE TABLE c{clientID}_unleashed_salesquotetaxes (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    taxcode VARCHAR(255),
    taxrate DECIMAL(18,6),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteSalespersons Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotesalespersons;
CREATE TABLE c{clientID}_unleashed_salesquotesalespersons (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    fullname VARCHAR(255),
    email VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteLines Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquotelines;
CREATE TABLE c{clientID}_unleashed_salesquotelines (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    linenumber INT,
    productguid VARCHAR(255),
    productcode VARCHAR(255),
    productdescription TEXT,
    quotequantity DECIMAL(18,6),
    unitprice DECIMAL(18,2),
    discountrate DECIMAL(18,6),
    linetotal DECIMAL(18,2),
    unitcost DECIMAL(18,2),
    taxrate DECIMAL(18,6),
    linetax DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesQuoteOrders Production Table
DROP TABLE IF EXISTS c{clientID}_unleashed_salesquoteorders;
CREATE TABLE c{clientID}_unleashed_salesquoteorders (
    salesquoteid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    ordernumber VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- UNLEASHED LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_unleashed_lastrefreshdate;
CREATE TABLE c{clientID}_unleashed_lastrefreshdate (
    `Id` INT AUTO_INCREMENT PRIMARY KEY,
    `TableName` VARCHAR(255) NOT NULL,
    `RefreshRowCount` INT DEFAULT 0,
    `TotalRowCount` INT DEFAULT 0,
    `StartDate` DATETIME DEFAULT NULL,
    `EndDate` DATETIME DEFAULT NULL,
    `LastRefreshUTCDate` DATETIME DEFAULT NULL,
    `LoadType` VARCHAR(100) DEFAULT NULL,
    `RefreshStatus` VARCHAR(100) DEFAULT NULL,
    `JobRunId` BIGINT DEFAULT NULL,
    `DatabaseDestination` VARCHAR(100) DEFAULT NULL,
    `ClientID` VARCHAR(255) DEFAULT NULL,
    `OrganisationID` INT DEFAULT NULL,
    `TriggerType` VARCHAR(100) DEFAULT NULL,
    `RefreshDetails` TEXT DEFAULT NULL,
    `CreatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_table_org` (`TableName`, `OrganisationID`),
    INDEX `idx_status_date` (`RefreshStatus`, `StartDate`),
    UNIQUE KEY `unique_table_client_org` (`TableName`, `ClientID`, `OrganisationID`)
);
