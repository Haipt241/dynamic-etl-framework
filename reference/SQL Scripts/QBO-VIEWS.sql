-- =====================================================
-- QuickBooks Online Views - Complete Set
-- =====================================================
-- This file contains view definitions for all QBO tables
-- Replace {clientID} with actual client identifier when creating views
-- 
-- Usage:
-- 1. Replace {clientID} with actual value (e.g., CLIENT123)
-- 2. Execute sections as needed to create client-specific views
-- 3. Views provide a client-filtered interface to the underlying tables
-- =====================================================

-- =====================================================
-- MASTER DATA ENTITY VIEWS
-- =====================================================

-- CompanyInfo View
DROP VIEW IF EXISTS {clientID}_qbo_companyinfo;
CREATE VIEW {clientID}_qbo_companyinfo AS
SELECT
    Id,
    SyncToken,
    CompanyName,
    LegalName,
    CompanyAddr_Id,
    CompanyAddr_Line1,
    CompanyAddr_Line2,
    CompanyAddr_Line3,
    CompanyAddr_Line4,
    CompanyAddr_Line5,
    CompanyAddr_City,
    CompanyAddr_Country,
    CompanyAddr_CountrySubDivisionCode,
    CompanyAddr_PostalCode,
    CompanyAddr_Lat,
    CompanyAddr_Long,
    CompanyStartDate,
    Country,
    Email_Address,
    FiscalYearStartMonth,
    CustomerCommunicationAddr_Id,
    CustomerCommunicationAddr_Line1,
    CustomerCommunicationAddr_City,
    CustomerCommunicationAddr_Country,
    CustomerCommunicationAddr_CountrySubDivisionCode,
    CustomerCommunicationAddr_PostalCode,
    LegalAddr_Id,
    LegalAddr_Line1,
    LegalAddr_City,
    LegalAddr_Country,
    LegalAddr_CountrySubDivisionCode,
    LegalAddr_PostalCode,
    LegalAddr_Lat,
    LegalAddr_Long,
    PrimaryPhone_FreeFormNumber,
    WebAddr_URI,
    SupportedLanguages,
    NameValue,
    domain,
    sparse,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_companyinfo
;

-- Account View
DROP VIEW IF EXISTS {clientID}_qbo_account;
CREATE VIEW {clientID}_qbo_account AS
SELECT
    Id,
    Name,
    SyncToken,
    AcctNum,
    CurrencyRef_value,
    CurrencyRef_name,
    ParentRef_value,
    Description,
    Active,
    SubAccount,
    Classification,
    AccountType,
    AccountSubType,
    CurrentBalance,
    CurrentBalanceWithSubAccounts,
    FullyQualifiedName,
    domain,
    sparse,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_account
;

-- Customer View
DROP VIEW IF EXISTS {clientID}_qbo_customer;
CREATE VIEW {clientID}_qbo_customer AS
SELECT
    Id,
    SyncToken,
    DisplayName,
    Title,
    GivenName,
    MiddleName,
    FamilyName,
    Suffix,
    CompanyName,
    PrintOnCheckName,
    FullyQualifiedName,
    Active,
    Taxable,
    Job,
    BillWithParent,
    IsProject,
    IsStatementWithParent,
    IsCDS,
    Balance,
    BalanceWithJobs,
    OpenBalanceDate,
    TotalRevenue,
    TotalExpense,
    CurrencyRef_value,
    CurrencyRef_name,
    PreferredDeliveryMethod,
    PrimaryPhone_FreeFormNumber,
    AlternatePhone_FreeFormNumber,
    Mobile_FreeFormNumber,
    Fax_FreeFormNumber,
    PrimaryEmailAddr_Address,
    WebAddr_URI,
    BillAddr_Id,
    BillAddr_Line1,
    BillAddr_Line2,
    BillAddr_Line3,
    BillAddr_Line4,
    BillAddr_Line5,
    BillAddr_City,
    BillAddr_Country,
    BillAddr_CountrySubDivisionCode,
    BillAddr_PostalCode,
    BillAddr_Lat,
    BillAddr_Long,
    ShipAddr_Id,
    ShipAddr_Line1,
    ShipAddr_Line2,
    ShipAddr_Line3,
    ShipAddr_Line4,
    ShipAddr_Line5,
    ShipAddr_City,
    ShipAddr_Country,
    ShipAddr_CountrySubDivisionCode,
    ShipAddr_PostalCode,
    ShipAddr_Lat,
    ShipAddr_Long,
    OtherAddr_Id,
    OtherAddr_Line1,
    OtherAddr_Line2,
    OtherAddr_Line3,
    OtherAddr_Line4,
    OtherAddr_Line5,
    OtherAddr_City,
    OtherAddr_Country,
    OtherAddr_CountrySubDivisionCode,
    OtherAddr_PostalCode,
    OtherAddr_Lat,
    OtherAddr_Long,
    ParentRef_value,
    ParentRef_name,
    Level,
    SalesTermRef_value,
    SalesTermRef_name,
    PaymentMethodRef_value,
    PaymentMethodRef_name,
    DefaultTaxCodeRef_value,
    DefaultTaxCodeRef_name,
    CustomerTypeRef_value,
    CustomerTypeRef_name,
    ARAccountRef_value,
    ARAccountRef_name,
    ShipMethodRef_value,
    ShipMethodRef_name,
    ResaleNum,
    PrimaryTaxIdentifier,
    SecondaryTaxIdentifier,
    TaxExemptionReasonId,
    sparse,
    domain,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_customer
;

-- Vendor View
DROP VIEW IF EXISTS {clientID}_qbo_vendor;
CREATE VIEW {clientID}_qbo_vendor AS
SELECT
    Id,
    SyncToken,
    Title,
    GivenName,
    MiddleName,
    FamilyName,
    Suffix,
    CompanyName,
    DisplayName,
    PrintOnCheckName,
    Active,
    Vendor1099,
    Balance,
    BillAddr_Id,
    BillAddr_Line1,
    BillAddr_Line2,
    BillAddr_Line3,
    BillAddr_Line4,
    BillAddr_Line5,
    BillAddr_City,
    BillAddr_Country,
    BillAddr_CountrySubDivisionCode,
    BillAddr_PostalCode,
    TaxIdentifier,
    AcctNum,
    CurrencyRef_value,
    CurrencyRef_name,
    TermRef_value,
    PrimaryPhone_FreeFormNumber,
    AlternatePhone_FreeFormNumber,
    Mobile_FreeFormNumber,
    Fax_FreeFormNumber,
    PrimaryEmailAddr_Address,
    WebAddr_URI,
    BillRate,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_vendor
;

-- Employee View
DROP VIEW IF EXISTS {clientID}_qbo_employee;
CREATE VIEW {clientID}_qbo_employee AS
SELECT
    Id,
    SyncToken,
    Organization,
    Title,
    GivenName,
    MiddleName,
    FamilyName,
    Suffix,
    DisplayName,
    PrintOnCheckName,
    Active,
    PrimaryPhone_FreeFormNumber,
    Mobile_FreeFormNumber,
    PrimaryEmailAddr_Address,
    EmployeeNumber,
    SSN,
    PrimaryAddr_Id,
    PrimaryAddr_Line1,
    PrimaryAddr_Line2,
    PrimaryAddr_Line3,
    PrimaryAddr_Line4,
    PrimaryAddr_Line5,
    PrimaryAddr_City,
    PrimaryAddr_Country,
    PrimaryAddr_CountrySubDivisionCode,
    PrimaryAddr_PostalCode,
    BillableTime,
    BillRate,
    BirthDate,
    Gender,
    HiredDate,
    ReleasedDate,
    V4IDPseudonym,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_employee
;

-- Item View
DROP VIEW IF EXISTS {clientID}_qbo_item;
CREATE VIEW {clientID}_qbo_item AS
SELECT
    Id,
    SyncToken,
    Name,
    Sku,
    Description,
    Active,
    SubItem,
    ParentRef_value,
    Level,
    FullyQualifiedName,
    Taxable,
    SalesTaxIncluded,
    UnitPrice,
    Type,
    IncomeAccountRef_value,
    IncomeAccountRef_name,
    PurchaseDesc,
    PurchaseTaxIncluded,
    PurchaseCost,
    ExpenseAccountRef_value,
    ExpenseAccountRef_name,
    AssetAccountRef_value,
    TrackQtyOnHand,
    QtyOnHand,
    InvStartDate,
    ReorderPoint,
    ManPartNum,
    DepositToAccountRef_value,
    SalesTaxCodeRef_value,
    PurchaseTaxCodeRef_value,
    ClassRef_value,
    PrefVendorRef_value,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_item
;

-- Class View
DROP VIEW IF EXISTS {clientID}_qbo_class;
CREATE VIEW {clientID}_qbo_class AS
SELECT
    Id,
    SyncToken,
    Name,
    SubClass,
    ParentRef_value,
    FullyQualifiedName,
    Active,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_class
;

-- Department View
DROP VIEW IF EXISTS {clientID}_qbo_department;
CREATE VIEW {clientID}_qbo_department AS
SELECT
    Id,
    SyncToken,
    Name,
    SubDepartment,
    ParentRef_value,
    FullyQualifiedName,
    Active,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_department
;

-- TaxCode View
DROP VIEW IF EXISTS {clientID}_qbo_taxcode;
CREATE VIEW {clientID}_qbo_taxcode AS
SELECT
    Id,
    SyncToken,
    Name,
    Description,
    Active,
    Hidden,
    Taxable,
    TaxGroup,
    SalesTaxRateList_TaxRateDetail_TaxRateRef_value,
    SalesTaxRateList_TaxRateDetail_TaxRateRef_name,
    SalesTaxRateList_TaxRateDetail_TaxTypeApplicable,
    SalesTaxRateList_TaxRateDetail_TaxOrder,
    PurchaseTaxRateList_TaxRateDetail_TaxRateRef_value,
    PurchaseTaxRateList_TaxRateDetail_TaxRateRef_name,
    PurchaseTaxRateList_TaxRateDetail_TaxTypeApplicable,
    PurchaseTaxRateList_TaxRateDetail_TaxOrder,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_taxcode
;

-- TaxRate View
DROP VIEW IF EXISTS {clientID}_qbo_taxrate;
CREATE VIEW {clientID}_qbo_taxrate AS
SELECT
    Id,
    SyncToken,
    Name,
    Description,
    Active,
    RateValue,
    AgencyRef_value,
    TaxReturnLineRef_value,
    SpecialTaxType,
    DisplayType,
    EffectiveTaxRate_RateValue,
    EffectiveTaxRate_EffectiveDate,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_taxrate
;

-- Term View
DROP VIEW IF EXISTS {clientID}_qbo_term;
CREATE VIEW {clientID}_qbo_term AS
SELECT
    Id,
    SyncToken,
    Name,
    Active,
    Type,
    DiscountPercent,
    DueDays,
    DiscountDays,
    DayOfMonthDue,
    DueNextMonthDays,
    DiscountDayOfMonth,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_term
;

-- PaymentMethod View
DROP VIEW IF EXISTS {clientID}_qbo_paymentmethod;
CREATE VIEW {clientID}_qbo_paymentmethod AS
SELECT
    Id,
    SyncToken,
    Name,
    Active,
    Type,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_paymentmethod
;

-- =====================================================
-- TRANSACTION ENTITY VIEWS
-- =====================================================

-- Invoice View
DROP VIEW IF EXISTS {clientID}_qbo_invoice;
CREATE VIEW {clientID}_qbo_invoice AS
SELECT
    Id,
    SyncToken,
    DocNumber,
    TxnDate,
    DueDate,
    TotalAmt,
    HomeTotalAmt,
    Balance,
    HomeBalance,
    CustomerRef_value,
    CustomerRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    BillEmail_Address,
    TxnStatus,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    Line_SalesItemLineDetail_ItemRef_value,
    Line_SalesItemLineDetail_ItemRef_name,
    Line_SalesItemLineDetail_ClassRef_value,
    Line_SalesItemLineDetail_ClassRef_name,
    Line_SalesItemLineDetail_Qty,
    Line_SalesItemLineDetail_UnitPrice,
    Line_SalesItemLineDetail_TaxCodeRef_value,
    Line_SalesItemLineDetail_ServiceDate,
    Line_GroupLineDetail_GroupItemRef_value,
    Line_GroupLineDetail_GroupItemRef_name,
    Line_GroupLineDetail_Quantity,
    Line_SubTotalLineDetail_ServiceDate,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    CustomerMemo_value,
    BillAddr_Id,
    BillAddr_Line1,
    BillAddr_Line2,
    BillAddr_Line3,
    BillAddr_Line4,
    BillAddr_Line5,
    BillAddr_City,
    BillAddr_Country,
    BillAddr_CountrySubDivisionCode,
    BillAddr_PostalCode,
    ShipAddr_Id,
    ShipAddr_Line1,
    ShipAddr_Line2,
    ShipAddr_Line3,
    ShipAddr_Line4,
    ShipAddr_Line5,
    ShipAddr_City,
    ShipAddr_Country,
    ShipAddr_CountrySubDivisionCode,
    ShipAddr_PostalCode,
    FreeFormAddress,
    ShipFromAddr_Id,
    ShipFromAddr_Line1,
    ShipFromAddr_Line2,
    ShipFromAddr_Line3,
    ShipFromAddr_Line4,
    ShipFromAddr_Line5,
    ShipFromAddr_City,
    ShipFromAddr_Country,
    ShipFromAddr_CountrySubDivisionCode,
    ShipFromAddr_PostalCode,
    ShipMethodRef_value,
    ShipDate,
    TrackingNum,
    GlobalTaxCalculation,
    ApplyTaxAfterDiscount,
    PrintStatus,
    EmailStatus,
    TransactionLocationType,
    DepositToAccountRef_value,
    AllowIPNPayment,
    AllowOnlinePayment,
    AllowOnlineCreditCardPayment,
    AllowOnlineACHPayment,
    EInvoiceStatus,
    InvoiceLink,
    PaymentDetailsMessage,
    ConvenienceFeeDetail,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_invoice
;

-- Payment View
DROP VIEW IF EXISTS {clientID}_qbo_payment;
CREATE VIEW {clientID}_qbo_payment AS
SELECT
    Id,
    SyncToken,
    TxnDate,
    TotalAmt,
    CustomerRef_value,
    CustomerRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    PrivateNote,
    PaymentRefNum,
    DepositToAccountRef_value,
    DepositToAccountRef_name,
    PaymentMethodRef_value,
    PaymentMethodRef_name,
    UnappliedAmt,
    ProcessPayment,
    TransactionLocationType,
    Line_Amount,
    Line_LinkedTxn_TxnId,
    Line_LinkedTxn_TxnType,
    Line_LinkedTxn_TxnLineId,
    ARAccountRef_value,
    ARAccountRef_name,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_payment
;

-- Bill View
DROP VIEW IF EXISTS {clientID}_qbo_bill;
CREATE VIEW {clientID}_qbo_bill AS
SELECT
    Id,
    SyncToken,
    DocNumber,
    TxnDate,
    DueDate,
    TotalAmt,
    HomeTotalAmt,
    Balance,
    VendorRef_value,
    VendorRef_name,
    APAccountRef_value,
    APAccountRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    GlobalTaxCalculation,
    SalesTermRef_value,
    SalesTermRef_name,
    TransactionLocationType,
    LineId,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    AccountBasedExpenseLineDetail_AccountRef_value,
    AccountBasedExpenseLineDetail_AccountRef_name,
    AccountBasedExpenseLineDetail_BillableStatus,
    AccountBasedExpenseLineDetail_TaxCodeRef_value,
    AccountBasedExpenseLineDetail_TaxAmount,
    AccountBasedExpenseLineDetail_ClassRef_value,
    AccountBasedExpenseLineDetail_ClassRef_name,
    AccountBasedExpenseLineDetail_CustomerRef_value,
    AccountBasedExpenseLineDetail_CustomerRef_name,
    AccountBasedExpenseLineDetail_MarkupInfo_PercentBased,
    AccountBasedExpenseLineDetail_MarkupInfo_Value,
    AccountBasedExpenseLineDetail_MarkupInfo_Percent,
    AccountBasedExpenseLineDetail_MarkupInfo_PriceLevelRef_value,
    AccountBasedExpenseLineDetail_MarkupInfo_PriceLevelRef_name,
    ItemBasedExpenseLineDetail_ItemRef_value,
    ItemBasedExpenseLineDetail_ItemRef_name,
    ItemBasedExpenseLineDetail_ClassRef_value,
    ItemBasedExpenseLineDetail_ClassRef_name,
    ItemBasedExpenseLineDetail_UnitPrice,
    ItemBasedExpenseLineDetail_Qty,
    ItemBasedExpenseLineDetail_TaxCodeRef_value,
    ItemBasedExpenseLineDetail_CustomerRef_value,
    ItemBasedExpenseLineDetail_CustomerRef_name,
    ItemBasedExpenseLineDetail_BillableStatus,
    ItemBasedExpenseLineDetail_MarkupInfo_PercentBased,
    ItemBasedExpenseLineDetail_MarkupInfo_Value,
    ItemBasedExpenseLineDetail_MarkupInfo_Percent,
    ItemBasedExpenseLineDetail_MarkupInfo_PriceLevelRef_value,
    ItemBasedExpenseLineDetail_MarkupInfo_PriceLevelRef_name,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    LinkedTxn_TxnId,
    LinkedTxn_TxnType,
    LinkedTxn_TxnLineId,
    VendorAddr_Id,
    VendorAddr_Line1,
    VendorAddr_Line2,
    VendorAddr_Line3,
    VendorAddr_Line4,
    VendorAddr_Line5,
    VendorAddr_City,
    VendorAddr_Country,
    VendorAddr_CountrySubDivisionCode,
    VendorAddr_PostalCode,
    VendorAddr_Lat,
    VendorAddr_Long,
    PrivateNote,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_bill
;

-- BillPayment View
DROP VIEW IF EXISTS {clientID}_qbo_billpayment;
CREATE VIEW {clientID}_qbo_billpayment AS
SELECT
    Id,
    SyncToken,
    TxnDate,
    PayType,
    DocNumber,
    PrivateNote,
    VendorRef_value,
    VendorRef_name,
    DepartmentRef_value,
    DepartmentRef_name,
    APAccountRef_value,
    APAccountRef_name,
    TotalAmt,
    ProcessBillPayment,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    TransactionLocationType,
    Line_Amount,
    Line_LinkedTxn_TxnId,
    Line_LinkedTxn_TxnType,
    CheckPayment_BankAccountRef_value,
    CheckPayment_BankAccountRef_name,
    CheckPayment_PrintStatus,
    CreditCardPayment_CCAccountRef_value,
    CreditCardPayment_CCAccountRef_name,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_billpayment
;

-- SalesReceipt View
DROP VIEW IF EXISTS {clientID}_qbo_salesreceipt;
CREATE VIEW {clientID}_qbo_salesreceipt AS
SELECT
    Id,
    SyncToken,
    DocNumber,
    TxnDate,
    TotalAmt,
    HomeTotalAmt,
    Balance,
    CustomerRef_value,
    CustomerRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    DepositToAccountRef_value,
    DepositToAccountRef_name,
    PaymentMethodRef_value,
    PaymentMethodRef_name,
    PaymentRefNum,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    Line_SalesItemLineDetail_ItemRef_value,
    Line_SalesItemLineDetail_ItemRef_name,
    Line_SalesItemLineDetail_ClassRef_value,
    Line_SalesItemLineDetail_ClassRef_name,
    Line_SalesItemLineDetail_Qty,
    Line_SalesItemLineDetail_UnitPrice,
    Line_SalesItemLineDetail_TaxCodeRef_value,
    Line_SalesItemLineDetail_ServiceDate,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    CustomerMemo_value,
    BillAddr_Id,
    BillAddr_Line1,
    BillAddr_Line2,
    BillAddr_Line3,
    BillAddr_Line4,
    BillAddr_Line5,
    BillAddr_City,
    BillAddr_Country,
    BillAddr_CountrySubDivisionCode,
    BillAddr_PostalCode,
    ShipAddr_Id,
    ShipAddr_Line1,
    ShipAddr_Line2,
    ShipAddr_Line3,
    ShipAddr_Line4,
    ShipAddr_Line5,
    ShipAddr_City,
    ShipAddr_Country,
    ShipAddr_CountrySubDivisionCode,
    ShipAddr_PostalCode,
    FreeFormAddress,
    ShipMethodRef_value,
    ShipDate,
    TrackingNum,
    PrintStatus,
    EmailStatus,
    BillEmail_Address,
    GlobalTaxCalculation,
    TotalTax,
    TransactionLocationType,
    ApplyTaxAfterDiscount,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_salesreceipt
;

-- JournalEntry View
DROP VIEW IF EXISTS {clientID}_qbo_journalentry;
CREATE VIEW {clientID}_qbo_journalentry AS
SELECT
    Id,
    JournalEntryId,
    SyncToken,
    Adjustment,
    HomeCurrencyAdjustment,
    TxnDate,
    DocNumber,
    PrivateNote,
    TxnStatus,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    GlobalTaxCalculation,
    TotalAmt,
    HomeTotalAmt,
    TransactionLocationType,
    RecurDataRef_value,
    RecurDataRef_name,
    Line_Id,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    Line_PostingType,
    Line_JournalEntryLineDetail_AccountRef_value,
    Line_JournalEntryLineDetail_AccountRef_name,
    Line_JournalEntryLineDetail_ClassRef_value,
    Line_JournalEntryLineDetail_ClassRef_name,
    Line_JournalEntryLineDetail_DepartmentRef_value,
    Line_JournalEntryLineDetail_DepartmentRef_name,
    Line_JournalEntryLineDetail_EntityRef_value,
    Line_JournalEntryLineDetail_EntityRef_type,
    Line_JournalEntryLineDetail_EntityRef_name,
    Line_JournalEntryLineDetail_TaxCodeRef_value,
    Line_JournalEntryLineDetail_TaxApplicableOn,
    Line_JournalEntryLineDetail_TaxAmount,
    Line_JournalEntryLineDetail_BillableStatus,
    Line_JournalEntryLineDetail_JournalCodeRef_value,
    Line_JournalEntryLineDetail_JournalCodeRef_name,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_journalentry
;

-- Purchase View
DROP VIEW IF EXISTS {clientID}_qbo_purchase;
CREATE VIEW {clientID}_qbo_purchase AS
SELECT
    Id,
    SyncToken,
    DocNumber,
    TxnDate,
    TotalAmt,
    PaymentType,
    AccountRef_value,
    AccountRef_name,
    EntityRef_value,
    EntityRef_name,
    EntityRef_type,
    Credit,
    DepartmentRef_value,
    DepartmentRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    PrivateNote,
    GlobalTaxCalculation,
    TransactionLocationType,
    PrintStatus,
    PurchaseEx_Any,
    LineId,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    AccountBasedExpenseLineDetail_AccountRef_value,
    AccountBasedExpenseLineDetail_AccountRef_name,
    AccountBasedExpenseLineDetail_BillableStatus,
    AccountBasedExpenseLineDetail_TaxCodeRef_value,
    AccountBasedExpenseLineDetail_TaxAmount,
    AccountBasedExpenseLineDetail_ClassRef_value,
    AccountBasedExpenseLineDetail_ClassRef_name,
    AccountBasedExpenseLineDetail_CustomerRef_value,
    AccountBasedExpenseLineDetail_CustomerRef_name,
    ItemBasedExpenseLineDetail_ItemRef_value,
    ItemBasedExpenseLineDetail_ItemRef_name,
    ItemBasedExpenseLineDetail_ClassRef_value,
    ItemBasedExpenseLineDetail_ClassRef_name,
    ItemBasedExpenseLineDetail_UnitPrice,
    ItemBasedExpenseLineDetail_Qty,
    ItemBasedExpenseLineDetail_TaxCodeRef_value,
    ItemBasedExpenseLineDetail_CustomerRef_value,
    ItemBasedExpenseLineDetail_CustomerRef_name,
    ItemBasedExpenseLineDetail_BillableStatus,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    RemitToAddr_Id,
    RemitToAddr_Line1,
    RemitToAddr_Line2,
    RemitToAddr_Line3,
    RemitToAddr_Line4,
    RemitToAddr_Line5,
    RemitToAddr_City,
    RemitToAddr_Country,
    RemitToAddr_CountrySubDivisionCode,
    RemitToAddr_PostalCode,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_purchase
;

-- =====================================================
-- OTHER ENTITY VIEWS
-- =====================================================

-- TimeActivity View
DROP VIEW IF EXISTS {clientID}_qbo_timeactivity;
CREATE VIEW {clientID}_qbo_timeactivity AS
SELECT
    Id,
    SyncToken,
    TxnDate,
    NameOf,
    EmployeeRef_value,
    EmployeeRef_name,
    VendorRef_value,
    VendorRef_name,
    CustomerRef_value,
    CustomerRef_name,
    ItemRef_value,
    ItemRef_name,
    ClassRef_value,
    ClassRef_name,
    PayrollItemRef_value,
    PayrollItemRef_name,
    DepartmentRef_value,
    DepartmentRef_name,
    HourlyRate,
    BreakHours,
    BreakMinutes,
    StartTime,
    EndTime,
    Hours,
    Minutes,
    Description,
    Billable,
    BillableStatus,
    Taxable,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_timeactivity
;

-- Budget View
DROP VIEW IF EXISTS {clientID}_qbo_budget;
CREATE VIEW {clientID}_qbo_budget AS
SELECT
    Id,
    SyncToken,
    Name,
    StartDate,
    EndDate,
    BudgetType,
    Active,
    BudgetDetail_BudgetDate,
    BudgetDetail_AccountRef_value,
    BudgetDetail_AccountRef_name,
    BudgetDetail_CustomerRef_value,
    BudgetDetail_CustomerRef_name,
    BudgetDetail_ClassRef_value,
    BudgetDetail_ClassRef_name,
    BudgetDetail_DepartmentRef_value,
    BudgetDetail_DepartmentRef_name,
    BudgetDetail_Amount,
    sparse,
    domain,
    
    
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_budget
;

-- Attachable View
DROP VIEW IF EXISTS {clientID}_qbo_attachable;
CREATE VIEW {clientID}_qbo_attachable AS
SELECT
    Id,
    SyncToken,
    FileName,
    ContentType,
    Size,
    Note,
    PlaceName,
    LatLong_Value,
    LatLong_Lat,
    LatLong_Long,
    AttachableRef_EntityRef_Type,
    AttachableRef_EntityRef_Value,
    AttachableRef_EntityRef_Name,
    AttachableRef_IncludeOnSend,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_attachable
;

-- =====================================================
-- REPORT VIEWS
-- =====================================================

-- BalanceSheet View
DROP VIEW IF EXISTS {clientID}_qbo_balancesheet;
CREATE VIEW {clientID}_qbo_balancesheet AS
SELECT
    ReportName,
    Currency,
    StartPeriod,
    EndPeriod,
    Time,
    Option_Name,
    Option_Value,
    Row_Id,
    Row_Type,
    Row_Group,
    Row_Header,
    Row_Summary,
    Row_ColTitle,
    Col_Account_Name,
    Col_Account_Name_id,
    Col_Total,
    Col_Total_id,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_balancesheet
;

-- ProfitAndLoss View
DROP VIEW IF EXISTS {clientID}_qbo_profitandloss;
CREATE VIEW {clientID}_qbo_profitandloss AS
SELECT
    ReportName,
    Currency,
    StartPeriod,
    EndPeriod,
    Time,
    Option_Name,
    Option_Value,
    Row_Id,
    Row_Type,
    Row_Group,
    Row_Header,
    Row_Summary,
    Row_ColTitle,
    Col_Account_Name,
    Col_Account_Name_id,
    Col_Total,
    Col_Total_id,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_profitandloss
;

-- =====================================================
-- HELPER VIEWS
-- =====================================================

-- All Tables Summary View
DROP VIEW IF EXISTS {clientID}_qbo_tables_summary;
CREATE VIEW {clientID}_qbo_tables_summary AS
SELECT 
    'CompanyInfo' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_companyinfo
UNION ALL
SELECT 
    'Account' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_account
UNION ALL
SELECT 
    'Customer' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_customer
UNION ALL
SELECT 
    'Vendor' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_vendor
UNION ALL
SELECT 
    'Invoice' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_invoice
UNION ALL
SELECT 
    'Payment' as TableName,
    COUNT(*) as RowCount,
    MAX(Id) as LastId
FROM c{clientID}_qbo_payment;

-- Active Customers Only View
DROP VIEW IF EXISTS {clientID}_qbo_customer_active;
CREATE VIEW {clientID}_qbo_customer_active AS
SELECT * FROM {clientID}_qbo_customer 
WHERE Active = 1;

-- Active Vendors Only View
DROP VIEW IF EXISTS {clientID}_qbo_vendor_active;
CREATE VIEW {clientID}_qbo_vendor_active AS
SELECT * FROM {clientID}_qbo_vendor 
WHERE Active = 1;

-- =====================================================
-- ADDITIONAL ENTITY VIEWS
-- =====================================================

-- Deposit View
DROP VIEW IF EXISTS {clientID}_qbo_deposit;
CREATE VIEW {clientID}_qbo_deposit AS
SELECT
    Id,
    SyncToken,
    TxnDate,
    TotalAmt,
    HomeTotalAmt,
    DepositToAccountRef_value,
    DepositToAccountRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    PrivateNote,
    GlobalTaxCalculation,
    TxnStatus,
    DepartmentRef_value,
    DepartmentRef_name,
    TransactionLocationType,
    CashBack_AccountRef_value,
    CashBack_AccountRef_name,
    CashBack_Amount,
    CashBack_Memo,
    LineId,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    Line_LinkedTxn_TxnId,
    Line_LinkedTxn_TxnType,
    Line_LinkedTxn_TxnLineId,
    DepositLineDetail_Entity_value,
    DepositLineDetail_Entity_name,
    DepositLineDetail_Entity_type,
    DepositLineDetail_ClassRef_value,
    DepositLineDetail_ClassRef_name,
    DepositLineDetail_AccountRef_value,
    DepositLineDetail_AccountRef_name,
    DepositLineDetail_PaymentMethodRef_value,
    DepositLineDetail_PaymentMethodRef_name,
    DepositLineDetail_CheckNum,
    DepositLineDetail_TxnType,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    sparse,
    domain,
    MetaData_CreateTime,
    MetaData_LastUpdatedTime,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_deposit
;

-- Credit Memo View
DROP VIEW IF EXISTS {clientID}_qbo_creditmemo;
CREATE VIEW {clientID}_qbo_creditmemo AS
SELECT
    Id,
    SyncToken,
    DocNumber,
    TxnDate,
    TotalAmt,
    HomeTotalAmt,
    Balance,
    CustomerRef_value,
    CustomerRef_name,
    CurrencyRef_value,
    CurrencyRef_name,
    ExchangeRate,
    Line_Id,
    Line_LineNum,
    Line_Description,
    Line_Amount,
    Line_DetailType,
    Line_SalesItemLineDetail_ItemRef_value,
    Line_SalesItemLineDetail_ItemRef_name,
    Line_SalesItemLineDetail_ClassRef_value,
    Line_SalesItemLineDetail_ClassRef_name,
    Line_SalesItemLineDetail_Qty,
    Line_SalesItemLineDetail_UnitPrice,
    Line_SalesItemLineDetail_TaxCodeRef_value,
    Line_SalesItemLineDetail_ServiceDate,
    TxnTaxDetail_TxnTaxCodeRef_value,
    TxnTaxDetail_TotalTax,
    CustomerMemo_value,
    BillAddr_Id,
    BillAddr_Line1,
    BillAddr_Line2,
    BillAddr_Line3,
    BillAddr_Line4,
    BillAddr_Line5,
    BillAddr_City,
    BillAddr_Country,
    BillAddr_CountrySubDivisionCode,
    BillAddr_PostalCode,
    ShipAddr_Id,
    ShipAddr_Line1,
    ShipAddr_Line2,
    ShipAddr_Line3,
    ShipAddr_Line4,
    ShipAddr_Line5,
    ShipAddr_City,
    ShipAddr_Country,
    ShipAddr_CountrySubDivisionCode,
    ShipAddr_PostalCode,
    FreeFormAddress,
    PrintStatus,
    EmailStatus,
    BillEmail_Address,
    GlobalTaxCalculation,
    TotalTax,
    TransactionLocationType,
    ApplyTaxAfterDiscount,
    sparse,
    domain,
    MetaData_CreateTime,
    MetaData_LastUpdatedTime,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_creditmemo
;

-- Transfer View
DROP VIEW IF EXISTS {clientID}_qbo_transfer;
CREATE VIEW {clientID}_qbo_transfer AS
SELECT
    Id,
    SyncToken,
    TxnDate,
    Amount,
    PrivateNote,
    FromAccountRef_value,
    FromAccountRef_name,
    ToAccountRef_value,
    ToAccountRef_name,
    sparse,
    domain,
    MetaData_CreateTime,
    MetaData_LastUpdatedTime,
    ClientID,
    OrganisationID
FROM c{clientID}_qbo_transfer
;


-- =====================================================
-- USAGE INSTRUCTIONS
-- =====================================================
/*
To use these views:

1. Replace {clientID} with actual client identifier
   Example: Replace {clientID} with CLIENT123

2. Execute the view creation statements for the client

3. Query the views to see customer, invoice, and other data

4. The views automatically filter by ClientID so you only see data for that client

5. Use the summary view to check data counts across all tables
*/