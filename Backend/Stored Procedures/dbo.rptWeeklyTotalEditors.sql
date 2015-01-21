SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rptWeeklyTotalEditors] (
   @ClinicID smallint,
   @FromDate date,
   @ToDate date
)
AS
	SET @ToDate=DATEADD(day,1,@ToDate);
	SELECT CONVERT(date, Jobs.ReturnedOn) AS StatusDate, Jobs.EditorID, COUNT(Jobs.JobNumber) AS Jobs, 
	SUM(vwRptEditingJobs.NumPages) AS Pages, SUM(vwRptEditingJobs.NumVBC) AS Lines
    FROM  Jobs LEFT OUTER JOIN vwRptEditingJobs 
	ON Jobs.JobNumber = vwRptEditingJobs.JobNumber
    WHERE (Jobs.ClinicID = @ClinicID) AND (Jobs.ReturnedOn IS NOT NULL) AND 
	(Jobs.ReturnedOn >= @FromDate) AND (Jobs.ReturnedOn <= @ToDate)
    GROUP BY CONVERT(date, Jobs.ReturnedOn), Jobs.EditorID
RETURN
GO
