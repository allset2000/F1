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
[SRETypeId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED  ([DictatorID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [IX_Dictators_Unique_DictatorName] UNIQUE NONCLUSTERED  ([DictatorName], [ClinicID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Dictators_ClinicID] ON [dbo].[Dictators] ([ClinicID], [EHRProviderID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Dictators_DictatorName] ON [dbo].[Dictators] ([DictatorName]) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Dictators]  WITH CHECK ADD  CONSTRAINT [FK_Dictators_Clinics] FOREIGN KEY([ClinicID])
REFERENCES [dbo].[Clinics] ([ClinicID])
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_Clinics]
GO

ALTER TABLE [dbo].[Dictators]  WITH CHECK ADD  CONSTRAINT [FK_Dictators_CRFlagTypes] FOREIGN KEY([CRFlagType])
REFERENCES [dbo].[CRFlagTypes] ([CRFlagType])
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_CRFlagTypes]
GO

ALTER TABLE [dbo].[Dictators]  WITH CHECK ADD  CONSTRAINT [FK_Dictators_JobTypes] FOREIGN KEY([DefaultJobTypeID])
REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO

CREATE NONCLUSTERED INDEX [IX_Dictators_ClinicID] ON [dbo].[Dictators] ([ClinicID], [EHRProviderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Dictators_DictatorName] ON [dbo].[Dictators] ([DictatorName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_JobTypes]

GO

ALTER TABLE [dbo].[Dictators]  WITH CHECK ADD  CONSTRAINT [fk_dictators_SRETypeId] FOREIGN KEY([SRETypeId])
REFERENCES [dbo].[SREEngineType] ([SRETypeId])
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [fk_dictators_SRETypeId]
GO

ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [fk_dictators_SRETypeId] FOREIGN KEY ([SRETypeId]) REFERENCES [dbo].[SREEngineType] ([SRETypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'DefaultJobTypeID'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Client UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DictatorID'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BackEnd Dictator Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DictatorName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default Job Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DefaultJobTypeID'
GO
