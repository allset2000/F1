CREATE TABLE [dbo].[PatientDataAccess]
(
[PatientDataAccessID] [int] NOT NULL IDENTITY(1, 1),
[MessageThreadID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[PatientDataAccessPermissionID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[PatientDataAccess] ADD 
CONSTRAINT [PK_PatientDataAccess] PRIMARY KEY CLUSTERED  ([PatientDataAccessID]) ON [PRIMARY]
ALTER TABLE [dbo].[PatientDataAccess] ADD
CONSTRAINT [FK_PatientDataAccess_PatientDataAccessPermissions] FOREIGN KEY ([PatientDataAccessPermissionID]) REFERENCES [dbo].[PatientDataAccessPermissions] ([PatientDataAccessPermissionID])
GO

ALTER TABLE [dbo].[PatientDataAccess] ADD CONSTRAINT [FK_PatientDataAccess_MessageThreads] FOREIGN KEY ([MessageThreadID]) REFERENCES [dbo].[MessageThreads] ([MessageThreadID])
GO
ALTER TABLE [dbo].[PatientDataAccess] ADD CONSTRAINT [FK_PatientDataAccess_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
