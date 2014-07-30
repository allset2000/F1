SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[doUpdateNewWorkflowData]
AS

BEGIN TRY
BEGIN TRANSACTION

  DECLARE @idValue int 

	SELECT @idValue = MAX(EditorIdOk) FROM [dbo].[Editors] 

	/* Append Companies */



	/* Set Editors Companies */
 
    UPDATE dbo.Editors 
	SET dbo.Editors.EditorCompanyId = dbo.Companies.CompanyId
	FROM dbo.Editors INNER JOIN dbo.Editors_Pay ON dbo.Editors.EditorID = dbo.Editors_Pay.EditorID 
	INNER JOIN dbo.Companies ON dbo.Editors_Pay.PayType = dbo.Companies.CompanyCode

	/* Set Editors numeric Ids */

	--SELECT @idValue = MAX(EditorIdOk) FROM [dbo].[Editors] 

    
 --   UPDATE [dbo].[Editors]
	--SET 
	--	@idValue = EditorIdOk = @idValue + 1
	--WHERE (EditorIdOk = 0) 
	 
	--/* Set Dictators numeric Ids */
	
	--SELECT @idValue = MAX(DictatorIdOk) FROM [dbo].[Dictators]
 --   IF (@idValue = 0) 
 --   BEGIN
	--   SET @idValue = 5000
 --   END
    
 --   UPDATE [dbo].[Dictators]
	--SET 
	--	@idValue = DictatorIdOk = @idValue + 1
	--WHERE (DictatorIdOk = 0)
		
	--/* Set Jobs_Documents numeric Ids and JobDocumentTypeId */
	
	--SELECT @idValue = MIN(DocumentId) FROM [dbo].[Jobs_Documents] 

 --   UPDATE [dbo].[Jobs_Documents]
	--SET 
	--	@idValue = DocumentId = @idValue - 1,
	--	DocumentTypeId = 1
	--WHERE (DocumentId = 0)
	
	
	--/* Set Jobs numeric Ids, appointment Id's and document Id's */
	
	--SELECT @idValue = MIN(JobId) FROM [dbo].[Jobs]
 --   IF (@idValue = 0) 
 --   BEGIN
	--		SET @idValue = -1
 --   END
    
 --   UPDATE [dbo].[Jobs]
	--SET 
	--	@idValue = JobId = @idValue - 1
	--WHERE (JobId = 0)

 --   UPDATE [dbo].[Jobs]
	--SET 
	--	AppointmentId = JobId,
	--	DocumentId = -1
	--WHERE (JobId < 0)
	
	
 --   UPDATE [dbo].[Jobs]
 --   SET JobStatus = [dbo].[JobStatusA].[Status],
	--	JobStatusDate = [dbo].[JobStatusA].[StatusDate],
	--	JobPath = ISNULL([dbo].[JobStatusA].[Path], '')
 --   FROM [dbo].[Jobs] INNER JOIN [dbo].[JobStatusA] 
	--ON [dbo].[Jobs].JobNumber = [dbo].[JobStatusA].JobNumber
	--WHERE ([dbo].[Jobs].JobStatus = 0 AND JobId < 0)


 --   UPDATE [dbo].[Jobs]
 --   SET JobStatus = [dbo].[JobStatusB].[Status],
	--	JobStatusDate = [dbo].[JobStatusB].[StatusDate],
	--	JobPath = ISNULL([dbo].[JobStatusB].[Path],'')
 --   FROM [dbo].[Jobs] INNER JOIN [dbo].[JobStatusB] 
	--ON [dbo].[Jobs].JobNumber = [dbo].[JobStatusB].JobNumber
	--WHERE ([dbo].[Jobs].JobStatus = 0 AND JobId < 0)
			

 --   UPDATE [dbo].[Jobs]
	--SET 
	--	DocumentId = [dbo].[Jobs_Documents].DocumentId
	--FROM [dbo].[Jobs] INNER JOIN [dbo].[Jobs_Documents] 
	--ON [dbo].[Jobs].JobNumber = [dbo].[Jobs_Documents].JobNumber
	--WHERE ([Jobs].JobId < 0)
	
	--	/* Set Jobs_Patients numeric Ids */
	
	--SELECT @idValue = MAX(PatientId) FROM [dbo].[Jobs_Patients] 

 --   UPDATE [dbo].[Jobs_Patients]
	--SET 
	--	PatientId = JobId,
	--	AppointmentId = [dbo].[Jobs].AppointmentId
	--FROM [dbo].[Jobs_Patients] INNER JOIN [dbo].[Jobs]
	--ON [dbo].[Jobs_Patients].JobNumber = [dbo].[Jobs].JobNumber
	--WHERE (PatientId = 0 OR [dbo].[Jobs_Patients].AppointmentId = 0)
	
	--/* Update Jobs_Documents table */
	
 --   UPDATE [dbo].[Jobs_Documents]
	--SET 	
	--	DocumentStatusId = ISNULL([dbo].[Jobs].DocumentStatus, 1),
	--	JobId = [dbo].[Jobs].JobId
	--FROM [dbo].[Jobs] INNER JOIN [dbo].[Jobs_Documents] 
	--ON [dbo].[Jobs].JobNumber = [dbo].[Jobs_Documents].JobNumber

 --   UPDATE [dbo].[Jobs_Documents_History]
	--SET 
	--	DocumentIdOk = [dbo].[Jobs_Documents].DocumentId,
	--	DocumentTypeId = [dbo].[Jobs_Documents].DocumentTypeId,
	--	DocumentStatusId = [dbo].[Jobs].DocumentStatus,
	--  JobId = [dbo].[Jobs].JobId	
	--FROM [dbo].[Jobs] INNER JOIN [dbo].[Jobs_Documents] 
	--ON [dbo].[Jobs].JobNumber = [dbo].[Jobs_Documents].JobNumber
	--WHERE ([dbo].[Jobs_Documents_History].[DocumentIdOk] = 0)
		
		
	--/* Create missing records in Appointments table */

	--INSERT INTO [dbo].[Appointments]
	--	([AppointmentId], [ClinicID] ,[LocationID] ,[AttendingDictatorID],
	--	 [AppointmentDate], [AppointmentTime], [ReasonTag], [ReasonText], [DocumentId], [AppointmentStatusId])
	--SELECT JobId, [ClinicID], Location, DictatorID,
	--       ISNULL([AppointmentDate], '1900-01-01'), ISNULL([AppointmentTime],'1900-01-01') , '', '', [DocumentId], 1
	--FROM dbo.[Jobs] WHERE (dbo.[Jobs].JobId < 0) AND (dbo.[Jobs].JobId NOT IN (SELECT [dbo].[Appointments].AppointmentId FROM [dbo].[Appointments])) 
	
	--UPDATE [dbo].[Appointments]
	--SET [AppointmentDate] = ISNULL([dbo].[Jobs].[AppointmentDate], '1900-01-01'),
	--    [AppointmentTime]	= ISNULL([dbo].[Jobs].[AppointmentTime], '1900-01-01'),
	--   	[DocumentId] = [dbo].[Jobs].[DocumentId] 
	--FROM [dbo].[Appointments] INNER JOIN [dbo].[Jobs]
	--ON [dbo].[Appointments].AppointmentId = [dbo].[Jobs].AppointmentId

	--/* Append records into Jobs_MultDications table */
	
	--INSERT INTO [dbo].[JobDictations]
	--([DictationId], [JobNumber], [DictatorID], [ContextName], [Vocabulary], [Duration],
	-- [DictationDate], [DictationTime], [RecServer], [RecognizedText], [DictationStatus], [DocumentId])
	--SELECT JobId, JobNumber, DictatorId, [ContextName], Vocabulary, Duration,
	-- [DictationDate], [DictationTime], [RecServer], '', 1, DocumentId
	--FROM dbo.[Jobs] WHERE (dbo.[Jobs].JobId < 0) AND dbo.[Jobs].JobId NOT IN (SELECT [dbo].[JobDictations].[DictationId] FROM [dbo].[JobDictations])
	
	
	exec sp_updatestats;

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
		ROLLBACK TRANSACTION
						DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
						SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	   END
END CATCH

RETURN


  /*
  
   UPDATE [dbo].[Editors]
	SET 
		EditorIdOk = 0
	 
    UPDATE [dbo].[Dictators]
	SET DictatorIdOk = 0

	
	UPDATE [dbo].[Jobs]
	SET 
		JobId = 0,
		DocumentId = 0,
		AppointmentId = 0,
		JobStatus = 0,
		JobStatusDate = '2078-12-31',
		JobPath = ''	
		
	 UPDATE [dbo].[Jobs_Documents]
	SET 
		DocumentId = 0,
		DocumentTypeId = 0,
		JobId = 0
		
	  UPDATE [dbo].[Jobs_Documents_History]
	SET 
		DocumentIdOk = 0,
		DocumentTypeId = 0,
		DocumentStatusId = 0,
		JobId = 0
		
	  UPDATE [dbo].[Jobs_Patients]
		SET 
		PatientId = 0,
		AppointmentId = 0
		
		TRUNCATE TABLE [dbo].[Appointments]	
		TRUNCATE TABLE [dbo].[JobDictations]
		
		
	INSERT INTO [Entrada_100223].[dbo].[Jobs_Documents]
           ([JobNumber]
           ,[Doc]
           ,[XmlData]
           ,[Username]
           ,[DocDate]
           ,[DocumentId]
           ,[DocumentTypeId]
           ,[DocumentStatusId]
           ,[JobId])
	select '', Doc, XmlData, Username, DocDate,
	DocumentId, DocumentTypeId, DocumentStatusId, JobId from 
	[Entrada_100223].[dbo].[Jobs_Documents]
	where jobNumber = '010308000038'
	  
	  	
	*/

GO
