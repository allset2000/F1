
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/24/2014
	Version: 1.0
	Details: Deletes archived Jobs_Documents and Jobs_Documents_History tables on Entrada_Archive database based on purge policy.
	Tecnical Details:  The script involves two different databases. Tables that have prefix EN_ reside on source database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped into SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source and archive databases.
	
	Revised Date: 1/29/2015
	Revised By: Mikayil Bayramov.
	Revision Details: 1) To improve the perfomance the "DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @purgeAge" segment was replaced with the "GETDATE() - @purgeAge >= js.StatusDate" one.
	                     Since StatusDate is indexed field, wrapping it into conversion fuction blocks index to be accesed. 
					  2) Added clustered indexes to temp tables
					  3) Added handling for large xml log files
	Revision Version: 1.1

	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_PurgeArchivedJobsDocuments]
AS
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	
	BEGIN DISTRIBUTED TRANSACTION [Purge Archived Job Documents]
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
			        @purgeAge AS INT,
			        @policyID AS INT,
			        @purgeID AS INT = 0,
					@count AS INT = 0,
					@skip AS INT = 0,
					@take AS INT = 0
			
			--Get policy purge age 
			SELECT @purgeAge = PurgeAge, @policyId = PolicyID
			FROM dbo.ArchivePolicy
			WHERE PolicyName = 'JobDocuments' AND IsActive = 1

			IF OBJECT_ID('tempdb..#PurgedJobDocuments') IS NOT NULL DROP TABLE #PurgedJobDocuments
			CREATE TABLE #PurgedJobDocuments (
				ID INT IDENTITY (1, 1) NOT NULL,
				JobNumber VARCHAR(50) NOT NULL,
				DocumentID VARCHAR(50) NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobDocuments (JobNumber)

			IF OBJECT_ID('tempdb..#PurgedJobDocumentsHistory') IS NOT NULL DROP TABLE #PurgedJobDocumentsHistory
			CREATE TABLE #PurgedJobDocumentsHistory (
				ID INT IDENTITY (1, 1) NOT NULL,
				JobNumber VARCHAR(50) NOT NULL,
				DocumentID VARCHAR(50) NULL
			)
			CREATE CLUSTERED INDEX IX_JobNumber ON #PurgedJobDocumentsHistory (JobNumber)
	  
			--Get records to be purged
			INSERT INTO #PurgedJobDocuments
			SELECT DISTINCT jd.JobNumber, NULL AS DocumentID			
			FROM dbo.Jobs_Documents AS jd INNER JOIN dbo.EN_Jobs AS j ON jd.JobNumber = j.JobNumber 
										  INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate
			
			INSERT INTO #PurgedJobDocumentsHistory
			SELECT DISTINCT jdh.JobNumber, jdh.DocumentID
			FROM dbo.Jobs_Documents_History AS jdh INNER JOIN dbo.EN_Jobs AS j ON jdh.JobNumber = j.JobNumber 
										           INNER JOIN dbo.EN_JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
			WHERE GETDATE() - @purgeAge >= js.StatusDate
			
			--Begin process only if there is a data.
			IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobDocuments) OR EXISTS (SELECT TOP 1 1 FROM #PurgedJobDocumentsHistory) BEGIN
				--Create purge log for policy
				INSERT INTO dbo.PurgeLog(PolicyID, PurgeAge, PurgeExecutionStartDate)
				VALUES (@policyID, @purgeAge, GETDATE())
				
				--Get created purgeID
				SELECT @purgeID = SCOPE_IDENTITY() 
				
				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobDocuments) BEGIN				
					--Purge archived records						  
					DELETE jd FROM dbo.Jobs_Documents AS jd INNER JOIN #PurgedJobDocuments AS pjd ON jd.JobNumber = pjd.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobDocuments) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000
					
						--Create deleted records reference in PurgeData table
						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Documents', CAST((SELECT Job.JobNumber, Job.DocumentID FROM #PurgedJobDocuments AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)

						SET @count = @count + 100000
					END
					
					--Update archive details 
					--Update only those jobs that match archived in this transaction ones
					UPDATE jad
					SET jad.DocumentPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobDocuments AS pjd ON jad.JobNumber = pjd.JobNumber
					WHERE jad.DocumentPurgedOn IS NULL
				END

				IF EXISTS (SELECT TOP 1 1 FROM #PurgedJobDocumentsHistory) BEGIN
					DELETE jdh FROM dbo.Jobs_Documents_History AS jdh INNER JOIN #PurgedJobDocumentsHistory AS pjdh ON jdh.JobNumber = pjdh.JobNumber

					SET @count = 0
					WHILE @count <= (SELECT MAX(ID) FROM #PurgedJobDocumentsHistory) BEGIN
						SELECT @skip = @count + 1,  @take = @count + 100000

						INSERT INTO dbo.PurgeData (PurgeID, [Description], PurgeData)
						SELECT @purgeID,'Jobs_Documents_History', CAST((SELECT Job.JobNumber, Job.DocumentID FROM #PurgedJobDocumentsHistory AS Job WHERE ID BETWEEN @skip AND @take FOR XML AUTO, ROOT('PurgedJobs')) AS XML)
						
						SET @count = @count + 100000
					END

					UPDATE jad
					SET jad.DocumentPurgedOn = GETDATE()
					FROM dbo.EN_Jobs_ArchiveDetails AS jad INNER JOIN #PurgedJobDocumentsHistory AS pjdh ON jad.JobNumber = pjdh.JobNumber
					WHERE jad.DocumentPurgedOn IS NULL
				END
				
				--Set policy purge end time
				UPDATE dbo.PurgeLog
				SET PurgeExecutionEndDate = GETDATE()
				WHERE PurgeID = @purgeID
			END
			--Clean up
			IF OBJECT_ID('tempdb..#PurgedJobDocuments')  IS NOT NULL DROP TABLE #PurgedJobDocuments
			IF OBJECT_ID('tempdb..#PurgedJobDocumentsHistory') IS NOT NULL DROP TABLE #PurgedJobDocumentsHistory
		END TRY
		BEGIN CATCH
		    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Purge Archived Job Documents]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
				 
			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Purge Archived Job Documents]
END
GO
