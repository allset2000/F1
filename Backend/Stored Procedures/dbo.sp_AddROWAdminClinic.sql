SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_AddROWAdminClinic] 
	-- Add the parameters for the stored procedure here
	@Username varchar(20),
	@ClinicID smallint
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO ROW_AdminsClinics(Admin_ID, Clinic_ID) VALUES(@Username, @ClinicID)
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
