
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
			--s.EHREncounterID AS EncounterID,
			s.ReasonName,
			s.ResourceID,
			s.[Status] AS AppointmentStatus ,
			e.EncounterID
     FROM dbo.Schedules s
	 INNER JOIN dbo.Encounters AS e ON S.ScheduleID = e.ScheduleID
	 INNER JOIN dbo.Jobs AS j ON E.EncounterID = j.EncounterID 
	 INNER JOIN dbo.Dictations D ON D.JobID=J.JobID
	 INNER JOIN Queue_Users qu ON  qu.QueueID = d.QueueID 
	 INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID	
	WHERE qu.DictatorID = @DictatorId AND 	          
		  d.[Status] IN (100, 200) AND 		
		  ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate AND
		  e.ScheduleID IS NOT NULL
END


GO
