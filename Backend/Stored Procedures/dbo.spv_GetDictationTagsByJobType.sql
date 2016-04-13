SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_GetDictationTagsByJobType]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Get the list of available job tags based on clinic and/or dictator
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: @JobType, @ClinicID
--X
--X RETURNS: Tag list
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04-11-2016   | Naga		  			| Initial design
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CREATE PROCEDURE [dbo].[spv_GetDictationTagsByJobType]
					@JobType	VARCHAR(200),
					@ClinicID	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT t.* FROM dbo.JobsTddSplitRules r
	INNER JOIN dbo.JobsTddAllowedTags t
	ON r.ID = t.SplitRuleID
	AND r.JobType = @JobType
	AND r.ClinicID = @ClinicID
	
END
GO
