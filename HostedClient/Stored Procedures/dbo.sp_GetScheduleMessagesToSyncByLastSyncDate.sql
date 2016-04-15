
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 23/11/2015
-- Description: SP called from DictateAPI to pull Schedules to sync on mobile
-- =============================================
--exec sp_GetScheduleMessagesToSyncByLastSyncDate 2196,'11/20/2015 7:37:37 PM',0
CREATE PROCEDURE [dbo].[sp_GetScheduleMessagesToSyncByLastSyncDate](
	@DictatorId INT,
    @LastSyncDate DATETIME
)
AS
BEGIN
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
	 LEFT JOIN dbo.Dictations D WITH(NOLOCK) ON D.JobID=J.JobID
	 LEFT JOIN Queue_Users qu WITH(NOLOCK) ON  qu.QueueID = d.QueueID 
	 LEFT JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID	
	WHERE ((j.Status in (100,500) AND qu.DictatorID = @DictatorId) OR (j.Status NOT IN(100,500) AND 
							  (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID)))  AND		
		  ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate AND
		  e.ScheduleID IS NOT NULL
END


GO
