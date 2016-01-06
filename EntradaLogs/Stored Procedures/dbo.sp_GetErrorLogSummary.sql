SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 12/31/2015
-- Description:	Error log summary
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetErrorLogSummary] 	
@FromDate DATE,
@ToDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 
	 SET @FromDate=ISNULL(@FromDate,DATEADD(DAY,-7,GETDATE()))

	   SELECT * FROM 
		 (SELECT  LC.LogConfigurationID,
				 LC.ApplicationName, 
				 COUNT(*) as ErrorCount 
			FROM 
			dbo.LogExceptions LE
			INNER JOIN [dbo].[LogConfiguration] LC
			ON LC.LogConfigurationID=LE.LogConfigurationID
			WHERE CONVERT(DATE,LE.ErrorCreatedDate)>=CONVERT(DATE,@FromDate) 
						  AND CONVERT(DATE,LE.ErrorCreatedDate)<=CONVERT(DATE,ISNULL(@ToDate,GETDATE())
						 )
			GROUP BY LC.LogConfigurationID, LC.ApplicationName
		)A 
		ORDER BY ErrorCount DESC
END
GO
