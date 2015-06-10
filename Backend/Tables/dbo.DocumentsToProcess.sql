CREATE TABLE [dbo].[DocumentsToProcess]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessFailureCount] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentsToProcess] ADD CONSTRAINT [PK_DocumentsToProcess] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
