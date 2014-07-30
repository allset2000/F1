SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Leonardo Soto
-- Create date: 2011-07-18 4:02 PM
-- Description:	For Alex
-- =============================================
CREATE PROCEDURE [dbo].[sp_EditorWorkingTime] 
	@startDate datetime,
	@endDate datetime,
	@editorType varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
SELECT Editors.EditorID, Editors.FirstName, Editors.LastName, T_Dates.Date, SignIn, SignOff, NumJobs, SumVBC as CharsWSpaces, SumVBC/65.0 as CharsWSpaces_Lines, SumChars AS VBC, SumChars/65.0 as VBCLines FROM Editors CROSS JOIN
(
SELECT DISTINCT DATEADD(dd, Days.Row, DATEADD(mm, Months.Row, DATEADD(yy, Years.Row, @startDate))) AS Date
		FROM
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
		 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
		 UNION ALL SELECT 20 -- add more years here...
		) AS Years
		INNER JOIN
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11
		) AS Months
		ON DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @startDate)) <= @endDate 
		INNER JOIN
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
		 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
		 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
		 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
		 UNION ALL SELECT 30
		) AS Days
		ON DATEADD(dd, Days.Row, DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @startDate))) <= @endDate
		WHERE DATEADD(yy, Years.Row, @startDate) <= @endDate
) T_Dates
LEFT OUTER JOIN
(
SELECT     EditorID, MIN(OperationTime) AS SignIn
FROM         EditorLogs
WHERE     OperationName = 'SignIn' AND CONVERT(DATE,OperationTime,102)>=@startDate AND CONVERT(DATE,OperationTime,102)<=@endDate
GROUP BY EditorID, OperationName, CONVERT(DATE,OperationTime,102)
--ORDER BY EditorID, SignIn
) T1
ON Editors.EditorID=T1.EditorID AND T_Dates.Date=CONVERT(DATE, SignIn,102)
LEFT OUTER JOIN
(
SELECT     EditorID, MAX(OperationTime) AS SignOff
FROM         EditorLogs
WHERE     OperationName = 'SignOff' AND CONVERT(DATE,OperationTime,102)>=@startDate AND CONVERT(DATE,OperationTime,102)<=@endDate
GROUP BY EditorID, OperationName, CONVERT(DATE,OperationTime,102)
--ORDER BY EditorID, SignOff
) T2 
ON Editors.EditorID=T2.EditorID AND T_Dates.Date=CONVERT(DATE, SignOff,102)
INNER JOIN
(
SELECT EditorID, CONVERT(DATE,ReturnedOn,102) AS RetDate, COUNT(Jobs.JobNumber) As NumJobs, SUM(NumVBC_Editor) as SumVBC, SUM(NumChars_Editor) as SumChars
FROM Jobs INNER JOIN Jobs_EditingData ON Jobs.JobNumber=Jobs_EditingData.JobNumber 
WHERE ReturnedOn>=@startDate AND ReturnedOn<=@endDate
GROUP BY EditorID, CONVERT(DATE,ReturnedOn,102)
) TJobs_Counts
ON Editors.EditorID=TJobs_Counts.EditorID AND T_Dates.Date=TJobs_Counts.RetDate
INNER JOIN Editors_Pay ON Editors.EditorID=Editors_Pay.EditorID
WHERE Editors_Pay.PayType=@editorType
ORDER BY EditorID, Date


END
GO
