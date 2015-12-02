SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 2/5/2014
-- Description: Temporary SP used to manually update EHREncounterID's in the schedule table
-- Part of Redmine ticket 3454
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3454_UpdateEHREncounterID]

@EHREncounterID varchar(50),
@ScheduleID bigint

AS 

Begin Tran

UPDATE schedules set EHREncounterID = @EHREncounterID,UpdatedDateInUTC=GETUTCDATE() where ScheduleID = @ScheduleID

Commit tran

GO
