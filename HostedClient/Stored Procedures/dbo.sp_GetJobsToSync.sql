
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/7/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile

-- Modified by: Mikayil Bayramov
-- Modified Date: 12/10/2014
-- Description: Moved the main select logic to the vw_GetJobsToSync view.
--              The main select statment can be used by other sql objects. 
--              Therefore, to easy the maintenability, we will keep it separate.

--	Modified By: Mikayil Bayramov
--	Modification Date: 5/29/2015
--	Details: Performance improvement. Eliminating use of vw_GetJobsToSync view.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSync](
	 @DictatorId INT,
	 @MaxFutureDays INT
) AS 
BEGIN
	SELECT j.JobID, j.JobNumber, j.ClinicID, j.EncounterID, j.JobTypeID, j.OwnerDictatorID, j.[Status], j.Stat, j.[Priority], j.RuleID, j.AdditionalData 
	FROM dbo.Dictations AS d INNER JOIN dbo.Jobs AS j ON d.JobID = j.JobID 
						     INNER JOIN dbo.Encounters AS e ON j.EncounterID = e.EncounterID
						     INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID
						     INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
	WHERE qu.DictatorID = @DictatorId AND 	       
		  d.[Status] IN (100, 200) AND 
		  q.Deleted = 0 AND 
		  DATEDIFF (D, GETDATE(), e.AppointmentDate) <= @MaxFutureDays 
END
GO
