
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull Referring Physicians to sync
--EXEC [sp_GetReferringPhysiciansToSyncByLastSyncDate] 2000,'2015-11-24 01:17:53.370'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferringPhysiciansToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

		SELECT DISTINCT ReferringID AS ID, [State], FirstName, LastName, 
			   [Address], Phone1
		FROM(    
				SELECT rp.ReferringID ,
						CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
						rp.FirstName,
						rp.LastName,						
						rp.Address1+', '+rp.City+', '+rp.State+', '+rp.Zip AS [Address],
						rp.Phone1
				FROM dbo.Dictations AS d 
					INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID 
					INNER JOIN dbo.Jobs_Referring AS jr ON j.JobID = jr.JobID
					INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID
					INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID
					INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
					INNER JOIN dbo.ReferringPhysicians rp ON rp.ReferringID=jr.ReferringID 
				WHERE qu.DictatorID = @DictatorId AND 	       
					  d.[Status] IN (100, 200) AND 		
					  ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			UNION 
			   		SELECT rp.ReferringID,
							CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
							rp.FirstName,
							rp.LastName,
							rp.Address1+', '+rp.City+', '+rp.State+', '+rp.Zip AS [Address],
							rp.Phone1
					FROM dbo.Patients AS p 
						INNER JOIN dbo.Encounters AS e ON p.PatientID = e.PatientID
						INNER JOIN dbo.Jobs AS j ON e.EncounterID = j.EncounterID
						INNER JOIN dbo.Dictations AS d ON d.JobID = j.JobID 
						INNER JOIN dbo.Queue_Users AS qu ON d.QueueID = qu.QueueID 
						INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID 
						INNER JOIN dbo.ReferringPhysicians rp ON rp.ReferringID=p.PrimaryCareProviderID 
					WHERE qu.DictatorID = @DictatorId AND 	       
					  d.[Status] IN (100, 200) AND 		
					  p.PrimaryCareProviderID IS NOT NULL AND		
					  ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			)A
			 
	



END
GO

