-- PAYROLL_AU Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_payroll_au_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Employees Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeesstage (
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

-- EmployeeBankAccounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeebankaccountsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeebankaccountsstage (
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

-- EmployeeLeaveBalances Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeeleavebalancesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeeleavebalancesstage (
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

-- EmployeeSuperMemberships Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeesupermembershipsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeesupermembershipsstage (
    employeeid VARCHAR(255) NOT NULL,
    superfundid VARCHAR(255),
    employeenumber VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (superfundid)
);

-- paysliptimesheetearnln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_paysliptimesheetearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_paysliptimesheetearnlnstage (
    employeeid VARCHAR(255) NOT NULL,
    earningsrateid VARCHAR(255),
    amount DECIMAL(18,2),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (earningsrateid)
);

-- empopenballeaveln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_empopenballeavelnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_empopenballeavelnstage (
    employeeid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255),
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- emppaytplearnln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_emppaytplearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_emppaytplearnlnstage (
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

-- emppaytpldeductln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_emppaytpldeductlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_emppaytpldeductlnstage (
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

-- EmployeePayTplSuperLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeepaytplsuperlinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeepaytplsuperlinesstage (
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

-- EmpPayTplReimbLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_emppaytplreimblinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_emppaytplreimblinesstage (
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


-- Pattern: c{clientID}_{orgID}_payroll_au_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeePayTplLeaveLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_employeepaytplleavelinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_employeepaytplleavelinesstage (
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

-- LeaveApplications Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_leaveapplicationsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_leaveapplicationsstage (
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

-- LeaveApplicationPeriods Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_leaveapplicationperiodsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_leaveapplicationperiodsstage (
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

-- PayItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payitemsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payitemsstage (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PayItemsEarningsRates Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payitemsearningsratesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payitemsearningsratesstage (
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

-- PayItemsDeductionTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payitemsdeductiontypesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payitemsdeductiontypesstage (
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

-- payitemreimbtypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payitemreimbtypesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payitemreimbtypesstage (
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

-- PayItemsLeaveTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payitemsleavetypesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payitemsleavetypesstage (
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

-- PayrollCalendars Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payrollcalendarsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payrollcalendarsstage (
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

-- PayRuns Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payrunsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payrunsstage (
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

-- Pattern: c{clientID}_{orgID}_payroll_au_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunPayslips Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payrunpayslipsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payrunpayslipsstage (
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

-- Settings Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_settingsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_settingsstage (
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    accounts JSON,
    daysinpayrollyear VARCHAR(50),
    employeesarestp2 BOOLEAN,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SuperFunds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_superfundsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_superfundsstage (
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

-- Timesheets Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_timesheetsstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_timesheetsstage (
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

-- TimesheetLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_timesheetlinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_timesheetlinesstage (
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

-- Payslip Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipstage (
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

-- PayslipEarningsLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipearningslinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipearningslinesstage (
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

-- payslipleaveearnln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipleaveearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipleaveearnlnstage (
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

-- PayslipDeductionLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipdeductionlinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipdeductionlinesstage (
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

-- payslipreimbln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipreimblnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipreimblnstage (
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

-- Pattern: c{clientID}_{orgID}_payroll_au_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipTaxLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_paysliptaxlinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_paysliptaxlinesstage (
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

-- PayslipLeaveAccrualLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_payslipleaveaccruallinesstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_payslipleaveaccruallinesstage (
    payslipid VARCHAR(255) NOT NULL,
    leavetypeid VARCHAR(255) NOT NULL,
    numberofunits DECIMAL(18,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavetypeid)
);

-- empopenbalearnln Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_payroll_au_empopenbalearnlnstage;
CREATE TABLE c{clientID}_{orgID}_payroll_au_empopenbalearnlnstage (
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