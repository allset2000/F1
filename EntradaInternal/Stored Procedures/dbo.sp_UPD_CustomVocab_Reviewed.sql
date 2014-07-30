SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_UPD_CustomVocab_Reviewed]
	@BatchID bigint,
	@Tentative bit

AS
BEGIN

			UPDATE CustomVocab_Batch
			SET dteBatchReviewed = GETDATE(),
				bitReviewIncomplete = @Tentative
			WHERE bintBatchID = @BatchID	
			
		
			UPDATE CustomVocab_Words
			SET dteReviewed = GETDATE()
			WHERE bintBatchID = @BatchID	
END



GO
