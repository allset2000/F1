SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Narender
-- Create date: 05/26/2015
-- Description:	This stored procedure will return the jobs list based on search filter criteria
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobReportsSearchJobList] 
@JobReportSearchPreferenceId int,
@PageNo smallint,
@SortColumnFromGrid varchar(50)= null,
@SortTypeFromGrid   varchar(50)= null,
@PageSize smallint,
@TotalCount int output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

		-- declare variable to hold the saved preferences from preferences table
		Declare @DateField varchar(50) Declare @Range varchar(50) Declare @RangeOptionFromDate datetime Declare @RangeOptionToDate datetime  Declare @From datetime 
		Declare @To datetime Declare @JobType  varchar(50) Declare @JobStatus varchar(50) Declare @DictatorID varchar(50) Declare @MRN varchar(50) Declare @FirstName varchar(50) 
		Declare @LastName  varchar(50) Declare @DeviceGenerated bit Declare @CC	bit Declare @STAT bit Declare @SelectedColumns varchar(300) Declare @GroupBy varchar(50)
		Declare @ResultsPerPage smallint Declare @SortBy varchar(50) Declare @SortType varchar(20) Declare @ClinicID smallint Declare @IsSaved bit Declare @JobNumber varchar(20)
		Declare @DictatorFirstName varchar(20) Declare @DictatorLastName varchar(20)

		-- get the user selected search filter items
		EXEC	[dbo].[sp_GetPortalJobReportPreference] @preferenceId = @JobReportSearchPreferenceId, @DateField = @DateField OUTPUT, @Range = @Range OUTPUT, 
				@RangeOptionFromDate = @RangeOptionFromDate OUTPUT, @RangeOptionToDate = @RangeOptionToDate OUTPUT, @From = @From OUTPUT, @To = @To OUTPUT, 
				@JobType = @JobType OUTPUT, @JobStatus = @JobStatus OUTPUT, @DictatorID = @DictatorID OUTPUT, @MRN = @MRN OUTPUT, @FirstName = @FirstName OUTPUT, 
				@LastName = @LastName OUTPUT, @DeviceGenerated = @DeviceGenerated OUTPUT, @CC = @CC OUTPUT, @STAT = @STAT OUTPUT, @SelectedColumns = @SelectedColumns OUTPUT, 
				@GroupBy = @GroupBy OUTPUT, @ResultsPerPage = @ResultsPerPage OUTPUT, @SortBy = @SortBy OUTPUT, @SortType = @SortType OUTPUT, @ClinicID = @ClinicID OUTPUT,
				@IsSaved = @IsSaved OUTPUT, @JobNumber = @JobNumber OUTPUT, @DictatorFirstName = @DictatorFirstName OUTPUT, @DictatorLastName = @DictatorLastName OUTPUT

			
		IF(@SortColumnFromGrid <> 'null')
			begin
				set @SortBy = null;
				set  @SortType= null;
			end
		If(@IsSaved is NULL) 
			return -1 -- this condition is to make sure that we get a valid filter record, not to try to get a record which was deleted

	IF OBJECT_ID('tempdb..#SearchItems') IS NOT NULL
    DROP TABLE #Results

	CREATE TABLE #SearchItems (
	Jobnumber varchar(20) NULL, DictatorID varchar(50) NULL, JobType varchar(100) NULL, 
	IsGenericJob bit NULL, AppointmentDate smalldatetime NULL, CC bit null, Stat bit NULL, MRN varchar(50), 
	Patient varchar(120) NULL, FirstName varchar(50) NULL, LastName varchar(50) NULL, JobStatus varchar(120) NULL, InProcess Datetime null, AwaitingDelivery datetime NULL)

	INSERT INTO #SearchItems 
	SELECT J.JobNumber, J.DictatorID, J.JobType, J.IsGenericJob as DeviceGenerated,J.AppointmentDate,J.CC,J.Stat, JP.MRN, (JP.FirstName + ' '+ JP.LastName) AS Patient, 
	JP.FirstName, JP.LastName, js.JobStatus, JTI.StatusDate AS 'InProcess', jta.StatusDate AS 'AwaitingDelevery'
		FROM	dbo.Jobs J 
		INNER JOIN dbo.Jobs_Patients JP ON J.JobNumber = JP.JobNumber 
		INNER JOIN dbo.Dictators D ON J.DictatorID = D.DictatorID
			OUTER APPLY(SELECT JT.JobNumber,MAX(jt.StatusDate) StatusDate,jg.Id,JG.StatusGroup, @GroupBy as selectedGrpBy
			   FROM dbo.JobTracking JT  
			   INNER JOIN dbo.StatusCodes SC on JT.Status= SC.StatusID
			   INNER JOIN dbo.JobStatusGroup JG on JG.Id = SC.StatusGroupId  
			   WHERE JT.JobNumber=j.JobNumber AND jg.Id=1 and JT.StatusDate >= DATEADD(M,-3,getdate()) -- will  always get lessthan 3 months data..
			   GROUP BY jg.Id,jt.JobNumber,JG.StatusGroup) JTI
			OUTER APPLY(SELECT JT.JobNumber,MAX(jt.StatusDate) StatusDate,jg.Id,JG.StatusGroup
			   FROM dbo.JobTracking JT  
			   INNER JOIN dbo.StatusCodes SC on JT.Status= SC.StatusID
			   INNER JOIN dbo.JobStatusGroup JG on JG.Id = SC.StatusGroupId  
			   WHERE  JT.JobNumber=j.JobNumber AND jg.Id=4 and JT.StatusDate >= DATEADD(M,-3,getdate()) -- will  always get lessthan 3 months data..-- 4 is for status group for Awaiting Delivery
			   GROUP BY jg.Id,jt.JobNumber,JG.StatusGroup) JTA
			OUTER APPLY(SELECT case when JSA.StatusDate is null then (JG.StatusGroup + ': '+ CONVERT(varchar(75), JSB.StatusDate, 100)) 
				  ELSE (JG.StatusGroup + ': '+ CONVERT(varchar(75), JSA.StatusDate, 100)) end JobStatus, JG.StatusGroup,JG.Id 
			   FROM  dbo.JobStatusGroup JG 
			   LEFT outer JOIN dbo.JobStatusA JSA on JSA.JobNumber = J.JobNumber 
			   LEFT OUTER JOIN dbo.JobStatusB JSB on JSB.JobNumber = J.JobNumber
			   INNER JOIN dbo.StatusCodes SC on JSA.Status= SC.StatusID OR JSB.Status= SC.StatusID
			   WHERE JG.Id = SC.StatusGroupId ) JS
		WHERE 
			(@DateField is null or JTI.Id= @DateField) 
			and (@From is null or JTI.StatusDate  >= @From)
			and (@To is null or JTI.StatusDate  <= @To) 
			and (@RangeOptionFromDate is null or JTI.StatusDate  >= @RangeOptionFromDate) 
			and (@RangeOptionToDate is null or JTI.StatusDate  <= @RangeOptionToDate) 
			and (@JobType is null or J.JobType = @JobType) 
			and (@JobStatus is null or JS.Id = @JobStatus) 
			and (@DictatorID is null or J.DictatorID = @DictatorID) 
			and (@MRN is null or JP.MRN = @MRN) 
			and (@FirstName is null or JP.FirstName = @FirstName) 
			and (@LastName is null or JP.LastName = @LastName) 
			and (@DeviceGenerated is null or J.IsGenericJob = @DeviceGenerated) 
			and (@CC is null or J.CC = @CC) 
			and (@STAT is null or J.Stat = @STAT) 
			and (@ClinicID is null or J.ClinicID = @ClinicID)  
			and (@JobNumber is null or J.JobNumber = @JobNumber)  
			and (@DictatorFirstName is null or D.FirstName like '%'+@DictatorFirstName+'%')  
			and (@DictatorLastName is null or D.LastName like '%'+@DictatorLastName+'%')  
			and (J.ReceivedOn  >= DATEADD(M,-3,getdate())) --  >= DATEADD(M,-4,getdate()-- will  always get lessthan 3 months data..
	
          Select Jobnumber, DictatorID, JobType, IsGenericJob, AppointmentDate, CC, Stat, MRN, 
	      Patient, JobStatus, InProcess, AwaitingDelivery
		  from #SearchItems
		  Order by
		  CASE WHEN @SortTypeFromGrid = 'Ascending' THEN 
					CASE @SortColumnFromGrid 
					WHEN 'MRN'   THEN MRN 
					WHEN 'JobNumber' THEN JobNumber 
					WHEN 'JobStatus' THEN JobStatus 
					WHEN 'User' THEN DictatorID 
					WHEN 'JobType' THEN JobType 
					WHEN 'Patient' THEN FirstName 
					END
				END,
				CASE WHEN @SortTypeFromGrid = 'Descending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'MRN'   THEN MRN 
					WHEN 'JobNumber' THEN JobNumber 
					WHEN 'JobStatus' THEN JobStatus 
					WHEN 'User' THEN DictatorID 
					WHEN 'JobType' THEN JobType 
					WHEN 'Patient' THEN FirstName 
					END
				END DESC,
				CASE WHEN @SortTypeFromGrid = 'Ascending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'InProcess' THEN InProcess
					WHEN 'AppointmentDate' THEN AppointmentDate
					END
				END,
				CASE WHEN @SortTypeFromGrid = 'Descending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'InProcess' THEN InProcess
					WHEN 'AppointmentDate' THEN AppointmentDate
				END
				END DESC,
				CASE WHEN @SortTypeFromGrid = 'Ascending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'DeviceGenerated' THEN IsGenericJob
					END
				END,
				CASE WHEN @SortTypeFromGrid = 'Descending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'DeviceGenerated' THEN IsGenericJob
					END
				END DESC,
		    CASE WHEN @SortType = 'Ascending' THEN
			  CASE @SortBy 
				WHEN 'MRN'   THEN MRN 
				WHEN 'Job Number' THEN JobNumber 
				WHEN 'Job Status' THEN JobStatus 
				WHEN 'User' THEN DictatorID 
				WHEN 'Job Type' THEN JobType 
				WHEN 'Patient' THEN FirstName 
			  END
			END,
			CASE WHEN @SortType = 'Descending' THEN
			  CASE @SortBy 
				WHEN 'MRN'   THEN MRN 
				WHEN 'Job Number' THEN JobNumber 
				WHEN 'Job Status' THEN JobStatus 
				WHEN 'User' THEN DictatorID 
				WHEN 'Job Type' THEN JobType 
				WHEN 'Patient' THEN FirstName 
			  END
			END DESC,
			CASE WHEN @SortType = 'Ascending' THEN
			  CASE @SortBy 
				WHEN 'Device Generated'   THEN IsGenericJob
			  END
			END,
			CASE WHEN @SortType = 'Descending' THEN
			  CASE @SortBy 
				WHEN 'Device Generated'   THEN IsGenericJob
			  END
			END DESC,
			CASE WHEN @SortType = 'Ascending' THEN
			  CASE @SortBy 
				WHEN 'In Process' THEN InProcess--StatusDate -- JTI
				WHEN 'Appointment Date' THEN AppointmentDate
				WHEN 'Awaiting Delivery' THEN AwaitingDelivery --StatusDate -- JTA
			  END
			END,
			CASE WHEN @SortType = 'Descending' THEN
			  CASE @SortBy 
				WHEN 'In Process' THEN InProcess --StatusDate -- JTI
				WHEN 'Appointment Date' THEN AppointmentDate
				WHEN 'Awaiting Delivery' THEN AwaitingDelivery --StatusDate -- JTA
			  END
			END DESC
		  OFFSET (@PageNo - 1) * @PageSize ROWS
		  FETCH NEXT @PageSize ROWS ONLY

		-- execute same SQL to get the total count
		  Select @TotalCount = count(JobNumber)
		FROM #SearchItems

		DROP TABLE #SearchItems
       
END



GO


