SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ins_upd_reason]
	@ClinicID smallint,
	@EHRCode varchar(50),
	@Description varchar(255)
AS
BEGIN
	UPDATE RulesReasons
	SET
		Description = @Description
	WHERE ClinicID = @ClinicID AND EHRCode = @EHRCode

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO RulesReasons (ClinicID, EHRCode, Description)
		VALUES (@ClinicID, @EHRCode, @Description)
	END
END
GO
