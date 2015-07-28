/******************************          
** File:  spGetJobDocumnet.sql          
** Name:  spGetJobDocumnet          
** Desc:  Get the Job Document details based on job number
** Auth:  Suresh          
** Date:  19/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE spGetJobDocumnet 
(          
 @vvcrJobNumber VARCHAR(20),
 @vintDocumentID INT =-1      
)           
AS          
BEGIN       
	IF(@vintDocumentID = -1) -- if Document ID is -1 then pull the data from Jobs_Documents
		SELECT JobNumber,Doc,XmlData,UserName,DocDate,DocumentId,DocumentTypeID,DocumentStatusId,JobId,Status,StatusDate
		FROM Jobs_Documents
		WHERE JobNumber=@vvcrJobNumber 
	ELSE IF(@vintDocumentID <> -1) --if Document ID is not -1 then pull the data from Jobs_Documents_History
		SELECT JobNumber,doc 
		FROM Jobs_Documents_History 
		WHERE JobNumber=@vvcrJobNumber and DocumentID=@vintDocumentID
	
END   

