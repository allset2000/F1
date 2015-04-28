SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 04/27/2015
	Version: 1.0
	Details: Inserts new record into JobDeliveryHistory table. Returns inserted record's DeliveryID
	
	Revised Date: 
	Revised By: 
	Revision Details: 
*/
CREATE PROCEDURE [dbo].[InsertJobDeliveryHistory] (
	@JobNumber VARCHAR(20) = NULL, 
	@Method SMALLINT = NULL, 
	@RuleName VARCHAR(100) = NULL, 
	@DeliveredOn DATETIME = NULL, 
	@JobData VARCHAR(200) = NULL, 
	@Id INT = NULL
) AS
BEGIN
	SET @DeliveredOn = COALESCE(@DeliveredOn, GETDATE())

	INSERT INTO [dbo].[JobDeliveryHistory] (JobNumber, Method, RuleName, DeliveredOn, JobData, Id)
	VALUES (@JobNumber, @Method, @RuleName, @DeliveredOn, @JobData, @Id)

	SELECT SCOPE_IDENTITY()
END

GO
