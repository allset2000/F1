SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 03/23/2015
-- Description: SP used to return if a clinic can use the patient image api call (dicatate api)
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateClinicPatientImage]
(
	@ClinicId INT
)
AS
BEGIN

	DECLARE @VendorAccess bit
	DECLARE @ClinicAccess bit
	DECLARE @Return bit

	SELECT @VendorAccess = PatientImagesEnabled, @ClinicAccess = C.DisablePatientImages FROM Clinics C INNER JOIN EHRVendors V on V.EHRVendorId = C.EHRVendorId WHERE ClinicId = @ClinicId

	IF @VendorAccess = 1
	BEGIN
		SET @Return = 1
		IF @ClinicAccess = 1
		BEGIN
			SET @Return = 0
		END
	END
	ELSE
	BEGIN
		SET @Return = 0
	END

	SELECT @Return

END


GO
