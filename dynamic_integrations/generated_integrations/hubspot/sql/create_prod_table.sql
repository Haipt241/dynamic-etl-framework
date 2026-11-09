-- HUBSPOT Production Tables - Auto Generated
-- Pattern: c{clientID}_hubspot_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Companies Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companies;
CREATE TABLE c{clientID}_hubspot_companies (
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

-- Deals Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_deals;
CREATE TABLE c{clientID}_hubspot_deals (
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

-- Contacts Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_contacts;
CREATE TABLE c{clientID}_hubspot_contacts (
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

-- FeedbackSubmissions Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_feedbacksubmissions;
CREATE TABLE c{clientID}_hubspot_feedbacksubmissions (
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

-- LineItems Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_lineitems;
CREATE TABLE c{clientID}_hubspot_lineitems (
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

-- Products Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_products;
CREATE TABLE c{clientID}_hubspot_products (
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

-- Quotes Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_quotes;
CREATE TABLE c{clientID}_hubspot_quotes (
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

-- Discounts Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_discounts;
CREATE TABLE c{clientID}_hubspot_discounts (
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

-- Fees Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_fees;
CREATE TABLE c{clientID}_hubspot_fees (
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

-- Tickets Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_tickets;
CREATE TABLE c{clientID}_hubspot_tickets (
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


-- Pattern: c{clientID}_hubspot_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- GoalTargets Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_goaltargets;
CREATE TABLE c{clientID}_hubspot_goaltargets (
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

-- Taxes Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_taxes;
CREATE TABLE c{clientID}_hubspot_taxes (
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

-- Calls Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_calls;
CREATE TABLE c{clientID}_hubspot_calls (
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

-- Emails Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_emails;
CREATE TABLE c{clientID}_hubspot_emails (
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

-- Meetings Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_meetings;
CREATE TABLE c{clientID}_hubspot_meetings (
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

-- Notes Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_notes;
CREATE TABLE c{clientID}_hubspot_notes (
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

-- Tasks Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_tasks;
CREATE TABLE c{clientID}_hubspot_tasks (
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

-- Owners Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_owners;
CREATE TABLE c{clientID}_hubspot_owners (
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

-- CompanyContactsAssoc Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companycontactsassoc;
CREATE TABLE c{clientID}_hubspot_companycontactsassoc (
    companyid VARCHAR(255) NOT NULL,
    contactid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, contactid)
);

-- ParentChildCompanyAssoc Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_parentchildcompanyassoc;
CREATE TABLE c{clientID}_hubspot_parentchildcompanyassoc (
    companyid VARCHAR(255) NOT NULL,
    childid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, childid)
);

-- Pattern: c{clientID}_hubspot_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CompanyCallsAssoc Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companycallsassoc;
CREATE TABLE c{clientID}_hubspot_companycallsassoc (
    companyid VARCHAR(255) NOT NULL,
    callid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, callid)
);

-- CompanyEmailsAssoc Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companyemailsassoc;
CREATE TABLE c{clientID}_hubspot_companyemailsassoc (
    companyid VARCHAR(255) NOT NULL,
    emailid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, emailid)
);

-- CompanyMeetingsAssoc Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companymeetingsassoc;
CREATE TABLE c{clientID}_hubspot_companymeetingsassoc (
    companyid VARCHAR(255) NOT NULL,
    meetingid VARCHAR(255) NOT NULL,
    clientid VARCHAR(100) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (companyid, meetingid)
);

-- CompaniesProperties Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_companiesproperties;
CREATE TABLE c{clientID}_hubspot_companiesproperties (
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

-- DealProperties Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_dealproperties;
CREATE TABLE c{clientID}_hubspot_dealproperties (
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

-- TicketsProperties Production Table
DROP TABLE IF EXISTS c{clientID}_hubspot_ticketsproperties;
CREATE TABLE c{clientID}_hubspot_ticketsproperties (
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

-- HUBSPOT LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_hubspot_lastrefreshdate;
CREATE TABLE c{clientID}_hubspot_lastrefreshdate (
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
