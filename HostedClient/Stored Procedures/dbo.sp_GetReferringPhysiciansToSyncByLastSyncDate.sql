
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
				FROM dbo.Jobs AS j WITH(NOLOCK)
					INNER JOIN dbo.Jobs_Referring AS jr WITH(NOLOCK) ON j.JobID = jr.JobID
					INNER JOIN dbo.ReferringPhysicians rp ON rp.ReferringID=jr.ReferringID 
					INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
					LEFT JOIN dbo.Dictations AS d WITH(NOLOCK) ON d.JobID = j.JobID 
					LEFT JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID
					LEFT JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID					
				WHERE ((j.Status in (100,500) AND qu.DictatorID = @DictatorId) OR (j.Status NOT IN(100,500) AND 
							  (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID)))  AND	
					  ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			UNION 
			   		SELECT rp.ReferringID,
							CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
							rp.FirstName,
							rp.LastName,
							rp.Address1+', '+rp.City+', '+rp.State+', '+rp.Zip AS [Address],
							rp.Phone1
					FROM dbo.Patients AS p WITH(NOLOCK)
						INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON p.PatientID = e.PatientID
						INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON e.EncounterID = j.EncounterID
						INNER JOIN dbo.ReferringPhysicians rp WITH(NOLOCK) ON rp.ReferringID=p.PrimaryCareProviderID 
						LEFT JOIN dbo.Dictations AS d WITH(NOLOCK) ON d.JobID = j.JobID 
						LEFT JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON d.QueueID = qu.QueueID 
						LEFT JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID 						
					WHERE ((j.Status in (100,500) AND qu.DictatorID = @DictatorId) OR (j.Status NOT IN(100,500) AND 
							  (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID)))  AND		
					  p.PrimaryCareProviderID IS NOT NULL AND		
					  ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			)A
			 
	



END
GO
