-- SIMPRO Views - Auto Generated
-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies View
DROP VIEW IF EXISTS {etani_client_id}_simpro_companies;
CREATE VIEW {etani_client_id}_simpro_companies AS
SELECT
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_companies;

-- Customers View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customers;
CREATE VIEW {etani_client_id}_simpro_customers AS
SELECT
    id,
    companyname,
    givenname,
    familyname,
    phone,
    donotcall,
    altphone,
    address_address AS `address.address`,
    address_city AS `address.city`,
    address_state AS `address.state`,
    address_postalcode AS `address.postalcode`,
    address_country AS `address.country`,
    billingaddress_address AS `billingaddress.address`,
    billingaddress_city AS `billingaddress.city`,
    billingaddress_state AS `billingaddress.state`,
    billingaddress_postalcode AS `billingaddress.postalcode`,
    billingaddress_country AS `billingaddress.country`,
    customertype,
    amountowing,
    rates_parttaxcode_id AS `rates.parttaxcode.id`,
    rates_parttaxcode_code AS `rates.parttaxcode.code`,
    rates_parttaxcode_type AS `rates.parttaxcode.type`,
    rates_parttaxcode_rate AS `rates.parttaxcode.rate`,
    rates_parttaxcode_reversetaxenabled AS `rates.parttaxcode.reversetaxenabled`,
    rates_labourtaxcode_id AS `rates.labourtaxcode.id`,
    rates_labourtaxcode_code AS `rates.labourtaxcode.code`,
    rates_labourtaxcode_type AS `rates.labourtaxcode.type`,
    rates_labourtaxcode_rate AS `rates.labourtaxcode.rate`,
    rates_labourtaxcode_reversetaxenabled AS `rates.labourtaxcode.reversetaxenabled`,
    rates_discountfee AS `rates.discountfee`,
    rates_alwaysdeductcis AS `rates.alwaysdeductcis`,
    rates_servicefee_id AS `rates.servicefee.id`,
    rates_servicefee_name AS `rates.servicefee.name`,
    rates_material_pricingtier_id AS `rates.material.pricingtier.id`,
    rates_material_pricingtier_name AS `rates.material.pricingtier.name`,
    rates_material_pricingtier_defaultmarkup AS `rates.material.pricingtier.defaultmarkup`,
    rates_material_markup AS `rates.material.markup`,
    profile_notes AS `profile.notes`,
    profile_customerprofile_id AS `profile.customerprofile.id`,
    profile_customerprofile_name AS `profile.customerprofile.name`,
    profile_customergroup_id AS `profile.customergroup.id`,
    profile_customergroup_name AS `profile.customergroup.name`,
    profile_accountmanager_id AS `profile.accountmanager.id`,
    profile_accountmanager_name AS `profile.accountmanager.name`,
    profile_currency AS `profile.currency`,
    profile_servicejobcostcenter_id AS `profile.servicejobcostcenter.id`,
    profile_servicejobcostcenter_name AS `profile.servicejobcostcenter.name`,
    banking_accountname AS `banking.accountname`,
    banking_routingno AS `banking.routingno`,
    banking_accountno AS `banking.accountno`,
    banking_paymentmethod_id AS `banking.paymentmethod.id`,
    banking_paymentmethod_name AS `banking.paymentmethod.name`,
    banking_paymenttermid AS `banking.paymenttermid`,
    banking_paymentterms_days AS `banking.paymentterms.days`,
    banking_paymentterms_type AS `banking.paymentterms.type`,
    banking_creditlimit AS `banking.creditlimit`,
    banking_onstop AS `banking.onstop`,
    banking_retention AS `banking.retention`,
    banking_vendorordernorequired AS `banking.vendorordernorequired`,
    email,
    datemodified,
    datecreated,
    ein,
    website,
    fax,
    companynumber,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customers;

-- CustomerPreferredTechs View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customerpreferredtechs;
CREATE VIEW {etani_client_id}_simpro_customerpreferredtechs AS
SELECT
    customerid AS `customersid`,
    technicianid AS `id`,
    name,
    type,
    typeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customerpreferredtechs;

-- CustomerTags View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customertags;
CREATE VIEW {etani_client_id}_simpro_customertags AS
SELECT
    customerid AS `customersid`,
    tagindex,
    tagvalue AS `value`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customertags;

-- CustomerSites View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customersites;
CREATE VIEW {etani_client_id}_simpro_customersites AS
SELECT
    customerid AS `customersid`,
    siteid AS `id`,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customersites;

-- CustomerContracts View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customercontracts;
CREATE VIEW {etani_client_id}_simpro_customercontracts AS
SELECT
    customerid AS `customersid`,
    contractid AS `id`,
    name,
    startdate,
    enddate,
    contractno,
    expired,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customercontracts;

-- CustomerContacts View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customercontacts;
CREATE VIEW {etani_client_id}_simpro_customercontacts AS
SELECT
    customerid AS `customersid`,
    contactid AS `id`,
    givenname,
    familyname,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customercontacts;

-- CustomerResponseTimes View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customerresponsetimes;
CREATE VIEW {etani_client_id}_simpro_customerresponsetimes AS
SELECT
    customerid AS `customersid`,
    responsetimeid AS `id`,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customerresponsetimes;

-- CustomerCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customercustomfields;
CREATE VIEW {etani_client_id}_simpro_customercustomfields AS
SELECT
    customerid AS `customersid`,
    customfieldindex,
    customfield_id AS `customfield.id`,
    customfield_name AS `customfield.name`,
    customfield_type AS `customfield.type`,
    customfield_ismandatory AS `customfield.ismandatory`,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customercustomfields;

-- Employees View
DROP VIEW IF EXISTS {etani_client_id}_simpro_employees;
CREATE VIEW {etani_client_id}_simpro_employees AS
SELECT
    id,
    name,
    position,
    address_address AS `address.address`,
    dateofhire,
    primarycontact_email AS `primarycontact.email`,
    assignedcostcenters,
    customfields,
    archived,
    datecreated,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_employees;


-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Jobs View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobs;
CREATE VIEW {etani_client_id}_simpro_jobs AS
SELECT
    id,
    customer_id AS `customer.id`,
    customer_companyname AS `customer.companyname`,
    site_id AS `site.id`,
    description,
    dateissued,
    total_extax AS `total.extax`,
    status_name AS `status.name`,
    customfields,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobs;

-- Invoices View
DROP VIEW IF EXISTS {etani_client_id}_simpro_invoices;
CREATE VIEW {etani_client_id}_simpro_invoices AS
SELECT
    id,
    internalid,
    type,
    customer_id AS `customer.id`,
    customer_companyname AS `customer.companyname`,
    customer_givenname AS `customer.givenname`,
    customer_familyname AS `customer.familyname`,
    recurringinvoice_id AS `recurringinvoice.id`,
    recurringinvoice_description AS `recurringinvoice.description`,
    recurringinvoice_total_extax AS `recurringinvoice.total.extax`,
    recurringinvoice_total_tax AS `recurringinvoice.total.tax`,
    recurringinvoice_total_inctax AS `recurringinvoice.total.inctax`,
    dateissued,
    period_startdate AS `period.startdate`,
    period_enddate AS `period.enddate`,
    paymenttermid,
    paymentterms_days AS `paymentterms.days`,
    paymentterms_type AS `paymentterms.type`,
    paymentterms_duedate AS `paymentterms.duedate`,
    progressclaimnumber,
    isfinalclaim,
    stage,
    peritem,
    orderno,
    latepaymentfee,
    cisdeductionrate,
    exchangerate,
    accountingcategory_id AS `accountingcategory.id`,
    accountingcategory_name AS `accountingcategory.name`,
    status_id AS `status.id`,
    status_name AS `status.name`,
    autoadjuststatus,
    description,
    notes,
    total_extax AS `total.extax`,
    total_tax AS `total.tax`,
    total_inctax AS `total.inctax`,
    total_reversechargetax AS `total.reversechargetax`,
    total_amountapplied AS `total.amountapplied`,
    total_balancedue AS `total.balancedue`,
    isretainage,
    retainage,
    ispaid,
    datepaid,
    currency,
    datecreated,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_invoices;

-- Quotes View
DROP VIEW IF EXISTS {etani_client_id}_simpro_quotes;
CREATE VIEW {etani_client_id}_simpro_quotes AS
SELECT
    id,
    customer_id AS `customer.id`,
    description,
    dateissued,
    total_extax AS `total.extax`,
    customfields,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_quotes;

-- Leads View
DROP VIEW IF EXISTS {etani_client_id}_simpro_leads;
CREATE VIEW {etani_client_id}_simpro_leads AS
SELECT
    id,
    customer_id AS `customer.id`,
    description,
    datecreated,
    customfields,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_leads;

-- Contractors View
DROP VIEW IF EXISTS {etani_client_id}_simpro_contractors;
CREATE VIEW {etani_client_id}_simpro_contractors AS
SELECT
    id,
    name,
    position,
    address_address AS `address.address`,
    dateofhire,
    customfields,
    archived,
    datecreated,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_contractors;

-- Sites View
DROP VIEW IF EXISTS {etani_client_id}_simpro_sites;
CREATE VIEW {etani_client_id}_simpro_sites AS
SELECT
    id,
    name,
    customer_id AS `customer.id`,
    address_address AS `address.address`,
    isactive,
    customfields,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_sites;

-- Catalogs View
DROP VIEW IF EXISTS {etani_client_id}_simpro_catalogs;
CREATE VIEW {etani_client_id}_simpro_catalogs AS
SELECT
    id,
    partno,
    name,
    tradeprice,
    sellprice,
    uom,
    group_name AS `group.name`,
    customfields,
    archived,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_catalogs;

-- Schedules View
DROP VIEW IF EXISTS {etani_client_id}_simpro_schedules;
CREATE VIEW {etani_client_id}_simpro_schedules AS
SELECT
    id,
    date,
    staff_id AS `staff.id`,
    totalhours,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_schedules;

-- CustomerPayments View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customerpayments;
CREATE VIEW {etani_client_id}_simpro_customerpayments AS
SELECT
    id,
    payment_date AS `payment.date`,
    payment_paymentmethod_name AS `payment.paymentmethod.name`,
    payment_paymentmethod_id AS `payment.paymentmethod.id`,
    status,
    depositaccount,
    financecharge,
    checkno,
    details,
    financefeebreakdown,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customerpayments;

-- StorageDevices View
DROP VIEW IF EXISTS {etani_client_id}_simpro_storagedevices;
CREATE VIEW {etani_client_id}_simpro_storagedevices AS
SELECT
    id,
    name,
    isdefault,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_storagedevices;

-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- VendorOrders View
DROP VIEW IF EXISTS {etani_client_id}_simpro_vendororders;
CREATE VIEW {etani_client_id}_simpro_vendororders AS
SELECT
    id,
    vendor_id AS `vendor.id`,
    orderno,
    dateissued,
    total_inctax AS `total.inctax`,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_vendororders;

-- EmployeeTimesheets View
DROP VIEW IF EXISTS {etani_client_id}_simpro_employeetimesheets;
CREATE VIEW {etani_client_id}_simpro_employeetimesheets AS
SELECT
    scheduletype,
    reference,
    h_ref AS `_href`,
    date,
    starttime,
    endtime,
    totalhrs,
    jobid AS `_href.jobs`,
    sectionsid AS `_href.sections`,
    costcentersid AS `_href.costcenters`,
    schedulesid AS `_href.schedules`,
    schedulerateid AS `schedulerate.id`,
    scheduleratename AS `schedulerate.name`,
    cost,
    employeeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_employeetimesheets;

-- ContractorTimesheets View
DROP VIEW IF EXISTS {etani_client_id}_simpro_contractortimesheets;
CREATE VIEW {etani_client_id}_simpro_contractortimesheets AS
SELECT
    scheduletype,
    reference,
    h_ref AS `_href`,
    date,
    starttime,
    endtime,
    totalhrs,
    jobid AS `_href.jobs`,
    sectionsid AS `_href.sections`,
    costcentersid AS `_href.costcenters`,
    schedulesid AS `_href.schedules`,
    schedulerateid AS `schedulerate.id`,
    scheduleratename AS `schedulerate.name`,
    cost,
    totalcost,
    contractorid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_contractortimesheets;

-- InvoiceCostCenters View
DROP VIEW IF EXISTS {etani_client_id}_simpro_invoicecostcenters;
CREATE VIEW {etani_client_id}_simpro_invoicecostcenters AS
SELECT
    invoicesid,
    id,
    name,
    jobid,
    recurringinvoiceid,
    sectionid,
    costcenter_id AS `costcenter.id`,
    costcenter_name AS `costcenter.name`,
    total_extax AS `total.extax`,
    total_inctax AS `total.inctax`,
    claim_extax AS `claim.extax`,
    claim_inctax AS `claim.inctax`,
    claim_percent AS `claim.percent`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_invoicecostcenters;

-- InvoiceCostCenterItems View
DROP VIEW IF EXISTS {etani_client_id}_simpro_invoicecostcenteritems;
CREATE VIEW {etani_client_id}_simpro_invoicecostcenteritems AS
SELECT
    invoicesid,
    costcentersid AS `invoicecostcentersid`,
    id,
    item_id AS `item.id`,
    item_partno AS `item.partno`,
    item_name AS `item.name`,
    item_type AS `item.type`,
    quantity_total AS `quantity.total`,
    quantity_remaining AS `quantity.remaining`,
    quantity_claimed AS `quantity.claimed`,
    unitprice_extax AS `unitprice.extax`,
    unitprice_inctax AS `unitprice.inctax`,
    total_extax AS `total.extax`,
    total_inctax AS `total.inctax`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_invoicecostcenteritems;

-- InvoicesJobs View
DROP VIEW IF EXISTS {etani_client_id}_simpro_invoicesjobs;
CREATE VIEW {etani_client_id}_simpro_invoicesjobs AS
SELECT
    id,
    invoicesid,
    description,
    total_inctax AS `total.inctax`,
    total_extax AS `total.extax`,
    total_tax AS `total.tax`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_invoicesjobs;

-- JobSections View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobsections;
CREATE VIEW {etani_client_id}_simpro_jobsections AS
SELECT
    id,
    name,
    description,
    displayorder,
    jobid,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobsections;

-- JobCostCenters View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobcostcenters;
CREATE VIEW {etani_client_id}_simpro_jobcostcenters AS
SELECT
    id,
    costcenter_id AS `costcenter.id`,
    costcenter_name AS `costcenter.name`,
    name,
    job_id AS `job.id`,
    job_type AS `job.type`,
    job_name AS `job.name`,
    job_stage AS `job.stage`,
    job_status AS `job.status`,
    section_id AS `section.id`,
    section_name AS `section.name`,
    _href,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobcostcenters;

-- JobCostCentersSchedules View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobcostcentersschedules;
CREATE VIEW {etani_client_id}_simpro_jobcostcentersschedules AS
SELECT
    id,
    totalhours,
    staff_id AS `staff.id`,
    staff_name AS `staff.name`,
    staff_type AS `staff.type`,
    staff_typeid AS `staff.typeid`,
    jobid,
    sectionid,
    costcentersid,
    date,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobcostcentersschedules;

-- JobCostCentersLabourateItems View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobcostcenterslabourateitems;
CREATE VIEW {etani_client_id}_simpro_jobcostcenterslabourateitems AS
SELECT
    id,
    labortype_id AS `labortype.id`,
    labortype_name AS `labortype.name`,
    laborrate,
    labormarkup,
    salestaxcode_id AS `salestaxcode.id`,
    salestaxcode_code AS `salestaxcode.code`,
    salestaxcode_type AS `salestaxcode.type`,
    salestaxcode_rate AS `salestaxcode.rate`,
    projectedtime,
    ticked,
    datemodified,
    discount,
    sellprice_extax AS `sellprice.extax`,
    sellprice_inctax AS `sellprice.inctax`,
    sellprice_exdiscountextax AS `sellprice.exdiscountextax`,
    sellprice_exdiscountinctax AS `sellprice.exdiscountinctax`,
    total_qty AS `total.qty`,
    total_amount_extax AS `total.amount.extax`,
    total_amount_inctax AS `total.amount.inctax`,
    claimed_todate_qty AS `claimed.todate.qty`,
    claimed_todate_amount_extax AS `claimed.todate.amount.extax`,
    claimed_todate_amount_inctax AS `claimed.todate.amount.inctax`,
    claimed_remaining_qty AS `claimed.remaining.qty`,
    claimed_remaining_amount_extax AS `claimed.remaining.amount.extax`,
    claimed_remaining_amount_inctax AS `claimed.remaining.amount.inctax`,
    incomeaccount_id AS `incomeaccount.id`,
    incomeaccount_name AS `incomeaccount.name`,
    incomeaccount_number AS `incomeaccount.number`,
    jobid,
    sectionid,
    costcentersid,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobcostcenterslabourateitems;

-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- QuoteSections View
DROP VIEW IF EXISTS {etani_client_id}_simpro_quotesections;
CREATE VIEW {etani_client_id}_simpro_quotesections AS
SELECT
    id,
    name,
    description,
    quoteid,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_quotesections;

-- QuoteCostCenters View
DROP VIEW IF EXISTS {etani_client_id}_simpro_quotecostcenters;
CREATE VIEW {etani_client_id}_simpro_quotecostcenters AS
SELECT
    id,
    costcenter_id AS `costcenter.id`,
    costcenter_name AS `costcenter.name`,
    name,
    quote_id AS `quote.id`,
    quote_type AS `quote.type`,
    quote_name AS `quote.name`,
    quote_stage AS `quote.stage`,
    quote_status AS `quote.status`,
    section_id AS `section.id`,
    section_name AS `section.name`,
    _href,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_quotecostcenters;

-- StorageDeviceStock View
DROP VIEW IF EXISTS {etani_client_id}_simpro_storagedevicestock;
CREATE VIEW {etani_client_id}_simpro_storagedevicestock AS
SELECT
    catalog_id AS `catalog.id`,
    storagedeviceid,
    inventorycount,
    inventoryvalue,
    onorder,
    totalvalue,
    minimumlevel,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_storagedevicestock;

-- VendorOrderReceipts View
DROP VIEW IF EXISTS {etani_client_id}_simpro_vendororderreceipts;
CREATE VIEW {etani_client_id}_simpro_vendororderreceipts AS
SELECT
    id,
    vendororderid,
    vendorinvoiceno,
    dateissued,
    total_inctax AS `total.inctax`,
    itemsreceiveddate,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_vendororderreceipts;

-- Activities View
DROP VIEW IF EXISTS {etani_client_id}_simpro_activities;
CREATE VIEW {etani_client_id}_simpro_activities AS
SELECT
    id,
    name,
    billable,
    schedulerate,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_activities;

-- ActivitySchedules View
DROP VIEW IF EXISTS {etani_client_id}_simpro_activityschedules;
CREATE VIEW {etani_client_id}_simpro_activityschedules AS
SELECT
    id,
    totalhours,
    staff_id AS `staff.id`,
    staff_name AS `staff.name`,
    staff_type AS `staff.type`,
    staff_typeid AS `staff.typeid`,
    date,
    activity_id AS `activity.id`,
    activity_name AS `activity.name`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_activityschedules;

-- AssetTypes View
DROP VIEW IF EXISTS {etani_client_id}_simpro_assettypes;
CREATE VIEW {etani_client_id}_simpro_assettypes AS
SELECT
    id,
    name,
    reference,
    description,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_assettypes;

-- CostCenters View
DROP VIEW IF EXISTS {etani_client_id}_simpro_costcenters;
CREATE VIEW {etani_client_id}_simpro_costcenters AS
SELECT
    id,
    name,
    incomeaccountno,
    expenseaccountno,
    monthlysalesbudget,
    monthlyexpenditurebudget,
    archived,
    ismembershipcostcenter,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_costcenters;

-- BusinessGroups View
DROP VIEW IF EXISTS {etani_client_id}_simpro_businessgroups;
CREATE VIEW {etani_client_id}_simpro_businessgroups AS
SELECT
    id,
    name,
    costcenters,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_businessgroups;

-- CustomerGroups View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customergroups;
CREATE VIEW {etani_client_id}_simpro_customergroups AS
SELECT
    id,
    name,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customergroups;

-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CustomerProfiles View
DROP VIEW IF EXISTS {etani_client_id}_simpro_customerprofiles;
CREATE VIEW {etani_client_id}_simpro_customerprofiles AS
SELECT
    id,
    name,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_customerprofiles;

-- SecurityGroups View
DROP VIEW IF EXISTS {etani_client_id}_simpro_securitygroups;
CREATE VIEW {etani_client_id}_simpro_securitygroups AS
SELECT
    id,
    name,
    businessgroup_id AS `businessgroup.id`,
    dashboards,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_securitygroups;

-- LaborRates View
DROP VIEW IF EXISTS {etani_client_id}_simpro_laborrates;
CREATE VIEW {etani_client_id}_simpro_laborrates AS
SELECT
    id,
    name,
    costrate,
    markup,
    isdefault,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_laborrates;

-- ScheduleRates View
DROP VIEW IF EXISTS {etani_client_id}_simpro_schedulerates;
CREATE VIEW {etani_client_id}_simpro_schedulerates AS
SELECT
    id,
    name,
    multiplier,
    showinmobile,
    displayorder,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_schedulerates;

-- ServiceFees View
DROP VIEW IF EXISTS {etani_client_id}_simpro_servicefees;
CREATE VIEW {etani_client_id}_simpro_servicefees AS
SELECT
    id,
    name,
    labortime,
    price,
    displayorder,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_servicefees;

-- UnitOfMeasurement View
DROP VIEW IF EXISTS {etani_client_id}_simpro_unitofmeasurement;
CREATE VIEW {etani_client_id}_simpro_unitofmeasurement AS
SELECT
    id,
    name,
    symbol,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_unitofmeasurement;

-- ContractorInvoices View
DROP VIEW IF EXISTS {etani_client_id}_simpro_contractorinvoices;
CREATE VIEW {etani_client_id}_simpro_contractorinvoices AS
SELECT
    id,
    contractorjobs,
    invoiceno,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_contractorinvoices;

-- AccountCategories View
DROP VIEW IF EXISTS {etani_client_id}_simpro_accountcategories;
CREATE VIEW {etani_client_id}_simpro_accountcategories AS
SELECT
    id,
    name,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_accountcategories;

-- FitTimes View
DROP VIEW IF EXISTS {etani_client_id}_simpro_fittimes;
CREATE VIEW {etani_client_id}_simpro_fittimes AS
SELECT
    id,
    name,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_fittimes;

-- Prebuilds View
DROP VIEW IF EXISTS {etani_client_id}_simpro_prebuilds;
CREATE VIEW {etani_client_id}_simpro_prebuilds AS
SELECT
    id,
    name,
    description,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_prebuilds;

-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InventoryJournals View
DROP VIEW IF EXISTS {etani_client_id}_simpro_inventoryjournals;
CREATE VIEW {etani_client_id}_simpro_inventoryjournals AS
SELECT
    id,
    journaldate,
    amount,
    costcenter_id AS `costcenter.id`,
    costcenter_name AS `costcenter.name`,
    memo,
    datecreated AS `exportdate`,
    secondaryaccount,
    datemodified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_inventoryjournals;

-- Teams View
DROP VIEW IF EXISTS {etani_client_id}_simpro_teams;
CREATE VIEW {etani_client_id}_simpro_teams AS
SELECT
    id,
    name,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_teams;

-- TeamAvailability View
DROP VIEW IF EXISTS {etani_client_id}_simpro_teamavailability;
CREATE VIEW {etani_client_id}_simpro_teamavailability AS
SELECT
    teamid AS `teamsid`,
    availabilityindex,
    startday,
    starttime,
    endday,
    endtime,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_teamavailability;

-- TeamCostCenters View
DROP VIEW IF EXISTS {etani_client_id}_simpro_teamcostcenters;
CREATE VIEW {etani_client_id}_simpro_teamcostcenters AS
SELECT
    teamid AS `teamsid`,
    costcenterid AS `id`,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_teamcostcenters;

-- TeamMembers View
DROP VIEW IF EXISTS {etani_client_id}_simpro_teammembers;
CREATE VIEW {etani_client_id}_simpro_teammembers AS
SELECT
    teamid AS `teamsid`,
    memberid AS `id`,
    name,
    type,
    typeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_teammembers;

-- TeamZones View
DROP VIEW IF EXISTS {etani_client_id}_simpro_teamzones;
CREATE VIEW {etani_client_id}_simpro_teamzones AS
SELECT
    teamid AS `teamsid`,
    zoneid AS `id`,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_teamzones;

-- ResponseTimes View
DROP VIEW IF EXISTS {etani_client_id}_simpro_responsetimes;
CREATE VIEW {etani_client_id}_simpro_responsetimes AS
SELECT
    id,
    name,
    days,
    hours,
    minutes,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_responsetimes;

-- Tasks View
DROP VIEW IF EXISTS {etani_client_id}_simpro_tasks;
CREATE VIEW {etani_client_id}_simpro_tasks AS
SELECT
    id,
    subject,
    assignedto_id AS `assignedto.id`,
    assignedto_name AS `assignedto.name`,
    assignedto_type AS `assignedto.type`,
    assignedto_typeid AS `assignedto.typeid`,
    completedby_id AS `completedby.id`,
    completedby_name AS `completedby.name`,
    completedby_type AS `completedby.type`,
    completedby_typeid AS `completedby.typeid`,
    duedate,
    percentcomplete,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_tasks;

-- TaskAssignees View
DROP VIEW IF EXISTS {etani_client_id}_simpro_taskassignees;
CREATE VIEW {etani_client_id}_simpro_taskassignees AS
SELECT
    id,
    name,
    type,
    typeid,
    taskid AS `tasksid`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_taskassignees;

-- JobTasks View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobtasks;
CREATE VIEW {etani_client_id}_simpro_jobtasks AS
SELECT
    id,
    subject,
    assignedto_id AS `assignedto.id`,
    assignedto_name AS `assignedto.name`,
    assignedto_type AS `assignedto.type`,
    assignedto_typeid AS `assignedto.typeid`,
    completedby_id AS `completedby.id`,
    completedby_name AS `completedby.name`,
    completedby_type AS `completedby.type`,
    completedby_typeid AS `completedby.typeid`,
    duedate,
    percentcomplete,
    jobid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobtasks;

-- Pattern: {etani_client_id}_simpro_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobTaskAssignees View
DROP VIEW IF EXISTS {etani_client_id}_simpro_jobtaskassignees;
CREATE VIEW {etani_client_id}_simpro_jobtaskassignees AS
SELECT
    id,
    name,
    type,
    typeid,
    taskid AS `tasksid`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_simpro_jobtaskassignees;