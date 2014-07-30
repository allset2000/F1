SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_INS_CommandCenter_User]

	@sLastName varchar(150),
	@sFirstName varchar(150),
	@bitActive bit,
	@sUserName varchar(50),
	@sPwd varchar(50),
	@uidCompanyUID varchar(50),
	@intDefaultSecLevel int	
	
AS

BEGIN

	DECLARE @UID uniqueidentifier

	SET @UID = NEWID()

	INSERT INTO [EntradaInternal].[dbo].[Security_Users]
			   ([uidUserUID],
			   [sLastName],
			   [sFirstName],
			   [bitActive],
			   [sUserName],
			   [sPwd],
			   [intDefaultSecLevel])
		 VALUES
			   (@UID,
			   @sLastName,
			   @sFirstName,
			   @bitActive,
			   @sUserName,
			   @sPwd,
			   @intDefaultSecLevel)


	INSERT INTO [EntradaInternal].[dbo].[Security_XREF_ClientsUsers]
				(uidClientUID,
				uidUserUID,
				bitActive)
		 VALUES	
				(CAST(@uidCompanyUID AS uniqueidentifier),
				@UID,
				@bitActive)
END


GO
