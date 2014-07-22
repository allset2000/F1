SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_location]
	@ClinicID smallint,
	@EHRCode varchar(50),
	@Description varchar(255)
AS
BEGIN
	UPDATE RulesLocations
	SET
		Description = @Description
	WHERE ClinicID = @ClinicID AND EHRCode = @EHRCode

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO RulesLocations (ClinicID, EHRCode, Description)
		VALUES (@ClinicID, @EHRCode, @Description)
	END
END
GO
