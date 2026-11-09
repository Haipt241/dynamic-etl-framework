DELIMITER $$

DROP PROCEDURE IF EXISTS `Dynamic-ETL-SIMPRO-Integration-CloseOut`$$

CREATE PROCEDURE `Dynamic-ETL-SIMPRO-Integration-CloseOut`(
    IN client_id_number VARCHAR(255),
    IN etani_organisation_id VARCHAR(255)
)
BEGIN
    DECLARE client_id VARCHAR(255);
    DECLARE organisation_id VARCHAR(255);
    DECLARE view_prefix VARCHAR(255);
    DECLARE sql_stmt TEXT;
    
    -- Get ClientID and OrganisationID from the lookup query
    SELECT 
        CAST(CONCAT(UPPER(af.Code),'_CLIENT',IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')),c.id)) AS CHAR(255)),
        CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Legacy.id')), cs.id) AS CHAR(255))
    INTO client_id, organisation_id
    FROM etaniv2.client_service cs
    INNER JOIN etaniv2.client c ON cs.`Client` = c.id
    INNER JOIN etaniv2.accounting_firm af ON c.AccountingFirm = af.id
    WHERE cs.`Service` = 72
        AND cs.id = etani_organisation_id
        AND cs.`Client` = client_id_number;
    
    -- Set the view prefix (e.g., "bigoleshoecompany_client2033")
    SET view_prefix = LOWER(client_id);
    
    -- Create c6842_simpro_capacitydev table if it doesn't exist
    SET @sql_stmt = CONCAT('CREATE TABLE IF NOT EXISTS evadb_stage.c', client_id_number, '_simpro_capacitydev (
      UUID bigint UNSIGNED NOT NULL AUTO_INCREMENT,
      StaffID varchar(100) DEFAULT NULL,
      StaffName varchar(255) DEFAULT NULL,
      Mon varchar(20) DEFAULT NULL,
      Tue varchar(20) DEFAULT NULL,
      Wed varchar(20) DEFAULT NULL,
      Thu varchar(20) DEFAULT NULL,
      Fri varchar(20) DEFAULT NULL,
      Total varchar(20) DEFAULT NULL,
      Percent varchar(10) DEFAULT NULL,
      Productivity varchar(20) DEFAULT NULL,
      Team varchar(255) DEFAULT NULL,
      BillRate decimal(18, 2) DEFAULT NULL,
      BillableRate decimal(18, 2) DEFAULT NULL,
      FulltimeEquivPercent varchar(10) DEFAULT NULL,
      ClientID varchar(255) DEFAULT NULL,
      OrganisationID bigint DEFAULT NULL,
      Notes text DEFAULT NULL,
      Working tinyint DEFAULT NULL,
      DirectorPartner tinyint DEFAULT NULL,
      FeeEarner tinyint DEFAULT NULL,
      EtlInsertTime timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      EtlUpdateTime timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (UUID)
    )
    ENGINE = INNODB,
    AUTO_INCREMENT = 21,
    AVG_ROW_LENGTH = 819,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_0900_ai_ci,
    ROW_FORMAT = DYNAMIC');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6842_simpro_invoices view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_simpro_invoices');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_simpro_invoices
    AS
    SELECT
      `invoices`.`ID` AS `invoice_id`,
      `invoices`.`ID` AS `invoice_number`,
      `invoices`.`Type` AS `invoice_type`,
      NULL AS `invoice_date`,
      `invoices`.`EtlInsertTime` AS `invoice_created_at`,
      `invoices`.`IsPaid` AS `invoice_status`,
      `invoices`.`Total_IncTax` AS `invoice_amount_including_tax`,
      `invoices`.`Total_ExTax` AS `invoice_amount_sub_total`,
      `invoices`.`Total_Tax` AS `invoice_amount_tax`,
      `invoices`.`Total_AmountApplied` AS `invoice_amount_paid`,
      `invoices`.`Total_BalanceDue` AS `invoice_amount_outstanding`,
      `invoices`.`Total_IncTax` AS `invoice_total_amount`,
      `jobs`.`ID` AS `job_id`,
      `jobs`.`Description` AS `job_name`,
      `invoices_jobs`.`Total_IncTax` AS `invoice_jobs_amount`,
      `customers`.`ID` AS `client_id`,
      `customers`.`CompanyName` AS `client_name`,
      `customers`.`BillingAddress_Address` AS `client_address_line`,
      `customers`.`Address_City` AS `client_city`,
      NULL AS `client_state_province`,
      NULL AS `client_zip_code`,
      NULL AS `client_country`,
      NULL AS `client_email_address`,
      NULL AS `job_manager_id`,
      NULL AS `job_manager_name`,
      NULL AS `job_partner_id`,
      NULL AS `job_partner_name`,
      NULL AS `client_partner_id`,
      NULL AS `client_partner_name`,
      NULL AS `client_manager_id`,
      NULL AS `client_manager_name`,
      `invoices`.`ClientID` AS `system_client_id`,
      `invoices`.`OrganisationID` AS `system_organisation_id`,
      `invoices`.`EtlInsertTime` AS `system_etl_insert_time`,
      `invoices`.`EtlUpdateTime` AS `system_etl_update_time`,
      NULL AS `system_tenant_id`,
      NULL AS `invoice_due_date`,
      NULL AS `invoice_paid_date`,
      NULL AS `invoice_last_modified_on`,
      NULL AS `invoice_last_modified_user_id`,
      NULL AS `invoice_category`,
      NULL AS `invoice_description`,
      NULL AS `invoice_currency_code`,
      NULL AS `invoice_payment_instructions`,
      NULL AS `invoice_jobs_wip_amount`,
      NULL AS `client_key`,
      NULL AS `client_type`
    FROM (((`evadb_stage`.`c', client_id_number, '_simpro_invoices` `invoices`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_invoicesjobs` `invoices_jobs`
        ON ((`invoices`.`ID` = `invoices_jobs`.`invoicesId`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_jobs` `jobs`
        ON ((`jobs`.`ID` = `invoices_jobs`.`ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_customers` `customers`
        ON ((`customers`.`ID` = `jobs`.`Customer_ID`)))');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6842_simpro_header view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_simpro_header');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_simpro_header
    AS
    SELECT
      NULL AS `header_id`,
      `jobs`.`ID` AS `job_id`,
      `jobs`.`Description` AS `job_name`,
      NULL AS `job_description`,
      `jobs`.`Customer_ID` AS `job_client_id`,
      `jobs`.`Customer_CompanyName` AS `job_client_name`,
      NULL AS `job_client_order_number`,
      `jobs`.`Status_Name` AS `job_state`,
      `jobs`.`DateIssued` AS `job_start_date`,
      NULL AS `job_due_date`,
      NULL AS `job_completed_date`,
      `jobs`.`ID` AS `job_internal_id`,
      NULL AS `job_assigned`,
      NULL AS `job_milestones`,
      NULL AS `job_notes`,
      `jobs`.`Total_ExTax` AS `job_budget_amount`,
      NULL AS `job_contact_id`,
      NULL AS `job_contact_name`,
      NULL AS `job_manager_id`,
      NULL AS `job_manager_name`,
      NULL AS `job_partner_id`,
      NULL AS `job_partner_name`,
      `jobcost`.`CostCenter_Name` AS `job_category`,
      NULL AS `job_custom_field_1`,
      NULL AS `job_custom_field_2`,
      NULL AS `job_custom_field_3`,
      NULL AS `job_custom_field_4`,
      NULL AS `job_custom_field_5`,
      NULL AS `job_custom_field_6`,
      NULL AS `job_custom_field_7`,
      NULL AS `job_custom_field_8`,
      NULL AS `job_custom_field_9`,
      NULL AS `job_custom_field_10`,
      `sections`.`ID` AS `task_id`,
      `sections`.`Name` AS `task_name`,
      `sections`.`Description` AS `task_description`,
      NULL AS `task_estimated_minutes`,
      NULL AS `task_actual_minutes`,
      NULL AS `task_completed`,
      NULL AS `task_folder`,
      NULL AS `task_start_date`,
      NULL AS `task_due_date`,
      `emp`.`ID` AS `task_assigned_staff_id`,
      `emp`.`Name` AS `task_assigned_staff_name`,
      `times`.`TotalHrs` AS `task_assigned_staff_allocated_minutes`,
      NULL AS `task_assigned_staff`,
      NULL AS `task_percent_complete`,
      NULL AS `task_date_completed`,
      NULL AS `task_custom_field_1`,
      NULL AS `task_custom_field_2`,
      NULL AS `task_custom_field_3`,
      NULL AS `task_custom_field_4`,
      NULL AS `task_custom_field_5`,
      NULL AS `task_custom_field_6`,
      NULL AS `task_custom_field_7`,
      NULL AS `task_custom_field_8`,
      NULL AS `task_custom_field_9`,
      NULL AS `task_custom_field_10`,
      NULL AS `task_billable`,
      NULL AS `task_billable_amount`,
      CONCAT(`jobs`.`ID`, \' \', `sections`.`Name`) AS `jobid_taskname`,
      NULL AS `quoted_amount`,
      NULL AS `quoted_time`,
      NULL AS `cost`,
      `jobs`.`ClientID` AS `system_client_id`,
      `jobs`.`OrganisationID` AS `system_organisation_id`
    FROM (((((`evadb_stage`.`c', client_id_number, '_simpro_jobs` `jobs`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_jobsections` `sections`
        ON ((`jobs`.`ID` = `sections`.`JobID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_jobcostcenters` `jobcost`
        ON ((`jobs`.`ID` = `jobcost`.`Job_ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_employeetimesheets` `times`
        ON ((`jobs`.`ID` = `times`.`EmployeeID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_employees` `emp`
        ON ((`times`.`EmployeeID` = `emp`.`ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_customers` `cust`
        ON ((`jobs`.`Customer_ID` = `cust`.`ID`)))');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6842_simpro_transactions view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_simpro_transactions');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_simpro_transactions
    AS
    WITH `defaultrate`
    AS
    (SELECT
        IFNULL(`evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`CostRate`, 0) AS `CostRate`,
        IFNULL(`evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`Markup`, 0) AS `Markup`
      FROM `evadb_stage`.`c', client_id_number, '_simpro_laborrates`
      WHERE ((`evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`IsDefault` = \'true\')
      OR (`evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`IsDefault` IS NULL))
      ORDER BY `evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`Archived`, `evadb_stage`.`c', client_id_number, '_simpro_laborrates`.`ID` LIMIT 1)
    SELECT
      CONCAT(`jc_schedules`.`ID`, \'-\', IFNULL(`invoices`.`ID`, \'UNINVOICED\')) AS `transaction_id`,
      `jc_schedules`.`ID` AS `timesheet_id`,
      `staff`.`ID` AS `staff_id`,
      `staff`.`Name` AS `staff_name`,
      `customers`.`ID` AS `client_id`,
      `customers`.`CompanyName` AS `client_name`,
      NULL AS `client_group_name`,
      `jc_schedules`.`ClientID` AS `client_system_id`,
      `jc_schedules`.`OrganisationID` AS `organisation_system_id`,
      NULL AS `client_partner_name`,
      NULL AS `client_manager_name`,
      NULL AS `client_partner_id`,
      NULL AS `client_manager_id`,
      `jc_schedules`.`Date` AS `timesheet_date`,
      `jc_schedules`.`TotalHours` AS `timesheet_hours`,
      `jc_schedules`.`TotalHours` AS `timesheet_quantity`,
      `jobs`.`Description` AS `timesheet_note`,
      `cost_centers`.`Name` AS `timesheet_category`,
      `cost_centers`.`Name` AS `timesheet_type`,
      \'true\' AS `timesheet_billable`,
      IFNULL((`jc_schedules`.`TotalHours` * (`defaultrate`.`CostRate` * (1 + `defaultrate`.`Markup`))), 0) AS `timesheet_billable_amount_totalled`,
      IFNULL((`defaultrate`.`CostRate` * (1 + `defaultrate`.`Markup`)), 0) AS `timesheet_billable_rate`,
      IFNULL((`defaultrate`.`CostRate` * (1 + `defaultrate`.`Markup`)), 0) AS `timesheet_standard_charge_rate`,
      IFNULL((`jc_schedules`.`TotalHours` * (`defaultrate`.`CostRate` * (1 + `defaultrate`.`Markup`))), 0) AS `timesheet_standard_amount_totalled`,
      (CASE WHEN (`invoices`.`ID` IS NOT NULL) THEN 1 ELSE 0 END) AS `timesheet_is_invoiced`,
      \'true\' AS `timesheet_billable_without_leave`,
      `jobs`.`ID` AS `task_id`,
      `jobs`.`Description` AS `task_name`,
      NULL AS `timesheet_task_completed`,
      `jobs`.`ID` AS `job_id`,
      NULL AS `job_number`,
      `jobs`.`Description` AS `job_name`,
      `jobs`.`DateIssued` AS `job_start_date`,
      NULL AS `job_due_date`,
      `jobs`.`Status_Name` AS `job_state`,
      NULL AS `job_completed_date`,
      NULL AS `job_partner_name`,
      NULL AS `job_manager_name`,
      `invoices`.`ID` AS `invoice_id`,
      `invoices`.`ID` AS `invoice_number`,
      NULL AS `invoice_date`,
      `invoices`.`IsPaid` AS `invoice_type`,
      `invoices`.`Total_AmountApplied` AS `invoice_amount_paid`,
      `invoices`.`Total_IncTax` AS `invoice_amount_including_tax`,
      `invoices`.`Total_BalanceDue` AS `invoice_amount_outstanding`,
      `customers`.`CompanyName` AS `invoice_client_name`,
      SUM(`jc_schedules`.`TotalHours`) OVER (PARTITION BY `invoices`.`ID`, `jobs`.`ID`) AS `invoice_timesheet_hours`,
      SUM(IFNULL((`jc_schedules`.`TotalHours` * (`defaultrate`.`CostRate` * (1 + `defaultrate`.`Markup`))), 0)) OVER (PARTITION BY `invoices`.`ID`, `jobs`.`ID`) AS `invoice_timesheet_totalled`,
      NULL AS `invoice_due_date`,
      NULL AS `invoice_line_amount`,
      CONCAT(`staff`.`Name`, \'-\', `jobs`.`Description`) AS `staff_task_label`,
      NULL AS `team_name`
    FROM (((((((`evadb_stage`.`c', client_id_number, '_simpro_jobcostcentersschedules` `jc_schedules`
      LEFT JOIN `defaultrate`
        ON ((1 = 1)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_employees` `staff`
        ON ((`staff`.`ID` = `jc_schedules`.`Staff_ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_jobs` `jobs`
        ON ((`jobs`.`ID` = `jc_schedules`.`JobID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_costcenters` `cost_centers`
        ON ((`cost_centers`.`ID` = `jc_schedules`.`CostCentersID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_customers` `customers`
        ON ((`customers`.`ID` = `jobs`.`Customer_ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_invoicesjobs` `invoices_jobs`
        ON ((`invoices_jobs`.`ID` = `jobs`.`ID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_invoices` `invoices`
        ON ((`invoices`.`ID` = `invoices_jobs`.`invoicesId`)))');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6842_simpro_uniquestaffdetail view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_simpro_uniquestaffdetail');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_simpro_uniquestaffdetail
    AS
    SELECT
      `employees`.`ID` AS `staff_id`,
      COALESCE(`capacitydev`.`StaffName`, `employees`.`Name`) AS `staff_name`,
      `employees`.`PrimaryContact_Email` AS `staff_email`,
      NULL AS `staff_mobile`,
      NULL AS `staff_phone`,
      `employees`.`ClientID` AS `staff_client_id`,
      `employees`.`OrganisationID` AS `staff_organisation_id`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, \'0:00\')) / 3600) AS `mon`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, \'0:00\')) / 3600) AS `tue`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, \'0:00\')) / 3600) AS `wed`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, \'0:00\')) / 3600) AS `thu`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, \'0:00\')) / 3600) AS `fri`,
      (((((TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, \'0:00\')) + TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, \'0:00\'))) / 3600) AS `capacity_total`,
      (CAST(COALESCE(`capacitydev`.`Percent`, 0) AS decimal(5, 2)) / 100.0) AS `capacity_percent`,
      (TIME_TO_SEC(COALESCE(`capacitydev`.`Productivity`, \'0:00\')) / 3600) AS `capacity_productivity`,
      COALESCE(`capacitydev`.`BillRate`, 0) AS `capacity_bill_rate`,
      COALESCE(`capacitydev`.`BillableRate`, 0) AS `capacity_billable_rate`,
      CAST(COALESCE(`capacitydev`.`FulltimeEquivPercent`, 0) AS decimal(5, 2)) AS `capacity_fulltime_equiv_percent`,
      (CASE WHEN (`employees`.`Name` = \'Retainer\') THEN \'Retainer\' WHEN ((`capacitydev`.`Team` IS NULL) OR
          (`capacitydev`.`Team` = \'\')) THEN \'No Staff Allocation\' ELSE `capacitydev`.`Team` END) AS `capacity_team`,
      COALESCE(`capacitydev`.`Notes`, 0) AS `capacity_notes`,
      IFNULL(`capacitydev`.`Working`, 1) AS `capacity_working`,
      IFNULL(`capacitydev`.`DirectorPartner`, 0) AS `capacity_director_partner`,
      IFNULL(`capacitydev`.`FeeEarner`, 1) AS `capacity_fee_earner`,
      NULL AS `capacity_manager`,
      `timeentries`.`MinDate` AS `timeentry_start_date`,
      `timeentries`.`MaxDate` AS `timeentry_end_date`,
      NULL AS `capacity_historic_rates`,
      NULL AS `capacity_custom_task_rate`,
      NULL AS `capacity_historic_capacity`,
      NULL AS `staff_manager_user_id`,
      NULL AS `staff_partner_user_id`,
      NULL AS `staff_entity_group_id`,
      (CASE WHEN (`employees`.`Archived` = \'1\') THEN 1 ELSE 0 END) AS `staff_is_deleted`,
      `employees`.`DateModified` AS `staff_last_modified_on`,
      `capacitydev`.`EtlInsertTime` AS `capacity_created_at`,
      `capacitydev`.`EtlUpdateTime` AS `capacity_updated_at`,
      (CASE WHEN (`capacitydev`.`StaffID` IS NOT NULL) THEN \'Yes\' ELSE \'No\' END) AS `capacity_in_capacity_dev`,
      CONCAT(`employees`.`Name`, \'-\', `employees`.`OrganisationID`) AS `staff_org_id`
    FROM ((`evadb_stage`.`c', client_id_number, '_simpro_employees` `employees`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_simpro_capacitydev` `capacitydev`
        ON (((`employees`.`ID` = `capacitydev`.`StaffID`)
        AND (`employees`.`OrganisationID` = `capacitydev`.`OrganisationID`))))
      LEFT JOIN (SELECT
          `timesheet`.`EmployeeID` AS `EmployeeID`,
          `timesheet`.`OrganisationID` AS `OrganisationID`,
          DATE_FORMAT(MIN(`timesheet`.`Date`), \'%d-%b-%Y\') AS `MinDate`,
          (CASE WHEN (MAX(`timesheet`.`Date`) < (CURDATE() - INTERVAL 14 DAY)) THEN DATE_FORMAT(MAX(`timesheet`.`Date`), \'%d-%b-%Y\') ELSE NULL END) AS `MaxDate`
        FROM `evadb_stage`.`c', client_id_number, '_simpro_employeetimesheets` `timesheet`
        WHERE (`timesheet`.`EmployeeID` IS NOT NULL)
        GROUP BY `timesheet`.`EmployeeID`,
                 `timesheet`.`OrganisationID`) `timeentries`
        ON (((`employees`.`ID` = `timeentries`.`EmployeeID`)
        AND (`employees`.`OrganisationID` = `timeentries`.`OrganisationID`))))
    ORDER BY IFNULL(`capacitydev`.`Working`, 1) DESC, COALESCE(`capacitydev`.`StaffName`, `employees`.`Name`)');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Return success message
    SELECT CONCAT('Successfully created SIMPRO integration views for client: ', client_id, ' with organisation ID: ', organisation_id) AS result;
    
END$$

DELIMITER ;
