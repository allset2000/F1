SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/23/2012
-- Description:	Notifies On-Call editors of any 
--		Huron Valley jobs that we receive over 
--		the weekend. 
--		For report "Huron Valley Jobs Per Site.rdl"

-- =============================================


CREATE PROCEDURE [dbo].[sp_Monitoring_HuronValley_JobsBySiteLocation]

@ReceivedOn datetime,
@ReceivedOn2 datetime,
@PayTypeVar varchar(10)

AS

BEGIN

	SET NOCOUNT ON;

	SELECT JC.Custom9 AS [Site Location],
		D.LastName + ', ' + D.FirstName AS [Speaker],
		J.JobNumber,
		JP.MRN,
		JC.Custom11 AS [Accession No],
		JC.Custom5 AS [Procedure],
		CAST(CAST(CAST(J.AppointmentDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(CAST(J.AppointmentTime AS TIME) AS VARCHAR(10)) AS DATETIME) as [Study Date],
		J.ReceivedOn as [Received],
		J.CompletedOn as [Completed],
		DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
		COUNT(J.JobNumber)  AS Total,		
		CASE J.STAT
			WHEN 1 THEN 'Y'
			ELSE 'N'
		END AS [Stat]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		J.DictatorID = D.DictatorID
	INNER JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON
		J.JobNumber = JC.JobNumber
	INNER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
		J.JobNumber = JP.JobNumber		
	WHERE J.ClinicID = 45 AND
		J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @ReceivedOn)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @ReceivedOn2)+1, 0)) 
	GROUP BY JC.Custom9,
		JC.Custom11,
		JC.Custom5,
		J.JobNumber,
		J.AppointmentDate,
		J.AppointmentTime,
		J.ReceivedOn,
		J.CompletedOn,
		J.JobNumber,
		JP.MRN,
		D.LastName,
		D.FirstName,
		J.Stat
	ORDER BY J.ReceivedOn
	
END

	


GO
