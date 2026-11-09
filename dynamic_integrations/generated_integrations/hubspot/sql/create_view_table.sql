-- HUBSPOT Views - Auto Generated
-- Pattern: {etani_client_id}_hubspot_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companies;
CREATE VIEW {etani_client_id}_hubspot_companies AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    propertiescreatedate AS `properties.createdate`,
    propertieshsobjectid AS `properties.hs_object_id`,
    propertieshslastmodifieddate AS `properties.hs_lastmodifieddate`,
    propertiesdomain AS `properties.domain`,
    propertiesname AS `properties.name`,
    url,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companies;

-- Deals View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_deals;
CREATE VIEW {etani_client_id}_hubspot_deals AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    propertiescreatedate AS `properties.createdate`,
    propertieshsobjectid AS `properties.hs_object_id`,
    propertiesamount AS `properties.amount`,
    propertiesclosedate AS `properties.closedate`,
    propertiesdealname AS `properties.dealname`,
    propertiesdealstage AS `properties.dealstage`,
    propertieshslastmodifieddate AS `properties.hs_lastmodifieddate`,
    propertiespipeline AS `properties.pipeline`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_deals;

-- Contacts View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_contacts;
CREATE VIEW {etani_client_id}_hubspot_contacts AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    url,
    propertiescompany AS `properties.company`,
    propertiescreatedate AS `properties.createdate`,
    propertieshsobjectid AS `properties.hs_object_id`,
    propertieslastmodifieddate AS `properties.lastmodifieddate`,
    propertiesphone AS `properties.phone`,
    propertieswebsite AS `properties.website`,
    propertiesemail AS `properties.email`,
    propertiesfirstname AS `properties.firstname`,
    propertieslastname AS `properties.lastname`,
    propertieshsallassignedbusinessunitids AS `properties.hs_all_assigned_business_unit_ids`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_contacts;

-- FeedbackSubmissions View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_feedbacksubmissions;
CREATE VIEW {etani_client_id}_hubspot_feedbacksubmissions AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    properties,
    associations,
    propertieswithhistory,
    objectwritetraceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_feedbacksubmissions;

-- LineItems View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_lineitems;
CREATE VIEW {etani_client_id}_hubspot_lineitems AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    objectwritetraceid,
    properties,
    associations,
    propertieswithhistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_lineitems;

-- Products View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_products;
CREATE VIEW {etani_client_id}_hubspot_products AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    propertiescreatedate AS `properties.createdate`,
    propertieshsobjectid AS `properties.hs_object_id`,
    propertiesprice AS `properties.price`,
    propertieshslastmodifieddate AS `properties.hs_lastmodifieddate`,
    propertiesdescription AS `properties.description`,
    propertieshscostofgoodssold AS `properties.hs_cost_of_goods_sold`,
    propertieshsrecurringbillingperiod AS `properties.hs_recurring_billing_period`,
    propertieshssku AS `properties.hs_sku`,
    propertiesname AS `properties.name`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_products;

-- Quotes View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_quotes;
CREATE VIEW {etani_client_id}_hubspot_quotes AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    objectwritetraceid,
    properties,
    associations,
    propertieswithhistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_quotes;

-- Discounts View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_discounts;
CREATE VIEW {etani_client_id}_hubspot_discounts AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    objectwritetraceid,
    properties,
    associations,
    propertieswithhistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_discounts;

-- Fees View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_fees;
CREATE VIEW {etani_client_id}_hubspot_fees AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    objectwritetraceid,
    properties,
    associations,
    propertieswithhistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_fees;

-- Tickets View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_tickets;
CREATE VIEW {etani_client_id}_hubspot_tickets AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    propertiescreatedate AS `properties.createdate`,
    propertieshsobjectid AS `properties.hs_object_id`,
    propertieshslastmodifieddate AS `properties.hs_lastmodifieddate`,
    propertieshubspotownerid AS `properties.hubspot_owner_id`,
    propertieshspipeline AS `properties.hs_pipeline`,
    propertieshspipelinestage AS `properties.hs_pipeline_stage`,
    propertieshsticketpriority AS `properties.hs_ticket_priority`,
    propertiessubject AS `properties.subject`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_tickets;


-- Pattern: {etani_client_id}_hubspot_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- GoalTargets View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_goaltargets;
CREATE VIEW {etani_client_id}_hubspot_goaltargets AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    properties,
    associations,
    objectwritetraceid,
    propertieswithhistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_goaltargets;

-- Taxes View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_taxes;
CREATE VIEW {etani_client_id}_hubspot_taxes AS
SELECT
    id,
    archived,
    createdat,
    updatedat,
    archivedat,
    properties,
    associations,
    propertieswithhistory,
    objectwritetraceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_taxes;

-- Calls View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_calls;
CREATE VIEW {etani_client_id}_hubspot_calls AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_calls;

-- Emails View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_emails;
CREATE VIEW {etani_client_id}_hubspot_emails AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_emails;

-- Meetings View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_meetings;
CREATE VIEW {etani_client_id}_hubspot_meetings AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_meetings;

-- Notes View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_notes;
CREATE VIEW {etani_client_id}_hubspot_notes AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_notes;

-- Tasks View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_tasks;
CREATE VIEW {etani_client_id}_hubspot_tasks AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_tasks;

-- Owners View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_owners;
CREATE VIEW {etani_client_id}_hubspot_owners AS
SELECT
    id,
    createdat,
    updatedat,
    archived,
    email,
    firstname,
    lastname,
    userid,
    teams,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_owners;

-- CompanyContactsAssoc View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companycontactsassoc;
CREATE VIEW {etani_client_id}_hubspot_companycontactsassoc AS
SELECT
    companyid AS `companiesid`,
    contactid AS `id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companycontactsassoc;

-- ParentChildCompanyAssoc View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_parentchildcompanyassoc;
CREATE VIEW {etani_client_id}_hubspot_parentchildcompanyassoc AS
SELECT
    companyid AS `companiesid`,
    childid AS `id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_parentchildcompanyassoc;

-- Pattern: {etani_client_id}_hubspot_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CompanyCallsAssoc View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companycallsassoc;
CREATE VIEW {etani_client_id}_hubspot_companycallsassoc AS
SELECT
    companyid AS `companiesid`,
    callid AS `id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companycallsassoc;

-- CompanyEmailsAssoc View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companyemailsassoc;
CREATE VIEW {etani_client_id}_hubspot_companyemailsassoc AS
SELECT
    companyid AS `companiesid`,
    emailid AS `id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companyemailsassoc;

-- CompanyMeetingsAssoc View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companymeetingsassoc;
CREATE VIEW {etani_client_id}_hubspot_companymeetingsassoc AS
SELECT
    companyid AS `companiesid`,
    meetingid AS `id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companymeetingsassoc;

-- CompaniesProperties View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_companiesproperties;
CREATE VIEW {etani_client_id}_hubspot_companiesproperties AS
SELECT
    name,
    label,
    description,
    groupname,
    type,
    fieldtype,
    calculated,
    externaloptions,
    showcurrencysymbol,
    hubspotdefined,
    hasuniquevalue,
    hidden,
    displayorder,
    formfield,
    readonlyvalue,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_companiesproperties;

-- DealProperties View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_dealproperties;
CREATE VIEW {etani_client_id}_hubspot_dealproperties AS
SELECT
    name,
    label,
    description,
    groupname,
    type,
    fieldtype,
    calculated,
    externaloptions,
    showcurrencysymbol,
    hubspotdefined,
    hasuniquevalue,
    hidden,
    displayorder,
    formfield,
    readonlyvalue,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_dealproperties;

-- TicketsProperties View
DROP VIEW IF EXISTS {etani_client_id}_hubspot_ticketsproperties;
CREATE VIEW {etani_client_id}_hubspot_ticketsproperties AS
SELECT
    name,
    label,
    description,
    groupname,
    type,
    fieldtype,
    calculated,
    externaloptions,
    showcurrencysymbol,
    hubspotdefined,
    hasuniquevalue,
    hidden,
    displayorder,
    formfield,
    readonlyvalue,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_hubspot_ticketsproperties;