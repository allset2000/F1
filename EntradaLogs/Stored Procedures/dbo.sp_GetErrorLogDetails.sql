
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 01/04/2016
-- Description:	Error log details
-- ModifiedDate: 3/22/2016
-- Description : Exception message and application filter added 

-- =============================================
--exec sp_GetErrorLogDetails 0,0,'2/1/2016','3/22/2016','System.IO.DirectoryNotFoundException: Could not find a part of the path 'C:\ExpressLinkOut'.at ',''
CREATE PROCEDURE [dbo].[sp_GetErrorLogDetails]	
@LogConfigurationID INT=NULL,
@LogExceptionID INT=NULL,
@FromDate DATE=NULL,
@ToDate DATE=NULL,
@ExceptionMessage NVarchar(MAX)=NULL,
@ApplicationName Varchar(300)=NULL

AS
BEGIN

   SET NOCOUNT ON;
	 
   DECLARE @SqlStatement NVARCHAR(MAX)

   
	 
	SET @SqlStatement='SELECT LE.LogExceptionID, LE.LogConfigurationID, LE.MainClassName, LE.MainMethodName, LE.ErrorThrownAtClassName, LE.ErrorThrownAtMethodName, LE.ExceptionMessage, 
			LE.InnerError, LE.StackTrace, LE.ErrorCreatedDate, LE.ErrorWrittenDate, LCD.LogExceptionsCustomDataID, LCD.UserID, LCD.DictatorID, LCD.ConfigID, LCD.JobID, LCD.JobNumber,
			LCD.DictationID, LCD.EditorID, LCD.ErrorCustomDescription, LCD.ErrorCustomProcess, LCD.Parameters, LCD.LogCreatedDate, LCD.LogWrittenDate, LCD.CustomData1, LCD.DictationTypeId,
			LCD.UploadedFileName, LCD.ClinicId, LCD.ClinicCode, LCD.IP, LCD.MobileUserAgent, LCD.EncounterID, LCD.PatientID, LCD.ThreadID, LCD.MobileTrackingId, LCD.MobileVersion,
			LCD.MobileBuild, LCD.MobileOS, LCD.QuickBloxUserId, LCD.JobTypeID, LCD.UserAgent, LCD.ApiKey, LCD.DeliveryID, LCD.ImageID, LCD.Macro, LCD.TemplateName, LCD.NewEditorId, LCD.JobStage,
            LCD.SendingQALevel, LCD.ClinicName, LCD.BackendCompanyId, LCD.BackendDictatorName, LCD.BackendEditorId, LCD.SearchQuery, LCD.BackendDeliveryId, LCD.DeletedBy, LCD.SplitRuleId,
			LCD.TddTagId, LCD.TddTagName, LCD.ROWAdminId, LCD.ROWUserId, LCD.DictatorId_str, LCD.QueueId, LCD.EHRClinicId, LCD.ChangedData, LCD.ClinicDocumentId, LCD.RoleId, LCD.ActionId,
			LCD.ErrorId, LCD.ConfigurationId, LCD.ConnectionString, LCD.InvitationId
	FROM DBO.LogExceptions LE
	INNER JOIN [LogConfiguration] LC ON LC.LogConfigurationID=LE.LogConfigurationID
	LEFT JOIN [dbo].[LogExceptionsCustomData] LCD ON LCD.LogExceptionID=LE.LogExceptionID
	WHERE 1=1 '

	IF (@FromDate IS NOT NULL)
	  SET @SqlStatement+='AND CONVERT(DATE,LE.ErrorCreatedDate)>='''+CONVERT(VARCHAR(10),@FromDate,101)+''' AND CONVERT(DATE,LE.ErrorCreatedDate)<='''+CONVERT(VARCHAR(10),@ToDate,101)+''''

	IF(ISNULL(@LogConfigurationID,0)>0)
		SET @SqlStatement+=' AND LE.LogConfigurationID='+CAST(@LogConfigurationID AS VARCHAR)

	IF(ISNULL(@LogExceptionID,0)>0)
		 SET @SqlStatement+=' AND LE.LogExceptionID='+CAST(@LogExceptionID AS VARCHAR)
    
	IF(ISNULL(@ExceptionMessage,'')<>'')
	BEGIN
	 --Replace single quote with double quote
	 SET @ExceptionMessage=REPLACE(@ExceptionMessage,'''','''''')
	 SET @SqlStatement+=' AND LE.ExceptionMessage LIKE '''+CAST(@ExceptionMessage AS NVARCHAR(MAX))+'%'''
    END

	 IF(ISNULL(@ApplicationName,'')<>'')
	 SET @SqlStatement+=' AND LC.ApplicationName='''+CAST(@ApplicationName AS VARCHAR(300))+''''

	
	EXEC (@SqlStatement)

END
GO
