SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 02/20/2015
	Version: 1.0
	Details: Sets patient info sharing permissions in message thread per provided user. 
	         Returns updated/created PatientDataAccessID
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_CreateUpdatePatientDataAccess] (
	@ThreadID VARCHAR(100),
    @ThreadOwnerID INT,
    @UserID INT,
	@IsPermited BIT
)
AS
SET XACT_ABORT ON
BEGIN
	BEGIN TRANSACTION CreateUpdatePatientDataAccess
		BEGIN TRY
			DECLARE @MessageThreadID AS INT,
					@PatientDataAccessID AS INT,
					@IsPermitedHistory AS BIT,
					@RecordAccessDate AS DATETIME = GETDATE()

			--Get parent id per thread id and thread owner id
			SELECT @MessageThreadID = MessageThreadID
			FROM [dbo].[MessageThreads] 
			WHERE ThreadID = @ThreadID AND
				  ThreadOwnerID = @ThreadOwnerID

			--Get child id per parent id and user id
			SELECT @PatientDataAccessID = PatientDataAccessID
			FROM [dbo].[PatientDataAccess]
			WHERE MessageThreadID = @MessageThreadID AND 
				  UserID = @UserID 

			--Check if the permission record for this thread/user is found
			IF (SELECT @PatientDataAccessID) IS NOT NULL BEGIN
				--Collect the previous IsPermited value. We will need it, later.
				SELECT @IsPermitedHistory = IsPermited
				FROM [dbo].[PatientDataAccess]
				WHERE PatientDataAccessID = @PatientDataAccessID

				--If found then update the record
				UPDATE [dbo].[PatientDataAccess]
				SET IsPermited= @IsPermited,
					UpdatedDate = @RecordAccessDate
				WHERE PatientDataAccessID = @PatientDataAccessID AND 
				      IsPermited != @IsPermited
			END
			ELSE BEGIN
				--Else, insert new one     
				INSERT INTO [dbo].[PatientDataAccess] (MessageThreadID, UserID, IsPermited, CreatedDate, UpdatedDate)
				VALUES (@MessageThreadID, @UserID, @IsPermited, @RecordAccessDate, NULL)

				--Reload @PatientDataAccessID
				SELECT @PatientDataAccessID = PatientDataAccessID
				FROM [dbo].[PatientDataAccess]
				WHERE MessageThreadID = @MessageThreadID AND 
					  UserID = @UserID 
			END

			--If the patient info sharing was revoked for the current user (provided @IsPermited value is 0), 
			--then copy this record from [dbo].[PatientDataAccess] to [dbo].[PatientDataAccessHistory]
			--NOTE!  do it only for users that previous been granted premission or new users premissions
			IF (SELECT @IsPermited) = 0 AND ((SELECT @IsPermitedHistory) = 1 OR (SELECT @IsPermitedHistory) IS NULL) BEGIN
				INSERT INTO [dbo].[PatientDataAccessHistory] (PatientDataAccessID, MessageThreadID, UserID, IsPermited, CreatedDate, PermitionRevokedDate)
				SELECT PatientDataAccessID, MessageThreadID, UserID, IsPermited, CreatedDate, @RecordAccessDate
				FROM [dbo].[PatientDataAccess]
				WHERE PatientDataAccessID = @PatientDataAccessID
			END

			SELECT @PatientDataAccessID
		END TRY
		BEGIN CATCH
		    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION CreateUpdatePatientDataAccess
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
				 
			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION CreateUpdatePatientDataAccess
END
GO
