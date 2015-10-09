USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[sp_ValidateNewUserClinicCode]    Script Date: 09-10-2015 12:08:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

		SELECT COUNT(*) 
		      FROM Userinvitations U
		INNER JOIN Clinics C ON C.Clinicid = U.Clinicid
		WHERE C.Cliniccode=@ClinicCode and U.SecurityToken=@RegistrationCode
END
