SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/22/2014
-- Description: SP used to remove a document from ClinicsDocuments and log who did it
-- =============================================
CREATE PROCEDURE [dbo].[sp_RemoveClinicDocument] (
	 @DocumentId int,
	 @ChangedBy varchar(100)
) AS 
BEGIN
	
	DECLARE @DocumentName varchar(200)
	DECLARE @ClinicID INT
	
	SELECT @DocumentName=FileName,@ClinicID=ClinicId FROM ClinicDocuments WHERE ClinicDocumentID = @DocumentId
	
	INSERT INTO EventHistory(EventMessage,Parameters,EventBy,EventDate) values('Removed Clinic Document: ' + @DocumentName, '<ClinicId>' + CAST(@ClinicId as VARCHAR(10)) + '</ClinicId><DocumentId>' + CAST(@DocumentId as VARCHAR(10)) + '</DocumentId><FileName>' + @DocumentName + '</FileName>',@ChangedBy,GETDATE())
	
	DELETE FROM ClinicDocuments WHERE ClinicDocumentID = @DocumentId
	
END


GO
