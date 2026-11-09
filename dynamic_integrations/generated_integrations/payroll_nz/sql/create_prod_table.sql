-- PAYROLL_NZ Production Tables - Auto Generated
-- Pattern: c{clientID}_payroll_nz_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employee Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_employee;
CREATE TABLE c{clientID}_payroll_nz_employee (
    employeeid VARCHAR(255) NOT NULL,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    dateofbirth DATETIME,
    gender VARCHAR(255),
    email VARCHAR(255),
    phonenumber VARCHAR(255),
    startdate DATETIME,
    addressline1 VARCHAR(255),
    addressline2 VARCHAR(255),
    addresscity VARCHAR(255),
    addressregion VARCHAR(255),
    addresspostalcode VARCHAR(50),
    addresscountry VARCHAR(100),
    payrollcalendarid VARCHAR(255),
    updateddateutc DATETIME,
    createddateutc DATETIME,
    enddate DATETIME,
    engagementtype VARCHAR(255),
    fixedtermenddate DATETIME,
    employmenttype VARCHAR(255),
    jobtitle VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- EmployeeLeave Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_employeeleave;
CREATE TABLE c{clientID}_payroll_nz_employeeleave (
    leaveid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255),
    description VARCHAR(255),
    startdate DATETIME,
    enddate DATETIME,
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leaveid)
);

-- LeaveBalances Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_leavebalances;
CREATE TABLE c{clientID}_payroll_nz_leavebalances (
    name VARCHAR(255),
    leavetypeid VARCHAR(255),
    balance DECIMAL(18,2),
    typeofunits VARCHAR(100),
    employeeid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- PaymentMethods Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paymentmethods;
CREATE TABLE c{clientID}_payroll_nz_paymentmethods (
    paymentmethod VARCHAR(255),
    employeeid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- EmployeeLeavePeriods Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_employeeleaveperiods;
CREATE TABLE c{clientID}_payroll_nz_employeeleaveperiods (
    leaveid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255) NOT NULL,
    periodstartdate DATETIME,
    periodenddate DATETIME,
    numberofunits DECIMAL(18,2),
    periodstatus VARCHAR(100),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leaveid)
);

-- paymethodbankacct Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paymethodbankacct;
CREATE TABLE c{clientID}_payroll_nz_paymethodbankacct (
    employeeid VARCHAR(255) NOT NULL,
    accountname VARCHAR(255),
    accountnumber VARCHAR(100),
    sortcode VARCHAR(50),
    percentage DECIMAL(5,2),
    calculationtype VARCHAR(100),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid, accountnumber)
);

-- PayRunCalendars Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payruncalendars;
CREATE TABLE c{clientID}_payroll_nz_payruncalendars (
    payrollcalendarid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    calendartype VARCHAR(100),
    periodstartdate DATETIME,
    periodenddate DATETIME,
    paymentdate DATETIME,
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrollcalendarid)
);

-- OpeningBalances Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_openingbalances;
CREATE TABLE c{clientID}_payroll_nz_openingbalances (
    periodenddate DATETIME,
    dayspaid INT,
    unpaidweeks INT,
    grossearnings DECIMAL(18,2),
    employeeid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (periodenddate)
);

-- LeaveTypes Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_leavetypes;
CREATE TABLE c{clientID}_payroll_nz_leavetypes (
    leavetypeid VARCHAR(255) NOT NULL,
    scheduleofaccrual VARCHAR(255),
    maximumtoaccrue DECIMAL(18,2),
    openingbalance DECIMAL(18,6),
    rateaccruedhourly DECIMAL(18,2),
    percentageofgrossearnings INT,
    includeholidaypayeverypay BOOLEAN,
    showannualleaveinadvance BOOLEAN,
    annualleavetotalamountpaid DECIMAL(18,2),
    scheduleofaccrualdate DATETIME,
    unitsaccruedannually INT,
    typeofunitstoaccrue VARCHAR(100),
    openingbalancetypeofunits VARCHAR(100),
    employeeid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- Deductions Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_deductions;
CREATE TABLE c{clientID}_payroll_nz_deductions (
    deductionid VARCHAR(255) NOT NULL,
    deductionname VARCHAR(255),
    deductioncategory VARCHAR(255),
    liabilityaccountid VARCHAR(255),
    currentrecord BOOLEAN,
    standardamount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (deductionid)
);


-- Pattern: c{clientID}_payroll_nz_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalaryAndWages Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_salaryandwages;
CREATE TABLE c{clientID}_payroll_nz_salaryandwages (
    salaryandwagesid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255),
    numberofunitsperweek INT,
    rateperunit DECIMAL(18,4),
    numberofunitsperday INT,
    daysperweek INT,
    effectivefrom DATETIME,
    annualsalary DECIMAL(18,4),
    status VARCHAR(255),
    paymenttype VARCHAR(255),
    workpatterntype VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salaryandwagesid)
);

-- PayTemplates Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paytemplates;
CREATE TABLE c{clientID}_payroll_nz_paytemplates (
    employeeid VARCHAR(255) NOT NULL,
    earningtemplates JSON,
    deductiontemplates JSON,
    benefittemplates JSON,
    reimbursementtemplates JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- PayTemplateEarnings Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paytemplateearnings;
CREATE TABLE c{clientID}_payroll_nz_paytemplateearnings (
    employeeid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,4),
    numberofunits INT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid, earningsrateid)
);

-- PayTemplateDeductions Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paytemplatedeductions;
CREATE TABLE c{clientID}_payroll_nz_paytemplatedeductions (
    employeeid VARCHAR(255) NOT NULL,
    deductiontypeid VARCHAR(255) NOT NULL,
    calculationtype VARCHAR(255),
    percentage DECIMAL(18,4),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid, deductiontypeid)
);

-- PayTemplateBenefits Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paytemplatebenefits;
CREATE TABLE c{clientID}_payroll_nz_paytemplatebenefits (
    employeeid VARCHAR(255) NOT NULL,
    benefittypeid VARCHAR(255) NOT NULL,
    calculationtype VARCHAR(255),
    percentage DECIMAL(18,4),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid, benefittypeid)
);

-- paytplreimb Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paytplreimb;
CREATE TABLE c{clientID}_payroll_nz_paytplreimb (
    employeeid VARCHAR(255) NOT NULL,
    reimbursementtypeid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    calculationtype VARCHAR(255),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid, reimbursementtypeid)
);

-- EarningsRates Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_earningsrates;
CREATE TABLE c{clientID}_payroll_nz_earningsrates (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    earningstype VARCHAR(255),
    ratetype VARCHAR(255),
    typeofunits VARCHAR(255),
    currentrecord BOOLEAN,
    expenseaccountid VARCHAR(255),
    rateperunit DECIMAL(18,4),
    multipleofordinaryearningsrate DECIMAL(18,4),
    fixedamount DECIMAL(18,4),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- Reimbursements Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_reimbursements;
CREATE TABLE c{clientID}_payroll_nz_reimbursements (
    reimbursementid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    accountid VARCHAR(255),
    currentrecord BOOLEAN,
    standardamount DECIMAL(18,4),
    standardtypeofunits VARCHAR(255),
    standardrateperunit DECIMAL(18,4),
    reimbursementcategory VARCHAR(255),
    calculationtype VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reimbursementid)
);

-- Superannuations Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_superannuations;
CREATE TABLE c{clientID}_payroll_nz_superannuations (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    category VARCHAR(255),
    liabilityaccountid VARCHAR(255),
    expenseaccountid VARCHAR(255),
    standardamount DECIMAL(18,4),
    percentage DECIMAL(18,4),
    calculationtypenz VARCHAR(255),
    companymax DECIMAL(18,4),
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRuns Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payruns;
CREATE TABLE c{clientID}_payroll_nz_payruns (
    payrunid VARCHAR(255) NOT NULL,
    payrollcalendarid VARCHAR(255),
    periodstartdate DATETIME,
    periodenddate DATETIME,
    paymentdate DATETIME,
    totalcost DECIMAL(18,4),
    totalpay DECIMAL(18,4),
    payrunstatus VARCHAR(255),
    payruntype VARCHAR(255),
    calendartype VARCHAR(255),
    posteddatetime DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- Pattern: c{clientID}_payroll_nz_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlips Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslips;
CREATE TABLE c{clientID}_payroll_nz_payslips (
    payslipid VARCHAR(255) NOT NULL,
    employeeid VARCHAR(255),
    payrunid VARCHAR(255),
    lastedited DATETIME,
    firstname VARCHAR(255),
    lastname VARCHAR(255),
    totalearnings DECIMAL(18,4),
    grossearnings DECIMAL(18,4),
    totalpay DECIMAL(18,4),
    totalemployertaxes DECIMAL(18,4),
    totalemployeetaxes DECIMAL(18,4),
    totaldeductions DECIMAL(18,4),
    totalreimbursements DECIMAL(18,4),
    totalstatutorydeductions DECIMAL(18,4),
    totalsuperannuation DECIMAL(18,4),
    bacshash VARCHAR(255),
    paymentmethod VARCHAR(255),
    earningslines JSON,
    leaveearningslines JSON,
    timesheetearningslines JSON,
    deductionlines JSON,
    reimbursementlines JSON,
    leaveaccruallines JSON,
    superannuationlines JSON,
    paymentlines JSON,
    employeetaxlines JSON,
    employertaxlines JSON,
    statutorydeductionlines JSON,
    taxsettings JSON,
    grossearningshistory JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid)
);

-- Timesheets Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_timesheets;
CREATE TABLE c{clientID}_payroll_nz_timesheets (
    timesheetid VARCHAR(255) NOT NULL,
    payrollcalendarid VARCHAR(255),
    employeeid VARCHAR(255),
    startdate DATETIME,
    enddate DATETIME,
    status VARCHAR(255),
    totalhours INT,
    updateddateutc DATETIME,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid)
);

-- PaySlipEarnLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipearnln;
CREATE TABLE c{clientID}_payroll_nz_payslipearnln (
    payslipid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,4),
    numberofunits INT,
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, earningsrateid)
);

-- PaySlipDeductLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipdeductln;
CREATE TABLE c{clientID}_payroll_nz_payslipdeductln (
    payslipid VARCHAR(255) NOT NULL,
    deductiontypeid VARCHAR(255) NOT NULL,
    calculationtype VARCHAR(255),
    percentage DECIMAL(18,4),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, deductiontypeid)
);

-- PaySlipSupern Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipsupern;
CREATE TABLE c{clientID}_payroll_nz_payslipsupern (
    payslipid VARCHAR(255) NOT NULL,
    superannuationid VARCHAR(255) NOT NULL,
    calculationtype VARCHAR(255),
    percentage DECIMAL(18,4),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, superannuationid)
);

-- PaySlipLeaveEarnLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipleaveearnln;
CREATE TABLE c{clientID}_payroll_nz_payslipleaveearnln (
    payslipid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,4),
    numberofunits INT,
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, earningsrateid)
);

-- PaySlipTimesheetEarnLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_paysliptimesheetearnln;
CREATE TABLE c{clientID}_payroll_nz_paysliptimesheetearnln (
    payslipid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255) NOT NULL,
    rateperunit DECIMAL(18,4),
    numberofunits INT,
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, earningsrateid)
);

-- PaySlipReimbLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipreimbln;
CREATE TABLE c{clientID}_payroll_nz_payslipreimbln (
    payslipid VARCHAR(255) NOT NULL,
    reimbursementtypeid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, reimbursementtypeid)
);

-- PaySlipAccrual Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipaccrual;
CREATE TABLE c{clientID}_payroll_nz_payslipaccrual (
    payslipid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255) NOT NULL,
    numberofunits INT,
    autocalculate BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, leavetypeid)
);

-- PaySlipPaymentLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslippaymentln;
CREATE TABLE c{clientID}_payroll_nz_payslippaymentln (
    payslipid VARCHAR(255) NOT NULL,
    paymentmethod VARCHAR(255) NOT NULL,
    amount DECIMAL(18,4),
    accountnumber VARCHAR(255),
    accountname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, paymentmethod)
);

-- Pattern: c{clientID}_payroll_nz_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlipEmpTaxLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipemptaxln;
CREATE TABLE c{clientID}_payroll_nz_payslipemptaxln (
    payslipid VARCHAR(255) NOT NULL,
    taxlineid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(18,4),
    globaltaxtypeid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, taxlineid)
);

-- PaySlipEmrTaxLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipemrtaxln;
CREATE TABLE c{clientID}_payroll_nz_payslipemrtaxln (
    payslipid VARCHAR(255) NOT NULL,
    taxlineid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(18,4),
    globaltaxtypeid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, taxlineid)
);

-- PaySlipStatDeductLn Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_payslipstatdeductln;
CREATE TABLE c{clientID}_payroll_nz_payslipstatdeductln (
    payslipid VARCHAR(255) NOT NULL,
    deductiontypeid VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(18,4),
    liabilityamount DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, deductiontypeid)
);

-- Settings Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_settings;
CREATE TABLE c{clientID}_payroll_nz_settings (
    id VARCHAR(255) NOT NULL,
    accounts JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StatutoryDeductions Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_statutorydeductions;
CREATE TABLE c{clientID}_payroll_nz_statutorydeductions (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    liabilityaccountid VARCHAR(255),
    statutorydeductioncategory VARCHAR(255),
    currentrecord BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SettingsAccounts Production Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_settingsaccounts;
CREATE TABLE c{clientID}_payroll_nz_settingsaccounts (
    settingsid VARCHAR(255) NOT NULL,
    accountid VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    code VARCHAR(255),
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (settingsid, accountid)
);

-- PAYROLL_NZ LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_payroll_nz_lastrefreshdate;
CREATE TABLE c{clientID}_payroll_nz_lastrefreshdate (
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
