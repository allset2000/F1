CREATE TABLE [dbo].[JobTypes]
(
[JobTypeID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_JobTypes_Active] DEFAULT ((0)),
[Vocabulary] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TddEnabled] [bit] NOT NULL CONSTRAINT [DF_JobTypes_TddEnabled] DEFAULT ((0)),
[AckEnabled] [smallint] NOT NULL CONSTRAINT [DF_RulesJobs_AckEnabled] DEFAULT ((0)),
[EHRDocumentTypeID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_JobTypes_EHRDocumentTypeID] DEFAULT (''),
[EHRImageTypeID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JobTypes_EHRImageTypeID] DEFAULT (''),
[NoShowEnabled] [bit] NOT NULL CONSTRAINT [DF__JobTypes__NoShow__4C364F0E] DEFAULT ((0)),
[DisableGenericJobs] [bit] NOT NULL CONSTRAINT [DF__JobTypes__Disabl__4D2A7347] DEFAULT ((0)),
[AllowEncounterSearch] [bit] NOT NULL CONSTRAINT [DF_JobTypes_AllowEncounterSearch] DEFAULT ((0)),
[AllowNotifications] [bit] NOT NULL CONSTRAINT [DF_JobTypes_AllowNotifications] DEFAULT ((0)),
[DocumentType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_JobTypes_DocumentType] DEFAULT (''),
[ROWTemplateId] [int] NULL,
[ACKTemplateId] [int] NULL,
[UpdatedDateInUTC] [datetime] NULL CONSTRAINT [DF_JobTypes_UpdatedDateInUTC] DEFAULT (getutcdate()),
[JobTypeCategoryId] [int] NOT NULL CONSTRAINT [DF__JobTypes__JobTyp__1EF06FC3] DEFAULT ((1)),
[EncounterTemplate] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictationTemplate] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateEncounter] [bit] NULL,
[EncounterSearchTypeId] [int] NULL,
[EncounterCategory] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskSubject] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskTypeId] [int] NULL CONSTRAINT [DF_JobTypes_TaskTypeId] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[JobTypes] ADD
CONSTRAINT [FK_JobTypes_EncounterSearchType] FOREIGN KEY ([EncounterSearchTypeId]) REFERENCES [dbo].[EncounterSearchType] ([EncounterSearchTypeId])
ALTER TABLE [dbo].[JobTypes] ADD
CONSTRAINT [FK_JobTypes_TaskType] FOREIGN KEY ([TaskTypeId]) REFERENCES [dbo].[TaskType] ([TaskTypeID])
GO
ALTER TABLE [dbo].[JobTypes] ADD CONSTRAINT [PK_JobTypes] PRIMARY KEY CLUSTERED  ([JobTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobTypes_ClinicID] ON [dbo].[JobTypes] ([ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobTypes] WITH NOCHECK ADD CONSTRAINT [FK_JobTypes_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JobTypes] ADD CONSTRAINT [FK_JobTypes_JobTypeCategory] FOREIGN KEY ([JobTypeCategoryId]) REFERENCES [dbo].[JobTypeCategory] ([JobTypeCategoryId])
GO
