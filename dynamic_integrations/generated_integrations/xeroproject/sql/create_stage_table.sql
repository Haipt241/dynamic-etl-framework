-- XEROPROJECT Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_xeroproject_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Projects Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_projectsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_projectsstage (
    projectid VARCHAR(255) NOT NULL,
    contactid VARCHAR(255),
    name VARCHAR(255),
    currencycode VARCHAR(10),
    minuteslogged INT,
    totaltaskamount JSON,
    totalexpenseamount JSON,
    minutestobeinvoiced INT,
    taskamounttobeinvoiced JSON,
    taskamountinvoiced JSON,
    expenseamounttobeinvoiced JSON,
    expenseamountinvoiced JSON,
    projectamountinvoiced JSON,
    deposit JSON,
    depositapplied JSON,
    creditnoteamount JSON,
    deadlineutc DATETIME,
    totalinvoiced JSON,
    totaltobeinvoiced JSON,
    estimate JSON,
    status VARCHAR(50),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_tasksstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_tasksstage (
    taskid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    rate JSON,
    chargetype VARCHAR(50),
    estimateminutes INT,
    totalminutes INT,
    totalamount JSON,
    minutestobeinvoiced INT,
    minutesinvoiced INT,
    nonchargeableminutes INT,
    amounttobeinvoiced JSON,
    amountinvoiced JSON,
    status VARCHAR(50),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- TimeEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_timeentriesstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_timeentriesstage (
    timeentryid VARCHAR(255) NOT NULL,
    userid VARCHAR(255),
    projectid VARCHAR(255) NOT NULL,
    taskid VARCHAR(255),
    dateutc DATETIME,
    dateenteredutc DATETIME,
    duration INT,
    description TEXT,
    status VARCHAR(50),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timeentryid)
);

-- ProjectUsers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_projectusersstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_projectusersstage (
    userid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- ProjectTaskAmounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_projecttaskamountsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_projecttaskamountsstage (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- ProjectExpenseAmounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_projectexpenseamountsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_projectexpenseamountsstage (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- ProjectInvoiceAmounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_projectinvoiceamountsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_projectinvoiceamountsstage (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- TaskRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_taskratesstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_taskratesstage (
    taskid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- TaskTotalAmounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_tasktotalamountsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_tasktotalamountsstage (
    taskid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);

-- TaskInvoicedAmounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_xeroproject_taskinvoicedamountsstage;
CREATE TABLE c{clientID}_{orgID}_xeroproject_taskinvoicedamountsstage (
    taskid VARCHAR(255) NOT NULL,
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (taskid)
);
