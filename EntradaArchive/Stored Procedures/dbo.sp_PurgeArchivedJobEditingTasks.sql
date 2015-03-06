SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/24/2014
	Version: 1.0
	Details: Deletes archived JobEditingTasks, JobEditingTasksData and JobEditingSummary tables on Entrada_Archive database based on purge policy.
	Tecnical Details:  The script involves two different databases. Tables that have prefix EN_ reside on source database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped into SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source and archive databases.

	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_PurgeArchivedJobEditingTasks]
AS
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	
	BEGIN DISTRIBUTED TRANSACTION [Purge Archived Job Editing Tasks]
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
			        @purgeAge AS INT,
			        @policyID AS INT,
			        @purgeID AS INT = 0,
					@count AS INT = 0,
					@skip AS INT = 0,
					@take AS INT = 0
			
			SELECT @purgeAge = PurgeAge, @policyId = PolicyID
			FROM dbo.ArchivePolicy
			WHERE PolicyName = 'JobEditingTasks' AND IsActive = 1

			IF OBJECT_ID('tempdb..#PurgedJobEditingTasks') IS NOT NULL DROP TABLE #PurgedJobEditingTasks
			CREATE TABLE #PurgedJobEditingTasks (
				ID INT IDENTITY (1, 1) NOT NULL,
				JobNumber VARCHAR(50) NOT NULL,
				JobId INT NOT NULL, 
				JobEditingTaskId INT NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobEditingTasks (JobNumber, JobId, JobEditingTaskId)

			IF OBJECT_ID('tempdb..#PurgedJobEditingTasksData') IS NOT NULL DROP TABLE #PurgedJobEditingTasksData
			CREATE TABLE #PurgedJobEditingTasksData (
				ID INT IDENTITY (1, 1) NOT NULL,
				JobEditingTaskId INT NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobEditingTasksData (JobEditingTaskId)

			IF OBJECT_ID('tempdb..#PurgedJobEditingSummary') IS NOT NULL DROP TABLE #PurgedJobEditingSummary
			CREATE TABLE #PurgedJobEditingSummary (
				ID INT IDENTITY (1, 1) NOT NULL,
				JobNumber VARCHAR(50) NOT NULL,
				JobId INT NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobEditingSummary (JobNumber, JobId)

			--Get records to be purged
			INSERT INTO #PurgedJobEditingTasks
			SELECT DISTINCT j.JobNumber, j.JobId, jet.JobEditingTaskId 			
			FROM dbo.JobEditingTasks AS jet INNER JOIN dbo.EN_Jobs AS j ON jet.JobId = j.JobId 
										    INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			INSERT INTO #PurgedJobEditingTasksData
			SELECT DISTINCT pjetd.JobEditingTaskId		
			FROM dbo.JobEditingTasksData AS jetd INNER JOIN #PurgedJobEditingTasks AS pjetd ON jetd.JobEditingTaskId = pjetd.JobEditingTaskId 

			INSERT INTO #PurgedJobEditingSummary
			SELECT DISTINCT j.JobNumber, j.JobId		
			FROM dbo.JobEditingSummary AS jes INNER JOIN dbo.EN_Jobs AS j ON  jes.JobId = j.JobId
									          INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			--Begin process only if there is a data.
			IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingTasks) OR
			   EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingTasksData) OR 
			   EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingSummary)  BEGIN
				--Create purge log for policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created purgeID
				SELECT @purgeID = SCOPE_IDENTITY() 
				
				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingTasks) BEGIN				
					--Purge archived records						  
					DELETE jet FROM dbo.JobEditingTasks AS jet INNER JOIN #PurgedJobEditingTasks AS pjet ON jet.JobId = pjet.JobId AND jet.JobEditingTaskId = pjet.JobEditingTaskId  
					
					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobEditingTasks) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000

						--Create deleted records reference in PurgeData table
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID, 'JobEditingTasks', 
							   CAST((SELECT Job.JobNumber, Job.JobEditingTaskId FROM #PurgedJobEditingTasks AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
					
					--Update archive details 
					--Update only those jobs that match archived in this transaction ones
					UPDATE jad
					SET jad.JobEditingTasksPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobEditingTasks AS pjet ON jad.JobNumber = pjet.JobNumber
					WHERE jad.JobEditingTasksPurgedOn IS NULL
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingTasksData) BEGIN									  
					DELETE jetd FROM dbo.JobEditingTasksData AS jetd INNER JOIN #PurgedJobEditingTasksData AS pjetd ON jetd.JobEditingTaskId = pjetd.JobEditingTaskId
					
					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobEditingTasksData) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000

						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'JobEditingTasksData', CAST((SELECT Job.JobEditingTaskId FROM #PurgedJobEditingTasksData AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END

					--We do not update archive details here, since JobEditingTasksData is a child table of JobEditingTasks, which is processed and logged at the previous steps. 
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobEditingSummary) BEGIN									  
					DELETE jes FROM dbo.JobEditingSummary AS jes INNER JOIN #PurgedJobEditingSummary AS pjes ON jes.JobId = pjes.JobId

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobEditingTasksData) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
				
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'JobEditingTasksData', CAST((SELECT Job.JobNumber, Job.JobId FROM #PurgedJobEditingSummary AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)
					
						SET @count = @count + 100000
					END
					
					UPDATE jad
					SET jad.JobEditingTasksPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobEditingSummary AS pjes ON jad.JobNumber = pjes.JobNumber
					WHERE jad.JobEditingTasksPurgedOn IS NULL
				END

				--Set policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
			--Clean up
			IF OBJECT_ID('tempdb..#PurgedJobEditingTasks')  IS NOT NULL DROP TABLE #PurgedJobEditingTasks
			IF OBJECT_ID('tempdb..#PurgedJobEditingTasksData')  IS NOT NULL DROP TABLE #PurgedJobEditingTasksData
			IF OBJECT_ID('tempdb..#PurgedJobEditingSummary')  IS NOT NULL DROP TABLE #PurgedJobEditingSummary
		END TRY
		BEGIN CATCH
		    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Purge Archived Job Editing Tasks]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
				 
			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Purge Archived Job Editing Tasks]
END
GO
