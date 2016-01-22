CREATE TABLE [dbo].[Job_History]
(
[JobHistoryID] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentStatus] [smallint] NOT NULL,
[DocumentID] [int] NULL,
[UserId] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HistoryDateTime] [datetime] NOT NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsHistory] [bit] NOT NULL CONSTRAINT [DF_Job_History_IsHistory] DEFAULT ((0))
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Job_History_DocumentId] ON [dbo].[Job_History] ([DocumentID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Job_History_JobNumber] ON [dbo].[Job_History] ([JobNumber]) ON [PRIMARY]

ALTER TABLE [dbo].[Job_History] ADD
CONSTRAINT [FK_Job_History_DocumentID] FOREIGN KEY ([DocumentID]) REFERENCES [dbo].[Jobs_Documents_History] ([DocumentID])
ALTER TABLE [dbo].[Job_History] ADD
CONSTRAINT [FK_Job_History_JobNumber] FOREIGN KEY ([JobNumber]) REFERENCES [dbo].[Jobs] ([JobNumber])
ALTER TABLE [dbo].[Job_History] ADD 
CONSTRAINT [PK_Job_History] PRIMARY KEY CLUSTERED  ([JobHistoryID]) ON [PRIMARY]









GO

SET ANSI_PADDING OFF
GO
