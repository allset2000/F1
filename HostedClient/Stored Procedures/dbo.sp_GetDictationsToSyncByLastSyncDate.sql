SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
--	Description: SP called from DictateAPI to pull Dictations to sync on mobile


-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDictationsToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN
	 
	 SET NOCOUNT ON;
	
	  SELECT d.DictationID
			,d.JobID
			,d.DictationTypeID
			,d.DictatorID
			,d.QueueID
			,d.Status
			,d.Duration
			,d.MachineName
			,d.FileName
			,d.ClientVersion
			,d.UpdatedDateInUTC
	FROM dbo.Dictations AS d 
	INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID
	INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID 
	INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID
	INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
	WHERE qu.DictatorID = @DictatorId AND 		
		  d.[Status] IN (100, 200)  AND 
		  q.Deleted = 0 AND
		   ISNULL(d.UpdatedDateInUTC,GETUTCDATE()) >@LastSyncDate

END
GO
