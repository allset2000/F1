CREATE TABLE [dbo].[JobStatusB]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NULL,
[StatusDate] [datetime] NULL,
[Path] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusB] ADD CONSTRAINT [PK_JobStatusB] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Status_INC_JobNumber] ON [dbo].[JobStatusB] ([Status]) INCLUDE ([JobNumber]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusB] ADD CONSTRAINT [FK_JobStatusB_StatusCodes] FOREIGN KEY ([Status]) REFERENCES [dbo].[StatusCodes] ([StatusID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
