SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Dustin Dorsey
Create date:	8/15/14
Description:	Returns Total Vendor TAT Times
======================================================= */

CREATE PROCEDURE [dbo].[sp_Reporting_DateParameter]

AS 

select CONVERT(nvarchar(50), DATENAME(m, CompletedOn) + ' ' + DATENAME(yyyy, CompletedOn)) as MonthYear, MAX(CompletedOn) as SortDate
FROM Entrada.dbo.JOBS 
WHERE CompletedOn BETWEEN Dateadd(Month, Datediff(Month, 0, DATEADD(m, -12, current_timestamp)), 0) and GetDate()
GROUP BY CONVERT(nvarchar(50), DATENAME(m, CompletedOn) + ' ' + DATENAME(yyyy, CompletedOn))
ORDER BY MAX(CompletedOn) desc
GO
