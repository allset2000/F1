CREATE TABLE [dbo].[DSGReportRelations]
(
[ReportRelationId] [int] NOT NULL IDENTITY(1, 1),
[CompanyId] [int] NOT NULL CONSTRAINT [DF_ReportRelations_UserId] DEFAULT ((0)),
[ReportId] [int] NOT NULL CONSTRAINT [DF_ReportRelations_ReportId] DEFAULT ((0))
) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[DSGReportRelations] TO [carnold]
GRANT INSERT ON  [dbo].[DSGReportRelations] TO [carnold]
GRANT UPDATE ON  [dbo].[DSGReportRelations] TO [carnold]
GRANT SELECT ON  [dbo].[DSGReportRelations] TO [jablumenthal]
GRANT INSERT ON  [dbo].[DSGReportRelations] TO [jablumenthal]
GRANT DELETE ON  [dbo].[DSGReportRelations] TO [jablumenthal]
GRANT UPDATE ON  [dbo].[DSGReportRelations] TO [jablumenthal]
GO

ALTER TABLE [dbo].[DSGReportRelations] ADD CONSTRAINT [PK_DSGReportRelations] PRIMARY KEY CLUSTERED  ([ReportRelationId]) ON [PRIMARY]
GO
