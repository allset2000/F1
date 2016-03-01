
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		A. Raghu
-- Create date: 02/22/2016
-- Description:	get conversation details by job ID
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetConversationDetailsByJobID]
	@jobID INT	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
  
    SELECT 
		   MH.MessageThreadId, 
		   MH.ThreadID, 
		   MH.ThreadOwnerID,
		   MH.PatientID,
		   MH.IsActive,
		   MH.PassPhrase,
		   MH.ThreadAdminUserID,		  
		   MH.CreatedDate,
		   P.FirstName +' '+P.LastName AS PatientName,
		   MH.ThreadDictatorID,
		   QB.QuickBloxUserID,
		   QB.[Login] AS QBLogin ,
		   QB.[Password] AS QBPassword,
		   P.DOB,
		   p.MRN
	   FROM MessageThreads MH WITH(NOLOCK)	
	   INNER JOIN dbo.Jobs J ON J.ChatHistory_ThreadID=MH.MessageThreadID
	   INNER JOIN [dbo].[QuickBloxUsers] QB on QB.UserID= MH.ThreadOwnerID  
	   INNER JOIN Patients p WITH(NOLOCK) ON P.PatientID=MH.PatientID       
   WHERE J.JobID=@jobID


END
GO
