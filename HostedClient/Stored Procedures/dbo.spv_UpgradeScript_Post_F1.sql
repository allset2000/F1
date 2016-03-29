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


END

GO
