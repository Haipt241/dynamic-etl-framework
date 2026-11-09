-- PAYROLL_AU Production Tables - Auto Generated
-- Pattern: c{clientID}_payroll_au_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employees Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employees;
CREATE TABLE c{clientID}_payroll_au_employees (
    employeeid VARCHAR(255) NOT NULL,
    title VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    status VARCHAR(255),
    email VARCHAR(255),
    dateofbirth DATETIME,
    jobtitle VARCHAR(255),
    gender VARCHAR(255),
    homeaddressline1 VARCHAR(255),
    homeaddressline2 VARCHAR(255),
    homeaddresscity VARCHAR(255),
    homeaddressregion VARCHAR(255),
    homeaddresspostalcode VARCHAR(255),
    homeaddresscountry VARCHAR(255),
    phone VARCHAR(255),
    mobile VARCHAR(255),
    startdate DATETIME,
    classification VARCHAR(255),
    ordinaryearningsrateid VARCHAR(255),
    payrollcalendarid VARCHAR(255),
    updateddateutc DATETIME,
    isauthorisedtoapproveleave BOOLEAN,
    isauthorisedtoapprovetimesheets BOOLEAN,
    taxdeclaustralianresident BOOLEAN,
    taxdecltaxfreethresholdclaimed BOOLEAN,
    taxdeclhashelpdebt BOOLEAN,
    taxdeclhassfssdebt BOOLEAN,
    taxdeclhasstudentstartuploan BOOLEAN,
    taxdeclhastradesupportloandebt BOOLEAN,
    taxdeclhasloanorstudentdebt BOOLEAN,
    taxdecleligibleleaveloading BOOLEAN,
    taxdeclupdateddateutc DATETIME,
    taxdeclresidencystatus VARCHAR(255),
    openingbalancedate DATETIME,
    openingbalancetax DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- EmployeeBankAccounts Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employeebankaccounts;
CREATE TABLE c{clientID}_payroll_au_employeebankaccounts (
    employeeid VARCHAR(255) NOT NULL,
    statementtext VARCHAR(255),
    accountname VARCHAR(255),
    bsb VARCHAR(255),
    accountnumber VARCHAR(255),
    remainder BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EmployeeLeaveBalances Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employeeleavebalances;
CREATE TABLE c{clientID}_payroll_au_employeeleavebalances (
    employeeid VARCHAR(255) NOT NULL,
    leavename VARCHAR(255),
    leavetypeid VARCHAR(255),
    numberofunits DECIMAL(18,4),
    typeofunits VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EmployeeSuperMemberships Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employeesupermemberships;
CREATE TABLE c{clientID}_payroll_au_employeesupermemberships (
    employeeid VARCHAR(255) NOT NULL,
    superfundid VARCHAR(255),
    employeenumber VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (superfundid)
);

-- paysliptimesheetearnln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_paysliptimesheetearnln;
CREATE TABLE c{clientID}_payroll_au_paysliptimesheetearnln (
    employeeid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255),
    amount DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- empopenballeaveln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_empopenballeaveln;
CREATE TABLE c{clientID}_payroll_au_empopenballeaveln (
    employeeid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255),
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- emppaytplearnln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_emppaytplearnln;
CREATE TABLE c{clientID}_payroll_au_emppaytplearnln (
    employeeid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255),
    rateperunit DECIMAL(18,2),
    numberofunits DECIMAL(18,4),
    fixedamount DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- emppaytpldeductln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_emppaytpldeductln;
CREATE TABLE c{clientID}_payroll_au_emppaytpldeductln (
    employeeid VARCHAR(255) NOT NULL,
    deductiontypeid VARCHAR(255),
    calculationtype VARCHAR(255),
    amount DECIMAL(18,2),
    percentage DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (deductiontypeid)
);

-- EmployeePayTplSuperLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employeepaytplsuperlines;
CREATE TABLE c{clientID}_payroll_au_employeepaytplsuperlines (
    employeeid VARCHAR(255) NOT NULL,
    supermembershipid VARCHAR(255),
    contributiontype VARCHAR(255),
    calculationtype VARCHAR(255),
    amount DECIMAL(18,2),
    percentage DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (supermembershipid)
);

-- EmpPayTplReimbLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_emppaytplreimblines;
CREATE TABLE c{clientID}_payroll_au_emppaytplreimblines (
    employeeid VARCHAR(255) NOT NULL,
    reimbursementtypeid VARCHAR(255),
    description VARCHAR(255),
    amount DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reimbursementtypeid)
);


-- Pattern: c{clientID}_payroll_au_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeePayTplLeaveLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_employeepaytplleavelines;
CREATE TABLE c{clientID}_payroll_au_employeepaytplleavelines (
    employeeid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255),
    calculationtype VARCHAR(255),
    annualnumberofunits DECIMAL(18,4),
    fulltimenumberofunitsperperiod DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- LeaveApplications Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_leaveapplications;
CREATE TABLE c{clientID}_payroll_au_leaveapplications (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    leaveapplicationid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255),
    leavetypeid VARCHAR(255),
    title VARCHAR(255),
    startdate DATETIME,
    enddate DATETIME,
    updateddateutc DATETIME,
    payouttype VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leaveapplicationid)
);

-- LeaveApplicationPeriods Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_leaveapplicationperiods;
CREATE TABLE c{clientID}_payroll_au_leaveapplicationperiods (
    leaveapplicationid VARCHAR(255) NOT NULL,
    payperiodstartdate DATETIME,
    payperiodenddate DATETIME,
    leaveperiodstatus VARCHAR(255),
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leaveapplicationid)
);

-- PayItems Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payitems;
CREATE TABLE c{clientID}_payroll_au_payitems (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PayItemsEarningsRates Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payitemsearningsrates;
CREATE TABLE c{clientID}_payroll_au_payitemsearningsrates (
    earningsrateid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    earningstype VARCHAR(255),
    ratetype VARCHAR(255),
    accountcode VARCHAR(255),
    typeofunits VARCHAR(255),
    multiplier DECIMAL(18,4),
    amount DECIMAL(18,4),
    isexemptfromtax BOOLEAN,
    isexemptfromsuper BOOLEAN,
    accrueleave BOOLEAN,
    isreportableasw1 BOOLEAN,
    employmentterminationpaymenttype VARCHAR(255),
    updateddateutc DATETIME,
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- PayItemsDeductionTypes Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payitemsdeductiontypes;
CREATE TABLE c{clientID}_payroll_au_payitemsdeductiontypes (
    deductiontypeid VARCHAR(255) NOT NULL,
    deductioncategory VARCHAR(255),
    name VARCHAR(255),
    accountcode VARCHAR(255),
    reducestax BOOLEAN,
    reducessuper BOOLEAN,
    isexemptfromw1 BOOLEAN,
    updateddateutc DATETIME,
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (deductiontypeid)
);

-- payitemreimbtypes Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payitemreimbtypes;
CREATE TABLE c{clientID}_payroll_au_payitemreimbtypes (
    reimbursementtypeid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    accountcode VARCHAR(255),
    updateddateutc DATETIME,
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reimbursementtypeid)
);

-- PayItemsLeaveTypes Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payitemsleavetypes;
CREATE TABLE c{clientID}_payroll_au_payitemsleavetypes (
    leavetypeid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    typeofunits VARCHAR(255),
    normalentitlement DECIMAL(18,4),
    leaveloadingrate DECIMAL(18,4),
    ispaidleave BOOLEAN,
    showonpayslip BOOLEAN,
    leavecategorycode VARCHAR(255),
    sgcexempt BOOLEAN,
    updateddateutc DATETIME,
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- PayrollCalendars Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payrollcalendars;
CREATE TABLE c{clientID}_payroll_au_payrollcalendars (
    payrollcalendarid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    calendartype VARCHAR(255),
    startdate DATETIME,
    paymentdate DATETIME,
    updateddateutc DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrollcalendarid)
);

-- PayRuns Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payruns;
CREATE TABLE c{clientID}_payroll_au_payruns (
    payrunid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    payrollcalendarid VARCHAR(255),
    payrunperiodstartdate DATETIME,
    payrunperiodenddate DATETIME,
    paymentdate DATETIME,
    wages DECIMAL(15,2),
    deductions DECIMAL(15,2),
    tax DECIMAL(15,2),
    super DECIMAL(15,2),
    reimbursement DECIMAL(15,2),
    netpay DECIMAL(15,2),
    payrunstatus VARCHAR(255),
    updateddateutc DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- Pattern: c{clientID}_payroll_au_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunPayslips Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payrunpayslips;
CREATE TABLE c{clientID}_payroll_au_payrunpayslips (
    payrunid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255) NOT NULL,
    payslipid VARCHAR(255) NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    wages DECIMAL(15,2),
    deductions DECIMAL(15,2),
    tax DECIMAL(15,2),
    super DECIMAL(15,2),
    reimbursements DECIMAL(15,2),
    netpay DECIMAL(15,2),
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid, employeeid, payslipid)
);

-- Settings Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_settings;
CREATE TABLE c{clientID}_payroll_au_settings (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    accounts JSON,
    daysinpayrollyear VARCHAR(50),
    employeesarestp2 BOOLEAN,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SuperFunds Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_superfunds;
CREATE TABLE c{clientID}_payroll_au_superfunds (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    superfundid VARCHAR(255) NOT NULL,
    name VARCHAR(500),
    type VARCHAR(100),
    usi VARCHAR(50),
    updateddateutc DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (superfundid)
);

-- Timesheets Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_timesheets;
CREATE TABLE c{clientID}_payroll_au_timesheets (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    timesheetid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255),
    startdate DATETIME,
    enddate DATETIME,
    status VARCHAR(50),
    hours DECIMAL(18,4),
    updateddateutc DATETIME,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid)
);

-- TimesheetLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_timesheetlines;
CREATE TABLE c{clientID}_payroll_au_timesheetlines (
    timesheetid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    numberofunits JSON,
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, earningsrateid)
);

-- Payslip Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslip;
CREATE TABLE c{clientID}_payroll_au_payslip (
    payslipid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255),
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    lastedited DATETIME,
    tax DECIMAL(18,2),
    netpay DECIMAL(18,2),
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid)
);

-- PayslipEarningsLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslipearningslines;
CREATE TABLE c{clientID}_payroll_au_payslipearningslines (
    payslipid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,6),
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- payslipleaveearnln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslipleaveearnln;
CREATE TABLE c{clientID}_payroll_au_payslipleaveearnln (
    payslipid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,6),
    numberofunits DECIMAL(18,4),
    payouttype VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- PayslipDeductionLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslipdeductionlines;
CREATE TABLE c{clientID}_payroll_au_payslipdeductionlines (
    payslipid VARCHAR(255) NOT NULL,
    deductiontypeid VARCHAR(255) NOT NULL,
    amount DECIMAL(15,2),
    calculationtype VARCHAR(255),
    percentage DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (deductiontypeid)
);

-- payslipreimbln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslipreimbln;
CREATE TABLE c{clientID}_payroll_au_payslipreimbln (
    payslipid VARCHAR(255) NOT NULL,
    reimbursementtypeid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(15,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reimbursementtypeid)
);

-- Pattern: c{clientID}_payroll_au_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipTaxLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_paysliptaxlines;
CREATE TABLE c{clientID}_payroll_au_paysliptaxlines (
    payslipid VARCHAR(255) NOT NULL,
    paysliptaxlineid VARCHAR(255) NOT NULL,
    taxtypename VARCHAR(255),
    description VARCHAR(255),
    amount DECIMAL(15,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (paysliptaxlineid)
);

-- PayslipLeaveAccrualLines Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_payslipleaveaccruallines;
CREATE TABLE c{clientID}_payroll_au_payslipleaveaccruallines (
    payslipid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255) NOT NULL,
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- empopenbalearnln Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_empopenbalearnln;
CREATE TABLE c{clientID}_payroll_au_empopenbalearnln (
    payslipid VARCHAR(255) NOT NULL,
    supermembershipid VARCHAR(255) NOT NULL,
    contributiontype VARCHAR(255),
    calculationtype VARCHAR(255),
    amount DECIMAL(15,2),
    percentage DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (supermembershipid)
);

-- PAYROLL_AU LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_payroll_au_lastrefreshdate;
CREATE TABLE c{clientID}_payroll_au_lastrefreshdate (
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
