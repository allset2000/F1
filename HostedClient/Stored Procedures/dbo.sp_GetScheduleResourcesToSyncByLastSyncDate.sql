
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Raghu A
-- Create date: 24/11/2015
-- Description: SP called from DictateAPI to pull Schedules resource id's
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleResourcesToSyncByLastSyncDate] (
	@ClinicId INT,
	@LastSyncDate DATETIME
)
AS
BEGIN

	SELECT EHRCode as 'ID',
		   Description as 'ResourceName' 
     FROM RulesProviders 
	 WHERE ClinicID = @ClinicId AND
	 ISNULL(UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
END


GO

