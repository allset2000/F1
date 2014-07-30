CREATE TABLE [dbo].[Macros]
(
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Text] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Macros] ADD CONSTRAINT [PK_Macros] PRIMARY KEY CLUSTERED  ([DictatorID], [Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Macros] ADD CONSTRAINT [FK_Macros_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
GO
