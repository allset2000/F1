SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/17/2015
-- Description: SP used to pull the users that have the specific application access passed in
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUsersByApplicationPermisssion] (
	 @ApplicationId int
) AS 
BEGIN

	SELECT * FROM Users where UserId IN (
	SELECT DISTINCT(U.UserID)
	FROM Users U
		INNER JOIN UserRoleXref URX on URX.UserId = U.UserId
		INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId
	WHERE RAX.ApplicationId = @ApplicationId and URX.IsDeleted = 0 and RAX.IsDeleted = 0
	)
	ORDER BY Name
END


GO
