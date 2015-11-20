/******************************          
** File:  spSetSQLCompatibilityLevel.sql          
** Name:  spSetSQLCompatibilityLevel          
** Desc:  Set the Data base comapatibility level to 2008 or 2014          
** Auth:  Suresh          
** Date:  04/Nov/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/   
CREATE PROCEDURE spSetSQLCompatibilityLevel(
	@vintMode int
)
AS
BEGIN
DECLARE @DatabaseName varchar(100)
DECLARE @sql VARCHAR(MAX)
	SET @DatabaseName = DB_Name()
	SET @sql = 'USE [master] ALTER DATABASE '+ @DatabaseName +' SET COMPATIBILITY_LEVEL = ' + convert(varchar,@vintMode)
	EXEC (@sql) 
END
