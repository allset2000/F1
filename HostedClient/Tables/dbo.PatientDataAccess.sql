CREATE TABLE [dbo].[PatientDataAccess]
(
[PatientDataAccessID] [int] NOT NULL IDENTITY(1, 1),
[MessageThreadID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[IsPermited] [bit] NOT NULL CONSTRAINT [DF__PatientDa__IsPer__26A5A303] DEFAULT ((0)),
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientDataAccess] ADD CONSTRAINT [PK_PatientDataAccess] PRIMARY KEY CLUSTERED  ([PatientDataAccessID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientDataAccess] ADD CONSTRAINT [FK_PatientDataAccess_MessageThreads] FOREIGN KEY ([MessageThreadID]) REFERENCES [dbo].[MessageThreads] ([MessageThreadID])
GO
ALTER TABLE [dbo].[PatientDataAccess] ADD CONSTRAINT [FK_PatientDataAccess_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
