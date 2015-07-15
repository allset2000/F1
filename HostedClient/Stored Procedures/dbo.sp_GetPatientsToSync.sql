
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/7/2014
-- Description: SP called from DictateAPI to pull patients to sync

--	Modified By: Mikayil Bayramov
--	Modification Date: 5/29/2015
--	Details: Performance improvement.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientsToSync] (
	 @DictatorId INT,
	 @MaxFutureDays INT
) AS 
BEGIN
	SELECT DISTINCT p.PatientID, p.AlternateID, p.ClinicID, p.DOB, p.FirstName, p.MI, p.LastName, p.Suffix, p.PrimaryCareProviderID
	FROM dbo.Patients AS p INNER JOIN dbo.Encounters AS e ON p.PatientID = e.PatientID
						   INNER JOIN dbo.Jobs AS j ON e.EncounterID = j.EncounterID
						   INNER JOIN dbo.Dictations AS d ON d.JobID = j.JobID 
						   INNER JOIN dbo.Queue_Users AS qu ON d.QueueID = qu.QueueID
						   INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID 
		WHERE qu.DictatorID = @DictatorId AND 	       
			  d.[Status] IN (100, 200) AND 
			  q.Deleted = 0 AND 
			  DATEDIFF (D, GETDATE(), e.AppointmentDate) <= @MaxFutureDays 
END
GO
