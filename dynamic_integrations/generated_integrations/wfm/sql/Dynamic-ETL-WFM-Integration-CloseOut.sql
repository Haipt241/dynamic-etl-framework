CREATE TABLE IF NOT EXISTS evadb_stage.c2104_wfm_capacitydev (
  UUID varchar(50) NOT NULL,
  StaffUUID varchar(100) DEFAULT NULL,
  StaffName varchar(255) DEFAULT NULL,
  Mon varchar(20) DEFAULT '7:36',
  Tue varchar(20) DEFAULT '7:36',
  Wed varchar(20) DEFAULT '7:36',
  Thu varchar(20) DEFAULT '7:36',
  Fri varchar(20) DEFAULT '7:36',
  Total varchar(20) DEFAULT '38:00',
  Percent varchar(10) DEFAULT '80',
  Productivity varchar(20) DEFAULT '70:00',
  Team varchar(255) DEFAULT NULL,
  BillRate decimal(18, 2) DEFAULT NULL,
  BillableRate decimal(18, 2) DEFAULT NULL,
  FulltimeEquivPercent varchar(10) DEFAULT '100',
  Notes text DEFAULT NULL,
  Working tinyint(1) DEFAULT 1,
  DirectorPartner tinyint(1) DEFAULT 0,
  FeeEarner tinyint(1) DEFAULT 1,
  SourceSystemName varchar(100) DEFAULT 'API',
  CaptureLog text DEFAULT NULL,
  OrganisationID int DEFAULT NULL,
  IntegrationRunID int DEFAULT NULL,
  EtlInsertTime timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  EtlUpdateTime timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (UUID)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_0900_ai_ci,
ROW_FORMAT = DYNAMIC;



DROP VIEW IF EXISTS evadb.bigoleshoecompany_client2104_wfm_header CASCADE;

DROP VIEW IF EXISTS evadb.bigoleshoecompany_client2104_wfm_invoices CASCADE;

DROP VIEW IF EXISTS evadb.bigoleshoecompany_client2104_wfm_transactions CASCADE;

DROP VIEW IF EXISTS evadb.bigoleshoecompany_client2104_wfm_uniquestaffdetail CASCADE;

CREATE VIEW evadb.bigoleshoecompany_client2104_wfm_uniquestaffdetail
AS
SELECT
  `staff`.`Id` AS `staff_id`,
  COALESCE(`capacitydev`.`StaffName`, CONCAT(`staff`.`FirstName`, ' ', `staff`.`LastName`)) AS `staff_name`,
  `staff`.`ContactdetailsEmail` AS `staff_email`,
  `staff`.`ContactdetailsMobile` AS `staff_mobile`,
  `staff`.`ContactdetailsPhone` AS `staff_phone`,
  `staff`.`ClientID` AS `staff_client_id`,
  `staff`.`OrganisationID` AS `staff_organisation_id`,
  (TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, '0:00')) / 3600) AS `mon`,
  (TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, '0:00')) / 3600) AS `tue`,
  (TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, '0:00')) / 3600) AS `wed`,
  (TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, '0:00')) / 3600) AS `thu`,
  (TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, '0:00')) / 3600) AS `fri`,
  (((((TIME_TO_SEC(COALESCE(`capacitydev`.`Mon`, '0:00')) + TIME_TO_SEC(COALESCE(`capacitydev`.`Tue`, '0:00'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Wed`, '0:00'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Thu`, '0:00'))) + TIME_TO_SEC(COALESCE(`capacitydev`.`Fri`, '0:00'))) / 3600) AS `capacity_total`,
  (COALESCE(`capacitydev`.`Percent`, 0) / 100.0) AS `capacity_percent`,
  COALESCE(`capacitydev`.`Productivity`, 0) AS `capacity_productivity`,
  COALESCE(`capacitydev`.`BillRate`, 0) AS `capacity_bill_rate`,
  COALESCE(`capacitydev`.`BillableRate`, 0) AS `capacity_billable_rate`,
  COALESCE(`capacitydev`.`FulltimeEquivPercent`, 0) AS `capacity_fulltime_equiv_percent`,
  (CASE WHEN (CONCAT(`staff`.`FirstName`, ' ', `staff`.`LastName`) = 'Retainer') THEN 'Retainer' WHEN ((`capacitydev`.`Team` IS NULL) OR
      (`capacitydev`.`Team` = '')) THEN 'No Staff Allocation' ELSE `capacitydev`.`Team` END) AS `capacity_team`,
  COALESCE(`capacitydev`.`Notes`, 0) AS `capacity_notes`,
  IFNULL(`capacitydev`.`Working`, `staff`.`CurrentlyWorking`) AS `capacity_working`,
  IFNULL(`capacitydev`.`DirectorPartner`, `staff`.`Director`) AS `capacity_director_partner`,
  IFNULL(`capacitydev`.`FeeEarner`, `staff`.`FreeEarner`) AS `capacity_fee_earner`,
  0 AS `capacity_manager`,
  `timeentries`.`MinDate` AS `timeentry_start_date`,
  `timeentries`.`MaxDate` AS `timeentry_end_date`,
  NULL AS `capacity_historic_rates`,
  NULL AS `capacity_custom_task_rate`,
  NULL AS `capacity_historic_capacity`,
  NULL AS `staff_manager_user_id`,
  NULL AS `staff_partner_user_id`,
  NULL AS `staff_entity_group_id`,
  (CASE WHEN (`staff`.`DeletedAt` IS NOT NULL) THEN 1 ELSE 0 END) AS `staff_is_deleted`,
  `staff`.`UpdatedAt` AS `staff_last_modified_on`,
  `capacitydev`.`EtlInsertTime` AS `capacity_created_at`,
  `capacitydev`.`EtlUpdateTime` AS `capacity_updated_at`,
  (CASE WHEN (`capacitydev`.`StaffUUID` IS NOT NULL) THEN 'Yes' ELSE 'No' END) AS `capacity_in_capacity_dev`,
  CONCAT(`staff`.`FirstName`, ' ', `staff`.`LastName`, '-', `staff`.`OrganisationID`) AS `staff_org_id`
FROM ((`evadb_stage`.`c2104_wfm_staff` `staff`
  LEFT JOIN `evadb_stage`.`c2104_wfm_capacitydev` `capacitydev`
    ON (((`staff`.`Id` = `capacitydev`.`StaffUUID`)
    AND (`staff`.`OrganisationID` = `capacitydev`.`OrganisationID`))))
  LEFT JOIN (SELECT
      `t`.`StaffUuid` AS `StaffUuid`,
      `t`.`OrganisationID` AS `OrganisationID`,
      DATE_FORMAT(MIN(`t`.`Date`), '%d-%b-%Y') AS `MinDate`,
      (CASE WHEN (MAX(`t`.`Date`) < (CURDATE() - INTERVAL 14 DAY)) THEN DATE_FORMAT(MAX(`t`.`Date`), '%d-%b-%Y') ELSE NULL END) AS `MaxDate`
    FROM `evadb_stage`.`c2104_wfm_timesheets` `t`
    WHERE (`t`.`StaffUuid` IS NOT NULL)
    GROUP BY `t`.`StaffUuid`,
             `t`.`OrganisationID`) `timeentries`
    ON (((`staff`.`Id` = `timeentries`.`StaffUuid`)
    AND (`staff`.`OrganisationID` = `timeentries`.`OrganisationID`))))
ORDER BY CONCAT(`staff`.`FirstName`, ' ', `staff`.`LastName`);

CREATE VIEW evadb.bigoleshoecompany_client2104_wfm_transactions
AS
SELECT
  CONCAT('TS-', `timesheets`.`Id`) AS `transaction_id`,
  `timesheets`.`Id` AS `timesheet_id`,
  `timesheets`.`StaffUuid` AS `staff_id`,
  CONCAT(`timesheets`.`StaffFirstname`, ' ', `timesheets`.`StaffLastname`) AS `staff_name`,
  NULL AS `client_group_name`,
  `clients`.`Name` AS `client_name`,
  `timesheets`.`Billable` AS `timesheet_billable`,
  ROUND((ROUND((`timesheets`.`Time` / 60.0), 2) * COALESCE(`job_tasks`.`Custombillablerate`, `capacity`.`BillableRate`, 0)), 2) AS `timesheet_billable_amount_totalled`,
  COALESCE(`job_tasks`.`Custombillablerate`, `capacity`.`BillableRate`) AS `timesheet_billable_rate`,
  FALSE AS `timesheet_is_invoiced`,
  `timesheets`.`Date` AS `timesheet_date`,
  'Time' AS `timesheet_type`,
  ROUND((`timesheets`.`Time` / 60.0), 2) AS `timesheet_quantity`,
  `capacity`.`BillRate` AS `timesheet_standard_charge_rate`,
  NULL AS `timesheet_category`,
  `timesheets`.`Note` AS `timesheet_note`,
  ROUND((`timesheets`.`Time` / 60.0), 2) AS `timesheet_hours`,
  ROUND((ROUND((`timesheets`.`Time` / 60.0), 2) * COALESCE(`capacity`.`BillRate`, 0)), 2) AS `timesheet_standard_amount_totalled`,
  `timesheets`.`JobtaskUuid` AS `task_id`,
  COALESCE(`timesheets`.`JobtaskName`, `job_tasks`.`Name`) AS `task_name`,
  `job_tasks`.`Completed` AS `timesheet_task_completed`,
  `timesheets`.`JobUuid` AS `job_id`,
  `timesheets`.`JobJobnumber` AS `job_number`,
  `timesheets`.`JobName` AS `job_name`,
  `jobs`.`StartDate` AS `job_start_date`,
  `jobs`.`DueDate` AS `job_due_date`,
  `job_status`.`Name` AS `job_state`,
  `jobs`.`CompletedDate` AS `job_completed_date`,
  NULL AS `job_partner_name`,
  CONCAT(`job_manager`.`FirstName`, ' ', `job_manager`.`LastName`) AS `job_manager_name`,
  NULL AS `invoice_id`,
  NULL AS `invoice_number`,
  NULL AS `invoice_due_date`,
  NULL AS `invoice_type`,
  NULL AS `invoice_amount_paid`,
  NULL AS `invoice_amount_including_tax`,
  NULL AS `invoice_amount_outstanding`,
  NULL AS `invoice_date`,
  NULL AS `invoice_timesheet_hours`,
  NULL AS `invoice_timesheet_totalled`,
  NULL AS `invoice_client_name`,
  NULL AS `timesheet_billable_without_leave`,
  CONCAT(`timesheets`.`StaffFirstname`, ' ', `timesheets`.`StaffLastname`, '-', COALESCE(`timesheets`.`JobtaskName`, `job_tasks`.`Name`)) AS `staff_task_label`,
  `timesheets`.`ClientID` AS `client_system_id`,
  `timesheets`.`OrganisationID` AS `organisation_system_id`,
  `clients`.`Id` AS `client_id`,
  `client_partner`.`Id` AS `client_partner_id`,
  `client_partner`.`Name` AS `client_partner_name`,
  `clients`.`ClientManagerUUID` AS `client_manager_id`,
  CONCAT(`client_manager`.`FirstName`, ' ', `client_manager`.`LastName`) AS `client_manager_name`,
  `capacity`.`Team` AS `team_name`
FROM (((((((((`evadb_stage`.`c2104_wfm_timesheets` `timesheets`
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobs` `jobs`
    ON (((`jobs`.`Id` = `timesheets`.`JobUuid`)
    AND (`jobs`.`OrganisationID` = `timesheets`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_staff` `job_manager`
    ON (((`job_manager`.`Id` = `jobs`.`JobManagerUuid`)
    AND (`job_manager`.`OrganisationID` = `jobs`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobstatus` `job_status`
    ON (((`job_status`.`Id` = `jobs`.`JobStatusUuid`)
    AND (`job_status`.`OrganisationID` = `jobs`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobstasks` `job_tasks`
    ON (((`job_tasks`.`Uuid` = `timesheets`.`JobtaskUuid`)
    AND (`job_tasks`.`OrganisationID` = `timesheets`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_clients` `clients`
    ON (((`clients`.`Id` = `jobs`.`ClientUuid`)
    AND (`clients`.`OrganisationID` = `timesheets`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_capacitydev` `capacity`
    ON (((`capacity`.`StaffUUID` = `timesheets`.`StaffUuid`)
    AND (`capacity`.`OrganisationID` = `timesheets`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_staff` `client_manager`
    ON (((`client_manager`.`Id` = `clients`.`ClientManagerUUID`)
    AND (`client_manager`.`OrganisationID` = `clients`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_clientsclientrel` `client_rel`
    ON (((`client_rel`.`clientsId` = `clients`.`Id`)
    AND (`client_rel`.`OrganisationID` = `clients`.`OrganisationID`)
    AND (`client_rel`.`Type` = 'Partner'))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_clients` `client_partner`
    ON (((`client_partner`.`Id` = `client_rel`.`Relatedclientuuid`)
    AND (`client_partner`.`OrganisationID` = `client_rel`.`OrganisationID`))))
WHERE EXISTS (SELECT
    1
  FROM `evadb_stage`.`c2104_wfm_invoicesjobstasks` `ijt`
  WHERE ((`ijt`.`Jobtaskuuid` = `timesheets`.`JobtaskUuid`)
  AND (`ijt`.`OrganisationID` = `timesheets`.`OrganisationID`))) IS FALSE;

CREATE VIEW evadb.bigoleshoecompany_client2104_wfm_invoices
AS
SELECT
  `invoices`.`Id` AS `invoice_id`,
  `invoices`.`ClientID` AS `system_client_id`,
  `invoices`.`OrganisationID` AS `system_organisation_id`,
  NULL AS `system_tenant_id`,
  `invoices`.`Date` AS `invoice_date`,
  `invoices`.`DueDate` AS `invoice_due_date`,
  `invoices`.`DatePaid` AS `invoice_paid_date`,
  `invoices`.`UpdatedAt` AS `invoice_last_modified_on`,
  NULL AS `invoice_last_modified_user_id`,
  `invoices`.`InvoiceNumber` AS `invoice_number`,
  NULL AS `invoice_category`,
  `invoices`.`Type` AS `invoice_type`,
  `invoices`.`Description` AS `invoice_description`,
  `invoices`.`Status` AS `invoice_status`,
  NULL AS `invoice_currency_code`,
  NULL AS `invoice_payment_instructions`,
  `invoices`.`AmountExTax` AS `invoice_amount`,
  NULL AS `invoice_amount_sub_total`,
  NULL AS `invoice_amount_tax`,
  `invoices`.`AmountIncTax` AS `invoice_amount_including_tax`,
  `invoices`.`AmountPaid` AS `invoice_amount_paid`,
  (`invoices`.`AmountIncTax` - `invoices`.`AmountPaid`) AS `invoice_amount_outstanding`,
  `invoices`.`FixedPrice` AS `invoice_total_amount`,
  NULL AS `job_id`,
  NULL AS `job_name`,
  NULL AS `job_manager_id`,
  NULL AS `job_manager_name`,
  NULL AS `job_partner_id`,
  NULL AS `job_partner_name`,
  NULL AS `invoice_jobs_amount`,
  NULL AS `invoice_jobs_wip_amount`,
  `clients`.`Id` AS `client_id`,
  NULL AS `client_key`,
  NULL AS `client_type`,
  `invoices`.`ContactUUID` AS `contact_id`,
  `clients`.`Name` AS `client_name`,
  NULL AS `client_address_line`,
  NULL AS `client_city`,
  NULL AS `client_state_province`,
  NULL AS `client_zip_code`,
  NULL AS `client_country`,
  `clients`.`ContactdetailsEmail` AS `client_email_address`,
  `clientpartner`.`Id` AS `client_partner_id`,
  `clientpartner`.`Name` AS `client_partner_name`,
  `clients`.`ClientManagerUUID` AS `client_manager_id`,
  CONCAT_WS(' ', `client_manager`.`FirstName`, `client_manager`.`LastName`) AS `client_manager_name`,
  `invoices`.`EtlInsertTime` AS `system_etl_insert_time`,
  `invoices`.`EtlUpdateTime` AS `system_etl_update_time`,
  `invoices`.`CreatedAt` AS `invoice_created_at`,
  `invoices`.`Sent` AS `invoice_sent`,
  `invoices`.`Mode` AS `invoice_mode`,
  `invoices`.`ProgressDate` AS `invoice_progress_date`
FROM ((((`evadb_stage`.`c2104_wfm_invoices` `invoices`
  LEFT JOIN `evadb_stage`.`c2104_wfm_clients` `clients`
    ON ((`invoices`.`ClientUUID` = `clients`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2104_wfm_clientsclientrel` `clientrel`
    ON (((`clientrel`.`Relatedclientuuid` = `clients`.`Id`)
    AND (`clientrel`.`OrganisationID` = `clients`.`OrganisationID`)
    AND (`clientrel`.`Type` = 'Partner'))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_clients` `clientpartner`
    ON (((`clientpartner`.`Id` = `clientrel`.`Relatedclientuuid`)
    AND (`clientpartner`.`OrganisationID` = `clientrel`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2104_wfm_staff` `client_manager`
    ON ((`clients`.`ClientManagerUUID` = `client_manager`.`Id`)));

CREATE VIEW evadb.bigoleshoecompany_client2104_wfm_header
AS
SELECT
  NULL AS `header_id`,
  `job`.`Id` AS `job_id`,
  `job`.`JobNumber` AS `job_internal_id`,
  `job`.`Name` AS `job_name`,
  `job`.`Description` AS `job_description`,
  `job`.`ClientUuid` AS `job_client_id`,
  `client`.`Name` AS `job_client_name`,
  `job`.`ClientOrderNumber` AS `job_client_order_number`,
  `jobstatus`.`Name` AS `job_state`,
  `job`.`StartDate` AS `job_start_date`,
  `job`.`DueDate` AS `job_due_date`,
  `job`.`CompletedDate` AS `job_completed_date`,
  `job`.`Budget` AS `job_budget_amount`,
  `job`.`JobManagerUuid` AS `job_manager_id`,
  NULL AS `job_manager_name`,
  `job`.`ClientManagerUuid` AS `job_partner_id`,
  NULL AS `job_partner_name`,
  `job`.`JobCategoryUuid` AS `job_category_id`,
  `jobcat`.`Name` AS `job_category`,
  NULL AS `job_notes`,
  `job`.`ClientID` AS `system_client_id`,
  `job`.`OrganisationID` AS `system_organisation_id`,
  `task`.`Uuid` AS `task_id`,
  `task`.`Name` AS `task_name`,
  `task`.`Description` AS `task_description`,
  `task`.`Estimatedminutes` AS `task_estimated_minutes`,
  `task`.`Actualminutes` AS `task_actual_minutes`,
  `task`.`Completed` AS `task_completed`,
  NULL AS `task_folder`,
  `task`.`Startdate` AS `task_start_date`,
  `task`.`Duedate` AS `task_due_date`,
  NULL AS `task_assigned_staff_id`,
  NULL AS `task_assigned_staff_name`,
  NULL AS `task_assigned_staff_allocated_minutes`,
  NULL AS `task_assigned_staff`,
  `task`.`Billable` AS `task_billable`,
  `task`.`Custombillablerate` AS `task_billable_amount`,
  NULL AS `task_percent_complete`,
  NULL AS `task_date_completed`,
  CONCAT(`job`.`Id`, ' ', `task`.`Name`) AS `jobid_taskname`,
  NULL AS `job_contact_id`,
  NULL AS `job_contact_name`,
  NULL AS `job_assigned`,
  NULL AS `job_milestones`,
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
  NULL AS `quoted_amount`,
  NULL AS `quoted_time`,
  NULL AS `cost`
FROM ((((`evadb_stage`.`c2104_wfm_jobs` `job`
  LEFT JOIN `evadb_stage`.`c2104_wfm_clients` `client`
    ON ((`job`.`ClientUuid` = `client`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobstatus` `jobstatus`
    ON ((`job`.`JobStatusUuid` = `jobstatus`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobcategories` `jobcat`
    ON ((`job`.`JobCategoryUuid` = `jobcat`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2104_wfm_jobstasks` `task`
    ON ((`job`.`Id` = `task`.`jobsId`)));