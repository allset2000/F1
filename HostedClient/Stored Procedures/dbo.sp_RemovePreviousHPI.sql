SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:	Sam Shoultz
-- Create date: 4/21/2015
-- Description:	Remove PreviousHPI records for clinical data for the given patient
-- =============================================
CREATE PROCEDURE [dbo].[sp_RemovePreviousHPI]
	@ClinicID smallint,
	@MRN varchar(36)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PatientID int
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND MRN = @MRN

	IF ISNULL (@PatientID, -1) = -1
	BEGIN
		RETURN
	END

	DELETE FROM PatientClinicals WHERE Category = 'PREVIOUSHPI' AND PatientID = @PatientID

END
GO
