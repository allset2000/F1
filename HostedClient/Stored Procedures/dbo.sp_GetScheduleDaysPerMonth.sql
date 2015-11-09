/****** Object:  StoredProcedure [dbo].[sp_GetScheduleDaysPerMonth]    Script Date: 9/22/2015 12:07:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
		ResourceId VARCHAR(100)
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	SELECT DISTINCT(DAY(AppointmentDate)) as 'Day'
	FROM Schedules S
		INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
	WHERE ClinicId = @ClinicId 
	and MONTH(AppointmentDate) = @Month and YEAR(AppointmentDate) = @Year
	and S.Status in (0,100,200)

	DROP TABLE #tmp_resourceids

END

