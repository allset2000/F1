SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 9/24/2012
-- Description:	Retrieves turnaround summary data
--		for report "Jobs Delivered Per Day (Panorama).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_JobsDelivered_PerDay_Panorama]

	@ReceivedOn datetime,
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(20) --- This is actually the ClinicCode
	
AS
BEGIN

	SELECT J.JobNumber,
		D.LastName + ', ' + D.FirstName AS [Provider],
		J.ReceivedOn AS [Received], 
		J.CompletedOn AS [Completed], 		
		J.JobType,
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs]
	FROM [Entrada].[dbo].Jobs J
	INNER JOIN [Entrada].[dbo].[Dictators] D WITH(NOLOCK) ON 
		J.DictatorID = D.DictatorID
	WHERE J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0) AND
		J.ClinicID = 66
	ORDER BY D.LastName,
		D.FirstName,
		J.ReceivedOn DESC,
		J.CompletedOn
		
END

GO
