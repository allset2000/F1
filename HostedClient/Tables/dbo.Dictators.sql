CREATE TABLE [dbo].[Dictators]
(
[DictatorID] [int] NOT NULL IDENTITY(1, 1),
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_DictatorName] DEFAULT (''),
[ClinicID] [smallint] NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_Dictators_Active] DEFAULT ((0)),
[DefaultJobTypeID] [int] NOT NULL,
[DefaultQueueID] [int] NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_FirstName] DEFAULT (''),
[MI] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_MI] DEFAULT (''),
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_LastName] DEFAULT (''),
[Suffix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Suffix] DEFAULT (''),
[Initials] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Initials] DEFAULT (''),
[Signature] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Dictators_Signature] DEFAULT (''),
[EHRProviderID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRProviderAlias] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VRMode] [smallint] NOT NULL CONSTRAINT [DF__Dictators__VRMod__4E1E9780] DEFAULT ((99)),
[CRFlagType] [int] NOT NULL CONSTRAINT [DF_Dictators_CRFlagType] DEFAULT ((0)),
[ForceCRStartDate] [datetime] NULL,
[ForceCREndDate] [datetime] NULL,
[ExcludeStat] [bit] NOT NULL CONSTRAINT [DF_Dictators_ExcludeStat] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[Dictators] ADD
CONSTRAINT [FK_Dictators_CRFlagTypes] FOREIGN KEY ([CRFlagType]) REFERENCES [dbo].[CRFlagTypes] ([CRFlagType])
ALTER TABLE [dbo].[Dictators] ADD 
CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED  ([DictatorID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [IX_Dictators_Unique_DictatorName] UNIQUE NONCLUSTERED  ([DictatorName], [ClinicID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Dictators_DictatorName] ON [dbo].[Dictators] ([DictatorName]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Dictators_ClinicID] ON [dbo].[Dictators] ([ClinicID]) ON [PRIMARY]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DefaultJobTypeID'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Client UserID', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorID'
GO

EXEC sp_addextendedproperty N'MS_Description', N'BackEnd Dictator Name', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DictatorName'
GO

ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_JobTypes] FOREIGN KEY ([DefaultJobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
