SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves totals for jobs for current
--		and previous two months for report
--		"Dictator Jobs (90 Day Overview).rdl"
-- Edited by Jennifer Blumenthal on 05/29/2013
-- =============================================
create PROCEDURE [dbo].[sp_Reporting_DictatorJobs_90day_v2] 



AS
BEGIN


	SELECT ClinicName, 
		Dictators.DictatorID, 
		T.Cnt AS Curr, 
		T_1.Cnt AS Minus1, 
		T_2.Cnt AS Minus2 
	FROM [Entrada].[dbo].Dictators 

	LEFT OUTER JOIN
		(SELECT DictatorID, 
			COUNT(*) AS Cnt
		FROM [Entrada].[dbo].Jobs
		WHERE (MONTH(ReceivedOn) = MONTH(GETDATE())) AND
			(YEAR(ReceivedOn) = YEAR(GETDATE()))
	   GROUP BY DictatorID
		) T ON 
		Dictators.DictatorID=T.DictatorID 
		
	LEFT OUTER JOIN
		(SELECT DictatorID, 
			COUNT(*) AS Cnt
		FROM [Entrada].[dbo].Jobs
		WHERE (MONTH(ReceivedOn) = MONTH(DATEADD(m, - 1, GETDATE()))) AND
			(YEAR(ReceivedOn) = YEAR(DATEADD(m, - 1, GETDATE())))
		GROUP BY DictatorID
		) T_1 ON 
		Dictators.DictatorID=T_1.DictatorID 

	LEFT OUTER JOIN
	(SELECT DictatorID, 
		COUNT(*) AS Cnt
		FROM [Entrada].[dbo].Jobs
		WHERE (MONTH(ReceivedOn) = MONTH(DATEADD(m, - 2, GETDATE())))AND
			(YEAR(ReceivedOn) = YEAR(DATEADD(m, - 2, GETDATE())))
		GROUP BY DictatorID
		) T_2 ON 
		Dictators.DictatorID = T_2.DictatorID 
		
	INNER JOIN [Entrada].[dbo].Clinics ON 
		Dictators.ClinicID = Clinics.ClinicID
	ORDER BY ClinicName, 
		DictatorID		
				
END

GO
