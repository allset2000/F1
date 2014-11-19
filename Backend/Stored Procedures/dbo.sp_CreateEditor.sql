
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_CreateEditor]
(
	@vEditorID VARCHAR(50) = ''
	, @vEditorPwd VARCHAR(50) = ''
	, @iJobCount SMALLINT = -1
	, @iJobMax SMALLINT = -1
	, @JobStat SMALLINT = -1
	, @bAutoDownload BIT = ''
	, @bManaged BIT = ''
	, @cManagedBy NCHAR(10) = ''
	, @iClinicID SMALLINT
	, @bEnableAudit BIT
	, @vSignOff1 VARCHAR(50) = ''
	, @vSignOff2 VARCHAR(50) = ''
	, @vSignOff3 VARCHAR(50) = ''
	, @iRoleID SMALLINT = -1
	, @vFirstName VARCHAR(50) = ''
	, @vLastName VARCHAR(50) = ''
	, @vMI VARCHAR(50) = ''
	, @iType SMALLINT = -1
	, @iIdleTime SMALLINT = -1
	, @iEditorIdOk INT = -1
	, @iEditorCompanyId INT = -1
	, @vEditorQAIDMatch VARCHAR(50) = ''
	, @vEditorEMail VARCHAR(48) = ''
)
AS
BEGIN

IF EXISTS (select * from Editors where EditorId = @vEditorID)
BEGIN
	UPDATE [dbo].[Editors] SET
           [EditorPwd] = @vEditorPwd,
           [JobCount] = @iJobCount,
           [JobMax] = @iJobMax,
           [JobStat] = @JobStat,
           [AutoDownload] = @bAutoDownload,
           [Managed] = @bManaged,
           [ManagedBy] = @cManagedBy,
           [ClinicID] = @iClinicID,
           [EnableAudit] = @bEnableAudit,
           [SignOff1] = @vSignOff1,
           [SignOff2] = @vSignOff2,
           [SignOff3] = @vSignOff3,
           [RoleID] = @iRoleID,
           [FirstName] = @vFirstName,
           [LastName] = @vLastName,
           [MI] = @vMI,
           [Type] = @iType,
           [IdleTime] = @iIdleTime,
           [EditorIdOk] = @iEditorIdOk,
           [EditorCompanyId] = @iEditorCompanyId,
           [EditorQAIDMatch] = @vEditorQAIDMatch,
           [EditorEMail] = @vEditorEMail
	WHERE EditorId = @vEditorId
END
ELSE
BEGIN
	INSERT INTO [dbo].[Editors]
           ([EditorID]
           ,[EditorPwd]
           ,[JobCount]
           ,[JobMax]
           ,[JobStat]
           ,[AutoDownload]
           ,[Managed]
           ,[ManagedBy]
           ,[ClinicID]
           ,[EnableAudit]
           ,[SignOff1]
           ,[SignOff2]
           ,[SignOff3]
           ,[RoleID]
           ,[FirstName]
           ,[LastName]
           ,[MI]
           ,[Type]
           ,[IdleTime]
           ,[EditorIdOk]
           ,[EditorCompanyId]
           ,[EditorQAIDMatch]
           ,[EditorEMail])
     VALUES
           (@vEditorID
           ,@vEditorPwd
           ,@iJobCount
           ,@iJobMax
           ,@JobStat
           ,@bAutoDownload
           ,@bManaged
           ,@cManagedBy
           ,@iClinicID
           ,@bEnableAudit
           ,@vSignOff1
           ,@vSignOff2
           ,@vSignOff3
           ,@iRoleID
           ,@vFirstName
           ,@vLastName
           ,@vMI
           ,@iType
           ,@iIdleTime
           ,@iEditorIdOk
           ,@iEditorCompanyId
           ,@vEditorQAIDMatch
           ,@vEditorEMail)
END
END
GO
