
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetExpressLinkConfigurationCount]
AS
BEGIN

	DECLARE @HourDiff INT
	SET @HourDiff = (DATEPART(hh, GETDATE() - GETUTCDATE()) - 24)

	SELECT DATEDIFF(MINUTE, DATEADD(hour,@HourDiff,EL.LastSync), GETDATE()) as '1', DATEDIFF(MINUTE, EL.LastScheduleSync, DATEADD(hour,@HourDiff,EL.LastSync)) as '2',*
	FROM ExpressLinkConfigurations EL 
			INNER JOIN Clinics C on C.ClinicId = EL.ClinicId 
	WHERE (DATEDIFF(MINUTE, DATEADD(hour,@HourDiff,EL.LastSync), GETDATE()) > 5 OR DATEDIFF(MINUTE, EL.LastScheduleSync, DATEADD(hour,@HourDiff,EL.LastSync)) > 5)
			AND EL.Enabled = 1
END
GO
