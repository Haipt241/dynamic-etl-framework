-- JOBMAN Production Tables - Auto Generated
-- Pattern: c{clientID}_jobman_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Accounts Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_accounts;
CREATE TABLE c{clientID}_jobman_accounts (
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

-- Organisation Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_organisation;
CREATE TABLE c{clientID}_jobman_organisation (
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

-- Users Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_users;
CREATE TABLE c{clientID}_jobman_users (
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

-- Catalogue Materials Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_catalogue materials;
CREATE TABLE c{clientID}_jobman_catalogue materials (
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

-- Catalogue Material Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_catalogue material detail;
CREATE TABLE c{clientID}_jobman_catalogue material detail (
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

-- Catalogue Products Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_catalogue products;
CREATE TABLE c{clientID}_jobman_catalogue products (
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

-- Catalogue Product Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_catalogue product detail;
CREATE TABLE c{clientID}_jobman_catalogue product detail (
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

-- Catalogue Services Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_catalogue services;
CREATE TABLE c{clientID}_jobman_catalogue services (
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

-- Contacts Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_contacts;
CREATE TABLE c{clientID}_jobman_contacts (
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

-- Contact Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_contact detail;
CREATE TABLE c{clientID}_jobman_contact detail (
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


-- Pattern: c{clientID}_jobman_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Customers Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_customers;
CREATE TABLE c{clientID}_jobman_customers (
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

-- Customer Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_customer detail;
CREATE TABLE c{clientID}_jobman_customer detail (
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

-- Employees Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_employees;
CREATE TABLE c{clientID}_jobman_employees (
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

-- Employee Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_employee detail;
CREATE TABLE c{clientID}_jobman_employee detail (
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

-- Locations Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_locations;
CREATE TABLE c{clientID}_jobman_locations (
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

-- Location Detail Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_location detail;
CREATE TABLE c{clientID}_jobman_location detail (
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

-- Categories Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_categories;
CREATE TABLE c{clientID}_jobman_categories (
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

-- Jobs Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_jobs;
CREATE TABLE c{clientID}_jobman_jobs (
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

-- Job Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_job details;
CREATE TABLE c{clientID}_jobman_job details (
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

-- Invoices Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_invoices;
CREATE TABLE c{clientID}_jobman_invoices (
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

-- Pattern: c{clientID}_jobman_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Invoice Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_invoice details;
CREATE TABLE c{clientID}_jobman_invoice details (
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

-- Time Entries Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_time entries;
CREATE TABLE c{clientID}_jobman_time entries (
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

-- Time Entry Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_time entry details;
CREATE TABLE c{clientID}_jobman_time entry details (
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

-- Estimates Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_estimates;
CREATE TABLE c{clientID}_jobman_estimates (
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

-- Estimate Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_estimate details;
CREATE TABLE c{clientID}_jobman_estimate details (
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

-- Purchase Orders Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_purchase orders;
CREATE TABLE c{clientID}_jobman_purchase orders (
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

-- Purchase Order Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_purchase order details;
CREATE TABLE c{clientID}_jobman_purchase order details (
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

-- Expenses Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_expenses;
CREATE TABLE c{clientID}_jobman_expenses (
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

-- Expense Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_expense details;
CREATE TABLE c{clientID}_jobman_expense details (
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

-- Payments Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_payments;
CREATE TABLE c{clientID}_jobman_payments (
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

-- Pattern: c{clientID}_jobman_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Payment Details Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_payment details;
CREATE TABLE c{clientID}_jobman_payment details (
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

-- Job Tasks Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_job tasks;
CREATE TABLE c{clientID}_jobman_job tasks (
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

-- Job Time Entries Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_job time entries;
CREATE TABLE c{clientID}_jobman_job time entries (
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

-- Job Expenses Production Table
DROP TABLE IF EXISTS c{clientID}_jobman_job expenses;
CREATE TABLE c{clientID}_jobman_job expenses (
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

-- JOBMAN LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_jobman_lastrefreshdate;
CREATE TABLE c{clientID}_jobman_lastrefreshdate (
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
