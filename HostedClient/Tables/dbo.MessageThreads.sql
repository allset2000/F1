CREATE TABLE [dbo].[MessageThreads]
(
[MessageThreadID] [int] NOT NULL IDENTITY(1, 1),
[ThreadID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ThreadOwnerID] [int] NOT NULL,
[PatientID] [int] NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__MessageTh__IsAct__0603C947] DEFAULT ((1)),
[PassPhrase] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MessageThreads_PassPhrase] DEFAULT (''),
[ThreadAdminUserID] [int] NULL,
[ThreadDictatorID] [int] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[MessageThreads] ADD 
CONSTRAINT [PK_MessageThreads] PRIMARY KEY CLUSTERED  ([MessageThreadID]) ON [PRIMARY]
ALTER TABLE [dbo].[MessageThreads] ADD
CONSTRAINT [FK_MessageThreads_Patients] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patients] ([PatientID])
GO

ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [FK_MessageThreads_Users] FOREIGN KEY ([ThreadOwnerID]) REFERENCES [dbo].[Users] ([UserID])
GO
