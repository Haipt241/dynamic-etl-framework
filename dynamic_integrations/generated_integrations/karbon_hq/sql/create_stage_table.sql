-- KARBON_HQ Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_karbon_hq_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Invoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_invoicesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_invoicesstage (
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

-- Payments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_paymentsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_paymentsstage (
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

-- ClientGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_clientgroupsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_clientgroupsstage (
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

-- ClientGroupsDetails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_clientgroupsdetailsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_clientgroupsdetailsstage (
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

-- Contacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsstage (
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

-- ContactsDetails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsdetailsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsdetailsstage (
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

-- Organizations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_organizationsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_organizationsstage (
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

-- Timesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_timesheetsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_timesheetsstage (
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

-- TimesheetsTimeEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_timesheetstimeentriesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_timesheetstimeentriesstage (
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

-- Users Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_usersstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_usersstage (
    id VARCHAR(100),
    name VARCHAR(100),
    emailaddress VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Pattern: c{clientID}_{orgID}_karbon_hq_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- WorkItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_workitemsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_workitemsstage (
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

-- WorkTemplates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_worktemplatesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_worktemplatesstage (
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

-- WorkSchedules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_workschedulesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_workschedulesstage (
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

-- EstimateSummaries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_estimatesummariesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_estimatesummariesstage (
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

-- invoicesTaxItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_invoicestaxitemsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_invoicestaxitemsstage (
    taxname VARCHAR(255),
    taxvalue DECIMAL(10,2),
    invoicesid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- contactsAccRegNum Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsaccregnumstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsaccregnumstage (
    registrationnumber VARCHAR(255),
    type VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- contactsAccNotes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsaccnotesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsaccnotesstage (
    body VARCHAR(255),
    type VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- contactsBizCards Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsbizcardsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsbizcardsstage (
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

-- contactsBizAddr Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsbizaddrstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsbizaddrstage (
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

-- contactsDetBizPhn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsdetbizphnstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsdetbizphnstage (
    number VARCHAR(255),
    countrycode VARCHAR(255),
    label VARCHAR(255),
    contactsdetailsbusinesscardsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_{orgID}_karbon_hq_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- contactsDetTeam Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_contactsdetteamstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_contactsdetteamstage (
    memberkey VARCHAR(255),
    membertype VARCHAR(255),
    roletype VARCHAR(255),
    contactsdetailsid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ClientGroupsMembers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_clientgroupsmembersstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_clientgroupsmembersstage (
    contactkey VARCHAR(100),
    organizationkey VARCHAR(100),
    clientgroupkey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- WorkTemplatesActorRoles Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_worktemplatesactorrolesstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_worktemplatesactorrolesstage (
    actorkey VARCHAR(100),
    actorname VARCHAR(100),
    worktemplatekey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TimesheetWorkItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_karbon_hq_timesheetworkitemsstage;
CREATE TABLE c{clientID}_{orgID}_karbon_hq_timesheetworkitemsstage (
    workitemkey VARCHAR(100),
    timesheetkey VARCHAR(100),
    clientid VARCHAR(100),
    organisationid INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (workitemkey, timesheetkey)
);