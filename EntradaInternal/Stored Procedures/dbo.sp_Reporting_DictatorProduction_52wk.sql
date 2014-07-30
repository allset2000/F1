SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	1/27/2012
Description:	Retrieves dictator production data
				for report "Dictator Production - All Clinics (52 wk).rdl"
				
change log:

date	username		description
3/28/13	jablumenthal	Cindy Gulley requested to add the
						average of the most recent 12 weeks.
4/2/13	jablumenthal	the date filter was not correct.  It was 
						using the date 52 weeks back from TODAY.
						For example, today is Tuesday. It should 
						have been using the Monday at the beginning
						of 52 weeks ago.  I changed the @Date parameter
						to calculate the date as the Monday 52 
						weeks ago. 
4/9/13	jablumenthal	after a discussion with Cindy Gulley on the 
						dates, I learned that what the code is really
						doing is showing the date of Monday as the first
						day of the week, but is really starting the week
						on the Sunday before.  The weeks should run from 
						Sunday to Saturday per Cindy, so I updated the code
						below to reflect that.			
5/21/13	jablumenthal	per Rob Trumble request, removed the current partial week	
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorProduction_52wk] 

AS
BEGIN


	--create #temp
	if object_id('tempdb..#temp') is not null drop table #temp

	create table #temp (id int identity(1,1),
						ClinicName varchar(200),
						Week_Commencing datetime,
						NumJobs varchar(20),
						NumJobs_Qtr varchar(20),
						avg_denom int
						)
						
	--declare and set variables
	DECLARE @Date datetime,	--the beginning date of the report: 52 full weeks ago
			@Qtr datetime,	--the beginning date for the quarter: 12 full weeks ago
			@Cur datetime	--the beginning date for the current partial week

/*	--this code has been replaced with the date functions below to start the week on Sunday:

	--this is the beginning of the week (Monday), 52 weeks ago; it is used for the date range of the entire report: the current partial week plus the prior 52 weeks
	SET @Date = DATEADD(wk, DATEDIFF(wk, 0, CONVERT(VARCHAR ,DATEADD(wk, -52, GetDate()), 110)), 0) --CONVERT(VARCHAR ,DATEADD(wk, -52, GetDate()), 110) 
	--this is used to calculate the average of the most recent 12 weeks including the current partial week
	SET @Qtr = DATEADD(wk, DATEDIFF(wk, 0, CONVERT(VARCHAR ,DATEADD(wk, -12, GetDate()), 110)), 0) --CONVERT(VARCHAR, DATEADD(wk, -12, GetDate()), 110)  
*/

	--this is the beginning of the week (Sunday), 52 weeks ago; it is used for the date range of the entire report: the current partial week plus the prior 52 weeks
	SET @Date = convert(varchar(10), dateadd(wk, -52, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)
	--this is used to calculate the average of the most recent 12 weeks including the current partial week
	SET @Qtr = convert(varchar(10), dateadd(wk, -12, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)
	--current week
	SET @Cur = convert(varchar(10), dateadd(dd, 1 - datepart(dw, getdate()), getdate()), 110)
	
	
	--insert data into #temp
	insert into #temp(ClinicName, 
					  Week_Commencing, 
					  NumJobs, 
					  NumJobs_Qtr
					  )
	SELECT  C.ClinicName as ClinicName,
			convert(varchar(10), DATEADD(dd, 1 - DATEPART(dw, ReceivedOn), ReceivedOn), 110) as [Week Commencing],
			--DATEADD(wk, DATEDIFF(wk, 0, J.ReceivedOn), 0) as [Week_Commencing],  --replaced with the above line to start the week on Sunday
			JobNumber as NumJobs, 
			CASE
				WHEN DATEADD(dd, 1 - DATEPART(dw, ReceivedOn), ReceivedOn) >= @Qtr then JobNumber
				--WHEN (DATEADD(wk, DATEDIFF(wk, 0, J.ReceivedOn), 0)) >= @Qtr then JobNumber --1/4/13 --replaced with the above line to start the week on Sunday
				ELSE NULL
			END as NumJobs_Qtr  --only populate the JobNumber if it's within the last 12 weeks
	FROM [Entrada].[dbo].Jobs J WITH (NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH (NOLOCK) ON
		 J.ClinicID = C.ClinicID
	WHERE J.ReceivedOn >= @Date
	  AND J.ReceivedOn < @Cur
	ORDER BY C.ClinicName, DATEADD(dd, 1 - DATEPART(dw, ReceivedOn), ReceivedOn), J.JobNumber


	--update #temp with avg_denom, the sum of which will be the denominator for the 12-week average calculation in the report
	--set avg_denom to 1 for the minimum occurence of each ClinicName and Week so that it only gets counted once in the average
	UPDATE #temp
	SET avg_denom = 1
	FROM #temp a
	JOIN (SELECT ClinicName, Week_Commencing, MIN(id) AS id
		  FROM #temp
		  WHERE NumJobs_Qtr is not null 
		  GROUP BY ClinicName, Week_Commencing
		  ) b
	  ON  a.id = b.id


	--select the data for the report
	SELECT  ClinicName, 
			Week_Commencing,
			COUNT(NumJobs) AS NumJobs,
			COUNT(NumJobs_Qtr) AS NumJobs_Qtr,
			SUM(Avg_denom) AS avg_denom
	FROM #temp
	GROUP BY ClinicName, Week_Commencing
	ORDER BY ClinicName, Week_Commencing

end
GO
