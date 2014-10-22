
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/20/2014
-- Description: SP used to pull a document for a clinic by id
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClinicDocumentById] (
	 @DocumentId int
) AS 
BEGIN
	SELECT ClinicDocumentID,ClinicId,DocumentFile,FileName,FileContentType,IsAccountSpecific,DateCreated,DateUpdated FROM ClinicDocuments WHERE ClinicDocumentID = @DocumentId
END


GO
