USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateuserWithShowalerts]    Script Date: 8/17/2015 11:23:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Entrada_Dev
-- Create date: 06/21/2015
-- Description: SP used to validate a users password and application access based on the roles
-- =============================================
CREATE PROCEDURE [dbo].[proc_UpdateuserWithShowalerts]
(
	@UserId INT,
	@alertId Int
	
)
AS
BEGIN
UPDATE    Users
SET            DowntimeAlertIDToHide = @alertId
WHERE     (UserID = @userId)

	END