-- DEPUTY Views - Auto Generated
-- Pattern: {etani_client_id}_deputy_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Address View
DROP VIEW IF EXISTS {etani_client_id}_deputy_address;
CREATE VIEW {etani_client_id}_deputy_address AS
SELECT
    id,
    contactname,
    unitno,
    streetno,
    suiteno,
    pobox,
    street1,
    street2,
    city,
    state,
    postcode,
    countryid AS `country`,
    phone,
    saved,
    creatorid AS `creator`,
    created,
    modified,
    notes,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_address;

-- Category View
DROP VIEW IF EXISTS {etani_client_id}_deputy_category;
CREATE VIEW {etani_client_id}_deputy_category AS
SELECT
    id,
    category,
    `group`,
    sortorder,
    stafflog,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_category;

-- Comment View
DROP VIEW IF EXISTS {etani_client_id}_deputy_comment;
CREATE VIEW {etani_client_id}_deputy_comment AS
SELECT
    id,
    orm,
    recid,
    infeed,
    comment,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_comment;

-- CompanyPeriod View
DROP VIEW IF EXISTS {etani_client_id}_deputy_companyperiod;
CREATE VIEW {etani_client_id}_deputy_companyperiod AS
SELECT
    id,
    datestart,
    start,
    `end`,
    dateend,
    companyid AS `company`,
    payperiodid AS `payperiod`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_companyperiod;

-- Contact View
DROP VIEW IF EXISTS {etani_client_id}_deputy_contact;
CREATE VIEW {etani_client_id}_deputy_contact AS
SELECT
    id,
    phone1,
    phone2,
    phone3,
    phone1type,
    phone2type,
    phone3type,
    primaryphone,
    email1,
    email2,
    primaryemail,
    email1type,
    email2type,
    im1,
    im2,
    im1type,
    im2type,
    web,
    notes,
    saved,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_contact;

-- Country View
DROP VIEW IF EXISTS {etani_client_id}_deputy_country;
CREATE VIEW {etani_client_id}_deputy_country AS
SELECT
    id,
    code,
    codea3,
    region,
    active,
    sortorder,
    countryname AS `country`,
    zipvalidatepreg,
    phonedisplaypreg,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_country;

-- CustomAppData View
DROP VIEW IF EXISTS {etani_client_id}_deputy_customappdata;
CREATE VIEW {etani_client_id}_deputy_customappdata AS
SELECT
    documentid,
    `data`,
    keyint,
    keystring,
    label,
    operationalunitid AS `operationalunit`,
    employeeid AS `employee`,
    permission,
    deleted,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_customappdata;

-- CustomField View
DROP VIEW IF EXISTS {etani_client_id}_deputy_customfield;
CREATE VIEW {etani_client_id}_deputy_customfield AS
SELECT
    id,
    `system`,
    name,
    apiname,
    type,
    deputyfield,
    valuelist,
    published,
    validation,
    conditionalrules,
    displaytiming,
    action,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_customfield;

-- CustomFieldData View
DROP VIEW IF EXISTS {etani_client_id}_deputy_customfielddata;
CREATE VIEW {etani_client_id}_deputy_customfielddata AS
SELECT
    `system`,
    f01,
    f02,
    f03,
    f04,
    f05,
    f06,
    f07,
    f08,
    f09,
    f10,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_customfielddata;

-- Company View
DROP VIEW IF EXISTS {etani_client_id}_deputy_company;
CREATE VIEW {etani_client_id}_deputy_company AS
SELECT
    id,
    code,
    active,
    parentcompanyid AS `parentcompany`,
    companyname,
    companynumber,
    tradingname,
    isworkplace,
    ispayrollentity,
    payrollexportcode,
    addressid AS `address`,
    contactid AS `contact`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_company;


-- Pattern: {etani_client_id}_deputy_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Employee View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employee;
CREATE VIEW {etani_client_id}_deputy_employee AS
SELECT
    id,
    companyid AS `company`,
    firstname,
    lastname,
    displayname,
    othername,
    saluation,
    active,
    roleid AS `role`,
    dateofbirth,
    gender,
    pronouns,
    custompronouns,
    startdate,
    terminationdate,
    allowappraisal,
    mainaddressid AS `mainaddress`,
    postaladdressid AS `postaladdress`,
    emergencyaddressid AS `emergencyaddress`,
    contactid AS `contact`,
    photoid AS `photo`,
    userid AS `user`,
    stressprofileid AS `stressprofile`,
    trainingrecordsid AS `trainingrecords`,
    historyid,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employee;

-- PayRules View
DROP VIEW IF EXISTS {etani_client_id}_deputy_payrules;
CREATE VIEW {etani_client_id}_deputy_payrules AS
SELECT
    id,
    remunerationtype,
    remunerationby,
    paytitle,
    isexported,
    annualsalary,
    hourlyrate,
    ismultiplier,
    multipliervalue,
    multiplierbaserateid AS `multiplierbaserate`,
    unitvalue,
    minimumtype,
    maximumtype,
    minimumvalue,
    maximumvalue,
    minimumshiftlength,
    maximumshiftlength,
    schedule,
    recommendwith,
    dexmlscriptid AS `dexmlscript`,
    dexmlscriptparam,
    payportionrule,
    payrollcategory,
    ratetype,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_payrules;

-- TimesheetPayReturn View
DROP VIEW IF EXISTS {etani_client_id}_deputy_timesheetpayreturn;
CREATE VIEW {etani_client_id}_deputy_timesheetpayreturn AS
SELECT
    id,
    timesheetid AS `timesheet`,
    payruleid AS `payrule`,
    overridden,
    value,
    cost,
    overridecomment,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_timesheetpayreturn;

-- EmployeeAgreement View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeeagreement;
CREATE VIEW {etani_client_id}_deputy_employeeagreement AS
SELECT
    id,
    employeeid,
    paypointid AS `paypoint`,
    emptype,
    companyname,
    active,
    startdate,
    contractid AS `contract`,
    salarypayruleid AS `salarypayrule`,
    payrollid,
    payperiodid AS `payperiod`,
    historyid,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeeagreement;

-- EmployeeAgreementHistory View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeeagreementhistory;
CREATE VIEW {etani_client_id}_deputy_employeeagreementhistory AS
SELECT
    id,
    agreementid,
    paypointid AS `paypoint`,
    emptype,
    companyname,
    active,
    startdate,
    contractid AS `contract`,
    salarypayruleid AS `salarypayrule`,
    payrollid,
    payperiodid AS `payperiod`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeeagreementhistory;

-- EmployeeAppraisal View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeeappraisal;
CREATE VIEW {etani_client_id}_deputy_employeeappraisal AS
SELECT
    id,
    employeeid AS `employee`,
    daytimestamp,
    date,
    mark01,
    mark02,
    mark03,
    mark04,
    mark05,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeeappraisal;

-- EmployeeAvailability View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeeavailability;
CREATE VIEW {etani_client_id}_deputy_employeeavailability AS
SELECT
    id,
    employeeid AS `employee`,
    type,
    maxdaterecurringgenerated,
    starttime,
    endtime,
    date,
    comment,
    scheduleid AS `schedule`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeeavailability;

-- EmployeeHistory View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeehistory;
CREATE VIEW {etani_client_id}_deputy_employeehistory AS
SELECT
    id,
    companyid AS `company`,
    firstname,
    lastname,
    displayname,
    othername,
    salutation,
    mainaddressid AS `mainaddress`,
    postaladdressid AS `postaladdress`,
    emergencyaddressid AS `emergencyaddress`,
    dateofbirth,
    gender,
    photoid AS `photo`,
    active,
    startdate,
    terminationdate,
    position,
    roleid AS `role`,
    employeeid,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeehistory;

-- EmployeePaycycle View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeepaycycle;
CREATE VIEW {etani_client_id}_deputy_employeepaycycle AS
SELECT
    id,
    employeeid,
    employeeagreementid,
    periodid,
    recommendedloadings,
    timesheets,
    timesheetstimeapproved,
    timesheetspayapproved,
    paycyclerulesid AS `paycyclerules`,
    paycyclerulesapproved,
    exported,
    exportid,
    paid,
    timetotal,
    costtotal,
    employeeagreementhistoryid,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeepaycycle;

-- EmployeePayCycleReturn View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeepaycyclereturn;
CREATE VIEW {etani_client_id}_deputy_employeepaycyclereturn AS
SELECT
    id,
    paycycleid,
    payruleid AS `payrule`,
    approved,
    overridden,
    value,
    cost,
    overridecomment,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeepaycyclereturn;

-- Pattern: {etani_client_id}_deputy_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- EmployeeRole View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeerole;
CREATE VIEW {etani_client_id}_deputy_employeerole AS
SELECT
    id,
    role,
    ranking,
    reporttoid AS `reportto`,
    permissions,
    require2fa,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeerole;

-- EmployeeSalaryCost View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeesalarycost;
CREATE VIEW {etani_client_id}_deputy_employeesalarycost AS
SELECT
    id,
    employeeid AS `employee`,
    employeeagreementid AS `employeeagreement`,
    daytimestamp,
    date,
    opunitid AS `opunit`,
    cost,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeesalarycost;

-- EmployeeWorkplace View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employeeworkplace;
CREATE VIEW {etani_client_id}_deputy_employeeworkplace AS
SELECT
    id,
    employeeid,
    companyid AS `company`,
    sortorder,
    agreement1id AS `agreement1`,
    agreement2id AS `agreement2`,
    agreement3id AS `agreement3`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employeeworkplace;

-- EmploymentCondition View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employmentcondition;
CREATE VIEW {etani_client_id}_deputy_employmentcondition AS
SELECT
    id,
    name,
    description,
    workingdaysperperiod,
    usualstarttime,
    usualfinishtime,
    usualmealbreak,
    avghoursperday,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employmentcondition;

-- EmploymentContract View
DROP VIEW IF EXISTS {etani_client_id}_deputy_employmentcontract;
CREATE VIEW {etani_client_id}_deputy_employmentcontract AS
SELECT
    id,
    code,
    name,
    description,
    employmentbasis,
    employmentcategory,
    employmentstatus,
    employmentconditionid AS `employmentcondition`,
    basepayruleid AS `basepayrule`,
    stressprofileid AS `stressprofile`,
    startdate,
    enddate,
    periodtype,
    file,
    strictleaveapproval,
    award,
    employmentsubtype,
    awardstartdate,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_employmentcontract;

-- ContractLeaveRules View
DROP VIEW IF EXISTS {etani_client_id}_deputy_contractleaverules;
CREATE VIEW {etani_client_id}_deputy_contractleaverules AS
SELECT
    id,
    contractid,
    leaveruleid,
    basepayruleid AS `basepayrule`,
    loadingpayrule1id AS `loadingpayrule1`,
    loadingpayrule2id AS `loadingpayrule2`,
    loadingpayrule3id AS `loadingpayrule3`,
    creatorid AS `creator`,
    created,
    modified,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_deputy_contractleaverules;