SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Samuel Shoultz
-- Create date: 3/3/2015
-- Description: SP used to pull the list of roles and count of users attached to that role for dispaly in AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllClinicRoles]
	@ContentKey AS VARCHAR(50) = NULL
AS 
BEGIN
	SELECT Roles.*, (SELECT COUNT(*) FROM UserRoleXref WHERE Roles.RoleID = UserRoleXref.RoleID) AS UserCount FROM Roles WHERE ClinicId = 0 ORDER BY RoleName
END
GO
