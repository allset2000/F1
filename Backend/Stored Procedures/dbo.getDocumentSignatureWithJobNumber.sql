SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getDocumentSignatureWithJobNumber] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.DocumentSignatures
	WHERE (JobNumber = @JobNumber) AND (SignatureStatus <> 'X')
	ORDER BY SignatureStatus DESC, DocumentSignatureId DESC
RETURN

GO
