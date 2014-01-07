CREATE TABLE [dbo].[StatusCategories]
(
[CategoryID] [smallint] NOT NULL,
[CategoryName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusCategories] ADD CONSTRAINT [PK_StatusCategories] PRIMARY KEY CLUSTERED  ([CategoryID]) ON [PRIMARY]
GO
