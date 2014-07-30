SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Isaac Swindle
Create date:	6/27/2014
Description:	returns data for "Editor Production By Date And Group_SCR.rdl"
				Specific request by Dr. Srinivas Vuthoori for daily tracking 

======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_ByDateAndGroup_SCR_NON_VR_TAT]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime
	
AS
BEGIN

DECLARE @PayTypeVar varchar(15) = 'SCR'

	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedOn, 
			EJ.NumVBC as NumVBC_Editor,
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Editors.LastName, 
			Editors.FirstName,
			CAST(Jobs.Stat AS int),
			(EJ.NumVBC / 65.0) as Lines
	FROM [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK)
	JOIN Entrada.dbo.Jobs WITH (NOLOCK) ON Jobs.JobNumber = EJ.JobNumber
	JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
	JOIN Entrada.dbo.Editors WITH (NOLOCK) ON Jobs.EditorID = Editors.EditorID
	WHERE Jobs.JobNumber IN (
				SELECT DISTINCT JT.JobNumber
				FROM Entrada.dbo.JobTracking JT
				WHERE JT.JobNumber IN (
						SELECT	Jobs.JobNumber
						FROM Entrada.dbo.Jobs WITH (NOLOCK) 
						JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
						WHERE (CONVERT(DATE, Jobs.ReturnedOn, 101) >= @ReceivedOn) 
							AND (CONVERT(DATE, Jobs.ReturnedOn, 101) < @ReceivedOn2) 
							AND (Editors_Pay.PayType = @PayTypeVar))
				EXCEPT
				SELECT DISTINCT JT.JobNumber
				FROM Entrada.dbo.JobTracking JT
				WHERE JT.JobNumber IN (
						SELECT	Jobs.JobNumber
						FROM Entrada.dbo.Jobs WITH (NOLOCK) 
						JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON Jobs.EditorID = Editors_Pay.EditorID 
						WHERE (CONVERT(DATE, Jobs.ReturnedOn, 101) >= @ReceivedOn) 
							AND (CONVERT(DATE, Jobs.ReturnedOn, 101) < @ReceivedOn2) 
							AND (Editors_Pay.PayType = @PayTypeVar))
				AND JT.[Status] = '130')
	AND Jobs.Stat = '0'

END
GO
