
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/2/2015
-- Description: SP Used to get roles for a clinic
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAvailableClinicRoles] (
	@clinicid int,
	@applicationid int
) AS 
BEGIN

	IF (@clinicid < 0)
	BEGIN
		SELECT * FROM Roles R
			INNER JOIN RoleApplicationXref RAX on RAX.RoleId = R.RoleId
		WHERE RAX.ApplicationId = @applicationid and RAX.IsDeleted = 0
	END
	ELSE
	BEGIN
		SELECT * FROM Roles R
			INNER JOIN RoleApplicationXref RAX on RAX.RoleId = R.RoleId
		WHERE RAX.ApplicationId = @applicationid and R.ClinicId in (0, @clinicid) and RAX.IsDeleted = 0
	END

END

GO
