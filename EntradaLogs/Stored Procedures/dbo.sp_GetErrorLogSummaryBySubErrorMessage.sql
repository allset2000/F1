SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	Error log details group by sub error message
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetErrorLogSummaryBySubErrorMessage]
@FromDate DATE,
@ToDate DATE,
@SubStringLength Int
AS
BEGIN

    SET NOCOUNT ON;
	 
	SET @FromDate=ISNULL(@FromDate,DATEADD(DAY,-7,GETDATE()))



	SELECT  SUBSTRING(exceptionmessage, 1, @SubStringLength) AS [ExceptionMessage], 
	        COUNT(*) AS Total
	FROM logexceptions LE 
	INNER JOIN logconfiguration LC ON LE.logconfigurationid = lc.logconfigurationid
	WHERE CONVERT(DATE,LE.ErrorCreatedDate)>=CONVERT(DATE,@FromDate) 
				AND CONVERT(DATE,LE.ErrorCreatedDate)<=CONVERT(DATE,ISNULL(@ToDate,GETDATE())
				)
	GROUP BY SUBSTRING(exceptionmessage, 1, @SubStringLength)
	ORDER BY COUNT(*) DESC
END
GO
