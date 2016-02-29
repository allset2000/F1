
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 01/27/2016
-- Description:	This SP will return WorkList for selected search filter
--EXEC sp_GetWorklistSearchReport @clinicID=353,@PageNo=1,@SortColumnFromGrid='Patient',@SortTypeFromGrid='Descending',@PageSize=10,@QueueID=3671
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWorklistSearchReport] 
@clinicID smallint,
@PageNo smallint,
@SortColumnFromGrid varchar(50)= null,
@SortTypeFromGrid   varchar(50)= null,
@PageSize smallint,
@QueueID INT=null,
@JobType BIGINT = null,
@Status SMALLINT = null,
@From datetime = null,
@To datetime = null,
@MRN varchar(50) = null,
@FirstName varchar(100) = null,
@LastName varchar(100) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

		 DECLARE @Sql NVarchar(max)=''	
   BEGIN TRY

	 IF (@SortTypeFromGrid='Descending')
		   BEGIN
			  SET @SortTypeFromGrid='DESC'	   
		   END
		ELSE
		   BEGIN
			  SET @SortTypeFromGrid='ASC'
		   END   
		SELECT @SortColumnFromGrid = CASE WHEN @SortColumnFromGrid='DictatorId' THEN 'DictatorId'
								WHEN  @SortColumnFromGrid='Patient' THEN 'Patient'
								WHEN @SortColumnFromGrid='JobType' THEN 'JobType'
								WHEN @SortColumnFromGrid='Queue' THEN 'Queue'
								WHEN @SortColumnFromGrid='Appointment' THEN 'Appointment'
								WHEN @SortColumnFromGrid='Status' THEN 'Status'
								WHEN @SortColumnFromGrid='ChangedBy' THEN 'ChangedBy'
								ELSE 'Patient' END

								
	 SET @Sql=';WITH Worklist_CTE AS ( 
				     				SELECT 
	
		Q.Name AS Queue,
		JobTypes.Name AS JobType,
		(P.MRN + '' - '' + P.FirstName + '' '' + P.LastName) AS Patient,
		E.AppointmentDate AS Appointment,
		DT.ChangedBy AS ChangedBy,
		J.Status AS Status, COUNT(*) OVER() as TotalCount
			FROM Jobs J 
				INNER JOIN JobTypes ON J.JobTypeID = JobTypes.JobTypeID 
				INNER JOIN Encounters E ON J.EncounterID = E.EncounterID 
				INNER JOIN Patients P ON E.PatientID = P.PatientID 
				LEFT JOIN (SELECT D.JobID,D.DictationID,D.DictatorID,D.QueueID FROM Dictations D 
							INNER JOIN DictationTypes DT ON D.DictationTypeID = DT.DictationTypeID ) D ON D.JobID = J.JobId    
				LEFT JOIN (Select DictationID,Status,MAX(ChangeDate) AS MAX_ChangeDate,ChangedBy FROM DictationsTracking GROUP BY DictationID,Status,ChangedBy) DT ON D.DictationID = DT.DictationID AND J.Status = DT.Status
				LEFT JOIN Queues Q ON D.QueueID = Q.QueueID 
				LEFT JOIN Dictators DI ON D.DictatorID = DI.DictatorID
			WHERE J.Status IN(100,500) AND J.ClinicID = ' +CAST(@clinicID AS VARCHAR)
			
			 
				IF(@QueueID IS NOT NULL)
					SET @sql += ' AND D.QueueID = ' + CAST(@QueueID AS VARCHAR)
				IF(@JobType IS NOT NULL)
					SET @sql += ' AND J.JobTypeID = ' + CAST(@JobType AS VARCHAR)
				IF(@Status IS NOT NULL)
					SET @sql += ' AND J.Status = ' + +CAST(@Status AS VARCHAR)
				IF(@from IS NOT NULL)
					SET @sql += ' AND Convert(Date,E.AppointmentDate) >= CAST('''+ CAST(@from AS VARCHAR) +''' AS DATE)'
				IF(@To IS NOT NULL)
					SET @sql += ' AND Convert(Date,E.AppointmentDate) <=  CAST(''' +CAST( @To AS VARCHAR) +''' AS DATE)'
				IF(@MRN IS NOT NULL)
					SET @sql += ' AND P.MRN = ' + @MRN
				IF(@FirstName IS NOT NULL)
					SET @sql += ' AND P.FirstName like ''%' + @FirstName +'%'''
				IF(@LastName IS NOT NULL)
					SET @sql += ' AND P.LastName like ''%' + @LastName +'%'''

				SET @sql += ')'

					SET @Sql=@Sql+' SELECT  Queue,JobType,Patient,Appointment,
						CASE WHEN ChangedBy NOT LIKE ''%[^0-9]%'' THEN (SELECT DictatorName FROM Dictators WHERE DictatorID = ChangedBy) WHEN ChangedBy = ''HL7'' THEN ''Interface'' WHEN ChangedBy NOT LIKE ''[^0-9]%'' THEN ''Entrada'' ELSE ChangedBy END ChangedBy, 
						CASE WHEN Status is not null and Status = 100 THEN ''Available'' when status =500 then ''Deleted'' ELSE ''Unknown'' END Status,
						TotalCount
						 
						FROM 
							(SELECT ROW_NUMBER() OVER(ORDER BY '+@SortColumnFromGrid +' '+@SortTypeFromGrid+') as RowNumber,  
									   CTE.*
								FROM Worklist_CTE AS CTE
								)A
							ORDER BY RowNumber 
							OFFSET (('+CAST(@PageNo AS VARCHAR)+'  - 1) * '+CAST(@PageSize AS VARCHAR) +' ) ROWS
							FETCH NEXT '+CAST(@PageSize AS VARCHAR)+' ROWS ONLY  ' 
			   EXEC (@Sql)

	END TRY
	BEGIN CATCH
	    
		    DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())


		INSERT INTO [EntradaLogs].dbo.LogExceptions
				   (LogConfigurationID,ErrorThrownAtMethodName,ExceptionMessage,StackTrace,ErrorCreatedDate)
		   SELECT LogConfigurationID,'sp_GetWorklistSearchReport',@errorMessage,@Sql,GETDATE() FROM [EntradaLogs].dbo.LogConfiguration 
		   WHERE ApplicationCode='CUSTOMER_PORTAL_UI'
			


	END CATCH

END
GO
