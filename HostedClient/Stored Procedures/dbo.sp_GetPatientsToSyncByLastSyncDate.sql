
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull patients to sync
--exec sp_GetPatientsToSyncByLastSyncDate 3489,'1/1/1753 12:00:00 AM'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientsToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN
		SET NOCOUNT ON;

		  DECLARE @GenericPatientID INT

		  SELECT @GenericPatientID=GenericPatientID FROM SystemSettings WITH(NOLOCK) WHERE ClinicID=350
   
			 SELECT DISTINCT p.PatientID AS ID, 
					CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
					p.MRN, 
					p.DOB, 
					p.FirstName, 
					p.LastName, 
					p.Suffix,
					p.Gender, 
					p.Address1+', '+p.City+', '+p.State+', '+p.Zip AS [Address],
					p.Phone1,
					p.PrimaryCareProviderID ,
					e.EncounterID
			FROM dbo.Patients  AS p WITH(NOLOCK)
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON p.PatientID = e.PatientID
				INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON e.EncounterID = j.EncounterID
				INNER JOIN dbo.Dictations AS d WITH(NOLOCK) ON d.JobID = j.JobID 
				INNER JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON d.QueueID = qu.QueueID 
				INNER JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID 
			WHERE qu.DictatorID = @DictatorId AND 
				  e.PatientID <>@GenericPatientID AND
				  d.[Status] IN (100, 200) AND 				
				  ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate-- AND
				 -- 
END
GO
