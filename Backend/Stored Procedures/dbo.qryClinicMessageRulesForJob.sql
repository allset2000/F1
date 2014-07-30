SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryClinicMessageRulesForJob] (
	 @MessageTypeId int,
	 @ClinicID smallint,
	 @LocationID smallint, 
	 @DictatorID varchar(50),
	 @JobType varchar(50)	 
) AS
	SELECT dbo.ClinicsMessagesRules.*
	FROM dbo.ClinicsMessagesRules
	WHERE (MessageTypeId = @MessageTypeId) AND 
	      (ClinicID IN (-1, @ClinicID)) AND 
		  (LocationID IN (0, -1, @LocationID)) AND 
	      (DictatorID IN ('', @DictatorID)) AND 
          (JobType IN ('', @JobType))
RETURN
GO
