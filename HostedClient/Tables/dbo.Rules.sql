CREATE TABLE [dbo].[Rules]
(
[RuleID] [smallint] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_Rules_Enabled] DEFAULT ((1)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_Rules_CreatedOn] DEFAULT (getdate()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_Rules_LastUpdatedOn] DEFAULT (getdate()),
[Description] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BeginDate] [datetime] NOT NULL CONSTRAINT [DF_Rules_BeginDate] DEFAULT (CONVERT([datetime],CONVERT([varchar](10),getdate(),(101)),(0))),
[EndDate] [datetime] NOT NULL CONSTRAINT [DF_Rules_EndDate] DEFAULT ('2099-12-31 00:00:00.000'),
[JobTypeID] [int] NOT NULL,
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Rules_Type] DEFAULT ('S')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rules] ADD CONSTRAINT [PK_Rules] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rules] ADD CONSTRAINT [FK_Rules_JobTypeID] FOREIGN KEY ([JobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Rules', 'COLUMN', N'Enabled'
GO
