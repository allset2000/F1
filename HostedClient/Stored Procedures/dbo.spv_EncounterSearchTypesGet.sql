
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[spv_EncounterSearchTypesGet]
--X HISTORY:
--x EXEC [spv_EncounterSearchTypesGet]
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY					|	Ticket#			|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04-Apr-2016  | Sharif Shaik		|	#366			| to get all Encounter Search Types

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	SELECT EncounterSearchTypeId, EncounterSearchTypeName
	FROM [dbo].[EncounterSearchType]
	ORDER BY EncounterSearchTypeName
END
GO
