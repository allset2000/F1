CREATE TABLE [dbo].[JobDictations]
(
[DictationId] [int] NOT NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContextName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vocabulary] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Duration] [smallint] NOT NULL,
[DictationDate] [smalldatetime] NULL,
[DictationTime] [smalldatetime] NULL,
[RecServer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecognizedText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictationStatus] [int] NOT NULL,
[DocumentId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


GO
ALTER TABLE [dbo].[JobDictations] ADD CONSTRAINT [PK_JobDictations] PRIMARY KEY CLUSTERED  ([DictationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobDictations_DocumentId] ON [dbo].[JobDictations] ([DocumentId]) ON [PRIMARY]
GO
