SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 7/12/2016
-- Description:	Get schedule for process jobs
-- =============================================
CREATE PROCEDURE [dbo].[spv_JobBuilder_Schedules]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1000 scheduleID AS scheduleID, rowprocessed AS rowprocessed 
	FROM dbo.Schedules WITH(NOLOCK)
	WHERE rowprocessed in (0,2,3)
    AND DATEDIFF(dd, appointmentdate, GETDATE()) = 0
    ORDER BY CASE WHEN CONVERT(DATE,AppointmentDate)=CONVERT(DATE,GETDATE()) THEN 0 ELSE 1 END, AppointmentDate

END
GO
