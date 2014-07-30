SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_TddJobReProcess] 
	-- Add the parameters for the stored procedure here
	@JobNumber varchar(20)
AS
BEGIN
	DECLARE @DocStatus smallint;
	SELECT @DocStatus = DocumentStatus FROM Jobs WHERE JobNumber=@JobNumber;
	IF @DocStatus = 130
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
				INSERT INTO DocumentsToProcess VALUES (@JobNumber)
				INSERT INTO JobsTddReProcess VALUES(@JobNumber, SUSER_NAME(), GETDATE())
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 
			   BEGIN
				ROLLBACK TRANSACTION
								DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
								SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			   END
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('Invalid Document Status', 1, 1)
	END
	RETURN
END
GO
