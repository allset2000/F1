
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile
--EXEC sp_GetJobsToSyncByLastSyncDate 3526,0,'2014-11-20 10:15:02.970'
--Modified :Raghu--3/12/2016  --> Status code 450 added 
--Modified :Raghu--4/7/2016  --> Uploaded Date field added  
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSyncByLastSyncDate](
	 @DictatorID INT,
	 @EncounterId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

		WITH CTE_Jobs AS
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
					A.UploadedDate
			FROM dbo.Dictations AS d WITH(NOLOCK)
				INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON d.JobID = j.JobID 
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
				INNER JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Jobs_Referring jr WITH(NOLOCK) ON jr.JobID=j.JobID	
				LEFT JOIN
				        (SELECT JT.JobID,max(JT.ChangeDate) as UploadedDate 
						   FROM [dbo].[JobsTracking] JT WITH(NOLOCK)
								INNER JOIN Jobs js on Js.JobID=JT.JobID						  
							 Where JT.[Status]=300 AND ISNULL(js.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
						     Group by JT.JobID
						 ) A on A.JobId=j.JobID
			WHERE qu.DictatorID=@DictatorID AND
				  @EncounterId=(CASE WHEN @EncounterId=0 THEN @EncounterId ELSE e.EncounterID END) AND 	       
				  d.[Status] IN (100, 200) AND 	
				  q.Deleted=0 AND
				   ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
		)

		SELECT  CTE.ID, CTE.DictationID, CTE.JobNumber, CTE.JobTypeID, CTE.[State],	 CTE.IsStat, 
		        CTE.QueueID, CTE.EncounterID,CTE.ReferringPhysicianID,		
				CASE WHEN [State] IN(300,350) THEN 1
					 WHEN [State]=100 THEN 6
					 WHEN [State]=360 THEN 7
					 WHEN [State]=390 THEN 8
					 WHEN [State]=500 THEN 9
					 WHEN [State]=450 THEN 5
					 WHEN [State]=400 THEN SC.StatusGroupId END  AS StatusGroupID,
					 UploadedDate					
		FROM CTE_Jobs AS CTE		
		 LEFT JOIN 
				( 
					 SELECT jc.FileName AS EHJobnumber, ISNULL(JSA.Status,JSB.Status) AS StatusCode   
					 FROM [Entrada].dbo.Jobs_Client JC  WITH(NOLOCK)
				     INNER JOIN CTE_Jobs cj WITH(NOLOCK) ON  cj.JobNumber=JC.FileName	
					 LEFT JOIN [Entrada].dbo.JobStatusA JSA WITH(NOLOCK) ON JSA.JobNumber=JC.JobNumber
					 LEFT JOIN [Entrada].dbo.JobStatusB JSB WITH(NOLOCK) ON JSB.JobNumber=JC.JobNumber
				
				) AS StatusData ON StatusData.EHJobnumber=CTE.JobNumber
        LEFT JOIN [Entrada].dbo.StatusCodes SC WITH(NOLOCK) ON SC.StatusID=StatusData.StatusCode		

				   
END




GO
