
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spUpdateDictation.sql  
** Name:  spUpdateDictation  
** Desc:  Update the dictation and if status changed then insert into Dictationstracking table 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
** #358 01/18/2016 Santhosh  Deleting jobs which have same encounterid and ruleid after dictation 
** updated 02/25/2016 Raghu dictation trigger logic implemented in this store procedure
*******************************/
  
CREATE PROCEDURE [dbo].[spUpdateDictation]  
(
 @bgintJobID BIGINT,  
 @bgintDictationID  BIGINT,
 @vintDictationTypeID int,
 @vintDictatorID int,
 @vintQueueID int,
 @smintDuration smallint,
 @vvcrMachineName varchar(50),
 @vvcrFileName VARCHAR(255),
 @vvcrClientVersion VARCHAR(100),
 @vvcrChangedBy VARCHAR(20),
 @vintStatus  SMALLINT 
)  
AS  
BEGIN TRY 
	DECLARE @OldDictationStatus INT,
			@OldJobStatus INT,
			@newJobStatus INT
	BEGIN TRANSACTION 
	
	SELECT @OldDictationStatus = status FROM Dictations WHERE DictationID = @bgintDictationID 

	
	UPDATE Dictations SET [FileName] = @vvcrFileName,status=@vintStatus,JobID=@bgintJobID,DictationTypeID=@vintDictationTypeID,DictatorID=@vintDictatorID,
		   QueueID=@vintQueueID,Duration=@smintDuration,MachineName=@vvcrMachineName,UpdatedDateInUTC=GETUTCDATE()
	WHERE DictationID = @bgintDictationID  	
	
	-- Only update if the status changed
	IF (@OldDictationStatus <> @vintStatus)
		INSERT INTO DictationsTracking
		    (DictationID,Status,ChangeDate,ChangedBy)
		VALUES
		    (@bgintDictationID,@vintStatus,GETDATE(),@vvcrChangedBy)


	--begin trigger logic updated in store procedure
			-- Find the lowest status of all a job's dictations
			--SELECT @newJobStatus = [Status] FROM Dictations WHERE JobID = @bgintjobId;

			SELECT @newJobStatus =@vintStatus

			-- If any dictation is Available (100) or OnHold (200), the job should be Available (100)
			-- If all dictations are Deleted (500), the job should be Deleted (500)
			-- If all dictations are Dictated (250), the job should be Completed (300)
			SELECT @newJobStatus =
			   CASE 
				  WHEN @newJobStatus >= 0 AND @newJobStatus < 250 THEN 100 
				  WHEN @newJobStatus >= 500 THEN 500
				  WHEN @newJobStatus = 250 THEN 300 
				  ELSE -1
			   END 

			IF @newJobStatus <>-1 BEGIN

			      	SELECT @OldJobStatus = status FROM Jobs WHERE jobID = @bgintJobID 

					-- We only want to update jobs that are Available (100)
					UPDATE dbo.Jobs 
					SET [Status] = @newJobStatus,UpdatedDateInUTC=GETUTCDATE() 
					WHERE JobID = @bgintjobId AND [Status] in (100,500)

					-- Changing the dictation status may have changed the job status
				-- (via the trigger), so we may need to insert a tracking row
				IF (@OldJobStatus <> @newJobStatus)
					INSERT INTO Jobstracking
						 (JobID,Status,ChangeDate,ChangedBy)
					VALUES
						 (@bgintjobId,@newJobStatus,GETDATE(),@vvcrChangedBy)	

			END	
	
	--end trigger logic

	--This is to delete jobs which have same encounterid and ruleid as this dictated job for NextGen vendor only
	IF(@vintStatus = 250)
	BEGIN
		-- Only for NextGen Vendor
		DECLARE @EHREncounterID VARCHAR(50)
		DECLARE @JobNumber VARCHAR(20)
		DECLARE @RuleId SMALLINT

		SELECT @EHREncounterID = S.EHREncounterID, @JobNumber = J.JobNumber, @RuleId = J.RuleID 
		FROM Dictations D
			INNER JOIN Jobs J ON J.JobID = D.JobID
			INNER JOIN Encounters E ON E.EncounterID = J.EncounterID
			INNER JOIN Schedules S ON S.ScheduleID = E.ScheduleID
			INNER JOIN Clinics C ON C.ClinicID = J.ClinicID AND C.EHRVendorID = 3
			INNER JOIN Rules R ON R.RuleID = J.RuleID AND R.RemoveAppointments = 1
		WHERE D.DictationID = @bgintDictationID		
	
		UPDATE Jobs
		SET Status = 500, UpdatedDateInUTC = GETUTCDATE()
		FROM Jobs J 
			INNER JOIN Dictations D ON D.JobID = J.JobID AND D.Status = 100
			INNER JOIN Clinics C ON C.ClinicID = J.ClinicID AND C.EHRVendorID = 3
			INNER JOIN Encounters E ON E.EncounterID = J.EncounterID
			INNER JOIN Schedules S ON S.ScheduleID = E.ScheduleID AND S.EHREncounterID = @EHREncounterID
		WHERE J.RuleID = @RuleId AND J.JobNumber <> @JobNumber

		UPDATE Dictations
		SET Status = 500, UpdatedDateInUTC = GETUTCDATE()
		FROM Dictations D 
			INNER JOIN Jobs J ON D.JobID = J.JobID AND D.Status = 100
			INNER JOIN Clinics C ON C.ClinicID = J.ClinicID AND C.EHRVendorID = 3
			INNER JOIN Encounters E ON E.EncounterID = J.EncounterID
			INNER JOIN Schedules S ON S.ScheduleID = E.ScheduleID AND S.EHREncounterID = @EHREncounterID
		WHERE J.RuleID = @RuleId AND J.JobNumber <> @JobNumber
		-- Only for NextGen Vendor
	END
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

  
GO
