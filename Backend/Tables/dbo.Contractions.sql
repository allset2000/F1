CREATE TABLE [dbo].[Contractions]
(
[Contraction] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContractionText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contractions] ADD CONSTRAINT [PK_Contractions] PRIMARY KEY CLUSTERED  ([Contraction]) ON [PRIMARY]
GO
