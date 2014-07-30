SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetJobsWithFilters]
	@UserInRole varchar(50),
	@ClinicName varchar(50),
	@DictatorID varchar(50)
AS
BEGIN
	SELECT Jobs.JobNumber, Jobs.JobType, Jobs.AppointmentDate, Jobs.DictationDate, Jobs_Patients.MRN, 
		   Jobs_Patients.AlternateID, Jobs_Patients.FirstName, Jobs_Patients.LastName, Clinics.ClinicName, 
		   Jobs.DictatorID, Jobs.EditorID 
	FROM  Jobs INNER JOIN Clinics ON Jobs.ClinicID = Clinics.ClinicID 
			   INNER JOIN Jobs_Patients ON Jobs.JobNumber = Jobs_Patients.JobNumber 
	WHERE  CASE
			WHEN @UserInRole = 'Clinic_Admin' THEN CASE WHEN Clinics.ClinicName = @ClinicName THEN 1 ELSE 0 END
			WHEN @UserInRole = 'Physician'	  THEN CASE WHEN Jobs.DictatorID = @DictatorID    THEN 1 ELSE 0 END
			/*WHEN @UserInRole = 'Editor' THEN 0*/
		   END = 1
END

GO
