-- TIDYWORK Views - Auto Generated
-- Pattern: {etani_client_id}_tidywork_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Activities View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_activities;
CREATE VIEW {etani_client_id}_tidywork_activities AS
SELECT
    activityid,
    departmentids,
    code,
    name,
    description,
    isoverhead,
    ispayable,
    isactive,
    clientid,
    organisationid,
    synctoken,
    metadata_createtime,
    metadata_lastupdatedtime,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_activities;

-- ActivityDepartments View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_activitydepartments;
CREATE VIEW {etani_client_id}_tidywork_activitydepartments AS
SELECT
    activityid,
    departmentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_activitydepartments;

-- ChargeRates View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_chargerates;
CREATE VIEW {etani_client_id}_tidywork_chargerates AS
SELECT
    chargerateid,
    code,
    name,
    currencyid,
    currencyisocode,
    currentamount,
    currentquotecostamount,
    clientid,
    organisationid,
    synctoken,
    metadata_createtime,
    metadata_lastupdatedtime,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_chargerates;

-- Customers View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_customers;
CREATE VIEW {etani_client_id}_tidywork_customers AS
SELECT
    customerid,
    code,
    name,
    description,
    currencyid,
    currencyisocode,
    countryid,
    countryisocode,
    taxtypeid,
    taxtypecode,
    notes,
    invoiceduebasis,
    invoiceduenumber,
    isactive,
    postaladdress1,
    postaladdress2,
    postalsuburb,
    postalcity,
    postalstate,
    postalpostcode,
    customerportalenabled,
    customerportallink,
    customerportaluserid,
    materiallocationid,
    materialpricinglevelid,
    projectpricinglevelid,
    physicaladdresses,
    contacts,
    clientid,
    organisationid,
    synctoken,
    metadata_createtime,
    metadata_lastupdatedtime,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_customers;

-- CustomerAddresses View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_customeraddresses;
CREATE VIEW {etani_client_id}_tidywork_customeraddresses AS
SELECT
    customerid,
    customeraddressid,
    isprimary,
    address1,
    address2,
    suburb,
    city,
    state,
    postcode,
    roworder,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_customeraddresses;

-- CustomerContacts View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_customercontacts;
CREATE VIEW {etani_client_id}_tidywork_customercontacts AS
SELECT
    customerid,
    customercontactid,
    isprimary,
    firstname,
    lastname,
    email,
    phone,
    mobile,
    fax,
    address1,
    address2,
    suburb,
    city,
    state,
    postcode,
    countryid,
    countryisocode,
    postaladdress1,
    postaladdress2,
    postalsuburb,
    postalcity,
    postalstate,
    postalpostcode,
    postalcountryid,
    postalcountryisocode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_customercontacts;

-- ExpenseActuals View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_expenseactuals;
CREATE VIEW {etani_client_id}_tidywork_expenseactuals AS
SELECT
    expenseid,
    dateutc,
    date,
    customerid,
    customercode,
    customername,
    projectid,
    projectcode,
    projectname,
    departmentcode,
    departmentname,
    userid,
    username,
    useremail,
    expensecategorycode,
    expensecategoryname,
    expensetypecode,
    expensetypename,
    notes,
    amount,
    currencyid,
    currencyisocode,
    billing,
    state,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_expenseactuals;

-- ExpenseCategories View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_expensecategories;
CREATE VIEW {etani_client_id}_tidywork_expensecategories AS
SELECT
    expensecategoryid,
    code,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_expensecategories;

-- Expenses View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_expenses;
CREATE VIEW {etani_client_id}_tidywork_expenses AS
SELECT
    expenseid,
    projectid,
    userid,
    expensedate,
    expensedateutc,
    notes,
    state,
    expensetypeid,
    currencyid,
    amount,
    description,
    expensetypecode,
    expensetypename,
    isbillable,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_expenses;

-- ExpenseTypes View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_expensetypes;
CREATE VIEW {etani_client_id}_tidywork_expensetypes AS
SELECT
    expensetypeid,
    code,
    name,
    isactive,
    expensecategoryid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_expensetypes;


-- Pattern: {etani_client_id}_tidywork_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- MaterialActuals View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_materialactuals;
CREATE VIEW {etani_client_id}_tidywork_materialactuals AS
SELECT
    materialid,
    dateutc,
    date,
    customerid,
    customercode,
    customername,
    projectid,
    projectcode,
    projectname,
    departmentcode,
    departmentname,
    userid,
    username,
    useremail,
    materialitemid,
    materialitemcode,
    materialitemname,
    materialcategoryid,
    materialcategorycode,
    materialcategoryname,
    materiallocationid,
    materiallocationcode,
    materiallocationname,
    unitcost,
    unitcostcurrencyid,
    unitcostcurrencyisocode,
    unitprice,
    unitpricecurrencyid,
    unitpricecurrencyisocode,
    unit,
    quantity,
    totalcost,
    totalprice,
    billing,
    state,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_materialactuals;

-- MaterialCategories View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_materialcategories;
CREATE VIEW {etani_client_id}_tidywork_materialcategories AS
SELECT
    materialcategoryid,
    code,
    name,
    description,
    defaultstockreorderlevel,
    taxtypeid,
    isdefault,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_materialcategories;

-- MaterialItems View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_materialitems;
CREATE VIEW {etani_client_id}_tidywork_materialitems AS
SELECT
    materialitemid,
    materialcategoryid,
    materialcategorycode,
    materialcategoryname,
    materiallocationid,
    materiallocationcode,
    materiallocationname,
    code,
    name,
    description,
    isactive,
    costcurrencyid,
    costcurrencyisocode,
    chargecurrencyid,
    chargecurrencyisocode,
    cost,
    charge,
    pricebycustlevelqty,
    pricingunitid,
    pricingunitabbrev,
    usageunitid,
    usageunitabbrev,
    stocklevel,
    stockreorderlevel,
    ismanaged,
    sku,
    barcode,
    netcost,
    reference,
    materialitemtype,
    supplierid,
    taxtypeid,
    allowedincustomerportal,
    pricing,
    locationstocklevels,
    images,
    updatedutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_materialitems;

-- ItemPricing View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_itempricing;
CREATE VIEW {etani_client_id}_tidywork_itempricing AS
SELECT
    materialitemid,
    pricingid,
    pricelevel,
    quantity,
    price,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_itempricing;

-- ItemLocationStock View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_itemlocationstock;
CREATE VIEW {etani_client_id}_tidywork_itemlocationstock AS
SELECT
    materialitemid,
    locationstockid,
    locationid,
    locationcode,
    stocklevel,
    reorderlevel,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_itemlocationstock;

-- ItemImages View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_itemimages;
CREATE VIEW {etani_client_id}_tidywork_itemimages AS
SELECT
    materialitemid,
    imageid,
    filename,
    fileurl,
    filesize,
    mimetype,
    isprimary,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_itemimages;

-- MaterialLocation View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_materiallocation;
CREATE VIEW {etani_client_id}_tidywork_materiallocation AS
SELECT
    materiallocationid,
    code,
    name,
    description,
    isdefault,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_materiallocation;

-- MaterialPricingLevel View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_materialpricinglevel;
CREATE VIEW {etani_client_id}_tidywork_materialpricinglevel AS
SELECT
    materialpricinglevelid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_materialpricinglevel;

-- Material View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_material;
CREATE VIEW {etani_client_id}_tidywork_material AS
SELECT
    materialid,
    projectid,
    projectcode,
    projectname,
    userid,
    supplierid,
    notes,
    purchaseorderid,
    purchaseorderno,
    purchaseordernote,
    purchaseorderlineid,
    state,
    isestimate,
    isorderrequired,
    materialdateutc,
    materialdate,
    materialitemcode,
    materiallocationid,
    pricingmultiplier,
    pricingunitid,
    usageunitid,
    roworder,
    materialitemid,
    materialitemname,
    costcurrencyid,
    chargecurrencyid,
    quantity,
    usagequantity,
    cost,
    charge,
    length,
    width,
    height,
    isbillable,
    taskid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_material;

-- Organization View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_organization;
CREATE VIEW {etani_client_id}_tidywork_organization AS
SELECT
    name,
    domains,
    features,
    generalsettings,
    accountingsettings,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_organization;

-- Pattern: {etani_client_id}_tidywork_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- OrgDomains View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_orgdomains;
CREATE VIEW {etani_client_id}_tidywork_orgdomains AS
SELECT
    domain,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_orgdomains;

-- OrgFeatures View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_orgfeatures;
CREATE VIEW {etani_client_id}_tidywork_orgfeatures AS
SELECT
    feature,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_orgfeatures;

-- ProjectGroups View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectgroups;
CREATE VIEW {etani_client_id}_tidywork_projectgroups AS
SELECT
    projectgroupid,
    code,
    name,
    description,
    isactive,
    isdefault,
    extacctrackingid1,
    extacctrackingid2,
    brandingthemeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectgroups;

-- Projects View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projects;
CREATE VIEW {etani_client_id}_tidywork_projects AS
SELECT
    projectid,
    parentquoteid,
    projectgroupid,
    projectgroupcode,
    projectgroupname,
    code,
    name,
    description,
    status,
    customerid,
    customercontactid,
    templateid,
    currencyid,
    taxrateid,
    manageruserid,
    customerref,
    specialinstructions,
    startdate,
    startdateutc,
    enddate,
    enddateutc,
    fixedpriceamount,
    isoverhead,
    priority,
    pricetype,
    invoicenote,
    url,
    allowedincustomerportal,
    usercompleteddateutc,
    usercompleteddate,
    updatedtimeutc,
    tasks,
    color,
    materials,
    expenses,
    milestones,
    roles,
    materialsundertasksrequired,
    materiallocationid,
    updateoptions,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projects;

-- ProjectTasks View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projecttasks;
CREATE VIEW {etani_client_id}_tidywork_projecttasks AS
SELECT
    projectid,
    taskid,
    parentid,
    level,
    name,
    description,
    status,
    startdateutc,
    enddateutc,
    startedtimeutc,
    completedtimeutc,
    estimatedminutes,
    isleaftask,
    isbillable,
    isonhold,
    fixedprice,
    displayorder,
    assignments,
    materials,
    children,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projecttasks;

-- ProjectTaskAssignments View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projecttaskassignments;
CREATE VIEW {etani_client_id}_tidywork_projecttaskassignments AS
SELECT
    taskid,
    taskassignmentid,
    userid,
    chargerateid,
    chargeperhour,
    chargecurrencyid,
    estimatedminutes,
    selfestimatedminutes,
    actualminutes,
    iscomplete,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projecttaskassignments;

-- ProjectMaterials View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectmaterials;
CREATE VIEW {etani_client_id}_tidywork_projectmaterials AS
SELECT
    projectid,
    materialid,
    materialitemid,
    quantity,
    unitcost,
    totalcost,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectmaterials;

-- ProjectExpenses View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectexpenses;
CREATE VIEW {etani_client_id}_tidywork_projectexpenses AS
SELECT
    projectid,
    expenseid,
    description,
    amount,
    currencyid,
    expensedate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectexpenses;

-- ProjectMilestones View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectmilestones;
CREATE VIEW {etani_client_id}_tidywork_projectmilestones AS
SELECT
    projectid,
    milestoneid,
    name,
    description,
    duedate,
    iscompleted,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectmilestones;

-- ProjectRoles View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectroles;
CREATE VIEW {etani_client_id}_tidywork_projectroles AS
SELECT
    projectid,
    userid,
    username,
    ispeermanager,
    isapprover,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectroles;

-- Pattern: {etani_client_id}_tidywork_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ProjectSummary View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_projectsummary;
CREATE VIEW {etani_client_id}_tidywork_projectsummary AS
SELECT
    projectid,
    code,
    name,
    description,
    projectgroup,
    startdateutc,
    startdate,
    enddateutc,
    enddate,
    completeddateutc,
    lastmodifiedutc,
    manager,
    customer,
    customerref,
    pricetype,
    status,
    plannedtime,
    actualtime,
    incompletetaskseffort,
    plannedtimecost,
    plannedmaterialscost,
    plannedexpensescost,
    plannedtimerevenue,
    plannedmaterialsrevenue,
    plannedexpensesrevenue,
    plannedmilestonerevenue,
    plannedfixedpricerevenue,
    plannedfixedpricetaskrevenue,
    timecost,
    materialscost,
    expensescost,
    invoiced,
    invoicable,
    invoicedetailsstring,
    adjustments,
    totalactualcost,
    totalactualrevenue,
    totalactualprofit,
    totalplannedcost,
    totalplannedrevenue,
    totalplannedprofit,
    actualtimerevenue,
    actualmaterialsrevenue,
    actualexpensesrevenue,
    actualmilestonerevenue,
    actualfixedpricerevenue,
    actualfixedpricetaskrevenue,
    url,
    specialinstructions,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_projectsummary;

-- PurchaseOrder View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_purchaseorder;
CREATE VIEW {etani_client_id}_tidywork_purchaseorder AS
SELECT
    purchaseorderid,
    orderno,
    supplierid,
    projectid,
    datesinutc,
    earliestraiseddate,
    latestraiseddate,
    purchaseorderstatuses,
    receivedstatuses,
    invoicedstatuses,
    simplesearch,
    earliestexpecteddeliverydate,
    latestexpecteddeliverydate,
    `order`,
    page,
    pagesize,
    includelines,
    includefreightitems,
    includedescendants,
    includeancestors,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_purchaseorder;

-- Quote View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quote;
CREATE VIEW {etani_client_id}_tidywork_quote AS
SELECT
    quoteid,
    projectgroupid,
    projectgroupcode,
    projectgroupname,
    code,
    name,
    description,
    specialinstructions,
    customerid,
    customerref,
    customercontactid,
    templateid,
    startdateutc,
    startdate,
    enddateutc,
    enddate,
    expirydateutc,
    expirydate,
    salespersonuserid,
    materialsundertasksrequired,
    pricetype,
    currencyid,
    fixedpriceamount,
    markuppercentage,
    taxrateid,
    status,
    color,
    tasks,
    materials,
    expenses,
    milestones,
    roles,
    updateoptions,
    label,
    materiallocationid,
    updatedtimeutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quote;

-- QuoteTasks View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quotetasks;
CREATE VIEW {etani_client_id}_tidywork_quotetasks AS
SELECT
    quoteid,
    taskid,
    parentid,
    level,
    name,
    description,
    estimatedminutes,
    isbillable,
    fixedprice,
    displayorder,
    assignments,
    materials,
    children,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quotetasks;

-- QuoteTaskAssignments View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quotetaskassignments;
CREATE VIEW {etani_client_id}_tidywork_quotetaskassignments AS
SELECT
    taskid,
    taskassignmentid,
    userid,
    chargerateid,
    chargeperhour,
    estimatedminutes,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quotetaskassignments;

-- QuoteMaterials View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quotematerials;
CREATE VIEW {etani_client_id}_tidywork_quotematerials AS
SELECT
    quoteid,
    materialid,
    materialitemid,
    quantity,
    unitcost,
    totalcost,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quotematerials;

-- QuoteExpenses View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quoteexpenses;
CREATE VIEW {etani_client_id}_tidywork_quoteexpenses AS
SELECT
    quoteid,
    expenseid,
    description,
    amount,
    currencyid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quoteexpenses;

-- QuoteMilestones View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quotemilestones;
CREATE VIEW {etani_client_id}_tidywork_quotemilestones AS
SELECT
    quoteid,
    milestoneid,
    name,
    description,
    duedate,
    iscompleted,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quotemilestones;

-- QuoteRoles View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_quoteroles;
CREATE VIEW {etani_client_id}_tidywork_quoteroles AS
SELECT
    quoteid,
    userid,
    username,
    ispeermanager,
    isapprover,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_quoteroles;

-- Sales View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_sales;
CREATE VIEW {etani_client_id}_tidywork_sales AS
SELECT
    saleid,
    customerid,
    saleno,
    earliesteffectivedate,
    latesteffectivedate,
    datesinutc,
    includestatusonhold,
    includestatusdraft,
    includestatusinvoiced,
    includestatusvoid,
    page,
    pagesize,
    materialitemid,
    materialcategoryid,
    materiallocationid,
    iscredit,
    includeimages,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_sales;

-- Pattern: {etani_client_id}_tidywork_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Tasks View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_tasks;
CREATE VIEW {etani_client_id}_tidywork_tasks AS
SELECT
    taskid,
    projectid,
    startdateutc,
    startdate,
    enddateutc,
    enddate,
    startedtimeutc,
    startedtime,
    completedtimeutc,
    completedtime,
    status,
    assignments,
    materials,
    parentid,
    displayorder,
    name,
    description,
    estimatedminutes,
    isleaftask,
    isbillable,
    isonhold,
    fixedprice,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_tasks;

-- TaskAssignments View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_taskassignments;
CREATE VIEW {etani_client_id}_tidywork_taskassignments AS
SELECT
    taskid,
    taskassignmentid,
    userid,
    selfestimatedminutes,
    actualminutes,
    estimatedminutes,
    chargerateid,
    chargeperhour,
    chargecurrencyid,
    iscomplete,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_taskassignments;

-- Templates View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_templates;
CREATE VIEW {etani_client_id}_tidywork_templates AS
SELECT
    templateid,
    templatetype,
    name,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_templates;

-- TimeActuals View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_timeactuals;
CREATE VIEW {etani_client_id}_tidywork_timeactuals AS
SELECT
    timeid,
    starttimeutc,
    starttime,
    customerid,
    customercode,
    customername,
    projectid,
    projectcode,
    projectname,
    projectgroup,
    taskid,
    taskname,
    activityid,
    activitycode,
    activityname,
    departmentcode,
    departmentname,
    userid,
    username,
    useremail,
    totalminutes,
    billableminutes,
    billing,
    state,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_timeactuals;

-- TimePlan View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_timeplan;
CREATE VIEW {etani_client_id}_tidywork_timeplan AS
SELECT
    customerid,
    customercode,
    customername,
    projectid,
    projectcode,
    projectname,
    taskid,
    taskname,
    parenttaskid,
    parenttaskname,
    grandparenttaskid,
    grandparenttaskname,
    taskstartdateutc,
    taskstartdate,
    taskenddateutc,
    taskenddate,
    departmentcode,
    departmentname,
    userid,
    username,
    useremail,
    totalminutes,
    selfminutes,
    billing,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_timeplan;

-- Times View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_times;
CREATE VIEW {etani_client_id}_tidywork_times AS
SELECT
    timeid,
    projectid,
    projectcode,
    projectname,
    taskid,
    taskname,
    taskcompletionindicated,
    activityid,
    activitycode,
    activityname,
    userid,
    username,
    notes,
    starttime,
    starttimeutc,
    minutes,
    state,
    timeprofileid,
    timeprofilename,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_times;

-- Users View
DROP VIEW IF EXISTS {etani_client_id}_tidywork_users;
CREATE VIEW {etani_client_id}_tidywork_users AS
SELECT
    userid,
    customerid,
    firstname,
    lastname,
    displayname,
    departmentname,
    departmentid,
    contactemail,
    isactive,
    isselfassignmentpermitted,
    istimewriter,
    ismaterialwriter,
    timezoneid,
    timezonename,
    ishelper,
    isnonhuman,
    issystemadministrator,
    isresourceadministrator,
    isprojectmanager,
    isquoteestimator,
    ispurchaser,
    issalesperson,
    isinvoicer,
    isreporter,
    canprojectmanagerchangeprojectstate,
    canprojectmanagerseeprojectprofit,
    canprojectmanagereditprojecttemplates,
    cansalespersonseepricing,
    cansalespersonseedashboard,
    ismaterialapprover,
    isexpenseapprover,
    istimeapprover,
    defaultchargerateid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_tidywork_users;