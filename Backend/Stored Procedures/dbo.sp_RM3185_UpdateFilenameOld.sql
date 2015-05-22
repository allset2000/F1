
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

@Jobnumber varchar(20)

AS 

Begin Tran

UPDATE Entrada.dbo.Jobs_Client
set Filename = Filename + '-old'
where jobnumber = @Jobnumber

Commit Tran

GO
