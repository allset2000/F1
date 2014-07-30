SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CustomVocab_Schema]

	@BatchProcessed int,
	@Speaker varchar(500),
	@Topic varchar(500)
	
	
	-- @BatchProcessed = -1 (No filter)
	--                 = 0 (Not reviewed or processed)
	--				   = 1 (Reviewed, but not processed)
	--				   = 2 (Bookmarked progress)
AS

BEGIN

	IF @BatchProcessed = -1
		BEGIN
		--Unselected Words
			SELECT CVW.bintBatchID,
				CVW.bintWordID,
				CVW.sWord,
				CVW.bitManualAdd,
				CVW.dteProcessed,
				CVW.dteReviewed,
				CVW.dteWordAdded
			FROM CustomVocab_Words CVW WITH(NOLOCK)
			INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
				CVW.bintBatchID = CVB.bintBatchID
			WHERE	CVB.sSpeaker = @Speaker AND 
				CVB.sVocab = @Topic AND
				CVW.dteWordAdded IS NULL
			ORDER BY sWord
			
		--Selected Words
			SELECT CVW.bintBatchID,
				CVW.bintWordID,
				CVW.sWord,
				CVW.bitManualAdd,
				CVW.dteProcessed,
				CVW.dteReviewed,
				CVW.dteWordAdded
			FROM CustomVocab_Words CVW WITH(NOLOCK)
			INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
				CVW.bintBatchID = CVB.bintBatchID
			WHERE	CVB.sSpeaker = @Speaker AND 
				CVB.sVocab = @Topic AND
				CVW.dteWordAdded IS NOT NULL
			ORDER BY sWord
			
		END		
	ELSE
		IF @BatchProcessed = 0
			BEGIN
				SELECT CVW.bintBatchID,
					CVW.bintWordID,
					CVW.sWord,
					CVW.bitManualAdd,
					CVW.dteProcessed,
					CVW.dteReviewed,
					CVW.dteWordAdded
				FROM CustomVocab_Words CVW WITH(NOLOCK)
				INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
					CVW.bintBatchID = CVB.bintBatchID
				WHERE CVW.dteReviewed IS NULL AND
					CVW.dteProcessed IS NULL AND
					CVB.sSpeaker = @Speaker AND 
					CVB.sVocab = @Topic
				ORDER BY sWord
			END
		ELSE 
			IF @BatchProcessed = 1
				BEGIN
				
				--Unselected Words
					SELECT CVW.bintBatchID,
						CVW.bintWordID,
						CVW.sWord,
						CVW.bitManualAdd,
						CVW.dteProcessed,
						CVW.dteReviewed,
						CVW.dteWordAdded
					FROM CustomVocab_Words CVW WITH(NOLOCK)
					INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
						CVW.bintBatchID = CVB.bintBatchID
					WHERE CVW.dteWordAdded IS NULL AND
						CVW.dteReviewed IS NOT NULL AND
						CVW.dteProcessed IS NULL AND
						CVB.bitReviewIncomplete = 0 AND
						CVB.sSpeaker = @Speaker AND 
						CVB.sVocab = @Topic
					ORDER BY sWord
				
				--Selected Words
					SELECT CVW.bintBatchID,
						CVW.bintWordID,
						CVW.sWord,
						CVW.bitManualAdd,
						CVW.dteProcessed,
						CVW.dteReviewed,
						CVW.dteWordAdded
					FROM CustomVocab_Words CVW WITH(NOLOCK)
					INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
						CVW.bintBatchID = CVB.bintBatchID
					WHERE CVW.dteWordAdded IS NOT NULL AND
						CVW.dteReviewed IS NOT NULL AND
						CVW.dteProcessed IS NULL AND
						CVB.bitReviewIncomplete = 0 AND
						CVB.sSpeaker = @Speaker AND 
						CVB.sVocab = @Topic
					ORDER BY sWord						
				END		
			ELSE
				BEGIN  -- BatchProcessed = 2
				
				--Unselected Words
					SELECT CVW.bintBatchID,
						CVW.bintWordID,
						CVW.sWord,
						CVW.bitManualAdd,
						CVW.dteProcessed,
						CVW.dteReviewed,
						CVW.dteWordAdded
					FROM CustomVocab_Words CVW WITH(NOLOCK)
					INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
						CVW.bintBatchID = CVB.bintBatchID
					WHERE CVW.dteWordAdded IS NULL AND
						CVB.bitReviewIncomplete = 1 AND
						CVB.sSpeaker = @Speaker AND 
						CVB.sVocab = @Topic
					ORDER BY sWord		
					
				--Selected Words
					SELECT CVW.bintBatchID,
						CVW.bintWordID,
						CVW.sWord,
						CVW.bitManualAdd,
						CVW.dteProcessed,
						CVW.dteReviewed,
						CVW.dteWordAdded
					FROM CustomVocab_Words CVW WITH(NOLOCK)
					INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
						CVW.bintBatchID = CVB.bintBatchID
					WHERE CVW.dteWordAdded IS NOT NULL AND
						CVB.bitReviewIncomplete = 1 AND
						CVB.sSpeaker = @Speaker AND 
						CVB.sVocab = @Topic
					ORDER BY sWord				
				END
END


GO
