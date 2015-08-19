USE [Entrada]
GO
/****** Object:  StoredProcedure [dbo].[proc_fetchdashboardactivitydetails]    Script Date: 8/17/2015 11:58:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		EntradaDev
-- =============================================
CREATE PROCEDURE [dbo].[proc_fetchdashboardactivitydetails]
	
 @dictatorid as varchar(150),
 @Jobtype varchar(25),
 @PageNumber AS INT,
	@RowspPage AS INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare	@totalcount as int 
	declare @advancedate as date


select @advancedate=DateAdd(month,-3,getdate()) 

IF OBJECT_ID('tempdb..#alljobs') IS NOT NULL
drop table #alljobs
select  

jobs.jobnumber ,dictatorid,jobtype,appointmentdate , JP.MRN, Concat(JP.Firstname,' ',JP.MI,' ',JP.LastName) patient,
case 
when IsGenericJob is not null and IsGenericJob=1 then 'Y'
when IsGenericJob is  null and IsGenericJob=0 then 'N'
else 'N' end  devicegenerated
into #alljobs from jobs
inner join jobs_patients JP on JP.jobnumber=jobs.jobnumber
 where Cast (dictationdate as date) between Cast (@advancedate as date) and Cast(getdate() as date) and dictatorid =@dictatorid--'nxgmcardwell'



-- get all In process jobs fortoday 

if(@Jobtype='inptd')
begin
select @totalcount = count(JT.JobNumber)

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where (JT.status >=100 and JT.status <=235) and Cast(JT.statusdate as date)=Cast(getdate() as date)

select ROW_NUMBER() OVER (ORDER BY JT.jobnumber ASC) AS jobId, JT.JobNumber,AJ.dictatorid,AJ.jobtype, AJ.devicegenerated,AJ.appointmentdate,AJ.MRN,AJ.Patient,
case
when StatusDate is not null then  'Inprocess :'+CONVERT(varchar, StatusDate, 100)
else '' end statusdate,
case
when StatusDate is not null then  'Inprocess :'+CONVERT(varchar, StatusDate, 100)
else '' end jobstatus

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where (JT.status >=100 and JT.status <=235) and Cast(JT.statusdate as date)=Cast(getdate() as date)
order by JobId 
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end
if(@Jobtype='delivered')
begin
select @totalcount = count(JT.JobNumber)

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where  JT.status =360

select ROW_NUMBER() OVER (ORDER BY JT.jobnumber ASC) AS jobId, JT.JobNumber,AJ.dictatorid,AJ.jobtype, AJ.devicegenerated,AJ.appointmentdate,AJ.MRN,AJ.Patient,
case
when StatusDate is not null then  'Delivered :'+CONVERT(varchar, StatusDate, 100)
else '' end statusdate,
case
when StatusDate is not null then  'Delivered :'+CONVERT(varchar, StatusDate, 100)
else '' end jobstatus

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where  JT.status =360
order by JobId
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end
-- get all customer Review jobs 
if(@Jobtype='cr')
begin

select @totalcount = count(JT.JobNumber)

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where  JT.status =250 or JT.status=240

select ROW_NUMBER() OVER (ORDER BY JT.jobnumber ASC) AS jobId, JT.JobNumber,AJ.dictatorid,AJ.jobtype, AJ.devicegenerated,AJ.appointmentdate,AJ.MRN,AJ.Patient,
case
when StatusDate is not null then  'Customer Reviewed :'+CONVERT(varchar, StatusDate, 100)
else '' end statusdate,
case
when StatusDate is not null then  'Customer Reviewed :'+CONVERT(varchar, StatusDate, 100)
else '' end jobstatus

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where  JT.status =250 or JT.status=240
order by JobId
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end
-- get all inprocess jobs 
if(@Jobtype='inp')
begin
select @totalcount = count(JT.JobNumber)

 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where JT.status >=100 and JT.status <=235

select ROW_NUMBER() OVER (ORDER BY JT.jobnumber ASC) AS jobId, JT.JobNumber,AJ.dictatorid,AJ.jobtype, AJ.devicegenerated,AJ.appointmentdate,AJ.MRN,AJ.Patient,
case
when StatusDate is not null then  'Inprocess :'+CONVERT(varchar, StatusDate, 100)
else '' end statusdate,
case
when StatusDate is not null then  'Inprocess :'+CONVERT(varchar, StatusDate, 100)
else '' end jobstatus,
case 
when @totalcount is not null then @totalcount
else 0 end totalcount
 from jobtracking JT
inner join  #alljobs AJ on AJ.JobNumber=JT.JobNumber
where JT.status >=100 and JT.status <=235
order by JobId
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end





END

--declare @totalcount as int
--exec proc_fetchdashboardactivitydetails 'nxgmcardwell','inp',1,10

--select @totalcount 