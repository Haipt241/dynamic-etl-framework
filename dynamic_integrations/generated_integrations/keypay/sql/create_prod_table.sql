-- KEYPAY Production Tables - Auto Generated
-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Business Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_business;
CREATE TABLE c{clientID}_keypay_business (
    id VARCHAR(255) NOT NULL,
    abn VARCHAR(255),
    addressline1 VARCHAR(255),
    addressline2 VARCHAR(255),
    budgetentrymethod VARCHAR(255),
    budgetwarningpercent DOUBLE,
    contactemailaddress VARCHAR(255),
    contactfaxnumber VARCHAR(255),
    contactname VARCHAR(255),
    contactphonenumber VARCHAR(255),
    datecreated DATETIME,
    defaultsuperrate DOUBLE,
    endofweek VARCHAR(255),
    externalid VARCHAR(255),
    foreignentitycountry VARCHAR(255),
    industryname VARCHAR(255),
    initialfinancialyearstart INT,
    isforeignentity BOOLEAN,
    journalservice VARCHAR(255),
    leaveaccrualstartdatetype VARCHAR(255),
    leaveyearstart DATETIME,
    legalname VARCHAR(255),
    managementsoftwareid VARCHAR(255),
    managerscaneditrosterbudgets BOOLEAN,
    name VARCHAR(255),
    numberofemployees VARCHAR(255),
    paycyclefrequency VARCHAR(255),
    postcode VARCHAR(255),
    promocode VARCHAR(255),
    region VARCHAR(255),
    sbrsoftwareid VARCHAR(255),
    sbrsoftwareprovider VARCHAR(255),
    source VARCHAR(255),
    standardhoursperday DOUBLE,
    state VARCHAR(255),
    suburb VARCHAR(255),
    whitelabelid VARCHAR(255),
    whitelabelname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Employee Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employee;
CREATE TABLE c{clientID}_keypay_employee (
    id VARCHAR(255) NOT NULL,
    anniversarydate DATETIME,
    australianresident BOOLEAN,
    automaticallyapplypublicholidaynotworkedearningslines BOOLEAN,
    automaticallypayemployee TEXT,
    awardid VARCHAR(255),
    bankaccount1accountname TEXT,
    bankaccount1accountnumber TEXT,
    bankaccount1allocatedpercentage DECIMAL(18,2),
    bankaccount1bsb TEXT,
    bankaccount1fixedamount DECIMAL(18,2),
    bankaccount2accountname TEXT,
    bankaccount2accountnumber TEXT,
    bankaccount2allocatedpercentage DECIMAL(18,2),
    bankaccount2bsb TEXT,
    bankaccount2fixedamount DECIMAL(18,2),
    bankaccount3accountname TEXT,
    bankaccount3accountnumber TEXT,
    bankaccount3allocatedpercentage DECIMAL(18,2),
    bankaccount3bsb TEXT,
    bankaccount3fixedamount DECIMAL(18,2),
    businessawardpackage TEXT,
    claimmedicarelevyreduction BOOLEAN,
    claimtaxfreethreshold BOOLEAN,
    closelyheldemployee BOOLEAN,
    closelyheldreporting TEXT,
    contractorabn TEXT,
    datecreated DATETIME,
    dateofbirth DATETIME,
    datetaxfiledeclarationreported DATETIME,
    datetaxfiledeclarationsigned DATETIME,
    disableautoprogression BOOLEAN,
    dvlpayslipdescription TEXT,
    emailaddress TEXT,
    emergencycontact1address TEXT,
    emergencycontact1alternatecontactnumber TEXT,
    emergencycontact1contactnumber TEXT,
    emergencycontact1name TEXT,
    emergencycontact1relationship TEXT,
    emergencycontact2address TEXT,
    emergencycontact2alternatecontactnumber TEXT,
    emergencycontact2contactnumber TEXT,
    emergencycontact2name TEXT,
    emergencycontact2relationship TEXT,
    employingentityabn TEXT,
    employingentityid VARCHAR(255),
    employmentagreement TEXT,
    employmentagreementid VARCHAR(255),
    employmenttype VARCHAR(255),
    enddate DATETIME,
    externalid VARCHAR(255),
    firstname TEXT,
    gender VARCHAR(255),
    hasapprovedworkingholidayvisa BOOLEAN,
    haswithholdingvariation BOOLEAN,
    homephone TEXT,
    hoursperday DECIMAL(18,2),
    hoursperweek DECIMAL(18,2),
    includeinportablelongserviceleavereport BOOLEAN,
    isenabledfortimesheets TEXT,
    isexemptfromfloodlevy BOOLEAN,
    isexemptfrompayrolltax BOOLEAN,
    isseasonalworker BOOLEAN,
    jobtitle TEXT,
    leaveaccrualstartdatetype VARCHAR(255),
    leavetemplate TEXT,
    leaveyearstart DATETIME,
    locations TEXT,
    maximumquarterlysupercontributionsbase DECIMAL(18,2),
    medicarelevyexemption TEXT,
    medicarelevyreductiondependentcount INT,
    medicarelevyreductionspouse BOOLEAN,
    medicarelevysurchargewithholdingtier TEXT,
    middlename VARCHAR(255),
    mobilephone TEXT,
    othertaxoffset BOOLEAN,
    overridetemplaterate VARCHAR(255),
    payconditionruleset TEXT,
    payratetemplate TEXT,
    payschedule TEXT,
    payslipnotificationtype VARCHAR(255),
    portablelongserviceleaveid VARCHAR(255),
    postaladdressisoverseas BOOLEAN,
    postaladdressline2 TEXT,
    postalcountry TEXT,
    postalpostcode VARCHAR(255),
    postalstate VARCHAR(255),
    postalstreetaddress TEXT,
    postalsuburb TEXT,
    preferredname TEXT,
    previoussurname TEXT,
    primarylocation TEXT,
    primarypaycategory TEXT,
    rate DECIMAL(18,2),
    rateunit TEXT,
    reportingdimensionvalues TEXT,
    residentialaddressisoverseas BOOLEAN,
    residentialaddressline2 VARCHAR(255),
    residentialcountry VARCHAR(255),
    residentialpostcode VARCHAR(255),
    residentialstate VARCHAR(255),
    residentialstreetaddress VARCHAR(255),
    residentialsuburb VARCHAR(255),
    rosteringnotificationchoices TEXT,
    seniorstaxoffset BOOLEAN,
    singletouchpayroll TEXT,
    startdate DATETIME,
    status VARCHAR(255),
    stsldebt BOOLEAN,
    superfund1allocatedpercentage DECIMAL(18,2),
    superfund1employernominatedfund BOOLEAN,
    superfund1fixedamount DECIMAL(18,2),
    superfund1fundname TEXT,
    superfund1membernumber TEXT,
    superfund1productcode VARCHAR(255),
    superfund2allocatedpercentage DECIMAL(18,2),
    superfund2employernominatedfund BOOLEAN,
    superfund2fixedamount DECIMAL(18,2),
    superfund2fundname TEXT,
    superfund2membernumber TEXT,
    superfund2productcode VARCHAR(255),
    superfund3allocatedpercentage DECIMAL(18,2),
    superfund3employernominatedfund BOOLEAN,
    superfund3fixedamount DECIMAL(18,2),
    superfund3fundname TEXT,
    superfund3membernumber TEXT,
    superfund3productcode VARCHAR(255),
    superthresholdamount DECIMAL(18,2),
    surname TEXT,
    tags TEXT,
    taxcategory TEXT,
    taxfilenumber TEXT,
    taxvariation DECIMAL(18,2),
    terminationreason TEXT,
    title TEXT,
    workphone TEXT,
    worktypes VARCHAR(255),
    workingholidayvisacountry VARCHAR(255),
    workingholidayvisastartdate DATETIME,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRun Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrun;
CREATE TABLE c{clientID}_keypay_payrun (
    datefinalised DATETIME,
    datepaid DATETIME,
    externalid VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    isfinalised BOOLEAN,
    notation VARCHAR(255),
    payperiodending DATETIME,
    payperiodstarting DATETIME,
    payscheduleid INT,
    payslipspublished BOOLEAN,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusinessAccess Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_businessaccess;
CREATE TABLE c{clientID}_keypay_businessaccess (
    accesstype VARCHAR(255),
    email VARCHAR(255),
    name VARCHAR(255),
    kioskaccesstype VARCHAR(255),
    kioskpermissions VARCHAR(500),
    payrollapproveelectronic BOOLEAN,
    payrollapprovalaccess VARCHAR(255),
    payrollcreationaccess VARCHAR(255),
    payrollbusinessrestrictions INT,
    reportsaccesstype VARCHAR(255),
    reportsnorestriction BOOLEAN,
    reportsspecific VARCHAR(1000),
    id VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusinessDocument Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_businessdocument;
CREATE TABLE c{clientID}_keypay_businessdocument (
    id VARCHAR(255) NOT NULL,
    datecreated DATETIME,
    friendlyname VARCHAR(255),
    requiresemployeeacknowledgement BOOLEAN,
    sendinitialnotificationon DATETIME,
    sendnotificationimmediately BOOLEAN,
    sendnotificationtoemployee BOOLEAN,
    sendremindereveryxdays INT,
    visibletoallemployees BOOLEAN,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Invoice Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_invoice;
CREATE TABLE c{clientID}_keypay_invoice (
    id VARCHAR(255) NOT NULL,
    culturename VARCHAR(255),
    currency VARCHAR(255),
    date DATETIME,
    gst DOUBLE,
    invoicenumber VARCHAR(255),
    totalexcludinggst DOUBLE,
    totalincludinggst DOUBLE,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Location Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_location;
CREATE TABLE c{clientID}_keypay_location (
    id VARCHAR(255) NOT NULL,
    country VARCHAR(255),
    externalaccountinglocationid VARCHAR(255),
    externalid VARCHAR(255),
    fullyqualifiedname VARCHAR(255),
    generalledgermappingcode VARCHAR(255),
    isglobal BOOLEAN,
    isrollupreportinglocation BOOLEAN,
    name VARCHAR(255),
    parentid VARCHAR(255),
    source VARCHAR(255),
    state VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccounts Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccounts;
CREATE TABLE c{clientID}_keypay_chartofaccounts (
    complete BOOLEAN,
    defexpenseaccountid INT,
    defexpensesplitbyempentity BOOLEAN,
    defexpensesplitbylocation BOOLEAN,
    defliabilityaccountid INT,
    defliabilitysplitbyempentity BOOLEAN,
    defliabilitysplitbylocation BOOLEAN,
    empexpenseaccountid INT,
    empexpensesplitbyempentity BOOLEAN,
    empexpensesplitbylocation BOOLEAN,
    paymentaccountid INT,
    paymentaccsplitbyempentity BOOLEAN,
    paymentaccsplitbylocation BOOLEAN,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (organisationid)
);

-- PayRunDeductions Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrundeductions;
CREATE TABLE c{clientID}_keypay_payrundeductions (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- PayRunEarningsLines Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrunearningslines;
CREATE TABLE c{clientID}_keypay_payrunearningslines (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);


-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEmpExpenses Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrunempexpenses;
CREATE TABLE c{clientID}_keypay_payrunempexpenses (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- EmployeeLeaveAllowances Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employeeleaveallowances;
CREATE TABLE c{clientID}_keypay_employeeleaveallowances (
    automaticallyaccrues BOOLEAN,
    canapplyforleave BOOLEAN,
    hoursperyear DECIMAL(10,4),
    leaveaccrualruleaccrualtype VARCHAR(255),
    leaveaccrualruleaccrueinadvance BOOLEAN,
    leaveaccrualrulecaptype VARCHAR(255),
    leaveaccrualrulecarryoveramount DOUBLE,
    leaveaccrualrulecarryoverbehaviour VARCHAR(255),
    leaveaccrualruleid INT,
    leaveaccrualruleleaveyearoffsetamount INT,
    leaveaccrualruleunitcap DOUBLE,
    leavecategoryid VARCHAR(255),
    leavecategoryname VARCHAR(255),
    leaveloading DECIMAL(10,4),
    leaveunittype VARCHAR(255),
    unittype VARCHAR(255),
    units DECIMAL(10,4),
    employeeid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (leavecategoryid, employeeid)
);

-- EmployeeGroup Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employeegroup;
CREATE TABLE c{clientID}_keypay_employeegroup (
    id VARCHAR(255) NOT NULL,
    filtercombinationstrategy VARCHAR(255),
    name VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployerLiabilities Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employerliabilities;
CREATE TABLE c{clientID}_keypay_employerliabilities (
    payrunid INT NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- LeaveCategory Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_leavecategory;
CREATE TABLE c{clientID}_keypay_leavecategory (
    id VARCHAR(255) NOT NULL,
    accruesfirstpayrunperperiodonly BOOLEAN,
    automaticallyaccrues BOOLEAN,
    contingentperiod DECIMAL(10,4),
    deductfrompaycategoryid VARCHAR(255),
    deductfromprimarypaycategory BOOLEAN,
    entitlementperiod DECIMAL(10,4),
    excludefromterminationpayout BOOLEAN,
    externalid VARCHAR(255),
    hideaccrualsonpayslip BOOLEAN,
    isbalanceuntracked BOOLEAN,
    isnameprivate BOOLEAN,
    isprivate BOOLEAN,
    leaveaccrualruleaccrualtype VARCHAR(255),
    leaveaccrualruleaccrueinadvance BOOLEAN,
    leaveaccrualrulecaptype VARCHAR(255),
    leaveaccrualrulecarryoveramount DOUBLE,
    leaveaccrualrulecarryoverbehaviour VARCHAR(255),
    leaveaccrualruleid INT,
    leaveaccrualruleleaveyearoffsetamount INT,
    leaveaccrualruleunitcap DOUBLE,
    leavecategorytype VARCHAR(255),
    leaveentitlementcarryoveramount DOUBLE,
    leaveentitlementcarryovertype VARCHAR(255),
    leaveentitlementforfeitureamount DOUBLE,
    leaveentitlementforfeituremonthsstartafter INT,
    leaveentitlementforfeituretype VARCHAR(255),
    leaveentitlementid INT,
    leaveentitlementisprorata BOOLEAN,
    leaveentitlementleavebalancetype VARCHAR(255),
    leaveentitlementstandardallowanceunittype VARCHAR(255),
    leaveentitlementstandardallowanceunittypeamount DOUBLE,
    leaveloading DECIMAL(10,4),
    leaveunittype VARCHAR(255),
    name VARCHAR(255),
    payoutasetp BOOLEAN,
    preventnegativebalanceunpaidleavecategoryid VARCHAR(255),
    source VARCHAR(255),
    transferonterminationtopaycategoryid VARCHAR(255),
    transfertopaycategoryid VARCHAR(255),
    unittype VARCHAR(255),
    units DECIMAL(10,4),
    usedeductfrompaycategoryrate BOOLEAN,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusinessABA Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_businessaba;
CREATE TABLE c{clientID}_keypay_businessaba (
    id VARCHAR(255) NOT NULL,
    accountname VARCHAR(255),
    accountnumber VARCHAR(255),
    balanceadditionalcontent VARCHAR(255),
    balancelodgementreference VARCHAR(255),
    bsb VARCHAR(255),
    financialinstitutioncode VARCHAR(255),
    includeselfbalancingtransaction BOOLEAN,
    lodgementreference VARCHAR(255),
    mergemultipleaccountpayments BOOLEAN,
    paymentadditionalcontent VARCHAR(255),
    userid VARCHAR(255),
    username VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BillingPlan Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_billingplan;
CREATE TABLE c{clientID}_keypay_billingplan (
    id VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    functionawards VARCHAR(255),
    functionemployeeonboarding VARCHAR(255),
    functionpayconditions VARCHAR(255),
    functionrostering VARCHAR(255),
    functiontimeandattendance VARCHAR(255),
    includedemployees INT,
    ishidden BOOLEAN,
    name VARCHAR(255),
    pricepersms DOUBLE,
    priceperunit DOUBLE,
    superinclusion VARCHAR(255),
    type VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- DeductionCategory Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_deductioncategory;
CREATE TABLE c{clientID}_keypay_deductioncategory (
    id VARCHAR(255) NOT NULL,
    expensegeneralledgermappingcode VARCHAR(255),
    externalid VARCHAR(255),
    isresc BOOLEAN,
    issystem BOOLEAN,
    liabilitygeneralledgermappingcode VARCHAR(255),
    name VARCHAR(255),
    paymentsummaryclassification VARCHAR(255),
    sgccalculationimpact VARCHAR(255),
    source VARCHAR(255),
    taxexempt BOOLEAN,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeExpenseCategory Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employeeexpensecategory;
CREATE TABLE c{clientID}_keypay_employeeexpensecategory (
    id VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    externalid VARCHAR(255),
    externalreferenceid VARCHAR(255),
    externaltaxcodeid VARCHAR(255),
    generalledgermappingcode VARCHAR(255),
    name VARCHAR(255),
    taxcode VARCHAR(255),
    taxrate DECIMAL(10,4),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PaygAdjustments Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_paygadjustments;
CREATE TABLE c{clientID}_keypay_paygadjustments (
    payrunid INT NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (clientid, organisationid)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRateTemplate Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payratetemplate;
CREATE TABLE c{clientID}_keypay_payratetemplate (
    externalid VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    maxquarterlysupercontribbase DECIMAL(18,2),
    name VARCHAR(255),
    primarypaycategoryid INT,
    reapplytolinkedemployees BOOLEAN,
    source VARCHAR(255),
    superthresholdamount DECIMAL(18,2),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRunTotals Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payruntotals;
CREATE TABLE c{clientID}_keypay_payruntotals (
    payrunid INT NOT NULL,
    payruntotalsemployercontribution DOUBLE,
    payruntotalsgrossearnings DOUBLE,
    payruntotalshelpwithheld DOUBLE,
    payruntotalsid INT,
    payruntotalsispublished BOOLEAN,
    payruntotalsnetearnings DOUBLE,
    payruntotalsnotation VARCHAR(255),
    payruntotalspaygwithheld DOUBLE,
    payruntotalsposttaxdeductions DOUBLE,
    payruntotalspretaxdeductions DOUBLE,
    payruntotalssfsswithheld DOUBLE,
    payruntotalssupercontribution DOUBLE,
    payruntotalstaxableearnings DOUBLE,
    payruntotalstotalemployeeexpenses DOUBLE,
    payruntotalstotalemployerliabilities DOUBLE,
    payruntotalstotalhours DOUBLE,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (clientid, organisationid)
);

-- Accounts Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_accounts;
CREATE TABLE c{clientID}_keypay_accounts (
    id VARCHAR(255) NOT NULL,
    accountcode VARCHAR(255),
    accountname VARCHAR(255),
    accounttype VARCHAR(255),
    externalreferenceid VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LeaveRequest Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_leaverequest;
CREATE TABLE c{clientID}_keypay_leaverequest (
    id VARCHAR(255) NOT NULL,
    attachmentid VARCHAR(255),
    employee VARCHAR(255),
    employeeid VARCHAR(255),
    fromdate DATETIME,
    hoursapplied DECIMAL(10,4),
    leavecategory VARCHAR(255),
    leavecategoryid VARCHAR(255),
    notes TEXT,
    status VARCHAR(255),
    todate DATETIME,
    totalhours DECIMAL(10,4),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayCategory Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_paycategory;
CREATE TABLE c{clientID}_keypay_paycategory (
    id VARCHAR(255) NOT NULL,
    accruesleave BOOLEAN,
    allowancedescription VARCHAR(500),
    awardid VARCHAR(255),
    awardname VARCHAR(255),
    defaultsuperrate DECIMAL(10,4),
    externalid VARCHAR(255),
    generalledgermappingcode VARCHAR(255),
    hideunitsonpayslip BOOLEAN,
    ispayrolltaxexempt BOOLEAN,
    isprimary BOOLEAN,
    issystempaycategory BOOLEAN,
    istaxexempt BOOLEAN,
    name VARCHAR(255),
    numberofdecimalplaces INT,
    parentid VARCHAR(255),
    paycategorytype VARCHAR(255),
    paymentsummaryclassification VARCHAR(255),
    penaltyloadingpercent DECIMAL(10,4),
    rateloadingpercent DECIMAL(10,4),
    rateunit VARCHAR(255),
    roundingmethod VARCHAR(255),
    source VARCHAR(255),
    superexpensemappingcode VARCHAR(255),
    superliabilitymappingcode VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeePayRate Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employeepayrate;
CREATE TABLE c{clientID}_keypay_employeepayrate (
    accruesleave BOOLEAN,
    calculatedrate DECIMAL(18,2),
    hassuperrateoverride BOOLEAN,
    isprimarypaycategory BOOLEAN,
    paycategoryid INT,
    paycategoryname VARCHAR(255),
    rate DECIMAL(18,2),
    rateunit VARCHAR(255),
    superrate DECIMAL(18,2),
    employeeid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeeid)
);

-- PayRunSummary Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrunsummary;
CREATE TABLE c{clientID}_keypay_payrunsummary (
    datefinalised DATETIME,
    datepaid DATETIME,
    externalid VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    isfinalised BOOLEAN,
    notation VARCHAR(255),
    payperiodending DATETIME,
    payperiodstarting DATETIME,
    payscheduleid INT,
    payslipspublished BOOLEAN,
    totalgrosswages DECIMAL(18,2),
    totalhours DECIMAL(18,2),
    totalnetwages DECIMAL(18,2),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PaySchedule Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedule;
CREATE TABLE c{clientID}_keypay_payschedule (
    abadetailsid INT,
    autopayconfigadjustdatepaidtoworkday BOOLEAN,
    autopayconfigadjustrundatetoworkday BOOLEAN,
    autopayconfigdayofweek INT,
    autopayconfigenabled BOOLEAN,
    autopayconfigexportjournals BOOLEAN,
    autopayconfigfinalise BOOLEAN,
    autopayconfiginitialdatepaid DATETIME,
    autopayconfiginitialpayperiodending DATETIME,
    autopayconfiginitialpayruncreationdatetime DATETIME,
    autopayconfiglodgepayrun BOOLEAN,
    autopayconfignextscheduledcreationdatetime DATETIME,
    autopayconfigpaused BOOLEAN,
    autopayconfigpublishpayslips VARCHAR(255),
    autopayconfigpublishpayslipshour INT,
    autopayconfigrunonspecificdayofmonth BOOLEAN,
    autopayconfigscheduledenddate DATETIME,
    autopayconfigspecificdayofmonth INT,
    autopayconfigsuppressnotifications BOOLEAN,
    autopayconfigtimesheetimportoption VARCHAR(255),
    autopayconfigweekofmonth INT,
    defaultfinaliseexportjournals VARCHAR(255),
    defaultfinaliseexportjournalsday INT,
    defaultfinaliseexportjournalstimeofday VARCHAR(255),
    defaultfinaliseexportjournalstimeline VARCHAR(255),
    defaultfinaliselodgepayrun VARCHAR(255),
    defaultfinaliselodgepayrunday INT,
    defaultfinaliselodgepayruntimeofday VARCHAR(255),
    defaultfinaliselodgepayruntimeline VARCHAR(255),
    defaultfinalisepaymentacctdebitsetting VARCHAR(255),
    defaultfinalisepublishpayslips VARCHAR(255),
    defaultfinalisepublishpayslipsday INT,
    defaultfinalisepublishpayslipstimeofday VARCHAR(255),
    defaultfinalisepublishpayslipstimeline VARCHAR(255),
    defaultfinaliserunreportpacks VARCHAR(255),
    defaultfinaliserunreportpacksday INT,
    defaultfinaliserunreportpackstimeofday VARCHAR(255),
    defaultfinaliserunreportpackstimeline VARCHAR(255),
    defaultfinalisesubmittopensionsync VARCHAR(255),
    defaultfinalisesubmittopensionsyncday INT,
    defaultfinalisesubmittopensionsynctimeofday VARCHAR(255),
    defaultfinalisesubmittopensionsynctimeline VARCHAR(255),
    defaultfinalisesuperpayment BOOLEAN,
    defaultfinalisesuppressnotifications BOOLEAN,
    employeeselectionstrategy VARCHAR(255),
    equalmonthlypayments BOOLEAN,
    externalid VARCHAR(255),
    frequency VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    lastdatepaid DATETIME,
    lastpayrun DATETIME,
    name VARCHAR(255),
    payschedapprovalnotificationsubject VARCHAR(255),
    payschedapprovalnotificationtemplate VARCHAR(1000),
    payschedapprovalreminderday INT,
    payschedapprovalremindersubject VARCHAR(255),
    payschedapprovalremindertemplate VARCHAR(1000),
    payschedapprovalrequireapproval BOOLEAN,
    payschedapprovalsendreminder BOOLEAN,
    payschedpaymentapprovalnotificationsubject VARCHAR(255),
    payschedpaymentapprovalnotificationtemplate VARCHAR(1000),
    payschedpaymentapprovalreminderday INT,
    payschedpaymentapprovalremindersubject VARCHAR(255),
    payschedpaymentapprovalremindertemplate VARCHAR(1000),
    payschedpaymentapprovalrequireapproval BOOLEAN,
    payschedpaymentapprovalsendreminder BOOLEAN,
    paygaccountbsb VARCHAR(255),
    paygaccountname VARCHAR(255),
    paygaccountnumber VARCHAR(255),
    paygreference VARCHAR(255),
    source VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Payslip Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslip;
CREATE TABLE c{clientID}_keypay_payslip (
    id VARCHAR(255) NOT NULL,
    abn VARCHAR(255),
    basepayrate VARCHAR(255),
    baserate VARCHAR(255),
    businessaddress TEXT,
    businessname VARCHAR(255),
    contactname VARCHAR(255),
    employeebaserate DECIMAL(19,4),
    employeebaserateunit VARCHAR(255),
    employeeexternalid VARCHAR(255),
    employeefirstname VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employeepostaladdresscountry VARCHAR(255),
    employeepostaladdressline2 VARCHAR(255),
    employeepostalstreetaddress VARCHAR(255),
    employeepostalsuburbname VARCHAR(255),
    employeepostalsuburbpostcode VARCHAR(255),
    employeepostalsuburbstate VARCHAR(255),
    employeesurname VARCHAR(255),
    grossearnings DECIMAL(19,4),
    grossytd DECIMAL(19,4),
    helpamount DECIMAL(19,4),
    helpytd DECIMAL(19,4),
    hourlyrate DECIMAL(19,4),
    ispublished BOOLEAN,
    message TEXT,
    netearnings DECIMAL(19,4),
    netytd DECIMAL(19,4),
    notation TEXT,
    payperiodending VARCHAR(255),
    payperiodstarting VARCHAR(255),
    paygwithholdingamount DECIMAL(19,4),
    paygytd DECIMAL(19,4),
    posttaxdeductionamount DECIMAL(19,4),
    posttaxdeductionsytd DECIMAL(19,4),
    pretaxdeductionamount DECIMAL(19,4),
    pretaxdeductionsytd DECIMAL(19,4),
    sfssamount DECIMAL(19,4),
    sfssytd DECIMAL(19,4),
    supercontribution DECIMAL(19,4),
    superytd DECIMAL(19,4),
    taxableearnings DECIMAL(19,4),
    totalhours DECIMAL(19,4),
    withholdingytd DECIMAL(19,4),
    businessid VARCHAR(255) NOT NULL,
    payrunid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SuperAdjustment Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_superadjustment;
CREATE TABLE c{clientID}_keypay_superadjustment (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Timesheet Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_timesheet;
CREATE TABLE c{clientID}_keypay_timesheet (
    id VARCHAR(255) NOT NULL,
    attachmentdata VARCHAR(100),
    attachmentdatecreated DATETIME,
    attachmentdatescanned DATETIME,
    attachmentfriendlyname VARCHAR(255),
    attachmentid VARCHAR(255),
    attachmentisdeleted BOOLEAN,
    attachmentisinfected BOOLEAN,
    attachmenturl VARCHAR(500),
    classification VARCHAR(255),
    classificationid VARCHAR(255),
    comments TEXT,
    employeeid VARCHAR(255),
    endtime DATETIME,
    externalid VARCHAR(255),
    fullyqualifiedlocationname VARCHAR(255),
    hiddencomments TEXT,
    leavecategoryid VARCHAR(255),
    locationid VARCHAR(255),
    locationisdeleted BOOLEAN,
    paycategoryid VARCHAR(255),
    rate DECIMAL(19,4),
    source VARCHAR(255),
    starttime DATETIME,
    status VARCHAR(255),
    submittedbyuser VARCHAR(255),
    units DECIMAL(19,4),
    worktype VARCHAR(255),
    worktypeid VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- WorkType Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_worktype;
CREATE TABLE c{clientID}_keypay_worktype (
    id VARCHAR(255) NOT NULL,
    accruesleave BOOLEAN,
    awardpackageid VARCHAR(255),
    awardpackagename VARCHAR(255),
    externalid VARCHAR(255),
    leavecategoryid VARCHAR(255),
    mappingtype VARCHAR(255),
    name VARCHAR(255),
    paycategoryid VARCHAR(255),
    shortcode VARCHAR(255),
    source VARCHAR(255),
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusiAccEmpGroups Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busiaccempgroups;
CREATE TABLE c{clientID}_keypay_busiaccempgroups (
    businessaccessid VARCHAR(255) NOT NULL,
    employeegroupid INT NOT NULL,
    permissions VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeegroupid)
);

-- BusiAccLocAccess Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busiacclocaccess;
CREATE TABLE c{clientID}_keypay_busiacclocaccess (
    businessaccessid VARCHAR(255) NOT NULL,
    filtertype VARCHAR(255),
    permissions VARCHAR(500),
    locationids JSON,
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- BusiAccKiosks Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busiacckiosks;
CREATE TABLE c{clientID}_keypay_busiacckiosks (
    businessaccessid VARCHAR(255) NOT NULL,
    kioskid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (kioskid)
);

-- BusiAccPayApproval Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busiaccpayapproval;
CREATE TABLE c{clientID}_keypay_busiaccpayapproval (
    businessaccessid VARCHAR(255) NOT NULL,
    payscheduleid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payscheduleid)
);

-- BusiAccPayCreation Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busiaccpaycreation;
CREATE TABLE c{clientID}_keypay_busiaccpaycreation (
    businessaccessid VARCHAR(255) NOT NULL,
    payscheduleid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payscheduleid)
);

-- BusiDocSelGroups Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busidocselgroups;
CREATE TABLE c{clientID}_keypay_busidocselgroups (
    businessdocumentid VARCHAR(255) NOT NULL,
    groupid INT NOT NULL,
    groupname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (groupid)
);

-- BusiDocSelLocs Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_busidocsellocs;
CREATE TABLE c{clientID}_keypay_busidocsellocs (
    businessdocumentid VARCHAR(255) NOT NULL,
    locationid INT NOT NULL,
    locationname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationid)
);

-- InvoiceLineItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_invoicelineitems;
CREATE TABLE c{clientID}_keypay_invoicelineitems (
    invoiceid VARCHAR(255) NOT NULL,
    abn VARCHAR(255),
    billingplan VARCHAR(255),
    brandname VARCHAR(255),
    businessid INT,
    businessnumber VARCHAR(255),
    description VARCHAR(500),
    quantity DOUBLE,
    totalincludinggst DOUBLE,
    unitpriceincludinggst DOUBLE,
    whitelabelname VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InvoiceLineDetails Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_invoicelinedetails;
CREATE TABLE c{clientID}_keypay_invoicelinedetails (
    invoicelineitemid VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    groupname VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LocationShiftConds Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_locationshiftconds;
CREATE TABLE c{clientID}_keypay_locationshiftconds (
    locationid VARCHAR(255) NOT NULL,
    shiftconditionid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (shiftconditionid)
);

-- ChartOfAccDeductionCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccdeductioncats;
CREATE TABLE c{clientID}_keypay_chartofaccdeductioncats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    splitbyempentity BOOLEAN,
    splitbylocation BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccPayCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccpaycats;
CREATE TABLE c{clientID}_keypay_chartofaccpaycats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    splitbyempentity BOOLEAN,
    splitbylocation BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpExpenseCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempexpensecats;
CREATE TABLE c{clientID}_keypay_chartofaccempexpensecats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    splitbyempentity BOOLEAN,
    splitbylocation BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpLiabilityCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempliabilitycats;
CREATE TABLE c{clientID}_keypay_chartofaccempliabilitycats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    splitbyempentity BOOLEAN,
    splitbylocation BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLeaveCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccleavecats;
CREATE TABLE c{clientID}_keypay_chartofaccleavecats (
    accruefromcontingentperiod BOOLEAN,
    expenseaccountid INT,
    id INT NOT NULL,
    islongserviceleave BOOLEAN,
    liabilityaccountid INT,
    name VARCHAR(255),
    splitbyempentity BOOLEAN,
    splitbylocation BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntity Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentity;
CREATE TABLE c{clientID}_keypay_chartofaccempentity (
    employingentityid INT,
    defexpenseaccountid INT,
    defliabilityaccountid INT,
    empexpenseaccountid INT,
    paymentaccountid INT,
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocation Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocation;
CREATE TABLE c{clientID}_keypay_chartofacclocation (
    locationid INT,
    defexpenseaccountid INT,
    defliabilityaccountid INT,
    empexpenseaccountid INT,
    paymentaccountid INT,
    id VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocDeductionCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocdeductioncats;
CREATE TABLE c{clientID}_keypay_chartofacclocdeductioncats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ChartOfAccLocEmpExpenseCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocempexpensecats;
CREATE TABLE c{clientID}_keypay_chartofacclocempexpensecats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocEmpLiabilityCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocempliabilitycats;
CREATE TABLE c{clientID}_keypay_chartofacclocempliabilitycats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocLeaveCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocleavecats;
CREATE TABLE c{clientID}_keypay_chartofacclocleavecats (
    accruefromcontingentperiod BOOLEAN,
    expenseaccountid INT,
    id INT NOT NULL,
    islongserviceleave BOOLEAN,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocPayCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofacclocpaycats;
CREATE TABLE c{clientID}_keypay_chartofacclocpaycats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntDeductionCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentdeductioncats;
CREATE TABLE c{clientID}_keypay_chartofaccempentdeductioncats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntEmpExpenseCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentempexpensecats;
CREATE TABLE c{clientID}_keypay_chartofaccempentempexpensecats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntEmpLiabilityCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentempliabilitycats;
CREATE TABLE c{clientID}_keypay_chartofaccempentempliabilitycats (
    expenseaccountid INT,
    id INT NOT NULL,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntLeaveCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentleavecats;
CREATE TABLE c{clientID}_keypay_chartofaccempentleavecats (
    accruefromcontingentperiod BOOLEAN,
    expenseaccountid INT,
    id INT NOT NULL,
    islongserviceleave BOOLEAN,
    liabilityaccountid INT,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntPayCats Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_chartofaccempentpaycats;
CREATE TABLE c{clientID}_keypay_chartofaccempentpaycats (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRunDeductionItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrundeductionitems;
CREATE TABLE c{clientID}_keypay_payrundeductionitems (
    payrunid VARCHAR(255) NOT NULL,
    deductioncategoryid VARCHAR(255),
    deductioncategoryname VARCHAR(255),
    amount DOUBLE,
    notes VARCHAR(1000),
    paymentreference VARCHAR(255),
    note VARCHAR(1000),
    paytobankaccountbsb VARCHAR(255),
    paytobankaccbankcode VARCHAR(255),
    paytobankaccnumber VARCHAR(255),
    paytosuperfundname VARCHAR(255),
    paytosuperfundmembernum VARCHAR(255),
    payto VARCHAR(255),
    additionaldata INT,
    id INT NOT NULL,
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employeeexternalid VARCHAR(255),
    assocempdeductioncategoryid INT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEarningsLineItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrunearningslineitems;
CREATE TABLE c{clientID}_keypay_payrunearningslineitems (
    payrunid VARCHAR(255) NOT NULL,
    super DOUBLE,
    sfss DOUBLE,
    help DOUBLE,
    payg DOUBLE,
    paycategoryid VARCHAR(255),
    paycategoryname VARCHAR(255),
    units DOUBLE,
    notes VARCHAR(1000),
    rate DOUBLE,
    earnings DOUBLE,
    lumpsumnumofpayperiods DOUBLE,
    lumpsumcalculationmethod VARCHAR(255),
    lumpsumefinancialyear VARCHAR(255),
    timesheetlineid VARCHAR(255),
    timesheetlineexternalid VARCHAR(255),
    id INT NOT NULL,
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employeeexternalid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRunEmpExpenseItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payrunempexpenseitems;
CREATE TABLE c{clientID}_keypay_payrunempexpenseitems (
    payrunid VARCHAR(255) NOT NULL,
    employeeexpensecategoryid VARCHAR(255),
    employeeexpensecategoryname VARCHAR(255),
    notes VARCHAR(1000),
    amount DOUBLE,
    taxcode VARCHAR(255),
    taxrate DOUBLE,
    taxcodedisplayname VARCHAR(255),
    id INT NOT NULL,
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employeeexternalid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- EmployeeGroupFilters Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employeegroupfilters;
CREATE TABLE c{clientID}_keypay_employeegroupfilters (
    employeegroupid VARCHAR(255) NOT NULL,
    filtertype VARCHAR(255),
    operator VARCHAR(255),
    value VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EmployerLiabilityItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_employerliabilityitems;
CREATE TABLE c{clientID}_keypay_employerliabilityitems (
    payrunid INT NOT NULL,
    id INT NOT NULL,
    amount DOUBLE,
    employeeexternalid VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employerliabilitycategoryid VARCHAR(255),
    employerliabilitycategoryname VARCHAR(255),
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    notes VARCHAR(1000),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LeaveCatTiers Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_leavecattiers;
CREATE TABLE c{clientID}_keypay_leavecattiers (
    leavecategoryid VARCHAR(255) NOT NULL,
    id INT NOT NULL,
    accrualamount DOUBLE,
    accrualstartafter INT,
    accrualstartafterunittype VARCHAR(255),
    accrualunittype VARCHAR(255),
    isdeleted BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PaygAdjustmentItems Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_paygadjustmentitems;
CREATE TABLE c{clientID}_keypay_paygadjustmentitems (
    payrunid INT NOT NULL,
    id INT NOT NULL,
    notes VARCHAR(1000),
    amount DOUBLE,
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    employeeexternalid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRateTemplateCategories Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payratetemplatecategories;
CREATE TABLE c{clientID}_keypay_payratetemplatecategories (
    payratetemplateid VARCHAR(255) NOT NULL,
    paycategoryid INT NOT NULL,
    calculatedrate DOUBLE,
    standardweeklyhours DOUBLE,
    usersuppliedrate DOUBLE,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (paycategoryid)
);

-- PaySchedAutoPayReports Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedautopayreports;
CREATE TABLE c{clientID}_keypay_payschedautopayreports (
    payscheduleid VARCHAR(255) NOT NULL,
    reportpackid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reportpackid)
);

-- PaySchedAutoPayUsers Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedautopayusers;
CREATE TABLE c{clientID}_keypay_payschedautopayusers (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedDefaultReports Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payscheddefaultreports;
CREATE TABLE c{clientID}_keypay_payscheddefaultreports (
    payscheduleid VARCHAR(255) NOT NULL,
    reportpackid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reportpackid)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySchedApprovalUsers Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedapprovalusers;
CREATE TABLE c{clientID}_keypay_payschedapprovalusers (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedPaymentApprovalUsers Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedpaymentapprovalusers;
CREATE TABLE c{clientID}_keypay_payschedpaymentapprovalusers (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedIgnoredWarnings Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedignoredwarnings;
CREATE TABLE c{clientID}_keypay_payschedignoredwarnings (
    payscheduleid VARCHAR(255) NOT NULL,
    warningid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (warningid)
);

-- PaySchedLocations Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payschedlocations;
CREATE TABLE c{clientID}_keypay_payschedlocations (
    payscheduleid VARCHAR(255) NOT NULL,
    locationid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationid)
);

-- PayslipAccruedLeave Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipaccruedleave;
CREATE TABLE c{clientID}_keypay_payslipaccruedleave (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    balance DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid)
);

-- PayslipBankPayments Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipbankpayments;
CREATE TABLE c{clientID}_keypay_payslipbankpayments (
    payslipid VARCHAR(255) NOT NULL,
    accountname VARCHAR(255),
    accountnumber VARCHAR(255),
    amount DECIMAL(19,4),
    bsb VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid)
);

-- PayslipDeductions Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipdeductions;
CREATE TABLE c{clientID}_keypay_payslipdeductions (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    ytdamount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipEarningsLines Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipearningslines;
CREATE TABLE c{clientID}_keypay_payslipearningslines (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    rate DECIMAL(19,4),
    units DECIMAL(19,4),
    ytdamount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipEmployeeExpenses Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipemployeeexpenses;
CREATE TABLE c{clientID}_keypay_payslipemployeeexpenses (
    payslipid VARCHAR(255) NOT NULL,
    id VARCHAR(255),
    amount DECIMAL(19,4),
    description TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, id)
);

-- PayslipGrossYTDDetails Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipgrossytddetails;
CREATE TABLE c{clientID}_keypay_payslipgrossytddetails (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipLeaveTaken Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipleavetaken;
CREATE TABLE c{clientID}_keypay_payslipleavetaken (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    hours DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipPaygAdjustments Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslippaygadjustments;
CREATE TABLE c{clientID}_keypay_payslippaygadjustments (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipSuperAdjustments Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipsuperadjustments;
CREATE TABLE c{clientID}_keypay_payslipsuperadjustments (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipSuperPayments Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_payslipsuperpayments;
CREATE TABLE c{clientID}_keypay_payslipsuperpayments (
    payslipid VARCHAR(255) NOT NULL,
    fundname VARCHAR(255),
    amount DECIMAL(19,4),
    fundcode VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, fundname)
);

-- PayslipTotalAccruedLeave Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_paysliptotalaccruedleave;
CREATE TABLE c{clientID}_keypay_paysliptotalaccruedleave (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    balance DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- SuperAdjustmentDetails Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_superadjustmentdetails;
CREATE TABLE c{clientID}_keypay_superadjustmentdetails (
    payrunid VARCHAR(255) NOT NULL,
    id VARCHAR(255),
    amount DECIMAL(19,4),
    contributiontype VARCHAR(255),
    empexternalid VARCHAR(255),
    employeeid VARCHAR(255),
    employeename VARCHAR(255),
    externalid VARCHAR(255),
    locationid VARCHAR(255),
    locationname VARCHAR(255),
    notes TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid, id)
);

-- TimesheetBreaks Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_timesheetbreaks;
CREATE TABLE c{clientID}_keypay_timesheetbreaks (
    timesheetid VARCHAR(255) NOT NULL,
    starttime DATETIME,
    endtime DATETIME,
    ispaidbreak BOOLEAN,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, starttime)
);

-- TimesheetDimensionValues Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_timesheetdimensionvalues;
CREATE TABLE c{clientID}_keypay_timesheetdimensionvalues (
    timesheetid VARCHAR(255) NOT NULL,
    dimensionvalueid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, dimensionvalueid)
);

-- TimesheetShiftConditionIds Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_timesheetshiftconditionids;
CREATE TABLE c{clientID}_keypay_timesheetshiftconditionids (
    timesheetid VARCHAR(255) NOT NULL,
    shiftconditionid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, shiftconditionid)
);

-- TimesheetShiftConditions Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_timesheetshiftconditions;
CREATE TABLE c{clientID}_keypay_timesheetshiftconditions (
    timesheetid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, id)
);

-- Pattern: c{clientID}_keypay_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WorkEmploymentTypes Production Table
DROP TABLE IF EXISTS c{clientID}_keypay_workemploymenttypes;
CREATE TABLE c{clientID}_keypay_workemploymenttypes (
    worktypeid VARCHAR(255) NOT NULL,
    employmenttype VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (worktypeid, employmenttype)
);

-- KEYPAY LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_keypay_lastrefreshdate;
CREATE TABLE c{clientID}_keypay_lastrefreshdate (
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
