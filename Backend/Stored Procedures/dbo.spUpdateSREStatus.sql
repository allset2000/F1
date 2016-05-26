
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************      
** File:  spUpdateSREStatus.sql      
** Name:  spUpdateSREStatus      
** Desc:  Update the job status and add the record to jobtracking table      
** Auth:  Suresh      
** Date:  27/Mar/2015      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/
CREATE PROCEDURE [dbo].[spUpdateSREStatus]  
(  
 @vvcrJobNumber VARCHAR(20),  
 @vsintStatus SMALLINT,  
 @vvcrPath  VARCHAR(255),
 @vvcrRecServer VARCHAR(50),
 @vintCharacterCount INT = null  
)  
AS  
BEGIN TRANSACTION  
	BEGIN TRY
		UPDATE  jobStatusA SET [Status] = @vsintStatus, StatusDate = GETDATE(), [Path] = @vvcrPath  
		WHERE JobNumber = @vvcrJobNumber  

		INSERT INTO JobTracking  
		VALUES (@vvcrJobNumber,@vsintStatus,GETDATE(),@vvcrPath )  

		UPDATE jobs SET jobstatus=@vsintStatus,JobStatusDate=GETDATE() WHERE jobnumber=@vvcrJobNumber
		
		-- update the status into hosted db.
		EXEC spUpdateBackendStatusAndDateIntoHosted @vvcrJobNumber,@vsintStatus

        IF @vsintStatus <> 130  
			BEGIN 
				UPDATE jobs SET IsLockedForProcessing=0 WHERE jobNumber=@vvcrJobNumber  
			END	

		IF @vsintStatus =140 OR @vsintStatus = 136 OR @vsintStatus = 275
			BEGIN 
				UPDATE dbo.Jobs SET ProcessFailureCount=0,RecServer=@vvcrRecServer,CharacterCountFromSRE=@vintCharacterCount WHERE JobNumber=@vvcrJobNumber
			END	

		IF @vsintStatus = 136 OR @vsintStatus = 275
			BEGIN
				-- if job has no previous history then we need to add a new entry in Job_history
				IF NOT EXISTS(SELECT 1 FROM [Entrada].dbo.Job_History WHERE JobNumber=@vvcrJobNumber)
					BEGIN
						INSERT INTO [Entrada].dbo.Job_History (JobNumber,MRN,JobType,CurrentStatus,HistoryDateTime,FirstName,MI,LastName,DOB,IsHistory,AppointmentDate)
							SELECT J.Jobnumber,JP.MRN,J.JobType, 110, GETDATE(),JP.FirstName, JP.MI, JP.LastName, JP.DOB, 1, J.AppointmentDate + J.AppointmentTime  AS AppointmentDate 
							FROM [Entrada].dbo.Jobs J INNER JOIN [Entrada].dbo.Jobs_Patients JP ON J.JobNumber = JP.JobNumber WHERE J.JobNumber = @vvcrJobNumber
					END
				INSERT INTO job_history(jobnumber,CurrentStatus,HistoryDateTime,IsHistory)
				VALUES(@vvcrJobNumber,@vsintStatus,GETDATE(),1)
			END
		COMMIT
	END TRY
BEGIN CATCH
	-- Rollback the transaction  
    ROLLBACK  
    -- Raise an error and return  
    RAISERROR ('Error in Insert or Update Status.', 16, 1)  
    RETURN  
END CATCH
GO
