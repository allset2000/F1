SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 4/30/15
-- Description: Temp SP used to update connectionstring in ExpressLinkConfiguration Table
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM2682_UpdateExpressLinkConnString] 
(
@ID int,
@ConnectionString Varchar(MAX)
) 

AS 

BEGIN
	
update expressLinkConfigurations 
set connectionstring = @ConnectionString
where ID = @ID 
	
END

GO
