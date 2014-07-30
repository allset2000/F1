SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_INS_CustomVocab_Batch]
	@Speaker varchar(500),
	@Vocab varchar(500),
	@FileName varchar(500),
	@Reviewed bit,
	@TentativeSave bit,
	@FileID bigint OUTPUT,
	@BatchID bigint OUTPUT

	
AS

BEGIN
	
	SET @FileID = 0
	
	INSERT INTO CustomVocab_Batch
	(sSpeaker,
	sVocab,
	dteBatchReviewed,
	bitReviewIncomplete)
	VALUES
	(@Speaker,
	@Vocab,
	CASE @Reviewed
		WHEN 1 THEN GETDATE()
		ELSE NULL
	END,
	@TentativeSave)

	SET @BatchID = @@IDENTITY

	IF @FileName != ''
		BEGIN
			INSERT INTO [EntradaInternal].[dbo].[CustomVocab_WordFiles]
				   ([sFileName],
				   [bintBatchID])
			VALUES
			(
					@FileName,
					@BatchID
			)
			
			SET @FileID = @@IDENTITY
			--IF EXISTS(SELECT *
			--		FROM CustomVocab_WordFiles
			--		WHERE sFileName = @FileName
			--			AND bintBatchID = 
		END


	SELECT @BatchID, @FileID


END


GO
