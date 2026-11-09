-- KARBON_HQ Production Tables - Auto Generated
-- Pattern: c{clientID}_karbon_hq_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Invoices Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_invoices;
CREATE TABLE c{clientID}_karbon_hq_invoices (
    invoicekey VARCHAR(255) NOT NULL,
    invoicenumber VARCHAR(255),
    totalamountdue DECIMAL(18,2),
    invoicetotal DECIMAL(18,2),
    invoicesubtotal DECIMAL(18,2),
    invoicetaxtotal DECIMAL(18,2),
    invoicedate DATETIME,
    paymentduedate DATETIME,
    updatedat DATETIME,
    currencycode VARCHAR(255),
    paymentinstructions TEXT,
    invoicestatus VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    clientclientkey VARCHAR(255),
    clientclienttype VARCHAR(255),
    clientname VARCHAR(255),
    clientaddressline VARCHAR(255),
    clientcity VARCHAR(255),
    clientstateprovincecounty VARCHAR(255),
    clientzipcode VARCHAR(255),
    clientcountry VARCHAR(255),
    clientemailaddress VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (invoicekey)
);

-- Payments Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_payments;
CREATE TABLE c{clientID}_karbon_hq_payments (
    paymentkey VARCHAR(255) NOT NULL,
    paymentreference VARCHAR(255),
    paymenttype VARCHAR(255),
    paymentdate DATE,
    grossamount DECIMAL(18,2),
    paymentmethod VARCHAR(255),
    clientkey VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    karbonpaymentcardtype VARCHAR(255),
    karbonpaymentcardcountry VARCHAR(255),
    karbonpaymentcardfunding VARCHAR(255),
    karbonpaymentpayoutstatus VARCHAR(255),
    karbonpaymentsurchargeamount INT,
    karbonpaymentsurchargetaxamount INT,
    karbonpaymentkarbonfeeamount INT,
    karbonpaymentkarbonfeetaxamount INT,
    karbonpaymentnetamount INT,
    clientclientkey VARCHAR(255),
    clientclienttype VARCHAR(255),
    clientname VARCHAR(255),
    clientaddressline VARCHAR(255),
    clientcity VARCHAR(255),
    clientstateprovincecounty VARCHAR(255),
    clientzipcode VARCHAR(255),
    clientcountry VARCHAR(255),
    clientemailaddress VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (paymentkey)
);

-- ClientGroups Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_clientgroups;
CREATE TABLE c{clientID}_karbon_hq_clientgroups (
    clientgroupkey VARCHAR(100),
    fullname VARCHAR(100),
    phonenumber VARCHAR(100),
    website VARCHAR(100),
    lastmodifieddatetime DATETIME,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (clientgroupkey)
);

-- ClientGroupsDetails Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_clientgroupsdetails;
CREATE TABLE c{clientID}_karbon_hq_clientgroupsdetails (
    clientgroupkey VARCHAR(100),
    fullname VARCHAR(100),
    clientowner VARCHAR(100),
    clientmanager VARCHAR(100),
    contacttype VARCHAR(100),
    userdefinedidentifier VARCHAR(100),
    restrictionlevel VARCHAR(100),
    primarycontact VARCHAR(100),
    entitydescription VARCHAR(100),
    members JSON,
    accountingdetails VARCHAR(100),
    lastmodifieddatetime DATETIME,
    clientid VARCHAR(100),
    organisationid INT,
    businesscard_isprimarycard BOOLEAN,
    businesscard_organizationkey VARCHAR(100),
    businesscard_roleortitle VARCHAR(100),
    businesscard_facebooklink VARCHAR(100),
    businesscard_linkedinlink VARCHAR(100),
    businesscard_twitterlink VARCHAR(100),
    businesscard_skypelink VARCHAR(100),
    businesscard_websites JSON,
    businesscard_emailaddresses JSON,
    businesscard_addresses JSON,
    businesscard_phonenumbers JSON,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Contacts Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contacts;
CREATE TABLE c{clientID}_karbon_hq_contacts (
    contactkey VARCHAR(100),
    fullname VARCHAR(100),
    preferredname VARCHAR(100),
    salutation VARCHAR(100),
    clientowner VARCHAR(100),
    clientmanager VARCHAR(100),
    address VARCHAR(100),
    emailaddress VARCHAR(100),
    phonenumber VARCHAR(100),
    roleortitle VARCHAR(100),
    userdefinedidentifier VARCHAR(100),
    lastmodifieddatetime DATETIME,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contactkey)
);

-- ContactsDetails Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsdetails;
CREATE TABLE c{clientID}_karbon_hq_contactsdetails (
    contactkey VARCHAR(255) NOT NULL,
    firstname VARCHAR(255),
    middlename VARCHAR(255),
    lastname VARCHAR(255),
    preferredname VARCHAR(255),
    salutation VARCHAR(255),
    suffix VARCHAR(255),
    clientowner VARCHAR(255),
    clientmanager VARCHAR(255),
    contacttype VARCHAR(255),
    userdefinedidentifier VARCHAR(255),
    restrictionlevel VARCHAR(255),
    avatarurl TEXT,
    lastmodifieddatetime DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    entitydescriptiontext VARCHAR(255),
    accountingdetailcontactpermakey VARCHAR(255),
    accountingdetailorganizationpermakey VARCHAR(255),
    accountingdetailbirthdate VARCHAR(255),
    accountingdetaildeathdate VARCHAR(255),
    accountingdetailsalutation VARCHAR(255),
    accountingdetailsex VARCHAR(255),
    accountingdetailfinancialyearendday INT,
    accountingdetailfinancialyearendmonth INT,
    accountingdetailincorporationdate VARCHAR(255),
    accountingdetailincorporationstate VARCHAR(255),
    accountingdetaillegalname VARCHAR(255),
    accountingdetaillineofbusiness VARCHAR(255),
    accountingdetailentitytype VARCHAR(255),
    accountingdetailtaxcountrycode VARCHAR(255),
    accountingdetailtradingname VARCHAR(255),
    accountingdetailannualrevenue INT,
    accountingdetailbasecurrency VARCHAR(255),
    accountingdetailgstbasis VARCHAR(255),
    accountingdetailgstperiod VARCHAR(255),
    accountingdetailincometaxinstallmentperiod VARCHAR(255),
    accountingdetailisvatregistered BOOLEAN,
    accountingdetailorganizationvaluation INT,
    accountingdetailpaystax BOOLEAN,
    accountingdetailpreparegst BOOLEAN,
    accountingdetailprovisionaltaxbasic VARCHAR(255),
    accountingdetailprovisionaltaxratio VARCHAR(255),
    accountingdetailrevenuemodel VARCHAR(255),
    accountingdetailsalestaxbasis VARCHAR(255),
    accountingdetailsalestaxperiod VARCHAR(255),
    accountingdetailsells VARCHAR(255),
    accountingdetaildatesignedengagement VARCHAR(255),
    accountingdetailbank TEXT,
    accountingdetailpayroll TEXT,
    accountingdetailbillpay TEXT,
    accountingdetailbenefits TEXT,
    accountingdetailrevenue TEXT,
    accountingdetailexpenses TEXT,
    accountingdetailfilemanagement TEXT,
    accountingdetailaccounting TEXT,
    accountingdetailregistrationnumbers TEXT,
    accountingdetaillegalfirm TEXT,
    accountingdetaillegalfirmname VARCHAR(255),
    accountingdetaillegalfirmorganizationkey VARCHAR(255),
    accountingdetailtaxprovider TEXT,
    accountingdetailtaxprovidername VARCHAR(255),
    accountingdetailtaxproviderorganizationkey VARCHAR(255),
    accountingdetailnotes TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (contactkey)
);

-- Organizations Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_organizations;
CREATE TABLE c{clientID}_karbon_hq_organizations (
    organizationkey VARCHAR(100),
    fullname VARCHAR(100),
    phonenumber VARCHAR(100),
    website VARCHAR(100),
    lastmodifieddatetime DATETIME,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Timesheets Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_timesheets;
CREATE TABLE c{clientID}_karbon_hq_timesheets (
    timesheetkey VARCHAR(100),
    startdate DATETIME,
    enddate DATETIME,
    userkey VARCHAR(100),
    status VARCHAR(100),
    workitemkeys JSON,
    timeentries VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TimesheetsTimeEntries Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_timesheetstimeentries;
CREATE TABLE c{clientID}_karbon_hq_timesheetstimeentries (
    timeentrykey VARCHAR(100),
    timesheetkey VARCHAR(100),
    startdate DATETIME,
    enddate DATETIME,
    userkey VARCHAR(100),
    status VARCHAR(100),
    entitykey VARCHAR(100),
    workitemkey VARCHAR(100),
    clientkey VARCHAR(100),
    clienttype VARCHAR(100),
    minutes FLOAT,
    hourlyrate FLOAT,
    rolename VARCHAR(100),
    tasktypename VARCHAR(100),
    descriptions VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Users Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_users;
CREATE TABLE c{clientID}_karbon_hq_users (
    id VARCHAR(100),
    name VARCHAR(100),
    emailaddress VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Pattern: c{clientID}_karbon_hq_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WorkItems Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_workitems;
CREATE TABLE c{clientID}_karbon_hq_workitems (
    workitemkey VARCHAR(100),
    title VARCHAR(100),
    assigneeemailaddress VARCHAR(100),
    assigneekey VARCHAR(100),
    assigneename VARCHAR(100),
    clientkey VARCHAR(100),
    clientname VARCHAR(100),
    clienttype VARCHAR(100),
    relatedclientgroupkey VARCHAR(100),
    clientgroupkey VARCHAR(100),
    relatedclientgroupname VARCHAR(100),
    startdate DATETIME,
    duedate DATETIME,
    completeddate DATETIME,
    todoperiod DATETIME,
    worktype VARCHAR(100),
    workstatus VARCHAR(100),
    primarystatus VARCHAR(100),
    secondarystatus VARCHAR(100),
    worktemplatekey VARCHAR(100),
    worktemplatetile VARCHAR(100),
    workschedulekey VARCHAR(100),
    estimatedbudget VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- WorkTemplates Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_worktemplates;
CREATE TABLE c{clientID}_karbon_hq_worktemplates (
    worktemplatekey VARCHAR(100),
    title VARCHAR(100),
    estimatedbudget VARCHAR(100),
    description VARCHAR(100),
    worktypekey VARCHAR(100),
    hasscheduledclienttaskgroups VARCHAR(100),
    estimatedtime VARCHAR(100),
    drafthaschanges VARCHAR(100),
    publisheddate DATETIME,
    numberofworkitemscreated BIGINT,
    datelastworkitemcreated DATETIME,
    datemodified DATETIME,
    actorroles JSON,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- WorkSchedules Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_workschedules;
CREATE TABLE c{clientID}_karbon_hq_workschedules (
    workschedulekey VARCHAR(100),
    clientkey VARCHAR(100),
    clienttype VARCHAR(100),
    createdfromworkitemkey VARCHAR(100),
    recurrencefrequency VARCHAR(100),
    customfrequencyunits VARCHAR(100),
    customfrequencymultiple VARCHAR(100),
    frequencydescription VARCHAR(100),
    schedulestartdate DATETIME,
    scheduleenddate DATETIME,
    scheduleduedatemethod VARCHAR(100),
    scheduleduedatedays BIGINT,
    scheduleduedatemonthmultiple VARCHAR(100),
    assigneeuserkey VARCHAR(100),
    workitemdescription VARCHAR(100),
    preventstartendonweekend VARCHAR(100),
    initializebeforestartdateunits VARCHAR(100),
    initializebeforestartdatemultiple VARCHAR(100),
    workitemtitledefinition VARCHAR(100),
    workitemtitledisplaytext VARCHAR(100),
    initializetasksbeforestartdateunits VARCHAR(100),
    initializetasksbeforestartdatemultiple BIGINT,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EstimateSummaries Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_estimatesummaries;
CREATE TABLE c{clientID}_karbon_hq_estimatesummaries (
    estimatesummarykey VARCHAR(100),
    workitemkey VARCHAR(100),
    userkey VARCHAR(100),
    rolekey VARCHAR(100),
    rolename VARCHAR(100),
    tasktypekey VARCHAR(100),
    tasktypename VARCHAR(100),
    estimateminutes VARCHAR(100),
    actualminutes BIGINT,
    hourlyrate FLOAT,
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- invoicesTaxItems Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_invoicestaxitems;
CREATE TABLE c{clientID}_karbon_hq_invoicestaxitems (
    taxname VARCHAR(255),
    taxvalue DECIMAL(10,2),
    invoicesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- contactsAccRegNum Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsaccregnum;
CREATE TABLE c{clientID}_karbon_hq_contactsaccregnum (
    registrationnumber VARCHAR(255),
    type VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- contactsAccNotes Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsaccnotes;
CREATE TABLE c{clientID}_karbon_hq_contactsaccnotes (
    body VARCHAR(255),
    type VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- contactsBizCards Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsbizcards;
CREATE TABLE c{clientID}_karbon_hq_contactsbizcards (
    isprimarycard BOOLEAN,
    organizationkey VARCHAR(255),
    websites TEXT,
    emailaddresses TEXT,
    roleortitle VARCHAR(255),
    facebooklink VARCHAR(255),
    linkedinlink VARCHAR(255),
    twitterlink VARCHAR(255),
    skypelink VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- contactsBizAddr Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsbizaddr;
CREATE TABLE c{clientID}_karbon_hq_contactsbizaddr (
    addresslines VARCHAR(255),
    city VARCHAR(255),
    stateprovincecounty VARCHAR(255),
    zipcode VARCHAR(255),
    countrycode VARCHAR(255),
    label VARCHAR(255),
    contactsdetailsbusinesscardsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- contactsDetBizPhn Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsdetbizphn;
CREATE TABLE c{clientID}_karbon_hq_contactsdetbizphn (
    number VARCHAR(255),
    countrycode VARCHAR(255),
    label VARCHAR(255),
    contactsdetailsbusinesscardsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_karbon_hq_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- contactsDetTeam Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_contactsdetteam;
CREATE TABLE c{clientID}_karbon_hq_contactsdetteam (
    memberkey VARCHAR(255),
    membertype VARCHAR(255),
    roletype VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ClientGroupsMembers Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_clientgroupsmembers;
CREATE TABLE c{clientID}_karbon_hq_clientgroupsmembers (
    contactkey VARCHAR(100),
    organizationkey VARCHAR(100),
    clientgroupkey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- WorkTemplatesActorRoles Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_worktemplatesactorroles;
CREATE TABLE c{clientID}_karbon_hq_worktemplatesactorroles (
    actorkey VARCHAR(100),
    actorname VARCHAR(100),
    worktemplatekey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TimesheetWorkItems Production Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_timesheetworkitems;
CREATE TABLE c{clientID}_karbon_hq_timesheetworkitems (
    workitemkey VARCHAR(100),
    timesheetkey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (workitemkey, timesheetkey)
);

-- KARBON_HQ LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_karbon_hq_lastrefreshdate;
CREATE TABLE c{clientID}_karbon_hq_lastrefreshdate (
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
