CREATE TABLE [dbo].[Stats]
(
[Job] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobDate] [smalldatetime] NULL,
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[NumChars] [smallint] NULL,
[Dictator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Topic] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumWords] [int] NULL,
[Confidence] [float] NULL,
[ArchiveID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stats] ADD CONSTRAINT [FK_Stats_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
