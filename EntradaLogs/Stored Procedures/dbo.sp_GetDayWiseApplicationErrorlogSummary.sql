
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	get day wise application level error log summary
--exec sp_GetDayWiseApplicationErrorlogSummary '3/21/2016','3/24/2016'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDayWiseApplicationErrorlogSummary]
@FromDate DATE,
@ToDate DATE
AS
BEGIN

    SET NOCOUNT ON;
	 
	SELECT * FROM 
			(
			SELECT 
				   CONVERT(VARCHAR, DATEPART(yy, LE.ErrorWrittenDate)) + '/' + CONVERT(VARCHAR, DATEPART(mm, LE.ErrorWrittenDate)) 
					   + '/' +  CONVERT(VARCHAR, DATEPART(dd, LE.ErrorWrittenDate)) AS ErrorWrittenDate, 				  
				   LC.applicationname,				  
				   COUNT(*) ErrorCount 
			FROM dbo.logexceptions LE WITH(NOLOCK)
			INNER JOIN dbo.logconfiguration LC ON LE.logconfigurationid = LC.logconfigurationid
			WHERE CONVERT(DATE,LE.ErrorCreatedDate)>=CONVERT(DATE,@FromDate) 
							  AND CONVERT(DATE,LE.ErrorCreatedDate)<=CONVERT(DATE,ISNULL(@ToDate,GETDATE())
							 )
			GROUP BY DATEPART(yy, LE.ErrorWrittenDate), DATEPART(mm, LE.ErrorWrittenDate), DATEPART(dd, LE.ErrorWrittenDate),LC.applicationname		
			) p
			PIVOT
			(
			 SUM(ErrorCount) FOR applicationname in (
				 [Admin Console Internal WEB API], [Customer Portal Services], [Customer Portal UI], [EditOne], [Entrada Mobile Application], [Express Link Client],
				 [Express Link Internal WEB API], [Express Link Public WEB API], [Job Builder], [Job Controller], [Job Transcoder], [Mobile Dictate Internal WEB API],
				 [Mobile Dictate Public WEB API], [Real Time TCP IP Server], [Row Backend DataService], [Row Web Service], [Speech Recognition Engine]
				 )
			) AS pvt
		ORDER BY DATEPART(yy, ErrorWrittenDate), DATEPART(mm, ErrorWrittenDate), DATEPART(dd, ErrorWrittenDate)DESC 
END
GO
