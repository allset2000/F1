
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 02/21/2015
	Version: 1.0
	Details: Disables message thread per povidded thread id and thread owner id.
	         Then revokes all users under the current message thread patient info sharing permissions.
			 NOTE! Users that have been previously revoked permissions, and filtered out from the process (they've already been denied permissions, so what is the point). 
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script was changed?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_DisableMessageThread] (
	@ThreadID VARCHAR(100),
    @ThreadOwnerID INT
)
AS
SET XACT_ABORT ON
BEGIN
	BEGIN TRANSACTION DisableMessageThread
		BEGIN TRY
			DECLARE @MessageThreadID AS INT,
			        @UpdateDate AS DATETIME = GETDATE(),
					@RevokedPemissionID AS INT = (SELECT PatientDataAccessPermissionID FROM [dbo].[PatientDataAccessPermissions] WHERE PermissionCode = 0)

			--Get message thread id per thread id and thread owner id
			SELECT @MessageThreadID = MessageThreadID
			FROM [dbo].[MessageThreads] 
			WHERE ThreadID = @ThreadID AND
				  ThreadOwnerID = @ThreadOwnerID

			IF (SELECT @MessageThreadID) IS NOT NULL BEGIN
				--First, disable the message thread.
				UPDATE [dbo].[MessageThreads] 
				SET IsActive= 0,
					UpdatedDate = @UpdateDate
				WHERE MessageThreadID = @MessageThreadID

				--Then revoke all user permissions for the current message thread.
				--But before, get all PatientDataAccessID that are about to be updated, for later actions.
				SELECT PatientDataAccessID
				INTO #Temp
				FROM [dbo].[PatientDataAccess] 
				WHERE MessageThreadID = 3 AND 
				      PatientDataAccessPermissionID != @RevokedPemissionID

				UPDATE [dbo].[PatientDataAccess]
				SET PatientDataAccessPermissionID = @RevokedPemissionID,
					UpdatedDate = @UpdateDate
				WHERE PatientDataAccessID IN (SELECT PatientDataAccessID FROM #Temp)

				--Finaly, copy all revoked user permision records of the current message thread to [dbo].[PatientDataAccessHistory]
				--NOTE! Do it only for users that previously been granted premission
				INSERT INTO [dbo].[PatientDataAccessHistory] (PatientDataAccessID, MessageThreadID, UserID, PatientDataAccessPermissionID, CreatedDate, PermitionRevokedDate)
				SELECT PatientDataAccessID, MessageThreadID, UserID, @RevokedPemissionID, CreatedDate, @UpdateDate
				FROM [dbo].[PatientDataAccess]
				WHERE MessageThreadID = @MessageThreadID AND 
				      PatientDataAccessID IN (SELECT PatientDataAccessID FROM #Temp)
			END 
		END TRY
		BEGIN CATCH
		    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION DisableMessageThread
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
				 
			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION DisableMessageThread
END
GO
