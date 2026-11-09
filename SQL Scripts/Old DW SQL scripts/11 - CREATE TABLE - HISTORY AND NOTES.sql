/*
Notes : Table and Stored Procedure Scripts already added on other scripts
*/
--CreditNotes
CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[CreditNoteId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_INSERT](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[CreditNoteId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_REFRESH](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[CreditNoteId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_CreditNotes](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[CreditNoteId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

--Overpayments
CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[OverpaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_INSERT](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[OverpaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_REFRESH](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[OverpaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_Overpayments](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[OverpaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

--Prepayments
CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[PrepaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_INSERT](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[PrepaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_REFRESH](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[PrepaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_Prepayments](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[PrepaymentId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

--Invoices
CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[InvoiceId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_INSERT](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[InvoiceId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_REFRESH](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[InvoiceId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO

CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUEHN_Invoices](
	[Changes] [nvarchar](255) NULL,
	[DateUTCString] [nvarchar](255) NULL,
	[DateUTC] [datetime] NULL,
	[User] [nvarchar](255) NULL,
	[Details] [nvarchar](max) NULL,
	[InvoiceId] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID))
GO





--XEROBLUEHN_CreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_INSERT', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_INSERT
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_INSERT
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes 
	WHERE OrganisationId = @OrganisationID
	AND CreditNoteId IN (SELECT CreditNoteId FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_CreditNotes', 'NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_INSERT'
GO

--XEROBLUEHN_CreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_REFRESH', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_REFRESH
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes_REFRESH
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes 
	WHERE OrganisationId = @OrganisationID
	AND CreditNoteId IN (SELECT CreditNoteId FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_CreditNotes', 'NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE_REFRESH'
GO

--XEROBLUEHN_CreditNotes - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_CreditNotes
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes 
	WHERE OrganisationId = @OrganisationID
	AND CreditNoteId IN (SELECT CreditNoteId FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotes
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_CreditNotes', 'NEW_CLIENT1_XEROBLUEHN_CreditNotesSTAGE'
GO



--XEROBLUEHN_Overpayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments 
	WHERE OrganisationId = @OrganisationID
	AND OverpaymentId IN (SELECT OverpaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Overpayments', 'NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE'
GO

--XEROBLUEHN_Overpayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_INSERT', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_INSERT
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_INSERT
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments 
	WHERE OrganisationId = @OrganisationID
	AND OverpaymentId IN (SELECT OverpaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Overpayments', 'NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_INSERT'
GO

--XEROBLUEHN_Overpayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_REFRESH', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_REFRESH
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Overpayments_REFRESH
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments 
	WHERE OrganisationId = @OrganisationID
	AND OverpaymentId IN (SELECT OverpaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Overpayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Overpayments', 'NEW_CLIENT1_XEROBLUEHN_OverpaymentsSTAGE_REFRESH'
GO



--XEROBLUEHN_Prepayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments 
	WHERE OrganisationId = @OrganisationID
	AND PrepaymentId IN (SELECT PrepaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Prepayments', 'NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE'
GO

--XEROBLUEHN_Prepayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_INSERT', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_INSERT
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_INSERT
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments 
	WHERE OrganisationId = @OrganisationID
	AND PrepaymentId IN (SELECT PrepaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Prepayments', 'NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_INSERT'
GO

--XEROBLUEHN_Prepayments - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_REFRESH', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_REFRESH
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Prepayments_REFRESH
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments 
	WHERE OrganisationId = @OrganisationID
	AND PrepaymentId IN (SELECT PrepaymentId FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Prepayments
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Prepayments', 'NEW_CLIENT1_XEROBLUEHN_PrepaymentsSTAGE_REFRESH'
GO



--XEROBLUEHN_Invoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Invoices 
	WHERE OrganisationId = @OrganisationID
	AND InvoiceId IN (SELECT InvoiceId FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Invoices
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Invoices', 'NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE'
GO

--XEROBLUEHN_Invoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_INSERT', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_INSERT
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_INSERT
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Invoices 
	WHERE OrganisationId = @OrganisationID
	AND InvoiceId IN (SELECT InvoiceId FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Invoices
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_INSERT
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Invoices', 'NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_INSERT'
GO

--XEROBLUEHN_Invoices - STORED PROCEDURE
IF OBJECT_ID('NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_REFRESH', 'P') IS NOT NULL
DROP PROC NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_REFRESH
GO
CREATE PROCEDURE NEW_CLIENT1.uspUpsert_XEROBLUEHN_Invoices_REFRESH
     @OrganisationID AS int 
AS  
	BEGIN TRANSACTION;
	DELETE FROM dbo.NEW_CLIENT1_XEROBLUEHN_Invoices 
	WHERE OrganisationId = @OrganisationID
	AND InvoiceId IN (SELECT InvoiceId FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID);

	INSERT INTO dbo.NEW_CLIENT1_XEROBLUEHN_Invoices
	SELECT * FROM dbo.NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_REFRESH
	WHERE OrganisationId = @OrganisationID;

	COMMIT;
EXEC ETANI.uspInsert_LastRefreshDate 'NEW_CLIENT1', @OrganisationID, 'XEROBLUE', 'NEW_CLIENT1_XEROBLUEHN_Invoices', 'NEW_CLIENT1_XEROBLUEHN_InvoicesSTAGE_REFRESH'
GO