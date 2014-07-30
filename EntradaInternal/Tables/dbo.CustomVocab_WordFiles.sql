CREATE TABLE [dbo].[CustomVocab_WordFiles]
(
[bintFileID] [bigint] NOT NULL IDENTITY(1, 1),
[sFileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[bintBatchID] [bigint] NOT NULL,
[dteImported] [datetime] NOT NULL CONSTRAINT [DF_CustomVocab_WordFiles_dteCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
