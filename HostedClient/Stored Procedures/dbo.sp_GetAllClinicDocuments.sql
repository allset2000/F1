SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/13/2014
-- Description: SP used to pull all documents mapped to a specifc clinic, used by Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllClinicDocuments] (
	 @ClinicId int
) AS 
BEGIN
	SELECT ClinicDocumentID,ClinicId,DocumentFile,FileName,FileContentType,DateCreated,DateUpdated FROM ClinicDocuments WHERE ClinicId = @ClinicId
END


GO
