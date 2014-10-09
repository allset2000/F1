SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		
-- Create date: 10/9/2014
-- Description:	OTN dictator compliance deleted jobs report
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorComplianceDeleted]  

@ReceivedOn		datetime,
@ReceivedOn2	datetime,
@PayTypeVar		varchar(20)	= NULL

AS

select d.LastName + ', ' + d.FirstName as 'Provider', p.mrn, p.LastName, p.FirstName, s.AppointmentDate, JT.ChangedBy, jt.changeDate
From jobs j
inner join dictators d on j.ownerdictatorid=d.dictatorid
inner join Encounters e on e.EncounterID = j.EncounterID
    inner join Schedules s on s.ScheduleID = e.ScheduleID
    inner join Patients p on p.PatientID = s.PatientID
    inner join JobsTracking jt on jt.JobID = j.JobID
where j.clinicid = 190 
and j.Status = 500 
and jt.Status = 500 
and jt.ChangedBy not in ('HL7')
and s.AppointmentDate > @ReceivedOn and s.AppointmentDate < @ReceivedOn2
order by d.lastname, d.firstname, s.AppointmentDate asc
GO
