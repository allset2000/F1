CREATE TABLE [dbo].[Dictators](
	[DictatorID] [int] IDENTITY(1,1) NOT NULL,
	[DictatorName] [varchar](50) NOT NULL CONSTRAINT [DF_Dictators_DictatorName]  DEFAULT (''),
	[ClinicID] [smallint] NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_Dictators_Active]  DEFAULT ((0)),
	[DefaultJobTypeID] [int] NOT NULL,
	[Password] [varchar](64) NOT NULL,
	[Salt] [varchar](32) NOT NULL,
	[FirstName] [varchar](100) NOT NULL CONSTRAINT [DF_Dictators_FirstName]  DEFAULT (''),
	[MI] [varchar](100) NOT NULL CONSTRAINT [DF_Dictators_MI]  DEFAULT (''),
	[LastName] [varchar](100) NOT NULL CONSTRAINT [DF_Dictators_LastName]  DEFAULT (''),
	[Suffix] [varchar](100) NOT NULL CONSTRAINT [DF_Dictators_Suffix]  DEFAULT (''),
	[Initials] [varchar](20) NOT NULL CONSTRAINT [DF_Dictators_Initials]  DEFAULT (''),
	[Signature] [varchar](1000) NOT NULL CONSTRAINT [DF_Dictators_Signature]  DEFAULT (''),
	[EHRProviderID] [varchar](36) NOT NULL,
	[EHRProviderAlias] [varchar](36) NOT NULL,
	[DefaultQueueID] [int] NULL,
	[VRMode] [smallint] NOT NULL CONSTRAINT [DF__Dictators__VRMod__4E1E9780]  DEFAULT ((99)),
	[CRFlagType] [int] NOT NULL CONSTRAINT [DF_Dictators_CRFlagType]  DEFAULT ((0)),
	[ForceCRStartDate] [datetime] NULL,
	[ForceCREndDate] [datetime] NULL,
	[ExcludeStat] [bit] NOT NULL CONSTRAINT [DF_Dictators_ExcludeStat]  DEFAULT ((0)),
	[SignatureImage] [varbinary](max) NULL,
	[ImageName] [varchar](100) NULL,
	[UserId] [int] NULL,
	[SRETypeId] [int] NULL,
 CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED 
(
	[DictatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_Dictators_Unique_DictatorName] UNIQUE NONCLUSTERED 
(
	[DictatorName] ASC,
	[ClinicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

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

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [FK_Dictators_JobTypes]
GO

ALTER TABLE [dbo].[Dictators]  WITH CHECK ADD  CONSTRAINT [fk_dictators_SRETypeId] FOREIGN KEY([SRETypeId])
REFERENCES [dbo].[SREEngineType] ([SRETypeId])
GO

ALTER TABLE [dbo].[Dictators] CHECK CONSTRAINT [fk_dictators_SRETypeId]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Client UserID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DictatorID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BackEnd Dictator Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DictatorName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default Job Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Dictators', @level2type=N'COLUMN',@level2name=N'DefaultJobTypeID'
GO


