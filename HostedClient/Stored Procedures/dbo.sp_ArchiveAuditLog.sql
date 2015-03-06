SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	Created By: Mikayil Bayramov
	Created Date: 01/29/2015
	Version: 1.0
	Details: Archives AuditLogExpressLinkApi, AuditLogDictateApi and AuditLogAdminConsoleApi tables on EntradaHostedClient database.
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
CREATE PROCEDURE [dbo].[sp_ArchiveAuditLog]
AS 
SET XACT_ABORT ON 
BEGIN  
	--Use distributed transaction since we are cross referencing multiple databases	     
	BEGIN DISTRIBUTED TRANSACTION [Archiving Audit Log] 
		BEGIN TRY
			DECLARE @archiveAge AS INT,
					@policyID AS INT, 
					@archiveID AS INT
					
			--Get policy parameters	
			SELECT @archiveAge = ArchiveAge, @policyID = PolicyID
			FROM dbo.EA_ArchivePolicy
			WHERE PolicyName = 'AuditLog' AND IsActive = 1

			--Begin process only if there is a data to archive.	
			IF EXISTS(SELECT TOP 1 1 FROM dbo.AuditLogExpressLinkApi WHERE GETDATE() - @archiveAge >= OperationTime) OR
			   EXISTS(SELECT TOP 1 1 FROM dbo.AuditLogDictateApi WHERE GETDATE() - @archiveAge >= OperationTime) OR 
			   EXISTS(SELECT TOP 1 1 FROM dbo.AuditLogAdminConsoleApi WHERE GETDATE() - @archiveAge >= OperationTime) BEGIN  

			   	--Create archive log for policy
				INSERT INTO dbo.EA_ArchiveLog(PolicyID, ArchiveAge, ArchiveExecutionStartDate)
				VALUES (@policyID, @archiveAge, GETDATE())
				
				--Get created archiveID
				SELECT @archiveID = SCOPE_IDENTITY() 

				--Archive
				INSERT INTO dbo.EA_AuditLogExpressLinkApi
				SELECT *, @archiveID
				FROM dbo.AuditLogExpressLinkApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				INSERT INTO dbo.EA_AuditLogDictateApi
				SELECT *, @archiveID
				FROM dbo.AuditLogDictateApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				INSERT INTO dbo.EA_AuditLogAdminConsoleApi
				SELECT *, @archiveID
				FROM dbo.AuditLogAdminConsoleApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				--Remove archived records from source database/table
				DELETE FROM dbo.AuditLogExpressLinkApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				DELETE FROM dbo.AuditLogDictateApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				DELETE FROM dbo.AuditLogAdminConsoleApi
				WHERE GETDATE() - @archiveAge >= OperationTime

				--Set policy archive end time
				UPDATE dbo.EA_ArchiveLog
				SET ArchiveExecutionEndDate = GETDATE()
				WHERE ArchiveID = @archiveID
			END
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION [Archiving Audit Log] 

			DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())

			RAISERROR (@errorMessage, @errorSeverity, @errorState)
		END CATCH
	IF @@TRANCOUNT > 0 COMMIT TRANSACTION [Archiving Audit Log] 
END
GO
