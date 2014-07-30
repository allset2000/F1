SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetDaysInMonth] (@CurrentDate datetime)
/* 
    Return table 
*/
RETURNS @DaysInMonthTable table
([ValidDate] [DateTime]
)
as
begin


declare @BOM smallDateTime
declare @EOM smalldateTime
declare @tempDate smallDateTime
SET @BOM = dbo.StartOfMonth(@CurrentDate)
SET @EOM = DATEADD (mm , 1, dbo.StartOfMonth(@CurrentDate) ) - 1

WHILE @BOM <= @EOM  
BEGIN  
 INSERT INTO @DaysInMonthTable (ValidDate)   
 VALUES(@BOM)  
 SET @BOM = @BOM + 1    
END

return
end

GO
