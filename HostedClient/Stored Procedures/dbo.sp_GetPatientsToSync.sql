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
	IF (@MaxFutureDays >= 0)
	BEGIN
		SELECT DISTINCT P.*
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
		SELECT DISTINCT P.*
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
END
GO
