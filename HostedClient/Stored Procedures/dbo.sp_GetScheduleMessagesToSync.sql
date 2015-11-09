
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 12/10/2014
-- Description: SP called from DictateAPI to pull Schedules to sync on mobile

--	Modified By: Mikayil Bayramov
--	Modification Date: 5/29/2015
--	Details: Performance improvement. Eliminating use of vw_GetJobsToSync view
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleMessagesToSync](
	@DictatorId INT,
	@MaxFutureDays INT
)AS
BEGIN
	SELECT s.ScheduleID, s.AppointmentDate, s.ReasonName
	FROM dbo.Dictations AS d INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID 
							 INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID
							 INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID
							 INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
							 INNER JOIN dbo.Schedules AS s ON s.ScheduleID = e.ScheduleID 
	WHERE qu.DictatorID = @DictatorId AND 	       
		  d.[Status] IN (100, 200) AND 
		  q.Deleted = 0 AND 
		  DATEDIFF (D, GETDATE(), e.AppointmentDate) <= @MaxFutureDays AND 
		  e.ScheduleID IS NOT NULL
END


GO
