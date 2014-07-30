CREATE TABLE [dbo].[SiteTimeRestriction]
(
[Client] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SiteCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTime] [smalldatetime] NULL,
[EndTime] [smalldatetime] NULL,
[JobType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SiteTimeRestriction] ADD CONSTRAINT [PK_SiteTimeRestriction] PRIMARY KEY CLUSTERED  ([Client], [SiteCode], [JobType]) ON [PRIMARY]
GO
