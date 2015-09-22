SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Narender Ramadheni
-- Create date: 09/13/2015
-- Description:	SP used to check if the reportName alreday exists in DB
-- =============================================
CREATE PROCEDURE [dbo].[sp_CheckPortalJobSearchSavedReports] 
@ReportName VARCHAR(100),
@userID VARCHAR(50)

AS
BEGIN
	SELECT COUNT(*) FROM PortalJobReportPreferences WHERE ReportName = @ReportName and UserID = @userID
END
GO
