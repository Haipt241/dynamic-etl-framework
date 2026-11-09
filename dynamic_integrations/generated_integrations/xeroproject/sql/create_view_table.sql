-- XEROPROJECT Views - Auto Generated
-- Pattern: {etani_client_id}_xeroproject_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Projects View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_projects;
CREATE VIEW {etani_client_id}_xeroproject_projects AS
SELECT
    projectid,
    contactid,
    name,
    currencycode,
    minuteslogged,
    totaltaskamount,
    totalexpenseamount,
    minutestobeinvoiced,
    taskamounttobeinvoiced,
    taskamountinvoiced,
    expenseamounttobeinvoiced,
    expenseamountinvoiced,
    projectamountinvoiced,
    deposit,
    depositapplied,
    creditnoteamount,
    deadlineutc,
    totalinvoiced,
    totaltobeinvoiced,
    estimate,
    status,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_projects;

-- Tasks View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_tasks;
CREATE VIEW {etani_client_id}_xeroproject_tasks AS
SELECT
    taskid,
    projectid,
    name,
    rate,
    chargetype,
    estimateminutes,
    totalminutes,
    totalamount,
    minutestobeinvoiced,
    minutesinvoiced,
    nonchargeableminutes,
    amounttobeinvoiced,
    amountinvoiced,
    status,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_tasks;

-- TimeEntries View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_timeentries;
CREATE VIEW {etani_client_id}_xeroproject_timeentries AS
SELECT
    timeentryid,
    userid,
    projectid,
    taskid,
    dateutc,
    dateenteredutc,
    duration,
    description,
    status,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_timeentries;

-- ProjectUsers View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_projectusers;
CREATE VIEW {etani_client_id}_xeroproject_projectusers AS
SELECT
    userid,
    name,
    email,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_projectusers;

-- ProjectTaskAmounts View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_projecttaskamounts;
CREATE VIEW {etani_client_id}_xeroproject_projecttaskamounts AS
SELECT
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_projecttaskamounts;

-- ProjectExpenseAmounts View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_projectexpenseamounts;
CREATE VIEW {etani_client_id}_xeroproject_projectexpenseamounts AS
SELECT
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_projectexpenseamounts;

-- ProjectInvoiceAmounts View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_projectinvoiceamounts;
CREATE VIEW {etani_client_id}_xeroproject_projectinvoiceamounts AS
SELECT
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_projectinvoiceamounts;

-- TaskRates View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_taskrates;
CREATE VIEW {etani_client_id}_xeroproject_taskrates AS
SELECT
    taskid,
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_taskrates;

-- TaskTotalAmounts View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_tasktotalamounts;
CREATE VIEW {etani_client_id}_xeroproject_tasktotalamounts AS
SELECT
    taskid,
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_tasktotalamounts;

-- TaskInvoicedAmounts View
DROP VIEW IF EXISTS {etani_client_id}_xeroproject_taskinvoicedamounts;
CREATE VIEW {etani_client_id}_xeroproject_taskinvoicedamounts AS
SELECT
    taskid,
    projectid,
    currency,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_xeroproject_taskinvoicedamounts;
