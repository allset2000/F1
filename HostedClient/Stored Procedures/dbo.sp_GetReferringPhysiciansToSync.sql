SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 12/10/2014
-- Description: SP called from DictateAPI to pull Referring Physicians to sync on mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferringPhysiciansToSync] (
	@DictatorId AS INT,
	@MaxFutureDays AS INT
)
AS
BEGIN
	SELECT jr.* 
	FROM Jobs_Referring AS jr INNER JOIN dbo.vw_GetJobsToSync AS gjts ON jr.JobID = gjts.JobID
	WHERE (gjts.Dictations_DictatorID = @DictatorId OR gjts.Queue_Users_DictatorID = @DictatorId) AND 
	      (@MaxFutureDays IS NULL OR (DATEDIFF (D, GETDATE(), gjts.AppointmentDate) <= @MaxFutureDays))
END



GO
