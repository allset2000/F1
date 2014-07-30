SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_UPD_CustomVocab_Processed]
	@BatchID bigint,
	@WordID bigint,
	@Word varchar(250),
	@ManualAdd bit,
	@Reviewed bit,
	@Processed bit,
	@WordAdded bit,
	@Tentative bit
AS
BEGIN
	
	IF @WordID IS NOT NULL
		BEGIN
			IF @WordID > 0
				IF @Processed > 0
					BEGIN
						UPDATE CustomVocab_Words
						SET dteProcessed = CASE @Processed
												WHEN 1 THEN GETDATE()
												ELSE NULL
											END
						WHERE bintWordID = @WordID
					END
				ELSE
					BEGIN
						UPDATE CustomVocab_Words
						SET dteProcessed = CASE @Processed
												WHEN 1 THEN GETDATE()
												ELSE NULL
											END,
							dteReviewed = CASE @Reviewed
												WHEN 1 THEN GETDATE()
												ELSE NULL
											END,
							dteWordAdded = CASE @WordAdded
												WHEN 1 THEN GETDATE()
												ELSE NULL
											END,
							sWord = @Word
						WHERE bintWordID = @WordID
					END
			ELSE
				BEGIN
					INSERT INTO CustomVocab_Words(
						dteProcessed,
						sWord,
						bintBatchID,
						dteReviewed,
						bitManualAdd,
						dteWordAdded,
						bintFileID
						)
					VALUES
						(CASE @Processed
								WHEN 1 THEN GETDATE()
								ELSE NULL
							END,
						@Word,
						@BatchID,
						CASE @Reviewed
							WHEN 1 THEN GETDATE()
							ELSE NULL
						END,
						@ManualAdd,
						CASE @WordAdded
							WHEN 1 THEN GETDATE()
							ELSE NULL
						END,
						0)
				END
		END

	ELSE
		BEGIN
			UPDATE CustomVocab_Batch
			SET dteBatchProcessed = CASE @Processed
										WHEN 1 THEN GETDATE()
										ELSE NULL
									END,
				dteBatchReviewed = CASE @Reviewed
										WHEN 1 THEN GETDATE()
										ELSE NULL
									END,
				bitReviewIncomplete = @Tentative
			WHERE bintBatchID = @BatchID	
			
		
			UPDATE CustomVocab_Words
			SET dteProcessed = CASE @Processed
									WHEN 1 THEN GETDATE()
									ELSE NULL
								END,
				dteReviewed = CASE @Reviewed
										WHEN 1 THEN GETDATE()
										ELSE NULL
									END
			WHERE bintBatchID = @BatchID	
		END

END



GO
