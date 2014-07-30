
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doUpdateUsersData]
AS

BEGIN TRY
BEGIN TRANSACTION

 DECLARE @idValue int 
	
	--/* Set Editors numeric Ids */

--	SELECT @idValue = MAX(EditorIdOk) FROM [dbo].[Editors] 
        
 --   UPDATE [dbo].[Editors]
	--SET 
	--	@idValue = EditorIdOk = @idValue + 1
	--WHERE (EditorIdOk = 0) 
	 
	--/* Set Dictators numeric Ids */
	
	--SELECT @idValue = MAX(DictatorIdOk) FROM [dbo].[Dictators]
 --   IF (@idValue = 0) 
 --   BEGIN
	--   SET @idValue = 5000
 --   END
    
 --   UPDATE [dbo].[Dictators]
	--SET 
	--	@idValue = DictatorIdOk = @idValue + 1
	--WHERE (DictatorIdOk = 0)
    
 --  	/* Update Contacts Table */
   	 
	--INSERT INTO [dbo].[Contacts]
	--([ContactId],[ContactType],[FullName],[FirstName],
	--[MiddleName], [LastName],[Initials], 
	--[UserID],[Password],[ASPMembershipPwd],[UserSettings],[EMail],[ContactStatus])
 --   SELECT EditorIdOk, 'E', ISNULL(FirstName, '') + ' ' + LTRIM(CAST(ISNULL(MI,'') AS varchar)) + ' ' + ISNULL(LastName, ''), ISNULL(FirstName, ''), 
	--LTRIM(CAST(ISNULL(MI, '') AS varchar)), ISNULL(LastName, ''), '' AS Initials, 
	--EditorID, EditorPwd, '' AS ASPMembershipPwd, '' AS UserSettings, EditorEMail AS EMail, 'A'
 --   FROM [dbo].[Editors]
 --   WHERE (dbo.[Editors].EditorIdOK NOT IN (SELECT [dbo].[Contacts].ContactId FROM [dbo].[Contacts]))
    
 --   INSERT INTO [dbo].[ContactRoles]
 --      ([ContactRoleId],[ContactId],[RoleId],[ClinicId],
 --       [ClinicsFilter],[DictatorsFilter], [JobsFilter],[RoleStatus])
 --   SELECT 0, EditorIdOk, CASE [TYPE] WHEN 10 THEN 10 WHEN 20 THEN 20 ELSE 10 END, ISNULL(ClinicID, -1),
 --   CASE WHEN ClinicID IS NULL THEN '' ELSE 'ClinicID = ' + CAST(ClinicID AS varchar) END, '' AS DictatorsFilter, '' AS JobsFilter, 'A'    
 --   FROM [dbo].[Editors]
 --   WHERE (dbo.[Editors].EditorIdOk NOT IN (SELECT [dbo].[ContactRoles].ContactId FROM [dbo].[ContactRoles] WHERE RoleId IN (10,20)))

	--INSERT INTO [dbo].[Contacts]
	--([ContactId],[ContactType],[FullName],[FirstName],
	--[MiddleName], [LastName],[Initials], 
	--[UserID],[Password],[ASPMembershipPwd],[UserSettings],[EMail],[ContactStatus])
 --   SELECT DictatorIdOk, 'D', ISNULL(FirstName, '') + ' ' + LTRIM(CAST(ISNULL(MI,'') AS varchar)) + ' ' + ISNULL(LastName, ''), ISNULL(FirstName, ''), 
	--LTRIM(CAST(ISNULL(MI, '') AS varchar)), ISNULL(LastName, ''), ISNULL(Initials, '') AS Initials, 
	--DictatorID, '' AS Password, '' AS ASPMembershipPwd, '' AS [UserSettings], '' AS EMail, 'A'
 --   FROM [dbo].[Dictators]
 --   WHERE (dbo.[Dictators].DictatorIdOk NOT IN (SELECT [dbo].[Contacts].ContactId FROM [dbo].[Contacts]))

    --INSERT INTO [dbo].[ContactRoles]
    --   ([ContactRoleId],[ContactId],[RoleId],[ClinicId],
    --    [ClinicsFilter],[DictatorsFilter],[JobsFilter],[RoleStatus])
    --SELECT 0, DictatorIdOk, 11, ISNULL(ClinicID, -1),
    --'' AS ClinicsFilter, '' AS DictatorsFilter, '' AS JobsFilter, 'A'    
    --FROM [dbo].[Dictators]
    --WHERE (dbo.[Dictators].DictatorIdOk NOT IN (SELECT [dbo].[ContactRoles].ContactId FROM [dbo].[ContactRoles] WHERE RoleId = 11))
        
	----INSERT INTO EntradaPortalUsers.dbo.UserIDMapping
	----([UserId],[UserIdOk])
	----SELECT UserId, 0 
	----FROM EntradaPortalUsers.dbo.aspnet_Users WHERE (UserId NOT IN (SELECT UserId FROM EntradaPortalUsers.dbo.UserIDMapping))
	
	----SELECT @idValue = MAX(UserIdOk) FROM EntradaPortalUsers.dbo.UserIDMapping
 ----   IF (@idValue = 0) 
 ----   BEGIN
	----   SET @idValue = 10000
 ----   END 
    		
	----UPDATE EntradaPortalUsers.dbo.UserIDMapping
	----SET 
	----	@idValue = UserIdOk = @idValue + 1
	----WHERE (UserIdOk = 0)
	
	----INSERT INTO [dbo].[Contacts]
	----([ContactId],[ContactType],[FullName],[FirstName],
	----[MiddleName], [LastName],[Initials], 
	----[UserID],[Password],[ASPMembershipPwd],[UserSettings], [EMail],[ContactStatus])
	----SELECT DISTINCT UserIdOk, 'P', UserName, UserName, 
	----'' AS MiddleName, '' AS LastName, '' AS Initials, 
	----UserName AS [UserID], '' AS [Password], 'Unknown', '' AS UserSettings, Email, 'A' 
	----FROM EntradaPortalUsers.dbo.vwASPMembershipUsers
	----WHERE (UserName NOT IN (SELECT [dbo].[Contacts].UserID FROM [dbo].[Contacts] WHERE (ContactType = 'P')))

	--UPDATE  [dbo].[Contacts]
	--SET	 UserID = dbo.Editors.EditorID,
	--	 [Password] = dbo.Editors.EditorPwd
	--FROM dbo.Contacts INNER JOIN dbo.Editors
 --   ON dbo.Contacts.ContactId = dbo.Editors.EditorIdOk

 --   UPDATE [dbo].[Contacts]
 --   SET [FullName] = REPLACE([FullName], '  ', ' ')
    
 ----   INSERT INTO [dbo].[ContactRoles]
 ----      ([ContactRoleId],[ContactId],[RoleId],[ClinicId],
 ----       [ClinicsFilter],[DictatorsFilter],[JobsFilter],[RoleStatus])
 ----   SELECT 0, ContactId, [dbo].ftGetGeneralObjectId('RoleType', RoleName), 
	----	[dbo].ftGetClinicId(ClinicName), '' AS ClinicsFilter, '' AS DictatorsFilter, '' AS JobsFilter, 'A'    
 ----   FROM EntradaPortalUsers.dbo.vwASPMembershipUsersRoles INNER JOIN [dbo].[Contacts]
	----ON EntradaPortalUsers.dbo.vwASPMembershipUsersRoles.UserIdOk = [dbo].[Contacts].ContactId
 ----   WHERE (dbo.[Contacts].ContactId NOT IN (SELECT [dbo].[ContactRoles].ContactId FROM [dbo].[ContactRoles] WHERE RoleId = [dbo].ftGetGeneralObjectId('RoleType', EntradaPortalUsers.dbo.vwASPMembershipUsersRoles.RoleName)))

	--SELECT @idValue = MAX(ContactRoleId) FROM [dbo].[ContactRoles]
    
 --   UPDATE [dbo].[ContactRoles]
	--SET 
	--	@idValue = ContactRoleId = @idValue + 1
	--WHERE (ContactRoleId = 0)

	--INSERT INTO [dbo].[DocumentSignatureRules]
	--		   ([DocSignatureRuleId] ,[DocSignatureRuleType] ,[ClinicRuleID],[LocationRuleID],
	--		    [JobTypeRule],[ReviewerDictatorID],[SignerDictatorID],[ReviewerStampLocation],
	--		    [SignerStampLocation],[ReviewerStamp],[SignerStamp],[SignerUnsignStamp],[DocSignatureRuleStatus])
	--SELECT DictatorIdOk, 'S', ClinicID, 0, 
	--	   '', '', DictatorID, 'N', 
	--	   CASE ESignatureLocation WHEN 'Top' THEN 'T' ELSE 'B' END, '' AS [ReviewerStamp], ISNULL(ESignatureStamp,'') AS SignerStamp, '', 'A'  
	--FROM  [dbo].Dictators
	--WHERE (ESignatureEnabled = 1) AND (DictatorID NOT IN (SELECT  [SignerDictatorID] FROM [DocumentSignatureRules] WHERE [DocSignatureRuleType] = 'S'))
	      
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
		ROLLBACK TRANSACTION
						DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
						SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	   END
END CATCH

RETURN
GO
