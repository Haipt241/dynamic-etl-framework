-- TIDYWORK Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_tidywork_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Activities Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_activitiesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_activitiesstage (
    activityid VARCHAR(255) NOT NULL,
    departmentids JSON,
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    isoverhead BOOLEAN NOT NULL,
    ispayable BOOLEAN NOT NULL,
    isactive BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    synctoken VARCHAR(255),
    metadata_createtime DATETIME,
    metadata_lastupdatedtime DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (activityid)
);

-- ActivityDepartments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_activitydepartmentsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_activitydepartmentsstage (
    activityid VARCHAR(255) NOT NULL,
    departmentid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (activityid, departmentid, organisationid)
);

-- ChargeRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_chargeratesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_chargeratesstage (
    chargerateid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    currencyid VARCHAR(255),
    currencyisocode VARCHAR(10),
    currentamount DECIMAL(15,2),
    currentquotecostamount DECIMAL(15,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    synctoken VARCHAR(255),
    metadata_createtime DATETIME,
    metadata_lastupdatedtime DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (chargerateid)
);

-- Customers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_customersstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_customersstage (
    customerid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    currencyid VARCHAR(255),
    currencyisocode VARCHAR(10),
    countryid VARCHAR(255),
    countryisocode VARCHAR(10),
    taxtypeid VARCHAR(255),
    taxtypecode VARCHAR(255),
    notes TEXT,
    invoiceduebasis VARCHAR(255),
    invoiceduenumber INT,
    isactive BOOLEAN NOT NULL,
    postaladdress1 VARCHAR(500),
    postaladdress2 VARCHAR(500),
    postalsuburb VARCHAR(255),
    postalcity VARCHAR(255),
    postalstate VARCHAR(255),
    postalpostcode VARCHAR(20),
    customerportalenabled BOOLEAN NOT NULL,
    customerportallink VARCHAR(500),
    customerportaluserid VARCHAR(255),
    materiallocationid VARCHAR(255),
    materialpricinglevelid VARCHAR(255),
    projectpricinglevelid VARCHAR(255),
    physicaladdresses JSON,
    contacts JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    synctoken VARCHAR(255),
    metadata_createtime DATETIME,
    metadata_lastupdatedtime DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customerid)
);

-- CustomerAddresses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_customeraddressesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_customeraddressesstage (
    customerid VARCHAR(255) NOT NULL,
    customeraddressid VARCHAR(255) NOT NULL,
    isprimary BOOLEAN NOT NULL,
    address1 VARCHAR(500),
    address2 VARCHAR(500),
    suburb VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postcode VARCHAR(20),
    roworder INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customeraddressid, organisationid)
);

-- CustomerContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_customercontactsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_customercontactsstage (
    customerid VARCHAR(255) NOT NULL,
    customercontactid VARCHAR(255) NOT NULL,
    isprimary BOOLEAN NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    mobile VARCHAR(50),
    fax VARCHAR(50),
    address1 VARCHAR(500),
    address2 VARCHAR(500),
    suburb VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postcode VARCHAR(20),
    countryid VARCHAR(255),
    countryisocode VARCHAR(10),
    postaladdress1 VARCHAR(500),
    postaladdress2 VARCHAR(500),
    postalsuburb VARCHAR(255),
    postalcity VARCHAR(255),
    postalstate VARCHAR(255),
    postalpostcode VARCHAR(20),
    postalcountryid VARCHAR(255),
    postalcountryisocode VARCHAR(10),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customercontactid, organisationid)
);

-- ExpenseActuals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_expenseactualsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_expenseactualsstage (
    expenseid VARCHAR(255) NOT NULL,
    dateutc DATETIME,
    date DATETIME,
    customerid VARCHAR(255),
    customercode VARCHAR(255),
    customername VARCHAR(255),
    projectid VARCHAR(255),
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    departmentcode VARCHAR(255),
    departmentname VARCHAR(255),
    userid VARCHAR(255),
    username VARCHAR(255),
    useremail VARCHAR(255),
    expensecategorycode VARCHAR(255),
    expensecategoryname VARCHAR(255),
    expensetypecode VARCHAR(255),
    expensetypename VARCHAR(255),
    notes TEXT,
    amount DECIMAL(15,2),
    currencyid VARCHAR(255),
    currencyisocode VARCHAR(10),
    billing VARCHAR(255),
    state VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expenseid)
);

-- ExpenseCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_expensecategoriesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_expensecategoriesstage (
    expensecategoryid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expensecategoryid)
);

-- Expenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_expensesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_expensesstage (
    expenseid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255),
    userid VARCHAR(255),
    expensedate DATETIME,
    expensedateutc DATETIME,
    notes TEXT,
    state VARCHAR(255),
    expensetypeid VARCHAR(255),
    currencyid VARCHAR(255),
    amount DECIMAL(15,2),
    description TEXT,
    expensetypecode VARCHAR(255),
    expensetypename VARCHAR(255),
    isbillable BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expenseid)
);

-- ExpenseTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_expensetypesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_expensetypesstage (
    expensetypeid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    isactive BOOLEAN,
    expensecategoryid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expensetypeid)
);


-- Pattern: c{clientID}_{orgID}_tidywork_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- MaterialActuals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materialactualsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materialactualsstage (
    materialid VARCHAR(255) NOT NULL,
    dateutc DATETIME,
    date DATETIME,
    customerid VARCHAR(255),
    customercode VARCHAR(255),
    customername VARCHAR(255),
    projectid VARCHAR(255),
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    departmentcode VARCHAR(255),
    departmentname VARCHAR(255),
    userid VARCHAR(255),
    username VARCHAR(255),
    useremail VARCHAR(255),
    materialitemid VARCHAR(255),
    materialitemcode VARCHAR(255),
    materialitemname VARCHAR(255),
    materialcategoryid VARCHAR(255),
    materialcategorycode VARCHAR(255),
    materialcategoryname VARCHAR(255),
    materiallocationid VARCHAR(255),
    materiallocationcode VARCHAR(255),
    materiallocationname VARCHAR(255),
    unitcost DECIMAL(18,2),
    unitcostcurrencyid VARCHAR(255),
    unitcostcurrencyisocode VARCHAR(10),
    unitprice DECIMAL(18,2),
    unitpricecurrencyid VARCHAR(255),
    unitpricecurrencyisocode VARCHAR(10),
    unit VARCHAR(255),
    quantity DECIMAL(18,4),
    totalcost DECIMAL(18,2),
    totalprice DECIMAL(18,2),
    billing VARCHAR(255),
    state VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialid)
);

-- MaterialCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materialcategoriesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materialcategoriesstage (
    materialcategoryid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    defaultstockreorderlevel DECIMAL(18,4),
    taxtypeid VARCHAR(255),
    isdefault BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialcategoryid)
);

-- MaterialItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materialitemsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materialitemsstage (
    materialitemid VARCHAR(255) NOT NULL,
    materialcategoryid VARCHAR(255),
    materialcategorycode VARCHAR(255),
    materialcategoryname VARCHAR(255),
    materiallocationid VARCHAR(255),
    materiallocationcode VARCHAR(255),
    materiallocationname VARCHAR(255),
    code VARCHAR(255),
    name VARCHAR(255),
    description VARCHAR(255),
    isactive BOOLEAN,
    costcurrencyid VARCHAR(255),
    costcurrencyisocode VARCHAR(10),
    chargecurrencyid VARCHAR(255),
    chargecurrencyisocode VARCHAR(10),
    cost DECIMAL(18,2),
    charge DECIMAL(18,2),
    pricebycustlevelqty DECIMAL(18,4),
    pricingunitid VARCHAR(255),
    pricingunitabbrev VARCHAR(255),
    usageunitid VARCHAR(255),
    usageunitabbrev VARCHAR(255),
    stocklevel DECIMAL(18,4),
    stockreorderlevel DECIMAL(18,4),
    ismanaged BOOLEAN,
    sku VARCHAR(255),
    barcode VARCHAR(255),
    netcost DECIMAL(18,2),
    reference VARCHAR(255),
    materialitemtype VARCHAR(255),
    supplierid VARCHAR(255),
    taxtypeid VARCHAR(255),
    allowedincustomerportal BOOLEAN,
    pricing JSON,
    locationstocklevels JSON,
    images JSON,
    updatedutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialitemid)
);

-- ItemPricing Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_itempricingstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_itempricingstage (
    materialitemid VARCHAR(255) NOT NULL,
    pricingid VARCHAR(255) NOT NULL,
    pricelevel VARCHAR(255),
    quantity DECIMAL(18,4),
    price DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (pricingid, organisationid)
);

-- ItemLocationStock Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_itemlocationstockstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_itemlocationstockstage (
    materialitemid VARCHAR(255) NOT NULL,
    locationstockid VARCHAR(255) NOT NULL,
    locationid VARCHAR(255),
    locationcode VARCHAR(255),
    stocklevel DECIMAL(18,4),
    reorderlevel DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationstockid, organisationid)
);

-- ItemImages Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_itemimagesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_itemimagesstage (
    materialitemid VARCHAR(255) NOT NULL,
    imageid VARCHAR(255) NOT NULL,
    filename VARCHAR(500),
    fileurl VARCHAR(1000),
    filesize BIGINT,
    mimetype VARCHAR(255),
    isprimary BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (imageid, organisationid)
);

-- MaterialLocation Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materiallocationstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materiallocationstage (
    materiallocationid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    isdefault BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materiallocationid)
);

-- MaterialPricingLevel Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materialpricinglevelstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materialpricinglevelstage (
    materialpricinglevelid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialpricinglevelid)
);

-- Material Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_materialstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_materialstage (
    materialid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255),
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    userid VARCHAR(255),
    supplierid VARCHAR(255),
    notes TEXT,
    purchaseorderid VARCHAR(255),
    purchaseorderno VARCHAR(255),
    purchaseordernote TEXT,
    purchaseorderlineid VARCHAR(255),
    state VARCHAR(255),
    isestimate BOOLEAN,
    isorderrequired BOOLEAN,
    materialdateutc DATETIME,
    materialdate DATETIME,
    materialitemcode VARCHAR(255),
    materiallocationid VARCHAR(255),
    pricingmultiplier DECIMAL(18,6),
    pricingunitid VARCHAR(255),
    usageunitid VARCHAR(255),
    roworder INT,
    materialitemid VARCHAR(255),
    materialitemname VARCHAR(255),
    costcurrencyid VARCHAR(255),
    chargecurrencyid VARCHAR(255),
    quantity DECIMAL(18,6),
    usagequantity DECIMAL(18,6),
    cost DECIMAL(18,6),
    charge DECIMAL(18,6),
    length DECIMAL(18,6),
    width DECIMAL(18,6),
    height DECIMAL(18,6),
    isbillable BOOLEAN,
    taskid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialid)
);

-- Organization Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_organizationstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_organizationstage (
    name VARCHAR(255),
    domains JSON,
    features JSON,
    generalsettings JSON,
    accountingsettings JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- Pattern: c{clientID}_{orgID}_tidywork_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- OrgDomains Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_orgdomainsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_orgdomainsstage (
    domain VARCHAR(500) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (domain, organisationid)
);

-- OrgFeatures Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_orgfeaturesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_orgfeaturesstage (
    feature VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (feature, organisationid)
);

-- ProjectGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectgroupsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectgroupsstage (
    projectgroupid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    isactive BOOLEAN,
    isdefault BOOLEAN,
    extacctrackingid1 VARCHAR(255),
    extacctrackingid2 VARCHAR(255),
    brandingthemeid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectgroupid)
);

-- Projects Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectsstage (
    projectid VARCHAR(255) NOT NULL,
    parentquoteid VARCHAR(255),
    projectgroupid VARCHAR(255),
    projectgroupcode VARCHAR(255),
    projectgroupname VARCHAR(255),
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    status VARCHAR(255),
    customerid VARCHAR(255),
    customercontactid VARCHAR(255),
    templateid VARCHAR(255),
    currencyid VARCHAR(255),
    taxrateid VARCHAR(255),
    manageruserid VARCHAR(255),
    customerref VARCHAR(255),
    specialinstructions TEXT,
    startdate DATETIME,
    startdateutc DATETIME,
    enddate DATETIME,
    enddateutc DATETIME,
    fixedpriceamount DECIMAL(18,2),
    isoverhead BOOLEAN,
    priority VARCHAR(255),
    pricetype VARCHAR(255),
    invoicenote TEXT,
    url TEXT,
    allowedincustomerportal BOOLEAN,
    usercompleteddateutc DATETIME,
    usercompleteddate DATETIME,
    updatedtimeutc DATETIME,
    tasks JSON,
    color VARCHAR(10),
    materials JSON,
    expenses JSON,
    milestones JSON,
    roles JSON,
    materialsundertasksrequired BOOLEAN,
    materiallocationid VARCHAR(255),
    updateoptions JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- ProjectTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projecttasksstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projecttasksstage (
    projectid VARCHAR(255) NOT NULL,
    taskid VARCHAR(255) NOT NULL,
    parentid VARCHAR(255),
    level INT,
    name VARCHAR(255),
    description TEXT,
    status VARCHAR(255),
    startdateutc DATETIME,
    enddateutc DATETIME,
    startedtimeutc DATETIME,
    completedtimeutc DATETIME,
    estimatedminutes INT,
    isleaftask BOOLEAN,
    isbillable BOOLEAN,
    isonhold BOOLEAN,
    fixedprice DECIMAL(18,2),
    displayorder INT,
    assignments JSON,
    materials JSON,
    children JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid, organisationid)
);

-- ProjectTaskAssignments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projecttaskassignmentsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projecttaskassignmentsstage (
    taskid VARCHAR(255) NOT NULL,
    taskassignmentid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    chargerateid VARCHAR(255),
    chargeperhour DECIMAL(18,2),
    chargecurrencyid VARCHAR(255),
    estimatedminutes INT,
    selfestimatedminutes INT,
    actualminutes INT,
    iscomplete BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskassignmentid, organisationid)
);

-- ProjectMaterials Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectmaterialsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectmaterialsstage (
    projectid VARCHAR(255) NOT NULL,
    materialid VARCHAR(255) NOT NULL,
    materialitemid VARCHAR(255),
    quantity DECIMAL(18,4),
    unitcost DECIMAL(18,2),
    totalcost DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialid, organisationid)
);

-- ProjectExpenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectexpensesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectexpensesstage (
    projectid VARCHAR(255) NOT NULL,
    expenseid VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    amount DECIMAL(18,2),
    currencyid VARCHAR(255),
    expensedate DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expenseid, organisationid)
);

-- ProjectMilestones Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectmilestonesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectmilestonesstage (
    projectid VARCHAR(255) NOT NULL,
    milestoneid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    duedate DATETIME,
    iscompleted BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (milestoneid, organisationid)
);

-- ProjectRoles Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectrolesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectrolesstage (
    projectid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    ispeermanager BOOLEAN NOT NULL,
    isapprover BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_tidywork_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ProjectSummary Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_projectsummarystage;
CREATE TABLE c{clientID}_{orgID}_tidywork_projectsummarystage (
    projectid VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    projectgroup VARCHAR(255),
    startdateutc DATETIME,
    startdate DATETIME,
    enddateutc DATETIME,
    enddate DATETIME,
    completeddateutc DATETIME,
    lastmodifiedutc DATETIME,
    manager VARCHAR(255),
    customer VARCHAR(255),
    customerref VARCHAR(255),
    pricetype VARCHAR(255),
    status VARCHAR(255),
    plannedtime INT,
    actualtime INT,
    incompletetaskseffort INT,
    plannedtimecost DECIMAL(18,2),
    plannedmaterialscost DECIMAL(18,2),
    plannedexpensescost DECIMAL(18,2),
    plannedtimerevenue DECIMAL(18,2),
    plannedmaterialsrevenue DECIMAL(18,2),
    plannedexpensesrevenue DECIMAL(18,2),
    plannedmilestonerevenue DECIMAL(18,2),
    plannedfixedpricerevenue DECIMAL(18,2),
    plannedfixedpricetaskrevenue DECIMAL(18,2),
    timecost DECIMAL(18,2),
    materialscost DECIMAL(18,2),
    expensescost DECIMAL(18,2),
    invoiced DECIMAL(18,2),
    invoicable DECIMAL(18,2),
    invoicedetailsstring VARCHAR(255),
    adjustments DECIMAL(18,2),
    totalactualcost DECIMAL(18,2),
    totalactualrevenue DECIMAL(18,2),
    totalactualprofit DECIMAL(18,2),
    totalplannedcost DECIMAL(18,2),
    totalplannedrevenue DECIMAL(18,2),
    totalplannedprofit DECIMAL(18,2),
    actualtimerevenue DECIMAL(18,2),
    actualmaterialsrevenue DECIMAL(18,2),
    actualexpensesrevenue DECIMAL(18,2),
    actualmilestonerevenue DECIMAL(18,2),
    actualfixedpricerevenue DECIMAL(18,2),
    actualfixedpricetaskrevenue DECIMAL(18,2),
    url VARCHAR(255),
    specialinstructions TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- PurchaseOrder Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_purchaseorderstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_purchaseorderstage (
    purchaseorderid VARCHAR(255) NOT NULL,
    orderno VARCHAR(255),
    supplierid VARCHAR(255),
    projectid VARCHAR(255),
    datesinutc BOOLEAN,
    earliestraiseddate DATETIME,
    latestraiseddate DATETIME,
    purchaseorderstatuses VARCHAR(255),
    receivedstatuses VARCHAR(255),
    invoicedstatuses VARCHAR(255),
    simplesearch VARCHAR(255),
    earliestexpecteddeliverydate DATETIME,
    latestexpecteddeliverydate DATETIME,
    `order` JSON,
    page INT,
    pagesize INT,
    includelines BOOLEAN,
    includefreightitems BOOLEAN,
    includedescendants BOOLEAN,
    includeancestors BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (purchaseorderid)
);

-- Quote Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quotestage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quotestage (
    quoteid VARCHAR(255) NOT NULL,
    projectgroupid VARCHAR(255),
    projectgroupcode VARCHAR(255),
    projectgroupname VARCHAR(255),
    code VARCHAR(255),
    name VARCHAR(255),
    description TEXT,
    specialinstructions TEXT,
    customerid VARCHAR(255),
    customerref VARCHAR(255),
    customercontactid VARCHAR(255),
    templateid VARCHAR(255),
    startdateutc DATETIME,
    startdate DATETIME,
    enddateutc DATETIME,
    enddate DATETIME,
    expirydateutc DATETIME,
    expirydate DATETIME,
    salespersonuserid VARCHAR(255),
    materialsundertasksrequired BOOLEAN,
    pricetype VARCHAR(255),
    currencyid VARCHAR(255),
    fixedpriceamount DECIMAL(18,2),
    markuppercentage DECIMAL(18,2),
    taxrateid VARCHAR(255),
    status VARCHAR(255),
    color VARCHAR(255),
    tasks JSON,
    materials JSON,
    expenses JSON,
    milestones JSON,
    roles JSON,
    updateoptions JSON,
    label VARCHAR(255),
    materiallocationid VARCHAR(255),
    updatedtimeutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (quoteid)
);

-- QuoteTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quotetasksstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quotetasksstage (
    quoteid VARCHAR(255) NOT NULL,
    taskid VARCHAR(255) NOT NULL,
    parentid VARCHAR(255),
    level INT,
    name VARCHAR(255),
    description TEXT,
    estimatedminutes INT,
    isbillable BOOLEAN,
    fixedprice DECIMAL(18,2),
    displayorder INT,
    assignments JSON,
    materials JSON,
    children JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid, organisationid)
);

-- QuoteTaskAssignments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quotetaskassignmentsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quotetaskassignmentsstage (
    taskid VARCHAR(255) NOT NULL,
    taskassignmentid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    chargerateid VARCHAR(255),
    chargeperhour DECIMAL(18,2),
    estimatedminutes INT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskassignmentid, organisationid)
);

-- QuoteMaterials Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quotematerialsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quotematerialsstage (
    quoteid VARCHAR(255) NOT NULL,
    materialid VARCHAR(255) NOT NULL,
    materialitemid VARCHAR(255),
    quantity DECIMAL(18,4),
    unitcost DECIMAL(18,2),
    totalcost DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (materialid, organisationid)
);

-- QuoteExpenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quoteexpensesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quoteexpensesstage (
    quoteid VARCHAR(255) NOT NULL,
    expenseid VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    amount DECIMAL(18,2),
    currencyid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (expenseid, organisationid)
);

-- QuoteMilestones Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quotemilestonesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quotemilestonesstage (
    quoteid VARCHAR(255) NOT NULL,
    milestoneid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    description TEXT,
    duedate DATETIME,
    iscompleted BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (milestoneid, organisationid)
);

-- QuoteRoles Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_quoterolesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_quoterolesstage (
    quoteid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    ispeermanager BOOLEAN NOT NULL,
    isapprover BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid, organisationid)
);

-- Sales Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_salesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_salesstage (
    saleid VARCHAR(255),
    customerid VARCHAR(255),
    saleno VARCHAR(255),
    earliesteffectivedate DATETIME,
    latesteffectivedate DATETIME,
    datesinutc BOOLEAN,
    includestatusonhold BOOLEAN,
    includestatusdraft BOOLEAN,
    includestatusinvoiced BOOLEAN,
    includestatusvoid BOOLEAN,
    page INT,
    pagesize INT,
    materialitemid VARCHAR(255),
    materialcategoryid VARCHAR(255),
    materiallocationid VARCHAR(255),
    iscredit BOOLEAN,
    includeimages BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (saleid)
);

-- Pattern: c{clientID}_{orgID}_tidywork_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_tasksstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_tasksstage (
    taskid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255),
    startdateutc DATETIME,
    startdate DATETIME,
    enddateutc DATETIME,
    enddate DATETIME,
    startedtimeutc DATETIME,
    startedtime DATETIME,
    completedtimeutc DATETIME,
    completedtime DATETIME,
    status VARCHAR(255),
    assignments JSON,
    materials JSON,
    parentid VARCHAR(255),
    displayorder INT,
    name VARCHAR(255),
    description TEXT,
    estimatedminutes INT,
    isleaftask BOOLEAN,
    isbillable BOOLEAN,
    isonhold BOOLEAN,
    fixedprice DECIMAL(15,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- TaskAssignments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_taskassignmentsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_taskassignmentsstage (
    taskid VARCHAR(255) NOT NULL,
    taskassignmentid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    selfestimatedminutes INT,
    actualminutes INT,
    estimatedminutes INT,
    chargerateid VARCHAR(255),
    chargeperhour DECIMAL(18,2),
    chargecurrencyid VARCHAR(255),
    iscomplete BOOLEAN NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskassignmentid, organisationid)
);

-- Templates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_templatesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_templatesstage (
    templateid VARCHAR(255) NOT NULL,
    templatetype INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (templateid)
);

-- TimeActuals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_timeactualsstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_timeactualsstage (
    timeid VARCHAR(255) NOT NULL,
    starttimeutc DATETIME,
    starttime DATETIME,
    customerid VARCHAR(255),
    customercode VARCHAR(255),
    customername VARCHAR(255),
    projectid VARCHAR(255),
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    projectgroup VARCHAR(255),
    taskid VARCHAR(255),
    taskname VARCHAR(255),
    activityid VARCHAR(255),
    activitycode VARCHAR(255),
    activityname VARCHAR(255),
    departmentcode VARCHAR(255),
    departmentname VARCHAR(255),
    userid VARCHAR(255),
    username VARCHAR(255),
    useremail VARCHAR(255),
    totalminutes INT,
    billableminutes INT,
    billing VARCHAR(255),
    state VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timeid)
);

-- TimePlan Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_timeplanstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_timeplanstage (
    customerid VARCHAR(255),
    customercode VARCHAR(255),
    customername VARCHAR(255),
    projectid VARCHAR(255) NOT NULL,
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    taskid VARCHAR(255) NOT NULL,
    taskname VARCHAR(255),
    parenttaskid VARCHAR(255),
    parenttaskname VARCHAR(255),
    grandparenttaskid VARCHAR(255),
    grandparenttaskname VARCHAR(255),
    taskstartdateutc DATETIME,
    taskstartdate DATETIME,
    taskenddateutc DATETIME,
    taskenddate DATETIME,
    departmentcode VARCHAR(255),
    departmentname VARCHAR(255),
    userid VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    useremail VARCHAR(255),
    totalminutes INT,
    selfminutes INT,
    billing VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid, taskid, userid)
);

-- Times Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_timesstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_timesstage (
    timeid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255),
    projectcode VARCHAR(255),
    projectname VARCHAR(255),
    taskid VARCHAR(255),
    taskname VARCHAR(255),
    taskcompletionindicated BOOLEAN,
    activityid VARCHAR(255),
    activitycode VARCHAR(255),
    activityname VARCHAR(255),
    userid VARCHAR(255),
    username VARCHAR(255),
    notes TEXT,
    starttime DATETIME,
    starttimeutc DATETIME,
    minutes INT,
    state VARCHAR(255),
    timeprofileid VARCHAR(255),
    timeprofilename VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timeid)
);

-- Users Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_tidywork_usersstage;
CREATE TABLE c{clientID}_{orgID}_tidywork_usersstage (
    userid VARCHAR(255) NOT NULL,
    customerid VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    displayname VARCHAR(255),
    departmentname VARCHAR(255),
    departmentid VARCHAR(255),
    contactemail VARCHAR(255),
    isactive BOOLEAN,
    isselfassignmentpermitted BOOLEAN,
    istimewriter BOOLEAN,
    ismaterialwriter BOOLEAN,
    timezoneid VARCHAR(255),
    timezonename VARCHAR(255),
    ishelper BOOLEAN,
    isnonhuman BOOLEAN,
    issystemadministrator BOOLEAN,
    isresourceadministrator BOOLEAN,
    isprojectmanager BOOLEAN,
    isquoteestimator BOOLEAN,
    ispurchaser BOOLEAN,
    issalesperson BOOLEAN,
    isinvoicer BOOLEAN,
    isreporter BOOLEAN,
    canprojectmanagerchangeprojectstate BOOLEAN,
    canprojectmanagerseeprojectprofit BOOLEAN,
    canprojectmanagereditprojecttemplates BOOLEAN,
    cansalespersonseepricing BOOLEAN,
    cansalespersonseedashboard BOOLEAN,
    ismaterialapprover BOOLEAN,
    isexpenseapprover BOOLEAN,
    istimeapprover BOOLEAN,
    defaultchargerateid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);