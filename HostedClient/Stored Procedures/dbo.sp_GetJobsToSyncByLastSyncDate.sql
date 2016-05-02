
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
--Modified:Raghu A--18/04/2016--Update proc for get completed jobs
-- EXEC sp_GetJobsToSyncByLastSyncDate_A 1045,0,'2014-11-20 10:15:02.970'
-- EXEC sp_GetJobsToSyncByLastSyncDate 1045,0,'2014-11-20 10:15:02.970'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSyncByLastSyncDate](
	 @DictatorID INT,
	 @EncounterId INT,
	 @LastSyncDate DATETIME,
	 @AppointmentDate DATETIME=NULL
) AS 
BEGIN
    
	   SET NOCOUNT ON;
	       
		
			 SELECT Distinct j.JobID AS ID,
					temp.DictationID,
					j.JobNumber,
					j.JobTypeID, 
					j.[Status] AS [State],			
					j.Stat AS IsStat,
					temp.QueueID,
					e.EncounterID,
					jr.ReferringID AS ReferringPhysicianID,
					a.UploadedDate AS UploadedDate,
					CASE WHEN J.[Status] IN(300,350) THEN 1					
					 WHEN J.[Status]=360 THEN 7
					 WHEN J.[Status]=390 THEN 8
					 WHEN J.[Status]=500 THEN 9
					 WHEN J.[Status]=450 THEN 5
					 WHEN J.[Status]=400 THEN ISNULL(SC.StatusGroupId,1)
					 ELSE  6
					 END  AS StatusGroupID,
					 j.OwnerDictatorID,
					 j.RhythmWorkFlowID
			FROM dbo.Encounters AS e WITH(NOLOCK)
				INNER JOIN Jobs j WITH(NOLOCK) on j.EncounterID=e.EncounterID 
				INNER JOIN 
						( 
						     -- get completed jobs list match with owner dictatorID
									SELECT j.JobID,J.EncounterID,0 AS Deleted,d.DictationID,d.QueueID AS QueueID
									FROM 
										dbo.Jobs j WITH(NOLOCK)
									 LEFT JOIN Dictations d  WITH(NOLOCK) on d.JobID=j.JobID
									 WHERE j.Status NOT IN(100,500)  
									   AND j.OwnerDictatorID=@DictatorId 
									   
								UNION
								--get all jobs list match with dictation dictatorID
									 SELECT j.JobID,J.EncounterID,
										 CASE WHEN j.Status NOT IN(100,500) THEN 0 ELSE q.Deleted END AS Deleted,
										 d.DictationID,
										 d.QueueID AS QueueID										 
									 FROM
									  DBO.Jobs J WITH(NOLOCK) 
									 INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
									 INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
									 INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
									 WHERE  QU.DictatorID=@DictatorId
								
							)temp on temp.EncounterID=e.EncounterID and j.JobID=temp.JobID
				LEFT JOIN
				        (SELECT JT.JobID,max(JT.ChangeDate) as UploadedDate 
						   FROM [dbo].[JobsTracking] JT WITH(NOLOCK)
								INNER JOIN Jobs js  WITH(NOLOCK) on Js.JobID=JT.JobID						  
							 Where JT.[Status]=300 AND ISNULL(js.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
						     Group by JT.JobID
						 ) A on A.JobId=j.JobID		
				LEFT JOIN dbo.Jobs_Referring jr WITH(NOLOCK) ON jr.JobID=temp.JobID
				LEFT JOIN [Entrada].dbo.StatusCodes SC WITH(NOLOCK) ON SC.StatusID=j.BackendStatus	
			WHERE
				  @EncounterId=(CASE WHEN @EncounterId=0 THEN @EncounterId ELSE e.EncounterID END) AND 
				  CAST(e.AppointmentDate AS DATE)=(CASE WHEN @AppointmentDate IS NOT NULL THEN  CAST(@AppointmentDate AS DATE)  ELSE CAST(e.AppointmentDate AS DATE) END) AND 
				  temp.Deleted=0 AND
				  ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate

		 		

	


				   
END







GO
