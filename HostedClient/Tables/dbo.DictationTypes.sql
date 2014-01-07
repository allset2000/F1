CREATE TABLE [dbo].[DictationTypes]
(
[DictationTypeID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[JobTypeID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_DictationTypes_Active] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DictationTypes] ADD CONSTRAINT [PK_DictationTypes] PRIMARY KEY CLUSTERED  ([DictationTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DictationTypes_ClinicID] ON [dbo].[DictationTypes] ([ClinicID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DictationTypes_JobTypeID] ON [dbo].[DictationTypes] ([JobTypeID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DictationTypes] WITH NOCHECK ADD CONSTRAINT [FK_DictationTypes_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DictationTypes] ADD CONSTRAINT [FK_DictationTypes_JobTypes] FOREIGN KEY ([JobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
