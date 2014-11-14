SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/14/2014
-- Description: SP used to get an editor for AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_getEditorByID] (  
   @EditorID VARCHAR(50) = ''
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
      ,[EditorEMail],
      C.CompanyName
  FROM [dbo].[Editors] e
		INNER JOIN [dbo].Companies c on e.EditorCompanyId = c.CompanyId
  WHERE EditorID = @EditorID
END
GO
