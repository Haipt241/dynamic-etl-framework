DELIMITER $$

DROP PROCEDURE IF EXISTS `Dynamic-ETL-KARBON_HQ-Integration-CloseOut`$$

CREATE PROCEDURE `Dynamic-ETL-KARBON_HQ-Integration-CloseOut`(
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
    
    -- Create c6843_karbon_hq_capacitydev table if it doesn't exist
    SET @sql_stmt = CONCAT('CREATE TABLE IF NOT EXISTS evadb_stage.c', client_id_number, '_karbon_hq_capacitydev (
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
    AUTO_INCREMENT = 13,
    AVG_ROW_LENGTH = 1365,
    CHARACTER SET utf8mb4,
    COLLATE utf8mb4_0900_ai_ci,
    ROW_FORMAT = DYNAMIC');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6843_karbon_hq_invoices view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_karbon_hq_invoices');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_karbon_hq_invoices
    AS
    SELECT
      `invoice`.`InvoiceKey` AS `invoice_id`,
      `invoice`.`ClientID` AS `client_system_id`,
      `invoice`.`OrganisationID` AS `organisation_system_id`,
      NULL AS `system_tenant_id`,
      `invoice`.`InvoiceDate` AS `invoice_date`,
      `invoice`.`PaymentDueDate` AS `invoice_due_date`,
      NULL AS `invoice_paid_date`,
      `invoice`.`UpdatedAt` AS `invoice_last_modified_on`,
      NULL AS `invoice_last_modified_user_id`,
      `invoice`.`InvoiceNumber` AS `invoice_number`,
      NULL AS `invoice_category`,
      NULL AS `invoice_type`,
      NULL AS `invoice_description`,
      `invoice`.`InvoiceStatus` AS `invoice_status`,
      `invoice`.`CurrencyCode` AS `invoice_currency_code`,
      `invoice`.`PaymentInstructions` AS `invoice_payment_instructions`,
      NULL AS `invoice_amount`,
      `invoice`.`InvoiceSubTotal` AS `invoice_amount_sub_total`,
      `invoice`.`InvoiceTaxTotal` AS `invoice_amount_tax`,
      NULL AS `invoice_amount_including_tax`,
      NULL AS `invoice_amount_paid`,
      `invoice`.`TotalAmountDue` AS `invoice_amount_outstanding`,
      `invoice`.`InvoiceTotal` AS `invoice_total_amount`,
      NULL AS `job_id`,
      NULL AS `job_name`,
      NULL AS `job_manager_id`,
      NULL AS `job_manager_name`,
      NULL AS `job_partner_id`,
      NULL AS `job_partner_name`,
      NULL AS `invoice_jobs_amount`,
      NULL AS `invoice_jobs_wip_amount`,
      `invoice`.`ClientClientkey` AS `client_id`,
      `invoice`.`ClientClientkey` AS `client_key`,
      `invoice`.`ClientClienttype` AS `client_type`,
      `invoice`.`ClientName` AS `client_name`,
      `invoice`.`ClientAddressline` AS `client_address_line`,
      `invoice`.`ClientCity` AS `client_city`,
      `invoice`.`ClientStateprovincecounty` AS `client_state_province`,
      `invoice`.`ClientZipcode` AS `client_zip_code`,
      `invoice`.`ClientCountry` AS `client_country`,
      `invoice`.`ClientEmailaddress` AS `client_email_address`,
      NULL AS `client_partner_id`,
      NULL AS `client_partner_name`,
      NULL AS `client_manager_id`,
      NULL AS `client_manager_name`,
      `invoice`.`EtlInsertTime` AS `system_etl_insert_time`,
      `invoice`.`EtlUpdateTime` AS `system_etl_update_time`,
      NULL AS `invoice_created_at`,
      NULL AS `invoice_sent`,
      NULL AS `invoice_mode`,
      NULL AS `invoice_progress_date`
    FROM `evadb_stage`.`c', client_id_number, '_karbon_hq_invoices` `invoice`');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6843_karbon_hq_header view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_karbon_hq_header');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_karbon_hq_header
    AS
    SELECT
      NULL AS `header_id`,
      `work`.`WorkItemKey` AS `job_id`,
      `work`.`Title` AS `job_name`,
      NULL AS `job_description`,
      `work`.`ClientKey` AS `job_client_id`,
      `work`.`ClientName` AS `job_client_name`,
      NULL AS `job_client_order_number`,
      `work`.`WorkStatus` AS `job_state`,
      `work`.`StartDate` AS `job_start_date`,
      `work`.`DueDate` AS `job_due_date`,
      `work`.`CompletedDate` AS `job_completed_date`,
      `work`.`WorkItemKey` AS `job_internal_id`,
      NULL AS `job_assigned`,
      NULL AS `job_milestones`,
      NULL AS `job_notes`,
      `work`.`EstimatedBudget` AS `job_budget_amount`,
      NULL AS `job_contact_id`,
      NULL AS `job_contact_name`,
      `work`.`AssigneeKey` AS `job_manager_id`,
      `work`.`AssigneeName` AS `job_manager_name`,
      NULL AS `job_partner_id`,
      NULL AS `job_partner_name`,
      `work`.`WorkType` AS `job_category`,
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
      NULL AS `task_id`,
      NULL AS `task_name`,
      NULL AS `task_description`,
      NULL AS `task_estimated_minutes`,
      NULL AS `task_actual_minutes`,
      NULL AS `task_completed`,
      NULL AS `task_folder`,
      NULL AS `task_start_date`,
      NULL AS `task_due_date`,
      NULL AS `task_assigned_staff_id`,
      NULL AS `task_assigned_staff_name`,
      NULL AS `task_assigned_staff_allocated_minutes`,
      NULL AS `task_assigned_staff`,
      NULL AS `task_percent_complete`,
      NULL AS `task_date_completed`,
      NULL AS `task_billable`,
      NULL AS `task_billable_amount`,
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
      CONCAT(`work`.`WorkItemKey`, \' \', `work`.`Title`) AS `jobid_taskname`,
      NULL AS `quoted_amount`,
      NULL AS `quoted_time`,
      NULL AS `cost`,
      `work`.`ClientID` AS `system_client_id`,
      `work`.`OrganisationID` AS `system_organisation_id`
    FROM (((`evadb_stage`.`c', client_id_number, '_karbon_hq_workitems` `work`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_contacts` `contact`
        ON ((`work`.`ClientKey` = `contact`.`ContactKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_organizations` `org`
        ON ((`work`.`ClientKey` = `org`.`OrganizationKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_users` `user`
        ON ((`work`.`AssigneeEmailAddress` = `user`.`EmailAddress`)))');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6843_karbon_hq_transactions_blend view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_karbon_hq_transactions_blend');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_karbon_hq_transactions_blend
    AS
    SELECT
      `time_entries`.`TimeEntryKey` AS `transaction_id`,
      `timesheets`.`TimesheetKey` AS `timesheet_id`,
      `timesheets`.`UserKey` AS `staff_id`,
      `users`.`Name` AS `staff_name`,
      `organization`.`FullName` AS `client_name`,
      `client_groups`.`FullName` AS `client_group_name`,
      `contacts`.`ContactKey` AS `client_system_id`,
      `time_entries`.`OrganisationID` AS `organisation_system_id`,
      (CASE WHEN (`invoices`.`InvoiceKey` IS NOT NULL) THEN 1 WHEN (`time_entries`.`ClientKey` IS NOT NULL) THEN 1 ELSE 0 END) AS `timesheet_billable`,
      ROUND((`time_entries`.`Minutes` / 60.0), 2) AS `timesheet_hours`,
      ROUND((`time_entries`.`Minutes` / 60.0), 2) AS `timesheet_quantity`,
      `time_entries`.`HourlyRate` AS `timesheet_standard_charge_rate`,
      ROUND(((`time_entries`.`Minutes` / 60.0) * `time_entries`.`HourlyRate`), 2) AS `timesheet_standard_amount_totalled`,
      `time_entries`.`HourlyRate` AS `timesheet_billable_rate`,
      ROUND(((`time_entries`.`Minutes` / 60.0) * `time_entries`.`HourlyRate`), 2) AS `timesheet_billable_amount_totalled`,
      `timesheets`.`StartDate` AS `timesheet_date`,
      `time_entries`.`TaskTypeName` AS `timesheet_type`,
      `time_entries`.`Descriptions` AS `timesheet_note`,
      `time_entries`.`ClientType` AS `timesheet_category`,
      `time_entries`.`WorkItemKey` AS `task_id`,
      `work_items`.`Title` AS `task_name`,
      NULL AS `timesheet_task_completed`,
      `time_entries`.`WorkItemKey` AS `job_id`,
      `work_items`.`WorkTemplateTile` AS `job_number`,
      `work_items`.`Title` AS `job_name`,
      `work_items`.`StartDate` AS `job_start_date`,
      `work_items`.`DueDate` AS `job_due_date`,
      `work_items`.`WorkStatus` AS `job_state`,
      `work_items`.`CompletedDate` AS `job_completed_date`,
      NULL AS `job_partner_name`,
      `work_items`.`AssigneeName` AS `job_manager_name`,
      `invoices`.`InvoiceNumber` AS `invoice_number`,
      `invoices`.`PaymentDueDate` AS `invoice_due_date`,
      `invoices`.`InvoiceStatus` AS `invoice_type`,
      (`invoices`.`InvoiceTotal` - `invoices`.`TotalAmountDue`) AS `invoice_amount_paid`,
      `invoices`.`InvoiceTotal` AS `invoice_amount_including_tax`,
      `invoices`.`TotalAmountDue` AS `invoice_amount_outstanding`,
      `invoices`.`InvoiceDate` AS `invoice_date`,
      NULL AS `invoice_task_id`,
      NULL AS `invoice_billable_rate`,
      NULL AS `invoice_line_amount`,
      (CASE WHEN (`invoices`.`InvoiceKey` IS NOT NULL) THEN SUM(ROUND((`time_entries`.`Minutes` / 60.0), 2)) OVER (PARTITION BY `invoices`.`InvoiceKey`) ELSE NULL END) AS `invoice_timesheet_hours`,
      (CASE WHEN (`invoices`.`InvoiceKey` IS NOT NULL) THEN SUM(ROUND(((`time_entries`.`Minutes` / 60.0) * `time_entries`.`HourlyRate`), 2)) OVER (PARTITION BY `invoices`.`InvoiceKey`) ELSE NULL END) AS `invoice_timesheet_totalled`,
      `organization`.`FullName` AS `invoice_client_name`,
      CONCAT(`users`.`Name`, \'-\', `work_items`.`Title`) AS `staff_task_label`,
      (CASE WHEN (`time_entries`.`TaskTypeName` LIKE \'%Leave%\') THEN \'NA\' WHEN (`time_entries`.`TaskTypeName` LIKE \'%Holiday%\') THEN \'NA\' WHEN (`time_entries`.`ClientType` = \'Internal\') THEN \'Internal\' WHEN (`invoices`.`InvoiceKey` IS NOT NULL) THEN \'Billable\' WHEN (`time_entries`.`ClientKey` IS NOT NULL) THEN \'Billable\' ELSE \'UNKNOWN\' END) AS `timesheet_billable_without_leave`,
      `organization`.`OrganizationKey` AS `client_id`,
      `partner_user`.`Name` AS `client_partner_name`,
      `manager_user`.`Name` AS `client_manager_name`,
      `partner_user`.`Id` AS `client_partner_id`,
      `manager_user`.`Id` AS `client_manager_id`,
      NULL AS `team_name`
    FROM (((((((((((`evadb_stage`.`c', client_id_number, '_karbon_hq_timesheetstimeentries` `time_entries`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_organizations` `organization`
        ON ((`organization`.`OrganizationKey` = `time_entries`.`ClientKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_timesheets` `timesheets`
        ON ((`timesheets`.`TimesheetKey` = `time_entries`.`TimesheetKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_users` `users`
        ON ((`users`.`Id` = `timesheets`.`UserKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_workitems` `work_items`
        ON ((`work_items`.`WorkItemKey` = `time_entries`.`WorkItemKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_invoices` `invoices`
        ON ((`invoices`.`ClientID` = `work_items`.`ClientID`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_contacts` `contacts`
        ON ((`contacts`.`OrganisationID` = `organization`.`OrganizationKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_clientgroupsmembers` `group_members`
        ON ((`group_members`.`ContactKey` = `contacts`.`ContactKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_clientgroups` `client_groups`
        ON ((`client_groups`.`ClientGroupKey` = `group_members`.`ClientGroupKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_clientgroupsdetails` `group_details`
        ON ((`group_details`.`ClientGroupKey` = `client_groups`.`ClientGroupKey`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_users` `manager_user`
        ON ((`manager_user`.`EmailAddress` = `contacts`.`ClientManager`)))
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_hq_users` `partner_user`
        ON ((`partner_user`.`EmailAddress` = `contacts`.`ClientOwner`)))');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop and create bigoleshoecompany_client6843_karbon_hq_uniquestaffdetail view
    SET @sql_stmt = CONCAT('DROP VIEW IF EXISTS evadb.', view_prefix, '_karbon_hq_uniquestaffdetail');
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @sql_stmt = CONCAT('
    CREATE VIEW evadb.', view_prefix, '_karbon_hq_uniquestaffdetail
    AS
    SELECT
      `users`.`Id` AS `staff_id`,
      COALESCE(`capacitydev`.`StaffName`, `users`.`Name`) AS `staff_name`,
      `users`.`EmailAddress` AS `staff_email`,
      NULL AS `staff_mobile`,
      NULL AS `staff_phone`,
      `users`.`ClientID` AS `staff_client_id`,
      `users`.`OrganisationID` AS `staff_organisation_id`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, \'0:00\')) / 3600) END) AS `mon`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, \'0:00\')) / 3600) END) AS `tue`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, \'0:00\')) / 3600) END) AS `wed`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, \'0:00\')) / 3600) END) AS `thu`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, \'0:00\')) / 3600) END) AS `fri`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (((((TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, \'0:00\')) + TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, \'0:00\'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, \'0:00\'))) / 3600) END) AS `capacity_total`,
      (CAST(COALESCE(`capacitydev`.`Percent`, 0) AS decimal(5, 2)) / 100.0) AS `capacity_percent`,
      (CASE WHEN (IFNULL(`capacitydev`.`Working`, 1) = 0) THEN 0 ELSE (TIME_TO_SEC(COALESCE(`capacitydev`.`Productivity`, \'0:00\')) / 3600) END) AS `capacity_productivity_hours`,
      COALESCE(`capacitydev`.`BillRate`, 0) AS `capacity_bill_rate`,
      COALESCE(`capacitydev`.`BillableRate`, 0) AS `capacity_billable_rate`,
      CAST(COALESCE(`capacitydev`.`FulltimeEquivPercent`, 0) AS decimal(5, 2)) AS `capacity_fulltime_equiv_percent`,
      (CASE WHEN (`users`.`Name` = \'Retainer\') THEN \'Retainer\' WHEN ((`capacitydev`.`Team` IS NULL) OR
          (`capacitydev`.`Team` = \'\')) THEN \'No Staff Allocation\' ELSE `capacitydev`.`Team` END) AS `capacity_team`,
      COALESCE(`capacitydev`.`Notes`, 0) AS `capacity_notes`,
      IFNULL(`capacitydev`.`Working`, 1) AS `capacity_working`,
      IFNULL(`capacitydev`.`DirectorPartner`, 0) AS `capacity_director_partner`,
      IFNULL(`capacitydev`.`FeeEarner`, 1) AS `capacity_fee_earner`,
      0 AS `capacity_manager`,
      `timeentries`.`MinDate` AS `timeentry_start_date`,
      `timeentries`.`MaxDate` AS `timeentry_end_date`,
      NULL AS `capacity_historic_rates`,
      NULL AS `capacity_custom_task_rate`,
      NULL AS `capacity_historic_capacity`,
      NULL AS `staff_manager_user_id`,
      NULL AS `staff_partner_user_id`,
      NULL AS `staff_entity_group_id`,
      NULL AS `staff_is_deleted`,
      `users`.`EtlUpdateTime` AS `staff_last_modified_on`,
      `capacitydev`.`EtlInsertTime` AS `capacity_created_at`,
      `capacitydev`.`EtlUpdateTime` AS `capacity_updated_at`,
      (CASE WHEN (`capacitydev`.`StaffID` IS NOT NULL) THEN \'Yes\' ELSE \'No\' END) AS `capacity_in_capacity_dev`,
      CONCAT(`users`.`Name`, \'-\', `users`.`OrganisationID`) AS `staff_org_id`
    FROM ((`evadb_stage`.`c', client_id_number, '_karbon_hq_users` `users`
      LEFT JOIN `evadb_stage`.`c', client_id_number, '_karbon_capacitydev` `capacitydev`
        ON (((`users`.`Id` = `capacitydev`.`StaffID`)
        AND (`users`.`OrganisationID` = `capacitydev`.`OrganisationID`))))
      LEFT JOIN (SELECT
          `timesheet`.`UserKey` AS `UserId`,
          `timesheet`.`OrganisationID` AS `OrganisationID`,
          DATE_FORMAT(MIN(`timesheet`.`StartDate`), \'%d-%b-%Y\') AS `MinDate`,
          (CASE WHEN (MAX(`timesheet`.`EndDate`) < (CURDATE() - INTERVAL 14 DAY)) THEN DATE_FORMAT(MAX(`timesheet`.`EndDate`), \'%d-%b-%Y\') ELSE NULL END) AS `MaxDate`
        FROM `evadb_stage`.`c', client_id_number, '_karbon_hq_timesheets` `timesheet`
        WHERE (`timesheet`.`UserKey` IS NOT NULL)
        GROUP BY `timesheet`.`UserKey`,
                 `timesheet`.`OrganisationID`) `timeentries`
        ON (((`users`.`Id` = `timeentries`.`UserId`)
        AND (`users`.`OrganisationID` = `timeentries`.`OrganisationID`))))
    ORDER BY IFNULL(`capacitydev`.`Working`, 1) DESC, COALESCE(`capacitydev`.`StaffName`, `users`.`Name`)');
    
    PREPARE stmt FROM @sql_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Return success message
    SELECT CONCAT('Successfully created KARBON integration views for client: ', client_id, ' with organisation ID: ', organisation_id) AS result;
    
END$$

DELIMITER ;
