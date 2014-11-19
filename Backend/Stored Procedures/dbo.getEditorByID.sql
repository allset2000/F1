SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[getEditorByID] (  
   @vEditorID VARCHAR(50) = ''
) 
AS  
BEGIN
   SELECT [EditorID]
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
      ,[EditorEMail]
  FROM [dbo].[Editors]
  WHERE EditorID = @vEditorID
END
GO
