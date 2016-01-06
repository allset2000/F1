SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	get day wise application level error log summary
--sp_GetDayWiseApplicationErrorlogSummary '2015/12/12','2015/12/30'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDayWiseApplicationErrorlogSummary]
@FromDate DATE,
@ToDate DATE
AS
BEGIN

    SET NOCOUNT ON;
	 
	 SET @FromDate=ISNULL(@FromDate,DATEADD(DAY,-7,GETDATE()))

	SELECT * FROM (
		SELECT DATEPART(yy, ErrorWrittenDate) AS  [Year], 
		       DATEPART(mm, ErrorWrittenDate) AS [Month], 
			   DATEPART(dd, ErrorWrittenDate) AS [Day],
	           CONVERT(VARCHAR, DATEPART(yy, ErrorWrittenDate)) + '/' + CONVERT(VARCHAR, DATEPART(mm, ErrorWrittenDate)) 
		           + '/' +  CONVERT(VARCHAR, DATEPART(dd, ErrorWrittenDate)) AS ErrorWrittenDate, 
			   LC.applicationname,
		       COUNT(*) ErrorCount 
	    FROM logexceptions LE 
		INNER JOIN logconfiguration LC ON LE.logconfigurationid = lc.logconfigurationid
		WHERE CONVERT(DATE,LE.ErrorCreatedDate)>=CONVERT(DATE,@FromDate) 
						  AND CONVERT(DATE,LE.ErrorCreatedDate)<=CONVERT(DATE,ISNULL(@ToDate,GETDATE())
						 )
		GROUP BY DATEPART(yy, ErrorWrittenDate), DATEPART(mm, ErrorWrittenDate), DATEPART(dd, ErrorWrittenDate), LC.applicationname		
		) p
		PIVOT
		(
		 SUM(errorCount) FOR applicationname in (
			 [Admin Console Internal WEB API], [Customer Portal Services], [Customer Portal UI], [EditOne], [Entrada Mobile Application], [Express Link Client],
			 [Express Link Internal WEB API], [Express Link Public WEB API], [Job Builder], [Job Controller], [Job Transcoder], [Mobile Dictate Internal WEB API],
			 [Mobile Dictate Public WEB API], [Real Time TCP IP Server], [Row Backend DataService], [Row Web Service], [Speech Recognition Engine]
			 )
		) AS pvt
		ORDER BY DATEPART(yy, ErrorWrittenDate), DATEPART(mm, ErrorWrittenDate), DATEPART(dd, ErrorWrittenDate)DESC 
END
GO
