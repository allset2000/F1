SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Stored Procedure

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 12/16/2014
-- Description: Temporary SP used to manually mark jobs -old in the Jobs_Client table 
-- Part of Redmine ticket 3185
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3185_UpdateFilenameOld]

@JobID bigint

AS 

Begin Tran

UPDATE JC
set Filename = Filename + '-old'
from Entrada.dbo.Jobs_Client JC
INNER JOIN EntradaHostedClient.dbo.Jobs J ON J.Jobnumber = JC.Filename
where jobid = @JobID

Commit Tran


GO
