
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spv_UpgradeScript_Post_F1]
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_post_F1
--X
--X AUTHOR: Sharif Shaik
--X
--X DESCRIPTION: SP Used to store all data changes in the F.1 release
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 29-Mar-2016  | Sharif Shaik			| Initial Design
--X   1    | 04-Apr-2016  | Narender Ramadheni		| #5461# Added new status and status group

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN


	IF NOT EXISTS (SELECT 1 FROM RhythmWorkFlows  WHERE RhythmWorkFlowID = 1) BEGIN
		INSERT INTO RhythmWorkFlows (RhythmWorkFlowID,RhythmWorkFlowName) VALUES (1, 'Device Edit')
	END
	IF NOT EXISTS (SELECT 1 FROM RhythmWorkFlows  WHERE RhythmWorkFlowID = 2) BEGIN
		INSERT INTO RhythmWorkFlows (RhythmWorkFlowID,RhythmWorkFlowName) VALUES (2, 'Transcription')
	END
	IF NOT EXISTS (SELECT 1 FROM RhythmWorkFlows  WHERE RhythmWorkFlowID = 3) BEGIN
		INSERT INTO RhythmWorkFlows (RhythmWorkFlowID,RhythmWorkFlowName) VALUES (3, 'No Edit - Direct to EHR')
	END
	
	--#5461# 
	-- Adding  new Status group for Draft Review, Rhythm jobs
	IF NOT EXISTS (SELECT 1 FROM JobStatusGroup WHERE StatusGroup = 'Draft Review' and Id = 6)
		BEGIN
			SET IDENTITY_INSERT [dbo].[JobStatusGroup] ON
			INSERT INTO [dbo].[JobStatusGroup] (Id, StatusGroup) VALUES (6,'Draft Review')
			SET IDENTITY_INSERT [dbo].[JobStatusGroup] OFF
		END
	IF NOT EXISTS (SELECT 1 FROM JobStatusGroup WHERE StatusGroup = 'Job Approved From Mobile' and Id = 7)
		BEGIN
			SET IDENTITY_INSERT [dbo].[JobStatusGroup] ON
			INSERT INTO [dbo].[JobStatusGroup] (Id, StatusGroup) VALUES (7,'Job Approved From Mobile')
			SET IDENTITY_INSERT [dbo].[JobStatusGroup] OFF
		END
	--Updating Status table with new status for DraftReview and SendDirectToEHR	
	IF NOT EXISTS (SELECT 1 FROM StatusCodes WHERE StatusID = 136)
		INSERT INTO [dbo].[StatusCodes] ([StatusID],[StatusName],[FriendlyStatusName],[StatusClass],[StatusStage],[EditionStage],[CurrentEditorRule],[SpeechFolderTag],
				[IsActiveJobStatus],[IsJobSearchStatus],[IsSpecialCaseStatus],[StatusGroupId])
		 VALUES (136,'Draft Review','Draft Review','Draft Review','','DR','','JobsInProcess',0,1,0,6)
	IF NOT EXISTS (SELECT 1 FROM StatusCodes WHERE StatusID = 355)
		INSERT INTO [dbo].[StatusCodes] ([StatusID],[StatusName],[FriendlyStatusName],[StatusClass],[StatusStage],[EditionStage],[CurrentEditorRule],[SpeechFolderTag],
				[IsActiveJobStatus],[IsJobSearchStatus],[IsSpecialCaseStatus],[StatusGroupId])
		 VALUES (355,'Job Sent Direct to EHR','Job Sent Direct to EHR','','','Delivered','','',0,1,0,4)
	IF NOT EXISTS (SELECT 1 FROM StatusCodes WHERE StatusID = 138)
		INSERT INTO [dbo].[StatusCodes] ([StatusID],[StatusName],[FriendlyStatusName],[StatusClass],[StatusStage],[EditionStage],[CurrentEditorRule],[SpeechFolderTag],
				[IsActiveJobStatus],[IsJobSearchStatus],[IsSpecialCaseStatus],[StatusGroupId])
		 VALUES (138,'Job Approved From Mobile','Job Approved From Mobile','Job Approved From Mobile','','DR','','',0,1,0,7)
	--end #5461#

END

GO
