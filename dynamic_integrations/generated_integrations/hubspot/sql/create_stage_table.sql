-- HUBSPOT Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_hubspot_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Companies Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companiesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companiesstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    propertiescreatedate DATETIME,
    propertieshsobjectid VARCHAR(255),
    propertieshslastmodifieddate DATETIME,
    propertiesdomain VARCHAR(255),
    propertiesname VARCHAR(255),
    url VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Deals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_dealsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_dealsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    propertiescreatedate DATETIME,
    propertieshsobjectid VARCHAR(255),
    propertiesamount VARCHAR(255),
    propertiesclosedate DATETIME,
    propertiesdealname TEXT,
    propertiesdealstage VARCHAR(255),
    propertieshslastmodifieddate DATETIME,
    propertiespipeline VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_contactsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_contactsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    url VARCHAR(500),
    propertiescompany VARCHAR(255),
    propertiescreatedate DATETIME,
    propertieshsobjectid VARCHAR(255),
    propertieslastmodifieddate DATETIME,
    propertiesphone VARCHAR(255),
    propertieswebsite VARCHAR(255),
    propertiesemail VARCHAR(255),
    propertiesfirstname VARCHAR(255),
    propertieslastname VARCHAR(255),
    propertieshsallassignedbusinessunitids VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- FeedbackSubmissions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_feedbacksubmissionsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_feedbacksubmissionsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    objectwritetraceid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LineItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_lineitemsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_lineitemsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    objectwritetraceid VARCHAR(255),
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Products Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_productsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_productsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    propertiescreatedate DATETIME,
    propertieshsobjectid VARCHAR(255),
    propertiesprice VARCHAR(255),
    propertieshslastmodifieddate DATETIME,
    propertiesdescription TEXT,
    propertieshscostofgoodssold VARCHAR(255),
    propertieshsrecurringbillingperiod VARCHAR(255),
    propertieshssku VARCHAR(255),
    propertiesname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Quotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_quotesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_quotesstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    objectwritetraceid VARCHAR(255),
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Discounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_discountsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_discountsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    objectwritetraceid VARCHAR(255),
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Fees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_feesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_feesstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    objectwritetraceid VARCHAR(255),
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tickets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_ticketsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_ticketsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    propertiescreatedate DATETIME,
    propertieshsobjectid VARCHAR(255),
    propertieshslastmodifieddate DATETIME,
    propertieshubspotownerid VARCHAR(255),
    propertieshspipeline VARCHAR(255),
    propertieshspipelinestage VARCHAR(255),
    propertieshsticketpriority VARCHAR(255),
    propertiessubject TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_{orgID}_hubspot_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- GoalTargets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_goaltargetsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_goaltargetsstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    properties JSON,
    associations JSON,
    objectwritetraceid VARCHAR(255),
    propertieswithhistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Taxes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_taxesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_taxesstage (
    id VARCHAR(255) NOT NULL,
    archived BOOLEAN,
    createdat DATETIME,
    updatedat DATETIME,
    archivedat DATETIME,
    properties JSON,
    associations JSON,
    propertieswithhistory JSON,
    objectwritetraceid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Calls Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_callsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_callsstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    clientid VARCHAR(34) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Emails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_emailsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_emailsstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    clientid VARCHAR(34) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Meetings Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_meetingsstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_meetingsstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    clientid VARCHAR(34) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Notes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_notesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_notesstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    clientid VARCHAR(34) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_tasksstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_tasksstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    clientid VARCHAR(34) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Owners Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_ownersstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_ownersstage (
    id VARCHAR(255) NOT NULL,
    createdat DATETIME,
    updatedat DATETIME,
    archived BOOLEAN,
    email VARCHAR(100),
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    userid BIGINT,
    teams VARCHAR(100),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CompanyContactsAssoc Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companycontactsassocstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companycontactsassocstage (
    companyid VARCHAR(255) NOT NULL,
    contactid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, contactid)
);

-- ParentChildCompanyAssoc Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_parentchildcompanyassocstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_parentchildcompanyassocstage (
    companyid VARCHAR(255) NOT NULL,
    childid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, childid)
);

-- Pattern: c{clientID}_{orgID}_hubspot_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- CompanyCallsAssoc Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companycallsassocstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companycallsassocstage (
    companyid VARCHAR(255) NOT NULL,
    callid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, callid)
);

-- CompanyEmailsAssoc Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companyemailsassocstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companyemailsassocstage (
    companyid VARCHAR(255) NOT NULL,
    emailid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, emailid)
);

-- CompanyMeetingsAssoc Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companymeetingsassocstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companymeetingsassocstage (
    companyid VARCHAR(255) NOT NULL,
    meetingid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, meetingid)
);

-- CompaniesProperties Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_companiespropertiesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_companiespropertiesstage (
    name VARCHAR(1000),
    label VARCHAR(1000),
    description VARCHAR(1000),
    groupname VARCHAR(1000),
    type VARCHAR(1000),
    fieldtype VARCHAR(1000),
    calculated VARCHAR(100),
    externaloptions VARCHAR(100),
    showcurrencysymbol VARCHAR(100),
    hubspotdefined VARCHAR(100),
    hasuniquevalue VARCHAR(100),
    hidden VARCHAR(100),
    displayorder INT,
    formfield VARCHAR(100),
    readonlyvalue VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- DealProperties Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_dealpropertiesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_dealpropertiesstage (
    name VARCHAR(1000),
    label VARCHAR(1000),
    description VARCHAR(1000),
    groupname VARCHAR(1000),
    type VARCHAR(1000),
    fieldtype VARCHAR(1000),
    calculated VARCHAR(100),
    externaloptions VARCHAR(100),
    showcurrencysymbol VARCHAR(100),
    hubspotdefined VARCHAR(100),
    hasuniquevalue VARCHAR(100),
    hidden VARCHAR(100),
    displayorder INT,
    formfield VARCHAR(100),
    readonlyvalue VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- TicketsProperties Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_hubspot_ticketspropertiesstage;
CREATE TABLE c{clientID}_{orgID}_hubspot_ticketspropertiesstage (
    name VARCHAR(1000),
    label VARCHAR(1000),
    description VARCHAR(1000),
    groupname VARCHAR(1000),
    type VARCHAR(1000),
    fieldtype VARCHAR(1000),
    calculated VARCHAR(100),
    externaloptions VARCHAR(100),
    showcurrencysymbol VARCHAR(100),
    hubspotdefined VARCHAR(100),
    hasuniquevalue VARCHAR(100),
    hidden VARCHAR(100),
    displayorder INT,
    formfield VARCHAR(100),
    readonlyvalue VARCHAR(100),
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);