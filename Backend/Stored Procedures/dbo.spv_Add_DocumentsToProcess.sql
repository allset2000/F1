SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_Add_DocumentsToProcess]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Stored procedure to Add the Job to DocumentsToProcess table
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
CREATE PROCEDURE [dbo].[spv_Add_DocumentsToProcess]
				@JobNumber			VARCHAR(20)

AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO dbo.DocumentsToProcess
	        ( JobNumber, ProcessFailureCount )
	VALUES  ( @JobNumber, 0 )

END
GO
