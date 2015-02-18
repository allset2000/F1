CREATE TABLE [dbo].[EntradaContent]
(
[ContentID] [int] NOT NULL IDENTITY(1, 1),
[ContentKey] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionNumber] [int] NOT NULL,
[Content] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EntradaContent] ADD CONSTRAINT [PK_EntradaContent] PRIMARY KEY CLUSTERED  ([ContentID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EntradaContent] ADD CONSTRAINT [UQ__EntradaC__4EFC7AEC269B3091] UNIQUE NONCLUSTERED  ([ContentKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Content] ON [dbo].[EntradaContent] ([ContentKey]) ON [PRIMARY]
GO
