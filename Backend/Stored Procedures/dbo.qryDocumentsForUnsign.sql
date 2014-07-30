SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[qryDocumentsForUnsign] (
	@DictatorID varchar(50)
)
AS
  SELECT *
  FROM   dbo.vwDocuments
  WHERE (DocumentStatus IN (160, 170)) AND 
        (JobNumber IN (SELECT JobNumber FROM DocumentSignatures WHERE (DocSignatureMode = 'S') AND (SignatureStatus = 'A') AND (AppliedBy = @DictatorID)) )
RETURN
GO
