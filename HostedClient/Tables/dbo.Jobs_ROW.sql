CREATE TABLE [dbo].[Jobs_ROW]
(
[JobID] [bigint] NOT NULL,
[AckStatus] [int] NOT NULL CONSTRAINT [DF_Jobs_ROW_AckStatus] DEFAULT ((100)),
[ROWStatus] [int] NOT NULL CONSTRAINT [DF_Jobs_ROW_ROWStatus] DEFAULT ((100)),
[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Jobs_ROW_CreateDate] DEFAULT (getdate()),
[ChangedDate] [datetime] NOT NULL CONSTRAINT [DF_Jobs_ROW_ChangedDate] DEFAULT (getdate()),
[AckMessageID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ROWMessageID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageNum] [int] NULL,
[MessageTotal] [int] NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobID_AckStatus] ON [dbo].[Jobs_ROW] ([JobID], [AckStatus]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Jobs_ROW] ADD CONSTRAINT [FK_Jobs_ROW] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Jobs] ([JobID])
GO
