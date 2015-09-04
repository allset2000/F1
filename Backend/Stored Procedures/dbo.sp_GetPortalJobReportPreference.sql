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
@RangeOptionFromDate datetime output,
@RangeOptionToDate datetime output,
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

    Select	@DateField = USP.DateField, @Range = USP.[Range],@From = USP.[From], @To = USP.[To], @JobType= USP.JobType, @JobStatus= USP.JobStatus,
			@DictatorID = USP.DictatorID, @MRN = USP.MRN, @FirstName = USP.FirstName, @LastName = USP.LastName, @DeviceGenerated = USP.IsDeviceGenerated, @CC = USP.CC,
			@STAT = USP.STAT, @SelectedColumns = USP.SelectedColumns, @GroupBy = USP.GroupBy, @ResultsPerPage = USP.ResultsPerPage, @SortBy = USP.SortBy, @SortType = USP.SortType,
			@ClinicID = USP.ClinicID, @IsSaved= USP.IsSaved, @JobNumber = JobNumber, @DictatorFirstName = DictatorFirstName, @DictatorLastName = DictatorLastName from PortalJobReportPreferences USP 
		where USP.ID = @preferenceId
	
	if(@Range is not null)
		SELECT 
		  @RangeOptionFromDate = CASE (USP.[Range])
			  WHEN '1' THEN DateAdd(hh,-6,GetDate()) 
			  WHEN '2' THEN DateAdd(hh,-12,GetDate()) 
			  WHEN '3' THEN DateAdd(hh,-18,GetDate()) 
			  WHEN '4' THEN DateAdd(hh,-24,GetDate()) 
			  WHEN '5' THEN DateAdd(hh,-24,GetDate()) 
			  WHEN '6' THEN DateAdd(hh,-48,GetDate()) 
			  WHEN '7' THEN DateAdd(D,-7,GetDate()) 
			  WHEN '8' THEN DateAdd(D,-30,GetDate()) 
			  WHEN '9' THEN DateAdd(D,-60,GetDate()) 
			  WHEN '10' THEN DateAdd(D,-90,GetDate()) 
			  WHEN '11' THEN DateAdd(W,-1,GetDate()) 
			  WHEN '12' THEN DateAdd(W,-2,GetDate()) 
			  END,
		  @RangeOptionToDate = CASE (USP.[Range])
			  WHEN '1' THEN DateAdd(hh,0,GetDate()) 
			  WHEN '2' THEN DateAdd(hh,-7,GetDate()) 
			  WHEN '3' THEN DateAdd(hh,-13,GetDate()) 
			  WHEN '4' THEN DateAdd(hh,-19,GetDate()) 
			  WHEN '5' THEN DateAdd(hh,0,GetDate()) 
			  WHEN '6' THEN DateAdd(hh,-24,GetDate()) 
			  WHEN '7' THEN DateAdd(D,0,GetDate()) 
			  WHEN '8' THEN DateAdd(D,0,GetDate()) 
			  WHEN '9' THEN DateAdd(D,0,GetDate()) 
			  WHEN '10' THEN DateAdd(D,0,GetDate()) 
			  WHEN '11' THEN DateAdd(W,0,GetDate()) 
			  WHEN '12' THEN DateAdd(W,-1,GetDate()) 
			  END
		from PortalJobReportPreferences USP where USP.ID = @preferenceId
END

GO


