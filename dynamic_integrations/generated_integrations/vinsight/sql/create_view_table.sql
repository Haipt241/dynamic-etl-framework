-- VINSIGHT Views - Auto Generated
-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- AuditLogEntry View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_auditlogentry;
CREATE VIEW {etani_client_id}_vinsight_auditlogentry AS
SELECT
    json_id AS `$id`,
    id,
    related_id AS `relatedid`,
    date,
    type,
    source_type AS `sourcetype`,
    source_id AS `sourceid`,
    event_type AS `eventtype`,
    user_name AS `username`,
    requested_via AS `requestedvia`,
    remote_ip AS `remoteip`,
    description,
    data_format AS `dataformat`,
    user_id AS `userid`,
    organisation_id AS `organisationid`,
    alternate_key AS `alternatekey`,
    child_entries AS `childentries`,
    parent_entry AS `parententry`,
    user,
    data_json_id AS `data.$id`,
    datasalesordernum AS `data.salesordernum`,
    data_date_modified_from AS `data.-datemodified`,
    data_date_modified_to AS `data.+datemodified`,
    user_email AS `user.email`,
    organisation_name AS `organisation.name`,
    organisation_id_nested AS `organisation.id`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_auditlogentry;

-- Components View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_components;
CREATE VIEW {etani_client_id}_vinsight_components AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    component_group_num AS `componentgroupnum`,
    description,
    is_active AS `isactive`,
    asset_ledger_code AS `assetledgercode`,
    allocation_entries AS `allocationentries`,
    `group`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_components;

-- ContactActivity View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_contactactivity;
CREATE VIEW {etani_client_id}_vinsight_contactactivity AS
SELECT
    id AS `entrynum`,
    activity_date AS `activitydate`,
    attendees,
    categories,
    comments,
    contact_contact_code AS `contact.contactcode`,
    contact_email AS `contact.email`,
    contact_name AS `contactname`,
    contact_num AS `contactnum`,
    description,
    duration,
    organiser,
    organiser_contact_num AS `organisercontactnum`,
    gps,
    address,
    status,
    type_entry_num AS `type.entrynum`,
    type_code AS `type.code`,
    type_description AS `type.description`,
    type_icon AS `type.icon`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_contactactivity;

-- AuditLogChildEntries View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_auditlogchildentries;
CREATE VIEW {etani_client_id}_vinsight_auditlogchildentries AS
SELECT
    parent_audit_log_id AS `auditlogentryid`,
    id,
    type,
    description,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_auditlogchildentries;

-- ComponentsAllocationEntries View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_componentsallocationentries;
CREATE VIEW {etani_client_id}_vinsight_componentsallocationentries AS
SELECT
    component_id AS `componentid`,
    entry_num AS `entrynum`,
    allocation_percent AS `allocationpercent`,
    description,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_componentsallocationentries;

-- ContactCategories View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_contactcategories;
CREATE VIEW {etani_client_id}_vinsight_contactcategories AS
SELECT
    id AS `$id`,
    code,
    description,
    `values`,
    value_type AS `valuetype`,
    save_values AS `savevalues`,
    entry_num AS `entrynum`,
    can_multi_apply AS `canmultiapply`,
    is_multi_value AS `ismultivalue`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_contactcategories;

-- Contacts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_contacts;
CREATE VIEW {etani_client_id}_vinsight_contacts AS
SELECT
    id AS `$id`,
    contact_num AS `contactnum`,
    type,
    contact_code AS `contactcode`,
    legal_name AS `legalname`,
    first_name AS `firstname`,
    last_name AS `lastname`,
    title,
    phone,
    fax,
    mobile,
    email,
    comments,
    physical_use_postal_address AS `physicalusepostaladdress`,
    physical_address1 AS `physicaladdress1`,
    physical_address2 AS `physicaladdress2`,
    physical_city AS `physicalcity`,
    physical_region AS `physicalregion`,
    physical_post_code AS `physicalpostcode`,
    physical_country AS `physicalcountry`,
    postal_use_physical_address AS `postalusephysicaladdress`,
    postal_address AS `postaladdress`,
    postal_address2 AS `postaladdress2`,
    postal_city AS `postalcity`,
    postal_region AS `postalregion`,
    postal_code AS `postalcode`,
    postal_country AS `postalcountry`,
    key_words AS `keywords`,
    contact_category AS `contactcategory`,
    is_active AS `isactive`,
    is_creditor AS `iscreditor`,
    is_debtor AS `isdebtor`,
    is_grower AS `isgrower`,
    is_carrier AS `iscarrier`,
    is_mail_order AS `ismailorder`,
    is_employee AS `isemployee`,
    is_related_party AS `isrelatedparty`,
    is_grower_operator AS `isgroweroperator`,
    is_sales_operator AS `issalesoperator`,
    is_production_operator AS `isproductionoperator`,
    is_wine_tax_liable AS `iswinetaxliable`,
    credit_account_number AS `creditaccountnumber`,
    bank_account_number AS `bankaccountnumber`,
    bank_account_name AS `bankaccountname`,
    default_division_num_for_sales_orders AS `defaultdivisionnumforsalesorders`,
    default_division_num_for_purchase_orders AS `defaultdivisionnumforpurchaseorders`,
    default_stock_location_code AS `defaultstocklocationcode`,
    default_sales_person_num AS `defaultsalespersonnum`,
    default_sales_person_code AS `defaultsalespersoncode`,
    is_wine_tax_own_use AS `iswinetaxownuse`,
    tax_number AS `taxnumber`,
    default_payment_term_entry_num AS `defaultpaymenttermentrynum`,
    default_currency_num AS `defaultcurrencynum`,
    revenue_ledger_code AS `revenueledgercode`,
    default_bill_to_contact_num AS `defaultbilltocontactnum`,
    date_modified AS `datemodified`,
    default_sales_tax_rate_num AS `defaultsalestaxratenum`,
    expense_ledger_code AS `expenseledgercode`,
    physical_delivery_instructions AS `physicaldeliveryinstructions`,
    lead_time_hours AS `leadtimehours`,
    default_sales_order_template AS `defaultsalesordertemplate`,
    date_created AS `datecreated`,
    default_carrier_contact_num AS `defaultcarriercontactnum`,
    default_payment_term AS `defaultpaymentterm`,
    default_currency AS `defaultcurrency`,
    contact_activities AS `contactactivities`,
    default_sales_person_opr AS `defaultsalespersonopr`,
    default_sales_person AS `defaultsalesperson`,
    default_stock_location AS `defaultstocklocation`,
    default_bill_to_contact AS `defaultbilltocontact`,
    default_sales_tax_rate AS `defaultsalestaxrate`,
    default_carrier_contact AS `defaultcarriercontact`,
    lead_time AS `leadtime`,
    is_wet_liable AS `iswetliable`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_contacts;

-- Currencies View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencies;
CREATE VIEW {etani_client_id}_vinsight_currencies AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    currency_code AS `currencycode`,
    description,
    major_unit_symbol AS `majorunitsymbol`,
    major_unit_description AS `majorunitdescription`,
    minor_unit_symbol AS `minorunitsymbol`,
    minor_unit_description AS `minorunitdescription`,
    date_modified AS `datemodified`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencies;

-- Dashboard View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_dashboard;
CREATE VIEW {etani_client_id}_vinsight_dashboard AS
SELECT
    id AS `$id`,
    `key`,
    serialized_object AS `serializedobject`,
    format,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_dashboard;

-- CurrencySalesOrders View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencysalesorders;
CREATE VIEW {etani_client_id}_vinsight_currencysalesorders AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    sales_order_id AS `salesorderid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencysalesorders;


-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CurrencySalesOrderItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencysalesorderitems;
CREATE VIEW {etani_client_id}_vinsight_currencysalesorderitems AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    sales_order_item_id AS `salesorderitemid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencysalesorderitems;

-- CurrencyTaxTypes View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencytaxtypes;
CREATE VIEW {etani_client_id}_vinsight_currencytaxtypes AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    tax_type_id AS `taxtypeid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencytaxtypes;

-- CurrencyStockItemPrices View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencystockitemprices;
CREATE VIEW {etani_client_id}_vinsight_currencystockitemprices AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    stock_item_price_id AS `stockitempriceid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencystockitemprices;

-- CurrencyPurchaseOrders View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencypurchaseorders;
CREATE VIEW {etani_client_id}_vinsight_currencypurchaseorders AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    purchase_order_id AS `purchaseorderid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencypurchaseorders;

-- CurrencyDeals View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencydeals;
CREATE VIEW {etani_client_id}_vinsight_currencydeals AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    deal_id AS `dealid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencydeals;

-- CurrencyPurchaseOrderItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencypurchaseorderitems;
CREATE VIEW {etani_client_id}_vinsight_currencypurchaseorderitems AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    purchase_order_item_id AS `purchaseorderitemid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencypurchaseorderitems;

-- CurrencyContacts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencycontacts;
CREATE VIEW {etani_client_id}_vinsight_currencycontacts AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    contact_id AS `contactid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencycontacts;

-- CurrencyDivisions View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencydivisions;
CREATE VIEW {etani_client_id}_vinsight_currencydivisions AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    division_id AS `divisionid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencydivisions;

-- CurrencyCdrs View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencycdrs;
CREATE VIEW {etani_client_id}_vinsight_currencycdrs AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    cdr_id AS `cdrid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencycdrs;

-- CurrencyDtrPyts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencydtrpyts;
CREATE VIEW {etani_client_id}_vinsight_currencydtrpyts AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    dtr_pyt_id AS `dtrpytid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencydtrpyts;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- CurrencyGenJorEnts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencygenjorents;
CREATE VIEW {etani_client_id}_vinsight_currencygenjorents AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    gen_jor_ent_id AS `genjorentid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencygenjorents;

-- CurrencyStkItmPrcLists View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_currencystkitmprclists;
CREATE VIEW {etani_client_id}_vinsight_currencystkitmprclists AS
SELECT
    currency_entry_num AS `currencyentrynum`,
    stk_itm_prc_list_id AS `stkitmprclistid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_currencystkitmprclists;

-- Divisions View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisions;
CREATE VIEW {etani_client_id}_vinsight_divisions AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    division_code AS `divisioncode`,
    description,
    company_name AS `companyname`,
    legal_name AS `legalname`,
    physical_address1 AS `physicaladdress1`,
    physical_address2 AS `physicaladdress2`,
    physical_city AS `physicalcity`,
    physical_region AS `physicalregion`,
    physical_post_code AS `physicalpostcode`,
    physical_country AS `physicalcountry`,
    postal_address AS `postaladdress`,
    postal_address2 AS `postaladdress2`,
    postal_city AS `postalcity`,
    postal_region AS `postalregion`,
    postal_code AS `postalcode`,
    postal_country AS `postalcountry`,
    phone,
    fax,
    email,
    tax_number AS `taxnumber`,
    company_image_path AS `companyimagepath`,
    logo_dimensions AS `logodimensions`,
    logo_contains_name AS `logocontainsname`,
    excise_rate1 AS `exciserate1`,
    excise_rate2 AS `exciserate2`,
    excise_rate3 AS `exciserate3`,
    sales_tax_rate AS `salestaxrate`,
    culture,
    logo_image_content_type AS `logoimagecontenttype`,
    bank_account_name AS `bankaccountname`,
    bank_account_number AS `bankaccountnumber`,
    remittance_instructions AS `remittanceinstructions`,
    weight_unit_of_measure_code AS `weightunitofmeasurecode`,
    volume_unit_of_measure_code AS `volumeunitofmeasurecode`,
    length_unit_of_measure_code AS `lengthunitofmeasurecode`,
    invoice_footer AS `invoicefooter`,
    invoice_header AS `invoiceheader`,
    invoice_division_address AS `invoicedivisionaddress`,
    default_currency_num AS `defaultcurrencynum`,
    cost_method AS `costmethod`,
    first_sales_tax_period AS `firstsalestaxperiod`,
    sales_tax_period AS `salestaxperiod`,
    balance_date AS `balancedate`,
    footer_image_content_type AS `footerimagecontenttype`,
    company_contact_num AS `companycontactnum`,
    timezone,
    shipment_length_unit_of_measure_code AS `shipmentlengthunitofmeasurecode`,
    shipment_weight_unit_of_measure_code AS `shipmentweightunitofmeasurecode`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisions;

-- DivisionSalesOrders View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisionsalesorders;
CREATE VIEW {etani_client_id}_vinsight_divisionsalesorders AS
SELECT
    division_entry_num AS `divisionentrynum`,
    sales_order_id AS `salesorderid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisionsalesorders;

-- DivisionDeals View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisiondeals;
CREATE VIEW {etani_client_id}_vinsight_divisiondeals AS
SELECT
    division_entry_num AS `divisionentrynum`,
    deal_id AS `dealid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisiondeals;

-- DivisionPurchaseOrders View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisionpurchaseorders;
CREATE VIEW {etani_client_id}_vinsight_divisionpurchaseorders AS
SELECT
    division_entry_num AS `divisionentrynum`,
    purchase_order_id AS `purchaseorderid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisionpurchaseorders;

-- DivisionAssessments View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisionassessments;
CREATE VIEW {etani_client_id}_vinsight_divisionassessments AS
SELECT
    division_entry_num AS `divisionentrynum`,
    assessment_id AS `assessmentid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisionassessments;

-- DivisionStockItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisionstockitems;
CREATE VIEW {etani_client_id}_vinsight_divisionstockitems AS
SELECT
    division_entry_num AS `divisionentrynum`,
    stock_item_id AS `stockitemid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisionstockitems;

-- DivisionJournals View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_divisionjournals;
CREATE VIEW {etani_client_id}_vinsight_divisionjournals AS
SELECT
    division_entry_num AS `divisionentrynum`,
    journal_id AS `journalid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_divisionjournals;

-- Documents View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_documents;
CREATE VIEW {etani_client_id}_vinsight_documents AS
SELECT
    categories,
    url,
    content,
    id,
    date_created AS `datecreated`,
    date_modified AS `datemodified`,
    is_active AS `isactive`,
    name,
    display_name AS `displayname`,
    mime_type AS `mimetype`,
    entry_type AS `entrytype`,
    content_encoding AS `contentencoding`,
    md5_hash AS `md5hash`,
    size_bytes AS `sizebytes`,
    owner_id AS `ownerid`,
    owner_display_name AS `owner_displayname`,
    owner_type AS `ownertype`,
    html_link_snippet AS `htmllinksnippet`,
    attachments_count AS `attachmentscount`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_documents;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- DuePayments View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_duepayments;
CREATE VIEW {etani_client_id}_vinsight_duepayments AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    due_date AS `duedate`,
    amount,
    description,
    payment_term_entry_num AS `paymenttermentrynum`,
    source_num AS `sourcenum`,
    source_type AS `sourcetype`,
    date_modified AS `datemodified`,
    payment_term AS `paymentterm`,
    sales_order AS `salesorder`,
    purchase_order AS `purchaseorder`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_duepayments;

-- ExpressionDefinition View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_expressiondefinition;
CREATE VIEW {etani_client_id}_vinsight_expressiondefinition AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    description,
    expression,
    expression_language AS `expressionlanguage`,
    argument_types AS `argumenttypes`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_expressiondefinition;

-- LedgerAccounts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_ledgeraccounts;
CREATE VIEW {etani_client_id}_vinsight_ledgeraccounts AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    description,
    ledger_account_type_num AS `ledgeraccounttypenum`,
    is_inventory_ledger AS `isinventoryledger`,
    is_debtor_ledger AS `isdebtorledger`,
    is_creditor_ledger AS `iscreditorledger`,
    is_cash_flow_ledger AS `iscashflowledger`,
    is_bank_account AS `isbankaccount`,
    is_active AS `isactive`,
    comment,
    ledger_account_type_id AS `ledgeraccounttype.$id`,
    ledger_account_type_entry_num AS `ledgeraccounttype.entrynum`,
    ledger_account_type_code AS `ledgeraccounttype.code`,
    ledger_account_type_ref AS `ledgeraccounttype.$ref`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_ledgeraccounts;

-- PaymentTerms View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_paymentterms;
CREATE VIEW {etani_client_id}_vinsight_paymentterms AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    description,
    percentage,
    expression_entry_num AS `expressionentrynum`,
    parent_entry_num AS `parententrynum`,
    expression_argument AS `expressionargument`,
    date_modified AS `datemodified`,
    expression_definition_entry_num AS `expressiondefinition.entrynum`,
    expression_definition_code AS `expressiondefinition.code`,
    expression_definition_description AS `expressiondefinition.description`,
    expression_definition_expression AS `expressiondefinition.expression`,
    expression_definition_expression_language AS `expressiondefinition.expressionlanguage`,
    expression_definition_argument_types AS `expressiondefinition.argumenttypes`,
    expression_definition_payment_terms AS `expressiondefinition.paymentterms`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_paymentterms;

-- ProductCategory View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_productcategory;
CREATE VIEW {etani_client_id}_vinsight_productcategory AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    description,
    `values`,
    value_type AS `valuetype`,
    save_values AS `savevalues`,
    can_multi_apply AS `canmultiapply`,
    is_multi_value AS `ismultivalue`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_productcategory;

-- AuditLogEntries View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_auditlogentries;
CREATE VIEW {etani_client_id}_vinsight_auditlogentries AS
SELECT
    api_id AS `$id`,
    id,
    related_id AS `relatedid`,
    date,
    type,
    source_type AS `sourcetype`,
    source_id AS `sourceid`,
    event_type AS `eventtype`,
    user_name AS `username`,
    requested_via AS `requestedvia`,
    remote_ip AS `remoteip`,
    description,
    `data`,
    data_format AS `dataformat`,
    user_id AS `userid`,
    organisation_id AS `organisationid`,
    alternate_key AS `alternatekey`,
    parent_entry_id AS `parententry.id`,
    parent_entry_date AS `parententry.date`,
    parent_entry_type AS `parententry.type`,
    user_user_name AS `user.username`,
    user_first_name AS `user.firstname`,
    user_last_name AS `user.lastname`,
    organisation_name AS `organisation.name`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_auditlogentries;

-- ProductDetail View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_productdetail;
CREATE VIEW {etani_client_id}_vinsight_productdetail AS
SELECT
    id AS `$id`,
    `key`,
    serialized_object AS `serializedobject`,
    format,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_productdetail;

-- PurchaseOrderItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorderitems;
CREATE VIEW {etani_client_id}_vinsight_purchaseorderitems AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    description,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    unit_price AS `unitprice`,
    discount,
    sales_tax_rate_value AS `salestaxratevalue`,
    sales_tax_rate_num AS `salestaxratenum`,
    price_entry_num AS `priceentrynum`,
    discount_entry_num AS `discountentrynum`,
    price_description AS `pricedescription`,
    discount_description AS `discountdescription`,
    order_num AS `ordernum`,
    currency_num AS `currencynum`,
    stock_item_num AS `stockitemnum`,
    suppliers_code AS `supplierscode`,
    total_cost AS `totalcost`,
    analysis_certificate AS `analysiscertificate`,
    lot_code AS `lotcode`,
    date_first_used AS `datefirstused`,
    date_last_used AS `datelastused`,
    allocation_type AS `allocationtype`,
    allocation_id AS `allocationid`,
    allocation_num AS `allocationnum`,
    expiry_date AS `expirydate`,
    quantity_available AS `quantityavailable`,
    sort,
    discount_numeric AS `discountnumeric`,
    currency,
    `order`,
    stock_item AS `stockitem`,
    sales_tax_rate AS `salestaxrate`,
    unit_of_measure AS `unitofmeasure`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorderitems;

-- PurchaseOrderReceiptItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorderreceiptitems;
CREATE VIEW {etani_client_id}_vinsight_purchaseorderreceiptitems AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    receipt_num AS `receiptnum`,
    stock_item_num AS `stockitemnum`,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    units_in_stock_initially_at_location AS `unitsinstockinitiallyatlocation`,
    units_in_stock_finally_at_location AS `unitsinstockfinallyatlocation`,
    units_in_stock_initially_at_all_locations AS `unitsinstockinitiallyatalllocations`,
    units_in_stock_finally_at_all_locations AS `unitsinstockfinallyatalllocations`,
    units_in_stock_unit_of_measure AS `unitsinstockunitofmeasure`,
    cost_method AS `costmethod`,
    cost_per_unit AS `costperunit`,
    cost_total AS `costtotal`,
    analysis_certificate AS `analysiscertificate`,
    lot_code AS `lotcode`,
    date_first_used AS `datefirstused`,
    date_last_used AS `datelastused`,
    supplier_code AS `suppliercode`,
    sort,
    receipt,
    stock_item AS `stockitem`,
    unit_of_measure AS `unitofmeasure`,
    warnings,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorderreceiptitems;

-- PurchaseOrderReceipts View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorderreceipts;
CREATE VIEW {etani_client_id}_vinsight_purchaseorderreceipts AS
SELECT
    id AS `$id`,
    receipt_num AS `receiptnum`,
    date_delivered AS `datedelivered`,
    order_num AS `ordernum`,
    is_updated AS `isupdated`,
    is_final_delivery AS `isfinaldelivery`,
    stock_location_code AS `stocklocationcode`,
    is_active AS `isactive`,
    delivery_instructions AS `deliveryinstructions`,
    date_modified AS `datemodified`,
    `order`,
    stock_location AS `stocklocation`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorderreceipts;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrderReceiptEntries View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorderreceiptentries;
CREATE VIEW {etani_client_id}_vinsight_purchaseorderreceiptentries AS
SELECT
    purchase_order_receipts_id AS `purchaseorderreceipts_id`,
    purchase_order_receipts_organisation_id AS `purchaseorderreceipts_organisationid`,
    entry_num AS `entrynum`,
    quantity,
    description,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorderreceiptentries;

-- PurchaseOrderReceiptAliases View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorderreceiptaliases;
CREATE VIEW {etani_client_id}_vinsight_purchaseorderreceiptaliases AS
SELECT
    purchase_order_receipts_id AS `purchaseorderreceipts_id`,
    purchase_order_receipts_organisation_id AS `purchaseorderreceipts_organisationid`,
    alias_name AS `aliasname`,
    alias_type AS `aliastype`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorderreceiptaliases;

-- PurchaseOrder View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_purchaseorder;
CREATE VIEW {etani_client_id}_vinsight_purchaseorder AS
SELECT
    id AS `$id`,
    order_num AS `ordernum`,
    order_reference AS `orderreference`,
    delivery_address,
    delivery_instructions AS `deliveryinstructions`,
    ordered_with AS `orderedwith`,
    sub_total_amount AS `subtotalamount`,
    comments,
    currency_num AS `currencynum`,
    payment_term_description AS `paymenttermdescription`,
    transaction_reference AS `transactionreference`,
    is_posted AS `isposted`,
    stock_location_code AS `stocklocationcode`,
    status,
    payment_term_entry_num AS `paymenttermentrynum`,
    operator_num AS `operatornum`,
    total_excluding_taxes AS `totalexcludingtaxes`,
    billing_contact_num AS `billingcontactnum`,
    date_modified AS `datemodified`,
    categories,
    date_created AS `datecreated`,
    invoice_accounting_status AS `invoiceaccountingstatus`,
    division_num AS `divisionnum`,
    date_delivered AS `datedelivered`,
    contact_num AS `contactnum`,
    ordered_by_operator_code AS `orderedbyoperatorcode`,
    order_date AS `orderdate`,
    date_required AS `daterequired`,
    date_paid AS `datepaid`,
    date_payment_due AS `datepaymentdue`,
    is_active AS `isactive`,
    total_including_taxes AS `totalincludingtaxes`,
    currency_rate AS `currencyrate`,
    contact_contact_num AS `contact.contactnum`,
    contact_type AS `contact.type`,
    contact_contact_code AS `contact.contactcode`,
    contact_legal_name AS `contact.legalname`,
    contact_first_name AS `contact.firstname`,
    contact_last_name AS `contact.lastname`,
    contact_title AS `contact.title`,
    contact_phone AS `contact.phone`,
    contact_fax AS `contact.fax`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_purchaseorder;

-- Region View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_region;
CREATE VIEW {etani_client_id}_vinsight_region AS
SELECT
    id AS `$id`,
    region_code AS `regioncode`,
    description,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_region;

-- ResourceCollections View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_resourcecollections;
CREATE VIEW {etani_client_id}_vinsight_resourcecollections AS
SELECT
    ref_id AS `$id`,
    id,
    name,
    parent_collection_id AS `parentcollectionid`,
    date_modified AS `datemodified`,
    parent_collection AS `parentcollection`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_resourcecollections;

-- Addons View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_addons;
CREATE VIEW {etani_client_id}_vinsight_addons AS
SELECT
    api_id AS `$id`,
    open_api_specification_file AS `openapispecificationfile`,
    id,
    name,
    short_name AS `shortname`,
    author,
    image_url AS `imageurl`,
    description,
    link_description AS `linkdescription`,
    web_address AS `webaddress`,
    tags,
    position,
    integrations,
    disconnect_link AS `disconnectlink`,
    max_integrations AS `maxintegrations`,
    for_countries AS `forcountries`,
    is_permanent AS `ispermanent`,
    is_in_session_only AS `isinsessiononly`,
    is_active AS `isactive`,
    is_invite_only AS `isinviteonly`,
    is_plugin AS `isplugin`,
    billing_category AS `billingcategory`,
    per_integration_billing_max_paid AS `perintegrationbillingmaxpaid`,
    listens_to_webhooks AS `listenstowebhooks`,
    api_rate_limit_calls_per_second AS `apiratelimitcallspersecond`,
    o_auth_flow AS `oauthflow`,
    security_scheme AS `securityscheme`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_addons;

-- Roles View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_roles;
CREATE VIEW {etani_client_id}_vinsight_roles AS
SELECT
    ref_id AS `$id`,
    application_id AS `applicationid`,
    id,
    name,
    lowered_name AS `loweredname`,
    description,
    is_read_only AS `isreadonly`,
    date_modified AS `datemodified`,
    organisation_id AS `organisationid`,
    is_admin AS `isadmin`,
    application,
    is_two_factor_required AS `istwofactorrequired`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_roles;

-- SalesOrderDespatches View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_salesorderdespatches;
CREATE VIEW {etani_client_id}_vinsight_salesorderdespatches AS
SELECT
    id AS `$id`,
    despatch_num AS `despatchnum`,
    order_num AS `ordernum`,
    date_despatched AS `datedespatched`,
    is_updated AS `isupdated`,
    is_final_despatch AS `isfinaldespatch`,
    date_updated AS `dateupdated`,
    carrier_code AS `carriercode`,
    reference,
    comments,
    delivery_name,
    delivery_address,
    delivery_suburb AS `deliverysuburb`,
    delivery_city AS `deliverycity`,
    delivery_region AS `deliveryregion`,
    delivery_post_code AS `deliverypostcode`,
    delivery_country AS `deliverycountry`,
    delivery_email AS `deliveryemail`,
    delivery_phone AS `deliveryphone`,
    delivery_instructions AS `deliveryinstructions`,
    stock_location_code AS `stocklocationcode`,
    is_active AS `isactive`,
    carrier_contact_num AS `carriercontactnum`,
    date_modified AS `datemodified`,
    location_notified AS `locationnotified`,
    carrier_notified AS `carriernotified`,
    location_status AS `locationstatus`,
    carrier_status AS `carrierstatus`,
    categories,
    `order`,
    stock_location AS `stocklocation`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_salesorderdespatches;

-- SalesOrderDespatchItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_salesorderdespatchitems;
CREATE VIEW {etani_client_id}_vinsight_salesorderdespatchitems AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    despatch_num AS `despatchnum`,
    stock_item_num AS `stockitemnum`,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    units_in_stock_initially_at_location AS `unitsinstockinitiallyatlocation`,
    units_in_stock_finally_at_location AS `unitsinstockfinallyatlocation`,
    units_in_stock_initially_at_all_locations AS `unitsinstockinitiallyatalllocations`,
    units_in_stock_finally_at_all_locations AS `unitsinstockfinallyatalllocations`,
    units_in_stock_unit_of_measure AS `unitsinstockunitofmeasure`,
    cost_method AS `costmethod`,
    cost_per_unit AS `costperunit`,
    cost_total AS `costtotal`,
    quantity_required AS `quantityrequired`,
    quantity_back_ordered AS `quantitybackordered`,
    lot_code AS `lotcode`,
    description,
    sort,
    parent_entry_num AS `parententrynum`,
    date_modified AS `datemodified`,
    despatch,
    stock_item AS `stockitem`,
    unit_of_measure AS `unitofmeasure`,
    parent,
    warnings,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_salesorderdespatchitems;

-- SalesOrderItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_salesorderitems;
CREATE VIEW {etani_client_id}_vinsight_salesorderitems AS
SELECT
    entry_num AS `entrynum`,
    description,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    unit_price AS `unitprice`,
    discount,
    sales_tax_rate_value AS `salestaxratevalue`,
    sales_tax_rate_num AS `salestaxratenum`,
    is_wine_tax_liable AS `iswinetaxliable`,
    wine_tax_rate_value AS `winetaxratevalue`,
    wine_tax_rate_num AS `winetaxratenum`,
    price_description AS `pricedescription`,
    discount_description AS `discountdescription`,
    order_num AS `ordernum`,
    currency_num AS `currencynum`,
    stock_item_num AS `stockitemnum`,
    price_entry_num AS `priceentrynum`,
    discount_entry_num AS `discountentrynum`,
    stock_location_code AS `stocklocationcode`,
    sort,
    allocation_type AS `allocationtype`,
    allocation_id AS `allocationid`,
    allocation_num AS `allocationnum`,
    discount_numeric AS `discountnumeric`,
    source_entry_num AS `sourceentrynum`,
    order_salesordernum AS `order.salesordernum`,
    order_delivery_name AS `order.delivery_name`,
    order_delivery_address AS `order.delivery_address`,
    order_delivery_suburb AS `order.deliverysuburb`,
    order_delivery_city AS `order.deliverycity`,
    order_delivery_region AS `order.deliveryregion`,
    order_delivery_post_code AS `order.deliverypostcode`,
    order_delivery_country AS `order.deliverycountry`,
    order_delivery_email AS `order.deliveryemail`,
    order_delivery_phone AS `order.deliveryphone`,
    order_delivery_instructions AS `order.deliveryinstructions`,
    order_comments AS `order.comments`,
    order_order_reference AS `order.orderreference`,
    order_order_date AS `order.orderdate`,
    order_invoice_date AS `order.invoicedate`,
    order_date_required AS `order.daterequired`,
    order_date_despatched AS `order.datedespatched`,
    order_date_payment_due AS `order.datepaymentdue`,
    order_payment_term_description AS `order.paymenttermdescription`,
    order_date_paid AS `order.datepaid`,
    order_carrier_code AS `order.carriercode`,
    order_sub_total_amount AS `order.subtotalamount`,
    order_freight_amount AS `order.freightamount`,
    order_is_posted AS `order.isposted`,
    order_transaction_reference AS `order.transactionreference`,
    order_is_wine_tax_liable AS `order.iswinetaxliable`,
    order_contact_num AS `order.contactnum`,
    order_division_num AS `order.divisionnum`,
    order_sales_person_code AS `order.salespersoncode`,
    order_currency_num AS `order.currencynum`,
    order_stock_location_code AS `order.stocklocationcode`,
    order_status AS `order.status`,
    order_payment_term_entry_num AS `order.paymenttermentrynum`,
    order_is_non_arms_length AS `order.isnonarmslength`,
    order_sales_person_num AS `order.salespersonnum`,
    order_carrier_contact_num AS `order.carriercontactnum`,
    order_currency_rate AS `order.currencyrate`,
    order_invoice_sent_status AS `order.invoicesentstatus`,
    order_invoice_paid_status AS `order.invoicepaidstatus`,
    order_order_delivery_status AS `order.orderdeliverystatus`,
    order_order_movement_status AS `order.ordermovementstatus`,
    order_tracking_uri AS `order.trackinguri`,
    order_total_including_taxes AS `order.totalincludingtaxes`,
    order_total_excluding_taxes AS `order.totalexcludingtaxes`,
    order_billing_contact_num AS `order.billingcontactnum`,
    order_is_active AS `order.isactive`,
    order_datemodified AS `order.datemodified`,
    order_categories AS `order.categories`,
    order_validation_error AS `order.validationerror`,
    order_datecreated AS `order.datecreated`,
    order_contact AS `order.contact`,
    order_currency AS `order.currency`,
    order_items AS `order.items`,
    order_sales_person_opr AS `order.salespersonopr`,
    order_stock_location AS `order.stocklocation`,
    order_payment_term AS `order.paymentterm`,
    order_sales_person AS `order.salesperson`,
    order_carrier_contact AS `order.carriercontact`,
    order_billing_contact AS `order.billingcontact`,
    order_$ref AS `order.$ref`,
    order_division AS `order.division`,
    currency,
    stock_item AS `stockitem`,
    sales_tax_rate AS `salestaxrate`,
    wine_tax_rate AS `winetaxrate`,
    unit_of_measure AS `unitofmeasure`,
    price_list_entry AS `pricelistentry`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_salesorderitems;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- SalesOrders View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_salesorders;
CREATE VIEW {etani_client_id}_vinsight_salesorders AS
SELECT
    salesordernum,
    division_num AS `divisionnum`,
    contact_num AS `contactnum`,
    contact_contact_code AS `contact.contactcode`,
    contact_default_sales_order_template AS `contact.defaultsalesordertemplate`,
    contact_$ref AS `contact.$ref`,
    division_division_code AS `division.divisioncode`,
    division_$ref AS `division.$ref`,
    invoice_date AS `invoicedate`,
    date_paid AS `datepaid`,
    date_payment_due AS `datepaymentdue`,
    order_reference AS `orderreference`,
    total_including_taxes AS `totalincludingtaxes`,
    currency_currency_code AS `currency.currencycode`,
    currency_major_unit_symbol AS `currency.majorunitsymbol`,
    currency_$ref AS `currency.$ref`,
    currency_rate AS `currencyrate`,
    date_despatched AS `datedespatched`,
    status,
    is_active AS `isactive`,
    categories,
    stock_location_code AS `stocklocationcode`,
    invoice_sent_status AS `invoicesentstatus`,
    delivery_region AS `deliveryregion`,
    despatch_status AS `despatchstatus`,
    stock_locations_count AS `stocklocationscount`,
    first_despatch_location AS `firstdespatchlocation`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_salesorders;

-- StockItemComponents View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockitemcomponents;
CREATE VIEW {etani_client_id}_vinsight_stockitemcomponents AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    stock_item_num AS `stockitemnum`,
    component_stock_item_num AS `componentstockitemnum`,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    entity_type AS `entitytype`,
    entity_id AS `entityid`,
    is_quantity_total AS `isquantitytotal`,
    entity_num AS `entitynum`,
    rate_type AS `ratetype`,
    stock_item AS `stockitem`,
    component_stock_item AS `componentstockitem`,
    stock_item_unit_of_measure AS `stockitemunitofmeasure`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockitemcomponents;

-- StockItemLocations View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockitemlocations;
CREATE VIEW {etani_client_id}_vinsight_stockitemlocations AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    stock_item_num AS `stockitemnum`,
    stock_location_code AS `stocklocationcode`,
    units_in_stock AS `unitsinstock`,
    unit_of_measure_code AS `unitofmeasurecode`,
    total_cost AS `totalcost`,
    latest_cost AS `latestcost`,
    standard_cost AS `standardcost`,
    re_ord_lvl AS `reordlvl`,
    stock_item AS `stockitem`,
    stock_location AS `stocklocation`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockitemlocations;

-- StockItemMovements View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockitemmovements;
CREATE VIEW {etani_client_id}_vinsight_stockitemmovements AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    operation_type AS `operationtype`,
    operation_id AS `operationid`,
    source_operation_type AS `sourceoperationtype`,
    source_operation_id AS `sourceoperationid`,
    transaction_description AS `transactiondescription`,
    date_processed AS `dateprocessed`,
    date_as_at AS `dateasat`,
    entity_type AS `entitytype`,
    entity_id AS `entityid`,
    stock_item_num AS `stockitemnum`,
    stock_location_code AS `stocklocationcode`,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    units_in_stock_initially_at_location AS `unitsinstockinitiallyatlocation`,
    units_in_stock_finally_at_location AS `unitsinstockfinallyatlocation`,
    units_in_stock_initially_at_all_locations AS `unitsinstockinitiallyatalllocations`,
    units_in_stock_finally_at_all_locations AS `unitsinstockfinallyatalllocations`,
    units_in_stock_units_of_measure_code AS `unitsinstockunitsofmeasurecode`,
    cost_method AS `costmethod`,
    cost_per_unit AS `costperunit`,
    cost_total AS `costtotal`,
    standard_cost_initial AS `standardcostinitial`,
    standard_cost_final AS `standardcostfinal`,
    total_cost_variance AS `totalcostvariance`,
    stock_item AS `stockitem`,
    unit_of_measure AS `unitofmeasure`,
    units_in_stock_unit_of_measure AS `unitsinstockunitofmeasure`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockitemmovements;

-- StockItemPrices View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockitemprices;
CREATE VIEW {etani_client_id}_vinsight_stockitemprices AS
SELECT
    entry_num AS `entrynum`,
    unit_of_measure_code AS `unitofmeasurecode`,
    price_description AS `pricedescription`,
    price,
    discount,
    discount_numeric AS `discountnumeric`,
    is_default_price AS `isdefaultprice`,
    order_type AS `ordertype`,
    type,
    sales_tax_rate_num AS `salestaxratenum`,
    currency_num AS `currencynum`,
    contact_num AS `contactnum`,
    contact_category AS `contactcategory`,
    expiry_date AS `expirydate`,
    active_date AS `activedate`,
    stock_item_num AS `stockitemnum`,
    product_category AS `productcategory`,
    is_purchase_price AS `ispurchaseprice`,
    currency_currency_code AS `currency.currencycode`,
    salestaxrate_code AS `salestaxrate.code`,
    stockitem_stock_item_code AS `stockitem.stockitemcode`,
    uom_entry_num AS `unitofmeasure.entrynum`,
    uom_stock_item_num AS `unitofmeasure.stockitemnum`,
    uom_unit_of_measure_code AS `unitofmeasure.unitofmeasurecode`,
    uom_conversion_rate AS `unitofmeasure.conversionrate`,
    uom_length AS `unitofmeasure.length`,
    uom_width AS `unitofmeasure.width`,
    uom_height AS `unitofmeasure.height`,
    uom_weight AS `unitofmeasure.weight`,
    uom_stock_item AS `unitofmeasure.stockitem`,
    uom_unit_of_measure AS `unitofmeasure.unitofmeasure`,
    can_multi_apply AS `canmultiapply`,
    status,
    contact,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockitemprices;

-- StockItems View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockitems;
CREATE VIEW {etani_client_id}_vinsight_stockitems AS
SELECT
    id AS `$id`,
    stock_item_num AS `stockitemnum`,
    stock_item_code AS `stockitemcode`,
    description,
    stock_group_code AS `stockgroupcode`,
    lot_code AS `lotcode`,
    re_order_level AS `reorderlevel`,
    comments,
    is_wine_additive AS `iswineadditive`,
    is_purchase_order_item AS `ispurchaseorderitem`,
    is_packaging AS `ispackaging`,
    is_bulk_wine AS `isbulkwine`,
    is_sales_order_item AS `issalesorderitem`,
    is_packaged_wine AS `ispackagedwine`,
    is_stock_take_item AS `isstocktakeitem`,
    is_grower_additive AS `isgroweradditive`,
    is_wine_tax_liable AS `iswinetaxliable`,
    operation_standard_text AS `operationstandardtext`,
    trial_stock_solution_strength AS `trialstocksolutionstrength`,
    default_rate AS `defaultrate`,
    default_rate_type AS `defaultratetype`,
    default_rate_uom AS `defaultrateuom`,
    default_quantity_uom AS `defaultquantityuom`,
    default_volume_per_area AS `defaultvolumeperarea`,
    quantity_per_unit AS `quantityperunit`,
    default_stock_location_code AS `defaultstocklocationcode`,
    units_in_stock AS `unitsinstock`,
    units_in_stock_uom AS `unitsinstockuom`,
    standard_cost AS `standardcost`,
    total_cost AS `totalcost`,
    latest_cost AS `latestcost`,
    cost_method AS `costmethod`,
    base_uom AS `baseuom`,
    inner_uom AS `inneruom`,
    outer_uom AS `outeruom`,
    pallet_count AS `palletcount`,
    date_updated AS `dateupdated`,
    revenue_ledger_code AS `revenueledgercode`,
    expense_ledger_code AS `expenseledgercode`,
    asset_ledger_code AS `assetledgercode`,
    is_active AS `isactive`,
    allocation_stock_item_num AS `allocationstockitemnum`,
    bar_code AS `barcode`,
    allocation_status AS `allocationstatus`,
    sales_tax_rate_num AS `salestaxratenum`,
    wine_tax_rate_num AS `winetaxratenum`,
    supplier_num AS `suppliernum`,
    previous_packaging_operation_num AS `previouspackagingoperationnum`,
    pallet_spec_num AS `palletspecnum`,
    labelling_spec_num AS `labellingspecnum`,
    packaging_template_stock_item_num AS `packagingtemplatestockitemnum`,
    default_application_rate_type AS `defaultapplicationratetype`,
    product_categories AS `productcategories`,
    date_modified AS `datemodified`,
    auto_build AS `autobuild`,
    lead_time_hours AS `leadtimehours`,
    division_num AS `divisionnum`,
    next_standard_cost_type AS `nextstandardcosttype`,
    system_flags AS `systemflags`,
    is_system_defined AS `issystemdefined`,
    system_prevents_edit AS `systempreventsedit`,
    system_prevents_delete AS `systempreventsdelete`,
    kit_creation AS `kitcreation`,
    kit_price_list AS `kitpricelist`,
    prices,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockitems;

-- Aliases View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_aliases;
CREATE VIEW {etani_client_id}_vinsight_aliases AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    entity_type AS `entitytype`,
    entity_id AS `entityid`,
    entity_num AS `entitynum`,
    entity_uniqifier AS `entityuniqifier`,
    domain,
    sub_domain AS `subdomain`,
    sub_domain_description AS `subdomaindescription`,
    domain_entity_type AS `domainentitytype`,
    domain_entity_id AS `domainentityid`,
    domain_entity_code AS `domainentitycode`,
    domain_entity_description AS `domainentitydescription`,
    domain_entity_url AS `domainentityurl`,
    domain_data AS `domaindata`,
    hash,
    entity_num_small AS `entitynumsmall`,
    date_modified AS `datemodified`,
    parent_entry_num AS `parententrynum`,
    is_active AS `isactive`,
    domain_date_modified AS `domaindatemodified`,
    date_cache_updated AS `datecacheupdated`,
    validation_error AS `validationerror`,
    contact,
    stock_item AS `stockitem`,
    sales_order AS `salesorder`,
    purchase_order AS `purchaseorder`,
    tax_rate AS `taxrate`,
    stock_location AS `stocklocation`,
    sales_order_despatch AS `salesorderdespatch`,
    parent_alias AS `parentalias`,
    payment_term AS `paymentterm`,
    stock_item_price AS `stockitemprice`,
    journal,
    sales_order_item AS `salesorderitem`,
    ledger_account AS `ledgeraccount`,
    purchase_order_receipt AS `purchaseorderreceipt`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_aliases;

-- ChildAliases View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_childaliases;
CREATE VIEW {etani_client_id}_vinsight_childaliases AS
SELECT
    id AS `$id`,
    parent_alias_id AS `parentaliasid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_childaliases;

-- StockLocations View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stocklocations;
CREATE VIEW {etani_client_id}_vinsight_stocklocations AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    code,
    description,
    is_bonded AS `isbonded`,
    owner_contact_num AS `ownercontactnum`,
    is_active AS `isactive`,
    date_modified AS `datemodified`,
    owner_type AS `owner.type`,
    owner_contact_code AS `owner.contactcode`,
    owner_legal_name AS `owner.legalname`,
    owner_first_name AS `owner.firstname`,
    owner_last_name AS `owner.lastname`,
    owner_title AS `owner.title`,
    owner_phone AS `owner.phone`,
    owner_fax AS `owner.fax`,
    owner_mobile AS `owner.mobile`,
    owner_email AS `owner.email`,
    owner_comments AS `owner.comments`,
    owner_physical_use_postal_address AS `owner.physicalusepostaladdress`,
    owner_physical_address1 AS `owner.physicaladdress1`,
    owner_physical_address2 AS `owner.physicaladdress2`,
    owner_physical_city AS `owner.physicalcity`,
    owner_physical_region AS `owner.physicalregion`,
    owner_physical_post_code AS `owner.physicalpostcode`,
    owner_physical_country AS `owner.physicalcountry`,
    owner_postal_use_physical_address AS `owner.postalusephysicaladdress`,
    owner_postal_address AS `owner.postaladdress`,
    owner_postal_address2 AS `owner.postaladdress2`,
    owner_postal_city AS `owner.postalcity`,
    owner_postal_region AS `owner.postalregion`,
    owner_postal_code AS `owner.postalcode`,
    owner_postal_country AS `owner.postalcountry`,
    owner_key_words AS `owner.keywords`,
    owner_contact_category AS `owner.contactcategory`,
    owner_is_active AS `owner.isactive`,
    owner_is_creditor AS `owner.iscreditor`,
    owner_is_debtor AS `owner.isdebtor`,
    owner_is_grower AS `owner.isgrower`,
    owner_is_carrier AS `owner.iscarrier`,
    owner_is_mail_order AS `owner.ismailorder`,
    owner_is_employee AS `owner.isemployee`,
    owner_is_related_party AS `owner.isrelatedparty`,
    owner_is_grower_operator AS `owner.isgroweroperator`,
    owner_is_sales_operator AS `owner.issalesoperator`,
    owner_is_production_operator AS `owner.isproductionoperator`,
    owner_is_wine_tax_liable AS `owner.iswinetaxliable`,
    owner_credit_account_number AS `owner.creditaccountnumber`,
    owner_bank_account_number AS `owner.bankaccountnumber`,
    owner_bank_account_name AS `owner.bankaccountname`,
    owner_default_division_num_for_sales_orders AS `owner.defaultdivisionnumforsalesorders`,
    owner_default_division_num_for_purchase_orders AS `owner.defaultdivisionnumforpurchaseorders`,
    owner_default_stock_location_code AS `owner.defaultstocklocationcode`,
    owner_default_sales_person_num AS `owner.defaultsalespersonnum`,
    owner_default_sales_person_code AS `owner.defaultsalespersoncode`,
    owner_is_wine_tax_own_use AS `owner.iswinetaxownuse`,
    owner_tax_number AS `owner.taxnumber`,
    owner_default_payment_term_entry_num AS `owner.defaultpaymenttermentrynum`,
    owner_default_currency_num AS `owner.defaultcurrencynum`,
    owner_revenue_ledger_code AS `owner.revenueledgercode`,
    owner_default_bill_to_contact_num AS `owner.defaultbilltocontactnum`,
    owner_datemodified AS `owner.datemodified`,
    owner_default_sales_tax_rate_num AS `owner.defaultsalestaxratenum`,
    owner_expense_ledger_code AS `owner.expenseledgercode`,
    owner_physical_delivery_instructions AS `owner.physicaldeliveryinstructions`,
    owner_lead_time_hours AS `owner.leadtimehours`,
    owner_default_sales_order_template AS `owner.defaultsalesordertemplate`,
    owner_date_created AS `owner.datecreated`,
    owner_default_carrier_contact_num AS `owner.defaultcarriercontactnum`,
    owner_owned_stock_locations AS `owner.ownedstocklocations`,
    owner_is_wet_liable AS `owner.iswetliable`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stocklocations;

-- StockTransfers View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stocktransfers;
CREATE VIEW {etani_client_id}_vinsight_stocktransfers AS
SELECT
    id AS `$id`,
    transfer_num AS `transfernum`,
    date,
    transfer_type AS `transfertype`,
    source_stock_location_code AS `sourcestocklocationcode`,
    destination_stock_location_code AS `destinationstocklocationcode`,
    operator_code AS `operatorcode`,
    is_updated AS `isupdated`,
    comments,
    destination_location AS `destinationlocation`,
    source_location AS `sourcelocation`,
    entries,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stocktransfers;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- StockTransferEntries View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stocktransferentries;
CREATE VIEW {etani_client_id}_vinsight_stocktransferentries AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    stock_transfer_num AS `stocktransfernum`,
    stock_item_num AS `stockitemnum`,
    quantity,
    unit_of_measure_code AS `unitofmeasurecode`,
    units_in_stock_initially_at_location AS `unitsinstockinitiallyatlocation`,
    units_in_stock_finally_at_location AS `unitsinstockfinallyatlocation`,
    units_in_stock_initially_at_all_locations AS `unitsinstockinitiallyatalllocations`,
    units_in_stock_finally_at_all_locations AS `unitsinstockfinallyatalllocations`,
    units_in_stock_unit_of_measure AS `unitsinstockunitofmeasure`,
    cost_method AS `costmethod`,
    cost_per_unit AS `costperunit`,
    cost_total AS `costtotal`,
    stock_location_code AS `stocklocationcode`,
    source_or_destination AS `sourceordestination`,
    sort,
    source_entry_num AS `sourceentrynum`,
    stock_transfer_pair_entry_num AS `stocktransferpairentrynum`,
    is_updated AS `isupdated`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stocktransferentries;

-- StoredObjects View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_storedobjects;
CREATE VIEW {etani_client_id}_vinsight_storedobjects AS
SELECT
    id AS `$id`,
    `key`,
    serialized_object AS `serializedobject`,
    format,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_storedobjects;

-- Translation View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_translation;
CREATE VIEW {etani_client_id}_vinsight_translation AS
SELECT
    ref_id AS `$id`,
    id,
    `key`,
    language,
    locale,
    variant,
    value,
    date_modified AS `datemodified`,
    translation_key AS `translationkey`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_translation;

-- UnitsOfMeasure View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_unitsofmeasure;
CREATE VIEW {etani_client_id}_vinsight_unitsofmeasure AS
SELECT
    id AS `$id`,
    code,
    conversion_rate AS `conversionrate`,
    date_modified AS `datemodified`,
    length,
    width,
    height,
    weight,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_unitsofmeasure;

-- Users View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_users;
CREATE VIEW {etani_client_id}_vinsight_users AS
SELECT
    ref_id AS `$id`,
    application_id AS `applicationid`,
    id,
    user_name AS `username`,
    lowered_user_name AS `loweredusername`,
    mobile_alias AS `mobilealias`,
    is_anonymous AS `isanonymous`,
    last_activity_date AS `lastactivitydate`,
    first_name AS `firstname`,
    last_name AS `lastname`,
    is_api_user AS `isapiuser`,
    date_modified AS `datemodified`,
    is_partner_user AS `ispartneruser`,
    application,
    api_key AS `apikey`,
    api_user_created_by_user AS `apiusercreatedbyuser`,
    api_key_expiry_date AS `apikeyexpirydate`,
    api_key_auto_extend_expiry_date AS `apikeyautoextendexpirydate`,
    api_key_date_last_used AS `apikeydatelastused`,
    api_key_connection_id AS `apikeyconnectionid`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_users;

-- Varieties View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_varieties;
CREATE VIEW {etani_client_id}_vinsight_varieties AS
SELECT
    id AS `$id`,
    code,
    description,
    wine_type AS `winetype`,
    stock_item_num AS `stockitemnum`,
    stock_item AS `stockitem`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_varieties;

-- AnalysisCodes View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_analysiscodes;
CREATE VIEW {etani_client_id}_vinsight_analysiscodes AS
SELECT
    id AS `$id`,
    name,
    db_column_name AS `dbcolumnname`,
    required,
    type_name AS `typename`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_analysiscodes;

-- WineryOperationVarianceCodes View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_wineryoperationvariancecodes;
CREATE VIEW {etani_client_id}_vinsight_wineryoperationvariancecodes AS
SELECT
    id AS `$id`,
    code,
    description,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_wineryoperationvariancecodes;

-- Wines View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_wines;
CREATE VIEW {etani_client_id}_vinsight_wines AS
SELECT
    id AS `$id`,
    code,
    description,
    asset_ledger_code AS `assetledgercode`,
    stock_item_num AS `stockitemnum`,
    stock_item AS `stockitem`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_wines;

-- WineStatuses View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_winestatuses;
CREATE VIEW {etani_client_id}_vinsight_winestatuses AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    wine_type_code AS `winetypecode`,
    status_code AS `statuscode`,
    colour_code AS `colourcode`,
    wine_type AS `winetype`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_winestatuses;

-- Pattern: {etani_client_id}_vinsight_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- StockGroups View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_stockgroups;
CREATE VIEW {etani_client_id}_vinsight_stockgroups AS
SELECT
    id AS `$id`,
    code,
    description,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_stockgroups;

-- AnalysisSetEntry View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_analysissetentry;
CREATE VIEW {etani_client_id}_vinsight_analysissetentry AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    analysis_set_num AS `analysissetnum`,
    column_name AS `columnname`,
    property_name AS `propertyname`,
    type_name AS `typename`,
    sort_order AS `sortorder`,
    decimal_places AS `decimalplaces`,
    title,
    show_previous_value AS `showpreviousvalue`,
    filter,
    show_on_graph AS `showongraph`,
    y_axis_index AS `yaxisindex`,
    analysis_set AS `analysisset`,
    sync_token AS `synctoken`,
    meta_data_create_time AS `metadata_createtime`,
    meta_data_last_updated_time AS `metadata_lastupdatedtime`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_analysissetentry;

-- Categories View
DROP VIEW IF EXISTS {etani_client_id}_vinsight_categories;
CREATE VIEW {etani_client_id}_vinsight_categories AS
SELECT
    id AS `$id`,
    entry_num AS `entrynum`,
    entity_type AS `entitytype`,
    code,
    description,
    `values`,
    value_type AS `valuetype`,
    save_values AS `savevalues`,
    can_multi_apply AS `canmultiapply`,
    is_multi_value AS `ismultivalue`,
    ClientID,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_vinsight_categories;