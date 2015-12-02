SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/18/2014
-- Description: SP called from DictateAPI to pull System settings to sync on mobile

-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSystemSettingsToSync](
	 @ClinicId INT
) AS 
BEGIN
    
	SET NOCOUNT ON;

	 SELECT ss.SystemSettingsID, 
			ss.ClinicID, 
			ss.GenericPatientID,
			c.ExpressQueuesEnabled,
			c.ImageCaptureEnabled,
			c.PatientClinicalsEnabled	
	FROM dbo.SystemSettings ss
	INNER JOIN	 dbo.Clinics c ON c.ClinicID=ss.ClinicID
	WHERE c.ClinicID = @ClinicId 
END


GO
