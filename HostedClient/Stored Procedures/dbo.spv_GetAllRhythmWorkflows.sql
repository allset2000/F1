SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
** File:  spv_GetAllRhythmWorkflows.sql  
** Name:  spv_GetAllRhythmWorkflows  
** Desc:  Get All Rhythm Workflows
** Auth:  Santhosh  
** Date:  05/April/2015 
**************************/
CREATE PROCEDURE [dbo].[spv_GetAllRhythmWorkflows]
AS
BEGIN
	SELECT RhythmWorkFlowID, RhythmWorkFlowName FROM RhythmWorkFlows
END
GO
