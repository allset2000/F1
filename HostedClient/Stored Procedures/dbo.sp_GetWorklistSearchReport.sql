
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 01/27/2016
-- Description:	This SP will return WorkList for selected search filter
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWorklistSearchReport] 
@clinicID smallint,
@PageNo smallint,
@SortColumnFromGrid varchar(50)= null,
@SortTypeFromGrid   varchar(50)= null,
@PageSize smallint,
@QueueID varchar(50) = null,
@JobType varchar(100) = null,
@Status varchar(50) = null,
@From varchar(50) = null,
@To varchar(50)= null,
@MRN varchar(50) = null,
@FirstName varchar(100) = null,
@LastName varchar(100) = null,
@TotalCount int Output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	Declare @JobTypeID int

    IF OBJECT_ID('tempdb..#WorkListSearchItems') IS NOT NULL
		DROP TABLE #WorkListSearchItems
	
	select @JobTypeID = JobTypeID from JobTypes where Name = @JobType and clinicID = @clinicID

	CREATE TABLE #WorkListSearchItems (
			QueueName varchar(50) NULL,
			JobType varchar(100) NULL,
			Patient varchar(100),
			Appointment DateTime null,
			ChangedBy varchar(50) null,
			Status smallint null)


	INSERT INTO #WorkListSearchItems
		SELECT 
		Q.Name AS QueueName,
		JobTypes.Name AS JobType,
		(P.MRN + ' - ' + P.FirstName + ' ' + P.LastName) AS Patient,
		E.AppointmentDate AS Appointment,
		JT.ChangedBy AS ChangedBy,
		J.Status AS Status
			FROM Jobs J 
			INNER JOIN JobTypes ON J.JobTypeID = JobTypes.JobTypeID 
			INNER JOIN Encounters E ON J.EncounterID = E.EncounterID 
			INNER JOIN Patients P ON E.PatientID = P.PatientID 
			INNER JOIN Dictations D ON D.JobID = J.JobId 
			LEFT JOIN Queues Q ON D.QueueID = Q.QueueID 
			LEFT JOIN Dictators DI ON D.DictatorID = DI.DictatorID
			LEFT OUTER JOIN (Select JobID,Status,MAX(ChangeDate) AS MAX_ChangeDate,ChangedBy FROM JobsTracking GROUP BY JobID,Status,ChangedBy) JT 
						ON J.jobid = JT.jobID AND J.status = JT.status
			WHERE 
			(@ClinicID is null or J.ClinicID = @ClinicID)
			AND (CAST(@QueueID as int) is null or D.QueueID = CAST(@QueueID as int))
			AND (CAST(@JobType as BIGINT)  is null or J.JobTypeID = CAST(@JobType as BIGINT))
			AND (CAST(@Status as SMALLINT) is null or J.Status = CAST(@Status as SMALLINT)) 
			AND (J.Status IN(100,500))
			AND (CONVERT(DateTime, @from) is null or E.AppointmentDate >= CONVERT(DateTime, @from)) -- need to confirm whether to get less than 3 months data
			AND (CONVERT(DateTime, @to) is null or E.AppointmentDate <= CONVERT(DateTime, @to))
			AND (@MRN is null or P.MRN = @MRN)
			AND (@FirstName is null or P.FirstName LIKE '%' + @FirstName + '%')
			AND (@LastName is null or P.LastName LIKE '%' + @LastName + '%')

			
	SELECT QueueName,JobType,
	 Patient,Appointment,ChangedBy, 
		CASE WHEN Status is not null and Status = 100 THEN 'Available' ELSE 'Deleted' END Status FROM #WorkListSearchItems
	ORDER BY 
	CASE WHEN @SortTypeFromGrid = 'Ascending' THEN 
					CASE @SortColumnFromGrid
					WHEN 'Patient' THEN Patient
					WHEN 'JobType' THEN JobType
					WHEN 'Queue' THEN QueueName
					WHEN 'Appointment' THEN (CONVERT(varchar, Appointment)) 
					WHEN 'Status' THEN (CONVERT(varchar,Status))
					WHEN 'ChangedBy' THEN ChangedBy
					END
				END,
				CASE WHEN @SortTypeFromGrid = 'Descending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'Patient' THEN Patient
					WHEN 'JobType' THEN JobType
					WHEN 'Queue' THEN QueueName
					WHEN 'Appointment' THEN (CONVERT(varchar, Appointment)) 
					WHEN 'Status' THEN (CONVERT(varchar,Status))
					WHEN 'ChangedBy' THEN ChangedBy
					END
				END DESC
		OFFSET (@PageNo - 1) * @PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
	
	SELECT @TotalCount = Count(QueueName) from #WorkListSearchItems

	DROP TABLE #WorkListSearchItems
    
END
GO
