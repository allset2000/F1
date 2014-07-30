SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_INS_CommandCenter_Clients]

	--@uidClientUID varchar(150),
	@intClientID bigint,
	@sClientCode varchar(20),
	@sClientName varchar(300),
	@bitActive bit,
	@dteCreate datetime,
	@dteModified datetime
	
AS

BEGIN

	DECLARE @UID uniqueidentifier

	SET @UID = NEWID()

	INSERT INTO [EntradaInternal].[dbo].[Security_Clients]
			   ([uidClientUID],
			   [intClientID],
			   [sClientCode],
			   [sClientName],
			   [bitActive],
			   [dteCreate],
			   [dteModified])
		 VALUES
			   (@UID, 
			   @intClientID, 
			   @sClientCode, 
			   @sClientName, 
			   @bitActive, 
			   @dteCreate, 
			   @dteModified)
			   
END


GO
