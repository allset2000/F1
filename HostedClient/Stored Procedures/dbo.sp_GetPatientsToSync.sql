
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/7/2014
-- Description: SP called from DictateAPI to pull patients to sync
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientsToSync] (
	 @DictatorId int,
	 @MaxFutureDays int
) AS 
BEGIN
	CREATE TABLE #tmp_patientid
	(
		PatientId int
	)

	IF (@MaxFutureDays >= 0)
	BEGIN
		INSERT INTO #tmp_patientid
		SELECT DISTINCT P.PatientId
		FROM Dictations D
			INNER JOIN Jobs J on J.JobID = D.JobID 
			INNER JOIN Encounters E ON J.EncounterID = E.EncounterID
			INNER JOIN Patients P ON P.PatientID = E.PatientID
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE D.Status in (100,200)
				AND DATEDIFF (D, GETDATE (), E.AppointmentDate) <= @MaxFutureDays
				AND Q.Deleted = 0
				AND (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
	END
	ELSE
	BEGIN
		INSERT INTO #tmp_patientid
		SELECT DISTINCT P.PatientId
		FROM Dictations D
			INNER JOIN Jobs J on J.JobID = D.JobID 
			INNER JOIN Encounters E ON J.EncounterID = E.EncounterID
			INNER JOIN Patients P ON P.PatientID = E.PatientID
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE D.Status in (100,200)
				AND Q.Deleted = 0
				AND (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
	END

	SELECT  PatientID ,
			ClinicID ,
			MRN ,
			AlternateID ,
			FirstName ,
			MI ,
			LastName ,
			Suffix ,
			Gender ,
			Address1 ,
			Address2 ,
			City ,
			State ,
			Zip ,
			CASE WHEN ISDATE(dob) = 1 THEN convert(varchar(10),cast(dob as date),101) ELSE '01/01/1900' END as 'DOB',
			Phone1 ,
			Phone2 ,
			Fax1 ,
			Fax2 ,
			PrimaryCareProviderID
       FROM dbo.Patients 
	   WHERE PatientId in (select PatientId from #tmp_patientid)

	   DROP TABLE #tmp_patientid

END
GO
