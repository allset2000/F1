SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh
-- Create date: 03/24/2015
-- Description: SP used to obtain all Clinic Message Rules
-- Modified date: 01/19/2016
-- Description: Pulling Dictators, Jobtypes, Users as comma separated values from child tables
-- =============================================
CREATE PROCEDURE [dbo].[qryGetAllMessageRules]
AS
BEGIN
	SELECT [ClinicsMessagesRules].[MessageRuleId]
		  ,[ClinicsMessagesRules].[MessageTypeId]
		  ,[ClinicsMessagesRules].[ClinicID]
		  ,[ClinicsMessagesRules].[LocationID]
		  ,(SELECT STUFF((SELECT ', ' + DictatorId FROM ClinicMessageRuleDictators WHERE MessageRuleId = [ClinicsMessagesRules].[MessageRuleId] FOR XML PATH('')),1,1,'')) AS [DictatorID]
		  ,(SELECT STUFF((SELECT ', ' + JobType FROM ClinicMessageRuleJobtypes WHERE MessageRuleId = [ClinicsMessagesRules].[MessageRuleId] FOR XML PATH('')),1,1,'')) AS [JobType]
		  ,[ClinicsMessagesRules].[StatJobSubjectPattern]
		  ,[ClinicsMessagesRules].[StatJobContentPattern]
		  ,[ClinicsMessagesRules].[NoStatJobSubjectPattern]
		  ,[ClinicsMessagesRules].[NoStatJobContentPattern]
		  ,[ClinicsMessagesRules].[SendTo]
		  ,[ClinicsMessagesRules].[StatJobFrequency]
		  ,[ClinicsMessagesRules].[NoStatJobFrequency]
		  ,(SELECT STUFF((SELECT ', ' + CONVERT(VARCHAR,UserId) FROM ClinicMessageRuleUsers WHERE MessageRuleId = [ClinicsMessagesRules].[MessageRuleId] FOR XML PATH('')),1,1,'')) AS [UserId]
		  ,CASE WHEN [MessageTypeId] = 1 THEN 'CRJobAvailable'
				WHEN [MessageTypeId] = 2 THEN 'OrphanJobAvailable' END AS [NotificationType]
		  ,(SELECT STUFF((SELECT ', ' + [Contacts].FullName FROM [Contacts] WHERE [Contacts].ContactId IN (SELECT UserId FROM ClinicMessageRuleUsers WHERE MessageRuleId = [ClinicsMessagesRules].[MessageRuleId]) FOR XML PATH('')),1,1,'')) AS [User]
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
