/*
Create the following MySQL views in evadb database using stored procedure - "Dynamic-ETL-FYI-Integration-CloseOut"
- bigoleshoecompany_client2033_fyi_invoices
- bigoleshoecompany_client2033_fyi_header
- bigoleshoecompany_client2033_fyi_transactions_blend
- bigoleshoecompany_client2033_fyi_uniquestaffdetail

The stored procedure - "Dynamic-ETL-FYI-Integration-CloseOut will have the following parameters:
- client_id_number
- etani_organisation_id

and will have to use the query:
SELECT
    CAST(CONCAT(UPPER(af.Code),'_CLIENT',IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')),c.id)) AS CHAR(255)) AS ClientID,
    CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Legacy.id')), cs.id) AS CHAR(255)) AS OrganisationID
FROM client_service cs
INNER JOIN client c ON cs.`Client` = c.id
INNER JOIN accounting_firm af ON c.AccountingFirm = af.id
WHERE cs.`Service` = 72
    AND cs.id = {client_number}
    AND cs.`Client` = {organsiation_id}


The "bigoleshoecompany_client2033" is the ClientID variable. It may vary for different clients
Create the tables abd views using the following SQL queries:
*/

CREATE TABLE evadb_stage.c2033_fyi_capacitydev (
  id bigint UNSIGNED NOT NULL AUTO_INCREMENT INVISIBLE,
  StaffName varchar(255) DEFAULT NULL,
  Mon varchar(255) DEFAULT NULL,
  Tue varchar(255) DEFAULT NULL,
  Wed varchar(255) DEFAULT NULL,
  Thu varchar(255) DEFAULT NULL,
  Fri varchar(255) DEFAULT NULL,
  Total varchar(255) DEFAULT NULL,
  Percent varchar(255) DEFAULT NULL,
  Productivity varchar(255) DEFAULT NULL,
  Team varchar(255) DEFAULT NULL,
  StaffID varchar(255) DEFAULT NULL,
  BillRate varchar(255) DEFAULT NULL,
  BillableRate varchar(255) DEFAULT NULL,
  FulltimeEquivPercent varchar(255) DEFAULT NULL,
  ClientID varchar(255) DEFAULT NULL,
  OrganisationID varchar(255) DEFAULT NULL,
  Notes text DEFAULT NULL,
  Working tinyint(1) DEFAULT NULL,
  DirectorPartner tinyint(1) DEFAULT NULL,
  FeeEarner tinyint(1) DEFAULT NULL,
  createdAt datetime DEFAULT NULL,
  UpdatedAt datetime DEFAULT NULL,
  StaffHistoricRates text DEFAULT NULL,
  CustomTaskRate text DEFAULT NULL,
  Manager tinyint(1) DEFAULT NULL,
  HistoricCapacity text DEFAULT NULL,
  PRIMARY KEY (id)
);


DROP VIEW IF EXISTS bigoleshoecompany_client2033_fyi_invoices;
CREATE VIEW bigoleshoecompany_client2033_fyi_invoices
AS
SELECT
  CONCAT(`invoice`.`Id`, '-', COALESCE(`job`.`Id`, 'NO_JOB')) AS `invoice_job_link_id`,
  `invoice`.`Id` AS `invoice_id`,
  `invoice`.`InvoiceNumber` AS `invoice_number`,
  `invoice`.`Type` AS `invoice_type`,
  `invoice`.`Status` AS `invoice_status`,
  `invoice`.`InvoiceDate` AS `invoice_date`,
  `invoice`.`DueDate` AS `invoice_due_date`,
  `invoice`.`PaidDate` AS `invoice_paid_date`,
  `invoice`.`LastModifiedOn` AS `invoice_last_modified_on`,
  `invoice`.`AmountIncludingTax` AS `invoice_amount_including_tax`,
  `invoice`.`PaidAmount` AS `invoice_amount_paid`,
  `invoice`.`AmountOutstanding` AS `invoice_amount_outstanding`,
  `invoice`.`AmountIncludingTax` AS `invoice_total_amount`,
  `job`.`Id` AS `job_id`,
  `job`.`Name` AS `job_name`,
  `job`.`ManagerUserId` AS `job_manager_id`,
  `user_manager`.`DisplayName` AS `job_manager_name`,
  `job`.`PartnerUserId` AS `job_partner_id`,
  `user_partner`.`DisplayName` AS `job_partner_name`,
  NULL AS `invoice_jobs_amount`,
  NULL AS `invoice_jobs_wip_amount`,
  `entity`.`Id` AS `client_id`,
  `entity`.`Name` AS `client_name`,
  `entity`.`PartnerUserId` AS `client_partner_id`,
  `entity`.`PartnerUserDisplayName` AS `client_partner_name`,
  `entity`.`ManagerUserId` AS `client_manager_id`,
  `entity`.`ManagerUserDisplayName` AS `client_manager_name`,
  `invoice`.`ClientID` AS `system_client_id`,
  `invoice`.`OrganisationID` AS `organisation_system_id`,
  `invoice`.`TenantId` AS `system_tenant_id`,
  `invoice`.`EtlInsertTime` AS `system_etl_insert_time`,
  `invoice`.`EtlUpdateTime` AS `system_etl_update_time`,
  NULL AS `invoice_created_at`,
  NULL AS `invoice_category`,
  NULL AS `invoice_description`,
  NULL AS `invoice_currency_code`,
  NULL AS `invoice_payment_instructions`,
  NULL AS `client_key`,
  NULL AS `client_type`,
  NULL AS `client_address_line`,
  NULL AS `client_city`,
  NULL AS `client_state_province`,
  NULL AS `client_zip_code`,
  NULL AS `client_country`,
  NULL AS `client_email_address`
FROM (((((`evadb_stage`.`c2033_fyi_invoice` `invoice`
  LEFT JOIN `evadb_stage`.`c2033_fyi_invoicejobs` `invoice_jobs_link`
    ON (((`invoice`.`Id` = `invoice_jobs_link`.`invoiceId`)
    AND (`invoice`.`OrganisationID` = `invoice_jobs_link`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_job` `job`
    ON (((`invoice_jobs_link`.`JobId` = `job`.`Id`)
    AND (`invoice_jobs_link`.`OrganisationID` = `job`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_entity` `entity`
    ON (((`invoice`.`EntityId` = `entity`.`Id`)
    AND (`invoice`.`OrganisationID` = `entity`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user_manager`
    ON (((`job`.`ManagerUserId` = `user_manager`.`Id`)
    AND (`job`.`OrganisationID` = `user_manager`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user_partner`
    ON (((`job`.`PartnerUserId` = `user_partner`.`Id`)
    AND (`job`.`OrganisationID` = `user_partner`.`OrganisationID`))))
WHERE ((`invoice`.`Status` <> 'Cancelled')
OR (`invoice`.`Status` IS NULL));


DROP VIEW IF EXISTS bigoleshoecompany_client2033_fyi_header;
CREATE VIEW bigoleshoecompany_client2033_fyi_header
AS
SELECT
  NULL AS `header_id`,
  NULL AS `task_billable`,
  `job`.`Id` AS `job_id`,
  `job`.`Name` AS `job_name`,
  NULL AS `job_description`,
  `job`.`EntityId` AS `job_client_id`,
  `entity`.`Name` AS `job_client_name`,
  NULL AS `job_client_order_number`,
  `jobstate`.`Name` AS `job_state`,
  `job`.`StartDate` AS `job_start_date`,
  `job`.`DueDate` AS `job_due_date`,
  NULL AS `job_completed_date`,
  `job`.`XpmInternalId` AS `job_internal_id`,
  NULL AS `job_assigned`,
  NULL AS `job_milestones`,
  `job`.`LastComment` AS `job_notes`,
  `job`.`Value` AS `job_budget_amount`,
  NULL AS `job_contact_id`,
  NULL AS `job_contact_name`,
  `job`.`ManagerUserId` AS `job_manager_id`,
  `job`.`ManagerUserDisplayName` AS `job_manager_name`,
  `job`.`PartnerUserId` AS `job_partner_id`,
  `job`.`PartnerUserDisplayName` AS `job_partner_name`,
  `task`.`Id` AS `task_id`,
  `task`.`Subject` AS `task_name`,
  `task`.`Message` AS `task_description`,
  NULL AS `task_estimated_minutes`,
  NULL AS `task_actual_minutes`,
  `task`.`Status` AS `task_completed`,
  NULL AS `task_folder`,
  `task`.`StartDate` AS `task_start_date`,
  `task`.`DueDate` AS `task_due_date`,
  `user`.`Id` AS `task_assigned_staff_id`,
  `user`.`DisplayName` AS `task_assigned_staff_name`,
  NULL AS `task_assigned_staff_allocated_minutes`,
  NULL AS `task_assigned_staff`,
  NULL AS `task_percent_complete`,
  NULL AS `task_date_completed`,
  CONCAT(`job`.`Id`, ' ', `task`.`Subject`) AS `jobid_taskname`,
  NULL AS `task_billable_amount`,
  NULL AS `job_category`,
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
  NULL AS `cost`,
  `job`.`ClientID` AS `system_client_id`,
  `job`.`OrganisationID` AS `system_organisation_id`
FROM ((((`evadb_stage`.`c2033_fyi_job` `job`
  LEFT JOIN `evadb_stage`.`c2033_fyi_task` `task`
    ON ((`job`.`Id` = `task`.`JobId`)))
  LEFT JOIN `evadb_stage`.`c2033_fyi_entity` `entity`
    ON ((`job`.`EntityId` = `entity`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2033_fyi_jobstate` `jobstate`
    ON ((`job`.`JobStateId` = `jobstate`.`Id`)))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user`
    ON ((`task`.`AssignedUserEmail` = `user`.`Email`)));


DROP VIEW IF EXISTS bigoleshoecompany_client2033_fyi_transactions_blend;
CREATE VIEW bigoleshoecompany_client2033_fyi_transactions_blend
AS
SELECT
  `timeentry`.`Id` AS `transaction_id`,
  `timeentry`.`Id` AS `timesheet_id`,
  `timeentry`.`UserId` AS `staff_id`,
  COALESCE(`user`.`DisplayName`, `timeentry`.`UserDisplayName`) AS `staff_name`,
  `entity_group`.`Name` AS `client_group_name`,
  COALESCE(`entity`.`Name`, `timeentry`.`EntityName`) AS `client_name`,
  `timeentry`.`Billable` AS `timesheet_billable`,
  `timeentry`.`BillableAmount` AS `timesheet_billable_amount_totalled`,
  `timeentry`.`RateVersionBillableRate` AS `timesheet_billable_rate`,
  (`timeentry`.`InvoicedDate` IS NOT NULL) AS `timesheet_is_invoiced`,
  `timeentry`.`EntryDate` AS `timesheet_date`,
  `timeentry`.`EntryType` AS `timesheet_type`,
  `timeentry`.`Quantity` AS `timesheet_quantity`,
  `timeentry`.`RateVersionBaseRate` AS `timesheet_standard_charge_rate`,
  `timeentry`.`Category` AS `timesheet_category`,
  `timeentry`.`Notes` AS `timesheet_note`,
  ROUND((`timeentry`.`Minutes` / 60.0), 2) AS `timesheet_hours`,
  ROUND(((`timeentry`.`Minutes` * CAST(`timeentry`.`RateVersionBaseRate` AS decimal(10, 2))) / 60), 2) AS `timesheet_standard_amount_totalled`,
  `timeentry`.`XpmTaskId` AS `task_id`,
  `timeentry_customfield`.`Value` AS `task_name`,
  `timeentry_customfield_completed`.`Value` AS `timesheet_task_completed`,
  `timeentry`.`JobId` AS `job_id`,
  `job`.`XpmInternalId` AS `job_number`,
  COALESCE(`job`.`Name`, `timeentry`.`JobName`) AS `job_name`,
  COALESCE(`job`.`StartDate`, `timeentry`.`JobStartDate`) AS `job_start_date`,
  COALESCE(`job`.`DueDate`, `timeentry`.`JobDueDate`) AS `job_due_date`,
  COALESCE(`jobstate`.`Name`, `job`.`JobStateName`) AS `job_state`,
  (CASE WHEN (`job`.`JobStateName` = 'Completed') THEN `job`.`LastModifiedOn` ELSE NULL END) AS `job_completed_date`,
  `user_partner`.`DisplayName` AS `job_partner_name`,
  `user_manager`.`DisplayName` AS `job_manager_name`,
  `invoice`.`InvoiceNumber` AS `invoice_number`,
  `invoice`.`DueDate` AS `invoice_due_date`,
  `invoice`.`Type` AS `invoice_type`,
  `invoice`.`PaidAmount` AS `invoice_amount_paid`,
  `invoice`.`AmountIncludingTax` AS `invoice_amount_including_tax`,
  `invoice`.`AmountOutstanding` AS `invoice_amount_outstanding`,
  `timeentry`.`InvoicedDate` AS `invoice_date`,
  `timeentry`.`InvoicedAmount` AS `invoice_line_amount`,
  SUM(ROUND((`timeentry`.`Minutes` / 60.0), 2)) OVER (PARTITION BY `timeentry`.`InvoiceId`) AS `invoice_timesheet_hours`,
  SUM(`timeentry`.`InvoicedAmount`) OVER (PARTITION BY `timeentry`.`InvoiceId`) AS `invoice_timesheet_totalled`,
  COALESCE(`entity`.`Name`, `timeentry`.`EntityName`) AS `invoice_client_name`,
  (CASE WHEN (`timeentry`.`Category` = 'chargeable') THEN 'Billable' WHEN (`timeentry`.`Category` = 'non_productive') THEN 'Internal' WHEN (`timeentry`.`Category` = 'capacity_reducing') THEN 'NA' ELSE 'UNKNOWN' END) AS `timesheet_billable_without_leave`,
  CONCAT(COALESCE(`user`.`DisplayName`, `timeentry`.`UserDisplayName`, ''), (CASE WHEN (`timeentry_customfield`.`Value` IS NOT NULL) THEN CONCAT('-', `timeentry_customfield`.`Value`) ELSE '' END)) AS `staff_task_label`,
  `timeentry`.`ClientID` AS `client_system_id`,
  `timeentry`.`OrganisationID` AS `organisation_system_id`,
  `timeentry`.`EntityId` AS `client_id`,
  `entity`.`PartnerUserDisplayName` AS `client_partner_name`,
  `entity`.`ManagerUserDisplayName` AS `client_manager_name`,
  `entity`.`PartnerUserId` AS `client_partner_id`,
  `entity`.`ManagerUserId` AS `client_manager_id`,
  NULL AS `team_name`
FROM ((((((((((`evadb_stage`.`c2033_fyi_timeentry` `timeentry`
  LEFT JOIN `evadb_stage`.`c2033_fyi_invoice` `invoice`
    ON (((`timeentry`.`InvoiceId` = `invoice`.`Id`)
    AND (`timeentry`.`OrganisationID` = `invoice`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_job` `job`
    ON (((`timeentry`.`JobId` = `job`.`Id`)
    AND (`timeentry`.`OrganisationID` = `job`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_group` `entity_group`
    ON (((`timeentry`.`EntityEntityGroupId` = `entity_group`.`Id`)
    AND (`timeentry`.`OrganisationID` = `entity_group`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user`
    ON (((`timeentry`.`UserId` = `user`.`Id`)
    AND (`timeentry`.`OrganisationID` = `user`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user_manager`
    ON (((COALESCE(`job`.`ManagerUserId`, `timeentry`.`JobManagerUserId`) = `user_manager`.`Id`)
    AND (`timeentry`.`OrganisationID` = `user_manager`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_user` `user_partner`
    ON (((COALESCE(`job`.`PartnerUserId`, `timeentry`.`JobPartnerUserId`) = `user_partner`.`Id`)
    AND (`timeentry`.`OrganisationID` = `user_partner`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_jobstate` `jobstate`
    ON (((COALESCE(`job`.`JobStateId`, `timeentry`.`JobJobStateId`) = `jobstate`.`Id`)
    AND (`timeentry`.`OrganisationID` = `jobstate`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_entity` `entity`
    ON (((`timeentry`.`EntityId` = `entity`.`Id`)
    AND (`timeentry`.`OrganisationID` = `entity`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_timeentrycustomfields` `timeentry_customfield`
    ON (((`timeentry`.`Id` = `timeentry_customfield`.`timeentryId`)
    AND (`timeentry_customfield`.`CustomFieldName` = 'task_name')
    AND (`timeentry`.`OrganisationID` = `timeentry_customfield`.`OrganisationID`))))
  LEFT JOIN `evadb_stage`.`c2033_fyi_timeentrycustomfields` `timeentry_customfield_completed`
    ON (((`timeentry`.`Id` = `timeentry_customfield_completed`.`timeentryId`)
    AND (`timeentry_customfield_completed`.`CustomFieldName` = 'CompletedDate')
    AND (`timeentry`.`OrganisationID` = `timeentry_customfield_completed`.`OrganisationID`))));


DROP VIEW IF EXISTS CREATE VIEW bigoleshoecompany_client2033_fyi_uniquestaffdetail;
CREATE VIEW bigoleshoecompany_client2033_fyi_uniquestaffdetail
AS
SELECT
  `staff`.`SourceId` AS `staff_id`,
  COALESCE(`capacitydev`.`StaffName`, `staff`.`Name`) AS `staff_name`,
  `staff`.`Email` AS `staff_email`,
  `staff`.`Mobile` AS `staff_mobile`,
  `staff`.`Phone` AS `staff_phone`,
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
  (CASE WHEN (`staff`.`Name` = 'Retainer') THEN 'Retainer' WHEN ((`capacitydev`.`Team` IS NULL) OR
      (`capacitydev`.`Team` = '')) THEN 'No Staff Allocation' ELSE `capacitydev`.`Team` END) AS `capacity_team`,
  COALESCE(`capacitydev`.`Notes`, 0) AS `capacity_notes`,
  IFNULL(`capacitydev`.`Working`, 1) AS `capacity_working`,
  IFNULL(`capacitydev`.`DirectorPartner`, 0) AS `capacity_director_partner`,
  IFNULL(`capacitydev`.`FeeEarner`, 1) AS `capacity_fee_earner`,
  IFNULL(`capacitydev`.`Manager`, 0) AS `capacity_manager`,
  `timeentries`.`MinDate` AS `timeentry_start_date`,
  `timeentries`.`MaxDate` AS `timeentry_end_date`,
  `capacitydev`.`StaffHistoricRates` AS `capacity_historic_rates`,
  `capacitydev`.`CustomTaskRate` AS `capacity_custom_task_rate`,
  `capacitydev`.`HistoricCapacity` AS `capacity_historic_capacity`,
  `staff`.`ManagerUserId` AS `staff_manager_user_id`,
  `staff`.`PartnerUserId` AS `staff_partner_user_id`,
  `staff`.`EntityGroupId` AS `staff_entity_group_id`,
  `staff`.`IsDeleted` AS `staff_is_deleted`,
  `staff`.`LastModifiedOn` AS `staff_last_modified_on`,
  `capacitydev`.`createdAt` AS `capacity_created_at`,
  `capacitydev`.`UpdatedAt` AS `capacity_updated_at`,
  (CASE WHEN (`capacitydev`.`StaffID` IS NOT NULL) THEN 'Yes' ELSE 'No' END) AS `capacity_in_capacity_dev`,
  CONCAT(`staff`.`Name`, '-', `staff`.`OrganisationID`) AS `staff_org_id`
FROM ((`evadb_stage`.`c2033_fyi_employee` `staff`
  LEFT JOIN `evadb_stage`.`c2033_fyi_capacitydev` `capacitydev`
    ON (((`staff`.`Id` = `capacitydev`.`StaffID`)
    AND (`staff`.`OrganisationID` = `capacitydev`.`OrganisationID`))))
  LEFT JOIN (SELECT
      `timeentry`.`UserId` AS `UserId`,
      `timeentry`.`OrganisationID` AS `OrganisationID`,
      DATE_FORMAT(MIN(STR_TO_DATE(`timeentry`.`EntryDate`, '%Y-%m-%d')), '%d-%b-%Y') AS `MinDate`,
      (CASE WHEN (MAX(STR_TO_DATE(`timeentry`.`EntryDate`, '%Y-%m-%d')) < (CURDATE() - INTERVAL 14 DAY)) THEN DATE_FORMAT(MAX(STR_TO_DATE(`timeentry`.`EntryDate`, '%Y-%m-%d')), '%d-%b-%Y') ELSE NULL END) AS `MaxDate`
    FROM `evadb_stage`.`c2033_fyi_timeentry` `timeentry`
    WHERE (`timeentry`.`UserId` IS NOT NULL)
    GROUP BY `timeentry`.`UserId`,
             `timeentry`.`OrganisationID`) `timeentries`
    ON (((`staff`.`Id` = `timeentries`.`UserId`)
    AND (`staff`.`OrganisationID` = `timeentries`.`OrganisationID`))))
ORDER BY IFNULL(`capacitydev`.`Working`, 1) DESC, COALESCE(`capacitydev`.`StaffName`, `staff`.`Name`);