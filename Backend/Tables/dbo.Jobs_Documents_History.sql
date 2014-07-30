CREATE TABLE [dbo].[Jobs_Documents_History]
(
[DocumentID] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc] [varbinary] (max) NOT NULL,
[XmlData] [xml] NULL,
[Username] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocDate] [datetime] NULL,
[DocumentIdOk] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentIdOk] DEFAULT ((0)),
[DocumentTypeId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentTypeId] DEFAULT ((0)),
[DocumentStatusId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_DocumentStatusId] DEFAULT ((0)),
[JobId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_History_JobId] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Documents_History] ADD CONSTRAINT [PK_Jobs_Documents_History] PRIMARY KEY CLUSTERED  ([DocumentID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_DocumentId] ON [dbo].[Jobs_Documents_History] ([DocumentID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_History_DocumentIdOk] ON [dbo].[Jobs_Documents_History] ([DocumentIdOk]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_History_JobId] ON [dbo].[Jobs_Documents_History] ([JobId]) ON [PRIMARY]
GO
