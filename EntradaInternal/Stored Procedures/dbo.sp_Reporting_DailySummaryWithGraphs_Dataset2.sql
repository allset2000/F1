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
CREATE PROCEDURE [dbo].[sp_Reporting_DailySummaryWithGraphs_Dataset2]

AS
BEGIN


SELECT  COUNT(Jobs.JobNumber) AS NumJobs, 
		vwJobsStatusA.StatusStage
FROM Entrada.dbo.Jobs with (nolock) 
INNER JOIN Entrada.dbo.vwJobsStatusA 
	  ON Jobs.JobNumber = vwJobsStatusA.JobNumber
GROUP BY vwJobsStatusA.StatusStage
			 
END

--=Fields!TotalJobs.Value-Fields!TotalCompleted.Value
GO
