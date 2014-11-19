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
					
			--Get JobDocuments policy parameters	
			SELECT @archiveAge = ArchiveAge, 
				   @policyId = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'JobDocuments' AND 
				  IsActive = 1

			--Get JobNumbers of Jobs Documents and Jobs Documents History that will be archived  
			--Validate against Jobs_ArchiveDetails, to make sure we do not get previously archived jobs.
			IF OBJECT_ID('tempdb..#ArchivedJobsDocuments') IS NOT NULL DROP TABLE #ArchivedJobsDocuments
			SELECT DISTINCT j.JobNumber
			INTO #ArchivedJobsDocuments
			FROM dbo.Jobs AS j WITH(NOLOCK) INNER JOIN dbo.Jobs_Documents AS jd WITH(NOLOCK) ON j.JobNumber = jd.JobNumber
											INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
											LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON j.JobNumber = jad.JobNumber 
			WHERE DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @archiveAge AND
				  jad.DocumentArchivedOn IS NULL
				  
			IF OBJECT_ID('tempdb..#ArchivedJobsDocumentsHistory') IS NOT NULL DROP TABLE #ArchivedJobsDocumentsHistory
			SELECT DISTINCT j.JobNumber
			INTO #ArchivedJobsDocumentsHistory
			FROM dbo.Jobs AS j with(nolock) INNER JOIN dbo.Jobs_Documents_History AS jdh WITH(NOLOCK) ON j.JobNumber = jdh.JobNumber
			                                INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
											LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON j.JobNumber = jad.JobNumber
			WHERE DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @archiveAge AND
				  jad.DocumentArchivedOn IS NULL
				  
			--Begin process only if there is a data.
			IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocuments) OR EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocumentsHistory) 
			BEGIN
				--Create archive log for JobDocuments policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyId, @archiveAge, GETDATE())
				
				--Get created ArchiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocuments)
				BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_Jobs_Documents
					SELECT jd.*, @archiveID
					FROM dbo.Jobs_Documents AS jd WITH(NOLOCK)INNER JOIN #ArchivedJobsDocuments AS ajd ON jd.JobNumber = ajd.JobNumber
					
					--Remove archived records from source database/tables
					DELETE jd
					FROM dbo.Jobs_Documents AS jd INNER JOIN #ArchivedJobsDocuments AS ajd on jd.JobNumber = ajd.JobNumber
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsDocumentsHistory) 
				BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_Jobs_Documents_History
					SELECT jdh.*, @archiveID
					FROM dbo.Jobs_Documents_History AS jdh WITH(NOLOCK)INNER JOIN #ArchivedJobsDocumentsHistory AS ajdh ON jdh.JobNumber = ajdh.JobNumber
					
					--Remove archived records from source database/tables
					DELETE jdh
					FROM dbo.Jobs_Documents_History AS jdh INNER JOIN #ArchivedJobsDocumentsHistory AS ajdh ON jdh.JobNumber = ajdh.JobNumber
				END
				
				--Create list of archived jobs
				IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
				SELECT DISTINCT a.JobNumber
				INTO #ArchivedJobs
				FROM (SELECT JobNumber FROM #ArchivedJobsDocuments
					  UNION ALL
					  SELECT JobNumber FROM #ArchivedJobsDocumentsHistory) AS a
				      
				--Log archive details
				INSERT INTO dbo.Jobs_ArchiveDetails (JobNumber, DocumentArchivedOn)
				SELECT a.JobNumber, GETDATE()
				FROM #ArchivedJobs AS a LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON a.JobNumber = jad.JobNumber
				WHERE  jad.JobNumber IS NULL
				
				--Update archive details 
				--Update only those jobs that match archived in this transaction ones and DcoumentArchivedOn is null
				UPDATE jad
				SET jad.DocumentArchivedOn = GETDATE()
				FROM dbo.Jobs_ArchiveDetails AS jad INNER JOIN #ArchivedJobs AS aj ON jad.JobNumber = aj.JobNumber
				WHERE jad.DocumentArchivedOn IS NULL
				
				--Set JobsDocument policy archive end time
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
