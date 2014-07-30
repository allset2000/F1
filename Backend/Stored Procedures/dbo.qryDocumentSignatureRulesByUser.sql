SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryDocumentSignatureRulesByUser] (
	@DictatorID varchar(50)
)
AS
  SELECT *
  FROM   dbo.vwDocumentSignatureRules
  WHERE ((ReviewerDictatorID = @DictatorID) OR (SignerDictatorID = @DictatorID)) AND (DocSignatureRuleStatus = 'A')
RETURN
GO
