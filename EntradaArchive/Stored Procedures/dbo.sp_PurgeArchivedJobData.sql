SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/24/2014
	Version: 1.0
	Details: Deletes archived Jobs_Patients, Jobs_Referring, Jobs_Custom, Jobs_Client and Stats tables on Entrada_Archive database based on purge policy.
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
CREATE PROCEDURE [dbo].[sp_PurgeArchivedJobData]
AS
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	
	BEGIN DISTRIBUTED TRANSACTION [Purge Archived Job Data]
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
			WHERE PolicyName = 'JobData' AND IsActive = 1

			IF OBJECT_ID('tempdb..#PurgedJobsPatients') IS NOT NULL DROP TABLE #PurgedJobsPatients
			CREATE TABLE #PurgedJobsPatients (
				ID INT IDENTITY (1, 1) NOT NULL, 
				JobNumber VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobsPatients (JobNumber)

			IF OBJECT_ID('tempdb..#PurgedJobsReferring') IS NOT NULL DROP TABLE #PurgedJobsReferring
			CREATE TABLE #PurgedJobsReferring (
				ID INT IDENTITY (1, 1) NOT NULL, 
				JobNumber VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobsReferring (JobNumber)

			IF OBJECT_ID('tempdb..#PurgedJobsCustom') IS NOT NULL DROP TABLE #PurgedJobsCustom
			CREATE TABLE #PurgedJobsCustom (
				ID INT IDENTITY (1, 1) NOT NULL, 
				JobNumber VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobsCustom (JobNumber)

			IF OBJECT_ID('tempdb..#PurgedJobsClient') IS NOT NULL DROP TABLE #PurgedJobsClient
			CREATE TABLE #PurgedJobsClient (
				ID INT IDENTITY (1, 1) NOT NULL, 
				JobNumber VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobsClient (JobNumber)

			IF OBJECT_ID('tempdb..#PurgedStats') IS NOT NULL DROP TABLE #PurgedStats
			CREATE TABLE #PurgedStats (
				ID INT IDENTITY (1, 1) NOT NULL, 
				JobNumber VARCHAR(50) NOT NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedStats (JobNumber)

			--Get records to be archived
			INSERT INTO #PurgedJobsPatients
			SELECT DISTINCT jp.JobNumber			
			FROM dbo.Jobs_Patients AS jp INNER JOIN dbo.EN_Jobs AS j ON jp.JobNumber = j.JobNumber 
										 INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			INSERT INTO #PurgedJobsReferring
			SELECT DISTINCT jr.JobNumber			
			FROM dbo.Jobs_Referring AS jr INNER JOIN dbo.EN_Jobs AS j ON jr.JobNumber = j.JobNumber 
										  INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			INSERT INTO #PurgedJobsCustom
			SELECT DISTINCT jc.JobNumber			
			FROM dbo.Jobs_Custom AS jc INNER JOIN dbo.EN_Jobs AS j ON jc.JobNumber = j.JobNumber 
									   INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			INSERT INTO #PurgedJobsClient
			SELECT DISTINCT jc.JobNumber			
			FROM dbo.Jobs_Client AS jc INNER JOIN dbo.EN_Jobs AS j ON jc.JobNumber = j.JobNumber 
									   INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate

			INSERT INTO #PurgedStats
			SELECT DISTINCT s.Job AS JobNumber		
			FROM dbo.[Stats] AS s INNER JOIN dbo.EN_Jobs AS j ON s.Job = j.JobNumber 
								  INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate
			
			--Begin process only if there is a data.
			IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobsPatients) OR
			   EXISTS (SELECT TOP 1 1 FROM #PurgedJobsReferring) OR 
			   EXISTS (SELECT TOP 1 1 FROM #PurgedJobsCustom) OR
			   EXISTS (SELECT TOP 1 1 FROM #PurgedJobsClient) OR 
			   EXISTS (SELECT TOP 1 1 FROM #PurgedStats) BEGIN
				--Create purge log for policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created purgeID
				SELECT @purgeID = SCOPE_IDENTITY() 
				
				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobsPatients) BEGIN				
					--Purge archived records						  
					DELETE jp FROM dbo.Jobs_Patients AS jp INNER JOIN #PurgedJobsPatients AS pjp ON jp.JobNumber = pjp.JobNumber
					
					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobsPatients) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000

						--Create deleted records reference in PurgeData table
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Patients', CAST((SELECT Job.JobNumber FROM #PurgedJobsPatients AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
									
					--Update archive details 
					--Update only those jobs that match archived in this transaction ones
					UPDATE jad
					SET jad.JobDataPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobsPatients AS pjp ON jad.JobNumber = pjp.JobNumber
					WHERE jad.JobDataPurgedOn IS NULL
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobsReferring) BEGIN									  
					DELETE jr FROM dbo.Jobs_Referring AS jr INNER JOIN #PurgedJobsReferring AS pjr ON jr.JobNumber = pjr.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobsReferring) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
											
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Referring', CAST((SELECT Job.JobNumber FROM #PurgedJobsReferring AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
					
					UPDATE jad
					SET jad.JobDataPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobsReferring AS pjr ON jad.JobNumber = pjr.JobNumber
					WHERE jad.JobDataPurgedOn IS NULL
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobsCustom) BEGIN									  
					DELETE jc FROM dbo.Jobs_Custom AS jc INNER JOIN #PurgedJobsCustom AS pjc ON jc.JobNumber = pjc.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobsCustom) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
					
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Custom', CAST((SELECT Job.JobNumber FROM #PurgedJobsCustom AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
					
					UPDATE jad
					SET jad.JobDataPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobsCustom AS pjc ON jad.JobNumber = pjc.JobNumber
					WHERE jad.JobDataPurgedOn IS NULL
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobsClient) BEGIN										  
					DELETE jc FROM dbo.Jobs_Client AS jc INNER JOIN #PurgedJobsClient AS pjc ON jc.JobNumber = pjc.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobsClient) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
										
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Client', CAST((SELECT Job.JobNumber FROM #PurgedJobsClient AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END

					UPDATE jad
					SET jad.JobDataPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobsClient AS pjc ON jad.JobNumber = pjc.JobNumber
					WHERE jad.JobDataPurgedOn IS NULL
				END
				
				IF EXISTS (SELECT TOP 1 1 FROM #PurgedStats) BEGIN									  
					DELETE s FROM dbo.[Stats] AS s INNER JOIN #PurgedStats AS ps ON s.Job = ps.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedStats) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
											
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Stats', CAST((SELECT Job.JobNumber FROM #PurgedStats AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
					
					UPDATE jad
					SET jad.JobDataPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedStats AS ps ON jad.JobNumber = ps.JobNumber
					WHERE jad.JobDataPurgedOn IS NULL
				END

				--Set policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
			--Clean up
			IF OBJECT_ID('tempdb..#PurgedJobsPatients')  IS NOT NULL DROP TABLE #PurgedJobsPatients
			IF OBJECT_ID('tempdb..#PurgedJobsReferring')  IS NOT NULL DROP TABLE #PurgedJobsReferring
			IF OBJECT_ID('tempdb..#PurgedJobsCustom')  IS NOT NULL DROP TABLE #PurgedJobsCustom
			IF OBJECT_ID('tempdb..#PurgedJobsClient')  IS NOT NULL DROP TABLE #PurgedJobsClient
			IF OBJECT_ID('tempdb..#PurgedStats')  IS NOT NULL DROP TABLE #PurgedStats
		END TRY
		BEGIN CATCH
		    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Purge Archived Job Data]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
				 
			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Purge Archived Job Data]
END
GO
