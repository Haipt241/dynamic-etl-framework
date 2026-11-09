-- VINSIGHT Stage Tables - Auto Generated
-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- AuditLogEntry Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_auditlogentrystage;
CREATE TABLE c{clientID}_{orgID}_vinsight_auditlogentrystage (
    json_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    related_id VARCHAR(255),
    date DATETIME NOT NULL,
    type VARCHAR(255),
    source_type VARCHAR(255),
    source_id VARCHAR(255),
    event_type VARCHAR(255),
    user_name VARCHAR(255),
    requested_via VARCHAR(255),
    remote_ip VARCHAR(255),
    description TEXT,
    data_format VARCHAR(255),
    user_id VARCHAR(255),
    organisation_id VARCHAR(255),
    alternate_key VARCHAR(255),
    child_entries JSON,
    parent_entry JSON,
    user JSON,
    data_json_id VARCHAR(255),
    datasalesordernum INT,
    data_date_modified_from DATETIME,
    data_date_modified_to DATETIME,
    user_email VARCHAR(255),
    organisation_name VARCHAR(255),
    organisation_id_nested VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Components Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_componentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_componentsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT NOT NULL,
    code VARCHAR(255) NOT NULL,
    component_group_num INT NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL,
    asset_ledger_code VARCHAR(255),
    allocation_entries JSON,
    `group` JSON,
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ContactActivity Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_contactactivitystage;
CREATE TABLE c{clientID}_{orgID}_vinsight_contactactivitystage (
    id VARCHAR(255) NOT NULL,
    activity_date DATETIME,
    attendees TEXT,
    categories TEXT,
    comments TEXT,
    contact_contact_code VARCHAR(255),
    contact_email VARCHAR(255),
    contact_name VARCHAR(255),
    contact_num INT,
    description TEXT,
    duration VARCHAR(255),
    organiser VARCHAR(255),
    organiser_contact_num INT,
    gps VARCHAR(255),
    address TEXT,
    status VARCHAR(255),
    type_entry_num INT,
    type_code VARCHAR(255),
    type_description VARCHAR(255),
    type_icon VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AuditLogChildEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_auditlogchildentriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_auditlogchildentriesstage (
    parent_audit_log_id VARCHAR(255) NOT NULL,
    id VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    description TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (parent_audit_log_id, id)
);

-- ComponentsAllocationEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_componentsallocationentriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_componentsallocationentriesstage (
    component_id VARCHAR(255) NOT NULL,
    entry_num INT NOT NULL,
    allocation_percent DECIMAL(5,2),
    description VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (component_id, entry_num)
);

-- ContactCategories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_contactcategoriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_contactcategoriesstage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description VARCHAR(500),
    `values` VARCHAR(500),
    value_type VARCHAR(100),
    save_values BOOLEAN,
    entry_num INT,
    can_multi_apply BOOLEAN,
    is_multi_value BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Contacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_contactsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_contactsstage (
    id VARCHAR(255) NOT NULL,
    contact_num INT,
    type VARCHAR(255),
    contact_code VARCHAR(255),
    legal_name VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    title VARCHAR(255),
    phone VARCHAR(255),
    fax VARCHAR(255),
    mobile VARCHAR(255),
    email VARCHAR(255),
    comments TEXT,
    physical_use_postal_address BOOLEAN,
    physical_address1 VARCHAR(255),
    physical_address2 VARCHAR(255),
    physical_city VARCHAR(255),
    physical_region VARCHAR(255),
    physical_post_code VARCHAR(255),
    physical_country VARCHAR(255),
    postal_use_physical_address BOOLEAN,
    postal_address VARCHAR(255),
    postal_address2 VARCHAR(255),
    postal_city VARCHAR(255),
    postal_region VARCHAR(255),
    postal_code VARCHAR(255),
    postal_country VARCHAR(255),
    key_words VARCHAR(255),
    contact_category VARCHAR(255),
    is_active BOOLEAN,
    is_creditor BOOLEAN,
    is_debtor BOOLEAN,
    is_grower BOOLEAN,
    is_carrier BOOLEAN,
    is_mail_order BOOLEAN,
    is_employee BOOLEAN,
    is_related_party BOOLEAN,
    is_grower_operator BOOLEAN,
    is_sales_operator BOOLEAN,
    is_production_operator BOOLEAN,
    is_wine_tax_liable BOOLEAN,
    credit_account_number VARCHAR(255),
    bank_account_number VARCHAR(255),
    bank_account_name VARCHAR(255),
    default_division_num_for_sales_orders INT,
    default_division_num_for_purchase_orders INT,
    default_stock_location_code VARCHAR(255),
    default_sales_person_num INT,
    default_sales_person_code VARCHAR(255),
    is_wine_tax_own_use BOOLEAN,
    tax_number VARCHAR(255),
    default_payment_term_entry_num INT,
    default_currency_num INT,
    revenue_ledger_code VARCHAR(255),
    default_bill_to_contact_num INT,
    date_modified DATETIME,
    default_sales_tax_rate_num INT,
    expense_ledger_code VARCHAR(255),
    physical_delivery_instructions TEXT,
    lead_time_hours INT,
    default_sales_order_template VARCHAR(255),
    date_created DATETIME,
    default_carrier_contact_num INT,
    default_payment_term VARCHAR(255),
    default_currency VARCHAR(255),
    contact_activities VARCHAR(255),
    default_sales_person_opr VARCHAR(255),
    default_sales_person VARCHAR(255),
    default_stock_location VARCHAR(255),
    default_bill_to_contact VARCHAR(255),
    default_sales_tax_rate VARCHAR(255),
    default_carrier_contact VARCHAR(255),
    lead_time VARCHAR(255),
    is_wet_liable BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Currencies Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currenciesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currenciesstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    currency_code VARCHAR(255),
    description VARCHAR(255),
    major_unit_symbol VARCHAR(255),
    major_unit_description VARCHAR(255),
    minor_unit_symbol VARCHAR(255),
    minor_unit_description VARCHAR(255),
    date_modified DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Dashboard Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_dashboardstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_dashboardstage (
    id VARCHAR(255) NOT NULL,
    `key` VARCHAR(255) NOT NULL,
    serialized_object TEXT,
    format VARCHAR(50),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- CurrencySalesOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencysalesordersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencysalesordersstage (
    currency_entry_num INT NOT NULL,
    sales_order_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, sales_order_id)
);


-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- CurrencySalesOrderItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencysalesorderitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencysalesorderitemsstage (
    currency_entry_num INT NOT NULL,
    sales_order_item_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, sales_order_item_id)
);

-- CurrencyTaxTypes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencytaxtypesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencytaxtypesstage (
    currency_entry_num INT NOT NULL,
    tax_type_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, tax_type_id)
);

-- CurrencyStockItemPrices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencystockitempricesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencystockitempricesstage (
    currency_entry_num INT NOT NULL,
    stock_item_price_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, stock_item_price_id)
);

-- CurrencyPurchaseOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencypurchaseordersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencypurchaseordersstage (
    currency_entry_num INT NOT NULL,
    purchase_order_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, purchase_order_id)
);

-- CurrencyDeals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencydealsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencydealsstage (
    currency_entry_num INT NOT NULL,
    deal_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, deal_id)
);

-- CurrencyPurchaseOrderItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencypurchaseorderitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencypurchaseorderitemsstage (
    currency_entry_num INT NOT NULL,
    purchase_order_item_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, purchase_order_item_id)
);

-- CurrencyContacts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencycontactsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencycontactsstage (
    currency_entry_num INT NOT NULL,
    contact_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, contact_id)
);

-- CurrencyDivisions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencydivisionsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencydivisionsstage (
    currency_entry_num INT NOT NULL,
    division_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, division_id)
);

-- CurrencyCdrs Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencycdrsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencycdrsstage (
    currency_entry_num INT NOT NULL,
    cdr_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, cdr_id)
);

-- CurrencyDtrPyts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencydtrpytsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencydtrpytsstage (
    currency_entry_num INT NOT NULL,
    dtr_pyt_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, dtr_pyt_id)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- CurrencyGenJorEnts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencygenjorentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencygenjorentsstage (
    currency_entry_num INT NOT NULL,
    gen_jor_ent_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, gen_jor_ent_id)
);

-- CurrencyStkItmPrcLists Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_currencystkitmprclistsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_currencystkitmprclistsstage (
    currency_entry_num INT NOT NULL,
    stk_itm_prc_list_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (currency_entry_num, stk_itm_prc_list_id)
);

-- Divisions Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    division_code VARCHAR(255),
    description VARCHAR(500),
    company_name VARCHAR(255),
    legal_name VARCHAR(255),
    physical_address1 VARCHAR(500),
    physical_address2 VARCHAR(500),
    physical_city VARCHAR(255),
    physical_region VARCHAR(255),
    physical_post_code VARCHAR(50),
    physical_country VARCHAR(255),
    postal_address VARCHAR(500),
    postal_address2 VARCHAR(500),
    postal_city VARCHAR(255),
    postal_region VARCHAR(255),
    postal_code VARCHAR(50),
    postal_country VARCHAR(255),
    phone VARCHAR(255),
    fax VARCHAR(255),
    email VARCHAR(255),
    tax_number VARCHAR(255),
    company_image_path VARCHAR(1000),
    logo_dimensions VARCHAR(255),
    logo_contains_name BOOLEAN,
    excise_rate1 DECIMAL(18,2),
    excise_rate2 DECIMAL(18,2),
    excise_rate3 DECIMAL(18,2),
    sales_tax_rate DECIMAL(18,2),
    culture VARCHAR(255),
    logo_image_content_type VARCHAR(255),
    bank_account_name VARCHAR(255),
    bank_account_number VARCHAR(255),
    remittance_instructions TEXT,
    weight_unit_of_measure_code VARCHAR(255),
    volume_unit_of_measure_code VARCHAR(255),
    length_unit_of_measure_code VARCHAR(255),
    invoice_footer TEXT,
    invoice_header TEXT,
    invoice_division_address TEXT,
    default_currency_num INT,
    cost_method VARCHAR(255),
    first_sales_tax_period DATETIME,
    sales_tax_period VARCHAR(255),
    balance_date DATETIME,
    footer_image_content_type VARCHAR(255),
    company_contact_num INT,
    timezone VARCHAR(255),
    shipment_length_unit_of_measure_code VARCHAR(255),
    shipment_weight_unit_of_measure_code VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- DivisionSalesOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionsalesordersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionsalesordersstage (
    division_entry_num INT NOT NULL,
    sales_order_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, sales_order_id)
);

-- DivisionDeals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisiondealsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisiondealsstage (
    division_entry_num INT NOT NULL,
    deal_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, deal_id)
);

-- DivisionPurchaseOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionpurchaseordersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionpurchaseordersstage (
    division_entry_num INT NOT NULL,
    purchase_order_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, purchase_order_id)
);

-- DivisionAssessments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionassessmentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionassessmentsstage (
    division_entry_num INT NOT NULL,
    assessment_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, assessment_id)
);

-- DivisionStockItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionstockitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionstockitemsstage (
    division_entry_num INT NOT NULL,
    stock_item_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, stock_item_id)
);

-- DivisionJournals Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_divisionjournalsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_divisionjournalsstage (
    division_entry_num INT NOT NULL,
    journal_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (division_entry_num, journal_id)
);

-- Documents Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_documentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_documentsstage (
    categories VARCHAR(500),
    url TEXT,
    content TEXT,
    id VARCHAR(255) NOT NULL,
    date_created DATETIME,
    date_modified DATETIME,
    is_active BOOLEAN,
    name TEXT,
    display_name TEXT,
    mime_type VARCHAR(255),
    entry_type VARCHAR(255),
    content_encoding VARCHAR(255),
    md5_hash VARCHAR(255),
    size_bytes INT,
    owner_id VARCHAR(255),
    owner_display_name VARCHAR(255),
    owner_type VARCHAR(255),
    html_link_snippet TEXT,
    attachments_count INT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- DuePayments Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_duepaymentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_duepaymentsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    due_date DATETIME,
    amount DECIMAL(18,2),
    description VARCHAR(255),
    payment_term_entry_num INT,
    source_num INT,
    source_type VARCHAR(50),
    date_modified DATETIME,
    payment_term VARCHAR(100),
    sales_order VARCHAR(100),
    purchase_order VARCHAR(100),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ExpressionDefinition Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_expressiondefinitionstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_expressiondefinitionstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    code VARCHAR(255),
    description VARCHAR(255),
    expression TEXT,
    expression_language VARCHAR(50),
    argument_types VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- LedgerAccounts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_ledgeraccountsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_ledgeraccountsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    code VARCHAR(255),
    description VARCHAR(500),
    ledger_account_type_num INT,
    is_inventory_ledger BOOLEAN,
    is_debtor_ledger BOOLEAN,
    is_creditor_ledger BOOLEAN,
    is_cash_flow_ledger BOOLEAN,
    is_bank_account BOOLEAN,
    is_active BOOLEAN,
    comment TEXT,
    ledger_account_type_id VARCHAR(255),
    ledger_account_type_entry_num BIGINT,
    ledger_account_type_code VARCHAR(255),
    ledger_account_type_ref VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PaymentTerms Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_paymenttermsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_paymenttermsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT NOT NULL,
    code VARCHAR(255),
    description VARCHAR(500),
    percentage DECIMAL(10,2),
    expression_entry_num INT,
    parent_entry_num INT,
    expression_argument VARCHAR(255),
    date_modified DATETIME,
    expression_definition_entry_num BIGINT,
    expression_definition_code VARCHAR(80),
    expression_definition_description VARCHAR(104),
    expression_definition_expression VARCHAR(172),
    expression_definition_expression_language VARCHAR(40),
    expression_definition_argument_types VARCHAR(16),
    expression_definition_payment_terms VARCHAR(128),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductCategory Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_productcategorystage;
CREATE TABLE c{clientID}_{orgID}_vinsight_productcategorystage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    code VARCHAR(255),
    description TEXT,
    `values` TEXT,
    value_type VARCHAR(255),
    save_values BOOLEAN,
    can_multi_apply BOOLEAN,
    is_multi_value BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AuditLogEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_auditlogentriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_auditlogentriesstage (
    api_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    related_id VARCHAR(255),
    date DATETIME NOT NULL,
    type VARCHAR(255),
    source_type VARCHAR(255),
    source_id VARCHAR(255),
    event_type VARCHAR(255),
    user_name VARCHAR(255),
    requested_via VARCHAR(255),
    remote_ip VARCHAR(255),
    description TEXT,
    `data` JSON,
    data_format VARCHAR(255),
    user_id VARCHAR(255),
    organisation_id VARCHAR(255),
    alternate_key VARCHAR(255),
    parent_entry_id VARCHAR(255),
    parent_entry_date DATETIME,
    parent_entry_type VARCHAR(255),
    user_user_name VARCHAR(255),
    user_first_name VARCHAR(255),
    user_last_name VARCHAR(255),
    organisation_name VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ProductDetail Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_productdetailstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_productdetailstage (
    id VARCHAR(255) NOT NULL,
    `key` VARCHAR(255),
    serialized_object TEXT,
    format VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderitemsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    description TEXT,
    quantity DECIMAL(18,2),
    unit_of_measure_code VARCHAR(50),
    unit_price DECIMAL(18,4),
    discount DECIMAL(18,4),
    sales_tax_rate_value DECIMAL(18,4),
    sales_tax_rate_num INT,
    price_entry_num INT,
    discount_entry_num INT,
    price_description TEXT,
    discount_description TEXT,
    order_num INT,
    currency_num INT,
    stock_item_num INT,
    suppliers_code VARCHAR(255),
    total_cost DECIMAL(18,4),
    analysis_certificate TEXT,
    lot_code VARCHAR(255),
    date_first_used DATETIME,
    date_last_used DATETIME,
    allocation_type VARCHAR(255),
    allocation_id VARCHAR(255),
    allocation_num INT,
    expiry_date DATETIME,
    quantity_available DECIMAL(18,2),
    sort INT,
    discount_numeric DECIMAL(18,4),
    currency TEXT,
    `order` TEXT,
    stock_item TEXT,
    sales_tax_rate TEXT,
    unit_of_measure TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderReceiptItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderreceiptitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderreceiptitemsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    receipt_num INT,
    stock_item_num INT,
    quantity DECIMAL(18,2),
    unit_of_measure_code VARCHAR(255),
    units_in_stock_initially_at_location DECIMAL(18,2),
    units_in_stock_finally_at_location DECIMAL(18,2),
    units_in_stock_initially_at_all_locations DECIMAL(18,2),
    units_in_stock_finally_at_all_locations DECIMAL(18,2),
    units_in_stock_unit_of_measure VARCHAR(100),
    cost_method VARCHAR(100),
    cost_per_unit DECIMAL(18,6),
    cost_total DECIMAL(18,2),
    analysis_certificate VARCHAR(100),
    lot_code VARCHAR(100),
    date_first_used DATETIME,
    date_last_used DATETIME,
    supplier_code VARCHAR(100),
    sort VARCHAR(100),
    receipt VARCHAR(100),
    stock_item VARCHAR(100),
    unit_of_measure VARCHAR(100),
    warnings VARCHAR(100),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- PurchaseOrderReceipts Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderreceiptsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderreceiptsstage (
    id VARCHAR(255) NOT NULL,
    receipt_num INT,
    date_delivered DATETIME,
    order_num INT,
    is_updated BOOLEAN,
    is_final_delivery BOOLEAN,
    stock_location_code VARCHAR(255),
    is_active BOOLEAN,
    delivery_instructions TEXT,
    date_modified DATETIME,
    `order` TEXT,
    stock_location TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- PurchaseOrderReceiptEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderreceiptentriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderreceiptentriesstage (
    purchase_order_receipts_id VARCHAR(255) NOT NULL,
    purchase_order_receipts_organisation_id VARCHAR(255) NOT NULL,
    entry_num INT,
    quantity DECIMAL(18,2),
    description TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (purchase_order_receipts_id, purchase_order_receipts_organisation_id)
);

-- PurchaseOrderReceiptAliases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderreceiptaliasesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderreceiptaliasesstage (
    purchase_order_receipts_id VARCHAR(255) NOT NULL,
    purchase_order_receipts_organisation_id VARCHAR(255) NOT NULL,
    alias_name VARCHAR(255),
    alias_type VARCHAR(100),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (purchase_order_receipts_id, purchase_order_receipts_organisation_id)
);

-- PurchaseOrder Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_purchaseorderstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_purchaseorderstage (
    id VARCHAR(255) NOT NULL,
    order_num INT,
    order_reference VARCHAR(255),
    delivery_address TEXT,
    delivery_instructions TEXT,
    ordered_with VARCHAR(255),
    sub_total_amount DECIMAL(18,2),
    comments TEXT,
    currency_num INT,
    payment_term_description VARCHAR(500),
    transaction_reference VARCHAR(255),
    is_posted BOOLEAN,
    stock_location_code VARCHAR(255),
    status VARCHAR(100),
    payment_term_entry_num INT,
    operator_num INT,
    total_excluding_taxes DECIMAL(18,2),
    billing_contact_num INT,
    date_modified DATETIME,
    categories TEXT,
    date_created DATETIME,
    invoice_accounting_status VARCHAR(255),
    division_num INT,
    date_delivered DATETIME,
    contact_num INT,
    ordered_by_operator_code VARCHAR(255),
    order_date DATETIME,
    date_required DATETIME,
    date_paid DATETIME,
    date_payment_due DATETIME,
    is_active BOOLEAN,
    total_including_taxes DECIMAL(18,2),
    currency_rate DECIMAL(18,6),
    contact_contact_num BIGINT,
    contact_type VARCHAR(255),
    contact_contact_code VARCHAR(255),
    contact_legal_name VARCHAR(255),
    contact_first_name VARCHAR(255),
    contact_last_name VARCHAR(255),
    contact_title VARCHAR(255),
    contact_phone VARCHAR(255),
    contact_fax VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Region Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_regionstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_regionstage (
    id VARCHAR(255) NOT NULL,
    region_code VARCHAR(255),
    description TEXT,
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ResourceCollections Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_resourcecollectionsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_resourcecollectionsstage (
    ref_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    parent_collection_id VARCHAR(255),
    date_modified DATETIME,
    parent_collection TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Addons Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_addonsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_addonsstage (
    api_id VARCHAR(255),
    open_api_specification_file VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    short_name VARCHAR(255),
    author VARCHAR(255),
    image_url VARCHAR(500),
    description TEXT,
    link_description VARCHAR(255),
    web_address VARCHAR(500),
    tags TEXT,
    position INT,
    integrations TEXT,
    disconnect_link VARCHAR(500),
    max_integrations INT,
    for_countries TEXT,
    is_permanent BOOLEAN,
    is_in_session_only BOOLEAN,
    is_active BOOLEAN,
    is_invite_only BOOLEAN,
    is_plugin BOOLEAN,
    billing_category VARCHAR(255),
    per_integration_billing_max_paid INT,
    listens_to_webhooks BOOLEAN,
    api_rate_limit_calls_per_second DECIMAL(10,2),
    o_auth_flow VARCHAR(255),
    security_scheme VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Roles Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_rolesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_rolesstage (
    ref_id VARCHAR(255),
    application_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    lowered_name VARCHAR(255),
    description TEXT,
    is_read_only BOOLEAN,
    date_modified DATETIME,
    organisation_id VARCHAR(255),
    is_admin BOOLEAN,
    application TEXT,
    is_two_factor_required BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrderDespatches Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_salesorderdespatchesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_salesorderdespatchesstage (
    id VARCHAR(255) NOT NULL,
    despatch_num INT,
    order_num INT,
    date_despatched DATETIME,
    is_updated BOOLEAN,
    is_final_despatch BOOLEAN,
    date_updated DATETIME,
    carrier_code VARCHAR(255),
    reference VARCHAR(255),
    comments TEXT,
    delivery_name VARCHAR(255),
    delivery_address TEXT,
    delivery_suburb VARCHAR(255),
    delivery_city VARCHAR(255),
    delivery_region VARCHAR(255),
    delivery_post_code VARCHAR(20),
    delivery_country VARCHAR(255),
    delivery_email VARCHAR(255),
    delivery_phone VARCHAR(50),
    delivery_instructions TEXT,
    stock_location_code VARCHAR(50),
    is_active BOOLEAN,
    carrier_contact_num VARCHAR(50),
    date_modified DATETIME,
    location_notified VARCHAR(255),
    carrier_notified VARCHAR(255),
    location_status VARCHAR(255),
    carrier_status VARCHAR(255),
    categories TEXT,
    `order` TEXT,
    stock_location TEXT,
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrderDespatchItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_salesorderdespatchitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_salesorderdespatchitemsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    despatch_num INT,
    stock_item_num INT,
    quantity DECIMAL(18,2),
    unit_of_measure_code VARCHAR(255),
    units_in_stock_initially_at_location DECIMAL(18,2),
    units_in_stock_finally_at_location DECIMAL(18,2),
    units_in_stock_initially_at_all_locations DECIMAL(18,2),
    units_in_stock_finally_at_all_locations DECIMAL(18,2),
    units_in_stock_unit_of_measure VARCHAR(100),
    cost_method VARCHAR(100),
    cost_per_unit DECIMAL(18,4),
    cost_total DECIMAL(18,4),
    quantity_required DECIMAL(18,2),
    quantity_back_ordered DECIMAL(18,2),
    lot_code VARCHAR(100),
    description VARCHAR(100),
    sort INT,
    parent_entry_num VARCHAR(100),
    date_modified DATETIME,
    despatch TEXT,
    stock_item TEXT,
    unit_of_measure TEXT,
    parent TEXT,
    warnings TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- SalesOrderItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_salesorderitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_salesorderitemsstage (
    entry_num INT NOT NULL,
    description TEXT,
    quantity DECIMAL(18,4),
    unit_of_measure_code VARCHAR(255),
    unit_price DECIMAL(18,4),
    discount DECIMAL(18,4),
    sales_tax_rate_value DECIMAL(18,4),
    sales_tax_rate_num INT,
    is_wine_tax_liable BOOLEAN,
    wine_tax_rate_value DECIMAL(18,4),
    wine_tax_rate_num INT,
    price_description VARCHAR(255),
    discount_description VARCHAR(255),
    order_num INT,
    currency_num INT,
    stock_item_num INT,
    price_entry_num INT,
    discount_entry_num INT,
    stock_location_code VARCHAR(255),
    sort INT,
    allocation_type VARCHAR(255),
    allocation_id VARCHAR(255),
    allocation_num INT,
    discount_numeric DECIMAL(18,4),
    source_entry_num INT,
    order_salesordernum INT,
    order_delivery_name TEXT,
    order_delivery_address TEXT,
    order_delivery_suburb TEXT,
    order_delivery_city TEXT,
    order_delivery_region TEXT,
    order_delivery_post_code TEXT,
    order_delivery_country TEXT,
    order_delivery_email TEXT,
    order_delivery_phone TEXT,
    order_delivery_instructions TEXT,
    order_comments TEXT,
    order_order_reference TEXT,
    order_order_date DATETIME,
    order_invoice_date DATETIME,
    order_date_required TEXT,
    order_date_despatched DATETIME,
    order_date_payment_due DATETIME,
    order_payment_term_description TEXT,
    order_date_paid DATETIME,
    order_carrier_code TEXT,
    order_sub_total_amount TEXT,
    order_freight_amount TEXT,
    order_is_posted BOOLEAN,
    order_transaction_reference TEXT,
    order_is_wine_tax_liable BOOLEAN,
    order_contact_num INT,
    order_division_num INT,
    order_sales_person_code TEXT,
    order_currency_num INT,
    order_stock_location_code TEXT,
    order_status TEXT,
    order_payment_term_entry_num INT,
    order_is_non_arms_length BOOLEAN,
    order_sales_person_num INT,
    order_carrier_contact_num INT,
    order_currency_rate DECIMAL(18,4),
    order_invoice_sent_status TEXT,
    order_invoice_paid_status TEXT,
    order_order_delivery_status TEXT,
    order_order_movement_status TEXT,
    order_tracking_uri TEXT,
    order_total_including_taxes DECIMAL(18,4),
    order_total_excluding_taxes DECIMAL(18,4),
    order_billing_contact_num TEXT,
    order_is_active BOOLEAN,
    order_datemodified DATETIME,
    order_categories TEXT,
    order_validation_error TEXT,
    order_datecreated DATETIME,
    order_contact TEXT,
    order_currency TEXT,
    order_items TEXT,
    order_sales_person_opr TEXT,
    order_stock_location TEXT,
    order_payment_term TEXT,
    order_sales_person TEXT,
    order_carrier_contact TEXT,
    order_billing_contact TEXT,
    order_$ref TEXT,
    order_division TEXT,
    currency TEXT,
    stock_item TEXT,
    sales_tax_rate TEXT,
    wine_tax_rate TEXT,
    unit_of_measure TEXT,
    price_list_entry TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (entry_num)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- SalesOrders Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_salesordersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_salesordersstage (
    salesordernum INT NOT NULL,
    division_num INT,
    contact_num INT,
    contact_contact_code TEXT,
    contact_default_sales_order_template TEXT,
    contact_$ref TEXT,
    division_division_code TEXT,
    division_$ref TEXT,
    invoice_date DATETIME,
    date_paid DATETIME,
    date_payment_due DATETIME,
    order_reference VARCHAR(255),
    total_including_taxes DECIMAL(18,2),
    currency_currency_code TEXT,
    currency_major_unit_symbol TEXT,
    currency_$ref TEXT,
    currency_rate DECIMAL(18,6),
    date_despatched DATETIME,
    status VARCHAR(255),
    is_active BOOLEAN,
    categories TEXT,
    stock_location_code VARCHAR(255),
    invoice_sent_status VARCHAR(255),
    delivery_region VARCHAR(255),
    despatch_status VARCHAR(255),
    stock_locations_count INT,
    first_despatch_location VARCHAR(255),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (salesordernum)
);

-- StockItemComponents Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockitemcomponentsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockitemcomponentsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    stock_item_num INT,
    component_stock_item_num INT,
    quantity DECIMAL(10,2),
    unit_of_measure_code VARCHAR(255),
    entity_type VARCHAR(255),
    entity_id VARCHAR(255),
    is_quantity_total BOOLEAN,
    entity_num VARCHAR(255),
    rate_type VARCHAR(255),
    stock_item VARCHAR(255),
    component_stock_item VARCHAR(255),
    stock_item_unit_of_measure VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockItemLocations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockitemlocationsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockitemlocationsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    stock_item_num INT,
    stock_location_code VARCHAR(255),
    units_in_stock DECIMAL(18,4),
    unit_of_measure_code VARCHAR(255),
    total_cost DECIMAL(18,4),
    latest_cost DECIMAL(18,4),
    standard_cost DECIMAL(18,4),
    re_ord_lvl DECIMAL(18,4),
    stock_item TEXT,
    stock_location TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockItemMovements Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockitemmovementsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockitemmovementsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    operation_type VARCHAR(255),
    operation_id INT,
    source_operation_type VARCHAR(255),
    source_operation_id INT,
    transaction_description VARCHAR(500),
    date_processed DATETIME,
    date_as_at DATETIME,
    entity_type VARCHAR(255),
    entity_id INT,
    stock_item_num INT,
    stock_location_code VARCHAR(255),
    quantity DECIMAL(18,2),
    unit_of_measure_code VARCHAR(255),
    units_in_stock_initially_at_location DECIMAL(18,2),
    units_in_stock_finally_at_location DECIMAL(18,2),
    units_in_stock_initially_at_all_locations DECIMAL(18,2),
    units_in_stock_finally_at_all_locations DECIMAL(18,2),
    units_in_stock_units_of_measure_code VARCHAR(255),
    cost_method VARCHAR(255),
    cost_per_unit DECIMAL(18,2),
    cost_total DECIMAL(18,2),
    standard_cost_initial DECIMAL(18,2),
    standard_cost_final DECIMAL(18,2),
    total_cost_variance DECIMAL(18,2),
    stock_item TEXT,
    unit_of_measure TEXT,
    units_in_stock_unit_of_measure TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockItemPrices Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockitempricesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockitempricesstage (
    entry_num INT NOT NULL,
    unit_of_measure_code VARCHAR(255),
    price_description VARCHAR(255),
    price DECIMAL(18,2),
    discount DECIMAL(18,2),
    discount_numeric DECIMAL(18,2),
    is_default_price BOOLEAN,
    order_type VARCHAR(255),
    type VARCHAR(255),
    sales_tax_rate_num INT,
    currency_num INT,
    contact_num INT,
    contact_category VARCHAR(255),
    expiry_date DATETIME,
    active_date DATETIME,
    stock_item_num INT,
    product_category VARCHAR(255),
    is_purchase_price BOOLEAN,
    currency_currency_code TEXT,
    salestaxrate_code TEXT,
    stockitem_stock_item_code TEXT,
    uom_entry_num INT,
    uom_stock_item_num INT,
    uom_unit_of_measure_code TEXT,
    uom_conversion_rate DECIMAL(18,4),
    uom_length TEXT,
    uom_width TEXT,
    uom_height TEXT,
    uom_weight TEXT,
    uom_stock_item TEXT,
    uom_unit_of_measure TEXT,
    can_multi_apply BOOLEAN,
    status VARCHAR(255),
    contact TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (entry_num)
);

-- StockItems Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockitemsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockitemsstage (
    id VARCHAR(255) NOT NULL,
    stock_item_num INT NOT NULL,
    stock_item_code VARCHAR(255),
    description TEXT,
    stock_group_code VARCHAR(255),
    lot_code VARCHAR(255),
    re_order_level DECIMAL(15,4),
    comments TEXT,
    is_wine_additive BOOLEAN NOT NULL,
    is_purchase_order_item BOOLEAN NOT NULL,
    is_packaging BOOLEAN NOT NULL,
    is_bulk_wine BOOLEAN NOT NULL,
    is_sales_order_item BOOLEAN NOT NULL,
    is_packaged_wine BOOLEAN NOT NULL,
    is_stock_take_item BOOLEAN NOT NULL,
    is_grower_additive BOOLEAN NOT NULL,
    is_wine_tax_liable BOOLEAN NOT NULL,
    operation_standard_text TEXT,
    trial_stock_solution_strength DECIMAL(15,4),
    default_rate DECIMAL(15,4),
    default_rate_type VARCHAR(255),
    default_rate_uom VARCHAR(255),
    default_quantity_uom VARCHAR(255),
    default_volume_per_area DECIMAL(15,4),
    quantity_per_unit DECIMAL(15,4),
    default_stock_location_code VARCHAR(255),
    units_in_stock DECIMAL(15,4),
    units_in_stock_uom VARCHAR(255),
    standard_cost DECIMAL(15,6),
    total_cost DECIMAL(15,4),
    latest_cost DECIMAL(15,4),
    cost_method VARCHAR(255),
    base_uom VARCHAR(255),
    inner_uom VARCHAR(255),
    outer_uom VARCHAR(255),
    pallet_count INT,
    date_updated DATETIME,
    revenue_ledger_code VARCHAR(255),
    expense_ledger_code VARCHAR(255),
    asset_ledger_code VARCHAR(255),
    is_active BOOLEAN NOT NULL,
    allocation_stock_item_num INT,
    bar_code VARCHAR(255),
    allocation_status VARCHAR(255),
    sales_tax_rate_num INT,
    wine_tax_rate_num INT,
    supplier_num INT,
    previous_packaging_operation_num INT,
    pallet_spec_num INT,
    labelling_spec_num INT,
    packaging_template_stock_item_num INT,
    default_application_rate_type VARCHAR(255),
    product_categories TEXT,
    date_modified DATETIME,
    auto_build BOOLEAN NOT NULL,
    lead_time_hours INT,
    division_num INT NOT NULL,
    next_standard_cost_type VARCHAR(255),
    system_flags INT NOT NULL,
    is_system_defined BOOLEAN NOT NULL,
    system_prevents_edit BOOLEAN NOT NULL,
    system_prevents_delete BOOLEAN NOT NULL,
    kit_creation VARCHAR(255),
    kit_price_list VARCHAR(255),
    prices TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Aliases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_aliasesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_aliasesstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    entity_type VARCHAR(255),
    entity_id VARCHAR(255),
    entity_num INT,
    entity_uniqifier VARCHAR(255),
    domain VARCHAR(255),
    sub_domain VARCHAR(255),
    sub_domain_description VARCHAR(255),
    domain_entity_type VARCHAR(255),
    domain_entity_id VARCHAR(255),
    domain_entity_code VARCHAR(255),
    domain_entity_description VARCHAR(255),
    domain_entity_url VARCHAR(255),
    domain_data TEXT,
    hash VARCHAR(255),
    entity_num_small INT,
    date_modified DATETIME,
    parent_entry_num INT,
    is_active BOOLEAN,
    domain_date_modified DATETIME,
    date_cache_updated DATETIME,
    validation_error VARCHAR(255),
    contact TEXT,
    stock_item TEXT,
    sales_order TEXT,
    purchase_order TEXT,
    tax_rate TEXT,
    stock_location TEXT,
    sales_order_despatch TEXT,
    parent_alias TEXT,
    payment_term TEXT,
    stock_item_price TEXT,
    journal TEXT,
    sales_order_item TEXT,
    ledger_account TEXT,
    purchase_order_receipt TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ChildAliases Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_childaliasesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_childaliasesstage (
    id VARCHAR(255) NOT NULL,
    parent_alias_id VARCHAR(255) NOT NULL,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockLocations Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stocklocationsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stocklocationsstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    code VARCHAR(255),
    description VARCHAR(255),
    is_bonded BOOLEAN,
    owner_contact_num VARCHAR(100),
    is_active BOOLEAN,
    date_modified DATETIME,
    owner_type TEXT,
    owner_contact_code TEXT,
    owner_legal_name TEXT,
    owner_first_name TEXT,
    owner_last_name TEXT,
    owner_title TEXT,
    owner_phone TEXT,
    owner_fax TEXT,
    owner_mobile TEXT,
    owner_email TEXT,
    owner_comments TEXT,
    owner_physical_use_postal_address BOOLEAN,
    owner_physical_address1 TEXT,
    owner_physical_address2 TEXT,
    owner_physical_city TEXT,
    owner_physical_region TEXT,
    owner_physical_post_code TEXT,
    owner_physical_country TEXT,
    owner_postal_use_physical_address BOOLEAN,
    owner_postal_address TEXT,
    owner_postal_address2 TEXT,
    owner_postal_city TEXT,
    owner_postal_region TEXT,
    owner_postal_code TEXT,
    owner_postal_country TEXT,
    owner_key_words TEXT,
    owner_contact_category TEXT,
    owner_is_active BOOLEAN,
    owner_is_creditor BOOLEAN,
    owner_is_debtor BOOLEAN,
    owner_is_grower BOOLEAN,
    owner_is_carrier BOOLEAN,
    owner_is_mail_order BOOLEAN,
    owner_is_employee BOOLEAN,
    owner_is_related_party BOOLEAN,
    owner_is_grower_operator BOOLEAN,
    owner_is_sales_operator BOOLEAN,
    owner_is_production_operator BOOLEAN,
    owner_is_wine_tax_liable BOOLEAN,
    owner_credit_account_number TEXT,
    owner_bank_account_number TEXT,
    owner_bank_account_name TEXT,
    owner_default_division_num_for_sales_orders TEXT,
    owner_default_division_num_for_purchase_orders TEXT,
    owner_default_stock_location_code TEXT,
    owner_default_sales_person_num TEXT,
    owner_default_sales_person_code TEXT,
    owner_is_wine_tax_own_use BOOLEAN,
    owner_tax_number TEXT,
    owner_default_payment_term_entry_num TEXT,
    owner_default_currency_num TEXT,
    owner_revenue_ledger_code TEXT,
    owner_default_bill_to_contact_num TEXT,
    owner_datemodified DATETIME,
    owner_default_sales_tax_rate_num TEXT,
    owner_expense_ledger_code TEXT,
    owner_physical_delivery_instructions TEXT,
    owner_lead_time_hours TEXT,
    owner_default_sales_order_template TEXT,
    owner_date_created DATETIME,
    owner_default_carrier_contact_num TEXT,
    owner_owned_stock_locations TEXT,
    owner_is_wet_liable BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StockTransfers Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stocktransfersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stocktransfersstage (
    id VARCHAR(255) NOT NULL,
    transfer_num INT NOT NULL,
    date DATETIME NOT NULL,
    transfer_type INT NOT NULL,
    source_stock_location_code VARCHAR(255),
    destination_stock_location_code VARCHAR(255),
    operator_code VARCHAR(255),
    is_updated BOOLEAN,
    comments VARCHAR(500),
    destination_location VARCHAR(255),
    source_location VARCHAR(255),
    entries TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- StockTransferEntries Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stocktransferentriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stocktransferentriesstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT NOT NULL,
    stock_transfer_num INT NOT NULL,
    stock_item_num INT NOT NULL,
    quantity DECIMAL(18,4) NOT NULL,
    unit_of_measure_code VARCHAR(255),
    units_in_stock_initially_at_location DECIMAL(18,4),
    units_in_stock_finally_at_location DECIMAL(18,4),
    units_in_stock_initially_at_all_locations DECIMAL(18,4),
    units_in_stock_finally_at_all_locations DECIMAL(18,4),
    units_in_stock_unit_of_measure VARCHAR(255),
    cost_method VARCHAR(255),
    cost_per_unit DECIMAL(18,4),
    cost_total DECIMAL(18,4),
    stock_location_code VARCHAR(255),
    source_or_destination VARCHAR(50),
    sort INT,
    source_entry_num INT,
    stock_transfer_pair_entry_num INT,
    is_updated BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- StoredObjects Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_storedobjectsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_storedobjectsstage (
    id VARCHAR(255) NOT NULL,
    `key` VARCHAR(500),
    serialized_object TEXT,
    format VARCHAR(50),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Translation Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_translationstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_translationstage (
    ref_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    `key` VARCHAR(255),
    language VARCHAR(255),
    locale VARCHAR(255),
    variant VARCHAR(255),
    value TEXT,
    date_modified DATETIME,
    translation_key VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- UnitsOfMeasure Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_unitsofmeasurestage;
CREATE TABLE c{clientID}_{orgID}_vinsight_unitsofmeasurestage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    conversion_rate DECIMAL(18,2),
    date_modified DATETIME,
    length TEXT,
    width TEXT,
    height TEXT,
    weight TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Users Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_usersstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_usersstage (
    ref_id VARCHAR(255),
    application_id VARCHAR(255),
    id VARCHAR(255) NOT NULL,
    user_name VARCHAR(255),
    lowered_user_name VARCHAR(255),
    mobile_alias VARCHAR(255),
    is_anonymous BOOLEAN,
    last_activity_date DATETIME,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    is_api_user BOOLEAN,
    date_modified DATETIME,
    is_partner_user BOOLEAN,
    application TEXT,
    api_key VARCHAR(255),
    api_user_created_by_user VARCHAR(255),
    api_key_expiry_date TEXT,
    api_key_auto_extend_expiry_date TEXT,
    api_key_date_last_used TEXT,
    api_key_connection_id VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Varieties Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_varietiesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_varietiesstage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description TEXT,
    wine_type VARCHAR(255),
    stock_item_num VARCHAR(255),
    stock_item TEXT,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AnalysisCodes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_analysiscodesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_analysiscodesstage (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    db_column_name VARCHAR(255),
    required BOOLEAN,
    type_name VARCHAR(255),
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- WineryOperationVarianceCodes Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_wineryoperationvariancecodesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_wineryoperationvariancecodesstage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description VARCHAR(255),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Wines Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_winesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_winesstage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description VARCHAR(255),
    asset_ledger_code VARCHAR(255),
    stock_item_num VARCHAR(100),
    stock_item VARCHAR(100),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- WineStatuses Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_winestatusesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_winestatusesstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    wine_type_code VARCHAR(255),
    status_code VARCHAR(255),
    colour_code INT,
    wine_type VARCHAR(100),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Pattern: c{clientID}_{orgID}_vinsight_{entity}stage
-- Replace {clientID} and {orgID} with actual values
-- AWS: Database prefixes are no longer needed with AWS

-- StockGroups Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_stockgroupsstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_stockgroupsstage (
    id VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description TEXT,
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- AnalysisSetEntry Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_analysissetentrystage;
CREATE TABLE c{clientID}_{orgID}_vinsight_analysissetentrystage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    analysis_set_num INT,
    column_name VARCHAR(255),
    property_name VARCHAR(255),
    type_name VARCHAR(255),
    sort_order INT,
    decimal_places INT,
    title VARCHAR(255),
    show_previous_value BOOLEAN,
    filter VARCHAR(255),
    show_on_graph BOOLEAN,
    y_axis_index INT,
    analysis_set VARCHAR(255),
    sync_token VARCHAR(255),
    meta_data_create_time DATETIME,
    meta_data_last_updated_time DATETIME,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- Categories Stage Table
DROP TABLE IF EXISTS c{clientID}_{orgID}_vinsight_categoriesstage;
CREATE TABLE c{clientID}_{orgID}_vinsight_categoriesstage (
    id VARCHAR(255) NOT NULL,
    entry_num INT,
    entity_type VARCHAR(255),
    code VARCHAR(255),
    description TEXT,
    `values` TEXT,
    value_type VARCHAR(255),
    save_values BOOLEAN,
    can_multi_apply BOOLEAN,
    is_multi_value BOOLEAN,
    ClientID VARCHAR(255) NOT NULL,
    OrganisationID VARCHAR(255) NOT NULL,
    etlinserttime DATETIME DEFAULT CURRENT_TIMESTAMP,
    etlupdatetime DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);