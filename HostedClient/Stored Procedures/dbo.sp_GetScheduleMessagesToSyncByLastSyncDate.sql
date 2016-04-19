
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 23/11/2015
-- Description: SP called from DictateAPI to pull Schedules to sync on mobile
-- =============================================
--exec sp_GetScheduleMessagesToSyncByLastSyncDate 1045,'11/20/2015 7:37:37 PM'
CREATE PROCEDURE [dbo].[sp_GetScheduleMessagesToSyncByLastSyncDate](
	@DictatorId INT,
    @LastSyncDate DATETIME
)
AS
BEGIN
  
  SET NOCOUNT ON;

	 SELECT  s.ScheduleID AS ID, 
			DATEDIFF(SECOND,{D '1970-01-01'}, s.AppointmentDate) AS AppointmentDate, --Unix Timestamp
			s.ReasonName,
			s.PatientID,
			e.EncounterID,
			s.ReasonName,
			s.ResourceID,
			s.[Status] AS AppointmentStatus 
     FROM dbo.Schedules s WITH(NOLOCK)
	 INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON S.ScheduleID = e.ScheduleID
	 INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON E.EncounterID = j.EncounterID 
	 INNER JOIN 
				( 
						SELECT j.JobID,J.EncounterID,0 AS Deleted,d.DictationID,NULL AS QueueID FROM 
						dbo.Jobs j WITH(NOLOCK)
						LEFT JOIN Dictations d WITH(NOLOCK) on d.JobID=j.JobID
						WHERE j.Status NOT IN(100,500)  
						AND (j.OwnerDictatorID=@DictatorId) 
									   
				UNION
						SELECT j.JobID,J.EncounterID,q.Deleted,d.DictationID,q.QueueID  FROM
						dbo.Jobs J WITH(NOLOCK)  
						INNER JOIN Dictations D  WITH(NOLOCK)  ON J.JobID=D.JobID
						INNER JOIN Queue_Users QU  WITH(NOLOCK)  ON QU.QueueID=D.QueueID
						INNER JOIN Queues q WITH(NOLOCK)  ON Q.QueueID=QU.QueueID
						WHERE  j.Status In(100,500) and QU.DictatorID=@DictatorId
				)A on A.JobID=j.JobID and a.EncounterID=e.EncounterID
	WHERE 		
		  ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate AND
		  e.ScheduleID IS NOT NULL
END


GO
