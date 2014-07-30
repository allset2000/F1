SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	returns data for "Editor Production By Date And Group.rdl"

change log:

date		username		description
4/11/13		jablumenthal	code was internal to report.  created
							procedure to replace internal code 
							then archived procedure to replace it with
							a new one that uses the new QA workflow tables.
======================================================= */
CREATE PROCEDURE [dbo].[archive_sp_Reporting_EditorProduction_ByDateAndGroup]

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
			Editors.LastName, 
			Editors.FirstName,
			Jobs_EditingData.NumVBC_Editor / 65 as Lines
	FROM Entrada.dbo.Jobs_EditingData WITH (NOLOCK)
	JOIN Entrada.dbo.Jobs WITH (NOLOCK) ON Jobs.JobNumber = Jobs_EditingData.JobNumber 
	JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
	JOIN Entrada.dbo.Editors WITH (NOLOCK) ON Jobs.EditorID = Editors.EditorID
	WHERE (CONVERT(DATE, Jobs.ReturnedOn, 101) >= @ReceivedOn) 
	  AND (CONVERT(DATE, Jobs.ReturnedOn, 101) < @ReceivedOn2) 
	  AND (Editors_Pay.PayType = @PayTypeVar)
                  
END
                         
GO
