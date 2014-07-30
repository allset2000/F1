SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jennifer Blumenthal
Create date:	4/5/13
Description:	Retrieves turnaround summary data with or without excluded
				providers and clinics, and showing STAT jobs only or all jobs
				for report "Summary Turnaround Time - Master.rdl"

change log:
date		username		description
======================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_TurnaroundTime_Summary_Master]
--declare
	@BeginDate datetime, 
	@EndDate datetime,
	@Exclude int,
	@Stat varchar(5)
	
--set @begindate = '2013-04-01'
--set @enddate = 	'2013-04-03'
--set @exclude = 1
--set @stat = 1 --1 = stat jobs only; 2 = all jobs

AS
BEGIN

	--declare internal parameters
	declare	@Clinic varchar(max),
			@Dictator varchar(max)

	--define parameters
	if @Exclude = 1
		begin
			set @Clinic = 'CMA, CMC, CCV, ETMG, MOG, MWR, PAN, OAP, AAL, BMC, SMOC, TOG'
			set @Dictator = 'bnjclooney, bnjmmcnamara, nwpmgordon'
		end
	else
		begin
			set @Clinic = 'ZZZ'
			set @Dictator = 'none'	
		end
		
	if @Stat = 2
		begin
			set @Stat = '1, 0' --if user picked 'show all jobs' then we need to see both stat values
		end		
		
	--create temp tables to hold parsed parameter values
	if object_id('tempdb..#clinics') is not null drop table #Clinics
	if object_id('tempdb..#dictators') is not null drop table #Dictators
	if object_id('tempdb..#stat') is not null drop table #Stat
		
	create table #clinics (ClinicCode varchar(15))
	create table #dictators (DictatorID varchar(35))
	create table #stat (Stat bit)

	--populate temp tables with parsed parameter values
	insert into #clinics (ClinicCode)	select ltrim(id) from dbo.ParamParserFn(@Clinic,',')
	insert into #dictators (DictatorID) select ltrim(id) from dbo.ParamParserFn(@Dictator,',')
	insert into #stat (Stat)			select ltrim(id) from dbo.ParamParserFn(@stat, ',')

	--select * from #clinics
	--select * from #dictators
	--select * from #stat

	SET NOCOUNT ON

	--get data
	SELECT  C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
         J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		 J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  and (C.ClinicCode not in (select ClinicCode from #clinics))
	  and (D.DictatorID not in (select DictatorID from #dictators))
	  and (J.Stat in (select Stat from #stat))
	GROUP BY C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 C.ClinicName
		
END
GO
