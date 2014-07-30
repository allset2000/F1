SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Daily Summary with Graphs.rdl"
				
change log

date		username		description
6/10/13		jablumenthal	replaced the internal code in the 
							report with this new stored proc
======================================================= */
create PROCEDURE [dbo].[sp_Reporting_DailySummaryWithGraphs_Dataset1]

	@TodayDate datetime
	
AS
BEGIN


SELECT  COUNT(JobNumber) AS TotalJobs, 
		SUM(CASE WHEN ReturnedOn IS NOT NULL THEN 1 ELSE 0 END) AS TotalEdited, 
		SUM(CASE WHEN CompletedOn IS NOT NULL THEN 1 ELSE 0 END) AS TotalCompleted, 
		SUM(CONVERT(INT, Stat)) AS TotalStat
FROM Entrada.dbo.Jobs with (nolock)
WHERE convert(date, ReceivedOn) >= @TodayDate
			 
END

--=Fields!TotalJobs.Value-Fields!TotalCompleted.Value
GO
