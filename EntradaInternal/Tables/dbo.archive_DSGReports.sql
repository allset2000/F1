CREATE TABLE [dbo].[archive_DSGReports]
(
[ReportId] [int] NOT NULL,
[ReportName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportAlias] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportSQLName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReportIsUsed] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[archive_DSGReports] ADD CONSTRAINT [PK__archive___D5BD4805351DDF8C] PRIMARY KEY CLUSTERED  ([ReportId]) ON [PRIMARY]
GO
