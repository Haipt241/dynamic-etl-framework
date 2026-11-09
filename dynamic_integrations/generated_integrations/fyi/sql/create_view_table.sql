-- FYI Views - Auto Generated
-- Pattern: {etani_client_id}_fyi_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Cabinet View
DROP VIEW IF EXISTS {etani_client_id}_fyi_cabinet;
CREATE VIEW {etani_client_id}_fyi_cabinet AS
SELECT
    id,
    name,
    type,
    isknowledge AS `is_knowledge`,
    lastmodifiedon AS `last_modified_on`,
    createdon AS `created_on`,
    isdeleted AS `is_deleted`,
    jobsenabled AS `jobs_enabled`,
    jobsrequired AS `jobs_required`,
    jobsordering AS `jobs_ordering`,
    tagsenabled AS `tags_enabled`,
    tagsrequired AS `tags_required`,
    tagsordering AS `tags_ordering`,
    accountsenabled AS `accounts_enabled`,
    accountsrequired AS `accounts_required`,
    accountsordering AS `accounts_ordering`,
    keywordsordering AS `keywords_ordering`,
    keywordsrequired AS `keywords_required`,
    keywordsenabled AS `keywords_enabled`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_cabinet;

-- Category View
DROP VIEW IF EXISTS {etani_client_id}_fyi_category;
CREATE VIEW {etani_client_id}_fyi_category AS
SELECT
    id,
    name,
    lastmodifiedon AS `last_modified_on`,
    createdon AS `created_on`,
    visibletemplates AS `visible_templates`,
    visibleprocesses AS `visible_processes`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_category;

-- Comment View
DROP VIEW IF EXISTS {etani_client_id}_fyi_comment;
CREATE VIEW {etani_client_id}_fyi_comment AS
SELECT
    id,
    customerid AS `customer_id`,
    source,
    sourceid AS `source_id`,
    message,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_comment;

-- Contact View
DROP VIEW IF EXISTS {etani_client_id}_fyi_contact;
CREATE VIEW {etani_client_id}_fyi_contact AS
SELECT
    id,
    source,
    sourceid AS `source_id`,
    addressee,
    email,
    mobile,
    name,
    phone,
    position,
    salutation,
    isdeleted AS `is_deleted`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_contact;

-- CustomFieldEntity View
DROP VIEW IF EXISTS {etani_client_id}_fyi_customfieldentity;
CREATE VIEW {etani_client_id}_fyi_customfieldentity AS
SELECT
    id,
    customerid AS `customer_id`,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    deleteduserid AS `deleted_user_id`,
    source,
    sourceid AS `source_id`,
    name,
    fieldtype AS `field_type`,
    applies_to,
    isshared AS `is_shared`,
    external_ids,
    clientid,
    organisationid,
    detailsid AS `details.id`,
    detailsname AS `details.name`,
    detailstype AS `details.type`,
    detailssha1 AS `details.sha1`,
    detailsusejob AS `details.usejob`,
    detailsuselead AS `details.uselead`,
    detailsuseclient AS `details.useclient`,
    detailsusecontact AS `details.usecontact`,
    detailsusejobcost AS `details.usejobcost`,
    detailsusejobtask AS `details.usejobtask`,
    detailsusejobtime AS `details.usejobtime`,
    detailsusesupplier AS `details.usesupplier`,
    detailsvalueelement AS `details.valueelement`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_customfieldentity;

-- CustomFieldJob View
DROP VIEW IF EXISTS {etani_client_id}_fyi_customfieldjob;
CREATE VIEW {etani_client_id}_fyi_customfieldjob AS
SELECT
    id,
    customerid AS `customer_id`,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    deleteduserid AS `deleted_user_id`,
    source,
    sourceid AS `source_id`,
    name,
    fieldtype AS `field_type`,
    applies_to,
    isshared AS `is_shared`,
    external_ids,
    clientid,
    organisationid,
    detailsid AS `details.id`,
    detailsname AS `details.name`,
    detailstype AS `details.type`,
    detailssha1 AS `details.sha1`,
    detailsxpmid AS `details.xpmid`,
    detailsusejob AS `details.usejob`,
    detailsuselead AS `details.uselead`,
    detailsuseclient AS `details.useclient`,
    detailsusecontact AS `details.usecontact`,
    detailsusejobcost AS `details.usejobcost`,
    detailsusejobtask AS `details.usejobtask`,
    detailsusejobtime AS `details.usejobtime`,
    detailsusesupplier AS `details.usesupplier`,
    detailsvalueelement AS `details.valueelement`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_customfieldjob;

-- Document View
DROP VIEW IF EXISTS {etani_client_id}_fyi_document;
CREATE VIEW {etani_client_id}_fyi_document AS
SELECT
    id,
    clientid,
    organisationid,
    createdon AS `created_on`,
    externalid AS `external_id`,
    lastsavedon AS `last_saved_on`,
    lastmodifiedon AS `last_modified_on`,
    name,
    originalfilename AS `original_filename`,
    documenttype AS `document_type`,
    referencenumber AS `reference_number`,
    details,
    keywords,
    status,
    isdeleted AS `is_deleted`,
    versionid AS `version_id`,
    linkid AS `link_id`,
    threadid AS `thread_id`,
    cabinetid AS `cabinet.id`,
    cabinetname AS `cabinet.name`,
    cabinettype AS `cabinet.type`,
    cabinetisknowledge AS `cabinet.is_knowledge`,
    cabinetlastmodifiedon AS `cabinet.last_modified_on`,
    cabinetcreatedon AS `cabinet.created_on`,
    cabinetisdeleted AS `cabinet.is_deleted`,
    cabinetjobsenabled AS `cabinet.jobs_enabled`,
    cabinetjobsrequired AS `cabinet.jobs_required`,
    cabinetjobsordering AS `cabinet.jobs_ordering`,
    cabinettagsenabled AS `cabinet.tags_enabled`,
    cabinettagsrequired AS `cabinet.tags_required`,
    cabinettagsordering AS `cabinet.tags_ordering`,
    cabinetaccountsenabled AS `cabinet.accounts_enabled`,
    cabinetaccountsrequired AS `cabinet.accounts_required`,
    cabinetaccountsordering AS `cabinet.accounts_ordering`,
    cabinetkeywordsordering AS `cabinet.keywords_ordering`,
    cabinetkeywordsrequired AS `cabinet.keywords_required`,
    cabinetkeywordsenabled AS `cabinet.keywords_enabled`,
    cabinetcategories AS `cabinet.categories`,
    cabinetcategoriesoptions AS `cabinet_categories.options`,
    jobname AS `job.name`,
    jobid AS `job.id`,
    jobentityid AS `job.entity_id`,
    jobjobstateid AS `job.job_state_id`,
    jobstartdate AS `job.start_date`,
    jobjobtypeid AS `job.job_type_id`,
    jobcabinetid AS `job.cabinet_id`,
    jobmanageruserid AS `job.manager_user_id`,
    jobpartneruserid AS `job.partner_user_id`,
    jobcreateduserid AS `job.created_user_id`,
    jobcreatedon AS `job.created_on`,
    joblastmodifiedon AS `job.last_modified_on`,
    joblastmodifieduserid AS `job.last_modified_user_id`,
    jobcommentscount AS `job.comments_count`,
    jobprimary AS `job.primary`,
    jobtype AS `job.type`,
    jobworkflowenabled AS `job.workflow_enabled`,
    jobvalue AS `job.value`,
    jobduedate AS `job.due_date`,
    jobsource AS `job.source`,
    jobsourceid AS `job.source_id`,
    jobbudgetminutes AS `job.budget_minutes`,
    jobactualminutes AS `job.actual_minutes`,
    jobbudgetamount AS `job.budget_amount`,
    jobactualamount AS `job.actual_amount`,
    jobwipamount AS `job.wip_amount`,
    jobwriteonoff AS `job.write_on_off`,
    jobinvoicedamount AS `job.invoiced_amount`,
    jobparentid AS `job.parent_id`,
    jobusers AS `job.users`,
    jobtemplateid AS `job.template_id`,
    jobjobcustomfields AS `job.job_custom_fields`,
    jobxpmactualminutes AS `job.xpm_actual_minutes`,
    jobxpmestimatedminutes AS `job.xpm_estimated_minutes`,
    jobxpmvarianceminutes AS `job.xpm_variance_minutes`,
    entityid AS `entity.id`,
    entityname AS `entity.name`,
    entitydetails AS `entity.details`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_document;

-- Employee View
DROP VIEW IF EXISTS {etani_client_id}_fyi_employee;
CREATE VIEW {etani_client_id}_fyi_employee AS
SELECT
    id,
    clientid,
    organisationid,
    name,
    email,
    source,
    sourceid AS `source_id`,
    entitygroupid AS `entity_group_id`,
    details,
    contacts,
    entity_custom_fields,
    mobile,
    phone,
    isdeleted AS `is_deleted`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    manageruserid AS `manager_user.id`,
    manageruserdisplayname AS `manager_user.display_name`,
    managerusercreatedon AS `manager_user.created_on`,
    managerusercreateduserid AS `manager_user.created_user_id`,
    manageruserlastmodifiedon AS `manager_user.last_modified_on`,
    manageruserlastmodifieduserid AS `manager_user.last_modified_user_id`,
    manageruserdeleteduserid AS `manager_user.deleted_user_id`,
    manageruseremail AS `manager_user.email`,
    manageruseremailalias AS `manager_user.email_alias`,
    manageruserinactive AS `manager_user.inactive`,
    manageruserproductivitytarget AS `manager_user.productivity_target`,
    manageruserworkinghours AS `manager_user.working_hours`,
    managerusersource AS `manager_user.source`,
    manageruseruserrole AS `manager_user.user_role`,
    manageruserpermissionuserrole AS `manager_user.permission_user_role`,
    partneruserid AS `partner_user.id`,
    partneruserdisplayname AS `partner_user.display_name`,
    partnerusercreatedon AS `partner_user.created_on`,
    partnerusercreateduserid AS `partner_user.created_user_id`,
    partneruserlastmodifiedon AS `partner_user.last_modified_on`,
    partneruserlastmodifieduserid AS `partner_user.last_modified_user_id`,
    partneruserdeleteduserid AS `partner_user.deleted_user_id`,
    partneruseremail AS `partner_user.email`,
    partneruseremailalias AS `partner_user.email_alias`,
    partneruserinactive AS `partner_user.inactive`,
    partneruserproductivitytarget AS `partner_user.productivity_target`,
    partneruserworkinghours AS `partner_user.working_hours`,
    partnerusersource AS `partner_user.source`,
    partneruseruserrole AS `partner_user.user_role`,
    partneruserpermissionuserrole AS `partner_user.permission_user_role`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_employee;

-- Entity View
DROP VIEW IF EXISTS {etani_client_id}_fyi_entity;
CREATE VIEW {etani_client_id}_fyi_entity AS
SELECT
    id,
    clientid,
    organisationid,
    name,
    email,
    source,
    sourceid AS `source_id`,
    entitygroupid AS `entity_group_id`,
    mobile,
    phone,
    address,
    city,
    region,
    postcode,
    country,
    postaladdress AS `postal_address`,
    postalcity AS `postal_city`,
    postalregion AS `postal_region`,
    postalpostcode AS `postal_postcode`,
    postalcountry AS `postal_country`,
    businessnumber AS `business_number`,
    companynumber AS `company_number`,
    isdeleted AS `is_deleted`,
    manageruserid AS `manager_user.id`,
    manageruserdisplayname AS `manager_user.display_name`,
    managerusercreatedon AS `manager_user.created_on`,
    managerusercreateduserid AS `manager_user.created_user_id`,
    manageruserlastmodifiedon AS `manager_user.last_modified_on`,
    manageruserlastmodifieduserid AS `manager_user.last_modified_user_id`,
    manageruserdeleteduserid AS `manager_user.deleted_user_id`,
    manageruseremail AS `manager_user.email`,
    manageruseremailalias AS `manager_user.email_alias`,
    manageruserinactive AS `manager_user.inactive`,
    manageruserproductivitytarget AS `manager_user.productivity_target`,
    manageruserworkinghours AS `manager_user.working_hours`,
    managerusersource AS `manager_user.source`,
    manageruseruserrole AS `manager_user.user_role`,
    manageruserpermissionuserrole AS `manager_user.permission_user_role`,
    partneruserid AS `partner_user.id`,
    partneruserdisplayname AS `partner_user.display_name`,
    partnerusercreatedon AS `partner_user.created_on`,
    partnerusercreateduserid AS `partner_user.created_user_id`,
    partneruserlastmodifiedon AS `partner_user.last_modified_on`,
    partneruserlastmodifieduserid AS `partner_user.last_modified_user_id`,
    partneruserdeleteduserid AS `partner_user.deleted_user_id`,
    partneruseremail AS `partner_user.email`,
    partneruseremailalias AS `partner_user.email_alias`,
    partneruserinactive AS `partner_user.inactive`,
    partneruserproductivitytarget AS `partner_user.productivity_target`,
    partneruserworkinghours AS `partner_user.working_hours`,
    partnerusersource AS `partner_user.source`,
    partneruseruserrole AS `partner_user.user_role`,
    partneruserpermissionuserrole AS `partner_user.permission_user_role`,
    detailsclientcode AS `details.client_code`,
    detailsexportcode AS `details.export_code`,
    detailsuuid AS `details.uuid`,
    detailsbusinessstructure AS `details.business_structure`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_entity;

-- EntityRelationship View
DROP VIEW IF EXISTS {etani_client_id}_fyi_entityrelationship;
CREATE VIEW {etani_client_id}_fyi_entityrelationship AS
SELECT
    id,
    type,
    entityrelationshiptype AS `entity_relationship_type`,
    entityid AS `entity_id`,
    relatedentityid AS `related_entity_id`,
    percentage,
    numberofshares AS `number_of_shares`,
    startdate AS `start_date`,
    enddate AS `end_date`,
    createdon AS `created_on`,
    createduserid AS `created_user_id`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_entityrelationship;


-- Pattern: {etani_client_id}_fyi_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- Group View
DROP VIEW IF EXISTS {etani_client_id}_fyi_group;
CREATE VIEW {etani_client_id}_fyi_group AS
SELECT
    id,
    name,
    source,
    primaryentityid AS `primary_entity_id`,
    createdon AS `created_on`,
    lastmodifiedon AS `last_modified_on`,
    isdeleted AS `is_deleted`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_group;

-- Invoice View
DROP VIEW IF EXISTS {etani_client_id}_fyi_invoice;
CREATE VIEW {etani_client_id}_fyi_invoice AS
SELECT
    id,
    entityid AS `entity_id`,
    amountoutstanding AS `amount_outstanding`,
    duedate AS `due_date`,
    amountincludingtax AS `amount_including_tax`,
    invoiceamount AS `invoice_amount`,
    invoicedate AS `invoice_date`,
    invoicenumber AS `invoice_number`,
    jobid AS `job_id`,
    paidamount AS `paid_amount`,
    paiddate AS `paid_date`,
    status,
    type,
    tenantid AS `tenant_id`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_invoice;

-- Job View
DROP VIEW IF EXISTS {etani_client_id}_fyi_job;
CREATE VIEW {etani_client_id}_fyi_job AS
SELECT
    id,
    name,
    entityid AS `entity_id`,
    jobstateid AS `job_state_id`,
    startdate AS `start_date`,
    jobtypeid AS `job_type_id`,
    cabinetid AS `cabinet_id`,
    manageruserid AS `manager_user_id`,
    partneruserid AS `partner_user_id`,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    commentscount AS `comments_count`,
    `primary`,
    xpminternalid AS `xpm_internal_id`,
    type,
    workflowenabled AS `workflow_enabled`,
    value,
    duedate AS `due_date`,
    sourceid AS `source_id`,
    budgetminutes AS `budget_minutes`,
    actualminutes AS `actual_minutes`,
    varianceminutes AS `variance_minutes`,
    budgetamount AS `budget_amount`,
    actualamount AS `actual_amount`,
    invoicedamount AS `invoiced_amount`,
    varianceamount AS `variance_amount`,
    parentid AS `parent_id`,
    lastcomment AS `last_comment`,
    customfieldcf1 AS `custom_field_cf_1`,
    xpmactualminutes AS `xpm_actual_minutes`,
    xpmestimatedminutes AS `xpm_estimated_minutes`,
    xpmvarianceminutes AS `xpm_variance_minutes`,
    clientid,
    organisationid,
    jobtypename AS `job_type.name`,
    jobtypestatus AS `job_type.status`,
    jobtypecreatedon AS `job_type.created_on`,
    jobtypecreateduserid AS `job_type.created_user_id`,
    jobtypelastmodifiedon AS `job_type.last_modified_on`,
    jobtypelastmodifieduserid AS `job_type.last_modified_user_id`,
    jobtypesource AS `job_type.source`,
    jobtypesourceid AS `job_type.source_id`,
    jobstatename AS `job_state.name`,
    manageruserdisplayname AS `manager_user.display_name`,
    managerusercreatedon AS `manager_user.created_on`,
    managerusercreateduserid AS `manager_user.created_user_id`,
    manageruserlastmodifiedon AS `manager_user.last_modified_on`,
    manageruserlastmodifieduserid AS `manager_user.last_modified_user_id`,
    manageruserdeleteduserid AS `manager_user.deleted_user_id`,
    manageruseremail AS `manager_user.email`,
    manageruseremailalias AS `manager_user.email_alias`,
    manageruserinactive AS `manager_user.inactive`,
    manageruserproductivitytarget AS `manager_user.productivity_target`,
    manageruserworkinghours AS `manager_user.working_hours`,
    managerusersource AS `manager_user.source`,
    manageruseruserrole AS `manager_user.user_role`,
    manageruserpermissionuserrole AS `manager_user.permission_user_role`,
    partneruserdisplayname AS `partner_user.display_name`,
    partnerusercreatedon AS `partner_user.created_on`,
    partnerusercreateduserid AS `partner_user.created_user_id`,
    partneruserlastmodifiedon AS `partner_user.last_modified_on`,
    partneruserlastmodifieduserid AS `partner_user.last_modified_user_id`,
    partneruserdeleteduserid AS `partner_user.deleted_user_id`,
    partneruseremail AS `partner_user.email`,
    partneruseremailalias AS `partner_user.email_alias`,
    partneruserinactive AS `partner_user.inactive`,
    partneruserproductivitytarget AS `partner_user.productivity_target`,
    partneruserworkinghours AS `partner_user.working_hours`,
    partnerusersource AS `partner_user.source`,
    partneruseruserrole AS `partner_user.user_role`,
    partneruserpermissionuserrole AS `partner_user.permission_user_role`,
    createduserdisplayname AS `created_user.display_name`,
    createdusercreatedon AS `created_user.created_on`,
    createdusercreateduserid AS `created_user.created_user_id`,
    createduserlastmodifiedon AS `created_user.last_modified_on`,
    createduserlastmodifieduserid AS `created_user.last_modified_user_id`,
    createduserdeleteduserid AS `created_user.deleted_user_id`,
    createduseremail AS `created_user.email`,
    createduseremailalias AS `created_user.email_alias`,
    createduserinactive AS `created_user.inactive`,
    createduserproductivitytarget AS `created_user.productivity_target`,
    createduserworkinghours AS `created_user.working_hours`,
    createdusersource AS `created_user.source`,
    createduseruserrole AS `created_user.user_role`,
    createduserpermissionuserrole AS `created_user.permission_user_role`,
    lastmodifieduserdisplayname AS `last_modified_user.display_name`,
    lastmodifiedusercreatedon AS `last_modified_user.created_on`,
    lastmodifiedusercreateduserid AS `last_modified_user.created_user_id`,
    lastmodifieduserlastmodifiedon AS `last_modified_user.last_modified_on`,
    lastmodifieduserlastmodifieduserid AS `last_modified_user.last_modified_user_id`,
    lastmodifieduserdeleteduserid AS `last_modified_user.deleted_user_id`,
    lastmodifieduseremail AS `last_modified_user.email`,
    lastmodifieduseremailalias AS `last_modified_user.email_alias`,
    lastmodifieduserinactive AS `last_modified_user.inactive`,
    lastmodifieduserproductivitytarget AS `last_modified_user.productivity_target`,
    lastmodifieduserworkinghours AS `last_modified_user.working_hours`,
    lastmodifiedusersource AS `last_modified_user.source`,
    lastmodifieduseruserrole AS `last_modified_user.user_role`,
    lastmodifieduserpermissionuserrole AS `last_modified_user.permission_user_role`,
    entityname AS `entity.name`,
    entityemail AS `entity.email`,
    entitygroupid AS `entity_group.id`,
    entitygroupname AS `entity_group.name`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_job;

-- JobState View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobstate;
CREATE VIEW {etani_client_id}_fyi_jobstate AS
SELECT
    id,
    customerid AS `customer_id`,
    name,
    type,
    sourceid AS `source_id`,
    details,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    deleteduserid AS `deleted_user_id`,
    displayorder AS `display_order`,
    availableboard AS `available_board`,
    color,
    locktimes AS `lock_times`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobstate;

-- JobTemplate View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobtemplate;
CREATE VIEW {etani_client_id}_fyi_jobtemplate AS
SELECT
    id,
    name,
    status,
    salesaccount AS `sales_account`,
    brandingtheme AS `branding_theme`,
    createdon AS `created_on`,
    createduserid AS `created_user_id`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    source,
    sourceid AS `source_id`,
    itemdescription AS `item_description`,
    mode,
    type,
    referencecustomfieldid AS `reference_custom_field_id`,
    jobname AS `job_name`,
    parent_ids,
    budgetamount AS `budget_amount`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobtemplate;

-- JobType View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobtype;
CREATE VIEW {etani_client_id}_fyi_jobtype AS
SELECT
    id,
    name,
    status,
    createdon AS `created_on`,
    createduserid AS `created_user_id`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    source,
    sourceid AS `source_id`,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobtype;

-- Notification View
DROP VIEW IF EXISTS {etani_client_id}_fyi_notification;
CREATE VIEW {etani_client_id}_fyi_notification AS
SELECT
    id,
    state,
    type,
    sourcetable AS `source_table`,
    userid AS `user_id`,
    createdon AS `created_on`,
    clientid,
    organisationid,
    taskid AS `task.id`,
    taskcreatedon AS `task.created_on`,
    tasklastmodifiedon AS `task.last_modified_on`,
    tasksubject AS `task.subject`,
    taskmessage AS `task.message`,
    taskduedate AS `task.due_date`,
    taskstatus AS `task.status`,
    taskstartdate AS `task.start_date`,
    taskentity AS `task.entity`,
    taskentityid AS `task_entity.id`,
    taskentityname AS `task_entity.name`,
    taskentityemail AS `task_entity.email`,
    taskentitysource AS `task_entity.source`,
    taskentitysourceid AS `task_entity.source_id`,
    taskentityentitygroupid AS `task_entity.entity_group_id`,
    taskentitydetails AS `task_entity.details`,
    taskentitycollaborate AS `task_entity.collaborate`,
    taskentitymobile AS `task_entity.mobile`,
    taskentityphone AS `task_entity.phone`,
    taskentitybusinessnumber AS `task_entity.business_number`,
    taskentityisdeleted AS `task_entity.is_deleted`,
    taskentitylastmodifieduserid AS `task_entity.last_modified_user_id`,
    taskentitylastmodifiedon AS `task_entity.last_modified_on`,
    taskassigneduser AS `task.assigned_user`,
    taskassigneduserid AS `task_assigned_user.id`,
    taskassigneduserdisplayname AS `task_assigned_user.display_name`,
    taskassignedusercreatedon AS `task_assigned_user.created_on`,
    taskassignedusercreateduserid AS `task_assigned_user.created_user_id`,
    taskassigneduserlastmodifiedon AS `task_assigned_user.last_modified_on`,
    taskassigneduserlastmodifieduserid AS `task_assigned_user.last_modified_user_id`,
    taskassigneduserdeleteduserid AS `task_assigned_user.deleted_user_id`,
    taskassigneduseremail AS `task_assigned_user.email`,
    taskassigneduseremailalias AS `task_assigned_user.email_alias`,
    taskassigneduserinactive AS `task_assigned_user.inactive`,
    taskassigneduserproductivitytarget AS `task_assigned_user.productivity_target`,
    taskassigneduserworkinghours AS `task_assigned_user.working_hours`,
    taskassignedusersource AS `task_assigned_user.source`,
    taskassigneduseruserrole AS `task_assigned_user.user_role`,
    taskassigneduserpermissionuserrole AS `task_assigned_user.permission_user_role`,
    taskcreateduser AS `task.created_user`,
    taskcreateduserid AS `task_created_user.id`,
    taskcreateduserdisplayname AS `task_created_user.display_name`,
    taskcreatedusercreatedon AS `task_created_user.created_on`,
    taskcreatedusercreateduserid AS `task_created_user.created_user_id`,
    taskcreateduserlastmodifiedon AS `task_created_user.last_modified_on`,
    taskcreateduserlastmodifieduserid AS `task_created_user.last_modified_user_id`,
    taskcreateduserdeleteduserid AS `task_created_user.deleted_user_id`,
    taskcreateduseremail AS `task_created_user.email`,
    taskcreateduseremailalias AS `task_created_user.email_alias`,
    taskcreateduserinactive AS `task_created_user.inactive`,
    taskcreateduserproductivitytarget AS `task_created_user.productivity_target`,
    taskcreateduserworkinghours AS `task_created_user.working_hours`,
    taskcreatedusersource AS `task_created_user.source`,
    taskcreateduseruserrole AS `task_created_user.user_role`,
    taskcreateduserpermissionuserrole AS `task_created_user.permission_user_role`,
    taskcategories AS `task.categories`,
    taskcategoriesoptions AS `task_categories.options`,
    taskjob AS `task.job`,
    taskjobname AS `task_job.name`,
    taskjobid AS `task_job.id`,
    taskjobentityid AS `task_job.entity_id`,
    taskjobjobstateid AS `task_job.job_state_id`,
    taskjobstartdate AS `task_job.start_date`,
    taskjobjobtypeid AS `task_job.job_type_id`,
    taskjobcabinetid AS `task_job.cabinet_id`,
    taskjobmanageruserid AS `task_job.manager_user_id`,
    taskjobpartneruserid AS `task_job.partner_user_id`,
    taskjobcreateduserid AS `task_job.created_user_id`,
    taskjobcreatedon AS `task_job.created_on`,
    taskjoblastmodifiedon AS `task_job.last_modified_on`,
    taskjoblastmodifieduserid AS `task_job.last_modified_user_id`,
    taskjobcommentscount AS `task_job.comments_count`,
    taskjobprimary AS `task_job.primary`,
    taskjobtype AS `task_job.type`,
    taskjobworkflowenabled AS `task_job.workflow_enabled`,
    taskjobvalue AS `task_job.value`,
    taskjobduedate AS `task_job.due_date`,
    taskjobsource AS `task_job.source`,
    taskjobsourceid AS `task_job.source_id`,
    taskjobbudgetminutes AS `task_job.budget_minutes`,
    taskjobactualminutes AS `task_job.actual_minutes`,
    taskjobbudgetamount AS `task_job.budget_amount`,
    taskjobactualamount AS `task_job.actual_amount`,
    taskjobwipamount AS `task_job.wip_amount`,
    taskjobwriteonoff AS `task_job.write_on_off`,
    taskjobinvoicedamount AS `task_job.invoiced_amount`,
    taskjobparentid AS `task_job.parent_id`,
    taskjobusers AS `task_job.users`,
    taskjobtemplateid AS `task_job.template_id`,
    taskjobjobcustomfields AS `task_job.job_custom_fields`,
    taskjobxpmactualminutes AS `task_job.xpm_actual_minutes`,
    taskjobxpmestimatedminutes AS `task_job.xpm_estimated_minutes`,
    taskjobxpmvarianceminutes AS `task_job.xpm_variance_minutes`,
    taskdelegatoruser AS `task.delegator_user`,
    taskdelegatoruserid AS `task_delegator_user.id`,
    taskdelegatoruserdisplayname AS `task_delegator_user.display_name`,
    taskdelegatorusercreatedon AS `task_delegator_user.created_on`,
    taskdelegatorusercreateduserid AS `task_delegator_user.created_user_id`,
    taskdelegatoruserlastmodifiedon AS `task_delegator_user.last_modified_on`,
    taskdelegatoruserlastmodifieduserid AS `task_delegator_user.last_modified_user_id`,
    taskdelegatoruserdeleteduserid AS `task_delegator_user.deleted_user_id`,
    taskdelegatoruseremail AS `task_delegator_user.email`,
    taskdelegatoruseremailalias AS `task_delegator_user.email_alias`,
    taskdelegatoruserinactive AS `task_delegator_user.inactive`,
    taskdelegatoruserproductivitytarget AS `task_delegator_user.productivity_target`,
    taskdelegatoruserworkinghours AS `task_delegator_user.working_hours`,
    taskdelegatorusersource AS `task_delegator_user.source`,
    taskdelegatoruseruserrole AS `task_delegator_user.user_role`,
    taskdelegatoruserpermissionuserrole AS `task_delegator_user.permission_user_role`,
    useremail AS `user.email`,
    userdisplayname AS `user.display_name`,
    createduserid AS `created_user.id`,
    createduseremail AS `created_user.email`,
    createduserdisplayname AS `created_user.display_name`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_notification;

-- Rate View
DROP VIEW IF EXISTS {etani_client_id}_fyi_rate;
CREATE VIEW {etani_client_id}_fyi_rate AS
SELECT
    id,
    name,
    type,
    createdon AS `created_on`,
    lastmodifiedon AS `last_modified_on`,
    taxrate AS `tax_rate`,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_rate;

-- Tag View
DROP VIEW IF EXISTS {etani_client_id}_fyi_tag;
CREATE VIEW {etani_client_id}_fyi_tag AS
SELECT
    id,
    customerid AS `customer_id`,
    name,
    createduserid AS `created_user_id`,
    createdon AS `created_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    lastmodifiedon AS `last_modified_on`,
    deleteduserid AS `deleted_user_id`,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_tag;

-- Task View
DROP VIEW IF EXISTS {etani_client_id}_fyi_task;
CREATE VIEW {etani_client_id}_fyi_task AS
SELECT
    id,
    createdon AS `created_on`,
    lastmodifiedon AS `last_modified_on`,
    subject,
    message,
    duedate AS `due_date`,
    status,
    startdate AS `start_date`,
    commentcount AS `comment_count`,
    categories,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    entityid AS `entity.id`,
    entityname AS `entity.name`,
    entityemail AS `entity.email`,
    entitydetails AS `entity.details`,
    entityisdeleted AS `entity.is_deleted`,
    documentid AS `document.id`,
    documentcreatedon AS `document.created_on`,
    documentexternalid AS `document.external_id`,
    documentlastsavedon AS `document.last_saved_on`,
    documentlastmodifiedon AS `document.last_modified_on`,
    documentname AS `document.name`,
    documentdocumenttype AS `document.document_type`,
    documentreferencenumber AS `document.reference_number`,
    documentdetails AS `document.details`,
    documentkeywords AS `document.keywords`,
    assigneduserdisplayname AS `assigned_user.display_name`,
    assigneduseremail AS `assigned_user.email`,
    assigneduseremailalias AS `assigned_user.email_alias`,
    assigneduseruserrole AS `assigned_user.user_role`,
    assigneduserpermissionuserrole AS `assigned_user.permission_user_role`,
    createduserdisplayname AS `created_user.display_name`,
    createduseremail AS `created_user.email`,
    createduseremailalias AS `created_user.email_alias`,
    createduseruserrole AS `created_user.user_role`,
    createduserpermissionuserrole AS `created_user.permission_user_role`,
    cabinetid AS `cabinet.id`,
    cabinetname AS `cabinet.name`,
    cabinettype AS `cabinet.type`,
    cabinetisknowledge AS `cabinet.is_knowledge`,
    jobname AS `job.name`,
    jobid AS `job.id`,
    jobentityid AS `job.entity_id`,
    jobjobstateid AS `job.job_state_id`,
    jobstartdate AS `job.start_date`,
    jobjobtypeid AS `job.job_type_id`,
    jobcabinetid AS `job.cabinet_id`,
    jobmanageruserid AS `job.manager_user_id`,
    jobmanageruser AS `job.manager_user`,
    jobmanageruserdisplayname AS `job_manager_user.display_name`,
    jobmanageruseremail AS `job_manager_user.email`,
    jobmanageruseremailalias AS `job_manager_user.email_alias`,
    jobmanageruseruserrole AS `job_manager_user.user_role`,
    jobmanageruserpermissionuserrole AS `job_manager_user.permission_user_role`,
    jobpartneruserid AS `job.partner_user_id`,
    jobpartneruser AS `job.partner_user`,
    jobpartneruserdisplayname AS `job_partner_user.display_name`,
    jobpartneruseremail AS `job_partner_user.email`,
    jobpartneruseremailalias AS `job_partner_user.email_alias`,
    jobpartneruseruserrole AS `job_partner_user.user_role`,
    jobpartneruserpermissionuserrole AS `job_partner_user.permission_user_role`,
    jobcreateduserid AS `job.created_user_id`,
    jobcreatedon AS `job.created_on`,
    joblastmodifiedon AS `job.last_modified_on`,
    joblastmodifieduserid AS `job.last_modified_user_id`,
    jobcommentscount AS `job.comments_count`,
    jobprimary AS `job.primary`,
    jobtype AS `job.type`,
    jobworkflowenabled AS `job.workflow_enabled`,
    jobvalue AS `job.value`,
    jobduedate AS `job.due_date`,
    jobsource AS `job.source`,
    jobsourceid AS `job.source_id`,
    jobbudgetminutes AS `job.budget_minutes`,
    jobactualminutes AS `job.actual_minutes`,
    jobbudgetamount AS `job.budget_amount`,
    jobactualamount AS `job.actual_amount`,
    jobwipamount AS `job.wip_amount`,
    jobwriteonoff AS `job.write_on_off`,
    jobinvoicedamount AS `job.invoiced_amount`,
    jobparentid AS `job.parent_id`,
    jobusers AS `job.users`,
    jobtemplateid AS `job.template_id`,
    jobjobcustomfields AS `job.job_custom_fields`,
    jobxpmactualminutes AS `job.xpm_actual_minutes`,
    jobxpmestimatedminutes AS `job.xpm_estimated_minutes`,
    jobxpmvarianceminutes AS `job.xpm_variance_minutes`,
    delegatoruserdisplayname AS `delegator_user.display_name`,
    delegatoruseremail AS `delegator_user.email`,
    delegatoruseremailalias AS `delegator_user.email_alias`,
    delegatoruseruserrole AS `delegator_user.user_role`,
    delegatoruserpermissionuserrole AS `delegator_user.permission_user_role`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_task;

-- Pattern: {etani_client_id}_fyi_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- TimeEntry View
DROP VIEW IF EXISTS {etani_client_id}_fyi_timeentry;
CREATE VIEW {etani_client_id}_fyi_timeentry AS
SELECT
    id,
    entrytype AS `entry_type`,
    userid AS `user_id`,
    entityid AS `entity_id`,
    jobid AS `job_id`,
    entrydate AS `entry_date`,
    minutes,
    starttime AS `start_time`,
    status,
    billable,
    xpmtaskid AS `xpm_task_id`,
    notes,
    lastmodifiedon AS `last_modified_on`,
    writeonoff AS `write_on_off`,
    billableamount AS `billable_amount`,
    invoiceddate AS `invoiced_date`,
    invoicedamount AS `invoiced_amount`,
    timetypeid AS `time_type_id`,
    quantity,
    category,
    invoiceid AS `invoice_id`,
    documentid AS `document_id`,
    clientid,
    organisationid,
    userdisplayname AS `user.display_name`,
    usercreatedon AS `user.created_on`,
    usercreateduserid AS `user.created_user_id`,
    userlastmodifiedon AS `user.last_modified_on`,
    userlastmodifieduserid AS `user.last_modified_user_id`,
    userdeleteduserid AS `user.deleted_user_id`,
    useremail AS `user.email`,
    useremailalias AS `user.email_alias`,
    userinactive AS `user.inactive`,
    userproductivitytarget AS `user.productivity_target`,
    userworkinghours AS `user.working_hours`,
    usersource AS `user.source`,
    useruserrole AS `user.user_role`,
    userpermissionuserrole AS `user.permission_user_role`,
    entityname AS `entity.name`,
    entityemail AS `entity.email`,
    entitysource AS `entity.source`,
    entitysourceid AS `entity.source_id`,
    entityentitygroupid AS `entity.entity_group_id`,
    entitydetailsclientcode AS `entity.details.client_code`,
    entitydetailsexportcode AS `entity.details.export_code`,
    entitydetailsuuid AS `entity.details.uuid`,
    entitydetailsbusinessstructure AS `entity.details.business_structure`,
    entitycollaborate AS `entity.collaborate`,
    entitymobile AS `entity.mobile`,
    entityphone AS `entity.phone`,
    entityaddress AS `entity.address`,
    entitycity AS `entity.city`,
    entityregion AS `entity.region`,
    entitypostcode AS `entity.postcode`,
    entitycountry AS `entity.country`,
    entitypostaladdress AS `entity.postal_address`,
    entitypostalcity AS `entity.postal_city`,
    entitypostalregion AS `entity.postal_region`,
    entitypostalpostcode AS `entity.postal_postcode`,
    entitypostalcountry AS `entity.postal_country`,
    entitybusinessnumber AS `entity.business_number`,
    entitycompanynumber AS `entity.company_number`,
    entityisdeleted AS `entity.is_deleted`,
    entitylastmodifieduserid AS `entity.last_modified_user_id`,
    entitylastmodifiedon AS `entity.last_modified_on`,
    jobname AS `job.name`,
    jobentityid AS `job.entity_id`,
    jobjobstateid AS `job.job_state_id`,
    jobstartdate AS `job.start_date`,
    jobjobtypeid AS `job.job_type_id`,
    jobcabinetid AS `job.cabinet_id`,
    jobmanageruserid AS `job.manager_user_id`,
    jobpartneruserid AS `job.partner_user_id`,
    jobcreateduserid AS `job.created_user_id`,
    jobcreatedon AS `job.created_on`,
    joblastmodifiedon AS `job.last_modified_on`,
    joblastmodifieduserid AS `job.last_modified_user_id`,
    jobcommentscount AS `job.comments_count`,
    jobprimary AS `job.primary`,
    jobtype AS `job.type`,
    jobworkflowenabled AS `job.workflow_enabled`,
    jobvalue AS `job.value`,
    jobduedate AS `job.due_date`,
    jobsource AS `job.source`,
    jobsourceid AS `job.source_id`,
    jobbudgetminutes AS `job.budget_minutes`,
    jobactualminutes AS `job.actual_minutes`,
    jobbudgetamount AS `job.budget_amount`,
    jobactualamount AS `job.actual_amount`,
    jobwipamount AS `job.wip_amount`,
    jobwriteonoff AS `job.write_on_off`,
    jobinvoicedamount AS `job.invoiced_amount`,
    jobparentid AS `job.parent_id`,
    jobusers AS `job.users`,
    jobtemplateid AS `job.template_id`,
    jobjobcustomfields AS `job.job_custom_fields`,
    jobxpmactualminutes AS `job.xpm_actual_minutes`,
    jobxpmestimatedminutes AS `job.xpm_estimated_minutes`,
    jobxpmvarianceminutes AS `job.xpm_variance_minutes`,
    rateversionid AS `rate_version.id`,
    rateversionstartfrom AS `rate_version.start_from`,
    rateversionbillablerate AS `rate_version.billable_rate`,
    rateversionbaserate AS `rate_version.base_rate`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_timeentry;

-- User View
DROP VIEW IF EXISTS {etani_client_id}_fyi_user;
CREATE VIEW {etani_client_id}_fyi_user AS
SELECT
    id,
    displayname AS `display_name`,
    createdon AS `created_on`,
    createduserid AS `created_user_id`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    deleteduserid AS `deleted_user_id`,
    email,
    emailalias AS `email_alias`,
    inactive,
    productivitytarget AS `productivity_target`,
    workinghours AS `working_hours`,
    source,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    userroleid AS `user_role.id`,
    userrolename AS `user_role.name`,
    userroleoptions AS `user_role.options`,
    userroleoptionsrole AS `user_role_options.role`,
    userroleoptionsaccess AS `user_role_options.access`,
    userroleoptionsaccessviews AS `user_role_options_access.views`,
    userroleoptionsaccessprocess AS `user_role_options_access.process`,
    userroleoptionsaccesseditjobs AS `user_role_options_access.edit_jobs`,
    userroleoptionsaccessknowledge AS `user_role_options_access.knowledge`,
    userroleoptionsaccesstemplates AS `user_role_options_access.templates`,
    userroleoptionsaccesscreatejob AS `user_role_options_access.create_job`,
    userroleoptionsaccessprocessrunworkspace AS `user_role_options_access.process_run_workspace`,
    userroleoptionscabinets AS `user_role_options.cabinets`,
    userrolecreatedon AS `user_role.created_on`,
    userrolecreateduserid AS `user_role.created_user_id`,
    userrolelastmodifiedon AS `user_role.last_modified_on`,
    userrolelastmodifieduserid AS `user_role.last_modified_user_id`,
    permissionuserroleid AS `permission_user_role.id`,
    permissionuserrolename AS `permission_user_role.name`,
    permissionuserroleoptions AS `permission_user_role.options`,
    permissionuserroleoptionsrole AS `permission_user_role_options.role`,
    permissionuserroleoptionsaccess AS `permission_user_role_options.access`,
    permissionuserroleoptionsaccessviews AS `permission_user_role_options_access.views`,
    permissionuserroleoptionsaccessprocess AS `permission_user_role_options_access.process`,
    permissionuserroleoptionsaccesseditjobs AS `permission_user_role_options_access.edit_jobs`,
    permissionuserroleoptionsaccessknowledge AS `permission_user_role_options_access.knowledge`,
    permissionuserroleoptionsaccesstemplates AS `permission_user_role_options_access.templates`,
    permissionuserroleoptionsaccesscreatejob AS `permission_user_role_options_access.create_job`,
    permissionuserroleoptionsaccessprocessrunworkspace AS `permission_user_role_options_access.process_run_workspace`,
    permissionuserroleoptionscabinets AS `permission_user_role_options.cabinets`,
    permissionuserrolecreatedon AS `permission_user_role.created_on`,
    permissionuserrolecreateduserid AS `permission_user_role.created_user_id`,
    permissionuserrolelastmodifiedon AS `permission_user_role.last_modified_on`,
    permissionuserrolelastmodifieduserid AS `permission_user_role.last_modified_user_id`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_user;

-- UserRole View
DROP VIEW IF EXISTS {etani_client_id}_fyi_userrole;
CREATE VIEW {etani_client_id}_fyi_userrole AS
SELECT
    id,
    name,
    createdon AS `created_on`,
    createduserid AS `created_user_id`,
    lastmodifiedon AS `last_modified_on`,
    lastmodifieduserid AS `last_modified_user_id`,
    clientid AS `client_id`,
    organisationid AS `organisation_id`,
    optionsrole AS `options.role`,
    optionsaccess AS `options.access`,
    optionsaccessviews AS `options_access.views`,
    optionsaccessprocess AS `options_access.process`,
    optionsaccesseditjobs AS `options_access.edit_jobs`,
    optionsaccessknowledge AS `options_access.knowledge`,
    optionsaccesstemplates AS `options_access.templates`,
    optionsaccesscreatejob AS `options_access.create_job`,
    optionsaccesscollaborate AS `options_access.collaborate`,
    optionsaccesscreatereport AS `options_access.create_report`,
    optionsaccessprocessrunlist AS `options_access.process_run_list`,
    optionsaccesscustomfieldedit AS `options_access.custom_field_edit`,
    optionsaccessexportclientlist AS `options_access.export_client_list`,
    optionsaccessprocessrunworkspace AS `options_access.process_run_workspace`,
    optionscabinets AS `options.cabinets`,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_userrole;

-- InvoiceJobs View
DROP VIEW IF EXISTS {etani_client_id}_fyi_invoicejobs;
CREATE VIEW {etani_client_id}_fyi_invoicejobs AS
SELECT
    jobid AS `job_id`,
    jobname AS `job_name`,
    amount,
    wipamount AS `wip_amount`,
    invoiceid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_invoicejobs;

-- CabinetCategories View
DROP VIEW IF EXISTS {etani_client_id}_fyi_cabinetcategories;
CREATE VIEW {etani_client_id}_fyi_cabinetcategories AS
SELECT
    id,
    name,
    lastmodifiedon AS `last_modified_on`,
    createdon AS `created_on`,
    displayorder AS `display_order`,
    isrequired AS `is_required`,
    visibletemplates AS `visible_templates`,
    visibleprocesses AS `visible_processes`,
    cabinetid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_cabinetcategories;

-- CabinetCatOpts View
DROP VIEW IF EXISTS {etani_client_id}_fyi_cabinetcatopts;
CREATE VIEW {etani_client_id}_fyi_cabinetcatopts AS
SELECT
    id,
    name,
    displayorder AS `display_order`,
    categoryid AS `category_id`,
    detailscabinets AS `details.cabinets`,
    detailsconditional AS `details.conditional`,
    cabinetid,
    cabinetcategoriesid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_cabinetcatopts;

-- CategoryOptions View
DROP VIEW IF EXISTS {etani_client_id}_fyi_categoryoptions;
CREATE VIEW {etani_client_id}_fyi_categoryoptions AS
SELECT
    id,
    name,
    displayorder AS `display_order`,
    categoryid AS `category_id`,
    details,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_categoryoptions;

-- DocCategories View
DROP VIEW IF EXISTS {etani_client_id}_fyi_doccategories;
CREATE VIEW {etani_client_id}_fyi_doccategories AS
SELECT
    id,
    name,
    categoryid AS `category_id`,
    options,
    documentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_doccategories;

-- DocumentTags View
DROP VIEW IF EXISTS {etani_client_id}_fyi_documenttags;
CREATE VIEW {etani_client_id}_fyi_documenttags AS
SELECT
    id,
    name,
    documentid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_documenttags;

-- EntityContacts View
DROP VIEW IF EXISTS {etani_client_id}_fyi_entitycontacts;
CREATE VIEW {etani_client_id}_fyi_entitycontacts AS
SELECT
    id,
    source,
    sourceid AS `source_id`,
    addressee,
    email,
    mobile,
    name,
    phone,
    position,
    salutation,
    isdeleted AS `is_deleted`,
    entityid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_entitycontacts;

-- Pattern: {etani_client_id}_fyi_{entity}
-- Replace {etani_client_id} with actual value
-- AWS: Database prefixes are no longer needed with AWS

-- EntityCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_fyi_entitycustomfields;
CREATE VIEW {etani_client_id}_fyi_entitycustomfields AS
SELECT
    customfieldid AS `custom_field_id`,
    value,
    customfieldfieldtype AS `custom_field.field_type`,
    customfieldname AS `custom_field.name`,
    customfieldcreatedon AS `custom_field.created_on`,
    customfieldcreateduserid AS `custom_field.created_user_id`,
    customfieldlastmodifiedon AS `custom_field.last_modified_on`,
    customfieldlastmodifieduserid AS `custom_field.last_modified_user_id`,
    entityid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_entitycustomfields;

-- JobUsers View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobusers;
CREATE VIEW {etani_client_id}_fyi_jobusers AS
SELECT
    id,
    email,
    jobid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobusers;

-- JobJobCustFields View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobjobcustfields;
CREATE VIEW {etani_client_id}_fyi_jobjobcustfields AS
SELECT
    customfieldid AS `custom_field_id`,
    value,
    customfieldfieldtype AS `custom_field.field_type`,
    customfieldname AS `custom_field.name`,
    customfieldcreatedon AS `custom_field.created_on`,
    customfieldcreateduserid AS `custom_field.created_user_id`,
    customfieldlastmodifiedon AS `custom_field.last_modified_on`,
    customfieldlastmodifieduserid AS `custom_field.last_modified_user_id`,
    jobid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobjobcustfields;

-- JobTemplateCustFields View
DROP VIEW IF EXISTS {etani_client_id}_fyi_jobtemplatecustfields;
CREATE VIEW {etani_client_id}_fyi_jobtemplatecustfields AS
SELECT
    customfieldid AS `custom_field_id`,
    value,
    jobtemplateid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_jobtemplatecustfields;

-- RateVersions View
DROP VIEW IF EXISTS {etani_client_id}_fyi_rateversions;
CREATE VIEW {etani_client_id}_fyi_rateversions AS
SELECT
    id,
    startfrom AS `start_from`,
    billablerate AS `billable_rate`,
    baserate AS `base_rate`,
    rateid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_rateversions;

-- TimeEntryCustomFields View
DROP VIEW IF EXISTS {etani_client_id}_fyi_timeentrycustomfields;
CREATE VIEW {etani_client_id}_fyi_timeentrycustomfields AS
SELECT
    customfieldid AS `custom_field_id`,
    value,
    customfieldfieldtype AS `custom_field.field_type`,
    customfieldname AS `custom_field.name`,
    customfieldcreatedon AS `custom_field.created_on`,
    customfieldcreateduserid AS `custom_field.created_user_id`,
    customfieldlastmodifiedon AS `custom_field.last_modified_on`,
    customfieldlastmodifieduserid AS `custom_field.last_modified_user_id`,
    timeentryid,
    clientid,
    organisationid,
    etlinserttime,
    etlupdatetime
FROM c{clientID}_fyi_timeentrycustomfields;