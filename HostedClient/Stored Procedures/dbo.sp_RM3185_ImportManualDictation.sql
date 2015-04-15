
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 12/16/2014
-- Description: Temporary SP used to manually import dictations 
-- Part of Redmine ticket 3185
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3185_ImportManualDictation]

@dictatorid int,
@dictationid bigint,
@JobID bigint,
@Mode int = 1
-- 1 = Just Update Status, 2 = Update Status, rename filename, move file

AS 

Begin Tran

DECLARE @ClinicID smallint
DECLARE @DictatorName varchar(50)
DECLARE @MoveFromLoc Varchar(500) = '\\prod-app001.entrada.local\AudioBackup\'
--- Dev - '\\Dev-app001.entrada-dev.local\AudioBackup\'
DECLARE @MoveToLoc Varchar(500) = '\\prod-app001.entrada.local\AudioIn\'
--- Dev - '\\Dev-app001.entrada-dev.local\AudioIn\'

SET @ClinicID = (Select ClinicID from Jobs where JobID = @JobID)
SET @DictatorName = (SELECT DictatorName from Dictators where DictatorID = @DictatorID)

--- IF @Mode = 2, then move the file from the AudioBackup location to the AudioIn. Also, update the the current filename in Jobs_Client table to -old. 

IF @Mode = 2 

BEGIN 

declare @cmdstring varchar(5000)

set @cmdstring = 'move ' + @MoveFromLoc + CONVERT(VARCHAR(10),@clinicID) + '\' + @DictatorName + '\' + CONVERT(VARCHAR(20),@dictationid) + '.ima4 ' + 
@MoveToLoc + CONVERT(VARCHAR(20),@dictationid) + '.ima4' 

exec master..xp_cmdshell @cmdstring 

UPDATE JC
set Filename = Filename + '-old'
from Entrada.dbo.Jobs_Client JC
INNER JOIN EntradaHostedClient.dbo.Jobs J ON J.Jobnumber = JC.Filename
where jobid = @JobID

END 

--- Update Job Status --- 

IF @Mode = 1 or @Mode = 2

BEGIN

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

END

Commit Tran

GO
