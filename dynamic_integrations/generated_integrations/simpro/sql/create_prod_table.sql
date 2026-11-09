-- SIMPRO Production Tables - Auto Generated
-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_companies;
CREATE TABLE c{clientID}_simpro_companies (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Customers Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customers;
CREATE TABLE c{clientID}_simpro_customers (
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

-- CustomerPreferredTechs Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customerpreferredtechs;
CREATE TABLE c{clientID}_simpro_customerpreferredtechs (
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

-- CustomerTags Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customertags;
CREATE TABLE c{clientID}_simpro_customertags (
    customerid BIGINT NOT NULL,
    tagindex INT NOT NULL,
    tagvalue TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (tagindex)
);

-- CustomerSites Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customersites;
CREATE TABLE c{clientID}_simpro_customersites (
    customerid BIGINT NOT NULL,
    siteid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (siteid)
);

-- CustomerContracts Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customercontracts;
CREATE TABLE c{clientID}_simpro_customercontracts (
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

-- CustomerContacts Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customercontacts;
CREATE TABLE c{clientID}_simpro_customercontacts (
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

-- CustomerResponseTimes Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customerresponsetimes;
CREATE TABLE c{clientID}_simpro_customerresponsetimes (
    customerid BIGINT NOT NULL,
    responsetimeid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (responsetimeid)
);

-- CustomerCustomFields Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customercustomfields;
CREATE TABLE c{clientID}_simpro_customercustomfields (
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

-- Employees Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_employees;
CREATE TABLE c{clientID}_simpro_employees (
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


-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Jobs Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobs;
CREATE TABLE c{clientID}_simpro_jobs (
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

-- Invoices Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_invoices;
CREATE TABLE c{clientID}_simpro_invoices (
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

-- Quotes Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_quotes;
CREATE TABLE c{clientID}_simpro_quotes (
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

-- Leads Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_leads;
CREATE TABLE c{clientID}_simpro_leads (
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

-- Contractors Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_contractors;
CREATE TABLE c{clientID}_simpro_contractors (
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

-- Sites Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_sites;
CREATE TABLE c{clientID}_simpro_sites (
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

-- Catalogs Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_catalogs;
CREATE TABLE c{clientID}_simpro_catalogs (
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

-- Schedules Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_schedules;
CREATE TABLE c{clientID}_simpro_schedules (
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

-- CustomerPayments Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customerpayments;
CREATE TABLE c{clientID}_simpro_customerpayments (
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

-- StorageDevices Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_storagedevices;
CREATE TABLE c{clientID}_simpro_storagedevices (
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

-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- VendorOrders Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_vendororders;
CREATE TABLE c{clientID}_simpro_vendororders (
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

-- EmployeeTimesheets Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_employeetimesheets;
CREATE TABLE c{clientID}_simpro_employeetimesheets (
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

-- ContractorTimesheets Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_contractortimesheets;
CREATE TABLE c{clientID}_simpro_contractortimesheets (
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

-- InvoiceCostCenters Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_invoicecostcenters;
CREATE TABLE c{clientID}_simpro_invoicecostcenters (
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

-- InvoiceCostCenterItems Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_invoicecostcenteritems;
CREATE TABLE c{clientID}_simpro_invoicecostcenteritems (
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

-- InvoicesJobs Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_invoicesjobs;
CREATE TABLE c{clientID}_simpro_invoicesjobs (
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

-- JobSections Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobsections;
CREATE TABLE c{clientID}_simpro_jobsections (
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

-- JobCostCenters Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobcostcenters;
CREATE TABLE c{clientID}_simpro_jobcostcenters (
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

-- JobCostCentersSchedules Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobcostcentersschedules;
CREATE TABLE c{clientID}_simpro_jobcostcentersschedules (
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

-- JobCostCentersLabourateItems Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobcostcenterslabourateitems;
CREATE TABLE c{clientID}_simpro_jobcostcenterslabourateitems (
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

-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- QuoteSections Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_quotesections;
CREATE TABLE c{clientID}_simpro_quotesections (
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

-- QuoteCostCenters Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_quotecostcenters;
CREATE TABLE c{clientID}_simpro_quotecostcenters (
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

-- StorageDeviceStock Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_storagedevicestock;
CREATE TABLE c{clientID}_simpro_storagedevicestock (
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

-- VendorOrderReceipts Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_vendororderreceipts;
CREATE TABLE c{clientID}_simpro_vendororderreceipts (
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

-- Activities Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_activities;
CREATE TABLE c{clientID}_simpro_activities (
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

-- ActivitySchedules Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_activityschedules;
CREATE TABLE c{clientID}_simpro_activityschedules (
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

-- AssetTypes Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_assettypes;
CREATE TABLE c{clientID}_simpro_assettypes (
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

-- CostCenters Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_costcenters;
CREATE TABLE c{clientID}_simpro_costcenters (
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

-- BusinessGroups Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_businessgroups;
CREATE TABLE c{clientID}_simpro_businessgroups (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    costcenters VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomerGroups Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customergroups;
CREATE TABLE c{clientID}_simpro_customergroups (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CustomerProfiles Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_customerprofiles;
CREATE TABLE c{clientID}_simpro_customerprofiles (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SecurityGroups Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_securitygroups;
CREATE TABLE c{clientID}_simpro_securitygroups (
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

-- LaborRates Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_laborrates;
CREATE TABLE c{clientID}_simpro_laborrates (
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

-- ScheduleRates Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_schedulerates;
CREATE TABLE c{clientID}_simpro_schedulerates (
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

-- ServiceFees Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_servicefees;
CREATE TABLE c{clientID}_simpro_servicefees (
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

-- UnitOfMeasurement Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_unitofmeasurement;
CREATE TABLE c{clientID}_simpro_unitofmeasurement (
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

-- ContractorInvoices Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_contractorinvoices;
CREATE TABLE c{clientID}_simpro_contractorinvoices (
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

-- AccountCategories Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_accountcategories;
CREATE TABLE c{clientID}_simpro_accountcategories (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- FitTimes Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_fittimes;
CREATE TABLE c{clientID}_simpro_fittimes (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Prebuilds Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_prebuilds;
CREATE TABLE c{clientID}_simpro_prebuilds (
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

-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InventoryJournals Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_inventoryjournals;
CREATE TABLE c{clientID}_simpro_inventoryjournals (
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

-- Teams Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_teams;
CREATE TABLE c{clientID}_simpro_teams (
    id BIGINT NOT NULL,
    name VARCHAR(100),
    archived VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TeamAvailability Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_teamavailability;
CREATE TABLE c{clientID}_simpro_teamavailability (
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

-- TeamCostCenters Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_teamcostcenters;
CREATE TABLE c{clientID}_simpro_teamcostcenters (
    teamid BIGINT NOT NULL,
    costcenterid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (costcenterid)
);

-- TeamMembers Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_teammembers;
CREATE TABLE c{clientID}_simpro_teammembers (
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

-- TeamZones Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_teamzones;
CREATE TABLE c{clientID}_simpro_teamzones (
    teamid BIGINT NOT NULL,
    zoneid BIGINT NOT NULL,
    name TEXT,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (zoneid)
);

-- ResponseTimes Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_responsetimes;
CREATE TABLE c{clientID}_simpro_responsetimes (
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

-- Tasks Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_tasks;
CREATE TABLE c{clientID}_simpro_tasks (
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

-- TaskAssignees Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_taskassignees;
CREATE TABLE c{clientID}_simpro_taskassignees (
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

-- JobTasks Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobtasks;
CREATE TABLE c{clientID}_simpro_jobtasks (
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

-- Pattern: c{clientID}_simpro_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobTaskAssignees Production Table
DROP TABLE IF EXISTS c{clientID}_simpro_jobtaskassignees;
CREATE TABLE c{clientID}_simpro_jobtaskassignees (
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

-- SIMPRO LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_simpro_lastrefreshdate;
CREATE TABLE c{clientID}_simpro_lastrefreshdate (
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
