-- DQ_MYOBAR Production Tables - Auto Generated
-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Contact Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_contact;
CREATE TABLE c{clientID}_dq_myobar_contact (
    uid VARCHAR(255),
    lastname TEXT,
    firstname TEXT,
    isindividual BOOLEAN,
    displayid VARCHAR(255),
    isactive BOOLEAN,
    addresses JSON,
    notes TEXT,
    identifiers JSON,
    customlist1 TEXT,
    customlist2 TEXT,
    customlist3 TEXT,
    currentbalance DECIMAL(15,2),
    type VARCHAR(255),
    lastmodified DATETIME,
    photouri TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    customfield1label TEXT,
    customfield1value TEXT,
    customfield2label TEXT,
    customfield2value TEXT,
    customfield3label TEXT,
    customfield3value TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- ContactCustomer Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_contactcustomer;
CREATE TABLE c{clientID}_dq_myobar_contactcustomer (
    uid VARCHAR(255),
    lastname TEXT,
    firstname TEXT,
    isindividual BOOLEAN,
    displayid VARCHAR(255),
    isactive BOOLEAN,
    addresses JSON,
    currentbalance DECIMAL(15,2),
    sellingdetails JSON,
    lastmodified DATETIME,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- ContactSupplier Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_contactsupplier;
CREATE TABLE c{clientID}_dq_myobar_contactsupplier (
    uid VARCHAR(255),
    companyname TEXT,
    isindividual BOOLEAN,
    displayid VARCHAR(255),
    isactive BOOLEAN,
    addresses JSON,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    buyingdetailspurchaselayout TEXT,
    buyingdetailsexpenseaccount TEXT,
    buyingdetailsexpenseaccountuid VARCHAR(255),
    buyingdetailsexpenseaccountname TEXT,
    paymentdetailsbsbnumber TEXT,
    paymentdetailsbankaccountnumber TEXT,
    paymentdetailsbankaccountname TEXT,
    paymentdetailsstatementtext VARCHAR(255),
    paymentdetailsrefund TEXT,
    paymentdetailsrefundpaymentmethod TEXT,
    paymentdetailsrefundcardnumber TEXT,
    paymentdetailsrefundnameoncard TEXT,
    paymentdetailsrefundnotes TEXT,
    paymentdetailsforeigncurrency TEXT,
    paymentdetailslastmodified TEXT,
    paymentdetailsphotouri TEXT,
    paymentdetailsuri TEXT,
    paymentdetailsrowversion TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- ContactEmployee Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_contactemployee;
CREATE TABLE c{clientID}_dq_myobar_contactemployee (
    uid VARCHAR(255),
    lastname TEXT,
    firstname TEXT,
    isindividual BOOLEAN,
    displayid VARCHAR(255),
    isactive BOOLEAN,
    addresses JSON,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    employeepayrolldetailsuid VARCHAR(255),
    timebillingdetailsemployeebillingrateexcludingtax INT,
    timebillingdetailscostperhour INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- EmployeePayrollDetails Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_employeepayrolldetails;
CREATE TABLE c{clientID}_dq_myobar_employeepayrolldetails (
    uid VARCHAR(255),
    dateofbirth DATETIME,
    gender TEXT,
    startdate DATETIME,
    employmentbasis TEXT,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    employeeuid VARCHAR(255),
    employeename TEXT,
    employeedisplayid VARCHAR(255),
    employeeuri TEXT,
    wagepaybasis TEXT,
    wageannualsalary TEXT,
    wagepayfrequency TEXT,
    taxtaxfilenumber TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- EmployeePaymentDetails Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_employeepaymentdetails;
CREATE TABLE c{clientID}_dq_myobar_employeepaymentdetails (
    uid VARCHAR(255),
    paymentmethod TEXT,
    bankstatementtext VARCHAR(255),
    bankaccounts JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    employeeuid VARCHAR(255),
    employeename TEXT,
    employeedisplayid VARCHAR(255),
    employeeuri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- EmployeeStandardPay Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_employeestandardpay;
CREATE TABLE c{clientID}_dq_myobar_employeestandardpay (
    uid VARCHAR(255),
    payfrequency TEXT,
    hoursperpayfrequency INT,
    payrollcategories JSON,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    employeeuid VARCHAR(255),
    employeename TEXT,
    employeedisplayid VARCHAR(255),
    employeeuri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Personal Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_personal;
CREATE TABLE c{clientID}_dq_myobar_personal (
    uid VARCHAR(255),
    lastname TEXT,
    firstname TEXT,
    isindividual BOOLEAN,
    displayid VARCHAR(255),
    isactive BOOLEAN,
    currentbalance DECIMAL(18,2),
    lastmodified DATETIME,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    addressesstreet TEXT,
    addressescity TEXT,
    addressesstate VARCHAR(255),
    addressespostcode VARCHAR(255),
    addressescountry TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SaleInvoice Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_saleinvoice;
CREATE TABLE c{clientID}_dq_myobar_saleinvoice (
    uid VARCHAR(255),
    number VARCHAR(100),
    date DATETIME,
    customerpurchaseordernumber VARCHAR(100),
    customer JSON,
    promiseddate DATETIME,
    balancedueamount DECIMAL(18,2),
    status VARCHAR(50),
    invoicetype VARCHAR(50),
    shiptoaddress TEXT,
    terms JSON,
    istaxinclusive BOOLEAN,
    subtotal DECIMAL(18,2),
    totaltax DECIMAL(18,2),
    totalamount DECIMAL(18,2),
    freighttaxcode JSON,
    category JSON,
    salesperson JSON,
    comment TEXT,
    shippingmethod VARCHAR(100),
    journalmemo TEXT,
    referralsource VARCHAR(100),
    orderuid VARCHAR(255),
    ordernumber TEXT,
    orderuri TEXT,
    invoicedeliverystatus VARCHAR(50),
    lastpaymentdate DATETIME,
    canapplysurcharge BOOLEAN,
    onlinepaymentmethod VARCHAR(50),
    lastmodified DATETIME,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SaleCustomerPayment Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_salecustomerpayment;
CREATE TABLE c{clientID}_dq_myobar_salecustomerpayment (
    uid VARCHAR(255),
    depositto TEXT,
    receiptnumber TEXT,
    date DATETIME,
    amountreceived DECIMAL(18,2),
    paymentmethod TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);


-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleCreditRefund Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_salecreditrefund;
CREATE TABLE c{clientID}_dq_myobar_salecreditrefund (
    uid VARCHAR(255),
    number TEXT,
    payee TEXT,
    date DATETIME,
    amount DECIMAL(18,2),
    memo TEXT,
    chequeprinted BOOLEAN,
    deliverystatus VARCHAR(255),
    foreigncurrency JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    invoiceuid VARCHAR(255),
    invoicenumber TEXT,
    invoiceuri TEXT,
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SaleCreditSettlement Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_salecreditsettlement;
CREATE TABLE c{clientID}_dq_myobar_salecreditsettlement (
    uid VARCHAR(255),
    number TEXT,
    date DATETIME,
    creditamount DECIMAL(18,2),
    memo TEXT,
    foreigncurrencyuid VARCHAR(255),
    foreigncurrencycode TEXT,
    foreigncurrencycurrencyname TEXT,
    foreigncurrencyuri TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    creditfrominvoiceuid VARCHAR(255),
    creditfrominvoicenumber TEXT,
    creditfrominvoiceuri TEXT,
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SaleOrder Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_saleorder;
CREATE TABLE c{clientID}_dq_myobar_saleorder (
    uid VARCHAR(255),
    number TEXT,
    date DATETIME,
    customerpurchaseordernumber TEXT,
    istaxinclusive BOOLEAN,
    subtotal DECIMAL(18,2),
    totalamount DECIMAL(18,2),
    status VARCHAR(255),
    ordertype VARCHAR(255),
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    termspaymentisdue TEXT,
    termsdiscountdate INT,
    termsbalanceduedate INT,
    termsdiscountforearlypayment INT,
    termsmonthlychargeforlatepayment INT,
    termsdiscountexpirydate TEXT,
    termsdiscount INT,
    termsduedate TEXT,
    termsfinancecharge INT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SaleQuote Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_salequote;
CREATE TABLE c{clientID}_dq_myobar_salequote (
    uid VARCHAR(255),
    number VARCHAR(100),
    date DATETIME,
    customerpurchaseordernumber TEXT,
    istaxinclusive BOOLEAN,
    subtotal DECIMAL(18,2),
    freight DECIMAL(18,2),
    totaltax DECIMAL(18,2),
    totalamount DECIMAL(18,2),
    category JSON,
    salesperson JSON,
    journalmemo TEXT,
    referralsource VARCHAR(255),
    balancedueamount DECIMAL(18,2),
    quotetype VARCHAR(50),
    foreigncurrency JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    termspaymentisdue TEXT,
    termsdiscountdate INT,
    termsbalanceduedate INT,
    termsdiscountforearlypayment INT,
    termsmonthlychargeforlatepayment INT,
    termsdiscountexpirydate TEXT,
    termsdiscount INT,
    termsduedate TEXT,
    termsfinancecharge INT,
    freighttaxcodeuid VARCHAR(255),
    freighttaxcodecode VARCHAR(255),
    freighttaxcodeuri VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- PurchaseBill Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchasebill;
CREATE TABLE c{clientID}_dq_myobar_purchasebill (
    uid VARCHAR(255),
    number VARCHAR(100),
    date DATETIME,
    supplierinvoicenumber VARCHAR(100),
    shiptoaddress TEXT,
    istaxinclusive BOOLEAN,
    isreportable BOOLEAN,
    subtotal DECIMAL(18,2),
    subtotalforeign DECIMAL(18,2),
    freight DECIMAL(18,2),
    freightforeign DECIMAL(18,2),
    totaltax DECIMAL(18,2),
    totaltaxforeign DECIMAL(18,2),
    totalamount DECIMAL(18,2),
    totalamountforeign DECIMAL(18,2),
    comment TEXT,
    shippingmethod VARCHAR(100),
    promiseddate DATETIME,
    journalmemo TEXT,
    billdeliverystatus VARCHAR(50),
    appliedtodate DECIMAL(18,2),
    appliedtodateforeign DECIMAL(18,2),
    balancedueamount DECIMAL(18,2),
    balancedueamountforeign DECIMAL(18,2),
    status VARCHAR(50),
    lastpaymentdate DATETIME,
    billtype VARCHAR(50),
    foreigncurrency VARCHAR(10),
    currencyexchangerate DECIMAL(18,6),
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    supplieruid VARCHAR(255),
    suppliername TEXT,
    supplierdisplayid VARCHAR(255),
    supplieruri TEXT,
    termspaymentisdue TEXT,
    termsdiscountdate INT,
    termsbalanceduedate INT,
    termsdiscountforearlypayment INT,
    termsmonthlychargeforlatepayment INT,
    termsdiscountexpirydate TEXT,
    termsdiscount DECIMAL(10,2),
    termsdiscountforeign TEXT,
    termsduedate TEXT,
    freighttaxcodeuid VARCHAR(255),
    freighttaxcodecode VARCHAR(255),
    freighttaxcodeuri VARCHAR(255),
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    orderuid VARCHAR(255),
    ordernumber TEXT,
    orderuri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- PurchaseOrder Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchaseorder;
CREATE TABLE c{clientID}_dq_myobar_purchaseorder (
    uid VARCHAR(255),
    number TEXT,
    date DATETIME,
    supplierinvoicenumber TEXT,
    shiptoaddress VARCHAR(1024),
    totalamount DECIMAL(19,4),
    status VARCHAR(255),
    ordertype VARCHAR(255),
    uri VARCHAR(1024),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    supplieruid VARCHAR(255),
    suppliername TEXT,
    supplierdisplayid VARCHAR(255),
    supplieruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- PurchaseSupplierPayment Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchasesupplierpayment;
CREATE TABLE c{clientID}_dq_myobar_purchasesupplierpayment (
    uid VARCHAR(255),
    payfrom TEXT,
    paymentnumber TEXT,
    date DATETIME,
    amountpaid DECIMAL(19,4),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    supplieruid VARCHAR(255),
    suppliername TEXT,
    supplierdisplayid VARCHAR(255),
    supplieruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- PurchaseDebitRefund Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchasedebitrefund;
CREATE TABLE c{clientID}_dq_myobar_purchasedebitrefund (
    uid VARCHAR(255),
    depositto TEXT,
    number TEXT,
    date DATETIME,
    amount DECIMAL(18,2),
    memo TEXT,
    paymentmethod JSON,
    foreigncurrency JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    billuid VARCHAR(255),
    billnumber TEXT,
    billuri TEXT,
    supplieruid VARCHAR(255),
    suppliername TEXT,
    supplierdisplayid VARCHAR(255),
    supplieruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- PurchaseDebitSettlement Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchasedebitsettlement;
CREATE TABLE c{clientID}_dq_myobar_purchasedebitsettlement (
    uid VARCHAR(255),
    debitfrombilluid VARCHAR(255),
    debitfrombillnumber TEXT,
    debitfrombilluri TEXT,
    supplierluid VARCHAR(255),
    suppliername TEXT,
    supplierdisplayid TEXT,
    supplieruri TEXT,
    number TEXT,
    date DATETIME,
    debitamount DECIMAL(18,2),
    memo TEXT,
    foreigncurrencyuid VARCHAR(255),
    foreigncurrencycode TEXT,
    foreigncurrencycurrencyname TEXT,
    foreigncurrencyuri TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Account Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_account;
CREATE TABLE c{clientID}_dq_myobar_account (
    uid VARCHAR(255),
    name TEXT,
    displayid VARCHAR(255),
    classification TEXT,
    type VARCHAR(255),
    number INT,
    description TEXT,
    isactive BOOLEAN,
    level INT,
    openingbalance DECIMAL(19,2),
    currentbalance DECIMAL(19,2),
    isheader BOOLEAN,
    lastreconcileddate DATETIME,
    lastmodified DATETIME,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    parentaccountuid VARCHAR(255),
    parentaccountname TEXT,
    parentaccountdisplayid VARCHAR(255),
    parentaccounturi TEXT,
    taxcodeuid VARCHAR(255),
    taxcodecode VARCHAR(255),
    taxcodeuri VARCHAR(255),
    bankingdetailsbsbnumber TEXT,
    bankingdetailsbankaccountnumber TEXT,
    bankingdetailsbankaccountname TEXT,
    foreigncurrencycode VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- AccountBudget Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_accountbudget;
CREATE TABLE c{clientID}_dq_myobar_accountbudget (
    financialyear INT,
    lastmonthinfinancialyear INT,
    budgets JSON,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- AccountingPro Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_accountingpro;
CREATE TABLE c{clientID}_dq_myobar_accountingpro (
    conversiondate DATETIME,
    currentfinancialyear INT,
    lastmonthfinancialyear INT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Job Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_job;
CREATE TABLE c{clientID}_dq_myobar_job (
    uid VARCHAR(255),
    number TEXT,
    isheader BOOLEAN,
    name TEXT,
    description TEXT,
    percentcomplete INT,
    startdate DATETIME,
    finishdate DATETIME,
    contact TEXT,
    manager TEXT,
    isactive BOOLEAN,
    trackreimbursables BOOLEAN,
    lastmodified DATETIME,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    parentjobuid VARCHAR(255),
    parentjobnumber TEXT,
    parentjobname TEXT,
    parentjoburi TEXT,
    linkedcustomeruid VARCHAR(255),
    linkedcustomername TEXT,
    linkedcustomerdisplayid VARCHAR(255),
    linkedcustomeruri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- AccountRegister Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_accountregister;
CREATE TABLE c{clientID}_dq_myobar_accountregister (
    uid VARCHAR(255),
    year INT,
    month INT,
    activity DECIMAL(18,2),
    adjustment DECIMAL(18,2),
    yearendactivity DECIMAL(18,2),
    yearendadjustment DECIMAL(18,2),
    unitcount INT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Category Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_category;
CREATE TABLE c{clientID}_dq_myobar_category (
    uid VARCHAR(255),
    displayid VARCHAR(255),
    name TEXT,
    description TEXT,
    isactive BOOLEAN,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- CategoryRegister Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_categoryregister;
CREATE TABLE c{clientID}_dq_myobar_categoryregister (
    year INT,
    month INT,
    activity DECIMAL(18,2),
    yearendactivity DECIMAL(18,2),
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Currency Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_currency;
CREATE TABLE c{clientID}_dq_myobar_currency (
    uid VARCHAR(255),
    code VARCHAR(255),
    currencyname TEXT,
    currencyrate DECIMAL(18,8),
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- GeneralJournal Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_generaljournal;
CREATE TABLE c{clientID}_dq_myobar_generaljournal (
    uid VARCHAR(255),
    displayid VARCHAR(255),
    dateoccurred DATETIME,
    istaxinclusive BOOLEAN,
    memo TEXT,
    gstreportingmethod TEXT,
    isyearendadjustment BOOLEAN,
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    foreigncurrencyuid VARCHAR(255),
    foreigncurrencycode TEXT,
    foreigncurrencycurrencyname TEXT,
    foreigncurrencyuri TEXT,
    uri TEXT,
    currencyexchangerate FLOAT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- JobBudget Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_jobbudget;
CREATE TABLE c{clientID}_dq_myobar_jobbudget (
    uid VARCHAR(255),
    budgets JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    jobuid VARCHAR(255),
    jobnumber TEXT,
    jobname TEXT,
    joburi TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- JobRegister Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_jobregister;
CREATE TABLE c{clientID}_dq_myobar_jobregister (
    uid VARCHAR(255),
    job JSON,
    account JSON,
    year INT,
    month INT,
    activity DECIMAL(18,2),
    yearendactivity DECIMAL(18,2),
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JournalTransaction Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_journaltransaction;
CREATE TABLE c{clientID}_dq_myobar_journaltransaction (
    uid VARCHAR(255),
    displayid VARCHAR(255),
    journaltype VARCHAR(255),
    sourcetransactionuid VARCHAR(255),
    sourcetransactiontransactiontype VARCHAR(255),
    sourcetransactionuri VARCHAR(255),
    dateoccurred DATETIME,
    dateposted DATETIME,
    description TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SpendMoneyTxn Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_spendmoneytxn;
CREATE TABLE c{clientID}_dq_myobar_spendmoneytxn (
    uid VARCHAR(255),
    payfrom TEXT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi VARCHAR(255),
    contactuid VARCHAR(255),
    contactname TEXT,
    contacttype VARCHAR(255),
    contactdisplayid VARCHAR(255),
    contacturi VARCHAR(255),
    payeeaddress VARCHAR(255),
    statementparticulars TEXT,
    statementcode TEXT,
    statementreference TEXT,
    paymentnumber TEXT,
    date DATETIME,
    amountpaid DECIMAL(18,6),
    istaxinclusive BOOLEAN,
    totaltax DECIMAL(13,2),
    memo VARCHAR(255),
    chequeprinted BOOLEAN,
    deliverystatus TEXT,
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    foreigncurrencyuid VARCHAR(255),
    foreigncurrencycode TEXT,
    foreigncurrencycurrencyname TEXT,
    foreigncurrencyuri TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- ReceiveMoneyTxn Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_receivemoneytxn;
CREATE TABLE c{clientID}_dq_myobar_receivemoneytxn (
    uid VARCHAR(255),
    depositto TEXT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    contactuid VARCHAR(255),
    contactname TEXT,
    contacttype VARCHAR(255),
    contactdisplayid VARCHAR(255),
    contacturi TEXT,
    receiptnumber TEXT,
    date DATETIME,
    amountreceived DECIMAL(18,6),
    istaxinclusive BOOLEAN,
    totaltax DECIMAL(13,2),
    paymentmethod TEXT,
    memostring VARCHAR(255),
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    foreigncurrencyuid VARCHAR(255),
    foreigncurrencycode TEXT,
    foreigncurrencycurrencyname TEXT,
    foreigncurrencyuri TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- TransferMoneyTxn Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_transfermoneytxn;
CREATE TABLE c{clientID}_dq_myobar_transfermoneytxn (
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    uid VARCHAR(255),
    transfernumber TEXT,
    date DATETIME,
    amount DECIMAL(18,6),
    memo TEXT,
    uri TEXT,
    rowversion TEXT,
    fromaccountuid VARCHAR(255),
    fromaccountname TEXT,
    fromaccountdisplayid VARCHAR(255),
    fromaccounturi TEXT,
    toaccountuid VARCHAR(255),
    toaccountname TEXT,
    toaccountdisplayid VARCHAR(255),
    toaccounturi TEXT,
    categoryuid VARCHAR(255),
    categoryname TEXT,
    categorydisplayid VARCHAR(255),
    categoryuri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Statement Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_statement;
CREATE TABLE c{clientID}_dq_myobar_statement (
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    uid VARCHAR(255),
    statementdate DATETIME,
    date DATETIME,
    description TEXT,
    amount DECIMAL(18,6),
    iscredit BOOLEAN,
    sourcetransactions JSON,
    status VARCHAR(255),
    reference TEXT,
    uri TEXT,
    rowversion TEXT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- BankAccount Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_bankaccount;
CREATE TABLE c{clientID}_dq_myobar_bankaccount (
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    uid VARCHAR(255),
    financialinstitution TEXT,
    bankaccountname TEXT,
    bsb TEXT,
    bankaccountnumber TEXT,
    cardname TEXT,
    cardnumber TEXT,
    account JSON,
    banklinkstatus VARCHAR(255),
    lastreconcileddate DATETIME,
    uri TEXT,
    rowversion TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Company Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_company;
CREATE TABLE c{clientID}_dq_myobar_company (
    companyname TEXT,
    serialnumber TEXT,
    address TEXT,
    phonenumber TEXT,
    faxnumber TEXT,
    emailaddress TEXT,
    abnortfn TEXT,
    abnbranch TEXT,
    acn TEXT,
    salestaxnumber TEXT,
    payeenumber TEXT,
    readonly BOOLEAN,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CompanyPreferences Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_companypreferences;
CREATE TABLE c{clientID}_dq_myobar_companypreferences (
    banking JSON,
    sales JSON,
    purchases JSON,
    timesheets JSON,
    rowversion TEXT,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    syscategorytracking TEXT,
    systransactionsmustbereversed BOOLEAN,
    syslockperiodpriorto TEXT,
    sysusealphaacctidentifier BOOLEAN,
    rptreporttaxablepayments BOOLEAN,
    rptemaildefaults TEXT,
    rptemailsales TEXT,
    rptemailsalesinvoice TEXT,
    rptemailsalesinvsubject TEXT,
    rptemailsalesinvmessage TEXT,
    rptemailsalesinvincludenum BOOLEAN,
    rptemailsalesorder TEXT,
    rptemailsalesordsubject TEXT,
    rptemailsalesordmessage TEXT,
    rptemailsalesordincludenum BOOLEAN,
    rptemailsalesquote TEXT,
    rptemailsalesquotesubject TEXT,
    rptemailsalesquotemessage TEXT,
    rptemailsalesquoteincludenum BOOLEAN,
    rptemailpurchases TEXT,
    rptemailpurchasesbill TEXT,
    rptemailpurchbillsubject TEXT,
    rptemailpurchbillmessage TEXT,
    rptemailpurchbillincludenum BOOLEAN,
    rptemailpurchasesorder TEXT,
    rptemailpurchordsubject TEXT,
    rptemailpurchordmessage TEXT,
    rptemailpurchordincludenum BOOLEAN,
    rptemailpurchasesquote TEXT,
    rptemailpurchquotesubject TEXT,
    rptemailpurchquotemessage TEXT,
    rptemailpurchquoteincludenum BOOLEAN,
    rptemailpayslips TEXT,
    rptemailpayslipssubject TEXT,
    rptemailpayslipsmessage TEXT,
    rptemailcompanyprofile TEXT,
    rptemailcompprofileenabled BOOLEAN,
    rptemailcompprofilefromname TEXT,
    rptemailcompprofilereplyto TEXT,
    rptbanking TEXT,
    rptbankinguseundepositedfunds BOOLEAN,
    rptsales TEXT,
    rptsalesterms TEXT,
    rptsalestermspaymentisdue TEXT,
    rptsalestermsdiscountdate INT,
    rptsalestermsbalanceduedate INT,
    rptsalestermsearlydiscount INT,
    rptsalestermslatecharge INT,
    rptsalestermspricelevel TEXT,
    rptsalestermstaxcode TEXT,
    rptsalestermstaxcodeuid VARCHAR(255),
    rptsalestermstaxcodecode VARCHAR(255),
    rptsalestermstaxcodeuri VARCHAR(255),
    rptsalestermsusecustomertax BOOLEAN,
    rptsalestermsfreighttaxcode TEXT,
    rptsalesfreighttaxcodeuid VARCHAR(255),
    rptsalesfreighttaxcodecode VARCHAR(255),
    rptsalesfreighttaxcodeuri VARCHAR(255),
    rptsalestermscreditlimit INT,
    rptpurchases TEXT,
    rptpurchasesterms TEXT,
    rptpurchtermspaymentisdue TEXT,
    rptpurchtermsdiscountdate INT,
    rptpurchtermsbalanceduedate INT,
    rptpurchtermsearlydiscount INT,
    rptpurchtermstaxcode TEXT,
    rptpurchtermstaxcodeuid VARCHAR(255),
    rptpurchtermstaxcodecode VARCHAR(255),
    rptpurchtermstaxcodeuri VARCHAR(255),
    rptpurchtermsusesuppliertax BOOLEAN,
    rptpurchtermsfreighttaxcode TEXT,
    rptpurchfreighttaxcodeuid VARCHAR(255),
    rptpurchfreighttaxcodecode VARCHAR(255),
    rptpurchfreighttaxcodeuri VARCHAR(255),
    rptpurchtermscreditlimit INT,
    rpttimesheets TEXT,
    rpttimesheetsusefor TEXT,
    rpttimesheetsweekstart TEXT,
    rptrowversion TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ProfitAndLossSummary Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_profitandlosssummary;
CREATE TABLE c{clientID}_dq_myobar_profitandlosssummary (
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    startdate DATETIME,
    enddate DATETIME,
    reportingbasis TEXT,
    yearendadjust BOOLEAN,
    taxcodebreakdown JSON,
    uri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- BalanceSheetSummary Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_balancesheetsummary;
CREATE TABLE c{clientID}_dq_myobar_balancesheetsummary (
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    asofdate DATETIME,
    yearendadjust BOOLEAN,
    reportingbasis TEXT,
    accountsbreakdown JSON,
    uri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayrollCategory Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_payrollcategory;
CREATE TABLE c{clientID}_dq_myobar_payrollcategory (
    uid VARCHAR(255),
    name TEXT,
    type VARCHAR(50),
    wagetype VARCHAR(50),
    stpcategory VARCHAR(50),
    overriddenwagesexpenseaccount VARCHAR(255),
    hourlydetails JSON,
    printonpayadvice BOOLEAN,
    carryentitlementovertonextyear BOOLEAN,
    calculationbasis JSON,
    linkedpayrollcategorywages JSON,
    exemptions JSON,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- SuperannuationFund Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_superannuationfund;
CREATE TABLE c{clientID}_dq_myobar_superannuationfund (
    uid VARCHAR(255),
    name TEXT,
    employermembershipnumber TEXT,
    phonenumber VARCHAR(50),
    website TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- Timesheet Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_timesheet;
CREATE TABLE c{clientID}_dq_myobar_timesheet (
    startdate DATETIME,
    enddate DATETIME,
    `lines` JSON,
    uri TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    employeeuid VARCHAR(255),
    employeename TEXT,
    employeedisplayid VARCHAR(255),
    employeeuri TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Activity Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_activity;
CREATE TABLE c{clientID}_dq_myobar_activity (
    uid VARCHAR(255),
    displayid VARCHAR(255),
    name TEXT,
    description TEXT,
    isactive BOOLEAN,
    type VARCHAR(255),
    unitofmeasurement TEXT,
    status VARCHAR(255),
    lastmodified DATETIME,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    chargeabledetailsusedescriptiononsales BOOLEAN,
    chargeabledetailsincomeaccount TEXT,
    chargeabledetailsincomeaccountuid VARCHAR(255),
    chargeabledetailsincomeaccountname TEXT,
    chargeabledetailsincomeaccountdisplayid VARCHAR(255),
    chargeabledetailsincomeaccounturi TEXT,
    chargeabledetailstaxcode TEXT,
    chargeabledetailstaxcodeuid VARCHAR(255),
    chargeabledetailstaxcodecode VARCHAR(255),
    chargeabledetailstaxcodeuri VARCHAR(255),
    chargeabledetailsrate TEXT,
    chargeabledetailsactivityrateexcludingtax TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- ActivitySlip Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_activityslip;
CREATE TABLE c{clientID}_dq_myobar_activityslip (
    uid VARCHAR(255),
    displayid VARCHAR(255),
    date DATETIME,
    isinvoiced BOOLEAN,
    memo TEXT,
    quantity VARCHAR(100),
    duration VARCHAR(100),
    notes TEXT,
    uri TEXT,
    rowversion TEXT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    provideruid VARCHAR(255),
    providername VARCHAR(255),
    providertype VARCHAR(255),
    providerdisplayid VARCHAR(255),
    provideruri VARCHAR(255),
    customeruid VARCHAR(255),
    customername TEXT,
    customerdisplayid VARCHAR(255),
    customeruri TEXT,
    activityuid VARCHAR(255),
    activityname TEXT,
    activityuri DATETIME,
    jobuid VARCHAR(255),
    jobnumber TEXT,
    jobname TEXT,
    joburi TEXT,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (uid)
);

-- CurrentUser Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_currentuser;
CREATE TABLE c{clientID}_dq_myobar_currentuser (
    useraccess JSON,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CustomerPymtInv Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_customerpymtinv;
CREATE TABLE c{clientID}_dq_myobar_customerpymtinv (
    rowid INT,
    number TEXT,
    uid VARCHAR(255),
    amountapplied DECIMAL(10,2),
    type VARCHAR(255),
    salecustomerpaymentid VARCHAR(255),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SaleCreditSettlementLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_salecreditsettlementlines;
CREATE TABLE c{clientID}_dq_myobar_salecreditsettlementlines (
    type VARCHAR(255),
    saleuid VARCHAR(255),
    salenumber VARCHAR(255),
    saleuri VARCHAR(255),
    amountapplied DECIMAL(18,2),
    salecreditsettlementid INT,
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (type, amountapplied)
);

-- PurDebitSettleLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purdebitsettlelines;
CREATE TABLE c{clientID}_dq_myobar_purdebitsettlelines (
    type VARCHAR(255),
    purchaseuid VARCHAR(255),
    purchasenumber TEXT,
    purchaseuri TEXT,
    amountapplied DECIMAL(18,2),
    purchasedebitsettlementid VARCHAR(255),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- GeneralJournalLns Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_generaljournallns;
CREATE TABLE c{clientID}_dq_myobar_generaljournallns (
    rowid INT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid TEXT,
    accounturi TEXT,
    jobuid VARCHAR(255),
    jobname TEXT,
    jobnumber TEXT,
    joburi TEXT,
    memo TEXT,
    taxcodeuid VARCHAR(255),
    taxcodecode VARCHAR(255),
    taxcodeuri VARCHAR(255),
    amount FLOAT,
    amountforeign FLOAT,
    iscredit BOOLEAN,
    taxamount DECIMAL(13,6),
    taxamountforeign DECIMAL(13,6),
    isoverriddentaxamount BOOLEAN,
    unitcount DECIMAL(19,6),
    rowversion TEXT,
    generaljournalid VARCHAR(255),
    clientid VARCHAR(255),
    organisationid VARCHAR(255),
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pattern: c{clientID}_dq_myobar_{entity}
-- Replace {clientID} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseSupPayLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_purchasesuppaylines;
CREATE TABLE c{clientID}_dq_myobar_purchasesuppaylines (
    rowid INT,
    type VARCHAR(255),
    purchaseuid VARCHAR(255),
    purchasenumber TEXT,
    purchaseuri TEXT,
    amountapplied DECIMAL(10,2),
    amountappliedforeign TEXT,
    rowversion TEXT,
    purchasesupplierpaymentid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ReceiveMoneyTxnLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_receivemoneytxnlines;
CREATE TABLE c{clientID}_dq_myobar_receivemoneytxnlines (
    rowid INT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    jobuid VARCHAR(255),
    jobnumber TEXT,
    jobname TEXT,
    joburi TEXT,
    taxcodeuid VARCHAR(255),
    taxcodecode VARCHAR(255),
    taxcodeuri VARCHAR(255),
    memo TEXT,
    amount DECIMAL(10,2),
    unitcount TEXT,
    rowversion TEXT,
    receivemoneytxnid VARCHAR(255) NOT NULL,
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- SpendMoneyTxnLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_spendmoneytxnlines;
CREATE TABLE c{clientID}_dq_myobar_spendmoneytxnlines (
    rowid INT,
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    jobuid VARCHAR(255),
    jobnumber TEXT,
    jobname TEXT,
    joburi TEXT,
    taxcodeuid VARCHAR(255),
    taxcodecode VARCHAR(255),
    taxcodeuri VARCHAR(255),
    memo TEXT,
    amount DECIMAL(10,2),
    unitcount TEXT,
    rowversion TEXT,
    spendmoneytxnid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- JournalTransactionLines Production Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_journaltransactionlines;
CREATE TABLE c{clientID}_dq_myobar_journaltransactionlines (
    accountuid VARCHAR(255),
    accountname TEXT,
    accountdisplayid VARCHAR(255),
    accounturi TEXT,
    jobuid VARCHAR(255),
    jobnumber TEXT,
    jobname TEXT,
    joburi TEXT,
    amount DECIMAL(10,2),
    iscredit BOOLEAN,
    unitcount TEXT,
    linedescription TEXT,
    reconcileddate DATETIME,
    uri TEXT,
    rowversion TEXT,
    journaltransactionid VARCHAR(255),
    clientid VARCHAR(255) NOT NULL,
    organisationid VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- DQ_MYOBAR LastRefreshDate Logging Table
DROP TABLE IF EXISTS c{clientID}_dq_myobar_lastrefreshdate;
CREATE TABLE c{clientID}_dq_myobar_lastrefreshdate (
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
