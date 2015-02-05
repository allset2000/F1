SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author: Dustin Dorsey
-- Create date: 2/5/2014
-- Description: Temporary SP used to manually update express link API Keys 
-- Part of Redmine ticket 3345
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3345_UpdateExpressLinkAPIKey]

@apikey uniqueidentifier,
@ID int

AS 

Begin Tran

update EntradaHostedClient.dbo.ExpressLinkConfigurations set apikey = @apikey where ID = @ID

Commit Tran



GO
