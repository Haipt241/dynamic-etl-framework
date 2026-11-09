-- DEPUTY Production Tables - Auto Generated
-- Pattern: c{clientID}_deputy_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Address Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_address;
CREATE TABLE c{clientID}_deputy_address (
    id INT NOT NULL,
    contactname VARCHAR(255),
    unitno VARCHAR(100),
    streetno VARCHAR(100),
    suiteno VARCHAR(100),
    pobox VARCHAR(100),
    street1 VARCHAR(500),
    street2 VARCHAR(500),
    city VARCHAR(255),
    state VARCHAR(255),
    postcode VARCHAR(20),
    countryid INT,
    phone VARCHAR(50),
    saved BOOLEAN,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    notes TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Category Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_category;
CREATE TABLE c{clientID}_deputy_category (
    id INT NOT NULL,
    category VARCHAR(255) NOT NULL,
    `group` VARCHAR(255),
    sortorder INT NOT NULL,
    stafflog BOOLEAN NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Comment Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_comment;
CREATE TABLE c{clientID}_deputy_comment (
    id INT NOT NULL,
    orm VARCHAR(255),
    recid INT,
    infeed BOOLEAN,
    comment TEXT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CompanyPeriod Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_companyperiod;
CREATE TABLE c{clientID}_deputy_companyperiod (
    id INT NOT NULL,
    datestart DATETIME,
    start INT NOT NULL,
    `end` INT NOT NULL,
    dateend DATETIME,
    companyid INT NOT NULL,
    payperiodid INT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contact Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_contact;
CREATE TABLE c{clientID}_deputy_contact (
    id INT NOT NULL,
    phone1 VARCHAR(50),
    phone2 VARCHAR(50),
    phone3 VARCHAR(50),
    phone1type VARCHAR(50),
    phone2type VARCHAR(50),
    phone3type VARCHAR(50),
    primaryphone INT,
    email1 VARCHAR(255),
    email2 VARCHAR(255),
    primaryemail INT,
    email1type VARCHAR(50),
    email2type VARCHAR(50),
    im1 VARCHAR(255),
    im2 VARCHAR(255),
    im1type VARCHAR(50),
    im2type VARCHAR(50),
    web VARCHAR(500),
    notes TEXT,
    saved BOOLEAN,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Country Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_country;
CREATE TABLE c{clientID}_deputy_country (
    id INT NOT NULL,
    code VARCHAR(100) NOT NULL,
    codea3 VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    active BOOLEAN NOT NULL,
    sortorder INT,
    countryname VARCHAR(255) NOT NULL,
    zipvalidatepreg VARCHAR(500),
    phonedisplaypreg VARCHAR(500),
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomAppData Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_customappdata;
CREATE TABLE c{clientID}_deputy_customappdata (
    documentid VARCHAR(255) NOT NULL,
    `data` TEXT NOT NULL,
    keyint INT,
    keystring VARCHAR(255),
    label VARCHAR(255),
    operationalunitid INT,
    employeeid INT,
    permission VARCHAR(255),
    deleted BOOLEAN,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (documentid)
);

-- CustomField Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_customfield;
CREATE TABLE c{clientID}_deputy_customfield (
    id INT NOT NULL,
    `system` VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    apiname VARCHAR(64) NOT NULL,
    type INT NOT NULL,
    deputyfield VARCHAR(10),
    valuelist TEXT,
    published BOOLEAN,
    validation VARCHAR(255),
    conditionalrules BOOLEAN,
    displaytiming INT,
    action INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CustomFieldData Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_customfielddata;
CREATE TABLE c{clientID}_deputy_customfielddata (
    `system` VARCHAR(255) NOT NULL,
    f01 TEXT,
    f02 TEXT,
    f03 TEXT,
    f04 TEXT,
    f05 TEXT,
    f06 TEXT,
    f07 TEXT,
    f08 TEXT,
    f09 TEXT,
    f10 TEXT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`system`)
);

-- Company Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_company;
CREATE TABLE c{clientID}_deputy_company (
    id INT NOT NULL,
    code VARCHAR(255) NOT NULL,
    active BOOLEAN,
    parentcompanyid INT,
    companyname VARCHAR(500) NOT NULL,
    companynumber VARCHAR(255),
    tradingname VARCHAR(500),
    isworkplace BOOLEAN NOT NULL,
    ispayrollentity BOOLEAN NOT NULL,
    payrollexportcode VARCHAR(255),
    addressid INT,
    contactid INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_deputy_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employee Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employee;
CREATE TABLE c{clientID}_deputy_employee (
    id INT NOT NULL,
    companyid INT NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    displayname VARCHAR(255) NOT NULL,
    othername VARCHAR(255),
    saluation VARCHAR(50),
    active BOOLEAN NOT NULL,
    roleid INT NOT NULL,
    dateofbirth DATE,
    gender INT,
    pronouns INT,
    custompronouns VARCHAR(100),
    startdate DATE,
    terminationdate DATE,
    allowappraisal BOOLEAN,
    mainaddressid INT,
    postaladdressid INT,
    emergencyaddressid INT,
    contactid INT,
    photoid INT,
    userid INT,
    stressprofileid INT,
    trainingrecordsid INT,
    historyid INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRules Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_payrules;
CREATE TABLE c{clientID}_deputy_payrules (
    id INT NOT NULL,
    remunerationtype INT NOT NULL,
    remunerationby INT NOT NULL,
    paytitle VARCHAR(255) NOT NULL,
    isexported BOOLEAN NOT NULL,
    annualsalary DECIMAL(19,4),
    hourlyrate DECIMAL(19,4),
    ismultiplier BOOLEAN,
    multipliervalue DECIMAL(19,4),
    multiplierbaserateid INT,
    unitvalue DECIMAL(19,4),
    minimumtype INT,
    maximumtype INT,
    minimumvalue DECIMAL(19,4),
    maximumvalue DECIMAL(19,4),
    minimumshiftlength DECIMAL(19,4),
    maximumshiftlength DECIMAL(19,4),
    schedule INT,
    recommendwith INT,
    dexmlscriptid INT,
    dexmlscriptparam VARCHAR(500),
    payportionrule INT,
    payrollcategory VARCHAR(255),
    ratetype INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- TimesheetPayReturn Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_timesheetpayreturn;
CREATE TABLE c{clientID}_deputy_timesheetpayreturn (
    id INT NOT NULL,
    timesheetid INT NOT NULL,
    payruleid INT,
    overridden BOOLEAN,
    value DECIMAL(19,4),
    cost DECIMAL(19,4),
    overridecomment TEXT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeAgreement Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeeagreement;
CREATE TABLE c{clientID}_deputy_employeeagreement (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    paypointid INT NOT NULL,
    emptype INT NOT NULL,
    companyname VARCHAR(500),
    active BOOLEAN,
    startdate DATETIME NOT NULL,
    contractid INT,
    salarypayruleid INT,
    payrollid VARCHAR(255),
    payperiodid INT,
    historyid INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeAgreementHistory Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeeagreementhistory;
CREATE TABLE c{clientID}_deputy_employeeagreementhistory (
    id INT NOT NULL,
    agreementid INT,
    paypointid INT NOT NULL,
    emptype INT NOT NULL,
    companyname VARCHAR(500),
    active BOOLEAN NOT NULL,
    startdate DATETIME NOT NULL,
    contractid INT,
    salarypayruleid INT,
    payrollid VARCHAR(255),
    payperiodid INT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeAppraisal Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeeappraisal;
CREATE TABLE c{clientID}_deputy_employeeappraisal (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    daytimestamp INT NOT NULL,
    date DATE NOT NULL,
    mark01 DECIMAL(19,4),
    mark02 DECIMAL(19,4),
    mark03 DECIMAL(19,4),
    mark04 DECIMAL(19,4),
    mark05 DECIMAL(19,4),
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeAvailability Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeeavailability;
CREATE TABLE c{clientID}_deputy_employeeavailability (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    type INT NOT NULL,
    maxdaterecurringgenerated DATE,
    starttime INT,
    endtime INT,
    date DATE,
    comment TEXT,
    scheduleid INT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeHistory Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeehistory;
CREATE TABLE c{clientID}_deputy_employeehistory (
    id INT NOT NULL,
    companyid INT NOT NULL,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    displayname VARCHAR(255) NOT NULL,
    othername VARCHAR(255),
    salutation VARCHAR(50),
    mainaddressid INT,
    postaladdressid INT,
    emergencyaddressid INT,
    dateofbirth DATE,
    gender INT,
    photoid INT,
    active BOOLEAN NOT NULL,
    startdate DATE,
    terminationdate DATE,
    position VARCHAR(255),
    roleid INT NOT NULL,
    employeeid INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeePaycycle Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeepaycycle;
CREATE TABLE c{clientID}_deputy_employeepaycycle (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    employeeagreementid INT NOT NULL,
    periodid INT NOT NULL,
    recommendedloadings BOOLEAN,
    timesheets INT,
    timesheetstimeapproved INT,
    timesheetspayapproved INT NOT NULL,
    paycyclerulesid INT,
    paycyclerulesapproved INT,
    exported BOOLEAN,
    exportid INT,
    paid BOOLEAN,
    timetotal DECIMAL(19,4),
    costtotal DECIMAL(19,4),
    employeeagreementhistoryid INT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeePayCycleReturn Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeepaycyclereturn;
CREATE TABLE c{clientID}_deputy_employeepaycyclereturn (
    id INT NOT NULL,
    paycycleid INT NOT NULL,
    payruleid INT NOT NULL,
    approved BOOLEAN NOT NULL,
    overridden BOOLEAN,
    value DECIMAL(19,4),
    cost DECIMAL(19,4),
    overridecomment TEXT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_deputy_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeeRole Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeerole;
CREATE TABLE c{clientID}_deputy_employeerole (
    id INT NOT NULL,
    role VARCHAR(255) NOT NULL,
    ranking INT NOT NULL,
    reporttoid INT,
    permissions VARCHAR(100),
    require2fa BOOLEAN,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeSalaryCost Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeesalarycost;
CREATE TABLE c{clientID}_deputy_employeesalarycost (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    employeeagreementid INT NOT NULL,
    daytimestamp INT NOT NULL,
    date DATE NOT NULL,
    opunitid INT NOT NULL,
    cost INT NOT NULL,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeWorkplace Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employeeworkplace;
CREATE TABLE c{clientID}_deputy_employeeworkplace (
    id INT NOT NULL,
    employeeid INT NOT NULL,
    companyid INT NOT NULL,
    sortorder INT NOT NULL,
    agreement1id INT,
    agreement2id INT,
    agreement3id INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmploymentCondition Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employmentcondition;
CREATE TABLE c{clientID}_deputy_employmentcondition (
    id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(100),
    workingdaysperperiod DECIMAL(19,4),
    usualstarttime VARCHAR(100),
    usualfinishtime VARCHAR(100),
    usualmealbreak VARCHAR(100),
    avghoursperday DECIMAL(19,4),
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmploymentContract Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_employmentcontract;
CREATE TABLE c{clientID}_deputy_employmentcontract (
    id INT NOT NULL,
    code VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    employmentbasis INT NOT NULL,
    employmentcategory INT NOT NULL,
    employmentstatus INT NOT NULL,
    employmentconditionid INT,
    basepayruleid INT NOT NULL,
    stressprofileid INT,
    startdate DATETIME,
    enddate DATETIME,
    periodtype INT NOT NULL,
    file VARCHAR(255),
    strictleaveapproval BOOLEAN,
    award VARCHAR(255),
    employmentsubtype VARCHAR(255),
    awardstartdate DATETIME,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ContractLeaveRules Production Table
DROP TABLE IF EXISTS c{clientID}_deputy_contractleaverules;
CREATE TABLE c{clientID}_deputy_contractleaverules (
    id INT NOT NULL,
    contractid INT NOT NULL,
    leaveruleid INT NOT NULL,
    basepayruleid INT,
    loadingpayrule1id INT,
    loadingpayrule2id INT,
    loadingpayrule3id INT,
    creatorid INT,
    created DATETIME,
    modified DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- DEPUTY LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_deputy_lastrefreshdate;
CREATE TABLE c{clientID}_deputy_lastrefreshdate (
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
