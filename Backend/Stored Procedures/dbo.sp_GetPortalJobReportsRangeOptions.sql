SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 05/21/2015
-- Description: SP Used to Get the Range Options
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetPortalJobReportsRangeOptions]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	SELECT * from RangeOptions
END

GO


