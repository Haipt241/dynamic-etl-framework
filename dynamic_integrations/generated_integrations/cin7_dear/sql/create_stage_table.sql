-- CIN7_DEAR Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Sale Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salestage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salestage (
    id VARCHAR(255) NOT NULL,
    customer VARCHAR(255),
    customerid VARCHAR(255),
    contact VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    defaultaccount VARCHAR(255),
    skipquote BOOLEAN,
    billingaddressdisplayaddressline1 VARCHAR(255),
    billingaddressdisplayaddressline2 VARCHAR(255),
    billingaddressline1 VARCHAR(255),
    billingaddressline2 VARCHAR(255),
    billingaddresscity VARCHAR(255),
    billingaddressstate VARCHAR(255),
    billingaddresspostcode VARCHAR(50),
    billingaddresscountry VARCHAR(100),
    shippingaddressdisplayaddressline1 VARCHAR(255),
    shippingaddressdisplayaddressline2 VARCHAR(255),
    shippingaddressline1 VARCHAR(255),
    shippingaddressline2 VARCHAR(255),
    shippingaddresscity VARCHAR(255),
    shippingaddressstate VARCHAR(255),
    shippingaddresspostcode VARCHAR(50),
    shippingaddresscountry VARCHAR(100),
    shippingaddresscompany VARCHAR(255),
    shippingaddresscontact VARCHAR(255),
    shippingaddressshiptoother BOOLEAN,
    shippingnotes TEXT,
    basecurrency VARCHAR(10),
    customercurrency VARCHAR(10),
    taxrule VARCHAR(255),
    taxcalculation VARCHAR(255),
    terms VARCHAR(255),
    pricetier VARCHAR(255),
    shipby DATETIME,
    location VARCHAR(255),
    saleorderdate DATETIME,
    lastmodifiedon DATETIME,
    note TEXT,
    customerreference VARCHAR(255),
    cogsamount DECIMAL(18,2),
    status VARCHAR(255),
    combinedpickingstatus VARCHAR(255),
    combinedpackingstatus VARCHAR(255),
    combinedshippingstatus VARCHAR(255),
    fulfilmentstatus VARCHAR(255),
    combinedinvoicestatus VARCHAR(255),
    combinedpaymentstatus VARCHAR(255),
    combinedtrackingnumbers VARCHAR(255),
    carrier VARCHAR(255),
    currencyrate DECIMAL(18,6),
    salesrepresentative VARCHAR(255),
    serviceonly BOOLEAN,
    type VARCHAR(255),
    sourcechannel VARCHAR(255),
    quotememo TEXT,
    quotestatus VARCHAR(255),
    quotetotalbeforetax DECIMAL(18,2),
    quotetax DECIMAL(18,2),
    quotetotal DECIMAL(18,2),
    ordersaleordernumber VARCHAR(255),
    ordermemo TEXT,
    orderstatus VARCHAR(255),
    ordertotalbeforetax DECIMAL(18,2),
    ordertax DECIMAL(18,2),
    ordertotal DECIMAL(18,2),
    manualjournalsstatus VARCHAR(255),
    externalid VARCHAR(255),
    additionalattribute1 VARCHAR(255),
    additionalattribute2 VARCHAR(255),
    additionalattribute3 VARCHAR(255),
    additionalattribute4 VARCHAR(255),
    additionalattribute5 VARCHAR(255),
    additionalattribute6 VARCHAR(255),
    additionalattribute7 VARCHAR(255),
    additionalattribute8 VARCHAR(255),
    additionalattribute9 VARCHAR(255),
    additionalattribute10 VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SaleQuoteLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salequotelinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salequotelinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    averagecost DECIMAL(18,2),
    taxrule VARCHAR(255),
    comment TEXT,
    dropship BOOLEAN,
    backorder BOOLEAN,
    backorderquantity DECIMAL(18,2),
    total DECIMAL(18,2),
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleid)
);

-- SaleQuoteAdditionalCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salequoteadditionalchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salequoteadditionalchargesstage (
    description VARCHAR(255),
    price DECIMAL(18,2),
    quantity DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    taxrule VARCHAR(255),
    comment TEXT,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleid)
);

-- SaleQuotePrepayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salequoteprepaymentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salequoteprepaymentsstage (
    id VARCHAR(255) NOT NULL,
    reference VARCHAR(255),
    amount DECIMAL(18,2),
    datepaid DATETIME,
    account VARCHAR(255),
    currencyrate DECIMAL(18,6),
    datecreated DATETIME,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, saleid)
);

-- SaleOrderLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleorderlinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleorderlinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    averagecost DECIMAL(18,2),
    taxrule VARCHAR(255),
    comment TEXT,
    dropship BOOLEAN,
    backorder BOOLEAN,
    backorderquantity DECIMAL(18,2),
    total DECIMAL(18,2),
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleid)
);

-- SaleOrderAdditionalCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleorderadditionalchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleorderadditionalchargesstage (
    description VARCHAR(255),
    price DECIMAL(18,2),
    quantity DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    taxrule VARCHAR(255),
    comment TEXT,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleid)
);

-- SaleFulfilments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salefulfilmentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salefulfilmentsstage (
    taskid VARCHAR(255) NOT NULL,
    fulfillmentnumber INT,
    linkedinvoicenumber VARCHAR(50),
    fulfilmentstatus VARCHAR(50),
    pickstatus VARCHAR(50),
    packstatus VARCHAR(50),
    shipstatus VARCHAR(50),
    shiprequireby DATETIME,
    shipshippingnotes TEXT,
    shipaddressdisplayaddressline1 VARCHAR(255),
    shipaddressdisplayaddressline2 VARCHAR(255),
    shipaddressline1 VARCHAR(255),
    shipaddressline2 VARCHAR(255),
    shipaddresscity VARCHAR(255),
    shipaddressstate VARCHAR(255),
    shipaddresspostcode VARCHAR(50),
    shipaddresscountry VARCHAR(100),
    shipaddresscompany VARCHAR(255),
    shipaddresscontact VARCHAR(255),
    shipaddressshiptoother BOOLEAN,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- SaleFulfilmentsPickLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salefulfilmentspicklinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salefulfilmentspicklinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    location VARCHAR(255),
    locationid VARCHAR(255),
    quantity DECIMAL(18,2),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    salefulfilmentsid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salefulfilmentsid)
);

-- SaleFulfilmentsPackLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salefulfilmentspacklinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salefulfilmentspacklinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    location VARCHAR(255),
    locationid VARCHAR(255),
    box VARCHAR(255),
    quantity DECIMAL(18,2),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    salefulfilmentsid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salefulfilmentsid)
);

-- SaleFulfilmentsShipLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salefulfilmentsshiplinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salefulfilmentsshiplinesstage (
    id VARCHAR(255) NOT NULL,
    shipmentdate DATETIME,
    carrier VARCHAR(255),
    boxes VARCHAR(255),
    trackingnumber VARCHAR(255),
    trackingurl VARCHAR(500),
    isshipped BOOLEAN,
    salefulfilmentsid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, salefulfilmentsid)
);


-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInvoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleinvoicesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleinvoicesstage (
    taskid VARCHAR(255) NOT NULL,
    invoicenumber VARCHAR(50),
    memo TEXT,
    status VARCHAR(50),
    invoicedate DATETIME,
    invoiceduedate DATETIME,
    currencyconversionrate DECIMAL(18,6),
    billingaddressline1 VARCHAR(255),
    billingaddressline2 VARCHAR(255),
    linkedfulfillmentnumber VARCHAR(50),
    totalbeforetax DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    paid DECIMAL(18,2),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- SaleInvoicesLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleinvoiceslinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleinvoiceslinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    averagecost DECIMAL(18,2),
    taxrule VARCHAR(255),
    account VARCHAR(255),
    comment TEXT,
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    saleinvoicesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleinvoicesid)
);

-- SaleInvoicesAdditionalCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleinvoicesadditionalchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleinvoicesadditionalchargesstage (
    description VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    taxrule VARCHAR(255),
    account VARCHAR(255),
    comment TEXT,
    saleinvoicesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleinvoicesid)
);

-- SaleInvoicesPayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleinvoicespaymentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleinvoicespaymentsstage (
    id VARCHAR(255) NOT NULL,
    reference VARCHAR(255),
    amount DECIMAL(18,2),
    datepaid DATETIME,
    account VARCHAR(255),
    currencyrate DECIMAL(18,6),
    datecreated DATETIME,
    saleinvoicesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, saleinvoicesid)
);

-- SaleCreditNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salecreditnotesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salecreditnotesstage (
    taskid VARCHAR(255) NOT NULL,
    creditnoteinvoicenumber VARCHAR(50),
    memo TEXT,
    status VARCHAR(50),
    creditnotedate DATETIME,
    creditnotenumber VARCHAR(50),
    creditnoteconversionrate DECIMAL(18,6),
    totalbeforetax DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- SaleCreditNotesLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salecreditnoteslinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salecreditnoteslinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    averagecost DECIMAL(18,2),
    taxrule VARCHAR(255),
    account VARCHAR(255),
    comment TEXT,
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    salecreditnotesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salecreditnotesid)
);

-- SaleCreditNotesAddCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salecreditnotesaddchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salecreditnotesaddchargesstage (
    description VARCHAR(255),
    quantity DECIMAL(18,2),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    tax DECIMAL(18,2),
    total DECIMAL(18,2),
    taxrule VARCHAR(255),
    account VARCHAR(255),
    comment TEXT,
    salecreditnotesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salecreditnotesid)
);

-- SaleCreditNotesRefunds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salecreditnotesrefundsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salecreditnotesrefundsstage (
    id VARCHAR(255) NOT NULL,
    reference VARCHAR(255),
    amount DECIMAL(18,2),
    datepaid DATETIME,
    account VARCHAR(255),
    currencyrate DECIMAL(18,6),
    datecreated DATETIME,
    salecreditnotesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, salecreditnotesid)
);

-- SaleCreditNotesRestock Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salecreditnotesrestockstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salecreditnotesrestockstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(255),
    location VARCHAR(255),
    locationid VARCHAR(255),
    quantity DECIMAL(18,2),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    salecreditnotesid VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (productid, salecreditnotesid)
);

-- SaleAttachments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleattachmentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleattachmentsstage (
    id VARCHAR(255) NOT NULL,
    contenttype VARCHAR(100),
    filename VARCHAR(255),
    downloadurl VARCHAR(500),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- SaleInventoryMovements Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saleinventorymovementsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saleinventorymovementsstage (
    taskid VARCHAR(255) NOT NULL,
    productid VARCHAR(255),
    date DATETIME,
    cogs DECIMAL(18,2),
    productlength DECIMAL(18,2),
    productwidth DECIMAL(18,2),
    productheight DECIMAL(18,2),
    productweight DECIMAL(18,2),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid, productid)
);

-- SaleTransactions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_saletransactionsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_saletransactionsstage (
    taskid VARCHAR(255) NOT NULL,
    transactionid VARCHAR(255) NOT NULL,
    debit VARCHAR(255),
    credit VARCHAR(255),
    description TEXT,
    amount DECIMAL(18,2),
    effectivedate DATETIME,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (transactionid)
);

-- SaleManualJournalsLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_salemanualjournalslinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_salemanualjournalslinesstage (
    reference VARCHAR(255),
    amount DECIMAL(18,2) NOT NULL,
    date DATETIME NOT NULL,
    debit VARCHAR(255) NOT NULL,
    credit VARCHAR(255) NOT NULL,
    saleid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reference)
);

-- ProductCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productcategorystage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productcategorystage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- UnitOfMeasure Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_unitofmeasurestage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_unitofmeasurestage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Brand Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_brandstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_brandstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Location Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_locationstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_locationstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    isdefault BOOLEAN,
    isdeprecated BOOLEAN,
    bins JSON,
    fixedassetslocation BOOLEAN,
    parentid VARCHAR(255),
    parentname VARCHAR(255),
    referencecount INT,
    addressline1 VARCHAR(255),
    addressline2 VARCHAR(255),
    addresscitysuburb VARCHAR(255),
    addressstateprovince VARCHAR(255),
    addresszippostcode VARCHAR(255),
    addresscountry VARCHAR(255),
    pickzones JSON,
    isshopfloor BOOLEAN,
    iscoman BOOLEAN,
    isstaging BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AttributeSet Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_attributesetstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_attributesetstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    attribute1name VARCHAR(255),
    attribute1type VARCHAR(50),
    attribute1values TEXT,
    attribute2name VARCHAR(255),
    attribute2type VARCHAR(50),
    attribute2values TEXT,
    attribute3name VARCHAR(255),
    attribute3type VARCHAR(50),
    attribute3values TEXT,
    attribute4name VARCHAR(255),
    attribute4type VARCHAR(50),
    attribute4values TEXT,
    attribute5name VARCHAR(255),
    attribute5type VARCHAR(50),
    attribute5values TEXT,
    attribute6name VARCHAR(255),
    attribute6type VARCHAR(50),
    attribute6values TEXT,
    attribute7name VARCHAR(255),
    attribute7type VARCHAR(50),
    attribute7values TEXT,
    attribute8name VARCHAR(255),
    attribute8type VARCHAR(50),
    attribute8values TEXT,
    attribute9name VARCHAR(255),
    attribute9type VARCHAR(50),
    attribute9values TEXT,
    attribute10name VARCHAR(255),
    attribute10type VARCHAR(50),
    attribute10values TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AttributeSetAttributes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_attributesetattributesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_attributesetattributesstage (
    name VARCHAR(255),
    type VARCHAR(50),
    `values` TEXT,
    attributesetid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (attributesetid)
);

-- Product Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productstage (
    id VARCHAR(255) NOT NULL,
    sku VARCHAR(255),
    name VARCHAR(255),
    category VARCHAR(255),
    brand VARCHAR(255),
    type VARCHAR(255),
    costingmethod VARCHAR(255),
    dropshipmode VARCHAR(255),
    defaultlocation VARCHAR(255),
    length FLOAT,
    width FLOAT,
    height FLOAT,
    weight FLOAT,
    uom VARCHAR(255),
    weightunits VARCHAR(255),
    dimensionsunits VARCHAR(255),
    barcode VARCHAR(255),
    minimumbeforereorder FLOAT,
    reorderquantity FLOAT,
    pricetier1 FLOAT,
    pricetier2 FLOAT,
    pricetier3 FLOAT,
    pricetier4 FLOAT,
    pricetier5 FLOAT,
    pricetier6 FLOAT,
    pricetier7 FLOAT,
    pricetier8 FLOAT,
    pricetier9 FLOAT,
    pricetier10 FLOAT,
    pricetierstier1 DECIMAL(18,2),
    pricetierstier2 DECIMAL(18,2),
    pricetierstier3 DECIMAL(18,2),
    pricetierstier4 DECIMAL(18,2),
    pricetierstier5 DECIMAL(18,2),
    pricetierstier6 DECIMAL(18,2),
    pricetierstier7 DECIMAL(18,2),
    pricetierstier8 DECIMAL(18,2),
    pricetierstier9 DECIMAL(18,2),
    pricetierstier10 DECIMAL(18,2),
    averagecost FLOAT,
    shortdescription TEXT,
    description TEXT,
    internalnote TEXT,
    additionalattribute1 VARCHAR(255),
    additionalattribute2 VARCHAR(255),
    additionalattribute3 VARCHAR(255),
    additionalattribute4 VARCHAR(255),
    additionalattribute5 VARCHAR(255),
    additionalattribute6 VARCHAR(255),
    additionalattribute7 VARCHAR(255),
    additionalattribute8 VARCHAR(255),
    additionalattribute9 VARCHAR(255),
    additionalattribute10 VARCHAR(255),
    attributeset VARCHAR(255),
    discountrule VARCHAR(255),
    tags VARCHAR(255),
    status VARCHAR(255),
    stocklocator VARCHAR(255),
    cogsaccount VARCHAR(255),
    revenueaccount VARCHAR(255),
    expenseaccount VARCHAR(255),
    inventoryaccount VARCHAR(255),
    purchasetaxrule VARCHAR(255),
    saletaxrule VARCHAR(255),
    lastmodifiedon DATETIME,
    sellable BOOLEAN,
    pickzones VARCHAR(255),
    billofmaterial BOOLEAN,
    autoassembly BOOLEAN,
    autodisassembly BOOLEAN,
    quantitytoproduce FLOAT,
    assemblyinstructionurl VARCHAR(255),
    assemblycostestimationmethod VARCHAR(255),
    cartonheight FLOAT,
    cartonwidth FLOAT,
    cartonlength FLOAT,
    cartonquantity FLOAT,
    cartoninnerquantity FLOAT,
    hscode VARCHAR(255),
    countryoforigin VARCHAR(255),
    countryoforigincode VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ProductSuppliers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productsuppliersstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productsuppliersstage (
    productid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    suppliername VARCHAR(256),
    productsku VARCHAR(256),
    productsupplierid VARCHAR(255),
    supplierinventorycode VARCHAR(256),
    supplierproductname VARCHAR(256),
    cost DECIMAL(18,2),
    fixedcost DECIMAL(18,2),
    currency VARCHAR(50),
    dropship BOOLEAN,
    supplierproducturl VARCHAR(256),
    lastsupplied DATETIME,
    defaultsupplier BOOLEAN,
    defaultprice DECIMAL(18,2),
    minimumorderqty INT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductSupplierOptions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productsupplieroptionsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productsupplieroptionsstage (
    id VARCHAR(255) NOT NULL,
    locationid VARCHAR(255),
    locationname VARCHAR(256),
    reorderquantity DECIMAL(18,2),
    `lead` INT,
    safety INT,
    minimumtoreorder DECIMAL(18,2),
    supplyintervals JSON,
    productsupplierid VARCHAR(255) NOT NULL,
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductSupplierOptionsIntervals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productsupplieroptionsintervalsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productsupplieroptionsintervalsstage (
    id VARCHAR(255) NOT NULL,
    deliverymethod VARCHAR(256) NOT NULL,
    intervaldays INT,
    intervalstartdate DATE,
    ismonday BOOLEAN,
    istuesday BOOLEAN,
    iswednesday BOOLEAN,
    isthursday BOOLEAN,
    isfriday BOOLEAN,
    issaturday BOOLEAN,
    issunday BOOLEAN,
    productsupplieroptionid VARCHAR(255) NOT NULL,
    productsupplierid VARCHAR(255) NOT NULL,
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductReorderLevels Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productreorderlevelsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productreorderlevelsstage (
    locationid VARCHAR(255) NOT NULL,
    locationname VARCHAR(255),
    minimumbeforereorder INT,
    reorderquantity INT,
    stocklocator VARCHAR(255),
    pickzones VARCHAR(255),
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationid, productid)
);

-- ProductBillOfMaterialsProducts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productbillofmaterialsproductsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productbillofmaterialsproductsstage (
    componentproductid VARCHAR(255) NOT NULL,
    productcode VARCHAR(255),
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    wastagepercent DECIMAL(18,2),
    wastagequantity DECIMAL(18,2),
    costpercentage DECIMAL(18,2),
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (componentproductid, productid)
);

-- ProductBillOfMaterialsServices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productbillofmaterialsservicesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productbillofmaterialsservicesstage (
    componentproductid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    quantity DECIMAL(18,2),
    expenseaccount VARCHAR(255),
    pricetier INT,
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (componentproductid, productid)
);

-- ProductMovements Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productmovementsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productmovementsstage (
    taskid VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    date DATETIME,
    number VARCHAR(255),
    quantity DECIMAL(18,2),
    amount DECIMAL(18,2),
    location VARCHAR(255),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    fromto VARCHAR(255),
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid, productid)
);

-- ProductAttachments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productattachmentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productattachmentsstage (
    id VARCHAR(255) NOT NULL,
    contenttype VARCHAR(255),
    filename VARCHAR(255),
    downloadurl TEXT,
    productid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, productid)
);

-- ProductCustomPrices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productcustompricesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productcustompricesstage (
    productid VARCHAR(255) NOT NULL,
    customerproductid VARCHAR(255) NOT NULL,
    productname VARCHAR(255),
    productsku VARCHAR(255),
    price DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customerproductid)
);

-- ProductFamily Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productfamilystage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productfamilystage (
    id VARCHAR(255) NOT NULL,
    sku VARCHAR(255),
    name VARCHAR(255),
    category VARCHAR(255),
    defaultlocation VARCHAR(255),
    brand VARCHAR(255),
    costingmethod VARCHAR(255),
    uom VARCHAR(255),
    minimumbeforereorder INT,
    reorderquantity INT,
    pricetier1 DECIMAL(18,6),
    pricetier2 DECIMAL(18,6),
    pricetier3 DECIMAL(18,6),
    pricetier4 DECIMAL(18,6),
    pricetier5 DECIMAL(18,6),
    pricetier6 DECIMAL(18,6),
    pricetier7 DECIMAL(18,6),
    pricetier8 DECIMAL(18,6),
    pricetier9 DECIMAL(18,6),
    pricetier10 DECIMAL(18,6),
    shortdescription TEXT,
    description TEXT,
    attributeset VARCHAR(255),
    discountrule VARCHAR(255),
    tags VARCHAR(255),
    cogsaccount VARCHAR(255),
    revenueaccount VARCHAR(255),
    inventoryaccount VARCHAR(255),
    purchasetaxrule VARCHAR(255),
    saletaxrule VARCHAR(255),
    dropshipmode VARCHAR(255),
    option1name VARCHAR(255),
    option2name VARCHAR(255),
    option3name VARCHAR(255),
    option1values VARCHAR(255),
    option2values VARCHAR(255),
    option3values VARCHAR(255),
    lastmodifiedon DATETIME,
    hscode VARCHAR(255),
    countryoforigin VARCHAR(255),
    countryoforigincode VARCHAR(255),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ProductFamilyProducts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productfamilyproductsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productfamilyproductsstage (
    id VARCHAR(255) NOT NULL,
    sku VARCHAR(255),
    name VARCHAR(255),
    option1 VARCHAR(255),
    option2 VARCHAR(255),
    option3 VARCHAR(255),
    productfamilyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductFamilyAttachments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productfamilyattachmentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productfamilyattachmentsstage (
    id VARCHAR(255) NOT NULL,
    contenttype VARCHAR(255),
    filename VARCHAR(255),
    downloadurl TEXT,
    productfamilyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Account Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_accountstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_accountstage (
    code VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    description TEXT,
    class VARCHAR(255) NOT NULL,
    systemaccount VARCHAR(255) NOT NULL,
    bankaccountnumber VARCHAR(255),
    bankaccountid VARCHAR(255),
    forpayments BOOLEAN NOT NULL,
    displayname VARCHAR(255) NOT NULL,
    oldcode VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (code)
);

-- Tax Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_taxstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_taxstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    account VARCHAR(255),
    isactive BOOLEAN,
    taxinclusive BOOLEAN,
    taxpercent DECIMAL(18,6),
    istaxforsale BOOLEAN,
    istaxforpurchase BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TaxComponents Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_taxcomponentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_taxcomponentsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    percent DECIMAL(18,10),
    accountcode VARCHAR(255),
    compound VARCHAR(50),
    componentorder VARCHAR(50),
    taxid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PaymentTerm Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_paymenttermstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_paymenttermstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    duration INT,
    method VARCHAR(255),
    isactive BOOLEAN,
    isdefault BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Carrier Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_carrierstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_carrierstage (
    carrierid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (carrierid)
);

-- Supplier Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_supplierstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_supplierstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    currency VARCHAR(255),
    paymentterm VARCHAR(255),
    taxrule VARCHAR(255),
    discount DECIMAL(19,4),
    comments TEXT,
    accountpayable VARCHAR(255),
    taxnumber VARCHAR(255),
    additionalattribute1 VARCHAR(255),
    additionalattribute2 VARCHAR(255),
    additionalattribute3 VARCHAR(255),
    additionalattribute4 VARCHAR(255),
    additionalattribute5 VARCHAR(255),
    additionalattribute6 VARCHAR(255),
    additionalattribute7 VARCHAR(255),
    additionalattribute8 VARCHAR(255),
    additionalattribute9 VARCHAR(255),
    additionalattribute10 VARCHAR(255),
    attributeset VARCHAR(255),
    status VARCHAR(255),
    lastmodifiedon DATETIME,
    addresses JSON,
    contacts JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SupplierAddresses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_supplieraddressesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_supplieraddressesstage (
    addressindex INT NOT NULL,
    line1 VARCHAR(255),
    line2 VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postcode VARCHAR(50),
    country VARCHAR(255),
    type VARCHAR(50),
    defaultfortype BOOLEAN,
    supplierid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (addressindex)
);

-- SupplierContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_suppliercontactsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_suppliercontactsstage (
    contactindex INT NOT NULL,
    name VARCHAR(255),
    phone VARCHAR(50),
    mobilephone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(255),
    `default` BOOLEAN,
    comment TEXT,
    includeinemail BOOLEAN,
    supplierid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contactindex)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Customer Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_customerstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_customerstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    displayname VARCHAR(255) NOT NULL,
    currency VARCHAR(255) NOT NULL,
    paymentterm VARCHAR(255) NOT NULL,
    discount DECIMAL(18,2) NOT NULL,
    taxrule VARCHAR(255) NOT NULL,
    carrier VARCHAR(255),
    salesrepresentative VARCHAR(255),
    location VARCHAR(255) NOT NULL,
    comments TEXT,
    accountreceivable VARCHAR(255) NOT NULL,
    revenueaccount VARCHAR(255) NOT NULL,
    pricetier VARCHAR(255) NOT NULL,
    taxnumber VARCHAR(255),
    additionalattribute1 VARCHAR(255),
    additionalattribute2 VARCHAR(255),
    additionalattribute3 VARCHAR(255),
    additionalattribute4 VARCHAR(255),
    additionalattribute5 VARCHAR(255),
    additionalattribute6 VARCHAR(255),
    additionalattribute7 VARCHAR(255),
    additionalattribute8 VARCHAR(255),
    additionalattribute9 VARCHAR(255),
    additionalattribute10 VARCHAR(255),
    attributeset VARCHAR(255),
    tags VARCHAR(255),
    status VARCHAR(255) NOT NULL,
    creditlimit DECIMAL(18,2) NOT NULL,
    isoncredithold BOOLEAN NOT NULL,
    lastmodifiedon DATETIME NOT NULL,
    addresses JSON,
    contacts JSON,
    productprices JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerAddresses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_customeraddressesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_customeraddressesstage (
    id VARCHAR(255),
    line1 VARCHAR(255),
    line2 VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postcode VARCHAR(50),
    country VARCHAR(255),
    type VARCHAR(50),
    defaultfortype BOOLEAN,
    customerid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_customercontactsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_customercontactsstage (
    id VARCHAR(255),
    name VARCHAR(255),
    jobtitle VARCHAR(255),
    phone VARCHAR(50),
    mobilephone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(255),
    `default` BOOLEAN,
    comment TEXT,
    includeinemail BOOLEAN,
    marketingconsent INT,
    customerid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerProductPrices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_customerproductpricesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_customerproductpricesstage (
    productid VARCHAR(255) NOT NULL,
    productname VARCHAR(255),
    productsku VARCHAR(255),
    price DECIMAL(18,2),
    customerid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (productid)
);

-- Disassembly Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_disassemblystage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_disassemblystage (
    taskid VARCHAR(255) NOT NULL,
    disassemblynumber VARCHAR(255),
    status VARCHAR(50),
    productid VARCHAR(255),
    productcode VARCHAR(255),
    productname VARCHAR(255),
    locationid VARCHAR(255),
    location VARCHAR(255),
    completiondate DATETIME,
    wipaccount VARCHAR(255),
    quantity DECIMAL(19,4),
    assemblyinstructionurl VARCHAR(2000),
    errors JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- DisassemblyPickLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_disassemblypicklinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_disassemblypicklinesstage (
    binid VARCHAR(255),
    bin VARCHAR(255),
    date DATETIME,
    batchsn VARCHAR(255),
    expirydate DATETIME,
    available DECIMAL(19,4),
    unitcost DECIMAL(19,4),
    quantity DECIMAL(19,4),
    totalcost DECIMAL(19,4),
    disassemblyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- DisassemblyOrderLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_disassemblyorderlinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_disassemblyorderlinesstage (
    productid VARCHAR(255),
    productcode VARCHAR(255),
    name VARCHAR(255),
    binid VARCHAR(255),
    bin VARCHAR(255),
    unit VARCHAR(50),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    account VARCHAR(255),
    quantity DECIMAL(19,4),
    cost DECIMAL(19,4),
    disassemblyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- DisassemblyOrderServiceLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_disassemblyorderservicelinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_disassemblyorderservicelinesstage (
    productid VARCHAR(255),
    name VARCHAR(255),
    account VARCHAR(255),
    comments TEXT,
    amount DECIMAL(19,4),
    disassemblyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- DisassemblyTransactions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_disassemblytransactionsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_disassemblytransactionsstage (
    id VARCHAR(255),
    effectivedate DATETIME,
    debit VARCHAR(255),
    credit VARCHAR(255),
    amount DECIMAL(19,4),
    disassemblyid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- FinishedGoods Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_finishedgoodsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_finishedgoodsstage (
    taskid VARCHAR(255) NOT NULL,
    assemblynumber VARCHAR(255),
    status VARCHAR(255),
    productid VARCHAR(255),
    productcode VARCHAR(255),
    productname VARCHAR(255),
    locationid VARCHAR(255),
    location VARCHAR(255),
    binid VARCHAR(255),
    bin VARCHAR(255),
    wipaccount VARCHAR(255),
    wipdate DATETIME,
    account VARCHAR(255),
    quantity DECIMAL(18,6),
    assemblyinstructionurl VARCHAR(255),
    completiondate DATETIME,
    batchsn VARCHAR(255),
    expirydate DATETIME,
    notes TEXT,
    customfield1 VARCHAR(255),
    customfield2 VARCHAR(255),
    customfield3 VARCHAR(255),
    customfield4 VARCHAR(255),
    customfield5 VARCHAR(255),
    customfield6 VARCHAR(255),
    customfield7 VARCHAR(255),
    customfield8 VARCHAR(255),
    customfield9 VARCHAR(255),
    customfield10 VARCHAR(255),
    errors JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- FinishedGoodsOrderLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_finishedgoodsorderlinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_finishedgoodsorderlinesstage (
    productid VARCHAR(255),
    productcode VARCHAR(255),
    name VARCHAR(500),
    expenseaccount VARCHAR(255),
    quantity DECIMAL(19,4),
    unit VARCHAR(100),
    wastagepercent DECIMAL(5,2),
    wastagequantity DECIMAL(19,4),
    totalquantity DECIMAL(19,4),
    totalcost DECIMAL(19,2),
    finishedgoodsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- FinishedGoodsPickLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_finishedgoodspicklinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_finishedgoodspicklinesstage (
    productid VARCHAR(255),
    productcode VARCHAR(255),
    name VARCHAR(500),
    binid VARCHAR(255),
    bin VARCHAR(255),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    quantity DECIMAL(19,4),
    unit VARCHAR(100),
    cost DECIMAL(19,2),
    finishedgoodsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- FinishedGoodsTransactions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_finishedgoodstransactionsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_finishedgoodstransactionsstage (
    id VARCHAR(255),
    effectivedate DATETIME,
    debit VARCHAR(255),
    credit VARCHAR(255),
    amount DECIMAL(19,2),
    finishedgoodsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Purchase Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasestage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasestage (
    id VARCHAR(255) NOT NULL,
    supplierid VARCHAR(255),
    supplier VARCHAR(255),
    contact VARCHAR(255),
    phone VARCHAR(50),
    inventoryaccount VARCHAR(50),
    blindreceipt BOOLEAN,
    approach VARCHAR(50),
    billingaddressdisplayline1 VARCHAR(500),
    billingaddressdisplayline2 VARCHAR(500),
    billingaddressline1 VARCHAR(255),
    billingaddressline2 VARCHAR(255),
    billingaddresscity VARCHAR(100),
    billingaddressstate VARCHAR(100),
    billingaddresspostcode VARCHAR(20),
    billingaddresscountry VARCHAR(100),
    shippingaddressdisplayline1 VARCHAR(500),
    shippingaddressdisplayline2 VARCHAR(500),
    shippingaddressline1 VARCHAR(255),
    shippingaddressline2 VARCHAR(255),
    shippingaddresscity VARCHAR(100),
    shippingaddressstate VARCHAR(100),
    shippingaddresspostcode VARCHAR(20),
    shippingaddresscountry VARCHAR(100),
    shippingaddressshiptoother BOOLEAN,
    basecurrency VARCHAR(10),
    suppliercurrency VARCHAR(10),
    taxrule VARCHAR(100),
    taxcalculation VARCHAR(50),
    terms VARCHAR(100),
    requiredby DATETIME,
    location VARCHAR(255),
    note TEXT,
    ordernumber VARCHAR(100),
    orderdate DATETIME,
    status VARCHAR(50),
    relateddropshipsaletask VARCHAR(255),
    currencyrate DECIMAL(19,6),
    lastupdateddate DATETIME,
    ordermemo TEXT,
    orderstatus VARCHAR(50),
    ordertotalbeforetax DECIMAL(19,2),
    ordertax DECIMAL(19,2),
    ordertotal DECIMAL(19,2),
    stockreceivedstatus VARCHAR(50),
    invoicedate DATETIME,
    invoiceduedate DATETIME,
    invoicenumber VARCHAR(100),
    invoicestatus VARCHAR(50),
    invoicetotalbeforetax DECIMAL(19,2),
    invoicetax DECIMAL(19,2),
    invoicetotal DECIMAL(19,2),
    invoicepaid DECIMAL(19,2),
    creditnotenumber VARCHAR(100),
    creditnotedate DATETIME,
    creditnotestatus VARCHAR(50),
    creditnotetotalbeforetax DECIMAL(19,2),
    creditnotetax DECIMAL(19,2),
    creditnotetotal DECIMAL(19,2),
    unstockstatus VARCHAR(50),
    manualjournalsstatus VARCHAR(50),
    additionalattribute1 VARCHAR(500),
    additionalattribute2 VARCHAR(500),
    additionalattribute3 VARCHAR(500),
    additionalattribute4 VARCHAR(500),
    additionalattribute5 VARCHAR(500),
    additionalattribute6 VARCHAR(500),
    additionalattribute7 VARCHAR(500),
    additionalattribute8 VARCHAR(500),
    additionalattribute9 VARCHAR(500),
    additionalattribute10 VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseorderlinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseorderlinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(500),
    quantity DECIMAL(19,4),
    price DECIMAL(19,4),
    discount DECIMAL(19,4),
    tax DECIMAL(19,4),
    taxrule VARCHAR(100),
    suppliersku VARCHAR(255),
    comment TEXT,
    total DECIMAL(19,2),
    productlength DECIMAL(19,4),
    productwidth DECIMAL(19,4),
    productheight DECIMAL(19,4),
    productweight DECIMAL(19,4),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(500),
    productcustomfield2 VARCHAR(500),
    productcustomfield3 VARCHAR(500),
    productcustomfield4 VARCHAR(500),
    productcustomfield5 VARCHAR(500),
    productcustomfield6 VARCHAR(500),
    productcustomfield7 VARCHAR(500),
    productcustomfield8 VARCHAR(500),
    productcustomfield9 VARCHAR(500),
    productcustomfield10 VARCHAR(500),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseOrderAdditionalCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseorderadditionalchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseorderadditionalchargesstage (
    description VARCHAR(500),
    reference VARCHAR(255),
    price DECIMAL(19,2),
    quantity DECIMAL(19,4),
    discount DECIMAL(19,2),
    tax DECIMAL(19,2),
    total DECIMAL(19,2),
    taxrule VARCHAR(100),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseOrderPrepayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseorderprepaymentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseorderprepaymentsstage (
    id VARCHAR(255),
    reference VARCHAR(255),
    amount DECIMAL(19,2),
    datepaid DATETIME,
    account VARCHAR(50),
    currencyrate DECIMAL(19,6),
    datecreated DATETIME,
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseStockReceivedLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasestockreceivedlinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasestockreceivedlinesstage (
    date DATETIME,
    quantity DECIMAL(19,4),
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(500),
    location VARCHAR(255),
    locationid VARCHAR(255),
    received BOOLEAN,
    batchsn VARCHAR(255),
    suppliersku VARCHAR(255),
    expirydate DATETIME,
    cardid VARCHAR(255),
    productlength DECIMAL(19,4),
    productwidth DECIMAL(19,4),
    productheight DECIMAL(19,4),
    productweight DECIMAL(19,4),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(500),
    productcustomfield2 VARCHAR(500),
    productcustomfield3 VARCHAR(500),
    productcustomfield4 VARCHAR(500),
    productcustomfield5 VARCHAR(500),
    productcustomfield6 VARCHAR(500),
    productcustomfield7 VARCHAR(500),
    productcustomfield8 VARCHAR(500),
    productcustomfield9 VARCHAR(500),
    productcustomfield10 VARCHAR(500),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseInvoiceLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseinvoicelinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseinvoicelinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(500),
    quantity DECIMAL(19,4),
    price DECIMAL(19,4),
    discount DECIMAL(19,4),
    tax DECIMAL(19,4),
    taxrule VARCHAR(100),
    account VARCHAR(50),
    comment TEXT,
    total DECIMAL(19,2),
    productlength DECIMAL(19,4),
    productwidth DECIMAL(19,4),
    productheight DECIMAL(19,4),
    productweight DECIMAL(19,4),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(500),
    productcustomfield2 VARCHAR(500),
    productcustomfield3 VARCHAR(500),
    productcustomfield4 VARCHAR(500),
    productcustomfield5 VARCHAR(500),
    productcustomfield6 VARCHAR(500),
    productcustomfield7 VARCHAR(500),
    productcustomfield8 VARCHAR(500),
    productcustomfield9 VARCHAR(500),
    productcustomfield10 VARCHAR(500),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseInvoiceAddCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseinvoiceaddchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseinvoiceaddchargesstage (
    description VARCHAR(500),
    reference VARCHAR(255),
    quantity DECIMAL(19,4),
    price DECIMAL(19,2),
    discount DECIMAL(19,2),
    tax DECIMAL(19,2),
    taxrule VARCHAR(100),
    account VARCHAR(50),
    total DECIMAL(19,2),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseInvoicePayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseinvoicepaymentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseinvoicepaymentsstage (
    id VARCHAR(255),
    reference VARCHAR(255),
    amount DECIMAL(19,2),
    datepaid DATETIME,
    account VARCHAR(50),
    currencyrate DECIMAL(19,6),
    datecreated DATETIME,
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseCreditNoteLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasecreditnotelinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasecreditnotelinesstage (
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(500),
    quantity DECIMAL(19,4),
    price DECIMAL(19,4),
    discount DECIMAL(19,4),
    tax DECIMAL(19,4),
    taxrule VARCHAR(100),
    account VARCHAR(50),
    comment TEXT,
    total DECIMAL(19,2),
    productlength DECIMAL(19,4),
    productwidth DECIMAL(19,4),
    productheight DECIMAL(19,4),
    productweight DECIMAL(19,4),
    weightunits VARCHAR(50),
    dimensionsunits VARCHAR(50),
    productcustomfield1 VARCHAR(500),
    productcustomfield2 VARCHAR(500),
    productcustomfield3 VARCHAR(500),
    productcustomfield4 VARCHAR(500),
    productcustomfield5 VARCHAR(500),
    productcustomfield6 VARCHAR(500),
    productcustomfield7 VARCHAR(500),
    productcustomfield8 VARCHAR(500),
    productcustomfield9 VARCHAR(500),
    productcustomfield10 VARCHAR(500),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurCreditNoteAddCharges Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purcreditnoteaddchargesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purcreditnoteaddchargesstage (
    description VARCHAR(500),
    reference VARCHAR(255),
    quantity DECIMAL(19,4),
    price DECIMAL(19,2),
    discount DECIMAL(19,2),
    tax DECIMAL(19,2),
    taxrule VARCHAR(100),
    account VARCHAR(50),
    total DECIMAL(19,2),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseCreditNoteRefunds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasecreditnoterefundsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasecreditnoterefundsstage (
    id VARCHAR(255),
    reference VARCHAR(255),
    amount DECIMAL(19,2),
    datepaid DATETIME,
    account VARCHAR(50),
    currencyrate DECIMAL(19,6),
    datecreated DATETIME,
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseCreditNoteUnstockLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasecreditnoteunstocklinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasecreditnoteunstocklinesstage (
    cardid VARCHAR(255),
    date DATETIME,
    quantity DECIMAL(19,4),
    productid VARCHAR(255),
    sku VARCHAR(255),
    name VARCHAR(500),
    location VARCHAR(255),
    batchsn VARCHAR(255),
    expirydate DATETIME,
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseManualJournalLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchasemanualjournallinesstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchasemanualjournallinesstage (
    reference VARCHAR(255),
    amount DECIMAL(19,2),
    date DATETIME,
    debit VARCHAR(50),
    credit VARCHAR(50),
    issystem BOOLEAN,
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseAttachments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseattachmentsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseattachmentsstage (
    id VARCHAR(255),
    contenttype VARCHAR(100),
    filename VARCHAR(255),
    downloadurl VARCHAR(2000),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseInventoryMovements Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_purchaseinventorymovementsstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_purchaseinventorymovementsstage (
    taskid VARCHAR(255),
    productid VARCHAR(255),
    date DATETIME,
    cogs DECIMAL(19,2),
    productlength DECIMAL(19,4),
    productwidth DECIMAL(19,4),
    productheight DECIMAL(19,4),
    productweight DECIMAL(19,4),
    weightunits VARCHAR(20),
    dimensionsunits VARCHAR(20),
    productcustomfield1 VARCHAR(255),
    productcustomfield2 VARCHAR(255),
    productcustomfield3 VARCHAR(255),
    productcustomfield4 VARCHAR(255),
    productcustomfield5 VARCHAR(255),
    productcustomfield6 VARCHAR(255),
    productcustomfield7 VARCHAR(255),
    productcustomfield8 VARCHAR(255),
    productcustomfield9 VARCHAR(255),
    productcustomfield10 VARCHAR(255),
    purchaseid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ProductAvailability Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productavailabilitystage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productavailabilitystage (
    id VARCHAR(255) NOT NULL,
    sku VARCHAR(255),
    name VARCHAR(255),
    barcode VARCHAR(255),
    location VARCHAR(255),
    bin VARCHAR(255),
    batch VARCHAR(255),
    expirydate DATETIME,
    onhand DECIMAL(18,6),
    allocated DECIMAL(18,6),
    available DECIMAL(18,6),
    onorder DECIMAL(18,6),
    stockonhand DECIMAL(18,6),
    intransit DECIMAL(18,6),
    nextdeliverydate DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccount Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_chartofaccountstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_chartofaccountstage (
    code VARCHAR(50) NOT NULL,
    status VARCHAR(20),
    name VARCHAR(255),
    type VARCHAR(50),
    description TEXT,
    class VARCHAR(50),
    systemaccount VARCHAR(50),
    bankaccountnumber VARCHAR(50),
    bankaccountid VARCHAR(255),
    forpayments BOOLEAN,
    displayname VARCHAR(300),
    oldcode VARCHAR(50),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (code)
);

-- Pattern: c{clientID}_{orgID}_cin7_dear_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ProductAttachment Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_cin7_dear_productattachmentstage;
CREATE TABLE c{clientID}_{orgID}_cin7_dear_productattachmentstage (
    id VARCHAR(255) NOT NULL,
    contenttype VARCHAR(255),
    isdefault BOOLEAN,
    filename VARCHAR(255),
    downloadurl VARCHAR(1024),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    productid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);