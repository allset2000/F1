CREATE TABLE [dbo].[Errors]
(
[ErrorID] [int] NOT NULL IDENTITY(1, 1),
[JobID] [bigint] NOT NULL CONSTRAINT [DF_Errors_JobID] DEFAULT ((0)),
[DictationID] [bigint] NOT NULL CONSTRAINT [DF_Errors_DictationID] DEFAULT ((0)),
[Process] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Errors_Process] DEFAULT (''),
[Message] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Errors_Message] DEFAULT (''),
[OccuredAt] [datetime] NOT NULL CONSTRAINT [DF_Errors_OccuredAt] DEFAULT (getdate())
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Errors_OccuredAt_Process] ON [dbo].[Errors] ([OccuredAt], [Process]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Errors] ADD CONSTRAINT [PK_Errors] PRIMARY KEY CLUSTERED  ([ErrorID]) ON [PRIMARY]
GO
