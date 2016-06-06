SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_Reporting_Athena_Job_Status]
	@ReceivedOn datetime = null,
	@ReceivedOn2 datetime = null,
	@PayTypeVar varchar(20) = null --- This is actually the ClinicCode
	
AS
BEGIN

Create table #job_status_hold (clinicid int, ClientJobNumber varchar(30), Jobnumber varchar(30), ack_status varchar(30), job_status varchar(30), create_timestamp datetime, modify_timestamp datetime)


insert into #job_status_hold select * from [CPRODATHENA01.ENTRADA-CPROD.LOCAL].athena_intrf.dbo.job_status WITH(NOLOCK) where Job_status is not null or jobnumber is null


select C.ClinicName, 
	J.JobNumber,JST.StatusName,JS.clientjobnumber,CASE WHEN JD.JobNumber IS NOT NULL THEN 'Y' ELSE 'N' END AS [INJTD],
	J.DictatorID, job_status, ack_status, JS.create_timestamp, JS.modify_timestamp, 
	CASE WHEN job_status is not null and job_status <> 'SENT' THEN 'ERROR' ELSE CASE WHEN JS.jobnumber is null and datediff(HH,JS.create_timestamp,getdate())>=24 THEN 'MISSING' ELSE '' END END as [Status]
	from #job_status_hold JS
	inner join Entrada.dbo.Clinics C WITH(NOLOCK) on JS.clinicid = C.ClinicID
	inner join Entrada.dbo.jobs_client JC WITH(NOLOCK) on JS.ClientJobNumber=JC.FileName
	inner join Entrada.dbo.Jobs J WITH(NOLOCK) on JC.JobNumber=J.JobNumber and J.ClinicID=JS.clinicid
	inner join Entrada.dbo.StatusCodes JST on J.JobStatus=JST.StatusID
	left join Entrada.dbo.Jobstodeliver JD on J.jobnumber=JD.JobNumber
	where J.JobType not in ('No Delivery')

END
GO
