SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 12/16/2014
-- Description: Temporary SP used to manually import dictations 
-- Part of Redmine ticket 3185
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3185_ImportManualDictation]

@dictatorid int,
@dictationid bigint,
@JobID bigint

AS 

Begin Tran

update D
set D.dictatorid = @dictatorid
FROM dictations  D
inner join Jobs J on D.jobid = J.jobid
where D.dictationid = @dictationid and J.jobid = @JobID

update D
set D.Status = 250, D.FileName= 'C:\AudioIn\' + CONVERT(varchar(50), @dictationid) + '.ima4' 
FROM Dictations D
inner join Jobs J on d.jobid = J.jobid 
where D.DictationID = @dictationid and J.jobid = @JobID

update J
set J.Status = 300
from jobs J
inner join dictations D on D.jobid = J.jobid
where D.dictationid = @dictationid and J.jobid = @JobID

Commit Tran
GO
