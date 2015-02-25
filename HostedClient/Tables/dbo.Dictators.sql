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
[VRMode] [smallint] NOT NULL CONSTRAINT [DF__Dictators__VRMod__4E1E9780] DEFAULT ((99)),
[CRFlagType] [int] NOT NULL CONSTRAINT [DF_Dictators_CRFlagType] DEFAULT ((0)),
[ForceCRStartDate] [datetime] NULL,
[ForceCREndDate] [datetime] NULL,
[ExcludeStat] [bit] NOT NULL CONSTRAINT [DF_Dictators_ExcludeStat] DEFAULT ((0)),
[SignatureImage] [varbinary] (max) NULL,
[ImageName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [int] NULL,
[SreType] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[Dictators] ADD
CONSTRAINT [FK__Dictators__SreTy__72F0F4D3] FOREIGN KEY ([SreType]) REFERENCES [dbo].[SreEngine] ([Id])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED  ([DictatorID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [IX_Dictators_Unique_DictatorName] UNIQUE NONCLUSTERED  ([DictatorName], [ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_CRFlagTypes] FOREIGN KEY ([CRFlagType]) REFERENCES [dbo].[CRFlagTypes] ([CRFlagType])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_JobTypes] FOREIGN KEY ([DefaultJobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DefaultJobTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Client UserID', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'BackEnd Dictator Name', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorName'
GO
