
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/1/2014
-- Description: SP used to Create/Update Contact records by the AC (Editor, or Dictator)
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateContact](
	@ID int,
	@ContactType varchar(1),
	@FullName varchar(254),
	@FirstName varchar(48),
	@MiddleName varchar(48),
	@LastName varchar(48),
	@Initials varchar(12),
	@UserID varchar(48),
	@Password varchar(48),
	@ASPMembershipPwd varchar(48),
	@UserSettings varchar(4096),
	@EMail varchar(48),
	@ContactStatus varchar(1),
	@SecurityToken varchar(255)
)  AS 
BEGIN

	IF NOT EXISTS (SELECT * FROM Contacts where ContactId = @ID)
	BEGIN

		DECLARE @NewContactId int
		-- Get new ContactId and update DBRules table with new id
		UPDATE DbRules
		SET @NewContactId = CurrentIdValue = CurrentIdValue + 1
		WHERE (SourceName = 'Contacts') AND (DbRuleType = 'I')

		-- Insert new record
		INSERT INTO Contacts(ContactId,ContactType,FullName,FirstName,MiddleName,LastName,Initials,UserID,Password,ASPMembershipPwd,UserSettings,EMail,ContactStatus,SecurityToken)
		VALUES(@NewContactId, @ContactType, @FullName, @FirstName, @MiddleName, @LastName, @Initials, @UserID, @Password, @ASPMembershipPwd, @UserSettings, @EMail, @ContactStatus, @SecurityToken)
	END
	ELSE
	BEGIN
		-- Record already exists, update values
		UPDATE Contacts SET ContactType = @ContactType,
							FullName = @FullName,
							FirstName = @FirstName,
							MiddleName = @MiddleName,
							LastName = @LastName,
							Initials = @Initials, 
							UserID = @UserID,
							Password = @Password,
							ASPMembershipPwd = @ASPMembershipPwd,
							UserSettings = @UserSettings,
							EMail = @EMail,
							ContactStatus = @ContactStatus,
							SecurityToken = @SecurityToken
		WHERE ContactId = @ID
	END	

END


GO
