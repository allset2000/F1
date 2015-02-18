
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/6/2015
-- Description: SP called from DictateAPI to pull Schedules resource id's
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleResources] (
	@ClinicId INT
)
AS
BEGIN

	SELECT EHRCode as 'ResourceId',Description as 'ResourceName' FROM RulesProviders WHERE ClinicID = @ClinicId

END


GO
