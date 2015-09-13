USE [Entrada]
GO
/****** Object:  StoredProcedure [dbo].[proc_fetchdashboardactivity_update]    Script Date: 8/17/2015 11:38:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		EntradaDev
-- =============================================
CREATE PROCEDURE [dbo].[proc_fetchdashboardactivity]
	
             @dictatirid varchar(5000)
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
	customerreviewed int null
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
	  from #tmpoutput t


--tempta.totalinprocess desc






END




