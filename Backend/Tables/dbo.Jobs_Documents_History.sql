CREATE TABLE [dbo].[Jobs_Documents_History]
(
[DocumentID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc] [varbinary] (max) NOT NULL,
[XmlData] [xml] NULL,
[Username] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocDate] [datetime] NULL,
[DocumentIdOk] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentIdOk] DEFAULT ((0)),
[DocumentTypeId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentTypeId] DEFAULT ((0)),
[DocumentStatusId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentStatusId] DEFAULT ((0)),
[JobId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_JobId] DEFAULT ((0)),
[TemplateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [smallint] NULL,
[StatusDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[Jobs_Documents_History] ADD 
CONSTRAINT [PK_Jobs_Documents_History] PRIMARY KEY CLUSTERED  ([DocumentID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobNumber_DocDate_INC_Username] ON [dbo].[Jobs_Documents_History] ([JobNumber], [DocDate]) INCLUDE ([Username]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobDocumentsHistory_DocDate] ON [dbo].[Jobs_Documents_History] ([DocDate]) ON [PRIMARY]







GO
