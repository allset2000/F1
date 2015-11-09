CREATE TABLE [dbo].[TaskMonitor]
(
[TaskID] [int] NOT NULL,
[TaskKey] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Frequency] [int] NOT NULL
) ON [PRIMARY]
GO
