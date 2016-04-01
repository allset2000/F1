SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[spv_TaskTypesGet]
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY					|	Ticket#			|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04-Apr-2016  | Sharif Shaik		|	#366			| to get all Task Types

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	SELECT TaskTypeID, TaskTypeName
	FROM [dbo].[TaskType]
END
GO
