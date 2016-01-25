SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Raghu A>
-- Create date: <1/18/2016>
-- Description:	<get quickbox user details by registration code> ============
CREATE PROCEDURE [dbo].[sp_GetQuickBloxUserByRegCode] 
	-- Add the parameters for the stored procedure here
	@RegistrationCode Varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
		SELECT QB.* 
		FROM dbo.QuickBloxUsers QB
		 INNER JOIN dbo.UserInvitations UI on UI.RegisteredUserId=QB.UserID    
		WHERE UI.SecurityToken=@RegistrationCode
	 
END
GO
