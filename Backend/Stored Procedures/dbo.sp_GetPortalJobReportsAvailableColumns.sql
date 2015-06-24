SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 05/21/2015
-- Description: SP Used to Get the Available columns
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetPortalJobReportsAvailableColumns]
AS
BEGIN
	SELECT Id,Name,Width,DisplayFormat FROM PortalJobReportAvailableColumns
END

GO


