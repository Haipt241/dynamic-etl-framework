-- DQ_MYOBAR Views - Auto Generated
-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Contact View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_contact;
CREATE VIEW {etani_client_id}_dq_myobar_contact AS
SELECT
    uid,
    lastname,
    firstname,
    isindividual,
    displayid,
    isactive,
    addresses,
    notes,
    identifiers,
    customlist1,
    customlist2,
    customlist3,
    currentbalance,
    type,
    lastmodified,
    photouri,
    uri,
    rowversion,
    clientid,
    organisationid,
    customfield1label AS `customfield1.label`,
    customfield1value AS `customfield1.value`,
    customfield2label AS `customfield2.label`,
    customfield2value AS `customfield2.value`,
    customfield3label AS `customfield3.label`,
    customfield3value AS `customfield3.value`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_contact;

-- ContactCustomer View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_contactcustomer;
CREATE VIEW {etani_client_id}_dq_myobar_contactcustomer AS
SELECT
    uid,
    lastname,
    firstname,
    isindividual,
    displayid,
    isactive,
    addresses,
    currentbalance,
    sellingdetails,
    lastmodified,
    uri,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_contactcustomer;

-- ContactSupplier View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_contactsupplier;
CREATE VIEW {etani_client_id}_dq_myobar_contactsupplier AS
SELECT
    uid,
    companyname,
    isindividual,
    displayid,
    isactive,
    addresses,
    clientid,
    organisationid,
    buyingdetailspurchaselayout AS `buyingdetails.purchaselayout`,
    buyingdetailsexpenseaccount AS `buyingdetails.expenseaccount`,
    buyingdetailsexpenseaccountuid AS `buyingdetails_expenseaccount.uid`,
    buyingdetailsexpenseaccountname AS `buyingdetails_expenseaccount.name`,
    paymentdetailsbsbnumber AS `paymentdetails.bsbnumber`,
    paymentdetailsbankaccountnumber AS `paymentdetails.bankaccountnumber`,
    paymentdetailsbankaccountname AS `paymentdetails.bankaccountname`,
    paymentdetailsstatementtext AS `paymentdetails.statementtext`,
    paymentdetailsrefund AS `paymentdetails.refund`,
    paymentdetailsrefundpaymentmethod AS `paymentdetails_refund.paymentmethod`,
    paymentdetailsrefundcardnumber AS `paymentdetails_refund.cardnumber`,
    paymentdetailsrefundnameoncard AS `paymentdetails_refund.nameoncard`,
    paymentdetailsrefundnotes AS `paymentdetails_refund.notes`,
    paymentdetailsforeigncurrency AS `paymentdetails.foreigncurrency`,
    paymentdetailslastmodified AS `paymentdetails.lastmodified`,
    paymentdetailsphotouri AS `paymentdetails.photouri`,
    paymentdetailsuri AS `paymentdetails.uri`,
    paymentdetailsrowversion AS `paymentdetails.rowversion`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_contactsupplier;

-- ContactEmployee View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_contactemployee;
CREATE VIEW {etani_client_id}_dq_myobar_contactemployee AS
SELECT
    uid,
    lastname,
    firstname,
    isindividual,
    displayid,
    isactive,
    addresses,
    uri,
    clientid,
    organisationid,
    employeepayrolldetailsuid AS `employeepayrolldetails.uid`,
    timebillingdetailsemployeebillingrateexcludingtax AS `timebillingdetails.employeebillingrateexcludingtax`,
    timebillingdetailscostperhour AS `timebillingdetails.costperhour`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_contactemployee;

-- EmployeePayrollDetails View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_employeepayrolldetails;
CREATE VIEW {etani_client_id}_dq_myobar_employeepayrolldetails AS
SELECT
    uid,
    dateofbirth,
    gender,
    startdate,
    employmentbasis,
    uri,
    clientid,
    organisationid,
    employeeuid AS `employee.uid`,
    employeename AS `employee.name`,
    employeedisplayid AS `employee.displayid`,
    employeeuri AS `employee.uri`,
    wagepaybasis AS `wage.paybasis`,
    wageannualsalary AS `wage.annualsalary`,
    wagepayfrequency AS `wage.payfrequency`,
    taxtaxfilenumber AS `tax.taxfilenumber`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_employeepayrolldetails;

-- EmployeePaymentDetails View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_employeepaymentdetails;
CREATE VIEW {etani_client_id}_dq_myobar_employeepaymentdetails AS
SELECT
    uid,
    paymentmethod,
    bankstatementtext,
    bankaccounts,
    uri,
    rowversion,
    clientid,
    organisationid,
    employeeuid AS `employee.uid`,
    employeename AS `employee.name`,
    employeedisplayid AS `employee.displayid`,
    employeeuri AS `employee.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_employeepaymentdetails;

-- EmployeeStandardPay View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_employeestandardpay;
CREATE VIEW {etani_client_id}_dq_myobar_employeestandardpay AS
SELECT
    uid,
    payfrequency,
    hoursperpayfrequency,
    payrollcategories,
    clientid,
    organisationid,
    employeeuid AS `employee.uid`,
    employeename AS `employee.name`,
    employeedisplayid AS `employee.displayid`,
    employeeuri AS `employee.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_employeestandardpay;

-- Personal View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_personal;
CREATE VIEW {etani_client_id}_dq_myobar_personal AS
SELECT
    uid,
    lastname,
    firstname,
    isindividual,
    displayid,
    isactive,
    currentbalance,
    lastmodified,
    uri,
    clientid,
    organisationid,
    addressesstreet AS `addresses.street`,
    addressescity AS `addresses.city`,
    addressesstate AS `addresses.state`,
    addressespostcode AS `addresses.postcode`,
    addressescountry AS `addresses.country`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_personal;

-- SaleInvoice View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleinvoice;
CREATE VIEW {etani_client_id}_dq_myobar_saleinvoice AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    customer,
    promiseddate,
    balancedueamount,
    status,
    invoicetype,
    shiptoaddress,
    terms,
    istaxinclusive,
    subtotal,
    totaltax,
    totalamount,
    freighttaxcode,
    category,
    salesperson,
    comment,
    shippingmethod,
    journalmemo,
    referralsource,
    orderuid AS `order.uid`,
    ordernumber AS `order.number`,
    orderuri AS `order.uri`,
    invoicedeliverystatus,
    lastpaymentdate,
    canapplysurcharge,
    onlinepaymentmethod,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleinvoice;

-- SaleCustomerPayment View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salecustomerpayment;
CREATE VIEW {etani_client_id}_dq_myobar_salecustomerpayment AS
SELECT
    uid,
    depositto,
    receiptnumber,
    date,
    amountreceived,
    paymentmethod,
    clientid,
    organisationid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salecustomerpayment;


-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SaleCreditRefund View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salecreditrefund;
CREATE VIEW {etani_client_id}_dq_myobar_salecreditrefund AS
SELECT
    uid,
    number,
    payee,
    date,
    amount,
    memo,
    chequeprinted,
    deliverystatus,
    foreigncurrency,
    uri,
    rowversion,
    clientid,
    organisationid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    invoiceuid AS `invoice.uid`,
    invoicenumber AS `invoice.number`,
    invoiceuri AS `invoice.uri`,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salecreditrefund;

-- SaleCreditSettlement View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salecreditsettlement;
CREATE VIEW {etani_client_id}_dq_myobar_salecreditsettlement AS
SELECT
    uid,
    number,
    date,
    creditamount,
    memo,
    foreigncurrencyuid AS `foreigncurrency.uid`,
    foreigncurrencycode AS `foreigncurrency.code`,
    foreigncurrencycurrencyname AS `foreigncurrency.currencyname`,
    foreigncurrencyuri AS `foreigncurrency.uri`,
    uri,
    rowversion,
    clientid,
    organisationid,
    creditfrominvoiceuid AS `creditfrominvoice.uid`,
    creditfrominvoicenumber AS `creditfrominvoice.number`,
    creditfrominvoiceuri AS `creditfrominvoice.uri`,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salecreditsettlement;

-- SaleOrder View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_saleorder;
CREATE VIEW {etani_client_id}_dq_myobar_saleorder AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    subtotal,
    totalamount,
    status,
    ordertype,
    uri,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_saleorder;

-- SaleQuote View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salequote;
CREATE VIEW {etani_client_id}_dq_myobar_salequote AS
SELECT
    uid,
    number,
    date,
    customerpurchaseordernumber,
    istaxinclusive,
    subtotal,
    freight,
    totaltax,
    totalamount,
    category,
    salesperson,
    journalmemo,
    referralsource,
    balancedueamount,
    quotetype,
    foreigncurrency,
    uri,
    rowversion,
    clientid,
    organisationid,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsduedate AS `terms.duedate`,
    termsfinancecharge AS `terms.financecharge`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salequote;

-- PurchaseBill View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasebill;
CREATE VIEW {etani_client_id}_dq_myobar_purchasebill AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    istaxinclusive,
    isreportable,
    subtotal,
    subtotalforeign,
    freight,
    freightforeign,
    totaltax,
    totaltaxforeign,
    totalamount,
    totalamountforeign,
    comment,
    shippingmethod,
    promiseddate,
    journalmemo,
    billdeliverystatus,
    appliedtodate,
    appliedtodateforeign,
    balancedueamount,
    balancedueamountforeign,
    status,
    lastpaymentdate,
    billtype,
    foreigncurrency,
    currencyexchangerate,
    uri,
    rowversion,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    termspaymentisdue AS `terms.paymentisdue`,
    termsdiscountdate AS `terms.discountdate`,
    termsbalanceduedate AS `terms.balanceduedate`,
    termsdiscountforearlypayment AS `terms.discountforearlypayment`,
    termsmonthlychargeforlatepayment AS `terms.monthlychargeforlatepayment`,
    termsdiscountexpirydate AS `terms.discountexpirydate`,
    termsdiscount AS `terms.discount`,
    termsdiscountforeign AS `terms.discountforeign`,
    termsduedate AS `terms.duedate`,
    freighttaxcodeuid AS `freighttaxcode.uid`,
    freighttaxcodecode AS `freighttaxcode.code`,
    freighttaxcodeuri AS `freighttaxcode.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    orderuid AS `order.uid`,
    ordernumber AS `order.number`,
    orderuri AS `order.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasebill;

-- PurchaseOrder View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchaseorder;
CREATE VIEW {etani_client_id}_dq_myobar_purchaseorder AS
SELECT
    uid,
    number,
    date,
    supplierinvoicenumber,
    shiptoaddress,
    totalamount,
    status,
    ordertype,
    uri,
    clientid,
    organisationid,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchaseorder;

-- PurchaseSupplierPayment View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasesupplierpayment;
CREATE VIEW {etani_client_id}_dq_myobar_purchasesupplierpayment AS
SELECT
    uid,
    payfrom,
    paymentnumber,
    date,
    amountpaid,
    clientid,
    organisationid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasesupplierpayment;

-- PurchaseDebitRefund View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasedebitrefund;
CREATE VIEW {etani_client_id}_dq_myobar_purchasedebitrefund AS
SELECT
    uid,
    depositto,
    number,
    date,
    amount,
    memo,
    paymentmethod,
    foreigncurrency,
    uri,
    rowversion,
    clientid,
    organisationid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    billuid AS `bill.uid`,
    billnumber AS `bill.number`,
    billuri AS `bill.uri`,
    supplieruid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasedebitrefund;

-- PurchaseDebitSettlement View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasedebitsettlement;
CREATE VIEW {etani_client_id}_dq_myobar_purchasedebitsettlement AS
SELECT
    uid,
    debitfrombilluid AS `debitfrombill.uid`,
    debitfrombillnumber AS `debitfrombill.number`,
    debitfrombilluri AS `debitfrombill.uri`,
    supplierluid AS `supplier.uid`,
    suppliername AS `supplier.name`,
    supplierdisplayid AS `supplier.displayid`,
    supplieruri AS `supplier.uri`,
    number,
    date,
    debitamount,
    memo,
    foreigncurrencyuid AS `foreigncurrency.uid`,
    foreigncurrencycode AS `foreigncurrency.code`,
    foreigncurrencycurrencyname AS `foreigncurrency.currencyname`,
    foreigncurrencyuri AS `foreigncurrency.uri`,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasedebitsettlement;

-- Account View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_account;
CREATE VIEW {etani_client_id}_dq_myobar_account AS
SELECT
    uid,
    name,
    displayid,
    classification,
    type,
    number,
    description,
    isactive,
    level,
    openingbalance,
    currentbalance,
    isheader,
    lastreconcileddate,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    parentaccountuid AS `parentaccount.uid`,
    parentaccountname AS `parentaccount.name`,
    parentaccountdisplayid AS `parentaccount.displayid`,
    parentaccounturi AS `parentaccount.uri`,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    bankingdetailsbsbnumber AS `bankingdetails.bsbnumber`,
    bankingdetailsbankaccountnumber AS `bankingdetails.bankaccountnumber`,
    bankingdetailsbankaccountname AS `bankingdetails.bankaccountname`,
    foreigncurrencycode AS `foreigncurrency.code`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_account;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- AccountBudget View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_accountbudget;
CREATE VIEW {etani_client_id}_dq_myobar_accountbudget AS
SELECT
    financialyear,
    lastmonthinfinancialyear,
    budgets,
    uri,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_accountbudget;

-- AccountingPro View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_accountingpro;
CREATE VIEW {etani_client_id}_dq_myobar_accountingpro AS
SELECT
    conversiondate,
    currentfinancialyear,
    lastmonthfinancialyear,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_accountingpro;

-- Job View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_job;
CREATE VIEW {etani_client_id}_dq_myobar_job AS
SELECT
    uid,
    number,
    isheader,
    name,
    description,
    percentcomplete,
    startdate,
    finishdate,
    contact,
    manager,
    isactive,
    trackreimbursables,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    parentjobuid AS `parentjob.uid`,
    parentjobnumber AS `parentjob.number`,
    parentjobname AS `parentjob.name`,
    parentjoburi AS `parentjob.uri`,
    linkedcustomeruid AS `linkedcustomer.uid`,
    linkedcustomername AS `linkedcustomer.name`,
    linkedcustomerdisplayid AS `linkedcustomer.displayid`,
    linkedcustomeruri AS `linkedcustomer.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_job;

-- AccountRegister View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_accountregister;
CREATE VIEW {etani_client_id}_dq_myobar_accountregister AS
SELECT
    uid,
    year,
    month,
    activity,
    adjustment,
    yearendactivity,
    yearendadjustment,
    unitcount,
    uri,
    rowversion,
    clientid,
    organisationid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_accountregister;

-- Category View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_category;
CREATE VIEW {etani_client_id}_dq_myobar_category AS
SELECT
    uid,
    displayid,
    name,
    description,
    isactive,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_category;

-- CategoryRegister View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_categoryregister;
CREATE VIEW {etani_client_id}_dq_myobar_categoryregister AS
SELECT
    year,
    month,
    activity,
    yearendactivity,
    rowversion,
    clientid,
    organisationid,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_categoryregister;

-- Currency View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_currency;
CREATE VIEW {etani_client_id}_dq_myobar_currency AS
SELECT
    uid,
    code,
    currencyname,
    currencyrate,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_currency;

-- GeneralJournal View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_generaljournal;
CREATE VIEW {etani_client_id}_dq_myobar_generaljournal AS
SELECT
    uid,
    displayid,
    dateoccurred,
    istaxinclusive,
    memo,
    gstreportingmethod,
    isyearendadjustment,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    foreigncurrencyuid AS `foreigncurrency.uid`,
    foreigncurrencycode AS `foreigncurrency.code`,
    foreigncurrencycurrencyname AS `foreigncurrency.currencyname`,
    foreigncurrencyuri AS `foreigncurrency.uri`,
    uri,
    currencyexchangerate,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_generaljournal;

-- JobBudget View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_jobbudget;
CREATE VIEW {etani_client_id}_dq_myobar_jobbudget AS
SELECT
    uid,
    budgets,
    uri,
    rowversion,
    clientid,
    organisationid,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_jobbudget;

-- JobRegister View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_jobregister;
CREATE VIEW {etani_client_id}_dq_myobar_jobregister AS
SELECT
    uid,
    job,
    account,
    year,
    month,
    activity,
    yearendactivity,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_jobregister;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- JournalTransaction View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_journaltransaction;
CREATE VIEW {etani_client_id}_dq_myobar_journaltransaction AS
SELECT
    uid,
    displayid,
    journaltype,
    sourcetransactionuid AS `sourcetransaction.uid`,
    sourcetransactiontransactiontype AS `sourcetransaction.transactiontype`,
    sourcetransactionuri AS `sourcetransaction.uri`,
    dateoccurred,
    dateposted,
    description,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_journaltransaction;

-- SpendMoneyTxn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_spendmoneytxn;
CREATE VIEW {etani_client_id}_dq_myobar_spendmoneytxn AS
SELECT
    uid,
    payfrom,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    contactuid AS `contact.uid`,
    contactname AS `contact.name`,
    contacttype AS `contact.type`,
    contactdisplayid AS `contact.displayid`,
    contacturi AS `contact.uri`,
    payeeaddress,
    statementparticulars,
    statementcode,
    statementreference,
    paymentnumber,
    date,
    amountpaid,
    istaxinclusive,
    totaltax,
    memo,
    chequeprinted,
    deliverystatus,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    foreigncurrencyuid AS `foreigncurrency.uid`,
    foreigncurrencycode AS `foreigncurrency.code`,
    foreigncurrencycurrencyname AS `foreigncurrency.currencyname`,
    foreigncurrencyuri AS `foreigncurrency.uri`,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_spendmoneytxn;

-- ReceiveMoneyTxn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_receivemoneytxn;
CREATE VIEW {etani_client_id}_dq_myobar_receivemoneytxn AS
SELECT
    uid,
    depositto,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    contactuid AS `contact.uid`,
    contactname AS `contact.name`,
    contacttype AS `contact.type`,
    contactdisplayid AS `contact.displayid`,
    contacturi AS `contact.uri`,
    receiptnumber,
    date,
    amountreceived,
    istaxinclusive,
    totaltax,
    paymentmethod,
    memostring,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    foreigncurrencyuid AS `foreigncurrency.uid`,
    foreigncurrencycode AS `foreigncurrency.code`,
    foreigncurrencycurrencyname AS `foreigncurrency.currencyname`,
    foreigncurrencyuri AS `foreigncurrency.uri`,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_receivemoneytxn;

-- TransferMoneyTxn View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_transfermoneytxn;
CREATE VIEW {etani_client_id}_dq_myobar_transfermoneytxn AS
SELECT
    clientid,
    organisationid,
    uid,
    transfernumber,
    date,
    amount,
    memo,
    uri,
    rowversion,
    fromaccountuid AS `fromaccount.uid`,
    fromaccountname AS `fromaccount.name`,
    fromaccountdisplayid AS `fromaccount.displayid`,
    fromaccounturi AS `fromaccount.uri`,
    toaccountuid AS `toaccount.uid`,
    toaccountname AS `toaccount.name`,
    toaccountdisplayid AS `toaccount.displayid`,
    toaccounturi AS `toaccount.uri`,
    categoryuid AS `category.uid`,
    categoryname AS `category.name`,
    categorydisplayid AS `category.displayid`,
    categoryuri AS `category.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_transfermoneytxn;

-- Statement View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_statement;
CREATE VIEW {etani_client_id}_dq_myobar_statement AS
SELECT
    clientid,
    organisationid,
    uid,
    statementdate,
    date,
    description,
    amount,
    iscredit,
    sourcetransactions,
    status,
    reference,
    uri,
    rowversion,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_statement;

-- BankAccount View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_bankaccount;
CREATE VIEW {etani_client_id}_dq_myobar_bankaccount AS
SELECT
    clientid,
    organisationid,
    uid,
    financialinstitution,
    bankaccountname,
    bsb,
    bankaccountnumber,
    cardname,
    cardnumber,
    account,
    banklinkstatus,
    lastreconcileddate,
    uri,
    rowversion,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_bankaccount;

-- Company View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_company;
CREATE VIEW {etani_client_id}_dq_myobar_company AS
SELECT
    companyname,
    serialnumber,
    address,
    phonenumber,
    faxnumber,
    emailaddress,
    abnortfn,
    abnbranch,
    acn,
    salestaxnumber,
    payeenumber,
    readonly,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_company;

-- CompanyPreferences View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_companypreferences;
CREATE VIEW {etani_client_id}_dq_myobar_companypreferences AS
SELECT
    banking,
    sales,
    purchases,
    timesheets,
    rowversion,
    clientid,
    organisationid,
    syscategorytracking AS `system.categorytracking`,
    systransactionsmustbereversed AS `system.transactionscannotbechangedmustbereversed`,
    syslockperiodpriorto AS `system.lockperiodpriorto`,
    sysusealphaacctidentifier AS `system.usealphaaccountidentifier`,
    rptreporttaxablepayments AS `reportsandforms.reporttaxablepayments`,
    rptemaildefaults AS `reportsandforms.emaildefaults`,
    rptemailsales AS `reportsandforms_emaildefaults.sales`,
    rptemailsalesinvoice AS `reportsandforms_emaildefaults_sales.invoice`,
    rptemailsalesinvsubject AS `reportsandforms_emaildefaults_sales_invoice.subject`,
    rptemailsalesinvmessage AS `reportsandforms_emaildefaults_sales_invoice.message`,
    rptemailsalesinvincludenum,
    rptemailsalesorder AS `reportsandforms_emaildefaults_sales.order`,
    rptemailsalesordsubject AS `reportsandforms_emaildefaults_sales_order.subject`,
    rptemailsalesordmessage AS `reportsandforms_emaildefaults_sales_order.message`,
    rptemailsalesordincludenum AS `reportsandforms_emaildefaults_sales_order.includenumberinsubject`,
    rptemailsalesquote AS `reportsandforms_emaildefaults_sales.quote`,
    rptemailsalesquotesubject AS `reportsandforms_emaildefaults_sales_quote.subject`,
    rptemailsalesquotemessage AS `reportsandforms_emaildefaults_sales_quote.message`,
    rptemailsalesquoteincludenum AS `reportsandforms_emaildefaults_sales_quote.includenumberinsubject`,
    rptemailpurchases AS `reportsandforms_emaildefaults.purchases`,
    rptemailpurchasesbill AS `reportsandforms_emaildefaults_purchases.bill`,
    rptemailpurchbillsubject AS `reportsandforms_emaildefaults_purchases_bill.subject`,
    rptemailpurchbillmessage AS `reportsandforms_emaildefaults_purchases_bill.message`,
    rptemailpurchbillincludenum,
    rptemailpurchasesorder AS `reportsandforms_emaildefaults_purchases.order`,
    rptemailpurchordsubject AS `reportsandforms_emaildefaults_purchases_order.subject`,
    rptemailpurchordmessage AS `reportsandforms_emaildefaults_purchases_order.message`,
    rptemailpurchordincludenum,
    rptemailpurchasesquote AS `reportsandforms_emaildefaults_purchases.quote`,
    rptemailpurchquotesubject AS `reportsandforms_emaildefaults_purchases_quote.subject`,
    rptemailpurchquotemessage AS `reportsandforms_emaildefaults_purchases_quote.message`,
    rptemailpurchquoteincludenum,
    rptemailpayslips AS `reportsandforms_emaildefaults.payslips`,
    rptemailpayslipssubject AS `reportsandforms_emaildefaults_payslips.subject`,
    rptemailpayslipsmessage AS `reportsandforms_emaildefaults_payslips.message`,
    rptemailcompanyprofile AS `reportsandforms_emaildefaults.companysendemailprofile`,
    rptemailcompprofileenabled,
    rptemailcompprofilefromname AS `reportsandforms_emaildefaults_companysendemailprofile.fromname`,
    rptemailcompprofilereplyto,
    rptbanking AS `reportsandforms.banking`,
    rptbankinguseundepositedfunds AS `reportsandforms_banking.prefertoreceivemoneyintoundepositedfunds`,
    rptsales AS `reportsandforms.sales`,
    rptsalesterms AS `reportsandforms_sales.terms`,
    rptsalestermspaymentisdue AS `reportsandforms_sales_terms.paymentisdue`,
    rptsalestermsdiscountdate AS `reportsandforms_sales_terms.discountdate`,
    rptsalestermsbalanceduedate AS `reportsandforms_sales_terms.balanceduedate`,
    rptsalestermsearlydiscount AS `reportsandforms_sales_terms.discountforearlypayment`,
    rptsalestermslatecharge AS `reportsandforms_sales_terms.monthlychargeforlatepayment`,
    rptsalestermspricelevel AS `reportsandforms_sales_terms.pricelevel`,
    rptsalestermstaxcode AS `reportsandforms_sales_terms.taxcode`,
    rptsalestermstaxcodeuid AS `reportsandforms_sales_terms_taxcode.uid`,
    rptsalestermstaxcodecode AS `reportsandforms_sales_terms_taxcode.code`,
    rptsalestermstaxcodeuri AS `reportsandforms_sales_terms_taxcode.uri`,
    rptsalestermsusecustomertax AS `reportsandforms_sales_terms.usecustomertaxcode`,
    rptsalestermsfreighttaxcode AS `reportsandforms_sales_terms.freighttaxcode`,
    rptsalesfreighttaxcodeuid AS `reportsandforms_sales_terms_freighttaxcode.uid`,
    rptsalesfreighttaxcodecode AS `reportsandforms_sales_terms_freighttaxcode.code`,
    rptsalesfreighttaxcodeuri AS `reportsandforms_sales_terms_freighttaxcode.uri`,
    rptsalestermscreditlimit AS `reportsandforms_sales_terms.creditlimit`,
    rptpurchases AS `reportsandforms.purchases`,
    rptpurchasesterms AS `reportsandforms_purchases.terms`,
    rptpurchtermspaymentisdue AS `reportsandforms_purchases_terms.paymentisdue`,
    rptpurchtermsdiscountdate AS `reportsandforms_purchases_terms.discountdate`,
    rptpurchtermsbalanceduedate AS `reportsandforms_purchases_terms.balanceduedate`,
    rptpurchtermsearlydiscount AS `reportsandforms_purchases_terms.discountforearlypayment`,
    rptpurchtermstaxcode AS `reportsandforms_purchases_terms.taxcode`,
    rptpurchtermstaxcodeuid AS `reportsandforms_purchases_terms_taxcode.uid`,
    rptpurchtermstaxcodecode AS `reportsandforms_purchases_terms_taxcode.code`,
    rptpurchtermstaxcodeuri AS `reportsandforms_purchases_terms_taxcode.uri`,
    rptpurchtermsusesuppliertax AS `reportsandforms_purchases_terms.usesuppliertaxcode`,
    rptpurchtermsfreighttaxcode AS `reportsandforms_purchases_terms.freighttaxcode`,
    rptpurchfreighttaxcodeuid AS `reportsandforms_purchases_terms_freighttaxcode.uid`,
    rptpurchfreighttaxcodecode AS `reportsandforms_purchases_terms_freighttaxcode.code`,
    rptpurchfreighttaxcodeuri AS `reportsandforms_purchases_terms_freighttaxcode.uri`,
    rptpurchtermscreditlimit AS `reportsandforms_purchases_terms.creditlimit`,
    rpttimesheets AS `reportsandforms.timesheets`,
    rpttimesheetsusefor AS `reportsandforms_timesheets.usetimesheetsfor`,
    rpttimesheetsweekstart AS `reportsandforms_timesheets.weekstartson`,
    rptrowversion AS `reportsandforms.rowversion`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_companypreferences;

-- ProfitAndLossSummary View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_profitandlosssummary;
CREATE VIEW {etani_client_id}_dq_myobar_profitandlosssummary AS
SELECT
    clientid,
    organisationid,
    startdate,
    enddate,
    reportingbasis,
    yearendadjust,
    taxcodebreakdown,
    uri,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_profitandlosssummary;

-- BalanceSheetSummary View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_balancesheetsummary;
CREATE VIEW {etani_client_id}_dq_myobar_balancesheetsummary AS
SELECT
    clientid,
    organisationid,
    asofdate,
    yearendadjust,
    reportingbasis,
    accountsbreakdown,
    uri,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_balancesheetsummary;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PayrollCategory View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_payrollcategory;
CREATE VIEW {etani_client_id}_dq_myobar_payrollcategory AS
SELECT
    uid,
    name,
    type,
    wagetype,
    stpcategory,
    overriddenwagesexpenseaccount,
    hourlydetails,
    printonpayadvice,
    carryentitlementovertonextyear,
    calculationbasis,
    linkedpayrollcategorywages,
    exemptions,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_payrollcategory;

-- SuperannuationFund View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_superannuationfund;
CREATE VIEW {etani_client_id}_dq_myobar_superannuationfund AS
SELECT
    uid,
    name,
    employermembershipnumber,
    phonenumber,
    website,
    uri,
    rowversion,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_superannuationfund;

-- Timesheet View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_timesheet;
CREATE VIEW {etani_client_id}_dq_myobar_timesheet AS
SELECT
    startdate,
    enddate,
    `lines`,
    uri,
    clientid,
    organisationid,
    employeeuid AS `employee.uid`,
    employeename AS `employee.name`,
    employeedisplayid AS `employee.displayid`,
    employeeuri AS `employee.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_timesheet;

-- Activity View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_activity;
CREATE VIEW {etani_client_id}_dq_myobar_activity AS
SELECT
    uid,
    displayid,
    name,
    description,
    isactive,
    type,
    unitofmeasurement,
    status,
    lastmodified,
    uri,
    rowversion,
    clientid,
    organisationid,
    chargeabledetailsusedescriptiononsales AS `chargeabledetails.usedescriptiononsales`,
    chargeabledetailsincomeaccount AS `chargeabledetails.incomeaccount`,
    chargeabledetailsincomeaccountuid AS `chargeabledetails_incomeaccount.uid`,
    chargeabledetailsincomeaccountname AS `chargeabledetails_incomeaccount.name`,
    chargeabledetailsincomeaccountdisplayid AS `chargeabledetails_incomeaccount.displayid`,
    chargeabledetailsincomeaccounturi AS `chargeabledetails_incomeaccount.uri`,
    chargeabledetailstaxcode AS `chargeabledetails.taxcode`,
    chargeabledetailstaxcodeuid AS `chargeabledetails_taxcode.uid`,
    chargeabledetailstaxcodecode AS `chargeabledetails_taxcode.code`,
    chargeabledetailstaxcodeuri AS `chargeabledetails_taxcode.uri`,
    chargeabledetailsrate AS `chargeabledetails.rate`,
    chargeabledetailsactivityrateexcludingtax AS `chargeabledetails.activityrateexcludingtax`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_activity;

-- ActivitySlip View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_activityslip;
CREATE VIEW {etani_client_id}_dq_myobar_activityslip AS
SELECT
    uid,
    displayid,
    date,
    isinvoiced,
    memo,
    quantity,
    duration,
    notes,
    uri,
    rowversion,
    clientid,
    organisationid,
    provideruid AS `provider.uid`,
    providername AS `provider.name`,
    providertype AS `provider.type`,
    providerdisplayid AS `provider.displayid`,
    provideruri AS `provider.uri`,
    customeruid AS `customer.uid`,
    customername AS `customer.name`,
    customerdisplayid AS `customer.displayid`,
    customeruri AS `customer.uri`,
    activityuid AS `activity.uid`,
    activityname AS `activity.name`,
    activityuri AS `activity.uri`,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_activityslip;

-- CurrentUser View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_currentuser;
CREATE VIEW {etani_client_id}_dq_myobar_currentuser AS
SELECT
    useraccess,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_currentuser;

-- CustomerPymtInv View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_customerpymtinv;
CREATE VIEW {etani_client_id}_dq_myobar_customerpymtinv AS
SELECT
    rowid,
    number,
    uid,
    amountapplied,
    type,
    salecustomerpaymentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_customerpymtinv;

-- SaleCreditSettlementLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_salecreditsettlementlines;
CREATE VIEW {etani_client_id}_dq_myobar_salecreditsettlementlines AS
SELECT
    type,
    saleuid AS `sale.uid`,
    salenumber AS `sale.number`,
    saleuri AS `sale.uri`,
    amountapplied,
    salecreditsettlementid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_salecreditsettlementlines;

-- PurDebitSettleLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purdebitsettlelines;
CREATE VIEW {etani_client_id}_dq_myobar_purdebitsettlelines AS
SELECT
    type,
    purchaseuid AS `purchase.uid`,
    purchasenumber AS `purchase.number`,
    purchaseuri AS `purchase.uri`,
    amountapplied,
    purchasedebitsettlementid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purdebitsettlelines;

-- GeneralJournalLns View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_generaljournallns;
CREATE VIEW {etani_client_id}_dq_myobar_generaljournallns AS
SELECT
    rowid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    jobuid AS `job.uid`,
    jobname AS `job.name`,
    jobnumber AS `job.number`,
    joburi AS `job.uri`,
    memo,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    amount,
    amountforeign,
    iscredit,
    taxamount,
    taxamountforeign,
    isoverriddentaxamount,
    unitcount,
    rowversion,
    generaljournalid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_generaljournallns;

-- Pattern: {etani_client_id}_dq_myobar_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseSupPayLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_purchasesuppaylines;
CREATE VIEW {etani_client_id}_dq_myobar_purchasesuppaylines AS
SELECT
    rowid,
    type,
    purchaseuid AS `purchase.uid`,
    purchasenumber AS `purchase.number`,
    purchaseuri AS `purchase.uri`,
    amountapplied,
    amountappliedforeign,
    rowversion,
    purchasesupplierpaymentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_purchasesuppaylines;

-- ReceiveMoneyTxnLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_receivemoneytxnlines;
CREATE VIEW {etani_client_id}_dq_myobar_receivemoneytxnlines AS
SELECT
    rowid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    memo,
    amount,
    unitcount,
    rowversion,
    receivemoneytxnid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_receivemoneytxnlines;

-- SpendMoneyTxnLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_spendmoneytxnlines;
CREATE VIEW {etani_client_id}_dq_myobar_spendmoneytxnlines AS
SELECT
    rowid,
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    taxcodeuid AS `taxcode.uid`,
    taxcodecode AS `taxcode.code`,
    taxcodeuri AS `taxcode.uri`,
    memo,
    amount,
    unitcount,
    rowversion,
    spendmoneytxnid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_spendmoneytxnlines;

-- JournalTransactionLines View
DROP VIEW IF EXISTS {etani_client_id}_dq_myobar_journaltransactionlines;
CREATE VIEW {etani_client_id}_dq_myobar_journaltransactionlines AS
SELECT
    accountuid AS `account.uid`,
    accountname AS `account.name`,
    accountdisplayid AS `account.displayid`,
    accounturi AS `account.uri`,
    jobuid AS `job.uid`,
    jobnumber AS `job.number`,
    jobname AS `job.name`,
    joburi AS `job.uri`,
    amount,
    iscredit,
    unitcount,
    linedescription,
    reconcileddate,
    uri,
    rowversion,
    journaltransactionid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_dq_myobar_journaltransactionlines;