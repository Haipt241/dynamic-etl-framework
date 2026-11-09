-- XEROPROJECT Production Tables - Auto Generated
-- Pattern: c{clientID}_xeroproject_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Projects Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_projects;
CREATE TABLE c{clientID}_xeroproject_projects (
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

-- Tasks Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_tasks;
CREATE TABLE c{clientID}_xeroproject_tasks (
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

-- TimeEntries Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_timeentries;
CREATE TABLE c{clientID}_xeroproject_timeentries (
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

-- ProjectUsers Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_projectusers;
CREATE TABLE c{clientID}_xeroproject_projectusers (
    userid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- ProjectTaskAmounts Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_projecttaskamounts;
CREATE TABLE c{clientID}_xeroproject_projecttaskamounts (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- ProjectExpenseAmounts Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_projectexpenseamounts;
CREATE TABLE c{clientID}_xeroproject_projectexpenseamounts (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- ProjectInvoiceAmounts Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_projectinvoiceamounts;
CREATE TABLE c{clientID}_xeroproject_projectinvoiceamounts (
    projectid VARCHAR(255) NOT NULL,
    currency VARCHAR(10),
    value DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (projectid)
);

-- TaskRates Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_taskrates;
CREATE TABLE c{clientID}_xeroproject_taskrates (
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

-- TaskTotalAmounts Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_tasktotalamounts;
CREATE TABLE c{clientID}_xeroproject_tasktotalamounts (
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

-- TaskInvoicedAmounts Production Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_taskinvoicedamounts;
CREATE TABLE c{clientID}_xeroproject_taskinvoicedamounts (
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


-- XEROPROJECT LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_xeroproject_lastrefreshdate;
CREATE TABLE c{clientID}_xeroproject_lastrefreshdate (
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
