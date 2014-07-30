SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CommandCenter_Nodes]

	@UserUID varchar(50),
	@ClientID varchar(50),
	@NodeID bigint
	
AS

BEGIN

	DECLARE @SecLvl int
	
	SELECT @SecLvl = intDefaultSecLevel
	FROM Security_Users SU WITH(NOLOCK) 
	WHERE uidUserUID = @UserUID
	
	IF @SecLvl > 4
		BEGIN
			SELECT N.bintNodeID, 
				N.sNodeName, 
				N.sNodeToolTip, 
				N.sNodeDesc, 
				N.bintParentNode, 
				N.sImageName, 
				N.bitIsContainer,
				N.bitActive, 
				N.dteCreated, 
				N.dteModified
			FROM CommandCenter_Nodes N WITH(NOLOCK)
			WHERE bitActive = 1
			ORDER BY bitIsContainer DESC,
				sNodeName
		
		END
	ELSE
		BEGIN
			SELECT N.bintNodeID, 
				N.sNodeName, 
				N.sNodeToolTip, 
				N.sNodeDesc, 
				N.bintParentNode, 
				N.sImageName, 
				N.bitIsContainer,
				N.bitActive, 
				N.dteCreated, 
				N.dteModified
			FROM CommandCenter_Nodes N WITH(NOLOCK)
			INNER JOIN Security_XREF_TasksUsers XTU WITH(NOLOCK) ON
				N.bintNodeID = XTU.bintTaskID
			WHERE XTU.uidUserUID = @UserUID
				AND N.bitActive = 1
				AND XTU.bitActive = 1
			ORDER BY bitIsContainer DESC,
				sNodeName		
		END
END


GO
