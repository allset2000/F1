SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:                              Raghu A
-- Create date: 7/12/2016
-- Description:      Get schedule for process jobs 
-- =============================================
CREATE PROCEDURE [dbo].[spv_JobBuilder_Schedules]            
AS
BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
	--if there is a record to process for the selected clinics for today process those first. 
	--Otherwise process for all clinics and for all days
	--IF EXISTS(SELECT 1 FROM Schedules WITH(NOLOCK) 
	--		WHERE rowprocessed in (0,2,3) 
	--			AND DATEDIFF(dd, appointmentdate, GETDATE()) = 0 
	--			AND clinicid in ('88','97','296','70','372','72','103','308','79','353','283','98','411','66','189','71','93','318','394','18','19','216','383','126','190','271')
 --   			)
	--	BEGIN
	--		SELECT TOP 1000 scheduleID AS scheduleID, rowprocessed AS rowprocessed 
	--					FROM dbo.Schedules WITH(NOLOCK)
	--					WHERE rowprocessed in (0,2,3)
	--		AND DATEDIFF(dd, appointmentdate, GETDATE()) = 0
	--		AND clinicid in ('88','97','296','70','372','72','103','308','79','353','283','98','411','66','189','71','93','318','394','18','19','216','383','126','190','271')
	--		ORDER BY 
	--			CASE WHEN ClinicId IN ('88','97','296','70','372','72','103','308','79','353','283','98','411','66','189','71','93','318','394','18','19','216','383','126','190','271') THEN 0 ELSE 1 END,
	--			CASE WHEN CONVERT(DATE,AppointmentDate)=CONVERT(DATE,GETDATE()) THEN 0 ELSE 1 END, 
	--			AppointmentDate
	--	END
 --     ELSE 
	--	BEGIN
	
			SELECT TOP 1000 scheduleID AS scheduleID, rowprocessed AS rowprocessed 
						FROM dbo.Schedules WITH(NOLOCK)
			WHERE rowprocessed in (0,2,3)
			--AND DATEDIFF(dd, GETDATE(), appointmentdate) = 0
			--AND clinicid in ('88','97','296','70','372','72','103','308','79','353','283','98','411','66','189','71','93','318','394','18','19','216','383','126','190','271')
			ORDER BY 
				--CASE WHEN ClinicId IN ('88','97','296','70','372','72','103','308','79','353','283','98','411','66','189','71','93','318','394','18','19','216','383','126','190','271') THEN 0 ELSE 1 END,
                CASE WHEN CONVERT(DATE,AppointmentDate)=CONVERT(DATE,GETDATE()) THEN 0 ELSE 1 END, 
                AppointmentDate

		--END
		
END
GO
