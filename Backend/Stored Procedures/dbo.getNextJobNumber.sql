SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getNextJobNumber] (
   @JobDate smalldatetime
) AS
	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
			
		DECLARE @searchDate smalldatetime
		DECLARE @nextJobNumber int
				
		SET @searchDate = DATEADD(dd, DATEDIFF(dd, 0, @JobDate), 0);

		WHILE (1 = 1)

        BEGIN 	-- while BEGIN			
			--INCREMENTS JobNumbers.[NumJobs] field for the given JobDate 
			IF EXISTS(SELECT 1 FROM [dbo].[JobNumbers] WHERE (JobDate = @searchDate))
				BEGIN
					UPDATE [dbo].[JobNumbers]
					SET @nextJobNumber = NumJobs = ISNULL(NumJobs, 0) + 1
					WHERE (JobDate = @searchDate)
				END
			ELSE 
				BEGIN
					SET @nextJobNumber = 1
					INSERT INTO [dbo].[JobNumbers]
							([JobDate],[NumJobs])
					VALUES
						(@searchDate, @nextJobNumber)
		        END
	
			--BUILDS the actual job number and checks if it exists in Jobs table.
			DECLARE @fullJobNumber varchar(16)
			   	   	   
			SET @fullJobNumber = CONVERT(varchar(8), @searchDate, 112) + RIGHT('00000000'+ CONVERT(varchar, @nextJobNumber), 8)
		
			IF NOT EXISTS( SELECT 1 FROM [dbo].[Jobs] WHERE (JobNumber = @fullJobNumber) )
				-- if there are not any jobs with the gererated job number, then exit the loop and return the number
				BREAK
			ELSE
				-- if there are a job with the gererated job number, then log an exception and continue with the next job number (loop again)
				BEGIN
					DECLARE @userName varchar(50)
					DECLARE @errorMsg varchar(128)

					SET @userName = 'DB-' + user;
					SET @errorMsg = 'Wrong sequence of job numbers for date ' + CONVERT(varchar(8), @searchDate, 112) + '.';
					SET @errorMsg = @errorMsg + 'Job number ' + @fullJobNumber + ' already exists. The stored procedure will try to get the next jobNumber.';

					INSERT INTO [dbo].[EditorLogs]
					    ([EditorID] ,[OperationTime] ,[OperationName] ,[JobNumber] ,[SuccessFlag] ,[ExceptionMessage],[SessionID])
					VALUES
					    ('SQLSERVER', GETDATE(), 'SQL.getNextJobNumber', @fullJobNumber, 0, @errorMsg, 'Unknown: TSQL-Generated');

					CONTINUE

				END
		 END   -- while END
	     
		 SELECT @nextJobNumber

		 COMMIT TRANSACTION
		 
		END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
			ROLLBACK TRANSACTION
							DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
							SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		   END
	END CATCH
	RETURN
RETURN
GO
GRANT EXECUTE ON  [dbo].[getNextJobNumber] TO [app_JobCreator]
GO
