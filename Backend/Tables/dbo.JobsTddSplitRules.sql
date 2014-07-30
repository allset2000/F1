CREATE TABLE [dbo].[JobsTddSplitRules]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NOT NULL,
[AllTagged] [bit] NOT NULL CONSTRAINT [DF_JobsTddSplitRules_AllTagged] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsTddSplitRules] ADD CONSTRAINT [PK_JobsTddSplitRules] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsTddSplitRules] ADD CONSTRAINT [FK_JobsTddSplitRules_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
