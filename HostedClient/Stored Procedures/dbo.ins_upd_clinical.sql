
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jonathan Pobst
-- Create date: 4/9/2014
-- Description:	Inserts or updates a row in PatientClinicals
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_clinical]
	@ClinicID smallint,
	@MRN varchar(36),
	@Category varchar(60),
	@Data varchar(max),
	@EHRControlID varchar(100),
	@Status varchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PatientID int
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND MRN = @MRN

	-- If we can't find this patient, bail
	IF ISNULL (@PatientID, -1) = -1
	BEGIN
		RETURN
	END

	IF (@Status = 'INACTIVE')
	BEGIN
		DELETE FROM PatientClinicals WHERE EHRControlID = @EHRControlID AND	Category = @Category AND PatientID = @PatientID
	END
	ELSE
	BEGIN
		UPDATE PatientClinicals
		SET
			Data = @Data
		WHERE
			EHRControlID = @EHRControlID AND
			Category = @Category AND
			PatientID = @PatientID

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO PatientClinicals (PatientID, Category, Data, EHRControlID)
			VALUES (@PatientID, @Category, @Data, @EHRControlID)
		END
	END

END
GO
