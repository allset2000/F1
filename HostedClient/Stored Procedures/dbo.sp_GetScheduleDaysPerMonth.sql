SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/6/2015
-- Description: SP called from DictateAPI to pull a list of days 
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleDaysPerMonth] (
	@ClinicId INT,
	@ResourceIds VARCHAR(1000),
	@Month INT,
	@Year INT
)
AS
BEGIN
	CREATE TABLE #tmp_resourceids
	(
		ResourceId INT
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	SELECT DISTINCT(DAY(AppointmentDate)) as 'Day'
	FROM Schedules S
		INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
	WHERE ClinicId = @ClinicId
	and MONTH(AppointmentDate) = @Month and YEAR(AppointmentDate) = @Year

	DROP TABLE #tmp_resourceids

END

GO
