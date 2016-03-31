
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
--X   1    | 31-Mar-2016  | Sharif Shaik			| Inserting records into new tables EncounterSearchType and TaskType
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

	/*366*/
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Appointment Encounter') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (1, 'Appointment Encounter')
	END
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Date') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (2, 'Date')
	END
		IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Provider') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (3, 'Provider')
	END
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Template') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (4, 'Template')
	END
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Provider & Template') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (5, 'Provider & Template')
	END
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Full') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (6, 'Full')
	END
	IF NOT EXISTS (SELECT 1 FROM EncounterSearchType  WHERE EncounterSearchTypeName = 'Best Match') BEGIN
		INSERT INTO EncounterSearchType (EncounterSearchTypeId, EncounterSearchTypeName) VALUES (7, 'Best Match')
	END

	

	

END

GO
