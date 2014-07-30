SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Jen Blumenthal
Create date:	5/28/13
Description:	Pulls data for 'Dictator Production - All Clinics (5 wk)'

change log:
date		username		description
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorProduction_5wk]

as begin

DECLARE @Date datetime,		--Sunday 5 weeks ago
		@CurWk datetime,	--Sunday of the current partial week
		@LastWk datetime	--Sunday of the last completed week	
		
Set @Date = convert(varchar(10), dateadd(wk, -5, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)		--the beginning of the week (Sunday), 5 weeks back from today
Set @CurWk = convert(varchar(10), dateadd(dd, 1 - datepart(dw,getdate()), getdate()), 110)						--the beginning (Sunday) of the current partial week
--Set @LastWk = convert(varchar(10), dateadd(wk, -1, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)	--the beginning (Sunday) of the last completed week

if object_id ('tempdb..#temp') is not null drop table #temp

--get most recent completed week data
SELECT  AcctManagerName,
		ClinicName,
		Week_Commencing,
		Count(JobNumber) as NumJobs
into #temp
FROM (
		SELECT  CASE
					WHEN X.AcctManagerName IS NULL THEN 'Unknown'
					ELSE X.AcctManagerName
				END AS AcctManagerName,
				C.ClinicName as ClinicName,
				convert(datetime, Convert(varchar(10), DATEADD(dd, 1 - DATEPART(dw, ReceivedOn), ReceivedOn), 110)) as [Week_Commencing],
				JobNumber
		FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
		LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
			 J.ClinicID = C.ClinicID
		LEFT OUTER JOIN EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref X WITH (NOLOCK) ON
			 C.ClinicID = X.ClinicID
		WHERE convert(datetime, convert(varchar(10), J.ReceivedOn, 110)) >= @Date
		  AND convert(datetime, convert(varchar(10), J.ReceivedOn, 110)) < @CurWk --we don't want to include the current partial week in the report
      ) A
GROUP BY AcctManagerName, ClinicName, Week_Commencing
ORDER BY AcctManagerName, ClinicName, Week_Commencing

--calculate variance
select #temp.AcctManagerName, #temp.ClinicName, #temp.Week_Commencing, #temp.NumJobs, aggs.total_jobs, aggs.avg_jobs, aggs.variance_to_avg
from #temp 
join (select t1.ClinicName,
			 sum(NumJobs) as total_jobs,
			 avg(NumJobs) as avg_jobs,
			 -1 + 1.0 * (select top 1 NumJobs from #temp t2 where t2.ClinicName = t1.ClinicName order by t2.Week_Commencing desc)/avg(NumJobs) as variance_to_avg
	  from #temp t1
	  group by t1.ClinicName
	 ) aggs on #temp.ClinicName = aggs.ClinicName
where aggs.variance_to_avg <= -.15
  and aggs.avg_jobs >= 25
order by #temp.AcctManagerName, #temp.ClinicName, #temp.Week_Commencing desc


end
GO
