SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_EditorBilling] 
	-- Add the parameters for the stored procedure here
	@startDate datetime, 
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT     Jobs.EditorID, Jobs.DictatorID, SUM(Jobs_EditingData.NumPages_Editor) as RawPages, SUM(Jobs_EditingData.NumChars_Editor) as NumVBC, 
						  SUM(Jobs_EditingData.NumVBC_Editor) as NumChars, SUM(Jobs_EditingData.NumVBC_Editor/65.0) as EntradaLines
	FROM         Jobs_EditingData INNER JOIN
						  JobStatusB ON Jobs_EditingData.JobNumber = JobStatusB.JobNumber INNER JOIN
						  Jobs ON Jobs_EditingData.JobNumber = Jobs.JobNumber
	WHERE JobStatusB.StatusDate>=@startDate and JobStatusB.StatusDate<@endDate
	GROUP BY EditorID,DictatorID
	ORDER BY EditorID
END
GO
