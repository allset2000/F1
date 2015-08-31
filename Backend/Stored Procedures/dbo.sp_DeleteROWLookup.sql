
/****** Object:  StoredProcedure [dbo].[sp_DeleteROWLookup]    Script Date: 8/17/2015 12:48:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to delete ROW Lookup in AdminConsole
-- =============================================  
CREATE PROCEDURE [dbo].[sp_DeleteROWLookup]
(
	@ClinicID INT
	, @Category VARCHAR(100)
	, @Key VARCHAR(100)
)
AS
BEGIN
	DELETE 
	FROM ROW_Lookup
	WHERE ClinicID = @ClinicID AND Category = @Category AND [Key] = @Key
	SELECT 1
END



GO


