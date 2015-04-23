-- =============================================
-- Author: Santhosh
-- Create date: 03/24/2015
-- Description: SP used to obtain all Clinic Message Rules
-- =============================================
CREATE PROCEDURE [dbo].[qryGetAllMessageRules]
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
		  ,[Contacts].FirstName + ' '+ [Contacts].LastName AS [User]
		  ,[Locations].[LocationName]
		  ,[Clinics].[ClinicName]
	  FROM [dbo].[ClinicsMessagesRules]
	  INNER JOIN [Clinics] ON [Clinics].ClinicID = [ClinicsMessagesRules].ClinicID
	  INNER JOIN [Locations] ON [Locations].LocationID = [ClinicsMessagesRules].LocationID
					AND [Locations].ClinicID = [ClinicsMessagesRules].ClinicID
	  LEFT JOIN [Contacts] ON [Contacts].ContactId = [ClinicsMessagesRules].[UserID]
	  ORDER BY [MessageRuleId] DESC
END

GO


