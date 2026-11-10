DROP VIEW IF EXISTS [ClientPrefix]_myob_budgets_eva;
CREATE VIEW [ClientPrefix]_myob_budgets_eva AS
SELECT 
 a.`Type`, 
 b.`Job_Name` AS `JobName`,
 b.`Job_Number` AS `JobNumber`,
 b.`Account.DisplayID` AS `AccountCode`,
 CONCAT(b.`Year`, '-', LPAD(b.`Month`, 2, '0'), '-01') AS `Date`, 
 b.`Amount`,
 c.`CompanyName`,
 a.`ParentAccount.Name` AS `AccountsName`,
 a.`Classification` AS `AccountClass`,
 b.`OrganisationID`,
 a.`Type` AS `AccountType`
FROM `evadb_stage`.c[ClientID]_myob_budgetblend b 
LEFT JOIN `evadb_stage`.c[ClientID]_myob_accounts a
ON b.`Account.UID` = a.`UID`
LEFT JOIN `evadb_stage`.c[ClientID]_myob_company c
ON b.`OrganisationID` = c.`OrganisationID`