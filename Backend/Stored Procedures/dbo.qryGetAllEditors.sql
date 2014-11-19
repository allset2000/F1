
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/28/2014
-- Description: SP used to get all Editors to dispaly on the Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[qryGetAllEditors]  AS 
BEGIN
	
	SELECT EditorID,EditorPwd,JobCount,JobMax,JobStat,AutoDownload,Managed,ManagedBy,ClinicID,EnableAudit,SignOff1,SignOff2,SignOff3,RoleID,FirstName,LastName,MI,Type,IdleTime,EditorIdOk,EditorCompanyId,EditorQAIDMatch,EditorEMail,C.CompanyName from Editors E inner join Companies C on C.CompanyId = E.EditorCompanyId
	
END


GO
