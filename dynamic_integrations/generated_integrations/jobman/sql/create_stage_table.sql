-- JOBMAN Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_jobman_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Accounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_accountsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_accountsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Organisation Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_organisationstage;
CREATE TABLE c{clientID}_{orgID}_jobman_organisationstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Users Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_usersstage;
CREATE TABLE c{clientID}_{orgID}_jobman_usersstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogue Materials Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_catalogue materialsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_catalogue materialsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogue Material Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_catalogue material detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_catalogue material detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogue Products Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_catalogue productsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_catalogue productsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogue Product Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_catalogue product detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_catalogue product detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Catalogue Services Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_catalogue servicesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_catalogue servicesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_contactsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_contactsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contact Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_contact detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_contact detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);


-- Pattern: c{clientID}_{orgID}_jobman_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Customers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_customersstage;
CREATE TABLE c{clientID}_{orgID}_jobman_customersstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Customer Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_customer detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_customer detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Employees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_employeesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_employeesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Employee Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_employee detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_employee detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Locations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_locationsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_locationsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Location Detail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_location detailstage;
CREATE TABLE c{clientID}_{orgID}_jobman_location detailstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Categories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_categoriesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_categoriesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Jobs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_jobsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_jobsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Job Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_job detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_job detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Invoices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_invoicesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_invoicesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_jobman_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Invoice Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_invoice detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_invoice detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Time Entries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_time entriesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_time entriesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Time Entry Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_time entry detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_time entry detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Estimates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_estimatesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_estimatesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Estimate Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_estimate detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_estimate detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Purchase Orders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_purchase ordersstage;
CREATE TABLE c{clientID}_{orgID}_jobman_purchase ordersstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Purchase Order Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_purchase order detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_purchase order detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Expenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_expensesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_expensesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Expense Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_expense detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_expense detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Payments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_paymentsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_paymentsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_jobman_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Payment Details Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_payment detailsstage;
CREATE TABLE c{clientID}_{orgID}_jobman_payment detailsstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Job Tasks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_job tasksstage;
CREATE TABLE c{clientID}_{orgID}_jobman_job tasksstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Job Time Entries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_job time entriesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_job time entriesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Job Expenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_jobman_job expensesstage;
CREATE TABLE c{clientID}_{orgID}_jobman_job expensesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat DATETIME NOT NULL,
    updatedat DATETIME NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid INT NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);