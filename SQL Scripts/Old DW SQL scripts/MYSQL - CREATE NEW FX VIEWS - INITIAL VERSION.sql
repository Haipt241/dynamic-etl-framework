DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_banktransactions_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_banktransactions_aud AS
SELECT
    `Id`                                        AS `Bank Transaction Line ID`,
    `BankTransactionId`                         AS `Bank Transaction ID`,
    `Type`                                      AS `Type`,
    `Contact_ContactName`                       AS `Contact Name`,
    `Contact_ContactId`                         AS `Contact ID`,
    `BankAccount_AccountId`                     AS `Account ID`,
    `BankAccount_AccountName`                   AS `Bank Account Account Name`,
    `BankAccount_Code`                          AS `Bank Account Code`,
    `LineItem_LineItemId`                       AS `Line Item ID`,
    `LineItem_Description`                      AS `Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_UnitAmount_AUD`                   AS `Unit Amount FX`,
    `LineItem_AccountCode`                      AS `Account Code Posted Against`,
    IFNULL(`LineItem_TaxType`, 'BLANK')         AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_TaxAmount_AUD`                    AS `Tax Amount FX`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_LineAmount_AUD`                   AS `Line Amount FX`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 CategoryID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 CategoryID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `LineItemAggregate`                         AS `Line Item Aggregate`,
    `IsReconciled`                              AS `Is Reconciled`,
    `Date`                                      AS `Date`,
    `Reference`                                 AS `Reference`,
    `CurrencyCode`                              AS `Currency Code`,
    `CurrencyRate`                              AS `Currency Rate`,
    `URL`                                       AS `URL`,
    `Status`                                    AS `Status`,
    `SubTotal`                                  AS `Sub Total`,
    `TotalTax`                                  AS `Total Tax`,
    `Total`                                     AS `Total`,
    `SubTotal_AUD`                              AS `Sub Total FX`,
    `TotalTax_AUD`                              AS `Total Tax FX`,
    `Total_AUD`                                 AS `Total FX`,
    `PrepaymentId`                              AS `Prepayment ID`,
    `OverpaymentId`                             AS `Overpayment ID`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `FullyPaidOnDate`                           AS `Fully Paid On Date`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `Account_UID`                               AS `Account_UID`,
    `BankTansactionCashflowCalculation`         AS `Bank Tansaction Cashflow Calculation`,
    `LineAmountCalculatedIncTax`                AS `Line Amount Calculated Inc Tax`,
    `PaymentAmount`                             AS `Payment Amount`,
    `BankTansactionCashflowCalculation_AUD`     AS `Bank Tansaction Cashflow Calculation FX`,
    `LineAmountCalculatedIncTax_AUD`            AS `Line Amount Calculated Inc Tax FX`,
    `PaymentAmount_AUD`                         AS `Payment Amount FX`
FROM evadb_stage.c1518_XEROBLUE_BankTransactions
WHERE `Status` = 'AUTHORISED';


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_banktransfers_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_banktransfers_aud AS
SELECT
    `BankTransferId`                            AS `Bank Transfer ID`,
    `FromBankAccount_Code`                      AS `From Bank Account Code`,
    `FromBankAccount_AccountId`                 AS `FromBankAccount_AccountId`,
    `FromBankAccount_Name`                      AS `From Bank Account Name`,
    `ToBankAccount_Code`                        AS `To Bank Account Code`,
    `ToBankAccount_AccountId`                   AS `ToBankAccount_AccountId`,
    `ToBankAccount_Name`                        AS `To Bank Account Name`,
    `Amount`                                    AS `Amount`,
    `Date`                                      AS `Date`,
    `CurrencyRate`                              AS `Currency Rate`,
    `FromBankTransactionID`                     AS `From Bank Transaction ID`,
    `ToBankTransactionID`                       AS `To Bank Transaction ID`,
    `HasAttachments`                            AS `Has Attachments`,
    `CreatedDateUTC`                            AS `Created Date UTC`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `Amount_AUD`                                AS `Amount FX`
FROM evadb_stage.c1518_XEROBLUE_BankTransfers;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnotes_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnotes_aud AS
SELECT
    `Id`                                        AS `Credit Note Line ID`,
    `CreditNoteId`                             AS `Credit Note ID`,
    `CreditNoteNumber`                          AS `Credit Note Number`,
    `Reference`                                 AS `Reference`,
    `Type`                                      AS `Type`,
    `Contact_ContactId`                         AS `Contact ID`,
    `Contact_Name`                             AS `Contact Name`,
    `Date`                                      AS `Date`,
    `Status`                                    AS `Status`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `LineItem_Description`                      AS `Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_AccountCode`                      AS `Account Code`,
    `LineItem_TaxType`                          AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_TaxAmount_AUD`                    AS `Tax FX Amount`,
    `LineItem_LineAmount_AUD`                   AS `Line FX Amount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate`                     AS `Discount Rate`,
    `LineItemAggregate`                         AS `Line Item Aggregate`,
    `SubTotal`                                  AS `Sub Total`,
    `TotalTax`                                  AS `Total Tax`,
    `Total`                                     AS `Total`,
    `SubTotal_AUD`                              AS `Sub FX Total`,
    `TotalTax_AUD`                              AS `Total FX Tax`,
    `Total_AUD`                                 AS `FX Total`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `CurrencyCode`                              AS `Currency Code`,
    `FullyPaidOnDate`                           AS `Fully Paid On Date`,
    `SentToContact`                             AS `Sent To Contact`,
    `BrandingThemeId`                           AS `Branding Theme ID`,
    `CurrencyRate`                              AS `Currency Rate`,
    `RemainingCredit`                           AS `Remaining Credit`,
    `RemainingCredit_AUD`                       AS `Remaining Credit FX`,
	`HasAttachments`							AS `Has Attachments`,
	`ClientID`									AS `Client ID` ,
	`OrganisationID`							AS `Organisation ID`,
    `Allocation1_AppliedAmount`                 AS `Allocation 1 Applied Amount`,
    `Allocation1_AppliedAmount_AUD`             AS `Allocation 1 Applied Amount FX`,
    `Allocation1_Date`                          AS `Allocation 1 Date`,
    `Allocation1_InvoiceId`                     AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber`                 AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount`                 AS `Allocation 2 Applied Amount`,
    `Allocation2_AppliedAmount_AUD`             AS `Allocation 2 Applied Amount FX`,
    `Allocation2_Date`                          AS `Allocation 2 Date`,
    `Allocation2_InvoiceId`                     AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber`                 AS `Allocation 2 Invoice Number`,
    `Allocation3_AppliedAmount`                 AS `Allocation 3 Applied Amount`,
    `Allocation3_AppliedAmount_AUD`             AS `Allocation 3 Applied Amount FX`,
    `Allocation3_Date`                          AS `Allocation 3 Date`,
    `Allocation3_InvoiceId`                     AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber`                 AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount`                 AS `Allocation 4 Applied Amount`,
    `Allocation4_AppliedAmount_AUD`             AS `Allocation 4 Applied Amount FX`,
    `Allocation4_Date`                          AS `Allocation 4 Date`,
    `Allocation4_InvoiceId`                     AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber`                 AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount`                 AS `Allocation 5 Applied Amount`,
    `Allocation5_AppliedAmount_AUD`             AS `Allocation 5 Applied Amount FX`,
    `Allocation5_Date`                          AS `Allocation 5 Date`,
    `Allocation5_InvoiceId`                     AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber`                 AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount`                 AS `Allocation 6 Applied Amount`,
    `Allocation6_AppliedAmount_AUD`             AS `Allocation 6 Applied Amount FX`,
    `Allocation6_Date`                          AS `Allocation 6 Date`,
    `Allocation6_InvoiceId`                     AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber`                 AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount`                 AS `Allocation 7 Applied Amount`,
    `Allocation7_AppliedAmount_AUD`             AS `Allocation 7 Applied Amount FX`,
    `Allocation7_Date`                          AS `Allocation 7 Date`,
    `Allocation7_InvoiceId`                     AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber`                 AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount`                 AS `Allocation 8 Applied Amount`,
    `Allocation8_AppliedAmount_AUD`             AS `Allocation 8 Applied Amount FX`,
    `Allocation8_Date`                          AS `Allocation 8 Date`,
    `Allocation8_InvoiceId`                     AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber`                 AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount`                 AS `Allocation 9 Applied Amount`,
    `Allocation9_AppliedAmount_AUD`             AS `Allocation 9 Applied Amount FX`,
    `Allocation9_Date`                          AS `Allocation 9 Date`,
    `Allocation9_InvoiceId`                     AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber`                 AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount`                AS `Allocation 10 Applied Amount`,
    `Allocation10_AppliedAmount_AUD`            AS `Allocation 10 Applied Amount FX`,
    `Allocation10_Date`                         AS `Allocation 10 Date`,
    `Allocation10_InvoiceId`                    AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber`                AS `Allocation 10 Invoice Number`,
    `Allocation11_AppliedAmount`                AS `Allocation 11 Applied Amount`,
    `Allocation11_AppliedAmount_AUD`            AS `Allocation 11 Applied Amount FX`,
    `Allocation11_Date`                         AS `Allocation 11 Date`,
    `Allocation11_InvoiceId`                    AS `Allocation 11 Invoice ID`,
    `Allocation11_InvoiceNumber`                AS `Allocation 11 Invoice Number`,
    `Allocation12_AppliedAmount`                AS `Allocation 12 Applied Amount`,
    `Allocation12_AppliedAmount_AUD`            AS `Allocation 12 Applied Amount FX`,
    `Allocation12_Date`                         AS `Allocation 12 Date`,
    `Allocation12_InvoiceId`                    AS `Allocation 12 Invoice ID`,
    `Allocation12_InvoiceNumber`                AS `Allocation 12 Invoice Number`,
    `Allocation13_AppliedAmount`                AS `Allocation 13 Applied Amount`,
    `Allocation13_AppliedAmount_AUD`            AS `Allocation 13 Applied Amount FX`,
    `Allocation13_Date`                         AS `Allocation 13 Date`,
    `Allocation13_InvoiceId`                    AS `Allocation 13 Invoice ID`,
    `Allocation13_InvoiceNumber`                AS `Allocation 13 Invoice Number`,
    `Allocation14_AppliedAmount`                AS `Allocation 14 Applied Amount`,
    `Allocation14_AppliedAmount_AUD`            AS `Allocation 14 Applied Amount FX`,
    `Allocation14_Date`                         AS `Allocation 14 Date`,
    `Allocation14_InvoiceId`                    AS `Allocation 14 Invoice ID`,
    `Allocation14_InvoiceNumber`                AS `Allocation 14 Invoice Number`,
    `Allocation15_AppliedAmount`                AS `Allocation 15 Applied Amount`,
    `Allocation15_AppliedAmount_AUD`            AS `Allocation 15 Applied Amount FX`,
    `Allocation15_Date`                         AS `Allocation 15 Date`,
    `Allocation15_InvoiceId`                    AS `Allocation 15 Invoice ID`,
    `Allocation15_InvoiceNumber`                AS `Allocation 15 Invoice Number`,
    `AccountUID`                                AS `Account UID`,
    `LineAmountCreditNoteCalculation`           AS `Line Amount Credit Note Calculation`,
    `LineAmountTradeCreditorCalculation`        AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation`          AS `Line Amount Trade Debtor Calculation`,
    `LineAmountCreditNoteCalculation_AUD`       AS `Line Amount Credit Note Calculation FX`,
    `LineAmountTradeCreditorCalculation_AUD`    AS `Line Amount Trade Creditor Calculation FX`,
    `LineAmountTradeDebtorCalculation_AUD`      AS `Line Amount Trade Debtor Calculation FX`
FROM evadb_stage.c1518_XEROBLUE_CreditNotes
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoices_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoices_aud AS
SELECT
    `Id`                                        AS `Invoice Line ID`,
    `InvoiceId`                                 AS `Invoice ID`,
    `Type`                                      AS `Type`,
    `ContactId`                                 AS `Contact ID`,
    `ContactName`                               AS `Contact Name`,
    `LineItem_LineItemId`                       AS `Line Item ID`,
    `LineItem_Description`                      AS `Line Item - Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_AccountCode`                      AS `Account Code`,
    `LineItem_TaxType`                          AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_TaxAmount_AUD`                    AS `Tax FX Amount`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_LineAmount_AUD`                   AS `Line FX Amount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `DiscountRate`                              AS `Discount Rate`,
    `DiscountRate%`                             AS `Discount Rate %`,
    `LineItem_DiscountAmount`                   AS `Discount Amount`,
    `LineItem_DiscountAmount_AUD`               AS `Discount FX Amount`,
    `LineItemAggregate`                         AS `Aggregate`,
    `Date`                                      AS `Date`,
    `DueDate`                                   AS `Due Date`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `InvoiceNumber`                             AS `Invoice Number`,
    `Reference`                                 AS `Reference`,
    `BrandingThemeId`                           AS `Branding Theme ID`,
    `URL`                                       AS `URL`,
    `CurrencyCode`                              AS `Currency Code`,
    `CurrencyRate`                              AS `Currency Rate`,
    `Status`                                    AS `Status`,
    `SentToContact`                             AS `Sent To Contact`,
    `ExpectedPaymentDate`                       AS `Expected Payment Date`,
    `PlannedPaymentDate`                        AS `Planned Payment Date`,
    `SubTotal`                                  AS `Invoice - Sub Total`,
    `SubTotal_AUD`                              AS `Invoice - FX Sub Total`,
    `TotalTax`                                  AS `Invoice - Total Tax`,
    `TotalTax_AUD`                              AS `Invoice - FX Total Tax`,
    `Total_AUD`                                 AS `Invoice Total`,
    `TotalDiscount_AUD`                         AS `Total Discount`,
    `HasAttachments`                            AS `Has Attachments`,
    `AmountDue_AUD`                             AS `Invoice - Amount Due`,
    `AmountPaid_AUD`                            AS `Invoice - Amount Paid`,
    `CISDeduction_AUD`                           AS `CIS Deduction`,
    `FullyPaidOnDate`                           AS `Fully Paid On Date`,
    `AmountCredited_AUD`                        AS `Amount Credited`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `CreditNotes`                               AS `Credit Notes`,
    `Payments`                                 AS `Payments`,
    `Prepayments`                              AS `Pre Payments`,
    `Overpayments`                             AS `Over Payments`,
    `RepeatingInvoiceID`                        AS `Repeating Invoice ID`,
    `Account_UID`                               AS `Account_UID`,
    `PaymentIds`                                AS `Payment ID`,
    `PrePaymentIds`                             AS `Pre Payment ID`,
    `OverPaymentIds`                            AS `Over Payment ID`,
    `CreditNoteIDs`                             AS `Credit Note ID`,
    `LineAmountCalculation`                      AS `Line Amount Calculation`,
    `LineAmountCalculation_AUD`                  AS `Line Amount FX Calculation`,
    `LineAmountCalculationIncTax`                AS `Line Amount Calculation Inc Tax`,
    `LineAmountCalculationIncTax_AUD`            AS `Line Amount FX Calculation Inc Tax`,
    `LineAmountTradeCreditorCalculation`         AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeCreditorCalculation_AUD`     AS `Line Amount FX Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation`           AS `Line Amount Trade Debtor Calculation`,
    `LineAmountTradeDebtorCalculation_AUD`       AS `Line Amount FX Trade Debtor Calculation`,
    `DayDifference`                              AS `Day Difference`
FROM evadb_stage.c1518_XEROBLUE_Invoices AS i
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journals_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journals_aud AS
SELECT
    `Id`                                        AS `ID`,
    `JournalId`                                 AS `Journal ID`,
    `JournalDate`                               AS `Journal Date`,
    `JournalNumber`                             AS `Journal Number`,
    `CreatedDateUTC`                            AS `Created Date UTC`,
    `Reference`                                 AS `Reference`,
    `SourceId`                                  AS `Source ID`,
    `SourceType`                                AS `Source Type`,
    `JournalLine_JournalLineId`                 AS `Journal Line ID`,
    `JournalLine_Description`                   AS `Description`,
    `JournalLine_AccountId`                     AS `Account ID`,
    `JournalLine_AccountCode`                   AS `Account Code`,
    `JournalLine_AccountType`                   AS `Account Type`,
    `JournalLine_AccountName`                   AS `Account Name`,
    `JournalLine_NetAmount`                     AS `Net Amount`,
    `JournalLine_GrossAmount`                   AS `Gross Amount`,
    `JournalLine_TaxAmount`                     AS `Tax Amount`,
    `JournalLine_NetAmount_AUD`                 AS `Net Amount FX`,
    `JournalLine_GrossAmount_AUD`               AS `Gross Amount FX`,
    `JournalLine_TaxAmount_AUD`                 AS `Tax Amount FX`,
    `JournalLine_TaxType`                       AS `Tax Type`,
    `JournalLine_TaxName`                       AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `Split`                                     AS `Split`
FROM evadb_stage.c1518_XEROBLUE_Journals;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscash_aud AS
SELECT
    `Id`                                        AS `ID`,
    `JournalId`                                 AS `Journal ID`,
    `JournalDate`                               AS `Journal Date`,
    `JournalNumber`                             AS `Journal Number`,
    `CreatedDateUTC`                            AS `Created Date UTC`,
    `Reference`                                 AS `Reference`,
    `SourceId`                                  AS `Source ID`,
    `SourceType`                                AS `Source Type`,
    `JournalLine_JournalLineId`                 AS `Journal Line ID`,
    `JournalLine_Description`                   AS `Description`,
    `JournalLine_AccountId`                     AS `Account ID`,
    `JournalLine_AccountCode`                   AS `Account Code`,
    `JournalLine_AccountType`                   AS `Account Type`,
    `JournalLine_AccountName`                   AS `Account Name`,
    `JournalLine_NetAmount`                     AS `Net Amount`,
    `JournalLine_GrossAmount`                   AS `Gross Amount`,
    `JournalLine_TaxAmount`                     AS `Tax Amount`,
    `JournalLine_NetAmount_AUD`                 AS `Net Amount FX`,
    `JournalLine_GrossAmount_AUD`               AS `Gross Amount FX`,
    `JournalLine_TaxAmount_AUD`                 AS `Tax Amount FX`,
    `JournalLine_TaxType`                       AS `Tax Type`,
    `JournalLine_TaxName`                       AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `Split`                                     AS `Split`
FROM evadb_stage.c1518_XEROBLUE_JournalsCash;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_payments_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_payments_aud AS
SELECT
    `PaymentId`         AS `Payment ID`,
    `Date`              AS `Date`,
    `Amount`            AS `Amount`,
    `Amount_AUD`        AS `Amount FX`,
    `CurrencyRate`      AS `Currency Rate`,
    `Reference`         AS `Reference`,
    `PaymentType`       AS `Payment Type`,
    `Status`            AS `Status`,
    `UpdatedDateUTC`    AS `Updated Date UTC`,
    `IsReconciled`      AS `Is Reconciled`,
    `BatchPaymentId`    AS `Batch Payment ID`,
    `InvoiceId`         AS `Invoice ID`,
    `InvoiceNumber`     AS `Invoice Number`,
    `CreditNoteId`      AS `Credit Note ID`,
    `CreditNoteNumber`  AS `Credit Note Number`,
    `AccountId`         AS `Account ID`,
    `AccountCode`       AS `Account Code`,
    `ClientID`          AS `Client ID`,
    `OrganisationID`    AS `Organisation ID`
FROM (
    SELECT * ,
        Row_number() OVER(PARTITION BY `PaymentId` ORDER BY `PaymentId`) rn
    FROM evadb_stage.c1518_XEROBLUE_Payments
    WHERE `Status` IN ('AUTHORISED')
) t
WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud AS
SELECT 
    `OverpaymentId`                              AS `OverpaymentId`, 
    `Date`                                       AS `Date`,
    `Type`                                       AS `Type`,
    `RemainingCredit`                            AS `RemainingCredit`,
    `RemainingCredit_AUD`                        AS `RemainingCredit FX`,
    `Contact_ContactId`                          AS `Contact ID`,
    `Contact_Name`                               AS `Contact Name`,
    `Status`                                     AS `Status`,
    `SubTotal`                                   AS `SubTotal`,
    `SubTotal_AUD`                               AS `SubTotal FX`,
    `TotalTax`                                   AS `TotalTax`,
    `TotalTax_AUD`                               AS `TotalTax FX`,
    `Total`                                      AS `Total`,
    `Total_AUD`                                  AS `Total FX`,
    `LineItem_LineItemId`                        AS `Line Item ID`,
    `LineItem_Description`                       AS `Description`,
    `LineItem_Quantity`                          AS `Quantity`,
    `LineItem_UnitAmount`                        AS `Unit Amount`,
    `LineItem_ItemCode`                          AS `Item Code`,
    `LineItem_AccountCode`                       AS `Account Code`,
    `LineItem_TaxType`                           AS `Tax Type`,
    `LineItem_TaxAmount`                         AS `Tax Amount`,
    `LineItem_TaxAmount_AUD`                     AS `Tax Amount FX`,
    `LineItem_LineAmount`                        AS `Line Amount`,
    `LineItem_LineAmount_AUD`                    AS `Line Amount FX`,
    `LineItem_TrackingCategory1_CategoryId`      AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`    AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`        AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`      AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`     AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`      AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`    AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`        AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`      AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`     AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate`                      AS `Discount Rate`,
    `LineAmountTypes`                            AS `Line Amount Types`,
    `CurrencyCode`                               AS `Currency Code`,
    `CurrencyRate`                               AS `Currency Rate`,
    `UpdatedDateUTC`                             AS `Updated Date UTC`,
    `Allocation1_AppliedAmount`                  AS `Allocation 1 Applied Amount`,
    `Allocation1_AppliedAmount_AUD`              AS `Allocation 1 Applied Amount FX`,
    `Allocation1_Date`                           AS `Allocation 1 Date`,
    `Allocation1_InvoiceId`                      AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber`                  AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount`                  AS `Allocation 2 Applied Amount`,
    `Allocation2_AppliedAmount_AUD`              AS `Allocation 2 Applied Amount FX`,
    `Allocation2_Date`                           AS `Allocation 2 Date`,
    `Allocation2_InvoiceId`                      AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber`                  AS `Allocation 2 Invoice Number`,
    `Allocation3_AppliedAmount`                  AS `Allocation 3 Applied Amount`,
    `Allocation3_AppliedAmount_AUD`              AS `Allocation 3 Applied Amount FX`,
    `Allocation3_Date`                           AS `Allocation 3 Date`,
    `Allocation3_InvoiceId`                      AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber`                  AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount`                  AS `Allocation 4 Applied Amount`,
    `Allocation4_AppliedAmount_AUD`              AS `Allocation 4 Applied Amount FX`,
    `Allocation4_Date`                           AS `Allocation 4 Date`,
    `Allocation4_InvoiceId`                      AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber`                  AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount`                  AS `Allocation 5 Applied Amount`,
    `Allocation5_AppliedAmount_AUD`              AS `Allocation 5 Applied Amount FX`,
    `Allocation5_Date`                           AS `Allocation 5 Date`,
    `Allocation5_InvoiceId`                      AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber`                  AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount`                  AS `Allocation 6 Applied Amount`,
    `Allocation6_AppliedAmount_AUD`              AS `Allocation 6 Applied Amount FX`,
    `Allocation6_Date`                           AS `Allocation 6 Date`,
    `Allocation6_InvoiceId`                      AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber`                  AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount`                  AS `Allocation 7 Applied Amount`,
    `Allocation7_AppliedAmount_AUD`              AS `Allocation 7 Applied Amount FX`,
    `Allocation7_Date`                           AS `Allocation 7 Date`,
    `Allocation7_InvoiceId`                      AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber`                  AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount`                  AS `Allocation 8 Applied Amount`,
    `Allocation8_AppliedAmount_AUD`              AS `Allocation 8 Applied Amount FX`,
    `Allocation8_Date`                           AS `Allocation 8 Date`,
    `Allocation8_InvoiceId`                      AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber`                  AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount`                  AS `Allocation 9 Applied Amount`,
    `Allocation9_AppliedAmount_AUD`              AS `Allocation 9 Applied Amount FX`,
    `Allocation9_Date`                           AS `Allocation 9 Date`,
    `Allocation9_InvoiceId`                      AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber`                  AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount`                 AS `Allocation 10 Applied Amount`,
    `Allocation10_AppliedAmount_AUD`             AS `Allocation 10 Applied Amount FX`,
    `Allocation10_Date`                          AS `Allocation 10 Date`,
    `Allocation10_InvoiceId`                     AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber`                 AS `Allocation 10 Invoice Number`,
    `HasAttachments`                             AS `Has Attachments`,
    `Payments`                                   AS `Payments`,
    `ClientID`                                   AS `Client ID`,
    `OrganisationID`                             AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_overpayments
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud AS
SELECT 
    `Id`                                        AS `Id`, 
    `CreditNoteId`                              AS `CreditNoteId`,
    `CreditNoteNumber`                          AS `CreditNoteNumber`,
    `Reference`                                 AS `Reference`,
    `Type`                                      AS `Type`,
    `Contact_ContactId`                         AS `Contact_ContactId`,
    `Contact_Name`                              AS `Contact_Name`,
    `Date`                                      AS `Date`,
    `Status`                                    AS `Status`,
    `LineAmountTypes`                           AS `LineAmountTypes`,
    `LineItem_Quantity`                         AS `LineItem_Quantity`,
    `LineItem_Description`                      AS `LineItem_Description`,
    `LineItem_UnitAmount`                       AS `LineItem_UnitAmount`,
    `LineItem_ItemCode`                         AS `LineItem_ItemCode`,
    `LineItem_AccountCode`                      AS `LineItem_AccountCode`,
    `LineItem_TaxType`                          AS `LineItem_TaxType`,
    `LineItem_TaxAmount`                        AS `LineItem_TaxAmount`,
    `LineItem_TaxAmount_AUD`                    AS `LineItem_TaxAmount FX`,
    `LineItem_LineAmount`                       AS `LineItem_LineAmount`,
    `LineItem_LineAmount_AUD`                   AS `LineItem_LineAmount FX`,
    `LineItem_TrackingCategory1_CategoryId`     AS `LineItem_TrackingCategory1_CategoryId`,
    `LineItem_TrackingCategory1_CategoryName`   AS `LineItem_TrackingCategory1_CategoryName`,
    `LineItem_TrackingCategory1_OptionId`       AS `LineItem_TrackingCategory1_OptionId`,
    `LineItem_TrackingCategory1_OptionName`     AS `LineItem_TrackingCategory1_OptionName`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `LineItem_TrackingCategory1_Option_Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `LineItem_TrackingCategory2_CategoryId`,
    `LineItem_TrackingCategory2_CategoryName`   AS `LineItem_TrackingCategory2_CategoryName`,
    `LineItem_TrackingCategory2_OptionId`       AS `LineItem_TrackingCategory2_OptionId`,
    `LineItem_TrackingCategory2_OptionName`     AS `LineItem_TrackingCategory2_OptionName`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `LineItem_TrackingCategory2_Option_Stat`,
    `LineItem_DiscountRate`                     AS `LineItem_DiscountRate`,
    `LineItemAggregate`                         AS `LineItemAggregate`,
    `SubTotal`                                  AS `SubTotal`,
    `SubTotal_AUD`                              AS `SubTotal FX`,
    `TotalTax`                                  AS `TotalTax`,
    `TotalTax_AUD`                              AS `TotalTax FX`,
    `Total`                                     AS `Total`,
    `Total_AUD`                                 AS `Total FX`,
    `UpdatedDateUTC`                            AS `UpdatedDateUTC`,
    `CurrencyCode`                              AS `CurrencyCode`,
    `FullyPaidOnDate`                           AS `FullyPaidOnDate`,
    `SentToContact`                             AS `SentToContact`,
    `BrandingThemeId`                           AS `BrandingThemeId`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `RemainingCredit`                           AS `RemainingCredit`,
    `RemainingCredit_AUD`                       AS `RemainingCredit FX`,
    `Allocation1_AppliedAmount`                 AS `Allocation1_AppliedAmount`,
    `Allocation1_AppliedAmount_AUD`             AS `Allocation1_AppliedAmount FX`,
    `Allocation1_Date`                          AS `Allocation1_Date`,
    `Allocation1_InvoiceId`                     AS `Allocation1_InvoiceId`,
    `Allocation1_InvoiceNumber`                 AS `Allocation1_InvoiceNumber`,
    `Allocation2_AppliedAmount`                 AS `Allocation2_AppliedAmount`,
    `Allocation2_AppliedAmount_AUD`             AS `Allocation2_AppliedAmount FX`,
    `Allocation2_Date`                          AS `Allocation2_Date`,
    `Allocation2_InvoiceId`                     AS `Allocation2_InvoiceId`,
    `Allocation2_InvoiceNumber`                 AS `Allocation2_InvoiceNumber`,
    `Allocation3_AppliedAmount`                 AS `Allocation3_AppliedAmount`,
    `Allocation3_AppliedAmount_AUD`            AS `Allocation3_AppliedAmount FX`,
    `Allocation3_Date`                         AS `Allocation3_Date`,
    `Allocation3_InvoiceId`                    AS `Allocation3_InvoiceId`,
    `Allocation3_InvoiceNumber`                AS `Allocation3_InvoiceNumber`,
    `Allocation4_AppliedAmount`                AS `Allocation4_AppliedAmount`,
    `Allocation4_AppliedAmount_AUD`            AS `Allocation4_AppliedAmount FX`,
    `Allocation4_Date`                         AS `Allocation4_Date`,
    `Allocation4_InvoiceId`                    AS `Allocation4_InvoiceId`,
    `Allocation4_InvoiceNumber`                AS `Allocation4_InvoiceNumber`,
    `Allocation5_AppliedAmount`                AS `Allocation5_AppliedAmount`,
    `Allocation5_AppliedAmount_AUD`            AS `Allocation5_AppliedAmount FX`,
    `Allocation5_Date`                         AS `Allocation5_Date`,
    `Allocation5_InvoiceId`                    AS `Allocation5_InvoiceId`,
    `Allocation5_InvoiceNumber`                AS `Allocation5_InvoiceNumber`,
    `Allocation6_AppliedAmount`                AS `Allocation6_AppliedAmount`,
    `Allocation6_AppliedAmount_AUD`            AS `Allocation6_AppliedAmount FX`,
    `Allocation6_Date`                         AS `Allocation6_Date`,
    `Allocation6_InvoiceId`                    AS `Allocation6_InvoiceId`,
    `Allocation6_InvoiceNumber`                AS `Allocation6_InvoiceNumber`,
    `Allocation7_AppliedAmount`                AS `Allocation7_AppliedAmount`,
    `Allocation7_AppliedAmount_AUD`            AS `Allocation7_AppliedAmount FX`,
    `Allocation7_Date`                         AS `Allocation7_Date`,
    `Allocation7_InvoiceId`                    AS `Allocation7_InvoiceId`,
    `Allocation7_InvoiceNumber`                AS `Allocation7_InvoiceNumber`,
    `Allocation8_AppliedAmount`                AS `Allocation8_AppliedAmount`,
    `Allocation8_AppliedAmount_AUD`            AS `Allocation8_AppliedAmount FX`,
    `Allocation8_Date`                         AS `Allocation8_Date`,
    `Allocation8_InvoiceId`                    AS `Allocation8_InvoiceId`,
    `Allocation8_InvoiceNumber`                AS `Allocation8_InvoiceNumber`,
    `Allocation9_AppliedAmount`                AS `Allocation9_AppliedAmount`,
    `Allocation9_AppliedAmount_AUD`            AS `Allocation9_AppliedAmount FX`,
    `Allocation9_Date`                         AS `Allocation9_Date`,
    `Allocation9_InvoiceId`                    AS `Allocation9_InvoiceId`,
    `Allocation9_InvoiceNumber`                AS `Allocation9_InvoiceNumber`,
    `Allocation10_AppliedAmount`               AS `Allocation10_AppliedAmount`,
    `Allocation10_AppliedAmount_AUD`           AS `Allocation10_AppliedAmount FX`,
    `Allocation10_Date`                        AS `Allocation10_Date`,
    `Allocation10_InvoiceId`                   AS `Allocation10_InvoiceId`,
    `Allocation10_InvoiceNumber`               AS `Allocation10_InvoiceNumber`,
    `Allocation11_AppliedAmount`               AS `Allocation11_AppliedAmount`,
    `Allocation11_AppliedAmount_AUD`           AS `Allocation11_AppliedAmount FX`,
    `Allocation11_Date`                        AS `Allocation11_Date`,
    `Allocation11_InvoiceId`                   AS `Allocation11_InvoiceId`,
    `Allocation11_InvoiceNumber`               AS `Allocation11_InvoiceNumber`,
    `Allocation12_AppliedAmount`               AS `Allocation12_AppliedAmount`,
    `Allocation12_AppliedAmount_AUD`           AS `Allocation12_AppliedAmount FX`,
    `Allocation12_Date`                        AS `Allocation12_Date`,
    `Allocation12_InvoiceId`                   AS `Allocation12_InvoiceId`,
    `Allocation12_InvoiceNumber`               AS `Allocation12_InvoiceNumber`,
    `Allocation13_AppliedAmount`               AS `Allocation13_AppliedAmount`,
    `Allocation13_AppliedAmount_AUD`           AS `Allocation13_AppliedAmount FX`,
    `Allocation13_Date`                        AS `Allocation13_Date`,
    `Allocation13_InvoiceId`                   AS `Allocation13_InvoiceId`,
    `Allocation13_InvoiceNumber`               AS `Allocation13_InvoiceNumber`,
    `Allocation14_AppliedAmount`               AS `Allocation14_AppliedAmount`,
    `Allocation14_AppliedAmount_AUD`           AS `Allocation14_AppliedAmount FX`,
    `Allocation14_Date`                        AS `Allocation14_Date`,
    `Allocation14_InvoiceId`                   AS `Allocation14_InvoiceId`,
    `Allocation14_InvoiceNumber`               AS `Allocation14_InvoiceNumber`,
    `Allocation15_AppliedAmount`               AS `Allocation15_AppliedAmount`,
    `Allocation15_AppliedAmount_AUD`           AS `Allocation15_AppliedAmount FX`,
    `Allocation15_Date`                        AS `Allocation15_Date`,
    `Allocation15_InvoiceId`                   AS `Allocation15_InvoiceId`,
    `Allocation15_InvoiceNumber`               AS `Allocation15_InvoiceNumber`,
    `HasAttachments`                           AS `HasAttachments`,
    `ClientID`                                 AS `ClientID`,
    `OrganisationID`                           AS `OrganisationID`
FROM evadb_stage.c1518_xeroblue_creditnotes
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud AS
SELECT 
    `PrepaymentId`                              AS `PrepaymentId`, 
    `Date`                                      AS `Date`,
    `Reference`                                 AS `Reference`,
    `Type`                                      AS `Type`,
    `RemainingCredit`                           AS `RemainingCredit`,
    `RemainingCredit_AUD`                       AS `RemainingCredit FX`,
    `Contact_ContactId`                         AS `Contact ID`,
    `Contact_Name`                              AS `Contact Name`,
    `Status`                                    AS `Status`,
    `SubTotal`                                  AS `SubTotal`,
    `SubTotal_AUD`                              AS `SubTotal FX`,
    `TotalTax`                                  AS `TotalTax`,
    `TotalTax_AUD`                              AS `TotalTax FX`,
    `Total`                                     AS `Total`,
    `Total_AUD`                                 AS `Total FX`,
    `LineItem_LineItemId`                       AS `Line Item ID`,
    `LineItem_Description`                      AS `Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_AccountCode`                      AS `Account Code`,
    `LineItem_TaxType`                          AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_TaxAmount_AUD`                    AS `Tax Amount FX`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_LineAmount_AUD`                   AS `Line Amount FX`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate`                     AS `Discount Rate`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `CurrencyCode`                              AS `CurrencyCode`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `Allocation1_AppliedAmount`                 AS `Allocation 1 Applied Amount`,
    `Allocation1_AppliedAmount_AUD`             AS `Allocation 1 Applied Amount FX`,
    `Allocation1_Date`                          AS `Allocation 1 Date`,
    `Allocation1_InvoiceId`                     AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber`                 AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount`                 AS `Allocation 2 Applied Amount`,
    `Allocation2_AppliedAmount_AUD`             AS `Allocation 2 Applied Amount FX`,
    `Allocation2_Date`                          AS `Allocation 2 Date`,
    `Allocation2_InvoiceId`                     AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber`                 AS `Allocation 2 Invoice Number`,
    `Allocation3_AppliedAmount`                 AS `Allocation 3 Applied Amount`,
    `Allocation3_AppliedAmount_AUD`             AS `Allocation 3 Applied Amount FX`,
    `Allocation3_Date`                          AS `Allocation 3 Date`,
    `Allocation3_InvoiceId`                     AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber`                 AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount`                 AS `Allocation 4 Applied Amount`,
    `Allocation4_AppliedAmount_AUD`             AS `Allocation 4 Applied Amount FX`,
    `Allocation4_Date`                          AS `Allocation 4 Date`,
    `Allocation4_InvoiceId`                     AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber`                 AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount`                 AS `Allocation 5 Applied Amount`,
    `Allocation5_AppliedAmount_AUD`             AS `Allocation 5 Applied Amount FX`,
    `Allocation5_Date`                          AS `Allocation 5 Date`,
    `Allocation5_InvoiceId`                     AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber`                 AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount`                 AS `Allocation 6 Applied Amount`,
    `Allocation6_AppliedAmount_AUD`             AS `Allocation 6 Applied Amount FX`,
    `Allocation6_Date`                          AS `Allocation 6 Date`,
    `Allocation6_InvoiceId`                     AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber`                 AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount`                 AS `Allocation 7 Applied Amount`,
    `Allocation7_AppliedAmount_AUD`             AS `Allocation 7 Applied Amount FX`,
    `Allocation7_Date`                          AS `Allocation 7 Date`,
    `Allocation7_InvoiceId`                     AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber`                 AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount`                 AS `Allocation 8 Applied Amount`,
    `Allocation8_AppliedAmount_AUD`             AS `Allocation 8 Applied Amount FX`,
    `Allocation8_Date`                          AS `Allocation 8 Date`,
    `Allocation8_InvoiceId`                     AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber`                 AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount`                 AS `Allocation 9 Applied Amount`,
    `Allocation9_AppliedAmount_AUD`             AS `Allocation 9 Applied Amount FX`,
    `Allocation9_Date`                          AS `Allocation 9 Date`,
    `Allocation9_InvoiceId`                     AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber`                 AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount`                AS `Allocation 10 Applied Amount`,
    `Allocation10_AppliedAmount_AUD`            AS `Allocation 10 Applied Amount FX`,
    `Allocation10_Date`                         AS `Allocation 10 Date`,
    `Allocation10_InvoiceId`                    AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber`                AS `Allocation 10 Invoice Number`,
    `HasAttachments`                            AS `HasAttachments`,
    `Payments`                                  AS `Payments`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`
FROM evadb_stage.c1518_xeroblue_prepayments
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicesoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicesoriginal_aud AS
SELECT 
    `Id`                                        AS `Id`, 
    `InvoiceId`                                 AS `InvoiceId`,
    `Type`                                      AS `Type`,
    `ContactId`                                 AS `ContactId`,
    `ContactName`                               AS `ContactName`,
    `LineItem_LineItemId`                       AS `LineItem_LineItemId`,
    `LineItem_Description`                      AS `LineItem_Description`,
    `LineItem_Quantity`                         AS `LineItem_Quantity`,
    `LineItem_UnitAmount`                       AS `LineItem_UnitAmount`,
    `LineItem_ItemCode`                         AS `LineItem_ItemCode`,
    `LineItem_AccountCode`                      AS `LineItem_AccountCode`,
    `LineItem_TaxType`                          AS `LineItem_TaxType`,
    `LineItem_TaxAmount`                        AS `LineItem_TaxAmount`,
    `LineItem_TaxAmount_AUD`                    AS `LineItem_TaxAmount FX`,
    `LineItem_LineAmount`                       AS `LineItem_LineAmount`,
    `LineItem_LineAmount_AUD`                   AS `LineItem_LineAmount FX`,
    `LineItem_TrackingCategory1_CategoryId`     AS `LineItem_TrackingCategory1_CategoryId`,
    `LineItem_TrackingCategory1_CategoryName`   AS `LineItem_TrackingCategory1_CategoryName`,
    `LineItem_TrackingCategory1_OptionId`       AS `LineItem_TrackingCategory1_OptionId`,
    `LineItem_TrackingCategory1_OptionName`     AS `LineItem_TrackingCategory1_OptionName`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `LineItem_TrackingCategory1_Option_Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `LineItem_TrackingCategory2_CategoryId`,
    `LineItem_TrackingCategory2_CategoryName`   AS `LineItem_TrackingCategory2_CategoryName`,
    `LineItem_TrackingCategory2_OptionId`       AS `LineItem_TrackingCategory2_OptionId`,
    `LineItem_TrackingCategory2_OptionName`     AS `LineItem_TrackingCategory2_OptionName`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `LineItem_TrackingCategory2_Option_Stat`,
    `LineItem_DiscountRate`                     AS `LineItem_DiscountRate`,
    `LineItem_DiscountAmount`                   AS `LineItem_DiscountAmount`,
    `LineItem_DiscountAmount_AUD`               AS `LineItem_DiscountAmount FX`,
    `LineItemAggregate`                         AS `LineItemAggregate`,
    `Date`                                      AS `Date`,
    `DueDate`                                   AS `DueDate`,
    `LineAmountTypes`                           AS `LineAmountTypes`,
    `InvoiceNumber`                             AS `InvoiceNumber`,
    `Reference`                                 AS `Reference`,
    `BrandingThemeId`                           AS `BrandingThemeId`,
    `URL`                                       AS `URL`,
    `CurrencyCode`                              AS `CurrencyCode`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `Status`                                    AS `Status`,
    `SentToContact`                             AS `SentToContact`,
    `ExpectedPaymentDate`                       AS `ExpectedPaymentDate`,
    `PlannedPaymentDate`                        AS `PlannedPaymentDate`,
    `SubTotal`                                  AS `SubTotal`,
    `SubTotal_AUD`                              AS `SubTotal FX`,
    `TotalTax`                                  AS `TotalTax`,
    `TotalTax_AUD`                              AS `TotalTax FX`,
    `Total`                                     AS `Total`,
    `Total_AUD`                                 AS `Total FX`,
    `TotalDiscount`                             AS `TotalDiscount`,
    `TotalDiscount_AUD`                         AS `TotalDiscount FX`,
    `HasAttachments`                            AS `HasAttachments`,
    `PaymentIds`                                AS `PaymentIds`,
    `PrePaymentIds`                             AS `PrePaymentIds`,
    `OverPaymentIds`                            AS `OverPaymentIds`,
    `CreditNoteIds`                             AS `CreditNoteIds`,
    `AmountDue`                                 AS `AmountDue`,
    `AmountDue_AUD`                             AS `AmountDue FX`,
    `AmountPaid`                                AS `AmountPaid`,
    `AmountPaid_AUD`                            AS `AmountPaid FX`,
    `CISDeduction`                              AS `CISDeduction`,
    `CISDeduction_AUD`                            AS `CISDeduction FX`,
    `FullyPaidOnDate`                         AS `FullyPaidOnDate`,
    `AmountCredited`                          AS `AmountCredited`,
    `AmountCredited_AUD`                      AS `AmountCredited FX`,
    `UpdatedDateUTC`                          AS `UpdatedDateUTC`,
    `CreditNotes`                             AS `CreditNotes`,
    `Prepayments`                             AS `Prepayments`,
    `Payments`                                AS `Payments`,
    `Overpayments`                            AS `Overpayments`,
    `RepeatingInvoiceID`                      AS `RepeatingInvoiceID`,
    `ClientID`                                AS `ClientID`,
    `OrganisationID`                          AS `OrganisationID`
FROM evadb_stage.c1518_xeroblue_invoices
WHERE `Status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud AS
SELECT 
    `PaymentId`                                 AS `PaymentId`, 
    `Date`                                      AS `Date`,
    `Amount`                                    AS `Amount`,
    `CurrencyRate`                              AS `CurrencyRate`,
    `Reference`                                 AS `Reference`,
    `PaymentType`                               AS `PaymentType`,
    `Status`                                    AS `Status`,
    `UpdatedDateUTC`                            AS `UpdatedDateUTC`,
    `IsReconciled`                              AS `IsReconciled`,
    `BatchPaymentId`                            AS `BatchPaymentId`,
    `InvoiceId`                                 AS `InvoiceId`,
    `InvoiceNumber`                             AS `InvoiceNumber`,
    `CreditNoteId`                              AS `CreditNoteId`,
    `CreditNoteNumber`                          AS `CreditNoteNumber`,
    `AccountId`                                 AS `AccountId`,
    `AccountCode`                               AS `AccountCode`,
    `ClientID`                                  AS `ClientID`,
    `OrganisationID`                            AS `OrganisationID`,
    `Amount_AUD`                                AS `Amount FX`
FROM evadb_stage.c1518_xeroblue_payments
WHERE `Status` IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invovrpymtallo_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invovrpymtallo_aud AS
SELECT
    i.id,
    i.invoiceid,
    i.type,
    i.contactid,
    i.contactname,
    i.lineitem_lineitemid,
    i.lineitem_description,
    i.lineitem_quantity,
    i.lineitem_unitamount,
    i.lineitem_itemcode,
    i.lineitem_accountcode,
    i.lineitem_taxtype,
    i.lineitem_taxamount,
    i.lineitem_lineamount,
    i.lineitem_trackingcategory1_categoryid,
    i.lineitem_trackingcategory1_categoryname,
    i.lineitem_trackingcategory1_optionid,
    i.lineitem_trackingcategory1_optionname,
    i.lineitem_trackingcategory1_option_stat,
    i.lineitem_trackingcategory2_categoryid,
    i.lineitem_trackingcategory2_categoryname,
    i.lineitem_trackingcategory2_optionid,
    i.lineitem_trackingcategory2_optionname,
    i.lineitem_trackingcategory2_option_stat,
    i.lineitem_discountrate,
    i.lineitem_discountamount,
    i.lineitemaggregate,
    i.date,
    i.duedate,
    i.lineamounttypes,
    i.invoicenumber,
    i.reference,
    i.brandingthemeid,
    i.url,
    i.currencycode,
    i.currencyrate,
    i.status,
    i.senttocontact,
    i.expectedpaymentdate,
    i.plannedpaymentdate,
    i.subtotal,
    i.totaltax,
    i.total,
    i.totaldiscount,
    i.hasattachments,
    i.paymentids,
    i.prepaymentids,
    i.overpaymentids,
    i.creditnoteids,
    i.amountdue,
    i.amountpaid,
    i.cisdeduction,
    i.fullypaidondate,
    i.amountcredited,
    i.updateddateutc,
    i.creditnotes,
    i.prepayments,
    i.payments,
    i.overpayments,
    i.repeatinginvoiceid,
    i.clientid,
    i.organisationid,
    a.invoiceid                 AS `overpaymentinvoiceid`,
    a.overpaymentid,
    a.allocation                AS `overpaymentallocation`,
    a.dt                        AS `overpaymentdate`,
    a.amount                    AS `overpaymentamount`,
    i.lineitem_lineamount_aud   AS `LineItem_LineAmount FX`,
    i.lineitem_taxamount_aud    AS `LineItem_TaxAmount FX`,
    i.amountdue_aud             AS `AmountDue FX`,
    i.amountpaid_aud            AS `AmountPaid FX`,
    i.cisdeduction_aud          AS `CISDeduction FX`,
    i.amountcredited_aud        AS `AmountCredited FX`,
    a.amount_fx                 AS `OverPaymentAmount FX`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 1 Invoice ID` AS `invoiceid`, 
        1 AS `allocation`,
        `Allocation 1 Date` AS `dt`,
        `Allocation 1 Applied Amount` AS `amount`,
        `Allocation 1 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 1 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 2 Invoice ID` AS `invoiceid`, 
        2 AS `allocation`,
        `Allocation 2 Date` AS `dt`,
        `Allocation 2 Applied Amount` AS `amount`,
        `Allocation 2 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 2 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 3 Invoice ID` AS `invoiceid`, 
        3 AS `allocation`,
        `Allocation 3 Date` AS `dt`,
        `Allocation 3 Applied Amount` AS `amount`,
        `Allocation 3 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 3 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 4 Invoice ID` AS `invoiceid`, 
        4 AS `allocation`,
        `Allocation 4 Date` AS `dt`,
        `Allocation 4 Applied Amount` AS `amount`,
        `Allocation 4 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 4 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 5 Invoice ID` AS `invoiceid`, 
        5 AS `allocation`,
        `Allocation 5 Date` AS `dt`,
        `Allocation 5 Applied Amount` AS `amount`,
        `Allocation 5 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 5 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 6 Invoice ID` AS `invoiceid`, 
        6 AS `allocation`,
        `Allocation 6 Date` AS `dt`,
        `Allocation 6 Applied Amount` AS `amount`,
        `Allocation 6 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 6 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 7 Invoice ID` AS `invoiceid`, 
        7 AS `allocation`,
        `Allocation 7 Date` AS `dt`,
        `Allocation 7 Applied Amount` AS `amount`,
        `Allocation 7 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 7 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 8 Invoice ID` AS `invoiceid`, 
        8 AS `allocation`,
        `Allocation 8 Date` AS `dt`,
        `Allocation 8 Applied Amount` AS `amount`,
        `Allocation 8 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 8 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 9 Invoice ID` AS `invoiceid`, 
        9 AS `allocation`,
        `Allocation 9 Date` AS `dt`,
        `Allocation 9 Applied Amount` AS `amount`,
        `Allocation 9 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 9 Applied Amount` IS NOT NULL
    UNION ALL
    SELECT 
        `Organisation ID`,
        `OverpaymentId`,
        `Allocation 10 Invoice ID` AS `invoiceid`, 
        10 AS `allocation`,
        `Allocation 10 Date` AS `dt`,
        `Allocation 10 Applied Amount` AS `amount`,
        `Allocation 10 Applied Amount FX` AS `amount_fx`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 10 Applied Amount` IS NOT NULL
) a ON i.`invoiceid` = a.`invoiceid` AND i.`organisationid` = a.`Organisation ID`
WHERE i.`status` IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invprepymtallo_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invprepymtallo_aud AS
SELECT 
    i.id,
    i.invoiceid,
    i.type,
    i.contactid,
    i.contactname,
    i.lineitem_lineitemid,
    i.lineitem_description,
    i.lineitem_quantity,
    i.lineitem_unitamount,
    i.lineitem_itemcode,
    i.lineitem_accountcode,
    i.lineitem_taxtype,
    i.lineitem_taxamount,
    i.lineitem_lineamount,
    i.lineitem_trackingcategory1_categoryid,
    i.lineitem_trackingcategory1_categoryname,
    i.lineitem_trackingcategory1_optionid,
    i.lineitem_trackingcategory1_optionname,
    i.lineitem_trackingcategory1_option_stat,
    i.lineitem_trackingcategory2_categoryid,
    i.lineitem_trackingcategory2_categoryname,
    i.lineitem_trackingcategory2_optionid,
    i.lineitem_trackingcategory2_optionname,
    i.lineitem_trackingcategory2_option_stat,
    i.lineitem_discountrate,
    i.lineitem_discountamount,
    i.lineitemaggregate,
    i.date,
    i.duedate,
    i.lineamounttypes,
    i.invoicenumber,
    i.reference,
    i.brandingthemeid,
    i.url,
    i.currencycode,
    i.currencyrate,
    i.status,
    i.senttocontact,
    i.expectedpaymentdate,
    i.plannedpaymentdate,
    i.subtotal,
    i.totaltax,
    i.total,
    i.totaldiscount,
    i.hasattachments,
    i.paymentids,
    i.prepaymentids,
    i.overpaymentids,
    i.creditnoteids,
    i.amountdue,
    i.amountpaid,
    i.cisdeduction,
    i.fullypaidondate,
    i.amountcredited,
    i.updateddateutc,
    i.creditnotes,
    i.prepayments,
    i.payments,
    i.overpayments,
    i.repeatinginvoiceid,
    i.clientid,
    i.organisationid,
    a.invoiceid                         AS `prepaymentinvoiceid`,
    a.prepaymentid,
    a.allocation                        AS `prepaymentallocation`,
    a.dt                                AS `prepaymentdate`,
    a.amount                            AS `prepaymentamount`,
    CONCAT(CAST(i.organisationid AS CHAR), i.lineitem_accountcode)  AS `Account UID`,
    i.amountcredited_aud                AS `AmountCredited FX`,
    i.amountdue_aud                     AS `AmountDue FX`,
    i.amountpaid_aud                    AS `AmountPaid FX`,
    i.cisdeduction_aud                  AS `CISDeduction FX`,
    i.lineitem_discountamount_aud       AS `LineItem_DiscountAmount FX`,
    i.lineitem_lineamount_aud           AS `LineItem_LineAmount FX`,
    i.lineitem_taxamount_aud            AS `LineItem_TaxAmount FX`,
    i.subtotal_aud                      AS `SubTotal FX`,
    i.total_aud                         AS `Total FX`,
    i.totaltax_aud                      AS `TotalTax FX`,
    i.totaldiscount_aud                 AS `TotalDiscount FX`,
    a.`Amount FX`                       AS `PrePaymentAmount FX`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 1 invoice id` AS invoiceid, 
        1 AS allocation,
        `allocation 1 date` AS dt,
        `allocation 1 applied amount` AS amount,
        `allocation 1 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 1 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 2 invoice id` AS invoiceid, 
        2 AS allocation,
        `allocation 2 date` AS dt,
        `allocation 2 applied amount` AS amount,
        `allocation 2 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 2 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 3 invoice id` AS invoiceid, 
        3 AS allocation,
        `allocation 3 date` AS dt,
        `allocation 3 applied amount` AS amount,
        `allocation 3 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 3 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 4 invoice id` AS invoiceid, 
        4 AS allocation,
        `allocation 4 date` AS dt,
        `allocation 4 applied amount` AS amount,
        `allocation 4 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 4 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 5 invoice id` AS invoiceid, 
        5 AS allocation,
        `allocation 5 date` AS dt,
        `allocation 5 applied amount` AS amount,
        `allocation 5 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 5 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 6 invoice id` AS invoiceid, 
        6 AS allocation,
        `allocation 6 date` AS dt,
        `allocation 6 applied amount` AS amount,
        `allocation 6 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 6 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 7 invoice id` AS invoiceid, 
        7 AS allocation,
        `allocation 7 date` AS dt,
        `allocation 7 applied amount` AS amount,
        `allocation 7 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 7 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 8 invoice id` AS invoiceid, 
        8 AS allocation,
        `allocation 8 date` AS dt,
        `allocation 8 applied amount` AS amount,
        `allocation 8 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 8 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 9 invoice id` AS invoiceid, 
        9 AS allocation,
        `allocation 9 date` AS dt,
        `allocation 9 applied amount` AS amount,
        `allocation 9 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 9 applied amount` IS NOT NULL
    UNION ALL
    SELECT 
        `organisation id`,
        prepaymentid,
        `allocation 10 invoice id` AS invoiceid, 
        10 AS allocation,
        `allocation 10 date` AS dt,
        `allocation 10 applied amount` AS amount,
        `allocation 10 applied amount fx` AS `Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE `allocation 10 applied amount` IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.`organisation id`
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud AS
SELECT 
    `CreditNoteId`                      AS `CreditNoteId`, 
    `ClientID`                          AS `ClientId`,
    `OrganisationID`                    AS `OrganisationId`,
    `CurrencyCode`                      AS `CurrencyCode`,
    `Allocation1_AppliedAmount`         AS `Allocation1_AppliedAmount`,
    `Allocation1_AppliedAmount_AUD`     AS `Allocation 1 Applied Amount FX`,
    `Allocation1_Date`                  AS `Allocation1_Date`,
    `Allocation1_InvoiceId`             AS `Allocation1_InvoiceId`,
    `Allocation2_AppliedAmount`         AS `Allocation2_AppliedAmount`,
    `Allocation2_AppliedAmount_AUD`     AS `Allocation 2 Applied Amount FX`,
    `Allocation2_Date`                  AS `Allocation2_Date`,
    `Allocation2_InvoiceID`             AS `Allocation2_InvoiceId`,
    `Allocation3_AppliedAmount`         AS `Allocation3_AppliedAmount`,
    `Allocation3_AppliedAmount_AUD`     AS `Allocation 3 Applied Amount FX`,
    `Allocation3_Date`                  AS `Allocation3_Date`,
    `Allocation3_InvoiceID`             AS `Allocation3_InvoiceId`,
    `Allocation4_AppliedAmount`         AS `Allocation4_AppliedAmount`,
    `Allocation4_AppliedAmount_AUD`     AS `Allocation 4 Applied Amount FX`,
    `Allocation4_Date`                  AS `Allocation4_Date`,
    `Allocation4_InvoiceID`             AS `Allocation4_InvoiceId`,
    `Allocation5_AppliedAmount`         AS `Allocation5_AppliedAmount`,
    `Allocation5_AppliedAmount_AUD`     AS `Allocation 5 Applied Amount FX`,
    `Allocation5_Date`                  AS `Allocation5_Date`,
    `Allocation5_InvoiceID`             AS `Allocation5_InvoiceId`,
    `Allocation6_AppliedAmount`         AS `Allocation6_AppliedAmount`,
    `Allocation6_AppliedAmount_AUD`     AS `Allocation 6 Applied Amount FX`,
    `Allocation6_Date`                  AS `Allocation6_Date`,
    `Allocation6_InvoiceID`             AS `Allocation6_InvoiceId`,
    `Allocation7_AppliedAmount`         AS `Allocation7_AppliedAmount`,
    `Allocation7_AppliedAmount_AUD`     AS `Allocation 7 Applied Amount FX`,
    `Allocation7_Date`                  AS `Allocation7_Date`,
    `Allocation7_InvoiceID`             AS `Allocation7_InvoiceId`,
    `Allocation8_AppliedAmount`         AS `Allocation8_AppliedAmount`,
    `Allocation8_AppliedAmount_AUD`     AS `Allocation 8 Applied Amount FX`,
    `Allocation8_Date`                  AS `Allocation8_Date`,
    `Allocation8_InvoiceID`             AS `Allocation8_InvoiceId`,
    `Allocation9_AppliedAmount`         AS `Allocation9_AppliedAmount`,
    `Allocation9_AppliedAmount_AUD`     AS `Allocation 9 Applied Amount FX`,
    `Allocation9_Date`                  AS `Allocation9_Date`,
    `Allocation9_InvoiceID`             AS `Allocation9_InvoiceId`,
    `Allocation10_AppliedAmount`        AS `Allocation10_AppliedAmount`,
    `Allocation10_AppliedAmount_AUD`    AS `Allocation 10 Applied Amount FX`,
    `Allocation10_Date`                 AS `Allocation10_Date`,
    `Allocation10_InvoiceID`            AS `Allocation10_InvoiceId`,
    `Allocation11_AppliedAmount`        AS `Allocation11_AppliedAmount`,
    `Allocation11_AppliedAmount_AUD`    AS `Allocation 11 Applied Amount FX`,
    `Allocation11_Date`                 AS `Allocation11_Date`,
    `Allocation11_InvoiceID`            AS `Allocation11_InvoiceId`,
    `Allocation12_AppliedAmount`        AS `Allocation12_AppliedAmount`,
    `Allocation12_AppliedAmount_AUD`    AS `Allocation 12 Applied Amount FX`,
    `Allocation12_Date`                 AS `Allocation12_Date`,
    `Allocation12_InvoiceID`            AS `Allocation12_InvoiceId`,
    `Allocation13_AppliedAmount`        AS `Allocation13_AppliedAmount`,
    `Allocation13_AppliedAmount_AUD`    AS `Allocation 13 Applied Amount FX`,
    `Allocation13_Date`                 AS `Allocation13_Date`,
    `Allocation13_InvoiceID`            AS `Allocation13_InvoiceId`,
    `Allocation14_AppliedAmount`        AS `Allocation14_AppliedAmount`,
    `Allocation14_AppliedAmount_AUD`    AS `Allocation 14 Applied Amount FX`,
    `Allocation14_Date`                 AS `Allocation14_Date`,
    `Allocation14_InvoiceID`            AS `Allocation14_InvoiceId`,
    `Allocation15_AppliedAmount`        AS `Allocation15_AppliedAmount`,
    `Allocation15_AppliedAmount_AUD`    AS `Allocation 15 Applied Amount FX`,
    `Allocation15_Date`                 AS `Allocation15_Date`,
    `Allocation15_InvoiceID`            AS `Allocation15_InvoiceId`
FROM (
    SELECT *, Row_number() OVER(PARTITION BY `CreditNoteId`, `OrganisationID` ORDER BY Id) rn 
    FROM evadb_stage.c1518_xeroblue_creditnotes
) t WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invcrdtallo_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invcrdtallo_aud AS
SELECT
    i.id,
    i.invoiceid,
    i.type,
    i.contactid,
    i.contactname,
    i.lineitem_lineitemid,
    i.lineitem_description,
    i.lineitem_quantity,
    i.lineitem_unitamount,
    i.lineitem_itemcode,
    i.lineitem_accountcode,
    i.lineitem_taxtype,
    i.lineitem_taxamount,
    i.lineitem_lineamount,
    i.lineitem_trackingcategory1_categoryid,
    i.lineitem_trackingcategory1_categoryname,
    i.lineitem_trackingcategory1_optionid,
    i.lineitem_trackingcategory1_optionname,
    i.lineitem_trackingcategory1_option_stat,
    i.lineitem_trackingcategory2_categoryid,
    i.lineitem_trackingcategory2_categoryname,
    i.lineitem_trackingcategory2_optionid,
    i.lineitem_trackingcategory2_optionname,
    i.lineitem_trackingcategory2_option_stat,
    i.lineitem_discountrate,
    i.lineitem_discountamount,
    i.lineitemaggregate,
    i.date,
    i.duedate,
    i.lineamounttypes,
    i.invoicenumber,
    i.reference,
    i.brandingthemeid,
    i.url,
    i.currencycode,
    i.currencyrate,
    i.status,
    i.senttocontact,
    i.expectedpaymentdate,
    i.plannedpaymentdate,
    i.subtotal,
    i.totaltax,
    i.total,
    i.totaldiscount,
    i.hasattachments,
    i.paymentids,
    i.prepaymentids,
    i.overpaymentids,
    i.creditnoteids,
    i.amountdue,
    i.amountpaid,
    i.cisdeduction,
    i.fullypaidondate,
    i.amountcredited,
    i.updateddateutc,
    i.creditnotes,
    i.prepayments,
    i.payments,
    i.overpayments,
    i.repeatinginvoiceid,
    i.clientid,
    i.organisationid,
    a.invoiceid AS creditnoteinvoiceid,
    a.creditnoteid,
    a.allocation AS creditnoteallocation,
    a.dt AS creditnotedate,
    a.amount AS creditnoteamount,
    a.`allocation 1 applied amount fx` AS `creditnoteamount fx`
FROM evadb_stage.c1518_xeroblue_invoices i
INNER JOIN (
    SELECT 
        organisationid, 
        creditnoteid,
        allocation1_invoiceid AS invoiceid, 
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount,
        `allocation 1 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount,
        `allocation 2 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount,
        `allocation 3 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount,
        `allocation 4 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount,
        `allocation 5 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation6_invoiceid AS invoiceid, 
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount,
        `allocation 6 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount,
        `allocation 7 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount,
        `allocation 8 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount,
        `allocation 9 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation10_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount,
        `allocation 10 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount,
        `allocation 11 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount,
        `allocation 12 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount,
        `allocation 13 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount,
        `allocation 14 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        organisationid, 
        creditnoteid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount,
        `allocation 15 applied amount fx`
    FROM bigoleshoecompany_client1518_xeroblue_uniquecreditnotes_aud
    WHERE allocation15_appliedamount IS NOT NULL
) a ON i.invoiceid = a.invoiceid AND i.organisationid = a.organisationid
WHERE i.status IN ('AUTHORISED', 'PAID');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceallocations_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceallocations_aud AS
SELECT 
    * 
FROM
(
    SELECT
        i.*,
        ca.creditnoteinvoiceid, 
        ca.creditnoteallocation, 
        ca.creditnoteamount, 
        ca.creditnotedate,
        IFNULL(ca.`lineitem_discountrate`, 0) AS `discount rate`, 
        IFNULL(ca.`lineitem_discountrate` * 0.01, 0) AS `discount rate %`,
        ppa.prepaymentid, 
        ppa.prepaymentallocation,
        ppa.prepaymentdate, 
        ppa.prepaymentamount,
        ppa.`prepaymentamount fx`,
        opa.overpaymentid, 
        opa.overpaymentallocation,
        opa.overpaymentdate, 
        opa.overpaymentamount,
        opa.`overpaymentamount fx`,
        CONCAT(IFNULL(i.`lineitem_accountcode`, 'BLANK'), '-', i.organisationid) AS `account_uid` ,
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `op allocation amount`,  
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `op allocation amount fx`,  
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `pp allocation amount`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `pp allocation amount fx`,   

        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`-i.`lineitem_taxamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `cn allocation amount`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`-i.`lineitem_taxamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `cn allocation amount fx`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(opa.`overpaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`+i.`lineitem_taxamount`)*(opa.`overpaymentamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `op allocation amount inc tax`,  
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`+i.`lineitem_taxamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND opa.`overpaymentamount` <> 0 AND opa.`overpaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`+i.`lineitem_taxamount fx`)*(opa.`overpaymentamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `op allocation amount inc tax fx`,  
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ppa.`prepaymentamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `pp allocation amount inc tax`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ppa.`prepaymentamount` <> 0 AND ppa.`prepaymentamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ppa.`prepaymentamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `pp allocation amount inc tax fx`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount`)*(ca.`creditnoteamount`/i.`total`))
                ELSE 0 END AS decimal(15,4)
            ) AS `cn allocation amount inc tax`,   
        CAST(
            CASE 
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCREC' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN ((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Inclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                WHEN i.`lineamounttypes` = 'Exclusive' AND i.type = 'ACCPAY' AND ca.`creditnoteamount` <> 0 AND ca.`creditnoteamount` IS NOT NULL  THEN 0-((i.`lineitem_lineamount fx`)*(ca.`creditnoteamount fx`/i.`total fx`))
                ELSE 0 END AS decimal(15,4)
            ) AS `cn allocation amount inc tax fx`  
    FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal_aud i
        LEFT JOIN bigoleshoecompany_client1518_xeroblue_invcrdtallo_aud AS ca
            ON i.invoiceid = ca.invoiceid AND i.lineitem_lineitemid = ca.lineitem_lineitemid
        LEFT JOIN bigoleshoecompany_client1518_xeroblue_invprepymtallo_aud ppa
            ON i.invoiceid = ppa.invoiceid AND i.lineitem_lineitemid = ppa.lineitem_lineitemid
        LEFT JOIN bigoleshoecompany_client1518_xeroblue_invovrpymtallo_aud opa
            ON i.invoiceid = opa.invoiceid AND i.lineitem_lineitemid = opa.lineitem_lineitemid
    WHERE ca.invoiceid IS NOT NULL OR ppa.invoiceid IS NOT NULL OR opa.invoiceid IS NOT NULL AND i.status IN ('AUTHORISED', 'PAID')
) AS t;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud AS
SELECT 
    i.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.accountid                                 AS `PaymentAccountID`,
    p.status                                    AS `PaymentStatus`,
    CONCAT(IFNULL(i.`lineitem_accountcode`, 'BLANK'), '-', CAST(i.`organisationid` AS CHAR)) AS `Account_UID`,
    IFNULL(i.`lineitem_discountrate`, 0)        AS `Discount Rate`,
    IFNULL(i.`lineitem_discountrate` * 0.01, 0) AS `Discount Rate %`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` - i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount`,
    CAST(
        CASE 
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` - i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` - i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount FX`,
    CAST(
        CASE 
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            WHEN i.`total` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount` + i.`lineitem_taxamount`) * (p.`amount` / i.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax`, 	
    CAST(
        CASE 
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCREC' THEN ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Inclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'Exclusive' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            WHEN i.`total fx` <> 0 AND i.lineamounttypes = 'NoTax' AND i.type = 'ACCPAY' THEN 0 - ((i.`lineitem_lineamount fx` + i.`lineitem_taxamount fx`) * (p.`amount fx` / i.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Payments Calculated Amount Inc Tax FX`	
FROM bigoleshoecompany_client1518_xeroblue_invoicesoriginal_aud i
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON i.invoiceid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ACCRECPAYMENT', 'ACCPAYPAYMENT') 
AND i.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud AS
SELECT 
    pp.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(IFNULL(pp.`account code`, 'BLANK'), '-', CAST(pp.`organisation id` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total` <> 0 AND pp.`total` IS NOT NULL THEN 0 - (pp.`total` * (p.`amount` / pp.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount`,
    CAST(
        CASE 
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'RECEIVE-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'Inclusive' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN 0 - (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            WHEN pp.`line amount types` = 'NoTax' AND pp.type = 'SPEND-PREPAYMENT' AND pp.`total fx` <> 0 AND pp.`total fx` IS NOT NULL THEN 0 - (pp.`total fx` * (p.`amount fx` / pp.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Prepayments Calculated Amount FX`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud pp
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON pp.prepaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('ARPREPAYMENTPAYMENT', 'APPREPAYMENTPAYMENT') 
AND pp.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud AS
SELECT 
    op.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(op.`account code`, '-', CAST(op.`organisation id` AS CHAR)) AS `Account_UID`,
    CAST(
        CASE 
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total` <> 0 AND op.`total` IS NOT NULL THEN 0 - (op.`total` * (p.`amount` / op.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount`,
    CAST(
        CASE 
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'RECEIVE-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'Inclusive' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN 0 - (op.`total fx` * (p.`amount fx` / op.`total fx`))
            WHEN op.`line amount types` = 'NoTax' AND op.type = 'SPEND-OVERPAYMENT' AND op.`total fx` <> 0 AND op.`total fx` IS NOT NULL THEN 0 - (op.`total fx` * (p.`amount fx` / op.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Overpayments Calculated Amount FX`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud op
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON op.overpaymentid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APOVERPAYMENTPAYMENT', 'AROVERPAYMENTPAYMENT') 
AND op.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud AS
SELECT 
    c.*,
    p.date                                      AS `PaymentDate`,
    p.amount                                    AS `PaymentAmount`,
    p.`amount fx`                               AS `PaymentAmount FX`,
    p.paymenttype                               AS `PaymentType`,
    p.status                                    AS `PaymentStatus`,
    p.accountid                                 AS `PaymentAccountID`,
    CONCAT(c.`lineitem_accountcode`, '-', CAST(c.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN (c.`lineitem_lineamount` * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` - c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - (c.`lineitem_lineamount fx` * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx` - c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN (c.`lineitem_lineamount fx` * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx` - c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount FX`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount` + c.`lineitem_taxamount`) * (p.`amount` / c.`total`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount`) * (p.`amount` / c.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`,
    CAST(
        CASE 
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx` + c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCRECCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN 0 - ((c.`lineitem_lineamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Exclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx` + c.`lineitem_taxamount fx`) * (p.`amount fx` / c.`total fx`))
            WHEN c.`lineamounttypes` = 'Inclusive' AND c.type = 'ACCPAYCREDIT' AND c.`lineitem_lineamount` <> 0 AND c.`lineitem_lineamount` IS NOT NULL THEN ((c.`lineitem_lineamount fx`) * (p.`amount fx` / c.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax FX`
FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud c
INNER JOIN bigoleshoecompany_client1518_xeroblue_paymentsoriginal_aud p ON c.creditnoteid = p.invoiceid
WHERE UPPER(p.paymenttype) IN ('APCREDITPAYMENT', 'ARCREDITPAYMENT') 
AND c.status IN ('AUTHORISED', 'PAID') 
AND p.status IN ('AUTHORISED');


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud AS
SELECT 
    a.*,
    CONCAT(IFNULL(a.`lineitem_accountcode`, 'BLANK'), '-', CAST(a.`organisationid` AS CHAR)) AS `Account UID`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` - a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount` + a.`lineitem_taxamount`) * (a.`amount` / a.`total`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount`) * (a.`amount` / a.`total`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx` - a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx` - a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount FX`,
    CAST(
        CASE 
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx` + a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCRECCREDIT' THEN (0 - (a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Exclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx` + a.`lineitem_taxamount fx`) * (a.`amount fx` / a.`total fx`))
            WHEN a.`lineamounttypes` = 'Inclusive' AND a.`type` = 'ACCPAYCREDIT' THEN ((a.`lineitem_lineamount fx`) * (a.`amount fx` / a.`total fx`))
            ELSE 0 
        END AS DECIMAL(15,4)
    ) AS `Credit Note Allocation Calculated Amount Inc Tax FX` 
FROM (
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        1 AS allocation,
        allocation1_date AS dt,
        allocation1_appliedamount AS amount,
        `allocation1_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation1_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation2_invoiceid AS invoiceid,
        2 AS allocation,
        allocation2_date AS dt,
        allocation2_appliedamount AS amount,
        `allocation2_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation2_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation3_invoiceid AS invoiceid,
        3 AS allocation,
        allocation3_date AS dt,
        allocation3_appliedamount AS amount,
        `allocation3_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation3_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation4_invoiceid AS invoiceid,
        4 AS allocation,
        allocation4_date AS dt,
        allocation4_appliedamount AS amount,
        `allocation4_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation4_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation5_invoiceid AS invoiceid,
        5 AS allocation,
        allocation5_date AS dt,
        allocation5_appliedamount AS amount,
        `allocation5_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation5_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation6_invoiceid AS invoiceid,
        6 AS allocation,
        allocation6_date AS dt,
        allocation6_appliedamount AS amount,
        `allocation6_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation6_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation7_invoiceid AS invoiceid,
        7 AS allocation,
        allocation7_date AS dt,
        allocation7_appliedamount AS amount,
        `allocation7_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation7_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation8_invoiceid AS invoiceid,
        8 AS allocation,
        allocation8_date AS dt,
        allocation8_appliedamount AS amount,
        `allocation8_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation8_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation9_invoiceid AS invoiceid,
        9 AS allocation,
        allocation9_date AS dt,
        allocation9_appliedamount AS amount,
        `allocation9_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation9_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation1_invoiceid AS invoiceid,
        10 AS allocation,
        allocation10_date AS dt,
        allocation10_appliedamount AS amount,
        `allocation10_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation10_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation11_invoiceid AS invoiceid,
        11 AS allocation,
        allocation11_date AS dt,
        allocation11_appliedamount AS amount,
        `allocation11_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation11_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation12_invoiceid AS invoiceid,
        12 AS allocation,
        allocation12_date AS dt,
        allocation12_appliedamount AS amount,
        `allocation12_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation12_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation13_invoiceid AS invoiceid,
        13 AS allocation,
        allocation13_date AS dt,
        allocation13_appliedamount AS amount,
        `allocation13_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation13_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation14_invoiceid AS invoiceid,
        14 AS allocation,
        allocation14_date AS dt,
        allocation14_appliedamount AS amount,
        `allocation14_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation14_appliedamount IS NOT NULL
    UNION ALL
    SELECT 
        id,
        creditnoteid,
        creditnotenumber,
        reference,
        type,
        contact_contactid,
        contact_name,
        date,
        status,
        lineamounttypes,
        lineitem_description,
        lineitem_quantity,
        lineitem_unitamount,
        lineitem_itemcode,
        lineitem_accountcode,
        lineitem_taxtype,
        lineitem_taxamount,
        lineitem_lineamount,
        lineitem_trackingcategory1_categoryid,
        lineitem_trackingcategory1_categoryname,
        lineitem_trackingcategory1_optionid,
        lineitem_trackingcategory1_optionname,
        lineitem_trackingcategory1_option_stat,
        lineitem_trackingcategory2_categoryid,
        lineitem_trackingcategory2_categoryname,
        lineitem_trackingcategory2_optionid,
        lineitem_trackingcategory2_optionname,
        lineitem_trackingcategory2_option_stat,
        lineitem_discountrate,
        subtotal,
        totaltax,
        total,
        updateddateutc,
        currencycode,
        fullypaidondate,
        senttocontact,
        brandingthemeid,
        currencyrate,
        remainingcredit,
        hasattachments,
        clientid,
        organisationid,
        allocation15_invoiceid AS invoiceid,
        15 AS allocation,
        allocation15_date AS dt,
        allocation15_appliedamount AS amount,
        `allocation15_appliedamount fx` AS `amount fx`,
        `lineitem_taxamount fx`,
        `lineitem_lineamount fx`,
        `subtotal fx`,
        `totaltax fx`,
        `total fx`,
        `remainingcredit fx`
    FROM bigoleshoecompany_client1518_xeroblue_creditnotesoriginal_aud 
    WHERE allocation15_appliedamount IS NOT NULL
) AS a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_prepaymentallocation_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_prepaymentallocation_aud AS
SELECT 
    a.*,
    CONCAT(IFNULL(`Account Code`, 'BLANK'), '-', CAST(`Organisation ID` AS CHAR)) AS `Account UID`
FROM (
    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 1 Invoice ID` AS `InvoiceId`, 
        1 AS `Allocation`,
        `Allocation 1 Date` AS `Dt`,
        `Allocation 1 Applied Amount` AS `Amount`,
        `Allocation 1 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 1 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 2 Invoice ID` AS `InvoiceId`, 
        2 AS `Allocation`,
        `Allocation 2 Date` AS `Dt`,
        `Allocation 2 Applied Amount` AS `Amount`,
        `Allocation 2 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 2 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 3 Invoice ID` AS `InvoiceId`, 
        3 AS `Allocation`,
        `Allocation 3 Date` AS `Dt`,
        `Allocation 3 Applied Amount` AS `Amount`,
        `Allocation 3 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 3 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 4 Invoice ID` AS `InvoiceId`, 
        4 AS `Allocation`,
        `Allocation 4 Date` AS `Dt`,
        `Allocation 4 Applied Amount` AS `Amount`,
        `Allocation 4 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 4 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 5 Invoice ID` AS `InvoiceId`, 
        5 AS `Allocation`,
        `Allocation 5 Date` AS `Dt`,
        `Allocation 5 Applied Amount` AS `Amount`,
        `Allocation 5 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 5 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 6 Invoice ID` AS `InvoiceId`, 
        6 AS `Allocation`,
        `Allocation 6 Date` AS `Dt`,
        `Allocation 6 Applied Amount` AS `Amount`,
        `Allocation 6 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 6 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 7 Invoice ID` AS `InvoiceId`, 
        7 AS `Allocation`,
        `Allocation 7 Date` AS `Dt`,
        `Allocation 7 Applied Amount` AS `Amount`,
        `Allocation 7 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 7 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 8 Invoice ID` AS `InvoiceId`, 
        8 AS `Allocation`,
        `Allocation 8 Date` AS `Dt`,
        `Allocation 8 Applied Amount` AS `Amount`,
        `Allocation 8 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 8 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 9 Invoice ID` AS `InvoiceId`, 
        9 AS `Allocation`,
        `Allocation 9 Date` AS `Dt`,
        `Allocation 9 Applied Amount` AS `Amount`,
        `Allocation 9 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 9 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `PrepaymentId`,
        `Date` AS `DATE`,
        `Reference`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `CurrencyCode`,
        `CurrencyRate`,
        `Updated Date UTC`,
        `HasAttachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 10 Invoice ID` AS `InvoiceId`, 
        10 AS `Allocation`,
        `Allocation 10 Date` AS `Dt`,
        `Allocation 10 Applied Amount` AS `Amount`,
        `Allocation 10 Applied Amount` AS `Amount FX`,
        `SubTotal FX` AS `SubTotal FX`,
        `TotalTax FX` AS `TotalTax FX`,
        `Total FX` AS `Total FX`,
        `Tax Amount FX` AS `TaxAmount FX`,
        `Line Amount FX` AS `LineAmount FX`
    FROM 
        bigoleshoecompany_client1518_xeroblue_prepaymentsoriginal_aud 
    WHERE 
        `Allocation 10 Applied Amount` IS NOT NULL
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_overpaymentallocation_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_overpaymentallocation_aud AS
SELECT 
    a.*,
    CONCAT(IFNULL(`Account Code`, 'BLANK'), '-', CAST(`Organisation ID` AS CHAR)) AS `Account UID`
FROM (
    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 1 Invoice ID` AS `InvoiceId`, 
        1 AS `Allocation`,
        `Allocation 1 Date` AS `Dt`,
        `Allocation 1 Applied Amount` AS `Amount`,
        `Allocation 1 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 1 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 2 Invoice ID` AS `InvoiceId`, 
        2 AS `Allocation`,
        `Allocation 2 Date` AS `Dt`,
        `Allocation 2 Applied Amount` AS `Amount`,
        `Allocation 2 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 2 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 3 Invoice ID` AS `InvoiceId`, 
        3 AS `Allocation`,
        `Allocation 3 Date` AS `Dt`,
        `Allocation 3 Applied Amount` AS `Amount`,
        `Allocation 3 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 3 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 4 Invoice ID` AS `InvoiceId`, 
        4 AS `Allocation`,
        `Allocation 4 Date` AS `Dt`,
        `Allocation 4 Applied Amount` AS `Amount`,
        `Allocation 4 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 4 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 5 Invoice ID` AS `InvoiceId`, 
        5 AS `Allocation`,
        `Allocation 5 Date` AS `Dt`,
        `Allocation 5 Applied Amount` AS `Amount`,
        `Allocation 5 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 5 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 6 Invoice ID` AS `InvoiceId`, 
        6 AS `Allocation`,
        `Allocation 6 Date` AS `Dt`,
        `Allocation 6 Applied Amount` AS `Amount`,
        `Allocation 6 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 6 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 7 Invoice ID` AS `InvoiceId`, 
        7 AS `Allocation`,
        `Allocation 7 Date` AS `Dt`,
        `Allocation 7 Applied Amount` AS `Amount`,
        `Allocation 7 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 7 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 8 Invoice ID` AS `InvoiceId`, 
        8 AS `Allocation`,
        `Allocation 8 Date` AS `Dt`,
        `Allocation 8 Applied Amount` AS `Amount`,
        `Allocation 8 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 8 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 9 Invoice ID` AS `InvoiceId`, 
        9 AS `Allocation`,
        `Allocation 9 Date` AS `Dt`,
        `Allocation 9 Applied Amount` AS `Amount`,
        `Allocation 9 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 9 Applied Amount` IS NOT NULL

    UNION ALL

    SELECT 
        `OverpaymentId`,
        `Date` AS `DATE`,
        `Type`,
        `RemainingCredit`,
        `Contact ID`,
        `Contact Name`,
        `Status`,
        `SubTotal`,
        `TotalTax`,
        `Total`,
        `Line Item ID`,
        `Description`,
        `Quantity`,
        `Unit Amount`,
        `Item Code`,
        `Account Code`,
        `Tax Type`,
        `Tax Amount`,
        `Line Amount`,
        `Tracking Category 1 Category ID`,
        `Tracking Category 1 Category Name`,
        `Tracking Category 1 Option ID`,
        `Tracking Category 1 Option Name`,
        `Tracking Category 1 Option Stat`,
        `Tracking Category 2 Category ID`,
        `Tracking Category 2 Category Name`,
        `Tracking Category 2 Option ID`,
        `Tracking Category 2 Option Name`,
        `Tracking Category 2 Option Stat`,
        `Discount Rate`,
        `Line Amount Types`,
        `Currency Code`,
        `Currency Rate`,
        `Updated Date UTC`,
        `Has Attachments`,
        `Payments`,
        `Client ID`,
        `Organisation ID`,
        `Allocation 10 Invoice ID` AS `InvoiceId`, 
        10 AS `Allocation`,
        `Allocation 10 Date` AS `Dt`,
        `Allocation 10 Applied Amount` AS `Amount`,
        `Allocation 10 Applied Amount` AS `Amount FX`,
        `SubTotal FX`,
        `TotalTax FX`,
        `Total FX`,
        `Tax Amount FX`,
        `Line Amount FX`
    FROM bigoleshoecompany_client1518_xeroblue_overpaymentsoriginal_aud 
    WHERE `Allocation 10 Applied Amount` IS NOT NULL
) a;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgets_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgets_aud AS
SELECT 
    `BudgetID`                              AS `Budget ID`,
    `Status`                                AS `Status`,
    `Type`                                  AS `Type`,
    `Description`                           AS `Description`,
    `UpdatedDateUTC`                        AS `Updated Date UTC`,
    `BudgetLines`                           AS `Budget Lines`,
    `BudgetLines.AccountID`                 AS `Budget Lines Account ID`,
    `BudgetLines.AccountCode`               AS `Budget Lines Account Code`,
    `BudgetLines.BudgetBalances`            AS `Budget Lines Budget Balances`,
    `BudgetLines.BudgetBalances.Period`     AS `Budget Lines Budget Balances Period`,
    `BudgetLines.BudgetBalances.Amount`     AS `Budget Lines Budget Balances Amount`,
    `BudgetLines.BudgetBalances.Notes`      AS `Budget Lines Budget Balances Notes`,
    `Tracking`                              AS `Tracking`,
    `Tracking.1.Name`                       AS `Tracking 1 Name`,
    `Tracking.1.Option`                     AS `Tracking 1 Option`,
    `Tracking.1.TrackingCategoryID`         AS `Tracking 1 Tracking Category ID`,
    `Tracking.1.TrackingOptionID`           AS `Tracking 1 Tracking Option ID`,
    `Tracking.2.Name`                       AS `Tracking 2 Name`,
    `Tracking.2.Option`                     AS `Tracking 2 Option`,
    `Tracking.2.TrackingCategoryID`         AS `Tracking 2 Tracking Category ID`,
    `Tracking.2.TrackingOptionID`           AS `Tracking 2 Tracking Option ID`,
    `ClientID`                              AS `ClientID`,
    `OrganisationID`                        AS `OrganisationID`,
    `BudgetLines.BudgetBalances.Amount_AUD` AS `Budget Lines Budget Balances Amount FX`
FROM evadb_stage.c1518_xeroblue_budgets
WHERE `BudgetLines.AccountID` IS NOT NULL;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_allocationaggregated_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_allocationaggregated_aud AS
SELECT 
    b.`InvoiceId`          AS `Invoice ID`
    ,b.`CreditNoteId`      AS `Allocation Source ID`
    ,b.`Type`              AS `Type`
    ,b.`Contact_ContactId` AS `Contact ID`
    ,b.`ClientID`          AS `Client ID`
    ,b.`OrganisationID`    AS `Organisation ID`
    ,b.`Dt`               AS `Allocation Date`
    ,b.`Date`              AS `Allocation Invoiced Date`
    ,b.`SubTotal FX`    AS `SubTotal FX`
    ,b.`TotalTax FX`    AS `TotalTax FX`
    ,b.`Total FX`       AS `Total FX`
    ,b.`LineItem_TaxAmount` AS `Tax Amount FX`
    ,b.`LineItem_LineAmount` AS `Line Amount FX`
    ,b.`Amount FX`      AS `Amount FX`
    ,b.`Credit Note Allocation Calculated Amount FX` AS `Allocation Calculated Amount FX`
    ,b.`Credit Note Allocation Calculated Amount Inc Tax FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,b.`Account UID`    AS `Account UID`
    ,'Credit Note Allocations' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_creditnoteallocations_aud b
UNION ALL
SELECT 
    c.`InvoiceId`          AS `Invoice ID`
    ,c.`PrepaymentId`      AS `Allocation Source ID`
    ,c.`Type`              AS `Type`
    ,c.`Contact ID`      AS `Contact ID`
    ,c.`Client ID`       AS `Client ID`
    ,c.`Organisation ID` AS `Organisation ID`
    ,c.`Dt`               AS `Allocation Date`
    ,c.`DATE`              AS `Allocation Invoiced Date`
    ,c.`SubTotal FX`    AS `SubTotal FX`
    ,c.`TotalTax FX`    AS `TotalTax FX`
    ,c.`Total FX`       AS `Total FX`
    ,c.`TaxAmount FX`   AS `Tax Amount FX`
    ,c.`LineAmount FX`  AS `Line Amount FX`
    ,c.`Amount FX`      AS `Amount FX`
    ,c.`LineAmount FX`  AS `Allocation Calculated Amount Inc`
    ,c.`LineAmount FX` + c.`TaxAmount FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,c.`Account UID`    AS `Account UID`
    ,'PrePayment Allocation' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_prepaymentallocation_aud c
UNION ALL
SELECT 
    c.`InvoiceId`          AS `Invoice ID`
    ,c.`OverpaymentId`     AS `Allocation Source ID`
    ,c.`Type`              AS `Type`
    ,c.`Contact ID`      AS `Contact ID`
    ,c.`Client ID`       AS `Client ID`
    ,c.`Organisation ID` AS `Organisation ID`
    ,c.`Dt`               AS `Allocation Date`
    ,c.`DATE`              AS `Allocation Invoiced Date`
    ,c.`SubTotal FX`    AS `SubTotal FX`
    ,c.`TotalTax FX`    AS `TotalTax FX`
    ,c.`Total FX`       AS `Total FX`
    ,c.`Tax Amount FX`  AS `Tax Amount FX`
    ,c.`Line Amount FX` AS `Line Amount FX`
    ,c.`Amount FX`      AS `Amount FX`
    ,c.`Line Amount FX` AS `Allocation Calculated Amount Inc`
    ,c.`Line Amount FX` + c.`Tax Amount FX` AS `Allocation Calculated Amount Inc Tax FX`
    ,c.`Account UID`    AS `Account UID`
    ,'OverPayment Allocation' AS `SOURCE`
FROM bigoleshoecompany_client1518_xeroblue_overpaymentallocation_aud c;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_invoicesdraft_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_invoicesdraft_aud AS
SELECT 
    `Id` AS `Invoice Line ID`,
    `InvoiceId` AS `Invoice ID`,
    `Type` AS `Type`,
    `ContactId` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItem_LineItemId` AS `Line Item ID`,
    `LineItem_Description` AS `Line Item - Description`,
    `LineItem_Quantity` AS `Quantity`,
    `LineItem_UnitAmount` AS `Unit Amount`,
    `LineItem_ItemCode` AS `Item Code`,
    `LineItem_AccountCode` AS `Account Code`,
    `LineItem_TaxType` AS `Tax Type`,
    `LineItem_TaxAmount` AS `Tax Amount`,
    `LineItem_TaxAmount_AUD` AS `Tax FX Amount`,
    `LineItem_LineAmount` AS `Line Amount`,
    `LineItem_LineAmount_AUD` AS `Line FX Amount`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `DiscountRate%` AS `Discount Rate %`,
    `LineItem_DiscountAmount` AS `Discount Amount`,
    `LineItem_DiscountAmount_AUD` AS `Discount FX Amount`,
    `LineItemAggregate` AS `Aggregate`,
    `Date` AS `Date`,
    `DueDate` AS `Due Date`,
    `LineAmountTypes` AS `Line Amount Types`,
    `InvoiceNumber` AS `Invoice Number`,
    `Reference` AS `Reference`,
    `BrandingThemeId` AS `Branding Theme ID`,
    `URL` AS `URL`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `Status` AS `Status`,
    `SentToContact` AS `Sent To Contact`,
    `ExpectedPaymentDate` AS `Expected Payment Date`,
    `PlannedPaymentDate` AS `Planned Payment Date`,
    `SubTotal` AS `Invoice - Sub Total`,
    `SubTotal_AUD` AS `Invoice - FX Sub Total`,
    `TotalTax` AS `Invoice - Total Tax`,
    `TotalTax_AUD` AS `Invoice - FX Total Tax`,
    `Total_AUD` AS `Invoice Total`,
    `TotalDiscount_AUD` AS `Total Discount`,
    `HasAttachments` AS `Has Attachments`,
    `AmountDue_AUD` AS `Invoice - Amount Due`,
    `AmountPaid_AUD` AS `Invoice - Amount Paid`,
    `CISDeduction_AUD` AS `CIS Deduction`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `AmountCredited_AUD` AS `Amount Credited`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `CreditNotes` AS `Credit Notes`,
    `Payments` AS `Payments`,
    `Prepayments` AS `Pre Payments`,
    `Overpayments` AS `Over Payments`,
    `RepeatingInvoiceID` AS `Repeating Invoice ID`,
    CONCAT(`LineItem_AccountCode`, '-', CAST(`OrganisationID` AS CHAR)) AS `Account_UID`,
    `PaymentIds` AS `Payment ID`,
    `PrePaymentIds` AS `Pre Payment ID`,
    `OverPaymentIds` AS `Over Payment ID`,
    `CreditNoteIDs` AS `Credit Note ID`,
    `LineAmountCalculation` AS `Line Amount Calculation`,
    `LineAmountCalculation_AUD` AS `Line Amount FX Calculation`,
    `LineAmountCalculationIncTax` AS `Line Amount Calculation Inc Tax`,
    `LineAmountCalculationIncTax_AUD` AS `Line Amount FX Calculation Inc Tax`,
    `LineAmountTradeCreditorCalculation` AS `Line Amount Trade Creditor Calculation`,
    `LineAmountTradeCreditorCalculation_AUD` AS `Line Amount FX Trade Creditor Calculation`,
    `LineAmountTradeDebtorCalculation` AS `Line Amount Trade Debtor Calculation`,
    `LineAmountTradeDebtorCalculation_AUD` AS `Line Amount FX Trade Debtor Calculation`,
    `DayDifference` AS `Day Difference`
FROM evadb_stage.c1518_XEROBLUE_InvoicesDraft;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactions_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactions_aud AS
SELECT 
    `lineid` AS `Line ID`,
    `id` AS `ID`,
    `date` AS `Date`,
    `type` AS `Type`,
    `contactid` AS `Contact ID`,
    `contactname` AS `Contact Name`,
    `lineitemid` AS `Line Item ID`,
    `description` AS `Description`,
    `quantity` AS `Quantity`,
    `unitamount` AS `Unit Amount`,
    `unitamount_aud` AS `Unit Amount FX`,
    `itemcode` AS `Item Code`,
    `accountcode` AS `Account Code`,
    `taxtype` AS `Tax Type`,
    `taxamount` AS `Tax Amount`,
    `taxamount_aud` AS `Tax Amount FX`,
    `lineamount` AS `Line Amount`,
    `lineamount_aud` AS `Line Amount FX`,
    `lineamounttypes` AS `Line Amount Types`,
    `status` AS `Status`,
    `subtotal` AS `Sub Total`,
    `subtotal_aud` AS `Sub Total FX`,
    `totaltax` AS `Total Tax`,
    `totaltax_aud` AS `Total Tax FX`,
    `total` AS `Total`,
    `total_aud` AS `Total FX`,
    `trackingcategory1categoryid` AS `Tracking Category 1 Category ID`,
    `trackingcategory1categoryname` AS `Tracking Category 1 Category Name`,
    `trackingcategory1optionid` AS `Tracking Category 1 Option ID`,
    `trackingcategory1optionname` AS `Tracking Category 1 Option Name`,
    `trackingcategory1optionstat` AS `Tracking Category 1 Option Stat`,
    `trackingcategory2categoryid` AS `Tracking Category 2 Category ID`,
    `trackingcategory2categoryname` AS `Tracking Category 2 Category Name`,
    `trackingcategory2optionid` AS `Tracking Category 2 Option ID`,
    `trackingcategory2optionname` AS `Tracking Category 2 Option Name`,
    `trackingcategory2optionstat` AS `Tracking Category 2 Option Stat`,
    `discountrate` AS `Discount Rate`,
    `currencycode` AS `Currency Code`,
    `currencyrate` AS `Currency Rate`,
    `updateddateutc` AS `Updated Date UTC`,
    `accountuid` AS `Account UID`,
    `hasattachments` AS `Has Attachments`,
    `creditnotenumber` AS `Credit Note Number`,
    `remainingcredit` AS `Remaining Credit`,
    `remainingcredit_aud` AS `Remaining Credit FX`,
    `fullypaidondate` AS `Fully Paid On Date`,
    `reference` AS `Reference`,
    `source` AS `Source`,
    `clientid` AS `Client ID`,
    `organisationid` AS `Organisation ID`,
    `showoncashbasisreports` AS `ShowOnCashBasisReports`,
    `duedate` AS `DueDate`,
    `invoicenumber` AS `InvoiceNumber`,
    `paymentsourceid` AS `PaymentSourceID`,
    `paymenttype` AS `PaymentType`,
    `allocationdate` AS `AllocationDate`,
    `allocationamount` AS `AllocationAmount`,
    `changes` AS `Changes`,
    `user` AS `User`,
    `details` AS `Details`,
    `daydifference` AS `DayDifference`
FROM evadb_stage.c1518_xeroblue_transactions;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscontacts_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscontacts_aud AS
SELECT 
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_NetAmount_AUD` AS `Net Amount FX`,
    `JournalLine_GrossAmount_AUD` AS `Gross Amount FX`,
    `JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `ContactSource` AS `ContactSource`,
    `PaymentSourceID` AS `PaymentSourceID`,
    `PaymentType` AS `PaymentType`,
    `Changes` AS `Changes`,
    `User` AS `User`,
    `Details` AS `Details`,
    `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    `FullyPaidOnDate` AS `FullyPaidOnDate`,
    `DayDifference` AS `DayDifference`,
    `InvoiceNumber` AS `InvoiceNumber`,
    `CreditNoteNumber` AS `CreditNoteNumber`
FROM evadb_stage.c1518_xeroblue_journals;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_journalscashcontacts_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_journalscashcontacts_aud AS
SELECT 
    `Id` AS `ID`,
    `JournalId` AS `Journal ID`,
    `JournalDate` AS `Journal Date`,
    `JournalNumber` AS `Journal Number`,
    `CreatedDateUTC` AS `Created Date UTC`,
    `Reference` AS `Reference`,
    `SourceId` AS `Source ID`,
    `SourceType` AS `Source Type`,
    `JournalLine_JournalLineId` AS `Journal Line ID`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_AccountId` AS `Account ID`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_AccountType` AS `Account Type`,
    `JournalLine_AccountName` AS `Account Name`,
    `JournalLine_NetAmount` AS `Net Amount`,
    `JournalLine_GrossAmount` AS `Gross Amount`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_NetAmount_AUD` AS `Net Amount FX`,
    `JournalLine_GrossAmount_AUD` AS `Gross Amount FX`,
    `JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxName` AS `Tax Name`,
    `LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    `Split` AS `Split`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `ContactSource` AS `ContactSource`,
    `PaymentSourceID` AS `PaymentSourceID`,
    `PaymentType` AS `PaymentType`,
    `Changes` AS `Changes`,
    `User` AS `User`,
    `Details` AS `Details`,
    `ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    `FullyPaidOnDate` AS `FullyPaidOnDate`,
    `DayDifference` AS `DayDifference`,
    `InvoiceNumber` AS `InvoiceNumber`,
    `CreditNoteNumber` AS `CreditNoteNumber`
FROM evadb_stage.c1518_xeroblue_journalscash;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_manualjournals_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_manualjournals_aud AS
SELECT
    `Id` AS `ID`,
    `ManualJournalId` AS `Manual Journal ID`,
    `Narration` AS `Narration`,
    `JournalLine_LineAmount` AS `Line Amount`,
    `JournalLine_AccountCode` AS `Account Code`,
    `JournalLine_Description` AS `Description`,
    `JournalLine_TaxType` AS `Tax Type`,
    `JournalLine_TaxAmount` AS `Tax Amount`,
    `JournalLine_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    `JournalLine_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    `JournalLine_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    `JournalLine_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    `JournalLine_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    `JournalLine_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    `JournalLine_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    `JournalLine_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    `JournalLine_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    `JournalLine_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    `JournalLineAggregate` AS `Journal Line Aggregate`,
    `Date` AS `Date`,
    `Status` AS `Status`,
    `URL` AS `URL`,
    `ShowOnCashBasisReports` AS `Show On Cash Basis Reports`,
    `LineAmountTypes` AS `Line Amount Types`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `HasAttachments` AS `Has Attachments`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`,
    IFNULL(`JournalLine_AccountCode`, 'BLANK') + '-' + CAST(`OrganisationID` AS CHAR) AS `Account UID`,
    CAST(
        CASE 
        WHEN (`LineAmountTypes` = 'Inclusive' OR `LineAmountTypes` = 'NoTax') THEN 0-(`JournalLine_LineAmount`)
        WHEN `LineAmountTypes` = 'Exclusive' AND (`JournalLine_TaxType` = 'INPUT' OR `JournalLine_TaxType` = 'OUTPUT' OR `JournalLine_TaxType` = 'CAPEXINPUT') THEN 0-(`JournalLine_LineAmount`+(`JournalLine_LineAmount`*0.1))
        WHEN `LineAmountTypes` = 'Exclusive' THEN 0-(`JournalLine_LineAmount`)
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Manual Journal Cash Calculation`,
    `JournalLine_LineAmount_AUD` AS `Line Amount FX`,
    `JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
    CAST(
        CASE 
        WHEN (`LineAmountTypes` = 'Inclusive' OR `LineAmountTypes` = 'NoTax') THEN 0-(`JournalLine_LineAmount_AUD`)
        WHEN `LineAmountTypes` = 'Exclusive' AND (`JournalLine_TaxType` = 'INPUT' OR `JournalLine_TaxType` = 'OUTPUT' OR `JournalLine_TaxType` = 'CAPEXINPUT') THEN 0-(`JournalLine_LineAmount_AUD`+(`JournalLine_LineAmount_AUD`*0.1))
        WHEN `LineAmountTypes` = 'Exclusive' THEN 0-(`JournalLine_LineAmount_AUD`)
        ELSE 0 END AS DECIMAL(15,4)
    ) AS `Manual Journal Cash Calculation FX`
FROM (
    SELECT *, 
        ROW_NUMBER() OVER(PARTITION BY `Id` ORDER BY Id) rn 
    FROM evadb_stage.c1518_XEROBLUE_ManualJournals
    WHERE Status IN ('POSTED')
) t WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniqueinvoices_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniqueinvoices_aud AS
SELECT
    `Id`                                        AS `Invoice Line ID`,
    `InvoiceId`                                 AS `Invoice ID`,
    `Type`                                      AS `Type`,
    `ContactId`                                 AS `Contact ID`,
    `ContactName`                               AS `Contact Name`,
    `LineItem_LineItemId`                       AS `Line Item ID`,
    `LineItem_Description`                      AS `Line Item - Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_AccountCode`                      AS `Account Code`,
    `LineItem_TaxType`                          AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 - Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 - Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `DiscountRate`                              AS `Discount Rate`,
    `DiscountRate%`                             AS `Discount Rate %`,
    `LineItem_DiscountAmount`                   AS `Discount Amount`,
    `LineItemAggregate`                         AS `Aggregate`,
    `Date`                                      AS `Date`,
    `DueDate`                                   AS `Due Date`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `InvoiceNumber`                             AS `Invoice Number`,
    `Reference`                                 AS `Reference`,
    `BrandingThemeId`                           AS `Branding Theme ID`,
    `URL`                                       AS `URL`,
    `CurrencyCode`                              AS `Currency Code`,
    `CurrencyRate`                              AS `Currency Rate`,
    `Status`                                    AS `Status`,
    `SentToContact`                             AS `Sent To Contact`,
    `ExpectedPaymentDate`                       AS `Expected Payment Date`,
    `PlannedPaymentDate`                        AS `Planned Payment Date`,
    `SubTotal`                                  AS `Invoice - Sub Total`,
    `TotalTax`                                  AS `Invoice - Total Tax`,
    `Total`                                     AS `Invoice Total`,
    `TotalDiscount`                             AS `Total Discount`,
    `HasAttachments`                            AS `Has Attachments`,
    `PaymentIds`                                AS `Payment ID`,
    `PrePaymentIds`                             AS `Pre Payment ID`,
    `OverPaymentIds`                            AS `Over Payment ID`,
    `CreditNoteIDs`                             AS `Credit Note ID`,
    `AmountDue`                                 AS `Invoice - Amount Due`,
    `AmountPaid`                                AS `Invoice - Amount Paid`,
    `CISDeduction`                              AS `CIS Deduction`,
    `FullyPaidOnDate`                           AS `Fully Paid On Date`,
    `AmountCredited`                            AS `Amount Credited`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `ClientID`                                  AS `Client ID`,
    `OrganisationID`                            AS `Organisation ID`,
    `CreditNotes`                               AS `Credit Notes`,
    `Payments`                                 AS `Payments`,
    `Prepayments`                              AS `Pre Payments`,
    `Overpayments`                             AS `Over Payments`,
    `RepeatingInvoiceID`                        AS `Repeating Invoice ID`,
    `Account_UID`                               AS `Account_UID`,
    `DayDifference`                             AS `Day Difference`,
    `LineItem_TaxAmount_AUD`                    AS `Tax Amount FX`,
    `LineItem_LineAmount_AUD`                   AS `Line Amount FX`,
    `LineItem_DiscountAmount_AUD`               AS `Discount Amount FX`,
    `SubTotal_AUD`                              AS `Invoice - Sub Total FX`,
    `TotalTax_AUD`                              AS `Invoice - Total Tax FX`,
    `Total_AUD`                                 AS `Invoice Total FX`,
    `TotalDiscount_AUD`                         AS `Total Discount FX`,
    `AmountDue_AUD`                             AS `Invoice - Amount Due FX`,
    `AmountPaid_AUD`                            AS `Invoice - Amount Paid FX`,
    `CISDeduction_AUD`                          AS `CIS Deduction FX`,
    `AmountCredited_AUD`                        AS `Amount Credited FX`
FROM (
        SELECT *, Row_number() OVER(PARTITION BY `InvoiceId`, `OrganisationID` ORDER BY Id) rn 
        FROM evadb_stage.c1518_XEROBLUE_Invoices
        WHERE Status in ('AUTHORISED', 'PAID')
    ) Invoices
WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquetransactions_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquetransactions_aud AS
SELECT
    `LineID` AS `Line ID`,
    `ID` AS `ID`,
    `Date` AS `Date`,
    `Type` AS `Type`,
    `ContactID` AS `Contact ID`,
    `ContactName` AS `Contact Name`,
    `LineItemID` AS `Line Item ID`,
    `Description` AS `Description`,
    `Quantity` AS `Quantity`,
    `UnitAmount` AS `Unit Amount`,
    `UnitAmount_AUD` AS `Unit Amount FX`,
    `ItemCode` AS `Item Code`,
    `AccountCode` AS `Account Code`,
    `TaxType` AS `Tax Type`,
    `TaxAmount` AS `Tax Amount`,
    `TaxAmount_AUD` AS `Tax Amount FX`,
    `LineAmount` AS `Line Amount`,
    `LineAmount_AUD` AS `Line Amount FX`,
    `LineAmountTypes` AS `Line Amount Types`,
    `Status` AS `Status`,
    `SubTotal` AS `Sub Total`,
    `SubTotal_AUD` AS `Sub Total FX`,
    `TotalTax` AS `Total Tax`,
    `TotalTax_AUD` AS `Total Tax FX`,
    `Total` AS `Total`,
    `Total_AUD` AS `Total FX`,
    `TrackingCategory1CategoryID` AS `Tracking Category 1 Category ID`,
    `TrackingCategory1CategoryName` AS `Tracking Category 1 Category Name`,
    `TrackingCategory1OptionID` AS `Tracking Category 1 Option ID`,
    `TrackingCategory1OptionName` AS `Tracking Category 1 Option Name`,
    `TrackingCategory1OptionStat` AS `Tracking Category 1 Option Stat`,
    `TrackingCategory2CategoryID` AS `Tracking Category 2 Category ID`,
    `TrackingCategory2CategoryName` AS `Tracking Category 2 Category Name`,
    `TrackingCategory2OptionID` AS `Tracking Category 2 Option ID`,
    `TrackingCategory2OptionName` AS `Tracking Category 2 Option Name`,
    `TrackingCategory2OptionStat` AS `Tracking Category 2 Option Stat`,
    `DiscountRate` AS `Discount Rate`,
    `CurrencyCode` AS `Currency Code`,
    `CurrencyRate` AS `Currency Rate`,
    `UpdatedDateUTC` AS `Updated Date UTC`,
    `AccountUID` AS `Account UID`,
    `HasAttachments` AS `Has Attachments`,
    `CreditNoteNumber` AS `Credit Note Number`,
    `RemainingCredit` AS `Remaining Credit`,
    `RemainingCredit_AUD` AS `Remaining Credit FX`,
    `FullyPaidOnDate` AS `Fully Paid On Date`,
    `Reference` AS `Reference`,
    `Source` AS `Source`,
    `ClientID` AS `Client ID`,
    `OrganisationID` AS `Organisation ID`
FROM (
    SELECT *, row_number() over(partition by `ID`, `OrganisationID` order by `LineID`) as rn
    FROM evadb_stage.c1518_XEROBLUE_Transactions
    WHERE ((`Source` = 'MANUALJOURNALS' AND `Status` = 'POSTED') OR `Status` IN ('AUTHORISED', 'PAID'))
)A WHERE rn = 1;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_transactionsblend_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_transactionsblend_aud AS
SELECT 
    tb.`Id` AS `ID`,
    tb.`JournalId` AS `Journal ID`,
    ROW_NUMBER() OVER (ORDER BY tb.`JournalDate` ASC) AS `Index`,
    tb.`JournalDate` AS `Journal Date`,
    tb.`JournalNumber` AS `Journal Number`,
    tb.`CreatedDateUTC` AS `Created Date UTC`,
    tb.`Reference` AS `Reference`,
    tb.`SourceId` AS `Source ID`,
    IFNULL(tb.`SourceType`, 'NULL VALUE') AS `Source Type`,
    tb.`JournalLine_JournalLineId` AS `Journal Line ID`,
    tb.`JournalLine_Description` AS `Description`,
    Acc.`AccountID` AS `Account ID`,
    Acc.`Code` AS `Account Code`,
    Acc.`AccountType` AS `Account Type`,
    Acc.`Name` AS `Account Name`,
    tb.`JournalLine_NetAmount` AS `Net Amount`,
    tb.`JournalLine_GrossAmount` AS `Gross Amount`,
    tb.`JournalLine_TaxAmount` AS `Tax Amount`,
    tb.`JournalLine_NetAmount_AUD` AS `Net Amount FX`,
    tb.`JournalLine_GrossAmount_AUD` AS `Gross Amount FX`,
    tb.`JournalLine_TaxAmount_AUD` AS `Tax Amount FX`,
    tb.`JournalLine_TaxType` AS `Tax Type`,
    tb.`JournalLine_TaxName` AS `Tax Name`,
    tb.`LineItem_TrackingCategory1_CategoryId` AS `Tracking Category 1 Category ID`,
    tb.`LineItem_TrackingCategory1_CategoryName` AS `Tracking Category 1 Category Name`,
    tb.`LineItem_TrackingCategory1_OptionId` AS `Tracking Category 1 Option ID`,
    tb.`LineItem_TrackingCategory1_OptionName` AS `Tracking Category 1 Option Name`,
    tb.`LineItem_TrackingCategory1_Option_Stat` AS `Tracking Category 1 Option Stat`,
    tb.`LineItem_TrackingCategory2_CategoryId` AS `Tracking Category 2 Category ID`,
    tb.`LineItem_TrackingCategory2_CategoryName` AS `Tracking Category 2 Category Name`,
    tb.`LineItem_TrackingCategory2_OptionId` AS `Tracking Category 2 Option ID`,
    tb.`LineItem_TrackingCategory2_OptionName` AS `Tracking Category 2 Option Name`,
    tb.`LineItem_TrackingCategory2_Option_Stat` AS `Tracking Category 2 Option Stat`,
    tb.`ClientID` AS `Client ID`,
    tb.`OrganisationID` AS `Organisation ID`,
    tb.`Split` AS `Split`,
    tb.`ContactID` AS `Contact ID`,
    tb.`ContactName` AS `Contact Name`,
    tb.`ContactSource` AS `ContactSource`,
    tb.`PaymentSourceID` AS `PaymentSourceID`,
    tb.`PaymentType` AS `PaymentType`,
    tb.`Changes` AS `Changes`,
    tb.`User` AS `User`,
    tb.`Details` AS `Details`,
    tb.`ShowOnCashBasisReports` AS `ShowOnCashBasisReports`,
    tb.`FullyPaidOnDate` AS `FullyPaidOnDate`,
    tb.`DayDifference` AS `DayDifference`,
    tb.`SourceNumber` AS `SourceNumber`,
    tb.`CashOrAccruals` AS `Cash/Accruals`,
    CASE 
        WHEN LOCATE('ACCREC', tb.`SourceType`) > 0 THEN 'ACCREC'
        WHEN LOCATE('ACCPAY', tb.`SourceType`) > 0 THEN 'ACCPAY'
        WHEN LEFT(tb.`SourceType`, 2) = 'AR' THEN 'ACCREC'
        WHEN LEFT(tb.`SourceType`, 2) = 'AP' THEN 'ACCPAY'
        ELSE 'OTHER UNRELATED TO AR/AP'
    END AS `ACC/ACCPAY`,

    Acc.`Class` AS `Accounts.Class`,

    CASE 
        WHEN Acc.`Class` = 'Revenue' THEN 'PnL'
        WHEN Acc.`Class` = 'Expense' THEN 'PnL'
        WHEN Acc.`Class` = 'Asset' THEN 'BS'
        WHEN Acc.`Class` = 'Liability' THEN 'BS'
        WHEN Acc.`Class` = 'Equity' THEN 'BS'
        ELSE NULL
    END AS `PnL-BS`,

    CASE
        WHEN tb.`SourceType` = 'ACCREC' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCPAY' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCREC' AND tb.`CashOrAccruals` = 'Cash' THEN 'Cash'
        WHEN tb.`SourceType` = 'ACCPAY' AND tb.`CashOrAccruals` = 'Cash' THEN 'Cash'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Applied' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Applied' THEN 'Payments'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Approved' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Approved' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Edited' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Edited' THEN 'Accruals'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Credited' THEN 'Payments'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Credited' THEN 'Payments'
        WHEN tb.`SourceType` = 'ACCRECPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Payments'
        WHEN tb.`SourceType` = 'ACCPAYPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Payments'
        WHEN tb.`SourceType` = 'ARCREDITPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Payments'
        WHEN tb.`SourceType` = 'APCREDITPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'Payments'
        WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'CashOPPP'
        WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' THEN 'CashOPPP'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Applied' THEN 'Accruals'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Applied' THEN 'Accruals'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Approved' THEN 'Accruals'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Approved' THEN 'Accruals'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Edited' THEN 'Accruals'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Edited' THEN 'Accruals'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Credited' THEN ' Payments'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Credited' THEN 'Payments'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Cash Refunded' THEN 'CashOPPP'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`CashOrAccruals` = 'Accruals' AND tb.`Changes` = 'Cash Refunded' THEN 'CashOPPP'
        ELSE NULL
    END AS `Aged Movement`,

    CASE
        WHEN Acc.`Type` = 'BANK' AND tb.`JournalLine_GrossAmount_AUD` >= 0 THEN tb.`JournalLine_GrossAmount_AUD`
        ELSE NULL
    END AS `Cash Received`,

    CASE
        WHEN Acc.`Type` = 'BANK' AND tb.`JournalLine_GrossAmount_AUD` < 0 THEN 0 - tb.`JournalLine_GrossAmount_AUD`
        ELSE NULL
    END AS `Cash Spent`,

    CASE
        WHEN tb.`JournalLine_GrossAmount` >= 0 THEN tb.`JournalLine_GrossAmount`
        ELSE NULL
    END AS `Debit Gross`,

    CASE
        WHEN tb.`JournalLine_NetAmount` >= 0 THEN tb.`JournalLine_NetAmount`
        ELSE NULL
    END AS `Debit Net Amount`,

    CASE
        WHEN tb.`JournalLine_GrossAmount` < 0 THEN 0 - tb.`JournalLine_GrossAmount`
        ELSE NULL
    END AS `Credit Gross`,

    CASE
        WHEN tb.`JournalLine_NetAmount` < 0 THEN 0 - tb.`JournalLine_NetAmount`
        ELSE NULL
    END AS `Credit Net Amount`,

    CASE
        WHEN tb.`JournalLine_GrossAmount_AUD` >= 0 THEN tb.`JournalLine_GrossAmount_AUD`
        ELSE NULL
    END AS `Debit Gross FX`,

    CASE
        WHEN tb.`JournalLine_NetAmount_AUD` >= 0 THEN tb.`JournalLine_NetAmount_AUD`
        ELSE NULL
    END AS `Debit Net Amount FX`,

    CASE
        WHEN tb.`JournalLine_GrossAmount_AUD` < 0 THEN 0 - tb.`JournalLine_GrossAmount_AUD`
        ELSE NULL
    END AS `Credit Gross FX`,

    CASE
        WHEN tb.`JournalLine_NetAmount_AUD` < 0 THEN 0 - tb.`JournalLine_NetAmount_AUD`
        ELSE NULL
    END AS `Credit Net Amount FX`,

    CASE
        WHEN 
          (CASE 
            WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` < 0 THEN 'GST Collected'
            WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` >= 0 THEN 'GST Paid'
            ELSE tb.`JournalLine_AccountName`
          END) = 'GST Collected' THEN 'PLUS GST Movements'
        WHEN 
          (CASE 
            WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` < 0 THEN 'GST Collected'
            WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` >= 0 THEN 'GST Paid'
            ELSE tb.`JournalLine_AccountName`
          END) = 'GST Paid' THEN 'PLUS GST Movements'
        WHEN Acc.`Type` = 'BANK' THEN 'Cash Surplus (Deficit)'
        WHEN Acc.`Class` = 'Asset' THEN 'Income'
        WHEN Acc.`Class` = 'Revenue' THEN 'Income'
        WHEN Acc.`Class` = 'Liability' THEN 'Less Expenses'
        WHEN Acc.`Class` = 'Expense' THEN 'Less Expenses'
        WHEN Acc.`Class` = 'Equity' THEN 'Less Expenses'
        ELSE Acc.`Name`
    END AS `Cash Summary`,

    CASE    
        WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` < 0 THEN 'GST Collected'
        WHEN tb.`JournalLine_AccountName` = 'GST' AND tb.`JournalLine_NetAmount_AUD` >= 0 THEN 'GST Paid'
        ELSE tb.`JournalLine_AccountName`
    END AS `Detailed Breakdown Account Names`,

    CASE 
        WHEN tb.`SourceType` = 'ACCREC' THEN 'Receivable Invoice'
        WHEN tb.`SourceType` = 'ACCPAY' THEN 'Payable Invoice'
        WHEN tb.`SourceType` = 'ACCRECPAYMENT' THEN 'Receivable Payment'
        WHEN tb.`SourceType` = 'ACCPAYPAYMENT' THEN 'Payable Payment'
        WHEN tb.`SourceType` = 'ARCREDITPAYMENT' THEN 'Receivable Credit Note Payment'
        WHEN tb.`SourceType` = 'APCREDITPAYMENT' THEN 'Payable Credit Note Payment'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Approved' THEN 'Receivable Credit Note'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Approved' THEN 'Payable Credit Note'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Edited' THEN 'Receivable Credit Note'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Edited' THEN 'Payable Credit Note'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Credited' THEN 'Receivable Credit Note Allocation'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Credited' THEN 'Payable Credit Note Allocation'
        WHEN tb.`SourceType` = 'ACCRECCREDIT' AND tb.`Changes` = 'Applied' THEN 'Receivable Credit Note Allocation'
        WHEN tb.`SourceType` = 'ACCPAYCREDIT' AND tb.`Changes` = 'Applied' THEN 'Payable Credit Note Allocation'
        WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Prepayment'
        WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Prepayment'
        WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Prepayment'
        WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Prepayment'
        WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Prepayment Allocation'
        WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Prepayment Allocation'
        WHEN tb.`SourceType` = 'ARPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Prepayment Note Allocation'
        WHEN tb.`SourceType` = 'APPREPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Prepayment Allocation'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Receivable Overpayment'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Approved' THEN 'Payable Overpayment'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Receivable Overpayment'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Edited' THEN 'Payable Overpayment'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Receivable Overpayment Allocation'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Credited' THEN 'Payable Overpayment Allocation'
        WHEN tb.`SourceType` = 'AROVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Receivable Overpayment Allocation'
        WHEN tb.`SourceType` = 'APOVERPAYMENT' AND tb.`Changes` = 'Applied' THEN 'Payable Overpayment Allocation'
        ELSE NULL 
    END AS `Source`,

    CASE
        WHEN tb.`ContactSource` = 'PAYMENTS' THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
        WHEN tb.`ContactSource` = 'INVOICES' THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
        WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Approved' THEN
            TRIM(REPLACE (CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
        WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` = 'Edited' THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
        WHEN tb.`ContactSource` = 'CREDITNOTES' AND tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
        WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
        WHEN tb.`ContactSource` = 'OVERPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
        WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Approved', 'Edited', 'Cash Refunded') THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`SourceId`), '  ', ' '))
        WHEN tb.`ContactSource` = 'PREPAYMENTS' AND tb.`Changes` IN ('Applied', 'Credited') THEN
            TRIM(REPLACE(CONCAT(tb.`JournalLine_AccountId`, ' | ', tb.`PaymentSourceID`), '  ', ' '))
        ELSE NULL
    END AS `Sync`,

    tb.`PlannedPaymentDate` AS `Planned Payment Date`,
    tb.`ItemCode` AS `Item Code`,
    tb.`Quantity` AS `Quantity`,
    tb.`DiscountRate` AS `Discount Rate`,
    tb.`UnitAmount` AS `Unit Amount`,
    tb.`UnitAmount_AUD` AS `Unit Amount FX`,
    tb.`AmountDue` AS `Amount Due`,
    tb.`AmountDue_AUD` AS `Amount Due FX`,
    tb.`URL` AS `URL`,
    tb.`DueDate` AS `Due Date`,
    Acc.`SystemAccount` AS `System Account`,
    NULL AS `Invoice Total`
    #I.`Invoice Total` AS `Invoice Total`
FROM evadb_stage.c1518_xeroblue_transactionsblend Tb
LEFT JOIN evadb_stage.c1518_xeroblue_accounts Acc 
ON tb.`JournalLine_AccountId` = Acc.`AccountId` AND tb.`OrganisationID` = Acc.`OrganisationID`;


DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquebanktransactions_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquebanktransactions_aud AS
SELECT
    b.`Id`                                        AS `Bank Transaction Line ID`,
    b.`BankTransactionId`                         AS `Bank Transaction ID`,
    b.`Type`                                      AS `Type`,
    b.`Contact_ContactName`                       AS `Contact Name`,
    b.`Contact_ContactId`                         AS `Contact ID`,
    b.`BankAccount_AccountId`                     AS `Account ID`,
    b.`BankAccount_AccountName`                   AS `Bank Account Account Name`,
    b.`BankAccount_Code`                          AS `Bank Account Code`,
    b.`LineItem_LineItemId`                       AS `Line Item ID`,
    b.`LineItem_Description`                      AS `Description`,
    b.`LineItem_Quantity`                         AS `Quantity`,
    b.`LineItem_UnitAmount`                       AS `Unit Amount`,
    b.`LineItem_AccountCode`                      AS `Account Code Posted Against`,
    b.`LineItem_TaxType`                          AS `Tax Type`, 
    b.`LineItem_TaxAmount`                        AS `Tax Amount`,
    b.`LineItem_ItemCode`                         AS `Item Code`,
    b.`LineItem_LineAmount`                       AS `Line Amount`,
    b.`LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 CategoryID`,
    b.`LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Name`,
    b.`LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    b.`LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    b.`LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    b.`LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 CategoryID`,
    b.`LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    b.`LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    b.`LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    b.`LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    b.`LineItemAggregate`                         AS `Line Item Aggregate`,
    b.`IsReconciled`                              AS `Is Reconciled`,
    b.`Date`                                      AS `Date`,
    b.`Reference`                                 AS `Reference`,
    b.`CurrencyCode`                              AS `Currency Code`,
    b.`CurrencyRate`                              AS `Currency Rate`,
    b.`URL`                                       AS `URL`,
    b.`Status`                                    AS `Status`,
    b.`SubTotal`                                  AS `Sub Total`,
    b.`TotalTax`                                  AS `Total Tax`,
    b.`Total`                                     AS `Total`,
    b.`PrepaymentId`                              AS `Prepayment ID`,
    b.`OverpaymentId`                             AS `Overpayment ID`,
    b.`UpdatedDateUTC`                            AS `Updated Date UTC`,
    b.`FullyPaidOnDate`                           AS `Fully Paid On Date`,
    b.`ClientID`                                  AS `Client ID`,
    b.`OrganisationID`                            AS `Organisation ID`,
    b.`LineAmountTypes`                           AS `Line Amount Types`,
    b.`Account_UID`                               AS `Account_UID`,
    b.`ConditionalType`                           AS `Conditional Type`,
    b.`LineItem_TaxAmount_AUD`                    AS `Tax Amount FX`,
    b.`LineItem_LineAmount_AUD`                   AS `Line Amount FX`,
    b.`SubTotal_AUD`                              AS `Sub Total FX`,
    b.`TotalTax_AUD`                              AS `Total Tax Fx`,
    b.`Total_AUD`                                 AS `Total FX`
FROM evadb_stage.c1518_XEROBLUE_BankTransactions b
INNER JOIN bigoleshoecompany_client1518_xeroblue_uniquetransactions_aud t 
    ON b.`Id` = t.`Line ID` AND b.`OrganisationID` = t.`Organisation ID`
WHERE t.`Source` = 'BANKTRANSACTIONS'; 








-- source table not yet created
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_budgetsummary_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_budgetsummary_aud AS
SELECT 
    `ID`                     AS `ID`,
    `Title`                  AS `Title`,
    `AccountId`              AS `AccountId`,
    `BankAccount`            AS `Account Name`,
    `ClientID`               AS `Client ID`,
    `OrganisationID`         AS `Organisation ID`,
    `FinancialYear`          AS `Financial Year`,
    `AccountName_UID`        AS `AccountName_UID`,
    `Amount`                 AS `Amount`,
    `Month`                  AS `Month`,
    `Amount_AUD`             AS `Amount_AUD`,
    `TotalAmount`            AS `Total Amount`,
    `TotalAmount_AUD`        AS `Total Amount FX`
FROM evadb_stage.c1518_XEROBLUE_BudgetSummaryInterim;


--Duplicate view - should bew deleted
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_uniquecreditnotesdq_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_uniquecreditnotesdq_aud AS
SELECT
    `CreditNoteId`                              AS `Credit Note ID`, 
    `Id`                                        AS `Credit Note Line ID`,
    `CreditNoteNumber`                          AS `Credit Note Number`,
    `Reference`                                 AS `Reference`,
    `Type`                                      AS `Type`,
    `Contact_ContactId`                         AS `Contact ID`,
    `Contact_Name`                              AS `Contact Name`,
    `Date`                                      AS `Date`,
    `Status`                                    AS `Status`,
    `LineAmountTypes`                           AS `Line Amount Types`,
    `LineItem_Description`                      AS `Description`,
    `LineItem_Quantity`                         AS `Quantity`,
    `LineItem_UnitAmount`                       AS `Unit Amount`,
    `LineItem_ItemCode`                         AS `Item Code`,
    `LineItem_AccountCode`                      AS `Account Code`,
    `LineItem_TaxType`                          AS `Tax Type`,
    `LineItem_TaxAmount`                        AS `Tax Amount`,
    `LineItem_LineAmount`                       AS `Line Amount`,
    `LineItem_TrackingCategory1_CategoryId`     AS `Tracking Category 1 Category ID`,
    `LineItem_TrackingCategory1_CategoryName`   AS `Tracking Category 1 Category Name`,
    `LineItem_TrackingCategory1_OptionId`       AS `Tracking Category 1 Option ID`,
    `LineItem_TrackingCategory1_OptionName`     AS `Tracking Category 1 Option Name`,
    `LineItem_TrackingCategory1_Option_Stat`    AS `Tracking Category 1 Option Stat`,
    `LineItem_TrackingCategory2_CategoryId`     AS `Tracking Category 2 Category ID`,
    `LineItem_TrackingCategory2_CategoryName`   AS `Tracking Category 2 Category Name`,
    `LineItem_TrackingCategory2_OptionId`       AS `Tracking Category 2 Option ID`,
    `LineItem_TrackingCategory2_OptionName`     AS `Tracking Category 2 Option Name`,
    `LineItem_TrackingCategory2_Option_Stat`    AS `Tracking Category 2 Option Stat`,
    `LineItem_DiscountRate`                     AS `Discount Rate`,
    `LineItemAggregate`                         AS `Line Item Aggregate`,
    `SubTotal`                                  AS `Sub Total`,
    `TotalTax`                                  AS `Total Tax`,
    `Total`                                     AS `Total`,
    `UpdatedDateUTC`                            AS `Updated Date UTC`,
    `CurrencyCode`                              AS `Currency Code`,
    `FullyPaidOnDate`                           AS `Fully Paid On Date`,
    `SentToContact`                             AS `Sent To Contact`,
    `BrandingThemeId`                           AS `Branding Theme ID`,
    `CurrencyRate`                              AS `Currency Rate`,
	`HasAttachments`                            AS `Has Attachments`,
	`ClientID`                                  AS `Client ID` ,
	`OrganisationID`                            AS `Organisation ID`,
    `RemainingCredit`                           AS `Remaining Credit`,
    `Allocation1_AppliedAmount`                 AS `Allocation 1 Applied Amount`,
    `Allocation1_Date`                          AS `Allocation 1 Date`,
    `Allocation1_InvoiceId`                     AS `Allocation 1 Invoice ID`,
    `Allocation1_InvoiceNumber`                 AS `Allocation 1 Invoice Number`,
    `Allocation2_AppliedAmount`                 AS `Allocation 2 Applied Amount`,
    `Allocation2_Date`                          AS `Allocation 2 Date`,
    `Allocation2_InvoiceId`                     AS `Allocation 2 Invoice ID`,
    `Allocation2_InvoiceNumber`                 AS `Allocation 2 Invoice Number`,
    `Allocation3_AppliedAmount`                 AS `Allocation 3 Applied Amount`,
    `Allocation3_Date`                          AS `Allocation 3 Date`,
    `Allocation3_InvoiceId`                     AS `Allocation 3 Invoice ID`,
    `Allocation3_InvoiceNumber`                 AS `Allocation 3 Invoice Number`,
    `Allocation4_AppliedAmount`                 AS `Allocation 4 Applied Amount`,
    `Allocation4_Date`                          AS `Allocation 4 Date`,
    `Allocation4_InvoiceId`                     AS `Allocation 4 Invoice ID`,
    `Allocation4_InvoiceNumber`                 AS `Allocation 4 Invoice Number`,
    `Allocation5_AppliedAmount`                 AS `Allocation 5 Applied Amount`,
    `Allocation5_Date`                          AS `Allocation 5 Date`,
    `Allocation5_InvoiceId`                     AS `Allocation 5 Invoice ID`,
    `Allocation5_InvoiceNumber`                 AS `Allocation 5 Invoice Number`,
    `Allocation6_AppliedAmount`                 AS `Allocation 6 Applied Amount`,
    `Allocation6_Date`                          AS `Allocation 6 Date`,
    `Allocation6_InvoiceId`                     AS `Allocation 6 Invoice ID`,
    `Allocation6_InvoiceNumber`                 AS `Allocation 6 Invoice Number`,
    `Allocation7_AppliedAmount`                 AS `Allocation 7 Applied Amount`,
    `Allocation7_Date`                          AS `Allocation 7 Date`,
    `Allocation7_InvoiceId`                     AS `Allocation 7 Invoice ID`,
    `Allocation7_InvoiceNumber`                 AS `Allocation 7 Invoice Number`,
    `Allocation8_AppliedAmount`                 AS `Allocation 8 Applied Amount`,
    `Allocation8_Date`                          AS `Allocation 8 Date`,
    `Allocation8_InvoiceId`                     AS `Allocation 8 Invoice ID`,
    `Allocation8_InvoiceNumber`                 AS `Allocation 8 Invoice Number`,
    `Allocation9_AppliedAmount`                 AS `Allocation 9 Applied Amount`,
    `Allocation9_Date`                          AS `Allocation 9 Date`,
    `Allocation9_InvoiceId`                     AS `Allocation 9 Invoice ID`,
    `Allocation9_InvoiceNumber`                 AS `Allocation 9 Invoice Number`,
    `Allocation10_AppliedAmount`                AS `Allocation 10 Applied Amount`,
    `Allocation10_Date`                         AS `Allocation 10 Date`,
    `Allocation10_InvoiceId`                    AS `Allocation 10 Invoice ID`,
    `Allocation10_InvoiceNumber`                AS `Allocation 10 Invoice Number`,
    `Allocation11_AppliedAmount`                AS `Allocation 11 Applied Amount`,
    `Allocation11_Date`                         AS `Allocation 11 Date`,
    `Allocation11_InvoiceId`                    AS `Allocation 11 Invoice ID`,
    `Allocation11_InvoiceNumber`                AS `Allocation 11 Invoice Number`,
    `Allocation12_AppliedAmount`                AS `Allocation 12 Applied Amount`,
    `Allocation12_Date`                         AS `Allocation 12 Date`,
    `Allocation12_InvoiceId`                    AS `Allocation 12 Invoice ID`,
    `Allocation12_InvoiceNumber`                AS `Allocation 12 Invoice Number`,
    `Allocation13_AppliedAmount`                AS `Allocation 13 Applied Amount`,
    `Allocation13_Date`                         AS `Allocation 13 Date`,
    `Allocation13_InvoiceId`                    AS `Allocation 13 Invoice ID`,
    `Allocation13_InvoiceNumber`                AS `Allocation 13 Invoice Number`,
    `Allocation14_AppliedAmount`                AS `Allocation 14 Applied Amount`,
    `Allocation14_Date`                         AS `Allocation 14 Date`,
    `Allocation14_InvoiceId`                    AS `Allocation 14 Invoice ID`,
    `Allocation14_InvoiceNumber`                AS `Allocation 14 Invoice Number`,
    `Allocation15_AppliedAmount`                AS `Allocation 15 Applied Amount`,
    `Allocation15_Date`                         AS `Allocation 15 Date`,
    `Allocation15_InvoiceId`                    AS `Allocation 15 Invoice ID`,
    `Allocation15_InvoiceNumber`                AS `Allocation 15 Invoice Number`,
    `AccountUID`                                AS `Account UID`,
    `LineItem_TaxAmount_AUD`                    AS `Tax Amount FX`,
    `LineItem_LineAmount_AUD`                   AS `Line Amount FX`,
    `SubTotal_AUD`                              AS `Sub Total FX`,
    `TotalTax_AUD`                              AS `Total Tax FX`,
    `Total_AUD`                                 AS `Total FX`,
    `RemainingCredit_AUD`                       AS `Remaining Credit FX`,
    `Allocation1_AppliedAmount_AUD`             AS `Allocation 1 Applied Amount FX`,
    `Allocation2_AppliedAmount_AUD`             AS `Allocation 2 Applied Amount FX`,
    `Allocation3_AppliedAmount_AUD`             AS `Allocation 3 Applied Amount FX`,
    `Allocation4_AppliedAmount_AUD`             AS `Allocation 4 Applied Amount FX`,
    `Allocation5_AppliedAmount_AUD`             AS `Allocation 5 Applied Amount FX`,
    `Allocation6_AppliedAmount_AUD`             AS `Allocation 6 Applied Amount FX`,
    `Allocation7_AppliedAmount_AUD`             AS `Allocation 7 Applied Amount FX`,
    `Allocation8_AppliedAmount_AUD`             AS `Allocation 8 Applied Amount FX`,
    `Allocation9_AppliedAmount_AUD`             AS `Allocation 9 Applied Amount FX`,
    `Allocation10_AppliedAmount_AUD`            AS `Allocation 10 Applied Amount FX`,
    `Allocation11_AppliedAmount_AUD`            AS `Allocation 11 Applied Amount FX`,
    `Allocation12_AppliedAmount_AUD`            AS `Allocation 12 Applied Amount FX`,
    `Allocation13_AppliedAmount_AUD`            AS `Allocation 13 Applied Amount FX`,
    `Allocation14_AppliedAmount_AUD`            AS `Allocation 14 Applied Amount FX`,
    `Allocation15_AppliedAmount_AUD`            AS `Allocation 15 Applied Amount FX`
FROM (
    SELECT *, Row_number() OVER(PARTITION BY `CreditNoteId`, `OrganisationID` ORDER BY Id) rn 
    FROM evadb_stage.c1518_xeroblue_creditnotes
) t WHERE rn = 1;


--new view
DROP VIEW IF EXISTS bigoleshoecompany_client1518_xeroblue_cashaggregated_aud;
CREATE VIEW bigoleshoecompany_client1518_xeroblue_cashaggregated_aud AS
SELECT 
    a.`InvoiceId` AS `Cash Source ID`,
    a.`Type` AS `Type`,
    a.`ContactId` AS `Contact ID`,
    a.`Date` AS `Date`,
    a.`PaymentDate` AS `Payment Date`,
    a.`OrganisationID` AS `Organisation ID`,
    a.`PaymentAccountID` AS `Payment Account ID`,
    a.`Payments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    a.`Payments Calculated Amount Inc Tax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Invoice' AS `Cash Type`,
    a.`Account_UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoicepaymentcash_aud a
UNION ALL
SELECT 
    b.`CreditNoteId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact_ContactId` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`OrganisationID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Credit Note Allocation Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Credit Note Allocation Calculated Amount Inc Tax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Credit Note' AS `Cash Type`,
    b.`Account UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoicecreditnotecash_aud b
UNION ALL
SELECT 
    b.`OverpaymentId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact ID` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`Organisation ID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Overpayments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Overpayments Calculated Amount FX` + b.`TotalTax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Overpayment' AS `Cash Type`,
    b.`Account_UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoiceoverpaymentcash_aud b
UNION ALL
SELECT 
    b.`PrepaymentId` AS `Cash Source ID`,
    b.`Type` AS `Type`,
    b.`Contact ID` AS `Contact ID`,
    b.`Date` AS `Date`,
    b.`PaymentDate` AS `Payment Date`,
    b.`Organisation ID` AS `Organisation ID`,
    b.`PaymentAccountID` AS `Payment Account ID`,
    b.`Prepayments Calculated Amount FX` AS `Payment Calculated Amount FX`,
    b.`Prepayments Calculated Amount FX` + b.`TotalTax FX` AS `Payment Calculated Amount Inc Tax FX`,
    'Prepayment' AS `Cash Type`,
    b.`Account UID` AS `Account_UID`
FROM bigoleshoecompany_client1518_xeroblue_invoiceprepaymentcash_aud b;