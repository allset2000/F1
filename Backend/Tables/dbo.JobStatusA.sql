CREATE TABLE [dbo].[JobStatusA]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NULL,
[StatusDate] [datetime] NULL,
[Path] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusA] ADD CONSTRAINT [PK_JobStatusA] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobStatusAStatus] ON [dbo].[JobStatusA] ([Status]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusA] ADD CONSTRAINT [FK_JobStatusA_StatusCodes] FOREIGN KEY ([Status]) REFERENCES [dbo].[StatusCodes] ([StatusID]) ON UPDATE CASCADE
GO
