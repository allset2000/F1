SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/29/2014
	Version: 1.0
	Details: Deletes data from archived AuditLogExpressLinkApi, AuditLogDictateApi and AuditLogAdminConsoleApi tables on Entrada_Archive database based on purge policy.
	Technical Details: The script involves two different databases.  Tables that have prefix EN_ reside on source database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped into SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source and archive databases.

	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_PurgeArchivedAuditLog]
AS
SET XACT_ABORT ON
BEGIN	
	--Use distributed transaction since we are cross referencing multiple databases		
	BEGIN DISTRIBUTED TRANSACTION [Purge Archived Audit Log]
		BEGIN TRY	
			DECLARE @purgeAge AS INT,
			        @policyID AS INT,
			        @purgeID AS INT = 0,
					@count AS INT = 0,
					@skip AS INT = 0,
					@take AS INT = 0
					
		    --Get policy purge age
			SELECT @purgeAge = PurgeAge,  @policyID = PolicyID
			FROM dbo.ArchivePolicy
			WHERE PolicyName = 'AuditLog' AND IsActive = 1

			IF OBJECT_ID('tempdb..#PurgedAuditLogExpressLinkApi') IS NOT NULL DROP TABLE #PurgedAuditLogExpressLinkApi
			CREATE TABLE #PurgedAuditLogExpressLinkApi (
				ID INT IDENTITY (1, 1) NOT NULL,
				LogId VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_LogId ON #PurgedAuditLogExpressLinkApi (LogId)

			IF OBJECT_ID('tempdb..#PurgedAuditLogDictateApi') IS NOT NULL DROP TABLE #PurgedAuditLogDictateApi
			CREATE TABLE #PurgedAuditLogDictateApi (
				ID INT IDENTITY (1, 1) NOT NULL,
				LogId VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_LogId ON #PurgedAuditLogDictateApi (LogId)

			IF OBJECT_ID('tempdb..#PurgedAuditLogAdminConsoleApi') IS NOT NULL DROP TABLE #PurgedAuditLogAdminConsoleApi
			CREATE TABLE #PurgedAuditLogAdminConsoleApi (
				ID INT IDENTITY (1, 1) NOT NULL,
				LogId VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_LogId ON #PurgedAuditLogAdminConsoleApi (LogId)

			INSERT INTO #PurgedAuditLogExpressLinkApi
			SELECT DISTINCT LogId 
			FROM dbo.AuditLogExpressLinkApi 
			WHERE GETDATE() - @purgeAge >= OperationTime

			INSERT INTO #PurgedAuditLogDictateApi
			SELECT DISTINCT LogId 
			FROM dbo.AuditLogDictateApi 
			WHERE GETDATE() - @purgeAge >= OperationTime

			INSERT INTO #PurgedAuditLogAdminConsoleApi
			SELECT DISTINCT LogId 
			FROM dbo.AuditLogAdminConsoleApi 
			WHERE GETDATE() - @purgeAge >= OperationTime

			--Begin process only if there is a data to purge.
			IF EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogExpressLinkApi) OR
			   EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogDictateApi) OR 
			   EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogAdminConsoleApi) BEGIN  
				--Create purge log for policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created purgeID
				SELECT @purgeID = SCOPE_IDENTITY() 
				
				IF EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogExpressLinkApi) BEGIN
					--Purge						  
					DELETE FROM dbo.AuditLogExpressLinkApi 
					WHERE GETDATE() - @purgeAge >= OperationTime

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedAuditLogExpressLinkApi) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
		 
						--Create deleted records reference in PurgeData table
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID, 'AuditLogExpressLinkApi', 
							   CAST((SELECT AuditLogExpressLinkApi.LogId FROM #PurgedAuditLogExpressLinkApi AS AuditLogExpressLinkApi WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedAuditLog')) AS XML)		 

						SET @count = @count + 100000
					END			
				END

				IF EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogDictateApi) BEGIN					  
					DELETE FROM dbo.AuditLogDictateApi 
					WHERE GETDATE() - @purgeAge >= OperationTime

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedAuditLogDictateApi) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
		 								 
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID, 'AuditLogDictateApi', 
							   CAST((SELECT AuditLogDictateApi.LogId FROM #PurgedAuditLogDictateApi AS AuditLogDictateApi WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedAuditLog')) AS XML)		 

						SET @count = @count + 100000
					END					
				END

				IF EXISTS(SELECT TOP 1 1 FROM #PurgedAuditLogAdminConsoleApi) BEGIN					  
					DELETE FROM dbo.AuditLogAdminConsoleApi 
					WHERE GETDATE() - @purgeAge >= OperationTime

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedAuditLogAdminConsoleApi) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
		 												 
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID, 'AuditLogAdminConsoleApi', 
						       CAST((SELECT AuditLogAdminConsoleApi.LogId FROM #PurgedAuditLogAdminConsoleApi AS AuditLogAdminConsoleApi WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedAuditLog')) AS XML)		 
						
						SET @count = @count + 100000
					END				
				END

				--Set policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
			IF OBJECT_ID('tempdb..#PurgedAuditLogExpressLinkApi') IS NOT NULL DROP TABLE #PurgedAuditLogExpressLinkApi
			IF OBJECT_ID('tempdb..#PurgedAuditLogDictateApi') IS NOT NULL DROP TABLE #PurgedAuditLogDictateApi
			IF OBJECT_ID('tempdb..#PurgedAuditLogAdminConsoleApi') IS NOT NULL DROP TABLE #PurgedAuditLogAdminConsoleApi
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Purge Archived Audit Log]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Purge Archived Audit Log]
END
GO
