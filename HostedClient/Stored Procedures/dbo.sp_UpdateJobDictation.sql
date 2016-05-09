
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 2/24/2016
-- Description: update dictation status after upload used for new upload method 
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateJobDictation]
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

		IF (@OldDictationStatus <> @vintStatus)
		INSERT INTO DictationsTracking
		    (DictationID,Status,ChangeDate,ChangedBy)
		VALUES
		    (@bgintDictationID,@vintStatus,GETDATE(),@vvcrChangedBy)

	
	--This is to delete jobs which have same encounterid and ruleid as this dictated job for NextGen vendor only
	IF(@vintStatus = 250)
	BEGIN
		-- Only for NextGen Vendor
		DECLARE @EHREncounterID VARCHAR(50)
		DECLARE @JobNumber VARCHAR(20)
		DECLARE @RuleId SMALLINT
		DECLARE @RemoveAppointments bit=0

		SELECT @EHREncounterID = S.EHREncounterID, @JobNumber = J.JobNumber, @RuleId = J.RuleID, @RemoveAppointments=1 
		FROM Dictations D
			INNER JOIN Jobs J ON J.JobID = D.JobID
			INNER JOIN Encounters E ON E.EncounterID = J.EncounterID
			INNER JOIN Schedules S ON S.ScheduleID = E.ScheduleID
			INNER JOIN Clinics C ON C.ClinicID = J.ClinicID AND C.EHRVendorID = 3
			INNER JOIN Rules R ON R.RuleID = J.RuleID AND R.RemoveAppointments = 1
		WHERE D.DictationID = @bgintDictationID		
	
		if @RemoveAppointments=1 
		BEGIN
			--temp tables to store JobIds and DictationIDs to be deleted 		
			DECLARE @JobstoDelete AS TABLE (JOBID BIGINT, DICTATIONID BIGINT)
			
			INSERT INTO @JobstoDelete (JOBID, DICTATIONID)
			SELECT J.JobID, D.DictationID 
			FROM Jobs J 
				INNER JOIN Dictations D ON D.JobID = J.JobID AND D.Status = 100
				INNER JOIN Clinics C ON C.ClinicID = J.ClinicID AND C.EHRVendorID = 3
				INNER JOIN Encounters E ON E.EncounterID = J.EncounterID
				INNER JOIN Schedules S ON S.ScheduleID = E.ScheduleID AND S.EHREncounterID = @EHREncounterID
			WHERE J.RuleID = @RuleId AND J.JobNumber <> @JobNumber

			UPDATE Jobs
			SET Status = 500, UpdatedDateInUTC = GETUTCDATE()
			FROM Jobs J 
				INNER JOIN @JobstoDelete JT ON J.JobID = JT.JobID 

			INSERT INTO JobsTracking (JobID, Status, Changedate, ChangedBy) 
			SELECT JobID, 500, GETUTCDATE(), 'LinkedAppt' FROM @JobstoDelete

			UPDATE Dictations
			SET Status = 500, UpdatedDateInUTC = GETUTCDATE()
			FROM Dictations D INNER JOIN @JobstoDelete JT ON D.DictationID = JT.DictationID

			INSERT INTO DictationsTracking (DictationID, Status, Changedate, ChangedBy) 
			SELECT DictationID, 500, GETUTCDATE(), 'LinkedAppt' FROM @JobstoDelete
			-- Only for NextGen Vendor
		END
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
