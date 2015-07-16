
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
--	Author: Sam Shoultz
--	Create date: 12/3/2014
--	Description: SP called from DictateAPI to pull Dictations to sync on mobile

--	Modified By: Mikayil Bayramov
--	Modification Date: 5/29/2015
--	Details: Performance improvement
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDictationsToSync] (
	 @DictatorId INT,
	 @MaxFutureDays INT
) AS 
BEGIN
	SELECT d.*
	FROM dbo.Dictations AS d INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID
							 INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID 
							 INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID
							 INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
	WHERE qu.DictatorID = @DictatorId AND 
		  DATEDIFF (D, GETDATE(), e.AppointmentDate) <= @MaxFutureDays AND
		  d.[Status] IN (100, 200)  AND 
		  q.Deleted = 0
END
GO
