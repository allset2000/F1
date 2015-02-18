SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/11/2015
-- Description:	SP is used to keep the RolesProviders table in sync when new schedule messages come in
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_rulesreasons]
	@ClinicID smallint,
	@ReasonID varchar(50),
	@ReasonName varchar(100),
	@type varchar(1)
AS
BEGIN

	IF EXISTS(SELECT 1 FROM RulesReasons where ClinicId = @ClinicId and EHRCode = @ReasonID and Type = @type)
	BEGIN
		UPDATE RulesReasons SET Description = @ReasonName where ClinicId = @ClinicId and EHRCode = @ReasonID and Type = @type
	END
	ELSE
	BEGIN
		INSERT INTO RulesReasons(ClinicId,EHRCode,Description,Type)
		VALUES(@ClinicID, @ReasonID, @ReasonName, @type)
	END

END
GO
