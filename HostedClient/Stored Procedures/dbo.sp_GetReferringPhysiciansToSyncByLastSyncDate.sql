
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull Referring Physicians to sync
-- Modified:Raghu A--18/04/2016--Update proc for get completed jobs physicians
--EXEC [sp_GetReferringPhysiciansToSyncByLastSyncDate] 1045,'2015-11-24 01:17:53.370'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferringPhysiciansToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

  SET NOCOUNT ON;

		
		SELECT DISTINCT ReferringID AS ID, [State], FirstName, LastName, 
			   [Address], Phone1
		FROM(    
				SELECT rp.ReferringID ,
						CASE WHEN temp.Deleted = 1 THEN 500 ELSE 100 END AS [State],
						rp.FirstName,
						rp.LastName,						
						rp.Address1+', '+rp.City+', '+rp.State+', '+rp.Zip AS [Address],
						rp.Phone1
				FROM dbo.Jobs AS j WITH(NOLOCK)
					INNER JOIN dbo.Jobs_Referring AS jr WITH(NOLOCK) ON j.JobID = jr.JobID
					INNER JOIN dbo.ReferringPhysicians rp WITH(NOLOCK)  ON rp.ReferringID=jr.ReferringID 
					INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
					INNER JOIN
							(
							  -- get completed jobs list match with owner dictatorID
									SELECT j.JobID,J.EncounterID,0 AS Deleted
									FROM 
										dbo.Jobs j WITH(NOLOCK)
									 WHERE j.Status NOT IN(100,500)  
									   AND j.OwnerDictatorID=@DictatorId 
								UNION
								--get all jobs list match with dictation dictatorID
									 SELECT j.JobID,J.EncounterID,
										 CASE WHEN j.Status NOT IN(100,500) THEN 0 ELSE q.Deleted END AS Deleted
									 FROM
									  DBO.Jobs J WITH(NOLOCK) 
									 INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
									 INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
									 INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
									 WHERE  QU.DictatorID=@DictatorId
							) temp on temp.EncounterID=e.EncounterID and j.JobID=temp.JobID				
				WHERE ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			UNION ALL
			   		SELECT rp.ReferringID,
							CASE WHEN temp.Deleted = 1 THEN 500 ELSE 100 END AS [State],
							rp.FirstName,
							rp.LastName,
							rp.Address1+', '+rp.City+', '+rp.State+', '+rp.Zip AS [Address],
							rp.Phone1
					FROM dbo.Patients AS p WITH(NOLOCK)
						INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON p.PatientID = e.PatientID
						INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON e.EncounterID = j.EncounterID
						INNER JOIN dbo.ReferringPhysicians rp WITH(NOLOCK) ON rp.ReferringID=p.PrimaryCareProviderID 
						INNER JOIN 
						         (
							       -- get completed jobs list match with owner dictatorID
									SELECT j.JobID,J.EncounterID,0 AS Deleted
									FROM 
										dbo.Jobs j WITH(NOLOCK)
									 WHERE j.Status NOT IN(100,500)  
									   AND j.OwnerDictatorID=@DictatorId 
								UNION
								--get all jobs list match with dictation dictatorID
									 SELECT j.JobID,J.EncounterID,
										 CASE WHEN j.Status NOT IN(100,500) THEN 0 ELSE q.Deleted END AS Deleted
									 FROM
									  DBO.Jobs J WITH(NOLOCK) 
									 INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
									 INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
									 INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
									 WHERE  QU.DictatorID=@DictatorId
								) temp on temp.EncounterID=e.EncounterID and j.JobID=temp.JobID							
					WHERE p.PrimaryCareProviderID IS NOT NULL AND		
					      ISNULL(rp.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			)A
			 
	



END
GO
