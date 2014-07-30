CREATE TABLE [dbo].[Dictator_Contractions]
(
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contraction] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContractionText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictator_Contractions] ADD CONSTRAINT [PK_Dictator_Contractions] PRIMARY KEY CLUSTERED  ([DictatorID], [Contraction]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictator_Contractions] ADD CONSTRAINT [FK_Dictator_Contractions_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
GO
