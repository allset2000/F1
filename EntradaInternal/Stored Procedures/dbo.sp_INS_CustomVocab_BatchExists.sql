SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_INS_CustomVocab_BatchExists]
	@Speaker varchar(500),
	@Vocab varchar(500),
	@FileName varchar(500),
	@Reviewed bit,
	@TentativeSave bit,
	@BatchID bigint,
	@FileID bigint OUTPUT
	

	
AS

BEGIN
	
	DECLARE @Count int
	
	SELECT @FileID = bintFileID
	FROM [EntradaInternal].[dbo].[CustomVocab_WordFiles]
	WHERE bintBatchID = @BatchID
		AND sFileName = @FileName

	IF @FileID IS NULL
		BEGIN
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

				END
		END

END


GO
