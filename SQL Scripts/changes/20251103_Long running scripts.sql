
-- VIRGATE PURE SPA long running Journals SP - update contact columns
-- Killed active query
-- reverted status to 1
UPDATE c1973_xeroblue_Journals J
LEFT JOIN c1973_xeroblue_transactions T
        ON j.`SourceId` = t.`Id`
        AND j.`OrganisationID` = t.`OrganisationID`        
SET  J.`ContactId` = t.`ContactID`, 
    J.`ContactName` = t.`ContactName`, 
    J.`ContactSource` = t.`Source`,
    J.`PaymentSourceID` = CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END,
    J.`PaymentType` =  CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END,
    J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
    J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
    J.`DayDifference` = t.`DayDifference`, 
    J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
    J.`ItemCode` = t.`ItemCode`, 
    J.`Quantity` = t.`Quantity`,
    J.`DiscountRate` = t.`DiscountRate`, 
    J.`CreditNoteNumber` = t.`CreditNoteNumber`,
    J.`UnitAmount` = t.`UnitAmount`, 
    J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
    J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
    J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
    J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
    J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
    J.`AmountDue` = t.`AmountDue`, 
    J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
    J.`AmountDue_USD` = t.`AmountDue_USD`, 
    J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
    J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
    J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
    J.`URL` = t.`URL`, 
    J.`InvoiceNumber` = t.`InvoiceNumber`,
    J.`DueDate` = t.`DueDate`, 
    J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END
WHERE j.ContactID IS NULL AND j.SourceID IS NOT NULL AND j.OrganisationID = 6868



-- ENSPIRA OrgID 5180 The Lab Melbourne long running Journals SP - update contact columns
-- Killed active query
-- reverted status to 1
UPDATE c844_xeroblue_JournalsCash J
LEFT JOIN c844_xeroblue_transactions T
        ON j.`SourceId` = t.`Id`
        AND j.`OrganisationID` = t.`OrganisationID`        
SET  J.`ContactId` = t.`ContactID`, 
    J.`ContactName` = t.`ContactName`, 
    J.`ContactSource` = t.`Source`,
    J.`PaymentSourceID` = CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END,
    J.`PaymentType` =  CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END,
    J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
    J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
    J.`DayDifference` = t.`DayDifference`, 
    J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
    J.`ItemCode` = t.`ItemCode`, 
    J.`Quantity` = t.`Quantity`,
    J.`DiscountRate` = t.`DiscountRate`, 
    J.`CreditNoteNumber` = t.`CreditNoteNumber`,
    J.`UnitAmount` = t.`UnitAmount`, 
    J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
    J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
    J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
    J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
    J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
    J.`AmountDue` = t.`AmountDue`, 
    J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
    J.`AmountDue_USD` = t.`AmountDue_USD`, 
    J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
    J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
    J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
    J.`URL` = t.`URL`, 
    J.`InvoiceNumber` = t.`InvoiceNumber`,
    J.`DueDate` = t.`DueDate`, 
    J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END
WHERE j.ContactID IS NULL AND j.SourceID IS NOT NULL AND j.OrganisationID = 5180



-- ENSPIRA OrgID 2268 Flor- Hanly long running Journals SP - update contact columns
-- Killed active query
-- reverted status to 1
UPDATE c861_xeroblue_Journals J
LEFT JOIN c861_xeroblue_transactions T
        ON j.`SourceId` = t.`Id`
        AND j.`OrganisationID` = t.`OrganisationID`        
SET  J.`ContactId` = t.`ContactID`, 
    J.`ContactName` = t.`ContactName`, 
    J.`ContactSource` = t.`Source`,
    J.`PaymentSourceID` = CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentSourceID` ELSE NULL END,
    J.`PaymentType` =  CASE WHEN t.`Source` = 'PAYMENTS' THEN t.`PaymentType` ELSE NULL END,
    J.`ShowOnCashBasisReports` =  t.`ShowOnCashBasisReports`, 
    J.`FullyPaidOnDate`= t.`FullyPaidOnDate`,
    J.`DayDifference` = t.`DayDifference`, 
    J.`PlannedPaymentDate` = t.`PlannedPaymentDate`, 
    J.`ItemCode` = t.`ItemCode`, 
    J.`Quantity` = t.`Quantity`,
    J.`DiscountRate` = t.`DiscountRate`, 
    J.`CreditNoteNumber` = t.`CreditNoteNumber`,
    J.`UnitAmount` = t.`UnitAmount`, 
    J.`UnitAmount_AUD` = t.`UnitAmount_AUD`, 
    J.`UnitAmount_USD` = t.`UnitAmount_USD`, 
    J.`UnitAmount_NZD` = t.`UnitAmount_NZD`, 
    J.`UnitAmount_EUR` = t.`UnitAmount_EUR`,
    J.`UnitAmount_GBP` =  t.`UnitAmount_GBP`, 
    J.`AmountDue` = t.`AmountDue`, 
    J.`AmountDue_AUD` = t.`AmountDue_AUD`, 
    J.`AmountDue_USD` = t.`AmountDue_USD`, 
    J.`AmountDue_NZD` = t.`AmountDue_NZD`, 
    J.`AmountDue_EUR` =  t.`AmountDue_EUR`,
    J.`AmountDue_GBP` = t.`AmountDue_GBP`, 
    J.`URL` = t.`URL`, 
    J.`InvoiceNumber` = t.`InvoiceNumber`,
    J.`DueDate` = t.`DueDate`, 
    J.`Reference` = CASE WHEN j.`Reference` IS NULL THEN t.`Reference` ELSE j.`Reference` END
WHERE j.ContactID IS NULL AND j.SourceID IS NOT NULL AND j.OrganisationID = 246



-- WILLIAMBUCK OrgID 5529 XPM Timesheets SP - update job_client_id, job_client_name, job_state, billable_without_leave, merged_staff_name_task_name columns
-- Causing active refresh to stuck on truncate table script
-- Killed old active query so new one can run (truncate table script)
UPDATE c1680_5529_xpm_timesheetsstage t
LEFT JOIN c1680_xpm_tasksdetail td 
    ON t.`OrganisationID` = td.`OrganisationID`
    AND t.`Job.ID` = td.`P_Response.Jobs.Job_ID`
SET
    t.`job_client_id` = `P_Response.Jobs.Job_Client_ID`,
    t.`job_client_name` = `P_Response.Jobs.Job_Client_Name`,
    t.`job_state` = `P_Response.Jobs.Job_State`,
    t.`billable_without_leave` = 
        CASE 
            WHEN t.`Task.Name` LIKE '%Leave%' THEN 'NA'
            WHEN t.`Task.Name` LIKE '%Public Holiday%' THEN 'NA'
            WHEN t.`Job.Name` LIKE '%Capacity Reducing%' THEN 'NA'
            WHEN t.`Job.Name` LIKE '%Leave%' THEN 'NA'
            WHEN t.`Billable` = 1 THEN 'Billable'
            WHEN t.`Billable` = 0 THEN 'Internal'
            ELSE 'UNKNOWN' 
        END,
    t.`merged_staff_name_task_name` = CONCAT(`Staff.Name`, '-', `Task.Name`)