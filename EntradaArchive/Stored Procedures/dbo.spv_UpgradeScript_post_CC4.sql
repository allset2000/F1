SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created  By: MIkayil Bayramov
	Created  Date: 04/13/2015
	DEtails: SP Used to store Entrada_Archive data changes in the CC.4 release.
*/
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC4]
AS
BEGIN
	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'JobDocuments'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('JobDocuments', 'Archive documents and history from jobs_documents, jobs_documents_history tables.',	1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'JobTracking'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('JobTracking', 'Archive JobTracking table.',	1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'EditorLogs'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('EditorLogs', 'Archive EditorLogs table.',	1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'JobFiles'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('JobFiles', 'Archive job related files from FinalRestingFolder to ArchiveFolder.', 1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'JobData'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('JobData', 'Archive Jobs_Patients, Jobs_Referring, Jobs_Custom, Jobs_Client and Stats tables.', 1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'JobEditingTasks'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('JobEditingTasks', 'Archive JobEditingTasks, JobEditingTasksData and JobEditingSummary tables.',	1363, 99999, 1)
	END

	IF(NOT EXISTS (SELECT 1 FROM [dbo].[ArchivePolicy] WHERE PolicyName = 'AuditLog'))
	BEGIN
		INSERT INTO [dbo].[ArchivePolicy] (PolicyName, Description, ArchiveAge, PurgeAge, IsActive)
		VALUES('AuditLog', 'Archive AuditLogExpressLinkApi, AuditLogDictateApi and AuditLogAdminConsoleApi tables.', 1363, 99999, 1)
	END
END
GO
