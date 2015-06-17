SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Narender
-- Create date: 06/15/2015
-- Description:	SP used to delete portal job reports search saved preferences
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeletePortalJobReportPreference]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM PortalJobReportPreferences WHERE ID=@id
  
END

GO


