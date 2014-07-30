SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves Jobs Edited per Day report data
--		for report "Jobs Edited Per Day - Line Emphasis (ENT).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_JobsEditedPerDay_ENT] 

@BeginDate datetime,
@EndDate datetime

AS
BEGIN

SELECT CONVERT(DATE, J.ReturnedOn, 101) AS [Returned Date], 
		C.ClinicName,
		J.JobType, 
		--JT.[Status],
		1 as [Jobs Returned],
		J.JobNumber as [Job ID],
		JED.NumVBC_Editor as [Chars],
		[Lines] = (CAST(COALESCE(JED.NumVBC_Editor, 0) AS DECIMAL(12,3)) / 65)
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	INNER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON 
		J.ClinicID = C.ClinicID
	INNER JOIN [Entrada].[dbo].Editors_Pay EP WITH(NOLOCK) ON
		J.EditorID = EP.EditorID
		AND (EP.PayType = 'ENT' or EP.PayType = 'Intern')
		--AND EP.PayEditorPayRoll = 'Y' --- Left out this line in case Begin & End dates pick up editors that are no longer employed (CA)
	left outer JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		J.JobNumber = JED.JobNumber
	INNER JOIN [Entrada].[dbo].DocumentStatus DS WITH(NOLOCK) ON
		J.DocumentStatus = DS.DocStatus
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	GROUP BY 
		CONVERT(DATE, J.ReturnedOn, 101), 
		C.ClinicName,
		J.JobType,
		JED.NumVBC_Editor,
		J.DocumentStatus,
		DS.[Description],
		J.JobNumber
	ORDER BY [Returned Date],
		C.ClinicName
	
END

GO
