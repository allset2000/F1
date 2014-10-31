SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetExpressLinkConfigurationCount]
AS
BEGIN
	SELECT 
		COUNT(*) 
	FROM ExpressLinkConfigurations EL 
		INNER JOIN Clinics C on C.ClinicId = EL.ClinicId 
	WHERE DATEDIFF(MINUTE, EL.LastSync, GETDATE()) > 5 OR DATEDIFF(MINUTE, EL.LastScheduleSync, EL.LastSync) > 5
END
GO
