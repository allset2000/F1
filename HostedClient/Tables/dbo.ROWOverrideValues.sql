CREATE TABLE [dbo].[ROWOverrideValues]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldID] [smallint] NOT NULL,
[Value] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobNumber] ON [dbo].[ROWOverrideValues] ([JobNumber]) ON [PRIMARY]
GO
