SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftGetGeneralObjectId] (
  @ObjectType varchar(48),
  @ObjectUniqueKey varchar(48)
)
RETURNS int
AS
BEGIN
	DECLARE @ObjectId int

	SELECT @ObjectId = ObjectId
	FROM GeneralObjects
	WHERE (ObjectType = @ObjectType) AND (ObjectUniqueKey = @ObjectUniqueKey)

	RETURN @ObjectId
END
GO
