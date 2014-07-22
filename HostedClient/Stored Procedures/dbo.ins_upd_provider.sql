SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_provider]
	@ClinicID smallint,
	@EHRCode varchar(50),
	@Description varchar(255)
AS
BEGIN
	UPDATE RulesProviders
	SET
		Description = @Description
	WHERE ClinicID = @ClinicID AND EHRCode = @EHRCode

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO RulesProviders (ClinicID, EHRCode, Description)
		VALUES (@ClinicID, @EHRCode, @Description)
	END
END
GO
