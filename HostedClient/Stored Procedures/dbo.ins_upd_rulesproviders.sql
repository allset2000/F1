SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/11/2015
-- Description:	SP is used to keep the RolesProviders table in sync when new schedule messages come in
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_rulesproviders]
	@ClinicID smallint,
	@ResourceID varchar(50),
	@ResourceName varchar(100)
AS
BEGIN

	IF EXISTS(SELECT 1 FROM RulesProviders where ClinicId = @ClinicId and EHRCode = @ResourceID)
	BEGIN
		UPDATE RulesProviders SET Description = @ResourceName where ClinicId = @ClinicId and EHRCode = @ResourceID
	END
	ELSE
	BEGIN
		INSERT INTO RulesProviders(ClinicId,EHRCode,Description)
		VALUES(@ClinicID, @ResourceID, @ResourceName)
	END

END
GO
