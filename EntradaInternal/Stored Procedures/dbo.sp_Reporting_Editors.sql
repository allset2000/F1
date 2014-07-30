SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*  =======================================================
Author:			Jen Blumenthal 
Create date:	3/27/2013
Description:	Retrieves list of Editors used in reporting.  
				Populates the EditorID (or @EditorID) 
				parameter list in reports.  

change log:

date	user			description
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Editors]

AS
BEGIN

SET NOCOUNT ON

	SELECT  EditorID,
			CASE
				WHEN ISNULL(LastName, '') = '' AND ISNULL(FirstName, '') = '' THEN 'UNKNOWN'
				WHEN ISNULL(LastName, '') = '' THEN ltrim(FirstName)
				WHEN ISNULL(FirstName, '') = '' THEN ltrim(LastName)
				ELSE ltrim(LastName) + ', ' + ltrim(FirstName)
			END as EditorName
	FROM Entrada.dbo.Editors
	WHERE ISNULL(EditorID, '') <> ''
	ORDER BY CASE
				WHEN ISNULL(LastName, '') = '' AND ISNULL(FirstName, '') = '' THEN 'UNKNOWN'
				WHEN ISNULL(LastName, '') = '' THEN ltrim(FirstName)
				WHEN ISNULL(FirstName, '') = '' THEN ltrim(LastName)
				ELSE ltrim(LastName) + ', ' + ltrim(FirstName)
			 END 


END
GO
