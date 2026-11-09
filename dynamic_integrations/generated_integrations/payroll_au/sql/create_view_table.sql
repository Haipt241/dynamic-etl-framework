-- PAYROLL_AU Views - Auto Generated
-- Pattern: {etani_client_id}_payroll_au_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employees View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employees;
CREATE VIEW {etani_client_id}_payroll_au_employees AS
SELECT
    employeeid,
    title,
    firstname,
    lastname,
    status,
    email,
    dateofbirth,
    jobtitle,
    gender,
    homeaddressline1 AS `homeaddress.addressline1`,
    homeaddressline2 AS `homeaddress.addressline2`,
    homeaddresscity AS `homeaddress.city`,
    homeaddressregion AS `homeaddress.region`,
    homeaddresspostalcode AS `homeaddress.postalcode`,
    homeaddresscountry AS `homeaddress.country`,
    phone,
    mobile,
    startdate,
    classification,
    ordinaryearningsrateid,
    payrollcalendarid,
    updateddateutc,
    isauthorisedtoapproveleave,
    isauthorisedtoapprovetimesheets,
    taxdeclaustralianresident AS `taxdeclaration.australianresidentfortaxpurposes`,
    taxdecltaxfreethresholdclaimed AS `taxdeclaration.taxfreethresholdclaimed`,
    taxdeclhashelpdebt AS `taxdeclaration.hashelpdebt`,
    taxdeclhassfssdebt AS `taxdeclaration.hassfssdebt`,
    taxdeclhasstudentstartuploan AS `taxdeclaration.hasstudentstartuploan`,
    taxdeclhastradesupportloandebt AS `taxdeclaration.hastradesupportloandebt`,
    taxdeclhasloanorstudentdebt AS `taxdeclaration.hasloanorstudentdebt`,
    taxdecleligibleleaveloading AS `taxdeclaration.eligibletoreceiveleaveloading`,
    taxdeclupdateddateutc AS `taxdeclaration.updateddateutc`,
    taxdeclresidencystatus AS `taxdeclaration.residencystatus`,
    openingbalancedate AS `openingbalances.openingbalancedate`,
    openingbalancetax AS `openingbalances.tax`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employees;

-- EmployeeBankAccounts View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employeebankaccounts;
CREATE VIEW {etani_client_id}_payroll_au_employeebankaccounts AS
SELECT
    employeeid AS `employeesid`,
    statementtext,
    accountname,
    bsb,
    accountnumber,
    remainder,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employeebankaccounts;

-- EmployeeLeaveBalances View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employeeleavebalances;
CREATE VIEW {etani_client_id}_payroll_au_employeeleavebalances AS
SELECT
    employeeid AS `employeesid`,
    leavename,
    leavetypeid,
    numberofunits,
    typeofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employeeleavebalances;

-- EmployeeSuperMemberships View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employeesupermemberships;
CREATE VIEW {etani_client_id}_payroll_au_employeesupermemberships AS
SELECT
    employeeid AS `employeesid`,
    superfundid,
    employeenumber,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employeesupermemberships;

-- paysliptimesheetearnln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_paysliptimesheetearnln;
CREATE VIEW {etani_client_id}_payroll_au_paysliptimesheetearnln AS
SELECT
    employeeid AS `employeesid`,
    earningsrateid,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_paysliptimesheetearnln;

-- empopenballeaveln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_empopenballeaveln;
CREATE VIEW {etani_client_id}_payroll_au_empopenballeaveln AS
SELECT
    employeeid AS `employeesid`,
    leavetypeid,
    numberofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_empopenballeaveln;

-- emppaytplearnln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_emppaytplearnln;
CREATE VIEW {etani_client_id}_payroll_au_emppaytplearnln AS
SELECT
    employeeid AS `employeesid`,
    earningsrateid,
    rateperunit,
    numberofunits,
    fixedamount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_emppaytplearnln;

-- emppaytpldeductln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_emppaytpldeductln;
CREATE VIEW {etani_client_id}_payroll_au_emppaytpldeductln AS
SELECT
    employeeid AS `employeesid`,
    deductiontypeid,
    calculationtype,
    amount,
    percentage,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_emppaytpldeductln;

-- EmployeePayTplSuperLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employeepaytplsuperlines;
CREATE VIEW {etani_client_id}_payroll_au_employeepaytplsuperlines AS
SELECT
    employeeid AS `employeesid`,
    supermembershipid,
    contributiontype,
    calculationtype,
    amount,
    percentage,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employeepaytplsuperlines;

-- EmpPayTplReimbLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_emppaytplreimblines;
CREATE VIEW {etani_client_id}_payroll_au_emppaytplreimblines AS
SELECT
    employeeid AS `employeesid`,
    reimbursementtypeid,
    description,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_emppaytplreimblines;


-- Pattern: {etani_client_id}_payroll_au_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeePayTplLeaveLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_employeepaytplleavelines;
CREATE VIEW {etani_client_id}_payroll_au_employeepaytplleavelines AS
SELECT
    employeeid AS `employeesid`,
    leavetypeid,
    calculationtype,
    annualnumberofunits,
    fulltimenumberofunitsperperiod,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_employeepaytplleavelines;

-- LeaveApplications View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_leaveapplications;
CREATE VIEW {etani_client_id}_payroll_au_leaveapplications AS
SELECT
    clientid,
    organisationid,
    leaveapplicationid,
    employeeid,
    leavetypeid,
    title,
    startdate,
    enddate,
    updateddateutc,
    payouttype,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_leaveapplications;

-- LeaveApplicationPeriods View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_leaveapplicationperiods;
CREATE VIEW {etani_client_id}_payroll_au_leaveapplicationperiods AS
SELECT
    leaveapplicationid AS `leaveapplicationsid`,
    payperiodstartdate,
    payperiodenddate,
    leaveperiodstatus,
    numberofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_leaveapplicationperiods;

-- PayItems View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payitems;
CREATE VIEW {etani_client_id}_payroll_au_payitems AS
SELECT
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payitems;

-- PayItemsEarningsRates View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payitemsearningsrates;
CREATE VIEW {etani_client_id}_payroll_au_payitemsearningsrates AS
SELECT
    earningsrateid,
    name,
    earningstype,
    ratetype,
    accountcode,
    typeofunits,
    multiplier,
    amount,
    isexemptfromtax,
    isexemptfromsuper,
    accrueleave,
    isreportableasw1,
    employmentterminationpaymenttype,
    updateddateutc,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payitemsearningsrates;

-- PayItemsDeductionTypes View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payitemsdeductiontypes;
CREATE VIEW {etani_client_id}_payroll_au_payitemsdeductiontypes AS
SELECT
    deductiontypeid,
    deductioncategory,
    name,
    accountcode,
    reducestax,
    reducessuper,
    isexemptfromw1,
    updateddateutc,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payitemsdeductiontypes;

-- payitemreimbtypes View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payitemreimbtypes;
CREATE VIEW {etani_client_id}_payroll_au_payitemreimbtypes AS
SELECT
    reimbursementtypeid,
    name,
    accountcode,
    updateddateutc,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payitemreimbtypes;

-- PayItemsLeaveTypes View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payitemsleavetypes;
CREATE VIEW {etani_client_id}_payroll_au_payitemsleavetypes AS
SELECT
    leavetypeid,
    name,
    typeofunits,
    normalentitlement,
    leaveloadingrate,
    ispaidleave,
    showonpayslip,
    leavecategorycode,
    sgcexempt,
    updateddateutc,
    currentrecord,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payitemsleavetypes;

-- PayrollCalendars View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payrollcalendars;
CREATE VIEW {etani_client_id}_payroll_au_payrollcalendars AS
SELECT
    payrollcalendarid,
    clientid,
    organisationid,
    name,
    calendartype,
    startdate,
    paymentdate,
    updateddateutc,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payrollcalendars;

-- PayRuns View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payruns;
CREATE VIEW {etani_client_id}_payroll_au_payruns AS
SELECT
    payrunid,
    clientid,
    organisationid,
    payrollcalendarid,
    payrunperiodstartdate,
    payrunperiodenddate,
    paymentdate,
    wages,
    deductions,
    tax,
    super,
    reimbursement,
    netpay,
    payrunstatus,
    updateddateutc,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payruns;

-- Pattern: {etani_client_id}_payroll_au_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunPayslips View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payrunpayslips;
CREATE VIEW {etani_client_id}_payroll_au_payrunpayslips AS
SELECT
    payrunid AS `payrunsid`,
    employeeid,
    payslipid,
    firstname,
    lastname,
    wages,
    deductions,
    tax,
    super,
    reimbursements,
    netpay,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payrunpayslips;

-- Settings View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_settings;
CREATE VIEW {etani_client_id}_payroll_au_settings AS
SELECT
    clientid,
    organisationid,
    accounts,
    daysinpayrollyear,
    employeesarestp2,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_settings;

-- SuperFunds View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_superfunds;
CREATE VIEW {etani_client_id}_payroll_au_superfunds AS
SELECT
    clientid,
    organisationid,
    superfundid,
    name,
    type,
    usi,
    updateddateutc,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_superfunds;

-- Timesheets View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_timesheets;
CREATE VIEW {etani_client_id}_payroll_au_timesheets AS
SELECT
    clientid,
    organisationid,
    timesheetid,
    employeeid,
    startdate,
    enddate,
    status,
    hours,
    updateddateutc,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_timesheets;

-- TimesheetLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_timesheetlines;
CREATE VIEW {etani_client_id}_payroll_au_timesheetlines AS
SELECT
    timesheetid AS `timesheetsid`,
    earningsrateid,
    numberofunits,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_timesheetlines;

-- Payslip View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslip;
CREATE VIEW {etani_client_id}_payroll_au_payslip AS
SELECT
    payslipid,
    employeeid,
    firstname,
    lastname,
    lastedited,
    tax,
    netpay,
    updateddateutc,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslip;

-- PayslipEarningsLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslipearningslines;
CREATE VIEW {etani_client_id}_payroll_au_payslipearningslines AS
SELECT
    payslipid AS `payslipsid`,
    earningsrateid,
    rateperunit,
    numberofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslipearningslines;

-- payslipleaveearnln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslipleaveearnln;
CREATE VIEW {etani_client_id}_payroll_au_payslipleaveearnln AS
SELECT
    payslipid AS `payslipsid`,
    earningsrateid,
    rateperunit,
    numberofunits,
    payouttype,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslipleaveearnln;

-- PayslipDeductionLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslipdeductionlines;
CREATE VIEW {etani_client_id}_payroll_au_payslipdeductionlines AS
SELECT
    payslipid AS `payslipsid`,
    deductiontypeid,
    amount,
    calculationtype,
    percentage,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslipdeductionlines;

-- payslipreimbln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslipreimbln;
CREATE VIEW {etani_client_id}_payroll_au_payslipreimbln AS
SELECT
    payslipid AS `payslipsid`,
    reimbursementtypeid,
    description,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslipreimbln;

-- Pattern: {etani_client_id}_payroll_au_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipTaxLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_paysliptaxlines;
CREATE VIEW {etani_client_id}_payroll_au_paysliptaxlines AS
SELECT
    payslipid AS `payslipsid`,
    paysliptaxlineid,
    taxtypename,
    description,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_paysliptaxlines;

-- PayslipLeaveAccrualLines View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_payslipleaveaccruallines;
CREATE VIEW {etani_client_id}_payroll_au_payslipleaveaccruallines AS
SELECT
    payslipid AS `payslipsid`,
    leavetypeid,
    numberofunits,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_payslipleaveaccruallines;

-- empopenbalearnln View
DROP VIEW IF EXISTS {etani_client_id}_payroll_au_empopenbalearnln;
CREATE VIEW {etani_client_id}_payroll_au_empopenbalearnln AS
SELECT
    payslipid AS `payslipsid`,
    supermembershipid,
    contributiontype,
    calculationtype,
    amount,
    percentage,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_payroll_au_empopenbalearnln;