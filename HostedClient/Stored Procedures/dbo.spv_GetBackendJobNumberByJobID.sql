
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Raghu A>
-- Create date: <05/28/2016>
-- Description:	<return job details and backend jobnumber by jobid>
-- =============================================
CREATE PROCEDURE [dbo].[spv_GetBackendJobNumberByJobID]	
	@JobID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	  SELECT j.JobID, j.JobNumber, j.ClinicID, j.EncounterID, j.JobTypeID, j.OwnerDictatorID, j.[Status], j.Stat, 
			 j.[Priority], j.RuleID, j.AdditionalData, j.ProcessFailureCount, j.UpdatedDateInUTC, j.HasDictation, 
			 j.HasImages, j.HasTagMetaData, j.HasChatHistory, j.OwnerUserID, j.TagMetaData, j.ChatHistory_ThreadID, 
			 j.RhythmWorkFlowID, j.BackendStatus, jc.Jobnumber As BackendJobnumber,C.ClinicCode+d.DictatorName As DictatorCode
	 FROM Jobs j WITH(NOLOCK)
	 INNER JOIN Clinics c WITH(NOLOCK) on j.ClinicID=c.ClinicID
	 INNER JOIN Dictators d WITH(NOLOCK) on d.DictatorID=j.OwnerDictatorID
	 lEFT JOIN [Entrada].dbo.Jobs_Client jc WITH(NOLOCK) ON jc.FileName=j.JobNumber
	 WHERE j.JobID=@JobID


END


GO
