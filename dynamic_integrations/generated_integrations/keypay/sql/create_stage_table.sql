-- KEYPAY Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Business Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_businessstage;
CREATE TABLE c{clientID}_{orgID}_keypay_businessstage (
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

-- Employee Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeestage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeestage (
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

-- PayRun Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunstage (
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

-- BusinessAccess Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_businessaccessstage;
CREATE TABLE c{clientID}_{orgID}_keypay_businessaccessstage (
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

-- BusinessDocument Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_businessdocumentstage;
CREATE TABLE c{clientID}_{orgID}_keypay_businessdocumentstage (
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

-- Invoice Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_invoicestage;
CREATE TABLE c{clientID}_{orgID}_keypay_invoicestage (
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

-- Location Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_locationstage;
CREATE TABLE c{clientID}_{orgID}_keypay_locationstage (
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

-- ChartOfAccounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccountsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccountsstage (
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

-- PayRunDeductions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrundeductionsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrundeductionsstage (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- PayRunEarningsLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunearningslinesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunearningslinesstage (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);


-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEmpExpenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunempexpensesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunempexpensesstage (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- EmployeeLeaveAllowances Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeeleaveallowancesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeeleaveallowancesstage (
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

-- EmployeeGroup Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeegroupstage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeegroupstage (
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

-- EmployerLiabilities Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employerliabilitiesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_employerliabilitiesstage (
    payrunid INT NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- LeaveCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_leavecategorystage;
CREATE TABLE c{clientID}_{orgID}_keypay_leavecategorystage (
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

-- BusinessABA Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_businessabastage;
CREATE TABLE c{clientID}_{orgID}_keypay_businessabastage (
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

-- BillingPlan Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_billingplanstage;
CREATE TABLE c{clientID}_{orgID}_keypay_billingplanstage (
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

-- DeductionCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_deductioncategorystage;
CREATE TABLE c{clientID}_{orgID}_keypay_deductioncategorystage (
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

-- EmployeeExpenseCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeeexpensecategorystage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeeexpensecategorystage (
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

-- PaygAdjustments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_paygadjustmentsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_paygadjustmentsstage (
    payrunid INT NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (clientid, organisationid)
);

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayRateTemplate Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payratetemplatestage;
CREATE TABLE c{clientID}_{orgID}_keypay_payratetemplatestage (
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

-- PayRunTotals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payruntotalsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payruntotalsstage (
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

-- Accounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_accountsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_accountsstage (
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

-- LeaveRequest Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_leaverequeststage;
CREATE TABLE c{clientID}_{orgID}_keypay_leaverequeststage (
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

-- PayCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_paycategorystage;
CREATE TABLE c{clientID}_{orgID}_keypay_paycategorystage (
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

-- EmployeePayRate Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeepayratestage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeepayratestage (
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

-- PayRunSummary Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunsummarystage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunsummarystage (
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

-- PaySchedule Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedulestage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedulestage (
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

-- Payslip Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipstage (
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

-- SuperAdjustment Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_superadjustmentstage;
CREATE TABLE c{clientID}_{orgID}_keypay_superadjustmentstage (
    payrunid VARCHAR(255) NOT NULL,
    businessid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payrunid)
);

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- Timesheet Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_timesheetstage;
CREATE TABLE c{clientID}_{orgID}_keypay_timesheetstage (
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

-- WorkType Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_worktypestage;
CREATE TABLE c{clientID}_{orgID}_keypay_worktypestage (
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

-- BusiAccEmpGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busiaccempgroupsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busiaccempgroupsstage (
    businessaccessid VARCHAR(255) NOT NULL,
    employeegroupid INT NOT NULL,
    permissions VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employeegroupid)
);

-- BusiAccLocAccess Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busiacclocaccessstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busiacclocaccessstage (
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

-- BusiAccKiosks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busiacckiosksstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busiacckiosksstage (
    businessaccessid VARCHAR(255) NOT NULL,
    kioskid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (kioskid)
);

-- BusiAccPayApproval Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busiaccpayapprovalstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busiaccpayapprovalstage (
    businessaccessid VARCHAR(255) NOT NULL,
    payscheduleid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payscheduleid)
);

-- BusiAccPayCreation Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busiaccpaycreationstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busiaccpaycreationstage (
    businessaccessid VARCHAR(255) NOT NULL,
    payscheduleid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payscheduleid)
);

-- BusiDocSelGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busidocselgroupsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busidocselgroupsstage (
    businessdocumentid VARCHAR(255) NOT NULL,
    groupid INT NOT NULL,
    groupname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (groupid)
);

-- BusiDocSelLocs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_busidocsellocsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_busidocsellocsstage (
    businessdocumentid VARCHAR(255) NOT NULL,
    locationid INT NOT NULL,
    locationname VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationid)
);

-- InvoiceLineItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_invoicelineitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_invoicelineitemsstage (
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

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- InvoiceLineDetails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_invoicelinedetailsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_invoicelinedetailsstage (
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

-- LocationShiftConds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_locationshiftcondsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_locationshiftcondsstage (
    locationid VARCHAR(255) NOT NULL,
    shiftconditionid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (shiftconditionid)
);

-- ChartOfAccDeductionCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccdeductioncatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccdeductioncatsstage (
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

-- ChartOfAccPayCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccpaycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccpaycatsstage (
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

-- ChartOfAccEmpExpenseCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempexpensecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempexpensecatsstage (
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

-- ChartOfAccEmpLiabilityCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempliabilitycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempliabilitycatsstage (
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

-- ChartOfAccLeaveCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccleavecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccleavecatsstage (
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

-- ChartOfAccEmpEntity Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentitystage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentitystage (
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

-- ChartOfAccLocation Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocationstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocationstage (
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

-- ChartOfAccLocDeductionCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocdeductioncatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocdeductioncatsstage (
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

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- ChartOfAccLocEmpExpenseCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocempexpensecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocempexpensecatsstage (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccLocEmpLiabilityCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocempliabilitycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocempliabilitycatsstage (
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

-- ChartOfAccLocLeaveCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocleavecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocleavecatsstage (
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

-- ChartOfAccLocPayCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofacclocpaycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofacclocpaycatsstage (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntDeductionCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentdeductioncatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentdeductioncatsstage (
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

-- ChartOfAccEmpEntEmpExpenseCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentempexpensecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentempexpensecatsstage (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChartOfAccEmpEntEmpLiabilityCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentempliabilitycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentempliabilitycatsstage (
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

-- ChartOfAccEmpEntLeaveCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentleavecatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentleavecatsstage (
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

-- ChartOfAccEmpEntPayCats Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_chartofaccempentpaycatsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_chartofaccempentpaycatsstage (
    expenseaccountid INT,
    id INT NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PayRunDeductionItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrundeductionitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrundeductionitemsstage (
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

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEarningsLineItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunearningslineitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunearningslineitemsstage (
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

-- PayRunEmpExpenseItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payrunempexpenseitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payrunempexpenseitemsstage (
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

-- EmployeeGroupFilters Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employeegroupfiltersstage;
CREATE TABLE c{clientID}_{orgID}_keypay_employeegroupfiltersstage (
    employeegroupid VARCHAR(255) NOT NULL,
    filtertype VARCHAR(255),
    operator VARCHAR(255),
    value VARCHAR(500),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- EmployerLiabilityItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_employerliabilityitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_employerliabilityitemsstage (
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

-- LeaveCatTiers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_leavecattiersstage;
CREATE TABLE c{clientID}_{orgID}_keypay_leavecattiersstage (
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

-- PaygAdjustmentItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_paygadjustmentitemsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_paygadjustmentitemsstage (
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

-- PayRateTemplateCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payratetemplatecategoriesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payratetemplatecategoriesstage (
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

-- PaySchedAutoPayReports Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedautopayreportsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedautopayreportsstage (
    payscheduleid VARCHAR(255) NOT NULL,
    reportpackid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reportpackid)
);

-- PaySchedAutoPayUsers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedautopayusersstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedautopayusersstage (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedDefaultReports Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payscheddefaultreportsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payscheddefaultreportsstage (
    payscheduleid VARCHAR(255) NOT NULL,
    reportpackid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reportpackid)
);

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PaySchedApprovalUsers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedapprovalusersstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedapprovalusersstage (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedPaymentApprovalUsers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedpaymentapprovalusersstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedpaymentapprovalusersstage (
    payscheduleid VARCHAR(255) NOT NULL,
    userid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (userid)
);

-- PaySchedIgnoredWarnings Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedignoredwarningsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedignoredwarningsstage (
    payscheduleid VARCHAR(255) NOT NULL,
    warningid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (warningid)
);

-- PaySchedLocations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payschedlocationsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payschedlocationsstage (
    payscheduleid VARCHAR(255) NOT NULL,
    locationid INT NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (locationid)
);

-- PayslipAccruedLeave Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipaccruedleavestage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipaccruedleavestage (
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

-- PayslipBankPayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipbankpaymentsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipbankpaymentsstage (
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

-- PayslipDeductions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipdeductionsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipdeductionsstage (
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

-- PayslipEarningsLines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipearningslinesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipearningslinesstage (
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

-- PayslipEmployeeExpenses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipemployeeexpensesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipemployeeexpensesstage (
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

-- PayslipGrossYTDDetails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipgrossytddetailsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipgrossytddetailsstage (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipLeaveTaken Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipleavetakenstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipleavetakenstage (
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

-- PayslipPaygAdjustments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslippaygadjustmentsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslippaygadjustmentsstage (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipSuperAdjustments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipsuperadjustmentsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipsuperadjustmentsstage (
    payslipid VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    amount DECIMAL(19,4),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (payslipid, name)
);

-- PayslipSuperPayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_payslipsuperpaymentsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_payslipsuperpaymentsstage (
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

-- PayslipTotalAccruedLeave Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_paysliptotalaccruedleavestage;
CREATE TABLE c{clientID}_{orgID}_keypay_paysliptotalaccruedleavestage (
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

-- SuperAdjustmentDetails Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_superadjustmentdetailsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_superadjustmentdetailsstage (
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

-- TimesheetBreaks Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_timesheetbreaksstage;
CREATE TABLE c{clientID}_{orgID}_keypay_timesheetbreaksstage (
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

-- TimesheetDimensionValues Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_timesheetdimensionvaluesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_timesheetdimensionvaluesstage (
    timesheetid VARCHAR(255) NOT NULL,
    dimensionvalueid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, dimensionvalueid)
);

-- TimesheetShiftConditionIds Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_timesheetshiftconditionidsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_timesheetshiftconditionidsstage (
    timesheetid VARCHAR(255) NOT NULL,
    shiftconditionid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, shiftconditionid)
);

-- TimesheetShiftConditions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_timesheetshiftconditionsstage;
CREATE TABLE c{clientID}_{orgID}_keypay_timesheetshiftconditionsstage (
    timesheetid VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (timesheetid, id)
);

-- Pattern: c{clientID}_{orgID}_keypay_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- WorkEmploymentTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_keypay_workemploymenttypesstage;
CREATE TABLE c{clientID}_{orgID}_keypay_workemploymenttypesstage (
    worktypeid VARCHAR(255) NOT NULL,
    employmenttype VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (worktypeid, employmenttype)
);