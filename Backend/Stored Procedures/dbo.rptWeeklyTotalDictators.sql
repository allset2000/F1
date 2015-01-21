SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rptWeeklyTotalDictators] (
   @ClinicID smallint,
   @FromDate date,
   @ToDate date
)
AS
	SET @ToDate=DATEADD(day,1,@ToDate);
	SELECT CONVERT(date, Jobs.ReceivedOn) AS ReceivedOn, Jobs.DictatorID, COUNT(Jobs.JobNumber) AS Jobs, 
	SUM(vwRptEditingJobs.NumPages) AS Pages, SUM(vwRptEditingJobs.NumVBC) AS Lines
    FROM  Jobs LEFT OUTER JOIN vwRptEditingJobs 
	ON Jobs.JobNumber = vwRptEditingJobs.JobNumber
    WHERE (Jobs.ClinicID = @ClinicID) AND (Jobs.ReceivedOn >= @FromDate) AND (Jobs.ReceivedOn <= @ToDate)
    GROUP BY CONVERT(date, Jobs.ReceivedOn), Jobs.DictatorID            
RETURN
GO
