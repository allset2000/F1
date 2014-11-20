
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/7/2014
-- Description: SP used to pull Account Specific Documents for Edit1 (currently used by dictateAPI)
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClinicASDocuments] (
	 @ClinicId int
) AS 
BEGIN
	SELECT ClinicDocumentID,FileName 
	FROM ClinicDocuments 
	WHERE ClinicId = @ClinicId AND IsAccountSpecific = 1
	ORDER BY FileName
END


GO
