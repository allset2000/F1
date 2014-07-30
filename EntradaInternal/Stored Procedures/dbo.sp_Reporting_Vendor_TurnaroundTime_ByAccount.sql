SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	12/17/13
Description:	Retrieves vendor turnaround time data by account
				for report "Vendor Turnaround Time by Account.rdl"
				
change log

date		username		description
12/17/13	jablumenthal	created
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Vendor_TurnaroundTime_ByAccount]
--declare
	@BeginDate datetime, 
	@EndDate datetime,
	@Exclude int,
	@Stat varchar(5),
	@VendorCode varchar(50)


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
	if object_id('tempdb..#vendors') is not null drop table #Vendors
	if object_id('tempdb..#clinics') is not null drop table #Clinics
	if object_id('tempdb..#dictators') is not null drop table #Dictators
	if object_id('tempdb..#stat') is not null drop table #Stat
		
	create table #vendors (vendor_code varchar(16))
	create table #clinics (ClinicCode varchar(15))
	create table #dictators (DictatorID varchar(35))
	create table #stat (Stat bit)

	--populate temp tables with parsed parameter values
	insert into #vendors (vendor_code)	select ltrim(id) from dbo.ParamParserFn(@VendorCode,',')
	insert into #clinics (ClinicCode)	select ltrim(id) from dbo.ParamParserFn(@Clinic,',')
	insert into #dictators (DictatorID) select ltrim(id) from dbo.ParamParserFn(@Dictator,',')
	insert into #stat (Stat)			select ltrim(id) from dbo.ParamParserFn(@stat, ',')


	--select data
	SELECT  V.CompanyName as VendorName,
			C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as Lines
			--SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		 J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Editors_Pay EP WITH (NOLOCK) ON
		 E.EditorID = EP.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	LEFT OUTER JOIN [Entrada].[dbo].DSGCompanies V WITH (NOLOCK) ON --Vendors
		 EP.PayType = V.CompanyCode
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND (V.CompanyCode in (select ltrim(rtrim(vendor_code)) from #vendors))
	  AND (C.ClinicCode not in (select ClinicCode from #clinics))
	  AND (D.DictatorID not in (select DictatorID from #dictators))
	  AND (J.Stat in (select Stat from #stat)) 
	GROUP BY V.CompanyName,
			 C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 V.CompanyName,
			 C.ClinicName
		
END

GO
