CREATE TABLE [dbo].[DSGReports]
(
[ReportId] [int] NOT NULL IDENTITY(1, 1),
[ReportName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGReports_ReportName] DEFAULT (''),
[ReportAlias] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGReports_ReportAlias] DEFAULT (''),
[ReportSQLName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DSGReports_ReportSQLName] DEFAULT (''),
[ReportIsUsed] [bit] NOT NULL CONSTRAINT [DF_DSGReports_ReportIsUsed] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSGReports] ADD CONSTRAINT [PK_DSGReports] PRIMARY KEY CLUSTERED  ([ReportId]) ON [PRIMARY]
GO
