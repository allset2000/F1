SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[fnParseString] (@DelimitedString VARCHAR(MAX), @Separator CHAR(1))
 
RETURNS
 
@ParsedTable TABLE (Instance NVARCHAR(80))

AS
 
BEGIN

	DECLARE @position int

	SET @position = 1 
	SET @DelimitedString = @DelimitedString + @Separator
	 
	 
	WHILE charindex(@Separator,@DelimitedString,@position) <> 0   

	BEGIN
	 
		INSERT into @ParsedTable 
		SELECT substring(@DelimitedString, @position, charindex(@Separator,@DelimitedString,@position) - @position)  

		SET @position = charindex(@Separator,@DelimitedString,@position) + 1 
	 
	END
	
	RETURN
	
END





GO
