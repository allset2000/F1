CREATE TABLE [dbo].[JobTypes]
(
[JobTypeID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_JobTypes_Active] DEFAULT ((0)),
[Vocabulary] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TddEnabled] [bit] NOT NULL CONSTRAINT [DF_JobTypes_TddEnabled] DEFAULT ((0)),
[AckEnabled] [smallint] NOT NULL CONSTRAINT [DF_RulesJobs_AckEnabled] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobTypes] ADD CONSTRAINT [PK_JobTypes] PRIMARY KEY CLUSTERED  ([JobTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobTypes_ClinicID] ON [dbo].[JobTypes] ([ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobTypes] WITH NOCHECK ADD CONSTRAINT [FK_JobTypes_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
