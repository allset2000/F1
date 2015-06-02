SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 05/25/2015
-- Description: SP Used to Get the JobStatus Options
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPortalJobReportsJobStatusOptions]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	SELECT * from JobStatusGroup

END

GO


