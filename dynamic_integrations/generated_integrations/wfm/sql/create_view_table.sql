-- WFM Views - Auto Generated
-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CustomFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_customfields;
CREATE VIEW {etani_client_id}_wfm_customfields AS
SELECT
    id AS `uuid`,
    name,
    type,
    mandatory,
    link,
    options,
    createdat,
    updatedat,
    clientid,
    organisationid,
    objectsclient AS `objects.client`,
    objectsclientenabled AS `objects_client.enabled`,
    objectsclientorder AS `objects_client.order`,
    objectscontact AS `objects.contact`,
    objectscontactenabled AS `objects_contact.enabled`,
    objectscontactorder AS `objects_contact.order`,
    objectssupplier AS `objects.supplier`,
    objectssupplierenabled AS `objects_supplier.enabled`,
    objectssupplierorder AS `objects_supplier.order`,
    objectsjob AS `objects.job`,
    objectsjobenabled AS `objects_job.enabled`,
    objectsjoborder AS `objects_job.order`,
    objectslead AS `objects.lead`,
    objectsleadenabled AS `objects_lead.enabled`,
    objectsleadorder AS `objects_lead.order`,
    objectsjobtask AS `objects.jobtask`,
    objectsjobtaskenabled AS `objects_jobtask.enabled`,
    objectsjobtaskorder AS `objects_jobtask.order`,
    objectsjobcost AS `objects.jobcost`,
    objectsjobcostenabled AS `objects_jobcost.enabled`,
    objectsjobcostorder AS `objects_jobcost.order`,
    objectstimesheet AS `objects.timesheet`,
    objectstimesheetenabled AS `objects_timesheet.enabled`,
    objectstimesheetorder AS `objects_timesheet.order`,
    objectsquote AS `objects.quote`,
    objectsquoteenabled AS `objects_quote.enabled`,
    objectsquoteorder AS `objects_quote.order`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_customfields;

-- Costs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_costs;
CREATE VIEW {etani_client_id}_wfm_costs AS
SELECT
    id AS `uuid`,
    name,
    costcode,
    note,
    type,
    billable,
    unitcost,
    unitprice,
    incomeaccount,
    costofsaleaccount,
    salestax,
    purchasetax,
    createdat,
    updatedat,
    clientid,
    organisationid,
    supplieruuid AS `supplier.uuid`,
    suppliername AS `supplier.name`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_costs;

-- JobCategories View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobcategories;
CREATE VIEW {etani_client_id}_wfm_jobcategories AS
SELECT
    id AS `uuid`,
    name,
    description,
    incomeaccount,
    costofsaleaccount,
    createdat,
    updatedat,
    deletedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobcategories;

-- JobStatus View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobstatus;
CREATE VIEW {etani_client_id}_wfm_jobstatus AS
SELECT
    id AS `uuid`,
    name,
    type,
    showinmyjobs,
    showinschedule,
    lockcosts,
    locktimesheets,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobstatus;

-- Staff View
DROP VIEW IF EXISTS {etani_client_id}_wfm_staff;
CREATE VIEW {etani_client_id}_wfm_staff AS
SELECT
    id AS `uuid`,
    firstname,
    lastname,
    currentlyworking,
    baserate,
    billablerate,
    director,
    freeearner,
    fulltimeequivalent,
    payrollcode,
    notes,
    role,
    historicrates,
    createdat,
    updatedat,
    deletedat,
    clientid,
    organisationid,
    contactdetailsemail AS `contactdetails.email`,
    contactdetailsmobile AS `contactdetails.mobile`,
    contactdetailsphone AS `contactdetails.phone`,
    contactdetailsaddress AS `contactdetails.address`,
    capacityproductivityrate AS `capacity.productivityrate`,
    capacitymonday AS `capacity.monday`,
    capacitytuesday AS `capacity.tuesday`,
    capacitywednesday AS `capacity.wednesday`,
    capacitythursday AS `capacity.thursday`,
    capacityfriday AS `capacity.friday`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_staff;

-- Taxes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_taxes;
CREATE VIEW {etani_client_id}_wfm_taxes AS
SELECT
    id AS `uuid`,
    name,
    type,
    rate,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_taxes;

-- LeadCategories View
DROP VIEW IF EXISTS {etani_client_id}_wfm_leadcategories;
CREATE VIEW {etani_client_id}_wfm_leadcategories AS
SELECT
    id AS `uuid`,
    name,
    createdat,
    updatedat,
    deletedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_leadcategories;

-- Tasks View
DROP VIEW IF EXISTS {etani_client_id}_wfm_tasks;
CREATE VIEW {etani_client_id}_wfm_tasks AS
SELECT
    id AS `uuid`,
    name,
    description,
    baserate,
    billablerate,
    exportcode,
    salestax,
    historicrates,
    incomeaccount,
    createdat,
    updatedat,
    deletedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_tasks;

-- Jobs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobs;
CREATE VIEW {etani_client_id}_wfm_jobs AS
SELECT
    id AS `uuid`,
    jobnumber,
    name,
    clientuuid,
    clientcontactuuid,
    description,
    clientordernumber,
    budget,
    jobstatusuuid,
    jobcategoryuuid,
    priority,
    taskinvoicerate,
    excludeestimatedbillings,
    estimatedbillings,
    capacityreducing,
    clientmanageruuid,
    jobmanageruuid,
    startdate,
    duedate,
    completeddate,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobs;

-- Timesheets View
DROP VIEW IF EXISTS {etani_client_id}_wfm_timesheets;
CREATE VIEW {etani_client_id}_wfm_timesheets AS
SELECT
    id AS `uuid`,
    time,
    starttime,
    endtime,
    date,
    note,
    billable,
    submittedat,
    createdat,
    updatedat,
    jobuuid AS `job.uuid`,
    jobjobnumber AS `job.jobnumber`,
    jobname AS `job.name`,
    jobtaskuuid AS `jobtask.uuid`,
    jobtaskname AS `jobtask.name`,
    jobtasklabel AS `jobtask.label`,
    staffuuid AS `staff.uuid`,
    stafffirstname AS `staff.firstname`,
    stafflastname AS `staff.lastname`,
    wipbaserate AS `wip.baserate`,
    wipcostamount AS `wip.costamount`,
    wipstandardrate AS `wip.standardrate`,
    wipstandardamount AS `wip.standardamount`,
    wipchargerate AS `wip.chargerate`,
    wipchargeamount AS `wip.chargeamount`,
    wipinvoiceuuid AS `wip.invoice.invoiceuuid`,
    wipinvoicetaskuuid AS `wip.invoice.invoicetaskuuid`,
    wipinvoicedate AS `wip.invoice.invoicedate`,
    wipinvoicerate AS `wip.invoice.invoicerate`,
    wipinvoicetime AS `wip.invoice.invoicetime`,
    wipinvoiceamount AS `wip.invoice.invoiceamount`,
    wipinvoicewriteonamount AS `wip.invoice.writeonamount`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_timesheets;


-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Clients View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clients;
CREATE VIEW {etani_client_id}_wfm_clients AS
SELECT
    id AS `uuid`,
    name,
    exportcode,
    clientmanageruuid,
    jobmanageruuid,
    referralsource,
    prospect,
    archived,
    favorite,
    addresses,
    createdat,
    updatedat,
    clientid,
    organisationid,
    contactdetailsemail AS `contactdetails.email`,
    contactdetailsphone AS `contactdetails.phone`,
    contactdetailsfax AS `contactdetails.fax`,
    contactdetailswebsite AS `contactdetails.website`,
    billingdetailsbusinessstructureuuid AS `billingdetails.businessstructureuuid`,
    billingdetailsclienttypeuuid AS `billingdetails.clienttypeuuid`,
    billingdetailsbalancedate AS `billingdetails.balancedate`,
    billingdetailsmarkup AS `billingdetails.markup`,
    billingdetailszeroratedtaxrate AS `billingdetails.zeroratedtaxrate`,
    billingdetailszeroratedtaxratetaxname AS `billingdetails_zeroratedtaxrate.taxname`,
    billingdetailszeroratedtaxraterate AS `billingdetails_zeroratedtaxrate.rate`,
    billingdetailsinvoiceduedate AS `billingdetails.invoiceduedate`,
    billingdetailsbillingclientuuid AS `billingdetails.billingclientuuid`,
    billingdetailscustomrates AS `billingdetails.customrates`,
    billingdetailstaxnumbers AS `billingdetails.taxnumbers`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clients;

-- Quotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotes;
CREATE VIEW {etani_client_id}_wfm_quotes AS
SELECT
    id AS `uuid`,
    quotenumber,
    quotename,
    clientuuid,
    contactuuid,
    salespersonuuid,
    jobmasterquote,
    type,
    description,
    optionalitemsexplanation,
    validfrom,
    validto,
    sent,
    status,
    accepteddeclineddate,
    budget,
    fixedprice,
    amountextax,
    amountinctax,
    costamountextax,
    createdat,
    updatedat,
    clientid,
    organisationid,
    leaduuid AS `lead.uuid`,
    leadname AS `lead.name`,
    jobuuid AS `job.uuid`,
    jobnumber AS `job.number`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotes;

-- Invoices View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoices;
CREATE VIEW {etani_client_id}_wfm_invoices AS
SELECT
    id AS `uuid`,
    invoicenumber,
    description,
    clientuuid,
    contactuuid,
    date,
    duedate,
    sent,
    status,
    type,
    mode,
    progressdate,
    fixedprice,
    amountextax,
    amountinctax,
    amountpaid,
    datepaid,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoices;

-- PurchaseOrders View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseorders;
CREATE VIEW {etani_client_id}_wfm_purchaseorders AS
SELECT
    id AS `uuid`,
    supplieruuid,
    purchaseordernumber,
    status,
    billingstatus,
    stockreceiptstatus,
    description,
    deliveryaddress,
    date,
    sent,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseorders;

-- PurchaseOrderBills View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseorderbills;
CREATE VIEW {etani_client_id}_wfm_purchaseorderbills AS
SELECT
    id AS `uuid`,
    purchaseorderuuid,
    date,
    supplierbillnumber,
    duedate,
    status,
    stockreceiptid,
    receiptdate,
    tax,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseorderbills;

-- StockReceipts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_stockreceipts;
CREATE VIEW {etani_client_id}_wfm_stockreceipts AS
SELECT
    id AS `uuid`,
    purchaseorderuuid,
    date,
    stockreceiptnote,
    stockreceiptid,
    supplierbillnumber,
    billdate,
    duedate,
    tax,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_stockreceipts;

-- Suppliers View
DROP VIEW IF EXISTS {etani_client_id}_wfm_suppliers;
CREATE VIEW {etani_client_id}_wfm_suppliers AS
SELECT
    id AS `uuid`,
    name,
    exportcode,
    status,
    favourite,
    zeroratedgst,
    addresses,
    createdat,
    updatedat,
    deletedat,
    clientid,
    organisationid,
    contactdetailsemail AS `contactdetails.email`,
    contactdetailsphone AS `contactdetails.phone`,
    contactdetailsfax AS `contactdetails.fax`,
    contactdetailswebsite AS `contactdetails.website`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_suppliers;

-- StaffCustTaskRates View
DROP VIEW IF EXISTS {etani_client_id}_wfm_staffcusttaskrates;
CREATE VIEW {etani_client_id}_wfm_staffcusttaskrates AS
SELECT
    taskuuid,
    baserate,
    billablerate,
    staffid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_staffcusttaskrates;

-- StaffHistoricRates View
DROP VIEW IF EXISTS {etani_client_id}_wfm_staffhistoricrates;
CREATE VIEW {etani_client_id}_wfm_staffhistoricrates AS
SELECT
    applieduptodate,
    billablerate,
    staffid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_staffhistoricrates;

-- TasksCustomRates View
DROP VIEW IF EXISTS {etani_client_id}_wfm_taskscustomrates;
CREATE VIEW {etani_client_id}_wfm_taskscustomrates AS
SELECT
    clientuuid,
    billablerate,
    tasksid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_taskscustomrates;

-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobsCustomfields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobscustomfields;
CREATE VIEW {etani_client_id}_wfm_jobscustomfields AS
SELECT
    uuid,
    name,
    value,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobscustomfields;

-- JobsTasks View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobstasks;
CREATE VIEW {etani_client_id}_wfm_jobstasks AS
SELECT
    uuid,
    taskuuid,
    name,
    label,
    phaseuuid,
    description,
    billable,
    custombillablerate,
    completed,
    startdate,
    duedate,
    estimatedminutes,
    actualminutes,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobstasks;

-- JobsTasksStaffs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobstasksstaffs;
CREATE VIEW {etani_client_id}_wfm_jobstasksstaffs AS
SELECT
    uuid,
    allocatedtime,
    jobsid,
    jobstasksid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobstasksstaffs;

-- JobsTasksCustFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobstaskscustfields;
CREATE VIEW {etani_client_id}_wfm_jobstaskscustfields AS
SELECT
    uuid,
    name,
    value,
    jobsid,
    jobstasksid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobstaskscustfields;

-- JobsCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobscosts;
CREATE VIEW {etani_client_id}_wfm_jobscosts AS
SELECT
    uuid,
    name,
    costcode,
    costuuid,
    date,
    quantity,
    note,
    type,
    billable,
    actual,
    unitcost,
    unitprice,
    supplieruuid,
    phaseuuid,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobscosts;

-- JobsCostsCustFlds View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobscostscustflds;
CREATE VIEW {etani_client_id}_wfm_jobscostscustflds AS
SELECT
    uuid,
    name,
    value,
    jobsid,
    jobscostsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobscostscustflds;

-- JobsNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsnotes;
CREATE VIEW {etani_client_id}_wfm_jobsnotes AS
SELECT
    uuid,
    title,
    phaseuuid,
    description,
    date,
    createdbyuuid,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsnotes;

-- JobsDocuments View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsdocuments;
CREATE VIEW {etani_client_id}_wfm_jobsdocuments AS
SELECT
    uuid,
    title,
    filename,
    filesize,
    note,
    phaseuuid,
    downloadurl,
    uploadedbyuuid,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsdocuments;

-- JobsStaffassigned View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsstaffassigned;
CREATE VIEW {etani_client_id}_wfm_jobsstaffassigned AS
SELECT
    uuid,
    custombillablerate,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsstaffassigned;

-- JobsPhases View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsphases;
CREATE VIEW {etani_client_id}_wfm_jobsphases AS
SELECT
    uuid,
    name,
    description,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsphases;

-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JobsMilestones View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsmilestones;
CREATE VIEW {etani_client_id}_wfm_jobsmilestones AS
SELECT
    name,
    date,
    phaseuuid,
    completed,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsmilestones;

-- JobsQuotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsquotes;
CREATE VIEW {etani_client_id}_wfm_jobsquotes AS
SELECT
    uuid,
    clientuuid,
    contactuuid,
    number,
    name,
    type,
    status,
    ismasterquote,
    validfrom,
    validto,
    salespersonuuid,
    budget,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsquotes;

-- JobsQuotesCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsquotescustomfields;
CREATE VIEW {etani_client_id}_wfm_jobsquotescustomfields AS
SELECT
    uuid,
    name,
    value,
    jobsid,
    jobsquotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsquotescustomfields;

-- JobsInvoices View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobsinvoices;
CREATE VIEW {etani_client_id}_wfm_jobsinvoices AS
SELECT
    uuid,
    clientuuid,
    contactuuid,
    number,
    clientordernumber,
    date,
    duedate,
    datepaid,
    status,
    amountextax,
    amountinctax,
    amountpaid,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobsinvoices;

-- JobsPurchOrd View
DROP VIEW IF EXISTS {etani_client_id}_wfm_jobspurchord;
CREATE VIEW {etani_client_id}_wfm_jobspurchord AS
SELECT
    uuid,
    supplieruuid,
    date,
    status,
    receivingstatus,
    billingstatus,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    jobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_jobspurchord;

-- TimesheetsCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_timesheetscustomfields;
CREATE VIEW {etani_client_id}_wfm_timesheetscustomfields AS
SELECT
    uuid,
    name,
    value,
    timesheetsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_timesheetscustomfields;

-- ClientsContacts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientscontacts;
CREATE VIEW {etani_client_id}_wfm_clientscontacts AS
SELECT
    uuid,
    salutation,
    firstname,
    lastname,
    position,
    `primary`,
    includeinemails,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientscontacts;

-- ClientsBillCustRates View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientsbillcustrates;
CREATE VIEW {etani_client_id}_wfm_clientsbillcustrates AS
SELECT
    taskuuid,
    billablerate,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientsbillcustrates;

-- ClientsCliGrps View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientscligrps;
CREATE VIEW {etani_client_id}_wfm_clientscligrps AS
SELECT
    uuid,
    name,
    taxable,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientscligrps;

-- ClientsClientRel View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientsclientrel;
CREATE VIEW {etani_client_id}_wfm_clientsclientrel AS
SELECT
    uuid,
    relatedclientuuid,
    type,
    startdate,
    enddate,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientsclientrel;

-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ClientsNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientsnotes;
CREATE VIEW {etani_client_id}_wfm_clientsnotes AS
SELECT
    uuid,
    title,
    phase,
    description,
    date,
    createdbyfirstname,
    createdbylastname,
    createdat,
    updatedat,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientsnotes;

-- ClientsDocuments View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientsdocuments;
CREATE VIEW {etani_client_id}_wfm_clientsdocuments AS
SELECT
    uuid,
    title,
    filename,
    filesize,
    note,
    phase,
    downloadurl,
    uploadedbyfirstname,
    uploadedbylastname,
    createdat,
    updatedat,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientsdocuments;

-- ClientsCustFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_clientscustfields;
CREATE VIEW {etani_client_id}_wfm_clientscustfields AS
SELECT
    uuid,
    name,
    value,
    clientsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_clientscustfields;

-- QuotesPhases View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotesphases;
CREATE VIEW {etani_client_id}_wfm_quotesphases AS
SELECT
    uuid,
    jobphaseuuid,
    name,
    description,
    `order`,
    createdat,
    updatedat,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotesphases;

-- QuotesNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotesnotes;
CREATE VIEW {etani_client_id}_wfm_quotesnotes AS
SELECT
    uuid,
    title,
    phase,
    description,
    date,
    createdbyuuid,
    createdat,
    updatedat,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotesnotes;

-- QuotesDocuments View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotesdocuments;
CREATE VIEW {etani_client_id}_wfm_quotesdocuments AS
SELECT
    uuid,
    title,
    filename,
    filesize,
    note,
    phase,
    downloadurl,
    uploadedbyuuid,
    createdat,
    updatedat,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotesdocuments;

-- QuotesTasks View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotestasks;
CREATE VIEW {etani_client_id}_wfm_quotestasks AS
SELECT
    uuid,
    taskuuid,
    jobtaskuuid,
    quotephaseuuid,
    name,
    label,
    description,
    billable,
    optional,
    accepted,
    time,
    staffrates,
    baserate,
    billablerate,
    fixedprice,
    costamount,
    amount,
    tax,
    `order`,
    createdat,
    updatedat,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotestasks;

-- QuotesTasksStaff View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotestasksstaff;
CREATE VIEW {etani_client_id}_wfm_quotestasksstaff AS
SELECT
    uuid,
    time,
    baserate,
    billablerate,
    quotesid,
    quotestasksid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotestasksstaff;

-- QuotesCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotescosts;
CREATE VIEW {etani_client_id}_wfm_quotescosts AS
SELECT
    uuid,
    costuuid,
    jobcostuuid,
    quotephaseuuid,
    name,
    description,
    costcode,
    costnote,
    type,
    quantity,
    unitprice,
    unitcost,
    billable,
    optional,
    accepted,
    fixedprice,
    amount,
    tax,
    `order`,
    createdat,
    updatedat,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotescosts;

-- QuotesCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_quotescustomfields;
CREATE VIEW {etani_client_id}_wfm_quotescustomfields AS
SELECT
    uuid,
    name,
    value,
    quotesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_quotescustomfields;

-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InvoicesJobs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesjobs;
CREATE VIEW {etani_client_id}_wfm_invoicesjobs AS
SELECT
    uuid,
    number,
    name,
    description,
    clientordernumber,
    taskinvoicemode,
    invoicesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesjobs;

-- InvoicesJobsPhases View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesjobsphases;
CREATE VIEW {etani_client_id}_wfm_invoicesjobsphases AS
SELECT
    uuid,
    jobphaseuuid,
    name,
    description,
    `order`,
    invoicesid,
    invoicesjobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesjobsphases;

-- InvoicesJobsTasks View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesjobstasks;
CREATE VIEW {etani_client_id}_wfm_invoicesjobstasks AS
SELECT
    uuid,
    taskuuid,
    jobtaskuuid,
    invoicephaseuuid,
    name,
    label,
    description,
    billable,
    additional,
    billablerate,
    time,
    fixedprice,
    amount,
    tax,
    `order`,
    createdat,
    updatedat,
    invoicesid,
    invoicesjobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesjobstasks;

-- InvoicesJobsTasksTimebreakdown View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesjobstaskstimebreakdown;
CREATE VIEW {etani_client_id}_wfm_invoicesjobstaskstimebreakdown AS
SELECT
    jobtimesheetuuid,
    invoicetimesheetuuid,
    date,
    staffuuid,
    stafffirstname,
    stafflastname,
    invoicebillable,
    billablerate,
    time,
    createdat,
    updatedat,
    invoicesid,
    invoicesjobsid,
    invoicesjobstasksid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesjobstaskstimebreakdown;

-- InvoicesJobsCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesjobscosts;
CREATE VIEW {etani_client_id}_wfm_invoicesjobscosts AS
SELECT
    uuid,
    jobcostuuid,
    costuuid,
    invoicephaseuuid,
    name,
    description,
    costcode,
    costnote,
    type,
    quantity,
    unitcost,
    unitprice,
    billable,
    fixedprice,
    amount,
    tax,
    additional,
    `order`,
    createdat,
    updatedat,
    invoicesid,
    invoicesjobsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesjobscosts;

-- InvoicesNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicesnotes;
CREATE VIEW {etani_client_id}_wfm_invoicesnotes AS
SELECT
    uuid,
    title,
    phase,
    description,
    date,
    createdbyuuid,
    createdat,
    updatedat,
    invoicesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicesnotes;

-- InvoicesPayments View
DROP VIEW IF EXISTS {etani_client_id}_wfm_invoicespayments;
CREATE VIEW {etani_client_id}_wfm_invoicespayments AS
SELECT
    date,
    amount,
    reference,
    accountuuid,
    accountname,
    updatedat,
    invoicesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_invoicespayments;

-- PurchaseOrdersJobs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseordersjobs;
CREATE VIEW {etani_client_id}_wfm_purchaseordersjobs AS
SELECT
    jobuuid,
    jobnumber,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseordersjobs;

-- PurchaseOrdersCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseorderscosts;
CREATE VIEW {etani_client_id}_wfm_purchaseorderscosts AS
SELECT
    uuid,
    jobuuid,
    jobcostuuid,
    costuuid,
    type,
    description,
    code,
    notes,
    quantity,
    unitcost,
    tax,
    createdat,
    updatedat,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseorderscosts;

-- PurchaseOrdersStockRec View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseordersstockrec;
CREATE VIEW {etani_client_id}_wfm_purchaseordersstockrec AS
SELECT
    uuid,
    receiptdate,
    stockreceiptnote,
    stockreceiptid,
    supplierbillnumber,
    billdate,
    tax,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseordersstockrec;

-- Pattern: {etani_client_id}_wfm_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrdersBills View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseordersbills;
CREATE VIEW {etani_client_id}_wfm_purchaseordersbills AS
SELECT
    uuid,
    date,
    supplierbillnumber,
    duedate,
    tax,
    stockreceiptid,
    receiptdate,
    amountextax,
    amountinctax,
    createdat,
    updatedat,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseordersbills;

-- PurchaseOrdersNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseordersnotes;
CREATE VIEW {etani_client_id}_wfm_purchaseordersnotes AS
SELECT
    uuid,
    title,
    phase,
    description,
    date,
    createdbyuuid,
    createdat,
    updatedat,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseordersnotes;

-- PurchaseOrdersDocs View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseordersdocs;
CREATE VIEW {etani_client_id}_wfm_purchaseordersdocs AS
SELECT
    uuid,
    title,
    filename,
    filesize,
    note,
    purchaseorderphase,
    downloadurl,
    uploadedbyuuid,
    createdat,
    updatedat,
    purchaseordersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseordersdocs;

-- PurchaseOrderBillsCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_purchaseorderbillscosts;
CREATE VIEW {etani_client_id}_wfm_purchaseorderbillscosts AS
SELECT
    uuid,
    purchaseordercostuuid,
    name,
    additional,
    quantity,
    unitcost,
    tax,
    createdat,
    updatedat,
    purchaseorderbillsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_purchaseorderbillscosts;

-- StockReceiptsCosts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_stockreceiptscosts;
CREATE VIEW {etani_client_id}_wfm_stockreceiptscosts AS
SELECT
    uuid,
    purchaseordercostuuid,
    name,
    additional,
    quantity,
    unitcost,
    tax,
    createdat,
    updatedat,
    stockreceiptsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_stockreceiptscosts;

-- SuppliersContacts View
DROP VIEW IF EXISTS {etani_client_id}_wfm_supplierscontacts;
CREATE VIEW {etani_client_id}_wfm_supplierscontacts AS
SELECT
    uuid,
    firstname,
    lastname,
    position,
    email,
    phone,
    mobile,
    createdat,
    updatedat,
    suppliersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_supplierscontacts;

-- SuppliersNotes View
DROP VIEW IF EXISTS {etani_client_id}_wfm_suppliersnotes;
CREATE VIEW {etani_client_id}_wfm_suppliersnotes AS
SELECT
    uuid,
    title,
    phase,
    note,
    createdbyuuid,
    createdat,
    updatedat,
    suppliersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_suppliersnotes;

-- SuppliersDocuments View
DROP VIEW IF EXISTS {etani_client_id}_wfm_suppliersdocuments;
CREATE VIEW {etani_client_id}_wfm_suppliersdocuments AS
SELECT
    uuid,
    title,
    filename,
    filesize,
    note,
    phase,
    downloadurl,
    uploadedby,
    createdat,
    updatedat,
    suppliersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_suppliersdocuments;

-- SuppliersCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_wfm_supplierscustomfields;
CREATE VIEW {etani_client_id}_wfm_supplierscustomfields AS
SELECT
    uuid,
    name,
    value,
    suppliersid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_wfm_supplierscustomfields;