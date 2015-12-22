
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
--exec sp_GetEncountersToSyncByLastSyncDate 562 ,'2015-11-20 10:15:02.970'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetEncountersToSyncByLastSyncDate](
	 @DictatorId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN
     SET NOCOUNT ON;

	SELECT DISTINCT e.EncounterID AS ID, 
			 DATEDIFF(SECOND,{D '1970-01-01'}, e.AppointmentDate) AS AppointmentDate ,
			 e.PatientID, 
			 e.ScheduleID,
			 CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 STUFF((SELECT ', ' + CAST(JobID AS VARCHAR)
				  FROM   dbo.Jobs j2 
				  WHERE  j2.EncounterID = e.EncounterID                   
				  FOR XML PATH('')), 1, 2, '')  JobDetails
		FROM dbo.Encounters e
				INNER	JOIN dbo.Jobs j ON j.EncounterID=e.EncounterID
				INNER JOIN dbo.Dictations d ON d.JobID=j.JobID	
				INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
		WHERE qu.DictatorID = @DictatorId AND 	       
			  d.[Status] IN (100, 200) AND 			  
			  ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
END



GO

