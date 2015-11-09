/****** Object:  StoredProcedure [dbo].[sp_CheckROWLookup]    Script Date: 8/25/2015 6:58:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/23/2015  
-- Description: SP used to check duplicate ROW Lookupused in Admin Console
-- =============================================  
CREATE PROCEDURE [dbo].[sp_CheckROWLookup] 
(
	@ClinicID INT
	, @Category VARCHAR(100)
	, @Key VARCHAR(100)
)
AS
BEGIN
	SELECT COUNT(*)
	FROM ROW_Lookup
	WHERE ClinicID = @ClinicID AND Category = @Category AND [Key] = @Key
END



GO


