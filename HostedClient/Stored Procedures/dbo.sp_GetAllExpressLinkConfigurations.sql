SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/31/2014
-- Description: SP used to pull all expresslink configurations from db for Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllExpressLinkConfigurations]
AS
BEGIN

	SELECT  EL.*,
			C.ClinicCode, 
			CASE WHEN ISNULL(EL.LastSync,'') <> '' AND DATEDIFF(MINUTE, EL.LastSync, GETDATE()) > 5 THEN 'lightcoral' 
				 WHEN ISNULL(EL.LastScheduleSync,'') <> '' AND DATEDIFF(MINUTE, EL.LastScheduleSync, EL.LastSync) > 5 THEN 'lightyellow' 
				 ELSE 'none' END AS 'RowColor' 
	FROM ExpressLinkConfigurations EL 
		INNER JOIN Clinics C on C.ClinicId = EL.ClinicId 
	order by EL.APIKey,C.ClinicCode

END
GO
