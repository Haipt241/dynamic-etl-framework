-- JOBMAN Views - Auto Generated
-- Pattern: {etani_client_id}_jobman_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Accounts View
DROP VIEW IF EXISTS {etani_client_id}_jobman_accounts;
CREATE VIEW {etani_client_id}_jobman_accounts AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_accounts;

-- Organisation View
DROP VIEW IF EXISTS {etani_client_id}_jobman_organisation;
CREATE VIEW {etani_client_id}_jobman_organisation AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_organisation;

-- Users View
DROP VIEW IF EXISTS {etani_client_id}_jobman_users;
CREATE VIEW {etani_client_id}_jobman_users AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_users;

-- Catalogue Materials View
DROP VIEW IF EXISTS {etani_client_id}_jobman_catalogue materials;
CREATE VIEW {etani_client_id}_jobman_catalogue materials AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_catalogue materials;

-- Catalogue Material Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_catalogue material detail;
CREATE VIEW {etani_client_id}_jobman_catalogue material detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_catalogue material detail;

-- Catalogue Products View
DROP VIEW IF EXISTS {etani_client_id}_jobman_catalogue products;
CREATE VIEW {etani_client_id}_jobman_catalogue products AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_catalogue products;

-- Catalogue Product Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_catalogue product detail;
CREATE VIEW {etani_client_id}_jobman_catalogue product detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_catalogue product detail;

-- Catalogue Services View
DROP VIEW IF EXISTS {etani_client_id}_jobman_catalogue services;
CREATE VIEW {etani_client_id}_jobman_catalogue services AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_catalogue services;

-- Contacts View
DROP VIEW IF EXISTS {etani_client_id}_jobman_contacts;
CREATE VIEW {etani_client_id}_jobman_contacts AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_contacts;

-- Contact Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_contact detail;
CREATE VIEW {etani_client_id}_jobman_contact detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_contact detail;


-- Pattern: {etani_client_id}_jobman_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Customers View
DROP VIEW IF EXISTS {etani_client_id}_jobman_customers;
CREATE VIEW {etani_client_id}_jobman_customers AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_customers;

-- Customer Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_customer detail;
CREATE VIEW {etani_client_id}_jobman_customer detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_customer detail;

-- Employees View
DROP VIEW IF EXISTS {etani_client_id}_jobman_employees;
CREATE VIEW {etani_client_id}_jobman_employees AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_employees;

-- Employee Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_employee detail;
CREATE VIEW {etani_client_id}_jobman_employee detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_employee detail;

-- Locations View
DROP VIEW IF EXISTS {etani_client_id}_jobman_locations;
CREATE VIEW {etani_client_id}_jobman_locations AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_locations;

-- Location Detail View
DROP VIEW IF EXISTS {etani_client_id}_jobman_location detail;
CREATE VIEW {etani_client_id}_jobman_location detail AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_location detail;

-- Categories View
DROP VIEW IF EXISTS {etani_client_id}_jobman_categories;
CREATE VIEW {etani_client_id}_jobman_categories AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_categories;

-- Jobs View
DROP VIEW IF EXISTS {etani_client_id}_jobman_jobs;
CREATE VIEW {etani_client_id}_jobman_jobs AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_jobs;

-- Job Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_job details;
CREATE VIEW {etani_client_id}_jobman_job details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_job details;

-- Invoices View
DROP VIEW IF EXISTS {etani_client_id}_jobman_invoices;
CREATE VIEW {etani_client_id}_jobman_invoices AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_invoices;

-- Pattern: {etani_client_id}_jobman_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Invoice Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_invoice details;
CREATE VIEW {etani_client_id}_jobman_invoice details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_invoice details;

-- Time Entries View
DROP VIEW IF EXISTS {etani_client_id}_jobman_time entries;
CREATE VIEW {etani_client_id}_jobman_time entries AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_time entries;

-- Time Entry Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_time entry details;
CREATE VIEW {etani_client_id}_jobman_time entry details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_time entry details;

-- Estimates View
DROP VIEW IF EXISTS {etani_client_id}_jobman_estimates;
CREATE VIEW {etani_client_id}_jobman_estimates AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_estimates;

-- Estimate Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_estimate details;
CREATE VIEW {etani_client_id}_jobman_estimate details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_estimate details;

-- Purchase Orders View
DROP VIEW IF EXISTS {etani_client_id}_jobman_purchase orders;
CREATE VIEW {etani_client_id}_jobman_purchase orders AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_purchase orders;

-- Purchase Order Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_purchase order details;
CREATE VIEW {etani_client_id}_jobman_purchase order details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_purchase order details;

-- Expenses View
DROP VIEW IF EXISTS {etani_client_id}_jobman_expenses;
CREATE VIEW {etani_client_id}_jobman_expenses AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_expenses;

-- Expense Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_expense details;
CREATE VIEW {etani_client_id}_jobman_expense details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_expense details;

-- Payments View
DROP VIEW IF EXISTS {etani_client_id}_jobman_payments;
CREATE VIEW {etani_client_id}_jobman_payments AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_payments;

-- Pattern: {etani_client_id}_jobman_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Payment Details View
DROP VIEW IF EXISTS {etani_client_id}_jobman_payment details;
CREATE VIEW {etani_client_id}_jobman_payment details AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_payment details;

-- Job Tasks View
DROP VIEW IF EXISTS {etani_client_id}_jobman_job tasks;
CREATE VIEW {etani_client_id}_jobman_job tasks AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_job tasks;

-- Job Time Entries View
DROP VIEW IF EXISTS {etani_client_id}_jobman_job time entries;
CREATE VIEW {etani_client_id}_jobman_job time entries AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_job time entries;

-- Job Expenses View
DROP VIEW IF EXISTS {etani_client_id}_jobman_job expenses;
CREATE VIEW {etani_client_id}_jobman_job expenses AS
SELECT
    id,
    name,
    createdat AS `created_at`,
    updatedat AS `updated_at`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_jobman_job expenses;