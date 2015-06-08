SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 05/21/2015
-- Description: SP Used to read the User Search Preferences
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetPortalJobReportsUserSavedSearchList]
(
  @userName VARCHAR(50)
)
AS
BEGIN
	SELECT * FROM PortalJobReportPreferences where UserName = @userName AND IsSaved = 1
END

GO


