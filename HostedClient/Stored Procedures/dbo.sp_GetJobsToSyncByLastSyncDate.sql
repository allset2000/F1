
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile
-- Modified :Raghu--3/12/2016  --> Status code 450 added 
-- Modified :Raghu--4/7/2016  --> Uploaded Date field added  
-- Modified :Raghu--12/7/2016  --> RhythmWorkFlowID field added  
-- EXEC sp_GetJobsToSyncByLastSyncDate 2942,0,'2014-11-20 10:15:02.970'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSyncByLastSyncDate](
	 @DictatorID INT,
	 @EncounterId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

		SELECT ID, DictationID, JobNumber, JobTypeID, [State],	 IsStat, QueueID, 
		       EncounterID, ReferringPhysicianID, StatusGroupID, UploadedDate FROM
		   (
			 SELECT j.JobID AS ID,
					d.DictationID,
					j.JobNumber,
					j.JobTypeID, 
					j.[Status] AS [State],			
					j.Stat AS IsStat,
					q.QueueID,
					e.EncounterID,
					jr.ReferringID AS ReferringPhysicianID,
					NULL AS UploadedDate,
					6 AS StatusGroupId
			FROM dbo.Dictations AS d WITH(NOLOCK)
				INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON d.JobID = j.JobID 
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
				INNER JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Jobs_Referring jr WITH(NOLOCK) ON jr.JobID=j.JobID
			WHERE qu.DictatorID=@DictatorID AND
				  @EncounterId=(CASE WHEN @EncounterId=0 THEN @EncounterId ELSE e.EncounterID END) AND 	       
				  d.[Status] IN (100, 200,500) AND 	j.STATUS in(100,500) AND
				  q.Deleted=0 AND
				   ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate

		 UNION

		  SELECT j.JobID AS ID,
					d.DictationID,
					j.JobNumber,
					j.JobTypeID, 
					j.[Status] AS [State],			
					j.Stat AS IsStat,
					NULL AS QueueID,
					e.EncounterID,
					NULL AS ReferringPhysicianID,
					A.UploadedDate,
				   CASE WHEN J.[Status] IN(300,350) THEN 1					
					 WHEN J.[Status]=360 THEN 7
					 WHEN J.[Status]=390 THEN 8
					 WHEN J.[Status]=500 THEN 9
					 WHEN J.[Status]=450 THEN 5
					 WHEN J.[Status]=400 THEN ISNULL(SC.StatusGroupId,1) END  AS StatusGroupID
			FROM dbo.Jobs AS j WITH(NOLOCK)
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
				LEFT JOIN dbo.Dictations AS d WITH(NOLOCK)	 ON d.JobID = j.JobID 
				LEFT JOIN
				        (SELECT JT.JobID,max(JT.ChangeDate) as UploadedDate 
						   FROM [dbo].[JobsTracking] JT WITH(NOLOCK)
								INNER JOIN Jobs js on Js.JobID=JT.JobID						  
							 Where JT.[Status]=300 AND ISNULL(js.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
						     Group by JT.JobID
						 ) A on A.JobId=j.JobID				
            LEFT JOIN [Entrada].dbo.StatusCodes SC WITH(NOLOCK) ON SC.StatusID=j.BackendStatus	
			WHERE (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID) AND
				  @EncounterId=(CASE WHEN @EncounterId=0 THEN @EncounterId ELSE e.EncounterID END) AND 	       
				  J.STATUS Not In(100,500) AND ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate			

		) A


				   
END




GO
