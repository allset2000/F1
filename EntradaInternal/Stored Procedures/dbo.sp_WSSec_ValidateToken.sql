SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 5/03/2012
-- Description:	Validates user-login in applications
--		that rely on web services for data.
-- =============================================
CREATE PROCEDURE [dbo].[sp_WSSec_ValidateToken] 

	@Token varchar(250)


AS
BEGIN

	SELECT COUNT(*)
	FROM Security_Users WU WITH(NOLOCK)
	WHERE WU.bitActive = 1 AND
		WU.uidUserUID = @Token
				
END
GO
