SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/4/2014
-- Description: SP used to get the Editors Pay for use in Admin console
-- =============================================
CREATE PROCEDURE [dbo].[qryGetEditorsPay](
	@EditorId varchar(50)
	)  AS 
BEGIN
	
	SELECT EditorId, 
		   CASE WHEN PayLineRate is null THEN 0.0 ELSE PayLineRate END as 'PayLineRate', 
		   CASE WHEN PayEditorPayRoll is null THEN 'N' ELSE PayEditorPayRoll END as 'PayEditorPayRoll', 
		   CASE WHEN PayType is null THEN '' ELSE PayType END as 'PayType', 
		   CASE WHEN PayrollCode is null THEN '' ELSE PayrollCode END as 'PayrollCode'
	FROM Editors_Pay 
	WHERE EditorID = @EditorID
	
END


GO
