/******************************  
** File:  spEntradadropStoredProcedure.sql  
** Name:  spEntradadropStoredProcedure  
** Desc:  it is drops the procedure if allready exists 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/ 
CREATE PROCEDURE spEntradadropStoredProcedure 
(
@pSPName varchar(50)
)
 AS  
   EXEC('if exists (select * from sysobjects where id = object_id(N''' + @pSPName + ''') and objectproperty(id, N''IsProcedure'') = 1)  
          drop procedure ' + @pSPName)  