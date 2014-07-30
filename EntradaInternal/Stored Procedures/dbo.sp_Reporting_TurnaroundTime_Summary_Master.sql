SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Summary Turnaround Time - Master.rdl"
				
change log

date		username		description
4/12/13		jablumenthal	updated stored proc to use new tables.
7/5/13		jablumenthal	added the following clinic exclusions per
							Cindy Gulley request:  MWR, BMC, SMOC, MOG, PAN, SCO
							added the following dictator exclusions per
							Cindy Gulley request:  tcscpandiscio, tcsjschwender
7/8/13		jablumenthal	added VEZ to list of excluded clinics per Cindy Gulley request.
8/7/13		jablumenthal	per Cindy Gulley request, added the following dictator exclusions 
							in the SSRS report:  Anderson, Cook, Brashear, Goss, Haire,
							Melvin, Mills, Parr, Entrada Test for both AOA accounts.
							(Dictator IDs:  aoacanderson, aoajbrashear, aoajgoss, aoajhaire,
							aoarmills, aoarparr, aoatcook, aoawmelvin, aoaetest)
8/9/13		jablumenthal	per Sue Fleming requested, added the following dictator exclusions
							in the SSRS report:  aoadmullins,aoadmullins5,aoaghommel,aoaghommel2,
							aoajphillips,aoajphillips27,ahcajacob,ahcbschwartz,ahcjfinkelstein,
							ahcjgladden,ahcjvarma,ahcsdodla,ahctho
8/26/13		jablumenthal	per Cindy Gulley request, added the following site exclusions: 
							Neurosurgical Associates (NRS), Twin Cities Spine (TCS)
9/6/13		jablumenthal	added MOG back in per request from Sue Fleming.
10/18/13	jablumenthal	excluded SHO, SLO per Sue Fleming.
11/12/13	jablumenthal	exclude Carolina Regional (84/CRO) & NextGen (38/NSG) per Cindy Gulley.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary_Master]

	@BeginDate datetime, 
	@EndDate datetime,
	@Exclude int,
	@Stat varchar(5)
	

AS
BEGIN

	SET NOCOUNT ON

	--declare internal parameters
	declare	@Clinic varchar(max),
			@Dictator varchar(max)

	--define parameters
	if @Exclude = 1
		begin
			set @Clinic = 'CMA, CMC, CCV, ETMG, MWR, PAN, OAP, AAL, BMC, SMOC, TOG, MWR, BMC, SMOC, MOG, PAN, SCO, VEZ, NRS, TCS, SLO, SHO, CRO, NSG'
			set @Dictator = 'bnjclooney, bnjmmcnamara, nwpmgordon, tcscpandiscio, tcsjschwender, aoacanderson, aoajbrashear'
			set @Dictator = @Dictator + ', aoajgoss, aoajhaire, aoarmills, aoarparr, aoatcook, aoawmelvin, aoaetest, aoadmullins'
			set @Dictator = @Dictator + ', aoadmullins5, aoaghommel, aoaghommel2, aoajphillips, aoajphillips27, ahcajacob, ahcbschwartz'
			set @Dictator = @Dictator + ', ahcjfinkelstein, ahcjgladden, ahcjvarma, ahcsdodla, ahctho'
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


	--get data
	SELECT  C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65) as Lines
			--SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	--JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
		  --J.JobNumber = JED.JobNumber
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
	  and (C.ClinicName != 'Entrada')
	GROUP BY C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 C.ClinicName
		
END
GO
