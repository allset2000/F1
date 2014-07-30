SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 7/11/2012
-- Description:	Retrieves turnaround summary data
--		for report "Job Status - Panorama.rdl"
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Reporting_JobsStatus_Panorama]

	@BeginDate datetime,
	@EndDate datetime
	
AS
BEGIN

	SET NOCOUNT ON


	SELECT J.JobNumber,
		J.ReceivedOn,
		JP.MRN,
		SC.StatusStage AS [Status],
		J.CompletedOn
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
		J.JobNumber = JP.JobNumber	
	INNER JOIN [Entrada].[dbo].[JobStatusA] JSA WITH(NOLOCK) ON
		J.JobNumber = JSA.JobNumber	
	INNER JOIN [Entrada].[dbo].[StatusCodes] SC WITH(NOLOCK) ON
		JSA.[Status] = SC.StatusID
	WHERE J.ClinicID = 66 --PANORAMA
		AND J.DictatorID = 'pancgottlob'
		AND J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
		AND J.CompletedOn IS NOT NULL
		
END

GO
