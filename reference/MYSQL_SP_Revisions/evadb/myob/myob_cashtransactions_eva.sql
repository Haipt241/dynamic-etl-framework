DROP VIEW IF EXISTS [ClientPrefix]_myob_cashtransactions_eva;
CREATE VIEW [ClientPrefix]_myob_cashtransactions_eva AS
SELECT 
    psp.`Payment Date` AS `Date`, 
    CAST(jn.`LineDescription` AS CHAR(255)) AS `Reference`,
    CAST(psp.`Cash Type` AS CHAR(255)) AS `Source Type`,
    jn.`P_Items_Description` AS `Description`,
    CASE WHEN psp.`AccountUID` IS NULL THEN jn.`Account.UID` ELSE psp.`AccountUID` END AS `AccountID`,
    CASE WHEN psp.`Account.DisplayID` IS NULL THEN jn.`Account.DisplayID` ELSE psp.`Account.DisplayID` END AS `Account Code`,
    a.`Type` AS `Account Type`,
    CASE WHEN psp.`AccountName` IS NULL THEN jn.`Account.Name` ELSE psp.`AccountName` END AS `Account Name`,
    CAST(
        CASE 
            WHEN jn2.Amount IS NULL OR jn.Amount IS NULL THEN 
                psp.`AmountApplied Payment` * 
                CASE 
                    WHEN IFNULL(psp.`isCredit`, jn.`isCredit`) = 0 THEN -1 
                    ELSE 1 
                END
            WHEN jn2.Amount = 0 THEN 0
            ELSE 
                psp.`AmountApplied Payment` * (jn.Amount / jn2.Amount) * 
                CASE 
                    WHEN IFNULL(psp.`isCredit`, jn.`isCredit`) = 0 THEN -1 
                    ELSE 1 
                END
        END AS DECIMAL(18,2)
    ) AS `Amount`,
    CAST(NULL AS CHAR(255)) AS `Tax Amount`, 
    psp.`Payment Contact UID` AS `ContactID`,
    CAST(psp.`Payment Contact Name` AS CHAR(255)) AS `Contact Name`,
    jn.`P_Items_SourceTransaction_TransactionType` AS `Invoice Or Bill`,
    CASE 
        WHEN a.`Classification` = 'OtherIncome' THEN 'Income'
        WHEN a.`Classification` = 'OtherExpense' THEN 'Income'
        WHEN a.`Classification` = 'CostOfSales' THEN 'Expense'
        ELSE a.`Classification`
    END AS `Account Class`,
    CAST(psp.`OrganisationID` AS CHAR) AS `OrganisationID`, 
    psp.`Payment UID` AS `ID`,
    psp.`Payment UID` AS `JournalID`,
    CAST(psp.`Number Payment` AS CHAR) AS `Journal Number`,
    CAST(psp.`Payment Date` AS CHAR) AS `CreatedDateUTC`,
    CAST(NULL AS CHAR(255)) AS `SourceID`,
    psp.`UID FROM Payment Table` AS `JournalLineID`,
    CAST(NULL AS CHAR(255)) AS `Tax Type`, 
    CAST(NULL AS CHAR(255)) AS `Tax Name`, 
    psp.`Job.UID` AS `JobUID`,  
    psp.`Job.Number` AS `Job Number`, 
    psp.`Job.Name` AS `Job Name`, 
    psp.`Job.URI` AS `Job URI`, 
    psp.`ClientID` AS `ClientID`,
    CAST(NULL AS CHAR(255)) AS `Split`,
    CAST(NULL AS CHAR(255)) AS `Contact Source`,
    CAST(NULL AS CHAR(255)) AS `PaymentSourceID`,
    CAST(psp.`Payment Type` AS CHAR(255)) AS `Payment Type`,  
    CAST(NULL AS CHAR(255)) AS `Fully Paid On Date`,
    CAST(NULL AS CHAR(255)) AS `Day Difference`, 
    CAST('CASH' AS CHAR(255)) AS `JournalType`, 
    o.`CompanyName` AS `Organisation Name`, 
 ROW_NUMBER() OVER (ORDER BY psp.`Payment Date` ASC) AS "Index",
    CAST(NULL AS CHAR(255)) AS `Source Number`, 
    CAST(NULL AS CHAR(255)) AS `ACC or ACCPAY`, 
    CAST(NULL AS CHAR(255)) AS `Aged Movement`,
    CAST(
        CASE WHEN a.`Type` = 'BANK' AND IFNULL(psp.`isCredit`, jn.`isCredit`) = 1 THEN 
            CASE 
                WHEN jn2.Amount IS NULL OR jn.Amount IS NULL THEN 
                    psp.`AmountApplied Payment`
                WHEN jn2.Amount = 0 THEN 0
                ELSE 
                    psp.`AmountApplied Payment` * (jn.Amount / jn2.Amount)
            END
            ELSE NULL 
        END AS DECIMAL(18,2)
    ) AS `Cash Received`,
    CAST(
        CASE WHEN a.`Type` = 'BANK' AND IFNULL(psp.`isCredit`, jn.`isCredit`) = 0 THEN 
            0 - (CASE 
                WHEN jn2.Amount IS NULL OR jn.Amount IS NULL THEN 
                    psp.`AmountApplied Payment`
                WHEN jn2.Amount = 0 THEN 0
                ELSE 
                    psp.`AmountApplied Payment` * (jn.Amount / jn2.Amount)
            END)
            ELSE NULL 
        END AS DECIMAL(18,2)
    ) AS `Cash Spent`,
    CASE 
        WHEN a.`Classification` = 'Asset' THEN 'Cash In'
        WHEN a.`Classification` = 'Income' THEN 'Cash In'
        WHEN a.`Classification` = 'OtherIncome' THEN 'Cash In'
        WHEN a.`Classification` = 'Liability' THEN 'Cash Out'
        WHEN a.`Classification` = 'Expense' THEN 'Cash Out'
        WHEN a.`Classification` = 'OtherExpense' THEN 'Cash Out'
        WHEN a.`Classification` = 'CostOfSales' THEN 'Cash Out'
        ELSE 'UNKNOWN' 
    END AS `CashIn/CashOut`,
    CAST(0 AS DECIMAL(18,2)) AS `Debit Gross`, 
    CAST(0 AS DECIMAL(18,2)) AS `Debit Net Amount`, 
    CAST(0 AS DECIMAL(18,2)) AS `Credit Gross`, 
    CAST(0 AS DECIMAL(18,2)) AS `Credit Net Amount`,
    CAST(0 AS DECIMAL(18,2)) AS `GrossAmountFX`,
    CAST(NULL AS CHAR(255)) AS `Cash Summary`, 
    CASE 
        WHEN psp.`Cash Type` = 'Invoice' THEN 'Receivable Invoice'
        WHEN psp.`Cash Type` = 'CustomerPayment' THEN 'Receivable Payment'
        WHEN psp.`Cash Type` = 'SaleCustomerPayment' THEN 'Receivable Payment'
        WHEN psp.`Cash Type` = 'CreditRefund' THEN 'Receivable Credit Note Payment'
        WHEN psp.`Cash Type` = 'CreditSettlement' THEN 'Receivable Payment'
        WHEN psp.`Cash Type` = 'Sale Credit Settlement' THEN 'Receivable Payment'
        WHEN psp.`Cash Type` = 'Sale Credit Note' THEN 'Receivable Payment'
        WHEN psp.`Cash Type` = 'Bill' THEN 'Payable Invoice'  
        WHEN psp.`Cash Type` = 'SupplierPayment' THEN 'Payable Payment'      
        WHEN psp.`Cash Type` = 'PurchaseSupplierPayment' THEN 'Payable Payment'
        WHEN psp.`Cash Type` = 'DebitRefund' THEN 'Payable Credit Note Payment'
        WHEN psp.`Cash Type` = 'DebitSettlement' THEN 'Payable Payment'
        WHEN psp.`Cash Type` = 'Purchase Debit Settlement' THEN 'Payable Payment'
        WHEN psp.`Cash Type` = 'Purchase Debit Note' THEN 'Payable Payment'
        ELSE NULL 
    END AS `Source`,
    TRIM(REPLACE(CONCAT(CASE WHEN psp.`AccountUID` IS NULL THEN jn.`Account.UID` ELSE psp.`AccountUID` END, ' | ', psp.`UID FROM Payment Table`), '  ', ' ')) AS `Sync`,
    CAST(NULL AS CHAR(255)) AS `Planned Payment Date`, 
    CAST(NULL AS CHAR(255)) AS `Item Code`, 
    CAST(NULL AS CHAR(255)) AS `Quantity`, 
    CAST(NULL AS CHAR(255)) AS `Discount Rate`,
    CAST(NULL AS CHAR(255)) AS `Unit Amount`,
    CAST(NULL AS CHAR(255)) AS `URL`, 
    CAST(NULL AS CHAR(255)) AS `Due Date`, 
    CAST(psp.`Amount Payment` AS DECIMAL(18,2)) AS `Invoice Total`
FROM [ClientPrefix]_dq_myobar_paymenttransactionsblend psp 
LEFT JOIN evadb_stage.c[ClientID]_myob_journaltransactions jn 
ON psp.`UID FROM Payment Table` COLLATE utf8mb4_general_ci = jn.`P_Items_SourceTransaction_UID` COLLATE utf8mb4_general_ci
LEFT JOIN evadb_stage.c[ClientID]_myob_journaltransactions jn2 
ON psp.`UID FROM Payment Table` COLLATE utf8mb4_general_ci = jn2.`P_Items_SourceTransaction_UID` COLLATE utf8mb4_general_ci
AND (jn2.`Account.Name` COLLATE utf8mb4_general_ci = 'Trade Creditors' 
OR jn2.`Account.Name` COLLATE utf8mb4_general_ci = 'Trade Debtors')
LEFT JOIN evadb_stage.c[ClientID]_myob_accounts a 
ON (CASE WHEN psp.`AccountUID` IS NULL THEN jn.`Account.UID` ELSE psp.`AccountUID` END) 
= a.`UID` COLLATE utf8mb4_general_ci 
AND psp.`OrganisationID` COLLATE utf8mb4_general_ci = a.`OrganisationID` COLLATE utf8mb4_general_ci
LEFT JOIN evadb_stage.c[ClientID]_myob_company o 
ON psp.`OrganisationID` COLLATE utf8mb4_general_ci = o.`OrganisationID` COLLATE utf8mb4_general_ci