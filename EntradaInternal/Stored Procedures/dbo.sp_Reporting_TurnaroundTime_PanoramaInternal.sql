SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time (Clinic).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_PanoramaInternal]

	@ReceivedOn datetime,
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(20) --- This is actually the ClinicCode

AS
BEGIN

SET NOCOUNT ON

	BEGIN
	
		-- Get Internally Editted Dictators
		SELECT C.ClinicName as [Clinic],
				J.JobNumber as [Job Number],
				D.LastName + ', ' + D.FirstName AS [Provider],
				E.LastName + ', ' + E.FirstName AS [Editor],
				E.EditorID AS [Editor ID],
				JP.MRN,
				J.JobType,
				J.ReceivedOn as [Received],
				J.CompletedOn as [Completed],
				DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
				CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
				COUNT(J2.JobNumber) AS OnTime,
				COUNT(J.JobNumber)  AS Total
			FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
			LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
				J.DictatorID = D.DictatorID
			LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
				J.ClinicID = C.ClinicID
			LEFT OUTER JOIN [Entrada].[dbo].Jobs_Patients JP WITH(NOLOCK) ON
				J.JobNumber = JP.JobNumber
			LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
				J.EditorID = E.EditorID
			LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
				J.JobNumber = J2.JobNumber
				AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
			WHERE --J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, GETDATE())-1, 0)  AND dateadd(dd, datediff(dd, 0, GETDATE())+0, 0) AND
				C.ClinicID IN (66) AND
				D.DictatorID IN (SELECT DictatorID FROM [EntradaInternal].[dbo].PanDictatatorInternalEdit) AND
				J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
			GROUP BY C.ClinicName,
					E.EditorID,
					D.LastName + ', ' + D.FirstName,
					E.LastName + ', ' + E.FirstName,
					J.ReceivedOn,
					J.CompletedOn,
					J.JobNumber,
					JP.MRN,
					J.JobType
			ORDER BY J.CompletedOn DESC,
				J.ReceivedOn,
				C.ClinicName,
				D.LastName + ', ' + D.FirstName,
				E.LastName + ', ' + E.FirstName	
				
				
	END


END

GO
