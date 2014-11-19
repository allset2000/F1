SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 10/28/2014
	Version: 1.0
	Details: Archives JobTracking table on Entrada_Archive database.
	Tecnical Details:  The script involves two different databases.  Tables that have prefix EA_ reside on archive database and are referenced as synonyms.
	                   To provide transaction over mupliple databases, this scrit was wrapped INTO SQL Distribution Transaction.
	                   For exception handling Try/Catch blocks are used. 
	                   In case of failure, the whole transaction will be rolled back to the previous state.
	                   Logs are created on both, source AND archive databases.
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developr this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_ArchiveJobTracking]
AS 
SET XACT_ABORT ON
BEGIN  
	--Use distributed transaction since we are cross referencing multiple databases	 	       
	BEGIN DISTRIBUTED TRANSACTION [Archiving Job Tracking] 
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
					@archiveAge AS INT,
					@policyId AS INT, 
					@archiveID AS INT = 0
			
			--Get JobTracking policy parameters		
			SELECT @archiveAge = ArchiveAge, 
				   @policyId = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'JobTracking' AND 
				  IsActive = 1

			--Get JobNumbers of Job Tracking that will be archived  
			--Validate against Jobs_ArchiveDetails, to make sure we do not get previously archived jobs.
			IF OBJECT_ID('tempdb..#ArchivedJobTracking') IS NOT NULL DROP TABLE #ArchivedJobTracking
			SELECT DISTINCT j.JobNumber
			INTO #ArchivedJobTracking
			FROM dbo.Jobs AS j WITH(NOLOCK) INNER JOIN dbo.JobTracking AS jt WITH(NOLOCK) ON j.JobNumber = jt.JobNumber
											INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
											LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON j.JobNumber = jad.JobNumber 
			WHERE DATEDIFF(DAY, js.StatusDate, GETDATE()) >= @archiveAge AND
				  jad.TrackingArchivedOn IS NULL
		  
			--Begin process only if there is a data
			IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobTracking) 
			BEGIN
				--Create archive log for JobTracking policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyId, @archiveAge, GETDATE())
				
				--Get created ArchiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				--Archive only those that haven't been archived yet.
				INSERT INTO dbo.EA_JobTracking
				SELECT jd.*, @archiveID
				FROM dbo.JobTracking AS jd WITH(NOLOCK)INNER JOIN #ArchivedJobTracking AS ajt ON jd.JobNumber = ajt.JobNumber

				--Remove archived records from source database/tables
				DELETE jd
				FROM dbo.JobTracking AS jd INNER JOIN #ArchivedJobTracking AS ajt on jd.JobNumber = ajt.JobNumber
				
				--Log archive details
				INSERT INTO dbo.Jobs_ArchiveDetails (JobNumber, TrackingArchivedOn)
				SELECT ajt.JobNumber, GETDATE()
				FROM #ArchivedJobTracking AS ajt LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON ajt.JobNumber = jad.JobNumber
				WHERE  jad.JobNumber IS NULL
				
				--Update archive details 
				--Update only those jobs that match archived in this transaction ones and TrackingArchivedOn is null
				UPDATE jad
				SET jad.TrackingArchivedOn = GETDATE()
				FROM dbo.Jobs_ArchiveDetails AS jad INNER JOIN #ArchivedJobTracking AS ajt ON jad.JobNumber = ajt.JobNumber
				WHERE jad.TrackingArchivedOn IS NULL
				
				--Set JobsDocument policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END	
			
			--Clean up
			IF OBJECT_ID('tempdb..#ArchivedJobTracking') IS NOT NULL DROP TABLE #ArchivedJobTracking	
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Job Tracking] 

			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Job Tracking] 
END
GO
