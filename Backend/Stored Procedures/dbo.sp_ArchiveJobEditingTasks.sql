
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 01/28/2015
	Version: 1.0
	Details: Archives Job Editing Tasks, Job Editing Tasks Data and Job Editing Summary tables on Entrada_Archive database.
	Tecnical Details:  The script involves two different databases. Tables that have prefix EA_ reside on Archive database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped INTO SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source AND archive databases.
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_ArchiveJobEditingTasks]
AS 
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	 	       
	BEGIN DISTRIBUTED TRANSACTION [Archiving Job Editing Tasks] 
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
					@archiveAge AS INT,
					@policyId AS INT,
					@archiveID AS INT = 0
					
			--Get policy parameters	
			SELECT @archiveAge = ArchiveAge, @policyId = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'JobEditingTasks' AND IsActive = 1

			IF OBJECT_ID('tempdb..#ArchivedJobEditingTasks') IS NOT NULL DROP TABLE #ArchivedJobEditingTasks
			CREATE TABLE #ArchivedJobEditingTasks (
				JobNumber VARCHAR(50) NOT NULL,
				JobId INT NOT NULL, 
				JobEditingTaskId INT NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobEditingTasks (JobNumber, JobId, JobEditingTaskId)

			IF OBJECT_ID('tempdb..#ArchivedJobEditingTasksData') IS NOT NULL DROP TABLE #ArchivedJobEditingTasksData
			CREATE TABLE #ArchivedJobEditingTasksData (JobEditingTaskId INT NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobEditingTasksData (JobEditingTaskId)

			IF OBJECT_ID('tempdb..#ArchivedJobEditingSummary') IS NOT NULL DROP TABLE #ArchivedJobEditingSummary
			CREATE TABLE #ArchivedJobEditingSummary (
				JobNumber VARCHAR(50) NOT NULL,
				JobId INT NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobEditingSummary (JobNumber, JobId)

			--Get records to be archived
			--Make sure we do not get previously archived jobs.
			INSERT INTO #ArchivedJobEditingTasks
			SELECT DISTINCT j.JobNumber, j.JobId, jet.JobEditingTaskId 
			FROM dbo.Jobs AS j INNER JOIN dbo.JobEditingTasks AS jet ON j.JobId = jet.JobId
							   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_JobEditingTasks AS ejet ON j.JobId = ejet.JobId 
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND ejet.JobId IS NULL
			
			INSERT INTO #ArchivedJobEditingTasksData
			SELECT DISTINCT jetd.JobEditingTaskId 
			FROM dbo.JobEditingTasksData AS jetd INNER JOIN #ArchivedJobEditingTasks AS ajet ON jetd.JobEditingTaskId = ajet.JobEditingTaskId

			INSERT INTO #ArchivedJobEditingSummary
			SELECT DISTINCT j.JobNumber, j.JobId 
			FROM dbo.Jobs AS j INNER JOIN dbo.JobEditingSummary AS jes ON j.JobId = jes.JobId
							   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_JobEditingSummary AS ejes ON j.Jobid = ejes.Jobid 
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND  ejes.Jobid IS NULL

			--Begin process only if there is a data.
			IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobEditingTasks) OR 
			   EXISTS (SELECT TOP 1 1 FROM #ArchivedJobEditingTasksData) OR 
			   EXISTS (SELECT TOP 1 1 FROM #ArchivedJobEditingSummary)  BEGIN
				--Create archive log for policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyId, @archiveAge, GETDATE())
				
				--Get created archiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobEditingTasks) BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_JobEditingTasks (JobEditingTaskId, JobId, AssignedToID, EditionNote, QACategoryId, CurrentStateId, NextStateId, WorkflowRuleId, AssignmentMode, AssignedById, ReleasedById, AssignedOn, ReceivedOn, ReturnedOn, PreviousTaskId, NextTaskId, TaskStatus, ArchiveID)
					SELECT jet.JobEditingTaskId, jet.JobId, jet.AssignedToID, jet.EditionNote, jet.QACategoryId, jet.CurrentStateId, jet.NextStateId, jet.WorkflowRuleId, jet.AssignmentMode, jet.AssignedById, jet.ReleasedById, jet.AssignedOn, jet.ReceivedOn, jet.ReturnedOn, jet.PreviousTaskId, jet.NextTaskId, jet.TaskStatus, @archiveID
					FROM dbo.JobEditingTasks AS jet INNER JOIN #ArchivedJobEditingTasks AS ajet ON jet.JobId = ajet.JobId AND jet.JobEditingTaskId = ajet.JobEditingTaskId

					--Remove archived records from source database/tables
					DELETE jet FROM dbo.JobEditingTasks AS jet INNER JOIN #ArchivedJobEditingTasks AS ajet ON jet.JobId = ajet.JobId AND jet.JobEditingTaskId = ajet.JobEditingTaskId
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobEditingTasksData) BEGIN
					INSERT INTO dbo.EA_JobEditingTasksData (JobEditingTaskId, NumPages, NumLines, NumChars, NumVBC, NumCharsPC, BodyWSpaces, HeaderFirstWSpaces, HeaderPrimaryWSpaces, HeaderEvenWSpaces, FooterFirstWSpaces, FooterPrimaryWSpaces, FooterEvenWSpaces, HeaderTotalWSpaces, FooterTotalWSpaces, HeaderFooterTotalWSpaces, DocumentWSpaces, NumTotalMacros, NumMacrosUnEdited, NumMacrosEdited, NumCharsUnEditedMacros, NumCharsEditedMacros, NumCharsChangedMacros, ArchiveID)
					SELECT jetd.JobEditingTaskId, jetd.NumPages, jetd.NumLines, jetd.NumChars, jetd.NumVBC, jetd.NumCharsPC, jetd.BodyWSpaces, jetd.HeaderFirstWSpaces, jetd.HeaderPrimaryWSpaces, jetd.HeaderEvenWSpaces, jetd.FooterFirstWSpaces, jetd.FooterPrimaryWSpaces, jetd.FooterEvenWSpaces, jetd.HeaderTotalWSpaces, jetd.FooterTotalWSpaces, jetd.HeaderFooterTotalWSpaces, jetd.DocumentWSpaces, jetd.NumTotalMacros, jetd.NumMacrosUnEdited, jetd.NumMacrosEdited, jetd.NumCharsUnEditedMacros, jetd.NumCharsEditedMacros, jetd.NumCharsChangedMacros, @archiveID
					FROM dbo.JobEditingTasksData AS jetd INNER JOIN #ArchivedJobEditingTasksData AS ajetd ON jetd.JobEditingTaskId = ajetd.JobEditingTaskId
					
					DELETE jetd FROM dbo.JobEditingTasksData AS jetd INNER JOIN #ArchivedJobEditingTasksData AS ajetd ON jetd.JobEditingTaskId = ajetd.JobEditingTaskId
				END

				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobEditingSummary) BEGIN
					INSERT INTO dbo.EA_JobEditingSummary (JobId, LastEditedByID, CurrentlyEditedByID, LastQAEditorID, CurrentStateId, CurrentQAStage, LastQAStage, AssignedToID, QACategoryId, LastQANote, QAEditorsList, FinishedOn, EditorEditingTaskId, LastEditingTaskId, LastQAEditingTaskId, BillingEditingTaskId, ArchiveID)
					SELECT jes.JobId, jes.LastEditedByID, jes.CurrentlyEditedByID, jes.LastQAEditorID, jes.CurrentStateId, jes.CurrentQAStage, jes.LastQAStage, jes.AssignedToID, jes.QACategoryId, jes.LastQANote, jes.QAEditorsList, jes.FinishedOn, jes.EditorEditingTaskId, jes.LastEditingTaskId, jes.LastQAEditingTaskId, jes.BillingEditingTaskId, @archiveID
					FROM dbo.JobEditingSummary AS jes INNER JOIN #ArchivedJobEditingSummary AS ajes ON jes.JobId = ajes.JobId
					
					DELETE jes FROM dbo.JobEditingSummary AS jes INNER JOIN #ArchivedJobEditingSummary AS ajes ON jes.JobId = ajes.JobId
				END
				
				--Create list of archived jobs
				IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
				SELECT DISTINCT a.JobNumber INTO #ArchivedJobs
				FROM (SELECT JobNumber FROM #ArchivedJobEditingTasks UNION ALL SELECT JobNumber FROM #ArchivedJobEditingSummary) AS a
				      
				--Log archive details
				INSERT INTO dbo.Jobs_ArchiveDetails (JobNumber, JobEditingTasksArchivedOn)
				SELECT a.JobNumber, GETDATE()
				FROM #ArchivedJobs AS a LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON a.JobNumber = jad.JobNumber
				WHERE  jad.JobNumber IS NULL
				
				--Update archive details 
				--Update only those jobs that match archived in this transaction ones
				UPDATE jad
				SET jad.JobEditingTasksArchivedOn = GETDATE()
				FROM dbo.Jobs_ArchiveDetails AS jad INNER JOIN #ArchivedJobs AS aj ON jad.JobNumber = aj.JobNumber
				WHERE jad.JobEditingTasksArchivedOn IS NULL
				
				--Set policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END	
			
			--Clean up
			IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
			IF OBJECT_ID('tempdb..#ArchivedJobEditingTaskS') IS NOT NULL DROP TABLE #ArchivedJobEditingTasks
			IF OBJECT_ID('tempdb..#ArchivedJobEditingTasksData') IS NOT NULL DROP TABLE #ArchivedJobEditingTasksData
			IF OBJECT_ID('tempdb..#ArchivedJobEditingSummary') IS NOT NULL DROP TABLE #ArchivedJobEditingSummary	
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Job Editing Tasks]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Job Editing Tasks]
END
GO
