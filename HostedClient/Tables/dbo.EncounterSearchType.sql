CREATE TABLE [dbo].[EncounterSearchType]
(
[EncounterSearchTypeId] [int] NOT NULL,
[EncounterSearchTypeName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EncounterSearchType] ADD CONSTRAINT [PK_EncounterSearchType] PRIMARY KEY CLUSTERED  ([EncounterSearchTypeId]) ON [PRIMARY]
GO
