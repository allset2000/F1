SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 5/15/2012
-- Description:	Retrieves uncompleted job info
--		for report "Pending Jobs (CIO).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_PendingJobs]

	@BeginDate datetime, 
	@EndDate datetime

AS
BEGIN

	SELECT DATEADD(dd, DATEDIFF(dd, 0, J.ReceivedOn)+1, 0) AS [Received On],
		J.DictatorID,
		SC.StatusName,
		count(SC.StatusName) as [Count]
	FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].[JobStatusA] JSA WITH(NOLOCK) ON
		J.JobNumber = JSA.JobNumber	
	LEFT OUTER JOIN [Entrada].[dbo].[StatusCodes] SC WITH(NOLOCK) ON
		JSA.[Status] = SC.StatusID
	WHERE J.ClinicID = 57 AND
		JSA.[Status] NOT IN (320, 360) AND 
		J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @BeginDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0))
	GROUP BY DATEADD(dd, DATEDIFF(dd, 0, J.ReceivedOn)+1, 0),
		J.DictatorID,
		SC.StatusName
	ORDER BY DATEADD(dd, DATEDIFF(dd, 0, J.ReceivedOn)+1, 0),
		J.DictatorID,
		SC.StatusName

END

GO
