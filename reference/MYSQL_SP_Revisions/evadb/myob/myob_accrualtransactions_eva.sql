DROP VIEW IF EXISTS [ClientPrefix]_myob_accrualtransactions_eva;
CREATE VIEW [ClientPrefix]_myob_accrualtransactions_eva AS
SELECT DISTINCT 
    t.`P_Items_DateOccurred` AS `Date`,
    t.`LineDescription` AS `Reference`,
    t.`P_Items_SourceTransaction_TransactionType` AS `Source Type`,
    t.`P_Items_Description` AS `Description`,
    t.`Account.UID` AS `AccountID`,
    t.`Account.DisplayID` AS `Account Code`,
    a.`Type` AS `Account Type`,
    t.`Account.Name` AS `Account Name`,
    CAST(CASE WHEN t.`isCredit` = 1 THEN t.`Amount` ELSE 0 - t.`Amount` END AS DECIMAL(18,2)) AS `Amount`,
    CAST(CASE WHEN t.`Amount` != 0 THEN tb.`TotalTax` ELSE 0 END AS DECIMAL(18,2)) AS `Tax Amount`,
    tb.`Contact.UID` AS `ContactID`,
    tb.`Contact.Name` AS `Contact Name`,
    CASE 
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Invoice' THEN 'Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Bill' THEN 'Bill'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CustomerPayment' THEN 'Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'SupplierPayment' THEN 'Bill'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditRefund' THEN 'Bill'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitRefund' THEN 'Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditSettlement' THEN 'Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitSettlement' THEN 'Bill'
        ELSE NULL 
    END AS `Invoice Or Bill`,
    CASE 
        WHEN a.`Classification` = 'OtherIncome' THEN 'Income'
        WHEN a.`Classification` = 'OtherExpense' THEN 'Income'
        WHEN a.`Classification` = 'CostOfSales' THEN 'Expense'
        ELSE a.`Classification`
    END AS `Account Class`,
    CAST(t.`OrganisationID` AS CHAR) AS `OrganisationID`,
    t.`P_Items_UID` AS `ID`,
    t.`P_Items_DisplayID` AS `JournalID`,
    CAST(t.`P_Items_DisplayID` AS CHAR) AS `Journal Number`,
    CAST(t.`P_Items_DatePosted` AS CHAR) AS `CreatedDateUTC`,
    t.`P_Items_SourceTransaction_UID` AS `SourceID`,
    t.`P_Items_UID` AS `JournalLineID`,
    a.`TaxCode.UID` AS `Tax Type`,
    a.`TaxCode.Code` AS `Tax Name`,
    t.`Job.UID` AS `JobUID`,
    t.`Job.Number` AS `Job Number`,
    t.`Job.Name` AS `Job Name`,
    t.`Job.URI` AS `Job URI`,
    t.`ClientID` AS `ClientID`,
    tb.`TransactionType` AS `Split`,
    tb.`TransactionType` AS `Contact Source`,
    CAST(NULL AS CHAR) AS `PaymentSourceID`,
    CAST(NULL AS CHAR) AS `Payment Type`,
    CASE WHEN tb.`Status` = 'Closed' THEN CAST(tb.`LastPaymentDate` AS CHAR) ELSE NULL END AS `Fully Paid On Date`,
    CASE WHEN tb.`Status` = 'Closed' THEN CAST(DATEDIFF(tb.`LastPaymentDate`, t.`P_Items_DateOccurred`) AS CHAR) ELSE NULL END AS `DayDifference`,
    CAST('ACCRUALS' AS CHAR) AS `JournalType`,
    o.`CompanyName` AS `Organisation Name`,
    ROW_NUMBER() OVER (ORDER BY t.`P_Items_DateOccurred` ASC) AS "Index", 
    tb.`ContactSourceNumber` AS `Source Number`,
    CASE 
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Invoice' THEN 'ACCREC'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Bill' THEN 'ACCPAY'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CustomerPayment' THEN 'ACCREC'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'SupplierPayment' THEN 'ACCPAY'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditRefund' THEN 'ACCPAY'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitRefund' THEN 'ACCREC'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditSettlement' THEN 'ACCREC'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitSettlement' THEN 'ACCPAY'
        ELSE NULL 
    END AS `ACC or ACCPAY`,
    CASE 
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Invoice' THEN 'Accruals'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Bill' THEN 'Accruals'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CustomerPayment' THEN 'Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'SupplierPayment' THEN 'Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditRefund' THEN 'Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitRefund' THEN 'Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditSettlement' THEN 'Accruals'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitSettlement' THEN 'Accruals'
        ELSE NULL 
    END AS `Aged Movement`,
    CAST(CASE WHEN a.`Type` = 'BANK' AND t.`isCredit` = 1 THEN t.`Amount` ELSE NULL END AS DECIMAL(18,2)) AS `Cash Received`,
    CAST(CASE WHEN a.`Type` = 'BANK' AND t.`isCredit` = 0 THEN 0 - t.`Amount` ELSE NULL END AS DECIMAL(18,2)) AS `Cash Spent`,
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
    CASE WHEN t.`isCredit` = 0 THEN CAST(t.`Amount` + IFNULL(tb.`TotalTax`, 0) AS DECIMAL(18,2)) ELSE NULL END AS `Debit Gross`,
    CASE WHEN t.`isCredit` = 0 THEN CAST(t.`Amount` AS DECIMAL(18,2)) ELSE NULL END AS `Debit Net Amount`,
    CASE WHEN t.`isCredit` = 1 THEN CAST(t.`Amount` + IFNULL(tb.`TotalTax`, 0) AS DECIMAL(18,2)) ELSE NULL END AS `Credit Gross`,
    CASE WHEN t.`isCredit` = 1 THEN CAST(t.`Amount` AS DECIMAL(18,2)) ELSE NULL END AS `Credit Net Amount`,
    CAST(t.`Amount` + IFNULL(tb.`TotalTax`, 0) AS DECIMAL(18,2)) AS `GrossAmountFX`,
    CASE
        WHEN 
          (CASE 
            WHEN t.`Account.Name` = 'GST Collected' THEN 'GST Collected'
            WHEN t.`Account.Name` = 'GST Paid' THEN 'GST Paid'
            ELSE t.`Account.Name`
          END) = 'GST Collected' THEN 'PLUS GST Movements'
        WHEN 
          (CASE 
            WHEN t.`Account.Name` = 'GST Collected' THEN 'GST Collected'
            WHEN t.`Account.Name` = 'GST Paid' THEN 'GST Paid'
            ELSE t.`Account.Name`
          END) = 'GST Paid' THEN 'PLUS GST Movements'
        WHEN a.`Type` = 'Bank' THEN 'Cash Surplus (Deficit)'
        WHEN a.`Classification` = 'Asset' THEN 'Income'
        WHEN a.`Classification` = 'Income' THEN 'Income'
        WHEN a.`Classification` = 'OtherIncome' THEN 'Income'
        WHEN a.`Classification` = 'Liability' THEN 'Less Expenses'
        WHEN a.`Classification` = 'Expense' THEN 'Less Expenses'
        WHEN a.`Classification` = 'OtherExpense' THEN 'Less Expenses'
        WHEN a.`Classification` = 'CostOfSales' THEN 'Less Expenses'
        WHEN a.`Classification` = 'Equity' THEN 'Less Expenses'
        ELSE t.`Account.Name`
    END AS `Cash Summary`,
    CASE 
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Invoice' THEN 'Receivable Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Bill' THEN 'Payable Invoice'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CustomerPayment' THEN 'Receivable Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'SupplierPayment' THEN 'Payable Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditRefund' THEN 'Receivable Credit Note Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitRefund' THEN 'Payable Credit Note Payment'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditSettlement' THEN 'Receivable Credit Note'
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitSettlement' THEN 'Payable Credit Note'
        ELSE NULL 
    END AS `Source`,
    CASE
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Invoice' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CustomerPayment' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditRefund' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitSettlement' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'Bill' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'SupplierPayment' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'DebitRefund' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        WHEN t.`P_Items_SourceTransaction_TransactionType` = 'CreditSettlement' THEN
            TRIM(REPLACE(CONCAT(t.`Account.UID`, ' | ', t.`P_Items_SourceTransaction_UID`), '  ', ' '))
        ELSE NULL
    END AS `Sync`,
    tb.`PromisedDate` AS `Planned Payment Date`,
    CAST(NULL AS CHAR) AS `Item Code`,
    CAST(NULL AS CHAR) AS `Quantity`,
    CAST(NULL AS CHAR) AS `Discount Rate`,
    CAST(NULL AS CHAR) AS `Unit Amount`,
    t.`P_Items_URI` AS `URL`,
    tb.`Terms.DueDate` AS `Due Date`,
    CAST(tb.`TotalAmount` AS DECIMAL(18,2)) AS `Invoice Total`
FROM evadb_stage.c[ClientID]_myob_journaltransactions t 
LEFT JOIN evadb_stage.c[ClientID]_myob_accounts a ON t.`Account.UID` = a.`UID` AND t.`OrganisationID` = a.`OrganisationID`
LEFT JOIN evadb_stage.c[ClientID]_myob_company o ON t.`OrganisationID` = o.`OrganisationID`
LEFT JOIN evadb_stage.c[ClientID]_myob_transactionblend tb ON t.`P_Items_SourceTransaction_UID` = tb.`UID`;