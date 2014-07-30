CREATE TABLE [dbo].[DSGReportRelations]
(
[ReportRelationId] [int] NOT NULL IDENTITY(1, 1),
[CompanyId] [int] NOT NULL CONSTRAINT [DF_ReportRelations_UserId] DEFAULT ((0)),
[ReportId] [int] NOT NULL CONSTRAINT [DF_ReportRelations_ReportId] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSGReportRelations] ADD CONSTRAINT [PK_DSGReportRelations] PRIMARY KEY CLUSTERED  ([ReportRelationId]) ON [PRIMARY]
GO
