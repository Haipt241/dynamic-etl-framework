-- WFM Production Tables - Auto Generated
-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_customfields;
CREATE TABLE c{clientID}_wfm_customfields (
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

-- Costs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_costs;
CREATE TABLE c{clientID}_wfm_costs (
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

-- JobCategories Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobcategories;
CREATE TABLE c{clientID}_wfm_jobcategories (
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

-- JobStatus Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobstatus;
CREATE TABLE c{clientID}_wfm_jobstatus (
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

-- Staff Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_staff;
CREATE TABLE c{clientID}_wfm_staff (
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

-- Taxes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_taxes;
CREATE TABLE c{clientID}_wfm_taxes (
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

-- LeadCategories Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_leadcategories;
CREATE TABLE c{clientID}_wfm_leadcategories (
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

-- Tasks Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_tasks;
CREATE TABLE c{clientID}_wfm_tasks (
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

-- Jobs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobs;
CREATE TABLE c{clientID}_wfm_jobs (
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

-- Timesheets Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_timesheets;
CREATE TABLE c{clientID}_wfm_timesheets (
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


-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Clients Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clients;
CREATE TABLE c{clientID}_wfm_clients (
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

-- Quotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotes;
CREATE TABLE c{clientID}_wfm_quotes (
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

-- Invoices Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoices;
CREATE TABLE c{clientID}_wfm_invoices (
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

-- PurchaseOrders Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseorders;
CREATE TABLE c{clientID}_wfm_purchaseorders (
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

-- PurchaseOrderBills Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseorderbills;
CREATE TABLE c{clientID}_wfm_purchaseorderbills (
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

-- StockReceipts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_stockreceipts;
CREATE TABLE c{clientID}_wfm_stockreceipts (
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

-- Suppliers Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_suppliers;
CREATE TABLE c{clientID}_wfm_suppliers (
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

-- StaffCustTaskRates Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_staffcusttaskrates;
CREATE TABLE c{clientID}_wfm_staffcusttaskrates (
    taskuuid VARCHAR(255),
    baserate INT,
    billablerate INT,
    staffid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- StaffHistoricRates Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_staffhistoricrates;
CREATE TABLE c{clientID}_wfm_staffhistoricrates (
    applieduptodate DATETIME,
    billablerate INT,
    staffid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TasksCustomRates Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_taskscustomrates;
CREATE TABLE c{clientID}_wfm_taskscustomrates (
    clientuuid VARCHAR(255),
    billablerate INT,
    tasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobsCustomfields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobscustomfields;
CREATE TABLE c{clientID}_wfm_jobscustomfields (
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

-- JobsTasks Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobstasks;
CREATE TABLE c{clientID}_wfm_jobstasks (
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

-- JobsTasksStaffs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobstasksstaffs;
CREATE TABLE c{clientID}_wfm_jobstasksstaffs (
    uuid VARCHAR(255),
    allocatedtime INT,
    jobsid VARCHAR(255) NOT NULL,
    jobstasksid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JobsTasksCustFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobstaskscustfields;
CREATE TABLE c{clientID}_wfm_jobstaskscustfields (
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

-- JobsCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobscosts;
CREATE TABLE c{clientID}_wfm_jobscosts (
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

-- JobsCostsCustFlds Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobscostscustflds;
CREATE TABLE c{clientID}_wfm_jobscostscustflds (
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

-- JobsNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsnotes;
CREATE TABLE c{clientID}_wfm_jobsnotes (
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

-- JobsDocuments Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsdocuments;
CREATE TABLE c{clientID}_wfm_jobsdocuments (
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

-- JobsStaffassigned Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsstaffassigned;
CREATE TABLE c{clientID}_wfm_jobsstaffassigned (
    uuid VARCHAR(255),
    custombillablerate INT,
    jobsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uuid, organisationid)
);

-- JobsPhases Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsphases;
CREATE TABLE c{clientID}_wfm_jobsphases (
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

-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobsMilestones Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsmilestones;
CREATE TABLE c{clientID}_wfm_jobsmilestones (
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

-- JobsQuotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsquotes;
CREATE TABLE c{clientID}_wfm_jobsquotes (
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

-- JobsQuotesCustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsquotescustomfields;
CREATE TABLE c{clientID}_wfm_jobsquotescustomfields (
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

-- JobsInvoices Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobsinvoices;
CREATE TABLE c{clientID}_wfm_jobsinvoices (
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

-- JobsPurchOrd Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_jobspurchord;
CREATE TABLE c{clientID}_wfm_jobspurchord (
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

-- TimesheetsCustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_timesheetscustomfields;
CREATE TABLE c{clientID}_wfm_timesheetscustomfields (
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

-- ClientsContacts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientscontacts;
CREATE TABLE c{clientID}_wfm_clientscontacts (
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

-- ClientsBillCustRates Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientsbillcustrates;
CREATE TABLE c{clientID}_wfm_clientsbillcustrates (
    taskuuid VARCHAR(255),
    billablerate INT,
    clientsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ClientsCliGrps Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientscligrps;
CREATE TABLE c{clientID}_wfm_clientscligrps (
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

-- ClientsClientRel Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientsclientrel;
CREATE TABLE c{clientID}_wfm_clientsclientrel (
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

-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ClientsNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientsnotes;
CREATE TABLE c{clientID}_wfm_clientsnotes (
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

-- ClientsDocuments Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientsdocuments;
CREATE TABLE c{clientID}_wfm_clientsdocuments (
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

-- ClientsCustFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_clientscustfields;
CREATE TABLE c{clientID}_wfm_clientscustfields (
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

-- QuotesPhases Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotesphases;
CREATE TABLE c{clientID}_wfm_quotesphases (
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

-- QuotesNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotesnotes;
CREATE TABLE c{clientID}_wfm_quotesnotes (
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

-- QuotesDocuments Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotesdocuments;
CREATE TABLE c{clientID}_wfm_quotesdocuments (
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

-- QuotesTasks Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotestasks;
CREATE TABLE c{clientID}_wfm_quotestasks (
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

-- QuotesTasksStaff Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotestasksstaff;
CREATE TABLE c{clientID}_wfm_quotestasksstaff (
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

-- QuotesCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotescosts;
CREATE TABLE c{clientID}_wfm_quotescosts (
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

-- QuotesCustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_quotescustomfields;
CREATE TABLE c{clientID}_wfm_quotescustomfields (
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

-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InvoicesJobs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesjobs;
CREATE TABLE c{clientID}_wfm_invoicesjobs (
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

-- InvoicesJobsPhases Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesjobsphases;
CREATE TABLE c{clientID}_wfm_invoicesjobsphases (
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

-- InvoicesJobsTasks Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesjobstasks;
CREATE TABLE c{clientID}_wfm_invoicesjobstasks (
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

-- InvoicesJobsTasksTimebreakdown Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesjobstaskstimebreakdown;
CREATE TABLE c{clientID}_wfm_invoicesjobstaskstimebreakdown (
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

-- InvoicesJobsCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesjobscosts;
CREATE TABLE c{clientID}_wfm_invoicesjobscosts (
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

-- InvoicesNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicesnotes;
CREATE TABLE c{clientID}_wfm_invoicesnotes (
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

-- InvoicesPayments Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_invoicespayments;
CREATE TABLE c{clientID}_wfm_invoicespayments (
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

-- PurchaseOrdersJobs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseordersjobs;
CREATE TABLE c{clientID}_wfm_purchaseordersjobs (
    jobuuid VARCHAR(255),
    jobnumber VARCHAR(255),
    purchaseordersid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PurchaseOrdersCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseorderscosts;
CREATE TABLE c{clientID}_wfm_purchaseorderscosts (
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

-- PurchaseOrdersStockRec Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseordersstockrec;
CREATE TABLE c{clientID}_wfm_purchaseordersstockrec (
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

-- Pattern: c{clientID}_wfm_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrdersBills Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseordersbills;
CREATE TABLE c{clientID}_wfm_purchaseordersbills (
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

-- PurchaseOrdersNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseordersnotes;
CREATE TABLE c{clientID}_wfm_purchaseordersnotes (
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

-- PurchaseOrdersDocs Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseordersdocs;
CREATE TABLE c{clientID}_wfm_purchaseordersdocs (
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

-- PurchaseOrderBillsCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_purchaseorderbillscosts;
CREATE TABLE c{clientID}_wfm_purchaseorderbillscosts (
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

-- StockReceiptsCosts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_stockreceiptscosts;
CREATE TABLE c{clientID}_wfm_stockreceiptscosts (
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

-- SuppliersContacts Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_supplierscontacts;
CREATE TABLE c{clientID}_wfm_supplierscontacts (
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

-- SuppliersNotes Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_suppliersnotes;
CREATE TABLE c{clientID}_wfm_suppliersnotes (
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

-- SuppliersDocuments Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_suppliersdocuments;
CREATE TABLE c{clientID}_wfm_suppliersdocuments (
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

-- SuppliersCustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_wfm_supplierscustomfields;
CREATE TABLE c{clientID}_wfm_supplierscustomfields (
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

-- WFM LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_wfm_lastrefreshdate;
CREATE TABLE c{clientID}_wfm_lastrefreshdate (
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
