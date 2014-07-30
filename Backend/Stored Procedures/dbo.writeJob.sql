SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeJob] (
	@JobId  [int],
	@JobNumber  [varchar]  (20),
	@DictatorID  [varchar]  (50),
	@ClinicID  [smallint],
	@Location  [smallint],
	@AppointmentDate  [smalldatetime],
	@AppointmentTime  [smalldatetime],
	@JobType  [varchar]  (100),
	@ContextName  [varchar]  (100),
	@Vocabulary  [varchar]  (255),
	@Stat  [bit],
	@CC  [bit],
	@Duration  [smallint],
	@DictationDate  [smalldatetime],
	@DictationTime  [smalldatetime],
	@ReceivedOn  [datetime],
	@ReturnedOn  [datetime],
	@CompletedOn  [datetime],
	@RecServer  [varchar]  (50),
	@EditorID  [varchar]  (50),
	@BilledOn  [datetime],
	@Amount  [money],
	@ParentJobNumber  [varchar]  (20),
	@DocumentStatus  [smallint],
	@AppointmentId  [int],
	@DocumentId  [int],
	@JobStatus  [smallint],
	@JobStatusDate  [datetime],
	@JobPath  [varchar]  (200),
	@GenericPatientFlag  [bit],
	@PoorAudioFlag  [bit],
	@TranscriptionModeFlag  [bit] 
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
			UPDATE [dbo].[Jobs] 
			 SET
			 --[DictatorID] = @DictatorID ,
			 --[ClinicID] = @ClinicID ,
			 --[Location] = @Location ,
			 [AppointmentDate] = @AppointmentDate ,
			 --[AppointmentTime] = @AppointmentTime ,
			 [JobType] = @JobType ,
			 --[ContextName] = @ContextName ,
			 --[Vocabulary] = @Vocabulary ,
			 [Stat] = @Stat ,
			 [CC] = @CC		
			 --[Duration] = @Duration ,
			 --[DictationDate] = @DictationDate ,
			 --[DictationTime] = @DictationTime ,
			 --[ReceivedOn] = @ReceivedOn ,
			 --[ReturnedOn] = @ReturnedOn ,
			 --[CompletedOn] = @CompletedOn ,
			 --[RecServer] = @RecServer ,
			 --[EditorID] = @EditorID ,
			 --[BilledOn] = @BilledOn ,
			 --[Amount] = @Amount ,
			 --[ParentJobNumber] = @ParentJobNumber ,
			 --[DocumentStatus] = @DocumentStatus ,
			 --[AppointmentId] = @AppointmentId ,
			 --[DocumentId] = @DocumentId ,
			 --[JobStatus] = @JobStatus ,
			 --[JobStatusDate] = @JobStatusDate ,
			 --[JobPath] = @JobPath ,
			 --[GenericPatientFlag] = @GenericPatientFlag ,
			 --[PoorAudioFlag] = @PoorAudioFlag ,
			 --[TranscriptionModeFlag] = @TranscriptionModeFlag  
		WHERE ([JobNumber] = @JobNumber)
		
		EXEC dbo.doUpdateJobDueDate @JobNumber, 'SaveJob'
	 
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
END
GO
