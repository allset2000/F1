CREATE TABLE [dbo].[CustomVocab_Words]
(
[bintWordID] [bigint] NOT NULL IDENTITY(1, 1),
[bintBatchID] [bigint] NOT NULL,
[bintFileID] [bigint] NOT NULL,
[sWord] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[bitManualAdd] [bit] NOT NULL CONSTRAINT [DF_CustomVocab_Words_bitManualAdd] DEFAULT ((0)),
[dteReviewed] [datetime] NULL,
[dteWordAdded] [datetime] NULL,
[dteProcessed] [datetime] NULL
) ON [PRIMARY]
GO
