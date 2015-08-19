USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetPassHistory]    Script Date: 8/17/2015 11:19:46 AM ******/
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
CREATE PROCEDURE [dbo].[proc_GetPassHistory] (

	
	@userid int
) AS 
BEGIN

SELECT        PwdId, PassCode, IsActive, DateCreated, UserId,Salt
FROM            PasscodeHistory
WHERE        (UserId = @userid) AND (IsActive = 1)

END