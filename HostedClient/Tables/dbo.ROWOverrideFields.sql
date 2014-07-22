CREATE TABLE [dbo].[ROWOverrideFields]
(
[FieldID] [smallint] NOT NULL IDENTITY(1, 1),
[FieldName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROWOverrideFields] ADD CONSTRAINT [PK_ROWOverrideFields] PRIMARY KEY CLUSTERED  ([FieldID]) ON [PRIMARY]
GO
