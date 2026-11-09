-- KEYPAY Views - Auto Generated
-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Business View
DROP VIEW IF EXISTS {etani_client_id}_keypay_business;
CREATE VIEW {etani_client_id}_keypay_business AS
SELECT
    id,
    abn,
    addressline1,
    addressline2,
    budgetentrymethod,
    budgetwarningpercent,
    contactemailaddress,
    contactfaxnumber,
    contactname,
    contactphonenumber,
    datecreated,
    defaultsuperrate,
    endofweek,
    externalid,
    foreignentitycountry,
    industryname,
    initialfinancialyearstart,
    isforeignentity,
    journalservice,
    leaveaccrualstartdatetype,
    leaveyearstart,
    legalname,
    managementsoftwareid,
    managerscaneditrosterbudgets,
    name,
    numberofemployees,
    paycyclefrequency,
    postcode,
    promocode,
    region,
    sbrsoftwareid,
    sbrsoftwareprovider,
    source,
    standardhoursperday,
    state,
    suburb,
    whitelabelid,
    whitelabelname,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_business;

-- Employee View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employee;
CREATE VIEW {etani_client_id}_keypay_employee AS
SELECT
    id,
    anniversarydate,
    australianresident,
    automaticallyapplypublicholidaynotworkedearningslines,
    automaticallypayemployee,
    awardid,
    bankaccount1accountname AS `bankaccount1_accountname`,
    bankaccount1accountnumber AS `bankaccount1_accountnumber`,
    bankaccount1allocatedpercentage AS `bankaccount1_allocatedpercentage`,
    bankaccount1bsb AS `bankaccount1_bsb`,
    bankaccount1fixedamount AS `bankaccount1_fixedamount`,
    bankaccount2accountname AS `bankaccount2_accountname`,
    bankaccount2accountnumber AS `bankaccount2_accountnumber`,
    bankaccount2allocatedpercentage AS `bankaccount2_allocatedpercentage`,
    bankaccount2bsb AS `bankaccount2_bsb`,
    bankaccount2fixedamount AS `bankaccount2_fixedamount`,
    bankaccount3accountname AS `bankaccount3_accountname`,
    bankaccount3accountnumber AS `bankaccount3_accountnumber`,
    bankaccount3allocatedpercentage AS `bankaccount3_allocatedpercentage`,
    bankaccount3bsb AS `bankaccount3_bsb`,
    bankaccount3fixedamount AS `bankaccount3_fixedamount`,
    businessawardpackage,
    claimmedicarelevyreduction,
    claimtaxfreethreshold,
    closelyheldemployee,
    closelyheldreporting,
    contractorabn,
    datecreated,
    dateofbirth,
    datetaxfiledeclarationreported,
    datetaxfiledeclarationsigned,
    disableautoprogression,
    dvlpayslipdescription,
    emailaddress,
    emergencycontact1address AS `emergencycontact1_address`,
    emergencycontact1alternatecontactnumber AS `emergencycontact1_alternatecontactnumber`,
    emergencycontact1contactnumber AS `emergencycontact1_contactnumber`,
    emergencycontact1name AS `emergencycontact1_name`,
    emergencycontact1relationship AS `emergencycontact1_relationship`,
    emergencycontact2address AS `emergencycontact2_address`,
    emergencycontact2alternatecontactnumber AS `emergencycontact2_alternatecontactnumber`,
    emergencycontact2contactnumber AS `emergencycontact2_contactnumber`,
    emergencycontact2name AS `emergencycontact2_name`,
    emergencycontact2relationship AS `emergencycontact2_relationship`,
    employingentityabn,
    employingentityid,
    employmentagreement,
    employmentagreementid,
    employmenttype,
    enddate,
    externalid,
    firstname,
    gender,
    hasapprovedworkingholidayvisa,
    haswithholdingvariation,
    homephone,
    hoursperday,
    hoursperweek,
    includeinportablelongserviceleavereport,
    isenabledfortimesheets,
    isexemptfromfloodlevy,
    isexemptfrompayrolltax,
    isseasonalworker,
    jobtitle,
    leaveaccrualstartdatetype,
    leavetemplate,
    leaveyearstart,
    locations,
    maximumquarterlysupercontributionsbase,
    medicarelevyexemption,
    medicarelevyreductiondependentcount,
    medicarelevyreductionspouse,
    medicarelevysurchargewithholdingtier,
    middlename,
    mobilephone,
    othertaxoffset,
    overridetemplaterate,
    payconditionruleset,
    payratetemplate,
    payschedule,
    payslipnotificationtype,
    portablelongserviceleaveid,
    postaladdressisoverseas,
    postaladdressline2,
    postalcountry,
    postalpostcode,
    postalstate,
    postalstreetaddress,
    postalsuburb,
    preferredname,
    previoussurname,
    primarylocation,
    primarypaycategory,
    rate,
    rateunit,
    reportingdimensionvalues,
    residentialaddressisoverseas,
    residentialaddressline2,
    residentialcountry,
    residentialpostcode,
    residentialstate,
    residentialstreetaddress,
    residentialsuburb,
    rosteringnotificationchoices,
    seniorstaxoffset,
    singletouchpayroll,
    startdate,
    status,
    stsldebt,
    superfund1allocatedpercentage AS `superfund1_allocatedpercentage`,
    superfund1employernominatedfund AS `superfund1_employernominatedfund`,
    superfund1fixedamount AS `superfund1_fixedamount`,
    superfund1fundname AS `superfund1_fundname`,
    superfund1membernumber AS `superfund1_membernumber`,
    superfund1productcode AS `superfund1_productcode`,
    superfund2allocatedpercentage AS `superfund2_allocatedpercentage`,
    superfund2employernominatedfund AS `superfund2_employernominatedfund`,
    superfund2fixedamount AS `superfund2_fixedamount`,
    superfund2fundname AS `superfund2_fundname`,
    superfund2membernumber AS `superfund2_membernumber`,
    superfund2productcode AS `superfund2_productcode`,
    superfund3allocatedpercentage AS `superfund3_allocatedpercentage`,
    superfund3employernominatedfund AS `superfund3_employernominatedfund`,
    superfund3fixedamount AS `superfund3_fixedamount`,
    superfund3fundname AS `superfund3_fundname`,
    superfund3membernumber AS `superfund3_membernumber`,
    superfund3productcode AS `superfund3_productcode`,
    superthresholdamount,
    surname,
    tags,
    taxcategory,
    taxfilenumber,
    taxvariation,
    terminationreason,
    title,
    workphone,
    worktypes,
    workingholidayvisacountry,
    workingholidayvisastartdate,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employee;

-- PayRun View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrun;
CREATE VIEW {etani_client_id}_keypay_payrun AS
SELECT
    datefinalised,
    datepaid,
    externalid,
    id,
    isfinalised,
    notation,
    payperiodending,
    payperiodstarting,
    payscheduleid,
    payslipspublished,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrun;

-- BusinessAccess View
DROP VIEW IF EXISTS {etani_client_id}_keypay_businessaccess;
CREATE VIEW {etani_client_id}_keypay_businessaccess AS
SELECT
    accesstype,
    email,
    name,
    kioskaccesstype AS `kioskaccess.accesstype`,
    kioskpermissions AS `kioskaccess.permissions`,
    payrollapproveelectronic AS `payrollaccess.approveelectronicpayrolllodgement`,
    payrollapprovalaccess AS `payrollaccess.payrunapprovalaccess`,
    payrollcreationaccess AS `payrollaccess.payruncreationaccess`,
    payrollbusinessrestrictions AS `payrollaccess.userbusinessrestrictioncount`,
    reportsaccesstype AS `reports.accesstype`,
    reportsnorestriction AS `reports.noreportingrestriction`,
    reportsspecific AS `reports.specificreports`,
    id,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_businessaccess;

-- BusinessDocument View
DROP VIEW IF EXISTS {etani_client_id}_keypay_businessdocument;
CREATE VIEW {etani_client_id}_keypay_businessdocument AS
SELECT
    id,
    datecreated,
    friendlyname,
    requiresemployeeacknowledgement,
    sendinitialnotificationon,
    sendnotificationimmediately,
    sendnotificationtoemployee,
    sendremindereveryxdays,
    visibletoallemployees,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_businessdocument;

-- Invoice View
DROP VIEW IF EXISTS {etani_client_id}_keypay_invoice;
CREATE VIEW {etani_client_id}_keypay_invoice AS
SELECT
    id,
    culturename,
    currency,
    date,
    gst,
    invoicenumber,
    totalexcludinggst,
    totalincludinggst,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_invoice;

-- Location View
DROP VIEW IF EXISTS {etani_client_id}_keypay_location;
CREATE VIEW {etani_client_id}_keypay_location AS
SELECT
    id,
    country,
    externalaccountinglocationid,
    externalid,
    fullyqualifiedname,
    generalledgermappingcode,
    isglobal,
    isrollupreportinglocation,
    name,
    parentid,
    source,
    state,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_location;

-- ChartOfAccounts View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccounts;
CREATE VIEW {etani_client_id}_keypay_chartofaccounts AS
SELECT
    complete,
    defexpenseaccountid AS `chartofaccounts.defaultaccounts.defaultexpenseaccountid`,
    defexpensesplitbyempentity,
    defexpensesplitbylocation AS `chartofaccounts.defaultaccounts.defaultexpensesplitbylocation`,
    defliabilityaccountid AS `chartofaccounts.defaultaccounts.defaultliabilityaccountid`,
    defliabilitysplitbyempentity,
    defliabilitysplitbylocation AS `chartofaccounts.defaultaccounts.defaultliabilitysplitbylocation`,
    empexpenseaccountid AS `chartofaccounts.defaultaccounts.employeeexpenseaccountid`,
    empexpensesplitbyempentity,
    empexpensesplitbylocation AS `chartofaccounts.defaultaccounts.employeeexpensesplitbylocation`,
    paymentaccountid AS `chartofaccounts.defaultaccounts.paymentaccountid`,
    paymentaccsplitbyempentity,
    paymentaccsplitbylocation AS `chartofaccounts.defaultaccounts.paymentaccountsplitbylocation`,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccounts;

-- PayRunDeductions View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrundeductions;
CREATE VIEW {etani_client_id}_keypay_payrundeductions AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrundeductions;

-- PayRunEarningsLines View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrunearningslines;
CREATE VIEW {etani_client_id}_keypay_payrunearningslines AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrunearningslines;


-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEmpExpenses View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrunempexpenses;
CREATE VIEW {etani_client_id}_keypay_payrunempexpenses AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrunempexpenses;

-- EmployeeLeaveAllowances View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employeeleaveallowances;
CREATE VIEW {etani_client_id}_keypay_employeeleaveallowances AS
SELECT
    automaticallyaccrues,
    canapplyforleave,
    hoursperyear,
    leaveaccrualruleaccrualtype AS `leaveaccrualrule.accrualtype`,
    leaveaccrualruleaccrueinadvance AS `leaveaccrualrule.accrueinadvance`,
    leaveaccrualrulecaptype AS `leaveaccrualrule.captype`,
    leaveaccrualrulecarryoveramount AS `leaveaccrualrule.carryoveramount`,
    leaveaccrualrulecarryoverbehaviour AS `leaveaccrualrule.carryoverbehaviour`,
    leaveaccrualruleid AS `leaveaccrualrule.id`,
    leaveaccrualruleleaveyearoffsetamount AS `leaveaccrualrule.leaveyearoffsetamount`,
    leaveaccrualruleunitcap AS `leaveaccrualrule.unitcap`,
    leavecategoryid,
    leavecategoryname,
    leaveloading,
    leaveunittype,
    unittype,
    units,
    employeeid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employeeleaveallowances;

-- EmployeeGroup View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employeegroup;
CREATE VIEW {etani_client_id}_keypay_employeegroup AS
SELECT
    id,
    filtercombinationstrategy,
    name,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employeegroup;

-- EmployerLiabilities View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employerliabilities;
CREATE VIEW {etani_client_id}_keypay_employerliabilities AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employerliabilities;

-- LeaveCategory View
DROP VIEW IF EXISTS {etani_client_id}_keypay_leavecategory;
CREATE VIEW {etani_client_id}_keypay_leavecategory AS
SELECT
    id,
    accruesfirstpayrunperperiodonly,
    automaticallyaccrues,
    contingentperiod,
    deductfrompaycategoryid,
    deductfromprimarypaycategory,
    entitlementperiod,
    excludefromterminationpayout,
    externalid,
    hideaccrualsonpayslip,
    isbalanceuntracked,
    isnameprivate,
    isprivate,
    leaveaccrualruleaccrualtype AS `leaveaccrualrule.accrualtype`,
    leaveaccrualruleaccrueinadvance AS `leaveaccrualrule.accrueinadvance`,
    leaveaccrualrulecaptype AS `leaveaccrualrule.captype`,
    leaveaccrualrulecarryoveramount AS `leaveaccrualrule.carryoveramount`,
    leaveaccrualrulecarryoverbehaviour AS `leaveaccrualrule.carryoverbehaviour`,
    leaveaccrualruleid AS `leaveaccrualrule.id`,
    leaveaccrualruleleaveyearoffsetamount AS `leaveaccrualrule.leaveyearoffsetamount`,
    leaveaccrualruleunitcap AS `leaveaccrualrule.unitcap`,
    leavecategorytype,
    leaveentitlementcarryoveramount AS `leaveentitlement.carryoveramount`,
    leaveentitlementcarryovertype AS `leaveentitlement.carryovertype`,
    leaveentitlementforfeitureamount AS `leaveentitlement.forfeitureamount`,
    leaveentitlementforfeituremonthsstartafter AS `leaveentitlement.forfeituremonthsstartafter`,
    leaveentitlementforfeituretype AS `leaveentitlement.forfeituretype`,
    leaveentitlementid AS `leaveentitlement.id`,
    leaveentitlementisprorata AS `leaveentitlement.isprorata`,
    leaveentitlementleavebalancetype AS `leaveentitlement.leavebalancetype`,
    leaveentitlementstandardallowanceunittype AS `leaveentitlement.standardallowanceunittype`,
    leaveentitlementstandardallowanceunittypeamount AS `leaveentitlement.standardallowanceunittypeamount`,
    leaveloading,
    leaveunittype,
    name,
    payoutasetp,
    preventnegativebalanceunpaidleavecategoryid,
    source,
    transferonterminationtopaycategoryid,
    transfertopaycategoryid,
    unittype,
    units,
    usedeductfrompaycategoryrate,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_leavecategory;

-- BusinessABA View
DROP VIEW IF EXISTS {etani_client_id}_keypay_businessaba;
CREATE VIEW {etani_client_id}_keypay_businessaba AS
SELECT
    id,
    accountname,
    accountnumber,
    balanceadditionalcontent,
    balancelodgementreference,
    bsb,
    financialinstitutioncode,
    includeselfbalancingtransaction,
    lodgementreference,
    mergemultipleaccountpayments,
    paymentadditionalcontent,
    userid,
    username,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_businessaba;

-- BillingPlan View
DROP VIEW IF EXISTS {etani_client_id}_keypay_billingplan;
CREATE VIEW {etani_client_id}_keypay_billingplan AS
SELECT
    id,
    description,
    functionawards,
    functionemployeeonboarding,
    functionpayconditions,
    functionrostering,
    functiontimeandattendance,
    includedemployees,
    ishidden,
    name,
    pricepersms,
    priceperunit,
    superinclusion,
    type,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_billingplan;

-- DeductionCategory View
DROP VIEW IF EXISTS {etani_client_id}_keypay_deductioncategory;
CREATE VIEW {etani_client_id}_keypay_deductioncategory AS
SELECT
    id,
    expensegeneralledgermappingcode,
    externalid,
    isresc,
    issystem,
    liabilitygeneralledgermappingcode,
    name,
    paymentsummaryclassification,
    sgccalculationimpact,
    source,
    taxexempt,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_deductioncategory;

-- EmployeeExpenseCategory View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employeeexpensecategory;
CREATE VIEW {etani_client_id}_keypay_employeeexpensecategory AS
SELECT
    id,
    description,
    externalid,
    externalreferenceid,
    externaltaxcodeid,
    generalledgermappingcode,
    name,
    taxcode,
    taxrate,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employeeexpensecategory;

-- PaygAdjustments View
DROP VIEW IF EXISTS {etani_client_id}_keypay_paygadjustments;
CREATE VIEW {etani_client_id}_keypay_paygadjustments AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_paygadjustments;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRateTemplate View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payratetemplate;
CREATE VIEW {etani_client_id}_keypay_payratetemplate AS
SELECT
    externalid,
    id,
    maxquarterlysupercontribbase AS `maximumquarterlysupercontributionsbase`,
    name,
    primarypaycategoryid,
    reapplytolinkedemployees,
    source,
    superthresholdamount,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payratetemplate;

-- PayRunTotals View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payruntotals;
CREATE VIEW {etani_client_id}_keypay_payruntotals AS
SELECT
    payrunid,
    payruntotalsemployercontribution AS `payruntotals.employercontribution`,
    payruntotalsgrossearnings AS `payruntotals.grossearnings`,
    payruntotalshelpwithheld AS `payruntotals.helpwithheld`,
    payruntotalsid AS `payruntotals.id`,
    payruntotalsispublished AS `payruntotals.ispublished`,
    payruntotalsnetearnings AS `payruntotals.netearnings`,
    payruntotalsnotation AS `payruntotals.notation`,
    payruntotalspaygwithheld AS `payruntotals.paygwithheld`,
    payruntotalsposttaxdeductions AS `payruntotals.posttaxdeductions`,
    payruntotalspretaxdeductions AS `payruntotals.pretaxdeductions`,
    payruntotalssfsswithheld AS `payruntotals.sfsswithheld`,
    payruntotalssupercontribution AS `payruntotals.supercontribution`,
    payruntotalstaxableearnings AS `payruntotals.taxableearnings`,
    payruntotalstotalemployeeexpenses AS `payruntotals.totalemployeeexpenses`,
    payruntotalstotalemployerliabilities AS `payruntotals.totalemployerliabilities`,
    payruntotalstotalhours AS `payruntotals.totalhours`,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payruntotals;

-- Accounts View
DROP VIEW IF EXISTS {etani_client_id}_keypay_accounts;
CREATE VIEW {etani_client_id}_keypay_accounts AS
SELECT
    id,
    accountcode,
    accountname,
    accounttype,
    externalreferenceid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_accounts;

-- LeaveRequest View
DROP VIEW IF EXISTS {etani_client_id}_keypay_leaverequest;
CREATE VIEW {etani_client_id}_keypay_leaverequest AS
SELECT
    id,
    attachmentid,
    employee,
    employeeid,
    fromdate,
    hoursapplied,
    leavecategory,
    leavecategoryid,
    notes,
    status,
    todate,
    totalhours,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_leaverequest;

-- PayCategory View
DROP VIEW IF EXISTS {etani_client_id}_keypay_paycategory;
CREATE VIEW {etani_client_id}_keypay_paycategory AS
SELECT
    id,
    accruesleave,
    allowancedescription,
    awardid,
    awardname,
    defaultsuperrate,
    externalid,
    generalledgermappingcode,
    hideunitsonpayslip,
    ispayrolltaxexempt,
    isprimary,
    issystempaycategory,
    istaxexempt,
    name,
    numberofdecimalplaces,
    parentid,
    paycategorytype,
    paymentsummaryclassification,
    penaltyloadingpercent,
    rateloadingpercent,
    rateunit,
    roundingmethod,
    source,
    superexpensemappingcode,
    superliabilitymappingcode,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_paycategory;

-- EmployeePayRate View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employeepayrate;
CREATE VIEW {etani_client_id}_keypay_employeepayrate AS
SELECT
    accruesleave,
    calculatedrate,
    hassuperrateoverride,
    isprimarypaycategory,
    paycategoryid,
    paycategoryname,
    rate,
    rateunit,
    superrate,
    employeeid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employeepayrate;

-- PayRunSummary View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrunsummary;
CREATE VIEW {etani_client_id}_keypay_payrunsummary AS
SELECT
    datefinalised,
    datepaid,
    externalid,
    id,
    isfinalised,
    notation,
    payperiodending,
    payperiodstarting,
    payscheduleid,
    payslipspublished,
    totalgrosswages,
    totalhours,
    totalnetwages,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrunsummary;

-- PaySchedule View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedule;
CREATE VIEW {etani_client_id}_keypay_payschedule AS
SELECT
    abadetailsid,
    autopayconfigadjustdatepaidtoworkday AS `autopayconfiguration.adjustdatepaidtoworkday`,
    autopayconfigadjustrundatetoworkday AS `autopayconfiguration.adjustrundatetoworkday`,
    autopayconfigdayofweek AS `autopayconfiguration.dayofweek`,
    autopayconfigenabled AS `autopayconfiguration.enabled`,
    autopayconfigexportjournals AS `autopayconfiguration.exportjournals`,
    autopayconfigfinalise AS `autopayconfiguration.finalise`,
    autopayconfiginitialdatepaid AS `autopayconfiguration.initialdatepaid`,
    autopayconfiginitialpayperiodending AS `autopayconfiguration.initialpayperiodending`,
    autopayconfiginitialpayruncreationdatetime AS `autopayconfiguration.initialpayruncreationdatetime`,
    autopayconfiglodgepayrun AS `autopayconfiguration.lodgepayrun`,
    autopayconfignextscheduledcreationdatetime AS `autopayconfiguration.nextscheduledcreationdatetimeutc`,
    autopayconfigpaused AS `autopayconfiguration.paused`,
    autopayconfigpublishpayslips AS `autopayconfiguration.publishpayslips`,
    autopayconfigpublishpayslipshour AS `autopayconfiguration.publishpayslipshour`,
    autopayconfigrunonspecificdayofmonth AS `autopayconfiguration.runonspecificdayofmonth`,
    autopayconfigscheduledenddate AS `autopayconfiguration.scheduledenddate`,
    autopayconfigspecificdayofmonth AS `autopayconfiguration.specificdayofmonth`,
    autopayconfigsuppressnotifications AS `autopayconfiguration.suppressnotifications`,
    autopayconfigtimesheetimportoption AS `autopayconfiguration.timesheetimportoption`,
    autopayconfigweekofmonth AS `autopayconfiguration.weekofmonth`,
    defaultfinaliseexportjournals AS `defaultfinalisesettings.exportjournals`,
    defaultfinaliseexportjournalsday AS `defaultfinalisesettings.exportjournalsday`,
    defaultfinaliseexportjournalstimeofday AS `defaultfinalisesettings.exportjournalstimeofday`,
    defaultfinaliseexportjournalstimeline AS `defaultfinalisesettings.exportjournalstimeline`,
    defaultfinaliselodgepayrun AS `defaultfinalisesettings.lodgepayrun`,
    defaultfinaliselodgepayrunday AS `defaultfinalisesettings.lodgepayrunday`,
    defaultfinaliselodgepayruntimeofday AS `defaultfinalisesettings.lodgepayruntimeofday`,
    defaultfinaliselodgepayruntimeline AS `defaultfinalisesettings.lodgepayruntimeline`,
    defaultfinalisepaymentacctdebitsetting AS `defaultfinalisesettings.paymentaccountdebitsetting`,
    defaultfinalisepublishpayslips AS `defaultfinalisesettings.publishpayslips`,
    defaultfinalisepublishpayslipsday AS `defaultfinalisesettings.publishpayslipsday`,
    defaultfinalisepublishpayslipstimeofday AS `defaultfinalisesettings.publishpayslipstimeofday`,
    defaultfinalisepublishpayslipstimeline AS `defaultfinalisesettings.publishpayslipstimeline`,
    defaultfinaliserunreportpacks AS `defaultfinalisesettings.runreportpacks`,
    defaultfinaliserunreportpacksday AS `defaultfinalisesettings.runreportpacksday`,
    defaultfinaliserunreportpackstimeofday AS `defaultfinalisesettings.runreportpackstimeofday`,
    defaultfinaliserunreportpackstimeline AS `defaultfinalisesettings.runreportpackstimeline`,
    defaultfinalisesubmittopensionsync AS `defaultfinalisesettings.submittopensionsync`,
    defaultfinalisesubmittopensionsyncday AS `defaultfinalisesettings.submittopensionsyncday`,
    defaultfinalisesubmittopensionsynctimeofday AS `defaultfinalisesettings.submittopensionsynctimeofday`,
    defaultfinalisesubmittopensionsynctimeline AS `defaultfinalisesettings.submittopensionsynctimeline`,
    defaultfinalisesuperpayment AS `defaultfinalisesettings.superpayment`,
    defaultfinalisesuppressnotifications AS `defaultfinalisesettings.suppressnotifications`,
    employeeselectionstrategy,
    equalmonthlypayments,
    externalid,
    frequency,
    id,
    lastdatepaid,
    lastpayrun,
    name,
    payschedapprovalnotificationsubject AS `payscheduleapprovalsettings.notificationsubject`,
    payschedapprovalnotificationtemplate AS `payscheduleapprovalsettings.notificationtemplate`,
    payschedapprovalreminderday AS `payscheduleapprovalsettings.reminderday`,
    payschedapprovalremindersubject AS `payscheduleapprovalsettings.remindersubject`,
    payschedapprovalremindertemplate AS `payscheduleapprovalsettings.remindertemplate`,
    payschedapprovalrequireapproval AS `payscheduleapprovalsettings.requireapproval`,
    payschedapprovalsendreminder AS `payscheduleapprovalsettings.sendreminder`,
    payschedpaymentapprovalnotificationsubject AS `payschedulepaymentapprovalsettings.notificationsubject`,
    payschedpaymentapprovalnotificationtemplate AS `payschedulepaymentapprovalsettings.notificationtemplate`,
    payschedpaymentapprovalreminderday AS `payschedulepaymentapprovalsettings.reminderday`,
    payschedpaymentapprovalremindersubject AS `payschedulepaymentapprovalsettings.remindersubject`,
    payschedpaymentapprovalremindertemplate AS `payschedulepaymentapprovalsettings.remindertemplate`,
    payschedpaymentapprovalrequireapproval AS `payschedulepaymentapprovalsettings.requireapproval`,
    payschedpaymentapprovalsendreminder AS `payschedulepaymentapprovalsettings.sendreminder`,
    paygaccountbsb,
    paygaccountname,
    paygaccountnumber,
    paygreference,
    source,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedule;

-- Payslip View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslip;
CREATE VIEW {etani_client_id}_keypay_payslip AS
SELECT
    id,
    abn,
    basepayrate,
    baserate,
    businessaddress,
    businessname,
    contactname,
    employeebaserate,
    employeebaserateunit,
    employeeexternalid,
    employeefirstname,
    employeeid,
    employeename,
    employeepostaladdresscountry,
    employeepostaladdressline2,
    employeepostalstreetaddress,
    employeepostalsuburbname,
    employeepostalsuburbpostcode,
    employeepostalsuburbstate,
    employeesurname,
    grossearnings,
    grossytd,
    helpamount,
    helpytd,
    hourlyrate,
    ispublished,
    message,
    netearnings,
    netytd,
    notation,
    payperiodending,
    payperiodstarting,
    paygwithholdingamount,
    paygytd,
    posttaxdeductionamount,
    posttaxdeductionsytd,
    pretaxdeductionamount,
    pretaxdeductionsytd,
    sfssamount,
    sfssytd,
    supercontribution,
    superytd,
    taxableearnings,
    totalhours,
    withholdingytd,
    businessid,
    payrunid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslip;

-- SuperAdjustment View
DROP VIEW IF EXISTS {etani_client_id}_keypay_superadjustment;
CREATE VIEW {etani_client_id}_keypay_superadjustment AS
SELECT
    payrunid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_superadjustment;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Timesheet View
DROP VIEW IF EXISTS {etani_client_id}_keypay_timesheet;
CREATE VIEW {etani_client_id}_keypay_timesheet AS
SELECT
    id,
    attachmentdata AS `attachment.data`,
    attachmentdatecreated AS `attachment.datecreated`,
    attachmentdatescanned AS `attachment.datescanned`,
    attachmentfriendlyname AS `attachment.friendlyname`,
    attachmentid AS `attachment.id`,
    attachmentisdeleted AS `attachment.isdeleted`,
    attachmentisinfected AS `attachment.isinfected`,
    attachmenturl AS `attachment.url`,
    classification,
    classificationid,
    comments,
    employeeid,
    endtime,
    externalid,
    fullyqualifiedlocationname,
    hiddencomments,
    leavecategoryid,
    locationid,
    locationisdeleted,
    paycategoryid,
    rate,
    source,
    starttime,
    status,
    submittedbyuser,
    units,
    worktype,
    worktypeid,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_timesheet;

-- WorkType View
DROP VIEW IF EXISTS {etani_client_id}_keypay_worktype;
CREATE VIEW {etani_client_id}_keypay_worktype AS
SELECT
    id,
    accruesleave,
    awardpackageid,
    awardpackagename,
    externalid,
    leavecategoryid,
    mappingtype,
    name,
    paycategoryid,
    shortcode,
    source,
    businessid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_worktype;

-- BusiAccEmpGroups View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busiaccempgroups;
CREATE VIEW {etani_client_id}_keypay_busiaccempgroups AS
SELECT
    businessaccessid,
    employeegroupid,
    permissions,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busiaccempgroups;

-- BusiAccLocAccess View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busiacclocaccess;
CREATE VIEW {etani_client_id}_keypay_busiacclocaccess AS
SELECT
    businessaccessid,
    filtertype,
    permissions,
    locationids,
    id,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busiacclocaccess;

-- BusiAccKiosks View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busiacckiosks;
CREATE VIEW {etani_client_id}_keypay_busiacckiosks AS
SELECT
    businessaccessid,
    kioskid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busiacckiosks;

-- BusiAccPayApproval View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busiaccpayapproval;
CREATE VIEW {etani_client_id}_keypay_busiaccpayapproval AS
SELECT
    businessaccessid,
    payscheduleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busiaccpayapproval;

-- BusiAccPayCreation View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busiaccpaycreation;
CREATE VIEW {etani_client_id}_keypay_busiaccpaycreation AS
SELECT
    businessaccessid,
    payscheduleid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busiaccpaycreation;

-- BusiDocSelGroups View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busidocselgroups;
CREATE VIEW {etani_client_id}_keypay_busidocselgroups AS
SELECT
    businessdocumentid,
    groupid AS `id`,
    groupname AS `name`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busidocselgroups;

-- BusiDocSelLocs View
DROP VIEW IF EXISTS {etani_client_id}_keypay_busidocsellocs;
CREATE VIEW {etani_client_id}_keypay_busidocsellocs AS
SELECT
    businessdocumentid,
    locationid AS `id`,
    locationname AS `name`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_busidocsellocs;

-- InvoiceLineItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_invoicelineitems;
CREATE VIEW {etani_client_id}_keypay_invoicelineitems AS
SELECT
    invoiceid,
    abn,
    billingplan,
    brandname,
    businessid,
    businessnumber,
    description,
    quantity,
    totalincludinggst,
    unitpriceincludinggst,
    whitelabelname,
    id,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_invoicelineitems;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- InvoiceLineDetails View
DROP VIEW IF EXISTS {etani_client_id}_keypay_invoicelinedetails;
CREATE VIEW {etani_client_id}_keypay_invoicelinedetails AS
SELECT
    invoicelineitemid,
    description,
    groupname,
    id,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_invoicelinedetails;

-- LocationShiftConds View
DROP VIEW IF EXISTS {etani_client_id}_keypay_locationshiftconds;
CREATE VIEW {etani_client_id}_keypay_locationshiftconds AS
SELECT
    locationid,
    shiftconditionid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_locationshiftconds;

-- ChartOfAccDeductionCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccdeductioncats;
CREATE VIEW {etani_client_id}_keypay_chartofaccdeductioncats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    splitbyempentity AS `splitbyemployingentity`,
    splitbylocation,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccdeductioncats;

-- ChartOfAccPayCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccpaycats;
CREATE VIEW {etani_client_id}_keypay_chartofaccpaycats AS
SELECT
    expenseaccountid,
    id,
    name,
    splitbyempentity AS `splitbyemployingentity`,
    splitbylocation,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccpaycats;

-- ChartOfAccEmpExpenseCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempexpensecats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempexpensecats AS
SELECT
    expenseaccountid,
    id,
    name,
    splitbyempentity AS `splitbyemployingentity`,
    splitbylocation,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempexpensecats;

-- ChartOfAccEmpLiabilityCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempliabilitycats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempliabilitycats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    splitbyempentity AS `splitbyemployingentity`,
    splitbylocation,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempliabilitycats;

-- ChartOfAccLeaveCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccleavecats;
CREATE VIEW {etani_client_id}_keypay_chartofaccleavecats AS
SELECT
    accruefromcontingentperiod,
    expenseaccountid,
    id,
    islongserviceleave,
    liabilityaccountid,
    name,
    splitbyempentity AS `splitbyemployingentity`,
    splitbylocation,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccleavecats;

-- ChartOfAccEmpEntity View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentity;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentity AS
SELECT
    employingentityid,
    defexpenseaccountid AS `defaultaccounts.defaultexpenseaccountid`,
    defliabilityaccountid AS `defaultaccounts.defaultliabilityaccountid`,
    empexpenseaccountid AS `defaultaccounts.employeeexpenseaccountid`,
    paymentaccountid AS `defaultaccounts.paymentaccountid`,
    id,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentity;

-- ChartOfAccLocation View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocation;
CREATE VIEW {etani_client_id}_keypay_chartofacclocation AS
SELECT
    locationid,
    defexpenseaccountid AS `defaultaccounts.defaultexpenseaccountid`,
    defliabilityaccountid AS `defaultaccounts.defaultliabilityaccountid`,
    empexpenseaccountid AS `defaultaccounts.employeeexpenseaccountid`,
    paymentaccountid AS `defaultaccounts.paymentaccountid`,
    id,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocation;

-- ChartOfAccLocDeductionCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocdeductioncats;
CREATE VIEW {etani_client_id}_keypay_chartofacclocdeductioncats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocdeductioncats;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- ChartOfAccLocEmpExpenseCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocempexpensecats;
CREATE VIEW {etani_client_id}_keypay_chartofacclocempexpensecats AS
SELECT
    expenseaccountid,
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocempexpensecats;

-- ChartOfAccLocEmpLiabilityCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocempliabilitycats;
CREATE VIEW {etani_client_id}_keypay_chartofacclocempliabilitycats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocempliabilitycats;

-- ChartOfAccLocLeaveCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocleavecats;
CREATE VIEW {etani_client_id}_keypay_chartofacclocleavecats AS
SELECT
    accruefromcontingentperiod,
    expenseaccountid,
    id,
    islongserviceleave,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocleavecats;

-- ChartOfAccLocPayCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofacclocpaycats;
CREATE VIEW {etani_client_id}_keypay_chartofacclocpaycats AS
SELECT
    expenseaccountid,
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofacclocpaycats;

-- ChartOfAccEmpEntDeductionCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentdeductioncats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentdeductioncats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentdeductioncats;

-- ChartOfAccEmpEntEmpExpenseCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentempexpensecats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentempexpensecats AS
SELECT
    expenseaccountid,
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentempexpensecats;

-- ChartOfAccEmpEntEmpLiabilityCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentempliabilitycats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentempliabilitycats AS
SELECT
    expenseaccountid,
    id,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentempliabilitycats;

-- ChartOfAccEmpEntLeaveCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentleavecats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentleavecats AS
SELECT
    accruefromcontingentperiod,
    expenseaccountid,
    id,
    islongserviceleave,
    liabilityaccountid,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentleavecats;

-- ChartOfAccEmpEntPayCats View
DROP VIEW IF EXISTS {etani_client_id}_keypay_chartofaccempentpaycats;
CREATE VIEW {etani_client_id}_keypay_chartofaccempentpaycats AS
SELECT
    expenseaccountid,
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_chartofaccempentpaycats;

-- PayRunDeductionItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrundeductionitems;
CREATE VIEW {etani_client_id}_keypay_payrundeductionitems AS
SELECT
    payrunid,
    deductioncategoryid,
    deductioncategoryname,
    amount,
    notes,
    paymentreference,
    note,
    paytobankaccountbsb,
    paytobankaccbankcode AS `paytobankaccountbankcode`,
    paytobankaccnumber AS `paytobankaccountnumber`,
    paytosuperfundname,
    paytosuperfundmembernum AS `paytosuperfundmembernumber`,
    payto,
    additionaldata,
    id,
    externalid,
    locationid,
    locationname,
    employeeid,
    employeename,
    employeeexternalid,
    assocempdeductioncategoryid AS `associatedemployeedeductioncategoryid`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrundeductionitems;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayRunEarningsLineItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrunearningslineitems;
CREATE VIEW {etani_client_id}_keypay_payrunearningslineitems AS
SELECT
    payrunid,
    super,
    sfss,
    help,
    payg,
    paycategoryid,
    paycategoryname,
    units,
    notes,
    rate,
    earnings,
    lumpsumnumofpayperiods AS `lumpsumnumberofpayperiods`,
    lumpsumcalculationmethod,
    lumpsumefinancialyear,
    timesheetlineid,
    timesheetlineexternalid,
    id,
    externalid,
    locationid,
    locationname,
    employeeid,
    employeename,
    employeeexternalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrunearningslineitems;

-- PayRunEmpExpenseItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payrunempexpenseitems;
CREATE VIEW {etani_client_id}_keypay_payrunempexpenseitems AS
SELECT
    payrunid,
    employeeexpensecategoryid,
    employeeexpensecategoryname,
    notes,
    amount,
    taxcode,
    taxrate,
    taxcodedisplayname,
    id,
    externalid,
    locationid,
    locationname,
    employeeid,
    employeename,
    employeeexternalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payrunempexpenseitems;

-- EmployeeGroupFilters View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employeegroupfilters;
CREATE VIEW {etani_client_id}_keypay_employeegroupfilters AS
SELECT
    employeegroupid,
    filtertype,
    operator,
    value,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employeegroupfilters;

-- EmployerLiabilityItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_employerliabilityitems;
CREATE VIEW {etani_client_id}_keypay_employerliabilityitems AS
SELECT
    payrunid,
    id,
    amount,
    employeeexternalid,
    employeeid,
    employeename,
    employerliabilitycategoryid,
    employerliabilitycategoryname,
    externalid,
    locationid,
    locationname,
    notes,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_employerliabilityitems;

-- LeaveCatTiers View
DROP VIEW IF EXISTS {etani_client_id}_keypay_leavecattiers;
CREATE VIEW {etani_client_id}_keypay_leavecattiers AS
SELECT
    leavecategoryid,
    id,
    accrualamount,
    accrualstartafter,
    accrualstartafterunittype,
    accrualunittype,
    isdeleted,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_leavecattiers;

-- PaygAdjustmentItems View
DROP VIEW IF EXISTS {etani_client_id}_keypay_paygadjustmentitems;
CREATE VIEW {etani_client_id}_keypay_paygadjustmentitems AS
SELECT
    payrunid,
    id,
    notes,
    amount,
    externalid,
    locationid,
    locationname,
    employeeid,
    employeename,
    employeeexternalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_paygadjustmentitems;

-- PayRateTemplateCategories View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payratetemplatecategories;
CREATE VIEW {etani_client_id}_keypay_payratetemplatecategories AS
SELECT
    payratetemplateid,
    paycategoryid,
    calculatedrate,
    standardweeklyhours,
    usersuppliedrate,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payratetemplatecategories;

-- PaySchedAutoPayReports View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedautopayreports;
CREATE VIEW {etani_client_id}_keypay_payschedautopayreports AS
SELECT
    payscheduleid,
    reportpackid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedautopayreports;

-- PaySchedAutoPayUsers View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedautopayusers;
CREATE VIEW {etani_client_id}_keypay_payschedautopayusers AS
SELECT
    payscheduleid,
    userid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedautopayusers;

-- PaySchedDefaultReports View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payscheddefaultreports;
CREATE VIEW {etani_client_id}_keypay_payscheddefaultreports AS
SELECT
    payscheduleid,
    reportpackid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payscheddefaultreports;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PaySchedApprovalUsers View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedapprovalusers;
CREATE VIEW {etani_client_id}_keypay_payschedapprovalusers AS
SELECT
    payscheduleid,
    userid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedapprovalusers;

-- PaySchedPaymentApprovalUsers View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedpaymentapprovalusers;
CREATE VIEW {etani_client_id}_keypay_payschedpaymentapprovalusers AS
SELECT
    payscheduleid,
    userid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedpaymentapprovalusers;

-- PaySchedIgnoredWarnings View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedignoredwarnings;
CREATE VIEW {etani_client_id}_keypay_payschedignoredwarnings AS
SELECT
    payscheduleid,
    warningid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedignoredwarnings;

-- PaySchedLocations View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payschedlocations;
CREATE VIEW {etani_client_id}_keypay_payschedlocations AS
SELECT
    payscheduleid,
    locationid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payschedlocations;

-- PayslipAccruedLeave View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipaccruedleave;
CREATE VIEW {etani_client_id}_keypay_payslipaccruedleave AS
SELECT
    payslipid,
    name,
    amount,
    balance,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipaccruedleave;

-- PayslipBankPayments View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipbankpayments;
CREATE VIEW {etani_client_id}_keypay_payslipbankpayments AS
SELECT
    payslipid,
    accountname,
    accountnumber,
    amount,
    bsb,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipbankpayments;

-- PayslipDeductions View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipdeductions;
CREATE VIEW {etani_client_id}_keypay_payslipdeductions AS
SELECT
    payslipid,
    name,
    amount,
    ytdamount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipdeductions;

-- PayslipEarningsLines View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipearningslines;
CREATE VIEW {etani_client_id}_keypay_payslipearningslines AS
SELECT
    payslipid,
    name,
    amount,
    rate,
    units,
    ytdamount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipearningslines;

-- PayslipEmployeeExpenses View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipemployeeexpenses;
CREATE VIEW {etani_client_id}_keypay_payslipemployeeexpenses AS
SELECT
    payslipid,
    id,
    amount,
    description,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipemployeeexpenses;

-- PayslipGrossYTDDetails View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipgrossytddetails;
CREATE VIEW {etani_client_id}_keypay_payslipgrossytddetails AS
SELECT
    payslipid,
    name,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipgrossytddetails;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayslipLeaveTaken View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipleavetaken;
CREATE VIEW {etani_client_id}_keypay_payslipleavetaken AS
SELECT
    payslipid,
    name,
    amount,
    hours,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipleavetaken;

-- PayslipPaygAdjustments View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslippaygadjustments;
CREATE VIEW {etani_client_id}_keypay_payslippaygadjustments AS
SELECT
    payslipid,
    name,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslippaygadjustments;

-- PayslipSuperAdjustments View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipsuperadjustments;
CREATE VIEW {etani_client_id}_keypay_payslipsuperadjustments AS
SELECT
    payslipid,
    name,
    amount,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipsuperadjustments;

-- PayslipSuperPayments View
DROP VIEW IF EXISTS {etani_client_id}_keypay_payslipsuperpayments;
CREATE VIEW {etani_client_id}_keypay_payslipsuperpayments AS
SELECT
    payslipid,
    fundname,
    amount,
    fundcode,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_payslipsuperpayments;

-- PayslipTotalAccruedLeave View
DROP VIEW IF EXISTS {etani_client_id}_keypay_paysliptotalaccruedleave;
CREATE VIEW {etani_client_id}_keypay_paysliptotalaccruedleave AS
SELECT
    payslipid,
    name,
    amount,
    balance,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_paysliptotalaccruedleave;

-- SuperAdjustmentDetails View
DROP VIEW IF EXISTS {etani_client_id}_keypay_superadjustmentdetails;
CREATE VIEW {etani_client_id}_keypay_superadjustmentdetails AS
SELECT
    payrunid,
    id,
    amount,
    contributiontype,
    empexternalid AS `employeeexternalid`,
    employeeid,
    employeename,
    externalid,
    locationid,
    locationname,
    notes,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_superadjustmentdetails;

-- TimesheetBreaks View
DROP VIEW IF EXISTS {etani_client_id}_keypay_timesheetbreaks;
CREATE VIEW {etani_client_id}_keypay_timesheetbreaks AS
SELECT
    timesheetid,
    starttime,
    endtime,
    ispaidbreak,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_timesheetbreaks;

-- TimesheetDimensionValues View
DROP VIEW IF EXISTS {etani_client_id}_keypay_timesheetdimensionvalues;
CREATE VIEW {etani_client_id}_keypay_timesheetdimensionvalues AS
SELECT
    timesheetid,
    dimensionvalueid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_timesheetdimensionvalues;

-- TimesheetShiftConditionIds View
DROP VIEW IF EXISTS {etani_client_id}_keypay_timesheetshiftconditionids;
CREATE VIEW {etani_client_id}_keypay_timesheetshiftconditionids AS
SELECT
    timesheetid,
    shiftconditionid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_timesheetshiftconditionids;

-- TimesheetShiftConditions View
DROP VIEW IF EXISTS {etani_client_id}_keypay_timesheetshiftconditions;
CREATE VIEW {etani_client_id}_keypay_timesheetshiftconditions AS
SELECT
    timesheetid,
    id,
    name,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_timesheetshiftconditions;

-- Pattern: {etani_client_id}_keypay_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- WorkEmploymentTypes View
DROP VIEW IF EXISTS {etani_client_id}_keypay_workemploymenttypes;
CREATE VIEW {etani_client_id}_keypay_workemploymenttypes AS
SELECT
    worktypeid,
    employmenttype,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_keypay_workemploymenttypes;