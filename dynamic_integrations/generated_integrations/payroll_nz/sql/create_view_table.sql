-- PAYROLL_NZ Views - Auto Generated
-- Pattern: {etani_client_id}_payroll_nz_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employee View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_employee;
CREATE VIEW {etani_client_id}_payroll_nz_employee AS
SELECT
    employeeid,
    firstname,
    lastname,
    dateofbirth,
    gender,
    email,
    phonenumber,
    startdate,
    addressline1 AS `address.line1`,
    addressline2 AS `address.line2`,
    addresscity AS `address.city`,
    addressregion AS `address.region`,
    addresspostalcode AS `address.postalcode`,
    addresscountry AS `address.country`,
    payrollcalendarid,
    updateddateutc,
    createddateutc,
    enddate,
    engagementtype,
    fixedtermenddate,
    employmenttype,
    jobtitle,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_employee;

-- EmployeeLeave View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_employeeleave;
CREATE VIEW {etani_client_id}_payroll_nz_employeeleave AS
SELECT
    leaveid,
    employeeid,
    leavetypeid,
    description,
    startdate,
    enddate,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_employeeleave;

-- LeaveBalances View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_leavebalances;
CREATE VIEW {etani_client_id}_payroll_nz_leavebalances AS
SELECT
    name,
    leavetypeid,
    balance,
    typeofunits,
    employeeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_leavebalances;

-- PaymentMethods View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paymentmethods;
CREATE VIEW {etani_client_id}_payroll_nz_paymentmethods AS
SELECT
    paymentmethod,
    employeeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paymentmethods;

-- EmployeeLeavePeriods View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_employeeleaveperiods;
CREATE VIEW {etani_client_id}_payroll_nz_employeeleaveperiods AS
SELECT
    leaveid,
    employeeid,
    periodstartdate AS `startdate`,
    periodenddate AS `enddate`,
    numberofunits,
    periodstatus,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_employeeleaveperiods;

-- paymethodbankacct View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paymethodbankacct;
CREATE VIEW {etani_client_id}_payroll_nz_paymethodbankacct AS
SELECT
    employeeid,
    accountname,
    accountnumber,
    sortcode,
    percentage,
    calculationtype,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paymethodbankacct;

-- PayRunCalendars View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payruncalendars;
CREATE VIEW {etani_client_id}_payroll_nz_payruncalendars AS
SELECT
    payrollcalendarid,
    name,
    calendartype,
    periodstartdate,
    periodenddate,
    paymentdate,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payruncalendars;

-- OpeningBalances View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_openingbalances;
CREATE VIEW {etani_client_id}_payroll_nz_openingbalances AS
SELECT
    periodenddate,
    dayspaid,
    unpaidweeks,
    grossearnings,
    employeeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_openingbalances;

-- LeaveTypes View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_leavetypes;
CREATE VIEW {etani_client_id}_payroll_nz_leavetypes AS
SELECT
    leavetypeid,
    scheduleofaccrual,
    maximumtoaccrue,
    openingbalance,
    rateaccruedhourly,
    percentageofgrossearnings,
    includeholidaypayeverypay,
    showannualleaveinadvance,
    annualleavetotalamountpaid,
    scheduleofaccrualdate,
    unitsaccruedannually,
    typeofunitstoaccrue,
    openingbalancetypeofunits,
    employeeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_leavetypes;

-- Deductions View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_deductions;
CREATE VIEW {etani_client_id}_payroll_nz_deductions AS
SELECT
    deductionid,
    deductionname,
    deductioncategory,
    liabilityaccountid,
    currentrecord,
    standardamount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_deductions;


-- Pattern: {etani_client_id}_payroll_nz_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalaryAndWages View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_salaryandwages;
CREATE VIEW {etani_client_id}_payroll_nz_salaryandwages AS
SELECT
    salaryandwagesid,
    earningsrateid,
    numberofunitsperweek,
    rateperunit,
    numberofunitsperday,
    daysperweek,
    effectivefrom,
    annualsalary,
    status,
    paymenttype,
    workpatterntype,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_salaryandwages;

-- PayTemplates View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paytemplates;
CREATE VIEW {etani_client_id}_payroll_nz_paytemplates AS
SELECT
    employeeid,
    earningtemplates,
    deductiontemplates,
    benefittemplates,
    reimbursementtemplates,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paytemplates;

-- PayTemplateEarnings View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paytemplateearnings;
CREATE VIEW {etani_client_id}_payroll_nz_paytemplateearnings AS
SELECT
    employeeid,
    earningsrateid,
    rateperunit,
    numberofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paytemplateearnings;

-- PayTemplateDeductions View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paytemplatedeductions;
CREATE VIEW {etani_client_id}_payroll_nz_paytemplatedeductions AS
SELECT
    employeeid,
    deductiontypeid,
    calculationtype,
    percentage,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paytemplatedeductions;

-- PayTemplateBenefits View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paytemplatebenefits;
CREATE VIEW {etani_client_id}_payroll_nz_paytemplatebenefits AS
SELECT
    employeeid,
    benefittypeid,
    calculationtype,
    percentage,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paytemplatebenefits;

-- paytplreimb View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paytplreimb;
CREATE VIEW {etani_client_id}_payroll_nz_paytplreimb AS
SELECT
    employeeid,
    reimbursementtypeid,
    description,
    calculationtype,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paytplreimb;

-- EarningsRates View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_earningsrates;
CREATE VIEW {etani_client_id}_payroll_nz_earningsrates AS
SELECT
    clientid,
    organisationid,
    earningsrateid,
    name,
    earningstype,
    ratetype,
    typeofunits,
    currentrecord,
    expenseaccountid,
    rateperunit,
    multipleofordinaryearningsrate,
    fixedamount,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_earningsrates;

-- Reimbursements View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_reimbursements;
CREATE VIEW {etani_client_id}_payroll_nz_reimbursements AS
SELECT
    reimbursementid,
    name,
    accountid,
    currentrecord,
    standardamount,
    standardtypeofunits,
    standardrateperunit,
    reimbursementcategory,
    calculationtype,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_reimbursements;

-- Superannuations View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_superannuations;
CREATE VIEW {etani_client_id}_payroll_nz_superannuations AS
SELECT
    id,
    name,
    category,
    liabilityaccountid,
    expenseaccountid,
    standardamount,
    percentage,
    calculationtypenz,
    companymax,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_superannuations;

-- PayRuns View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payruns;
CREATE VIEW {etani_client_id}_payroll_nz_payruns AS
SELECT
    payrunid,
    payrollcalendarid,
    periodstartdate,
    periodenddate,
    paymentdate,
    totalcost,
    totalpay,
    payrunstatus,
    payruntype,
    calendartype,
    posteddatetime,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payruns;

-- Pattern: {etani_client_id}_payroll_nz_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlips View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslips;
CREATE VIEW {etani_client_id}_payroll_nz_payslips AS
SELECT
    payslipid,
    employeeid,
    payrunid,
    lastedited,
    firstname,
    lastname,
    totalearnings,
    grossearnings,
    totalpay,
    totalemployertaxes,
    totalemployeetaxes,
    totaldeductions,
    totalreimbursements,
    totalstatutorydeductions,
    totalsuperannuation,
    bacshash,
    paymentmethod,
    earningslines,
    leaveearningslines,
    timesheetearningslines,
    deductionlines,
    reimbursementlines,
    leaveaccruallines,
    superannuationlines,
    paymentlines,
    employeetaxlines,
    employertaxlines,
    statutorydeductionlines,
    taxsettings,
    grossearningshistory,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslips;

-- Timesheets View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_timesheets;
CREATE VIEW {etani_client_id}_payroll_nz_timesheets AS
SELECT
    timesheetid,
    payrollcalendarid,
    employeeid,
    startdate,
    enddate,
    status,
    totalhours,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_timesheets;

-- PaySlipEarnLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipearnln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipearnln AS
SELECT
    payslipid,
    earningsrateid,
    rateperunit,
    numberofunits,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipearnln;

-- PaySlipDeductLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipdeductln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipdeductln AS
SELECT
    payslipid,
    deductiontypeid,
    calculationtype,
    percentage,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipdeductln;

-- PaySlipSupern View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipsupern;
CREATE VIEW {etani_client_id}_payroll_nz_payslipsupern AS
SELECT
    payslipid,
    superannuationid,
    calculationtype,
    percentage,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipsupern;

-- PaySlipLeaveEarnLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipleaveearnln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipleaveearnln AS
SELECT
    payslipid,
    earningsrateid,
    rateperunit,
    numberofunits,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipleaveearnln;

-- PaySlipTimesheetEarnLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_paysliptimesheetearnln;
CREATE VIEW {etani_client_id}_payroll_nz_paysliptimesheetearnln AS
SELECT
    payslipid,
    earningsrateid,
    rateperunit,
    numberofunits,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_paysliptimesheetearnln;

-- PaySlipReimbLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipreimbln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipreimbln AS
SELECT
    payslipid,
    reimbursementtypeid,
    description,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipreimbln;

-- PaySlipAccrual View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipaccrual;
CREATE VIEW {etani_client_id}_payroll_nz_payslipaccrual AS
SELECT
    payslipid,
    leavetypeid,
    numberofunits,
    autocalculate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipaccrual;

-- PaySlipPaymentLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslippaymentln;
CREATE VIEW {etani_client_id}_payroll_nz_payslippaymentln AS
SELECT
    payslipid,
    paymentmethod,
    amount,
    accountnumber,
    accountname,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslippaymentln;

-- Pattern: {etani_client_id}_payroll_nz_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySlipEmpTaxLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipemptaxln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipemptaxln AS
SELECT
    payslipid,
    taxlineid,
    description,
    amount,
    globaltaxtypeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipemptaxln;

-- PaySlipEmrTaxLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipemrtaxln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipemrtaxln AS
SELECT
    payslipid,
    taxlineid,
    description,
    amount,
    globaltaxtypeid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipemrtaxln;

-- PaySlipStatDeductLn View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_payslipstatdeductln;
CREATE VIEW {etani_client_id}_payroll_nz_payslipstatdeductln AS
SELECT
    payslipid,
    deductiontypeid,
    description,
    amount,
    liabilityamount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_payslipstatdeductln;

-- Settings View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_settings;
CREATE VIEW {etani_client_id}_payroll_nz_settings AS
SELECT
    id,
    accounts,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_settings;

-- StatutoryDeductions View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_statutorydeductions;
CREATE VIEW {etani_client_id}_payroll_nz_statutorydeductions AS
SELECT
    id,
    name,
    liabilityaccountid,
    statutorydeductioncategory,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_statutorydeductions;

-- SettingsAccounts View
DROP VIEW IF EXISTS {etani_client_id}_payroll_nz_settingsaccounts;
CREATE VIEW {etani_client_id}_payroll_nz_settingsaccounts AS
SELECT
    settingsid,
    accountid,
    type,
    code,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_nz_settingsaccounts;