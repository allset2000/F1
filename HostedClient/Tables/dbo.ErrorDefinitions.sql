CREATE TABLE [dbo].[ErrorDefinitions]
(
[ErrorDefinitionID] [int] NOT NULL IDENTITY(1, 1),
[ErrorCode] [int] NOT NULL,
[ErrorMessage] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResolutionGuide] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ErrorSourceType] [int] NOT NULL,
[AllowEncounterID] [bit] NOT NULL,
[AllowDocumentID] [bit] NOT NULL,
[AllowDocumentTypeID] [bit] NOT NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20160308-004141] ON [dbo].[ErrorDefinitions] ([ErrorCode]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20160308-004305] ON [dbo].[ErrorDefinitions] ([ErrorSourceType]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ErrorDefinitions] ADD CONSTRAINT [PK_ErrorDefinitions] PRIMARY KEY CLUSTERED  ([ErrorDefinitionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ErrorDefinitions] ADD CONSTRAINT [FK_ErrorDefinitions_ErrorSourceTypes] FOREIGN KEY ([ErrorSourceType]) REFERENCES [dbo].[ErrorSourceTypes] ([ErrorSourceTypeID])
GO
