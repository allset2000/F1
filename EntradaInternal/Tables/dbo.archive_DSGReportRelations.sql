CREATE TABLE [dbo].[archive_DSGReportRelations]
(
[ReportRelationId] [int] NOT NULL,
[CompanyId] [int] NOT NULL,
[ReportId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[archive_DSGReportRelations] ADD CONSTRAINT [PK__archive___B8638166314D4EA8] PRIMARY KEY CLUSTERED  ([ReportRelationId]) ON [PRIMARY]
GO
