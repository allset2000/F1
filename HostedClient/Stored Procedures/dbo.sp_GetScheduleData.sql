SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/6/2015
-- Description: SP called from DictateAPI to pull Schedules resource id's
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleData] (
	@ClinicId INT,
	@ResourceIds VARCHAR(1000),
	@AppointmentDate DATE,
	@DaysForward INT,
	@DaysBehind INT
)
AS
BEGIN

	CREATE TABLE #tmp_resourceids
	(
		ResourceId INT
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	IF (@DaysBehind > 0) BEGIN SET @DaysBehind = @DaysBehind * -1 END
	SET @DaysForward = @DaysForward + 1 -- Need to add 1 to this value (this is due to how appointment dates are stored / searched)

	SELECT *
	FROM Schedules
	WHERE ClinicId = @ClinicId
	and ResourceId in (select ResourceId from #tmp_resourceids)
	and AppointmentDate > (DATEADD(day, @DaysBehind, @AppointmentDate))
	and AppointmentDate < (DATEADD(day,@DaysForward, @AppointmentDate))

	DROP TABLE #tmp_resourceids

END


GO
