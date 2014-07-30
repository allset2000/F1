SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Single Editor Production Reporting System.rdl"
				
change log

date		username		description
4/12/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[archive_sp_Reporting_SingleEditorProduction]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@EditorID varchar(50)
	
AS
BEGIN

	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedDate, 
			Jobs_EditingData.NumVBC_Editor, 
			Jobs_EditingData.NumChars_Editor, 
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Editors.LastName, 
			Editors.FirstName, 
			Jobs.ClinicID, 
			CASE WHEN Jobs.ClinicID = 40 THEN 1 ELSE 0 END AS RadSourceJob, 
			CASE WHEN Jobs.ClinicID <> 40 THEN 1 ELSE 0 END AS NonRadSourceJob
	FROM Entrada.dbo.Jobs_EditingData WITH (NOLOCK)
	JOIN Entrada.dbo.Jobs WITH (NOLOCK) ON Jobs.JobNumber = Jobs_EditingData.JobNumber 
	JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
	JOIN Entrada.dbo.Editors WITH (NOLOCK) ON Jobs.EditorID = Editors.EditorID
	WHERE (CONVERT(DATE, Jobs.ReturnedOn, 101) >= @ReceivedOn) 
	  AND (CONVERT(DATE, Jobs.ReturnedOn, 101) < @ReceivedOn2) 
	  AND (Jobs.EditorID = @EditorID)
		
END
GO
