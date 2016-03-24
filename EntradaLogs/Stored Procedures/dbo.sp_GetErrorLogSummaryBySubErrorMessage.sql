
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	Error log details group by sub error message
-- =============================================
--exec sp_GetErrorLogSummaryBySubErrorMessage '2016-03-21','2016-03-24',100
CREATE PROCEDURE [dbo].[sp_GetErrorLogSummaryBySubErrorMessage]
@FromDate DATE,
@ToDate DATE,
@SubStringLength Int
AS
BEGIN

    SET NOCOUNT ON;	
		
		
			SELECT LC.LogConfigurationID,LC.ApplicationName, SUBSTRING(exceptionmessage, 1, @SubStringLength) AS [ExceptionMessage], 
					COUNT(*) AS Total
			FROM dbo.logexceptions LE WITH(NOLOCK)
			INNER JOIN dbo.logconfiguration LC ON LE.logconfigurationid = lc.logconfigurationid
			WHERE CONVERT(DATE,LE.ErrorCreatedDate)>=CONVERT(DATE,@FromDate) 
						AND CONVERT(DATE,LE.ErrorCreatedDate)<=CONVERT(DATE,ISNULL(@ToDate,GETDATE())
						)
			GROUP BY LC.logconfigurationid,LC.ApplicationName,SUBSTRING(exceptionmessage, 1, @SubStringLength)
			ORDER BY COUNT(*) DESC
			
		
				
END

GO
