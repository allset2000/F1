CREATE TABLE [dbo].[Editors_Pay]
(
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PayLineRate] [money] NULL,
[PayEditorPayRoll] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayrollCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Editors_Pay] ADD CONSTRAINT [PK_Editors_Pay] PRIMARY KEY CLUSTERED  ([EditorID]) ON [PRIMARY]
GO
