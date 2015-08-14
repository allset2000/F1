CREATE TABLE [dbo].[LogExceptionsCustomData]
(
[LogExceptionsCustomDataID] [int] NOT NULL IDENTITY(1, 1),
[LogExceptionID] [int] NOT NULL,
[UserID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictatorID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConfigID] [int] NULL,
[JobID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobNumber] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictationID] [int] NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCustomDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCustomProcess] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogCreatedDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__LogCr__75B852E5] DEFAULT (getdate()),
[LogWrittenDate] [datetime] NOT NULL CONSTRAINT [DF__LogExcept__LogWr__76AC771E] DEFAULT (getdate()),
[CustomData1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictationTypeId] [int] NULL,
[UploadedFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileUserAgent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EncounterID] [int] NULL,
[PatientID] [int] NULL,
[ThreadID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileTrackingId] [int] NULL,
[MobileVersion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileBuild] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileOS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuickBloxUserId] [int] NULL,
[JobTypeID] [int] NULL,
[UserAgent] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApiKey] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImageID] [bigint] NULL,
[Macro] [varchar](30) NULL,
[TemplateName] [varchar](40) NULL,
[NewEditorId] [varchar](30) NULL,
[JobStage] [varchar](5) NULL,
[SendingQALevel] [varchar](30) NULL,
[ClinicName] [varchar](150) NULL,
[BackendCompanyId] [int] NULL,
[BackendDictatorName] [varchar](150) NULL,
[BackendEditorId] [int] NULL,
[SearchQuery] [varchar](1550) NULL,
[BackendDeliveryId] [int] NULL,
[DeletedBy] [varchar](500) NULL,
[SplitRuleId] [int] NULL,
[TddTagId] [int] NULL,
[TddTagName] [varchar](500) NULL,
[ROWAdminId] [varchar](500) NULL,
[ROWUserId] [varchar](500) NULL,
[DictatorId_str] [varchar](500) NULL,
[QueueId] [int] NULL,
[EHRClinicId] [varchar](100) NULL,
[ChangedData] [varchar](2000) NULL,
[ClinicDocumentId] [int] NULL,
[RoleId] [int] NULL,
[ActionId] [int] NULL,
[ErrorId] [int] NULL,
[ConfigurationId] [int] NULL,
[ConnectionString] [varchar](1000) NULL,
[InvitationId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptionsCustomData] ADD CONSTRAINT [PK_LogExceptionsCustomData] PRIMARY KEY CLUSTERED  ([LogExceptionsCustomDataID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogExceptionsCustomData] ADD CONSTRAINT [FK_LogExceptionsCustomData_LogExceptions] FOREIGN KEY ([LogExceptionID]) REFERENCES [dbo].[LogExceptions] ([LogExceptionID])
GO
