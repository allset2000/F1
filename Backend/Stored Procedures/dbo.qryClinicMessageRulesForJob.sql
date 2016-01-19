SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh
-- Modified date: 01/19/2016
-- Description: SP used to pull message rules for a job
CREATE PROCEDURE [dbo].[qryClinicMessageRulesForJob] (
	 @MessageTypeId int,
	 @ClinicID smallint,
	 @LocationID smallint, 
	 @DictatorID varchar(50),
	 @JobType varchar(50)	 
) AS	
	SELECT dbo.ClinicsMessagesRules.*
	FROM dbo.ClinicsMessagesRules
	WHERE (MessageTypeId = @MessageTypeId) AND 
	      (ClinicID IN (-1, @ClinicID)) AND 
		  (LocationID IN (0, -1, @LocationID)) AND 
		  ((NOT EXISTS(SELECT DictatorID FROM dbo.ClinicMessageRuleDictators WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId)) OR (EXISTS(SELECT DictatorID FROM dbo.ClinicMessageRuleDictators WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId) AND (@DictatorID IN (SELECT DictatorID FROM dbo.ClinicMessageRuleDictators WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId)))) AND		            
		  ((NOT EXISTS(SELECT Jobtype FROM dbo.ClinicMessageRuleJobtypes WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId)) OR (EXISTS(SELECT Jobtype FROM dbo.ClinicMessageRuleJobtypes WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId) AND (@JobType IN (SELECT Jobtype FROM dbo.ClinicMessageRuleJobtypes WHERE MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId))))
	      
RETURN
GO
