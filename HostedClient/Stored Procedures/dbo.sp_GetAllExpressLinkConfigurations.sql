/****** Object:  StoredProcedure [dbo].[sp_GetAllExpressLinkConfigurations]    Script Date: 8/24/2015 5:08:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/31/2014
-- Description: SP used to pull all expresslink configurations from db for Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllExpressLinkConfigurations]
AS
BEGIN

	DECLARE @HourDiff INT
	SET @HourDiff = (DATEPART(hh, GETDATE() - GETUTCDATE()) - 24)

	SELECT  EL.ID,EL.ApiKey,EL.EHRClinicID,EL.EHRLocationID,EL.EHRType,EL.ConnectionString,EL.Enabled,EL.SyncSetupData,EL.DaysForward,EL.DaysBack,EL.StartDate,EL.LastPatientSync,EL.LastScheduleSync,EL.LastClinicalsSync,DATEADD(hh,@HourDiff,EL.LastSync) as 'LastSync',El.ClientVersion,
			C.ClinicCode, 
			CASE WHEN EL.Enabled = 0 THEN 'none'
				 WHEN ISNULL(EL.LastSync,'') <> '' AND DATEDIFF(MINUTE, EL.LastSync, GETDATE()) > 5 THEN 'lightcoral' 
				 WHEN ISNULL(EL.LastScheduleSync,'') <> '' AND DATEDIFF(HOUR, EL.LastScheduleSync, EL.LastSync) > 6 THEN 'lightyellow' 
				 ELSE 'none' END AS 'RowColor' 
	FROM ExpressLinkConfigurations EL 
		INNER JOIN Clinics C on C.ClinicId = EL.ClinicId 
	WHERE ISNULL(EL.Deleted,0) = 0
	order by EL.APIKey,C.ClinicCode

END

GO


