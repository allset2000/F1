
/****** Object:  StoredProcedure [dbo].[sp_InsertROWLookup]    Script Date: 8/17/2015 12:46:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to insert ROW Lookup to display in AdminConsole
-- =============================================  
CREATE PROCEDURE [dbo].[sp_InsertROWLookup]
(
	@ClinicID INT
	, @Category VARCHAR(100)
	, @Key VARCHAR(100)
	, @Value VARCHAR(100)
)
AS
BEGIN
	IF EXISTS(SELECT * FROM ROW_Lookup WHERE ClinicID = @ClinicID AND Category = @Category AND [Key] = @Key)
	BEGIN
		UPDATE ROW_Lookup
		SET Value = @Value
		WHERE ClinicID = @ClinicID AND Category = @Category AND [Key] = @Key
	END
	ELSE
	BEGIN
		INSERT INTO ROW_Lookup VALUES
		(@ClinicID, @Category, @Key, @Value)
	END
END



GO


