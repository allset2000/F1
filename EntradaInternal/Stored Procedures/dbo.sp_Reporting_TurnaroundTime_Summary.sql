SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	1/27/2012
Description:	Retrieves turnaround summary data
				for report "Summary Turnaround Time.rdl"

change log:
date		username		description
3/26/13		jablumenthal	added ltrim & rtrim in where clause because	only the first item in 
							each parameter list was getting excluded. 
 
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary]
--declare
	@BeginDate datetime, 
	@EndDate datetime,
	@ExcludeClinics varchar(max),
	@excludeProviders varchar(max)

AS
BEGIN

--set 	@BeginDate = '2013-04-04'
--set 	@EndDate = '2013-04-04'
--set 	@ExcludeClinics = 'CMA, CMC, CCV'
--set 	@excludeProviders = 'bnjclooney, bnjmmcnamara'

create table #clinic_hold (clinic varchar(15))
create table #providers_hold (provider varchar(35))

insert into #clinic_hold select id from dbo.ParamParserFn(@ExcludeClinics,',')
insert into #providers_hold  select id from dbo.ParamParserFn(@excludeProviders,',')

SET NOCOUNT ON

SELECT  C.ClinicName as [Clinic],
		J.JobNumber as [Job Number],
		--D.LastName + ', ' + D.FirstName AS [Dictator],
		--E.LastName + ', ' + E.FirstName AS [Editor],
		--E.EditorID AS [Editor ID],
		J.ReceivedOn as [Received],
		J.CompletedOn as [Completed],
		DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
		COUNT(J2.JobNumber) AS OnTime,
		COUNT(J.JobNumber)  AS Total,
		SUM(JED.NumVBC_Job / 65.0) AS EntradaLines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
         J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		 J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	--LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
	--	 J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  and (C.ClinicCode not in (select ltrim(rtrim(clinic)) from #clinic_hold))
	  and (D.DictatorID not in (select ltrim(rtrim(provider)) from #providers_hold))
	  and (C.ClinicName != 'Entrada')
	GROUP BY C.ClinicName,
			 --E.EditorID,
			 --D.LastName + ', ' + D.FirstName,
			 --E.LastName + ', ' + E.FirstName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 C.ClinicName --,
			 --D.LastName + ', ' + D.FirstName,
			 --E.LastName + ', ' + E.FirstName
		
END

GO
