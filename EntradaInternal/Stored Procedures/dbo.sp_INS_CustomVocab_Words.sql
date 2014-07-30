SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_INS_CustomVocab_Words]
	@BatchID bigint,
	@FileID bigint,
	@Word varchar(250),
	@ManualAdd bit,
	@Speaker varchar(500),
	@Vocab varchar(500)
	
AS

BEGIN

	DECLARE @ExistingWordID bigint,
			@PreviouslyAdded datetime

	
	SELECT @ExistingWordID = CVW.bintWordID,
		@PreviouslyAdded = CVW.dteWordAdded
	FROM CustomVocab_Words CVW WITH(NOLOCK)
	INNER JOIN CustomVocab_Batch CVB WITH(NOLOCK) ON
		CVW.bintBatchID = CVB.bintBatchID
	WHERE CVB.sSpeaker = @Speaker AND
		CVB.sVocab = @Vocab AND
		CVW.sWord = @Word 

	
	IF @PreviouslyAdded IS NOT NULL
		BEGIN
			UPDATE CustomVocab_Words
			SET sWord = @Word
			WHERE bintWordID = @ExistingWordID
		END
	ELSE
		BEGIN
		
			IF @ExistingWordID IS NOT NULL AND @PreviouslyAdded IS NULL
				BEGIN
					DELETE FROM CustomVocab_Words
					WHERE bintWordID = @ExistingWordID
				END
				
						
			INSERT INTO CustomVocab_Words
			(bintBatchID,
			bintFileID,
			sWord,
			bitManualAdd)
			VALUES
			(@BatchID,
			@FileID,
			@Word,
			@ManualAdd)
		END

END
GO
