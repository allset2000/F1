SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryClinicMessagesByStatus] (
   @MessageStatus char(1)
) AS
	SELECT dbo.ClinicsMessages.*, dbo.ClinicsMessagesRules.ClinicID, dbo.ClinicsMessagesRules.DictatorID,
	dbo.ClinicsMessagesRules.JobType, dbo.ClinicsMessagesRules.LocationID, dbo.ClinicsMessagesRules.MessageTypeId,
	dbo.ClinicsMessagesRules.NoStatJobFrequency, dbo.ClinicsMessagesRules.SendTo, dbo.ClinicsMessagesRules.StatJobFrequency
	FROM   dbo.ClinicsMessages INNER JOIN dbo.ClinicsMessagesRules
	ON dbo.ClinicsMessages.MessageRuleId = dbo.ClinicsMessagesRules.MessageRuleId
  WHERE (dbo.ClinicsMessages.MessageStatus = @MessageStatus)
RETURN
GO
