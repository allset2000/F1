
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
-- =============================================    
-- Author: Santhosh Mukk    
-- Create date: 01/22/2015    
-- Description: SP used to get all Invitation details based on invitationid
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetInvitationDetailsById]  
(
	@UserInvitationId INT = -1
)
AS     
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
		  ,R.RoleName
		  ,ISNULL(C.Name,'') AS 'ClinicName'
		  ,InvitationMessage,
		  InvitationTypeId,
		  UI.Deleted
	  FROM [dbo].[UserInvitations] UI 
		LEFT JOIN Clinics C ON C.ClinicID = UI.ClinicId AND C.Deleted = 0
		LEFT JOIN Roles R ON R.RoleID = UI.RoleId AND R.ClinicID = 0
	WHERE [UserInvitationId] = @UserInvitationId
  END

  
GO
