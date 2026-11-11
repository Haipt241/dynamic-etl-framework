-- QuickBooks Online Stored Procedures - Complete Set

-- CompanyInfo
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_companyinfo;
CREATE PROCEDURE sp_dynamic_qbo_companyinfo(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_companyinfo');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_companyinfostage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END;

-- Account
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_account;
CREATE PROCEDURE sp_dynamic_qbo_account(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_account');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_accountstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END;

-- Customer
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_customer;
CREATE PROCEDURE sp_dynamic_qbo_customer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_customer');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_customerstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END;

-- Vendor
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_vendor;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_vendor(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_vendor');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_vendorstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Employee
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_employee;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_employee(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_employee');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_employeestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Item
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_item;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_item(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_item');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_itemstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Class
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_class;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_class(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_class');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_classstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Department
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_department;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_department(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_department');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_departmentstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- TaxCode
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxcode;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_taxcode(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_taxcode');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_taxcodestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- TaxRate
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxrate;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_taxrate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_taxrate');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_taxratestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Term
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_term;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_term(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_term');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_termstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- PaymentMethod
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_paymentmethod;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_paymentmethod(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_paymentmethod');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_paymentmethodstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Transaction Procedures with Incremental Loading

-- Invoice
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_invoice;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_invoice(IN p_endpoint VARCHAR(100), IN p_clientID VARCHAR(100), IN p_etaniOrgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_legacyOrgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_invoice');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_etaniOrgID, '_qbo_invoicestage');
    
    SET @delete_updated = CONCAT('
        DELETE FROM ', v_table_name, '
        WHERE Id IN (
            SELECT DISTINCT Id FROM ', v_stage_table, '
        ) AND OrganisationID = ', v_OrganisationID, ';
    ');
    
    PREPARE stmt1 FROM @delete_updated;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');
    
    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Payment
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_payment;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_payment(IN p_endpoint VARCHAR(100), IN p_clientID VARCHAR(100), IN p_etaniOrgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_legacyOrgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_payment');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_etaniOrgID, '_qbo_paymentstage');
    
    SET @delete_updated = CONCAT('
        DELETE FROM ', v_table_name, '
        WHERE Id IN (
            SELECT DISTINCT Id FROM ', v_stage_table, '
        ) AND OrganisationID = ', v_OrganisationID, ';
    ');
    
    PREPARE stmt1 FROM @delete_updated;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');
    
    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- SalesReceipt
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_salesreceipt;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_salesreceipt(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_salesreceipt');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_salesreceiptstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Estimate
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_estimate;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_estimate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_estimate');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_estimatestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- CreditMemo
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_creditmemo;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_creditmemo(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_creditmemo');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_creditmemostage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- RefundReceipt
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_refundreceipt;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_refundreceipt(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_refundreceipt');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_refundreceiptstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Bill (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_bill;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_bill(IN p_endpoint VARCHAR(100), IN p_clientID VARCHAR(100), IN p_etaniOrgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_legacyOrgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_bill');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_etaniOrgID, '_qbo_billstage');
    
    SET @delete_updated = CONCAT('
        DELETE FROM ', v_table_name, '
        WHERE Id IN (
            SELECT DISTINCT Id FROM ', v_stage_table, '
        ) AND OrganisationID = ', v_OrganisationID, ';
    ');
    
    PREPARE stmt1 FROM @delete_updated;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');
    
    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- BillPayment
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_billpayment;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_billpayment(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_billpayment');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_billpaymentstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- VendorCredit
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_vendorcredit;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_vendorcredit(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_vendorcredit');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_vendorcreditstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Purchase
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_purchase;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_purchase(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_purchase');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_purchasestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- PurchaseOrder
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_purchaseorder;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_purchaseorder(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_purchaseorder');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_purchaseorderstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Deposit
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_deposit;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_deposit(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_deposit');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_depositstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Transfer
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_transfer;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_transfer(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_transfer');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_transferstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- JournalEntry (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_journalentry;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_journalentry(IN p_endpoint VARCHAR(100), IN p_clientID VARCHAR(100), IN p_etaniOrgID INT, IN p_legacyOrgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_legacyOrgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_journalentry');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_etaniOrgID, '_qbo_journalentrystage');
    
    SET @delete_updated = CONCAT('
        DELETE FROM ', v_table_name, '
        WHERE Id IN (
            SELECT DISTINCT Id FROM ', v_stage_table, '
        ) AND OrganisationID = ', v_OrganisationID, ';
    ');
    
    PREPARE stmt1 FROM @delete_updated;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;
    
    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');
    
    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Other Entities

-- TimeActivity
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_timeactivity;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_timeactivity(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_timeactivity');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_timeactivitystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Budget
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_budget;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_budget(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_budget');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_budgetstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        REPLACE INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- CompanyCurrency
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_companycurrency;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_companycurrency(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_companycurrency');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_companycurrencystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- ExchangeRate
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_exchangerate;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_exchangerate(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_exchangerate');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_exchangeratestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Preferences
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_preferences;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_preferences(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_preferences');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_preferencesstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Attachable (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_attachable;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_attachable(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_attachable');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_attachablestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Report Procedures

-- BalanceSheet (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_balancesheet;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_balancesheet(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_balancesheet');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_balancesheetstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- ProfitAndLoss
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_profitandloss;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_profitandloss(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_profitandloss');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_profitandlossstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- CashFlow
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_cashflow;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_cashflow(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_cashflow');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_cashflowstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- TrialBalance
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_trialbalance;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_trialbalance(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_trialbalance');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_trialbalancestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- GeneralLedger
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_generalledger;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_generalledger(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_generalledger');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_generalledgerstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- AccountListDetail (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_accountlistdetail;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_accountlistdetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_accountlistdetail');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_accountlistdetailstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- APAgingDetail (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_apagingdetail;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_apagingdetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_apagingdetail');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_apagingdetailstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- APAgingSummary (Already exists - updated for consistency)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_apagingsummary;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_apagingsummary(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_apagingsummary');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_apagingsummarystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- ARAgingDetail
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_aragingdetail;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_aragingdetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_aragingdetail');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_aragingdetailstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- ARAgingSummary
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_aragingsummary;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_aragingsummary(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_aragingsummary');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_aragingsummarystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- VendorBalanceDetail
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_vendorbalancedetail;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_vendorbalancedetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_vendorbalancedetail');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_vendorbalancedetailstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- CustomerBalanceDetail
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_customerbalancedetail;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_customerbalancedetail(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_customerbalancedetail');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_customerbalancedetailstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- InventoryValuationSummary
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_inventoryvaluationsummary;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_inventoryvaluationsummary(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_inventoryvaluationsummary');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_inventoryvaluationsummarystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- LastRefreshDate (Already exists - not modified)
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_lastrefreshdate;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_lastrefreshdate(IN p_endpoint VARCHAR(100), IN p_clientID VARCHAR(100), IN p_etaniOrgID INT, IN p_legacyOrgID INT, IN p_status VARCHAR(100))
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_legacyOrgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_lastrefreshdate');
    
    SET @update_sql = CONCAT('
        UPDATE ', v_table_name, '
        SET LastRefreshDate = NOW(), Status = ''', p_status, '''
        WHERE Endpoint = ''', p_endpoint, '''
        AND OrganisationID = ', v_OrganisationID, ';
    ');
    
    PREPARE stmt FROM @update_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, ' (Endpoint, LastRefreshDate, Status, OrganisationID)
        SELECT ''', p_endpoint, ''', NOW(), ''', p_status, ''', ', v_OrganisationID, '
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM ', v_table_name, '
            WHERE Endpoint = ''', p_endpoint, '''
            AND OrganisationID = ', v_OrganisationID, '
        );
    ');
    
    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- Additional Missing Entity Stored Procedures

-- TaxAgency
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxagency;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_taxagency(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_taxagency');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_taxagencystage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- TaxService
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_taxservice;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_taxservice(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_taxservice');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_taxservicestage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- UOM
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_uom;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_uom(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_uom');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_uomstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- QbdtEntityIdMapping
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_qbdtentityidmapping;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_qbdtentityidmapping(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_qbdtentityidmapping');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_qbdtentityidmappingstage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;

-- TDSMetadata
DROP PROCEDURE IF EXISTS sp_dynamic_qbo_tdsmetadata;
DELIMITER //
CREATE PROCEDURE sp_dynamic_qbo_tdsmetadata(IN p_clientID VARCHAR(100), IN p_orgID INT)
BEGIN
    DECLARE v_OrganisationID INT DEFAULT p_orgID;
    DECLARE v_clientID VARCHAR(100) DEFAULT p_clientID;
    DECLARE v_table_name VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_qbo_tdsmetadata');
    DECLARE v_stage_table VARCHAR(255) DEFAULT CONCAT('c', v_clientID, '_', p_orgID, '_qbo_tdsmetadatastage');

    SET @delete_default = CONCAT('
        DELETE FROM ', v_table_name, ' 
        WHERE OrganisationID = ', v_OrganisationID, ';
    ');

    PREPARE stmt1 FROM @delete_default;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @insert_sql = CONCAT('
        INSERT INTO ', v_table_name, '
        SELECT * FROM ', v_stage_table, ';
    ');

    PREPARE stmt2 FROM @insert_sql;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END //
DELIMITER ;