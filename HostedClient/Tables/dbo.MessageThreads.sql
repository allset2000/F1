CREATE TABLE [dbo].[MessageThreads]
(
[MessageThreadID] [int] NOT NULL IDENTITY(1, 1),
[ThreadID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ThreadOwnerID] [int] NOT NULL,
[ThreadOwnerClinicID] [smallint] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__MessageTh__IsAct__0FC23DAB] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [PK_MessageThreads] PRIMARY KEY CLUSTERED  ([MessageThreadID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [FK_MessageThreads_Clinics] FOREIGN KEY ([ThreadOwnerClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[MessageThreads] ADD CONSTRAINT [FK_MessageThreads_Users] FOREIGN KEY ([ThreadOwnerID]) REFERENCES [dbo].[Users] ([UserID])
GO
