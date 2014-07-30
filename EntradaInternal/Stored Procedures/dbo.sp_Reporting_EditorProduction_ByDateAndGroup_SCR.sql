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
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_ByDateAndGroup_SCR]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime
	
AS
BEGIN

DECLARE @PayTypeVar varchar(15) = 'SCR'

CREATE TABLE #TempSCR
	(

	EditorID [varchar](50) NOT NULL, 
	NTReturnedOn [datetime] NULL, 
	NTNumVBC_Editor [decimal] NULL,
	NTJobNumber [varchar](max) NULL, 
	NTPayType [varchar](100) NULL, 
	NTLastName [varchar](50) NULL, 
	NTFirstName [varchar](50) NULL,
	NTStat [int] NULL,
	NTLines [decimal] NULL,
	NSReturnedOn [datetime] NULL, 
	NSNumVBC_Editor [decimal] NULL,
	NSJobNumber [varchar](max) NULL, 
	NSPayType [varchar](100) NULL, 
	NSLastName [varchar](50) NULL, 
	NSFirstName [varchar](50) NULL,
	NSStat [int] NULL,
	NSLines [decimal] NULL,
	VTReturnedOn [datetime] NULL, 
	VTNumVBC_Editor [decimal] NULL,
	VTJobNumber [varchar](max) NULL, 
	VTPayType [varchar](100) NULL, 
	VTLastName [varchar](50) NULL, 
	VTFirstName [varchar](50) NULL,
	VTStat [int] NULL,
	VTLines [decimal] NULL,
	VSReturnedOn [datetime] NULL, 
	VSNumVBC_Editor [decimal] NULL,
	VSJobNumber [varchar](max) NULL, 
	VSPayType [varchar](100) NULL, 
	VSLastName [varchar](50) NULL, 
	VSFirstName [varchar](50) NULL,
	VSStat [int] NULL,
	VSLines [decimal] NULL,
	
	)
	INSERT INTO #TempSCR
	(
	EditorID, 
	NTReturnedOn, 
	NTNumVBC_Editor, 
	NTJobNumber, 
	NTPayType, 
	NTLastName, 
	NTFirstName, 
	NTStat, 
	NTLines 
	)
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

	INSERT INTO #TempSCR
	(
	EditorID, 
	NSReturnedOn, 
	NSNumVBC_Editor, 
	NSJobNumber, 
	NSPayType, 
	NSLastName, 
	NSFirstName, 
	NSStat, 
	NSLines 
	)
	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedOn, 
			EJ.NumVBC as NumVBC_Editor,
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Editors.LastName, 
			Editors.FirstName,
			CAST(Jobs.Stat AS int) AS Stat,
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
	AND Jobs.Stat = '1'
           
	INSERT INTO #TempSCR
	(
	EditorID, 
	VTReturnedOn, 
	VTNumVBC_Editor, 
	VTJobNumber, 
	VTPayType, 
	VTLastName, 
	VTFirstName, 
	VTStat, 
	VTLines 
	)  
	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedOn, 
			EJ.NumVBC as NumVBC_Editor,
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Editors.LastName, 
			Editors.FirstName,
			CAST(Jobs.Stat AS int) AS Stat,
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
				AND JT.[Status] = '130')
	AND Jobs.Stat = '0'

	INSERT INTO #TempSCR
	(
	EditorID, 
	VSReturnedOn, 
	VSNumVBC_Editor, 
	VSJobNumber, 
	VSPayType, 
	VSLastName, 
	VSFirstName, 
	VSStat, 
	VSLines 
	) 
	SELECT  Jobs.EditorID, 
			CONVERT(DATE, Jobs.ReturnedOn, 101) AS ReturnedOn, 
			EJ.NumVBC as NumVBC_Editor,
			Jobs.JobNumber, 
			Editors_Pay.PayType, 
			Editors.LastName, 
			Editors.FirstName,
			CAST(Jobs.Stat AS int) AS Stat,
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
				AND JT.[Status] = '130')
	AND Jobs.Stat = '1'

	Select * 
	FROM #TempSCR
END
GO
