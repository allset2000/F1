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
	
	@dictatirid varchar(500),
	@orderbyclause varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



--set statistics io ON
--Calculate jobs prior threemonths
declare @advancedate as date
select @advancedate=DateAdd(month,-3,getdate()) 

select Cast(sp.splitdata as varchar(500))as dictatorid into #tempdictators  from dbo.fnSplitString(@dictatirid,',') sp 

IF OBJECT_ID('tempdb..#alljobs') IS NOT NULL
drop table #alljobs
select  jobnumber ,dictatorid into #alljobs from jobs where Cast (dictationdate as date) between Cast (@advancedate as date) and Cast(getdate() as date) and dictatorid in(select dictatorid from #tempdictators)

IF OBJECT_ID('tempdb..#tmpjobstatusA') IS NOT NULL
drop table #tmpjobstatusA
select JBA.Jobnumber as JobA,JBB.Jobnumber as JobB,JBA.status as statusA,JBA.Statusdate as statusdate,AJ.dictatorid,SC.statusgroupid into #tmpjobstatusA from JobstatusA JBA

inner join StatusCodes SC on SC.statusId=JBA.status
inner join #alljobs AJ on AJ.Jobnumber=JBA.Jobnumber
left join JobstatusB JBB on JBB.Jobnumber=AJ.Jobnumber
where SC.statusgroupid in(1,3,4,5)                       


select 
tempta.dictatorid as clientuserid,
case 
when tempta.totalinprocess is null then 0
else tempta.totalinprocess end as totalinprocess,
case 
when temptb.totalinprocesstoday is null then 0
else temptb.totalinprocesstoday end as totalinprocesstoday,
case 
when temptc.delivered is null then 0
else temptc.delivered end as delivered,
case 
when temptd.customerreview is null then 0
else temptd.customerreview end as customerreviewed



from(select  
 count(JobA)  as totalinprocess,
dictatorid from #tmpjobstatusA ta
where statusgroupid=1
group by dictatorid) as tempta left join
(select  
 count(JobA)  as totalinprocesstoday,
dictatorid from #tmpjobstatusA ta
where statusgroupid=1 and Cast(statusdate as Date)=cast(getdate() as date)
group by dictatorid)as temptb
  left join
(select  
 count(JobA)+count(JobB)  as delivered,
dictatorid from #tmpjobstatusA ta
where statusgroupid=5 and Cast(statusdate as Date)=cast(getdate() as date)
group by dictatorid) as temptc left join 

(select  
 count(JobB)  as customerreview,
dictatorid from #tmpjobstatusA ta
where statusgroupid in(2,3)
group by dictatorid) as temptd

on temptd.dictatorid=temptc.dictatorid
on temptb.dictatorid=temptc.dictatorid
on tempta.dictatorid=temptd.dictatorid
order by 
case
when @orderbyclause ='inp 1' then tempta.totalinprocess else ''end asc,
case
when @orderbyclause ='inp 0' then tempta.totalinprocess else '' end desc,
case
when @orderbyclause ='inptd 1' then temptb.totalinprocesstoday else ''end asc,
case
when @orderbyclause ='inptd 0' then temptb.totalinprocesstoday else '' end desc,
case
when @orderbyclause ='delivered 1' then temptc.delivered else ''end asc,
case
when @orderbyclause ='delivered 0' then temptc.delivered else '' end desc,
case
when @orderbyclause ='cr 1' then temptd.customerreview else ''end asc,
case
when @orderbyclause ='cr 0' then temptd.customerreview else '' end desc,
case
when @orderbyclause ='dictator 1' then tempta.dictatorid else ''end asc,
case
when @orderbyclause ='dictator 0' then tempta.dictatorid else '' end desc


--tempta.totalinprocess desc






END

--exec proc_fetchdashboardactivity '13,227,160,223,104','inp 0'

--exec proc_fetchdashboardactivity_update 'NXGmwelby,NXGtsuess	,NXGbnelson,	NXGlmathers,	NXGmmann	,NXGjjordan,	NXGjgoodby,	NXGsedwards	,NXGmabbate,	NXGmcardwell,	NXGvlat'	,'inp 0'


