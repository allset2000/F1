
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/1/2014
-- Description: SP used to Create/Update Contact Role records by the AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateContactRoles](
	@ContactRoleId int,
	@ContactId int,
	@RoleId int,
	@ClinicId int,
	@ClinicsFilter varchar(500),
	@DictatorsFilter varchar(500),
	@JobsFilter varchar(255),
	@RoleStatus char(1) 
)  AS 
BEGIN

	IF NOT EXISTS (SELECT * FROM ContactRoles where ContactRoleId = @ContactRoleId)
	BEGIN

		DECLARE @NewRoleId int
		-- Get new ContactRoleId and update DBRules table with new id
		UPDATE DbRules
		SET @NewRoleId = CurrentIdValue = CurrentIdValue + 1
		WHERE (SourceName = 'ContactRoles') AND (DbRuleType = 'I')

		-- Insert new record
		INSERT INTO ContactRoles(ContactRoleId, ContactId, RoleId, ClinicId, ClinicsFilter, DictatorsFilter, JobsFilter, RoleStatus) 
		VALUES (@NewRoleId, @ContactId, @RoleId, @ClinicId, @ClinicsFilter, @DictatorsFilter, @JobsFilter, @RoleStatus)
	END
	ELSE
	BEGIN
		-- Record already exists, update values
		UPDATE ContactRoles	SET RoleId = @RoleId,
								ClinicId = @ClinicId,
								ClinicsFilter = @ClinicsFilter,
								DictatorsFilter = @DictatorsFilter,
								JobsFilter = @JobsFilter,
								RoleStatus = @RoleStatus
		WHERE ContactRoleId = @ContactRoleId
	END	
END


GO
