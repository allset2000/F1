SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CustomVocab_SpeakersAvail]

	@BatchProcessed int
	
	-- @BatchProcessed = -1 (No filter)
	--                 = 0 (Not reviewed or processed)
	--				   = 1 (Reviewed, but not processed)
	--				   = 2 (Bookmarked progress)

AS

BEGIN

IF @BatchProcessed = -1
	BEGIN
		SELECT DISTINCT(CVB.sSpeaker) as [SpeakerName],
			CVB.sVocab
		FROM CustomVocab_Batch CVB WITH(NOLOCK) 
		INNER JOIN CustomVocab_Words CVW WITH(NOLOCK) ON
			CVB.bintBatchID = CVW.bintBatchID
		GROUP BY sSpeaker,
				sVocab
		ORDER BY sSpeaker	
	END
	
ELSE
	IF @BatchProcessed = 0
		BEGIN
			SELECT DISTINCT(CVB.sSpeaker) as [SpeakerName],
				CVB.sVocab
			FROM CustomVocab_Batch CVB WITH(NOLOCK) 
			INNER JOIN CustomVocab_Words CVW WITH(NOLOCK) ON
				CVB.bintBatchID = CVW.bintBatchID
			WHERE CVW.dteReviewed IS NULL AND
				CVW.dteProcessed IS NULL
			GROUP BY sSpeaker,
					sVocab
			ORDER BY sSpeaker		
		END
		
	ELSE 
	
		IF @BatchProcessed = 1
			BEGIN 
				SELECT DISTINCT(CVB.sSpeaker) as [SpeakerName],
					CVB.sVocab
				FROM CustomVocab_Batch CVB WITH(NOLOCK) 
				INNER JOIN CustomVocab_Words CVW WITH(NOLOCK) ON
					CVB.bintBatchID = CVW.bintBatchID
				WHERE CVW.dteReviewed IS NOT NULL AND
					CVW.dteProcessed IS NULL AND
					CVB.bitReviewIncomplete = 0
				GROUP BY sSpeaker,
						sVocab
				ORDER BY sSpeaker		
			END
		ELSE --BatchProcessed = 2
			BEGIN 
				SELECT DISTINCT(CVB.sSpeaker) as [SpeakerName],
					CVB.sVocab
				FROM CustomVocab_Batch CVB WITH(NOLOCK) 
				INNER JOIN CustomVocab_Words CVW WITH(NOLOCK) ON
					CVB.bintBatchID = CVW.bintBatchID
				WHERE CVB.bitReviewIncomplete = 1
				GROUP BY sSpeaker,
						sVocab
				ORDER BY sSpeaker		
			END		

END


GO
