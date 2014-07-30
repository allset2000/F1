SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[qryWorkingEditors] (
   @FromTime datetime
) AS
	SELECT dbo.EditorLogs.EditorID, dbo.vwEditors.FirstName, dbo.vwEditors.LastName, MAX(OperationTime) AS LastOperationTime,
	MAX(EditorType) AS EditorType, MAX(EditorCompanyCode) AS EditorPayType 
	FROM  dbo.EditorLogs INNER JOIN dbo.vwEditors
	ON dbo.EditorLogs.EditorID = dbo.vwEditors.EditorID
	WHERE dbo.EditorLogs.EditorLogId > (select MAX(dbo.EditorLogs.EditorLogId) - 200000 from dbo.EditorLogs)
	GROUP BY dbo.EditorLogs.EditorID, dbo.vwEditors.FirstName, dbo.vwEditors.LastName
	HAVING (MAX(OperationTime) >= @FromTime)
	ORDER BY dbo.EditorLogs.EditorID
RETURN
GO
