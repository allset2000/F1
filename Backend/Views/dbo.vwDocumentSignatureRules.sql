SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwDocumentSignatureRules]
AS
SELECT     dbo.DocumentSignatureRules.DocSignatureRuleId, dbo.DocumentSignatureRules.DocSignatureRuleType, dbo.DocumentSignatureRules.ClinicRuleID, 
                      dbo.DocumentSignatureRules.LocationRuleID, dbo.DocumentSignatureRules.JobTypeRule, dbo.DocumentSignatureRules.ReviewerDictatorID, 
                      dbo.DocumentSignatureRules.SignerDictatorID, dbo.DocumentSignatureRules.ReviewerStampLocation, dbo.DocumentSignatureRules.SignerStampLocation, 
                      dbo.DocumentSignatureRules.ReviewerStamp, dbo.DocumentSignatureRules.SignerStamp, dbo.DocumentSignatureRules.SignerUnsignStamp, 
                      dbo.DocumentSignatureRules.DocSignatureRuleStatus, ISNULL(dbo.Dictators.ClinicID, 0) AS SignerClinicID, ISNULL(dbo.Dictators.FirstName, '') AS SignerFirstName, 
                      ISNULL(dbo.Dictators.MI, '') AS SignerMI, ISNULL(dbo.Dictators.LastName, '') AS SignerLastName
FROM         dbo.DocumentSignatureRules INNER JOIN
                      dbo.Dictators ON dbo.DocumentSignatureRules.SignerDictatorID = dbo.Dictators.DictatorID
GO
