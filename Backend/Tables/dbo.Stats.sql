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
[Confidence] [float] NULL
) ON [PRIMARY]
GO
