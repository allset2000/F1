SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 19th Jan 2016
-- Description:	This SP updates the EncounterID in Schedules table
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateScheduleEncounter] 
@scheduleID varchar(20),
@encounterID varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Update Schedules set EHREncounterID = @encounterID where ScheduleID = @scheduleID
	
END
