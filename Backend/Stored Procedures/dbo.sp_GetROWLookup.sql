
/****** Object:  StoredProcedure [dbo].[sp_GetROWLookup]    Script Date: 8/17/2015 12:50:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to get ROW Lookup to display in AdminConsole
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetROWLookup]
(
	@ClinicID INT
	, @Category VARCHAR(100)
	, @Key VARCHAR(100)
)
AS
BEGIN
	SELECT ClinicID, Category, [Key], Value 
	FROM ROW_Lookup
	WHERE ClinicID = @ClinicID AND Category = @Category AND [Key] = @Key
END



GO


