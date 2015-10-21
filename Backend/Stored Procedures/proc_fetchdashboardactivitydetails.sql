/****** Object:  StoredProcedure [dbo].[proc_fetchdashboardactivitydetails]    Script Date: 10/21/2015 20:58:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<A Raghu>
-- Create date: <12-10-2015>
-- Description:	<Description,,>
-- =============================================
--exec [proc_fetchdashboardactivitydetails] 'tscsmukkamala', 'DeliveredToday',1,10,'JobStatus','Ascending'
ALTER PROCEDURE [dbo].[proc_fetchdashboardactivitydetails]
	
	 @dictatorid  varchar(150),
	 @statusgroupname varchar(25) ,
	 @PageNumber  INT,
	 @RowspPage  INT,
	 @SortBy Varchar(50),
	 @SortType  Varchar(10)
	

AS
BEGIN
   	-- SET NOCOUNT ON added to prevent extra result sets from
    SET NOCOUNT ON;

		DECLARE @Sql NVarchar(max)=''	
		DECLARE @SortColumn Varchar(50)=''		 

  BEGIN	TRY
		 IF (@SortType='Descending')
		   BEGIN
			  SET @SortType='DESC'	   
		   END
		ELSE
		   BEGIN
			  SET @SortType='ASC'
		   END   
  
		SELECT @SortColumn=CASE WHEN @SortBy='DictatorId' THEN 'DictatorId'
								WHEN @SortBy='JobType' THEN 'JobType'	
								WHEN @SortBy='DeviceGenerated' THEN 'DeviceGenerated'
								WHEN @SortBy='FormatedAppointmentDate' THEN 'AppointmentDate'
								WHEN @SortBy='InProcessWithDate' THEN 'InProcessWithDate'
								WHEN @SortBy='JobStatus' THEN 'JobStatus'
								WHEN @SortBy='MRN' THEN 'MRN'
								WHEN @SortBy='AwaitingDelivery' THEN 'AwaitingDelivery'
								WHEN @SortBy='Patient' THEN 'Patient'
								ELSE 'jobnumber' END

			IF(@statusgroupname IN ('Inprocess','InprocessToday'))
					BEGIN
					   SET @Sql=';WITH DashBoardDetails_CTE AS ( 
				     				SELECT 
												j.JobNumber, J.DictatorId, J.JobType, J.Stat, 
												CASE WHEN J.IsGenericJob IS NOT NULL AND IsGenericJob=1 THEN ''Y'' ELSE ''N'' end DeviceGenerated, 			  
												J.AppointmentDate,
												IPD.StatusDate AS InProcessWithDate ,  
												IPD.StatusDate AS JobStatus ,   
												JP.MRN,  
												CONCAT(JP.Firstname,'' '',JP.MI,'' '',JP.LastName) Patient,
												AD.AwaitingDelivery,
												COUNT(*) OVER()  as TotalCount												
										 FROM jobs J WITH(NOLOCK)   
										 INNER JOIN jobstatusA JA WITH(NOLOCK) on J.jobnumber = JA.JobNumber  
										 INNER JOIN statuscodes SCA WITH(NOLOCK)  on JA.status = SCA.StatusID  
										 INNER JOIN Jobs_Patients JP WITH(NOLOCK)  on J.Jobnumber=JP.Jobnumber			
										 INNER JOIN (
														SELECT  JT.JobNumber,SC.StatusID ,MIN(JT.StatusDate) AS StatusDate
													   FROM Jobtracking JT WITH(NOLOCK)   
													   INNER JOIN statuscodes SC WITH(NOLOCK)  ON JT.Status=SC.StatusID  
													   WHERE SC.statusgroupid=1 --AND SCA.StatusID=JT.Status
													   GROUP BY JT.JobNumber,SC.StatusID
													) AS IPD 
													ON  IPD.JobNumber= J.Jobnumber  AND IPD.StatusID=SCA.StatusID     
										 LEFT JOIN (
														SELECT  JT.JobNumber ,MIN(JT.StatusDate) AS AwaitingDelivery
															 FROM Jobtracking JT WITH(NOLOCK)
															 INNER JOIN statuscodes SC ON JT.status=SC.statusid
															 WHERE SC.StatusGroupId=4
															 GROUP BY JT.JobNumber
													) AS AD ON  AD.JobNumber= J.Jobnumber
										WHERE 1=1 '
									IF(@statusgroupname='Inprocess')	   
										SET @Sql=@Sql+'AND DATEDIFF(d, J.receivedon, getdate())<= 90'
									  ELSE
										SET @Sql=@Sql+'AND DATEDIFF(d, J.receivedon, getdate()) =0'				  
						  
									SET @Sql=@Sql+' AND J.dictatorid ='''+@dictatorid+''' 
									
										) 					
				
									'
								
					END
		 				-- CustomerReview
			ELSE IF(@statusgroupname='CustomerReview')
					BEGIN
					   SET @Sql=';WITH DashBoardDetails_CTE AS ( 				     		
										 SELECT j.JobNumber, J.DictatorId, J.JobType,J.Stat,
												CASE WHEN J.IsGenericJob IS NOT NULL AND IsGenericJob=1 THEN ''Y'' ELSE ''N'' END DeviceGenerated,
												J.AppointmentDate,												
												IPD.StatusDate AS InProcessWithDate , 
												JSD.JobStatusDate AS JobStatus,												
												JP.MRN,
												CONCAT(JP.Firstname,'' '',JP.MI,'' '',JP.LastName) Patient,
												AD.AwaitingDelivery,
												COUNT(*) OVER()  as TotalCount
											FROM jobs J WITH(NOLOCK) 
											INNER JOIN jobstatusA JA WITH(NOLOCK)  on J.jobnumber = JA.JobNumber
											INNER JOIN statuscodes SCA WITH(NOLOCK)  on JA.status = SCA.StatusID
											INNER JOIN Jobs_Patients JP WITH(NOLOCK)  on J.Jobnumber=JP.Jobnumber
											INNER JOIN (
															SELECT  JT.JobNumber,MIN(JT.StatusDate) AS StatusDate
															FROM Jobtracking JT WITH(NOLOCK)    
															INNER JOIN statuscodes SC WITH(NOLOCK)  ON JT.Status=SC.StatusID  
															WHERE SC.statusgroupid=1 
															GROUP BY JT.JobNumber
														) AS IPD ON  IPD.JobNumber= J.Jobnumber
											INNER JOIN (
															SELECT  JT.JobNumber,MIN(JT.StatusDate) AS JobStatusDate
															FROM Jobtracking JT  
															INNER JOIN statuscodes SC ON JT.Status=SC.StatusID  
															WHERE SC.statusgroupid=2 
															GROUP BY JT.JobNumber
														) AS JSD ON  JSD.JobNumber= J.Jobnumber
										      	
											 LEFT JOIN (
															SELECT  JT.JobNumber ,MAX(JT.StatusDate) AS AwaitingDelivery
															 FROM Jobtracking JT WITH(NOLOCK)
															 INNER JOIN statuscodes SC ON JT.status=SC.statusid
															 WHERE SC.StatusGroupId=4
															 GROUP BY JT.JobNumber
														) AS AD ON  AD.JobNumber= J.Jobnumber								
										WHERE  DATEDIFF(d, J.receivedon, GETDATE())<= 90 
											AND J.dictatorid ='''+@dictatorid+'''
											AND SCA.statusgroupid=2
									
										) 					
				
									'
								
					
					END
			  ELSE --(@statusgroupname='DeliveredToday') -- Delivered Today does not need any join with other tables Only JobDeliveryHistory should be enough Bug 3430
				  BEGIN			
					   SET @Sql=';WITH DashBoardDetails_CTE AS ( 
				     			
													
		SELECT j.JobNumber, J.DictatorId, J.JobType,J.Stat,
												 CASE WHEN J.IsGenericJob IS NOT NULL AND IsGenericJob=1 THEN ''Y'' ELSE ''N'' END DeviceGenerated,
												   J.AppointmentDate, 
												    IPD.StatusDate AS InProcessWithDate , 
												    JDH.DeliveredOn AS JObStatus,
													JP.MRN,
													CONCAT(JP.Firstname,'' '',JP.MI,'' '',JP.LastName) Patient,
												    AD.AwaitingDelivery,
													COUNT(*) OVER()  as TotalCount
												FROM jobs J WITH(NOLOCK) 
												--INNER JOIN jobstatusA JA WITH(NOLOCK)  on J.jobnumber = JA.JobNumber
												INNER JOIN statuscodes SCA WITH(NOLOCK)  on J.JobStatus = SCA.StatusID
												INNER JOIN Jobs_Patients JP WITH(NOLOCK)  on J.Jobnumber=JP.Jobnumber
												INNER JOIN JobDeliveryHistory JDH WITH(NOLOCK)  ON J.jobnumber = JDH.jobnumber
												INNER JOIN (
																SELECT  JT.JobNumber,MIN(JT.StatusDate) AS StatusDate
																FROM Jobtracking JT WITH(NOLOCK)    
																INNER JOIN statuscodes SC WITH(NOLOCK)  ON JT.Status=SC.StatusID  
																GROUP BY JT.JobNumber
															) AS IPD ON  IPD.JobNumber= J.Jobnumber 
											     LEFT JOIN (
															SELECT  JT.JobNumber ,MIN(JT.StatusDate) AS AwaitingDelivery
															 FROM Jobtracking JT WITH(NOLOCK)
															 INNER JOIN statuscodes SC ON JT.status=SC.statusid
															 WHERE SC.StatusGroupId=4
															 GROUP BY JT.JobNumber
														) AS AD ON  AD.JobNumber= J.Jobnumber	
											WHERE 
												DATEDIFF(d, JDH.DeliveredOn, getdate())=0
												AND J.dictatorid ='''+@dictatorid+'''
								  
										) 					
				
									'

										print @Sql
				END



      		SET @Sql=@Sql+'SELECT A.JobNumber, A.DictatorId, A.JobType, A.DeviceGenerated, A.AppointmentDate,
								  ''In Process: '' + Convert(varchar,InProcessWithDate,100) AS InProcessWithDate,
								  (CASE WHEN '''+@statusgroupname+'''=''DeliveredToday'' THEN ''Delivered: ''
									   WHEN '''+@statusgroupname+'''=''CustomerReview'' THEN ''Customer Review: ''
									   ELSE ''In Process: '' END) +Convert(varchar,A.JObStatus,100) AS JObStatus,A.Stat,
								A.MRN, A.Patient,
								CASE WHEN ISNULL(AwaitingDelivery,'''')='''' THEN '''' ELSE ''Editing Complete: ''+ Convert(varchar,AwaitingDelivery,100) END AS AwaitingDelivery, 
								A.TotalCount 
							FROM
								(SELECT ROW_NUMBER() OVER(ORDER BY '+@SortColumn +' '+@SortType+') as RowNumber,  
									   CTE.*
								FROM DashBoardDetails_CTE AS CTE
								)A
							ORDER BY RowNumber 
							OFFSET (('+CAST(@PageNumber AS VARCHAR)+'  - 1) * '+CAST(@RowspPage AS VARCHAR) +' ) ROWS
							FETCH NEXT '+CAST(@RowspPage AS VARCHAR)+' ROWS ONLY
    
						
						  '

			
				EXEC (@Sql)

	END TRY
	BEGIN CATCH
	    
		    DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())


		INSERT INTO EH_LogExceptions
				   (LogConfigurationID,ErrorThrownAtMethodName,ExceptionMessage,StackTrace,ErrorCreatedDate)
		   VALUES  
					(19,'proc_fetchdashboardactivitydetails',@errorMessage,@Sql,GETDATE())
			


	END CATCH

END




