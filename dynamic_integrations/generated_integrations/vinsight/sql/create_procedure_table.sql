-- VINSIGHT Stored Procedures - Auto Generated
-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- AuditLogEntry
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_auditlogentry;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_auditlogentry(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_auditlogentry`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_auditlogentrystage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            json_id,
            id,
            related_id,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            type,
            source_type,
            source_id,
            event_type,
            user_name,
            requested_via,
            remote_ip,
            description,
            data_format,
            user_id,
            organisation_id,
            alternate_key,
            child_entries,
            parent_entry,
            user,
            data_json_id,
            datasalesordernum,
            CASE 
                WHEN CAST(data_date_modified_from AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE data_date_modified_from 
            END as data_date_modified_from,
            CASE 
                WHEN CAST(data_date_modified_to AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE data_date_modified_to 
            END as data_date_modified_to,
            user_email,
            organisation_name,
            organisation_id_nested,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Components
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_components;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_components(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_components`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_componentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            component_group_num,
            description,
            is_active,
            asset_ledger_code,
            allocation_entries,
            `group`,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ContactActivity
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_contactactivity;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_contactactivity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_contactactivity`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_contactactivitystage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            CASE 
                WHEN CAST(activity_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE activity_date 
            END as activity_date,
            CASE 
                WHEN CAST(attendees AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE attendees 
            END as attendees,
            categories,
            comments,
            contact_contact_code,
            contact_email,
            contact_name,
            contact_num,
            description,
            duration,
            organiser,
            organiser_contact_num,
            gps,
            address,
            status,
            type_entry_num,
            type_code,
            type_description,
            type_icon,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AuditLogChildEntries
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_auditlogchildentries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_auditlogchildentries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_auditlogchildentries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_auditlogchildentriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            parent_audit_log_id,
            id,
            type,
            description,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ComponentsAllocationEntries
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_componentsallocationentries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_componentsallocationentries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_componentsallocationentries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_componentsallocationentriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            component_id,
            entry_num,
            allocation_percent,
            description,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ContactCategories
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_contactcategories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_contactcategories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_contactcategories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_contactcategoriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            description,
            `values`,
            value_type,
            save_values,
            entry_num,
            can_multi_apply,
            is_multi_value,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Contacts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_contacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_contacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_contacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_contactsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            contact_num,
            type,
            contact_code,
            legal_name,
            first_name,
            CASE 
                WHEN CAST(last_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE last_name 
            END as last_name,
            title,
            phone,
            fax,
            mobile,
            email,
            comments,
            physical_use_postal_address,
            physical_address1,
            physical_address2,
            physical_city,
            physical_region,
            physical_post_code,
            physical_country,
            postal_use_physical_address,
            postal_address,
            postal_address2,
            postal_city,
            postal_region,
            postal_code,
            postal_country,
            key_words,
            contact_category,
            is_active,
            is_creditor,
            is_debtor,
            is_grower,
            is_carrier,
            is_mail_order,
            is_employee,
            is_related_party,
            is_grower_operator,
            is_sales_operator,
            is_production_operator,
            is_wine_tax_liable,
            credit_account_number,
            bank_account_number,
            bank_account_name,
            default_division_num_for_sales_orders,
            default_division_num_for_purchase_orders,
            default_stock_location_code,
            default_sales_person_num,
            default_sales_person_code,
            is_wine_tax_own_use,
            tax_number,
            default_payment_term_entry_num,
            default_currency_num,
            revenue_ledger_code,
            default_bill_to_contact_num,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            default_sales_tax_rate_num,
            expense_ledger_code,
            physical_delivery_instructions,
            CASE 
                WHEN CAST(lead_time_hours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lead_time_hours 
            END as lead_time_hours,
            default_sales_order_template,
            CASE 
                WHEN CAST(date_created AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_created 
            END as date_created,
            default_carrier_contact_num,
            default_payment_term,
            default_currency,
            contact_activities,
            default_sales_person_opr,
            default_sales_person,
            default_stock_location,
            default_bill_to_contact,
            default_sales_tax_rate,
            default_carrier_contact,
            CASE 
                WHEN CAST(lead_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lead_time 
            END as lead_time,
            is_wet_liable,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Currencies
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencies;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencies(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencies`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currenciesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            currency_code,
            description,
            major_unit_symbol,
            major_unit_description,
            minor_unit_symbol,
            minor_unit_description,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Dashboard
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_dashboard;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_dashboard(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_dashboard`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_dashboardstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            `key`,
            serialized_object,
            format,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencySalesOrders
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencysalesorders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencysalesorders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencysalesorders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencysalesordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            sales_order_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;


-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- CurrencySalesOrderItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencysalesorderitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencysalesorderitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencysalesorderitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencysalesorderitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            sales_order_item_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyTaxTypes
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencytaxtypes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencytaxtypes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencytaxtypes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencytaxtypesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            tax_type_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyStockItemPrices
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencystockitemprices;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencystockitemprices(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencystockitemprices`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencystockitempricesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            stock_item_price_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyPurchaseOrders
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencypurchaseorders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencypurchaseorders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencypurchaseorders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencypurchaseordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            purchase_order_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyDeals
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencydeals;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencydeals(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencydeals`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencydealsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            deal_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyPurchaseOrderItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencypurchaseorderitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencypurchaseorderitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencypurchaseorderitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencypurchaseorderitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            purchase_order_item_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyContacts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencycontacts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencycontacts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencycontacts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencycontactsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            contact_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyDivisions
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencydivisions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencydivisions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencydivisions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencydivisionsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            division_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyCdrs
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencycdrs;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencycdrs(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencycdrs`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencycdrsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            cdr_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyDtrPyts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencydtrpyts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencydtrpyts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencydtrpyts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencydtrpytsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            dtr_pyt_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- CurrencyGenJorEnts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencygenjorents;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencygenjorents(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencygenjorents`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencygenjorentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            gen_jor_ent_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- CurrencyStkItmPrcLists
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_currencystkitmprclists;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_currencystkitmprclists(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_currencystkitmprclists`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_currencystkitmprclistsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            currency_entry_num,
            stk_itm_prc_list_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Divisions
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisions;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisions(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisions`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            division_code,
            description,
            company_name,
            legal_name,
            physical_address1,
            physical_address2,
            physical_city,
            physical_region,
            physical_post_code,
            physical_country,
            postal_address,
            postal_address2,
            postal_city,
            postal_region,
            postal_code,
            postal_country,
            phone,
            fax,
            email,
            tax_number,
            company_image_path,
            logo_dimensions,
            logo_contains_name,
            excise_rate1,
            excise_rate2,
            excise_rate3,
            sales_tax_rate,
            culture,
            logo_image_content_type,
            bank_account_name,
            bank_account_number,
            remittance_instructions,
            weight_unit_of_measure_code,
            volume_unit_of_measure_code,
            length_unit_of_measure_code,
            invoice_footer,
            invoice_header,
            invoice_division_address,
            default_currency_num,
            cost_method,
            CASE 
                WHEN CAST(first_sales_tax_period AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE first_sales_tax_period 
            END as first_sales_tax_period,
            sales_tax_period,
            CASE 
                WHEN CAST(balance_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE balance_date 
            END as balance_date,
            footer_image_content_type,
            company_contact_num,
            CASE 
                WHEN CAST(timezone AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE timezone 
            END as timezone,
            shipment_length_unit_of_measure_code,
            shipment_weight_unit_of_measure_code,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionSalesOrders
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisionsalesorders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisionsalesorders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisionsalesorders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionsalesordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            sales_order_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionDeals
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisiondeals;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisiondeals(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisiondeals`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisiondealsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            deal_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionPurchaseOrders
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisionpurchaseorders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisionpurchaseorders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisionpurchaseorders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionpurchaseordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            purchase_order_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionAssessments
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisionassessments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisionassessments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisionassessments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionassessmentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            assessment_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionStockItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisionstockitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisionstockitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisionstockitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionstockitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            stock_item_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- DivisionJournals
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_divisionjournals;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_divisionjournals(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_divisionjournals`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_divisionjournalsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            division_entry_num,
            journal_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Documents
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_documents;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_documents(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_documents`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_documentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            categories,
            url,
            content,
            id,
            CASE 
                WHEN CAST(date_created AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_created 
            END as date_created,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            is_active,
            name,
            display_name,
            mime_type,
            entry_type,
            content_encoding,
            md5_hash,
            size_bytes,
            owner_id,
            owner_display_name,
            owner_type,
            html_link_snippet,
            attachments_count,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- DuePayments
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_duepayments;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_duepayments(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_duepayments`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_duepaymentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            CASE 
                WHEN CAST(due_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE due_date 
            END as due_date,
            amount,
            description,
            payment_term_entry_num,
            source_num,
            source_type,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            payment_term,
            sales_order,
            purchase_order,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ExpressionDefinition
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_expressiondefinition;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_expressiondefinition(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_expressiondefinition`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_expressiondefinitionstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            description,
            expression,
            expression_language,
            argument_types,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- LedgerAccounts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_ledgeraccounts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_ledgeraccounts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_ledgeraccounts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_ledgeraccountsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            description,
            ledger_account_type_num,
            is_inventory_ledger,
            is_debtor_ledger,
            is_creditor_ledger,
            is_cash_flow_ledger,
            is_bank_account,
            is_active,
            comment,
            ledger_account_type_id,
            ledger_account_type_entry_num,
            ledger_account_type_code,
            ledger_account_type_ref,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PaymentTerms
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_paymentterms;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_paymentterms(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_paymentterms`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_paymenttermsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            description,
            percentage,
            expression_entry_num,
            parent_entry_num,
            expression_argument,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            expression_definition_entry_num,
            expression_definition_code,
            expression_definition_description,
            expression_definition_expression,
            expression_definition_expression_language,
            expression_definition_argument_types,
            expression_definition_payment_terms,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ProductCategory
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_productcategory;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_productcategory(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_productcategory`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_productcategorystage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            description,
            `values`,
            value_type,
            save_values,
            can_multi_apply,
            is_multi_value,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AuditLogEntries
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_auditlogentries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_auditlogentries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_auditlogentries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_auditlogentriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            api_id,
            id,
            related_id,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            type,
            source_type,
            source_id,
            event_type,
            user_name,
            requested_via,
            remote_ip,
            description,
            `data`,
            data_format,
            user_id,
            organisation_id,
            alternate_key,
            parent_entry_id,
            CASE 
                WHEN CAST(parent_entry_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE parent_entry_date 
            END as parent_entry_date,
            parent_entry_type,
            user_user_name,
            user_first_name,
            CASE 
                WHEN CAST(user_last_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE user_last_name 
            END as user_last_name,
            organisation_name,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ProductDetail
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_productdetail;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_productdetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_productdetail`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_productdetailstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            `key`,
            serialized_object,
            format,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorderitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorderitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorderitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            description,
            quantity,
            unit_of_measure_code,
            unit_price,
            discount,
            sales_tax_rate_value,
            sales_tax_rate_num,
            price_entry_num,
            discount_entry_num,
            price_description,
            discount_description,
            order_num,
            currency_num,
            stock_item_num,
            suppliers_code,
            total_cost,
            analysis_certificate,
            lot_code,
            CASE 
                WHEN CAST(date_first_used AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_first_used 
            END as date_first_used,
            CASE 
                WHEN CAST(date_last_used AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_last_used 
            END as date_last_used,
            allocation_type,
            allocation_id,
            allocation_num,
            CASE 
                WHEN CAST(expiry_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expiry_date 
            END as expiry_date,
            quantity_available,
            sort,
            discount_numeric,
            currency,
            `order`,
            stock_item,
            sales_tax_rate,
            unit_of_measure,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderReceiptItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorderreceiptitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorderreceiptitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorderreceiptitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderreceiptitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            receipt_num,
            stock_item_num,
            quantity,
            unit_of_measure_code,
            units_in_stock_initially_at_location,
            units_in_stock_finally_at_location,
            units_in_stock_initially_at_all_locations,
            units_in_stock_finally_at_all_locations,
            units_in_stock_unit_of_measure,
            cost_method,
            cost_per_unit,
            cost_total,
            analysis_certificate,
            lot_code,
            CASE 
                WHEN CAST(date_first_used AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_first_used 
            END as date_first_used,
            CASE 
                WHEN CAST(date_last_used AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_last_used 
            END as date_last_used,
            supplier_code,
            sort,
            receipt,
            stock_item,
            unit_of_measure,
            warnings,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderReceipts
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorderreceipts;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorderreceipts(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorderreceipts`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderreceiptsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            receipt_num,
            CASE 
                WHEN CAST(date_delivered AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_delivered 
            END as date_delivered,
            order_num,
            CASE 
                WHEN CAST(is_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE is_updated 
            END as is_updated,
            is_final_delivery,
            stock_location_code,
            is_active,
            delivery_instructions,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            `order`,
            stock_location,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- PurchaseOrderReceiptEntries
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorderreceiptentries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorderreceiptentries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorderreceiptentries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderreceiptentriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            purchase_order_receipts_id,
            purchase_order_receipts_organisation_id,
            entry_num,
            quantity,
            description,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrderReceiptAliases
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorderreceiptaliases;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorderreceiptaliases(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorderreceiptaliases`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderreceiptaliasesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            purchase_order_receipts_id,
            purchase_order_receipts_organisation_id,
            alias_name,
            alias_type,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- PurchaseOrder
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_purchaseorder;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_purchaseorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_purchaseorder`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_purchaseorderstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            order_num,
            order_reference,
            delivery_address,
            delivery_instructions,
            ordered_with,
            sub_total_amount,
            comments,
            currency_num,
            payment_term_description,
            transaction_reference,
            is_posted,
            stock_location_code,
            status,
            payment_term_entry_num,
            operator_num,
            total_excluding_taxes,
            billing_contact_num,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            categories,
            CASE 
                WHEN CAST(date_created AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_created 
            END as date_created,
            invoice_accounting_status,
            division_num,
            CASE 
                WHEN CAST(date_delivered AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_delivered 
            END as date_delivered,
            contact_num,
            ordered_by_operator_code,
            CASE 
                WHEN CAST(order_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_date 
            END as order_date,
            CASE 
                WHEN CAST(date_required AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_required 
            END as date_required,
            CASE 
                WHEN CAST(date_paid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_paid 
            END as date_paid,
            CASE 
                WHEN CAST(date_payment_due AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_payment_due 
            END as date_payment_due,
            is_active,
            total_including_taxes,
            currency_rate,
            contact_contact_num,
            contact_type,
            contact_contact_code,
            contact_legal_name,
            contact_first_name,
            CASE 
                WHEN CAST(contact_last_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE contact_last_name 
            END as contact_last_name,
            contact_title,
            contact_phone,
            contact_fax,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Region
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_region;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_region(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_region`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_regionstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            region_code,
            description,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ResourceCollections
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_resourcecollections;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_resourcecollections(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_resourcecollections`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_resourcecollectionsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            ref_id,
            id,
            name,
            parent_collection_id,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            parent_collection,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Addons
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_addons;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_addons(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_addons`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_addonsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            api_id,
            open_api_specification_file,
            id,
            name,
            short_name,
            author,
            image_url,
            description,
            link_description,
            web_address,
            tags,
            position,
            integrations,
            disconnect_link,
            max_integrations,
            for_countries,
            is_permanent,
            is_in_session_only,
            is_active,
            is_invite_only,
            is_plugin,
            billing_category,
            per_integration_billing_max_paid,
            listens_to_webhooks,
            api_rate_limit_calls_per_second,
            o_auth_flow,
            security_scheme,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Roles
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_roles;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_roles(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_roles`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_rolesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            ref_id,
            application_id,
            id,
            name,
            lowered_name,
            description,
            is_read_only,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            organisation_id,
            is_admin,
            application,
            is_two_factor_required,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SalesOrderDespatches
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_salesorderdespatches;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_salesorderdespatches(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_salesorderdespatches`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_salesorderdespatchesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            despatch_num,
            order_num,
            CASE 
                WHEN CAST(date_despatched AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_despatched 
            END as date_despatched,
            CASE 
                WHEN CAST(is_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE is_updated 
            END as is_updated,
            is_final_despatch,
            CASE 
                WHEN CAST(date_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_updated 
            END as date_updated,
            carrier_code,
            reference,
            comments,
            delivery_name,
            delivery_address,
            delivery_suburb,
            delivery_city,
            delivery_region,
            delivery_post_code,
            delivery_country,
            delivery_email,
            delivery_phone,
            delivery_instructions,
            stock_location_code,
            is_active,
            carrier_contact_num,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            location_notified,
            carrier_notified,
            location_status,
            carrier_status,
            categories,
            `order`,
            stock_location,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SalesOrderDespatchItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_salesorderdespatchitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_salesorderdespatchitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_salesorderdespatchitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_salesorderdespatchitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            despatch_num,
            stock_item_num,
            quantity,
            unit_of_measure_code,
            units_in_stock_initially_at_location,
            units_in_stock_finally_at_location,
            units_in_stock_initially_at_all_locations,
            units_in_stock_finally_at_all_locations,
            units_in_stock_unit_of_measure,
            cost_method,
            cost_per_unit,
            cost_total,
            quantity_required,
            quantity_back_ordered,
            lot_code,
            description,
            sort,
            parent_entry_num,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            despatch,
            stock_item,
            unit_of_measure,
            parent,
            warnings,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- SalesOrderItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_salesorderitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_salesorderitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_salesorderitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_salesorderitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            entry_num,
            description,
            quantity,
            unit_of_measure_code,
            unit_price,
            discount,
            sales_tax_rate_value,
            sales_tax_rate_num,
            is_wine_tax_liable,
            wine_tax_rate_value,
            wine_tax_rate_num,
            price_description,
            discount_description,
            order_num,
            currency_num,
            stock_item_num,
            price_entry_num,
            discount_entry_num,
            stock_location_code,
            sort,
            allocation_type,
            allocation_id,
            allocation_num,
            discount_numeric,
            source_entry_num,
            order_salesordernum,
            order_delivery_name,
            order_delivery_address,
            order_delivery_suburb,
            order_delivery_city,
            order_delivery_region,
            order_delivery_post_code,
            order_delivery_country,
            order_delivery_email,
            order_delivery_phone,
            order_delivery_instructions,
            order_comments,
            order_order_reference,
            CASE 
                WHEN CAST(order_order_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_order_date 
            END as order_order_date,
            CASE 
                WHEN CAST(order_invoice_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_invoice_date 
            END as order_invoice_date,
            CASE 
                WHEN CAST(order_date_required AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_date_required 
            END as order_date_required,
            CASE 
                WHEN CAST(order_date_despatched AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_date_despatched 
            END as order_date_despatched,
            CASE 
                WHEN CAST(order_date_payment_due AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_date_payment_due 
            END as order_date_payment_due,
            order_payment_term_description,
            CASE 
                WHEN CAST(order_date_paid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_date_paid 
            END as order_date_paid,
            order_carrier_code,
            order_sub_total_amount,
            order_freight_amount,
            order_is_posted,
            order_transaction_reference,
            order_is_wine_tax_liable,
            order_contact_num,
            order_division_num,
            order_sales_person_code,
            order_currency_num,
            order_stock_location_code,
            order_status,
            order_payment_term_entry_num,
            order_is_non_arms_length,
            order_sales_person_num,
            order_carrier_contact_num,
            order_currency_rate,
            order_invoice_sent_status,
            order_invoice_paid_status,
            order_order_delivery_status,
            order_order_movement_status,
            order_tracking_uri,
            order_total_including_taxes,
            order_total_excluding_taxes,
            order_billing_contact_num,
            order_is_active,
            CASE 
                WHEN CAST(order_datemodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_datemodified 
            END as order_datemodified,
            order_categories,
            order_validation_error,
            CASE 
                WHEN CAST(order_datecreated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE order_datecreated 
            END as order_datecreated,
            order_contact,
            order_currency,
            order_items,
            order_sales_person_opr,
            order_stock_location,
            order_payment_term,
            order_sales_person,
            order_carrier_contact,
            order_billing_contact,
            order_$ref,
            order_division,
            currency,
            stock_item,
            sales_tax_rate,
            wine_tax_rate,
            unit_of_measure,
            price_list_entry,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- SalesOrders
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_salesorders;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_salesorders(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_salesorders`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_salesordersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            salesordernum,
            division_num,
            contact_num,
            contact_contact_code,
            contact_default_sales_order_template,
            contact_$ref,
            division_division_code,
            division_$ref,
            CASE 
                WHEN CAST(invoice_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE invoice_date 
            END as invoice_date,
            CASE 
                WHEN CAST(date_paid AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_paid 
            END as date_paid,
            CASE 
                WHEN CAST(date_payment_due AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_payment_due 
            END as date_payment_due,
            order_reference,
            total_including_taxes,
            currency_currency_code,
            currency_major_unit_symbol,
            currency_$ref,
            currency_rate,
            CASE 
                WHEN CAST(date_despatched AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_despatched 
            END as date_despatched,
            status,
            is_active,
            categories,
            stock_location_code,
            invoice_sent_status,
            delivery_region,
            despatch_status,
            stock_locations_count,
            first_despatch_location,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockItemComponents
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockitemcomponents;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockitemcomponents(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockitemcomponents`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockitemcomponentsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            stock_item_num,
            component_stock_item_num,
            quantity,
            unit_of_measure_code,
            entity_type,
            entity_id,
            is_quantity_total,
            entity_num,
            rate_type,
            stock_item,
            component_stock_item,
            stock_item_unit_of_measure,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockItemLocations
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockitemlocations;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockitemlocations(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockitemlocations`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockitemlocationsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            stock_item_num,
            stock_location_code,
            units_in_stock,
            unit_of_measure_code,
            total_cost,
            latest_cost,
            standard_cost,
            re_ord_lvl,
            stock_item,
            stock_location,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockItemMovements
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockitemmovements;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockitemmovements(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockitemmovements`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockitemmovementsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            operation_type,
            operation_id,
            source_operation_type,
            source_operation_id,
            transaction_description,
            CASE 
                WHEN CAST(date_processed AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_processed 
            END as date_processed,
            CASE 
                WHEN CAST(date_as_at AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_as_at 
            END as date_as_at,
            entity_type,
            entity_id,
            stock_item_num,
            stock_location_code,
            quantity,
            unit_of_measure_code,
            units_in_stock_initially_at_location,
            units_in_stock_finally_at_location,
            units_in_stock_initially_at_all_locations,
            units_in_stock_finally_at_all_locations,
            units_in_stock_units_of_measure_code,
            cost_method,
            cost_per_unit,
            cost_total,
            standard_cost_initial,
            standard_cost_final,
            total_cost_variance,
            stock_item,
            unit_of_measure,
            units_in_stock_unit_of_measure,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockItemPrices
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockitemprices;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockitemprices(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockitemprices`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockitempricesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            entry_num,
            unit_of_measure_code,
            price_description,
            price,
            discount,
            discount_numeric,
            is_default_price,
            order_type,
            type,
            sales_tax_rate_num,
            currency_num,
            contact_num,
            contact_category,
            CASE 
                WHEN CAST(expiry_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE expiry_date 
            END as expiry_date,
            CASE 
                WHEN CAST(active_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE active_date 
            END as active_date,
            stock_item_num,
            product_category,
            is_purchase_price,
            currency_currency_code,
            salestaxrate_code,
            stockitem_stock_item_code,
            uom_entry_num,
            uom_stock_item_num,
            uom_unit_of_measure_code,
            uom_conversion_rate,
            uom_length,
            uom_width,
            uom_height,
            uom_weight,
            uom_stock_item,
            uom_unit_of_measure,
            can_multi_apply,
            status,
            contact,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockItems
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockitems;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockitems(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockitems`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockitemsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            stock_item_num,
            stock_item_code,
            description,
            stock_group_code,
            lot_code,
            re_order_level,
            comments,
            is_wine_additive,
            is_purchase_order_item,
            is_packaging,
            is_bulk_wine,
            is_sales_order_item,
            is_packaged_wine,
            is_stock_take_item,
            is_grower_additive,
            is_wine_tax_liable,
            operation_standard_text,
            trial_stock_solution_strength,
            default_rate,
            default_rate_type,
            default_rate_uom,
            default_quantity_uom,
            default_volume_per_area,
            quantity_per_unit,
            default_stock_location_code,
            units_in_stock,
            units_in_stock_uom,
            standard_cost,
            total_cost,
            latest_cost,
            cost_method,
            base_uom,
            inner_uom,
            outer_uom,
            pallet_count,
            CASE 
                WHEN CAST(date_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_updated 
            END as date_updated,
            revenue_ledger_code,
            expense_ledger_code,
            asset_ledger_code,
            is_active,
            allocation_stock_item_num,
            bar_code,
            allocation_status,
            sales_tax_rate_num,
            wine_tax_rate_num,
            supplier_num,
            previous_packaging_operation_num,
            pallet_spec_num,
            labelling_spec_num,
            packaging_template_stock_item_num,
            default_application_rate_type,
            product_categories,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            auto_build,
            CASE 
                WHEN CAST(lead_time_hours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE lead_time_hours 
            END as lead_time_hours,
            division_num,
            next_standard_cost_type,
            system_flags,
            is_system_defined,
            system_prevents_edit,
            system_prevents_delete,
            kit_creation,
            kit_price_list,
            prices,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Aliases
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_aliases;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_aliases(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_aliases`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_aliasesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            entity_type,
            entity_id,
            entity_num,
            entity_uniqifier,
            domain,
            sub_domain,
            sub_domain_description,
            domain_entity_type,
            domain_entity_id,
            domain_entity_code,
            domain_entity_description,
            domain_entity_url,
            domain_data,
            hash,
            entity_num_small,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            parent_entry_num,
            is_active,
            CASE 
                WHEN CAST(domain_date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE domain_date_modified 
            END as domain_date_modified,
            CASE 
                WHEN CAST(date_cache_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_cache_updated 
            END as date_cache_updated,
            validation_error,
            contact,
            stock_item,
            sales_order,
            purchase_order,
            tax_rate,
            stock_location,
            sales_order_despatch,
            parent_alias,
            payment_term,
            stock_item_price,
            journal,
            sales_order_item,
            ledger_account,
            purchase_order_receipt,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- ChildAliases
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_childaliases;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_childaliases(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_childaliases`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_childaliasesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            parent_alias_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockLocations
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stocklocations;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stocklocations(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stocklocations`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stocklocationsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            code,
            description,
            is_bonded,
            owner_contact_num,
            is_active,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            owner_type,
            owner_contact_code,
            owner_legal_name,
            owner_first_name,
            CASE 
                WHEN CAST(owner_last_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE owner_last_name 
            END as owner_last_name,
            owner_title,
            owner_phone,
            owner_fax,
            owner_mobile,
            owner_email,
            owner_comments,
            owner_physical_use_postal_address,
            owner_physical_address1,
            owner_physical_address2,
            owner_physical_city,
            owner_physical_region,
            owner_physical_post_code,
            owner_physical_country,
            owner_postal_use_physical_address,
            owner_postal_address,
            owner_postal_address2,
            owner_postal_city,
            owner_postal_region,
            owner_postal_code,
            owner_postal_country,
            owner_key_words,
            owner_contact_category,
            owner_is_active,
            owner_is_creditor,
            owner_is_debtor,
            owner_is_grower,
            owner_is_carrier,
            owner_is_mail_order,
            owner_is_employee,
            owner_is_related_party,
            owner_is_grower_operator,
            owner_is_sales_operator,
            owner_is_production_operator,
            owner_is_wine_tax_liable,
            owner_credit_account_number,
            owner_bank_account_number,
            owner_bank_account_name,
            owner_default_division_num_for_sales_orders,
            owner_default_division_num_for_purchase_orders,
            owner_default_stock_location_code,
            owner_default_sales_person_num,
            owner_default_sales_person_code,
            owner_is_wine_tax_own_use,
            owner_tax_number,
            owner_default_payment_term_entry_num,
            owner_default_currency_num,
            owner_revenue_ledger_code,
            owner_default_bill_to_contact_num,
            CASE 
                WHEN CAST(owner_datemodified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE owner_datemodified 
            END as owner_datemodified,
            owner_default_sales_tax_rate_num,
            owner_expense_ledger_code,
            owner_physical_delivery_instructions,
            CASE 
                WHEN CAST(owner_lead_time_hours AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE owner_lead_time_hours 
            END as owner_lead_time_hours,
            owner_default_sales_order_template,
            CASE 
                WHEN CAST(owner_date_created AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE owner_date_created 
            END as owner_date_created,
            owner_default_carrier_contact_num,
            owner_owned_stock_locations,
            owner_is_wet_liable,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StockTransfers
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stocktransfers;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stocktransfers(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stocktransfers`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stocktransfersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            transfer_num,
            CASE 
                WHEN CAST(date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date 
            END as date,
            transfer_type,
            source_stock_location_code,
            destination_stock_location_code,
            operator_code,
            CASE 
                WHEN CAST(is_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE is_updated 
            END as is_updated,
            comments,
            destination_location,
            source_location,
            entries,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- StockTransferEntries
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stocktransferentries;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stocktransferentries(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stocktransferentries`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stocktransferentriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            stock_transfer_num,
            stock_item_num,
            quantity,
            unit_of_measure_code,
            units_in_stock_initially_at_location,
            units_in_stock_finally_at_location,
            units_in_stock_initially_at_all_locations,
            units_in_stock_finally_at_all_locations,
            units_in_stock_unit_of_measure,
            cost_method,
            cost_per_unit,
            cost_total,
            stock_location_code,
            source_or_destination,
            sort,
            source_entry_num,
            stock_transfer_pair_entry_num,
            CASE 
                WHEN CAST(is_updated AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE is_updated 
            END as is_updated,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- StoredObjects
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_storedobjects;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_storedobjects(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_storedobjects`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_storedobjectsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            `key`,
            serialized_object,
            format,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Translation
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_translation;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_translation(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_translation`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_translationstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            ref_id,
            id,
            `key`,
            language,
            locale,
            variant,
            value,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            translation_key,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- UnitsOfMeasure
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_unitsofmeasure;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_unitsofmeasure(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_unitsofmeasure`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_unitsofmeasurestage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            conversion_rate,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            length,
            width,
            height,
            weight,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Users
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_users;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_users(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_users`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_usersstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            ref_id,
            application_id,
            id,
            user_name,
            lowered_user_name,
            mobile_alias,
            is_anonymous,
            CASE 
                WHEN CAST(last_activity_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE last_activity_date 
            END as last_activity_date,
            first_name,
            CASE 
                WHEN CAST(last_name AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE last_name 
            END as last_name,
            is_api_user,
            CASE 
                WHEN CAST(date_modified AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE date_modified 
            END as date_modified,
            is_partner_user,
            application,
            api_key,
            CASE 
                WHEN CAST(api_user_created_by_user AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE api_user_created_by_user 
            END as api_user_created_by_user,
            CASE 
                WHEN CAST(api_key_expiry_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE api_key_expiry_date 
            END as api_key_expiry_date,
            CASE 
                WHEN CAST(api_key_auto_extend_expiry_date AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE api_key_auto_extend_expiry_date 
            END as api_key_auto_extend_expiry_date,
            CASE 
                WHEN CAST(api_key_date_last_used AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE api_key_date_last_used 
            END as api_key_date_last_used,
            api_key_connection_id,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Varieties
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_varieties;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_varieties(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_varieties`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_varietiesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            description,
            wine_type,
            stock_item_num,
            stock_item,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AnalysisCodes
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_analysiscodes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_analysiscodes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_analysiscodes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_analysiscodesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            name,
            db_column_name,
            required,
            type_name,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- WineryOperationVarianceCodes
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_wineryoperationvariancecodes;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_wineryoperationvariancecodes(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_wineryoperationvariancecodes`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_wineryoperationvariancecodesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            description,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Wines
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_wines;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_wines(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_wines`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_winesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            description,
            asset_ledger_code,
            stock_item_num,
            stock_item,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- WineStatuses
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_winestatuses;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_winestatuses(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_winestatuses`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_winestatusesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            wine_type_code,
            status_code,
            colour_code,
            wine_type,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Individual procedures for each entity following QBO pattern
-- AWS: Database prefixes are no longer needed with AWS
-- AWS: Procedures do not use DEFINER clause

-- StockGroups
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_stockgroups;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_stockgroups(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_stockgroups`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_stockgroupsstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            code,
            description,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- AnalysisSetEntry
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_analysissetentry;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_analysissetentry(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_analysissetentry`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_analysissetentrystage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            analysis_set_num,
            column_name,
            property_name,
            type_name,
            sort_order,
            decimal_places,
            title,
            show_previous_value,
            filter,
            show_on_graph,
            y_axis_index,
            analysis_set,
            sync_token,
            CASE 
                WHEN CAST(meta_data_create_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_create_time 
            END as meta_data_create_time,
            CASE 
                WHEN CAST(meta_data_last_updated_time AS CHAR) IN (''0000-00-00 00:00:00'', ''0000-00-00'', ''0001-01-01 00:00:00'', ''0001-01-01'', '''', ''null'') 
                THEN NULL 
                ELSE meta_data_last_updated_time 
            END as meta_data_last_updated_time,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- Categories
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_categories;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_categories(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_vinsight_categories`');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('`{client_database}`.`c', v_clientID, '_', p_orgID, '_vinsight_categoriesstage`');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT
            id,
            entry_num,
            entity_type,
            code,
            description,
            `values`,
            value_type,
            save_values,
            can_multi_apply,
            is_multi_value,
            ClientID,
            OrganisationID,
            etlinserttime,
            etlupdatetime
        FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END $$
DELIMITER ;

-- VINSIGHT LastRefreshDate Logging Procedure
DROP PROCEDURE IF EXISTS sp_dynamic_vinsight_lastrefreshdate;
DELIMITER $$
CREATE PROCEDURE sp_dynamic_vinsight_lastrefreshdate(
    IN p_CID INT,
    IN p_TableName VARCHAR(255),
    IN p_RefreshRowCount INT,
    IN p_TotalRowCount INT,
    IN p_StartDate DATETIME,
    IN p_EndDate DATETIME,
    IN p_LastRefreshUTCDate DATETIME,
    IN p_LoadType VARCHAR(255),
    IN p_RefreshStatus VARCHAR(255),
    IN p_JobRunId BIGINT,
    IN p_DatabaseDestination VARCHAR(255),
    IN p_ClientID VARCHAR(255),
    IN p_OrganisationID INT,
    IN p_TriggerType VARCHAR(255),
    IN p_RefreshDetails VARCHAR(255)
)
BEGIN
    DECLARE v_NewID INT;

    SET @lastRefreshDateTable = CONCAT('`{client_database}`.`c', p_CID, '_vinsight_lastrefreshdate`');

    SET @newid_sql = CONCAT('SELECT COALESCE(MAX(ID), 0) + 1 INTO @v_NewID FROM ', @lastRefreshDateTable, ';');
    PREPARE new_stmt FROM @newid_sql;
    EXECUTE new_stmt;
    DEALLOCATE PREPARE new_stmt;
    SET v_NewID = @v_NewID;

    SET @insert_sql = CONCAT(
        'INSERT INTO ', @lastRefreshDateTable, ' (',
        '`Id`, `TableName`, `RefreshRowCount`, `TotalRowCount`, `StartDate`, `EndDate`, ',
        '`LastRefreshUTCDate`, `LoadType`, `RefreshStatus`, `JobRunId`, `DatabaseDestination`, ',
        '`ClientID`, `OrganisationID`, `TriggerType`, `RefreshDetails`) VALUES (',
        COALESCE(v_NewID, 0), ', ',
        '''', COALESCE(p_TableName, ''), ''', ',
        COALESCE(p_RefreshRowCount, 0), ', ',
        COALESCE(p_TotalRowCount, 0), ', ',
        IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_StartDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
        IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_EndDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
        IFNULL(CONCAT("'", DATE_FORMAT(STR_TO_DATE(LEFT(p_LastRefreshUTCDate, 26), '%Y-%m-%d %H:%i:%s.%f'), '%Y-%m-%d %H:%i:%s.%f'), "'"), 'NULL'), ', ',
        '''', COALESCE(p_LoadType, ''), ''', ',
        '''', COALESCE(p_RefreshStatus, ''), ''', ',
        COALESCE(p_JobRunId, 'NULL'), ', ',
        '''', COALESCE(p_DatabaseDestination, ''), ''', ',
        '''', COALESCE(p_ClientID, ''), ''', ',
        COALESCE(p_OrganisationID, 'NULL'), ', ',
        '''', COALESCE(p_TriggerType, ''), ''', ',
        '''', COALESCE(p_RefreshDetails, ''), '''',
        ') ON DUPLICATE KEY UPDATE ',
        '`RefreshRowCount` = IF(VALUES(`RefreshRowCount`) IS NOT NULL, VALUES(`RefreshRowCount`), `RefreshRowCount`), ',
        '`TotalRowCount` = IF(VALUES(`TotalRowCount`) IS NOT NULL, VALUES(`TotalRowCount`), `TotalRowCount`), ',
        '`StartDate` = IF(VALUES(`StartDate`) IS NOT NULL, VALUES(`StartDate`), `StartDate`), ',
        '`EndDate` = IF(VALUES(`EndDate`) IS NOT NULL, VALUES(`EndDate`), `EndDate`), ',
        '`LastRefreshUTCDate` = IF(VALUES(`LastRefreshUTCDate`) IS NOT NULL, VALUES(`LastRefreshUTCDate`), `LastRefreshUTCDate`), ',
        '`LoadType` = IF(VALUES(`LoadType`) IS NOT NULL, VALUES(`LoadType`), `LoadType`), ',
        '`RefreshStatus` = IF(VALUES(`RefreshStatus`) IS NOT NULL, VALUES(`RefreshStatus`), `RefreshStatus`), ',
        '`JobRunId` = IF(VALUES(`JobRunId`) IS NOT NULL, VALUES(`JobRunId`), `JobRunId`), ',
        '`DatabaseDestination` = IF(VALUES(`DatabaseDestination`) IS NOT NULL, VALUES(`DatabaseDestination`), `DatabaseDestination`), ',
        '`TriggerType` = IF(VALUES(`TriggerType`) IS NOT NULL, VALUES(`TriggerType`), `TriggerType`), ',
        '`RefreshDetails` = VALUES(`RefreshDetails`)'
    );

    PREPARE ins_stmt FROM @insert_sql;
    EXECUTE ins_stmt;
    DEALLOCATE PREPARE ins_stmt;
END $$
DELIMITER ;
