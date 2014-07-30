SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "VR - Per Dictator Per Job Detail.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
7/5/13		jablumenthal	added the following clinic exclusions per
							Cindy Gulley request:
							MWR, BMC, SMOC, MOG, PAN, SCO
							added the following dictator exclusions per
							Cindy Gulley request:
							Pandiscio & Schwender (of TCS clinic)
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
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary_Original]

	@BeginDate datetime, 
	@EndDate datetime,
	@ExcludeClinics varchar(max),
	@excludeProviders varchar(max)

AS
BEGIN

create table #clinic_hold (clinic varchar(15))
create table #providers_hold (provider varchar(35))

insert into #clinic_hold select id from dbo.ParamParserFn(@ExcludeClinics,',')
insert into #providers_hold  select id from dbo.ParamParserFn(@excludeProviders,',')


SET NOCOUNT ON

	SELECT  C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			D.LastName + ', ' + D.FirstName AS [Dictator],
			E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as EntradaLines
			--SUM(JED.NumVBC_Job / 65.0) AS EntradaLines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	--INNER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
		--J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		J.JobNumber = J2.JobNumber
		AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	and (C.ClinicCode not in (select ltrim(rtrim(clinic)) from #clinic_hold))
	and (D.DictatorID not in (select ltrim(rtrim(provider)) from #providers_hold))
	and (C.ClinicName != 'Entrada')
	GROUP BY C.ClinicName,
			E.EditorID,
			D.LastName + ', ' + D.FirstName,
			E.LastName + ', ' + E.FirstName,
			J.ReceivedOn,
			J.CompletedOn,
			J.JobNumber
	ORDER BY [OnTime],
		C.ClinicName,
		D.LastName + ', ' + D.FirstName,
		E.LastName + ', ' + E.FirstName
		
END
GO
