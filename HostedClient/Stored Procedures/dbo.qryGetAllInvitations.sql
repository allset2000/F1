SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
-- =============================================    
-- Author: Santhosh Mukk    
-- Create date: 01/14/2015    
-- Description: SP used to get all Invitations to display on the Admin Console    
-- =============================================    
CREATE PROCEDURE [dbo].[qryGetAllInvitations]  AS     
BEGIN       
	SELECT [UserInvitationId]
		  ,[FirstName]
		  ,[MI]
		  ,[LastName]
		  ,[EmailAddress]
		  ,[PhoneNumber]
		  ,[InvitationSent]		  
		  ,UI.[ClinicId]
		  ,[InvitationMethod]
		  ,UI.[RoleId]
		  ,[SecurityToken]		  
		  ,[DateTimeRequested] AS [DateTimeInvitationSent]
		  ,[IsDemoUser]
		  ,R.RoleName
		  ,ISNULL(C.Name,'') AS 'ClinicName'
	  FROM [dbo].[UserInvitations] UI
	  LEFT JOIN Clinics C
	  ON C.ClinicID = UI.ClinicId
	  AND Deleted = 0
	  LEFT JOIN Roles R
	  ON R.RoleID = UI.RoleId
	  AND R.ClinicID = 0
	WHERE ISNULL(UI.RegisteredUserId,'0') = 0
  END

  
GO
