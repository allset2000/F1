SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:   <Description,,>

-- change log

-- date           username          description
-- 5/15/13  jablumenthal      added EditorName per request
--                                        from Ron Spears.
-- 1/8/14 ddorsey recreated report to work with client reporting portal 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_Account_Delivery_Errors]

@ReceivedOn datetime,
@ReceivedOn2 datetime,
@PayTypeVar varchar(100)

AS
BEGIN

    if object_id('tempdb..#error_Hold') is not null drop table #error_Hold
      Create Table #error_Hold (  Jobnumber varchar(60), 
                                                Clinicname varchar(250), 
                                                [message] varchar(8000), 
                                                ClinicID varchar(10), 
                                                errorMessage varchar(8000), 
                                                exceptionMessage varchar(8000), 
                                                StackTrace varchar(8000), 
                                                errorcode int, 
                                                error_type varchar(1), 
                                                ErrorDate datetime,
                                                DictationDate datetime,
                                                EditorID varchar(50),
                                                Method int,
                                                ContextName varchar(100),
                                                IsGenericJob bit,
                                                AppointmentDate datetime,
                                                StatusDate datetime,
                                                DictatorID varchar(100),
                                                JobType varchar (200),
                                                MRN int,
                                                ClinicCode varchar (20))

      insert into #error_Hold 
      Select  JobNumber, 
                  ClinicName, 
                  [message], 
                  ClinicID, 
                  ErrorMessage, 
                  ExceptionMessage, 
                  StackTrace, 
                  null,
                  null,
                  ErrorDate,
                  DictationDate,
                  EditorID,
                  Method,
                  ContextName,
                  IsGenericJob,
                  AppointmentDate,
                  StatusDate,
                  DictatorID,
                  JobType,
                  MRN,
                  ClinicCode
      from (
                  SELECT  ROW_NUMBER() OVER (PARTITION BY JTDE.DeliveryId ORDER BY ErrorDate DESC) AS 'RowNumber', 
                              ConfigurationName, 
                              JTDE.DeliveryId, 
                              ErrorId, 
                              ErrorDate, 
                              [message], --To account for error on 7/3/2014 for Ortho Specialist - IA cast this to varchar(56) or less IS
                              ErrorMessage, 
                              ExceptionMessage, 
                              StackTrace, 
                              A.JobNumber, 
                              A.ClinicID, 
                              Cl.ClinicName,
                              A.DictationDate,  
                              A.EditorID,
                              JTD.Method,
                              A.ContextName,
                              A.IsGenericJob,
                              A.AppointmentDate,
                              JT.StatusDate,
                              A.DictatorID,
                              A.JobType,
                              JP.MRN,
                              Cl.ClinicCode
                  FROM entrada.dbo.JobsToDeliverErrors JTDE WITH(NOLOCK) 
                  INNER JOIN entrada.dbo.Jobstodeliver JTD WITH(NOLOCK) ON JTDE.DeliveryId=JTD.Deliveryid
                  INNER JOIN entrada.dbo.Jobs A WITH(NOLOCK) on JTD.JobNumber=A.JobNumber
                  inner join Entrada.dbo.Clinics cl WITH(NOLOCK) on A.ClinicID=cl.ClinicID
                  inner Join Entrada.dbo.JobTracking JT WITH(NOLOCK) on A.JobNumber = JT.JobNumber
                  inner join Entrada.dbo.Jobs_Patients JP WITH(NOLOCK) on JP.JobNumber = A.JobNumber
                  where  JTD.Method <> '700'
                  AND A.AppointmentDate between @ReceivedOn and @ReceivedOn2
                  AND Cl.ClinicCode = @PayTypeVar
            ) X 
      where X.Rownumber = 2 

      Update #error_Hold 
      set errorcode = CASE WHEN Method <> 900 THEN left(Message,replace(charindex('|',Message),0,1)-1) ELSE 9 END
      

      Update #error_Hold 
      set errorcode = left(rtrim(errorMessage),replace(charindex('|',rtrim(errorMessage)),0,1)-1) 
      where errorcode is null

      Update #error_Hold 
      set error_type = replace(LEFT(errorcode,1),'0','9')

      insert into #error_Hold
      select  X.job_jobumber,
                  X.ClinicName,
                  CASE WHEN msg_num <> msg_total THEN 'ONE OR MORE SECTIONS DID NOT SEND' ELSE 'JOB FAILED TO REACH DESTINATION' END, 
                  ClinicID, 
                  '',
                  '',
                  '',
                  '400',
                  '4',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  ''
      From (
                  Select  ROW_NUMBER() OVER (Partition BY J.JobNumber order by msg_num desc ) as ROWNUM, 
                              J.JobNumber as job_jobumber, 
                              IJ.JobNumber as int_jobnumber,
                              C.ClinicName,
                              C.ClinicID, 
                              J.ContextName, 
                              j.IsGenericJob,
                              J.AppointmentDate, 
                              JTK.StatusDate,
                              J.DictatorID,
                              J.JobType,
                              P.MRN,
                              C.ClinicCode
                              msg_num, 
                              msg_total 
                  from entrada.dbo.Jobs J WITH(NOLOCK)
                  Inner join entrada.dbo.JobDeliveryHistory JDH WITH(NOLOCK) on J.JobNumber=JDH.JobNumber and Method = 200
                  INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) on J.Clinicid=C.ClinicID
                  inner join Entrada.dbo.JobTracking JTK on JTK.JobNumber = J.JobNumber
                  inner join Entrada.dbo.Jobs_Patients P on P.JobNumber = J.JobNumber
                  Left Join [CLIENTMONMIRTH.ENTRADA-CPROD.LOCAL\MIRTH].Athena_intrf.dbo.Jobs_Sent_status IJ WITH(NOLOCK) on J.JobNumber=IJ.jobNumber
                 where J.ClinicID in (select clinicid from entrada.dbo.Lookup_Athena_Clinic lac
                                                     inner join entrada.dbo.clinics c on c.clinicid = lac.[key]
                                                where hostedclinicid = '-1')
                       AND J.AppointmentDate between @ReceivedOn and @ReceivedOn2
                       AND C.ClinicCode = @PayTypeVar
              )X
      where ROWNUM = 1 
        and (int_jobnumber is null 
               or msg_num < msg_total)

      select * 
      from #error_Hold
order by AppointmentDate

END




GO
