SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/**********************************************************
Author:			Jen Blumenthal
Create date:	3/19/2013
Description:	created for Cindy Gulley.  Lines & jobs by account.
**********************************************************/
create PROCEDURE [dbo].[archive_sp_Reporting_AccountProduction]

	@BeginDate datetime, 
	@EndDate datetime,
	@ClinicCode varchar(max) 

AS
BEGIN


	--create temp table & populate with parsed report variable
	create table #clinics (clinic varchar(20))
	insert into #clinics select id from dbo.ParamParserFn(@cliniccode,',')


	--get data based using temp table & params
	SELECT  C.ClinicName AS [Clinic],
			J.JobNumber AS [Job],
			JED.NumChars_Editor AS [Chars],
		   (CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS [Lines]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		 J.JobNumber = JED.JobNumber
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND C.ClinicCode in (select ltrim(rtrim(clinic)) from #clinics)
	  --and C.ClinicCode = CASE @ClinicCode
			--			   WHEN '- All -' THEN C.ClinicCode
			--				ELSE @ClinicCode
			--			 END
	ORDER BY C.ClinicName

END

GO
