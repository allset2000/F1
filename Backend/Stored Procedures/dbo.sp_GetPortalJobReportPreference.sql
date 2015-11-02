SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Narender
-- Create date: 05/25/2015
-- Description:	This stored procedure will return the serach filter
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPortalJobReportPreference] 
@preferenceId smallint,
@DateField varchar(50) output,
@Range varchar(50) output,
@RangeOptionFromDate varchar(20) output,
@RangeOptionToDate varchar(20) output,
@From datetime output,
@To datetime output,
@JobType  varchar(50) output,
@JobStatus varchar(50) output,
@DictatorID varchar(50) output,
@MRN varchar(50) output,
@FirstName varchar(50) output,
@LastName  varchar(50) output,
@DeviceGenerated bit output,
@CC	bit output,
@STAT bit output,
@SelectedColumns varchar(500) output,
@GroupBy varchar(50) output,
@ResultsPerPage smallint output,
@SortBy varchar(50) output,
@SortType varchar(20) output,
@ClinicID smallint output,
@IsSaved bit output,
@JobNumber varchar(20) output,
@DictatorFirstName varchar(20) output,
@DictatorLastName varchar(20) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @RangeFromDatetime datetime declare @RangeToDatetime datetime

    Select	@DateField = USP.DateField, @Range = USP.[Range],@From = USP.[From], @To = USP.[To], @JobType= USP.JobType, @JobStatus= USP.JobStatus,
			@DictatorID = USP.DictatorID, @MRN = USP.MRN, @FirstName = USP.FirstName, @LastName = USP.LastName, 
			@DeviceGenerated = USP.IsDeviceGenerated, @CC =  USP.CC, @STAT =  USP.STAT, @SelectedColumns = USP.SelectedColumns, @GroupBy = USP.GroupBy, @ResultsPerPage = USP.ResultsPerPage, @SortBy = USP.SortBy, @SortType = USP.SortType,
			@ClinicID = USP.ClinicID, @IsSaved= USP.IsSaved, @JobNumber = JobNumber, @DictatorFirstName = DictatorFirstName, @DictatorLastName = DictatorLastName from PortalJobReportPreferences USP 
		where USP.ID = @preferenceId
	
	 if(@Range is not null)
		SELECT 
		  @RangeFromDatetime = CASE (@Range)
			  WHEN '1' THEN DateAdd(hh,-6,GetDate()) -- Last 6 hours
			  WHEN '2' THEN DateAdd(hh,-12,GetDate()) -- Last 7-12 hours
			  WHEN '3' THEN DateAdd(hh,-18,GetDate()) -- Last 13-18 hours
			  WHEN '4' THEN DateAdd(hh,-24,GetDate()) -- Last 19-24 hours
			  WHEN '5' THEN DateAdd(D,0,GetDate()) --Today
			  WHEN '6' THEN DateAdd(D,-1,GetDate()) --Yesterday
			  WHEN '7' THEN DateAdd(D,-7,GetDate())  -- Last 7 days
			  WHEN '8' THEN DateAdd(D,-30, GetDate()) -- Last 30 days
			  WHEN '9' THEN DateAdd(D,-60, GetDate()) -- Last 60 days
			  WHEN '10' THEN DateAdd(D,-90,GetDate()) -- Last 90 days
			  WHEN '11' THEN DATEADD(day, DATEDIFF(day, 0, GetDate()) /7*7, 0) -- This Week
			  WHEN '12' THEN DATEADD(day, DATEDIFF(day, 6, GetDate()) /7*7, 0) -- Last Week
			  END,
		  @RangeToDatetime = CASE (@Range)
			  WHEN '1' THEN DateAdd(hh,0,GetDate()) -- Last 6 hours
			  WHEN '2' THEN DateAdd(hh,-7,GetDate())  -- Last 7-12 hours
			  WHEN '3' THEN DateAdd(hh,-13,GetDate()) -- Last 13-18 hours 
			  WHEN '4' THEN DateAdd(hh,-19,GetDate()) -- Last 19-24 hours 
			  WHEN '5' THEN DateAdd(D,0,GetDate()) --Today
			  WHEN '6' THEN DateAdd(D,-1,GetDate()) --Yesterday
			  WHEN '7' THEN DateAdd(D,0,GetDate()) -- Last 7 days
			  WHEN '8' THEN DateAdd(D,0,GetDate()) -- Last 30 days
			  WHEN '9' THEN DateAdd(D,0,GetDate()) -- Last 60 days
			  WHEN '10' THEN DateAdd(D,0,GetDate()) -- Last 90 days
			  WHEN '11' THEN CONVERT(datetime, DATEADD(day, DATEDIFF(day, 6, GetDate()-1) /7*7 + 7, 6)) -- This Week
			  WHEN '12' THEN DATEADD(day, DATEDIFF(day, 13, GetDate()) /7*7 + 7, 6) -- Last Week 
			  END
		from PortalJobReportPreferences USP where USP.ID = @preferenceId

		 IF(@Range > 4)
				BEGIN
					SELECT @RangeOptionFromDate = CONVERT(varchar, @RangeFromDatetime, 101)+' 00:00:00'
					SELECT @RangeOptionToDate = CONVERT(varchar, @RangeToDatetime, 101) +' 23:59:59'
				END
			  ELSE
				BEGIN
					SELECT @RangeOptionFromDate =  CONVERT(varchar, @RangeFromDatetime, 120)
					SELECT @RangeOptionToDate =  CONVERT(varchar, @RangeToDatetime, 120)
				END	
END

GO


