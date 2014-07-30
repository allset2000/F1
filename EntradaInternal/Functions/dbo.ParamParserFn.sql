SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
change log:

date	username		description
4/1/13	jablumenthal	changed the @delimString datatype from varchar(255)
						to varchar(max); changed the TABLE.Id datatype from varchar(250)
						to varchar(max) because I am creating a report with a large
						select list for an input parameter.  The report was not functioning
						when selecting 'all' because the datatypes for the above parameters 
						were not large enough to handle the whole parameter string.
======================================================= */
CREATE FUNCTION [dbo].[ParamParserFn]( @delimString varchar(max), @delim char(1)) 
    RETURNS @paramtable 
    TABLE ( Id varchar(max) ) 
    AS BEGIN

    DECLARE @len int,
            @index int,
            @nextindex int

    SET @len = DATALENGTH(@delimString)
    SET @index = 0
    SET @nextindex = 0


    WHILE (@len > @index )
    BEGIN

    SET @nextindex = CHARINDEX(@delim, @delimString, @index)

    if (@nextindex = 0 ) SET @nextindex = @len + 2

     INSERT @paramtable
     SELECT SUBSTRING( @delimString, @index, @nextindex - @index )


    SET @index = @nextindex + 1

    END
     RETURN
    END
GO
