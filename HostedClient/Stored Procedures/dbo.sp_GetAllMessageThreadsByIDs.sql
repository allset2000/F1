SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_GetAllMessageThreadsByIDs]  
 @ThreadIds AS NVARCHAR(MAX)
AS   
BEGIN  
    SELECT   
     MH.MessageThreadId,   
     MH.ThreadID,   
     MH.ThreadOwnerID,  
     MH.PatientID,  
     MH.IsActive,  
     MH.PassPhrase,  
     MH.ThreadAdminUserID,      
     MH.CreatedDate,  
     P.FirstName +' '+P.MI+' '+P.LastName AS PatientName,  
     MH.ThreadDictatorID  
    FROM MessageThreads MH WITH(NOLOCK)   
    LEFT JOIN Patients p WITH(NOLOCK) ON P.PatientID=MH.PatientID  
    WHERE MH.ThreadID IN (SELECT splitdata FROM fnSplitString(@ThreadIds,','))  
END  
GO
