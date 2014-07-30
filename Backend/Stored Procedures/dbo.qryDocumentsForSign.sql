SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryDocumentsForSign] (
	@DictatorID varchar(50)
)
AS
  SELECT *
  FROM   dbo.vwDocuments
  WHERE (DocumentStatus = 150 OR DocumentStatus = 155) AND
        ((DictatorID IN (SELECT ReviewerDictatorID 
						 FROM DocumentSignatureRules 
						 WHERE ((ReviewerDictatorID = @DictatorID OR (SignerDictatorID = @DictatorID)) AND DocSignatureRuleStatus = 'A'))) OR 
         (DictatorID IN (SELECT SignerDictatorID 
						 FROM DocumentSignatureRules 
						 WHERE ((ReviewerDictatorID = @DictatorID OR (SignerDictatorID = @DictatorID)) AND DocSignatureRuleStatus = 'A'))) )
RETURN
GO
