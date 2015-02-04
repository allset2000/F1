SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/29/2015
-- Description: SP used to pull the role application permissions for a given role
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRoleApplicationPermissions] (
	 @RoleId int
) AS 
BEGIN

	SELECT RAX.ApplicationId
	FROM RoleApplicationXref RAX
		INNER JOIN Applications A on A.ApplicationId = RAX.ApplicationId
	WHERE RAX.RoleId = @RoleId and RAX.IsDeleted = 0

END


GO
