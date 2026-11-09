-- PAYROLL_NZ Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_payroll_nz_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Employee Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_employeestage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_employeestage (
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

-- EmployeeLeave Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_employeeleavestage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_employeeleavestage (
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

-- LeaveBalances Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_leavebalancesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_leavebalancesstage (
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

-- PaymentMethods Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paymentmethodsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paymentmethodsstage (
    paymentmethod VARCHAR(255),
    employeeid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- EmployeeLeavePeriods Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_employeeleaveperiodsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_employeeleaveperiodsstage (
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

-- paymethodbankacct Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paymethodbankacctstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paymethodbankacctstage (
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

-- PayRunCalendars Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payruncalendarsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payruncalendarsstage (
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

-- OpeningBalances Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_openingbalancesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_openingbalancesstage (
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

-- LeaveTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_leavetypesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_leavetypesstage (
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

-- Deductions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_deductionsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_deductionsstage (
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


-- Pattern: c{clientID}_{orgID}_payroll_nz_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- SalaryAndWages Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_salaryandwagesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_salaryandwagesstage (
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

-- PayTemplates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paytemplatesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paytemplatesstage (
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

-- PayTemplateEarnings Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paytemplateearningsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paytemplateearningsstage (
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

-- PayTemplateDeductions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paytemplatedeductionsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paytemplatedeductionsstage (
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

-- PayTemplateBenefits Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paytemplatebenefitsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paytemplatebenefitsstage (
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

-- paytplreimb Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paytplreimbstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paytplreimbstage (
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

-- EarningsRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_earningsratesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_earningsratesstage (
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

-- Reimbursements Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_reimbursementsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_reimbursementsstage (
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

-- Superannuations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_superannuationsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_superannuationsstage (
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

-- PayRuns Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payrunsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payrunsstage (
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

-- Pattern: c{clientID}_{orgID}_payroll_nz_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlips Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipsstage (
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

-- Timesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_timesheetsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_timesheetsstage (
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

-- PaySlipEarnLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipearnlnstage (
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

-- PaySlipDeductLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipdeductlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipdeductlnstage (
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

-- PaySlipSupern Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipsupernstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipsupernstage (
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

-- PaySlipLeaveEarnLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipleaveearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipleaveearnlnstage (
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

-- PaySlipTimesheetEarnLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_paysliptimesheetearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_paysliptimesheetearnlnstage (
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

-- PaySlipReimbLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipreimblnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipreimblnstage (
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

-- PaySlipAccrual Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipaccrualstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipaccrualstage (
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

-- PaySlipPaymentLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslippaymentlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslippaymentlnstage (
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

-- Pattern: c{clientID}_{orgID}_payroll_nz_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlipEmpTaxLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipemptaxlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipemptaxlnstage (
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

-- PaySlipEmrTaxLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipemrtaxlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipemrtaxlnstage (
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

-- PaySlipStatDeductLn Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_payslipstatdeductlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_payslipstatdeductlnstage (
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

-- Settings Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_settingsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_settingsstage (
    id VARCHAR(255) NOT NULL,
    accounts JSON,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StatutoryDeductions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_statutorydeductionsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_statutorydeductionsstage (
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

-- SettingsAccounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_nz_settingsaccountsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_nz_settingsaccountsstage (
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