SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 12/10/2014
-- Description: SP called from DictateAPI to pull Schedules to sync on mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleMessagesToSync] (
	@DictatorId AS INT,
	@MaxFutureDays AS INT
)
AS
BEGIN
	SELECT s.* 
	FROM Schedules AS s INNER JOIN dbo.vw_GetEncountersToSync AS gets ON s.ScheduleID = gets.ScheduleID AND gets.ScheduleID IS NOT NULL
	WHERE (gets.Dictations_DictatorID = @DictatorId or gets.Queue_Users_DictatorID = @DictatorId) AND 
	      (@MaxFutureDays IS NULL OR (DATEDIFF (D, GETDATE(), gets.AppointmentDate) <= @MaxFutureDays))
END


GO
