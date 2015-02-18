
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
	
	Revised Date: 1/29/2015
	Revised By: Mikayil Bayramov.
	Revision Details: 1) To improve the perfomance the "DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @purgeAge" segment was replaced with the "GETDATE() - @purgeAge >= js.StatusDate" one.
	                     Since StatusDate is indexed field, wrapping it into conversion fuction blocks index to be accesed. 
					  2) Added handling for large xml log files
	Revision Version: 1.1

	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
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
			        @purgeID AS INT = 0,
					@count AS INT = 0,
					@skip AS INT = 0,
					@take AS INT = 0
					
		    --Get policy purge age
			SELECT @purgeAge = PurgeAge, @policyID = PolicyID
			FROM dbo.ArchivePolicy
			WHERE PolicyName = 'EditorLogs' AND IsActive = 1

			IF OBJECT_ID('tempdb..#PurgedEditorLogs') IS NOT NULL DROP TABLE #PurgedEditorLogs
			CREATE TABLE #PurgedEditorLogs (
				ID INT IDENTITY (1, 1) NOT NULL,
				EditorLogId VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_EditorLogId ON #PurgedEditorLogs (EditorLogId)

			INSERT INTO #PurgedEditorLogs
			SELECT DISTINCT EditorLogId
			FROM dbo.EditorLogs WHERE GETDATE() - @purgeAge >= OperationTime

			--Begin process only if there is a data to purge.
			IF EXISTS (SELECT TOP 1 1 FROM #PurgedEditorLogs) BEGIN
				--Create purge log for policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created purgeID
				SELECT @purgeID = SCOPE_IDENTITY() 

				--Purge						  
				DELETE el FROM dbo.EditorLogs AS el INNER JOIN #PurgedEditorLogs AS pel ON el.EditorLogId = pel.EditorLogId
				WHERE GETDATE() - @purgeAge >= OperationTime

				SET @count = 0
				WHILE @count <= (SELECT MAX(ID) FROM #PurgedEditorLogs) BEGIN
					SELECT @skip = @count + 1,  @take = @count + 100000

					--Create deleted records reference in PurgeData table
					INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
					SELECT @purgeID, 'EditorLogs', 
						  CAST((SELECT EditorLog.EditorLogId FROM #PurgedEditorLogs AS EditorLog WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedEditorLogs')) AS XML)	
				
					SET @count = @count + 100000
				END
						   
				--Set policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
			IF OBJECT_ID('tempdb..#PurgedEditorLogs') IS NOT NULL DROP TABLE #PurgedEditorLogs
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
