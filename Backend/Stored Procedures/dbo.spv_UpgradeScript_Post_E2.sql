SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spv_UpgradeScript_Post_E2]
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_post_E2
--X
--X AUTHOR: Santhosh
--X
--X DESCRIPTION: SP Used to store all data changes in the E.2 release
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
--X   1    | 27-Jan-2016  | Santhosh                | #735 - Adding Multiple Providers and Multiple JobTypes while sending Notifications

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	/*735*/
	INSERT INTO ClinicMessageRuleDictators 
	SELECT MessageRuleId, DictatorID FROM ClinicsMessagesRules WHERE ISNULL(DictatorID,'') <> ''

	INSERT INTO ClinicMessageRuleJobTypes
	SELECT MessageRuleId, JobType FROM ClinicsMessagesRules WHERE ISNULL(JobType,'') <> ''

	INSERT INTO ClinicMessageRuleUsers
	SELECT MessageRuleId, UserId FROM ClinicsMessagesRules WHERE ISNULL(UserId,'') <> ''
	/*735*/
END

GO
