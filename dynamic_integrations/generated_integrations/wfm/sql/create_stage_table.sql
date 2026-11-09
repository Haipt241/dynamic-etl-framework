-- WFM Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- CustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_customfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_customfieldsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    type VARCHAR(255),
    mandatory BOOLEAN,
    link VARCHAR(500),
    options JSON,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    objectsclient TEXT,
    objectsclientenabled BOOLEAN,
    objectsclientorder INT,
    objectscontact TEXT,
    objectscontactenabled BOOLEAN,
    objectscontactorder INT,
    objectssupplier TEXT,
    objectssupplierenabled BOOLEAN,
    objectssupplierorder INT,
    objectsjob TEXT,
    objectsjobenabled BOOLEAN,
    objectsjoborder INT,
    objectslead TEXT,
    objectsleadenabled BOOLEAN,
    objectsleadorder INT,
    objectsjobtask TEXT,
    objectsjobtaskenabled BOOLEAN,
    objectsjobtaskorder INT,
    objectsjobcost TEXT,
    objectsjobcostenabled BOOLEAN,
    objectsjobcostorder INT,
    objectstimesheet TEXT,
    objectstimesheetenabled BOOLEAN,
    objectstimesheetorder INT,
    objectsquote TEXT,
    objectsquoteenabled BOOLEAN,
    objectsquoteorder INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Costs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_costsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_costsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    costcode VARCHAR(255),
    note TEXT,
    type VARCHAR(255),
    billable BOOLEAN,
    unitcost DECIMAL(18,2),
    unitprice DECIMAL(18,2),
    incomeaccount VARCHAR(255),
    costofsaleaccount VARCHAR(255),
    salestax JSON,
    purchasetax JSON,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    supplieruuid VARCHAR(255),
    suppliername VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobcategoriesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobcategoriesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    incomeaccount VARCHAR(255),
    costofsaleaccount VARCHAR(255),
    createdat DATETIME,
    updatedat DATETIME,
    deletedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobStatus Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobstatusstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobstatusstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    type VARCHAR(255),
    showinmyjobs BOOLEAN,
    showinschedule BOOLEAN,
    lockcosts BOOLEAN,
    locktimesheets BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Staff Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_staffstage;
CREATE TABLE c{clientID}_{orgID}_wfm_staffstage (
    id VARCHAR(255) NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    currentlyworking BOOLEAN,
    baserate DECIMAL(10,2),
    billablerate DECIMAL(10,2),
    director BOOLEAN,
    freeearner BOOLEAN,
    fulltimeequivalent INT,
    payrollcode VARCHAR(255),
    notes TEXT,
    role VARCHAR(255),
    historicrates JSON,
    createdat DATETIME,
    updatedat DATETIME,
    deletedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    contactdetailsemail VARCHAR(255),
    contactdetailsmobile VARCHAR(255),
    contactdetailsphone VARCHAR(255),
    contactdetailsaddress VARCHAR(255),
    capacityproductivityrate VARCHAR(255),
    capacitymonday VARCHAR(255),
    capacitytuesday VARCHAR(255),
    capacitywednesday VARCHAR(255),
    capacitythursday VARCHAR(255),
    capacityfriday VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Taxes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_taxesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_taxesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    type VARCHAR(255),
    rate DECIMAL(10,2),
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LeadCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_leadcategoriesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_leadcategoriesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    createdat DATETIME,
    updatedat DATETIME,
    deletedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_tasksstage;
CREATE TABLE c{clientID}_{orgID}_wfm_tasksstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    baserate DECIMAL(10,2),
    billablerate DECIMAL(10,2),
    exportcode VARCHAR(255),
    salestax JSON,
    historicrates JSON,
    incomeaccount VARCHAR(255),
    createdat DATETIME,
    updatedat DATETIME,
    deletedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Jobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsstage (
    id VARCHAR(255) NOT NULL,
    jobnumber VARCHAR(255),
    name VARCHAR(255),
    clientuuid VARCHAR(255),
    clientcontactuuid VARCHAR(255),
    description TEXT,
    clientordernumber VARCHAR(255),
    budget DECIMAL(18,2),
    jobstatusuuid VARCHAR(255),
    jobcategoryuuid VARCHAR(255),
    priority VARCHAR(255),
    taskinvoicerate VARCHAR(255),
    excludeestimatedbillings BOOLEAN,
    estimatedbillings DECIMAL(18,2),
    capacityreducing BOOLEAN,
    clientmanageruuid VARCHAR(255),
    jobmanageruuid VARCHAR(255),
    startdate DATE,
    duedate DATE,
    completeddate DATE,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Timesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_timesheetsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_timesheetsstage (
    id VARCHAR(255) NOT NULL,
    time INT,
    starttime VARCHAR(255),
    endtime VARCHAR(255),
    date DATE,
    note VARCHAR(255),
    billable BOOLEAN,
    submittedat DATE,
    createdat DATETIME,
    updatedat DATETIME,
    jobuuid VARCHAR(255),
    jobjobnumber VARCHAR(255),
    jobname VARCHAR(255),
    jobtaskuuid VARCHAR(255),
    jobtaskname VARCHAR(255),
    jobtasklabel VARCHAR(255),
    staffuuid VARCHAR(255),
    stafffirstname VARCHAR(255),
    stafflastname VARCHAR(255),
    wipbaserate DECIMAL(10,2),
    wipcostamount DECIMAL(10,2),
    wipstandardrate DECIMAL(10,2),
    wipstandardamount DECIMAL(10,2),
    wipchargerate DECIMAL(10,2),
    wipchargeamount DECIMAL(10,2),
    wipinvoiceuuid VARCHAR(100),
    wipinvoicetaskuuid VARCHAR(100),
    wipinvoicedate DATE,
    wipinvoicerate DECIMAL(10,2),
    wipinvoicetime INT,
    wipinvoiceamount DECIMAL(10,2),
    wipinvoicewriteonamount DECIMAL(10,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Clients Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    exportcode VARCHAR(255),
    clientmanageruuid VARCHAR(255),
    jobmanageruuid VARCHAR(255),
    referralsource VARCHAR(255),
    prospect BOOLEAN,
    archived BOOLEAN,
    favorite BOOLEAN,
    addresses JSON,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    contactdetailsemail VARCHAR(255),
    contactdetailsphone VARCHAR(255),
    contactdetailsfax VARCHAR(255),
    contactdetailswebsite VARCHAR(255),
    billingdetailsbusinessstructureuuid VARCHAR(255),
    billingdetailsclienttypeuuid VARCHAR(255),
    billingdetailsbalancedate VARCHAR(255),
    billingdetailsmarkup INT,
    billingdetailszeroratedtaxrate TEXT,
    billingdetailszeroratedtaxratetaxname VARCHAR(255),
    billingdetailszeroratedtaxraterate INT,
    billingdetailsinvoiceduedate DATETIME,
    billingdetailsbillingclientuuid VARCHAR(255),
    billingdetailscustomrates TEXT,
    billingdetailstaxnumbers TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Quotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotesstage (
    id VARCHAR(255) NOT NULL,
    quotenumber VARCHAR(255),
    quotename VARCHAR(255),
    clientuuid VARCHAR(255),
    contactuuid VARCHAR(255),
    salespersonuuid VARCHAR(255),
    jobmasterquote BOOLEAN,
    type VARCHAR(255),
    description TEXT,
    optionalitemsexplanation TEXT,
    validfrom DATE,
    validto DATE,
    sent BOOLEAN,
    status VARCHAR(255),
    accepteddeclineddate DATETIME,
    budget DECIMAL(15,2),
    fixedprice BOOLEAN,
    amountextax DECIMAL(15,2),
    amountinctax DECIMAL(15,2),
    costamountextax DECIMAL(15,2),
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    leaduuid VARCHAR(255),
    leadname VARCHAR(255),
    jobuuid VARCHAR(255),
    jobnumber VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Invoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesstage (
    id VARCHAR(255) NOT NULL,
    invoicenumber VARCHAR(255),
    description TEXT,
    clientuuid VARCHAR(255),
    contactuuid VARCHAR(255),
    date DATE,
    duedate DATE,
    sent BOOLEAN,
    status VARCHAR(255),
    type VARCHAR(255),
    mode VARCHAR(255),
    progressdate DATE,
    fixedprice BOOLEAN,
    amountextax DECIMAL(15,2),
    amountinctax DECIMAL(15,2),
    amountpaid DECIMAL(15,2),
    datepaid DATE,
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersstage (
    id VARCHAR(255) NOT NULL,
    supplieruuid VARCHAR(255),
    purchaseordernumber VARCHAR(255),
    status VARCHAR(255),
    billingstatus VARCHAR(255),
    stockreceiptstatus VARCHAR(255),
    description TEXT,
    deliveryaddress TEXT,
    date DATE,
    sent BOOLEAN,
    amountextax DECIMAL(18,2),
    amountinctax DECIMAL(18,2),
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderBills Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseorderbillsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseorderbillsstage (
    id VARCHAR(255) NOT NULL,
    purchaseorderuuid VARCHAR(255),
    date DATE,
    supplierbillnumber VARCHAR(255),
    duedate DATE,
    status VARCHAR(255),
    stockreceiptid VARCHAR(255),
    receiptdate DATE,
    tax JSON,
    amountextax DECIMAL(18,2),
    amountinctax DECIMAL(18,2),
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockReceipts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_stockreceiptsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_stockreceiptsstage (
    id VARCHAR(255) NOT NULL,
    purchaseorderuuid VARCHAR(255),
    date DATETIME,
    stockreceiptnote VARCHAR(255),
    stockreceiptid VARCHAR(255),
    supplierbillnumber VARCHAR(255),
    billdate DATETIME,
    duedate DATETIME,
    tax JSON,
    amountextax DECIMAL(15,2),
    amountinctax DECIMAL(15,2),
    createdat DATETIME,
    updatedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Suppliers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_suppliersstage;
CREATE TABLE c{clientID}_{orgID}_wfm_suppliersstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    exportcode VARCHAR(255),
    status VARCHAR(50),
    favourite BOOLEAN,
    zeroratedgst JSON,
    addresses JSON,
    createdat DATETIME,
    updatedat DATETIME,
    deletedat DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    contactdetailsemail VARCHAR(255),
    contactdetailsphone VARCHAR(255),
    contactdetailsfax VARCHAR(255),
    contactdetailswebsite VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StaffCustTaskRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_staffcusttaskratesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_staffcusttaskratesstage (
    taskuuid VARCHAR(255),
    baserate INT,
    billablerate INT,
    staffid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- StaffHistoricRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_staffhistoricratesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_staffhistoricratesstage (
    applieduptodate DATETIME,
    billablerate INT,
    staffid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TasksCustomRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_taskscustomratesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_taskscustomratesstage (
    clientuuid VARCHAR(255),
    billablerate INT,
    tasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- JobsCustomfields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobscustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobscustomfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobstasksstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobstasksstage (
    uuid VARCHAR(255),
    taskuuid VARCHAR(255),
    name VARCHAR(255),
    label VARCHAR(255),
    phaseuuid VARCHAR(255),
    description VARCHAR(255),
    billable BOOLEAN,
    custombillablerate INT,
    completed BOOLEAN,
    startdate VARCHAR(255),
    duedate VARCHAR(255),
    estimatedminutes INT,
    actualminutes INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsTasksStaffs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobstasksstaffsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobstasksstaffsstage (
    uuid VARCHAR(255),
    allocatedtime INT,
    jobsid VARCHAR(255) NOT NULL,
    jobstasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsTasksCustFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobstaskscustfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobstaskscustfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    jobstasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobscostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobscostsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    costcode VARCHAR(255),
    costuuid VARCHAR(255),
    date VARCHAR(255),
    quantity INT,
    note VARCHAR(255),
    type VARCHAR(255),
    billable BOOLEAN,
    actual BOOLEAN,
    unitcost INT,
    unitprice INT,
    supplieruuid VARCHAR(255),
    phaseuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsCostsCustFlds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobscostscustfldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobscostscustfldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    jobscostsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phaseuuid VARCHAR(255),
    description VARCHAR(255),
    date VARCHAR(255),
    createdbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsDocuments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsdocumentsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsdocumentsstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    filename VARCHAR(255),
    filesize INT,
    note VARCHAR(255),
    phaseuuid VARCHAR(255),
    downloadurl VARCHAR(255),
    uploadedbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsStaffassigned Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsstaffassignedstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsstaffassignedstage (
    uuid VARCHAR(255),
    custombillablerate INT,
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsPhases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsphasesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsphasesstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- JobsMilestones Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsmilestonesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsmilestonesstage (
    name VARCHAR(255),
    date VARCHAR(255),
    phaseuuid VARCHAR(255),
    completed BOOLEAN,
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsQuotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsquotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsquotesstage (
    uuid VARCHAR(255),
    clientuuid VARCHAR(255),
    contactuuid VARCHAR(255),
    number VARCHAR(255),
    name VARCHAR(255),
    type VARCHAR(255),
    status VARCHAR(255),
    ismasterquote BOOLEAN,
    validfrom VARCHAR(255),
    validto VARCHAR(255),
    salespersonuuid VARCHAR(255),
    budget INT,
    amountextax INT,
    amountinctax INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsQuotesCustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsquotescustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsquotescustomfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    jobsquotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsInvoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobsinvoicesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobsinvoicesstage (
    uuid VARCHAR(255),
    clientuuid VARCHAR(255),
    contactuuid VARCHAR(255),
    number VARCHAR(255),
    clientordernumber VARCHAR(255),
    date VARCHAR(255),
    duedate VARCHAR(255),
    datepaid VARCHAR(255),
    status VARCHAR(255),
    amountextax INT,
    amountinctax INT,
    amountpaid INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsPurchOrd Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_jobspurchordstage;
CREATE TABLE c{clientID}_{orgID}_wfm_jobspurchordstage (
    uuid VARCHAR(255),
    supplieruuid VARCHAR(255),
    date VARCHAR(255),
    status VARCHAR(255),
    receivingstatus VARCHAR(255),
    billingstatus VARCHAR(255),
    amountextax INT,
    amountinctax INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- TimesheetsCustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_timesheetscustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_timesheetscustomfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    timesheetsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- ClientsContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientscontactsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientscontactsstage (
    uuid VARCHAR(255),
    salutation VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    position VARCHAR(255),
    `primary` BOOLEAN,
    includeinemails BOOLEAN,
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- ClientsBillCustRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientsbillcustratesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientsbillcustratesstage (
    taskuuid VARCHAR(255),
    billablerate INT,
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ClientsCliGrps Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientscligrpsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientscligrpsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    taxable BOOLEAN,
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- ClientsClientRel Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientsclientrelstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientsclientrelstage (
    uuid VARCHAR(255),
    relatedclientuuid VARCHAR(255),
    type VARCHAR(255),
    startdate VARCHAR(255),
    enddate VARCHAR(255),
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ClientsNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientsnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientsnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phase VARCHAR(255),
    description VARCHAR(255),
    date VARCHAR(255),
    createdbyfirstname VARCHAR(255),
    createdbylastname VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- ClientsDocuments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientsdocumentsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientsdocumentsstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    filename VARCHAR(255),
    filesize INT,
    note VARCHAR(255),
    phase VARCHAR(255),
    downloadurl VARCHAR(255),
    uploadedbyfirstname VARCHAR(255),
    uploadedbylastname VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- ClientsCustFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_clientscustfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_clientscustfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesPhases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotesphasesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotesphasesstage (
    uuid VARCHAR(255),
    jobphaseuuid VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    `order` INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotesnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotesnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phase VARCHAR(255),
    description VARCHAR(255),
    date VARCHAR(255),
    createdbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesDocuments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotesdocumentsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotesdocumentsstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    filename VARCHAR(255),
    filesize INT,
    note VARCHAR(255),
    phase VARCHAR(255),
    downloadurl VARCHAR(255),
    uploadedbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotestasksstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotestasksstage (
    uuid VARCHAR(255),
    taskuuid VARCHAR(255),
    jobtaskuuid VARCHAR(255),
    quotephaseuuid VARCHAR(255),
    name VARCHAR(255),
    label VARCHAR(255),
    description VARCHAR(255),
    billable BOOLEAN,
    optional BOOLEAN,
    accepted BOOLEAN,
    time INT,
    staffrates BOOLEAN,
    baserate INT,
    billablerate INT,
    fixedprice BOOLEAN,
    costamount INT,
    amount INT,
    tax JSON,
    `order` INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesTasksStaff Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotestasksstaffstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotestasksstaffstage (
    uuid VARCHAR(255),
    time VARCHAR(255),
    baserate VARCHAR(255),
    billablerate VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    quotestasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- QuotesCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotescostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotescostsstage (
    uuid VARCHAR(255),
    costuuid VARCHAR(255),
    jobcostuuid VARCHAR(255),
    quotephaseuuid VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    costcode VARCHAR(255),
    costnote VARCHAR(255),
    type VARCHAR(255),
    quantity INT,
    unitprice INT,
    unitcost INT,
    billable BOOLEAN,
    optional BOOLEAN,
    accepted BOOLEAN,
    fixedprice BOOLEAN,
    amount INT,
    tax JSON,
    `order` INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- QuotesCustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_quotescustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_quotescustomfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    quotesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- InvoicesJobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesjobsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesjobsstage (
    uuid VARCHAR(255),
    number VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    clientordernumber VARCHAR(255),
    taskinvoicemode VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, invoicesid, organisationid)
);

-- InvoicesJobsPhases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesjobsphasesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesjobsphasesstage (
    uuid VARCHAR(255),
    jobphaseuuid VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    `order` INT,
    invoicesid VARCHAR(255) NOT NULL,
    invoicesjobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- InvoicesJobsTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesjobstasksstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesjobstasksstage (
    uuid VARCHAR(255),
    taskuuid VARCHAR(255),
    jobtaskuuid VARCHAR(255),
    invoicephaseuuid VARCHAR(255),
    name VARCHAR(255),
    label VARCHAR(255),
    description VARCHAR(255),
    billable BOOLEAN,
    additional BOOLEAN,
    billablerate INT,
    time INT,
    fixedprice BOOLEAN,
    amount INT,
    tax JSON,
    `order` INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    invoicesjobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- InvoicesJobsTasksTimebreakdown Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesjobstaskstimebreakdownstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesjobstaskstimebreakdownstage (
    jobtimesheetuuid VARCHAR(255),
    invoicetimesheetuuid VARCHAR(255),
    date VARCHAR(255),
    staffuuid VARCHAR(255),
    stafffirstname VARCHAR(255),
    stafflastname VARCHAR(255),
    invoicebillable VARCHAR(255),
    billablerate INT,
    time INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    invoicesjobsid VARCHAR(255) NOT NULL,
    invoicesjobstasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- InvoicesJobsCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesjobscostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesjobscostsstage (
    uuid VARCHAR(255),
    jobcostuuid VARCHAR(255),
    costuuid VARCHAR(255),
    invoicephaseuuid VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    costcode VARCHAR(255),
    costnote VARCHAR(255),
    type VARCHAR(255),
    quantity INT,
    unitcost INT,
    unitprice INT,
    billable BOOLEAN,
    fixedprice BOOLEAN,
    amount INT,
    tax JSON,
    additional BOOLEAN,
    `order` INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    invoicesjobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- InvoicesNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicesnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicesnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phase VARCHAR(255),
    description VARCHAR(255),
    date VARCHAR(255),
    createdbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- InvoicesPayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_invoicespaymentsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_invoicespaymentsstage (
    date VARCHAR(255),
    amount DECIMAL(10,2),
    reference VARCHAR(255),
    accountuuid VARCHAR(255),
    accountname VARCHAR(255),
    updatedat VARCHAR(255),
    invoicesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseOrdersJobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersjobsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersjobsstage (
    jobuuid VARCHAR(255),
    jobnumber VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseOrdersCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseorderscostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseorderscostsstage (
    uuid VARCHAR(255),
    jobuuid VARCHAR(255),
    jobcostuuid VARCHAR(255),
    costuuid VARCHAR(255),
    type VARCHAR(255),
    description VARCHAR(255),
    code VARCHAR(255),
    notes VARCHAR(255),
    quantity INT,
    unitcost INT,
    tax JSON,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- PurchaseOrdersStockRec Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersstockrecstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersstockrecstage (
    uuid VARCHAR(255),
    receiptdate VARCHAR(255),
    stockreceiptnote VARCHAR(255),
    stockreceiptid VARCHAR(255),
    supplierbillnumber VARCHAR(255),
    billdate VARCHAR(255),
    tax JSON,
    amountextax INT,
    amountinctax INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_wfm_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrdersBills Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersbillsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersbillsstage (
    uuid VARCHAR(255),
    date VARCHAR(255),
    supplierbillnumber VARCHAR(255),
    duedate VARCHAR(255),
    tax JSON,
    stockreceiptid VARCHAR(255),
    receiptdate VARCHAR(255),
    amountextax INT,
    amountinctax INT,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- PurchaseOrdersNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phase VARCHAR(255),
    description VARCHAR(255),
    date VARCHAR(255),
    createdbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- PurchaseOrdersDocs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseordersdocsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseordersdocsstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    filename VARCHAR(255),
    filesize INT,
    note VARCHAR(255),
    purchaseorderphase VARCHAR(255),
    downloadurl VARCHAR(255),
    uploadedbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- PurchaseOrderBillsCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_purchaseorderbillscostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_purchaseorderbillscostsstage (
    uuid VARCHAR(255),
    purchaseordercostuuid VARCHAR(255),
    name VARCHAR(255),
    additional BOOLEAN,
    quantity INT,
    unitcost INT,
    tax JSON,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    purchaseorderbillsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- StockReceiptsCosts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_stockreceiptscostsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_stockreceiptscostsstage (
    uuid VARCHAR(255),
    purchaseordercostuuid VARCHAR(255),
    name VARCHAR(255),
    additional BOOLEAN,
    quantity INT,
    unitcost INT,
    tax JSON,
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    stockreceiptsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- SuppliersContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_supplierscontactsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_supplierscontactsstage (
    uuid VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    position VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    mobile VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    suppliersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- SuppliersNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_suppliersnotesstage;
CREATE TABLE c{clientID}_{orgID}_wfm_suppliersnotesstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    phase VARCHAR(255),
    note VARCHAR(255),
    createdbyuuid VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    suppliersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- SuppliersDocuments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_suppliersdocumentsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_suppliersdocumentsstage (
    uuid VARCHAR(255),
    title VARCHAR(255),
    filename VARCHAR(255),
    filesize INT,
    note VARCHAR(255),
    phase VARCHAR(255),
    downloadurl VARCHAR(255),
    uploadedby VARCHAR(255),
    createdat VARCHAR(255),
    updatedat VARCHAR(255),
    suppliersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- SuppliersCustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_wfm_supplierscustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_wfm_supplierscustomfieldsstage (
    uuid VARCHAR(255),
    name VARCHAR(255),
    value VARCHAR(255),
    suppliersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);