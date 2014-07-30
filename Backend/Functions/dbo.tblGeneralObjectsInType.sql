SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[tblGeneralObjectsInType](
	@ObjectType varchar(48)
)
RETURNS TABLE
AS
RETURN(	
	SELECT * FROM GeneralObjects
	WHERE (ObjectType = @ObjectType)
)
GO
