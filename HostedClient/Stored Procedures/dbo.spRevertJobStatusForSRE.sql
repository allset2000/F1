SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spRevertJobStatusForSRE]
(    
@vvcrJobNumber VARCHAR(20)
)     
AS    
BEGIN 
	UPDATE jobs SET Status = 300,UpdatedDateInUTC=GETUTCDATE() WHERE JobNumber =  @vvcrJobNumber AND Status=350
END 



GO
