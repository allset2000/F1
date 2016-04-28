SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_Update_JobDocuments]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Stored procedure to Update Job Document (if already exists) or add Job Document (if does'nt exist already)
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04/27/2016   | Naga					| Initial Design
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
CREATE PROCEDURE [dbo].[spv_Update_JobDocuments]
				@JobNumber			VARCHAR(20),
				@Doc				VARBINARY(MAX) = NULL,
				@XmlData			XML = NULL,
				@UserName			VARCHAR(200),
				@DocDate			DATETIME = GETDATE,
				@DocumentId			INT = 0,
				@DocumentTypeId		INT = 0,
				@DocumentStatusId	INT = 0,
				@JobId				INT = 0,
				@Status				SMALLINT,
				@StatusDate			DATETIME = GETDATE,
				@TemplateName		VARCHAR(100)

AS
BEGIN

	SET NOCOUNT ON;

	-- If the Jobs Document doesn't contain an entry for this JobNumber, then add the record
	IF NOT EXISTS (SELECT 1 FROM dbo.Jobs_Documents WHERE JobNumber = @JobNumber)
	BEGIN
		INSERT INTO dbo.Jobs_Documents
				( JobNumber , Doc , XmlData , Username , DocDate , DocumentId , DocumentTypeId , DocumentStatusId , JobId , [Status] , StatusDate )
		VALUES  
				( @JobNumber , @Doc , @XmlData , @UserName , @DocDate , 0 , 0 , 0 , 0 , 0 , @StatusDate )
	END
	ELSE
	BEGIN
		-- Otherwise add a history record and update the Jobs Document
		INSERT INTO dbo.Jobs_Documents_History
		        ( JobNumber , Doc , XmlData , Username , DocDate , DocumentIdOk , DocumentTypeId , DocumentStatusId , JobId , TemplateName , [Status] , StatusDate )
		SELECT  JobNumber , Doc , XmlData , Username , DocDate , 0 , DocumentTypeId , DocumentStatusId , JobId , @TemplateName , [Status] , StatusDate 
			FROM dbo.Jobs_Documents WHERE JobNumber = @JobNumber
		
		UPDATE dbo.Jobs_Documents
		SET Doc = @Doc, 
			XmlData = @XmlData, 
			Username = @UserName, 
			DocDate = @DocDate, 
			DocumentId = @DocumentId, 
			DocumentTypeId = @DocumentTypeId, 
			DocumentStatusId = @DocumentStatusId, 
			JobId = @JobId, 
			[Status] = @Status, 
			StatusDate = @StatusDate
	END

END
GO
