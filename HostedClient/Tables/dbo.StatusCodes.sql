CREATE TABLE [dbo].[StatusCodes]
(
[StatusID] [smallint] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [smallint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusCodes] ADD CONSTRAINT [PK_StatusCodes] PRIMARY KEY CLUSTERED  ([StatusID], [Category]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusCodes] ADD CONSTRAINT [FK_StatusCodes_StatusCategories] FOREIGN KEY ([Category]) REFERENCES [dbo].[StatusCategories] ([CategoryID])
GO
