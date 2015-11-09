SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
-- =============================================    
-- Author: Santhosh Mukk    
-- Create date: 06/4/2015    
-- Description: SP used to get all Invitations sent or pending - should return all invitations other than deleted ones
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetAllInvitations]  AS     
BEGIN       
	SELECT UserInvitationId,
		   FirstName,
		   MI,
		   LastName,
		   EmailAddress,
		   PhoneNumber,
		   InvitationSent,
		   UI.ClinicId,
		   InvitationMethod,
		   UI.RoleId,
		   SecurityToken,
		   DateTimeRequested AS 'DateTimeInvitationSent',
		   ISNULL(C.Name,'') AS 'ClinicName',
		   UI.InvitationTypeId,
		   UIT.InvitationTypeName
	  FROM [dbo].[UserInvitations] UI
		  LEFT JOIN Clinics C ON C.ClinicID = UI.ClinicId AND C.Deleted = 0
		  INNER JOIN UserInvitationTypes UIT on UIT.InvitationTypeId = UI.InvitationTypeId
	WHERE UI.Deleted = 0
  END

  
GO
