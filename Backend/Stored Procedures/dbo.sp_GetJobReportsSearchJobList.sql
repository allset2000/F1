
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
		Declare @DateField varchar(50) Declare @Range varchar(50) Declare @RangeOptionFromDate varchar(20) Declare @RangeOptionToDate varchar(20)  Declare @From datetime 
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

			if @DateField is null 
				set @DateField=1 -- this condition is to get primary group status, is @DateField is null 

			if @DateField = 5 
				set @JobStatus=5 -- this condition is to sure jobs are available in JobDeliveryHistory, don't consider 360 status

	IF OBJECT_ID('tempdb..#SearchItems') IS NOT NULL
    DROP TABLE #SearchItems

	DECLARE @JobsToFilter TABLE(  JobNumber VARCHAR(20), StatusDate datetime, ClinicID int) 

	CREATE TABLE #SearchItems (
	Jobnumber varchar(20) NULL, DictatorID varchar(50) NULL, JobType varchar(100) NULL, 
	IsGenericJob bit NULL, AppointmentDate smalldatetime NULL, CC bit null, Stat bit NULL, MRN varchar(50), 
	Patient varchar(120) NULL, FirstName varchar(50) NULL, LastName varchar(50) NULL, JobStatus varchar(120) NULL, InProcess Datetime null, AwaitingDelivery datetime NULL)
	declare @dateRangeFrom varchar(20)
	declare @dateRangeTo varchar(20)
	IF(@From is null)
		begin
			SET @dateRangeFrom = @RangeOptionFromDate
			SET @dateRangeTo = @RangeOptionToDate
		end
	ELSE
		begin
			SET @dateRangeFrom =@From+' 00:00:00'
			SET @dateRangeTo = @To +' 23:59:59'
		end
	-- the below condition was added to fetch Jobs for "Delivered" status selected in DateField option
	IF(@DateField <>5)
		BEGIN
			INSERT INTO @JobsToFilter 
					SELECT JT.JobNumber, MIN(jt.StatusDate) StatusDate,j.ClinicID
						FROM dbo.JobTracking JT
							INNER JOIN dbo.StatusCodes SC on JT.Status= SC.StatusID
							INNER JOIN dbo.JobStatusGroup JG on JG.Id = SC.StatusGroupId
							INNER JOIN jobs j on j.jobnumber = jt.jobnumber 
						WHERE 
							(@JobType is null or J.JobType = @JobType) 
							and (@DictatorID is null or J.DictatorID = @DictatorID) 
							and (@DeviceGenerated is null or J.IsGenericJob = @DeviceGenerated) 
							and (@CC is null or J.CC = @CC) 
							and (@STAT is null or J.Stat = @STAT) 
							and (@JobNumber is null or J.JobNumber = @JobNumber) 
							and (J.ReceivedOn  >= DATEADD(M,-3,GETDATE()))
						GROUP BY jg.Id,JG.StatusGroup, JT.JobNumber,j.ClinicID 
						HAVING (@DateField is null or JG.Id= @DateField)
							and (@dateRangeFrom is null or (min(jt.StatusDate)  >= @dateRangeFrom))
							and (@dateRangeTo is null or (min(jt.StatusDate)  <= @dateRangeTo))
							and (J.ClinicID = @ClinicID)
		END
	ELSE IF( @DateField =5)
		BEGIN
			INSERT INTO @JobsToFilter 
					SELECT JT.JobNumber, MIN(JDH.DeliveredOn ) StatusDate,j.ClinicID
						FROM dbo.JobTracking JT
							INNER JOIN dbo.StatusCodes SC on JT.Status= SC.StatusID
							INNER JOIN dbo.JobStatusGroup JG on JG.Id = SC.StatusGroupId
							INNER JOIN JobDeliveryHistory JDH on JDH.JobNUmber = JT.JobNumber
							INNER JOIN jobs j on j.jobnumber = jt.jobnumber 
						WHERE    (@DateField is null or JG.Id= @DateField)
							and (@dateRangeFrom is null or JDH.DeliveredOn  >= @dateRangeFrom) 
                            and (@dateRangeTo is null or JDH.DeliveredOn  <= @dateRangeTo) 
                            and (@JobType is null or J.JobType = @JobType) 
							and (@DictatorID is null or J.DictatorID = @DictatorID) 
							and (@DeviceGenerated is null or J.IsGenericJob = @DeviceGenerated) 
							and (@CC is null or J.CC = @CC) 
							and (@STAT is null or J.Stat = @STAT) 
							and (@ClinicID is null or J.ClinicID = @ClinicID)  
							and (@JobNumber is null or J.JobNumber = @JobNumber) 
							and (J.ReceivedOn  >= DATEADD(M,-3,GETDATE()))
						GROUP BY jg.Id,JG.StatusGroup, JT.JobNumber,j.ClinicID  

		END

	INSERT INTO #SearchItems 
	SELECT J.JobNumber, J.DictatorID, J.JobType, J.IsGenericJob as DeviceGenerated,J.AppointmentDate,J.CC,J.Stat, JP.MRN, (ISNULL(JP.FirstName, '') + ' '+ ISNULL(JP.MI, '') +' '+ ISNULL(JP.LastName, '')) AS Patient, 
		 JP.FirstName, JP.LastName,
		 CASE WHEN JSB.id = 5 THEN 
				CASE WHEN JSB.DeliveredOn is null THEN 
					JTA.StatusGroup + ': '+ CONVERT(varchar(75), JTA.StatusDate, 100) 
				ELSE 
					JSB.DeliveredOn 
				END
		ELSE 
			JSB.JobStatus 
		END JobStatus,
		JH.StatusDate AS 'InProcess', 
		JTA.StatusDate AS 'AwaitingDelevery'
		FROM @JobsToFilter JH 
		INNER JOIN jobs j ON j.jobnumber = jH.jobnumber  and j.clinicId=JH.ClinicID
		INNER JOIN dbo.Jobs_Patients JP ON JH.JobNumber = JP.JobNumber 
		INNER JOIN dbo.Dictators D ON J.DictatorID = D.DictatorID
		OUTER APPLY(SELECT JT.JobNumber,MIN(jt.StatusDate) StatusDate,jg.Id,JG.StatusGroup
						FROM dbo.JobTracking JT  
						INNER JOIN dbo.StatusCodes SC on JT.Status= SC.StatusID
						INNER JOIN dbo.JobStatusGroup JG on JG.Id = SC.StatusGroupId  
						WHERE  JT.JobNumber=JH.JobNumber AND jg.Id=4 and JT.StatusDate >= DATEADD(M,-3,getdate()) -- will  always get lessthan 3 months data..-- 4 is for status group for Awaiting Delivery
						GROUP BY jg.Id,jt.JobNumber,JG.StatusGroup) JTA
		CROSS APPLY(SELECT TOP 1 JG.StatusGroup + ': '+ CONVERT(VARCHAR(75), MIN(JT.StatusDate), 100) JobStatus, JG.StatusGroup,JG.ID,JG.StatusGroup + ': '+ CONVERT(VARCHAR(75), MAX(JD.DeliveredOn), 100) DeliveredOn 
						FROM JobTracking JT 
						INNER JOIN dbo.StatusCodes SC ON JT.Status= SC.StatusID 
						INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
						LEFT OUTER JOIN JobDeliveryHistory JD ON JD.jobnumber=JT.jobnumber
						WHERE JT.jobnumber = JH.jobnumber and (jg.id in (1,2,3,4) or (@jobStatus =4 or @jobStatus is null or @jobStatus =5 and JH.JobNumber  in (SELECT jobnumber FROM JobDeliveryHistory WHERE jobnumber=JH.JobNumber )))
						GROUP BY JT.JobNumber,JG.StatusGroup,jg.id
						ORDER BY JG.ID DESC)  JSB
		WHERE	((@JobStatus is null or JSB.Id = @JobStatus) OR (JSB.DeliveredOn is null and JTA.id=@JobStatus))			
				and (@MRN is null or JP.MRN = @MRN) 
				and (@FirstName is null or JP.FirstName = @FirstName) 
				and (@LastName is null or JP.LastName = @LastName) 
				and (@DictatorFirstName is null or D.FirstName like '%'+@DictatorFirstName+'%')  
				and (@DictatorLastName is null or D.LastName like '%'+@DictatorLastName+'%')  

          SELECT Jobnumber, DictatorID, JobType, CASE WHEN IsGenericJob is not null and IsGenericJob=1 THEN 'Y' ELSE 'N' END DeviceGenerated,
		  AppointmentDate, CC, Stat, MRN, Patient, JobStatus, InProcess, AwaitingDelivery
		  FROM #SearchItems
		  ORDER BY
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
		  Select @TotalCount = COUNT(JobNumber)
		FROM #SearchItems

		DROP TABLE #SearchItems
       
END



GO
