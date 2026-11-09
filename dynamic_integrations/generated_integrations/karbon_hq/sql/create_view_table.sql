-- KARBON_HQ Views - Auto Generated
-- Pattern: {etani_client_id}_karbon_hq_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Invoices View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_invoices;
CREATE VIEW {etani_client_id}_karbon_hq_invoices AS
SELECT
    invoicekey,
    invoicenumber,
    totalamountdue,
    invoicetotal,
    invoicesubtotal,
    invoicetaxtotal,
    invoicedate,
    paymentduedate,
    updatedat,
    currencycode,
    paymentinstructions,
    invoicestatus,
    clientid,
    organisationid,
    clientclientkey AS `client.clientkey`,
    clientclienttype AS `client.clienttype`,
    clientname AS `client.name`,
    clientaddressline AS `client.addressline`,
    clientcity AS `client.city`,
    clientstateprovincecounty AS `client.stateprovincecounty`,
    clientzipcode AS `client.zipcode`,
    clientcountry AS `client.country`,
    clientemailaddress AS `client.emailaddress`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_invoices;

-- Payments View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_payments;
CREATE VIEW {etani_client_id}_karbon_hq_payments AS
SELECT
    paymentkey,
    paymentreference,
    paymenttype,
    paymentdate,
    grossamount,
    paymentmethod,
    clientkey,
    clientid,
    organisationid,
    karbonpaymentcardtype AS `karbonpayment.cardtype`,
    karbonpaymentcardcountry AS `karbonpayment.cardcountry`,
    karbonpaymentcardfunding AS `karbonpayment.cardfunding`,
    karbonpaymentpayoutstatus AS `karbonpayment.payoutstatus`,
    karbonpaymentsurchargeamount AS `karbonpayment.surchargeamount`,
    karbonpaymentsurchargetaxamount AS `karbonpayment.surchargetaxamount`,
    karbonpaymentkarbonfeeamount AS `karbonpayment.karbonfeeamount`,
    karbonpaymentkarbonfeetaxamount AS `karbonpayment.karbonfeetaxamount`,
    karbonpaymentnetamount AS `karbonpayment.netamount`,
    clientclientkey AS `client.clientkey`,
    clientclienttype AS `client.clienttype`,
    clientname AS `client.name`,
    clientaddressline AS `client.addressline`,
    clientcity AS `client.city`,
    clientstateprovincecounty AS `client.stateprovincecounty`,
    clientzipcode AS `client.zipcode`,
    clientcountry AS `client.country`,
    clientemailaddress AS `client.emailaddress`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_payments;

-- ClientGroups View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_clientgroups;
CREATE VIEW {etani_client_id}_karbon_hq_clientgroups AS
SELECT
    clientgroupkey,
    fullname,
    phonenumber,
    website,
    lastmodifieddatetime,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_clientgroups;

-- ClientGroupsDetails View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_clientgroupsdetails;
CREATE VIEW {etani_client_id}_karbon_hq_clientgroupsdetails AS
SELECT
    clientgroupkey,
    fullname,
    clientowner,
    clientmanager,
    contacttype,
    userdefinedidentifier,
    restrictionlevel,
    primarycontact,
    entitydescription,
    members,
    accountingdetails,
    lastmodifieddatetime,
    clientid,
    organisationid,
    businesscard_isprimarycard AS `businesscard.isprimarycard`,
    businesscard_organizationkey AS `businesscard.organizationkey`,
    businesscard_roleortitle AS `businesscard.roleortitle`,
    businesscard_facebooklink AS `businesscard.facebooklink`,
    businesscard_linkedinlink AS `businesscard.linkedinlink`,
    businesscard_twitterlink AS `businesscard.twitterlink`,
    businesscard_skypelink AS `businesscard.skypelink`,
    businesscard_websites AS `businesscard.websites`,
    businesscard_emailaddresses AS `businesscard.emailaddresses`,
    businesscard_addresses AS `businesscard.addresses`,
    businesscard_phonenumbers AS `businesscard.phonenumbers`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_clientgroupsdetails;

-- Contacts View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contacts;
CREATE VIEW {etani_client_id}_karbon_hq_contacts AS
SELECT
    contactkey,
    fullname,
    preferredname,
    salutation,
    clientowner,
    clientmanager,
    address,
    emailaddress,
    phonenumber,
    roleortitle,
    userdefinedidentifier,
    lastmodifieddatetime,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contacts;

-- ContactsDetails View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsdetails;
CREATE VIEW {etani_client_id}_karbon_hq_contactsdetails AS
SELECT
    contactkey,
    firstname,
    middlename,
    lastname,
    preferredname,
    salutation,
    suffix,
    clientowner,
    clientmanager,
    contacttype,
    userdefinedidentifier,
    restrictionlevel,
    avatarurl,
    lastmodifieddatetime,
    clientid,
    organisationid,
    entitydescriptiontext AS `entitydescription.text`,
    accountingdetailcontactpermakey AS `accountingdetail.contactpermakey`,
    accountingdetailorganizationpermakey AS `accountingdetail.organizationpermakey`,
    accountingdetailbirthdate AS `accountingdetail.birthdate`,
    accountingdetaildeathdate AS `accountingdetail.deathdate`,
    accountingdetailsalutation AS `accountingdetail.salutation`,
    accountingdetailsex AS `accountingdetail.sex`,
    accountingdetailfinancialyearendday AS `accountingdetail.financialyearendday`,
    accountingdetailfinancialyearendmonth AS `accountingdetail.financialyearendmonth`,
    accountingdetailincorporationdate AS `accountingdetail.incorporationdate`,
    accountingdetailincorporationstate AS `accountingdetail.incorporationstate`,
    accountingdetaillegalname AS `accountingdetail.legalname`,
    accountingdetaillineofbusiness AS `accountingdetail.lineofbusiness`,
    accountingdetailentitytype AS `accountingdetail.entitytype`,
    accountingdetailtaxcountrycode AS `accountingdetail.taxcountrycode`,
    accountingdetailtradingname AS `accountingdetail.tradingname`,
    accountingdetailannualrevenue AS `accountingdetail.annualrevenue`,
    accountingdetailbasecurrency AS `accountingdetail.basecurrency`,
    accountingdetailgstbasis AS `accountingdetail.gstbasis`,
    accountingdetailgstperiod AS `accountingdetail.gstperiod`,
    accountingdetailincometaxinstallmentperiod AS `accountingdetail.incometaxinstallmentperiod`,
    accountingdetailisvatregistered AS `accountingdetail.isvatregistered`,
    accountingdetailorganizationvaluation AS `accountingdetail.organizationvaluation`,
    accountingdetailpaystax AS `accountingdetail.paystax`,
    accountingdetailpreparegst AS `accountingdetail.preparegst`,
    accountingdetailprovisionaltaxbasic AS `accountingdetail.provisionaltaxbasic`,
    accountingdetailprovisionaltaxratio AS `accountingdetail.provisionaltaxratio`,
    accountingdetailrevenuemodel AS `accountingdetail.revenuemodel`,
    accountingdetailsalestaxbasis AS `accountingdetail.salestaxbasis`,
    accountingdetailsalestaxperiod AS `accountingdetail.salestaxperiod`,
    accountingdetailsells AS `accountingdetail.sells`,
    accountingdetaildatesignedengagement AS `accountingdetail.datesignedengagement`,
    accountingdetailbank AS `accountingdetail.bank`,
    accountingdetailpayroll AS `accountingdetail.payroll`,
    accountingdetailbillpay AS `accountingdetail.billpay`,
    accountingdetailbenefits AS `accountingdetail.benefits`,
    accountingdetailrevenue AS `accountingdetail.revenue`,
    accountingdetailexpenses AS `accountingdetail.expenses`,
    accountingdetailfilemanagement AS `accountingdetail.filemanagement`,
    accountingdetailaccounting AS `accountingdetail.accounting`,
    accountingdetailregistrationnumbers AS `accountingdetail.registrationnumbers`,
    accountingdetaillegalfirm AS `accountingdetail.legalfirm`,
    accountingdetaillegalfirmname AS `accountingdetail_legalfirm.name`,
    accountingdetaillegalfirmorganizationkey AS `accountingdetail_legalfirm.organizationkey`,
    accountingdetailtaxprovider AS `accountingdetail.taxprovider`,
    accountingdetailtaxprovidername AS `accountingdetail_taxprovider.name`,
    accountingdetailtaxproviderorganizationkey AS `accountingdetail_taxprovider.organizationkey`,
    accountingdetailnotes AS `accountingdetail.notes`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsdetails;

-- Organizations View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_organizations;
CREATE VIEW {etani_client_id}_karbon_hq_organizations AS
SELECT
    organizationkey,
    fullname,
    phonenumber,
    website,
    lastmodifieddatetime,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_organizations;

-- Timesheets View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_timesheets;
CREATE VIEW {etani_client_id}_karbon_hq_timesheets AS
SELECT
    timesheetkey,
    startdate,
    enddate,
    userkey,
    status,
    workitemkeys,
    timeentries,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_timesheets;

-- TimesheetsTimeEntries View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_timesheetstimeentries;
CREATE VIEW {etani_client_id}_karbon_hq_timesheetstimeentries AS
SELECT
    timeentrykey,
    timesheetkey AS `timesheetskey`,
    startdate,
    enddate,
    userkey,
    status,
    entitykey,
    workitemkey,
    clientkey,
    clienttype,
    minutes,
    hourlyrate,
    rolename,
    tasktypename,
    descriptions,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_timesheetstimeentries;

-- Users View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_users;
CREATE VIEW {etani_client_id}_karbon_hq_users AS
SELECT
    id,
    name,
    emailaddress,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_users;


-- Pattern: {etani_client_id}_karbon_hq_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WorkItems View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_workitems;
CREATE VIEW {etani_client_id}_karbon_hq_workitems AS
SELECT
    workitemkey,
    title,
    assigneeemailaddress,
    assigneekey,
    assigneename,
    clientkey,
    clientname,
    clienttype,
    relatedclientgroupkey,
    clientgroupkey,
    relatedclientgroupname,
    startdate,
    duedate,
    completeddate,
    todoperiod,
    worktype,
    workstatus,
    primarystatus,
    secondarystatus,
    worktemplatekey,
    worktemplatetile,
    workschedulekey,
    estimatedbudget,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_workitems;

-- WorkTemplates View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_worktemplates;
CREATE VIEW {etani_client_id}_karbon_hq_worktemplates AS
SELECT
    worktemplatekey,
    title,
    estimatedbudget,
    description,
    worktypekey,
    hasscheduledclienttaskgroups,
    estimatedtime,
    drafthaschanges,
    publisheddate,
    numberofworkitemscreated,
    datelastworkitemcreated,
    datemodified,
    actorroles,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_worktemplates;

-- WorkSchedules View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_workschedules;
CREATE VIEW {etani_client_id}_karbon_hq_workschedules AS
SELECT
    workschedulekey,
    clientkey,
    clienttype,
    createdfromworkitemkey,
    recurrencefrequency,
    customfrequencyunits,
    customfrequencymultiple,
    frequencydescription,
    schedulestartdate,
    scheduleenddate,
    scheduleduedatemethod,
    scheduleduedatedays,
    scheduleduedatemonthmultiple,
    assigneeuserkey,
    workitemdescription,
    preventstartendonweekend,
    initializebeforestartdateunits,
    initializebeforestartdatemultiple,
    workitemtitledefinition,
    workitemtitledisplaytext,
    initializetasksbeforestartdateunits,
    initializetasksbeforestartdatemultiple,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_workschedules;

-- EstimateSummaries View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_estimatesummaries;
CREATE VIEW {etani_client_id}_karbon_hq_estimatesummaries AS
SELECT
    estimatesummarykey,
    workitemkey,
    userkey,
    rolekey,
    rolename,
    tasktypekey,
    tasktypename,
    estimateminutes,
    actualminutes,
    hourlyrate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_estimatesummaries;

-- invoicesTaxItems View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_invoicestaxitems;
CREATE VIEW {etani_client_id}_karbon_hq_invoicestaxitems AS
SELECT
    taxname,
    taxvalue,
    invoicesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_invoicestaxitems;

-- contactsAccRegNum View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsaccregnum;
CREATE VIEW {etani_client_id}_karbon_hq_contactsaccregnum AS
SELECT
    registrationnumber,
    type,
    contactsdetailsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsaccregnum;

-- contactsAccNotes View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsaccnotes;
CREATE VIEW {etani_client_id}_karbon_hq_contactsaccnotes AS
SELECT
    body,
    type,
    contactsdetailsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsaccnotes;

-- contactsBizCards View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsbizcards;
CREATE VIEW {etani_client_id}_karbon_hq_contactsbizcards AS
SELECT
    isprimarycard,
    organizationkey,
    websites,
    emailaddresses,
    roleortitle,
    facebooklink,
    linkedinlink,
    twitterlink,
    skypelink,
    contactsdetailsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsbizcards;

-- contactsBizAddr View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsbizaddr;
CREATE VIEW {etani_client_id}_karbon_hq_contactsbizaddr AS
SELECT
    addresslines,
    city,
    stateprovincecounty,
    zipcode,
    countrycode,
    label,
    contactsdetailsbusinesscardsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsbizaddr;

-- contactsDetBizPhn View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsdetbizphn;
CREATE VIEW {etani_client_id}_karbon_hq_contactsdetbizphn AS
SELECT
    number,
    countrycode,
    label,
    contactsdetailsbusinesscardsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsdetbizphn;

-- Pattern: {etani_client_id}_karbon_hq_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- contactsDetTeam View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_contactsdetteam;
CREATE VIEW {etani_client_id}_karbon_hq_contactsdetteam AS
SELECT
    memberkey,
    membertype,
    roletype,
    contactsdetailsid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_contactsdetteam;

-- ClientGroupsMembers View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_clientgroupsmembers;
CREATE VIEW {etani_client_id}_karbon_hq_clientgroupsmembers AS
SELECT
    contactkey,
    organizationkey,
    clientgroupkey,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_clientgroupsmembers;

-- WorkTemplatesActorRoles View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_worktemplatesactorroles;
CREATE VIEW {etani_client_id}_karbon_hq_worktemplatesactorroles AS
SELECT
    actorkey,
    actorname,
    worktemplatekey AS `worktemplateskey`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_worktemplatesactorroles;

-- TimesheetWorkItems View
DROP VIEW IF EXISTS {etani_client_id}_karbon_hq_timesheetworkitems;
CREATE VIEW {etani_client_id}_karbon_hq_timesheetworkitems AS
SELECT
    workitemkey,
    timesheetkey AS `timesheetskey`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_karbon_hq_timesheetworkitems;