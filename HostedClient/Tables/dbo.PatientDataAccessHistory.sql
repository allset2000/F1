CREATE TABLE [dbo].[PatientDataAccessHistory]
(
[PatientDataAccessHistoryID] [int] NOT NULL IDENTITY(1, 1),
[PatientDataAccessID] [int] NOT NULL,
[MessageThreadID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[PatientDataAccessPermissionID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD 
CONSTRAINT [PK_PatientDataAccessHistory] PRIMARY KEY CLUSTERED  ([PatientDataAccessHistoryID]) ON [PRIMARY]
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD
CONSTRAINT [FK_PatientDataAccessHistory_PatientDataAccessPermissions] FOREIGN KEY ([PatientDataAccessPermissionID]) REFERENCES [dbo].[PatientDataAccessPermissions] ([PatientDataAccessPermissionID])
GO

ALTER TABLE [dbo].[PatientDataAccessHistory] ADD CONSTRAINT [FK_PatientDataAccessHistory_MessageThreads] FOREIGN KEY ([MessageThreadID]) REFERENCES [dbo].[MessageThreads] ([MessageThreadID])
GO
ALTER TABLE [dbo].[PatientDataAccessHistory] ADD CONSTRAINT [FK_PatientDataAccessHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
