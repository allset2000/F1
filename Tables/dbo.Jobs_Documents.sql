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
[ArchiveID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Documents] ADD CONSTRAINT [PK_Jobs_Documents] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Documents] ADD CONSTRAINT [FK_Jobs_Documents_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
