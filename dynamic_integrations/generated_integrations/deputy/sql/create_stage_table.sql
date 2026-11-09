-- DEPUTY Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_deputy_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Address Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_addressstage;
CREATE TABLE c{clientID}_{orgID}_deputy_addressstage (
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

-- Category Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_categorystage;
CREATE TABLE c{clientID}_{orgID}_deputy_categorystage (
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

-- Comment Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_commentstage;
CREATE TABLE c{clientID}_{orgID}_deputy_commentstage (
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

-- CompanyPeriod Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_companyperiodstage;
CREATE TABLE c{clientID}_{orgID}_deputy_companyperiodstage (
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

-- Contact Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_contactstage;
CREATE TABLE c{clientID}_{orgID}_deputy_contactstage (
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

-- Country Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_countrystage;
CREATE TABLE c{clientID}_{orgID}_deputy_countrystage (
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

-- CustomAppData Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_customappdatastage;
CREATE TABLE c{clientID}_{orgID}_deputy_customappdatastage (
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

-- CustomField Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_customfieldstage;
CREATE TABLE c{clientID}_{orgID}_deputy_customfieldstage (
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

-- CustomFieldData Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_customfielddatastage;
CREATE TABLE c{clientID}_{orgID}_deputy_customfielddatastage (
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

-- Company Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_companystage;
CREATE TABLE c{clientID}_{orgID}_deputy_companystage (
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


-- Pattern: c{clientID}_{orgID}_deputy_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Employee Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeestage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeestage (
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

-- PayRules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_payrulesstage;
CREATE TABLE c{clientID}_{orgID}_deputy_payrulesstage (
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

-- TimesheetPayReturn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_timesheetpayreturnstage;
CREATE TABLE c{clientID}_{orgID}_deputy_timesheetpayreturnstage (
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

-- EmployeeAgreement Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeeagreementstage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeeagreementstage (
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

-- EmployeeAgreementHistory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeeagreementhistorystage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeeagreementhistorystage (
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

-- EmployeeAppraisal Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeeappraisalstage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeeappraisalstage (
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

-- EmployeeAvailability Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeeavailabilitystage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeeavailabilitystage (
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

-- EmployeeHistory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeehistorystage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeehistorystage (
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

-- EmployeePaycycle Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeepaycyclestage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeepaycyclestage (
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

-- EmployeePayCycleReturn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeepaycyclereturnstage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeepaycyclereturnstage (
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

-- Pattern: c{clientID}_{orgID}_deputy_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeeRole Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeerolestage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeerolestage (
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

-- EmployeeSalaryCost Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeesalarycoststage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeesalarycoststage (
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

-- EmployeeWorkplace Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employeeworkplacestage;
CREATE TABLE c{clientID}_{orgID}_deputy_employeeworkplacestage (
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

-- EmploymentCondition Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employmentconditionstage;
CREATE TABLE c{clientID}_{orgID}_deputy_employmentconditionstage (
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

-- EmploymentContract Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_employmentcontractstage;
CREATE TABLE c{clientID}_{orgID}_deputy_employmentcontractstage (
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

-- ContractLeaveRules Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_deputy_contractleaverulesstage;
CREATE TABLE c{clientID}_{orgID}_deputy_contractleaverulesstage (
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