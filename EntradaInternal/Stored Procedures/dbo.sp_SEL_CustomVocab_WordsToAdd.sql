SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CustomVocab_WordsToAdd]

	@Speaker varchar(500),
	@Topic varchar(500)
	
AS

BEGIN

	SELECT CVW.bintBatchID,
		CVW.bintWordID,
		CVW.sWord		
	FROM CustomVocab_Words CVW WITH(NOLOCK) 
	INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
		CVW.bintBatchID = CVB.bintBatchID
	WHERE CVB.sSpeaker = @Speaker AND
		CVB.sVocab = @Topic AND
		CVW.dteReviewed IS NOT NULL AND
		CVW.dteWordAdded IS NOT NULL AND
		CVW.dteProcessed IS NULL AND
		CVB.bitReviewIncomplete = 0
	ORDER BY CVW.bintBatchID,
		CVW.bintWordID

END


GO
