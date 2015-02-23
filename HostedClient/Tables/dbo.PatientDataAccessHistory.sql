CREATE TABLE [dbo].[PatientDataAccessHistory]
(
[PatientDataAccessHistoryID] [int] NOT NULL IDENTITY(1, 1),
[PatientDataAccessID] [int] NOT NULL,
[MessageThreadID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[IsPermited] [bit] NOT NULL CONSTRAINT [DF__PatientDa__IsPer__194BA7E5] DEFAULT ((0)),
[CreatedDate] [datetime] NOT NULL,
[PermitionRevokedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD CONSTRAINT [PK_PatientDataAccessHistory] PRIMARY KEY CLUSTERED  ([PatientDataAccessHistoryID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD CONSTRAINT [FK_PatientDataAccessHistory_MessageThreads] FOREIGN KEY ([MessageThreadID]) REFERENCES [dbo].[MessageThreads] ([MessageThreadID])
GO
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD CONSTRAINT [FK_PatientDataAccessHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
