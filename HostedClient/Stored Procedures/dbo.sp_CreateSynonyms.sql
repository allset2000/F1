SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 12/9/2014
-- Description: SP used to create synonyms on a database
-- =============================================

CREATE PROCEDURE [dbo].[sp_CreateSynonyms]

@DatabaseOn varchar(75),
@DatabaseTo varchar(75),
@Prefix char(2) 

/*
EH - EntradahostedClient
EA - Entrada_Archive
CR - Crashtrack
EN - Entrada
EI - EntradaInternal
EU - EntradaUsers
*/

AS

BEGIN 

SET NOCOUNT ON

DECLARE @sql VARCHAR(8000)
DECLARE @sql1 varchar(Max)
DECLARE @sql2 varchar(Max)

-- Drops Temp Table if Exists

IF OBJECT_ID('tempdb..#AllTables') IS NOT NULL DROP TABLE #AllTables
IF OBJECT_ID('tempdb..#ExistingSynonyms') IS NOT NULL DROP TABLE #ExistingSynonyms

-- Creates a temp table to collect database name and table name for @DatabaseTo 

CREATE TABLE #AllTables ([DB Name] sysname, [Schema Name] sysname, [Table Name] sysname, [Table Type] sysname)
CREATE TABLE #ExistingSynonyms ([SynonymName] sysname)

SELECT @SQL1 = COALESCE(@SQL,'') + '
insert into #AllTables
 
select ' + QUOTENAME(name,'''') + ' as [DB Name], [Table_Schema] as [Table Schema], [Table_Name] as [Table Name],[Table_Type] as [Table Type] from ' +
QUOTENAME(Name) + '.INFORMATION_SCHEMA.Tables' + ' WHERE [Table_Type] = ' + '''' + 'Base Table' + '''' FROM sys.databases
where Name  = @DatabaseTo
ORDER BY name
 
EXECUTE(@SQL1)

-- Build list of existing synonyms

SELECT @SQL2 = 'INSERT INTO #ExistingSynonyms
Select name from ' + @DatabaseOn + '.dbo.' + 'sysobjects where xtype = ' + '''' + 'sn' + ''''

EXECUTE(@SQL2)

-- Start cursor to run through synonym creation

DECLARE curCreateSynonyms CURSOR FAST_FORWARD FOR

-- Used to build script to create synonyms and then execute it

select 'Use ' + @DatabaseOn + ' create synonym ' + @Prefix + '_'
+ [table name] + ' for [' + @DatabaseTo + '].[' + [schema name] + '].[' + [Table name] + ']' 
    from #AllTables where @Prefix + '_' + [table name] not in (Select [SynonymName] from #ExistingSynonyms)
    
    OPEN curCreateSynonyms
    FETCH NEXT FROM curCreateSynonyms INTO @sql
 
    WHILE @@FETCH_STATUS = 0
        BEGIN
           -- PRINT @sql
            EXEC (@sql)

            FETCH NEXT FROM curCreateSynonyms INTO @sql
        END
 
    CLOSE curCreateSynonyms
    DEALLOCATE curCreateSynonyms
    
Drop Table #AllTables

END


GO
