SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<A Raghu>
-- Create date: <08-10-2015>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateNewUserClinicCode] 
	-- Add the parameters for the stored procedure here
	@RegistrationCode varchar(50),
	@ClinicCode Varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Curr_ClinicID INT
	SELECT @Curr_ClinicID=ISNULL(ClinicId,0) FROM Userinvitations WITH(NOLOCK) WHERE SecurityToken=@RegistrationCode

	IF (@Curr_ClinicID<=0)
	   BEGIN
			IF EXISTS(SELECT '*' FROM SystemConfiguration where ConfigKey = 'SMDefaultClinic')
				BEGIN

					SELECT @ClinicCode=ClinicCode 
					FROM Clinics C WITH(NOLOCK)
					INNER JOIN SystemConfiguration SC ON CAST(SC.ConfigValue AS INT)=C.ClinicID
					WHERE ConfigKey = 'SMDefaultClinic'	
				   
				END			
		END

		SELECT COUNT(*) 
		      FROM Userinvitations U
		INNER JOIN Clinics C ON C.Clinicid = U.Clinicid
		WHERE C.Cliniccode=@ClinicCode and U.SecurityToken=@RegistrationCode
END


GO
