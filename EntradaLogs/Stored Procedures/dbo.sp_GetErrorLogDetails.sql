SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	Error log details
-- =============================================
--exec sp_GetErrorLogDetails 0,0,@LogExceptionMessage='System.AggregateException: One or more errors occurred. ---> System.Data.SqlClient.SqlException:'
CREATE PROCEDURE [dbo].[sp_GetErrorLogDetails]	
@LogConfigurationID INT=0,
@LogExceptionID INT=0,
@FromDate DATE=NULL,
@ToDate DATE=NULL
AS
BEGIN

   SET NOCOUNT ON;
	 
   DECLARE @SqlStatement NVARCHAR(MAX)

   SET @ToDate=ISNULL(@ToDate,GETDATE())

   SET @FromDate=ISNULL(@FromDate,DATEADD(DAY,-7,GETDATE()))

	 
	SET @SqlStatement='SELECT LE.LogExceptionID, LE.LogConfigurationID, LE.MainClassName, LE.MainMethodName, LE.ErrorThrownAtClassName, LE.ErrorThrownAtMethodName, LE.ExceptionMessage, 
			LE.InnerError, LE.StackTrace, LE.ErrorCreatedDate, LE.ErrorWrittenDate, LC.LogExceptionsCustomDataID, LC.UserID, LC.DictatorID, LC.ConfigID, LC.JobID, LC.JobNumber,
			LC.DictationID, LC.EditorID, LC.ErrorCustomDescription, LC.ErrorCustomProcess, LC.Parameters, LC.LogCreatedDate, LC.LogWrittenDate, LC.CustomData1, LC.DictationTypeId,
			LC.UploadedFileName, LC.ClinicId, LC.ClinicCode, LC.IP, LC.MobileUserAgent, LC.EncounterID, LC.PatientID, LC.ThreadID, LC.MobileTrackingId, LC.MobileVersion,
			LC.MobileBuild, LC.MobileOS, LC.QuickBloxUserId, LC.JobTypeID, LC.UserAgent, LC.ApiKey, LC.DeliveryID, LC.ImageID, LC.Macro, LC.TemplateName, LC.NewEditorId, LC.JobStage,
            LC.SendingQALevel, LC.ClinicName, LC.BackendCompanyId, LC.BackendDictatorName, LC.BackendEditorId, LC.SearchQuery, LC.BackendDeliveryId, LC.DeletedBy, LC.SplitRuleId,
			LC.TddTagId, LC.TddTagName, LC.ROWAdminId, LC.ROWUserId, LC.DictatorId_str, LC.QueueId, LC.EHRClinicId, LC.ChangedData, LC.ClinicDocumentId, LC.RoleId, LC.ActionId,
			LC.ErrorId, LC.ConfigurationId, LC.ConnectionString, LC.InvitationId
	FROM DBO.LogExceptions LE
	INNER JOIN [dbo].[LogExceptionsCustomData] LC ON LC.LogExceptionID=LE.LogExceptionID
	WHERE CONVERT(DATE,LE.ErrorCreatedDate)>='''+CONVERT(VARCHAR(10),@FromDate,101)+''' AND CONVERT(DATE,LE.ErrorCreatedDate)<='''+CONVERT(VARCHAR(10),@ToDate,101)+''''

	IF(ISNULL(@LogConfigurationID,0)>0)
		SET @SqlStatement=@SqlStatement+' AND LE.LogConfigurationID='+CAST(@LogConfigurationID AS VARCHAR)

	IF(ISNULL(@LogExceptionID,0)>0)
		 SET @SqlStatement=@SqlStatement+' AND LE.LogExceptionID='+CAST(@LogExceptionID AS VARCHAR)
    
	EXEC (@SqlStatement)

END
GO
