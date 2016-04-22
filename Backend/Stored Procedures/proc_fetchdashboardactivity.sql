
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--EXEC proc_fetchdashboardactivity 'tscskumar',1
-- =============================================
-- Author:		EntradaDev
-- Updated:     Baswaraj on 02-Feb-2016 for #393 
-- Updated:     Narender on 04-Apr-2016 for #5461 
-- Updated on 19thApril-16 : added a clinic comparision for jobs to get from hosted #7625
-- =============================================
CREATE PROCEDURE [dbo].[proc_fetchdashboardactivity]
	
             @dictatirid varchar(5000),
			 @ShowErrors int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--set statistics io ON
--Calculate jobs prior threemonths

IF OBJECT_ID('tempdb..#tmpoutput') IS NOT NULL
drop table #tmpoutput
create table #tmpoutput
(
	dictatorid varchar(500),
	totalinprocess int null,
	totalinprocesstoday int null,
	delivered int null,
	customerreviewed int null,
	errors INT NULL,
	draftreview INT
)

--splitting the comma separated dictators to inser into a temp table as we can not use user id in the backend database
IF OBJECT_ID('tempdb..#tempdictators') IS NOT NULL
drop table #tempdictators
select Cast(sp.splitdata as varchar(500))as dictatorid into #tempdictators  from dbo.fnSplitString(@dictatirid,',') sp 

--for IN PROCESS and CUSTOMER REVIEW


Merge #tmpoutput as T
Using (

select DictatorId,[In Process],[Available for CR]
from

(SELECT j.dictatorid,JSGA.StatusGroup  ,count(*) TotalJobCount from jobs J
	INNER JOIN jobstatusA JA on j.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN jobstatusgroup JSGA on SCA.statusGroupId = JSGA.id
	
WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid in (select dictatorid from #tempdictators) --select dictatorid from #tempdictators
	AND JSGA.id in (1,2)
group by J.dictatorid,JSGA.StatusGroup
) as P
Pivot
(
	sum(TotalJobCount) for StatusGroup
	IN ([In Process],[Available for CR])
) as PivotTablefrInprocessandCR
) as S on T.dictatorid=S.DictatorId
when not matched by target then
Insert(dictatorid,totalinprocess,customerreviewed) values (S.DictatorId,S.[In Process],S.[Available for CR]);



--for IN PROCESS (TODAY)
Merge #tmpoutput as T
using
(
SELECT j.dictatorid, count(*) Inprocesstoday from jobs J
	INNER JOIN jobstatusA JA on j.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN jobstatusgroup JSGA on SCA.statusGroupId = JSGA.id
WHERE 
	DATEDIFF(d, J.receivedon, getdate())= 0
	AND J.dictatorid in (select dictatorid from #tempdictators)
	AND JSGA.id =1
group by J.dictatorid
) as S on T.dictatorid=S.dictatorid
when matched then
update Set T.totalinprocesstoday=S.Inprocesstoday

when not matched by target then
Insert(dictatorid,totalinprocesstoday) values (S.DictatorId,S.Inprocesstoday);



--for DELIVERED (TODAY)
Merge #tmpoutput as T
using
(
SELECT J.dictatorId, count(distinct J.jobnumber)Deliveredtoday FROM JOBS J 
	INNER JOIN JobDeliveryHistory JDH ON J.jobnumber = JDH.jobnumber
WHERE
	DATEDIFF(d, JDH.DeliveredOn, getdate())=0 and J.dictatorid in (select dictatorid from #tempdictators)
GROUP BY J.dictatorId
) as S on S.dictatorId=T.dictatorid
when matched then
 Update set T.delivered=S.Deliveredtoday
 when not matched by target then
 Insert(dictatorid,delivered) values (S.DictatorId,S.Deliveredtoday);

 -- Added for to get JOB Errors -- Writtend by Baswaraj
-- Search the error flag in Entrada and/or EntradaHostedClient DBs
	IF(@ShowErrors = 1)
		BEGIN
		MERGE #tmpoutput AS T
			USING
			(
				SELECT a.dictatorid,COUNT(a.jobnumber)as ErrorCount  FROM 
				(
						SELECT DISTINCT j.dictatorid,j2d.jobnumber 
						FROM jobstodeliver J2D 
						    INNER JOIN JOBS J on j.jobnumber=j2d.jobnumber
							INNER JOIN #tempdictators temp on temp.dictatorid =j.dictatorid		
							INNER JOIN JobsToDeliverErrors J2DE on J2D.DeliveryID = J2DE.DeliveryID
							INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=J2DE.ErrorCode							
							INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType
						WHERE EST.ErrorSourceTypeID=1
					UNION 
						SELECT DISTINCT j.dictatorid,jc.jobnumber 
						FROM jobs J 
						    INNER JOIN #tempdictators temp on temp.dictatorid =j.dictatorid
							INNER JOIN jobs_client JC ON J.jobnumber=JC.jobnumber
							INNER JOIN EntradaHostedClient.DBO.jobs EHJ ON EHJ.jobnumber=JC.[FILENAME] AND EHJ.ClinicID= J.ClinicID
							INNER JOIN EntradaHostedClient.DBO.jobsdeliveryerrors EHJDE ON EHJDE.jobid=EHJ.jobid 
							INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=EHJDE.ErrorCode							
							INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType
						WHERE EST.ErrorSourceTypeID=1
				)a 
					INNER JOIN #tempdictators temp on temp.dictatorid =a.dictatorid
					GROUP BY a.dictatorId		
			) AS S ON S.dictatorId=T.dictatorid
			WHEN MATCHED THEN
			  UPDATE SET T.errors=S.ErrorCount
			WHEN NOT MATCHED BY TARGET THEN
				INSERT(dictatorid,errors) 
				VALUES (S.DictatorId,S.ErrorCount); 
   END
   
--for DRAFT REVIEW
Merge #tmpoutput as T
using
(
SELECT j.dictatorid, count(*) draftreview from jobs J
	INNER JOIN jobstatusA JA on j.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN jobstatusgroup JSGA on SCA.statusGroupId = JSGA.id
WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid in (select dictatorid from #tempdictators)
	AND J.RhythmWorkFlowID = 1 -- adding condition to fetch only the Rhythm jobs
	AND JSGA.id = 7
group by J.dictatorid
) as S on T.dictatorid=S.dictatorid
when matched then
update Set T.draftreview=S.draftreview

when not matched by target then
Insert(dictatorid,draftreview) values (S.DictatorId,S.draftreview);
--end DraftReview

 --final Output
 Select 
 
 dictatorid ,
 case when totalinprocess is null then 0 else totalinprocess end as totalinprocess
	,
	case when totalinprocesstoday is null then 0 else totalinprocesstoday end as totalinprocesstoday
	 ,
	 case when delivered is null then 0 else delivered end as delivered 
	,
	case when customerreviewed is null then 0 else customerreviewed end as customerreviewed
	,
	CASE WHEN errors IS NULL THEN 0 ELSE errors END AS errors
	,
	CASE WHEN draftreview IS NULL THEN 0 ELSE draftreview END AS draftreview
	  from #tmpoutput t
--tempta.totalinprocess desc
END

GO
