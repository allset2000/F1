SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_UPD_CommandCenter_PortalReport]
	@ReportID int,
	@ReportName varchar(64),
	@ReportAlias varchar(64),
	@ReportSQLName varchar(128),
	@ReportIsUsed bit
	
AS

BEGIN

	UPDATE [Entrada].[dbo].[DSGReports]
	   SET [ReportName] = @ReportName, 
		  [ReportAlias] = @ReportAlias,
		  [ReportSQLName] = @ReportSQLName, 
		  [ReportIsUsed] = @ReportIsUsed
	 WHERE ReportId = @ReportID
			   
	
END


GO
