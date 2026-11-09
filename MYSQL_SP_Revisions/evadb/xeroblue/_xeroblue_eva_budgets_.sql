CREATE VIEW ClientPrefix_xeroblue_budgets_eva_ClientCurrency AS
SELECT 
   b.`BudgetID`                              AS `Budget ID`,
   b.`Status`                                AS `Status`,
   a.`Type`                                  AS `AccountType`,
   b.`Type`                                  AS `Type`,
   b.`Description`                           AS `Description`,
   STR_TO_DATE(CONCAT(`b`.`BudgetLines.BudgetBalances.Period`, '-01'), '%Y-%m-%d') AS `Date`,
   b.`BudgetLines`                           AS `Budget Lines`,
   b.`BudgetLines.AccountID`                 AS `Budget Lines Account ID`,
   b.`BudgetLines.AccountCode`               AS `Budget Lines Account Code`,
   b.`BudgetLines.BudgetBalances`            AS `Budget Lines Budget Balances`,
   b.`BudgetLines.BudgetBalances.Period`     AS `Budget Lines Budget Balances Period`,
   b.`BudgetLines.BudgetBalances.Amount`     AS `Budget Lines Budget Balances Amount`,
   b.`BudgetLines.BudgetBalances.Notes`      AS `Budget Lines Budget Balances Notes`,
   b.`Tracking`                              AS `Tracking`,
   b.`Tracking.1.Name`                       AS `TrackingName`,
   b.`Tracking.1.Option`                     AS `TrackingOption`,
   b.`Tracking.1.TrackingCategoryID`         AS `Tracking 1 Tracking Category ID`,
   b.`Tracking.1.TrackingOptionID`           AS `Tracking 1 Tracking Option ID`,
   b.`Tracking.2.Name`                       AS `Tracking 2 Name`,
   b.`Tracking.2.Option`                     AS `Tracking 2 Option`,
   b.`Tracking.2.TrackingCategoryID`         AS `Tracking 2 Tracking Category ID`,
   b.`Tracking.2.TrackingOptionID`           AS `Tracking 2 Tracking Option ID`,
   b.`ClientID`                              AS `ClientID`,
   b.`OrganisationID`                        AS `OrganisationID`,
   b.`BudgetLines.BudgetBalances.Amount_ClientCurrency` AS `Budget Lines Budget Balances Amount FX`,
   a.`Name` AS `AccountName`,
   a.`Class` AS `AccountClass`,
   o.`Name` AS `OrganisationName`,
   b.`BudgetLines.BudgetBalances.Amount_ClientCurrency`     AS `Amount`
FROM evadb_stage.c{ClientId}_xeroblue_budgets b
LEFT JOIN evadb_stage.c{ClientId}_xeroblue_accounts a
ON b.`BudgetLines.AccountCode` = a.`code`
LEFT JOIN evadb_stage.c{ClientId}_xeroblue_organisationsclients o
ON b.`OrganisationID` = o.`OrganisationID`
WHERE b.`BudgetLines.AccountID` IS NOT NULL;