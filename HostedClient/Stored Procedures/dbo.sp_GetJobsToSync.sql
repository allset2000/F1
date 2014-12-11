
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
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSync](
	 @DictatorId int,
	 @MaxFutureDays int
) AS 
BEGIN
	SELECT JobID, JobNumber, ClinicID, EncounterID, JobTypeID, OwnerDictatorID, [Status], Stat, Priority, RuleID, AdditionalData 
	FROM dbo.vw_GetJobsToSync
	WHERE (Dictations_DictatorID = @DictatorId OR Queue_Users_DictatorID = @DictatorId) AND 
	      (@MaxFutureDays IS NULL OR (DATEDIFF (D, GETDATE(), AppointmentDate) <= @MaxFutureDays))

END
GO
