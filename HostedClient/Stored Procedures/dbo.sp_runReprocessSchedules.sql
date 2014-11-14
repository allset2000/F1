SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/13/2014
-- Description: SP used to reprocess schedule messages for a clinic
-- =============================================
CREATE PROCEDURE [dbo].[sp_runReprocessSchedules] (
	@ClinicId int,
	@MRN varchar(100),
	@LastName varchar(100),
	@FirstName varchar(100),
	@Provider varchar(100),
	@Location varchar(100),
	@Reason varchar(100),
	@ReprocessType int,
	@StartDate varchar(100),
	@EndDate varchar(100)
) AS 
BEGIN

	CREATE TABLE #tmp_data 
	(
		ScheduleID int,
		AppointmentID varchar(100),
		AppointmentDate datetime,
		MRN varchar(50),
		PatientFirstName varchar(100),
		PatientLastName varchar(100),
		PatientDOB datetime,
		ResourceName varchar(100),
		LocationID varchar(50),
		LocationName varchar(100),
		ReasonID varchar(50),
		ReasonName varchar(100),
		Status int,
		ChangedOn datetime
	)
	
	DECLARE @SQL_STRING varchar(1000)
	
	SET @SQL_STRING  = 'UPDATE dbo.Schedules SET Rowprocessed = ' + CAST(@ReprocessType as varchar(1)) + ' WHERE ClinicId = ' + CAST(@ClinicId as varchar(10)) 
	
	insert into #tmp_data
	EXEC sp_GetSchedulesForSearch @ClinicId, @MRN, @LastName, @FirstName, @Provider, @Location, @Reason, @StartDate, @EndDate

	UPDATE dbo.Schedules SET RowProcessed = @ReprocessType WHERE ScheduleID in (SELECT ScheduleID FROM #tmp_data)

	SELECT @@ROWCOUNT	
	DROP TABLE #tmp_data
			
END

GO
