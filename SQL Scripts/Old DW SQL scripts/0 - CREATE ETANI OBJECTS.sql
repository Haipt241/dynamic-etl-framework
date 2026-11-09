/**************************************************************************************
FILENAME: CREATE TABLE - STAGE
DESCRIPTION: LIST OF SQL SCRIPT FOR CREATING ETANI OBJECTS.
HISTORY:
DATE					DESCRIPTION
2023-07-13				INTIAL VERSION
2023-07-23				CREATE STORED PROCEDURE FOR MERGING USERACCESSDETAILS TABLE
2023-08-01              CREATE STORED PROCEDURE FOR Granting USER ACCESS
2023-08-02              CREATE STORED PROCEDURE FOR Revoking USER ACCESS
**************************************************************************************/


/* CREATE ETANI SCHEMA */
IF NOT EXISTS (select * from sys.schemas where name = N'ETANI')
 EXEC('CREATE SCHEMA ETANI');
GO

/* CREATE ERROR LOG TABLE */
IF OBJECT_ID('ETANI.ErrorLog', 'U') IS NULL
CREATE TABLE [ETANI].[ErrorLog](
	[Id] [bigint] NOT NULL,
	[Datasource] [nvarchar](255) NULL,
	[PackageName] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[OrganisationID] [int] NULL,
	[TaskName][nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[ErrorMessage] [nvarchar](max) NULL
)WITH (CLUSTERED INDEX (Id))
GO

/* CREATE PRIORITY LOG TABLE */
IF OBJECT_ID('ETANI.ADFPriorityLoad', 'U') IS NULL
CREATE TABLE [ETANI].[ADFPriorityLoad](
    [Id] [int] NULL,
    [FirmCode] [nvarchar](255) NULL,
	[Datasource] [nvarchar](255) NULL,
	[ClientID] [nvarchar](255) NULL,
	[TriggerNumber] [int] NULL,
	[Priority] [int] NULL
)WITH (CLUSTERED INDEX (Id))
GO


/* CREATE STORED PROCEDURE FOR ERROR LOGGING */
IF OBJECT_ID('ETANI.uspInsert_Etani_ErrorLog', 'P') IS NOT NULL
	DROP PROC ETANI.uspInsert_Etani_ErrorLog
GO
CREATE PROCEDURE ETANI.uspInsert_Etani_ErrorLog
    @ClientID as nvarchar(255),
    @OrganisationID as int,
    @Datasource as nvarchar(255),
    @PackageName as nvarchar(255),
    @TaskName as nvarchar(255),
    @Message as nvarchar(max)
AS  
    BEGIN TRY
        DECLARE 
            @recordCount as bigint

		SELECT 
			@recordCount = COUNT(1) 
		FROM [ETANI].[ErrorLog]

		INSERT INTO [ETANI].[ErrorLog]
		SELECT
			@recordCount + 1,
			@Datasource,
			@PackageName,
			@ClientID,
			@OrganisationID,
			@TaskName,
			GETDATE(),
			@Message
    END TRY
    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState    
            )
    END CATCH
GO


/* CREATE STORED PROCEDURE FOR CREATING DELAY */
IF OBJECT_ID('ETANI.uspWait', 'P') IS NOT NULL
	DROP PROC ETANI.uspWait
GO
CREATE PROCEDURE ETANI.uspWait 
    @Seconds as int
AS
BEGIN
    DECLARE @BEGIN DATETIME
    DECLARE @END DATETIME 

    SET @BEGIN = GETDATE()
    SET @END = DATEADD("SECOND",@Seconds,@BEGIN)

    WHILE (@BEGIN<@END)
    BEGIN   
        SET @BEGIN=GETDATE()
    END
END
GO

/* CREATE STORED PROCEDURE FOR LOGGING LAST REFRESH DATE OF EACH TABLE */
IF OBJECT_ID('ETANI.uspInsert_LastRefreshDate', 'P') IS NOT NULL
	DROP PROC ETANI.uspInsert_LastRefreshDate
GO
CREATE PROCEDURE ETANI.uspInsert_LastRefreshDate
	@ClientID NVARCHAR(36)
	,@OrganisationID INT
	,@Datasource NVARCHAR(255)
	,@TableName NVARCHAR(255)
	,@STageTableName NVARCHAR(255)
AS  
	DECLARE
		@Script NVARCHAR(MAX) = ''
		,@LastRefreshUTCDate NVARCHAR(255) = CONVERT(NVARCHAR(255), GETDATE(), 121)
		,@LastRefreshDateTable NVARCHAR(255) = @ClientID+'_'+@Datasource+'_LastRefreshDate'
		,@strOrganisationID NVARCHAR(255) = CAST(@OrganisationID AS NVARCHAR(255))

	SET @Script = '
	DECLARE @PageTotalResultCount AS INT = 0, @RowCount AS INT

	SELECT @PageTotalResultCount = COUNT(1) FROM dbo.'+@STageTableName+' WHERE OrganisationID = '+@strOrganisationID+'

	SELECT @RowCount = COUNT(1)+1 FROM dbo.'+@LastRefreshDateTable+'

	IF EXISTS (SELECT 1 FROM dbo.'+@LastRefreshDateTable+' WHERE TableName = '''+@TableName+''' AND ClientID = '''+@ClientID+''' AND OrganisationID = '+@strOrganisationID+')
	BEGIN
	UPDATE dbo.'+@LastRefreshDateTable+' SET LastRefreshUTCDate = '''+@LastRefreshUTCDate+''', ResultRowCount = @PageTotalResultCount
	WHERE TableName = '''+@TableName+''' AND ClientID = '''+@ClientID+''' AND OrganisationID = '+@strOrganisationID+'
	END
	ELSE
	BEGIN
	INSERT INTO dbo.'+@LastRefreshDateTable+' (Id, TableName, ResultRowCount, LastRefreshUTCDate, ClientID, OrganisationID)
	VALUES (@RowCount, '''+@TableName+''', @PageTotalResultCount, '''+@LastRefreshUTCDate+''', '''+@ClientID+''', '+@strOrganisationID+')
	END'

	EXEC(@Script)
GO


/* CREATE UserAccessDetailsSTAGE TABLE */
IF OBJECT_ID('ETANI.UserAccessDetailsSTAGE', 'U') IS NULL
CREATE TABLE [ETANI].[UserAccessDetailsSTAGE]
(
	[FirmID] [bigint] NULL,
	[FirmCode] [nvarchar](255) NULL,
	[FirmName] [nvarchar](255) NULL,
	[FirmStatus] [bigint] NULL,
	[UserID] [bigint] NULL,
	[UserFirstName] [nvarchar](255) NULL,
	[UserLastName] [nvarchar](255) NULL,
	[UserStatus] [bigint] NULL,
	[UserAADUserName] [nvarchar](255) NULL,
	[UserCreatedAt] [datetime] NULL,
	[UserUpdatedAt] [datetime] NULL,
	[ClientID] [bigint] NULL,
	[ClientName] [nvarchar](255) NULL,
	[ClientStatus] [bigint] NULL,
	[ClientLegacyID] [nvarchar](255) NULL
)
WITH (DISTRIBUTION = ROUND_ROBIN,CLUSTERED COLUMNSTORE INDEX)
GO


/* CREATE UserAccessDetails TABLE */
IF OBJECT_ID('ETANI.UserAccessDetails', 'U') IS NULL
CREATE TABLE [ETANI].[UserAccessDetails]
(
	[FirmID] [bigint] NULL,
	[FirmCode] [nvarchar](255) NULL,
	[FirmName] [nvarchar](255) NULL,
	[FirmStatus] [bigint] NULL,
	[UserID] [bigint] NULL,
	[UserFirstName] [nvarchar](255) NULL,
	[UserLastName] [nvarchar](255) NULL,
	[UserStatus] [bigint] NULL,
	[UserAADUserName] [nvarchar](255) NULL,
	[UserCreatedAt] [datetime] NULL,
	[UserUpdatedAt] [datetime] NULL,
	[ClientID] [bigint] NULL,
	[ClientName] [nvarchar](255) NULL,
	[ClientStatus] [bigint] NULL,
	[ClientLegacyID] [nvarchar](255) NULL,
	[EtaniModifiedDate] [datetime] NULL,
	[SQLClientID] [nvarchar](255) NULL,
	[UserGrantStatus] [nvarchar](255) NULL,
	[OldAADUserName] [nvarchar](255) NULL
)
WITH (DISTRIBUTION = ROUND_ROBIN,CLUSTERED COLUMNSTORE INDEX)
GO



/* CREATE STORED PROCEDURE FOR MERGING RECORDS OF USERACCESSDETAILS TABLE */
IF OBJECT_ID('ETANI.uspMerge_UserAccessDetails', 'P') IS NOT NULL
	DROP PROC ETANI.uspMerge_UserAccessDetails
GO
CREATE PROCEDURE ETANI.uspMerge_UserAccessDetails
    @FirmCode as nvarchar(255)
AS  
    BEGIN TRY
        --For Inserts
        INSERT INTO ETANI.UserAccessDetails (
            FirmID,
            FirmCode,
            FirmName,
            FirmStatus,
            UserID,
            UserFirstName,
            UserLastName,
            UserStatus,
            UserAADUserName,
            UserCreatedAt,
            UserUpdatedAt,
            ClientID,
            ClientName,
            ClientStatus,
            ClientLegacyID,
            EtaniModifiedDate,
            SQLClientID,
            UserGrantStatus,
            OldAADUserName
        ) 
        SELECT
            src.FirmID,
            src.FirmCode,
            src.FirmName,
            src.FirmStatus,
            src.UserID,
            src.UserFirstName,
            src.UserLastName,
            src.UserStatus,
            src.UserAADUserName,
            src.UserCreatedAt,
            src.UserUpdatedAt,
            src.ClientID,
            src.ClientName,
            src.ClientStatus,
            src.ClientLegacyID,
            GETDATE(),
            src.FirmCode+'_CLIENT'+CAST(COALESCE(src.ClientLegacyID,src.ClientID)AS NVARCHAR(10)),
            'GRANT ACCESS',
            NULL
        FROM ETANI.UserAccessDetailsSTAGE src
        LEFT JOIN ETANI.UserAccessDetails trg
        ON
            trg.UserID = src.UserID
            AND trg.ClientID = src.ClientID
            AND trg.FirmID = src.FirmID
        WHERE
        trg.UserID IS NULL
        AND trg.ClientID IS NULL
        AND trg.FirmID IS NULL
        AND src.FirmCode = @FirmCode;

        -- For Updates
        UPDATE trg SET
            trg.FirmID = src.FirmID,
            trg.FirmCode = src.FirmCode,
            trg.FirmName = src.FirmName,
            trg.FirmStatus = src.FirmStatus,
            trg.UserID = src.UserID,
            trg.UserFirstName = src.UserFirstName,
            trg.UserLastName = src.UserLastName,
            trg.UserStatus = src.UserStatus,
            trg.UserAADUserName = src.UserAADUserName,
            trg.UserCreatedAt = src.UserCreatedAt,
            trg.UserUpdatedAt = src.UserUpdatedAt,
            trg.ClientID = src.ClientID,
            trg.ClientName = src.ClientName,
            trg.ClientStatus = src.ClientStatus,
            trg.ClientLegacyID = src.ClientLegacyID,
            trg.EtaniModifiedDate = CASE WHEN trg.EtaniModifiedDate <= COALESCE(src.UserUpdatedAt,src.UserCreatedAt) 
                THEN GETDATE() ELSE trg.EtaniModifiedDate END,
            trg.SQLClientID = CASE WHEN trg.EtaniModifiedDate <= COALESCE(src.UserUpdatedAt,src.UserCreatedAt) 
                THEN src.FirmCode+'_CLIENT'+CAST(COALESCE(src.ClientLegacyID,src.ClientID)AS NVARCHAR(10)) ELSE trg.SQLClientID END,
            trg.UserGrantStatus = CASE WHEN trg.EtaniModifiedDate <= COALESCE(src.UserUpdatedAt,src.UserCreatedAt)
                AND trg.UserAADUserName <> src.UserAADUserName THEN 'UPDATE ACCESS' ELSE 'NO UPDATE' END,
            trg.OldAADUserName = CASE WHEN trg.EtaniModifiedDate <= COALESCE(src.UserUpdatedAt,src.UserCreatedAt) 
                AND trg.UserAADUserName <> src.UserAADUserName THEN trg.UserAADUserName ELSE NULL END
        FROM ETANI.UserAccessDetails trg
        JOIN ETANI.UserAccessDetailsSTAGE src
        ON
            trg.UserID = src.UserID
            AND trg.ClientID = src.ClientID
            AND trg.FirmID = src.FirmID
        WHERE trg.FirmCode = @FirmCode
		AND (trg.UserGrantStatus NOT IN ('GRANT ACCESS')
		OR trg.UserGrantStatus IS NULL);

        -- For Deletes
        UPDATE trg SET
            trg.UserGrantStatus = 'REVOKE ACCESS',
            trg.OldAADUserName = NULL
        FROM ETANI.UserAccessDetails trg
        LEFT JOIN ETANI.UserAccessDetailsSTAGE src
        ON
            trg.UserID = src.UserID
            AND trg.ClientID = src.ClientID
            AND trg.FirmID = src.FirmID
        WHERE
        src.UserID IS NULL
        AND src.ClientID IS NULL
        AND src.FirmID IS NULL
        AND trg.FirmCode = @FirmCode
		AND (trg.UserGrantStatus NOT IN ('GRANT ACCESS','UPDATE ACCESS','NO UPDATE')
        OR trg.UserGrantStatus IS NULL);
    END TRY
    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState    
            )
    END CATCH
GO


/* CREATE STORED PROCEDURE FOR Granting USER ACCESS */
IF OBJECT_ID('ETANI.uspGrant_UserAccess', 'P') IS NOT NULL
	DROP PROC ETANI.uspGrant_UserAccess
GO
CREATE PROCEDURE ETANI.uspGrant_UserAccess
    @FirmCode as nvarchar(255),
    @UserAADUsername nvarchar(255)
AS 
    DECLARE
        @SQL nvarchar(max) = ''
        ,@ClientID nvarchar(255) = ''

    BEGIN TRY
        IF OBJECT_ID('tempdb..#ClientIDList','U') IS NOT NULL
            DROP TABLE #ClientIDList

        SELECT
            aad.SQLClientID AS ClientID, 
            'GRANT SELECT ON SCHEMA :: ['+aad.SQLClientID+'] TO ['+@UserAADUsername+'];' AS GrantSchema,
            'GRANT SELECT ON dbo.'+o.name+' TO ['+@UserAADUsername+'];' AS GrantTables
        INTO #ClientIDList
        FROM ETANI.UserAccessDetails aad
        JOIN sys.schemas s ON s.name = aad.SQLClientID
        LEFT JOIN sys.objects o ON o.name like aad.SQLClientID+'[_]%'
        WHERE UserGrantStatus IN ('GRANT ACCESS','UPDATE ACCESS')
        AND FirmCode = @FirmCode
        AND UserAADUserName = @UserAADUsername

        WHILE EXISTS (SELECT * FROM #ClientIDList)
        BEGIN
            SELECT DISTINCT TOP 1 @ClientID = ClientID FROM #ClientIDList;

            SELECT @SQL = GrantSchema FROM #ClientIDList WHERE ClientID = @ClientID;

            EXEC (@SQL)

            SELECT @SQL = STRING_AGG(CAST(GrantTables AS nvarchar(max)), CHAR(13) + CHAR(10))
            FROM #ClientIDList WHERE ClientID = @ClientID;

            EXEC (@SQL)

            DELETE FROM #ClientIDList WHERE ClientID = @ClientID;
        END

        SELECT @SQL = 'GRANT SELECT ON dbo.FOREIGNEXCHANGE_MASTER TO ['+@UserAADUsername+'];'

        EXEC (@SQL)

        IF OBJECT_ID('tempdb..#ClientIDList','U') IS NOT NULL
            DROP TABLE #ClientIDList
    END TRY
    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState    
            )
    END CATCH
GO


/* CREATE STORED PROCEDURE FOR Revoking USER ACCESS */
IF OBJECT_ID('ETANI.uspRevoke_UserAccess', 'P') IS NOT NULL
	DROP PROC ETANI.uspRevoke_UserAccess
GO
CREATE PROCEDURE ETANI.uspRevoke_UserAccess
    @FirmCode as nvarchar(255),
    @UserAADUsername nvarchar(255)
AS 
    DECLARE
        @SQL nvarchar(max) = ''
        ,@ClientID nvarchar(255) = ''

    BEGIN TRY
        IF OBJECT_ID('tempdb..#ClientIDList','U') IS NOT NULL
            DROP TABLE #ClientIDList

        SELECT
            aad.SQLClientID AS ClientID, 
            'REVOKE SELECT ON SCHEMA :: ['+aad.SQLClientID+'] TO ['+@UserAADUsername+'];' AS GrantSchema,
            'REVOKE SELECT ON dbo.'+o.name+' TO ['+@UserAADUsername+'];' AS GrantTables
        INTO #ClientIDList
        FROM ETANI.UserAccessDetails aad
        JOIN sys.schemas s ON s.name = aad.SQLClientID
        LEFT JOIN sys.objects o ON o.name like aad.SQLClientID+'[_]%'
        WHERE UserGrantStatus IN ('REVOKE ACCESS')
        AND FirmCode = @FirmCode
        AND UserAADUserName = @UserAADUsername

        WHILE EXISTS (SELECT * FROM #ClientIDList)
        BEGIN
            SELECT DISTINCT TOP 1 @ClientID = ClientID FROM #ClientIDList;

            SELECT @SQL = GrantSchema FROM #ClientIDList WHERE ClientID = @ClientID;

            EXEC (@SQL)

            SELECT @SQL = STRING_AGG(CAST(GrantTables AS nvarchar(max)), CHAR(13) + CHAR(10))
            FROM #ClientIDList WHERE ClientID = @ClientID;

            EXEC (@SQL)

            DELETE FROM #ClientIDList WHERE ClientID = @ClientID;
        END

        IF OBJECT_ID('tempdb..#ClientIDList','U') IS NOT NULL
            DROP TABLE #ClientIDList
    END TRY
    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        RAISERROR (
            @ErrorMessage,
            @ErrorSeverity,
            @ErrorState    
            )
    END CATCH
GO