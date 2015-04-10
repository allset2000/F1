
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
	
	Revised Date: 4/10/2015
	Revised By: Sam Shoultz
	Revision Details: Removed check for PatientId / Clinic - Mobile needs this data populated regardless of clinic / patient / user access / membership.  This should always validat / check / populate
*/
CREATE PROCEDURE [dbo].[sp_CreateUpdatePatientDataAccess] (
	@MessageThreadID INT,
	@MessageThreadOwnerID INT,
	@PatientID INT,
    @UserID INT,
	@PermissionCode INT
)
AS
SET XACT_ABORT ON
BEGIN
	BEGIN TRANSACTION CreateUpdatePatientDataAccess
		BEGIN TRY
			DECLARE @PatientDataAccessID AS INT = -1,
					@PreviousPermissionCode AS INT = -1,
					@CreateUpdateDate AS DATETIME = GETDATE(),
					@PatientDataAccessPermissionID AS INT,
					@PreviousPatientDataAccessPermissionID AS INT

			--Get PatientDataAccessPermissionID 
			SELECT @PatientDataAccessPermissionID  = PatientDataAccessPermissionID 
			FROM [dbo].[PatientDataAccessPermissions]
			WHERE PermissionCode = @PermissionCode

			--Get PatientDataAccessID per MessageThreadID and user id
			SELECT @PatientDataAccessID = PatientDataAccessID
			FROM [dbo].[PatientDataAccess]
			WHERE MessageThreadID = @MessageThreadID AND UserID = @UserID 

			--Check if the permission record for this thread/user is found
			IF (SELECT @PatientDataAccessID) != -1  BEGIN
				--Collect the previous PermissionCode and PatientDataAccessPermissionID values. We will need it, later.
				SELECT @PreviousPermissionCode = pdap.PermissionCode, @PreviousPatientDataAccessPermissionID = pda.PatientDataAccessPermissionID 
				FROM [dbo].[PatientDataAccessPermissions] AS pdap INNER JOIN [dbo].[PatientDataAccess] AS pda ON pda.PatientDataAccessPermissionID = pdap.PatientDataAccessPermissionID
				WHERE pda.PatientDataAccessID = @PatientDataAccessID

				--If the patient info sharing was changed for the current user, 
				--then copy this record from [dbo].[PatientDataAccess] to [dbo].[PatientDataAccessHistory]
				IF (SELECT @PermissionCode) != (SELECT @PreviousPermissionCode)BEGIN
					INSERT INTO [dbo].[PatientDataAccessHistory] (PatientDataAccessID, MessageThreadID, UserID, PatientDataAccessPermissionID, CreatedDate, UpdatedDate)
					SELECT PatientDataAccessID, MessageThreadID, UserID, @PreviousPatientDataAccessPermissionID, CreatedDate, @CreateUpdateDate
					FROM [dbo].[PatientDataAccess]
					WHERE PatientDataAccessID = @PatientDataAccessID

					--Then update the record
					UPDATE [dbo].[PatientDataAccess]
					SET PatientDataAccessPermissionID = @PatientDataAccessPermissionID,
						UpdatedDate = @CreateUpdateDate
					WHERE PatientDataAccessID = @PatientDataAccessID
				END
			END
			ELSE BEGIN
				--Else, insert new one     
				INSERT INTO [dbo].[PatientDataAccess] (MessageThreadID, UserID, PatientDataAccessPermissionID, CreatedDate, UpdatedDate)
				VALUES (@MessageThreadID, @UserID, @PatientDataAccessPermissionID, @CreateUpdateDate, NULL)

				--Reload @PatientDataAccessID
				SELECT @PatientDataAccessID = PatientDataAccessID
				FROM [dbo].[PatientDataAccess]
				WHERE MessageThreadID = @MessageThreadID AND UserID = @UserID 
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
