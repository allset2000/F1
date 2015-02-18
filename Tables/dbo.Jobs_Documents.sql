CREATE TABLE [dbo].[Jobs_Documents]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Doc] [varbinary] (max) NOT NULL,
[XmlData] [xml] NULL,
[Username] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocDate] [datetime] NULL,
[DocumentId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_DocumentId] DEFAULT ((0)),
[DocumentTypeId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_DocumentTypeId] DEFAULT ((0)),
[DocumentStatusId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_DocumentStatusId] DEFAULT ((0)),
[JobId] [int] NOT NULL CONSTRAINT [DF_Jobs_Documents_JobId] DEFAULT ((0)),
[Status] [smallint] NULL,
[StatusDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_DocumentId] ON [dbo].[Jobs_Documents] ([DocumentId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_DocumentStatus] ON [dbo].[Jobs_Documents] ([DocumentStatusId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_Documents_JobId] ON [dbo].[Jobs_Documents] ([JobId]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Jobs_Documents] ADD CONSTRAINT [PK_Jobs_Documents] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
GO
