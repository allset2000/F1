
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
-- =============================================    
-- Author: Santhosh Mukk    
-- Create date: 01/14/2015    
-- Description: SP used to get all Invitations to display on the Admin Console    

-- Updated 6/1/2015
-- Changes: Added Invitation Type column and removed the IsDemoUser column

-- Updated 6/4/2015
-- Changes: Added support for multiple RoleId's
-- =============================================    
CREATE PROCEDURE [dbo].[qryGetAllInvitations]  AS     
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
	WHERE  (ISNULL(UI.RegisteredUserId,'0') = 0 or PendingRegStatus=1) and UI.Deleted = 0
  END

  
GO
