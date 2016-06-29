
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 02/24/2016
-- Description:	This SP is called from BackendWS to store the STAT changes from Ops Portal
-- Author: Narender
-- Updated date: 29/06/2016
-- Description: Updated SP to use specific columns while updating the history table
-- =============================================
CREATE PROCEDURE [dbo].[writeSTATHistory]
@JobNumber  [varchar]  (20),
@MRN varchar(20), 
@JobType varchar(100), 
@CurrentStatus smallint, 
@UserId [varchar] (40),
@FirstName varchar(20), 
@MI varchar(20), 
@LastName varchar(20),
@STAT bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO [dbo].[Job_History](JobNumber, MRN, JobType, CurrentStatus, DocumentID, UserId, HistoryDateTime,
										FirstName, MI, LastName, DOB, IsHistory, STAT) VALUES( @JobNumber, @MRN, @JobType, @CurrentStatus, NULL, @UserId, GETDATE(), @FirstName, @MI, @LastName, NULL, 1, @STAT )
	END TRY
	BEGIN CATCH
	    
		DECLARE @errorMessage AS VARCHAR(4000) = (SELECT ERROR_MESSAGE()),
					@errorSeverity AS INT = (SELECT ERROR_SEVERITY()),
					@errorState AS INT = (SELECT ERROR_STATE())
		INSERT INTO [EntradaLogs].dbo.LogExceptions
				   (LogConfigurationID,ErrorThrownAtMethodName,ExceptionMessage,StackTrace,ErrorCreatedDate)
		   SELECT LogConfigurationID,'writeSTATHistory',@errorMessage,null,GETDATE() FROM [EntradaLogs].dbo.LogConfiguration 
		   WHERE ApplicationCode='CUSTOMER_PORTAL_UI'
	END CATCH
END

GO
