SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/23/2014
-- Description: SP called from DictateAPI to pull Job Types to sync on mobile

-- =============================================
CREATE PROCEDURE [dbo].[sp_GetExpressNotesTagsByJobTypeID](
	 @JobTypeID INT
) AS 
BEGIN

		SET NOCOUNT ON;

		SELECT TagID,
		        Name,
				[Required]
		 FROM dbo.[ExpressNotesTags]
		 WHERE JobTypeID=@JobTypeID
		
END


GO
