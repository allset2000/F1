CREATE TABLE [dbo].[Dictators]
(
[DictatorID] [int] NOT NULL IDENTITY(1, 1),
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_DictatorName] DEFAULT (''),
[ClinicID] [smallint] NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_Dictators_Active] DEFAULT ((0)),
[DefaultJobTypeID] [int] NOT NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_FirstName] DEFAULT (''),
[MI] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_MI] DEFAULT (''),
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_LastName] DEFAULT (''),
[Suffix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Suffix] DEFAULT (''),
[Initials] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Initials] DEFAULT (''),
[Signature] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Signature] DEFAULT (''),
[EHRProviderID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRProviderAlias] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultQueueID] [int] NULL,
[VRMode] [smallint] NOT NULL CONSTRAINT [DF_Dictators_VRMode] DEFAULT ((99)),
[CRFlagType] [int] NOT NULL CONSTRAINT [DF_Dictators_CRFlagType] DEFAULT ((0)),
[ForceCRStartDate] [datetime] NULL,
[ForceCREndDate] [datetime] NULL,
[ExcludeStat] [bit] NOT NULL CONSTRAINT [DF_Dictators_ExcludeStat] DEFAULT ((0)),
[SignatureImage] [varbinary] (max) NULL,
[ImageName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [int] NULL,
[SRETypeId] [int] NULL,
[RhythmWorkFlowID] [int] NULL,
[AppSetting_DisableSendToTranscription] [bit] NOT NULL CONSTRAINT [DF_Dictators_AppSetting_DisableSendToTranscription] DEFAULT ((0)),
[Preference] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED  ([DictatorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Dictators_ClinicID] ON [dbo].[Dictators] ([ClinicID], [EHRProviderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Dictators_DictatorName] ON [dbo].[Dictators] ([DictatorName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [IX_Dictators_Unique_DictatorName] UNIQUE NONCLUSTERED  ([DictatorName], [ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_CRFlagTypes] FOREIGN KEY ([CRFlagType]) REFERENCES [dbo].[CRFlagTypes] ([CRFlagType])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_JobTypes] FOREIGN KEY ([DefaultJobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_RhythmWorkFlows] FOREIGN KEY ([RhythmWorkFlowID]) REFERENCES [dbo].[RhythmWorkFlows] ([RhythmWorkFlowID])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [fk_dictators_SRETypeId] FOREIGN KEY ([SRETypeId]) REFERENCES [dbo].[SREEngineType] ([SRETypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DefaultJobTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Client UserID', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'BackEnd Dictator Name', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorName'
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_Clinics]
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_CRFlagTypes]
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_JobTypes]

GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [fk_dictators_SRETypeId]
GO
