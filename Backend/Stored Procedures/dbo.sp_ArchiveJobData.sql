
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 01/28/2014
	Version: 1.0
	Details: Archives Archive Jobs_Patients, Jobs_Referring, Jobs_Custom, Jobs_Client and Stats tables on Entrada_Archive database.
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
CREATE PROCEDURE [dbo].[sp_ArchiveJobData]
AS 
SET XACT_ABORT ON
BEGIN
	--Use distributed transaction since we are cross referencing multiple databases	 	       
	BEGIN DISTRIBUTED TRANSACTION [Archiving Job Data] 
		BEGIN TRY
			DECLARE @statusCode AS INT = 360,--Completed Jobs status code
					@archiveAge AS INT,
					@policyId AS INT,
					@archiveID AS INT = 0
					
			--Get policy parameters	
			SELECT @archiveAge = ArchiveAge, @policyId = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'JobData' AND IsActive = 1

			IF OBJECT_ID('tempdb..#ArchivedJobsPatients') IS NOT NULL DROP TABLE #ArchivedJobsPatients
			CREATE TABLE #ArchivedJobsPatients (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsPatients (JobNumber)

			IF OBJECT_ID('tempdb..#ArchivedJobsReferring') IS NOT NULL DROP TABLE #ArchivedJobsReferring
			CREATE TABLE #ArchivedJobsReferring (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsReferring (JobNumber)

			IF OBJECT_ID('tempdb..#ArchivedJobsCustom') IS NOT NULL DROP TABLE #ArchivedJobsCustom
			CREATE TABLE #ArchivedJobsCustom (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsCustom (JobNumber)

			IF OBJECT_ID('tempdb..#ArchivedJobsClient') IS NOT NULL DROP TABLE #ArchivedJobsClient
			CREATE TABLE #ArchivedJobsClient (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedJobsClient (JobNumber)

			IF OBJECT_ID('tempdb..#ArchivedStats') IS NOT NULL DROP TABLE #ArchivedStats
			CREATE TABLE #ArchivedStats (JobNumber VARCHAR(50) NOT NULL)
			CREATE CLUSTERED INDEX IX_JobNumber ON #ArchivedStats (JobNumber)

			--Get records to be archived
			--Make sure we do not get previously archived jobs.
			INSERT INTO #ArchivedJobsPatients
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Patients AS jp ON j.JobNumber = jp.JobNumber
							   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Patients AS ejp ON j.JobNumber = ejp.JobNumber 
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND ejp.JobNumber IS NULL
				  
			INSERT INTO #ArchivedJobsReferring
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Referring AS jr ON j.JobNumber = jr.JobNumber
			                   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Referring AS ejr ON j.JobNumber = ejr.JobNumber
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND ejr.JobNumber IS NULL
				  				  
			INSERT INTO #ArchivedJobsCustom
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Custom AS jc ON j.JobNumber = jc.JobNumber
			                   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Custom AS ejc ON j.JobNumber = ejc.JobNumber
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND ejc.JobNumber IS NULL
				  
			INSERT INTO #ArchivedJobsClient
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.Jobs_Client AS jc ON j.JobNumber = jc.JobNumber
			                   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Jobs_Client AS ejc ON j.JobNumber = ejc.JobNumber
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND ejc.JobNumber IS NULL

			INSERT INTO #ArchivedStats
			SELECT DISTINCT j.JobNumber 
			FROM dbo.Jobs AS j INNER JOIN dbo.[Stats] AS s ON j.JobNumber = s.Job
			                   INNER JOIN dbo.JobStatusB AS js ON j.JobNumber = js.JobNumber AND js.[Status] = @statusCode
							   LEFT OUTER JOIN dbo.EA_Stats AS es ON j.JobNumber = es.Job
			WHERE GETDATE() - @archiveAge >= js.StatusDate AND  es.Job IS NULL

			--Begin process only if there is a data.
			IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsPatients) OR 
			   EXISTS (SELECT TOP 1 1 FROM #ArchivedJobsReferring) OR 
			   EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsCustom) OR 
			   EXISTS (SELECT TOP 1 1 FROM #ArchivedJobsClient) OR 
			   EXISTS(SELECT TOP 1 1 FROM #ArchivedStats) BEGIN
				--Create archive log for policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyId, @archiveAge, GETDATE())
				
				--Get created archiveID
				SELECT @archiveID = SCOPE_IDENTITY() 
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsPatients) BEGIN
					--Archive only those that haven't been archived yet.
					INSERT INTO dbo.EA_Jobs_Patients (JobNumber, AlternateID, MRN, FirstName, MI, LastName, Suffix, DOB, SSN, Address1, Address2, City, [State], Zip, Phone, Sex, PatientId, AppointmentId, ArchiveID)
					SELECT jp.JobNumber, jp.AlternateID, jp.MRN, jp.FirstName, jp.MI, jp.LastName, jp.Suffix, jp.DOB, jp.SSN, jp.Address1, jp.Address2, jp.City, jp.[State], jp.Zip, jp.Phone, jp.Sex, jp.PatientId, jp.AppointmentId, @archiveID
					FROM dbo.Jobs_Patients AS jp INNER JOIN #ArchivedJobsPatients AS ajp ON jp.JobNumber = ajp.JobNumber
					
					--Remove archived records from source database/tables
					DELETE jp FROM dbo.Jobs_Patients AS jp INNER JOIN #ArchivedJobsPatients AS ajp on jp.JobNumber = ajp.JobNumber
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsReferring) BEGIN
					INSERT INTO dbo.EA_Jobs_Referring (JobNumber, PhysicianID, FirstName, MI, LastName, Suffix, DOB, SSN, Sex, Address1, Address2, City, [State], Zip, Phone, Fax, ClinicName, ArchiveID)
					SELECT jr.JobNumber, jr.PhysicianID, jr.FirstName, jr.MI, jr.LastName, jr.Suffix, jr.DOB, jr.SSN, jr.Sex, jr.Address1, jr.Address2, jr.City, jr.[State], jr.Zip, jr.Phone, jr.Fax, jr.ClinicName, @archiveID
					FROM dbo.Jobs_Referring AS jr INNER JOIN #ArchivedJobsReferring AS ajr ON jr.JobNumber = ajr.JobNumber
					
					DELETE jr FROM dbo.Jobs_Referring AS jr INNER JOIN #ArchivedJobsReferring AS ajr ON jr.JobNumber = ajr.JobNumber
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsCustom) BEGIN
					INSERT INTO dbo.EA_Jobs_Custom (JobNumber, Custom1, Custom2, Custom3, Custom4, Custom5, Custom6, Custom7, Custom8, Custom9, Custom10, Custom11, Custom12, Custom13, Custom14, Custom15, Custom16, Custom17, Custom18, Custom19, Custom20, Custom21, Custom22, Custom23, Custom24, Custom25, Custom26, Custom27, Custom28, Custom29, Custom30, Custom31, Custom32, Custom33, Custom34, Custom35, Custom36, Custom37, Custom38, Custom39, Custom40, Custom41, Custom42, Custom43, Custom44, Custom45, Custom46, Custom47, Custom48, Custom49, Custom50, ArchiveID)
					SELECT jc.JobNumber, jc.Custom1, jc.Custom2, jc.Custom3, jc.Custom4, jc.Custom5, jc.Custom6, jc.Custom7, jc.Custom8, jc.Custom9, jc.Custom10, jc.Custom11, jc.Custom12, jc.Custom13, jc.Custom14, jc.Custom15, jc.Custom16, jc.Custom17, jc.Custom18, jc.Custom19, jc.Custom20, jc.Custom21, jc.Custom22, jc.Custom23, jc.Custom24, jc.Custom25, jc.Custom26, jc.Custom27, jc.Custom28, jc.Custom29, jc.Custom30, jc.Custom31, jc.Custom32, jc.Custom33, jc.Custom34, jc.Custom35, jc.Custom36, jc.Custom37, jc.Custom38, jc.Custom39, jc.Custom40, jc.Custom41, jc.Custom42, jc.Custom43, jc.Custom44, jc.Custom45, jc.Custom46, jc.Custom47, jc.Custom48, jc.Custom49, jc.Custom50, @archiveID
					FROM dbo.Jobs_Custom AS jc INNER JOIN #ArchivedJobsCustom AS ajc ON jc.JobNumber = ajc.JobNumber
					
					DELETE jc FROM dbo.Jobs_Custom AS jc INNER JOIN #ArchivedJobsCustom AS ajc on jc.JobNumber = ajc.JobNumber
				END
				
				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedJobsClient) BEGIN
					INSERT INTO dbo.EA_Jobs_Client (JobNumber, DictatorID, [FileName], MD5, ArchiveID)
					SELECT jc.JobNumber, jc.DictatorID, jc.[FileName], jc.MD5, @archiveID
					FROM dbo.Jobs_Client AS jc INNER JOIN #ArchivedJobsClient AS ajc ON jc.JobNumber = ajc.JobNumber

					DELETE jc FROM dbo.Jobs_Client AS jc INNER JOIN #ArchivedJobsClient AS ajc ON jc.JobNumber = ajc.JobNumber
				END

				IF EXISTS(SELECT TOP 1 1 FROM #ArchivedStats) BEGIN
					INSERT INTO dbo.EA_Stats (Job, JobDate, StartTime, EndTime, NumChars, Dictator, Topic, ServerName, NumWords, Confidence, ArchiveID)
					SELECT s.Job, s.JobDate, s.StartTime, s.EndTime, s.NumChars, s.Dictator, s.Topic, s.ServerName, s.NumWords, s.Confidence, @archiveID
					FROM dbo.[Stats] AS s INNER JOIN #ArchivedStats AS ac ON s.Job = ac.JobNumber

					DELETE s FROM dbo.[Stats] AS s INNER JOIN #ArchivedStats AS ac ON s.Job = ac.JobNumber
				END

				--Create list of archived jobs
				IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
				SELECT DISTINCT a.JobNumber
				INTO #ArchivedJobs
				FROM (SELECT JobNumber FROM #ArchivedJobsPatients UNION ALL SELECT JobNumber FROM #ArchivedJobsReferring UNION ALL
					  SELECT JobNumber FROM #ArchivedJobsCustom UNION ALL SELECT JobNumber FROM #ArchivedJobsClient UNION ALL SELECT JobNumber FROM #ArchivedStats) AS a
				      
				--Log archive details
				INSERT INTO dbo.Jobs_ArchiveDetails (JobNumber, JobDataArchivedOn)
				SELECT a.JobNumber, GETDATE()
				FROM #ArchivedJobs AS a LEFT OUTER JOIN dbo.Jobs_ArchiveDetails AS jad ON a.JobNumber = jad.JobNumber
				WHERE  jad.JobNumber IS NULL
				
				--Update archive details 
				--Update only those jobs that match archived in this transaction ones
				UPDATE jad
				SET jad.JobDataArchivedOn = GETDATE()
				FROM dbo.Jobs_ArchiveDetails AS jad INNER JOIN #ArchivedJobs AS aj ON jad.JobNumber = aj.JobNumber
				WHERE jad.JobDataArchivedOn IS NULL
				
				--Set policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END	
			--Clean up
			IF OBJECT_ID('tempdb..#ArchivedJobs') IS NOT NULL DROP TABLE #ArchivedJobs
			IF OBJECT_ID('tempdb..#ArchivedJobsPatients') IS NOT NULL DROP TABLE #ArchivedJobsPatients
			IF OBJECT_ID('tempdb..#ArchivedJobsReferring') IS NOT NULL DROP TABLE #ArchivedJobsReferring
			IF OBJECT_ID('tempdb..#ArchivedJobsCustom') IS NOT NULL DROP TABLE #ArchivedJobsCustom
			IF OBJECT_ID('tempdb..#ArchivedJobsClient') IS NOT NULL DROP TABLE #ArchivedJobsClient
			IF OBJECT_ID('tempdb..#ArchivedStats') IS NOT NULL DROP TABLE #ArchivedStats
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Job Data]
			
			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Job Data]
END
GO
