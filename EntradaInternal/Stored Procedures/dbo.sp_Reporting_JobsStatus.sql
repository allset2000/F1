SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/27/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time.rdl"
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Reporting_JobsStatus]

	@BeginDate datetime,
	@EndDate datetime,
	@ClinicID int,
	@PayType varchar(50)
	
AS
BEGIN

	SET NOCOUNT ON

SELECT C.ClinicName,
		J.JobType,
		JSA.[Status],
		SC.StatusName,		
		J.JobNumber,
		J.DictatorID,
		J.ReceivedOn,
		J.ReturnedOn,
		J.CompletedOn,
		DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [Elapsed TAT],
		COUNT(J2.JobNumber) AS OnTime,
		COUNT(J.JobNumber)  AS Total
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Editors_Pay EP WITH(NOLOCK) ON
		J.EditorID = EP.EditorID
	INNER JOIN [Entrada].[dbo].[JobStatusA] JSA WITH(NOLOCK) ON
		J.JobNumber = JSA.JobNumber	
	INNER JOIN [Entrada].[dbo].[StatusCodes] SC WITH(NOLOCK) ON
		JSA.[Status] = SC.StatusID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		J.JobNumber = J2.JobNumber
		AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.ClinicID = CASE @ClinicID 
							WHEN -1 THEN J.ClinicID
							ELSE @ClinicID
						END 	AND
		EP.PayType = CASE @PayType
						WHEN '-ALL-' THEN EP.PayType
						ELSE @PayType
					END	AND
		J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0) AND
		JSA.[Status] IN (140, 150, 160, 180, 190, 210, 220, 240)	
	GROUP BY C.ClinicName,
			J.JobType,
			JSA.[Status],
			SC.StatusName,
			J.DictatorID,
			J.ReceivedOn,
			J.ReturnedOn,
			J.CompletedOn,
			J.JobNumber
	ORDER BY C.ClinicName,
		JSA.[Status]
		
END

GO
