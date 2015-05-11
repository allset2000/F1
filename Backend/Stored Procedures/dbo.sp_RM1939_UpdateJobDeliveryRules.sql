SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 5/11/15
-- Description: Temp SP used to update values in JobDeliveryRules Table
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM1939_UpdateJobDeliveryRules] 
(
@RuleID int,
@ClinicID smallint = NULL,
@DictatorName varchar(50) = NULL,
@JobType varchar(100) = NULL,
@Method smallint = NULL,
@Rulename varchar(50) = NULL,
@AvoidRedelivery Bit = NULL
) 

AS 

BEGIN
	
	IF (@ClinicID is not null)
	BEGIN
		UPDATE JobDeliveryRules SET ClinicID = @ClinicID where RuleID = @RuleID 
	END

	IF (@DictatorName is not null)
	BEGIN
		UPDATE JobDeliveryRules SET DictatorName = @DictatorName where RuleID = @RuleID 
	END

	IF (@JobType is not null)
	BEGIN
		UPDATE JobDeliveryRules SET JobType = @JobType where RuleID = @RuleID 
	END

	IF (@Method is not null)
	BEGIN
		UPDATE JobDeliveryRules SET Method = @Method where RuleID = @RuleID 
	END

	IF (@Rulename is not null)
	BEGIN
		UPDATE JobDeliveryRules SET Rulename = @Rulename where RuleID = @RuleID 
	END

	IF (@AvoidRedelivery is not null)
	BEGIN
		UPDATE JobDeliveryRules SET AvoidRedelivery = @AvoidRedelivery where RuleID = @RuleID 
	END
	
END


GO
