SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobStatusQueue] AS
SELECT TOP 1000  JobNumber, Status, StatusDate, Path
FROM         JobStatusA
WHERE     (Status < 140) AND (Status > 100)
ORDER BY Status, Path, JobNumber
GO
