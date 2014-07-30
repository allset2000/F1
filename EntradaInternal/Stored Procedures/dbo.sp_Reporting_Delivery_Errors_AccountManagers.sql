SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =============================================
Author:			Unknown
Create date:	Unknown
Description:	This procedure pulls data for the 
				report 'Job Delivery Error' in the 
				'Monitoring' folder of the report portal.
				
change log:
date		username		description
4/25/13		jablumenthal	copied this proc for the 
							Acct Mgr version of the above 
							report.  Per Ron Spears, only 
							error_type 2 needs to be included.	
5/15/13		jablumenthal	added EditorName per request from Ron Spears	
5/23/13		jablumenthal	per Ron, report is not pulling in all the 
							data it should.  I had to edit the Acct Mgr
							filter to get the unknowns to show up.  		
================================================ */
CREATE PROCEDURE [dbo].[sp_Reporting_Delivery_Errors_AccountManagers]

	 @clinics varchar(max)
	,@AcctMgr varchar(max)


AS
BEGIN

	if object_id('tempdb..#error_Hold') is not null drop table #error_Hold

	Create Table #error_Hold (  Jobnumber varchar(60), 
								Clinicname varchar(250), 
								message varchar(8000), 
								ClinicID varchar(10), 
								errorMessage varchar(8000), 
								exceptionMessage varchar(8000), 
								StackTrace varchar(8000), 
								errorcode int, 
								error_type varchar(1),
								error_type_desc varchar(50), 
								ErrorDate datetime,
								AcctManagerName varchar(50),
								EditorID varchar(50))

	insert into #error_Hold (Jobnumber, 
							 Clinicname, 
							 [message], 
							 ClinicID, 
							 errorMessage, 
							 exceptionMessage, 
							 StackTrace, 
							 errorcode, 
							 error_type, 
							 error_type_desc,
							 ErrorDate,
							 AcctManagerName,
							 EditorID)
	Select  JobNumber, 
			ClinicName, 
			[Message], 
			ClinicID, 
			ErrorMessage, 
			ExceptionMessage, 
			StackTrace, 
			null,
			null,
			'Editing Errors',
			ErrorDate,
			AcctManagerName,
			EditorID
	from (
			SELECT  ROW_NUMBER() OVER (PARTITION BY JTDE.DeliveryId ORDER BY ErrorDate DESC) AS 'RowNumber', 
					ConfigurationName, 
					JTDE.DeliveryId, 
					ErrorId, 
					ErrorDate, 
					[Message], 
					ErrorMessage, 
					ExceptionMessage, 
					StackTrace, 
					A.JobNumber, 
					A.ClinicID, 
					Cl.ClinicName,
					CASE
						WHEN AM.XrefID is not null THEN AM.AcctManagerName
						ELSE 'Unknown'
					END as AcctManagerName,
					A.EditorID
			FROM entrada.dbo.JobsToDeliverErrors JTDE WITH(NOLOCK) 
			INNER JOIN entrada.dbo.Jobstodeliver JTD WITH(NOLOCK) ON JTDE.DeliveryId=JTD.Deliveryid
			INNER JOIN entrada.dbo.Jobs A WITH(NOLOCK) on JTD.JobNumber=A.JobNumber
			inner join Entrada.dbo.Clinics cl WITH(NOLOCK) on A.ClinicID=cl.ClinicID
			LEFT OUTER JOIN EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref AM WITH (NOLOCK) on A.ClinicID = AM.ClinicID
			where JTD.Method <> '700'
			  and [message] like '2%' --this gets converted to error_type 2
			  and cl.ClinicCode in (select ltrim(id) from EntradaInternal.dbo.ParamParserFn(@clinics,','))
			  and CASE
					WHEN AM.AcctManagerName IS NULL THEN 'Unknown'
					ELSE AM.AcctManagerName
				  END in (select ltrim(id) from EntradaInternal.dbo.ParamParserFn(@AcctMgr, ','))
		 ) X 
	where X.Rownumber = 1 
	  

	Update #error_Hold 
	set errorcode = left(Message,replace(charindex('|',Message),0,1)-1) 
	where errorcode is null

	Update #error_Hold 
	set errorcode = left(rtrim(errorMessage),replace(charindex('|',rtrim(errorMessage)),0,1)-1) 
	where errorcode is null

	Update #error_Hold 
	set error_type = replace(LEFT(errorcode,1),'0','9')


	--this section does not apply to Editing Errors 4/25/13 jb
	--insert into #error_Hold (Jobnumber, 
	--						 Clinicname, 
	--						 [message], 
	--						 ClinicID, 
	--						 errorMessage, 
	--						 exceptionMessage, 
	--						 StackTrace, 
	--						 errorcode, 
	--						 error_type, 
	--						 error_type_desc,
	--						 ErrorDate,
	--						 AcctManagerName)
	--select  X.job_jobumber,
	--		X.ClinicName,
	--		CASE WHEN msg_num <> msg_total THEN 'ONE OR MORE SECTIONS DID NOT SEND' ELSE 'JOB FAILED TO REACH DESTINATION' END, 
	--		ClinicID, 
	--		null,
	--		null,
	--		null,
	--		'400',
	--		'4',
	--		'Editing Errors',
	--		null,
	--		X.AcctManagerName
	--From (
	--		Select  ROW_NUMBER() OVER (Partition BY J.JobNumber order by msg_num desc ) as ROWNUM, 
	--				J.JobNumber as job_jobumber, 
	--				IJ.JobNumber as int_jobnumber,
	--				C.ClinicName,
	--				C.ClinicID, 
	--				msg_num, 
	--				msg_total,
	--				CASE
	--					WHEN AM.XrefID is not null THEN AM.AcctManagerName
	--					ELSE 'Unknown'
	--				END as AcctManagerName
	--		from entrada.dbo.Jobs J WITH (NOLOCK)
	--		Inner join entrada.dbo.JobDeliveryHistory JDH WITH (NOLOCK) on J.JobNumber=JDH.JobNumber 
	--		INNER JOIN Entrada.dbo.Clinics C WITH (NOLOCK) on J.Clinicid=C.ClinicID
	--		Left Join [CLIENTMONMIRTH.ENTRADA-CPROD.LOCAL\MIRTH].Athena_intrf.dbo.Jobs_Sent_status IJ WITH (NOLOCK) on J.JobNumber=IJ.jobNumber
	--		LEFT OUTER JOIN EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref AM WITH (NOLOCK) on J.ClinicID = AM.ClinicID
	--		where J.ClinicID in (select [KEY] 
	--							 from entrada.dbo.Lookup_Athena_Clinic WITH (NOLOCK))
	--		  and AM.AcctManagerName in (select ltrim(id) from EntradaInternal.dbo.ParamParserFn(@AcctMgr, ','))
	--		  and C.ClinicCode in (select ltrim(id) from EntradaInternal.dbo.ParamParserFn(@clinics,','))
	--	  ) X
	--where ROWNUM = 1 
	--  and (int_jobnumber is null 
	--	   or msg_num < msg_total)
	  

	select * 
	from #error_Hold
	order by AcctManagerName,
			 ClinicName,
			 ErrorDate desc,
			 JobNumber

END
GO
