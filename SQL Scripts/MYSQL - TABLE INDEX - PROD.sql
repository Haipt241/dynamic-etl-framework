-- c0000_xeroblue_accounts
ALTER TABLE evadb_stage.c0000_xeroblue_accounts
ADD INDEX c0000_xeroblue_accounts_A_idx (AccountId);

ALTER TABLE evadb_stage.c0000_xeroblue_accounts
ADD INDEX c0000_xeroblue_accounts_OrganisationIDCode_idx (OrganisationID, Code);

ALTER TABLE evadb_stage.c0000_xeroblue_accounts
ADD INDEX c0000_xeroblue_accounts_SystemAccount_idx (SystemAccount);

ALTER TABLE evadb_stage.c0000_xeroblue_accounts
ADD INDEX idx_accounts_AccountId_OrgID (AccountId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_accounts
ADD INDEX c0000_xeroblue_accounts_orgidacctype_idx (OrganisationID, AccountType);


-- c0000_xeroblue_banktransactions
ALTER TABLE evadb_stage.c0000_xeroblue_banktransactions
ADD INDEX c0000_xeroblue_BankTransactions_BTI_idx (BankTransactionId);

ALTER TABLE evadb_stage.c0000_xeroblue_banktransactions
ADD INDEX c0000_xeroblue_BankTransactions_BTILILII_idx (BankTransactionId, LineItem_LineItemId);

ALTER TABLE evadb_stage.c0000_xeroblue_banktransactions
ADD INDEX c0000_xeroblue_BankTransactions_LILII_idx (LineItem_LineItemId);

ALTER TABLE evadb_stage.c0000_xeroblue_banktransactions
ADD INDEX c0000_xeroblue_BankTransactions_OIBTI_idx (OrganisationID, BankTransactionId);

ALTER TABLE evadb_stage.c0000_xeroblue_banktransactions
ADD INDEX c0000_xeroblue_BankTransactions_OrgID_idx (OrganisationID);


-- c0000_xeroblue_banktransfers
ALTER TABLE evadb_stage.c0000_xeroblue_banktransfers
ADD INDEX c0000_xeroblue_banktransfers_OIBTI_idx (OrganisationID, BankTransferId);

ALTER TABLE evadb_stage.c0000_xeroblue_banktransfers
ADD INDEX c0000_xeroblue_BankTransfers_OrgID_idx (OrganisationID);


-- c0000_xeroblue_batchpayments
ALTER TABLE evadb_stage.c0000_xeroblue_batchpayments
ADD INDEX c0000_xeroblue_BatchPayments_OIBPI_idx (OrganisationID, BatchPaymentId);


-- c0000_xeroblue_contacts
ALTER TABLE evadb_stage.c0000_xeroblue_contacts
ADD INDEX c0000_xeroblue_Contacts_OrganisationIDContactId_idx (OrganisationID, ContactId);


-- c0000_xeroblue_creditnotes
ALTER TABLE evadb_stage.c0000_xeroblue_creditnotes
ADD INDEX c0000_xeroblue_CreditNotes_OrganisationIDCreditNoteID_idx (OrganisationID, CreditNoteId);

ALTER TABLE evadb_stage.c0000_xeroblue_creditnotes
ADD INDEX c0000_xeroblue_CreditNotes_id_rg_idx (CreditNoteId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_creditnotes
ADD INDEX c0000_xeroblue_CreditNotes_OrgID_idx (OrganisationID);


-- c0000_xeroblue_invoices
ALTER TABLE evadb_stage.c0000_xeroblue_invoices
ADD INDEX c0000_xeroblue_Invoices_InvoiceId_idx (InvoiceId);

ALTER TABLE evadb_stage.c0000_xeroblue_invoices
ADD INDEX c0000_xeroblue_Invoices_InvoiceIdUpdatedDateUTC_idx (InvoiceId, UpdatedDateUTC);

ALTER TABLE evadb_stage.c0000_xeroblue_invoices
ADD INDEX c0000_xeroblue_Invoices_OrganisationIDInvoiceId_idx (OrganisationID, InvoiceId);

ALTER TABLE evadb_stage.c0000_xeroblue_invoices
ADD INDEX c0000_xeroblue_Invoices_OrgID_idx (OrganisationID);


-- c0000_xeroblue_journals
ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_idx_journalid_organisationid (JournalId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_J_idx (JournalLine_JournalLineId);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_JD_idx (JournalDate);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_JI_idx (JournalId);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_JIJLJLI_idx (JournalId, JournalLine_JournalLineId);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_OJJ_idx (OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_OrgID_idx (OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_OS_idx (OrganisationID, SourceId);

ALTER TABLE evadb_stage.c0000_xeroblue_journals
ADD INDEX c0000_xeroblue_Journals_OJDJLNA_idx (OrganisationID, JournalDate, JournalLine_NetAmount);


-- c0000_xeroblue_journalscash
ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_journalscash_idx_journalid_organisationid (JournalId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_J_idx (JournalLine_JournalLineId);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_JD_idx (JournalDate);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_JI_idx (JournalId);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_JIJLJLI_idx (JournalId, JournalLine_JournalLineId);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_OJJ_idx (OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_OrgID_idx (OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_JournalsCash_OS_idx (OrganisationID, SourceId);

ALTER TABLE evadb_stage.c0000_xeroblue_journalscash
ADD INDEX c0000_xeroblue_Journalscash_OJDJLNA_idx (OrganisationID, JournalDate, JournalLine_NetAmount);


-- c0000_xeroblue_manualjournals
ALTER TABLE evadb_stage.c0000_xeroblue_manualjournals
ADD INDEX c0000_xeroblue_manualjournals_idx_journalid_organisationid (ManualJournalId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_manualjournals
ADD INDEX c0000_xeroblue_ManualJournals_OrgID_idx (OrganisationID);


-- c0000_xeroblue_organisationsclients
ALTER TABLE evadb_stage.c0000_xeroblue_organisationsclients
ADD INDEX c0000_xeroblue_organisationsclients_OrganisationIDBaseCurren_idx (OrganisationID, BaseCurrency);


-- c0000_xeroblue_overpayments
ALTER TABLE evadb_stage.c0000_xeroblue_overpayments
ADD INDEX c0000_xeroblue_overpayments_id_org_idx (OverpaymentId, OrganisationID);


-- c0000_xeroblue_payments
ALTER TABLE evadb_stage.c0000_xeroblue_payments
ADD INDEX c0000_xeroblue_payments_id_org_idx (InvoiceId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_payments
ADD INDEX c0000_xeroblue_payments_id_org2_idx (PaymentId, OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_payments
ADD INDEX c0000_xeroblue_Payments_OrganisationIDInvoiceIdPaymentId_idx (OrganisationID, InvoiceId, PaymentId);

ALTER TABLE evadb_stage.c0000_xeroblue_payments
ADD INDEX c0000_xeroblue_Payments_OrganisationIDInvoiceIdPaymentType_idx (OrganisationID, InvoiceId, PaymentType);

ALTER TABLE evadb_stage.c0000_xeroblue_payments
ADD INDEX c0000_xeroblue_Payments_OrganisationIDUpdatedDateUTC_idx (OrganisationID, UpdatedDateUTC);


-- c0000_xeroblue_prepayments
ALTER TABLE evadb_stage.c0000_xeroblue_prepayments
ADD INDEX c0000_xeroblue_prepayments_id_org_idx (PrepaymentId, OrganisationID);


-- c0000_xeroblue_transactions
ALTER TABLE evadb_stage.c0000_xeroblue_transactions
ADD INDEX c0000_xeroblue_transactions_IdOrganisationIDAllocationDateAl_idx (ID, OrganisationID, AllocationDate, AllocationAmount);

ALTER TABLE evadb_stage.c0000_xeroblue_transactions
ADD INDEX c0000_xeroblue_Transactions_OAL_idx (OrganisationID, AccountCode, LineAmount);

ALTER TABLE evadb_stage.c0000_xeroblue_transactions
ADD INDEX c0000_xeroblue_Transactions_OrgID_idx (OrganisationID);

ALTER TABLE evadb_stage.c0000_xeroblue_transactions
ADD INDEX c0000_xeroblue_Transactions_OrgIDId_idx (OrganisationID, ID);

ALTER TABLE evadb_stage.c0000_xeroblue_transactions
ADD INDEX c0000_xeroblue_transactions_PaymentSourceID_idx (PaymentSourceID);