SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:        
-- Create date: 8/5/2014
-- Description:   OTN dictator compliance report
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorCompliance]  

@ReceivedOn       datetime,
@ReceivedOn2      datetime,
@PayTypeVar       varchar(20) = NULL

AS

select d.LastName + ', ' + d.FirstName as 'Provider', p.mrn, p.LastName, p.FirstName, s.AppointmentDate, 
CASE j.status
WHEN 100 then 'Not Dictated'
WHEN 500 then 'Deleted'
ELSE 'NOT DEFINED'
END as 'Status'
From jobs j
inner join dictators d on j.ownerdictatorid=d.dictatorid
inner join Encounters e on e.EncounterID = j.EncounterID
    inner join Schedules s on s.ScheduleID = e.ScheduleID
    inner join Patients p on p.PatientID = s.PatientID
where j.clinicid = 190
and j.status = 100
and s.AppointmentDate > @ReceivedOn
and s.appointmentdate < @ReceivedOn2
order by d.lastname, d.firstname, s.AppointmentDate asc


GO
