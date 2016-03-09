
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile
--EXEC sp_GetJobsToSyncByLastSyncDate 2196,0,'2014-11-20 10:15:02.970'
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
					jr.ReferringID AS ReferringPhysicianID
			FROM dbo.Dictations AS d WITH(NOLOCK)
				INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON d.JobID = j.JobID 
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON j.EncounterID = e.EncounterID
				INNER JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Jobs_Referring jr WITH(NOLOCK) ON jr.JobID=j.JobID		
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
					 WHEN [State]=400 THEN SC.StatusGroupId END  AS StatusGroupID					
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
