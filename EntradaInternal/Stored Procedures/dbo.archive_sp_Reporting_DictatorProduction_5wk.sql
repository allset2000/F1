SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jennifer Blumenthal
Create date:	4/2/13
Description:	Retrieves dictator production data
				for report "Dictator Production - All Clinics (5 wk).rdl"
				
				Copy the report 'Dictator Production - All Clinics (52 wk)' and change the following:
				1. Show only last 5 weeks. 
				2. Show 2 worksheets, 1 for each account manager. 
				3. Add a variance to the weekly average column filtering to show only anything that is -15% worse than the previous week. 
				(example report shows >= -15% worse than average, not previous week - emailed cindy)
				4. only show those in which the average number of jobs is greater than 25.


the old date code:
	--Set @Date = DATEADD(wk, DATEDIFF(wk, 0, CONVERT(VARCHAR ,DATEADD(wk, -5, GetDate()), 110)), 0)	--the beginning of the week (Monday), 5 weeks back from today
	--Set @CurWk = DATEADD(wk, DATEDIFF(wk, 0, CONVERT(VARCHAR ,GetDate(), 110)), 0)					--the beginning (Monday) of the current week


**ADD AVG_DENOM COLUMN AND MARK THE FIRST WEEK WITH A 1, THEN IN THE REPORT, USE THAT TO CALCULATE:  IF AVG_DENOM = 1 THEN SUM(JOB CT) - AVG / AVG.
				
change log:

date	username		description
======================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_DictatorProduction_5wk] 

AS
BEGIN

	DECLARE @Date datetime,		--Sunday 5 weeks ago
			@CurWk datetime,	--Sunday of the current partial week
			@LastWk datetime	--Sunday of the last completed week	
			
	Set @Date = convert(varchar(10), dateadd(wk, -5, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)		--the beginning of the week (Sunday), 5 weeks back from today
	Set @CurWk = convert(varchar(10), dateadd(dd, 1 - datepart(dw,getdate()), getdate()), 110)						--the beginning (Sunday) of the current partial week
	--Set @LastWk = convert(varchar(10), dateadd(wk, -1, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())), 110)	--the beginning (Sunday) of the last completed week
	

	--get most recent completed week data
	SELECT  AcctManagerName,
			ClinicName,
			Week_Commencing,
			Count(JobNumber) as NumJobs
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
	
END
GO
