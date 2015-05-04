
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/29/2014
	Version: 1.0
	Details: Archives EditorLogs table on Entrada_Archive database.
	Tecnical Details:  The script involves two different databases.  Tables that have prefix EA_ reside on archive database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped INTO SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source AND archive databases.
	
	Revised Date: 1/28/2015
	Revised By: Mikayil Bayramov.
	Revision Details: 1) To improve the perfomance the "DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @archiveAge" segment was replaced with the "GETDATE() - @archiveAge >= js.StatusDate" one.
	                     Since StatusDate is indexed field, wrapping it into conversion fuction blocks index to be accesed. 
					  2) Removed WITH (NOLOCK) SQL key word. See reason here: http://stackoverflow.com/questions/686724/sql-server-when-should-you-use-with-nolock
	Revision Version: 1.1
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_ArchiveEditorLogs]
AS 
SET XACT_ABORT ON 
BEGIN  
	--Use distributed transaction since we are cross referencing multiple databases	     
	BEGIN DISTRIBUTED TRANSACTION [Archiving Editor Logs] 
		BEGIN TRY
			DECLARE @archiveAge AS INT,
					@policyID AS INT, 
					@archiveID AS INT = 0
					
			--Get policy parameters	
			SELECT @archiveAge = ArchiveAge, @policyID = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'EditorLogs' AND IsActive = 1
 
			--Begin process only if there is a data to archive.	  
			IF EXISTS(SELECT TOP 1 1 FROM dbo.EditorLogs WHERE GETDATE() - @archiveAge >= OperationTime) BEGIN
				--Create archive log for EditorLogs policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyID, @archiveAge, GETDATE())
				
				--Get created archiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				--Archive
				INSERT INTO dbo.EA_EditorLogs (EditorLogId, EditorID, OperationTime, OperationName, JobNumber, SuccessFlag, ExceptionMessage, SessionID, ArchiveID)
				SELECT el.EditorLogId, el.EditorID, el.OperationTime, el.OperationName, el.JobNumber, el.SuccessFlag, el.ExceptionMessage, el.SessionID, @archiveID
				FROM dbo.EditorLogs AS el
				WHERE GETDATE() - @archiveAge >= OperationTime

				--Remove archived records from source database/table
				DELETE FROM dbo.EditorLogs
				WHERE GETDATE() - @archiveAge >= OperationTime
				
				--Set policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END	
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Editor Logs] 

			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Editor Logs] 
END
GO
