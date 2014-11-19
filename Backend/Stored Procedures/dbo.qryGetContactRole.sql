SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/4/2014
-- Description: SP used to get the Contact Role for use in Admin console
-- =============================================
CREATE PROCEDURE [dbo].[qryGetContactRole](
	@ContactId varchar(50)
	)  AS 
BEGIN

	SELECT ContactRoleId, ContactId, RoleId, ClinicId, ClinicsFilter, DictatorsFilter, JobsFilter, RoleStatus from ContactRoles WHERE ContactId = @ContactId
	
END


GO
