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
[IsHistory] [bit] NOT NULL CONSTRAINT [DF__Job_Histo__IsHis__48FB865E] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[Job_History] ADD 
CONSTRAINT [PK__Job_Hist__A809D914EF8C2E5A] PRIMARY KEY CLUSTERED  ([JobHistoryID]) ON [PRIMARY]








GO

SET ANSI_PADDING OFF
GO
