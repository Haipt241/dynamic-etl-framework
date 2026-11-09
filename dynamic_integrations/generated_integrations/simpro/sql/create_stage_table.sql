-- SIMPRO Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Companies Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_companiesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_companiesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Customers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customersstage (
    id BIGINT NOT NULL,
    companyname TEXT,
    givenname TEXT,
    familyname TEXT,
    phone TEXT,
    donotcall VARCHAR(100),
    altphone TEXT,
    address_address TEXT,
    address_city TEXT,
    address_state TEXT,
    address_postalcode TEXT,
    address_country TEXT,
    billingaddress_address TEXT,
    billingaddress_city TEXT,
    billingaddress_state TEXT,
    billingaddress_postalcode TEXT,
    billingaddress_country TEXT,
    customertype TEXT,
    amountowing FLOAT,
    rates_parttaxcode_id BIGINT,
    rates_parttaxcode_code TEXT,
    rates_parttaxcode_type TEXT,
    rates_parttaxcode_rate FLOAT,
    rates_parttaxcode_reversetaxenabled VARCHAR(100),
    rates_labourtaxcode_id BIGINT,
    rates_labourtaxcode_code TEXT,
    rates_labourtaxcode_type TEXT,
    rates_labourtaxcode_rate FLOAT,
    rates_labourtaxcode_reversetaxenabled VARCHAR(100),
    rates_discountfee TEXT,
    rates_alwaysdeductcis VARCHAR(100),
    rates_servicefee_id BIGINT,
    rates_servicefee_name TEXT,
    rates_material_pricingtier_id BIGINT,
    rates_material_pricingtier_name TEXT,
    rates_material_pricingtier_defaultmarkup FLOAT,
    rates_material_markup FLOAT,
    profile_notes TEXT,
    profile_customerprofile_id BIGINT,
    profile_customerprofile_name TEXT,
    profile_customergroup_id BIGINT,
    profile_customergroup_name TEXT,
    profile_accountmanager_id BIGINT,
    profile_accountmanager_name TEXT,
    profile_currency TEXT,
    profile_servicejobcostcenter_id BIGINT,
    profile_servicejobcostcenter_name TEXT,
    banking_accountname TEXT,
    banking_routingno TEXT,
    banking_accountno TEXT,
    banking_paymentmethod_id BIGINT,
    banking_paymentmethod_name TEXT,
    banking_paymenttermid BIGINT,
    banking_paymentterms_days INT,
    banking_paymentterms_type TEXT,
    banking_creditlimit FLOAT,
    banking_onstop VARCHAR(100),
    banking_retention TEXT,
    banking_vendorordernorequired VARCHAR(100),
    email TEXT,
    datemodified DATETIME,
    datecreated DATETIME,
    ein TEXT,
    website TEXT,
    fax TEXT,
    companynumber TEXT,
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerPreferredTechs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customerpreferredtechsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customerpreferredtechsstage (
    customerid BIGINT NOT NULL,
    technicianid BIGINT NOT NULL,
    name TEXT,
    type TEXT,
    typeid INT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (technicianid)
);

-- CustomerTags Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customertagsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customertagsstage (
    customerid BIGINT NOT NULL,
    tagindex INT NOT NULL,
    tagvalue TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (tagindex)
);

-- CustomerSites Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customersitesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customersitesstage (
    customerid BIGINT NOT NULL,
    siteid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (siteid)
);

-- CustomerContracts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customercontractsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customercontractsstage (
    customerid BIGINT NOT NULL,
    contractid BIGINT NOT NULL,
    name TEXT,
    startdate DATE,
    enddate DATE,
    contractno TEXT,
    expired VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contractid)
);

-- CustomerContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customercontactsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customercontactsstage (
    customerid BIGINT NOT NULL,
    contactid BIGINT NOT NULL,
    givenname TEXT,
    familyname TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contactid)
);

-- CustomerResponseTimes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customerresponsetimesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customerresponsetimesstage (
    customerid BIGINT NOT NULL,
    responsetimeid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (responsetimeid)
);

-- CustomerCustomFields Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customercustomfieldsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customercustomfieldsstage (
    customerid BIGINT NOT NULL,
    customfieldindex INT NOT NULL,
    customfield_id BIGINT,
    customfield_name TEXT,
    customfield_type TEXT,
    customfield_ismandatory VARCHAR(100),
    value TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customfieldindex)
);

-- Employees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_employeesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_employeesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    position VARCHAR(100),
    address_address VARCHAR(100),
    dateofhire DATETIME,
    primarycontact_email VARCHAR(100),
    assignedcostcenters VARCHAR(100),
    customfields VARCHAR(100),
    archived VARCHAR(100),
    datecreated DATETIME,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Jobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobsstage (
    id BIGINT NOT NULL,
    customer_id BIGINT,
    customer_companyname VARCHAR(100),
    site_id BIGINT,
    description VARCHAR(100),
    dateissued DATETIME,
    total_extax FLOAT,
    status_name VARCHAR(100),
    customfields VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Invoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_invoicesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_invoicesstage (
    id BIGINT NOT NULL,
    internalid BIGINT NOT NULL,
    type VARCHAR(100) NOT NULL,
    customer_id BIGINT NOT NULL,
    customer_companyname VARCHAR(100) NOT NULL,
    customer_givenname VARCHAR(100) NOT NULL,
    customer_familyname VARCHAR(100) NOT NULL,
    recurringinvoice_id BIGINT NOT NULL,
    recurringinvoice_description VARCHAR(100) NOT NULL,
    recurringinvoice_total_extax FLOAT NOT NULL,
    recurringinvoice_total_tax FLOAT NOT NULL,
    recurringinvoice_total_inctax FLOAT NOT NULL,
    dateissued DATETIME NOT NULL,
    period_startdate DATETIME NOT NULL,
    period_enddate DATETIME NOT NULL,
    paymenttermid BIGINT NOT NULL,
    paymentterms_days BIGINT NOT NULL,
    paymentterms_type VARCHAR(100) NOT NULL,
    paymentterms_duedate DATETIME NOT NULL,
    progressclaimnumber INT NOT NULL,
    isfinalclaim BOOLEAN NOT NULL,
    stage TEXT NOT NULL,
    peritem BOOLEAN NOT NULL,
    orderno TEXT NOT NULL,
    latepaymentfee BOOLEAN NOT NULL,
    cisdeductionrate DECIMAL NOT NULL,
    exchangerate DECIMAL NOT NULL,
    accountingcategory_id BIGINT NOT NULL,
    accountingcategory_name TEXT NOT NULL,
    status_id BIGINT NOT NULL,
    status_name TEXT NOT NULL,
    autoadjuststatus BOOLEAN NOT NULL,
    description TEXT NOT NULL,
    notes TEXT NOT NULL,
    total_extax FLOAT NOT NULL,
    total_tax FLOAT NOT NULL,
    total_inctax FLOAT NOT NULL,
    total_reversechargetax FLOAT NOT NULL,
    total_amountapplied FLOAT NOT NULL,
    total_balancedue FLOAT NOT NULL,
    isretainage BOOLEAN NOT NULL,
    retainage JSON NOT NULL,
    ispaid BOOLEAN NOT NULL,
    datepaid DATE NOT NULL,
    currency TEXT NOT NULL,
    datecreated DATETIME NOT NULL,
    datemodified DATETIME NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Quotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_quotesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_quotesstage (
    id BIGINT NOT NULL,
    customer_id BIGINT,
    description VARCHAR(100),
    dateissued DATETIME,
    total_extax FLOAT,
    customfields VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Leads Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_leadsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_leadsstage (
    id BIGINT NOT NULL,
    customer_id BIGINT,
    description VARCHAR(100),
    datecreated DATETIME,
    customfields VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contractors Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_contractorsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_contractorsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    position VARCHAR(100),
    address_address VARCHAR(100),
    dateofhire DATETIME,
    customfields VARCHAR(100),
    archived VARCHAR(100),
    datecreated DATETIME,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Sites Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_sitesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_sitesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    customer_id BIGINT,
    address_address VARCHAR(100),
    isactive VARCHAR(100),
    customfields VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_catalogsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_catalogsstage (
    id BIGINT NOT NULL,
    partno VARCHAR(100),
    name TEXT,
    tradeprice FLOAT,
    sellprice FLOAT,
    uom VARCHAR(100),
    group_name VARCHAR(100),
    customfields VARCHAR(100),
    archived VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Schedules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_schedulesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_schedulesstage (
    id BIGINT NOT NULL,
    date DATETIME,
    staff_id BIGINT,
    totalhours FLOAT,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerPayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customerpaymentsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customerpaymentsstage (
    id BIGINT NOT NULL,
    payment_date DATETIME,
    payment_paymentmethod_name VARCHAR(100),
    payment_paymentmethod_id BIGINT,
    status VARCHAR(100),
    depositaccount VARCHAR(100),
    financecharge FLOAT,
    checkno VARCHAR(100),
    details VARCHAR(100),
    financefeebreakdown JSON,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StorageDevices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_storagedevicesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_storagedevicesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    isdefault VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- VendorOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_vendorordersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_vendorordersstage (
    id BIGINT NOT NULL,
    vendor_id BIGINT,
    orderno VARCHAR(100),
    dateissued DATETIME,
    total_inctax FLOAT,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeTimesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_employeetimesheetsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_employeetimesheetsstage (
    scheduletype TEXT,
    reference TEXT,
    h_ref TEXT,
    date DATETIME,
    starttime VARCHAR(100),
    endtime VARCHAR(100),
    totalhrs FLOAT,
    jobid VARCHAR(100) NOT NULL,
    sectionsid VARCHAR(100) NOT NULL,
    costcentersid VARCHAR(100) NOT NULL,
    schedulesid VARCHAR(100) NOT NULL,
    schedulerateid TEXT,
    scheduleratename TEXT,
    cost FLOAT,
    employeeid VARCHAR(100) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ContractorTimesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_contractortimesheetsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_contractortimesheetsstage (
    scheduletype TEXT,
    reference TEXT,
    h_ref TEXT,
    date DATETIME,
    starttime VARCHAR(100),
    endtime VARCHAR(100),
    totalhrs FLOAT,
    jobid VARCHAR(100) NOT NULL,
    sectionsid VARCHAR(100) NOT NULL,
    costcentersid VARCHAR(100) NOT NULL,
    schedulesid VARCHAR(100) NOT NULL,
    schedulerateid TEXT,
    scheduleratename TEXT,
    cost FLOAT,
    totalcost FLOAT,
    contractorid VARCHAR(100) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- InvoiceCostCenters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_invoicecostcentersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_invoicecostcentersstage (
    invoicesid BIGINT NOT NULL,
    id BIGINT NOT NULL,
    name TEXT,
    jobid BIGINT,
    recurringinvoiceid BIGINT,
    sectionid BIGINT,
    costcenter_id BIGINT,
    costcenter_name TEXT,
    total_extax FLOAT,
    total_inctax FLOAT,
    claim_extax FLOAT,
    claim_inctax FLOAT,
    claim_percent FLOAT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- InvoiceCostCenterItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_invoicecostcenteritemsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_invoicecostcenteritemsstage (
    invoicesid BIGINT NOT NULL,
    costcentersid BIGINT NOT NULL,
    id BIGINT NOT NULL,
    item_id BIGINT,
    item_partno TEXT,
    item_name TEXT,
    item_type TEXT,
    quantity_total FLOAT,
    quantity_remaining FLOAT,
    quantity_claimed FLOAT,
    unitprice_extax FLOAT,
    unitprice_inctax FLOAT,
    total_extax FLOAT,
    total_inctax FLOAT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- InvoicesJobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_invoicesjobsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_invoicesjobsstage (
    id BIGINT NOT NULL,
    invoicesid BIGINT NOT NULL,
    description VARCHAR(100),
    total_inctax FLOAT,
    total_extax FLOAT,
    total_tax FLOAT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobSections Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobsectionsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobsectionsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    description VARCHAR(100),
    displayorder BIGINT,
    jobid BIGINT NOT NULL,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobCostCenters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobcostcentersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobcostcentersstage (
    id BIGINT NOT NULL,
    costcenter_id BIGINT NOT NULL,
    costcenter_name VARCHAR(100),
    name VARCHAR(100),
    job_id BIGINT NOT NULL,
    job_type VARCHAR(100),
    job_name VARCHAR(100),
    job_stage VARCHAR(100),
    job_status VARCHAR(100),
    section_id BIGINT NOT NULL,
    section_name VARCHAR(100),
    _href VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobCostCentersSchedules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobcostcentersschedulesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobcostcentersschedulesstage (
    id BIGINT NOT NULL,
    totalhours FLOAT,
    staff_id BIGINT NOT NULL,
    staff_name VARCHAR(100),
    staff_type VARCHAR(100),
    staff_typeid BIGINT NOT NULL,
    jobid BIGINT NOT NULL,
    sectionid BIGINT NOT NULL,
    costcentersid BIGINT NOT NULL,
    date DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobCostCentersLabourateItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobcostcenterslabourateitemsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobcostcenterslabourateitemsstage (
    id BIGINT NOT NULL,
    labortype_id BIGINT,
    labortype_name VARCHAR(100),
    laborrate FLOAT,
    labormarkup FLOAT,
    salestaxcode_id BIGINT,
    salestaxcode_code VARCHAR(100),
    salestaxcode_type VARCHAR(100),
    salestaxcode_rate FLOAT,
    projectedtime FLOAT,
    ticked VARCHAR(100),
    datemodified DATETIME,
    discount FLOAT,
    sellprice_extax FLOAT,
    sellprice_inctax FLOAT,
    sellprice_exdiscountextax FLOAT,
    sellprice_exdiscountinctax FLOAT,
    total_qty FLOAT,
    total_amount_extax FLOAT,
    total_amount_inctax FLOAT,
    claimed_todate_qty FLOAT,
    claimed_todate_amount_extax FLOAT,
    claimed_todate_amount_inctax FLOAT,
    claimed_remaining_qty FLOAT,
    claimed_remaining_amount_extax FLOAT,
    claimed_remaining_amount_inctax FLOAT,
    incomeaccount_id BIGINT,
    incomeaccount_name VARCHAR(100),
    incomeaccount_number VARCHAR(100),
    jobid BIGINT NOT NULL,
    sectionid BIGINT NOT NULL,
    costcentersid BIGINT NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- QuoteSections Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_quotesectionsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_quotesectionsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    description VARCHAR(100),
    quoteid BIGINT NOT NULL,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- QuoteCostCenters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_quotecostcentersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_quotecostcentersstage (
    id BIGINT NOT NULL,
    costcenter_id BIGINT NOT NULL,
    costcenter_name VARCHAR(100),
    name VARCHAR(100),
    quote_id BIGINT NOT NULL,
    quote_type VARCHAR(100),
    quote_name VARCHAR(100),
    quote_stage VARCHAR(100),
    quote_status VARCHAR(100),
    section_id BIGINT NOT NULL,
    section_name VARCHAR(100),
    _href VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StorageDeviceStock Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_storagedevicestockstage;
CREATE TABLE c{clientID}_{orgID}_simpro_storagedevicestockstage (
    catalog_id BIGINT NOT NULL,
    storagedeviceid BIGINT NOT NULL,
    inventorycount FLOAT,
    inventoryvalue FLOAT,
    onorder FLOAT,
    totalvalue FLOAT,
    minimumlevel FLOAT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (catalog_id, storagedeviceid)
);

-- VendorOrderReceipts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_vendororderreceiptsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_vendororderreceiptsstage (
    id BIGINT NOT NULL,
    vendororderid BIGINT NOT NULL,
    vendorinvoiceno VARCHAR(100),
    dateissued DATETIME,
    total_inctax FLOAT,
    itemsreceiveddate DATETIME,
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Activities Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_activitiesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_activitiesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    billable VARCHAR(100),
    schedulerate VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ActivitySchedules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_activityschedulesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_activityschedulesstage (
    id BIGINT NOT NULL,
    totalhours FLOAT,
    staff_id BIGINT NOT NULL,
    staff_name VARCHAR(100),
    staff_type VARCHAR(100),
    staff_typeid BIGINT NOT NULL,
    date DATETIME,
    activity_id BIGINT NOT NULL,
    activity_name VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AssetTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_assettypesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_assettypesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    reference VARCHAR(100),
    description VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CostCenters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_costcentersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_costcentersstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    incomeaccountno VARCHAR(100),
    expenseaccountno VARCHAR(100),
    monthlysalesbudget FLOAT,
    monthlyexpenditurebudget FLOAT,
    archived VARCHAR(100),
    ismembershipcostcenter VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusinessGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_businessgroupsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_businessgroupsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    costcenters VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customergroupsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customergroupsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- CustomerProfiles Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_customerprofilesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_customerprofilesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SecurityGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_securitygroupsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_securitygroupsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    businessgroup_id BIGINT,
    dashboards VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LaborRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_laborratesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_laborratesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    costrate FLOAT,
    markup FLOAT,
    isdefault VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ScheduleRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_scheduleratesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_scheduleratesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    multiplier FLOAT,
    showinmobile VARCHAR(100),
    displayorder BIGINT,
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ServiceFees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_servicefeesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_servicefeesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    labortime FLOAT,
    price FLOAT,
    displayorder BIGINT,
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- UnitOfMeasurement Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_unitofmeasurementstage;
CREATE TABLE c{clientID}_{orgID}_simpro_unitofmeasurementstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    symbol VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ContractorInvoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_contractorinvoicesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_contractorinvoicesstage (
    id BIGINT NOT NULL,
    contractorjobs JSON,
    invoiceno VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AccountCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_accountcategoriesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_accountcategoriesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- FitTimes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_fittimesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_fittimesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Prebuilds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_prebuildsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_prebuildsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    description VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- InventoryJournals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_inventoryjournalsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_inventoryjournalsstage (
    id BIGINT NOT NULL,
    journaldate DATETIME,
    amount FLOAT,
    costcenter_id BIGINT NOT NULL,
    costcenter_name VARCHAR(100),
    memo VARCHAR(100),
    datecreated DATETIME,
    secondaryaccount VARCHAR(100),
    datemodified DATETIME,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id, costcenter_id)
);

-- Teams Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_teamsstage;
CREATE TABLE c{clientID}_{orgID}_simpro_teamsstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TeamAvailability Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_teamavailabilitystage;
CREATE TABLE c{clientID}_{orgID}_simpro_teamavailabilitystage (
    teamid BIGINT NOT NULL,
    availabilityindex INT NOT NULL,
    startday TEXT,
    starttime TEXT,
    endday TEXT,
    endtime TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (availabilityindex)
);

-- TeamCostCenters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_teamcostcentersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_teamcostcentersstage (
    teamid BIGINT NOT NULL,
    costcenterid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (costcenterid)
);

-- TeamMembers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_teammembersstage;
CREATE TABLE c{clientID}_{orgID}_simpro_teammembersstage (
    teamid BIGINT NOT NULL,
    memberid BIGINT NOT NULL,
    name TEXT,
    type TEXT,
    typeid INT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (memberid)
);

-- TeamZones Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_teamzonesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_teamzonesstage (
    teamid BIGINT NOT NULL,
    zoneid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (zoneid)
);

-- ResponseTimes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_responsetimesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_responsetimesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    days INT,
    hours INT,
    minutes INT,
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_tasksstage;
CREATE TABLE c{clientID}_{orgID}_simpro_tasksstage (
    id BIGINT NOT NULL,
    subject VARCHAR(100),
    assignedto_id BIGINT NOT NULL,
    assignedto_name VARCHAR(100),
    assignedto_type VARCHAR(100),
    assignedto_typeid BIGINT NOT NULL,
    completedby_id BIGINT NOT NULL,
    completedby_name VARCHAR(100),
    completedby_type VARCHAR(100),
    completedby_typeid BIGINT NOT NULL,
    duedate DATETIME,
    percentcomplete FLOAT NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TaskAssignees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_taskassigneesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_taskassigneesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    type VARCHAR(100),
    typeid BIGINT NOT NULL,
    taskid BIGINT NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- JobTasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobtasksstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobtasksstage (
    id BIGINT NOT NULL,
    subject VARCHAR(100),
    assignedto_id BIGINT NOT NULL,
    assignedto_name VARCHAR(100),
    assignedto_type VARCHAR(100),
    assignedto_typeid BIGINT NOT NULL,
    completedby_id BIGINT NOT NULL,
    completedby_name VARCHAR(100),
    completedby_type VARCHAR(100),
    completedby_typeid BIGINT NOT NULL,
    duedate DATETIME,
    percentcomplete FLOAT NOT NULL,
    jobid BIGINT NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_simpro_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- JobTaskAssignees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_simpro_jobtaskassigneesstage;
CREATE TABLE c{clientID}_{orgID}_simpro_jobtaskassigneesstage (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    type VARCHAR(100),
    typeid BIGINT NOT NULL,
    taskid BIGINT NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);