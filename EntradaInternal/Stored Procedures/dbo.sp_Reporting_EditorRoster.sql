SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves all editors
--		for report "Editor Roster.rdl"
-- =============================================
create PROCEDURE [dbo].[sp_Reporting_EditorRoster] 

AS
BEGIN

	SELECT E.EditorID, 
		E.JobCount, 
		E.JobMax, 
		E.FirstName, 
		E.LastName, 
		E.MI, 
		EP.PayType, 
		E.JobStat, 
		EP.PayLineRate, 
		EP.PayEditorPayRoll, 
		EP.PayrollCode, 
		E.[Type]
	FROM [Entrada].[dbo].[Editors_Pay] EP WITH(NOLOCK)
	RIGHT OUTER JOIN [Entrada].[dbo].[Editors] E WITH(NOLOCK) ON 
		E.EditorID = EP.EditorID
	WHERE E.[Type] <> 0
	ORDER BY EP.PayEditorPayRoll DESC, 
			E.LastName, 
			E.FirstName
	
END

GO
