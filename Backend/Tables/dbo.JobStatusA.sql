CREATE TABLE [dbo].[JobStatusA]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NULL,
[StatusDate] [datetime] NULL,
[Path] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Status] ON [dbo].[JobStatusA] ([Status]) INCLUDE ([JobNumber], [Path], [StatusDate]) ON [PRIMARY]

ALTER TABLE [dbo].[JobStatusA] ADD 
CONSTRAINT [PK_JobStatusA] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]


ALTER TABLE [dbo].[JobStatusA] ADD
CONSTRAINT [FK_JobStatusA_StatusCodes] FOREIGN KEY ([Status]) REFERENCES [dbo].[StatusCodes] ([StatusID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
