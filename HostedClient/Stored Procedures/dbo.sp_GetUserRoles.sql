
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/4/2015
-- Description: SP Used to get user roles from the user edit page
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserRoles] (
	@userid int
) AS 
BEGIN

		SELECT R.* FROM UserRoleXref URX
			INNER JOIN Roles R on R.RoleId = URX.RoleId
		WHERE URX.UserId = @userid and URX.IsDeleted = 0

END

GO
