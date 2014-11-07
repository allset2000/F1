SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/29/2014
	Version: 1.0
	Details: Deletes data from archived EditorLogs table on Entrada_Archive database based on purge policy.
	Technical Details: The script involves two different databases.  Tables that have prefix EN_ reside on source database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped into SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source and archive databases.
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script was changed?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_PurgeArchivedEditorLogs]
AS
SET XACT_ABORT ON
BEGIN	
	--Use distributed transaction since we are cross referencing multiple databases		
	BEGIN DISTRIBUTED TRANSACTION [Purge Archived Editor Logs]
		BEGIN TRY	
			DECLARE @purgeAge AS INT,
			        @policyID AS INT,
			        @purgeID AS INT = 0
					
		    --Get policy purge age for editor logs
			SELECT @purgeAge = PurgeAge, 
			       @policyID = PolicyID
			FROM dbo.ArchivePolicy
			WHERE PolicyName = 'EditorLogs' AND 
				  IsActive = 1

			--Begin process only if there is a data to purge.
			IF EXISTS (SELECT TOP 1 1 FROM dbo.EditorLogs WHERE DATEDIFF(DAY, OperationTime, GETDATE()) >= @purgeAge)
			BEGIN
				--Create purge log for EditorLogs policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created PurgeID
				SELECT @purgeID = SCOPE_IDENTITY() 
				
				--Purge						  
				DELETE FROM dbo.EditorLogs 
				WHERE DATEDIFF(DAY, OperationTime, GETDATE()) >= @purgeAge
								 
				--Create deleted records reference in PurgeData table
				INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
				SELECT @purgeID, 
				      'EditorLogs', 
				      CAST((SELECT EditorLog.EditorLogId 
				            FROM dbo.EditorLogs AS EditorLog 
				            WHERE DATEDIFF(DAY, OperationTime, GETDATE()) >= @purgeAge 
				            FOR XML AUTO, ROOT('PurgedEditorLogs')
				          ) AS XML)	
						  
				--Set EditorLogs policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Purge Archived Editor Logs]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Purge Archived Editor Logs]
END
GO
