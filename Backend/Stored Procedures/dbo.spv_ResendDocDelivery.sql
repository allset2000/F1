
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 05-APR-2016
-- Description:	This procedure will resend Job document and update in Jod_Documents, Job_Documents_History and  Job_history
-- =============================================
CREATE PROCEDURE [dbo].[spv_ResendDocDelivery]
@Jobnumber varchar(20),
@Documnet varbinary(max),
@UserName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	   BEGIN TRY
	--1 INSERT the jobs_documents_history with current document exists in jobs_document
	--2 UPDATE the @Docuemnt into Jobs_docuemnts
	--3 INSERT into Job_History with document ID mapping with JobS_Documents_History for Delivery status
		DECLARE @currentDate DATETIME 	
		SET @currentDate = GETDATE()
		EXEC doUpdateJobDocument @Jobnumber, @Documnet,@UserName,@currentDate
	--4 INSERT into JobsToDeliver with previously used Delivery mehtod which we need to get form Jobsdelivery_History.
		Declare @Method  smallint 
		Declare @RuleName varchar(100)

		DECLARE @JobHitoryID INT
		SELECT @JobHitoryID = IDENT_CURRENT('Job_History')
		UPDATE dbo.Job_History SET UserId = @UserName WHERE JobHistoryID = @JobHitoryID
		SELECT top 1 @Method = Method, @RuleName = RuleName from JobDeliveryHistory where JobNumber = @JobNumber order by DeliveredOn DESC
		IF NOT EXISTS(SELECT * FROM [dbo].[JobsToDeliver] WHERE (([JobNumber] = @JobNumber) AND ([Method] = @Method) AND ([RuleName] = @RuleName)))
		   BEGIN
				INSERT INTO [dbo].[JobsToDeliver] ( [JobNumber],[Method], [RuleName], [LastUpdatedOn],[JobHistoryID]) 
				VALUES  ( @JobNumber, @Method, @RuleName, Getdate(),@JobHitoryID)
			END
		END TRY
		BEGIN CATCH
				DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
						@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
						@errorState AS INT = (SELECT ERROR_STATE())

			INSERT INTO [EntradaLogs].dbo.LogExceptions 
					   (LogConfigurationID,ErrorThrownAtMethodName,ExceptionMessage,StackTrace,ErrorCreatedDate)
			   SELECT LogConfigurationID,'spv_ResendDocDelivery',@errorMessage,@errorMessage,GETDATE() FROM [EntradaLogs].dbo.LogConfiguration 
			   WHERE ApplicationCode='CUSTOMER_PORTAL_UI'
		END CATCH

END

GO
