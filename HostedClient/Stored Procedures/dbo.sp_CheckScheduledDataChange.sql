SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_CheckScheduledDataChange]
	@ClinicID SMALLINT,
	@AppointmentID VARCHAR(100),
	@appointmentDate DATETIME,
	@EHREncounterID  VARCHAR(50),
	@LocationID VARCHAR(50),
	@ReasonID VARCHAR(50),
	@ResourceID VARCHAR(50),
	@Status SMALLINT,
	@MRN VARCHAR(36)
AS
BEGIN

DECLARE @result INT



		SELECT @result = CASE
					WHEN @AppointmentDate != S.AppointmentDate OR 
						 @EHREncounterID != S.EHREncounterID OR
						 @LocationID != S.LocationID OR 
						 @ReasonID != S.ReasonID OR 
						 @ResourceID != S.ResourceID OR 
						 @Status != S.[Status] OR 
						 @MRN != P.MRN
					THEN 1
					ELSE 0 
				END
		FROM Schedules AS S INNER JOIN Patients AS P ON S.patientID = P.PatientID
		WHERE S.AppointmentID = @AppointmentID AND 
			  S.ClinicID = @ClinicID
	
SELECT ISNULL(@result,1)

END














GO
