
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
	 @DictatorID INT,
	 @EncounterId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

	 SELECT j.JobID AS ID,
			d.DictationID,
			j.JobNumber,
			j.JobTypeID, 
			j.[Status] AS [State],			
			j.Stat AS IsStat,
			q.QueueID,
			e.EncounterID		
	FROM dbo.Dictations AS d 
		INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID 
		INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID
		INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
		INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
	WHERE d.DictatorID=@DictatorID AND
		  @EncounterId=(CASE WHEN @EncounterId=0 THEN @EncounterId ELSE e.EncounterID END) AND 	       
		  d.[Status] IN (100, 200) AND 	
		  q.Deleted=0 AND
		   ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
END


GO
