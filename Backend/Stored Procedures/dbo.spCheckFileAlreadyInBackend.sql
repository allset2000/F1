/******************************  
** File:  spCheckFileAlreadyInBackend.sql  
** Name:  spCheckFileAlreadyInBackend  
** Desc:  check for the record present in Jobs_client table 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spCheckFileAlreadyInBackend] 
(  
 @vvcrDictatorID VARCHAR(50),
 @vvcrFileName  VARCHAR(100),
 @vvcrMD5   VARCHAR(100)
)  
AS 
BEGIN
	SELECT COUNT(*) 
	FROM Jobs_Client
	WHERE DictatorID = @vvcrDictatorID AND FileName = @vvcrFileName AND MD5 = @vvcrMD5
END  
