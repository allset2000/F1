SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 7/29/15
-- Description: Temp SP used to undelete jobs \ This is being used until the functionality is fixed in Admin Console
-- This stored proc sets the jobs back to Status 100
-- =============================================

CREATE PROCEDURE [dbo].[sp_TFS993_UndeleteJobs] 

@JobID bigint 

AS 

update entradahostedclient.dbo.jobs set status = 100 where jobid = @JobID;

update entradahostedclient.dbo.dictations set status = 100 where jobid = @JobID;

GO
