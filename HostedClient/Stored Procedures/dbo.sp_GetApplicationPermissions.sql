SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/27/2015
-- Description: SP used to pull all permissions for the given module
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetApplicationPermissions] (
	 @ApplicationId int
) AS 
BEGIN

	SELECT  M.ModuleId,
			M.ModuleName,
			A.ApplicationId,
			A.Description as 'ApplicationDescription',
			P.PermissionId,
			P.Code,
			P.Name,
			P.ParentPermissionId
	FROM Applications A
		INNER JOIN Modules M on M.ApplicationId = A.ApplicationId
		INNER JOIN Permissions P on P.ModuleId = M.ModuleId
	WHERE A.ApplicationId = @ApplicationId and A.IsDeleted = 0 and M.IsDeleted = 0

END


GO
