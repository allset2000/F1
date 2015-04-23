-- =============================================
-- Author: Santhosh
-- Create date: 03/24/2015
-- Description: SP used to get Clinic Message Rule
CREATE PROCEDURE [dbo].[getMessageRuleByID]
(
	@MessageRuleId INT = -1
)
AS
BEGIN
	SELECT [ClinicsMessagesRules].[MessageRuleId]
		  ,[ClinicsMessagesRules].[MessageTypeId]
		  ,[ClinicsMessagesRules].[ClinicID]
		  ,[ClinicsMessagesRules].[LocationID]
		  ,[ClinicsMessagesRules].[DictatorID]
		  ,[ClinicsMessagesRules].[JobType]
		  ,[ClinicsMessagesRules].[StatJobSubjectPattern]
		  ,[ClinicsMessagesRules].[StatJobContentPattern]
		  ,[ClinicsMessagesRules].[NoStatJobSubjectPattern]
		  ,[ClinicsMessagesRules].[NoStatJobContentPattern]
		  ,[ClinicsMessagesRules].[SendTo]
		  ,[ClinicsMessagesRules].[StatJobFrequency]
		  ,[ClinicsMessagesRules].[NoStatJobFrequency]
		  ,[ClinicsMessagesRules].[UserID]
		  ,CASE WHEN [MessageTypeId] = 1 THEN 'CRJobAvailable'
				WHEN [MessageTypeId] = 2 THEN 'OrphanJobAvailable' END AS [NotificationType]
		  ,[Contacts].FullName AS [User]
		  ,[Locations].[LocationName]
		  ,[Clinics].[ClinicName]
	  FROM [dbo].[ClinicsMessagesRules]
	  INNER JOIN [Clinics] ON [Clinics].ClinicID = [ClinicsMessagesRules].ClinicID
	  INNER JOIN [Locations] ON [Locations].LocationID = [ClinicsMessagesRules].LocationID
					AND [Locations].ClinicID = [ClinicsMessagesRules].ClinicID
	  LEFT JOIN [Contacts] ON [Contacts].ContactId = [ClinicsMessagesRules].[UserID]
	  WHERE [ClinicsMessagesRules].[MessageRuleId] = @MessageRuleId
END
GO


