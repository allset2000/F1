CREATE TABLE [dbo].[CustomVocab_Batch]
(
[bintBatchID] [bigint] NOT NULL IDENTITY(1, 1),
[sSpeaker] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sVocab] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[bitReviewIncomplete] [bit] NOT NULL CONSTRAINT [DF_CustomVocab_Batch_bitReviewIncomplete] DEFAULT ((0)),
[dteBatchDate] [datetime] NOT NULL CONSTRAINT [DF_CustomVocab_Batch_dtBatchDate] DEFAULT (getdate()),
[dteBatchReviewed] [datetime] NULL,
[dteBatchProcessed] [datetime] NULL
) ON [PRIMARY]
GO
