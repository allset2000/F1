
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

CREATE PROCEDURE [dbo].[writeContact] (
	@ContactId  [int],
	@ContactType  [char]  (1),
	@FullName  [varchar]  (254),
	@FirstName  [varchar]  (48),
	@MiddleName  [varchar]  (48),
	@LastName  [varchar]  (48),
	@Initials  [varchar]  (12),
	@UserID  [varchar]  (48),
	@UserSettings  [varchar]  (4096),
	@EMail  [varchar]  (48),
	@ContactStatus  [char]  (1)
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Contacts] WHERE ([ContactId] = @ContactId))
   BEGIN
		INSERT INTO [dbo].[Contacts] (
			[ContactId], [ContactType], [FullName], [FirstName], [MiddleName], [LastName], [Initials],
			[UserID], [Password], [ASPMembershipPwd], [UserSettings], [EMail], [ContactStatus] 
		) VALUES (
			@ContactId, @ContactType, @FullName, @FirstName, @MiddleName, @LastName, @Initials,
			@UserID, '', '', @UserSettings, @EMail, @ContactStatus 
		)
   END
ELSE 
   BEGIN
	UPDATE [dbo].[Contacts] 
	 SET
		 [FullName] = @FullName ,
		 [FirstName] = @FirstName ,
		 [MiddleName] = @MiddleName ,
		 [LastName] = @LastName ,
		 [Initials] = @Initials ,
		 [UserID] = @UserID ,
		 [UserSettings] = @UserSettings,
		 [EMail] = @EMail ,
		 [ContactStatus] = @ContactStatus  
	WHERE 
		([ContactId] = @ContactId) 

	END

GO
