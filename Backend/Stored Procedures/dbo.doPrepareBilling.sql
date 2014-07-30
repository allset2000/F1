SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[doPrepareBilling] 
	-- Add the parameters for the stored procedure here
	@PeriodStart smalldatetime
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM Bills 
			WHERE (PeriodStart = @PeriodStart) AND (BillStatus = 'P')
					
			DELETE FROM BillItems 
			WHERE BillId NOT IN (SELECT BillId FROM Bills)
			
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
	RETURN
END

GO
