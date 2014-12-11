
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/3/2014
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile

--Modified by: Mikayil Bayramov
--Modified Date: 12/10/2014
--Description: Moved the main select logic to the vw_GetEncountersToSync view.
--             The main select statment can be used by other sql objects. 
--             Therefore, to easy the maintenability, we will keep it separate.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetEncountersToSync] (
	 @DictatorId int,
	 @MaxFutureDays int
) AS 
BEGIN
	SELECT EncounterID, AppointmentDate, PatientID, ScheduleID
	FROM dbo.vw_GetEncountersToSync
	WHERE (Dictations_DictatorID = @DictatorId or Queue_Users_DictatorID = @DictatorId) AND 
	      (@MaxFutureDays IS NULL OR (DATEDIFF (D, GETDATE(), AppointmentDate) <= @MaxFutureDays))
END
GO
