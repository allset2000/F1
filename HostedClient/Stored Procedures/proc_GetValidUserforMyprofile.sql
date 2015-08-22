USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetValidUserforMyprofile]    Script Date: 8/17/2015 11:22:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Entrada_Dev
-- Create date: 06/21/2015
-- Description: SP used to validate a users password and application access based on the roles
-- =============================================
CREATE PROCEDURE [dbo].[proc_GetValidUserforMyprofile]
(
	@UserId INT,
	@ApplicationId INT
	
)
AS
BEGIN

	DECLARE @False bit
	DECLARE @True bit
	DECLARE @InvalidPassword int
	DECLARE @AppAccessInvalid int

	SET @False = 0
	SET @True = 1
	If exists (select * from sys.types WHERE is_table_type = 1 AND name ='user_inmem_myprofile')
drop type [dbo].[user_inmem_myprofile]

CREATE TYPE user_inmem_myprofile AS TABLE (
		[UserID] [int]  NOT NULL,
	[ClinicID] [int] NOT NULL,
	[LoginEmail] [varchar](100) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Password] [varchar](300) NOT NULL,
	[Salt] [varchar](300) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Deleted] [bit] NOT NULL ,
	[IsLockedOut] [bit] NOT NULL ,
	[LastPasswordReset] [datetime] NULL,
	[PasswordAttemptFailure] [int] NOT NULL ,
	[LastFailedAttempt] [datetime] NULL,
	[PWResetRequired] [bit] NOT NULL ,
	[SecurityToken] [varchar](100)  NULL ,
	[LastLoginDate] [datetime] NULL,
	[FirstName] [varchar](100) NULL,
	[MI] [varchar](50) NULL,
	[LastName] [varchar](100) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[TimeZoneId] [int] NULL,
	[FirstTimeLogin] [bit] NOT NULL ,
	[IsUserValidated] [bit]  NULL,
	[Auth] [bit] null,
	[AppAccess] [bit] null,
	[DowntimeAlertIDToHide] [int] null,
	[PhoneExtension] [int] null
	)


	DECLARE @mf user_inmem_myprofile
	Insert into  @mf       ([UserID]
			,[ClinicID]
           ,[LoginEmail]
           ,[Name]
           ,[Password]
           ,[Salt]
           ,[UserName]
           ,[Deleted]
           ,[IsLockedOut]
           ,[LastPasswordReset]
           ,[PasswordAttemptFailure]
           ,[LastFailedAttempt]
           ,[PWResetRequired]
           ,[SecurityToken]
           ,[LastLoginDate]
           ,[FirstName]
           ,[MI]
           ,[LastName]
           ,[PhoneNumber]
           ,[TimeZoneId]
           ,[FirstTimeLogin],[IsUserValidated],[DowntimeAlertIDToHide],[PhoneExtension]) Select * from dbo.Users where UserId=@UserId

	 
	 

	  	IF EXISTS (select * from @mf where UserID = @UserId and Deleted = 0)
	BEGIN
		-- Compare user roles for application access
		IF EXISTS (select * from UserRoleXref URX INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId WHERE URX.UserId = @UserId and RAX.ApplicationId = @ApplicationId and URX.IsDeleted = 0 and RAX.IsDeleted = 0)
		BEGIN
			
			update @mf set AUTH=1,APPACCESS=1 WHERE UserID = @UserId
		END
		ELSE
		BEGIN
			  -- User access validated (correct password) but application access denied
			update @mf set AUTH=1,APPACCESS=0 WHERE UserID = @UserId
		END
	END
	ELSE
	BEGIN
		  -- User access invalid, wrong password / application acess denied
		update @mf set AUTH=0,APPACCESS=0 WHERE UserID = @UserId
	END

	 select * from @mf
	END