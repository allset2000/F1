SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves Huron Valley report data
--		for report "Huron Valley Site Report.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_HuronValley_Report] 

@BeginDate datetime,
@EndDate datetime

AS
BEGIN

	SELECT HVR.SiteName AS [Site],
			j.JobNumber as [Job Number],
			j.DictatorID as [Dictator ID],
			j.CompletedOn as [Date Completed],
			j.Stat,
			j.Duration,
			j.DocumentStatus as [Job Status],
			SUM(JED.[DocumentWSpaces_Job]) AS [Chars],
			SUM(JED.[DocumentWSpaces_Job] / 65.0) AS [Lines]
	  FROM [Entrada].[dbo].[Jobs] j
	  inner join [Entrada].[dbo].[Jobs_Custom] jc ON
		j.JobNumber = jc.JobNumber
	  LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData2 JED ON
		j.JobNumber = JED.JobNumber
	  LEFT OUTER JOIN [Entrada].[dbo].HVRSite HVR ON
		jc.Custom2 = CASE SUBSTRING(jc.Custom2, 1, 1)
						WHEN 'X' THEN jc.Custom2
						ELSE HVR.SiteID
					END 
		AND
		HVR.SiteID LIKE CASE SUBSTRING(jc.Custom2, 1, 1)
							WHEN 'X' THEN 'X%'
							ELSE HVR.SiteID
						END
	  where ClinicID = 45 
		and j.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	GROUP BY HVR.SiteName,
			DictatorID,
			j.CompletedOn,
			j.Stat,
			j.Duration,
			j.DocumentStatus,
			JED.[DocumentWSpaces_Job],			
			j.JobNumber,
			jc.Custom2
	order by SiteName,
			DictatorID
	
END

GO
