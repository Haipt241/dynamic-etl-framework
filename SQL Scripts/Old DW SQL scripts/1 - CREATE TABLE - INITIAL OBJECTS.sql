/**************************************************************************************
FILENAME: CREATE TABLE - INITIAL OBJECTS
DESCRIPTION: LIST OF SQL SCRIPT FOR CREATING OBJECTS REQUIRED BEFORE LOADING NEW INTEGRATION.
	REPLACE "NEW_CLIENT1" WITH CORRECT CLIENT ID.
HISTORY:
DATE					DESCRIPTION
2023-07-13				INTIAL VERSION
**************************************************************************************/

/* CREATE SCRIPT FOR ADF QUEUE */
CREATE TABLE [ADF_XEROInsertQueue] (
    [runId] nvarchar(255),
    [debugRunId] nvarchar(255),
    [runGroupId] nvarchar(255),
    [pipelineName] nvarchar(255),
    [parameters.ClientID] nvarchar(255),
    [parameters.OrganisationID] nvarchar(255),
    [parameters.dbname] nvarchar(255),
    [parameters.AccessToken] nvarchar(max),
    [parameters.SubDomain] nvarchar(255),
    [parameters.WorkspaceID] nvarchar(255),
    [parameters.AccountingFirm] nvarchar(255),
    [parameters.apiAccessToken] nvarchar(max),
    [parameters.apiRefreshToken] nvarchar(max),
    [parameters.apiXeroTenantID] nvarchar(255),
    [parameters.hostname] nvarchar(255),
    [parameters.environment] nvarchar(255),
    [invokedBy.invokedByType] nvarchar(255),
    [runStart] datetime,
    [runEnd] datetime,
    [durationInMs] bigint,
    [status] nvarchar(255),
    [message] nvarchar(255),
    [lastUpdated] datetime,
    [annotations] nvarchar(255),
    [isLatest] bit
) WITH (CLUSTERED INDEX (runId));

/* CREATE SCRIPT FOR ORGANISATION TABLE */
CREATE TABLE [dbo].[NEW_XEROBLUE_Organisations](
	[Name] [nvarchar](255) NULL,
	[OrganisationType] [nvarchar](255) NULL,
	[BaseCurrency] [nvarchar](255) NULL,
	[CountryCode] [nvarchar](255) NULL,
	[IsDemoCompany] [nvarchar](255) NULL,
	[OrganisationStatus] [nvarchar](255) NULL,
	[RegistrationNumber] [nvarchar](255) NULL,
	[TaxNumber] [nvarchar](255) NULL,
	[FinancialYearEndDay] [nvarchar](255) NULL,
	[FinancialYearEndMonth] [nvarchar](255) NULL,
	[OrganisationEntityType] [nvarchar](255) NULL,
	[Timezone] [nvarchar](255) NULL,
	[LineOfBusiness] [nvarchar](255) NULL,
	[CreatedDateUTC] [datetime] NULL,
	[UpdatedDateUTC] [datetime] NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL,
	[AccessToken] [nvarchar](4000) NULL,
	[RefreshToken] [nvarchar](4000) NULL,
	[XeroTenantId] [nvarchar](255) NULL,
	[InsertOnly] [int] NULL,
	[CurrentlyRunning] [int] NULL,
	[WorkspaceID] [nvarchar](255) NULL,
	[DatasetID] [nvarchar](255) NULL,
	[ReportID] [nvarchar](255) NULL
)WITH (CLUSTERED INDEX (ClientID, OrganisationID));


/* CREATE SCRIPT FOR LASTREFRESHDATE TABLE */
CREATE TABLE [dbo].[NEW_CLIENT1_XEROBLUE_LastRefreshDate](
    [Id] int,
	[TableName] [nvarchar](255) NULL,
	[ResultRowCount] [int] NULL,
	[LastRefreshUTCDate] [datetime] NULL,
	[ClientID] [nvarchar](255) NULL,
    [OrganisationID] [int] NULL
)WITH (CLUSTERED INDEX (OrganisationID));


/* CREATE SCRIPT FOR NEW CLIENT ID SCHEMA */
IF NOT EXISTS (select * from sys.schemas where name = N'NEW_CLIENT1')
	EXEC('CREATE SCHEMA NEW_CLIENT1');
GO