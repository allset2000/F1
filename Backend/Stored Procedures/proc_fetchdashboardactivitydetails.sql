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
@statusgroupname varchar(25) ,
 @PageNumber AS INT,
	@RowspPage AS INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	declare	@totalcount as int 



	  --for All Inprocess
if(@statusgroupname='Inprocess')
  begin
  WITH TotalInprocess_cte AS (
    SELECT J.jobnumber
   from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=1
)

SELECT  j.JobNumber, J.DictatorId, J.JobType,
case 
when J.IsGenericJob is not null and IsGenericJob=1 then 'Y' else 'N' end DeviceGenerated,

J.AppointmentDate, 'Inprocess :' + Convert(varchar,
(select  top 1  JT.StatusDate from Jobtracking JT
	INNER JOIN statuscodes SC on JT.Status=SC.StatusID
	where SC.statusgroupid=1 and JT.JobNumber= J.Jobnumber 
	),100)InProcessWithDate , 
	JP.MRN,
Concat(JP.Firstname,' ',JP.MI,' ',JP.LastName) Patient,

TotalInprocess.totalcount as TotalCount

	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	Cross join
	(SELECT Count(*) AS totalcount FROM TotalInprocess_cte ) AS TotalInprocess
WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=1
	order by  j.JobNumber
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY

end



 -- InProcess Today
  if(@statusgroupname='InprocessToday')
  begin
  WITH TotalInprocessToday_cte AS (
    SELECT J.jobnumber
   	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber

WHERE 
	DATEDIFF(d, J.receivedon, getdate()) =0
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=1
)

 
 SELECT j.JobNumber, J.DictatorId, J.JobType,
case 
when J.IsGenericJob is not null and IsGenericJob=1 then 'Y' else 'N' end DeviceGenerated,

J.AppointmentDate, 'Inprocess :' + Convert(varchar,
(select  top 1  JT.StatusDate from Jobtracking JT
	INNER JOIN statuscodes SC on JT.Status=SC.StatusID
	where SC.statusgroupid=1 and JT.JobNumber= J.Jobnumber 
	),100)InProcessWithDate , 
	JP.MRN,
Concat(JP.Firstname,' ',JP.MI,' ',JP.LastName) Patient,
TotalInprocessToday.totalcount as TotalCount


	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	Cross join
	(SELECT Count(*) AS totalcount FROM TotalInprocessToday_cte ) AS TotalInprocessToday
WHERE 
	DATEDIFF(d, J.receivedon, getdate()) =0
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=1
	order by j.JobNumber
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end





 	-- CustomerReview
	 if(@statusgroupname='CustomerReview')
	 begin
	 WITH CustomerReview_cte as
	 (
	  Select J.Jobnumber
	 	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	
WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=2
	 )
	 	
SELECT j.JobNumber, J.DictatorId, J.JobType,
case 
when J.IsGenericJob is not null and IsGenericJob=1 then 'Y' else 'N' end DeviceGenerated,

J.AppointmentDate, 'Inprocess :' + Convert(varchar,
(select  top 1  JT.StatusDate from Jobtracking JT
	INNER JOIN statuscodes SC on JT.Status=SC.StatusID
	where SC.statusgroupid=1 and JT.JobNumber= J.Jobnumber 
	),100)InProcessWithDate , 
	'Customer Review: '+Convert(varchar,(select top 1  JT.StatusDate as JobStatusDate from Jobtracking JT
	INNER JOIN statuscodes SC on JT.Status=SC.StatusID
	where SC.statusgroupid=2 and JT.JobNumber= J.Jobnumber 
	 ),100)JobStatus ,
	JP.MRN,
Concat(JP.Firstname,' ',JP.MI,' ',JP.LastName) Patient,

	CustomerReview.totalcount as Totalcount
	
	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	cross join(Select count(*) as totalcount from CustomerReview_cte) as CustomerReview
WHERE 
	DATEDIFF(d, J.receivedon, getdate())<= 90 
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=2
		order by j.JobNumber
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end
 -- For delivered
  if(@statusgroupname='DeliveredToday')
  begin
  WITH DeliveredToday_cte as
  (
  Select J.jobnumber
	 from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	INNER JOIN JobDeliveryHistory JDH ON J.jobnumber = JDH.jobnumber
WHERE 
	DATEDIFF(d, JDH.DeliveredOn, getdate())=0
	AND J.dictatorid =@dictatorid
	AND SCA.statusgroupid=1
  )
  

SELECT j.JobNumber, J.DictatorId, J.JobType,
case 
when J.IsGenericJob is not null and IsGenericJob=1 then 'Y' else 'N' end DeviceGenerated,

J.AppointmentDate, 'Inprocess :' + Convert(varchar,
(select  top 1  JT.StatusDate from Jobtracking JT
	INNER JOIN statuscodes SC on JT.Status=SC.StatusID
	where SC.statusgroupid=1 and JT.JobNumber= J.Jobnumber 
	),100)InProcessWithDate , 'Delivered :'+Convert(varchar,JDH.DeliveredOn,100) as JObStatus,
	JP.MRN,
Concat(JP.Firstname,' ',JP.MI,' ',JP.LastName) Patient,

 DeliveredToday.totalcount as TotalCount

	from jobs J
	INNER JOIN jobstatusA JA on J.jobnumber = JA.JobNumber
	INNER JOIN statuscodes SCA on JA.status = SCA.StatusID
	INNER JOIN Jobs_Patients JP on J.Jobnumber=JP.Jobnumber
	INNER JOIN JobDeliveryHistory JDH ON J.jobnumber = JDH.jobnumber
	cross join(Select count(*) as totalcount from DeliveredToday_cte) as DeliveredToday
WHERE 
	DATEDIFF(d, JDH.DeliveredOn, getdate())=0
	AND J.dictatorid =@dictatorid 
	AND SCA.statusgroupid=1
	order by j.JobNumber
OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
FETCH NEXT @RowspPage ROWS ONLY
end



END

--declare @totalcount as int
--exec proc_fetchdashboardactivitydetails 'nxgmcardwell','inp',1,10

--select @totalcount 