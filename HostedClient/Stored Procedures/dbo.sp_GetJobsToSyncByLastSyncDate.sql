
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile

-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSyncByLastSyncDate](
	 @EncounterId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

	 SELECT j.JobID AS ID, 
			j.JobNumber,
			j.JobTypeID, 
			j.[Status] AS [State],			
			j.Stat AS IsStat,
			q.QueueID		
	FROM dbo.Dictations AS d 
		INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID 
		INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID
		INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
		INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
	WHERE e.EncounterID = @EncounterId AND 	       
		  d.[Status] IN (100, 200) AND 	
		  q.Deleted=0 AND
		   ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
END


GO
