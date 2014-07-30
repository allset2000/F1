SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_INS_CommandCenter_PortalReport]

	@ReportName varchar(64),
	@ReportAlias varchar(64),
	@ReportSQLName varchar(128),
	@ReportIsUsed bit
	
AS

BEGIN

	INSERT INTO [Entrada].[dbo].[DSGReports]
			   ([ReportName],
			   [ReportAlias],
			   [ReportSQLName],
			   [ReportIsUsed])
		 VALUES
			   (@ReportName,
			   @ReportAlias,
			   @ReportSQLName,
			   @ReportIsUsed)
			   
	
END


GO
