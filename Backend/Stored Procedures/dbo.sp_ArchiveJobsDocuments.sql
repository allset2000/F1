SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/24/2014
	Version: 1.0
	Details: Archives Jobs_Documents and Jobs_Documents_History tables on Entrada_Archive database.
	Tecnical Details:  The script involves two different databases. Tables that have prefix EA_ reside on Archive database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped INTO SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source AND archive databases.
	
	
	Revised Date: 1/28/2015
	Revised By: Mikayil Bayramov.
	Revision Details: 1) To improve the perfomance the "DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @archiveAge" segment was replaced with the "GETDATE() - @archiveAge >= js.StatusDate" one.
	                     Since StatusDate is indexed field, wrapping it into conversion fuction blocks index to be accesed. 
					  2) Removed WITH (NOLOCK) SQL key word. See reason here: http://stackoverflow.com/questions/686724/sql-server-when-should-you-use-with-nolock
					  3) Also, "LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON j.JobNumber = jad.JobNumber" segments for Jobs_Documents and Jobs_Documents_History tables was replaced with 
					     "LEFT OUTER JOIN dbo.EA_Jobs_Documents AS jad ON j.JobNumber = jad.JobNumber" and ""LEFT OUTER JOIN dbo.EA_Jobs_Documents_Hisotry AS jad ON j.JobNumber = jad.JobNumber" respectively.
						 With this approach we still validate against records that have been archived previously but also, maintaining  independence for archiving tables from Jobs_ArchiveDetails one. 
						 In other words, if for example, there are job numbers in Jobs_ArchiveDetails table created from Jobs_Documents_History activation, then with the previous approach these 
						 job numbers will not be pulled from Jobs_Documents table, which will lead to logical error. 
					  4) Added clustered indexes to temp tables
	Revision Version: 1.1

	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_ArchiveJobsDocuments]
AS 
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	 	       
	BEGIN DISTRIBUTED TRANSACTION [Archiving Jobs Documents] 
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
					@archiveAge AS INT,
					@policyId AS INT,
					@archiveID AS INT = 0
					
			--Get policy parameters	
			SELECT @archiveAge = ArchiveAge, @policyId = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'JobDocuments' AND IsActive = 1

			IF OBJECT_ID('tempdb..#ArchivedJobsDocuments') IS NOT NULL DROP TABLE #ArchivedJobsDocuments
			CREATE TABLE #ArchivedJobsDocuments (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsDocuments (JobNumber)

			IF OBJECT_ID('tempdb..#ArchivedJobsDocumentsHistory') IS NOT NULL DROP TABLE #ArchivedJobsDocumentsHistory
			CREATE TABLE #ArchivedJobsDocumentsHistory (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsDocumentsHistory (JobNumber)

			--Get records to be archived 
			--Make sure we do not get previously archived jobs.
			INSERT INTO #ArchivedJobsDocuments
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Documents AS jd ON j.JobNumber = jd.JobNumber
							   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Documents AS jad ON j.JobNumber = jad.JobNumber 
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND jad.JobNumber IS NULL
				  
			INSERT INTO #ArchivedJobsDocumentsHistory
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Documents_History AS jdh ON j.JobNumber = jdh.JobNumber
			                   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Documents_History AS jad ON j.JobNumber = jad.JobNumber
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND jad.JobNumber IS NULL
				  
			--Begin process only if there is a data.
			IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocuments) OR EXISTS (SELECT TOP 1 1 FROM #ArchivedJobsDocumentsHistory) BEGIN
				--Create archive log for policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyId, @archiveAge, GETDATE())
				
				--Get created archiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocuments) BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_Jobs_Documents
					SELECT jd.*, @archiveID
					FROM dbo.Jobs_Documents AS jd INNER JOIN #ArchivedJobsDocuments AS ajd ON jd.JobNumber = ajd.JobNumber
					
					--Remove archived records from source database/tables
					DELETE jd FROM dbo.Jobs_Documents AS jd INNER JOIN #ArchivedJobsDocuments AS ajd on jd.JobNumber = ajd.JobNumber
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocumentsHistory) BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_Jobs_Documents_History
					SELECT jdh.*, @archiveID
					FROM dbo.Jobs_Documents_History AS jdh INNER JOIN #ArchivedJobsDocumentsHistory AS ajdh ON jdh.JobNumber = ajdh.JobNumber
					
					--Remove archived records from source database/tables
					DELETE jdh FROM dbo.Jobs_Documents_History AS jdh INNER JOIN #ArchivedJobsDocumentsHistory AS ajdh ON jdh.JobNumber = ajdh.JobNumber
				END
				
				--Create list of archived jobs
				IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
				SELECT DISTINCT a.JobNumber INTO #ArchivedJobs
				FROM (SELECT JobNumber FROM #ArchivedJobsDocuments UNION ALL SELECT JobNumber FROM #ArchivedJobsDocumentsHistory) AS a
				      
				--Log archive details
				INSERT INTO dbo.Jobs_ArchiveDetails (JobNumber, DocumentArchivedOn)
				SELECT a.JobNumber, GETDATE()
				FROM #ArchivedJobs AS a LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON a.JobNumber = jad.JobNumber
				WHERE  jad.JobNumber IS NULL
				
				--Update archive details 
				--Update only those jobs that match archived in this transaction ones
				UPDATE jad
				SET jad.DocumentArchivedOn = GETDATE()
				FROM dbo.Jobs_ArchiveDetails AS jad INNER JOIN #ArchivedJobs AS aj ON jad.JobNumber = aj.JobNumber
				WHERE jad.DocumentArchivedOn IS NULL
				
				--Set policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END	
			
			--Clean up
			IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
			IF OBJECT_ID('tempdb..#ArchivedJobsDocuments') IS NOT NULL DROP TABLE #ArchivedJobsDocuments
			IF OBJECT_ID('tempdb..#ArchivedJobsDocumentsHistory') IS NOT NULL DROP TABLE #ArchivedJobsDocumentsHistory	
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Jobs Documents]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Jobs Documents]
END
GO
