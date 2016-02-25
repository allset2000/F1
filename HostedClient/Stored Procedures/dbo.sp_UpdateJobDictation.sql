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
