/****** Object:  StoredProcedure [dbo].[sp_GetMessageThreadByID]    Script Date: 10/16/2015 20:58:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Samuel Shoultz
-- Create date: 3/23/2015
-- Description: SP used to pull the MessageThread by threadid
--Modified By :Raghu, A Raghu
--Modified Date : 07/28/2015,10/16/2016
--Decription: ThreadAdminUserID added
---Added patient Name 
-- =============================================
--exec sp_GetMessageThreadByID '56250cbd31c5595a82000b9a'
ALTER PROCEDURE [dbo].[sp_GetMessageThreadByID]
	@ThreadId AS VARCHAR(100)
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
		   P.FirstName +' '+P.MI+' '+P.LastName AS PatientName
	   FROM MessageThreads MH WITH(NOLOCK)	
	   LEFT JOIN Patients p WITH(NOLOCK) ON P.PatientID=MH.PatientID
	   WHERE MH.ThreadID = @ThreadId
END


