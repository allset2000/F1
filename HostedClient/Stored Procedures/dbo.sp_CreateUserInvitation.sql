
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh Mukk
-- Create date: 01/14/2015
-- Description: SP used to Create new Invitation
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUserInvitation]
(
	@FirstName VARCHAR(100) = '',
	@MI VARCHAR(100) = '',
	@LastName VARCHAR(100) = '',
	@EmailAddress VARCHAR(100) = '',
	@PhoneNumber VARCHAR(15) = '',
	@ClinicId INT = -1,
	@InvitationMethod INT,
	@RoleId VARCHAR(500) = '',
	@SecurityToken VARCHAR(50),
	@InvitationTypeId INT,
	@RequestingUserId INT,
	@InvitationMessage VARCHAR(1500)
)
AS
BEGIN
INSERT INTO [dbo].[UserInvitations]
           ([FirstName]
           ,[MI]
           ,[LastName]
           ,[EmailAddress]
           ,[PhoneNumber]
           ,[InvitationSent]
           ,[ClinicId]
           ,[InvitationMethod]
           ,[RoleId]
           ,[SecurityToken]
           ,[DateTimeInvitationSent]
           ,[InvitationTypeId]
		   ,[RequestingUserId]
		   ,[DateTimeRequested]
		   ,[InvitationMessage])
     VALUES
           (@FirstName
           ,@MI
           ,@LastName
           ,@EmailAddress
           ,@PhoneNumber
           ,0
           ,@ClinicId
           ,@InvitationMethod
           ,@RoleId
           ,@SecurityToken
           ,GETDATE()
           ,@InvitationTypeId
		   ,@RequestingUserId
		   ,GETDATE()
		   ,@InvitationMessage)
END
GO
