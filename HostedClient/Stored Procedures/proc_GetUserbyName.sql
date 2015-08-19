USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetUserbyName]    Script Date: 8/17/2015 11:21:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/14/2015
-- Description: SP used to pull the User Entity (object) from the DB

--Created by:Entrada dev
--Creation Date:06/12/2015
-- =============================================
CREATE PROCEDURE [dbo].[proc_GetUserbyName] (
	@UserName varchar(100)
) AS 
BEGIN
	SELECT UserID, UserName, ClinicId, LoginEmail, Name, Password, Salt, Deleted, IsLockedOut,LastPasswordReset,PasswordAttemptFailure,LastFailedAttempt,PWResetRequired,SecurityToken,LastLoginDate,Firstname,Lastname
	FROM Users where UserName = @UserName
END