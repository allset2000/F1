SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "RadSource Job Counts - Per Editing Group.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	code was internal to report.  created proc
							to replace code, then archived proc to 
							replace with proc that uses new QA workflow tables.
======================================================= */
CREATE PROCEDURE [dbo].[archive_sp_Reporting_RadSourceJobCounts_PerEditingGroup]
	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(15)
	
AS
BEGIN


	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedOn, 
			Jobs_EditingData.NumVBC_Editor, 
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Jobs_EditingData.NumChars_Editor, 
			Editors.LastName, 
			Editors.FirstName,
			(Jobs_EditingData.NumVBC_Editor / 65) as EntradaLines,
			(Jobs_EditingData.NumChars_Editor / 65) as VBCLines
	FROM Entrada.dbo.Jobs_EditingData WITH (NOLOCK)
	JOIN Entrada.dbo.Jobs WITH (NOLOCK) ON Jobs.JobNumber = Jobs_EditingData.JobNumber
	JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
	JOIN Entrada.dbo.Editors WITH (NOLOCK) ON Jobs.EditorID = Editors.EditorID
	WHERE Jobs.ReturnedOn BETWEEN @ReceivedOn AND @ReceivedOn2 
	  AND (Editors_Pay.PayType = @PayTypeVar) 
	  AND Jobs.ClinicID = 40			 

END
GO
