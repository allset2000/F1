SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeJobEditingTaskData] (
	@JobEditingTaskId  [int],
	@NumPages  [int],
	@NumLines  [int],
	@NumChars  [int],
	@NumVBC  [int],
	@NumCharsPC  [int],
	@BodyWSpaces  [int],
	@HeaderFirstWSpaces  [int],
	@HeaderPrimaryWSpaces  [int],
	@HeaderEvenWSpaces  [int],
	@FooterFirstWSpaces  [int],
	@FooterPrimaryWSpaces  [int],
	@FooterEvenWSpaces  [int],
	@HeaderTotalWSpaces  [int],
	@FooterTotalWSpaces  [int],
	@HeaderFooterTotalWSpaces  [int],
	@DocumentWSpaces  [int]
) AS 
 
	 DECLARE @NumTotalMacros [int]
	 DECLARE @NumMacrosUnEdited [int]
	 DECLARE @NumMacrosEdited [int]
	 DECLARE @NumCharsUnEditedMacros [int]
	 DECLARE @NumCharsEditedMacros [int]
	 DECLARE @NumCharsChangedMacros [int]
 
	 SELECT @NumTotalMacros = NumTotalMacros,
			@NumMacrosUnEdited = NumMacrosUnEdited,
			@NumMacrosEdited = NumMacrosEdited,
			@NumCharsUnEditedMacros = NumCharsUnEditedMacros,
			@NumCharsEditedMacros = NumCharsEditedMacros,
			@NumCharsChangedMacros = NumCharsChangedMacros
     FROM ftMacroBillingTotals(@JobEditingTaskId)
     
	 DELETE FROM [dbo].[JobEditingTasksData]
	 WHERE [JobEditingTaskId] = @JobEditingTaskId;   
	 
	 INSERT INTO [dbo].[JobEditingTasksData] (
		[JobEditingTaskId],
		[NumPages],
		[NumLines],
		[NumChars],
		[NumVBC],
		[NumCharsPC],
		[BodyWSpaces],
		[HeaderFirstWSpaces],
		[HeaderPrimaryWSpaces],
		[HeaderEvenWSpaces],
		[FooterFirstWSpaces],
		[FooterPrimaryWSpaces],
		[FooterEvenWSpaces],
		[HeaderTotalWSpaces],
		[FooterTotalWSpaces],
		[HeaderFooterTotalWSpaces],
		[DocumentWSpaces],
		[NumTotalMacros],
		[NumMacrosUnEdited],
		[NumMacrosEdited],
		[NumCharsUnEditedMacros],
		[NumCharsEditedMacros],
		[NumCharsChangedMacros]
	) VALUES (
		@JobEditingTaskId,
		@NumPages,
		@NumLines,
		@NumChars,
		@NumVBC,
		@NumCharsPC,
		@BodyWSpaces,
		@HeaderFirstWSpaces,
		@HeaderPrimaryWSpaces,
		@HeaderEvenWSpaces,
		@FooterFirstWSpaces,
		@FooterPrimaryWSpaces,
		@FooterEvenWSpaces,
		@HeaderTotalWSpaces,
		@FooterTotalWSpaces,
		@HeaderFooterTotalWSpaces,
		@DocumentWSpaces,
		@NumTotalMacros,
		@NumMacrosUnEdited,
		@NumMacrosEdited,
		@NumCharsUnEditedMacros,
		@NumCharsEditedMacros,
		@NumCharsChangedMacros
	)
GO
